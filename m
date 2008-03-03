Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYCCPNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYCCPNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYCCPNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:13:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbYCCPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:13:22 -0500
Date: Mon, 3 Mar 2008 10:13:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, pavel@ucw.cz, acme@redhat.com,
       gregkh@suse.de, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com
Subject: Re: [(RT RFC) PATCH v2 1/9] allow rt-mutex lock-stealing to include
 lateral priority
In-Reply-To: <20080225160043.11268.83915.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0803030944530.18766@gandalf.stny.rr.com>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160043.11268.83915.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



/me finally has time to catch up on some email.

On Mon, 25 Feb 2008, Gregory Haskins wrote:

> The current logic only allows lock stealing to occur if the current task
> is of higher priority than the pending owner. We can gain signficant
> throughput improvements (200%+) by allowing the lock-stealing code to
> include tasks of equal priority.  The theory is that the system will make
> faster progress by allowing the task already on the CPU to take the lock
> rather than waiting for the system to wake-up a different task.
>
> This does add a degree of unfairness, yes.  But also note that the users
> of these locks under non -rt environments have already been using unfair
> raw spinlocks anyway so the tradeoff is probably worth it.
>
> The way I like to think of this is that higher priority tasks should
> clearly preempt, and lower priority tasks should clearly block.  However,
> if tasks have an identical priority value, then we can think of the
> scheduler decisions as the tie-breaking parameter. (e.g. tasks that the
> scheduler picked to run first have a logically higher priority amoung tasks
> of the same prio).  This helps to keep the system "primed" with tasks doing
> useful work, and the end result is higher throughput.

Interesting. I thought about this when I first implemented it. My thought
was on fairness, and having some worry about starvation. But if you have
two processes of the same RT priority, then you must account for it.

But..., this can cause confusion with having two tasks of the same RT
priority bound to two different CPUS.

  CPU0                            CPU1
 -----                         ---------
RT task blocks on L1
Owner releases L1
RT task pending owner of L1
                               Same prio RT task grabs L1
                               (steals from other RT task)
RT task wakes up to find
  L1 stolen and goes
  back to sleep.
                               Releases L1 giving
RT task becomes pending owner
                               Grabs L1 again and steals it again.
RT wakes up to find
  L1 stolen and goes back
  to sleep.


See the issue. The RT task on CPU0 may experience huge latencies.
Remember, RT is worried about latencies over performance.
If we can not ***guarantee*** a bounded latency, then, I don't care
how good the perfomance is, it is not good enough for RT.


That said, here's the compromise.

Non-RT tasks care more about overall perfomance than worst case latencies.
So.... See imbedded:


>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/Kconfig.preempt |   10 ++++++++++
>  kernel/rtmutex.c       |   31 +++++++++++++++++++++++--------
>  2 files changed, 33 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index 41a0d88..e493257 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -196,3 +196,13 @@ config SPINLOCK_BKL
>  	  Say Y here if you are building a kernel for a desktop system.
>  	  Say N if you are unsure.
>
> +config RTLOCK_LATERAL_STEAL
> +        bool "Allow equal-priority rtlock stealing"
> +        default y
> +        depends on PREEMPT_RT
> +        help
> +          This option alters the rtlock lock-stealing logic to allow
> +          equal priority tasks to preempt a pending owner in addition
> +          to higher priority tasks.  This allows for a significant
> +          boost in throughput under certain circumstances at the expense
> +          of strict FIFO lock access.

We either do this or we don't. No config option.

> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index a2b00cc..6624c66 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -313,12 +313,27 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  	return ret;
>  }
>
> +static inline int lock_is_stealable(struct task_struct *pendowner, int unfair)
> +{
> +#ifndef CONFIG_RTLOCK_LATERAL_STEAL
> +	if (current->prio >= pendowner->prio)
> +#else
> +	if (current->prio > pendowner->prio)
> +		return 0;
> +
> +	if (!unfair && (current->prio == pendowner->prio))
> +#endif
> +		return 0;
> +
> +	return 1;
> +}
> +

This instead:


	if (rt_task(current) ?
		(current->prio >= pendingowner->prio) :
		(current->prio > pendingowner->prio))


For RT tasks we keep the FIFO order. This keeps it deterministic.
But for non RT tasks, that still can steal locks, we just simply let them
steal if at a higher priority.

And just use that as the condition. No need to add another inline
function (doesn't make it any more readable).

Actually, this is the only change I see in this patch that is needed.
The rest is simply passing parameters and adding extra unneeded options.

-- Steve




>  /*
>   * Optimization: check if we can steal the lock from the
>   * assigned pending owner [which might not have taken the
>   * lock yet]:
>   */
> -static inline int try_to_steal_lock(struct rt_mutex *lock)
> +static inline int try_to_steal_lock(struct rt_mutex *lock, int unfair)
>  {
>  	struct task_struct *pendowner = rt_mutex_owner(lock);
>  	struct rt_mutex_waiter *next;
> @@ -330,7 +345,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
>  		return 1;
>
>  	spin_lock(&pendowner->pi_lock);
> -	if (current->prio >= pendowner->prio) {
> +	if (!lock_is_stealable(pendowner, unfair)) {
>  		spin_unlock(&pendowner->pi_lock);
>  		return 0;
>  	}
> @@ -383,7 +398,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
>   *
>   * Must be called with lock->wait_lock held.
>   */
> -static int try_to_take_rt_mutex(struct rt_mutex *lock)
> +static int try_to_take_rt_mutex(struct rt_mutex *lock, int unfair)
>  {
>  	/*
>  	 * We have to be careful here if the atomic speedups are
> @@ -406,7 +421,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
>  	 */
>  	mark_rt_mutex_waiters(lock);
>
> -	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock))
> +	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, unfair))
>  		return 0;
>
>  	/* We got the lock. */
> @@ -707,7 +722,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>  		int saved_lock_depth = current->lock_depth;
>
>  		/* Try to acquire the lock */
> -		if (try_to_take_rt_mutex(lock))
> +		if (try_to_take_rt_mutex(lock, 1))
>  			break;
>  		/*
>  		 * waiter.task is NULL the first time we come here and
> @@ -947,7 +962,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  	init_lists(lock);
>
>  	/* Try to acquire the lock again: */
> -	if (try_to_take_rt_mutex(lock)) {
> +	if (try_to_take_rt_mutex(lock, 0)) {
>  		spin_unlock_irqrestore(&lock->wait_lock, flags);
>  		return 0;
>  	}
> @@ -970,7 +985,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  		unsigned long saved_flags;
>
>  		/* Try to acquire the lock: */
> -		if (try_to_take_rt_mutex(lock))
> +		if (try_to_take_rt_mutex(lock, 0))
>  			break;
>
>  		/*
> @@ -1078,7 +1093,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
>
>  		init_lists(lock);
>
> -		ret = try_to_take_rt_mutex(lock);
> +		ret = try_to_take_rt_mutex(lock, 0);
>  		/*
>  		 * try_to_take_rt_mutex() sets the lock waiters
>  		 * bit unconditionally. Clean this up.
>
>
