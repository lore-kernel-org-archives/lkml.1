Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392Ab0BZQoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:44:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33608 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965364Ab0BZQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:44:37 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Oliver Neukum <oliver@neukum.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1266979170.23523.1660.camel@pasglop>
References: <1266445892.16346.306.camel@pasglop>
	 <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
	 <1266979170.23523.1660.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 26 Feb 2010 16:44:34 +0000
Message-ID: <1267202674.14703.70.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2010 16:44:35.0775 (UTC) FILETIME=[FAB95CF0:01CAB702]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 02:39 +0000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-02-19 at 17:15 +0000, Catalin Marinas wrote:
> > > We assume that anybody that dirties a page in the kernel will call
> > > flush_dcache_page() which removes our PG_arch_1 bit thus marking the
> > > page "dirty".
> >
> > This assumption is not valid with some drivers like USB HCD doing PIO.
> > But, yes, that's how it should be done.
> 
> So we go back to the fix should be done at the individual drivers level.
> If it's going to write into the page cache, it needs to whack the bits.
> 
> Now there's of course the question as to whether you really only want to
> do that for a PIO access and not for a DMA access, I think on power, we
> don't really discriminate that much (since in any case our icache still
> needs flushing). Maybe it would be useful to separate the I$ and D$ bits
> but I'm not sure I can be bothered.

On ARM, update_mmu_cache() invalidates the I-cache (if VM_EXEC)
independent of whether the D-cache was dirty (since we can get
speculative fetches into the I-cache before it was even mapped).

> > > Note that from experience, doing the check & flushes in
> > > update_mmu_cache() is racy on SMP. At least for I$/D$, we have the case
> > > where processor one does set_pte followed by update_mmu_cache(). The
> > > later isn't done yet but processor 2 sees the PTE now and starts using
> > > it, cache hasn't been fully flushed yet. You may avoid that race in some
> > > ways, but on ppc, I've stopped using that.
> >
> > I think that's possible on ARM too. Having two threads on different
> > CPUs, one thread triggers a prefetch abort (instruction page fault) on
> > CPU0 but the second thread on CPU1 may branch into this page after
> > set_pte() (hence not fault) but before update_mmu_cache() doing the
> > flush.
> >
> > On ARM11MPCore we flush the caches in flush_dcache_page() because the
> > cache maintenance operations weren't visible to the other CPUs.
> 
> I'm not even sure that's going to be 100% correct. Don't you also need
> to flush the remote icaches when you are dealing with instructions (such
> as swap) anyways ?

I don't think we tried swap but for pages that have been mapped for the
first time, the I-cache would be clean. At mm switching, if a thread
migrates to a new CPU we invalidate the cache at that point.

> I've had some discussions in the past with Russell and others around the
> problem of non-broadcast cache ops on ARM SMP since that's also hurting
> you hard with dma mappings.
> 
> Can you issue IPIs as FIQs if needed (from my old ARM knowledge, FIQs
> are still on even in local_irq_save() blocks right ? I haven't touched
> low level ARM for years tho, I may have forgotten things).

I have a patch for using IPIs via IRQ from the DMA API functions but,
while it works, it can deadlock with some drivers (complex situation).
Note that the patch added a specific IPI implementation which can cope
with interrupts being disabled (unlike the generic one).

My latest solution - http://bit.ly/apJv3O - is to use dummy
read-for-ownership or write-for-ownership accesses in the DMA cache
flushing functions to force cache line migration from the other CPUs.
Our current benchmarks only show around 10% disc throughput penalty
compared to the normal SMP case (compared to the UP case the penalty is
bigger but that's due to other things).

-- 
Catalin

