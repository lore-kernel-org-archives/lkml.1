Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYEEJQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYEEJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbYEEJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:16:08 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:36937 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYEEJQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:16:01 -0400
Date: Mon, 5 May 2008 14:44:50 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       akpm@linux-foundation.org, hch@infradead.org, mmlnx@us.ibm.com,
       dipankar@in.ibm.com, dsmith@redhat.com, rostedt@goodmis.org,
       adrian.bunk@movial.fi, a.p.zijlstra@chello.nl, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: Re: [PATCH 1/5] Add call_rcu_sched()
Message-ID: <20080505091450.GA8371@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080422004454.GA3517@linux.vnet.ibm.com> <20080422004539.GA3693@linux.vnet.ibm.com> <20080422005031.GF3693@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422005031.GF3693@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:50:31PM -0700, Paul E. McKenney wrote:
> 

Yet to review the complete series. 

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
> 
>  include/linux/rcuclassic.h       |    3 
>  include/linux/rcupdate.h         |   22 +
>  include/linux/rcupreempt.h       |   42 +++
>  include/linux/rcupreempt_trace.h |    6 
>  init/main.c                      |    1 
>  kernel/rcupdate.c                |   20 -
>  kernel/rcupreempt.c              |  433 +++++++++++++++++++++++++++++++++++----
>  kernel/rcupreempt_trace.c        |   58 +++++
>  8 files changed, 514 insertions(+), 71 deletions(-)
> 
> diff -urpNa -X dontdiff linux-2.6.25/include/linux/rcuclassic.h linux-2.6.25-C1-call_rcu_sched/include/linux/rcuclassic.h
> --- linux-2.6.25/include/linux/rcuclassic.h	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/include/linux/rcuclassic.h	2008-04-17 08:10:33.000000000 -0700
> @@ -153,7 +153,10 @@ extern struct lockdep_map rcu_lock_map;
> 
>  #define __synchronize_sched() synchronize_rcu()
> 
> +#define call_rcu_sched(head, func) call_rcu(head, func)
> +
>  extern void __rcu_init(void);
> +#define rcu_init_sched()	do { } while (0)
>  extern void rcu_check_callbacks(int cpu, int user);
>  extern void rcu_restart_cpu(int cpu);
> 
> diff -urpNa -X dontdiff linux-2.6.25/include/linux/rcupdate.h linux-2.6.25-C1-call_rcu_sched/include/linux/rcupdate.h
> --- linux-2.6.25/include/linux/rcupdate.h	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/include/linux/rcupdate.h	2008-04-17 08:10:33.000000000 -0700
> @@ -42,6 +42,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
>  #include <linux/lockdep.h>
> +#include <linux/completion.h>
> 
>  /**
>   * struct rcu_head - callback structure for use with RCU
> @@ -182,6 +183,27 @@ struct rcu_head {
>  		(p) = (v); \
>  	})
> 
> +/* Infrastructure to implement the synchronize_() primitives. */
> +
> +struct rcu_synchronize {
> +	struct rcu_head head;
> +	struct completion completion;
> +};
> +
> +extern void wakeme_after_rcu(struct rcu_head  *head);
> +
> +#define synchronize_rcu_xxx(name, func) \
> +void name(void) \
> +{ \
> +	struct rcu_synchronize rcu; \
> +	\
> +	init_completion(&rcu.completion); \
> +	/* Will wake me after RCU finished. */ \
> +	func(&rcu.head, wakeme_after_rcu); \
> +	/* Wait for it. */ \
> +	wait_for_completion(&rcu.completion); \
> +}
> +
>  /**
>   * synchronize_sched - block until all CPUs have exited any non-preemptive
>   * kernel code sequences.
> diff -urpNa -X dontdiff linux-2.6.25/include/linux/rcupreempt.h linux-2.6.25-C1-call_rcu_sched/include/linux/rcupreempt.h
> --- linux-2.6.25/include/linux/rcupreempt.h	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/include/linux/rcupreempt.h	2008-04-19 22:44:18.000000000 -0700
> @@ -42,10 +42,39 @@
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
> 
> -#define rcu_qsctr_inc(cpu)
> +struct rcu_dyntick_sched {
> +	int dynticks;
> +	int dynticks_snap;
> +	int sched_qs;
> +	int sched_qs_snap;
> +	int sched_dynticks_snap;
> +};
> +
> +DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
> +
> +static inline void rcu_qsctr_inc(int cpu)
> +{
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	rdssp->sched_qs++;
> +}
>  #define rcu_bh_qsctr_inc(cpu)
>  #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
> 
> +/**
> + * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual update function to be invoked after the grace period
> + *
> + * The update function will be invoked some time after a full
> + * synchronize_sched()-style grace period elapses, in other words after
> + * all currently executing preempt-disabled sections of code (including
> + * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
> + * completed.
> + */
> +extern void call_rcu_sched(struct rcu_head *head,
> +			   void (*func)(struct rcu_head *head));
> +
>  extern void __rcu_read_lock(void)	__acquires(RCU);
>  extern void __rcu_read_unlock(void)	__releases(RCU);
>  extern int rcu_pending(int cpu);
> @@ -57,6 +86,7 @@ extern int rcu_needs_cpu(int cpu);
>  extern void __synchronize_sched(void);
> 
>  extern void __rcu_init(void);
> +extern void rcu_init_sched(void);
>  extern void rcu_check_callbacks(int cpu, int user);
>  extern void rcu_restart_cpu(int cpu);
>  extern long rcu_batches_completed(void);
> @@ -83,20 +113,20 @@ extern struct rcupreempt_trace *rcupreem
>  struct softirq_action;
> 
>  #ifdef CONFIG_NO_HZ
> -DECLARE_PER_CPU(long, dynticks_progress_counter);
> +DECLARE_PER_CPU(struct rcu_dyntick_sched, dynticks_progress_counter);
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^
Where is this defined? And why do we need it? We
already have rcu_dyntick_sched.dynticks for this purpose, no?

