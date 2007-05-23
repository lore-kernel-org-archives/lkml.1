Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXEWBxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXEWBxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 21:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXEWBxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 21:53:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082AbXEWBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 21:53:37 -0400
Date: Tue, 22 May 2007 18:53:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Mike Houston <mikeserv@bmts.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
In-Reply-To: <46538AEE.4030700@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705221817150.3890@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
 <20070520170506.814a38d9.mikeserv@bmts.com> <20070521084549.61a1aa71@freepuppy>
 <20070521131055.0017404f.mikeserv@bmts.com> <20070521103755.51b954e1@freepuppy>
 <20070521225806.bb18d589.mikeserv@bmts.com> <20070521213146.3e220a44@freepuppy>
 <20070522181444.ad932718.mikeserv@bmts.com>
 <alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
 <46538AEE.4030700@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 May 2007, Stephen Hemminger wrote:
> 
> It looks like the chip reads the wrong memory sometimes. The problem happens
> only on the on-board NIC's and only on this kind of motherboard.

Do you know if it happens for particular addresses? (Ie, can you tell what 
the physical address of the descriptor is for the errors?)

> For testing, I have put code in to check that the receive data actually
> arrived before the IRQ, it triggered on my Gigabyte 925 motherboard. It
> appears that DMA access is messed up.

Yes, that certainly would also explain memory corruption. Either because 
writes went to the wrong address, or because writes went to the right 
address, but because an earlier IO descriptor read had gotten corrupted, 
the "right address" was in fact the wrong one ;)

The reason I ask whether you have some way of telling the pattern for the 
physical address is that one traditional cause of DMA errors is due to 
broken RAM remapping setup.

As an example of that - imagine that you have 1GB of RAM in the machine, 
and realize that the memory behind the 640kB -> 1MB area isn't accessible, 
because it's taken up by the legacy ISA region.

You have two possible outcomes: either (a) the memory is just "gone", and 
you lost it, or (b) there is some RAM remapping in the core chipset that 
makes the lost 384kB show up _above_ the 1GB mark instead.

The same "legacy ISA" hole situation happens for the "legacy PCI" hole, 
which is why if you have 4GB of RAM in the machine, usually you'll see 
3GB at addresses 0-3GB (roughly), and then you'll see the rest at above 
the 4GB mark, in order to have a nice PCI hole in the 32-bit access range.

There's also the "legacy 286" hole at the 15-16MB mark (which nobody uses 
any more, but chipsets still inexplicably support), and the SMM remapping. 

Anyway, core chipsets generally do CPU memory accesses _differently_ from 
DMA accesses from the PCI bus (at a minimum, SMM is something that only 
the CPU can do), so I could see a situation where the remapping was set up 
correctly for the CPU (and perhaps for "core chipset" devices like the 
integrated southbridge), but devices that do DMA from the outside get 
screwed over.

But it might not happen for all addresses. Non-remapped stuff might work 
well, so if there is some way of figuring out what the bad DMA address was 
for an erreneous access, that might offer some clues.

> This board has lots of "overclocker" friendly stuff; maybe the BIOS 
> never really sets up the PCI bridges and clocks properly.

It's hard to set up a normal PCI-PCI bridge subtly incorrectly. But 
special RAM timing or remapping stuff for the host bridge - sure.

> It doesn't seem like a software or driver problem. I have tried tweaking PCI
> registers but nothing worked in this case.

Yeah, the PCI registers that would affect things like this tend to be in 
the host bridge, not on the normal device.

That said, Intel doesn't generally do the really insane things. And a lot 
of the old remapping stuff is simply not done any more. For example, I 
doubt that the 925 chipset even supports remapping the 640k-1M range any 
more: 384kB just isn't worth it when people talk about gigs of RAM, the 
way it was when 16MB was considered a lot.

And looking quickly at the Intel 925X MCH (memory controller hub) 
registers, nothing jumps out as a good candidate for some obvious bug. 

			Linus
