Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZGXQQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZGXQQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZGXQQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:16:38 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:47994 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbZGXQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:16:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIFACN3aUpMQWXi/2dsb2JhbACBUdNggiqBYwU
Date: Fri, 24 Jul 2009 12:16:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH RFC -tip 4/4] Merge preemptable-RCU functionality into
	hierarchical RCU
Message-ID: <20090724161618.GC2419@Krystal>
References: <20090724001429.GA17374@linux.vnet.ibm.com> <20090724002758.GD18282@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090724002758.GD18282@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:24:31 up 146 days, 11:50,  3 users,  load average: 0.29, 0.37,
	0.37
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Create a kernel/rcutree_plugin.h file that contains definitions
> for preemptable RCU (or, under #else, empty definitions).  These
> definitions fit into plugins defined in kernel/rcutree.c for this
> purpose.
> 
> This variant of preemptable RCU uses a new algorithm whose read-side
> expense is roughly that of classic hierarchical RCU under CONFIG_PREEMPT.
> This new algorithm's update-side expense is similar to that of classic
> hierarchical RCU, and, in absence of read-side preemption or blocking,
> is exactly that of classic hierarchical RCU.  Perhaps more important,
> this new algorithm has a much simpler implementation, saving well over
> 1,000 lines of code compared to mainline's implementation of preemptable
> RCU, which will hopefully be retired in favor of this new algorithm.
> 
> The simplifications are obtained by maintaining per-task nesting state
> for running tasks,

That sounds familiar to me ;)

> and using a simple lock-protected algorithm to handle
> accounting when tasks block within RCU read-side critical sections,

Seems like this is derived from the tree RCU implementation,

