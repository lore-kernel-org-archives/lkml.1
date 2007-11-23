Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbXKWHvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbXKWHvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 02:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXKWHv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 02:51:28 -0500
Received: from smtp.bredband2.net ([82.209.166.4]:16926 "EHLO
	smtp.bredband2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbXKWHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 02:51:26 -0500
Date: Fri, 23 Nov 2007 08:44:43 +0100
From: Mats Johannesson <spamcan@abcbredband.net>
To: pavel@suse.cz, legolas558@users.sourceforge.net, dmitry.torokhov@gmail.com,
       astarikovskiy@suse.de, len.brown@intel.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Laptop keyboard unusable when ACPI is active
Message-ID: <20071123084443.2cf6b61e@loke.fish.not>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.4.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many responsible CCs added.

On 2007-10-20 18:33:09 Pavel Machek responded to Daniele C.:
> > > Try disabling acpi embedded controller.
> > >
> > How can I accomplish this? Are you referring to the i8042?
>
> rmmod acpi_ec or how is it called. But I'm not sure how easy this is.

Designed to be 'hard' because it in effect breaks several functions.
See "config ACPI_EC" in drivers/acpi/Kconfig which one must edit
manually, as well as arch/*/configs/*_defconfig

Either way, the result is exactly as not loading modularized battery
and ac (thermal module still worked on my system).

But this whole issue is getting ridiculous. INPUT subsystem is addled
more and more by ACPI (in real laptop life) while the maintainers,
from a user view, seem stumped.

The bad interaction between ACPI controlled EC (embedded controller)
and the i8042 interrupt handler is theorized about in detail at OLPCs
http://dev.laptop.org/ticket/2401 - almost at the end of that page.
Thanks to Daniele C for the link.

And the bug scenario has been present for many _years_ now. From my own
experience it is only getting worse. Here's the current relations in
2.6.24-rc3-git1

_EC-reading ACPI modules unloaded_

Notebook keyboard and Synaptics touchpad operations all perfectly OK.
Nothing related show up in the logs.


_EC-reading ACPI modules loaded_

Keyboard keys get stuck when EC is accessed for battery, temperature
etc.

Touchpad (mouse pointer) gets stuck for up to ca 5 seconds if I eg move
a window while EC data is read.

The logs are spammed when EC screws over i8042:
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 4
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
psmouse.c: TouchPad at isa0060/serio4/input0 - driver resynched.
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
psmouse.c: issuing reconnect request
[etc]

Messages about an unknown key show up (possibly in relation to a stuck
key). I don't have this on disk, so I'll copy the message from the bug
http://bugzilla.kernel.org/show_bug.cgi?id=9147
atkbd.c: Unknown key released (translated set 2, code 0xe0 on
isa0060/serio0).
atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.


_EC-reading ACPI modules loaded. Command line option i8042.nomux used_

Keyboard keys _can_ get stuck when EC is accessed for battery,
temperature etc. Much less frequent than without i8042.nomux though.

Synaptics touchpad operations OK. Nothing related show up in the logs.


I know that some kind of US holiday is in effect presently, but please
make an effort to take a coordinated look at this afterwards. The
issues are so old and widespread that even the angels cry (I'm told).

PS. No, Dmitry. Lowering the report rate, eg psmouse.rate=40 does not
fix anything, as I tried on your suggestion already in August 2006.
