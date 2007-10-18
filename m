Return-Path: <linux-kernel-owner+w=401wt.eu-S1764468AbXJRWGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764468AbXJRWGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbXJRWF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:05:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:57191 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759845AbXJRWFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:05:55 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 08:05:37 +1000
Message-Id: <1192745137.7367.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-18 at 22:56 +0800, Herbert Xu wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> > Take a real life example:
> > 
> > drivers/message/fusion/mptbase.c
> > 
> >        /* Disable interrupts! */
> >        CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
> > 
> >        ioc->active = 0;
> >        synchronize_irq(pdev->irq);
> > 
> > And we aren't in a spinlock here. 
> > 
> > That's just a random example grepped.... I think I see a few more. Then,
> > some drivers like tg3 actually do an smp_mb() before calling
> > synchronize_irq(). But then, some don't.
> 
> I really don't see what the point of the barrier would be here.
> Barriers are generally useless unless you have a counter-part
> on the other side.

The barrier would guarantee that ioc->active (and in fact the write to
the chip too above) are globally visible before the read of the irq
status. There are two different issues not to mixup here. Any previous
store vs. a read (general case) and MMIO store of IRQ mask which has
issues of it's own.

> The counterpart here is presumably the interrupt handler, which
> should be terminated by the IO write above regardless of the
> memory barrier.
>
> Of course I might have missed your point.  If so please give
> a description like this for the race that you see:
> 
> CPU1			CPU2
> disable IRQ
> 			whatever the race is
> synchronize_irq

Let's ignore for a moment the generic problem of loads crossing previous
stores and focus on the pure issue of using MMIO writes to mask
interrupts.

Writing to a chip to disable an IRQ is generally never going to provide
any synchronisation guarantee. The MMIO write itself is asynchronous and
not ordered vs. a subsequent read from main storage (ie memory). So
unless you do an MMIO read to flush it, you basically haven't yet
disabled your IRQ don't know when it will be. That's one thing.

Another one is that even if you do an MMIO read to flush, your IRQ may
already have been latched by your PIC, or may be an MSI already issued
and still travelling along busses, and thus might well occur in a few
instructions. In that later case, note that ignoring it is perfectly
fine since the IRQ line will eventually go down (for a level IRQ that
is, for an edge IRQ, ignoring is always fine). That's what we cause
short interrupts, they can be common, though linux has historical issues
with them (unrelated to this discussion). But your interrupt handler
_will_ be called, and thus should be aware that your intend is to ignore
it.

So for both of the reasons above, the MMIO write doesn't mean you IRQ
won't happen and in fact, synchronize_irq() here is totally useless
since it won't prevent the IRQ from actually still happening just after
the test_bit of IRQ_INPROGRESS.

Now, the way to actually do that properly is to _also_ have a flag to
indicate your handler you don't want to deal with that interrupt. That
could be something along the lines of:

	writel(irq mask);
	wmb();
	chip->masked = 1;
 	smp_mb();
	synchronize_irq();

Now, the IRQ handler can just do

	if (chip->masked == 1)
		return <whatever>;

Another way is to use spinlocks of course, but we are talking about high
perf stuff that tries to avoid spinlocks on every IRQs, which is fair
enough, thus putting the synchronization burden on the slow path.

In the above example, you need that smp_mb() to make sure that the
effect of chip->masked = 1 is globally visible before the read in
synchronize_irq() is performed. Without that, that read could cross the
previous write, in fact, it may even travel all the way to before the
MMIO in some cases, and thus cause synchronize_irq() to operate on a
completely stale version of irq_desc->status, thus possibly bailing out
early while the IRQ is still happening and chip->masked not yet visible
to the other CPUs. 

In general, synchronize_irq() alone is always bogus, because that read
can travel up. That's why I believe it would simply make things simpler
and avoid problems to put the smp_mb(); inside synchronize_irq() (and same
goes with napi_synchronize() for the exact same reasons).

> While in general I'd agree with you about give latitude to
> drivers, memory barriers I think is something that we can't
> afford to.


> The reason is that memory barries tend to come in pairs, e.g.,
> 
> CPU1			CPU2
> write A
> wmb
> write B
> 			read B
> 			rmb
> 			read A
> 
> Taking away either barrier would render the other useless.
> 
> So whenever we add only one barrier for the benefit of driver
> writers who don't bother to think about barriers we may not
> be helping them at all.

In the case of synchronize_irq and my above example, yes, indeed, there
should be a pending barrier between setting IRQ_INPROGRESS and the
reading of chip->masked by the driver. This is a very good point because
I incorrectly assumed that the spin_unlock inside handle_*_irq before
calling the handler would do it, but it will not indeed. The spin_unlock
is only a write barrier, not a read barrier, it won't prevent a
following read from travelling back into the spinlock, potentially
before the setting of IRQ_INPROGRESS.

Thus, indeed, either an smp_rmb() should be used in the IRQ handler
before testing thus chip->masked, or we should stick one in
handle_IRQ_event for safety.

I'm pretty sure quite a few drivers are broken in that regard :-)

So maybe it's fair enough to say that barriers in those case should be
left as a responsibility to the callers. However, I still think that
synchronize_irq() without a barrier will generally not make any sense,
even if you should also generally have some kind of matching barrier
within whatever you are synchronizing with.

Ben.
 