> making use of lessons learned while creating numerous user-level RCU
> algorithms over the past 18 months.
> 
> Shortcomings:
> 
> o	Very lightly tested, probably quite buggy.
> 
> o	Probably does not even compile for all of the relevant
> 	combinations of kernel configuration variables.
> 
> o	Lacks RCU priority boosting.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  include/linux/init_task.h  |   15 +
>  include/linux/rcupdate.h   |    2 
>  include/linux/rcupreempt.h |    4 
>  include/linux/rcutree.h    |   16 +
>  include/linux/sched.h      |   13 +
>  init/Kconfig               |   22 +-
>  kernel/Makefile            |    1 
>  kernel/exit.c              |    1 
>  kernel/fork.c              |    6 
>  kernel/rcutree.c           |  111 ++++++++----
>  kernel/rcutree.h           |    4 
>  kernel/rcutree_plugin.h    |  414 +++++++++++++++++++++++++++++++++++++++++++++
>  12 files changed, 566 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 5368fbd..3fd4541 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -94,6 +94,20 @@ extern struct group_info init_groups;
>  # define CAP_INIT_BSET  CAP_INIT_EFF_SET
>  #endif
>  
> +#ifdef CONFIG_PREEMPT_RCU
> +#define INIT_TASK_RCU_PREEMPT(tsk)					\
> +	.rcu_read_lock_nesting = 0,					\
> +	.rcu_flipctr_idx = 0,
> +#elif defined(CONFIG_TREE_PREEMPT_RCU)
> +#define INIT_TASK_RCU_PREEMPT(tsk)					\
> +	.rcu_read_lock_nesting = 0,					\
> +	.rcu_read_unlock_special = 0,					\
> +	.rcu_blocked_cpu = -1,						\
> +	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),
> +#else
> +#define INIT_TASK_RCU_PREEMPT(tsk)
> +#endif
> +
>  extern struct cred init_cred;
>  
>  #ifdef CONFIG_PERF_COUNTERS
> @@ -173,6 +187,7 @@ extern struct cred init_cred;
>  	INIT_LOCKDEP							\
>  	INIT_FTRACE_GRAPH						\
>  	INIT_TRACE_RECURSION						\
> +	INIT_TASK_RCU_PREEMPT(tsk)					\
>  }
>  
>  
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 9d85ee1..26892f5 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -66,7 +66,7 @@ extern void rcu_scheduler_starting(void);
>  extern int rcu_needs_cpu(int cpu);
>  extern int rcu_scheduler_active;
>  
> -#if defined(CONFIG_TREE_RCU)
> +#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
>  #include <linux/rcutree.h>
>  #elif defined(CONFIG_PREEMPT_RCU)
>  #include <linux/rcupreempt.h>
> diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> index 6c9dd9c..86f05c5 100644
> --- a/include/linux/rcupreempt.h
> +++ b/include/linux/rcupreempt.h
> @@ -99,6 +99,10 @@ static inline long rcu_batches_completed_bh(void)
>  	return rcu_batches_completed();
>  }
>  
> +static inline void exit_rcu(void)
> +{
> +}
> +
>  #ifdef CONFIG_RCU_TRACE
>  struct rcupreempt_trace;
>  extern long *rcupreempt_flipctr(int cpu);
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 8a0222c..bf3fc97 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -36,14 +36,30 @@ extern void rcu_bh_qs(int cpu);
>  extern int rcu_pending(int cpu);
>  extern int rcu_needs_cpu(int cpu);
>  
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +
> +extern void __rcu_read_lock(void);
> +extern void __rcu_read_unlock(void);
> +extern void exit_rcu(void);
> +
> +#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +
>  static inline void __rcu_read_lock(void)
>  {
>  	preempt_disable();
>  }
> +
>  static inline void __rcu_read_unlock(void)
>  {
>  	preempt_enable();
>  }
> +
> +static inline void exit_rcu(void)
> +{
> +}
> +
> +#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> +
>  static inline void __rcu_read_lock_bh(void)
>  {
>  	local_bh_disable();
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4d07542..e5852d6 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1189,6 +1189,13 @@ struct task_struct {
>  	int rcu_flipctr_idx;
>  #endif /* #ifdef CONFIG_PREEMPT_RCU */
>  
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +	int rcu_read_lock_nesting;
> +	char rcu_read_unlock_special;

This char should probably be placed along with other char because this
layout wastes space due to padding.

> +	int rcu_blocked_cpu;
> +	struct list_head rcu_node_entry;
> +#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	struct sched_info sched_info;
>  #endif
> @@ -1701,6 +1708,12 @@ extern cputime_t task_gtime(struct task_struct *p);
>  #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
>  #define used_math() tsk_used_math(current)
>  
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +#define RCU_READ_UNLOCK_BLOCKED  1

Expressing bitmasks seems clearer with:

(1 << 0)

> +#define RCU_READ_UNLOCK_NEED_GEN 2

(1 << 1)

> +#define RCU_READ_UNLOCK_GOT_GEN  4

(1 << 2)

> +#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +
>  #ifdef CONFIG_SMP
>  extern int set_cpus_allowed_ptr(struct task_struct *p,
>  				const struct cpumask *new_mask);
> diff --git a/init/Kconfig b/init/Kconfig
> index d10f31d..aac024f 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -335,11 +335,20 @@ config PREEMPT_RCU
>  	  now-naive assumptions about each RCU read-side critical section
>  	  remaining on a given CPU through its execution.
>  
> +config TREE_PREEMPT_RCU
> +	bool "Preemptable tree-based hierarchical RCU"
> +	depends on PREEMPT
> +	help
> +	  This option selects theRCU implementation that is

the RCU

> +	  designed for very large SMP systems with hundreds or
> +	  thousands of CPUs, but for which real-time response
> +	  is also required.
> +
>  endchoice
>  
>  config RCU_TRACE
>  	bool "Enable tracing for RCU"
> -	depends on TREE_RCU || PREEMPT_RCU
> +	depends on TREE_RCU || PREEMPT_RCU || TREE_PREEMPT_RCU
>  	help
>  	  This option provides tracing in RCU which presents stats
>  	  in debugfs for debugging RCU implementation.
> @@ -351,7 +360,7 @@ config RCU_FANOUT
>  	int "Tree-based hierarchical RCU fanout value"
>  	range 2 64 if 64BIT
>  	range 2 32 if !64BIT
> -	depends on TREE_RCU
> +	depends on TREE_RCU || TREE_PREEMPT_RCU
>  	default 64 if 64BIT
>  	default 32 if !64BIT
>  	help
> @@ -366,7 +375,7 @@ config RCU_FANOUT
>  
>  config RCU_FANOUT_EXACT
>  	bool "Disable tree-based hierarchical RCU auto-balancing"
> -	depends on TREE_RCU
> +	depends on TREE_RCU || TREE_PREEMPT_RCU
>  	default n
>  	help
>  	  This option forces use of the exact RCU_FANOUT value specified,
> @@ -379,11 +388,12 @@ config RCU_FANOUT_EXACT
>  	  Say N if unsure.
>  
>  config TREE_RCU_TRACE
> -	def_bool RCU_TRACE && TREE_RCU
> +	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
>  	select DEBUG_FS
>  	help
> -	  This option provides tracing for the TREE_RCU implementation,
> -	  permitting Makefile to trivially select kernel/rcutree_trace.c.
> +	  This option provides tracing for the TREE_RCU and
> +	  TREE_PREEMPT_RCU implementations, permitting Makefile to
> +	  trivially select kernel/rcutree_trace.c.
>  
>  config PREEMPT_RCU_TRACE
>  	def_bool RCU_TRACE && PREEMPT_RCU
> diff --git a/kernel/Makefile b/kernel/Makefile
> index d6042bc..ce8bfcd 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -81,6 +81,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>  obj-$(CONFIG_SECCOMP) += seccomp.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
>  obj-$(CONFIG_TREE_RCU) += rcutree.o
> +obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
>  obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
>  obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
>  obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 628d41f..e440ea0 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1011,6 +1011,7 @@ NORET_TYPE void do_exit(long code)
>  		__free_pipe_info(tsk->splice_pipe);
>  
>  	preempt_disable();
> +	exit_rcu();
>  	/* causes final put_task_struct in finish_task_switch(). */
>  	tsk->state = TASK_DEAD;
>  	schedule();
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 467746b..41d3175 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1026,6 +1026,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	p->rcu_read_lock_nesting = 0;
>  	p->rcu_flipctr_idx = 0;
>  #endif /* #ifdef CONFIG_PREEMPT_RCU */
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +	p->rcu_read_lock_nesting = 0;
> +	p->rcu_read_unlock_special = 0;
> +	p->rcu_blocked_cpu = -1;
> +	INIT_LIST_HEAD(&p->rcu_node_entry);
> +#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */

Hrm, ifdefs within copy_process. That would need to be cleaned up by
calling #ifdefed static inlines, possibly declared in headers.

>  	p->vfork_done = NULL;
>  	spin_lock_init(&p->alloc_lock);
>  
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 47817f7..b2a94c1 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -80,6 +80,21 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
>  struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
>  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
>  
> +extern long rcu_batches_completed_sched(void);
> +static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
> +			  struct rcu_node *rnp, unsigned long flags);
> +static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
> +static void __rcu_process_callbacks(struct rcu_state *rsp,
> +				    struct rcu_data *rdp);
> +static void __call_rcu(struct rcu_head *head,
> +		       void (*func)(struct rcu_head *rcu),
> +		       struct rcu_state *rsp);
> +static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp);
> +static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
> +					   int preemptable);
> +
> +#include "rcutree_plugin.h"
> +
>  /*
>   * Note a quiescent state.  Because we do not need to know
>   * how many quiescent states passed, just if there was at least
> @@ -90,6 +105,7 @@ void rcu_sched_qs(int cpu)
>  	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
>  	rdp->passed_quiesc = 1;
>  	rdp->passed_quiesc_completed = rdp->completed;
> +	rcu_preempt_qs(cpu);
>  }
>  
>  void rcu_bh_qs(int cpu)
> @@ -122,16 +138,6 @@ long rcu_batches_completed_sched(void)
>  EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
>  
>  /*
> - * Return the number of RCU batches processed thus far for debug & stats.
> - * @@@ placeholder, maps to rcu_batches_completed_sched().
> - */
> -long rcu_batches_completed(void)
> -{
> -	return rcu_batches_completed_sched();
> -}
> -EXPORT_SYMBOL_GPL(rcu_batches_completed);
> -
> -/*
>   * Return the number of RCU BH batches processed thus far for debug & stats.
>   */
>  long rcu_batches_completed_bh(void)
> @@ -192,6 +198,10 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
>  		return 1;
>  	}
>  
> +	/* If preemptable RCU, no point in sending reschedule IPI. */
> +	if (rdp->preemptable)
> +		return 0;
> +
>  	/* The CPU is online, so send it a reschedule IPI. */
>  	if (rdp->cpu != smp_processor_id())
>  		smp_send_reschedule(rdp->cpu);
> @@ -472,6 +482,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  
>  	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
>  	for (; rnp_cur < rnp_end; rnp_cur++) {
> +		rcu_print_task_stall(rnp);
>  		if (rnp_cur->qsmask == 0)
>  			continue;
>  		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
> @@ -685,6 +696,18 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
>  }
>  
>  /*
> + * Clean up after the prior grace period and let rcu_start_gp() start up
> + * the next grace period if one is needed.  Note that the caller must
> + * hold rnp->lock, as required by rcu_start_gp(), which will release it.
> + */
> +static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
> +{
> +	rsp->completed = rsp->gpnum;
> +	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
> +	rcu_start_gp(rsp, flags);  /* releases rnp->lock. */

Is locking here required to be taken in one function and released in
another ? Is there another simpler way around ?

> +}
> +
> +/*
>   * Similar to cpu_quiet(), for which it is a helper function.  Allows
>   * a group of CPUs to be quieted at one go, though all the CPUs in the
>   * group must be represented by the same leaf rcu_node structure.
> @@ -725,14 +748,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
>  
>  	/*
>  	 * Get here if we are the last CPU to pass through a quiescent
> -	 * state for this grace period.  Clean up and let rcu_start_gp()
> -	 * start up the next grace period if one is needed.  Note that
> -	 * we still hold rnp->lock, as required by rcu_start_gp(), which
> -	 * will release it.
> +	 * state for this grace period.  Invoke cpu_quiet_msk_root()
> +	 * to clean up and start the next grace period if one is needed.
>  	 */
> -	rsp->completed = rsp->gpnum;
> -	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
> -	rcu_start_gp(rsp, flags);  /* releases rnp->lock. */
> +	cpu_quiet_msk_finish(rsp, flags); /* releases rnp->lock. */

