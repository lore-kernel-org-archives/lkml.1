Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYKIAwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYKIAwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 19:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYKIAv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 19:51:58 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47295 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbYKIAv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 19:51:56 -0500
Date: Sat, 8 Nov 2008 16:51:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
	V2
Message-ID: <20081109005159.GM6917@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49129310.5000903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49129310.5000903@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:47:44PM +0800, Lai Jiangshan wrote:
> 
> this fix remove ugly macro, and increase readability for rcupdate codes
> 
> changed from v1:
> use HAVE_SPECIAL_RCU_BH/SCHED instead of define duplicate version of
> synchronize_sched().

Hello, Jiangshan!

I very much like getting rid of the ugly macro.  I of course like the
kernel-doc fixes.  ;-)

I am not yet convinced of the HAVE_SPECIAL_RCU_BH and
HAVE_SPECIAL_RCU_SCHED pieces.  It is not clear to me that this approach
is simpler than the current approach of simply providing the appropriate
definitions for the symbols in the implementation-specific rcuxxx.h
file.

Am I missing something?

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> index 5f89b62..68e84ff 100644
> --- a/include/linux/rcuclassic.h
> +++ b/include/linux/rcuclassic.h
> @@ -32,6 +32,7 @@
> 
>  #ifndef __LINUX_RCUCLASSIC_H
>  #define __LINUX_RCUCLASSIC_H
> +#define HAVE_SPECIAL_RCU_BH
> 
>  #include <linux/cache.h>
>  #include <linux/spinlock.h>
> @@ -166,12 +167,7 @@ extern struct lockdep_map rcu_lock_map;
>  		local_bh_enable(); \
>  	} while (0)
> 
> -#define __synchronize_sched() synchronize_rcu()
> -
> -#define call_rcu_sched(head, func) call_rcu(head, func)
> -
>  extern void __rcu_init(void);
> -#define rcu_init_sched()	do { } while (0)
>  extern void rcu_check_callbacks(int cpu, int user);
>  extern void rcu_restart_cpu(int cpu);
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 86f1f5e..7861bee 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -112,6 +112,7 @@ struct rcu_head {
>   */
>  #define rcu_read_unlock() __rcu_read_unlock()
> 
> +#ifdef HAVE_SPECIAL_RCU_BH
>  /**
>   * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
>   *
> @@ -125,13 +126,19 @@ struct rcu_head {
>   */
>  #define rcu_read_lock_bh() __rcu_read_lock_bh()
> 
> -/*
> +/**
>   * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
>   *
>   * See rcu_read_lock_bh() for more information.
>   */
>  #define rcu_read_unlock_bh() __rcu_read_unlock_bh()
> 
> +#else
> +#define rcu_bh_qsctr_inc(cpu)
> +#define rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
> +#define rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
> +#endif /* HAVE_SPECIAL_RCU_BH */
> +
>  /**
>   * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
>   *
> @@ -189,45 +196,6 @@ struct rcu_head {
>  		(p) = (v); \
>  	})
> 
> -/* Infrastructure to implement the synchronize_() primitives. */
> -
> -struct rcu_synchronize {
> -	struct rcu_head head;
> -	struct completion completion;
> -};
> -
> -extern void wakeme_after_rcu(struct rcu_head  *head);
> -
> -#define synchronize_rcu_xxx(name, func) \
> -void name(void) \
> -{ \
> -	struct rcu_synchronize rcu; \
> -	\
> -	init_completion(&rcu.completion); \
> -	/* Will wake me after RCU finished. */ \
> -	func(&rcu.head, wakeme_after_rcu); \
> -	/* Wait for it. */ \
> -	wait_for_completion(&rcu.completion); \
> -}
> -
> -/**
> - * synchronize_sched - block until all CPUs have exited any non-preemptive
> - * kernel code sequences.
> - *
> - * This means that all preempt_disable code sequences, including NMI and
> - * hardware-interrupt handlers, in progress on entry will have completed
> - * before this primitive returns.  However, this does not guarantee that
> - * softirq handlers will have completed, since in some kernels, these
> - * handlers can run in process context, and can block.
> - *
> - * This primitive provides the guarantees made by the (now removed)
> - * synchronize_kernel() API.  In contrast, synchronize_rcu() only
> - * guarantees that rcu_read_lock() sections will have completed.
> - * In "classic RCU", these two guarantees happen to be one and
> - * the same, but can differ in realtime RCU implementations.
> - */
> -#define synchronize_sched() __synchronize_sched()
> -
>  /**
>   * call_rcu - Queue an RCU callback for invocation after a grace period.
>   * @head: structure to be used for queueing the RCU updates.
> @@ -242,6 +210,11 @@ void name(void) \
>  extern void call_rcu(struct rcu_head *head,
>  			      void (*func)(struct rcu_head *head));
> 
> +
> +extern void synchronize_rcu(void);
> +extern void rcu_barrier(void);
> +
> +#ifdef HAVE_SPECIAL_RCU_BH
>  /**
>   * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
>   * @head: structure to be used for queueing the RCU updates.
> @@ -263,11 +236,46 @@ extern void call_rcu(struct rcu_head *head,
>  extern void call_rcu_bh(struct rcu_head *head,
>  			void (*func)(struct rcu_head *head));
> 
> -/* Exported common interfaces */
> -extern void synchronize_rcu(void);
> -extern void rcu_barrier(void);
>  extern void rcu_barrier_bh(void);
> +#else
> +
> +#define call_rcu_bh call_rcu
> +#define rcu_barrier_bh rcu_barrier
> +
> +/*
> + * Return the number of RCU batches processed thus far. Useful for debug
> + * and statistic. The _bh variant is identifcal to straight RCU
> + */
> +static inline long rcu_batches_completed_bh(void)
> +{
> +	return rcu_batches_completed();
> +}
> +#endif /* HAVE_SPECIAL_RCU_BH */
> +
> +#ifdef HAVE_SPECIAL_RCU_SCHED
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
> +extern void synchronize_sched(void);
>  extern void rcu_barrier_sched(void);
> +#else
> +#define call_rcu_sched call_rcu
> +#define synchronize_sched synchronize_rcu
> +#define rcu_barrier_sched rcu_barrier
> +
> +#define rcu_init_sched()	do { } while (0)
> +#endif /* HAVE_SPECIAL_RCU_SCHED */
> 
>  /* Internal to kernel */
>  extern void rcu_init(void);
> diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> index 3e05c09..f30d1c8 100644
> --- a/include/linux/rcupreempt.h
> +++ b/include/linux/rcupreempt.h
> @@ -32,6 +32,7 @@
> 
>  #ifndef __LINUX_RCUPREEMPT_H
>  #define __LINUX_RCUPREEMPT_H
> +#define HAVE_SPECIAL_RCU_SCHED
> 
>  #include <linux/cache.h>
>  #include <linux/spinlock.h>
> @@ -56,54 +57,18 @@ static inline void rcu_qsctr_inc(int cpu)
> 
>  	rdssp->sched_qs++;
>  }
> -#define rcu_bh_qsctr_inc(cpu)
> -
> -/*
> - * Someone might want to pass call_rcu_bh as a function pointer.
> - * So this needs to just be a rename and not a macro function.
> - *  (no parentheses)
> - */
> -#define call_rcu_bh	 	call_rcu
> -
> -/**
> - * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
> - * @head: structure to be used for queueing the RCU updates.
> - * @func: actual update function to be invoked after the grace period
> - *
> - * The update function will be invoked some time after a full
> - * synchronize_sched()-style grace period elapses, in other words after
> - * all currently executing preempt-disabled sections of code (including
> - * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
> - * completed.
> - */
> -extern void call_rcu_sched(struct rcu_head *head,
> -			   void (*func)(struct rcu_head *head));
> 
>  extern void __rcu_read_lock(void)	__acquires(RCU);
>  extern void __rcu_read_unlock(void)	__releases(RCU);
>  extern int rcu_pending(int cpu);
>  extern int rcu_needs_cpu(int cpu);
> 
> -#define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
> -#define __rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
> -
> -extern void __synchronize_sched(void);
> -
>  extern void __rcu_init(void);
>  extern void rcu_init_sched(void);
>  extern void rcu_check_callbacks(int cpu, int user);
>  extern void rcu_restart_cpu(int cpu);
>  extern long rcu_batches_completed(void);
> 
> -/*
> - * Return the number of RCU batches processed thus far. Useful for debug
> - * and statistic. The _bh variant is identifcal to straight RCU
> - */
> -static inline long rcu_batches_completed_bh(void)
> -{
> -	return rcu_batches_completed();
> -}
> -
>  #ifdef CONFIG_RCU_TRACE
>  struct rcupreempt_trace;
>  extern long *rcupreempt_flipctr(int cpu);
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index ad63af8..70cff32 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -56,11 +56,16 @@ static atomic_t rcu_barrier_cpu_count;
>  static DEFINE_MUTEX(rcu_barrier_mutex);
>  static struct completion rcu_barrier_completion;
> 
> +struct rcu_synchronize {
> +	struct rcu_head head;
> +	struct completion completion;
> +};
> +
>  /*
>   * Awaken the corresponding synchronize_rcu() instance now that a
>   * grace period has elapsed.
>   */
> -void wakeme_after_rcu(struct rcu_head  *head)
> +static void wakeme_after_rcu(struct rcu_head  *head)
>  {
>  	struct rcu_synchronize *rcu;
> 
> @@ -77,10 +82,48 @@ void wakeme_after_rcu(struct rcu_head  *head)
>   * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
>   * and may be nested.
>   */
> -void synchronize_rcu(void);	/* Makes kernel-doc tools happy */
> -synchronize_rcu_xxx(synchronize_rcu, call_rcu)
> +void synchronize_rcu(void)
> +{
> +	struct rcu_synchronize rcu;
> +
> +	init_completion(&rcu.completion);
> +	/* Will wake me after RCU finished. */
> +	call_rcu(&rcu.head, wakeme_after_rcu);
> +	/* Wait for it. */
> +	wait_for_completion(&rcu.completion);
> +}
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
> 
> +#ifdef HAVE_SPECIAL_RCU_SCHED
> +/**
> + * synchronize_sched - block until all CPUs have exited any non-preemptive
> + * kernel code sequences.
> + *
> + * This means that all preempt_disable code sequences, including NMI and
> + * hardware-interrupt handlers, in progress on entry will have completed
> + * before this primitive returns.  However, this does not guarantee that
> + * softirq handlers will have completed, since in some kernels, these
> + * handlers can run in process context, and can block.
> + *
> + * This primitive provides the guarantees made by the (now removed)
> + * synchronize_kernel() API.  In contrast, synchronize_rcu() only
> + * guarantees that rcu_read_lock() sections will have completed.
> + * In "classic RCU", these two guarantees happen to be one and
> + * the same, but can differ in realtime RCU implementations.
> + */
> +void synchronize_sched(void)
> +{
> +	struct rcu_synchronize rcu;
> +
> +	init_completion(&rcu.completion);
> +	/* Will wake me after RCU finished. */
> +	call_rcu_sched(&rcu.head, wakeme_after_rcu);
> +	/* Wait for it. */
> +	wait_for_completion(&rcu.completion);
> +}
> +EXPORT_SYMBOL_GPL(synchronize_sched);
> +#endif /* HAVE_SPECIAL_RCU_SCHED */
> +
>  static void rcu_barrier_callback(struct rcu_head *notused)
>  {
>  	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
> @@ -145,6 +188,7 @@ void rcu_barrier(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier);
> 
> +#ifdef HAVE_SPECIAL_RCU_BH
>  /**
>   * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
>   */
> @@ -153,7 +197,9 @@ void rcu_barrier_bh(void)
>  	_rcu_barrier(RCU_BARRIER_BH);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_bh);
> +#endif /* HAVE_SPECIAL_RCU_BH */
> 
> +#ifdef HAVE_SPECIAL_RCU_SCHED
>  /**
>   * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
>   */
> @@ -162,6 +208,7 @@ void rcu_barrier_sched(void)
>  	_rcu_barrier(RCU_BARRIER_SCHED);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> +#endif /* HAVE_SPECIAL_RCU_SCHED */
> 
>  void __init rcu_init(void)
>  {
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index 59236e8..2068ad9 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -1161,15 +1161,6 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  EXPORT_SYMBOL_GPL(call_rcu_sched);
> 
>  /*
> - * Wait until all currently running preempt_disable() code segments
> - * (including hardware-irq-disable segments) complete.  Note that
> - * in -rt this does -not- necessarily result in all currently executing
> - * interrupt -handlers- having completed.
> - */
> -synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
> -EXPORT_SYMBOL_GPL(__synchronize_sched);
> -
> -/*
>   * kthread function that manages call_rcu_sched grace periods.
>   */
>  static int rcu_sched_grace_period(void *arg)
> 
> 