> 
>  static inline void rcu_enter_nohz(void)
>  {
>  	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> -	__get_cpu_var(dynticks_progress_counter)++;
> -	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
> +	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> +	WARN_ON(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1);
>  }
> 
>  static inline void rcu_exit_nohz(void)
>  {
> -	__get_cpu_var(dynticks_progress_counter)++;
> +	__get_cpu_var(rcu_dyntick_sched).dynticks++;
>  	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> -	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
> +	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
>  }
> 
>  #else /* CONFIG_NO_HZ */
> diff -urpNa -X dontdiff linux-2.6.25/include/linux/rcupreempt_trace.h linux-2.6.25-C1-call_rcu_sched/include/linux/rcupreempt_trace.h
> --- linux-2.6.25/include/linux/rcupreempt_trace.h	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/include/linux/rcupreempt_trace.h	2008-04-20 07:44:41.000000000 -0700
> @@ -66,12 +66,15 @@ struct rcupreempt_trace {
>  	long		rcu_try_flip_m1;
>  	long		rcu_try_flip_me1;
>  	long		rcu_try_flip_m2;
> +	int		rcu_sched_cpu;
>  };
> 
>  #ifdef CONFIG_RCU_TRACE
> -#define RCU_TRACE(fn, arg) 	fn(arg);
> +#define RCU_TRACE(fn, arg) 			fn(arg)
> +#define RCU_TRACE_1ARG(fn, arg, arg1) 		fn(arg, arg1)
>  #else
>  #define RCU_TRACE(fn, arg)
> +#define RCU_TRACE_1ARG(fn, arg, arg1)
>  #endif
> 
>  extern void rcupreempt_trace_move2done(struct rcupreempt_trace *trace);
> @@ -94,6 +97,7 @@ extern void rcupreempt_trace_check_callb
>  extern void rcupreempt_trace_done_remove(struct rcupreempt_trace *trace);
>  extern void rcupreempt_trace_invoke(struct rcupreempt_trace *trace);
>  extern void rcupreempt_trace_next_add(struct rcupreempt_trace *trace);
> +extern void rcusched_trace_grace_wait(struct rcupreempt_trace *trace, int cpu);
> 
>  #endif /* __KERNEL__ */
>  #endif /* __LINUX_RCUPREEMPT_TRACE_H */
> diff -urpNa -X dontdiff linux-2.6.25/init/main.c linux-2.6.25-C1-call_rcu_sched/init/main.c
> --- linux-2.6.25/init/main.c	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/init/main.c	2008-04-17 08:10:33.000000000 -0700
> @@ -730,6 +730,7 @@ static void __init do_initcalls(void)
>   */
>  static void __init do_basic_setup(void)
>  {
> +	rcu_init_sched(); /* needed by module_init stage. */
>  	/* drivers will send hotplug events */
>  	init_workqueues();
>  	usermodehelper_init();
> diff -urpNa -X dontdiff linux-2.6.25/kernel/rcupdate.c linux-2.6.25-C1-call_rcu_sched/kernel/rcupdate.c
> --- linux-2.6.25/kernel/rcupdate.c	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/kernel/rcupdate.c	2008-04-17 08:10:33.000000000 -0700
> @@ -39,18 +39,12 @@
>  #include <linux/sched.h>
>  #include <asm/atomic.h>
>  #include <linux/bitops.h>
> -#include <linux/completion.h>
>  #include <linux/percpu.h>
>  #include <linux/notifier.h>
>  #include <linux/cpu.h>
>  #include <linux/mutex.h>
>  #include <linux/module.h>
> 
> -struct rcu_synchronize {
> -	struct rcu_head head;
> -	struct completion completion;
> -};
> -
>  static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
>  static atomic_t rcu_barrier_cpu_count;
>  static DEFINE_MUTEX(rcu_barrier_mutex);
> @@ -60,7 +54,7 @@ static struct completion rcu_barrier_com
>   * Awaken the corresponding synchronize_rcu() instance now that a
>   * grace period has elapsed.
>   */
> -static void wakeme_after_rcu(struct rcu_head  *head)
> +void wakeme_after_rcu(struct rcu_head  *head)
>  {
>  	struct rcu_synchronize *rcu;
> 
> @@ -77,17 +71,7 @@ static void wakeme_after_rcu(struct rcu_
>   * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
>   * and may be nested.
>   */
> -void synchronize_rcu(void)
> -{
> -	struct rcu_synchronize rcu;
> -
> -	init_completion(&rcu.completion);
> -	/* Will wake me after RCU finished */
> -	call_rcu(&rcu.head, wakeme_after_rcu);
> -
> -	/* Wait for it */
> -	wait_for_completion(&rcu.completion);
> -}
> +synchronize_rcu_xxx(synchronize_rcu, call_rcu)
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
> 
>  static void rcu_barrier_callback(struct rcu_head *notused)
> diff -urpNa -X dontdiff linux-2.6.25/kernel/rcupreempt.c linux-2.6.25-C1-call_rcu_sched/kernel/rcupreempt.c
> --- linux-2.6.25/kernel/rcupreempt.c	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/kernel/rcupreempt.c	2008-04-20 07:58:31.000000000 -0700
> @@ -46,6 +46,7 @@
>  #include <asm/atomic.h>
>  #include <linux/bitops.h>
>  #include <linux/module.h>
> +#include <linux/kthread.h>
>  #include <linux/completion.h>
>  #include <linux/moduleparam.h>
>  #include <linux/percpu.h>
> @@ -87,9 +88,14 @@ struct rcu_data {
>  	struct rcu_head **nexttail;
>  	struct rcu_head *waitlist[GP_STAGES];
>  	struct rcu_head **waittail[GP_STAGES];
> -	struct rcu_head *donelist;
> +	struct rcu_head *donelist;	/* from waitlist & waitschedlist */
>  	struct rcu_head **donetail;
>  	long rcu_flipctr[2];
> +	struct rcu_head *nextschedlist;
> +	struct rcu_head **nextschedtail;
> +	struct rcu_head *waitschedlist;
> +	struct rcu_head **waitschedtail;
> +	int rcu_sched_sleeping;
>  #ifdef CONFIG_RCU_TRACE
>  	struct rcupreempt_trace trace;
>  #endif /* #ifdef CONFIG_RCU_TRACE */
> @@ -131,11 +137,24 @@ enum rcu_try_flip_states {
>  	rcu_try_flip_waitmb_state,
>  };
> 
> +/*
> + * States for rcu_ctrlblk.rcu_sched_sleep.
		 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ should be
		 rcu_ctrlblk.sched_sleep
> + */
> +
> +enum rcu_sched_sleep_states {
> +	rcu_sched_not_sleeping,	/* Not sleeping, callbacks need GP.  */
> +	rcu_sched_sleep_prep,	/* Thinking of sleeping, rechecking. */
> +	rcu_sched_sleeping,	/* Sleeping, awaken if GP needed. */
> +};
> +
>  struct rcu_ctrlblk {
>  	spinlock_t	fliplock;	/* Protect state-machine transitions. */
>  	long		completed;	/* Number of last completed batch. */
>  	enum rcu_try_flip_states rcu_try_flip_state; /* The current state of
>  							the rcu state machine */
> +	spinlock_t	schedlock;	/* Protect rcu_sched sleep state. */
> +	enum rcu_sched_sleep_states sched_sleep; /* rcu_sched state. */
> +	wait_queue_head_t sched_wq;	/* Place for rcu_sched to sleep. */
>  };
> 
>  static DEFINE_PER_CPU(struct rcu_data, rcu_data);
> @@ -143,8 +162,12 @@ static struct rcu_ctrlblk rcu_ctrlblk = 
>  	.fliplock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
>  	.completed = 0,
>  	.rcu_try_flip_state = rcu_try_flip_idle_state,
> +	.schedlock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.schedlock),
> +	.sched_sleep = rcu_sched_not_sleeping,
> +	.sched_wq = __WAIT_QUEUE_HEAD_INITIALIZER(rcu_ctrlblk.sched_wq),
>  };
> 
> +static struct task_struct *rcu_sched_grace_period_task;
> 
>  #ifdef CONFIG_RCU_TRACE
>  static char *rcu_try_flip_state_names[] =
> @@ -194,6 +217,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(enu
>   * cached in a local variable, but where the CPU number is so cached.
>   */
>  #define RCU_TRACE_CPU(f, cpu) RCU_TRACE(f, &(RCU_DATA_CPU(cpu)->trace));
> +#define RCU_TRACE_1ARG_CPU(f, cpu, a) RCU_TRACE_1ARG(f, &(RCU_DATA_CPU(cpu)->trace), a);
> 
>  /*
>   * Helper macro for tracing when the appropriate rcu_data is not
> @@ -207,6 +231,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(enu
>   */
>  #define RCU_TRACE_RDP(f, rdp) RCU_TRACE(f, &((rdp)->trace));
> 
> +#define RCU_SCHED_BATCH_TIME (HZ / 50)
> +
>  /*
>   * Return the number of RCU batches processed thus far.  Useful
>   * for debug and statistics.
> @@ -413,32 +439,34 @@ static void __rcu_advance_callbacks(stru
>  	}
>  }
> 
> -#ifdef CONFIG_NO_HZ
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
> +	.dynticks = 1,
> +};
> 
> -DEFINE_PER_CPU(long, dynticks_progress_counter) = 1;
> -static DEFINE_PER_CPU(long, rcu_dyntick_snapshot);
> +#ifdef CONFIG_NO_HZ
>  static DEFINE_PER_CPU(int, rcu_update_flag);
> 
>  /**
>   * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
>   *
>   * If the CPU was idle with dynamic ticks active, this updates the
> - * dynticks_progress_counter to let the RCU handling know that the
> + * rcu_dyntick_sched.dynticks to let the RCU handling know that the
>   * CPU is active.
>   */
>  void rcu_irq_enter(void)
>  {
>  	int cpu = smp_processor_id();
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> 
>  	if (per_cpu(rcu_update_flag, cpu))
>  		per_cpu(rcu_update_flag, cpu)++;
> 
>  	/*
>  	 * Only update if we are coming from a stopped ticks mode
> -	 * (dynticks_progress_counter is even).
> +	 * (rcu_dyntick_sched.dynticks is even).
>  	 */
>  	if (!in_interrupt() &&
> -	    (per_cpu(dynticks_progress_counter, cpu) & 0x1) == 0) {
> +	    (rdssp->dynticks & 0x1) == 0) {
>  		/*
>  		 * The following might seem like we could have a race
>  		 * with NMI/SMIs. But this really isn't a problem.
> @@ -461,12 +489,12 @@ void rcu_irq_enter(void)
>  		 * RCU read-side critical sections on this CPU would
>  		 * have already completed.
>  		 */
> -		per_cpu(dynticks_progress_counter, cpu)++;
> +		rdssp->dynticks++;
>  		/*
>  		 * The following memory barrier ensures that any
>  		 * rcu_read_lock() primitives in the irq handler
>  		 * are seen by other CPUs to follow the above
> -		 * increment to dynticks_progress_counter. This is
> +		 * increment to rcu_dyntick_sched.dynticks. This is
>  		 * required in order for other CPUs to correctly
>  		 * determine when it is safe to advance the RCU
>  		 * grace-period state machine.
> @@ -474,7 +502,7 @@ void rcu_irq_enter(void)
>  		smp_mb(); /* see above block comment. */
>  		/*
>  		 * Since we can't determine the dynamic tick mode from
> -		 * the dynticks_progress_counter after this routine,
> +		 * the rcu_dyntick_sched.dynticks after this routine,
>  		 * we use a second flag to acknowledge that we came
>  		 * from an idle state with ticks stopped.
>  		 */
> @@ -482,7 +510,7 @@ void rcu_irq_enter(void)
>  		/*
>  		 * If we take an NMI/SMI now, they will also increment
>  		 * the rcu_update_flag, and will not update the
> -		 * dynticks_progress_counter on exit. That is for
> +		 * rcu_dyntick_sched.dynticks on exit. That is for
>  		 * this IRQ to do.
>  		 */
>  	}
> @@ -492,12 +520,13 @@ void rcu_irq_enter(void)
>   * rcu_irq_exit - Called from exiting Hard irq context.
>   *
>   * If the CPU was idle with dynamic ticks active, update the
> - * dynticks_progress_counter to put let the RCU handling be
> + * rcu_dyntick_sched.dynticks to put let the RCU handling be
>   * aware that the CPU is going back to idle with no ticks.
>   */
>  void rcu_irq_exit(void)
>  {
>  	int cpu = smp_processor_id();
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> 
>  	/*
>  	 * rcu_update_flag is set if we interrupted the CPU
> @@ -505,7 +534,7 @@ void rcu_irq_exit(void)
>  	 * Once this occurs, we keep track of interrupt nesting
>  	 * because a NMI/SMI could also come in, and we still
>  	 * only want the IRQ that started the increment of the
> -	 * dynticks_progress_counter to be the one that modifies
> +	 * rcu_dyntick_sched.dynticks to be the one that modifies
>  	 * it on exit.
>  	 */
>  	if (per_cpu(rcu_update_flag, cpu)) {
> @@ -517,28 +546,29 @@ void rcu_irq_exit(void)
> 
>  		/*
>  		 * If an NMI/SMI happens now we are still
> -		 * protected by the dynticks_progress_counter being odd.
> +		 * protected by the rcu_dyntick_sched.dynticks being odd.
>  		 */
> 
>  		/*
>  		 * The following memory barrier ensures that any
>  		 * rcu_read_unlock() primitives in the irq handler
>  		 * are seen by other CPUs to preceed the following
> -		 * increment to dynticks_progress_counter. This
> +		 * increment to rcu_dyntick_sched.dynticks. This
>  		 * is required in order for other CPUs to determine
>  		 * when it is safe to advance the RCU grace-period
>  		 * state machine.
>  		 */
>  		smp_mb(); /* see above block comment. */
> -		per_cpu(dynticks_progress_counter, cpu)++;
> -		WARN_ON(per_cpu(dynticks_progress_counter, cpu) & 0x1);
> +		rdssp->dynticks++;
> +		WARN_ON(rdssp->dynticks & 0x1);
>  	}
>  }
> 
>  static void dyntick_save_progress_counter(int cpu)
>  {
> -	per_cpu(rcu_dyntick_snapshot, cpu) =
> -		per_cpu(dynticks_progress_counter, cpu);
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	rdssp->dynticks_snap = rdssp->dynticks;
>  }
> 
>  static inline int
> @@ -546,9 +576,10 @@ rcu_try_flip_waitack_needed(int cpu)
>  {
>  	long curr;
>  	long snap;
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> 
> -	curr = per_cpu(dynticks_progress_counter, cpu);
> -	snap = per_cpu(rcu_dyntick_snapshot, cpu);
> +	curr = rdssp->dynticks;
> +	snap = rdssp->dynticks_snap;
>  	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
> 
>  	/*
> @@ -582,9 +613,10 @@ rcu_try_flip_waitmb_needed(int cpu)
>  {
>  	long curr;
>  	long snap;
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> 
> -	curr = per_cpu(dynticks_progress_counter, cpu);
> -	snap = per_cpu(rcu_dyntick_snapshot, cpu);
> +	curr = rdssp->dynticks;
> +	snap = rdssp->dynticks_snap;
>  	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
> 
>  	/*
> @@ -611,14 +643,85 @@ rcu_try_flip_waitmb_needed(int cpu)
>  	return 1;
>  }
> 
> +static void dyntick_save_progress_counter_sched(int cpu)
> +{
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	rdssp->sched_dynticks_snap = rdssp->dynticks;
> +}
> +
> +static int rcu_qsctr_inc_needed_dyntick(int cpu)
> +{
> +	long curr;
> +	long snap;
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	curr = rdssp->dynticks;
> +	snap = rdssp->sched_dynticks_snap;
> +	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
> +
> +	/*
> +	 * If the CPU remained in dynticks mode for the entire time
> +	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
> +	 * then it cannot be in the middle of an preempt-disabled
> +	 * region of code.  Therefore, this CPU has been in a quiescent
> +	 * state the entire time, and we don't need to wait for it.
> +	 */
> +
> +	if ((curr == snap) && ((curr & 0x1) == 0))
> +		return 0;
> +
> +	/*
> +	 * If the CPU passed through or entered a dynticks idle phase with
> +	 * no active irq handlers, then, as above, this CPU has already
> +	 * passed through a quiescent state.
> +	 */
> +
> +	if ((curr - snap) > 2 || (snap & 0x1) == 0)
> +		return 0;
> +
> +	/* We need this CPU to go through a quiescent state. */
> +
> +	return 1;
> +}
> +
>  #else /* !CONFIG_NO_HZ */
> 
> -# define dyntick_save_progress_counter(cpu)	do { } while (0)
> -# define rcu_try_flip_waitack_needed(cpu)	(1)
> -# define rcu_try_flip_waitmb_needed(cpu)	(1)
> +# define dyntick_save_progress_counter(cpu)		do { } while (0)
> +# define rcu_try_flip_waitack_needed(cpu)		(1)
> +# define rcu_try_flip_waitmb_needed(cpu)		(1)
> +
> +# define dyntick_save_progress_counter_sched(cpu)	do { } while (0)
> +# define rcu_qsctr_inc_needed_dyntick(cpu)		(1)
> 
>  #endif /* CONFIG_NO_HZ */
> 
> +static void save_qsctr_sched(int cpu)
> +{
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	rdssp->sched_qs_snap = rdssp->sched_qs;
> +}
> +
> +static inline int rcu_qsctr_inc_needed(int cpu)
> +{
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	/*
> +	 * If there has been a quiescent state, no more need to wait
> +	 * on this CPU.
> +	 */
> +
> +	if (rdssp->sched_qs != rdssp->sched_qs_snap) {
> +		smp_mb(); /* force ordering with cpu entering schedule(). */
> +		return 0;
> +	}
> +
> +	/* We need this CPU to go through a quiescent state. */
> +
> +	return 1;
> +}
> +
>  /*
>   * Get here when RCU is idle.  Decide whether we need to
>   * move out of idle state, and return non-zero if so.
> @@ -821,6 +924,26 @@ void rcu_check_callbacks(int cpu, int us
>  	unsigned long flags;
>  	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
> 
> +	/*
> +	 * If this CPU took its interrupt from user mode or from the
> +	 * idle loop, and this is not a nested interrupt, then
> +	 * this CPU has to have exited all prior preept-disable
> +	 * sections of code.  So increment the counter to note this.
> +	 *
> +	 * The memory barrier is needed to handle the case where
> +	 * writes from a preempt-disable section of code get reordered
> +	 * into schedule() by this CPU's write buffer.  So the memory
> +	 * barrier makes sure that the rcu_qsctr_inc() is seen by other
> +	 * CPUs to happen after any such write.
> +	 */
> +
> +	if (user ||
> +	    (idle_cpu(cpu) && !in_softirq() &&
> +	     hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> +		smp_mb();	/* Guard against aggressive schedule(). */
> +	     	rcu_qsctr_inc(cpu);
> +	}
> +
>  	rcu_check_mb(cpu);
>  	if (rcu_ctrlblk.completed == rdp->completed)
>  		rcu_try_flip();
> @@ -871,6 +994,8 @@ void rcu_offline_cpu(int cpu)
>  	struct rcu_head *list = NULL;
>  	unsigned long flags;
>  	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
> +	struct rcu_head *schedlist = NULL;
> +	struct rcu_head **schedtail = &schedlist;
>  	struct rcu_head **tail = &list;
> 
>  	/*
> @@ -884,6 +1009,11 @@ void rcu_offline_cpu(int cpu)
>  		rcu_offline_cpu_enqueue(rdp->waitlist[i], rdp->waittail[i],
>  						list, tail);
>  	rcu_offline_cpu_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
> +	rcu_offline_cpu_enqueue(rdp->waitschedlist, rdp->waitschedtail,
> +				schedlist, schedtail);
> +	rcu_offline_cpu_enqueue(rdp->nextschedlist, rdp->nextschedtail,
> +				schedlist, schedtail);
> +	rdp->rcu_sched_sleeping = 0;
>  	spin_unlock_irqrestore(&rdp->lock, flags);
>  	rdp->waitlistcount = 0;
> 
> @@ -918,22 +1048,40 @@ void rcu_offline_cpu(int cpu)
>  	 * fix.
>  	 */
> 
> -	local_irq_save(flags);
> +	local_irq_save(flags);  /* disable preempt till we know what lock. */
>  	rdp = RCU_DATA_ME();
>  	spin_lock(&rdp->lock);
>  	*rdp->nexttail = list;
>  	if (list)
>  		rdp->nexttail = tail;
> +	*rdp->nextschedtail = schedlist;
> +	if (schedlist)
> +		rdp->nextschedtail = schedtail;
>  	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
> 
>  void __devinit rcu_online_cpu(int cpu)
>  {
>  	unsigned long flags;
> +	struct rcu_data *rdp;
> 
>  	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
>  	cpu_set(cpu, rcu_cpu_online_map);
>  	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> +
> +	/*
> +	 * The rcu_sched grace-period processing might have bypassed
> +	 * this CPU, given that it was not in the rcu_cpu_online_map
> +	 * when the grace-period scan started.  This means that the
> +	 * grace-period task might sleep.  So make sure that if this
> +	 * should happen, the first callback posted to this CPU will
> +	 * wake up the grace-period task if need be.
> +	 */
> +
> +	rdp = RCU_DATA_CPU(cpu);
> +	spin_lock_irqsave(&rdp->lock, flags);
> +	rdp->rcu_sched_sleeping = 1;
> +	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
> 
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> @@ -988,31 +1136,215 @@ void call_rcu(struct rcu_head *head, voi
>  	*rdp->nexttail = head;
>  	rdp->nexttail = &head->next;
>  	RCU_TRACE_RDP(rcupreempt_trace_next_add, rdp);
> -	spin_unlock(&rdp->lock);
> -	local_irq_restore(flags);
> +	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu);
> 
> +void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long flags;
> +	struct rcu_data *rdp;
> +	int wake_gp = 0;
> +
> +	head->func = func;
> +	head->next = NULL;
> +	local_irq_save(flags);
> +	rdp = RCU_DATA_ME();
> +	spin_lock(&rdp->lock);
> +	*rdp->nextschedtail = head;
> +	rdp->nextschedtail = &head->next;
> +	if (rdp->rcu_sched_sleeping) {
> +
> +		/* Grace-period processing might be sleeping... */
> +
> +		rdp->rcu_sched_sleeping = 0;
> +		wake_gp = 1;
> +	}
> +	spin_unlock_irqrestore(&rdp->lock, flags);
> +	if (wake_gp) {
> +
> +		/* Wake up grace-period processing, unless someone beat us. */
> +
> +		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
> +		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleeping)
> +			wake_gp = 0;
> +		rcu_ctrlblk.sched_sleep = rcu_sched_not_sleeping;
> +		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +		if (wake_gp)
> +			wake_up_interruptible(&rcu_ctrlblk.sched_wq);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(call_rcu_sched);
> +
>  /*
>   * Wait until all currently running preempt_disable() code segments
>   * (including hardware-irq-disable segments) complete.  Note that
>   * in -rt this does -not- necessarily result in all currently executing
>   * interrupt -handlers- having completed.
>   */
> -void __synchronize_sched(void)
> +synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
> +EXPORT_SYMBOL_GPL(__synchronize_sched);
> +
> +/*
> + * kthread function that manages call_rcu_sched grace periods.
> + */
> +static int rcu_sched_grace_period(void *arg)
>  {
> -	cpumask_t oldmask;
> +	int couldsleep;		/* might sleep after current pass. */
> +	int couldsleepnext = 0; /* might sleep after next pass. */
>  	int cpu;
> +	unsigned long flags;
> +	cpumask_t cpu_snap;
> +	struct rcu_data *rdp;
> +	int ret;
> 
> -	if (sched_getaffinity(0, &oldmask) < 0)
> -		oldmask = cpu_possible_map;
> -	for_each_online_cpu(cpu) {
> -		sched_setaffinity(0, cpumask_of_cpu(cpu));
> -		schedule();
> -	}
> -	sched_setaffinity(0, oldmask);
> +	/*
> +	 * Each pass through the following loop handles one
> +	 * rcu_sched grace period cycle.
> +	 */
> +	do {
> +		/* Save each CPU's current state. */
> +
> +		spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
> +		cpu_snap = cpu_online_map;
> +		spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> +		for_each_cpu_mask(cpu, cpu_snap) {
> +			if (cpu_is_offline(cpu)) {
> +				cpu_clear(cpu, cpu_snap);
> +				continue;
> +			}
> +			dyntick_save_progress_counter_sched(cpu);
> +			save_qsctr_sched(cpu);
> +			if (cpu_is_offline(cpu))
> +				cpu_clear(cpu, cpu_snap);
> +		}
> +
> +		/*
> +		 * Sleep for about an RCU grace-period's worth to
> +		 * allow better batching and to consume less CPU.
> +		 */
> +		schedule_timeout_interruptible(RCU_SCHED_BATCH_TIME);
> +
> +		/*
> +		 * If there was nothing to do last time, prepare to
> +		 * sleep at the end of the current grace period cycle.
> +		 */
> +		couldsleep = couldsleepnext;
> +		couldsleepnext = 1;
> +		if (couldsleep) {
> +			spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
> +			rcu_ctrlblk.sched_sleep = rcu_sched_sleep_prep;
> +			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +		}
> +
> +		/*
> +		 * Wait on each CPU in turn to have either visited
> +		 * a quiescent state or been in dynticks-idle mode.
> +		 */
> +		for_each_cpu_mask(cpu, cpu_snap) {
> +			RCU_TRACE_1ARG_CPU(rcusched_trace_grace_wait, 0, cpu);
> +			while (rcu_qsctr_inc_needed(cpu) &&
> +			       rcu_qsctr_inc_needed_dyntick(cpu)) {
> +				if (cpu_is_offline(cpu)) {
> +					cpu_clear(cpu, cpu_snap);
> +					break;
> +				}
> +				/* resched_cpu(cpu); @@@ */
> +				schedule_timeout_interruptible(1);
> +			}
> +			RCU_TRACE_1ARG_CPU(rcusched_trace_grace_wait, 0, -1);
> +		}
> +
> +		/* Advance callbacks for each CPU.  */
> +
> +		for_each_cpu_mask(cpu, cpu_snap) {
> +			rdp = RCU_DATA_CPU(cpu);
> +			spin_lock_irqsave(&rdp->lock, flags);
> +			if (cpu_is_offline(cpu)) {
> +				spin_unlock_irqrestore(&rdp->lock, flags);
> +				continue;
> +			}
> +
> +			/*
> +			 * We are running on this CPU irq-disabled, so no
> +			 * CPU can go offline until we re-enable irqs.
> +			 * The current CPU might have already gone
> +			 * offline (between the for_each_offline_cpu and
						^^^^^^^^^^^^^^^^^^^^
						for_each_cpu_mask().

Infact, for_each_offline_cpu() doesn't even exist ;-)

I guess doing the multiple cpu_is_offline() checks is unavoidable,
unless we use get_online_cpus()/put_online_cpus(). But that's an
overkill in this context.

So, looks okay to me.


> +			 * the spin_lock_irqsave), but in that case all its
> +			 * callback lists will be empty, so no harm done.
> +			 *
> +			 * Advance the callbacks!  We share normal RCU's
> +			 * donelist, since callbacks are invoked the
> +			 * same way in either case.
> +			 */
> +			if (rdp->waitschedlist != NULL) {
> +				*rdp->donetail = rdp->waitschedlist;
> +				rdp->donetail = rdp->waitschedtail;
> +
> +				/*
> +				 * Next rcu_check_callbacks() will
> +				 * do the required raise_softirq().
> +				 */
> +			}
> +			if (rdp->nextschedlist != NULL) {
> +				rdp->waitschedlist = rdp->nextschedlist;
> +				rdp->waitschedtail = rdp->nextschedtail;
> +				couldsleep = 0;
> +				couldsleepnext = 0;
> +			} else {
> +				rdp->waitschedlist = NULL;
> +				rdp->waitschedtail = &rdp->waitschedlist;
> +			}
> +			rdp->nextschedlist = NULL;
> +			rdp->nextschedtail = &rdp->nextschedlist;
> +
> +			/* Mark sleep intention. */
> +
> +			rdp->rcu_sched_sleeping = couldsleep;
> +
> +			spin_unlock_irqrestore(&rdp->lock, flags);
> +		}
> +
> +		/* If we saw callbacks on the last scan, go deal with them. */
> +
> +		if (!couldsleep)
> +			continue;
> +
> +		/* Attempt to block... */
> +
> +		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
> +		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleep_prep) {
> +
> +			/*
> +			 * Someone posted a callback after we scanned.
> +			 * Go take care of it.
> +			 */
> +			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +			couldsleepnext = 0;
> +			continue;
> +		}
> +
> +		/* Block until the next person posts a callback. */
> +
> +		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
> +		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +		ret = 0;
> +		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
> +			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
> +			ret);
> +
> +		/*
> +		 * Signals would prevent us from sleeping, and we cannot
> +		 * do much with them in any case.  So flush them.
> +		 */
> +		if (ret)
> +			flush_signals(current);
> +		couldsleepnext = 0;
> +
> +	} while (!kthread_should_stop());
> +
> +	return (0);
>  }
> -EXPORT_SYMBOL_GPL(__synchronize_sched);
> 
>  /*
>   * Check to see if any future RCU-related work will need to be done
> @@ -1029,7 +1361,9 @@ int rcu_needs_cpu(int cpu)
> 
>  	return (rdp->donelist != NULL ||
>  		!!rdp->waitlistcount ||
> -		rdp->nextlist != NULL);
> +		rdp->nextlist != NULL ||
> +		rdp->nextschedlist != NULL ||
> +		rdp->waitschedlist != NULL);
>  }
> 
>  int rcu_pending(int cpu)
> @@ -1040,7 +1374,9 @@ int rcu_pending(int cpu)
> 
>  	if (rdp->donelist != NULL ||
>  	    !!rdp->waitlistcount ||
> -	    rdp->nextlist != NULL)
> +	    rdp->nextlist != NULL ||
> +	    rdp->nextschedlist != NULL ||
> +	    rdp->waitschedlist != NULL)
>  		return 1;
> 
>  	/* The RCU core needs an acknowledgement from this CPU. */
> @@ -1107,6 +1443,11 @@ void __init __rcu_init(void)
>  		rdp->donetail = &rdp->donelist;
>  		rdp->rcu_flipctr[0] = 0;
>  		rdp->rcu_flipctr[1] = 0;
> +		rdp->nextschedlist = NULL;
> +		rdp->nextschedtail = &rdp->nextschedlist;
> +		rdp->waitschedlist = NULL;
> +		rdp->waitschedtail = &rdp->waitschedlist;
> +		rdp->rcu_sched_sleeping = 0;
>  	}
>  	register_cpu_notifier(&rcu_nb);
> 
> @@ -1129,11 +1470,15 @@ void __init __rcu_init(void)
>  }
> 
>  /*
> - * Deprecated, use synchronize_rcu() or synchronize_sched() instead.
> + * Late-boot-time RCU initialization that must wait until after scheduler
> + * has been initialized.
>   */
> -void synchronize_kernel(void)
> +void __init rcu_init_sched(void)
>  {
> -	synchronize_rcu();
> +	rcu_sched_grace_period_task = kthread_run(rcu_sched_grace_period,
> +						  NULL,
> +						  "rcu_sched_grace_period");
> +	WARN_ON(IS_ERR(rcu_sched_grace_period_task));
>  }
> 
>  #ifdef CONFIG_RCU_TRACE
> diff -urpNa -X dontdiff linux-2.6.25/kernel/rcupreempt_trace.c linux-2.6.25-C1-call_rcu_sched/kernel/rcupreempt_trace.c
> --- linux-2.6.25/kernel/rcupreempt_trace.c	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-C1-call_rcu_sched/kernel/rcupreempt_trace.c	2008-04-21 15:45:07.000000000 -0700
> @@ -134,6 +134,10 @@ void rcupreempt_trace_next_add(struct rc
>  	trace->next_add++;
>  	trace->next_length++;
>  }
> +void rcusched_trace_grace_wait(struct rcupreempt_trace *trace, int cpu)
> +{
> +	trace->rcu_sched_cpu = cpu;
> +}
> 
>  static void rcupreempt_trace_sum(struct rcupreempt_trace *sp)
>  {
> @@ -262,6 +266,38 @@ static ssize_t rcuctrs_read(struct file 
>  	return bcount;
>  }
> 
> +static ssize_t rcuschedstat_read(struct file *filp, char __user *buffer,
> +				 size_t count, loff_t *ppos)
> +{
> +	int cnt = 0;
> +	int cpu = rcupreempt_trace_cpu(0)->rcu_sched_cpu;
> +	ssize_t bcount;
> +
> +	mutex_lock(&rcupreempt_trace_mutex);
> +
> +	cnt += snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
> +				"CPU: %d ", cpu);
> +	if (cpu != -1) {
> +		struct rcu_dyntick_sched *rdsp;
> +
> +		rdsp = &per_cpu(rcu_dyntick_sched, cpu);
> +		cnt += snprintf(&rcupreempt_trace_buf[cnt],
> +				RCUPREEMPT_TRACE_BUF_SIZE - cnt,
> +					"dynticks: %d %d qs %d %d",
> +			       rdsp->dynticks,
> +			       rdsp->sched_dynticks_snap,
> +			       rdsp->sched_qs,
> +			       rdsp->sched_qs_snap);
> +	}
> +	cnt += snprintf(&rcupreempt_trace_buf[cnt],
> +			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
> +			"\n");
> +	bcount = simple_read_from_buffer(buffer, count, ppos,
> +			rcupreempt_trace_buf, strlen(rcupreempt_trace_buf));
> +	mutex_unlock(&rcupreempt_trace_mutex);
> +	return bcount;
> +}
> +
>  static struct file_operations rcustats_fops = {
>  	.owner = THIS_MODULE,
>  	.read = rcustats_read,
> @@ -277,7 +313,12 @@ static struct file_operations rcuctrs_fo
>  	.read = rcuctrs_read,
>  };
> 
> -static struct dentry *rcudir, *statdir, *ctrsdir, *gpdir;
> +static struct file_operations rcuschedstat_fops = {
> +	.owner = THIS_MODULE,
> +	.read = rcuschedstat_read,
> +};
> +
> +static struct dentry *rcudir, *statdir, *ctrsdir, *gpdir, *schedstatdir;
>  static int rcupreempt_debugfs_init(void)
>  {
>  	rcudir = debugfs_create_dir("rcu", NULL);
> @@ -296,12 +337,19 @@ static int rcupreempt_debugfs_init(void)
>  						NULL, &rcuctrs_fops);
>  	if (!ctrsdir)
>  		goto free_out;
> +
> +	schedstatdir = debugfs_create_file("schedstat", 0444, rcudir,
> +						NULL, &rcuschedstat_fops);
> +	if (!schedstatdir)
> +		goto free_out;
>  	return 0;
>  free_out:
>  	if (statdir)
>  		debugfs_remove(statdir);
>  	if (gpdir)
>  		debugfs_remove(gpdir);
> +	if (ctrsdir)
> +		debugfs_remove(ctrsdir);
>  	debugfs_remove(rcudir);
>  out:
>  	return 1;
> @@ -309,11 +357,16 @@ out:
> 
>  static int __init rcupreempt_trace_init(void)
>  {
> +	int ret;
> +
>  	mutex_init(&rcupreempt_trace_mutex);
>  	rcupreempt_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
>  	if (!rcupreempt_trace_buf)
>  		return 1;
> -	return rcupreempt_debugfs_init();
> +	ret = rcupreempt_debugfs_init();
> +	if (ret)
> +		kfree(rcupreempt_trace_buf);
> +	return ret;
>  }
> 
>  static void __exit rcupreempt_trace_cleanup(void)
> @@ -322,6 +375,7 @@ static void __exit rcupreempt_trace_clea
>  	debugfs_remove(gpdir);
>  	debugfs_remove(ctrsdir);
>  	debugfs_remove(rcudir);
> +	debugfs_remove(schedstatdir);
>  	kfree(rcupreempt_trace_buf);
>  }

-- 
Thanks and Regards
gautham
