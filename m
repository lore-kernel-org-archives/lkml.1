Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbYBSJZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbYBSJZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYBSJYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:24:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbYBSJYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:24:41 -0500
Subject: Re: [PATCH, RFC] kthread: (possibly) a missing memory barrier in
	kthread_stop()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russel <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <200802191744.45281.nickpiggin@yahoo.com.au>
References: <1203375817.7619.73.camel@earth>
	 <200802191744.45281.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 10:24:20 +0100
Message-Id: <1203413060.10858.82.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 17:44 +1100, Nick Piggin wrote:
> On Tuesday 19 February 2008 10:03, Dmitry Adamushko wrote:
> > Hi,
> >
> >
> > [ description ]
> >
> > Subject: kthread: add a memory barrier to kthread_stop()
> >
> > 'kthread' threads do a check in the following order:
> > - set_current_state(TASK_INTERRUPTIBLE);
> > - kthread_should_stop();
> >
> > and set_current_state() implies an smp_mb().
> >
> > on another side (kthread_stop), wake_up_process() does not seem to
> > guarantee a full mb.
> >
> > And 'kthread_stop_info.k' must be visible before wake_up_process()
> > checks for/modifies a state of the 'kthread' task.
> >
> > (the patch is at the end of the message)
> >
> >
> > [ more detailed description ]
> >
> > the current code might well be safe in case a to-be-stopped 'kthread'
> > task is _not_ running on another CPU at the moment when kthread_stop()
> > is called (in this case, 'rq->lock' will act as a kind of synch.
> > point/barrier).
> >
> > Another case is as follows:
> >
> > CPU#0:
> >
> > ...
> > while (kthread_should_stop()) {
> >
> >        if (condition)
> >              schedule();
> >
> >        /* ... do something useful ... */   <--- EIP
> >
> >        set_current_state(TASK_INTERRUPTIBLE);
> > }
> >
> > so a 'kthread' task is about to call
> > set_current_state(TASK_INTERRUPTIBLE) ...
> >
> >
> > (in the mean time)
> >
> > CPU#1:
> >
> > kthread_stop()
> >
> > -> kthread_stop_info.k = k                 (*)
> > -> wake_up_process()
> >
> > wake_up_process() looks like:
> >
> > (try_to_wake_up)
> >
> > IRQ_OFF
> > LOCK
> >
> > old_state = p->state;
> > if (!(old_state & state))                  (**)
> >          goto out;
> >
> > ...
> >
> > UNLOCK
> > IRQ_ON
> >
> >
> > let's suppose (*) and (**) are reordered
> > (according to Documentation/memory-barriers.txt, neither IRQ_OFF nor
> > LOCK may prevent it from happening).
> >
> > - the state is TASK_RUNNING, so we are about to return.
> >
> > - CPU#1 is about to execute (*) (it's guaranteed to be done before
> > spin_unlock(&rq->lock) at the end of try_to_wake_up())
> >
> >
> > (in the mean time)
> >
> > CPU#0:
> >
> > - set_current_state(TASK_INTERRUPTIBLE);
> > - kthread_should_stop();
> >
> > here, kthread_stop_info.k is not yet visible
> >
> > - schedule()
> >
> > ...
> >
> > we missed a 'kthread_stop' event.
> >
> > hum?
> 
> Looks like you are correct to me.
> 
> 
> > TIA,
> >
> > ---
> >
> > From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> > Subject: kthread: add a memory barrier to kthread_stop()
> >
> > 'kthread' threads do a check in the following order:
> > - set_current_state(TASK_INTERRUPTIBLE);
> > - kthread_should_stop();
> >
> > and set_current_state() implies an smp_mb().
> >
> > on another side (kthread_stop), wake_up_process() is not guaranteed to
> > act as a full mb.
> >
> > 'kthread_stop_info.k' must be visible before wake_up_process() checks
> > for/modifies a state of the 'kthread' task.
> >
> >
> > Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> >
> >
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index 0ac8878..5167110 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -211,6 +211,10 @@ int kthread_stop(struct task_struct *k)
> >
> >  	/* Now set kthread_should_stop() to true, and wake it up. */
> >  	kthread_stop_info.k = k;
> > +
> > +	/* The previous store operation must not get ahead of the wakeup. */
> > +	smp_mb();

Does this not also imply you need a matching barrier in
kthread_should_stop() ?

> >  	wake_up_process(k);
> >  	put_task_struct(k);
> >
> >
> >
> > --
> 

