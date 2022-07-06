$fn = 90;

size = [ 4, 4 ];      // size of gate (excluding inverter dot)
inverter = 1;           // size of center dot relative to gate size.y
thickness = .1;          // thickness of wire.
dotsize = .4;

module nand() {
    
    difference() {
        offset(r=thickness/2) {
            hull() {
                translate([-(size.x-thickness)/2, 0]) square([thickness, size.y], center = true);
                translate([(size.x-size.y)/2, 0]) circle(d=size.y);
            }
            translate([(size.x + inverter)/2, 0]) circle(d=inverter);
        }
        offset(r=-thickness/2) {
            hull() {
                translate([-(size.x-thickness)/2, 0]) square([thickness, size.y], center = true);
                translate([(size.x-size.y)/2, 0]) circle(d=size.y);
            }
            translate([(size.x + inverter)/2, 0]) circle(d=inverter);
        }
    }
}

module wire(from, to) {
    
    hull() {
        translate(from) circle(d=thickness);
        translate(to)   circle(d=thickness);
    }
}

module dot(location) {
    translate(location) circle(d=dotsize);
}

module flipflop_2d() {
    translate([0, 4]) {
        nand();
    }

    translate([0, -4]) {
        nand();
    }

    WIRES = [
        [ [-2, 5], [-7, 5] ],
        [ [-2, 3], [-5, 3], [-5, 2], [5, -2], [5, -4] ],
        [ [3, 4], [7, 4] ],
        [ [5, 4] ]
    ];

    for (net = WIRES) {
        if (len(net) == 1) {
            dot(net[0]);
            dot([net[0].x, -net[0].y]);
        } else {
            for (seg = [0 : len(net)-2 ] ) {
                wire(net[seg], net[seg+1]);
                wire([net[seg].x, -net[seg].y], [net[seg+1].x, -net[seg+1].y]);
            }
        }
    }
    
    fontsize = 1.1;
    
    module not() {
        wire([-.5, fontsize*1.2], [.5, fontsize*1.2]);
        children();
    }       
    
    translate([0, -fontsize/2]) {    
        translate([-8, 5]) not() text("S", font="Roboto:style=Regular", size=fontsize, halign="center", valign="baseline" );
        translate([-8, -5]) not() text("R", font="Roboto:style=Regular", size=fontsize, halign="center", valign="baseline" );
        
        translate([8, 4]) text("Q", font="Roboto:style=Regular", size=fontsize, halign="center", valign="baseline" );
        translate([8, -4]) {
            not() text("Q", font="Roboto:style=Regular", size=fontsize, halign="center", valign="baseline" );
        }
    }
}

*linear_extrude(.5) square([100,80], center=true);
//linear_extrude(2) 
    scale(5) flipflop_2d();