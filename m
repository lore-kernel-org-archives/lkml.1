Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbYBWSTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbYBWSTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYBWSTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:19:05 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:54571 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbYBWSTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:19:04 -0500
Date: Sat, 23 Feb 2008 21:22:58 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch added to -mm tree
Message-ID: <20080223182258.GA19946@tv-sign.ru>
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org> <20080223162705.GA7686@tv-sign.ru> <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802230937530.21332@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Linus Torvalds wrote:
> 
> On Sat, 23 Feb 2008, Oleg Nesterov wrote:
> > 
> > In short: wake_up_process() doesn't imply mb(), this means that _in theory_
> > the commonly used code like
> > 
> > 	set_current_state(TASK_INTERRUPTIBLE);
> > 	if (CONDITION)
> > 		return;
> > 	schedule();
> > 
> > is racy wrt
> > 
> > 	CONDITION = 1;
> > 	wake_up_process(p);
> > 
> > I'll be happy to be wrong though, please correct me.
> 
> Well, you should be wrong on x86, because the spinlock at the head of 
> wake_up_process() (well, "try_to_wake_up()" to be exact) will be a full 
> memory barrier.
> 
> But yeah, in general spinlocks can have weaker semantics, and let 
> preceding writes percolate into the critical section and thus past the 
> point that actually sets task->state.

Yes. (I mean, this matches my understanding)

> And I do agree that we should *not* add a memory barrier in the caller 
> (that's just going to be really confusing for everybody, and make these 
> things much harder than they should be), and we should make sure that the 
> above sequence is always race-free.
> 
> I also think that a full memory barrier is overkill. We should be ok with 
> just adding a write barrier to the top of wake_up_process(), no? That way, 
> we know that the CONDITION will be seen on the other CPU before it sees 
> task->state change to TASK_RUNNING, so with the memory barrier int he 
> "set_current_state()", we know that the other side will see the new 
> condition _or_ it will see TASK_RUNNING when it hits schedule.

Yes, but still I suspect wmb() is not enough. Note that try_to_wake_up()
first checks (reads) the task->state,

	if (!(old_state & state))
		goto out;

without the full mb() it is (in theory) possible that try_to_wake_up()
first reads TASK_RUNNING and only then sets CONDITION. IOW, STORE and
LOAD could be re-ordered.

> (smp_wmb() also has the advantage of being a no-op on x86, where it's not 
> needed).

Can't we introduce smp_mb_before_spinlock() (or whatever) as iirc Steven
suggested some time ago?


A bit offtopic, but let's take another example, __queue_work()->insert_work().
With some trivial modification we can move set_wq_data() outside of cwq->lock.
But according to linux's memory model we still need wmb(), which is a bit
annoying. Perhaps we can also add smp_wmb_before_spinlock(). Not sure this
is not too ugly though.

Oleg.

