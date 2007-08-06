Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbXHFLh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbXHFLh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763349AbXHFLhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:37:46 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58735 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225AbXHFLho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:37:44 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070802195049.GA361@tv-sign.ru>
References: <20070801181253.GA90@tv-sign.ru>
	 <1185992994.2636.142.camel@imap.mvista.com>
	 <20070801201802.GA225@tv-sign.ru>
	 <1186000468.2636.168.camel@imap.mvista.com>
	 <20070801205053.GA263@tv-sign.ru>
	 <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
	 <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
	 <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
	 <20070802195049.GA361@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 07:35:54 -0400
Message-Id: <1186400154.21381.40.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 23:50 +0400, Oleg Nesterov wrote: 

> I strongly believe you guys take a _completely_ wrong approach.
> queue_work() should _not_ take the priority of the caller into
> account, this is bogus.

I think you have argued very effectively that there are situations in
which the priority should not be taken into account.  I also think a
case could easily be made to say that this RT business may be too
complex to justifiably pollute the workqueue infrastructure.

However, I assure you this:  The concept of a priority ordered queue
coupled with PI-boost is *very* desirable (IMHO) in the RT kernel for
use as an RPC mechanism.  Couple that with the fact that there are many
many parallels to what we need to do for an RT/RPC as there is for
workqueues.  To say outright that priority *can* never or *should* never
be taken into account is equally as bogus.

Ideally we can modify workqueues so that they both retain their
usefulness as they are used today, as well as provide new features as an
RT/RPC transport mechanism.  It would be a bonus if it could be done in
such a way as to advance the usefulness of the workqueues in general.
Perhaps it is not possible, but I doubt some compromise could not be
found.

The motivation to go in this direction is twofold:

1) To avoid having redundant "schedule something arbitrary on a kthread"
type subsystems
2) To possibly allow all users of the workqueue subsystem to benefit
from any advances we can come up with.

As I mentioned in the last mail, to make our proposal work I agree that
the API proposed in the original patch needs to change.  The priority
behavior simply cannot be the default.   I believe this right there will
make most of your examples of where it's broken fall away. 


> 
> Once again. Why do you think that queue_work() from RT99 should
> be considered as more important? This is just not true _unless_
> this task has to _wait_ for this work.

But that's just it.  The thing we are building *does* have to wait, thus
the concern.  

Like I said before, the original non-workqueue implementation *only*
provided for a REQUEST/RESPONSE pattern for RPCs.  The translation to
workqueues was not as straightforward as we originally hoped for because
they support more than REQUEST/RESPONSE.  I realize now that we need to
consider patterns beyond RPCs if we are to get this thing to work so
that all camps are happy.

> 
> So, perhaps, perhaps, it makes sense to modify insert_wq_barrier()
> so that it temporary raises the priority of cwq->thread to match
> that of the caller of flush_workqueue() or cancel_work_sync().

That is not a bad idea, actually.

> 
> However, I think even this is not needed. Please show us the real
> life example why the current implementation sucks.

Assume the following: 

1) Three tasks: A, B, and C where A has the highest priority and C the
lowest.  

2) C is your workqueue-daemon, and is bound to processor 0.

3) B is cpu bound and is currently scheduled on processor 0, and A is on
processor 1.

4) A inserts work to C's workqueue.  

When will the job complete?  Whats more, what if making any more forward
progress on A was predicated on the completion of that job (as it would
be in your RPC type model).  

The answer, of course, is that the work will not complete until B gives
up the processor because C is lower priority than B.  Both A and C will
block indefinitely behind B, thus effectively inverting B's priority to
become logically higher than A's.  This is an example of
priority-inversion and preventing it is one of the things that the patch
tries to address.


> 
> OK. Suppose that we re-order work_struct's according to the caller's
> priority.
> 
> Now, a niced thread doing flush_workqueue() can livelock if workqueue
> is actively used.

No, that's not livelock. That's preemption and it's by design.  Work
will continue when the higher-priority items are finished.  Livelock
would be logic like "while (!queue_empty());".  Here you are still
retaining your position in the queue relative to others at your priority
and below.  

> 
> Actually a niced (so that its priority is lower than cwq->thread's one)
> can deadlock. Suppose it does
> 
> 	lock(LOCK);
> 	flush_workueue(wq);
> 
> and we have a pending work_struct which does:
> 
> 	void work_handler(struct work_struct *self)
> 	{
> 		if (!try_lock(LOCK)) {
> 			// try again later...
> 			queue_work(wq, self);
> 			return;
> 		}
> 
> 		do_something();
> 	}
> 
> Deadlock.

That code is completely broken, so I don't think it matters much.  But
regardless, the new API changes will address that.

> 
> Aha. And this is exactly what I meant above. And this means that flush
> should govern the priority boosting, not queueing!

Ok.  I am not against this idea (I think).  Like I said, the original
system had the work and barrier logic as one unit so boosting at
queue-insert made sense.  We just brought the concept straight over in
the port to workqueues without thinking about it the way you are
proposing.  Upon cursory thought, your argument for flush-time boosting
makes sense to me.

> 
> But again, I think we can just create a special workqueue for that and
> make it RT99. No re-ordering, no playing games with re-niceing.

No, that's just broken in the other direction.  We might as well use
smp_call() at that point.

> 
> Because that workqueue should be "idle" most of the time (no pending
> works), otherwise we are doing something wrong. And I don't think this
> wq can have many users and work->func() shouldn't be heavy, so perhaps
> it is OK if it always runs with the high priority. The latter may be
> wrong though.
> 
> > However, you seem to have objections to the overall change in general
> 
> Well, yes... You propose the complex changes to solve the problem which
> doesn't look very common, this makes me unhappy :)

That's fair.  It's very possible that when its all said and done it may
turn out to be illogical to make the requirements harmonize into one
subsystem.  They may be simply too different from one another justify
the complexity needed to managed between the two worlds.  But I am not
convinced that is the case just yet.  I think we can make it work for
everyone with a little more design work.

I will submit a new patch later which addresses these concerns.

Regards,
-Greg






