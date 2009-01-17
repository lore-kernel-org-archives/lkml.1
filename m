Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbZAQKIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbZAQKIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 05:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZAQKIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 05:08:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZAQKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 05:08:08 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232186054.6813.48.camel@marge.simson.net>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 11:07:57 +0100
Message-Id: <1232186877.14073.59.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 10:54 +0100, Mike Galbraith wrote:

Same comments as before..

> The problem with the C++ testcases seems to be wake_up_all() plunking a
> genuine thundering herd onto runqueues.

I'm still trying to find what wake_up_all() is being hit... Both
test-cases seem to create ping-pong threads/processes (lots of them
though).

>   The sleeper fairness logic
> places the entire herd left of min_vruntime, meaning N*sched_latency
> pain for the poor sods who are setting the runqueue pace.

Right, how about we flip the 'initial' case in place_entity() for !
nr_exclusive wakeups.

> This doesn't make interactivity wonderful of course, fair schedulers
> don't do wonderful under heavy load, but this did prevent seizure.

That's not inherently to fair schedulers, there's only so much you can
do when there's 50 processes contending for time.

> (it's likely somewhat broken on top of being butt ugly.. diag hack;)
> 
> Suggestions welcome. 
> 
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index ef609f8..e20e557 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -143,6 +143,12 @@ int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
>  int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
>  wait_queue_head_t *bit_waitqueue(void *, int);
>  
> +#define WAKE_SYNC	1

The regular sync hint of affine me harder

> +#define WAKE_FAIR	2

sleeper fairness for this wakeup

> +#define WAKE_BUDDY	4

set buddies for this wakeup

> +#define WAKE_PREEMPT	8

Do wakeup preemption for this wakeup.

> +#define WAKE_NORMAL	(WAKE_FAIR | WAKE_BUDDY | WAKE_PREEMPT)
> +
>  #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
>  #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
>  #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 52bbf1c..ee52d89 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2258,13 +2258,13 @@ static int sched_balance_self(int cpu, int flag)
>   */
>  static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
>  {
> -	int cpu, orig_cpu, this_cpu, success = 0;
> +	int cpu, orig_cpu, this_cpu, success = 0, herd = sync & WAKE_FAIR;
>  	unsigned long flags;
>  	long old_state;
>  	struct rq *rq;
>  
>  	if (!sched_feat(SYNC_WAKEUPS))
> -		sync = 0;
> +		sync &= ~WAKE_SYNC;
>  
>  #ifdef CONFIG_SMP
>  	if (sched_feat(LB_WAKEUP_UPDATE)) {
> @@ -2334,7 +2334,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
>  out_activate:
>  #endif /* CONFIG_SMP */
>  	schedstat_inc(p, se.nr_wakeups);
> -	if (sync)
> +	if (sync & WAKE_SYNC)
>  		schedstat_inc(p, se.nr_wakeups_sync);
>  	if (orig_cpu != cpu)
>  		schedstat_inc(p, se.nr_wakeups_migrate);
> @@ -2342,7 +2342,7 @@ out_activate:
>  		schedstat_inc(p, se.nr_wakeups_local);
>  	else
>  		schedstat_inc(p, se.nr_wakeups_remote);
> -	activate_task(rq, p, 1);
> +	activate_task(rq, p, 1 + !herd);

Right, so how about 1 - !herd ?

>  	success = 1;
>  
>  out_running:
> @@ -4692,12 +4692,19 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
>  {
>  	wait_queue_t *curr, *next;
>  
> +
> +	if (!nr_exclusive)
> +		sync &= ~(WAKE_FAIR | WAKE_BUDDY);

Right, disable buddies and sleeper fairness for mass wakeups

>  	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
>  		unsigned flags = curr->flags;
>  
>  		if (curr->func(curr, mode, sync, key) &&
>  				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
>  			break;
> +
> +		/* Only one preemptive wakeup per herd. */
> +		sync &= ~WAKE_PREEMPT;

and only let the first wakeup do a preemption.

>  	}
>  }
>  
> @@ -4714,7 +4721,7 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode,
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&q->lock, flags);
> -	__wake_up_common(q, mode, nr_exclusive, 0, key);
> +	__wake_up_common(q, mode, nr_exclusive, WAKE_NORMAL, key);
>  	spin_unlock_irqrestore(&q->lock, flags);
>  }
>  EXPORT_SYMBOL(__wake_up);
> @@ -4724,7 +4731,7 @@ EXPORT_SYMBOL(__wake_up);
>   */
>  void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
>  {
> -	__wake_up_common(q, mode, 1, 0, NULL);
> +	__wake_up_common(q, mode, 1, WAKE_NORMAL, NULL);
>  }
>  
>  /**
> @@ -4744,13 +4751,13 @@ void
>  __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
>  {
>  	unsigned long flags;
> -	int sync = 1;
> +	int sync = WAKE_NORMAL | WAKE_SYNC;
>  
>  	if (unlikely(!q))
>  		return;
>  
>  	if (unlikely(!nr_exclusive))
> -		sync = 0;
> +		sync &= ~WAKE_SYNC;
>  
>  	spin_lock_irqsave(&q->lock, flags);
>  	__wake_up_common(q, mode, nr_exclusive, sync, NULL);
> @@ -4773,7 +4780,7 @@ void complete(struct completion *x)
>  
>  	spin_lock_irqsave(&x->wait.lock, flags);
>  	x->done++;
> -	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
> +	__wake_up_common(&x->wait, TASK_NORMAL, 1, WAKE_NORMAL, NULL);
>  	spin_unlock_irqrestore(&x->wait.lock, flags);
>  }
>  EXPORT_SYMBOL(complete);
> @@ -4790,7 +4797,7 @@ void complete_all(struct completion *x)
>  
>  	spin_lock_irqsave(&x->wait.lock, flags);
>  	x->done += UINT_MAX/2;
> -	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
> +	__wake_up_common(&x->wait, TASK_NORMAL, 0, WAKE_NORMAL, NULL);
>  	spin_unlock_irqrestore(&x->wait.lock, flags);
>  }
>  EXPORT_SYMBOL(complete_all);
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5cc1c16..3e40d7e 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -661,7 +661,7 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  }
>  
>  static void
> -place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
> +place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
>  {
>  	u64 vruntime = cfs_rq->min_vruntime;
>  
> @@ -671,12 +671,12 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  	 * little, place the new task so that it fits in the slot that
>  	 * stays open at the end.
>  	 */
> -	if (initial && sched_feat(START_DEBIT))
> +	if (!wakeup && sched_feat(START_DEBIT))
>  		vruntime += sched_vslice(cfs_rq, se);
>  
> -	if (!initial) {
> +	if (wakeup) {
>  		/* sleeps upto a single latency don't count. */
> -		if (sched_feat(NEW_FAIR_SLEEPERS)) {
> +		if (sched_feat(NEW_FAIR_SLEEPERS && wakeup == 1)) {

That doesn't look like it fancies compiling though ;-)

>  			unsigned long thresh = sysctl_sched_latency;
>  
>  			/*
> @@ -709,7 +709,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
>  	account_entity_enqueue(cfs_rq, se);
>  
>  	if (wakeup) {
> -		place_entity(cfs_rq, se, 0);
> +		place_entity(cfs_rq, se, wakeup);
>  		enqueue_sleeper(cfs_rq, se);
>  	}
>  
> @@ -1189,6 +1189,9 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
>  	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
>  		return 0;
>  
> +	/* Clear flags unused by this function. */
> +	sync = sync & WAKE_SYNC;
> +
>  	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
>  			p->se.avg_overlap > sysctl_sched_migration_cost))
>  		sync = 0;
> @@ -1392,9 +1395,11 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
>  	 * Also, during early boot the idle thread is in the fair class, for
>  	 * obvious reasons its a bad idea to schedule back to the idle thread.
>  	 */
> -	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
> +	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle) &&
> +			sync & WAKE_BUDDY)
>  		set_last_buddy(se);
> -	set_next_buddy(pse);
> +	if (sync & WAKE_BUDDY)
> +		set_next_buddy(pse);
>  
>  	/*
>  	 * We can come here with TIF_NEED_RESCHED already set from new task
> @@ -1416,10 +1421,10 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
>  		return;
>  	}
>  
> -	if (!sched_feat(WAKEUP_PREEMPT))
> +	if (!sched_feat(WAKEUP_PREEMPT) || !sync & WAKE_PREEMPT)

C operator precendence suggests you write !(sync & WAKE_PREEMPT), unless
you're attempting to write 0 in a complicated way.

>  		return;
>  
> -	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
> +	if (sched_feat(WAKEUP_OVERLAP) && (sync & WAKE_SYNC||
>  			(se->avg_overlap < sysctl_sched_migration_cost &&
>  			 pse->avg_overlap < sysctl_sched_migration_cost))) {
>  		resched_task(curr);
> @@ -1650,7 +1655,7 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
>  	sched_info_queued(p);
>  
>  	update_curr(cfs_rq);
> -	place_entity(cfs_rq, se, 1);
> +	place_entity(cfs_rq, se, 0);
>  
>  	/* 'curr' will be NULL if the child belongs to a different group */
>  	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
> @@ -1721,7 +1726,7 @@ static void moved_group_fair(struct task_struct *p)
>  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
>  
>  	update_curr(cfs_rq);
> -	place_entity(cfs_rq, &p->se, 1);
> +	place_entity(cfs_rq, &p->se, 0);
>  }
>  #endif


