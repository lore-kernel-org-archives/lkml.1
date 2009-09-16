Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbZIPXvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbZIPXvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZIPXvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:51:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37257 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbZIPXvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:51:35 -0400
Message-ID: <4AB17A08.50008@us.ibm.com>
Date: Wed, 16 Sep 2009 16:51:36 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: futex: wakeup race and futex_q woken state definition
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on futex commentary cleanup patch series.  While reading
through all the remaining comments, I've come across a couple I'd your
thoughts on:

The futex woken state is defined as:

 * A futex_q has a woken state, just like tasks have TASK_RUNNING.
 * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
 * The order of wakup is always to make the first condition true, then
 * wake up q->waiter, then make the second condition true.

1) wake_futex() actually wakes the task (q->task not q->waiter) after
   the lock_ptr has been set to NULL. I believe this is fine and can
   correct the comments accordingly.

2) futex_wait_queue_me() (recently refactored from futex_wait())
   performs the following test:

	/*
	 * !plist_node_empty() is safe here without any lock.
	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
	 */
	if (likely(!plist_node_empty(&q->list))) {
		/*
		 * If the timer has already expired, current will already be
		 * flagged for rescheduling. Only call schedule if there
		 * is no timeout, or if it has yet to expire.
		 */
		if (!timeout || timeout->task)
			schedule();
	}

As I understand it, this is to avoid a missed wakeup when a FUTEX_WAKE
call occurs after the queue_me() but before the futex_wait() call has
had a chance to call schedule() (via futex_wait_queue_me()).  However,
as no locks are taken, I don't see what prevents the futex_q from being
removed from the hash list after the plist_node_empty() test and before
the call to schedule().  In this scenario, the futex_q will not be found
on the hash list by subsequent wakers, and it will remain in schedule()
until a timeout or signal occurs.

This leads me to the question on the comment: "!plist_node_empty() is
safe here without any lock." - Why is that safe?

Secondly, why is the q.lock_ptr test not safe? "q.lock_ptr != 0 is not
safe, because of ordering against wakeup."

I understand the definition of the woken state to be
"plist_node_empty(&q->list) || q->lock_ptr == 0".  So testing the plist
will detect a woken futex sooner than testing for a null lock_ptr, but I
don't see how one is more "safe" than the other when no locks are held
to prevent the futex_q from vanishing off the list before the call to
schedule().

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
