Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZBCUTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZBCUTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBCUTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:19:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbZBCUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:19:07 -0500
Date: Tue, 3 Feb 2009 12:18:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <20090203195304.GA31049@elte.hu>
Message-ID: <alpine.LFD.2.00.0902031209280.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain>
 <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain> <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain> <20090203195304.GA31049@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Ingo Molnar wrote:
> 
>  - the screaming-irq observation i had - do you consider that valid?:
> 
>    >> [ In theory this also solves screaming level-triggered irqs that 
>    >>   advertise themselves as edge-triggered [due to firmware/BIOS bug - 
>    >>   these do happen] and then keep spamming the system. ]
> 
>    I wanted to have a pretty much interchangeable flow method between edge 
>    and level triggered - so that the BIOS cannot screw us by enumerating an 
>    irq as edge-triggered while it's level-triggered.

Yes, if we can't be 100% sure it's really edge-triggered, I guess the mask 
thing is really worth it. So maybe "handle_edge_irq()" is actually doing 
everything right.

Of course, with MSI, we can fundamentally really be sure that it's 
edge-triggered (since it's literally a packet on the PCI bus that 
generates it), and that actually brings up another possibility: assuming 
handle_edge_irq() is doing the correct "safe" thing, maybe the answer is 
to just get rid of the MSI "mask()" operation as being unnecessary, and 
catch it at that level.

NOTE! From a correctness standpoint I think this is all irrelevant. Even 
if we have turned off the power of some device, the msi irq masking isn't 
going to hurt (apart from _possibly_ causing a machine check, but that's 
nothing new - architectures that enable machine checks on accesses to 
non-responding PCI hardware have to handle those anyway).

So I wouldn't worry too much. I think this is interesting mostly from a 
performance standpoint - MSI interrupts are supposed to be fast, and under 
heavy interrupt load I could easily see something like

 - cpu1: handles interrupt, has acked it, calls down to the handler

 - the handler clears the original irq source, but another packet (or disk 
   completion) happens almost immediately

 - cpu2 takes the second interrupt, but it's still IRQ_INPROGRESS, so it 
   masks.

 - cpu1 gets back and unmasks etc and now really handles it because of 
   IRQ_PENDING.

Note how the mask/unmask were all just costly extra overhead over the PCI 
bus. If we're talking something like high-performance 10Gbit ethernet (or 
even maybe fast SSD disks), driver writers actually do count PCI cycles, 
because a single PCI read can be several hundred ns, and if you take a 
thousand interrupts per second, it does add up.

Of course, ethernet tends to do things like interrupt mitigation to avoid 
this, but that has its own downsides (longer latencies) and isn't really 
considered optimal in some RT environments (wall street trading kind of 
things).

I really don't know how big an issue this all is. It probably isn't really 
noticeable.

			Linus
