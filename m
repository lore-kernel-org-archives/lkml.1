Return-Path: <linux-kernel-owner+w=401wt.eu-S933692AbXHFO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbXHFO7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932657AbXHFO7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:59:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33565 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbXHFO7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:59:03 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070806142616.GA210@tv-sign.ru>
References: <20070801201802.GA225@tv-sign.ru>
	 <1186000468.2636.168.camel@imap.mvista.com>
	 <20070801205053.GA263@tv-sign.ru>
	 <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
	 <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
	 <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
	 <20070802195049.GA361@tv-sign.ru>
	 <1186400154.21381.40.camel@ghaskins-t60p.haskins.net>
	 <20070806142616.GA210@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 10:57:15 -0400
Message-Id: <1186412235.21381.82.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 18:26 +0400, Oleg Nesterov wrote:

> 
> This is true of course, and I didn't claim this.

My apologies.  I misunderstood you.


> > When will the job complete?
> 
> Immediately, A inserts the work on CPU 1.

Well, if you didn't care about which CPU, that's true.  But suppose we
want to direct this specifically at CWQ for cpu 0.  This is the type of
environment we need to build a "schedule_on_cpu()" type function.
Executing the function locally would be pointless for a RPC/smp_call()
like interface.


> 
> It can livelock if other higher-priority threads add works to this wq
> repeteadly.

That's really starvation, though.  I agree with you that it is
technically possible to happen if the bandwidth of the higher priority
producer task is greater than the bandwidth of the consumer.  But note
that the RT priorities already forgo starvation avoidance, so IMO the
queue can here as well.  E.g. if the system designer runs a greedy app
at a high RT priority, it can starve as many lower priority items as it
wants anyway.  This is no different.

(There might potentially be a problem here with Daniel's version of the
patch because I didn't initially notice that he used the entire priority
spectrum instead of only RT.  I think we need to go back to RT + 1
"normal" priority)

> 
> > > Actually a niced (so that its priority is lower than cwq->thread's one)
> > > can deadlock. Suppose it does
> > > 
> > > 	lock(LOCK);
> > > 	flush_workueue(wq);
> > > 
> > > and we have a pending work_struct which does:
> > > 
> > > 	void work_handler(struct work_struct *self)
> > > 	{
> > > 		if (!try_lock(LOCK)) {
> > > 			// try again later...
> > > 			queue_work(wq, self);
> > > 			return;
> > > 		}
> > > 
> > > 		do_something();
> > > 	}
> > > 
> > > Deadlock.
> > 
> > That code is completely broken, so I don't think it matters much.  But
> > regardless, the new API changes will address that.
> 
> Sorry. This code is not very nice, but it is correct currently.

Well, the "trylock+requeue" avoids the obvious recursive deadlock, but
it introduces a more subtle error: the reschedule effectively bypasses
the flush.  E.g. whatever work was being flushed was allowed to escape
out from behind the barrier.  If you don't care about the flush working,
why do it at all?

But like I said, its moot...we will fix that condition at the API level
(or move away from overloading the workqueues)

> 
> And I'll give you another example. Let's suppose the task does
> 
> 	rt_mutex_lock(some_unrelated_lock);
> 
> 	queue_work(WORK1);
> 	// WINDOW
> 	queue_work(WORK2);
> 
> I think it would be very natural to expect that these works will be
> executed in order, do you agree?

I agree.  That's a valid point and will be tough to solve.  If you look
at dynamic priority, you have the problem you are highlighting, and if
you look at static priority you can reintroduce inversion.  :(  This
might be the issue that kills the idea.

> 
> Now suppose that the current's priority was boosted because another
> higher-priority task tries to take rt_mutex in the WINDOW above?
> 
> Still, still I believe we should not re-order work_structs. If we do
> this, we should add another, simplified and specialized interface imho.
> 
> > > But again, I think we can just create a special workqueue for that and
> > > make it RT99. No re-ordering, no playing games with re-niceing.
> > 
> > No, that's just broken in the other direction.  We might as well use
> > smp_call() at that point.
> 
> Well, if we can use smp_call_() we don't need these complications?

All I meant is that running the queue at RT99 would have as many
deficiencies as smp_call() does, and therefore we might as well not
bother with new infrastructure.

With an RT99 or smp_call() solution, all invocations effectively preempt
whatever is running on the target CPU.  That is why I said it was the
opposite problem.  A low priority client can preempt a high-priority
task, which is just as bad as the current situation.

> 
> > I will submit a new patch later which addresses these concerns.
> 
> Please cc me ;)

Will do.  Thank you for the review!

-Greg

