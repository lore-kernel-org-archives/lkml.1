Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbXFRQyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbXFRQyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbXFRQye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:54:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59611 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761488AbXFRQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:54:33 -0400
Date: Mon, 18 Jun 2007 22:33:02 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com, Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: [PATCH -cfs] Fix cpu_load calculation error
Message-ID: <20070618170302.GB21037@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070618170114.GA21037@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618170114.GA21037@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CCing right folks this time!

On Mon, Jun 18, 2007 at 10:31:14PM +0530, Srivatsa Vaddagiri wrote:
> Ingo/Dmitry,
> 	I am resending the patch to fix cpu_load calculation error in
> cfs v17, this time CCing lkml.
> 
> Related to load-balance, there is still a lingering thought in my mind. I am 
> not sure though whether it is something we need to worry about atm.
> 
>    Load balance between CPUs is based on gross-weight imbalance between
>    the two i.e weight imbalance of all classes put together on both CPUs.
>    When move_tasks() is invoked to move this 'imbalance' amount of
>    weight, it can potentially end up moving that complete 'imbalance'
>    weight from one class only and not balance other classes?
> 
>    As an example, consider CPU0 and CPU1's initial load to be:
> 
>    (before balance)
>         CPU0_rq->cpu_load = 20480 (5*2048 rt load + 10*1024 normal load)
> 	CPU1_rq->cpu_load = 10240 (5*2048 rt load + 0 normal load)
> 
>    This leads to a load imbalance of 10240. When CPU1 attempts to
>    balance by pulling some 'imbalance' weight (say wt_diff/2 = 5120), it could 
>    potentially pull all this imbalance weight from real-time class alone?
> 
>   (after balance)
>         CPU0_rq->cpu_load = 14336 (2*2048 rt load + 10*1024 normal load)
> 	CPU1_rq->cpu_load = 16384 (8*2048 rt load + 0 normal load)
> 
>    Basically do we need to take into account class imbalance also in
>    sched_rt.c:load_balance()?
> 
>    I have CCed some folks from real-time who may hit us if they think
>    this needs to be fixed (from real-time perspective atleast!).
> 
> 
> 
> v17 cpu_load calculation didn't take into account that a class's
> delta_exec/fair may be stale because it could not get an opportunity to
> run. This can lead to incorrect calculation of a class's load. This
> patch removes load tracking from individual classes and instead
> introduces a global per-cpu load tracking common to all classes in
> kernel/sched.c itself.
> 
> Thanks to Dmitry for suggesting this idea.
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> 
> ---
>  include/linux/sched.h |    2 
>  kernel/sched.c        |  177 +++++++++++++++++++++++++++++++++-----------------
>  kernel/sched_debug.c  |    6 -
>  kernel/sched_fair.c   |   49 +------------
>  kernel/sched_rt.c     |    7 -
>  5 files changed, 126 insertions(+), 115 deletions(-)
> 
> Index: current/kernel/sched.c
> ===================================================================
> --- current.orig/kernel/sched.c	2007-06-15 22:50:33.000000000 +0530
> +++ current/kernel/sched.c	2007-06-15 23:31:22.000000000 +0530
> @@ -116,14 +116,18 @@
>  	struct list_head queue[MAX_RT_PRIO];
>  };
>  
> +struct load_stat {
> +	unsigned long raw_weighted_load;
> +	u64 delta_fair, delta_exec, exec_start, last_update_load;
> +};
> +
>  /* CFS-related fields in a runqueue */
>  struct cfs_rq {
>  	unsigned long raw_weighted_load;
>  	unsigned long nr_running;
>  
> -	u64 fair_clock, delta_fair_clock;
> -	u64 exec_clock, delta_exec_clock;
> -	u64 last_update_load;
> +	u64 fair_clock;
> +	u64 exec_clock;
>  	s64 wait_runtime;
>  	unsigned long wait_runtime_overruns, wait_runtime_underruns;
>  
> @@ -134,9 +138,6 @@
>  
>  /* Real-Time classes' related field in a runqueue: */
>  struct rt_rq {
> -	unsigned long raw_weighted_load;
> -	unsigned long nr_running;
> -
>  	struct prio_array active;
>  	int rt_load_balance_idx;
>  	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
> @@ -159,6 +160,7 @@
>  	long nr_running;
>  	#define CPU_LOAD_IDX_MAX 5
>  	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
> +	struct load_stat ls;	/* capture load from *all* tasks on this cpu */
>  	unsigned char idle_at_tick;
>  #ifdef CONFIG_NO_HZ
>  	unsigned char in_nohz_recently;
> @@ -499,6 +501,9 @@
>  	task_rq_unlock(rq, &flags);
>  }
>  
> +#define NICE_0_LOAD	SCHED_LOAD_SCALE
> +#define NICE_0_SHIFT	SCHED_LOAD_SHIFT
> +
>  /*
>   * resched_task - mark a task 'to be rescheduled now'.
>   *
> @@ -552,6 +557,50 @@
>  }
>  #endif
>  
> +static inline void set_exec_start(struct rq *rq)
> +{
> +	rq->ls.exec_start = __rq_clock(rq);
> +}
> +
> +/* Update delta_exec, delta_fair fields for rq.
> + *
> + *	delta_fair clock advances at a rate inversely proportional to
> + *	total load (rq->ls.raw_weighted_load) on the runqueue, while
> + *	delta_exec advances at the same rate as wall-clock (provided
> + *	cpu is not idle).
> + *
> + *	delta_exec / delta_fair is a measure of the (smoothened) load on this
> + * 	runqueue over any given interval. This (smoothened) load is used
> + * 	during load balance.
> + *
> + *	This function is called /before/ updating rq->ls.raw_weighted_load
> + * 	and when switching tasks.
> + *
> + * 	todo : Remove this for !CONFIG_SMP?
> + */
> +static void update_curr_load(struct rq *rq)
> +{
> +	u64 now = rq_clock(rq);
> +	u64 delta_exec, delta_fair;
> +	struct load_stat *ls = &rq->ls;
> +	unsigned long load = ls->raw_weighted_load;
> +
> +	if (rq->curr == rq->idle || !load)
> +		return;
> +
> +	delta_exec = now - ls->exec_start;
> +	if (unlikely((s64)delta_exec < 0))
> +		delta_exec = 0;
> +
> +	delta_fair = delta_exec * NICE_0_LOAD;
> +	delta_fair += load >> 1; /* rounding */
> +	do_div(delta_fair, load);
> +
> +	ls->delta_fair += delta_fair;
> +	ls->delta_exec += delta_exec;
> +	ls->exec_start = now;
> +}
> +
>  /*
>   * To aid in avoiding the subversion of "niceness" due to uneven distribution
>   * of tasks with abnormal "nice" values across CPUs the contribution that
> @@ -574,9 +623,6 @@
>  #define RTPRIO_TO_LOAD_WEIGHT(rp) \
>  	(PRIO_TO_LOAD_WEIGHT(MAX_RT_PRIO) + LOAD_WEIGHT(rp))
>  
> -#define NICE_0_LOAD	SCHED_LOAD_SCALE
> -#define NICE_0_SHIFT	SCHED_LOAD_SHIFT
> -
>  /*
>   * Nice levels are multiplicative, with a gentle 10% change for every
>   * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
> @@ -595,55 +641,28 @@
>  /*  10 */   110,    87,    70,    56,    45,    36,    29,    23,    18,    15,
>  };
>  
> -static inline unsigned long
> -total_raw_weighted_load(struct rq *rq)
> -{
> -	return rq->rt.raw_weighted_load + rq->cfs.raw_weighted_load;
> -}
> -
>  static inline void
>  inc_raw_weighted_load(struct rq *rq, const struct task_struct *p)
>  {
> -	/*
> -	 * Can be smth like (if we'd benefit from even high abstraction --
> -	 * say we are going to support more sched_classes):
> -	 *
> -	 * p->sched_class->inc_raw_weighted_load(p);
> -	 */
> -
> -	if (has_rt_policy(p))
> -		rq->rt.raw_weighted_load += p->se.load_weight;
> -	else
> -		rq->cfs.raw_weighted_load += p->se.load_weight;
> +	update_curr_load(rq);
> +	rq->ls.raw_weighted_load += p->se.load_weight;
>  }
>  
>  static inline void
>  dec_raw_weighted_load(struct rq *rq, const struct task_struct *p)
>  {
> -	if (has_rt_policy(p))
> -		rq->rt.raw_weighted_load -= p->se.load_weight;
> -	else
> -		rq->cfs.raw_weighted_load -= p->se.load_weight;
> +	update_curr_load(rq);
> +	rq->ls.raw_weighted_load -= p->se.load_weight;
>  }
>  
>  static inline void inc_nr_running(struct task_struct *p, struct rq *rq)
>  {
> -	if (has_rt_policy(p))
> -		rq->rt.nr_running++;
> -	else
> -		rq->cfs.nr_running++;
> -
>  	rq->nr_running++;
>  	inc_raw_weighted_load(rq, p);
>  }
>  
>  static inline void dec_nr_running(struct task_struct *p, struct rq *rq)
>  {
> -	if (has_rt_policy(p))
> -		rq->rt.nr_running--;
> -	else
> -		rq->cfs.nr_running--;
> -
>  	rq->nr_running--;
>  	dec_raw_weighted_load(rq, p);
>  }
> @@ -779,7 +798,7 @@
>  /* Used instead of source_load when we know the type == 0 */
>  unsigned long weighted_cpuload(const int cpu)
>  {
> -	return total_raw_weighted_load(cpu_rq(cpu));
> +	return cpu_rq(cpu)->ls.raw_weighted_load;
>  }
>  
>  #ifdef CONFIG_SMP
> @@ -913,7 +932,7 @@
>  static inline unsigned long source_load(int cpu, int type)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> -	unsigned long total = total_raw_weighted_load(rq);
> +	unsigned long total = weighted_cpuload(cpu);
>  
>  	if (type == 0)
>  		return total;
> @@ -928,7 +947,7 @@
>  static inline unsigned long target_load(int cpu, int type)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> -	unsigned long total = total_raw_weighted_load(rq);
> +	unsigned long total = weighted_cpuload(cpu);
>  
>  	if (type == 0)
>  		return total;
> @@ -942,7 +961,7 @@
>  static inline unsigned long cpu_avg_load_per_task(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> -	unsigned long total = total_raw_weighted_load(rq);
> +	unsigned long total = weighted_cpuload(cpu);
>  	unsigned long n = rq->nr_running;
>  
>  	return n ? total / n : SCHED_LOAD_SCALE;
> @@ -1623,18 +1642,49 @@
>  	return running + uninterruptible;
>  }
>  
> -static void update_load(struct rq *this_rq)
> +/* Update rq->cpu_load[] statistics. This function is usually called every
> + * scheduler tick (TICK_NSEC).
> + */
> +static void update_cpu_load(struct rq *this_rq)
>  {
> -	struct sched_class *class = sched_class_highest;
> -	unsigned long this_load = 0;
> +	unsigned long total_load = this_rq->ls.raw_weighted_load;
>  	int i, scale;
> +	unsigned long this_load =  total_load;
> +	struct load_stat *ls = &this_rq->ls;
> +	u64 fair_delta64, exec_delta64, idle_delta64,
> +		 sample_interval64, tmp64;
> +	u64 now = __rq_clock(this_rq);
>  
>  	this_rq->nr_load_updates++;
> +	if (sysctl_sched_features & 64)
> +		goto do_avg;
>  
> -	do {
> -		this_load += class->update_load(this_rq);
> -		class = class->next;
> -	} while (class);
> +	/* Update delta_fair/delta_exec fields first */
> +	update_curr_load(this_rq);
> +
> +	fair_delta64 = ls->delta_fair + 1;
> +	ls->delta_fair = 0;
> +
> +	exec_delta64 = ls->delta_exec + 1;
> +	ls->delta_exec = 0;
> +
> +	sample_interval64 = now - ls->last_update_load;
> +	ls->last_update_load = now;
> +
> +	if ((s64)sample_interval64 < (s64)TICK_NSEC)
> +		sample_interval64 = TICK_NSEC;
> +
> +	if (exec_delta64 > sample_interval64)
> +		exec_delta64 = sample_interval64;
> +
> +	idle_delta64 = sample_interval64 - exec_delta64;
> +
> +	tmp64 = div64_64(SCHED_LOAD_SCALE * exec_delta64, fair_delta64);
> +	tmp64 = div64_64(tmp64 * exec_delta64, sample_interval64);
> +
> +	this_load = (unsigned long)tmp64;
> +
> +do_avg:
>  
>  	/* Update our load: */
>  	for (i = 0, scale = 1; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
> @@ -2012,7 +2062,7 @@
>  
>  			avg_load += load;
>  			sum_nr_running += rq->nr_running;
> -			sum_weighted_load += total_raw_weighted_load(rq);
> +			sum_weighted_load += weighted_cpuload(i);
>  		}
>  
>  		/*
> @@ -2240,18 +2290,19 @@
>  	int i;
>  
>  	for_each_cpu_mask(i, group->cpumask) {
> +		unsigned long wl;
>  
>  		if (!cpu_isset(i, *cpus))
>  			continue;
>  
>  		rq = cpu_rq(i);
> +		wl = weighted_cpuload(i);
>  
> -		if (rq->nr_running == 1 &&
> -				 total_raw_weighted_load(rq) > imbalance)
> +		if (rq->nr_running == 1 && wl > imbalance)
>  			continue;
>  
> -		if (total_raw_weighted_load(rq) > max_load) {
> -			max_load = total_raw_weighted_load(rq);
> +		if (wl > max_load) {
> +			max_load = wl;
>  			busiest = rq;
>  		}
>  	}
> @@ -2831,14 +2882,17 @@
>  	if (time_after_eq(jiffies, rq->next_balance))
>  		raise_softirq(SCHED_SOFTIRQ);
>  }
> -#else
> +
> +#else	/* CONFIG_SMP */
> +
>  /*
>   * on UP we do not need to balance between CPUs:
>   */
>  static inline void idle_balance(int cpu, struct rq *rq)
>  {
>  }
> -#endif
> +
> +#endif	/* CONFIG_SMP */
>  
>  DEFINE_PER_CPU(struct kernel_stat, kstat);
>  
> @@ -2966,7 +3020,7 @@
>  		p->sched_class->task_tick(rq, p);
>  	spin_unlock(&rq->lock);
>  
> -	update_load(rq);
> +	update_cpu_load(rq);
>  #ifdef CONFIG_SMP
>  	rq->idle_at_tick = idle_at_tick;
>  	trigger_load_balance(cpu);
> @@ -3051,6 +3105,7 @@
>  	u64 now = __rq_clock(rq);
>  	struct task_struct *p;
>  
> +	update_curr_load(rq);
>  	prev->sched_class->put_prev_task(rq, prev, now);
>  
>  	do {
> @@ -3101,6 +3156,7 @@
>  	if (unlikely(!rq->nr_running)) {
>  		idle_balance(cpu, rq);
>  		if (!rq->nr_running) {
> +			update_curr_load(rq);
>  			prev->sched_class->put_prev_task(rq, prev,
>  							 __rq_clock(rq));
>  			next = rq->idle;
> @@ -3110,6 +3166,7 @@
>  	}
>  
>  	next = pick_next_task(rq, prev);
> +	set_exec_start(rq);
>  	next->se.nr_switches++;
>  
>  switch_tasks:
> @@ -6132,7 +6189,7 @@
>  		rq->nr_running = 0;
>  		rq->cfs.tasks_timeline = RB_ROOT;
>  		rq->clock = rq->cfs.fair_clock = 1;
> -		rq->cfs.last_update_load = sched_clock();
> +		rq->ls.last_update_load = sched_clock();
>  
>  		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
>  			rq->cpu_load[j] = 0;
> Index: current/include/linux/sched.h
> ===================================================================
> --- current.orig/include/linux/sched.h	2007-06-15 22:50:33.000000000 +0530
> +++ current/include/linux/sched.h	2007-06-15 22:50:49.000000000 +0530
> @@ -869,8 +869,6 @@
>  	struct task_struct * (*load_balance_next) (struct rq *rq);
>  	void (*task_tick) (struct rq *rq, struct task_struct *p);
>  	void (*task_new) (struct rq *rq, struct task_struct *p);
> -
> -	unsigned long (*update_load) (struct rq *rq);
>  };
>  
>  /* CFS stats for a schedulable entity (task, task-group etc) */
> Index: current/kernel/sched_fair.c
> ===================================================================
> --- current.orig/kernel/sched_fair.c	2007-06-15 22:50:33.000000000 +0530
> +++ current/kernel/sched_fair.c	2007-06-15 22:50:49.000000000 +0530
> @@ -119,6 +119,9 @@
>  
>  	rb_link_node(&se->run_node, parent, link);
>  	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
> +	cfs_rq->raw_weighted_load += se->load_weight;
> +	cfs_rq->nr_running++;
> +	se->on_rq = 1;
>  }
>  
>  static inline void
> @@ -127,6 +130,9 @@
>  	if (cfs_rq->rb_leftmost == &se->run_node)
>  		cfs_rq->rb_leftmost = NULL;
>  	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
> +	cfs_rq->raw_weighted_load -= se->load_weight;
> +	cfs_rq->nr_running--;
> +	se->on_rq = 0;
>  }
>  
>  static inline struct rb_node * first_fair(struct cfs_rq *cfs_rq)
> @@ -249,10 +255,6 @@
>  	delta_fair += load >> 1; /* rounding */
>  	do_div(delta_fair, load);
>  
> -	/* Load-balancing accounting. */
> -	cfs_rq->delta_fair_clock += delta_fair;
> -	cfs_rq->delta_exec_clock += delta_exec;
> -
>  	/*
>  	 * Task already marked for preemption, do not burden
>  	 * it with the cost of not having left the CPU yet:
> @@ -829,44 +831,6 @@
>  	inc_nr_running(p, rq);
>  }
>  
> -static unsigned long update_load_cfs_rq(struct cfs_rq *cfs_rq)
> -{
> -	u64 fair_delta64, exec_delta64, idle_delta64,
> -	    sample_interval64, now, tmp64;
> -
> -	if (sysctl_sched_features & 64)
> -		return cfs_rq->raw_weighted_load;
> -
> -	fair_delta64 = cfs_rq->delta_fair_clock + 1;
> -	cfs_rq->delta_fair_clock = 0;
> -
> -	exec_delta64 = cfs_rq->delta_exec_clock + 1;
> -	cfs_rq->delta_exec_clock = 0;
> -
> -	now = rq_clock(rq_of(cfs_rq));
> -	sample_interval64 = now - cfs_rq->last_update_load;
> -	cfs_rq->last_update_load = now;
> -
> -	if ((s64)sample_interval64 < (s64)TICK_NSEC)
> -		sample_interval64 = TICK_NSEC;
> -
> -	if (exec_delta64 > sample_interval64)
> -		exec_delta64 = sample_interval64;
> -
> -	idle_delta64 = sample_interval64 - exec_delta64;
> -
> -	tmp64 = div64_64(SCHED_LOAD_SCALE * exec_delta64, fair_delta64);
> -	tmp64 = div64_64(tmp64 * exec_delta64, sample_interval64);
> -
> -	return (unsigned long)tmp64;
> -}
> -
> -
> -static unsigned long update_load_fair(struct rq *rq)
> -{
> -	return update_load_cfs_rq(&rq->cfs);
> -}
> -
>  /*
>   * All the scheduling class methods:
>   */
> @@ -882,7 +846,6 @@
>  
>  	.load_balance_start	= load_balance_start_fair,
>  	.load_balance_next	= load_balance_next_fair,
> -	.update_load		= update_load_fair,
>  	.task_tick		= task_tick_fair,
>  	.task_new		= task_new_fair,
>  };
> Index: current/kernel/sched_rt.c
> ===================================================================
> --- current.orig/kernel/sched_rt.c	2007-06-15 22:50:33.000000000 +0530
> +++ current/kernel/sched_rt.c	2007-06-15 22:50:49.000000000 +0530
> @@ -194,12 +194,6 @@
>  	activate_task(rq, p, 1);
>  }
>  
> -static unsigned long update_load_rt(struct rq *rq)
> -{
> -	/* Temporal approach. */
> -	return rq->rt.raw_weighted_load;
> -}
> -
>  static struct sched_class rt_sched_class __read_mostly = {
>  	.enqueue_task		= enqueue_task_rt,
>  	.dequeue_task		= dequeue_task_rt,
> @@ -212,7 +206,6 @@
>  
>  	.load_balance_start	= load_balance_start_rt,
>  	.load_balance_next	= load_balance_next_rt,
> -	.update_load		= update_load_rt,
>  
>  	.task_tick		= task_tick_rt,
>  	.task_new		= task_new_rt,
> Index: current/kernel/sched_debug.c
> ===================================================================
> --- current.orig/kernel/sched_debug.c	2007-06-15 22:54:26.000000000 +0530
> +++ current/kernel/sched_debug.c	2007-06-15 23:03:04.000000000 +0530
> @@ -112,7 +112,9 @@
>  	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x))
>  
>  	P(nr_running);
> -	SEQ_printf(m, "  .%-30s: %lu\n", "raw_weighted_load", total_raw_weighted_load(rq));
> +	SEQ_printf(m, "  .%-30s: %lu\n", "raw_weighted_load", rq->ls.raw_weighted_load);
> +	P(ls.delta_fair);
> +	P(ls.delta_exec);
>  	P(nr_switches);
>  	P(nr_load_updates);
>  	P(nr_uninterruptible);
> @@ -126,9 +128,7 @@
>  	P(clock_unstable_events);
>  	P(clock_max_delta);
>  	P(cfs.fair_clock);
> -	P(cfs.delta_fair_clock);
>  	P(cfs.exec_clock);
> -	P(cfs.delta_exec_clock);
>  	P(cfs.wait_runtime);
>  	P(cfs.wait_runtime_overruns);
>  	P(cfs.wait_runtime_underruns);
> 
> 
> -- 
> Regards,
> vatsa

-- 
Regards,
vatsa
