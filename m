Return-Path: <linux-kernel-owner+w=401wt.eu-S1765608AbXHFOY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765608AbXHFOY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763190AbXHFOYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:24:17 -0400
Received: from mail.screens.ru ([213.234.233.54]:33742 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762086AbXHFOYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:24:16 -0400
Date: Mon, 6 Aug 2007 18:26:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070806142616.GA210@tv-sign.ru>
References: <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com> <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru> <1186400154.21381.40.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186400154.21381.40.camel@ghaskins-t60p.haskins.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Gregory Haskins wrote:
>
> On Thu, 2007-08-02 at 23:50 +0400, Oleg Nesterov wrote: 
> 
> > I strongly believe you guys take a _completely_ wrong approach.
> > queue_work() should _not_ take the priority of the caller into
> > account, this is bogus.
> 
> I think you have argued very effectively that there are situations in
> which the priority should not be taken into account.  I also think a
> case could easily be made to say that this RT business may be too
> complex to justifiably pollute the workqueue infrastructure.

Yes, perhaps we can make a separate inreface...

> However, I assure you this:  The concept of a priority ordered queue
> coupled with PI-boost is *very* desirable (IMHO) in the RT kernel for
> use as an RPC mechanism.  Couple that with the fact that there are many
> many parallels to what we need to do for an RT/RPC as there is for
> workqueues.

As I said, I do not understand what the problem exactly is, but surely
I undestand you didn't start this thread without any reason :)

> To say outright that priority *can* never or *should* never
> be taken into account is equally as bogus.

This is true of course, and I didn't claim this.

> > Once again. Why do you think that queue_work() from RT99 should
> > be considered as more important? This is just not true _unless_
> > this task has to _wait_ for this work.
> 
> But that's just it.  The thing we are building *does* have to wait, thus
> the concern.

Yes, as I said before when we have to wait, it makes sense to do
some tricks.

> > So, perhaps, perhaps, it makes sense to modify insert_wq_barrier()
> > so that it temporary raises the priority of cwq->thread to match
> > that of the caller of flush_workqueue() or cancel_work_sync().
> 
> That is not a bad idea, actually.

Great ;)

> > However, I think even this is not needed. Please show us the real
> > life example why the current implementation sucks.
> 
> Assume the following: 
> 
> 1) Three tasks: A, B, and C where A has the highest priority and C the
> lowest.  
> 
> 2) C is your workqueue-daemon, and is bound to processor 0.

...workqueue has a thread for each CPU...

> 3) B is cpu bound and is currently scheduled on processor 0, and A is on
> processor 1.
> 
> 4) A inserts work to C's workqueue.  
> 
> When will the job complete?

Immediately, A inserts the work on CPU 1.

But yes, I see what you mean, but again, again, unless A has to wait
for result etc, etc.

> > OK. Suppose that we re-order work_struct's according to the caller's
> > priority.
> > 
> > Now, a niced thread doing flush_workqueue() can livelock if workqueue
> > is actively used.
> 
> No, that's not livelock. That's preemption and it's by design.  Work
> will continue when the higher-priority items are finished.  Livelock
> would be logic like "while (!queue_empty());".  Here you are still
> retaining your position in the queue relative to others at your priority
> and below.  

It can livelock if other higher-priority threads add works to this wq
repeteadly.

> > Actually a niced (so that its priority is lower than cwq->thread's one)
> > can deadlock. Suppose it does
> > 
> > 	lock(LOCK);
> > 	flush_workueue(wq);
> > 
> > and we have a pending work_struct which does:
> > 
> > 	void work_handler(struct work_struct *self)
> > 	{
> > 		if (!try_lock(LOCK)) {
> > 			// try again later...
> > 			queue_work(wq, self);
> > 			return;
> > 		}
> > 
> > 		do_something();
> > 	}
> > 
> > Deadlock.
> 
> That code is completely broken, so I don't think it matters much.  But
> regardless, the new API changes will address that.

Sorry. This code is not very nice, but it is correct currently.

And I'll give you another example. Let's suppose the task does

	rt_mutex_lock(some_unrelated_lock);

	queue_work(WORK1);
	// WINDOW
	queue_work(WORK2);

I think it would be very natural to expect that these works will be
executed in order, do you agree?

Now suppose that the current's priority was boosted because another
higher-priority task tries to take rt_mutex in the WINDOW above?

Still, still I believe we should not re-order work_structs. If we do
this, we should add another, simplified and specialized interface imho.

> > But again, I think we can just create a special workqueue for that and
> > make it RT99. No re-ordering, no playing games with re-niceing.
> 
> No, that's just broken in the other direction.  We might as well use
> smp_call() at that point.

Well, if we can use smp_call_() we don't need these complications?

> I will submit a new patch later which addresses these concerns.

Please cc me ;)

Oleg.

