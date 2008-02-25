Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYBYNSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYBYNSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbYBYNSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:18:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYBYNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:18:11 -0500
Subject: Re: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080225112102.3B6E928E368@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <200801181429.00485.david-b@pacbell.net>
	 <1200904299.6341.2.camel@lappy> <200801211022.36312.david-b@pacbell.net>
	 <200802242033.52208.david-b@pacbell.net> <1203934828.6242.140.camel@lappy>
	 <20080225112102.3B6E928E368@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 14:17:43 +0100
Message-Id: <1203945463.6242.162.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 03:21 -0800, David Brownell wrote:
> > > > > >     ==> LOCKDEP feature is evidently missing:
> > > > > >             spin_lock_irq_nested(lock_ptr, lock_class)
> > > > > 
> > > > > This rant is more lines than adding the API :-/ the reason for it not
> > > > > being there is simple, it wasn't needed up until now.
> > > > 
> > > > I suspected that was the case, but for all I knew there was some
> > > > religious objection. 
> > > 
> > > Does this look about right?  Or, I suppose it could just call
> > > the _spin_lock_irqsave_nested() routine and discard the result.
> >
> > Before I look at the code, and with a notice that I haven't had my
> > morning juice yet...
> >
> > It seems to me a spin_lock_irq_nested() thing is redundant, because:
> >
> > The lock must obviously be held hardirq safe and nested implies one is
> > already held.
> 
> I thought the way to use the *_nested() calls was "consistently"!

Very much depends on your view of consistent :-)

> That is, if one instance of a lock access uses it, they all should,
> since that's the only way lockdep learns about equivalence classes.
> Also, locks shouldn't move between those equivalence classes... so
> the raw lockdep data stays correct.

Ah, see, you're missing a detail (see below for the full story). Its the
irq state that must be consistent. So if at any one point you take the
lock in an irq safe context, you must always take it irq safe.

> The IRQ framework uses spin_lock_irq() in only one place that I saw:
> in kernel/irq/autoprobe.c for the probe_irq_{on,off,mask}() calls.
>
> Those calls will grab locks at their "top level", and then the
> irqchip methods they call might need to grab locks for other irqs.
> Potential example:  chip->startup() and chip->shutdown() could
> need to ensure a *parent* controller starts/stops, and that should
> involve mutual exclusion using the parent's irq lock (as well as
> the child's).  So the chip and its parent should be in different
> lock classes, else lockdep will wrongly warn of recursion.

Quite, but we must also take note of the irq state.

> >	Hence the context is already hardirq safe thus using
> > spin_lock_irq/spin_unlock_irq is wrong because it will enable irqs and
> > destroy the irqsafe guarantee for the parent lock.
> 
> That's not how the autoprobe() stuff works.  The other calls in
> the genirq framework don't use the *_irq() variants though, so
> your intuition is right there.  (Only the autoprobe paths had
> the FIXME comments in that patch I sent earlier, related to the
> lack of the $SUBJECT primitive.)

Right, which is where I gleaned your usage from..

> > Obviously I'm missing something here.. otherwise you wouldn't need it.
> >
> > As I'm very much not familiar with the IRQ code, could you spell it out
> > to me?
> 
> The probe_irq_*() calls are made from task context, not hardirq
> context, but they access the same locks involved in IRQ management
> and processing.  So either they need to pass the same lock class
> annodations to lockdep, or there's something that's unusually
> counter-intuitive going on with respect to those annotations in
> simple tree data structures.

Ah, you can play tricks here :-) All you need to ensure are consisent
class uses. So if your normal usage is 0->1->2->3 etc.. all you need to
ensure is that the reverse never happens.

Also, have you looked at explicit lock_class_key usage per chip? That
way you can avoid using the _nested annotation. You can set a class on a
lock right after spin_lock_init() using lockdep_set_class*().


Look at it this way:

 spin_lock_irq()   := local_irq_disable(); spin_lock();
 spin_unlock_irq() := spin_unlock(); local_irq_enable();

 spin_lock_irq_nested() : local_irq_disable(); spin_lock_nested();


 spin_lock_irq(&parent_desc->lock);	local_irq_disable();
					spin_lock(&parent_desc->lock);

 spin_lock_irq_nested(&desc->lock, 1);	local_irq_disable();
 					spin_lock_nested(&desc->lock, 1)

 spin_unlock_irq(&desc->lock);		spin_unlock(&desc->lock);
					local_irq_enable(); <--- BUG!

 spin_unlock_irq(&parent_desc->lock);	spin_unlock(&parent_desc->lock);
					local_irq_enable();


At the BUG site lockdep will warn because parent_desc->lock is still
held as hardirq-safe lock, but the context is hardirq-unsafe.

It will become an actual deadlock if at that point an IRQ happens and
tries to acquire parent_desc->lock.

The safe approach is using spin_lock_irqsave{,_nested}().

