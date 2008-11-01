Return-Path: <linux-kernel-owner+w=401wt.eu-S1751774AbYKAEsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbYKAEsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 00:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYKAEsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 00:48:31 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:58858 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYKAEsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 00:48:30 -0400
From: Matthew Chapman <matthewc@cse.unsw.edu.au>
To: linux-kernel@vger.kernel.org
Date: Sat, 1 Nov 2008 15:48:28 +1100
Subject: ALPS input driver problem with DualPoint on Dell E6400/E6500
Message-ID: <20081101044828.GC7527@cse.unsw.EDU.AU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Dell Latitude E6400 laptop with an ALPS touchpad/touchstick
combination, aka DualPoint.  Individually, the touchpad and touchstick
work fine.  However, if I accidentally touch both together, or use the
touchpad buttons while using the touchstick (or vice versa), things go
astray.  The pointer jumps around, stray mouse buttons are pressed, and
the driver typically loses sync:

[13333.661085] psmouse.c: DualPoint TouchPad at isa0060/serio1/input0
lost sync at byte 5
[13333.662353] psmouse.c: DualPoint TouchPad at isa0060/serio1/input0
lost sync at byte 1
[13333.669493] psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 -
driver resynched.

To cut a long story short, it seems that in this case the ALPS device
sends a 9-byte packet format, with both a relative update and an
absolute update combined (why oh why...).  Has anyone else seen
something like this?


When I use just the touchstick and its buttons, the packets are normal
PS/2 relative mode packets, e.g.:

  08 01 00    dx=1 dy=0
  09 01 00    dx=1 dy=0   left T/S button down
  08 00 01    dx=0 dy=1   left T/S button up

When I use just the touchpad and its buttons, the packets look like
this, which also works fine with the current ALPS code:

  cf 27 1a 38 24 46   x=423 y=420 z=70 fin=1
  cf 2c 1a 39 1e 45   x=428 y=414 z=69 fin=1   left T/P button down
  cf 2f 1a 38 17 44   x=431 y=407 z=68 fin=1   left T/P button up

Let's say now I use the touchpad and press a touchstick button...

  cf 15 1a 38 5e 3d           x=405 y=478 z=61
  cf 19 1a 0f 00 00 39 56 3d  x=409 y=470 z=61  left T/P button down
           ^^^^^^^^
  cf 1d 1a 39 4e 3d           x=413 y=462 z=61

  cf 21 1a 0f 00 00 38 49 3f  x=417 y=456 z=63  left T/P button up
           ^^^^^^^^
  cf 21 1a 38 48 3e           x=417 y=455 z=62

Now let's try moving the touchstick also...

  cf 3d 12 3f fa fd 18 4c 21  dx=-6 dy=-3 x=317 y=204 z=33
           ^^^^^^^^
  38 fa fd                    dx=-6 dy=-3
  cf 3a 12 3f f9 fc 18 4c 20  dx=-7 dy=-4 x=314 y=204 z=32
           ^^^^^^^^
  38 fa fd                    dx=-6 dy=-3
  etc.

In other words, it seems like there's a relative update embedded right
in the middle of the absolute mode packet, which can be identified by
all the buttons being set to 1.

I can put together a patch, but it's a non-trivial change... I'm
interested in hearing whether anyone else has the same problem with
their E6400/E6500 or other DualPoint laptop, or has better ideas
regarding how to deal with this.

Matt

