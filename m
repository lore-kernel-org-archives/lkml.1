Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZIVIi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZIVIi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZIVIi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:38:57 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37573 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZIVIi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:38:56 -0400
Message-ID: <4AB88D09.3080907@gmail.com>
Date: Tue, 22 Sep 2009 10:38:33 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 5/5] futex: fix wakeup race by setting TASK_INTERRUPTIBLE
 before queue_me
References: <20090922052452.8717.39673.stgit@Aeon> <20090922053038.8717.97838.stgit@Aeon>
In-Reply-To: <20090922053038.8717.97838.stgit@Aeon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 22 Sep 2009 10:38:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart a écrit :
> PI futexes do not use the same plist_node_empty() test for wakeup. It was
> possible for the waiter (in futex_wait_requeue_pi()) to set TASK_INTERRUPTIBLE
> after the waker assigned the rtmutex to the waiter. The waiter would then note
> the plist was not empty and call schedule(). The task would not be found by any
> subsequeuent futex wakeups, resulting in a userspace hang. By moving the
> setting of TASK_INTERRUPTIBLE to before the call to queue_me(), the race with
> the waker is eliminated. Since we no longer call get_user() from within
> queue_me(), there is no need to delay the setting of TASK_INTERRUPTIBLE until
> after the call to queue_me().
> 
> The FUTEX_LOCK_PI operation is not affected as futex_lock_pi() relies entirely
> on the rtmutex code to handle schedule() and wakeup.  The requeue PI code is
> affected because the waiter starts as a non-PI waiter and is woken on a PI
> futex.
> 
> Remove the crusty old comment about holding spinlocks() across get_user() as we
> no longer do that. Correct the locking statement with a description of why the
> test is performed.

I am very confused by this ChangeLog...

> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Dinakar Guniguntala <dino@in.ibm.com>
> CC: John Stultz <johnstul@us.ibm.com>
> ---
> 
>  kernel/futex.c |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index f92afbe..463af2e 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1656,17 +1656,8 @@ out:
>  static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
>  				struct hrtimer_sleeper *timeout)
>  {
> -	queue_me(q, hb);
> -
> -	/*
> -	 * There might have been scheduling since the queue_me(), as we
> -	 * cannot hold a spinlock across the get_user() in case it
> -	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
> -	 * queueing ourselves into the futex hash. This code thus has to
> -	 * rely on the futex_wake() code removing us from hash when it
> -	 * wakes us up.
> -	 */
>  	set_current_state(TASK_INTERRUPTIBLE);

Hmm, you missed the smp_mb() properties here...

Before :
     queue_me()
     set_mb(current->state, TASK_INTERRUPTIBLE);
     if (timeout) {...}
     if (likely(!plist_node_empty(&q->list))) {
	...
     }

After :
     set_mb(current->state, TASK_INTERRUPTIBLE);
     queue_me();
     if (timeout) {...}
// no barrier... why ar we still testing q->list
// since it has no synchro between queue_me() and test ?
     if (likely(!plist_node_empty(&q->list))) {
	...
     }



> +	queue_me(q, hb);
>  
>  	/* Arm the timer */
>  	if (timeout) {
> @@ -1676,8 +1667,8 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
>  	}
>  
>  	/*
> -	 * !plist_node_empty() is safe here without any lock.
> -	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
> +	 * If we have been removed from the hash list, then another task
> +	 * has tried to wake us, and we can skip the call to schedule().
>  	 */
>  	if (likely(!plist_node_empty(&q->list))) {
>  		/*
> 

