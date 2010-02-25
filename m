Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0BYIO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 03:14:58 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45827 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0BYIO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 03:14:56 -0500
Date: Thu, 25 Feb 2010 13:44:38 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC PATCH v1 1/4] sched: introduce primitives to account for
	CFS bandwidth tracking
Message-ID: <20100225081438.GA9640@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100213025417.23325.90048.stgit@kitami.corp.google.com> <20100213025457.23325.69574.stgit@kitami.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100213025457.23325.69574.stgit@kitami.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 06:54:57PM -0800, Paul wrote:
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -190,10 +190,28 @@ static inline int rt_bandwidth_enabled(void)
>  	return sysctl_sched_rt_runtime >= 0;
>  }
> 
> -static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
> +static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
>  {
> -	ktime_t now;
> +	unsigned long delta;
> +	ktime_t soft, hard, now;
> +
> +	for (;;) {
> +		if (hrtimer_active(period_timer))
> +			break;
> +
> +		now = hrtimer_cb_get_time(period_timer);
> +		hrtimer_forward(period_timer, now, period);
> +
> +		soft = hrtimer_get_softexpires(period_timer);
> +		hard = hrtimer_get_expires(period_timer);
> +		delta = ktime_to_ns(ktime_sub(hard, soft));
> +		__hrtimer_start_range_ns(period_timer, soft, delta, 
> +					 HRTIMER_MODE_ABS_PINNED, 0);
> +	}
> +}
> 
> +static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
> +{
>  	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
>  		return;
> 
> @@ -201,22 +219,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
>  		return;
> 
>  	raw_spin_lock(&rt_b->rt_runtime_lock);
> -	for (;;) {
> -		unsigned long delta;
> -		ktime_t soft, hard;
> -
> -		if (hrtimer_active(&rt_b->rt_period_timer))
> -			break;
> -
> -		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
> -		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
> -
> -		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
> -		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
> -		delta = ktime_to_ns(ktime_sub(hard, soft));
> -		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
> -				HRTIMER_MODE_ABS_PINNED, 0);
> -	}
> +	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
>  	raw_spin_unlock(&rt_b->rt_runtime_lock);
>  }
> 
> @@ -241,6 +244,15 @@ struct cfs_rq;
> 
>  static LIST_HEAD(task_groups);
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +struct cfs_bandwidth {
> +	raw_spinlock_t		lock;
> +	ktime_t			period;
> +	u64			runtime, quota;
> +	struct hrtimer		period_timer;
> +};
> +#endif
> +
>  /* task group related information */
>  struct task_group {
>  #ifdef CONFIG_CGROUP_SCHED
> @@ -272,6 +284,10 @@ struct task_group {
>  	struct task_group *parent;
>  	struct list_head siblings;
>  	struct list_head children;
> +
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	struct cfs_bandwidth cfs_bandwidth;
> +#endif
>  };
> 
>  #ifdef CONFIG_USER_SCHED
> @@ -445,9 +461,76 @@ struct cfs_rq {
>  	 */
>  	unsigned long rq_weight;
>  #endif
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	u64 quota_assigned, quota_used;
> +#endif
>  #endif
>  };
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
> +
> +static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> +{
> +	struct cfs_bandwidth *cfs_b =
> +		container_of(timer, struct cfs_bandwidth, period_timer);
> +	ktime_t now;
> +	int overrun;
> +	int idle = 0;
> +
> +	for (;;) {
> +		now = hrtimer_cb_get_time(timer);
> +		overrun = hrtimer_forward(timer, now, cfs_b->period);
> +
> +		if (!overrun)
> +			break;
> +
> +		idle = do_sched_cfs_period_timer(cfs_b, overrun);
> +	}
> +
> +	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
> +}
> +
> +static
> +void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 quota, u64 period)
> +{
> +	raw_spin_lock_init(&cfs_b->lock);
> +	cfs_b->quota = cfs_b->runtime = quota;
> +	cfs_b->period = ns_to_ktime(period);
> +
> +	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	cfs_b->period_timer.function = sched_cfs_period_timer;
> +}
> +
> +static
> +void init_cfs_rq_quota(struct cfs_rq *cfs_rq)
> +{
> +	cfs_rq->quota_used = 0;
> +	if (cfs_rq->tg->cfs_bandwidth.quota == RUNTIME_INF)
> +		cfs_rq->quota_assigned = RUNTIME_INF;
> +	else
> +		cfs_rq->quota_assigned = 0;
> +}
> +
> +static void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> +{
> +	if (cfs_b->quota == RUNTIME_INF)
> +		return;
> +
> +	if (hrtimer_active(&cfs_b->period_timer))
> +		return;
> +
> +	raw_spin_lock(&cfs_b->lock);
> +	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
> +	raw_spin_unlock(&cfs_b->lock);
> +}
> +
> +static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> +{
> +	hrtimer_cancel(&cfs_b->period_timer);
> +}
> +#endif

May be you could define some of this functions for !CONFIG_CFS_BANDWIDTH case
and avoid them calling under #ifdef ? I was given this comment during my
initial iterations.

