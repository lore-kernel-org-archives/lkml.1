Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZIQIMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZIQIMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZIQIMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:12:36 -0400
Received: from www.tglx.de ([62.245.132.106]:34770 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbZIQIMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:12:34 -0400
Date: Thu, 17 Sep 2009 10:11:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: futex: wakeup race and futex_q woken state definition
In-Reply-To: <4AB17A08.50008@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0909170939080.2889@localhost.localdomain>
References: <4AB17A08.50008@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren,

On Wed, 16 Sep 2009, Darren Hart wrote:

> 2) futex_wait_queue_me() (recently refactored from futex_wait())
>   performs the following test:
> 
> 	/*
> 	 * !plist_node_empty() is safe here without any lock.
> 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
> 	 */
> 	if (likely(!plist_node_empty(&q->list))) {
> 		/*
> 		 * If the timer has already expired, current will already be
> 		 * flagged for rescheduling. Only call schedule if there
> 		 * is no timeout, or if it has yet to expire.
> 		 */
> 		if (!timeout || timeout->task)
> 			schedule();
> 	}
> 
> As I understand it, this is to avoid a missed wakeup when a FUTEX_WAKE
> call occurs after the queue_me() but before the futex_wait() call has
> had a chance to call schedule() (via futex_wait_queue_me()).  However,
> as no locks are taken, I don't see what prevents the futex_q from being
> removed from the hash list after the plist_node_empty() test and before
> the call to schedule().  In this scenario, the futex_q will not be found
> on the hash list by subsequent wakers, and it will remain in schedule()
> until a timeout or signal occurs.
> 
> This leads me to the question on the comment: "!plist_node_empty() is
> safe here without any lock." - Why is that safe?
> 
> Secondly, why is the q.lock_ptr test not safe? "q.lock_ptr != 0 is not
> safe, because of ordering against wakeup."
> 
> I understand the definition of the woken state to be
> "plist_node_empty(&q->list) || q->lock_ptr == 0".  So testing the plist
> will detect a woken futex sooner than testing for a null lock_ptr, but I
> don't see how one is more "safe" than the other when no locks are held
> to prevent the futex_q from vanishing off the list before the call to
> schedule().

Much of this are historic leftovers.

futex_wait_queue_me()
{
	queue_me(q, hb);

	/*
	 * There might have been scheduling since the queue_me(), as we
	 * cannot hold a spinlock across the get_user() in case it
	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
	 * queueing ourselves into the futex hash. This code thus has to
	 * rely on the futex_wake() code removing us from hash when it
	 * wakes us up.
	 */

This comment is stale and patently wrong today. There is no get_user()
while we hold a spinlock. So we should move set_current_state() before
queue_me()

	set_current_state(TASK_INTERRUPTIBLE);

	/*
	 * !plist_node_empty() is safe here without any lock.
	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
	 */
	if (likely(!plist_node_empty(&q->list))) {

If we move set_current_state() before the queue_me() this check is
still an optimization to avoid the schedule call in case we have been
woken up already. But the comment is still wrong as the wakeup code
has changed:

The old version did:

     plist_del(&q->list);
     wake_up_all(&q->waiters);
     q->lock_ptr = NULL;

Today we do:

     p = q->task;
     get_task_struct(p);
     plist_del(&q->list);
     q->lock_ptr = NULL;
     wake_up_state(p);
     put_task_struct(p);

We changed this because it makes no sense to use a waitqueue for a
single task.

So the whole commentry is stale and needs to be updated.

Thanks,

	tglx
