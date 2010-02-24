Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0BXCoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:44:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:56764 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0BXCoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:44:19 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
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
In-Reply-To: <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
References: <1266445892.16346.306.camel@pasglop>
	 <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 13:39:30 +1100
Message-ID: <1266979170.23523.1660.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 17:15 +0000, Catalin Marinas wrote:
> > Ok, you do things very differently than us on ppc then. We clear
> > PG_arch_1 in flush_dcache_page(), and we set it when the page has
> been
> > cache cleaned for execution.
> 
> For this perspective it's not that different, just that we use the
> negated PG_arch_1.

Right, though you default as "clean" while we default as "dirty".

> > We assume that anybody that dirties a page in the kernel will call
> > flush_dcache_page() which removes our PG_arch_1 bit thus marking the
> > page "dirty".
> 
> This assumption is not valid with some drivers like USB HCD doing PIO.
> But, yes, that's how it should be done.

So we go back to the fix should be done at the individual drivers level.
If it's going to write into the page cache, it needs to whack the bits.

Now there's of course the question as to whether you really only want to
do that for a PIO access and not for a DMA access, I think on power, we
don't really discriminate that much (since in any case our icache still
needs flushing). Maybe it would be useful to separate the I$ and D$ bits
but I'm not sure I can be bothered.
 
> > Note that from experience, doing the check & flushes in
> > update_mmu_cache() is racy on SMP. At least for I$/D$, we have the
> case
> > where processor one does set_pte followed by update_mmu_cache(). The
> > later isn't done yet but processor 2 sees the PTE now and starts
> using
> > it, cache hasn't been fully flushed yet. You may avoid that race in
> some
> > ways, but on ppc, I've stopped using that.
> 
> I think that's possible on ARM too. Having two threads on different
> CPUs, one thread triggers a prefetch abort (instruction page fault) on
> CPU0 but the second thread on CPU1 may branch into this page after
> set_pte() (hence not fault) but before update_mmu_cache() doing the
> flush.
> 
> On ARM11MPCore we flush the caches in flush_dcache_page() because the
> cache maintenance operations weren't visible to the other CPUs.

I'm not even sure that's going to be 100% correct. Don't you also need
to flush the remote icaches when you are dealing with instructions (such
as swap) anyways ?

I've had some discussions in the past with Russell and others around the
problem of non-broadcast cache ops on ARM SMP since that's also hurting
you hard with dma mappings.

Can you issue IPIs as FIQs if needed (from my old ARM knowledge, FIQs
are still on even in local_irq_save() blocks right ? I haven't touched
low level ARM for years tho, I may have forgotten things).

In this case, you should probably use the same bits as A9 and simply
make them use FIQs on 11MP to make the other cores flush as well.

> Cortex-A9 broadcasts the cache operations in hardware so we can use
> lazy flushing but with the race you pointed out.

Right.

> Using set_pte_at() for delayed flushing may be a better option for ARM
> as well (and maybe Documentation/cachetlb.txt updated). 

Cheers,
Ben.


