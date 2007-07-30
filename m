Return-Path: <linux-kernel-owner+w=401wt.eu-S938246AbXG3FUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938246AbXG3FUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXG3FT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:19:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55019 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXG3FT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:19:58 -0400
Subject: Re: v2.6.23-rc1-rt6-dw1
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1185765740.2636.2.camel@imap.mvista.com>
References: <1185765740.2636.2.camel@imap.mvista.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 29 Jul 2007 22:17:27 -0700
Message-Id: <1185772647.2686.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +/*
> + * trigger a reschedule on all other CPUs:
> + */
> +extern void smp_send_reschedule_allbutself(void);
> +
> +/*
> + * trigger a reschedule on all other CPUs:
> + */
> +extern void smp_send_reschedule_allbutself(void);
> +
>  
>  /*
>   * Prepare machine for booting other CPUs.
> @@ -97,6 +107,7 @@ static inline int up_smp_call_function(v
>  		0;				\
>  	})
>  static inline void smp_send_reschedule(int cpu) { }
> +static inline void smp_send_reschedule_allbutself(void) { }
>  #define num_booting_cpus()			1
>  #define smp_prepare_boot_cpu()			do {} while (0)
>  #define smp_call_function_single(cpuid, func, info, retry, wait) \
> :: end preempt-realtime-i386.patch ::
> :: start preempt-realtime-sched.patch ::
> --- linux-2.6.22.orig/include/linux/kernel.h
> +++ linux-2.6.22/include/linux/kernel.h
> @@ -88,7 +88,7 @@ extern int cond_resched(void);
>  # define might_resched() do { } while (0)
>  #endif
>  
> -#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
> +#if defined(CONFIG_DEBUG_SPINLOCK_SLEEP) || defined(CONFIG_DEBUG_PREEMPT)
>    void __might_sleep(char *file, int line);
>  # define might_sleep() \
>  	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
> @@ -198,6 +198,7 @@ extern void add_taint(unsigned);
>  /* Values used for system_state */
>  extern enum system_states {
>  	SYSTEM_BOOTING,
> +	SYSTEM_BOOTING_SCHEDULER_OK,
>  	SYSTEM_RUNNING,
>  	SYSTEM_HALT,
>  	SYSTEM_POWER_OFF,
> --- linux-2.6.22.orig/init/main.c
> +++ linux-2.6.22/init/main.c
> @@ -438,6 +438,8 @@ static void noinline __init_refok rest_i
>  {
>  	int pid;
>  
> +	system_state = SYSTEM_BOOTING_SCHEDULER_OK;
> +
>  	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
> --- linux-2.6.22.orig/lib/kernel_lock.c
> +++ linux-2.6.22/lib/kernel_lock.c
> @@ -35,22 +35,25 @@ DECLARE_MUTEX(kernel_sem);
>   * about recursion, both due to the down() and due to the enabling of
>   * preemption. schedule() will re-check the preemption flag after
>   * reacquiring the semaphore.
> + *
> + * Called with interrupts disabled.
>   */
>  int __lockfunc __reacquire_kernel_lock(void)
>  {
>  	struct task_struct *task = current;
>  	int saved_lock_depth = task->lock_depth;
>  
> +	local_irq_enable();
>  	BUG_ON(saved_lock_depth < 0);
>  
>  	task->lock_depth = -1;
> -	__preempt_enable_no_resched();
>  
>  	down(&kernel_sem);
>  
> -	preempt_disable();
>  	task->lock_depth = saved_lock_depth;
>  
> +	local_irq_disable();
> +
>  	return 0;
>  }
>  
> @@ -67,11 +70,15 @@ void __lockfunc lock_kernel(void)
>  	struct task_struct *task = current;
>  	int depth = task->lock_depth + 1;
>  
> -	if (likely(!depth))
> +	if (likely(!depth)) {
>  		/*
>  		 * No recursion worries - we set up lock_depth _after_
>  		 */
>  		down(&kernel_sem);
> +#ifdef CONFIG_DEBUG_RT_MUTEXES
> +		current->last_kernel_lock = __builtin_return_address(0);
> +#endif
> +	}
>  
>  	task->lock_depth = depth;
>  }
> @@ -82,8 +89,12 @@ void __lockfunc unlock_kernel(void)
>  
>  	BUG_ON(task->lock_depth < 0);
>  
> -	if (likely(--task->lock_depth < 0))
> +	if (likely(--task->lock_depth == -1)) {
> +#ifdef CONFIG_DEBUG_RT_MUTEXES
> +		current->last_kernel_lock = NULL;
> +#endif
>  		up(&kernel_sem);
> +	}
>  }
>  
>  #else
> @@ -116,11 +127,9 @@ static  __cacheline_aligned_in_smp DEFIN
>   */
>  int __lockfunc __reacquire_kernel_lock(void)
>  {
> -	while (!_raw_spin_trylock(&kernel_flag)) {
> -		if (test_thread_flag(TIF_NEED_RESCHED))
> -			return -EAGAIN;
> -		cpu_relax();
> -	}
> +	local_irq_enable();
> +	_raw_spin_lock(&kernel_flag);
> +	local_irq_disable();
>  	preempt_disable();
>  	return 0;
>  }
> :: end preempt-realtime-sched.patch ::
> :: start preempt-realtime-core.patch ::
> diff -u linux-rt-rebase.q/include/linux/kernel.h linux-2.6.22/include/linux/kernel.h
> --- linux-rt-rebase.q/include/linux/kernel.h
> +++ linux-2.6.22/include/linux/kernel.h	2007-07-27 01:32:15.000000000 +0000
> @@ -88,7 +88,7 @@
>  # define might_resched() do { } while (0)
>  #endif
>  
> -#if defined(CONFIG_DEBUG_SPINLOCK_SLEEP) || defined(CONFIG_DEBUG_PREEMPT)
> +#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
>    void __might_sleep(char *file, int line);
>  # define might_sleep() \
>  	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
> @@ -210,7 +210,6 @@
>  /* Values used for system_state */
>  extern enum system_states {
>  	SYSTEM_BOOTING,
> -	SYSTEM_BOOTING_SCHEDULER_OK,
>  	SYSTEM_RUNNING,
>  	SYSTEM_HALT,
>  	SYSTEM_POWER_OFF,
> reverted:
> --- linux-rt-rebase.q/include/linux/smp.h
> +++ linux-rt-rebase.q.orig/include/linux/smp.h
> @@ -33,16 +33,6 @@
>   */
>  extern void smp_send_reschedule(int cpu);
>  
> -/*
> - * trigger a reschedule on all other CPUs:
> - */
> -extern void smp_send_reschedule_allbutself(void);
> -
> -/*
> - * trigger a reschedule on all other CPUs:
> - */
> -extern void smp_send_reschedule_allbutself(void);
> -
>  
>  /*
>   * Prepare machine for booting other CPUs.
> @@ -107,7 +97,6 @@
>  		0;				\
>  	})
>  static inline void smp_send_reschedule(int cpu) { }
> -static inline void smp_send_reschedule_allbutself(void) { }
>  #define num_booting_cpus()			1
>  #define smp_prepare_boot_cpu()			do {} while (0)
>  #define smp_call_function_single(cpuid, func, info, retry, wait) \
> reverted:
> --- linux-rt-rebase.q/lib/kernel_lock.c
> +++ linux-rt-rebase.q.orig/lib/kernel_lock.c
> @@ -35,25 +35,22 @@
>   * about recursion, both due to the down() and due to the enabling of
>   * preemption. schedule() will re-check the preemption flag after
>   * reacquiring the semaphore.
> - *
> - * Called with interrupts disabled.
>   */
>  int __lockfunc __reacquire_kernel_lock(void)
>  {
>  	struct task_struct *task = current;
>  	int saved_lock_depth = task->lock_depth;
>  
> -	local_irq_enable();
>  	BUG_ON(saved_lock_depth < 0);
>  
>  	task->lock_depth = -1;
> +	__preempt_enable_no_resched();
>  
>  	down(&kernel_sem);
>  
> +	preempt_disable();
>  	task->lock_depth = saved_lock_depth;
>  
> -	local_irq_disable();
> -
>  	return 0;
>  }
>  
> @@ -70,15 +67,11 @@
>  	struct task_struct *task = current;
>  	int depth = task->lock_depth + 1;
>  
> +	if (likely(!depth))
> -	if (likely(!depth)) {
>  		/*
>  		 * No recursion worries - we set up lock_depth _after_
>  		 */
>  		down(&kernel_sem);
> -#ifdef CONFIG_DEBUG_RT_MUTEXES
> -		current->last_kernel_lock = __builtin_return_address(0);
> -#endif
> -	}
>  
>  	task->lock_depth = depth;
>  }
> @@ -89,12 +82,8 @@
>  
>  	BUG_ON(task->lock_depth < 0);
>  
> +	if (likely(--task->lock_depth < 0))
> -	if (likely(--task->lock_depth == -1)) {
> -#ifdef CONFIG_DEBUG_RT_MUTEXES
> -		current->last_kernel_lock = NULL;
> -#endif
>  		up(&kernel_sem);
> -	}
>  }
>  
>  #else
> @@ -127,9 +116,11 @@
>   */
>  int __lockfunc __reacquire_kernel_lock(void)
>  {
> +	while (!_raw_spin_trylock(&kernel_flag)) {
> +		if (test_thread_flag(TIF_NEED_RESCHED))
> +			return -EAGAIN;
> +		cpu_relax();
> +	}
> -	local_irq_enable();
> -	_raw_spin_lock(&kernel_flag);
> -	local_irq_disable();
>  	preempt_disable();
>  	return 0;
>  }
> :: end preempt-realtime-core.patch ::
> :: start preempt-realtime-init-show-enabled-debugs.patch ::
> diff -u linux-rt-rebase.q/init/main.c linux-2.6.22/init/main.c
> --- linux-rt-rebase.q/init/main.c
> +++ linux-2.6.22/init/main.c	2007-07-27 01:22:46.000000000 +0000
> @@ -438,8 +438,6 @@
>  {
>  	int pid;
>  
> -	system_state = SYSTEM_BOOTING_SCHEDULER_OK;
> -
>  	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
> :: end preempt-realtime-init-show-enabled-debugs.patch ::
> :: start schedule_on_each_cpu-enhance.patch ::
> diff -u linux-rt-rebase.q/kernel/workqueue.c linux-2.6.22/kernel/workqueue.c
> --- linux-rt-rebase.q/kernel/workqueue.c
> +++ linux-2.6.22/kernel/workqueue.c	2007-07-29 00:41:17.000000000 +0000
> @@ -647,6 +647,7 @@
>  
>  	return err;
>  }
> +EXPORT_SYMBOL(schedule_on_each_cpu);
>  
>  /**
>   * schedule_on_each_cpu_wq - call a function on each online CPU on a per-CPU wq
> :: end schedule_on_each_cpu-enhance.patch ::
> :: start version.patch ::
> reverted:
> --- linux-rt-rebase.q/kernel/workqueue.c
> +++ linux-rt-rebase.q.orig/kernel/workqueue.c
> @@ -647,7 +647,6 @@
>  
>  	return err;
>  }
> -EXPORT_SYMBOL(schedule_on_each_cpu);
>  
>  /**
>   * schedule_on_each_cpu_wq - call a function on each online CPU on a per-CPU wq
> :: end version.patch ::
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

