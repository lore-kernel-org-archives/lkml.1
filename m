Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXGJPjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXGJPjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXGJPjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:39:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754472AbXGJPjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:39:39 -0400
Date: Tue, 10 Jul 2007 08:39:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefano Rivoir <s.rivoir@gts.it>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: <4693327E.6000006@gts.it>
Message-ID: <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
 <4693327E.6000006@gts.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Jul 2007, Stefano Rivoir wrote:
> 
> 2.6.22 hangs at boot on my box. Here attached a original dmesg from 2.6.21,
> and a copy of it where it stops on 2.6.22 (I can't attach the original 2.6.22
> dmesg because it's not logged to disk yet); it actually stops right after
> 'init' launches.

Ok, without any oops or hang in any really obvious place, that doesn't 
really tell anybody anything specific enough to even start trying to debug 
this, so you'd need to do one of two things:

 - poke a lot at the machine to try to get more specific information. In 
   particular, get things like SysRQ-T output. That, in turn, probably 
   would mean trying to get a serial console hooked up or something.

   The next thing that you got on 2.6.21 after the point it hangs was 
   apparently 

	..
	input: PC Speaker as /class/input/input1
	ieee1394: Initialized config rom entry `ip1394'
	ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
	ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
	usbcore: registered new interface driver hiddev
	..

   so you could _try_ to disable the PC speaker or firewire, and see 
   what's up. Did you switch from the old firewire drivers to the new one, 
   for example? Or if you didn't, try it.

   IOW, we'd need a lot more debug information.

The second alternative will take some time, but is really a lot easier:

 - Get a kernel git tree, and do a "git bisect".

   There's almost 7000 commits in between 2.6.21 and 22, but that still 
   means that in about fourteen recompiles/reboots, "git bisect" should 
   tell us where your problem starts, which will hopefully make it obvious 
   what the problem is (or at least pinpoint it a *lot*).

Doing a git bisect isn't really that hard, but fourteen compiles/reboots 
will take some time (well, the compiles will, the reboots aren't that 
bad). But even if you're not a git user, it really is very simple:

 - get started with 'git': on most distros it's now as simple as doing 
   something like

	yum install git

   and while you might not get the latest version (Debian stable is at 
   some ancient 1.4.4.4 version that isn't as nice as the 1.5.x series), 
   for something like this you won't care that deeply.

 - get the kernel git tree (this will take a while to download about 
   180MB)

	git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

 - start the "git bisect" with

	git bisect good v2.6.21
	git bisect bad v2.6.22

   and it will pick a kernel version about half-way between the two 
   points, and you can now start testing. For each kernel you try, if it 
   boots fine, do "git bisect good", otherwise boot into a working kernel, 
   and then do "git bisect bad". Git will then pick the next "halfway" 
   kernel for that case.

Thanks,

		Linus
