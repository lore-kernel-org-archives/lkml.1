Return-Path: <linux-kernel-owner+w=401wt.eu-S966266AbXJSEUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966266AbXJSEUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXJSEUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:20:35 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3055 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750857AbXJSEUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:20:35 -0400
Date: Fri, 19 Oct 2007 12:20:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Message-ID: <20071019042025.GA9617@gondor.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au> <1192745137.7367.40.camel@pasglop> <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org> <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org> <20071019023219.GB8453@gondor.apana.org.au> <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org> <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 08:26:45PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 18 Oct 2007, Linus Torvalds wrote:
> >
> > I *think* it should work with something like
> > 
> > 	for (;;) {
> > 		smp_rmb();
> > 		if (!spin_is_locked(&desc->lock)) {
> > 			smp_rmb();
> > 			if (!(desc->status & IRQ_INPROGRESS)
> > 				break;
> > 		}
> > 		cpu_relax();
> > 	}
> 
> I'm starting to doubt this. 
> 
> One of the issues is that we still need the smp_mb() in front of the loop 
> (because we want to serialize the loop with any writes in the caller).

Right.  I think if we accept the definition of a spin lock/unlock
that Nick outlined earlier, then we can see that on the IRQ path
there simply isn't a memory barrier between the changing of the
status field and the execution of the action:

	spin_lock
	set IRQ_INPROGRESS
	spin_unlock

	action

	spin_lock
	clear IRQ_INPROGRESS
	spin_unlock

What may happen is that action can either float upwards to give

	spin_lock
	action
	set IRQ_INPROGRESS
	spin_unlock

	spin_lock
	clear IRQ_INPROGRESS
	spin_unlock

or it can float downwards to give

	spin_lock
	set IRQ_INPROGRESS
	spin_unlock

	spin_lock
	clear IRQ_INPROGRESS
	action
	spin_unlock

As a result we can add as many barriers as we want on the slow
(synchronize_irq) path and it just won't do any good (not unless
we add some barriers on the IRQ path == fast path).

What we do have on the right though is the fact in some ways
action behaves as if it's inside the spin lock even though it's
not.  In particular, action cannot float up past the first spin
lock nor can it float down past the last spin unlock.

> See commit fa490cfd15d7ce0900097cc4e60cfd7a76381138 and ponder. Maybe we 
> should take the same approach here, and do something like
> 
> 	repeat:
> 		/* Optimistic, no-locking loop */
> 		while (desc->status & IRQ_INPROGRESS)
> 			cpu_relax();
> 
> 		/* Ok, that indicated we're done: double-check carefully */
> 		spin_lock_irqsave(&desc->lock, flags);
> 		status = desc->status;
> 		spin_unlock_irqrestore(&desc->lock, flags);
> 
> 		/* Oops, that failed? */
> 		if (status & IRQ_INPROGRESS)
> 			goto repeat;

That's why I think this patch is in fact the only one that
solves all the races in this thread.  The case that it solves
which the lock/unlock patch does not is the one where action
flows downwards past the clearing of IRQ_INPROGRESS.  I missed
this case earlier.

In fact this bug exists elsewhere too.  For example, the network
stack does this in net/sched/sch_generic.c:

        /* Wait for outstanding qdisc_run calls. */
	while (test_bit(__LINK_STATE_QDISC_RUNNING, &dev->state))
		yield();

This has the same problem as the current synchronize_irq code.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
