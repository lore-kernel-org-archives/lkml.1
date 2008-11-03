Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYKCTCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYKCTCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYKCTC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:02:28 -0500
Received: from main.gmane.org ([80.91.229.2]:55439 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYKCTC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:02:27 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: ALPS input driver problem with DualPoint on Dell E6400/E6500
Date: Mon, 3 Nov 2008 19:02:04 +0000 (UTC)
Message-ID: <pan.2008.11.03.19.02.04@telenet.be>
References: <20081101044828.GC7527@cse.unsw.EDU.AU>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-61-244.access.telenet.be
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Nov 2008 15:48:28 +1100, Matthew Chapman wrote:

> I have a Dell Latitude E6400 laptop with an ALPS touchpad/touchstick
> combination, aka DualPoint.  Individually, the touchpad and touchstick
> work fine.  However, if I accidentally touch both together, or use the
> touchpad buttons while using the touchstick (or vice versa), things go
> astray.  The pointer jumps around, stray mouse buttons are pressed, and
> the driver typically loses sync:
> 
> [13333.661085] psmouse.c: DualPoint TouchPad at isa0060/serio1/input0
> lost sync at byte 5
> [13333.662353] psmouse.c: DualPoint TouchPad at isa0060/serio1/input0
> lost sync at byte 1
> [13333.669493] psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 -
> driver resynched.
> 
> To cut a long story short, it seems that in this case the ALPS device
> sends a 9-byte packet format, with both a relative update and an
> absolute update combined (why oh why...).  Has anyone else seen
> something like this?

I can definitely confirm this problem, also on a Dell Latitutde E6400 with 
2.6.27 kernel.

dmesg contains errors like this:

psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 6
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 - driver resynched.
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 5
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 - driver resynched.
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 5
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 6
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 3
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 3
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 3
psmouse.c: issuing reconnect request
input: PS/2 Generic Mouse as /class/input/input13

(Note also that this patch is still required to make this patch to make 
the synaptic driver recognize the touchpad:
http://lkml.org/lkml/2008/9/7/133 )

# cat /proc/bus/input/devices
I: Bus=0017 Vendor=0001 Product=0001 Version=0100
N: Name="Macintosh mouse button emulation"
P: Phys=
S: Sysfs=/class/input/input0
U: Uniq=
H: Handlers=mouse0 event0 
B: EV=7
B: KEY=70000 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/class/input/input1
U: Uniq=
H: Handlers=kbd event1 
B: EV=120013
B: KEY=800000000000 0 0 500f02102002 380303cf810d001 feffffdfffefffff 
ffffffffffffffff
B: MSC=10
B: LED=7

I: Bus=0019 Vendor=0000 Product=0005 Version=0000
N: Name="Lid Switch"
P: Phys=PNP0C0D/button/input0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=event4 
B: EV=21
B: SW=1

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button (CM)"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/class/input/input5
U: Uniq=
H: Handlers=kbd event5 
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0003 Version=0000
N: Name="Sleep Button (CM)"
P: Phys=PNP0C0E/button/input0
S: Sysfs=/class/input/input6
U: Uniq=
H: Handlers=kbd event6 
B: EV=3
B: KEY=4000 0 0

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=/video/input0
S: Sysfs=/class/input/input7
U: Uniq=
H: Handlers=kbd event7 
B: EV=3
B: KEY=3f000b00000000 0 0 0

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=/video/input0
S: Sysfs=/class/input/input8
U: Uniq=
H: Handlers=kbd event8 
B: EV=3
B: KEY=3f000b00000000 0 0 0

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=/video/input0
S: Sysfs=/class/input/input9
U: Uniq=
H: Handlers=kbd event9 
B: EV=3
B: KEY=3f000b00000000 0 0 0

I: Bus=0003 Vendor=413c Product=8157 Version=0111
N: Name="HID 413c:8157"
P: Phys=usb-0000:00:1a.0-1.1/input0
S: Sysfs=/class/input/input10
U: Uniq=
H: Handlers=kbd event10 
B: EV=120013
B: KEY=1000000000007 ff800000000007ff febeffdff3cfffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0001 Vendor=111d Product=76b2 Version=0001
N: Name="HDA Digital PCBeep"
P: Phys=card0/codec#0/beep0
S: Sysfs=/class/input/input12
U: Uniq=
H: Handlers=kbd event12 
B: EV=40001
B: SND=6

I: Bus=0011 Vendor=0002 Product=0001 Version=0000
N: Name="PS/2 Generic Mouse"
P: Phys=isa0060/serio1/input0
S: Sysfs=/class/input/input13
U: Uniq=
H: Handlers=mouse1 event2 
B: EV=7
B: KEY=70000 0 0 0 0
B: REL=3


 
> When I use just the touchstick and its buttons, the packets are normal
> PS/2 relative mode packets, e.g.:
> 
>   08 01 00    dx=1 dy=0
>   09 01 00    dx=1 dy=0   left T/S button down 08 00 01    dx=0 dy=1  
>   left T/S button up
> 
> When I use just the touchpad and its buttons, the packets look like
> this, which also works fine with the current ALPS code:
> 
>   cf 27 1a 38 24 46   x=423 y=420 z=70 fin=1 cf 2c 1a 39 1e 45   x=428
>   y=414 z=69 fin=1   left T/P button down cf 2f 1a 38 17 44   x=431
>   y=407 z=68 fin=1   left T/P button up
> 
> Let's say now I use the touchpad and press a touchstick button...
> 
>   cf 15 1a 38 5e 3d           x=405 y=478 z=61 cf 19 1a 0f 00 00 39 56
>   3d  x=409 y=470 z=61  left T/P button down
>            ^^^^^^^^
>   cf 1d 1a 39 4e 3d           x=413 y=462 z=61
> 
>   cf 21 1a 0f 00 00 38 49 3f  x=417 y=456 z=63  left T/P button up
>            ^^^^^^^^
>   cf 21 1a 38 48 3e           x=417 y=455 z=62
> 
> Now let's try moving the touchstick also...
> 
>   cf 3d 12 3f fa fd 18 4c 21  dx=-6 dy=-3 x=317 y=204 z=33
>            ^^^^^^^^
>   38 fa fd                    dx=-6 dy=-3 cf 3a 12 3f f9 fc 18 4c 20 
>   dx=-7 dy=-4 x=314 y=204 z=32
>            ^^^^^^^^
>   38 fa fd                    dx=-6 dy=-3 etc.
> 
> In other words, it seems like there's a relative update embedded right
> in the middle of the absolute mode packet, which can be identified by
> all the buttons being set to 1.
> 
> I can put together a patch, but it's a non-trivial change... I'm
> interested in hearing whether anyone else has the same problem with
> their E6400/E6500 or other DualPoint laptop, or has better ideas
> regarding how to deal with this.

-- 
Frederik Himpe


