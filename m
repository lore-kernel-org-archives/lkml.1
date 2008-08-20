Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYHTLRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYHTLRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYHTLRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:17:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14103 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYHTLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:17:18 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [RFC 1/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dario Faggioli <raistlin@linux.it>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <1218465906.6450.42.camel@Palanthas>
References: <1218465906.6450.42.camel@Palanthas>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 13:17:09 +0200
Message-Id: <1219231029.8651.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 16:45 +0200, Dario Faggioli wrote:

Some quick commments interspered in the patch below..

I'm not sure I understand the pending replenishment stuff, do we really
have to keep that in disrete state? (yeah - I should read the spec
again)

Also, I need to stare more at how you did the sporadic group stuff, a
litte description on your ideas here would be appreciated.


> diffstat:
>  include/linux/sched.h |   68 ++++++++
>  init/Kconfig          |   42 +++++
>  kernel/sched.c        |  352 ++++++++++++++++++++++++++++++++++++++++++--
>  kernel/sched_rt.c     |  400 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 838 insertions(+), 24 deletions(-)
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> ---
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5270d44..6804fa2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -38,13 +38,11 @@
>  #define SCHED_BATCH		3
>  /* SCHED_ISO: reserved but not implemented yet */
>  #define SCHED_IDLE		5
> +#define SCHED_SPORADIC		6
> +#define SS_REPL_MAX		CONFIG_SCHED_SPORADIC_REPL_MAX
>  
>  #ifdef __KERNEL__
>  
> -struct sched_param {
> -	int sched_priority;
> -};
> -
>  #include <asm/param.h>	/* for HZ */
>  
>  #include <linux/capability.h>
> @@ -90,6 +88,27 @@ struct sched_param {
>  
>  #include <asm/processor.h>
>  
> +/*
> + * If SCHED_SPORADIC scheduling is implemented we need more
> + * task scheduling parameters, as specified by the POSIX/Open Group
> + * real-time extensions.
> + *
> + * XXX:
> + * Could this be an ABI problem? For example every time we have a
> + * copy_from/to_user of struct sched_param, and becouse of the fact that
> + * we are changing the size of struct sched_param itself? Any idea
> + * or solution?
> + */
> +struct sched_param {
> +	int sched_priority;
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	int sched_ss_low_priority;
> +	struct timespec sched_ss_repl_period;
> +	struct timespec sched_ss_init_budget;
> +	int sched_ss_max_repl;
> +#endif
> +};
> +
>  struct mem_cgroup;
>  struct exec_domain;
>  struct futex_pi_state;
> @@ -1007,9 +1026,50 @@ struct sched_entity {
>  #endif
>  };
>  
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +/*
> + * SCHED_SPORADIC recharging event handler.
> + */
> +struct ss_repl {
> +	ktime_t instant;
> +	s64 amount;
> +};
> +
> +/*
> + * SCHED_SPORADIC task and task group data.
> + */
> +struct sched_sporadic_data {
> +	struct sched_rt_entity *rt_se;
> +
> +	/* initial values coming from sched_param */
> +	int priority;
> +	int low_priority;
> +	u64 init_budget;
> +	u64 repl_period;
> +	int repl_max;
> +
> +	/* current values */
> +	ktime_t act_time;
> +	s64 depl_budget;
> +	s64 curr_budget;
> +
> +	/* timer and buffer of pending recharges. */
> +	struct hrtimer repl_timer;
> +
> +	struct ss_repl repl[SS_REPL_MAX];
> +	int first_repl, last_repl;
> +	int nr_repl;
> +};
> +#endif
> +
>  struct sched_rt_entity {
>  	struct list_head run_list;
>  	unsigned int time_slice;
> +
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	struct sched_sporadic_data *ss;
> +#endif
> +
>  	unsigned long timeout;
>  	int nr_cpus_allowed;
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index b678803..97fbdfc 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -323,6 +323,44 @@ config CPUSETS
>  config HAVE_UNSTABLE_SCHED_CLOCK
>  	bool
>  
> +config POSIX_SCHED_SPORADIC
> +	bool "SCHED_SPORADIC POSIX scheduling policy support"
> +	default n
> +	help
> +	  Enable the SCHED_SPORADIC POSIX scheduling policy, which mimics
> +	  the behaviour of the Sporadic Server, a well known mechanism
> +	  to schedule aperiodic or sporadic tasks in periodic-based fixed
> +	  priorit real-time systems.
> +
> +	  To get details about the SCHED_SPORADIC scheduling policy refer to
> +	  "The Open Group Base Specifications Issue 6", IEEE Std 1003.1,
> +	  2004 Edition.
> +
> +	  [http://www.opengroup.org/onlinepubs/009695399/nfindex.html]
> +
> +config SCHED_SPORADIC_REPL_MAX
> +	int "Maximum number of pending recharges"
> +	range 1 1000
> +	depends on POSIX_SCHED_SPORADIC
> +	default 10
> +	help
> +	  Let you chose the maximum number of recharges that can be
> +	  pending at a given time instant for a SCHED_SPORADIC task
> +	  (or task group if group scheduling is configured).
> +
> +	  The kernel data structure handling the SCHED_SPORADIC scheduling
> +	  policy for tasks and groups contains a buffer of pending
> +	  replenishment this size large.
> +	  For tasks it is dynamically allocated when SCHED_SPORADIC is set
> +	  as the scheduling policy of the task, while for group it is created
> +	  as soon as the group itself is allocated.
> +
> +	  Anyway, since this is going to cause some memory overhead, it is
> +	  wise to not set this to a too much high value.
> +	  The best value depends on the characteristics of the application
> +	  you are going to use, but probably a value from 10 to 20 is
> +	  suitable for the most of the situations.
> +
>  config GROUP_SCHED
>  	bool "Group CPU scheduler"
>  	depends on EXPERIMENTAL
> @@ -347,6 +385,10 @@ config RT_GROUP_SCHED
>  	  setting below. If enabled, it will also make it impossible to
>  	  schedule realtime tasks for non-root users until you allocate
>  	  realtime bandwidth for them.
> +
> +	  If CONFIG_POSIX_SCHED_SPORADIC is defined this option also enables
> +	  Sporadic Server based group scheduling.
> +
>  	  See Documentation/sched-rt-group.txt for more information.
>  
>  choice
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 04160d2..404e6a7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -137,9 +137,24 @@ static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
>  }
>  #endif
>  
> +static inline int policy_is_sched_sporadic(int policy)
> +{
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +		return policy == SCHED_SPORADIC;
> +#else
> +		return 0;
> +#endif
> +}
> +
> +static inline int task_is_sched_sporadic(struct task_struct *p)
> +{
> +	return policy_is_sched_sporadic(p->policy);
> +}
> +
>  static inline int rt_policy(int policy)
>  {
> -	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
> +	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR ||
> +		     policy_is_sched_sporadic(policy)))
>  		return 1;
>  	return 0;
>  }
> @@ -268,7 +283,11 @@ struct task_group {
>  	struct rt_rq **rt_rq;
>  
>  	struct rt_bandwidth rt_bandwidth;
> +
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	struct sched_sporadic_data ss;
>  #endif
> +#endif /* CONFIG_RT_GROUP_SCHED */
>  
>  	struct rcu_head rcu;
>  	struct list_head list;
> @@ -453,6 +472,9 @@ struct rt_rq {
>  	u64 rt_runtime;
>  	/* Nests inside the rq lock: */
>  	spinlock_t rt_runtime_lock;
> +#if defined CONFIG_POSIX_SCHED_SPORADIC && defined CONFIG_RT_GROUP_SCHED
> +	spinlock_t rt_ss_rq_lock;
> +#endif
>  
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	unsigned long rt_nr_boosted;
> @@ -2555,6 +2577,17 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	if (mm)
>  		mmdrop(mm);
>  	if (unlikely(prev_state == TASK_DEAD)) {
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +		/*
> +		 * If a SCHED_SPORADIC task is dieing the replenishment
> +		 * timer has to be cancelled and the memory we allocated
> +		 * for its struct sched_sporadic_data has to be freed.
> +		 */
> +		if (task_is_sched_sporadic(prev)) {
> +			rt_ss_destroy_repl_timer(prev->rt.ss);
> +			kfree(prev->rt.ss);
> +		}
> +#endif
>  		/*
>  		 * Remove function-return probe instances associated with this
>  		 * task and put them back on the free list.
> @@ -4778,7 +4811,7 @@ void set_user_nice(struct task_struct *p, long nice)
>  	 * The RT priorities are set via sched_setscheduler(), but we still
>  	 * allow the 'normal' nice value to be set - but as expected
>  	 * it wont have any effect on scheduling until the task is
> -	 * SCHED_FIFO/SCHED_RR:
> +	 * SCHED_FIFO, SCHED_RR or SCHED_SPORADIC:
>  	 */
>  	if (task_has_rt_policy(p)) {
>  		p->static_prio = NICE_TO_PRIO(nice);
> @@ -4929,6 +4962,7 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
>  		break;
>  	case SCHED_FIFO:
>  	case SCHED_RR:
> +	case SCHED_SPORADIC:
>  		p->sched_class = &rt_sched_class;
>  		break;
>  	}
> @@ -4940,6 +4974,68 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
>  	set_load_weight(p);
>  }
>  
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +
> +static inline
> +void __init_sched_sporadic_param(struct sched_sporadic_data *ss,
> +				 struct sched_param *param)
> +{
> +	ss->priority = MAX_RT_PRIO-1 - param->sched_priority;
> +	ss->low_priority = MAX_RT_PRIO-1 - param->sched_ss_low_priority;
> +
> +	ss->init_budget = timespec_to_ns(&param->sched_ss_init_budget);
> +	ss->repl_period = timespec_to_ns(&param->sched_ss_repl_period);
> +	ss->repl_max = param->sched_ss_max_repl;
> +
> +	ss->act_time = ktime_set(0, 0);
> +	ss->curr_budget = ss->init_budget;
> +	ss->depl_budget = 0;
> +
> +	rt_ss_init_repl_timer(ss);
> +
> +	ss->first_repl = ss->last_repl = 0;
> +	ss->nr_repl = 0;
> +}
> +
> +static void
> +__setscheduler_param(struct rq *rq, struct task_struct *p, int policy,
> +		     struct sched_param *param)
> +{
> +	if (unlikely(policy_is_sched_sporadic(policy))) {
> +		struct sched_sporadic_data *ss;
> +
> +		/*
> +		 * The struct sched_sporadic_data ss is dynamically
> +		 * allocated because we do not want to impose the
> +		 * memory overhead it implies to all tasks' task_struct,
> +		 * if they have not SCHED_SPORADIC as their shceduling
> +		 * policy.
> +		 */

Sticking sched_entity and sched_rt_entity into a union - and taking out
the common variables has been on my todo list forever. 

If done, it might be possible to just stick struct sched_sporadic_data
into sched_rt_entity.

> +		if (likely(p->rt.ss == NULL)) {
> +			ss = kmalloc(sizeof(*ss), GFP_KERNEL);
> +			p->rt.ss = ss;
> +			ss->rt_se = &p->rt;
> +		} else {
> +			ss = p->rt.ss;
> +			hrtimer_cancel(&ss->repl_timer);
> +		}
> +		__init_sched_sporadic_param(ss, param);
> +	} else if (unlikely(policy_is_sched_sporadic(p->policy))) {
> +		hrtimer_cancel(&p->rt.ss->repl_timer);
> +		kfree(p->rt.ss);
> +		p->rt.ss = NULL;
> +	}
> +#else
> +
> +static void
> +__setscheduler_param(struct rq *rq, struct task_struct *p, int policy,
> +		     struct sched_param *param)
> +{
> +#endif
> +
> +	__setscheduler(rq, p, policy, param->sched_priority);
> +}
> +

Did that #endif get bored at its old location and just wander up a few
lines?

> static int __sched_setscheduler(struct task_struct *p, int policy,
>  				struct sched_param *param, bool user)
>  {
> @@ -4954,19 +5050,30 @@ recheck:
>  	/* double check policy once rq lock held */
>  	if (policy < 0)
>  		policy = oldpolicy = p->policy;
> -	else if (policy != SCHED_FIFO && policy != SCHED_RR &&
> +	else if (policy != SCHED_FIFO &&
> +			policy != SCHED_RR &&
> +			!policy_is_sched_sporadic(policy) &&

!rt_policy()

> 			policy != SCHED_NORMAL && policy != SCHED_BATCH &&
>  			policy != SCHED_IDLE)
>  		return -EINVAL;
>  	/*
> -	 * Valid priorities for SCHED_FIFO and SCHED_RR are
> -	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
> +	 * Valid priorities for SCHED_FIFO, SCHED_RR and SCHED_SPORADIC
> +	 * are 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
>  	 * SCHED_BATCH and SCHED_IDLE is 0.
>  	 */
>  	if (param->sched_priority < 0 ||
>  	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
>  	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
>  		return -EINVAL;
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	if (unlikely(policy_is_sched_sporadic(policy)) &&
> +	    ((p->mm && param->sched_ss_low_priority > MAX_USER_RT_PRIO-1) ||
> +	    (!p->mm && param->sched_ss_low_priority > MAX_RT_PRIO-1)))
> +		return -EINVAL;
> +	if (unlikely(policy_is_sched_sporadic(policy)) &&
> +	    param->sched_ss_max_repl > SS_REPL_MAX)
> +		return -EINVAL;
> +#endif

One could stuff this into a function called
setscheduler_validate_sporadic_param() or similar.

Another thing one could possibly do is query the hrtimer interface for
its granularity and validate the given period etc. against it.

> 	if (rt_policy(policy) != (param->sched_priority != 0))
>  		return -EINVAL;
>  
> @@ -5045,7 +5152,9 @@ recheck:
>  		p->sched_class->put_prev_task(rq, p);
>  
>  	oldprio = p->prio;
> -	__setscheduler(rq, p, policy, param->sched_priority);
> +
> +	/* for SCHED_SPORADICs we need the whole struct sched_param */
> +	__setscheduler_param(rq, p, policy, param);
>  
>  	if (running)
>  		p->sched_class->set_curr_task(rq);
> @@ -5191,6 +5300,16 @@ asmlinkage long sys_sched_getparam(pid_t pid, struct sched_param __user *param)
>  		goto out_unlock;
>  
>  	lp.sched_priority = p->rt_priority;
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	if (task_is_sched_sporadic(p)) {
> +		struct sched_sporadic_data *ss = p->rt.ss;
> +
> +		lp.sched_ss_low_priority = MAX_RT_PRIO-1 - ss->low_priority;
> +		lp.sched_ss_repl_period = ns_to_timespec(ss->repl_period);
> +		lp.sched_ss_init_budget = ns_to_timespec(ss->init_budget);
> +		lp.sched_ss_max_repl = ss->repl_max;
> +	}
> +#endif
>  	read_unlock(&tasklist_lock);
>  
>  	/*
> @@ -5497,6 +5616,7 @@ asmlinkage long sys_sched_get_priority_max(int policy)
>  	switch (policy) {
>  	case SCHED_FIFO:
>  	case SCHED_RR:
> +	case SCHED_SPORADIC:
>  		ret = MAX_USER_RT_PRIO-1;
>  		break;
>  	case SCHED_NORMAL:
> @@ -5522,6 +5642,7 @@ asmlinkage long sys_sched_get_priority_min(int policy)
>  	switch (policy) {
>  	case SCHED_FIFO:
>  	case SCHED_RR:
> +	case SCHED_SPORADIC:
>  		ret = 1;
>  		break;
>  	case SCHED_NORMAL:
> @@ -5562,13 +5683,14 @@ long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
>  		goto out_unlock;
>  
>  	/*
> -	 * Time slice is 0 for SCHED_FIFO tasks and for SCHED_OTHER
> -	 * tasks that are on an otherwise idle runqueue:
> +	 * Time slice is 0 for SCHED_FIFO/SCHED_SPORADIC tasks and
> +	 * for SCHED_OTHER tasks that are on an otherwise idle runqueue:
>  	 */
>  	time_slice = 0;
> -	if (p->policy == SCHED_RR) {
> -		time_slice = DEF_TIMESLICE;
> -	} else if (p->policy != SCHED_FIFO) {
> +	if (rt_policy(p->policy)) {
> +		if (p->policy == SCHED_RR)
> +			time_slice = DEF_TIMESLICE;
> +	} else {
>  		struct sched_entity *se = &p->se;
>  		unsigned long flags;
>  		struct rq *rq;
> @@ -7849,6 +7971,9 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
>  	rt_rq->rt_throttled = 0;
>  	rt_rq->rt_runtime = 0;
>  	spin_lock_init(&rt_rq->rt_runtime_lock);
> +#if defined CONFIG_POSIX_SCHED_SPORADIC && defined CONFIG_RT_GROUP_SCHED
> +	spin_lock_init(&rt_rq->rt_ss_rq_lock);
> +#endif
>  
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	rt_rq->rt_nr_boosted = 0;
> @@ -7978,6 +8103,20 @@ void __init sched_init(void)
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	init_rt_bandwidth(&init_task_group.rt_bandwidth,
>  			global_rt_period(), global_rt_runtime());
> +
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	init_task_group.ss.rt_se = NULL;
> +
> +	init_task_group.ss.repl_period = -1;
> +	init_task_group.ss.init_budget = -1;
> +	init_task_group.ss.repl_max = 1;
> +
> +	init_task_group.ss.depl_budget = 0;
> +	rt_ss_init_repl_timer(&init_task_group.ss);
> +	init_task_group.ss.first_repl = init_task_group.ss.last_repl = 0;
> +	init_task_group.ss.nr_repl = 0;
> +#endif

init_rt_ss()

> +
>  #ifdef CONFIG_USER_SCHED
>  	init_rt_bandwidth(&root_task_group.rt_bandwidth,
>  			global_rt_period(), RUNTIME_INF);
> @@ -8369,6 +8508,19 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
>  	init_rt_bandwidth(&tg->rt_bandwidth,
>  			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
>  
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	tg->ss.rt_se = NULL;
> +
> +	tg->ss.repl_period = -1;
> +	tg->ss.init_budget = -1;
> +	tg->ss.repl_max = -1;
> +
> +	tg->ss.depl_budget = 0;
> +	rt_ss_init_repl_timer(&tg->ss);
> +	tg->ss.first_repl = tg->ss.last_repl = 0;
> +	tg->ss.nr_repl = 0;
> +#endif

init_rt_ss() ?

>  	for_each_possible_cpu(i) {
>  		rq = cpu_rq(i);
>  
> @@ -8895,7 +9047,13 @@ cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
>  {
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	/* Don't accept realtime tasks when there is no way for them to run */
> -	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0)
> +	if (rt_task(tsk) &&
> +#ifndef CONFIG_POSIX_SCHED_SPORADIC
> +	    cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0)
> +#else
> +	    (cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0 &&
> +	     cgroup_tg(cgrp)->ss.init_budget < 0))
> +#endif /* !CONFIG_POSIX_SCHED_SPORADIC */
>  		return -EINVAL;
>  #else
>  	/* We don't support RT-tasks being in separate groups */
> @@ -8950,6 +9108,156 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
>  {
>  	return sched_group_rt_period(cgroup_tg(cgrp));
>  }
> +
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +
> +static int cpu_rt_ss_budget_write(struct cgroup *cgrp, struct cftype *cft,
> +				  s64 ss_budget)
> +{
> +	struct task_group *tg = cgroup_tg(cgrp);
> +	struct sched_sporadic_data *ss = &tg->ss;
> +	int i, err = 0;
> +
> +	if (unlikely(ss_budget < -1))
> +		ss_budget = -1;
> +
> +	read_lock(&tasklist_lock);
> +	if (!ss) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +	if (ss_budget != -1 && ss->repl_period != -1 &&
> +	    ss->repl_period < ss_budget) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +	if (ss_budget == 0 && ss->init_budget != -1 &&
> +	    ss->repl_period != -1 && ss->repl_max != -1 &&
> +	    tg_has_rt_tasks(tg)) {
> +		err = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	for_each_possible_cpu(i) {
> +		struct rt_rq *rt_rq = tg->rt_rq[i];
> +
> +		spin_lock(&rt_rq->rt_ss_rq_lock);
> +		ss->init_budget = (u64)ss_budget;
> +		ss->curr_budget = ss_budget;
> +		spin_unlock(&rt_rq->rt_ss_rq_lock);
> +	}
> +
> + unlock:
> +	read_unlock(&tasklist_lock);
> +	return err;
> +}
> +
> +static s64 cpu_rt_ss_budget_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct task_group *tg = cgroup_tg(cgrp);
> +	struct sched_sporadic_data *ss = &tg->ss;
> +
> +	if (!ss)
> +		return -1;
> +
> +	return ss->init_budget;
> +}
> +
> +static int cpu_rt_ss_period_write(struct cgroup *cgrp, struct cftype *cft,
> +				  s64 ss_period)
> +{
> +	struct task_group *tg = cgroup_tg(cgrp);
> +	struct sched_sporadic_data *ss = &tg->ss;
> +	int i, err = 0;
> +
> +	if (unlikely(ss_period < -1))
> +		ss_period = -1;
> +
> +	read_lock(&tasklist_lock);
> +	if (!ss) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +	if (ss_period != -1 && ss->init_budget != -1 &&
> +	    ss_period < ss->init_budget) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	for_each_possible_cpu(i) {
> +		struct rt_rq *rt_rq = tg->rt_rq[i];
> +
> +		spin_lock(&rt_rq->rt_ss_rq_lock);
> +		ss->repl_period = (u64)ss_period;
> +		spin_unlock(&rt_rq->rt_ss_rq_lock);
> +	}
> +
> + unlock:
> +	read_unlock(&tasklist_lock);
> +	return err;
> +}
> +
> +static s64 cpu_rt_ss_period_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct task_group *tg = cgroup_tg(cgrp);
> +	struct sched_sporadic_data *ss = &tg->ss;
> +
> +	if (!ss)
> +		return -1;
> +
> +	return ss->repl_period;
> +}
> +
> +static int cpu_rt_ss_repl_max_write(struct cgroup *cgrp, struct cftype *cft,
> +				    s64 repl_max)
> +{
> +	struct task_group *tg = cgroup_tg(cgrp);
> +	struct sched_sporadic_data *ss = &tg->ss;
> +	int i, err = 0;
> +
> +	if (unlikely(repl_max < -1))
> +		repl_max = -1;
> +
> +	read_lock(&tasklist_lock);
> +	if (!ss) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +	if (repl_max > SS_REPL_MAX) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	for_each_possible_cpu(i) {
> +		struct rt_rq *rt_rq = tg->rt_rq[i];
> +
> +		spin_lock(&rt_rq->rt_ss_rq_lock);
> +		if (repl_max != -1 && repl_max < ss->nr_repl) {
> +			spin_unlock(&rt_rq->rt_ss_rq_lock);
> +			err = -EBUSY;
> +			goto unlock;
> +		} else
> +			ss->repl_max = (int)repl_max;
> +		spin_unlock(&rt_rq->rt_ss_rq_lock);
> +	}
> +
> + unlock:
> +	read_unlock(&tasklist_lock);
> +	return err;
> +}
> +
> +static s64 cpu_rt_ss_repl_max_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct task_group *tg = cgroup_tg(cgrp);
> +	struct sched_sporadic_data *ss = &tg->ss;
> +
> +	if (!ss)
> +		return -1;
> +
> +	return ss->repl_max;
> +}
> +#endif
> +
>  #endif /* CONFIG_RT_GROUP_SCHED */
>  
>  static struct cftype cpu_files[] = {
> @@ -8971,7 +9279,25 @@ static struct cftype cpu_files[] = {
>  		.read_u64 = cpu_rt_period_read_uint,
>  		.write_u64 = cpu_rt_period_write_uint,
>  	},
> -#endif
> +
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	{
> +		.name = "rt_ss_budget_ns",
> +		.read_s64 = cpu_rt_ss_budget_read,
> +		.write_s64 = cpu_rt_ss_budget_write,
> +	},
> +	{
> +		.name = "rt_ss_period_ns",
> +		.read_s64 = cpu_rt_ss_period_read,
> +		.write_s64 = cpu_rt_ss_period_write,
> +	},
> +	{
> +		.name = "rt_ss_max_repl",
> +		.read_s64 = cpu_rt_ss_repl_max_read,
> +		.write_s64 = cpu_rt_ss_repl_max_write,
> +	},
> +#endif /* CONFIG_POSIX_SCHED_SPORADIC */

I'm not at all sure I understand how you've woven the sporadic bits into
the group structure - will have to stare at that a bit more..

> +#endif /* CONFIG_RT_GROUP_SCHED */
>  };
>  
>  static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 908c04f..b0c8bdf 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1,6 +1,6 @@
>  /*
> - * Real-Time Scheduling Class (mapped to the SCHED_FIFO and SCHED_RR
> - * policies)
> + * Real-Time Scheduling Class (mapped to the SCHED_FIFO,
> + * SCHED_SPORADIC and SCHED_RR policies)
>   */
>  
>  #ifdef CONFIG_SMP
> @@ -463,6 +463,338 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +
> +static void
> +prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio, int running);
> +
> +static inline int __ss_is_sched_prio(struct sched_sporadic_data *ss)
> +{
> +	/*
> +	 * A SCHED_SPORADIC task or group is running at its high priority
> +	 * level if its budget is positive and if it has room for at least
> +	 * one replenishment.
> +	 */
> +	return ss != NULL &&
> +	       ss->curr_budget > 0 &&
> +	       ss->nr_repl < ss->repl_max;
> +}

perhaps ss_is_sched_prio_high(), also that comment might be better
placed above the function.

> +static void __ss_switch_prio(struct task_struct *p, int new_prio)
> +{
> +	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);
> +	struct rq *rq = rq_of_rt_rq(rt_rq);
> +	int old_prio = rt_se_prio(&p->rt);
> +
> +	/*
> +	 * Change the priority of a SCHED_SPORADIC task taking
> +	 * priority inheritance into account.
> +	 */
> +	p->normal_prio = new_prio;
> +	p->prio = rt_mutex_getprio(p);
> +	prio_changed_rt(rq, p, old_prio, task_running(rq, p));
> +}
> +
> +static inline
> +void __ss_update_budget(struct sched_sporadic_data *ss,
> +			s64 depl_time, s64 exec_time)
> +{
> +	/*
> +	 * Update the SCHED_SPORADIC budget considering the fact that
> +	 * exec_time is a negative value and depl_time is zero in case
> +	 * a replenishment is taking place.
> +	 */
> +	ss->depl_budget += depl_time;
> +	ss->curr_budget -= exec_time;
> +
> +	if (ss->curr_budget < 0)
> +		ss->curr_budget = 0;
> +	else if (ss->curr_budget > ss->init_budget)
> +		ss->curr_budget = ss->init_budget;
> +}
> +
> +static inline
> +int __rt_se_is_ss(struct sched_rt_entity *rt_se)
> +{
> +	return rt_se->ss != NULL;
> +}
> +
> +static inline
> +struct sched_rt_entity *rt_se_of_ss(struct sched_sporadic_data *ss)
> +{
> +	return ss->rt_se;
> +}
> +
> +static inline
> +int rt_se_is_ss_sched_prio(struct sched_rt_entity *rt_se)
> +{
> +	return __rt_se_is_ss(rt_se) && __ss_is_sched_prio(rt_se->ss);
> +}
> +
> +static inline
> +int rt_se_is_ss_low_prio(struct sched_rt_entity *rt_se)
> +{
> +	return __rt_se_is_ss(rt_se) && !__ss_is_sched_prio(rt_se->ss);
> +}
> +
> +#ifdef CONFIG_RT_GROUP_SCHED
> +
> +static inline int __rt_rq_is_ss(struct rt_rq *rt_rq)
> +{
> +	struct task_group *tg = rt_rq->tg;
> +
> +	return tg != NULL &&
> +	       tg->ss.init_budget != -1 &&
> +	       tg->ss.repl_period != -1 &&
> +	       tg->ss.repl_max != -1;
> +}
> +
> +static inline int rt_rq_is_ss_sched_prio(struct rt_rq *rt_rq)
> +{
> +	return __rt_rq_is_ss(rt_rq) && __ss_is_sched_prio(&rt_rq->tg->ss);
> +}
> +
> +static inline int rt_rq_is_ss_low_prio(struct rt_rq *rt_rq)
> +{
> +	return __rt_rq_is_ss(rt_rq) && !__ss_is_sched_prio(&rt_rq->tg->ss);
> +}
> +
> +#endif
> +
> +static inline void rt_ss_set_act_time(struct sched_sporadic_data *ss)
> +{
> +	if (!ktime_to_ns(ss->act_time) == 0)
> +		return;
> +
> +	/*
> +	 * Since it is possible this function being called more than
> +	 * what it should be required, we record the activation time of
> +	 * the SCHED_SPORADIC task or task group only if act_time has
> +	 * been previously set to zero.
> +	 */
> +	ss->act_time = hrtimer_cb_get_time(&ss->repl_timer);

we usually use rq->clock for time accounting

Also, I see you use this in a for loop below - in which case its _much_
faster to get the time once pass it around.

Reading xtime is way expensive - which is why we normally use rq->clock
to measure time.

> +	ss->depl_budget = 0;
> +}
> +
> +static int rt_ss_decr_budget(struct sched_sporadic_data *ss, u64 exec_time)
> +{
> +	__ss_update_budget(ss, (s64)exec_time, (s64)exec_time);
> +
> +	return ss->curr_budget;
> +}
> +
> +static int rt_ss_repl_budget(struct sched_sporadic_data *ss, s64 repl_amount)
> +{
> +	__ss_update_budget(ss, 0, repl_amount);
> +
> +	return ss->curr_budget;
> +}

curr_budget is s64, which doesn't match the return value of the above
two functions.

Also, the above pattern suggests that __ss_update_budget() should be
returning curr_budget as well.

Then again, a quick scroll down doesn't show any consumers of this
return value.

> +static int rt_ss_post_recharge(struct sched_sporadic_data *ss)
> +{
> +	ktime_t now = hrtimer_cb_get_time(&ss->repl_timer);
> +	ktime_t repl_time;
> +	s64 repl_amount;
> +
> +	repl_time = ktime_add(ss->act_time, ns_to_ktime(ss->repl_period));
> +	repl_amount = (s64)-ss->depl_budget;
> +	ss->act_time = ns_to_ktime(0);

Again, doing time measurements using rq->clock is faster than reading
xtime and all this ktime fudging.

> +	if (ktime_us_delta(repl_time, now) <= 0) {
> +		/* replenishment time in the past, so replenish and exit. */
> +		rt_ss_repl_budget(ss, repl_amount);
> +		rt_ss_set_act_time(ss);
> +
> +		goto post_recharge_end;
> +	}
> +	if (ss->nr_repl < ss->repl_max) {
> +		int next_repl = ss->last_repl;
> +
> +		ss->repl[next_repl].instant = repl_time;
> +		ss->repl[next_repl].amount = repl_amount;
> +		ss->last_repl = (next_repl + 1) % SS_REPL_MAX;
> +		ss->nr_repl++;
> +
> +		if (ss->nr_repl != 1)
> +			goto post_recharge_end;
> +
> +		/*
> +		 * We have just added a replenishment event and it is the
> +		 * only one, so we need to start the replenishment timer.
> +		 */
> +		BUG_ON(hrtimer_active(&ss->repl_timer));
> +		hrtimer_start(&ss->repl_timer, repl_time, HRTIMER_MODE_ABS);
> +	}
> +
> + post_recharge_end:
> +	return ss->curr_budget <= 0;
> +}
> +
> +static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
> +static void dequeue_rt_stack(struct sched_rt_entity *rt_se);
> +static void __enqueue_rt_entity(struct sched_rt_entity *rt_se);
> +static void __dequeue_rt_entity(struct sched_rt_entity *rt_se);
> +
> +static inline
> +int rt_se_ss_budget_exhausted(struct sched_rt_entity *rt_se, u64 delta_exec)
> +{
> +	struct sched_sporadic_data *ss = rt_se->ss;
> +
> +	if (likely(!rt_se_is_ss_sched_prio(rt_se)))
> +		return 0;
> +
> +	/*
> +	 * If the we are running out of budget
> +	 * switch the task's priority and requeue.
> +	 */
> +	rt_ss_decr_budget(ss, delta_exec);
> +	if (ss->curr_budget <= 0 && rt_ss_post_recharge(ss)) {
> +		dequeue_rt_stack(rt_se);
> +
> +		for_each_sched_rt_entity(rt_se) {
> +			if (!group_rt_rq(rt_se))
> +				__ss_switch_prio(rt_task_of(rt_se),
> +						 ss->low_priority);
> +			__enqueue_rt_entity(rt_se);
> +		}
> +
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void __rt_se_ss_repl_timer(struct sched_rt_entity *rt_se)
> +{
> +	struct sched_sporadic_data *ss = rt_se->ss;
> +	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
> +	struct rq *rq = rq_of_rt_rq(rt_rq);
> +	ktime_t now = hrtimer_cb_get_time(&ss->repl_timer);
> +
> +	spin_lock(&rq->lock);
> +	while (ss->nr_repl > 0 &&
> +	       ktime_us_delta(ss->repl[ss->first_repl].instant, now) <= 0) {
> +		s64 repl_amount = ss->repl[ss->first_repl].amount;
> +
> +		/*
> +		 * Consume a replenishment event updating the budget and,
> +		 * if it is the case, requeueing the task at its high
> +		 * priority level.
> +		 */
> +		rt_ss_repl_budget(ss, repl_amount);
> +		ss->first_repl = (ss->first_repl + 1) % SS_REPL_MAX;
> +		ss->nr_repl--;
> +
> +		if (likely(!rt_se_is_ss_low_prio(rt_se))) {
> +			__ss_switch_prio(rt_task_of(rt_se),
> +					 rt_se->ss->priority);
> +			if (on_rt_rq(rt_se))
> +				/* do not enqueue a task if it was not! */
> +				enqueue_rt_entity(rt_se);

While not strictly needed, I prefer braces around this bit because its
multi line.

> +		}
> +	}
> +	spin_unlock(&rq->lock);
> +}
> +
> +#ifdef CONFIG_RT_GROUP_SCHED
> +
> +static inline
> +int rt_rq_ss_budget_exhausted(struct rt_rq *rt_rq, u64 delta_exec)
> +{
> +	struct sched_sporadic_data *ss = &rt_rq->tg->ss;
> +
> +	if (likely(!rt_rq_is_ss_sched_prio(rt_rq)))
> +		return 0;
> +
> +	rt_ss_decr_budget(ss, delta_exec);
> +	if (ss->curr_budget <= 0 && rt_ss_post_recharge(ss)) {
> +		rt_rq->rt_throttled = 1;
> +		if (rt_rq_throttled(rt_rq)) {
> +			sched_rt_rq_dequeue(rt_rq);
> +
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static inline void __rt_rq_ss_repl_timer(struct rt_rq *rt_rq)
> +{
> +	struct task_group *tg = rt_rq->tg;
> +	struct sched_sporadic_data *ss = &tg->ss;
> +	ktime_t now = hrtimer_cb_get_time(&ss->repl_timer);
> +
> +	spin_lock(&rt_rq->rt_ss_rq_lock);
> +	while (ss->nr_repl > 0 &&
> +	       ktime_us_delta(ss->repl[ss->first_repl].instant, now) <= 0) {
> +		s64 repl_amount = ss->repl[ss->first_repl].amount;
> +
> +		/*
> +		 * Consume a replenishment event for a task group,
> +		 * unthrottling it if needed.
> +		 */
> +		rt_ss_repl_budget(ss, repl_amount);
> +		ss->first_repl = (ss->first_repl + 1) % SS_REPL_MAX;
> +		ss->nr_repl--;
> +
> +		if (likely(!rt_rq_is_ss_low_prio(rt_rq))) {
> +			rt_ss_set_act_time(ss);
> +			rt_rq->rt_throttled = 0;
> +			sched_rt_rq_enqueue(rt_rq);
> +		}
> +	}
> +	spin_unlock(&rt_rq->rt_ss_rq_lock);
> +}
> +
> +#endif /* CONFIG_RT_GROUP_SCHED */
> +
> +static enum hrtimer_restart rt_ss_repl_timer(struct hrtimer *timer)
> +{
> +	struct sched_sporadic_data *ss;
> +	struct sched_rt_entity *rt_se;
> +	enum hrtimer_restart ret = HRTIMER_NORESTART;
> +
> +	ss = container_of(timer, struct sched_sporadic_data, repl_timer);
> +	rt_se = rt_se_of_ss(ss);
> +	if (rt_se)
> +		__rt_se_ss_repl_timer(rt_se);
> +#ifdef CONFIG_RT_GROUP_SCHED
> +	else {
> +		cpumask_t span = cpu_online_map;
> +		int i;
> +
> +		for_each_cpu_mask(i, span) {
> +			struct task_group *tg;
> +			struct rt_rq *rt_rq;
> +
> +			tg = container_of(ss, struct task_group, ss);
> +			rt_rq = tg->rt_rq[i];
> +			__rt_rq_ss_repl_timer(rt_rq);
> +		}
> +	}

I think you want to use the root domain span here.

Also, since you have a #ifdef above already, why not fold everything
into rt_ss_repl_timer_timer_group() and provide and empty stub in an
#else, that gets rid of this #ifdef.

> +#endif
> +	if (ss->nr_repl > 0) {
> +		timer->expires = ss->repl[ss->first_repl].instant;
> +		ret = HRTIMER_RESTART;
> +	}
> +
> +	return ret;
> +}
> +
> +static inline void rt_ss_init_repl_timer(struct sched_sporadic_data *ss)
> +{
> +	hrtimer_init(&ss->repl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	ss->repl_timer.function = rt_ss_repl_timer;
> +	ss->repl_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
> +}
> +
> +static inline void rt_ss_destroy_repl_timer(struct sched_sporadic_data *ss)
> +{
> +	hrtimer_cancel(&ss->repl_timer);
> +}
> +
> +#endif /* CONFIG_POSIX_SCHED_SPORADIC */
> +
>  /*
>   * Update the current task's runtime statistics. Skip current tasks that
>   * are not in our scheduling class.
> @@ -471,7 +803,6 @@ static void update_curr_rt(struct rq *rq)
>  {
>  	struct task_struct *curr = rq->curr;
>  	struct sched_rt_entity *rt_se = &curr->rt;
> -	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
>  	u64 delta_exec;
>  
>  	if (!task_has_rt_policy(curr))
> @@ -487,9 +818,25 @@ static void update_curr_rt(struct rq *rq)
>  	curr->se.exec_start = rq->clock;
>  	cpuacct_charge(curr, delta_exec);
>  
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	/* Check for the SCHED_SPORADIC rules for the task. */
> +	if (rt_se_ss_budget_exhausted(rt_se, delta_exec))
> +		resched_task(curr);
> +#endif
>  	for_each_sched_rt_entity(rt_se) {
> -		rt_rq = rt_rq_of_se(rt_se);
> +		struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
>  
> +#if defined CONFIG_POSIX_SCHED_SPORADIC && defined CONFIG_RT_GROUP_SCHED
> +		/*
> +		 * Check if in the hierarchy of the current task there
> +		 * is a SCHED_SPORADIC task group which needs to be
> +		 * updated.
> +		 */
> +		spin_lock(&rt_rq->rt_ss_rq_lock);
> +		if (rt_rq_ss_budget_exhausted(rt_rq, delta_exec))
> +			resched_task(curr);
> +		spin_unlock(&rt_rq->rt_ss_rq_lock);
> +#endif

Can we provide these in functions and stubs?

>  		spin_lock(&rt_rq->rt_runtime_lock);
>  		rt_rq->rt_time += delta_exec;
>  		if (sched_rt_runtime_exceeded(rt_rq))
> @@ -551,7 +898,9 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  	if (rt_rq->rt_nr_running) {
>  		struct rt_prio_array *array;
>  
> +#ifndef CONFIG_POSIX_SCHED_SPORADIC
>  		WARN_ON(rt_se_prio(rt_se) < rt_rq->highest_prio);
> +#endif
>  		if (rt_se_prio(rt_se) == rt_rq->highest_prio) {
>  			/* recalculate */
>  			array = &rt_rq->active;
> @@ -641,8 +990,28 @@ static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
>  static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
>  {
>  	dequeue_rt_stack(rt_se);
> -	for_each_sched_rt_entity(rt_se)
> +
> +	for_each_sched_rt_entity(rt_se) {
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +		struct rt_rq *rt_rq = group_rt_rq(rt_se);
> +
> +		if (!rt_rq) {
> +			if (rt_se_is_ss_sched_prio(rt_se))
> +				rt_ss_set_act_time(rt_se->ss);
> +			else if (rt_se_is_ss_low_prio(rt_se))
> +				__ss_switch_prio(rt_task_of(rt_se),
> +						 rt_se->ss->low_priority);
> +#ifdef CONFIG_RT_GROUP_SCHED
> +		} else {
> +			if (rt_rq_is_ss_sched_prio(rt_rq))
> +				rt_ss_set_act_time(&rt_rq->tg->ss);
> +			else if (rt_rq_is_ss_low_prio(rt_rq))
> +					continue;
> +#endif
> +		}
> +#endif

I smell the possibility to reduce ifdeffery by providing some stubs..

>  		__enqueue_rt_entity(rt_se);
> +	}
>  }
>  
>  static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
> @@ -652,8 +1021,14 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
>  	for_each_sched_rt_entity(rt_se) {
>  		struct rt_rq *rt_rq = group_rt_rq(rt_se);
>  
> -		if (rt_rq && rt_rq->rt_nr_running)
> -			__enqueue_rt_entity(rt_se);
> +		if (rt_rq) {
> +			if (rt_rq->rt_nr_running)
> +				__enqueue_rt_entity(rt_se);
> +#if defined CONFIG_POSIX_SCHED_SPORADIC && defined CONFIG_RT_GROUP_SCHED
> +			else if (rt_rq_is_ss_sched_prio(rt_rq))
> +				rt_ss_post_recharge(&rt_rq->tg->ss);
> +#endif

Why the ifdefs, just ensure rt_rq_is_ss_sched_prio() always fails and
provide an empty stub for rt_ss_post_recharge().

> +		}
>  	}
>  }
>  
> @@ -677,6 +1052,11 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
>  	struct sched_rt_entity *rt_se = &p->rt;
>  
>  	update_curr_rt(rq);
> +
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	if (rt_se_is_ss_sched_prio(rt_se))
> +		rt_ss_post_recharge(rt_se->ss);
> +#endif
>  	dequeue_rt_entity(rt_se);
>  
>  	dec_cpu_load(rq, p->se.load.weight);
> @@ -1444,7 +1824,13 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
>  static void set_curr_task_rt(struct rq *rq)
>  {
>  	struct task_struct *p = rq->curr;
> +#ifdef CONFIG_POSIX_SCHED_SPORADIC
> +	struct sched_rt_entity *rt_se = &p->rt;
>  
> +	for_each_sched_rt_entity(rt_se)
> +		if (unlikely(rt_se_is_ss_sched_prio(rt_se)))
> +			rt_ss_set_act_time(rt_se->ss);
> +#endif
>  	p->se.exec_start = rq->clock;
>  }
>  

