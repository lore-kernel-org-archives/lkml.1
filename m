Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXCGQOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXCGQOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbXCGQOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:14:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41715 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346AbXCGQOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:14:33 -0500
Date: Wed, 7 Mar 2007 08:10:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>, Ash Milsted <thatistosayiseenem@gawab.com>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Thomas Meyer <thomas.mey@web.de>, Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [2/6] 2.6.21-rc2: known regressions
In-Reply-To: <45EE9D52.9060807@garzik.org>
Message-ID: <Pine.LNX.4.64.0703070746150.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
 <20070305015034.GG3441@stusta.de> <45EE9D52.9060807@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Jeff Garzik wrote:
>
> Adrian Bunk wrote:
> > Subject    : AT keyboard only works with pci=noacpi
> > References : http://lkml.org/lkml/2007/3/3/68
> > Submitter  : Ash Milsted <thatistosayiseenem@gawab.com>
> > Status     : unknown
> 
> sounds like a BIOS bug, even though it appears to be a regression?

So?

BIOS bugs are not bugs we can fix, they are things we have to work around. 
They are like hardware bugs in a network chip: a "driver" that doesn't 
work around a BIOS bug is simply a *buggy* driver, exactly the same way a 
network driver has to work around errata in the hardware.

So it doesn't really matter if something is a BIOS bug or not. It's not 
reasonable to expect people to upgrade their BIOS'es - even if such an 
upgrade were to exist (which is fairly rare in itself). 

If it used to work, that just makes it (a) doubly important to try to fix 
it, since regressions are BAD BAD BAD and (b) a fair amount *easier* to 
fix, since we can hopefully get an idea of what broke it.

Ash, can you try to use "git bisect" to figure where it started? But 
perhaps just try -rc3 first to see if it's been fixed?

The working setups (whether with irqfixup or with pci=noacpi seem to both 
have a nice

	input: AT Translated Set 2 keyboard as /class/input/inputX

but the nonworking one does not. But even the nonworking one actually 
*found* the controller:

	PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
	PNP: PS/2 controller doesn't have AUX irq; using default 12
	serio: i8042 KBD port at 0x60,0x64 irq 1
	serio: i8042 AUX port at 0x60,0x64 irq 12
	mice: PS/2 mouse device common for all mice

which probably means that the "atkbd_probe()" function fails (probably 
because it never gets a reply, which in turn is probably because the 
interrupt routing is broken).

If you use "atkbd.reset=1" on the kernel command line, you would probably 
get a message like "keyboard reset failed"..

Now, the most likely cause is obviously just the ACPI changes that mess up 
irq routing somehow, but it would be important to figure out *what* makes 
it happen, which is why "git bisect" would be wonderful to try.

So Ash, if you get the git tree, just start with

	git bisect start
	git bisect good v2.6.20
	git bisect bad v2.6.21-rc1

and off you go.. git isn't really that hard to use any more.

		Linus
