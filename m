Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbXGNQto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbXGNQto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXGNQtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:49:36 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:59680 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348AbXGNQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:49:34 -0400
Date: Sat, 14 Jul 2007 12:49:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 2/5] Thread Migration Preemption - v2
Message-ID: <20070714164925.GA6975@Krystal>
References: <20070714175733.194012000@chello.nl> <20070714175839.641246000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714175839.641246000@chello.nl>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:48:46 up 7 days,  6:54,  2 users,  load average: 0.22, 0.16, 0.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, testers for this patch will be welcome.. it runs fine on my system,
but I have not tested the CPU hotplug corner cases.

Mathieu

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> This patch adds the ability to protect critical sections from migration to
> another CPU without disabling preemption.
> 
> This will be useful to minimize the amount of preemption disabling for the -rt
> patch. It will help leveraging improvements brought by the local_t types in
> asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> variables protected by migrate_disable must be either atomic or protected from
> concurrent updates done by other threads.
> 
> Typical use:
> 
> migrate_disable();
> local_inc(&__get_cpu_var(&my_local_t_var));
> migrate_enable();
> 
> Which will increment the variable atomically wrt the local CPU.
> 
> Changes:
> 
> Do a check_migrate() upon migrate_enable() to answer to the migration
> thread waiting for us to exit the migration disabled critical section. Use a
> NEED_MIGRATE thread flag for this.
> 
> Note: (or we could say FIXME)
> Is we ever want to check migration pending in assembly code, we will have to
> make sure we test the right thread flag bits on each architectures. Care should
> also be taken to check that the thread flags used won't trigger false positives
> in non selective asm thread flag checks.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/asm-alpha/thread_info.h     |    3 +
>  include/asm-arm/thread_info.h       |    5 +
>  include/asm-arm26/thread_info.h     |    5 +
>  include/asm-avr32/thread_info.h     |    4 +
>  include/asm-blackfin/thread_info.h  |    4 +
>  include/asm-cris/thread_info.h      |    4 +
>  include/asm-frv/thread_info.h       |    4 +
>  include/asm-h8300/thread_info.h     |    4 +
>  include/asm-i386/thread_info.h      |    6 +-
>  include/asm-ia64/thread_info.h      |    4 +
>  include/asm-m32r/thread_info.h      |    4 +
>  include/asm-m68k/thread_info.h      |    2 
>  include/asm-m68knommu/thread_info.h |    3 +
>  include/asm-mips/thread_info.h      |    4 +
>  include/asm-parisc/thread_info.h    |    4 +
>  include/asm-powerpc/thread_info.h   |    4 +
>  include/asm-s390/thread_info.h      |    4 +
>  include/asm-sh/thread_info.h        |    4 +
>  include/asm-sh64/thread_info.h      |    4 +
>  include/asm-sparc/thread_info.h     |    4 +
>  include/asm-sparc64/thread_info.h   |    5 +
>  include/asm-um/thread_info.h        |    4 +
>  include/asm-v850/thread_info.h      |    4 +
>  include/asm-x86_64/thread_info.h    |    4 +
>  include/asm-xtensa/thread_info.h    |    4 +
>  include/linux/preempt.h             |   44 +++++++++++++++++
>  kernel/sched.c                      |   91 +++++++++++++++++++++++++++++++++---
>  lib/smp_processor_id.c              |    6 +-
>  28 files changed, 230 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/include/asm-i386/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-i386/thread_info.h
> +++ linux-2.6/include/asm-i386/thread_info.h
> @@ -31,8 +31,7 @@ struct thread_info {
>  	unsigned long		status;		/* thread-synchronous flags */
>  	__u32			cpu;		/* current CPU */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> -
> -
> +	int			migrate_count;/* 0: can migrate, <0: BUG */
>  	mm_segment_t		addr_limit;	/* thread address space:
>  					 	   0-0xBFFFFFFF for user-thead
>  						   0-0xFFFFFFFF for kernel-thread
> @@ -74,6 +73,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.restart_block = {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -134,6 +134,7 @@ static inline struct thread_info *curren
>  #define TIF_SECCOMP		8	/* secure computing */
>  #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
>  #define TIF_NEED_RESCHED_DELAYED 10	/* reschedule on return to userspace */
> +#define TIF_NEED_MIGRATE	11	/* migration necessary */
>  #define TIF_MEMDIE		16
>  #define TIF_DEBUG		17	/* uses debug registers */
>  #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
> @@ -151,6 +152,7 @@ static inline struct thread_info *curren
>  #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
>  #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_DEBUG		(1<<TIF_DEBUG)
>  #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
>  #define _TIF_FREEZE		(1<<TIF_FREEZE)
> Index: linux-2.6/include/linux/preempt.h
> ===================================================================
> --- linux-2.6.orig/include/linux/preempt.h
> +++ linux-2.6/include/linux/preempt.h
> @@ -15,6 +15,8 @@
>    extern void notrace sub_preempt_count(unsigned int val);
>    extern void notrace mask_preempt_count(unsigned int mask);
>    extern void notrace unmask_preempt_count(unsigned int mask);
> +  extern void fastcall add_migrate_count(int val);
> +  extern void fastcall sub_migrate_count(int val);
>  #else
>  # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
>  # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
> @@ -22,6 +24,8 @@
>  		do { preempt_count() |= (mask); } while (0)
>  # define unmask_preempt_count(mask) \
>  		do { preempt_count() &= ~(mask); } while (0)
> +# define add_migrate_count(val) do { migrate_count() += (val); } while (0)
> +# define sub_migrate_count(val) do { migrate_count() -= (val); } while (0)
>  #endif
>  
>  #ifdef CONFIG_CRITICAL_TIMING
> @@ -35,7 +39,12 @@
>  #define inc_preempt_count() add_preempt_count(1)
>  #define dec_preempt_count() sub_preempt_count(1)
>  
> -#define preempt_count()		(current_thread_info()->preempt_count)
> +#define preempt_count() (current_thread_info()->preempt_count)
> +
> +#define inc_migrate_count() add_migrate_count(1)
> +#define dec_migrate_count() sub_migrate_count(1)
> +
> +#define migrate_count() (current_thread_info()->migrate_count)
>  
>  #ifdef CONFIG_PREEMPT
>  
> @@ -80,6 +89,36 @@ do { \
>  	preempt_check_resched(); \
>  } while (0)
>  
> +#define migrate_disable() \
> +do { \
> +	inc_migrate_count(); \
> +	barrier(); \
> +} while (0)
> +
> +#define migrate_enable_no_check() \
> +do { \
> +	barrier(); \
> +	dec_migrate_count(); \
> +} while (0)
> +
> +#ifdef CONFIG_SMP
> +extern void do_check_migrate(void);
> +#define check_migrate() \
> +do { \
> +	if (unlikely(test_thread_flag(TIF_NEED_MIGRATE))) \
> +		do_check_migrate(); \
> +} while (0)
> +#else
> +#define check_migrate()
> +#endif
> +
> +#define migrate_enable() \
> +do { \
> +	migrate_enable_no_check(); \
> +	barrier(); \
> +	check_migrate(); \
> +} while (0)
> +
>  #else
>  
>  #define preempt_disable()		do { } while (0)
> @@ -91,6 +130,9 @@ do { \
>  
>  #define preempt_schedule_irq()		do { } while (0)
>  
> +#define migrate_disable()		do { } while (0)
> +#define migrate_enable()		do { } while (0)
> +
>  #endif
>  
>  #endif /* __LINUX_PREEMPT_H */
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -1175,7 +1175,8 @@ migrate_task(struct task_struct *p, int 
>  	 * If the task is not on a runqueue (and not running), then
>  	 * it is sufficient to simply update the task's cpu field.
>  	 */
> -	if (!p->se.on_rq && !task_running(rq, p)) {
> +	if (!p->se.on_rq && !task_running(rq, p)
> +			&& !task_thread_info(p)->migrate_count) {
>  		set_task_cpu(p, dest_cpu);
>  		return 0;
>  	}
> @@ -1506,6 +1507,29 @@ static void balance_rt_tasks(struct rq *
>  
>  #endif
>  
> +void fastcall add_migrate_count(int val)
> +{
> +	/*
> +	 * Underflow?
> +	 */
> +	if (DEBUG_LOCKS_WARN_ON((migrate_count() < 0)))
> +		return;
> +	migrate_count() += val;
> +}
> +EXPORT_SYMBOL(add_migrate_count);
> +
> +void fastcall sub_migrate_count(int val)
> +{
> +	/*
> +	 * Underflow?
> +	 */
> +	if (DEBUG_LOCKS_WARN_ON(val > migrate_count()))
> +		return;
> +
> +	migrate_count() -= val;
> +}
> +EXPORT_SYMBOL(sub_migrate_count);
> +
>  /*
>   * find_idlest_cpu - find the idlest cpu among the cpus in group.
>   */
> @@ -1696,7 +1720,10 @@ try_to_wake_up(struct task_struct *p, un
>  #ifdef CONFIG_SMP
>  	if (unlikely(task_running(rq, p)))
>  		goto out_activate;
> -
> +#ifdef CONFIG_PREEMPT
> +	if (task_thread_info(p)->migrate_count)
> +		goto out_activate;
> +#endif
>  	new_cpu = cpu;
>  
>  	schedstat_inc(rq, ttwu_cnt);
> @@ -1970,6 +1997,7 @@ void sched_fork(struct task_struct *p, i
>  #ifdef CONFIG_PREEMPT
>  	/* Want to start with kernel preemption disabled. */
>  	task_thread_info(p)->preempt_count = 1;
> +	task_thread_info(p)->migrate_count = 0;
>  #endif
>  	put_cpu();
>  }
> @@ -2435,6 +2463,10 @@ static void sched_migrate_task(struct ta
>  	if (!cpu_isset(dest_cpu, p->cpus_allowed)
>  	    || unlikely(cpu_is_offline(dest_cpu)))
>  		goto out;
> +#ifdef CONFIG_PREEMPT
> +	if (task_thread_info(p)->migrate_count)
> +		goto out;
> +#endif
>  
>  	/* force the process onto the specified CPU */
>  	if (migrate_task(p, dest_cpu, &req)) {
> @@ -2496,6 +2528,7 @@ int can_migrate_task(struct task_struct 
>  	 * 1) running (obviously), or
>  	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
>  	 * 3) are cache-hot on their current CPU.
> +	 * 4) migration preemption is non 0 for this non running task.
>  	 */
>  	if (!cpu_isset(this_cpu, p->cpus_allowed))
>  		return 0;
> @@ -2503,6 +2536,10 @@ int can_migrate_task(struct task_struct 
>  
>  	if (task_running(rq, p))
>  		return 0;
> +#ifdef CONFIG_PREEMPT
> +	if (task_thread_info(p)->migrate_count)
> +		return 0;
> +#endif
>  
>  	/*
>  	 * Aggressive migration if too many balance attempts have failed:
> @@ -3822,6 +3859,27 @@ EXPORT_SYMBOL(schedule);
>  
>  #ifdef CONFIG_PREEMPT
>  
> +#ifdef CONFIG_SMP
> +/*
> + * Wake up the migration thread to deal with our pending migration.
> + * If we have been moved since, we will just wake up the migration thread from
> + * the wrong CPU, which does not hurt anyone. (that's why we use
> + * raw_smp_processor_id()).
> + */
> +void __sched do_check_migrate(void)
> +{
> +	struct rq *rq;
> +
> +	if (migrate_count())
> +		return;
> +
> +	clear_thread_flag(TIF_NEED_MIGRATE);
> +	rq = cpu_rq(raw_smp_processor_id());
> +	wake_up_process(rq->migration_thread);
> +}
> +EXPORT_SYMBOL(do_check_migrate);
> +#endif
> +
>  /*
>   * Global flag to turn preemption off on a CONFIG_PREEMPT kernel:
>   */
> @@ -5478,7 +5536,7 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed);
>   * So we race with normal scheduler movements, but that's OK, as long
>   * as the task is no longer on this CPU.
>   *
> - * Returns non-zero if task was successfully migrated.
> + * Returns non-zero if task is on dest_cpu when this function ends.
>   */
>  static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>  {
> @@ -5500,13 +5558,19 @@ static int __migrate_task(struct task_st
>  
>  	double_rq_lock(rq_src, rq_dest);
>  	/* Already moved. */
> -	if (task_cpu(p) != src_cpu)
> +	if (task_cpu(p) != src_cpu) {
> +		ret = 1;
>  		goto out;
> +	}
>  	/* Affinity changed (again). */
>  	if (!cpu_isset(dest_cpu, p->cpus_allowed))
>  		goto out;
>  
>  	on_rq = p->se.on_rq;
> +#ifdef CONFIG_PREEMPT
> +	if (!on_rq && task_thread_info(p)->migrate_count)
> +		goto out;
> +#endif
>  	if (on_rq)
>  		deactivate_task(rq_src, p, 0);
>  
> @@ -5532,6 +5596,7 @@ static int migration_thread(void *data)
>  {
>  	int cpu = (long)data;
>  	struct rq *rq;
> +	int migrated;
>  
>  	rq = cpu_rq(cpu);
>  	BUG_ON(rq->migration_thread != current);
> @@ -5567,10 +5632,22 @@ static int migration_thread(void *data)
>  		list_del_init(head->next);
>  
>  		spin_unlock(&rq->lock);
> -		__migrate_task(req->task, cpu, req->dest_cpu);
> +		migrated = __migrate_task(req->task, cpu, req->dest_cpu);
>  		local_irq_enable();
> -
> -		complete(&req->done);
> +		if (!migrated) {
> +			/*
> +			 * If the process has not been migrated, let it run
> +			 * until it reaches a migration_check() so it can
> +			 * wake us up.
> +			 */
> +			spin_lock_irq(&rq->lock);
> +			head = &rq->migration_queue;
> +			list_add(&req->list, head);
> +			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
> +			spin_unlock_irq(&rq->lock);
> +			wake_up_process(req->task);
> +		} else
> +			complete(&req->done);
>  	}
>  	__set_current_state(TASK_RUNNING);
>  	return 0;
> Index: linux-2.6/include/asm-alpha/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-alpha/thread_info.h
> +++ linux-2.6/include/asm-alpha/thread_info.h
> @@ -21,6 +21,7 @@ struct thread_info {
>  	mm_segment_t		addr_limit;	/* thread address space */
>  	unsigned		cpu;		/* current CPU */
>  	int			preempt_count; /* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  
>  	int bpt_nsaved;
>  	unsigned long bpt_addr[2];		/* breakpoint handling  */
> @@ -77,6 +78,7 @@ register struct thread_info *__current_t
>  #define TIF_UAC_SIGBUS		8
>  #define TIF_MEMDIE		9
>  #define TIF_RESTORE_SIGMASK	10	/* restore signal mask in do_signal */
> +#define TIF_NEED_MIGRATE	11	/* migration necessary */
>  
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
> @@ -84,6 +86,7 @@ register struct thread_info *__current_t
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  
>  /* Work to do on interrupt/exception return.  */
>  #define _TIF_WORK_MASK		(_TIF_NOTIFY_RESUME	\
> Index: linux-2.6/include/asm-arm/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-arm/thread_info.h
> +++ linux-2.6/include/asm-arm/thread_info.h
> @@ -51,6 +51,7 @@ struct cpu_context_save {
>  struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	int			preempt_count;	/* 0 => preemptable, <0 => bug */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	mm_segment_t		addr_limit;	/* address limit */
>  	struct task_struct	*task;		/* main task structure */
>  	struct exec_domain	*exec_domain;	/* execution domain */
> @@ -72,6 +73,7 @@ struct thread_info {
>  	.exec_domain	= &default_exec_domain,				\
>  	.flags		= 0,						\
>  	.preempt_count	= 1,						\
> +	.migrate_count = 0,						\
>  	.addr_limit	= KERNEL_DS,					\
>  	.cpu_domain	= domain_val(DOMAIN_USER, DOMAIN_MANAGER) |	\
>  			  domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) |	\
> @@ -138,6 +140,7 @@ extern void iwmmxt_task_switch(struct th
>   *  TIF_NOTIFY_RESUME	- resumption notification requested
>   *  TIF_SIGPENDING	- signal pending
>   *  TIF_NEED_RESCHED	- rescheduling necessary
> + *  TIF_NEED_MIGRATE	- migration necessary
>   *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
>   *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
>   */
> @@ -145,6 +148,7 @@ extern void iwmmxt_task_switch(struct th
>  #define TIF_SIGPENDING		1
>  #define TIF_NEED_RESCHED	2
>  #define TIF_NEED_RESCHED_DELAYED 3
> +#define TIF_NEED_MIGRATE	4
>  #define TIF_SYSCALL_TRACE	8
>  #define TIF_POLLING_NRFLAG	16
>  #define TIF_USING_IWMMXT	17
> @@ -155,6 +159,7 @@ extern void iwmmxt_task_switch(struct th
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_NEED_RESCHED_DELAYED (1<<TIF_NEED_RESCHED_DELAYED)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
>  #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
> Index: linux-2.6/include/asm-arm26/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-arm26/thread_info.h
> +++ linux-2.6/include/asm-arm26/thread_info.h
> @@ -45,6 +45,7 @@ struct cpu_context_save {
>  struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	int			preempt_count;	/* 0 => preemptable, <0 => bug */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	mm_segment_t		addr_limit;	/* address limit */
>  	struct task_struct	*task;		/* main task structure */
>  	struct exec_domain      *exec_domain;   /* execution domain */
> @@ -60,6 +61,7 @@ struct thread_info {
>  	.exec_domain	&default_exec_domain,	\
>  	.flags		0,			\
>  	.preempt_count	0,			\
> +	.migrate_count 0,			\
>  	.addr_limit	KERNEL_DS,		\
>  	.restart_block  = {                             \
>  		.fn     = do_no_restart_syscall,        \
> @@ -113,12 +115,14 @@ extern void free_thread_info(struct thre
>   *  TIF_NOTIFY_RESUME	- resumption notification requested
>   *  TIF_SIGPENDING	- signal pending
>   *  TIF_NEED_RESCHED	- rescheduling necessary
> + *  TIF_NEED_MIGRATE	- migration necessary
>   *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
>   *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
>   */
>  #define TIF_NOTIFY_RESUME	0
>  #define TIF_SIGPENDING		1
>  #define TIF_NEED_RESCHED	2
> +#define TIF_NEED_MIGRATE	3
>  #define TIF_SYSCALL_TRACE	8
>  #define TIF_USED_FPU		16
>  #define TIF_POLLING_NRFLAG	17
> @@ -127,6 +131,7 @@ extern void free_thread_info(struct thre
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_USED_FPU		(1 << TIF_USED_FPU)
>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
> Index: linux-2.6/include/asm-avr32/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-avr32/thread_info.h
> +++ linux-2.6/include/asm-avr32/thread_info.h
> @@ -25,6 +25,7 @@ struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	__u32			cpu;
>  	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	struct restart_block	restart_block;
>  	__u8			supervisor_stack[0];
>  };
> @@ -36,6 +37,7 @@ struct thread_info {
>  	.flags		= 0,						\
>  	.cpu		= 0,						\
>  	.preempt_count	= 1,						\
> +	.migrate_count = 0,						\
>  	.restart_block	= {						\
>  		.fn	= do_no_restart_syscall				\
>  	}								\
> @@ -84,6 +86,7 @@ static inline struct thread_info *curren
>  #define TIF_MEMDIE		7
>  #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal */
>  #define TIF_CPU_GOING_TO_SLEEP	9	/* CPU is entering sleep 0 mode */
> +#define TIF_NEED_MIGRATE      10       /* migration necessary */
>  #define TIF_USERSPACE		31      /* true if FS sets userspace */
>  
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
> @@ -96,6 +99,7 @@ static inline struct thread_info *curren
>  #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
>  #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  
>  /* XXX: These two masks must never span more than 16 bits! */
>  /* work to do on interrupt/exception return */
> Index: linux-2.6/include/asm-blackfin/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-blackfin/thread_info.h
> +++ linux-2.6/include/asm-blackfin/thread_info.h
> @@ -54,6 +54,7 @@ struct thread_info {
>  	unsigned long flags;	/* low level flags */
>  	int cpu;		/* cpu we're on */
>  	int preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int migrate_count;	/* 0: can migrate, <0 => BUG */
>  	mm_segment_t addr_limit;	/* address limit */
>  	struct restart_block restart_block;
>  	struct l1_scratch_task_info l1_task_info;
> @@ -69,6 +70,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count  = 1,                    \
> +	.migrate_count = 0,			\
>  	.restart_block	= {			\
>  		.fn = do_no_restart_syscall,	\
>  	},					\
> @@ -126,6 +128,7 @@ static inline struct thread_info *curren
>  #define TIF_MEMDIE              5
>  #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
>  #define TIF_FREEZE              7       /* is freezing for suspend */
> +#define TIF_NEED_MIGRATE	8	/* migration necessary */
>  
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -135,6 +138,7 @@ static inline struct thread_info *curren
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>  #define _TIF_FREEZE             (1<<TIF_FREEZE)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  
>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>  
> Index: linux-2.6/include/asm-cris/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-cris/thread_info.h
> +++ linux-2.6/include/asm-cris/thread_info.h
> @@ -32,6 +32,7 @@ struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	__u32			cpu;		/* current CPU */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  
>  	mm_segment_t		addr_limit;	/* thread address space:
>  					 	   0-0xBFFFFFFF for user-thead
> @@ -58,6 +59,7 @@ struct thread_info {
>  	.flags		= 0,				\
>  	.cpu		= 0,				\
>  	.preempt_count	= 1,				\
> +	.migrate_count = 0,				\
>  	.addr_limit	= KERNEL_DS,			\
>  	.restart_block = {				\
>  		       .fn = do_no_restart_syscall,	\
> @@ -82,6 +84,7 @@ struct thread_info {
>  #define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
>  #define TIF_SIGPENDING		2	/* signal pending */
>  #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
> +#define TIF_NEED_MIGRATE	4	/* migration necessary */
>  #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		17
>  
> @@ -90,6 +93,7 @@ struct thread_info {
>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  
>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>  #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
> Index: linux-2.6/include/asm-frv/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-frv/thread_info.h
> +++ linux-2.6/include/asm-frv/thread_info.h
> @@ -36,6 +36,7 @@ struct thread_info {
>  	unsigned long		status;		/* thread-synchronous flags */
>  	__u32			cpu;		/* current CPU */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  
>  	mm_segment_t		addr_limit;	/* thread address space:
>  					 	   0-0xBFFFFFFF for user-thead
> @@ -68,6 +69,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.restart_block = {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -114,6 +116,7 @@ register struct thread_info *__current_t
>  #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
>  #define TIF_IRET		5	/* return with iret */
>  #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
> +#define TIF_NEED_MIGRATE	7	/* migration necessary */
>  #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		17	/* OOM killer killed process */
>  #define TIF_FREEZE		18	/* freezing for suspend */
> @@ -127,6 +130,7 @@ register struct thread_info *__current_t
>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
>  #define _TIF_FREEZE		(1 << TIF_FREEZE)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  
>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>  #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
> Index: linux-2.6/include/asm-h8300/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-h8300/thread_info.h
> +++ linux-2.6/include/asm-h8300/thread_info.h
> @@ -24,6 +24,7 @@ struct thread_info {
>  	unsigned long	   flags;		/* low level flags */
>  	int		   cpu;			/* cpu we're on */
>  	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	struct restart_block restart_block;
>  };
>  
> @@ -37,6 +38,7 @@ struct thread_info {
>  	.flags =	0,			\
>  	.cpu =		0,			\
>  	.preempt_count = 1,			\
> +	.migrate_count = 0,			\
>  	.restart_block	= {			\
>  		.fn = do_no_restart_syscall,	\
>  	},					\
> @@ -92,6 +94,7 @@ static inline struct thread_info *curren
>  #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
>  					   TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		5
> +#define TIF_NEED_MIGRATE	6	/* migration necessary */
>  
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -99,6 +102,7 @@ static inline struct thread_info *curren
>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  
>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>  
> Index: linux-2.6/include/asm-ia64/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-ia64/thread_info.h
> +++ linux-2.6/include/asm-ia64/thread_info.h
> @@ -30,6 +30,7 @@ struct thread_info {
>  	__u32 status;			/* Thread synchronous flags */
>  	mm_segment_t addr_limit;	/* user-level address space limit */
>  	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
> +	int migrate_count;		/* 0: can migrate, <0 => BUG */
>  	struct restart_block restart_block;
>  };
>  
> @@ -43,6 +44,7 @@ struct thread_info {
>  	.cpu		= 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.preempt_count	= 0,			\
> +	.migrate_count = 0,			\
>  	.restart_block = {			\
>  		.fn = do_no_restart_syscall,	\
>  	},					\
> @@ -86,6 +88,7 @@ struct thread_info {
>  #define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
>  #define TIF_SINGLESTEP		5	/* restore singlestep on return to user mode */
>  #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
> +#define TIF_NEED_MIGRATE	7	/* migration necessary */
>  #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		17
>  #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
> @@ -99,6 +102,7 @@ struct thread_info {
>  #define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
> Index: linux-2.6/include/asm-m32r/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-m32r/thread_info.h
> +++ linux-2.6/include/asm-m32r/thread_info.h
> @@ -29,6 +29,7 @@ struct thread_info {
>  	unsigned long		status;		/* thread-synchronous flags */
>  	__u32			cpu;		/* current CPU */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  
>  	mm_segment_t		addr_limit;	/* thread address space:
>  					 	   0-0xBFFFFFFF for user-thread
> @@ -69,6 +70,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.restart_block = {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -151,6 +153,7 @@ static inline unsigned int get_thread_fa
>  #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
>  #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
>  #define TIF_IRET		5	/* return with iret */
> +#define TIF_NEED_MIGRATE	6	/* migration necessary */
>  #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>  					/* 31..28 fault code */
>  #define TIF_MEMDIE		17
> @@ -162,6 +165,7 @@ static inline unsigned int get_thread_fa
>  #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
>  #define _TIF_IRET		(1<<TIF_IRET)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  
>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>  #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
> Index: linux-2.6/include/asm-m68k/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-m68k/thread_info.h
> +++ linux-2.6/include/asm-m68k/thread_info.h
> @@ -9,6 +9,7 @@ struct thread_info {
>  	unsigned long		flags;
>  	struct exec_domain	*exec_domain;	/* execution domain */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	__u32 cpu; /* should always be 0 on m68k */
>  	struct restart_block    restart_block;
>  };
> @@ -58,5 +59,6 @@ struct thread_info {
>  #define TIF_DELAYED_TRACE	14	/* single step a syscall */
>  #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
>  #define TIF_MEMDIE		16
> +#define TIF_NEED_MIGRATE	17	/* migration necessary */
>  
>  #endif	/* _ASM_M68K_THREAD_INFO_H */
> Index: linux-2.6/include/asm-m68knommu/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-m68knommu/thread_info.h
> +++ linux-2.6/include/asm-m68knommu/thread_info.h
> @@ -37,6 +37,7 @@ struct thread_info {
>  	unsigned long	   flags;		/* low level flags */
>  	int		   cpu;			/* cpu we're on */
>  	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int		   migrate_count;	/* 0: can migrate, <0 => BUG */
>  	struct restart_block restart_block;
>  };
>  
> @@ -89,6 +90,7 @@ static inline struct thread_info *curren
>  #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
>  					   TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		5
> +#define TIF_NEED_MIGRATE	6	/* migration necessary */
>  
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -96,6 +98,7 @@ static inline struct thread_info *curren
>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  
>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>  
> Index: linux-2.6/include/asm-mips/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-mips/thread_info.h
> +++ linux-2.6/include/asm-mips/thread_info.h
> @@ -28,6 +28,7 @@ struct thread_info {
>  	unsigned long		tp_value;	/* thread pointer */
>  	__u32			cpu;		/* current CPU */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  
>  	mm_segment_t		addr_limit;	/* thread address space:
>  						   0-0xBFFFFFFF for user-thead
> @@ -49,6 +50,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.restart_block	= {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -115,6 +117,7 @@ register struct thread_info *__current_t
>  #define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
>  #define TIF_SECCOMP		5	/* secure computing */
>  #define TIF_NEED_RESCHED_DELAYED 6	/* reschedule on return to userspace */
> +#define TIF_NEED_MIGRATE	7	/* migration necessary */
>  #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
>  #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
>  #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
> @@ -129,6 +132,7 @@ register struct thread_info *__current_t
>  #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
>  #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
>  #define _TIF_NEED_RESCHED_DELAYED (1<<TIF_NEED_RESCHED_DELAYED)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>  #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> Index: linux-2.6/include/asm-parisc/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-parisc/thread_info.h
> +++ linux-2.6/include/asm-parisc/thread_info.h
> @@ -13,6 +13,7 @@ struct thread_info {
>  	mm_segment_t addr_limit;	/* user-level address space limit */
>  	__u32 cpu;			/* current CPU */
>  	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
> +	int migrate_count;		/* 0: can migrate, <0 => BUG */
>  	struct restart_block restart_block;
>  };
>  
> @@ -24,6 +25,7 @@ struct thread_info {
>  	.cpu		= 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>    	.restart_block	= {			\
>  		.fn = do_no_restart_syscall	\
>  	}					\
> @@ -63,6 +65,7 @@ struct thread_info {
>  #define TIF_32BIT               5       /* 32 bit binary */
>  #define TIF_MEMDIE		6
>  #define TIF_RESTORE_SIGMASK	7	/* restore saved signal mask */
> +#define TIF_NEED_MIGRATE	8	/* migration necessary */
>  
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> @@ -71,6 +74,7 @@ struct thread_info {
>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
>  #define _TIF_32BIT		(1 << TIF_32BIT)
>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  
>  #define _TIF_USER_WORK_MASK     (_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | \
>                                   _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
> Index: linux-2.6/include/asm-powerpc/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/thread_info.h
> +++ linux-2.6/include/asm-powerpc/thread_info.h
> @@ -35,6 +35,7 @@ struct thread_info {
>  	int		cpu;			/* cpu we're on */
>  	int		preempt_count;		/* 0 => preemptable,
>  						   <0 => BUG */
> +	int		migrate_count;	/* 0: can migrate, <0 => BUG */
>  	struct restart_block restart_block;
>  	unsigned long	local_flags;		/* private flags for thread */
>  
> @@ -53,6 +54,7 @@ struct thread_info {
>  	.exec_domain =	&default_exec_domain,	\
>  	.cpu =		0,			\
>  	.preempt_count = 1,			\
> +	.migrate_count = 0,			\
>  	.restart_block = {			\
>  		.fn = do_no_restart_syscall,	\
>  	},					\
> @@ -124,6 +126,7 @@ static inline struct thread_info *curren
>  #define TIF_NOERROR		14	/* Force successful syscall return */
>  #define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
>  #define TIF_FREEZE		16	/* Freezing for suspend */
> +#define TIF_NEED_MIGRATE	17	/* migration necessary */
>  
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -143,6 +146,7 @@ static inline struct thread_info *curren
>  #define _TIF_FREEZE		(1<<TIF_FREEZE)
>  #define _TIF_NEED_RESCHED_DELAYED (1<<TIF_NEED_RESCHED_DELAYED)
>  
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
>  
>  #define _TIF_USER_WORK_MASK	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | \
> Index: linux-2.6/include/asm-s390/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-s390/thread_info.h
> +++ linux-2.6/include/asm-s390/thread_info.h
> @@ -51,6 +51,7 @@ struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	unsigned int		cpu;		/* current CPU */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	struct restart_block	restart_block;
>  };
>  
> @@ -64,6 +65,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.restart_block	= {			\
>  		.fn = do_no_restart_syscall,	\
>  	},					\
> @@ -96,6 +98,7 @@ static inline struct thread_info *curren
>  #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
>  #define TIF_SINGLE_STEP		6	/* deliver sigtrap on return to user */
>  #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
> +#define TIF_NEED_MIGRATE	8	/* migration necessary */
>  #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
>  #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
>  					   TIF_NEED_RESCHED */
> @@ -110,6 +113,7 @@ static inline struct thread_info *curren
>  #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
>  #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
>  #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  #define _TIF_31BIT		(1<<TIF_31BIT)
> Index: linux-2.6/include/asm-sh/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-sh/thread_info.h
> +++ linux-2.6/include/asm-sh/thread_info.h
> @@ -21,6 +21,7 @@ struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	__u32			cpu;
>  	int			preempt_count; /* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	mm_segment_t		addr_limit;	/* thread address space */
>  	struct restart_block	restart_block;
>  	unsigned long		previous_sp;	/* sp of previous stack in case
> @@ -58,6 +59,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.restart_block	= {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -113,6 +115,7 @@ static inline struct thread_info *curren
>  #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
>  #define TIF_SINGLESTEP		5	/* singlestepping active */
>  #define TIF_NEED_RESCHED_DELAYED	6	/* reschedule on return to userspace */
> +#define TIF_NEED_MIGRATE	7	/* migration necessary */
>  #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
>  #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		18
> @@ -125,6 +128,7 @@ static inline struct thread_info *curren
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>  #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
>  #define _TIF_NEED_RESCHED_DELAYED	(1<<TIF_NEED_RESCHED_DELAYED)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  #define _TIF_FREEZE		(1<<TIF_FREEZE)
> Index: linux-2.6/include/asm-sh64/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-sh64/thread_info.h
> +++ linux-2.6/include/asm-sh64/thread_info.h
> @@ -23,6 +23,7 @@ struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	/* Put the 4 32-bit fields together to make asm offsetting easier. */
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	__u16			cpu;
>  
>  	mm_segment_t		addr_limit;
> @@ -41,6 +42,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit     = KERNEL_DS,            \
>  	.restart_block	= {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -79,12 +81,14 @@ static inline struct thread_info *curren
>  #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
>  #define TIF_MEMDIE		4
>  #define TIF_RESTORE_SIGMASK	5	/* Restore signal mask in do_signal */
> +#define TIF_NEED_MIGRATE	6	/* migration necessary */
>  
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  
>  #endif /* __KERNEL__ */
>  
> Index: linux-2.6/include/asm-sparc/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-sparc/thread_info.h
> +++ linux-2.6/include/asm-sparc/thread_info.h
> @@ -33,6 +33,7 @@ struct thread_info {
>  	int			cpu;		/* cpu we're on */
>  	int			preempt_count;	/* 0 => preemptable,
>  						   <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	int			softirq_count;
>  	int			hardirq_count;
>  
> @@ -65,6 +66,7 @@ struct thread_info {
>  	.flags		=	0,			\
>  	.cpu		=	0,			\
>  	.preempt_count	=	1,			\
> +	.migrate_count =	0,			\
>  	.restart_block	= {				\
>  		.fn	=	do_no_restart_syscall,	\
>  	},						\
> @@ -132,6 +134,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
>  #define TIF_SIGPENDING		2	/* signal pending */
>  #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
>  #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
> +#define TIF_NEED_MIGRATE	5	/* migration necessary */
>  #define TIF_USEDFPU		8	/* FPU was used by this task
>  					 * this quantum (SMP) */
>  #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
> @@ -143,6 +146,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  
> Index: linux-2.6/include/asm-sparc64/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-sparc64/thread_info.h
> +++ linux-2.6/include/asm-sparc64/thread_info.h
> @@ -47,6 +47,7 @@ struct thread_info {
>  	struct pt_regs		*kregs;
>  	struct exec_domain	*exec_domain;
>  	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	__u8			new_child;
>  	__u8			syscall_noerror;
>  	__u16			cpu;
> @@ -137,6 +138,7 @@ struct thread_info {
>  	.flags		= ((unsigned long)ASI_P) << TI_FLAG_CURRENT_DS_SHIFT,	\
>  	.exec_domain	=	&default_exec_domain,	\
>  	.preempt_count	=	1,			\
> +	.migrate_count =	0,			\
>  	.restart_block	= {				\
>  		.fn	=	do_no_restart_syscall,	\
>  	},						\
> @@ -225,7 +227,7 @@ register struct thread_info *current_thr
>  #define TIF_UNALIGNED		5	/* allowed to do unaligned accesses */
>  #define TIF_NEWSIGNALS		6	/* wants new-style signals */
>  #define TIF_32BIT		7	/* 32-bit binary */
> -/* flag bit 8 is available */
> +#define TIF_NEED_MIGRATE	8	/* migration necessary */
>  #define TIF_SECCOMP		9	/* secure computing */
>  #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
>  /* flag bit 11 is available */
> @@ -244,6 +246,7 @@ register struct thread_info *current_thr
>  #define _TIF_UNALIGNED		(1<<TIF_UNALIGNED)
>  #define _TIF_NEWSIGNALS		(1<<TIF_NEWSIGNALS)
>  #define _TIF_32BIT		(1<<TIF_32BIT)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
>  #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
> Index: linux-2.6/include/asm-um/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-um/thread_info.h
> +++ linux-2.6/include/asm-um/thread_info.h
> @@ -18,6 +18,7 @@ struct thread_info {
>  	__u32			cpu;		/* current CPU */
>  	int			preempt_count;  /* 0 => preemptable,
>  						   <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	mm_segment_t		addr_limit;	/* thread address space:
>  					 	   0-0xBFFFFFFF for user
>  						   0-0xFFFFFFFF for kernel */
> @@ -32,6 +33,7 @@ struct thread_info {
>  	.flags =		0,		\
>  	.cpu =		0,			\
>  	.preempt_count =	1,		\
> +	.migrate_count =	0,		\
>  	.addr_limit =	KERNEL_DS,		\
>  	.restart_block =  {			\
>  		.fn =  do_no_restart_syscall,	\
> @@ -71,6 +73,7 @@ static inline struct thread_info *curren
>  #define TIF_MEMDIE	 	5
>  #define TIF_SYSCALL_AUDIT	6
>  #define TIF_RESTORE_SIGMASK	7
> +#define TIF_NEED_MIGRATE	8	/* migration necessary */
>  
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
> @@ -79,5 +82,6 @@ static inline struct thread_info *curren
>  #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
>  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
> +#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
>  
>  #endif
> Index: linux-2.6/include/asm-v850/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-v850/thread_info.h
> +++ linux-2.6/include/asm-v850/thread_info.h
> @@ -32,6 +32,7 @@ struct thread_info {
>  	int			cpu;		/* cpu we're on */
>  	int			preempt_count;	/* 0 => preemptable,
>  						   <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  	struct restart_block	restart_block;
>  };
>  
> @@ -42,6 +43,7 @@ struct thread_info {
>  	.flags =	0,						      \
>  	.cpu =		0,						      \
>  	.preempt_count = 1,						      \
> +	.migrate_count = 0,						      \
>  	.restart_block = {						      \
>  		.fn = do_no_restart_syscall,				      \
>  	},								      \
> @@ -83,6 +85,7 @@ struct thread_info {
>  #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
>  					   TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		5
> +#define TIF_NEED_MIGRATE	6	/* migration necessary */
>  
>  /* as above, but as bit values */
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -90,6 +93,7 @@ struct thread_info {
>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  
>  
>  /* Size of kernel stack for each process.  */
> Index: linux-2.6/include/asm-x86_64/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86_64/thread_info.h
> +++ linux-2.6/include/asm-x86_64/thread_info.h
> @@ -30,6 +30,7 @@ struct thread_info {
>  	__u32			status;		/* thread synchronous flags */
>  	__u32			cpu;		/* current CPU */
>  	int 			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migrate_count;/* 0: can migrate, <0 => BUG */
>  
>  	mm_segment_t		addr_limit;	
>  	struct restart_block    restart_block;
> @@ -48,6 +49,7 @@ struct thread_info {
>  	.flags	       = 0,			\
>  	.cpu	       = 0,			\
>  	.preempt_count = 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit     = KERNEL_DS,		\
>  	.restart_block = {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -116,6 +118,7 @@ static inline struct thread_info *stack_
>  #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
>  #define TIF_SECCOMP		8	/* secure computing */
>  #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
> +#define TIF_NEED_MIGRATE	11	/* migration necessary */
>  /* 16 free */
>  #define TIF_IA32		17	/* 32bit process */ 
>  #define TIF_FORK		18	/* ret_from_fork */
> @@ -135,6 +138,7 @@ static inline struct thread_info *stack_
>  #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>  #define _TIF_NEED_RESCHED_DELAYED (1<<TIF_NEED_RESCHED_DELAYED)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_IA32		(1<<TIF_IA32)
>  #define _TIF_FORK		(1<<TIF_FORK)
>  #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
> Index: linux-2.6/include/asm-xtensa/thread_info.h
> ===================================================================
> --- linux-2.6.orig/include/asm-xtensa/thread_info.h
> +++ linux-2.6/include/asm-xtensa/thread_info.h
> @@ -34,6 +34,7 @@ struct thread_info {
>  	unsigned long		status;		/* thread-synchronous flags */
>  	__u32			cpu;		/* current CPU */
>  	__s32			preempt_count;	/* 0 => preemptable,< 0 => BUG*/
> +	__s32			migrate_count;/* 0: can migrate, <0 => BUG */
>  
>  	mm_segment_t		addr_limit;	/* thread address space */
>  	struct restart_block    restart_block;
> @@ -72,6 +73,7 @@ struct thread_info {
>  	.flags		= 0,			\
>  	.cpu		= 0,			\
>  	.preempt_count	= 1,			\
> +	.migrate_count = 0,			\
>  	.addr_limit	= KERNEL_DS,		\
>  	.restart_block = {			\
>  		.fn = do_no_restart_syscall,	\
> @@ -117,6 +119,7 @@ static inline struct thread_info *curren
>  #define TIF_IRET		5	/* return with iret */
>  #define TIF_MEMDIE		6
>  #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal() */
> +#define TIF_NEED_MIGRATE	8	/* migration necessary */
>  #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>  
>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> @@ -125,6 +128,7 @@ static inline struct thread_info *curren
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>  #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
>  #define _TIF_IRET		(1<<TIF_IRET)
> +#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>  
> Index: linux-2.6/lib/smp_processor_id.c
> ===================================================================
> --- linux-2.6.orig/lib/smp_processor_id.c
> +++ linux-2.6/lib/smp_processor_id.c
> @@ -10,12 +10,16 @@
>  unsigned int notrace debug_smp_processor_id(void)
>  {
>  	unsigned long preempt_count = preempt_count();
> +	unsigned long migrate_count = migrate_count();
>  	int this_cpu = raw_smp_processor_id();
>  	cpumask_t this_mask;
>  
>  	if (likely(preempt_count))
>  		goto out;
>  
> +	if (likely(migrate_count))
> +		goto out;
> +
>  	if (irqs_disabled())
>  		goto out;
>  
> @@ -42,7 +46,7 @@ unsigned int notrace debug_smp_processor
>  	if (!printk_ratelimit())
>  		goto out_enable;
>  
> -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] code: %s/%d\n", preempt_count()-1, current->comm, current->pid);
> +	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] migration [%08x] code: %s/%d\n", preempt_count()-1, migrate_count(), current->comm, current->pid);
>  	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
>  	dump_stack();
>  
> 
> --
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
