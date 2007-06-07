Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbXFGNOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbXFGNOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbXFGNOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:14:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:49805 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752706AbXFGNOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:14:42 -0400
Date: Thu, 7 Jun 2007 15:15:03 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: problem with softraw and keycodes > 128
Message-ID: <20070607131503.GA26905@suse.cz>
References: <4667C00D.40708@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667C00D.40708@hhs.nl>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 10:21:33AM +0200, Hans de Goede wrote:

Hans,

> I've been experimenting with getting the internetkeys on several
> keyboards to work. My biggest problem with this currently is the
> following:

> Step 1: press key, dmesg says:
>	atkbd.c: Unknown key released (translated set 2, code 0xa3 on  isa0060/serio0).
>	atkbd.c: Use 'setkeycodes e023 <keycode>' to make it known.
> Step 2: map key: setkeycodes e023 163
> Step 3: run xev, press key. X-keycode is: 153 instead of 163 ?


> Doing:
> 	echo -n 0 >/sys/devices/platform/i8042/serio1/softraw
> However does make them identical.

this is a well known problem. It's not easy to explain and next to
impossible to fix within the scope of operation of your test case -
otherwsie it'd be fixed ages ago.

The explanation why this happen will be a little longer, and will follow
the life of a keystroke as it passes through the different layers.

	1. First, the user presses a key. Since we're talking a 102-key
	PS/2-type keyboard here, the keyboard scans its matrix and figures out
	the position of the key. Then, since the connection to the PC is running
	in AT mode, it translates the key to a string (one to eight bytes) of
	AT-compatible scancodes.

	2. The i8042 in the computer receives the scancodes, translates them to
	XT-compatible scancodes and makes them available to the OS.

	3. In OS the i8042.c gets the scancodes and forwards them to atkbd.c

	4. atkbd.c decodes the string of scancodes and turns them into a single
	Linux input event, and forwards it to the input core.

	5. The Linux input core dispatches the events to char/keyboard.c.

	6. keyboard.c, a part of the VT driver, sees that X told the VT that it
	wants the "raw mode", which means that the VT should give the keystrokes
	as the original string of XT scancodes. Hence (when softraw is 1), it
	consults a table and synthesizes what it thinks the original string of
	bytes could have been and gives that to X. For all keys that atkbd.c
	knows by default, this string is IDENTICAL to what atkbd.c has received.

	7. X takes the string, and using an algorithm similar to, but DIFFERENT
	from the algoithm that atkbd.c uses, it converts them to an X scancode.
	The X scancodes are similar to, but different from the Linux event
	keycodes, for historical reasons going back to the 90's.

	8. Using an xmodmap table compiled from xkb sources, X converts the X
	scancode to an X keysym.

In the softraw == 0 case, the original string of XT scancodes is passed
all along the path to X, so that X really gets what the keyboard sent.

Since the table mapping Linux event keycodes to the synthesized XT
scancodes in step 6. is constant and shared for all (even USB and other)
keyboards, this means that the Linux kernel always presents a virtual
"Linux keyboard" to X.

The "Linux keyboard" always sends the same scancodes for keys with the
same meaning, regardless of what the real hardware does.

And this is why X sees a different code in softraw==1 mode than in
softraw==0 mode: In the first it gets the virtual "Linux keyboard", in
the other it gets access to the real hardware.

> Problem, as the xkb files for these keyboards expect the X-keycode to
> be 163, as just it is under the console. Now I know that X-keycodes !=
> console-keycodes, for example the A key is 30 on the console and 38 in
> X, but in the case of this special keys, both the xkb files for these
> internet keyboards (written by suse) and config files for special
> daemons like lineak, expect them to be identical.

This is wrong. Someone simply needs to write a xkb/lineak description
for the "Linux keyboard", and then all these problems will go away.

PS.: And it's best to use the 'evdev' driver for X instead the 'kbd'
driver, since that one gets the Linux keycodes directly from the kernel,
without any back/forward translation.

-- 
Vojtech Pavlik
Director SuSE Labs
