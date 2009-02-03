Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZBCU6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZBCU6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZBCU56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:57:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZBCU56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:57:58 -0500
Date: Tue, 3 Feb 2009 21:57:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090203205727.GA4460@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain> <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain> <20090203195304.GA31049@elte.hu> <alpine.LFD.2.00.0902031209280.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902031209280.3247@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I wouldn't worry too much. I think this is interesting mostly from a 
> performance standpoint - MSI interrupts are supposed to be fast, and under 
> heavy interrupt load I could easily see something like
> 
>  - cpu1: handles interrupt, has acked it, calls down to the handler
> 
>  - the handler clears the original irq source, but another packet (or disk 
>    completion) happens almost immediately
> 
>  - cpu2 takes the second interrupt, but it's still IRQ_INPROGRESS, so it 
>    masks.
> 
>  - cpu1 gets back and unmasks etc and now really handles it because of 
>    IRQ_PENDING.
> 
> Note how the mask/unmask were all just costly extra overhead over the PCI 
> bus. If we're talking something like high-performance 10Gbit ethernet (or 
> even maybe fast SSD disks), driver writers actually do count PCI cycles, 
> because a single PCI read can be several hundred ns, and if you take a 
> thousand interrupts per second, it does add up.

In practice MSI (and in particular MSI-X) irq sources tend to be bound to a 
single CPU on modern x86 hardware. The kernel does not do IRQ balancing 
anymore, nor does the hardware. We have a slow irq-balancer daemon 
(irqbalanced) in user-space. So singular IRQ sources, especially when they 
are MSI, tend to be 99.9% on the same CPU. Changing affinity is possible and 
has to always work reliably, but it is a performance slowpath.

An increasing trend is to have multiple irqs per device (multiple descriptor 
rings, split rx and tx rings with separate irq sources): and each IRQ can 
get balanced to a separate CPU. But those irqs cannot interact on a ->mask() 
level as each IRQ has its separate irq_desc.

The most advanced way of balancing IRQs is not widespread yet: it is where 
devices actually interpret the payload and send completions dynamically to 
differing CPUs - depending on things like the TCP/IP hash value or a 
in-descriptor "target CPU". That way we could get completion on the CPU 
where the work was submitted from. (and where the data structures are the 
most cache-localized)

That principle works both for networking and for other IO transports - but 
we have little support for it yet. It would work really well for workloads 
where one physical device is shared by many CPUs.

(A lesser method that approximates this is the use of lots of 
submission/completion rings per device and their binding to cpus - but that 
can never really approach the number of CPUs really possible in a system.)

And in this most advanced mode of MSI IRQs, and if MSI devices had the 
ability to direct IRQs to a specific CPU (they dont have that right now 
AFAICT), we'd run into the overhead scenarios you describe above, and your 
edge-triggered flow is the most performant one.

	Ingo