Question about locking:

If we make sure that no more than 32 (or 64) CPUs are sharing the upper
level bitmask in the tree (I think this respectively translates as a 32
or 64 fan-out), could we use a simple atomic_add_return to set the bit
and check the mask without any spinlock contention between siblings ?


>  }
>  
>  /*
> @@ -1004,6 +1023,7 @@ void rcu_check_callbacks(int cpu, int user)
>  
>  		rcu_bh_qs(cpu);
>  	}
> +	rcu_preempt_check_callbacks(cpu);
>  	raise_softirq(RCU_SOFTIRQ);
>  }
>  
> @@ -1183,6 +1203,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>  	__rcu_process_callbacks(&rcu_sched_state,
>  				&__get_cpu_var(rcu_sched_data));
>  	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
> +	rcu_preempt_process_callbacks();
>  
>  	/*
>  	 * Memory references from any later RCU read-side critical sections
> @@ -1247,17 +1268,6 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  EXPORT_SYMBOL_GPL(call_rcu_sched);
>  
>  /*
> - * @@@ Queue an RCU callback for invocation after a grace period.
> - * @@@ Placeholder pending rcutree_plugin.h.
> - */
> -void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> -{
> -	call_rcu_sched(head, func);
> -}
> -EXPORT_SYMBOL_GPL(call_rcu);
> -
> -
> -/*
>   * Queue an RCU for invocation after a quicker grace period.
>   */
>  void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> @@ -1330,7 +1340,8 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
>  int rcu_pending(int cpu)
>  {
>  	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
> -	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
> +	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
> +	       rcu_preempt_pending(cpu);
>  }
>  
>  /*
> @@ -1343,7 +1354,8 @@ int rcu_needs_cpu(int cpu)
>  {
>  	/* RCU callbacks either ready or pending? */
>  	return per_cpu(rcu_sched_data, cpu).nxtlist ||
> -	       per_cpu(rcu_bh_data, cpu).nxtlist;
> +	       per_cpu(rcu_bh_data, cpu).nxtlist ||
> +	       rcu_preempt_needs_cpu(cpu);
>  }
>  
>  /*
> @@ -1359,7 +1371,7 @@ int rcu_needs_cpu(int cpu)
>   * callbacks in flight yet.
>   */
>  static void __cpuinit
> -rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
> +rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
>  {
>  	unsigned long flags;
>  	int i;
> @@ -1376,6 +1388,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
>  	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
>  	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
>  	rdp->beenonline = 1;	 /* We have now been online. */
> +	rdp->preemptable = preemptable;

Hrm, I thought that this "preemptable" flag would be dynamically set to
1 when entering a preemptable/tree preempt RCU read-side C.S., but left
to 0 otherwiwse so the C.S. is considered as rcu sched, but it does not
seemed to be touched by this patch. So either I should look elsewhere,
or I am missing something.

Or maybe this flag is just simply not needed, and could go away ?

>  	rdp->passed_quiesc_completed = lastcomp - 1;
>  	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
>  	rdp->nxtlist = NULL;
> @@ -1427,8 +1440,9 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
>  
>  static void __cpuinit rcu_online_cpu(int cpu)
>  {
> -	rcu_init_percpu_data(cpu, &rcu_sched_state);
> -	rcu_init_percpu_data(cpu, &rcu_bh_state);
> +	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
> +	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
> +	rcu_preempt_init_percpu_data(cpu);
>  }
>  
>  /*
> @@ -1507,6 +1521,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
>  		rnp = rsp->level[i];
>  		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
>  			spin_lock_init(&rnp->lock);
> +			rnp->gpnum = 0;
>  			rnp->qsmask = 0;
>  			rnp->qsmaskinit = 0;
>  			rnp->grplo = j * cpustride;
> @@ -1524,13 +1539,16 @@ static void __init rcu_init_one(struct rcu_state *rsp)
>  					      j / rsp->levelspread[i - 1];
>  			}
>  			rnp->level = i;
> +			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
> +			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
>  		}
>  	}
>  }
>  
>  /*
> - * Helper macro for __rcu_init().  To be used nowhere else!
> - * Assigns leaf node pointers into each CPU's rcu_data structure.
> + * Helper macro for __rcu_init() and __rcu_init_preempt().  To be used
> + * nowhere else!  Assigns leaf node pointers into each CPU's rcu_data
> + * structure.
>   */
>  #define RCU_DATA_PTR_INIT(rsp, rcu_data) \
>  do { \
> @@ -1544,13 +1562,33 @@ do { \
>  	} \
>  } while (0)
>  
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +
> +void __init __rcu_init_preempt(void)
> +{
> +	int i;			/* All used by RCU_DATA_PTR_INIT(). */
> +	int j;
> +	struct rcu_node *rnp;
> +
> +	rcu_init_one(&rcu_preempt_state);
> +	RCU_DATA_PTR_INIT(&rcu_preempt_state, rcu_preempt_data);
> +}
> +
> +#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +
> +void __init __rcu_init_preempt(void)
> +{
> +}
> +
> +#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> +
>  void __init __rcu_init(void)
>  {
>  	int i;			/* All used by RCU_DATA_PTR_INIT(). */
>  	int j;
>  	struct rcu_node *rnp;
>  
> -	printk(KERN_INFO "Hierarchical RCU implementation.\n");
> +	rcu_bootup_announce();
>  #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
>  	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
>  #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> @@ -1558,6 +1596,7 @@ void __init __rcu_init(void)
>  	RCU_DATA_PTR_INIT(&rcu_sched_state, rcu_sched_data);
>  	rcu_init_one(&rcu_bh_state);
>  	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
> +	__rcu_init_preempt();
>  
>  	/*
>  	 * We don't need protection against CPU-hotplug here because
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 0024e5d..02587fd 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -80,6 +80,7 @@ struct rcu_dynticks {
>   */
>  struct rcu_node {
>  	spinlock_t lock;
> +	long	gpnum;		/* Current grace period for this node. */
>  	unsigned long qsmask;	/* CPUs or groups that need to switch in */
>  				/*  order for current grace period to proceed.*/
>  	unsigned long qsmaskinit;
> @@ -90,6 +91,8 @@ struct rcu_node {
>  	u8	grpnum;		/* CPU/group number for next level up. */
>  	u8	level;		/* root is at level 0. */
>  	struct rcu_node *parent;
> +	struct list_head blocked_tasks[2];
> +				/* Tasks blocked in RCU read-side critsect. */

Hrm, this is per-cpu ? Assigning a list of blocked tasks to a
CPU-specific data structure seems a bit odd, how does it deal with
task migration ?


>  } ____cacheline_internodealigned_in_smp;
>  
>  /* Index values for nxttail array in struct rcu_data. */
> @@ -111,6 +114,7 @@ struct rcu_data {
>  	bool		passed_quiesc;	/* User-mode/idle loop etc. */
>  	bool		qs_pending;	/* Core waits for quiesc state. */
>  	bool		beenonline;	/* CPU online at least once. */
> +	bool		preemptable;	/* Preemptable RCU? */
>  	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
>  	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
>  
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> new file mode 100644
> index 0000000..3f453ad
> --- /dev/null
> +++ b/kernel/rcutree_plugin.h
> @@ -0,0 +1,414 @@
> +/*
> + * Read-Copy Update mechanism for mutual exclusion (tree-based version)
> + * Internal non-public definitions that provide either classic
> + * or preemptable semantics.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright Red Hat, 2009
> + * Copyright IBM Corporation, 2009
> + *
> + * Author: Ingo Molnar <mingo@elte.hu>
> + *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> + */
> +
> +
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +
> +struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
> +DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
> +
> +/*
> + * Tell them what RCU they are running.
> + */
> +static inline void rcu_bootup_announce(void)
> +{
> +	printk(KERN_INFO
> +	       "Experimental preemptable hierarchical RCU implementation.\n");
> +}
> +
> +/*
> + * Return the number of RCU-preempt batches processed thus far
> + * for debug and statistics.
> + */
> +long rcu_batches_completed_preempt(void)
> +{
> +	return rcu_preempt_state.completed;
> +}
> +EXPORT_SYMBOL_GPL(rcu_batches_completed_preempt);
> +
> +/*
> + * Return the number of RCU batches processed thus far for debug & stats.
> + */
> +long rcu_batches_completed(void)
> +{
> +	return rcu_batches_completed_preempt();
> +}
> +EXPORT_SYMBOL_GPL(rcu_batches_completed);
> +
> +/*
> + * Record a preemptable-RCU quiescent state for the specified CPU.  Note
> + * that this just means that the task currently running on the CPU is
> + * not in a quiescent state.  There might be any number of tasks blocked
> + * while in an RCU read-side critical section.
> + */
> +static void rcu_preempt_qs_record(int cpu)
> +{
> +	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
> +	rdp->passed_quiesc = 1;
> +	rdp->passed_quiesc_completed = rdp->completed;
> +}
> +
> +/*
> + * We have entered the scheduler or are between softirqs in ksoftirqd.
> + * If we are in an RCU read-side critical section, we need to reflect
> + * that in the state of the rcu_node structure corresponding to this CPU.
> + * Caller must disable hardirqs.
> + */
> +static void rcu_preempt_qs(int cpu)
> +{
> +	struct task_struct *t = current;
> +	int phase;
> +	struct rcu_data *rdp;
> +	struct rcu_node *rnp;
> +
> +	if (t->rcu_read_lock_nesting &&
> +	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
> +
> +		/* Possibly blocking in an RCU read-side critical section. */
> +		rdp = rcu_preempt_state.rda[cpu];
> +		rnp = rdp->mynode;
> +		spin_lock(&rnp->lock);
> +		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;

Is it just me or the "special" name sounds a little too generic ?

Maybe something closer to rcu_read_preempt_mask ?

> +		t->rcu_blocked_cpu = cpu;
> +
> +		/*
> +		 * If this CPU has already checked in, then this task
> +		 * will hold up the next grace period rather than the
> +		 * current grace period.  Queue the task accordingly.
> +		 */
> +		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);

Hrm, maybe I'm just too lazy to try to find out about ! vs ^ precedence,
but would it hurt to add a pair of parenthesis here ?

> +		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
> +		smp_mb();  /* Ensure later ctxt swtch seen after above. */
> +
> +		/* If the RCU core is waiting for this CPU, tell them done. */
> +		if (t->rcu_read_unlock_special & RCU_READ_UNLOCK_NEED_GEN) {
> +			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_GEN;
> +			t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_GEN;
> +		}
> +		spin_unlock(&rnp->lock);
> +	}
> +
> +	/*
> +	 * Either we were not in an RCU read-side critical section to
> +	 * begin with, or we have now recorded that critical section
> +	 * globally.  Either way, we can now note a quiescent state
> +	 * for this CPU.
> +	 */
> +	rcu_preempt_qs_record(cpu);
> +}
> +
> +/*
> + * Tree-preemptable RCU implementtaion for rcu_read_lock().

implementation

> + * Just increment ->rcu_read_lock_nesting, shared state will be updated
> + * if we block.
> + */
> +void __rcu_read_lock(void)
> +{
> +	ACCESS_ONCE(current->rcu_read_lock_nesting)++;
> +	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */

Correct me if I am wrong, but as far as I understand, it seems like you
are poking the remote processors twice per Q.S.. Once to tell all of
them that the Q.S. begins, and the second one to wait for all of them
to pass through a Q.S.. Does the first pass imply touching all per-cpu
variables or is it a single global bit ?


> +}
> +EXPORT_SYMBOL_GPL(__rcu_read_lock);
> +
> +static void rcu_read_unlock_special(struct task_struct *t)
> +{
> +	int empty;
> +	unsigned long flags;
> +	struct rcu_node *rnp;
> +	int special;
> +
> +	/* NMI handlers cannot block and cannot safely manipulate state. */
> +	if (in_nmi())
> +		return;
> +
> +	local_irq_save(flags);
> +
> +	/*
> +	 * If RCU core is waiting for this CPU to exit critical section,
> +	 * let it know that we have done so.
> +	 */
> +	special = t->rcu_read_unlock_special;
> +	if (special & RCU_READ_UNLOCK_NEED_GEN) {
> +		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_GEN;
> +		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_GEN;

Hrm, why are you clearing the blocking bits upon rcu read exit rather
than when you are scheduled back ? How does this work if you are
preempted more than once per critical section ?

> +	}
> +
> +	/* Hardware IRQ handlers cannot block. */
> +	if (in_irq()) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	/* Clean up if blocked during RCU read-side critical section. */
> +	if (special & RCU_READ_UNLOCK_BLOCKED) {
> +
> +		/* Remove this task from the list it blocked on. */
> +		rnp = rcu_preempt_state.rda[t->rcu_blocked_cpu]->mynode;
> +		spin_lock(&rnp->lock);
> +		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
> +		list_del_init(&t->rcu_node_entry);
> +		t->rcu_blocked_cpu = -1;
> +
> +		/*
> +		 * If this was the last task on the current list, and if
> +		 * we aren't waiting on any CPUs, report the quiescent state.
> +		 * Note that both cpu_quiet_msk_finish() and cpu_quiet_msk()
> +		 * drop rnp->lock and restore irq.
> +		 */
> +		if (!empty && rnp->qsmask == 0 &&
> +		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
> +			if (rnp->parent == NULL) {
> +				/* Only one rcu_node in the tree. */
> +				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
> +				return;
> +			}
> +			/* Report up the rest of the hierarchy. */
> +			cpu_quiet_msk(rnp->grpmask, &rcu_preempt_state,
> +				      rnp->parent, flags);
> +			return;
> +		}
> +		spin_unlock(&rnp->lock);
> +		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> +	}
> +	local_irq_restore(flags);
> +}
> +
> +/*
> + * Tree-preemptable RCU implementation for rcu_read_unlock().
> + * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
> + * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
> + * invoke rcu_read_unlock_special() to clean up after a context switch
> + * in an RCU read-side critical section and other special cases.
> + */
> +void __rcu_read_unlock(void)
> +{
> +	struct task_struct *t = current;
> +
> +	barrier();  /* needed if we ever invoke rcu_unread_lock in rcutree.c */

rcu_unread_lock -> rcu_read_unlock

> +	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
> +	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))


if (likely(--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0) &&
   unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))

(assuming non-nesting as common case)

> +	    	rcu_read_unlock_special(t);
> +}
> +EXPORT_SYMBOL_GPL(__rcu_read_unlock);
> +
> +#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> +
> +/*
> + * Scan the current list of tasks blocked within RCU read-side critical
> + * sections, printing out the tid of each.
> + */
> +static void rcu_print_task_stall(struct rcu_node *rnp)
> +{
> +	unsigned long flags;
> +	struct list_head *lp;
> +	int phase = rnp->gpnum & 0x1;
> +	struct task_struct *t;
> +
> +	if (!list_empty(&rnp->blocked_tasks[phase])) {

Is using list_empty outside of a spinlock ok ? Even with list debugging
active ?

> +		spin_lock_irqsave(&rnp->lock, flags);
> +		phase = rnp->gpnum & 0x1; /* re-read under lock. */
> +		lp = &rnp->blocked_tasks[phase];
> +		list_for_each_entry(t, lp, rcu_node_entry)
> +			printk(" P%d", t->pid);
> +		spin_unlock_irqrestore(&rnp->lock, flags);
> +	}
> +}
> +
> +#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> +
> +/*
> + * Check for a quiescent state from the current CPU.  When a task blocks,
> + * the task is recorded in the corresponding CPU's rcu_node structure,
> + * which is checked elsewhere.
> + *
> + * Caller must disable hard irqs.
> + */
> +static void rcu_preempt_check_callbacks(int cpu)
> +{
> +	struct task_struct *t = current;
> +
> +	if (t->rcu_read_lock_nesting == 0) {
> +		rcu_preempt_qs_record(cpu);
> +		return;
> +	}
> +	if (per_cpu(rcu_preempt_data, cpu).qs_pending) {
> +		if (t->rcu_read_unlock_special & RCU_READ_UNLOCK_GOT_GEN) {
> +			rcu_preempt_qs_record(cpu);
> +			t->rcu_read_unlock_special &= RCU_READ_UNLOCK_GOT_GEN;
> +		} else if (!(t->rcu_read_unlock_special &
> +			     RCU_READ_UNLOCK_NEED_GEN))
> +			t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_GEN;

I would add brackets around else.

[...]

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