> +
>  /* Real-Time classes' related field in a runqueue: */
>  struct rt_rq {
>  	struct rt_prio_array active;
> @@ -1834,6 +1917,14 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
>  #endif
>  }
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +/*
> + * default period for cfs group bandwidth.
> + * default: 0.5s
> + */
> +static u64 sched_cfs_bandwidth_period = 500000000ULL;
> +#endif
> +
>  #include "sched_stats.h"
>  #include "sched_idletask.c"
>  #include "sched_fair.c"
> @@ -9422,6 +9513,9 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
>  	tg->cfs_rq[cpu] = cfs_rq;
>  	init_cfs_rq(cfs_rq, rq);
>  	cfs_rq->tg = tg;
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	init_cfs_rq_quota(cfs_rq);
> +#endif
>  	if (add)
>  		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
> 
> @@ -9594,6 +9688,10 @@ void __init sched_init(void)
>  		 * We achieve this by letting init_task_group's tasks sit
>  		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
>  		 */
> +#ifdef CONFIG_CFS_BANDWIDTH
> +		init_cfs_bandwidth(&init_task_group.cfs_bandwidth,
> +				RUNTIME_INF, sched_cfs_bandwidth_period);
> +#endif
>  		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
>  #elif defined CONFIG_USER_SCHED
>  		root_task_group.shares = NICE_0_LOAD;
> @@ -9851,6 +9949,10 @@ static void free_fair_sched_group(struct task_group *tg)
>  {
>  	int i;
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	destroy_cfs_bandwidth(&tg->cfs_bandwidth);
> +#endif
> +
>  	for_each_possible_cpu(i) {
>  		if (tg->cfs_rq)
>  			kfree(tg->cfs_rq[i]);
> @@ -9878,7 +9980,10 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
>  		goto err;
> 
>  	tg->shares = NICE_0_LOAD;
> -
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	init_cfs_bandwidth(&tg->cfs_bandwidth, RUNTIME_INF,
> +			sched_cfs_bandwidth_period);
> +#endif
>  	for_each_possible_cpu(i) {
>  		rq = cpu_rq(i);
> 
> @@ -10333,7 +10438,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
>  	return walk_tg_tree(tg_schedulable, tg_nop, &data);
>  }
> 
> -static int tg_set_bandwidth(struct task_group *tg,
> +static int tg_set_rt_bandwidth(struct task_group *tg,
>  		u64 rt_period, u64 rt_runtime)
>  {
>  	int i, err = 0;
> @@ -10372,7 +10477,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
>  	if (rt_runtime_us < 0)
>  		rt_runtime = RUNTIME_INF;
> 
> -	return tg_set_bandwidth(tg, rt_period, rt_runtime);
> +	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
>  }
> 
>  long sched_group_rt_runtime(struct task_group *tg)
> @@ -10397,7 +10502,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
>  	if (rt_period == 0)
>  		return -EINVAL;
> 
> -	return tg_set_bandwidth(tg, rt_period, rt_runtime);
> +	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
>  }
> 
>  long sched_group_rt_period(struct task_group *tg)
> @@ -10604,6 +10709,120 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
> 
>  	return (u64) tg->shares;
>  }
> +
> +#ifdef CONFIG_CFS_BANDWIDTH
> +static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
> +{
> +	int i;
> +	static DEFINE_MUTEX(mutex);
> +
> +	if (tg == &init_task_group)
> +		return -EINVAL;
> +
> +	if (!period)
> +		return -EINVAL;
> +
> +	mutex_lock(&mutex);

What is this mutex for ? So you essentially serializing the bandwidth
setting of all groups ? While that iself isn't an issue, just wondering if
cfs_bandwidth.lock isn't suffient ?

> +	/*
> +	 * Ensure we have at least one tick of bandwidth every period.  This is
> +	 * to prevent reaching a state of large arrears when throttled via
> +	 * entity_tick() resulting in prolonged exit starvation.
> +	 */
> +	if (NS_TO_JIFFIES(quota) < 1)
> +		return -EINVAL;

Return with mutex held ?

> +
> +	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
> +	tg->cfs_bandwidth.period = ns_to_ktime(period);
> +	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
> +	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
> +
> +	for_each_possible_cpu(i) {
> +		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
> +		struct rq *rq = rq_of(cfs_rq);
> +
> +		raw_spin_lock_irq(&rq->lock);
> +		cfs_rq->quota_used = 0;
> +		if (quota == RUNTIME_INF)
> +			cfs_rq->quota_assigned = RUNTIME_INF;
> +		else
> +			cfs_rq->quota_assigned = 0;
> +		raw_spin_unlock_irq(&rq->lock);
> +	}
> +	mutex_unlock(&mutex);
> +
> +	return 0;
> +}
> +
>  static void task_waking_fair(struct rq *rq, struct task_struct *p)
> @@ -1172,7 +1180,7 @@ static void task_waking_fair(struct rq *rq, struct task_struct *p)
>   * We still saw a performance dip, some tracing learned us that between
>   * cgroup:/ and cgroup:/foo balancing the number of affine wakeups increased
>   * significantly. Therefore try to bias the error in direction of failing
> - * the affine wakeup.
> + * the affie wakeup.

Unintended change ?

Regards,
Bharata.
