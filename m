Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab0BZVvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:51:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:58343 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0BZVvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:51:49 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1267202674.14703.70.camel@e102109-lin.cambridge.arm.com>
References: <1266445892.16346.306.camel@pasglop>
	 <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
	 <1266979170.23523.1660.camel@pasglop>
	 <1267202674.14703.70.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 08:49:40 +1100
Message-ID: <1267220980.23523.1820.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On ARM, update_mmu_cache() invalidates the I-cache (if VM_EXEC)
> independent of whether the D-cache was dirty (since we can get
> speculative fetches into the I-cache before it was even mapped).

We can get those speculative fetches too on power.

However, we only do the invalidate when PG_arch_1 is clear to avoid
doing it multiple time for a page that was already "cleaned". But it
seems that might not be that a good idea if indeed flush_dcache_page()
is not called for DMA transfers in most cases.

(In addition there is the race I mentioned with update_mmu_cache on SMP)

> > > > Note that from experience, doing the check & flushes in
> > > > update_mmu_cache() is racy on SMP. At least for I$/D$, we have the case
> > > > where processor one does set_pte followed by update_mmu_cache(). The
> > > > later isn't done yet but processor 2 sees the PTE now and starts using
> > > > it, cache hasn't been fully flushed yet. You may avoid that race in some
> > > > ways, but on ppc, I've stopped using that.
> > >
> > > I think that's possible on ARM too. Having two threads on different
> > > CPUs, one thread triggers a prefetch abort (instruction page fault) on
> > > CPU0 but the second thread on CPU1 may branch into this page after
> > > set_pte() (hence not fault) but before update_mmu_cache() doing the
> > > flush.
> > >
> > > On ARM11MPCore we flush the caches in flush_dcache_page() because the
> > > cache maintenance operations weren't visible to the other CPUs.
> > 
> > I'm not even sure that's going to be 100% correct. Don't you also need
> > to flush the remote icaches when you are dealing with instructions (such
> > as swap) anyways ?
> 
> I don't think we tried swap but for pages that have been mapped for the
> first time, the I-cache would be clean. 
>
> At mm switching, if a thread
> migrates to a new CPU we invalidate the cache at that point.

That sounds fragile. What about a multithread app with one thread on
each core hitting the pages at the same time ? Sounds racy to me...

> > I've had some discussions in the past with Russell and others around the
> > problem of non-broadcast cache ops on ARM SMP since that's also hurting
> > you hard with dma mappings.
> > 
> > Can you issue IPIs as FIQs if needed (from my old ARM knowledge, FIQs
> > are still on even in local_irq_save() blocks right ? I haven't touched
> > low level ARM for years tho, I may have forgotten things).
> 
> I have a patch for using IPIs via IRQ from the DMA API functions but,
> while it works, it can deadlock with some drivers (complex situation).
> Note that the patch added a specific IPI implementation which can cope
> with interrupts being disabled (unlike the generic one).

It will deadlock if you use normal IRQs. I don't see a good way around
that other than using a higher-level type of IRQs. I though ARM has
something like that (FIQs ?). Can you use those guys for IPIs ?

> My latest solution - http://bit.ly/apJv3O - is to use dummy
> read-for-ownership or write-for-ownership accesses in the DMA cache
> flushing functions to force cache line migration from the other CPUs.

That might do, but won't help for the icache, will it ?

> Our current benchmarks only show around 10% disc throughput penalty
> compared to the normal SMP case (compared to the UP case the penalty is
> bigger but that's due to other things).

Cheers,
Ben.


