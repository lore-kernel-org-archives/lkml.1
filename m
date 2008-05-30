Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYE3LZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYE3LZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYE3LYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:24:49 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58476 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYE3LYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:24:46 -0400
Date: Fri, 30 May 2008 04:24:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080530112440.GN4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 10:58:15AM +0200, Jens Axboe wrote:
> This adds kernel/smp.c which contains helpers for IPI function calls. In
> addition to supporting the existing smp_call_function() in a more efficient
> manner, it also adds a more scalable variant called smp_call_function_single()
> for calling a given function on a single CPU only.
> 
> The core of this is based on the x86-64 patch from Nick Piggin, lots of
> changes since then. "Alan D. Brunelle" <Alan.Brunelle@hp.com> has
> contributed lots of fixes and suggestions as well. Also thanks to
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> for reviewing RCU usage
> and getting rid of the data allocation fallback deadlock.

Looks much improved!!!  A few suggestions for header comments, and
there appears to be a leftover memory barrier that should now be
removed.  With these changes:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Acked-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/Kconfig              |    3 +
>  arch/sparc64/kernel/smp.c |   11 +-
>  include/linux/smp.h       |   34 ++++-
>  init/main.c               |    2 +
>  kernel/Makefile           |    1 +
>  kernel/smp.c              |  362 +++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 406 insertions(+), 7 deletions(-)
>  create mode 100644 kernel/smp.c
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 3ea332b..ad89a33 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -39,3 +39,6 @@ config HAVE_KRETPROBES
> 
>  config HAVE_DMA_ATTRS
>  	def_bool n
> +
> +config USE_GENERIC_SMP_HELPERS
> +	def_bool n
> diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
> index fa63c68..b82d017 100644
> --- a/arch/sparc64/kernel/smp.c
> +++ b/arch/sparc64/kernel/smp.c
> @@ -816,8 +816,9 @@ extern unsigned long xcall_call_function;
>   * You must not call this function with disabled interrupts or from a
>   * hardware interrupt handler or from a bottom half handler.
>   */
> -static int smp_call_function_mask(void (*func)(void *info), void *info,
> -				  int nonatomic, int wait, cpumask_t mask)
> +static int sparc64_smp_call_function_mask(void (*func)(void *info), void *info,
> +					  int nonatomic, int wait,
> +					  cpumask_t mask)
>  {
>  	struct call_data_struct data;
>  	int cpus;
> @@ -855,8 +856,8 @@ out_unlock:
>  int smp_call_function(void (*func)(void *info), void *info,
>  		      int nonatomic, int wait)
>  {
> -	return smp_call_function_mask(func, info, nonatomic, wait,
> -				      cpu_online_map);
> +	return sparc64_smp_call_function_mask(func, info, nonatomic, wait,
> +						cpu_online_map);
>  }
> 
>  void smp_call_function_client(int irq, struct pt_regs *regs)
> @@ -893,7 +894,7 @@ static void tsb_sync(void *info)
> 
>  void smp_tsb_sync(struct mm_struct *mm)
>  {
> -	smp_call_function_mask(tsb_sync, mm, 0, 1, mm->cpu_vm_mask);
> +	sparc64_smp_call_function_mask(tsb_sync, mm, 0, 1, mm->cpu_vm_mask);
>  }
> 
>  extern unsigned long xcall_flush_tlb_mm;
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 55232cc..2691bad 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -7,9 +7,19 @@
>   */
> 
>  #include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/cpumask.h>
> 
>  extern void cpu_idle(void);
> 
> +struct call_single_data {
> +	struct list_head list;
> +	void (*func) (void *info);
> +	void *info;
> +	unsigned int flags;
> +};
> +
>  #ifdef CONFIG_SMP
> 
>  #include <linux/preempt.h>
> @@ -53,9 +63,27 @@ extern void smp_cpus_done(unsigned int max_cpus);
>   * Call a function on all other processors
>   */
>  int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
> -
> +int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
> +				int wait);
>  int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
>  				int retry, int wait);
> +void __smp_call_function_single(int cpuid, struct call_single_data *data);
> +
> +/*
> + * Generic and arch helpers
> + */
> +#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
> +void generic_smp_call_function_single_interrupt(void);
> +void generic_smp_call_function_interrupt(void);
> +void init_call_single_data(void);
> +void arch_send_call_function_single_ipi(int cpu);
> +void arch_send_call_function_ipi(cpumask_t mask);
> +extern spinlock_t call_function_lock;
> +#else
> +static inline void init_call_single_data(void)
> +{
> +}
> +#endif
> 
>  /*
>   * Call a function on all processors
> @@ -112,7 +140,9 @@ static inline void smp_send_reschedule(int cpu) { }
>  })
>  #define smp_call_function_mask(mask, func, info, wait) \
>  			(up_smp_call_function(func, info))
> -
> +static inline void init_call_single_data(void)
> +{
> +}
>  #endif /* !SMP */
> 
>  /*
> diff --git a/init/main.c b/init/main.c
> index f7fb200..1efcccf 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -31,6 +31,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/start_kernel.h>
>  #include <linux/security.h>
> +#include <linux/smp.h>
>  #include <linux/workqueue.h>
>  #include <linux/profile.h>
>  #include <linux/rcupdate.h>
> @@ -779,6 +780,7 @@ static void __init do_pre_smp_initcalls(void)
>  {
>  	extern int spawn_ksoftirqd(void);
> 
> +	init_call_single_data();
>  	migration_init();
>  	spawn_ksoftirqd();
>  	if (!nosoftlockup)
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 1c9938a..9fa5797 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
>  obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
>  obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
>  obj-$(CONFIG_SMP) += cpu.o spinlock.o
> +obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
>  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
>  obj-$(CONFIG_UID16) += uid16.o
> diff --git a/kernel/smp.c b/kernel/smp.c
> new file mode 100644
> index 0000000..ef6de3d
> --- /dev/null
> +++ b/kernel/smp.c
> @@ -0,0 +1,362 @@
> +/*
> + * Generic helpers for smp ipi calls
> + *
> + * (C) Jens Axboe <jens.axboe@oracle.com> 2008
> + *
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/percpu.h>
> +#include <linux/rcupdate.h>
> +#include <linux/smp.h>
> +
> +static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
> +static LIST_HEAD(call_function_queue);
> +__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
> +
> +enum {
> +	CSD_FLAG_WAIT		= 0x01,
> +	CSD_FLAG_ALLOC		= 0x02,
> +};
> +
> +struct call_function_data {
> +	struct call_single_data csd;
> +	spinlock_t lock;
> +	unsigned int refs;
> +	cpumask_t cpumask;
> +	struct rcu_head rcu_head;
> +};
> +
> +struct call_single_queue {
> +	struct list_head list;
> +	spinlock_t lock;
> +};
> +
> +void __cpuinit init_call_single_data(void)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		struct call_single_queue *q = &per_cpu(call_single_queue, i);
> +
> +		spin_lock_init(&q->lock);
> +		INIT_LIST_HEAD(&q->list);
> +	}
> +}
> +
> +static void csd_flag_wait(struct call_single_data *data)
> +{
> +	/* Wait for response */
> +	do {
> +		/*
> +		 * We need to see the flags store in the IPI handler
> +		 */
> +		smp_mb();
> +		if (!(data->flags & CSD_FLAG_WAIT))
> +			break;
> +		cpu_relax();
> +	} while (1);
> +}
> +
> +/*
> + * Insert a previously allocated call_single_data element for execution
> + * on the given CPU. data must already have ->func, ->info, and ->flags set.
> + */
> +static void generic_exec_single(int cpu, struct call_single_data *data)
> +{
> +	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
> +	int wait = data->flags & CSD_FLAG_WAIT, ipi;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dst->lock, flags);
> +	ipi = list_empty(&dst->list);
> +	list_add_tail(&data->list, &dst->list);
> +	spin_unlock_irqrestore(&dst->lock, flags);
> +
> +	if (ipi)
> +		arch_send_call_function_single_ipi(cpu);
> +
> +	if (wait)
> +		csd_flag_wait(data);
> +}
> +
> +static void rcu_free_call_data(struct rcu_head *head)
> +{
> +	struct call_function_data *data;
> +
> +	data = container_of(head, struct call_function_data, rcu_head);
> +
> +	kfree(data);
> +}
> +
> +/*
> + * Invoked by arch to handle an IPI for call function. Must be called with
> + * interrupts disabled.
> + */
> +void generic_smp_call_function_interrupt(void)
> +{
> +	struct call_function_data *data;
> +	int cpu = get_cpu();
> +
> +	/*
> +	 * It's ok to use list_for_each_rcu() here even though we may delete
> +	 * 'pos', since list_del_rcu() doesn't clear ->next
> +	 */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
> +		int refs;
> +
> +		if (!cpu_isset(cpu, data->cpumask))
> +			continue;
> +
> +		data->csd.func(data->csd.info);
> +
> +		spin_lock(&data->lock);
> +		cpu_clear(cpu, data->cpumask);
> +		WARN_ON(data->refs == 0);
> +		data->refs--;
> +		refs = data->refs;
> +		spin_unlock(&data->lock);
> +
> +		if (refs)
> +			continue;
> +
> +		spin_lock(&call_function_lock);
> +		list_del_rcu(&data->csd.list);
> +		spin_unlock(&call_function_lock);
> +
> +		if (data->csd.flags & CSD_FLAG_WAIT) {
> +			/*
> +			 * serialize stores to data with the flag clear
> +			 * and wakeup
> +			 */
> +			smp_wmb();
> +			data->csd.flags &= ~CSD_FLAG_WAIT;
> +		} else
> +			call_rcu(&data->rcu_head, rcu_free_call_data);
> +	}
> +	rcu_read_unlock();
> +
> +	put_cpu();
> +}
> +
> +/*
> + * Invoked by arch to handle an IPI for call function single. Must be called
> + * from the arch with interrupts disabled.
> + */
> +void generic_smp_call_function_single_interrupt(void)
> +{
> +	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
> +	LIST_HEAD(list);
> +
> +	/*
> +	 * Need to see other stores to list head for checking whether
> +	 * list is empty without holding q->lock
> +	 */
> +	smp_mb();
> +	while (!list_empty(&q->list)) {
> +		unsigned int data_flags;
> +
> +		spin_lock(&q->lock);
> +		list_replace_init(&q->list, &list);
> +		spin_unlock(&q->lock);
> +
> +		while (!list_empty(&list)) {
> +			struct call_single_data *data;
> +
> +			data = list_entry(list.next, struct call_single_data,
> +						list);
> +			list_del(&data->list);
> +
> +			/*
> +			 * 'data' can be invalid after this call if
> +			 * flags == 0 (when called through
> +			 * generic_exec_single(), so save them away before
> +			 * making the call.
> +			 */
> +			data_flags = data->flags;
> +
> +			data->func(data->info);
> +
> +			if (data_flags & CSD_FLAG_WAIT) {
> +				smp_wmb();
> +				data->flags &= ~CSD_FLAG_WAIT;
> +			} else if (data_flags & CSD_FLAG_ALLOC)
> +				kfree(data);
> +		}
> +		/*
> +		 * See comment on outer loop
> +		 */
> +		smp_mb();
> +	}
> +}
> +
> +/*
> + * smp_call_function_single - Run a function on a specific CPU
> + * @func: The function to run. This must be fast and non-blocking.
> + * @info: An arbitrary pointer to pass to the function.
> + * @retry: Unused
> + * @wait: If true, wait until function has completed on other CPUs.

Suggest adding comment to the effect that @wait will be implicitly set
upon memory-allocation failure.

> + *
> + * Returns 0 on success, else a negative status code.
> + */
> +int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> +			     int retry, int wait)
> +{
> +	struct call_single_data d;
> +	unsigned long flags;
> +	/* prevent preemption and reschedule on another processor */
> +	int me = get_cpu();
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
> +	if (cpu == me) {
> +		local_irq_save(flags);
> +		func(info);
> +		local_irq_restore(flags);
> +	} else {
> +		struct call_single_data *data = NULL;
> +
> +		if (!wait) {
> +			data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +			if (data)
> +				data->flags = CSD_FLAG_ALLOC;
> +		}
> +		if (!data) {
> +			data = &d;
> +			data->flags = CSD_FLAG_WAIT;
> +		}
> +
> +		data->func = func;
> +		data->info = info;
> +		generic_exec_single(cpu, data);
> +	}
> +
> +	put_cpu();
> +	return 0;
> +}
> +EXPORT_SYMBOL(smp_call_function_single);
> +
> +/**
> + * __smp_call_function_single(): Run a function on another CPU
> + * @cpu: The CPU to run on.
> + * @data: Pre-allocated and setup data structure
> + *
> + * Like smp_call_function_single(), but allow caller to pass in a pre-allocated
> + * data structure. Useful for embedding @data inside other structures, for
> + * instance.
> + *
> + */
> +void __smp_call_function_single(int cpu, struct call_single_data *data)
> +{
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
> +
> +	generic_exec_single(cpu, data);
> +}
> +
> +/**
> + * smp_call_function_mask(): Run a function on a set of other CPUs.
> + * @mask: The set of cpus to run on.
> + * @func: The function to run. This must be fast and non-blocking.
> + * @info: An arbitrary pointer to pass to the function.
> + * @wait: If true, wait (atomically) until function has completed on other CPUs.
> + *
> + * Returns 0 on success, else a negative status code.
> + *
> + * If @wait is true, then returns once @func has returned.
> + *
> + * You must not call this function with disabled interrupts or from a
> + * hardware interrupt handler or from a bottom half handler.

Suggest adding comment to the effect that @wait will be implicitly set
upon memory-allocation failure.

Also, isn't it necessary to call this function with preemption disabled?
If so, this should be commented as well.

> + */
> +int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> +			   int wait)
> +{
> +	struct call_function_data d;
> +	struct call_function_data *data = NULL;
> +	cpumask_t allbutself;
> +	unsigned long flags;
> +	int cpu, num_cpus;
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
> +	cpu = smp_processor_id();
> +	allbutself = cpu_online_map;
> +	cpu_clear(cpu, allbutself);
> +	cpus_and(mask, mask, allbutself);
> +	num_cpus = cpus_weight(mask);
> +
> +	/*
> +	 * If zero CPUs, return. If just a single CPU, turn this request
> +	 * into a targetted single call instead since it's faster.
> +	 */
> +	if (!num_cpus)
> +		return 0;
> +	else if (num_cpus == 1) {
> +		cpu = first_cpu(mask);
> +		return smp_call_function_single(cpu, func, info, 0, wait);
> +	}
> +
> +	if (!wait) {
> +		data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +		if (data)
> +			data->csd.flags = CSD_FLAG_ALLOC;
> +	}
> +	if (!data) {
> +		data = &d;
> +		data->csd.flags = CSD_FLAG_WAIT;
> +	}
> +
> +	spin_lock_init(&data->lock);
> +	data->csd.func = func;
> +	data->csd.info = info;
> +	data->refs = num_cpus;
> +
> +	/*
> +	 * need to see above stores before the cpumask is valid for the CPU
> +	 */
> +	smp_wmb();

Given that all call_function_data structs either get run through
call_rcu() or are waited for, I believe we no longer need the above
smp_wmb().  The only reason we needed it before was that there was the
possibility of a call_function_data struct being reused while a reader
was still referencing it.  If I understand the code, this can no longer
happen, so this memory barrier is not needed and should be removed.

> +	data->cpumask = mask;
> +
> +	spin_lock_irqsave(&call_function_lock, flags);
> +	list_add_tail_rcu(&data->csd.list, &call_function_queue);
> +	spin_unlock_irqrestore(&call_function_lock, flags);
> +
> +	/* Send a message to all CPUs in the map */
> +	arch_send_call_function_ipi(mask);
> +
> +	/* optionally wait for the CPUs to complete */
> +	if (wait)
> +		csd_flag_wait(&data->csd);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(smp_call_function_mask);
> +
> +/**
> + * smp_call_function(): Run a function on all other CPUs.
> + * @func: The function to run. This must be fast and non-blocking.
> + * @info: An arbitrary pointer to pass to the function.
> + * @natomic: Unused
> + * @wait: If true, wait (atomically) until function has completed on other CPUs.
> + *
> + * Returns 0 on success, else a negative status code.
> + *
> + * If @wait is true, then returns once @func has returned; otherwise
> + * it returns just before the target cpu calls @func.

Suggest adding comment to the effect that @wait will be implicitly set
upon memory-allocation failure.

> + *
> + * You must not call this function with disabled interrupts or from a
> + * hardware interrupt handler or from a bottom half handler.
> + */
> +int smp_call_function(void (*func)(void *), void *info, int natomic, int wait)
> +{
> +	int ret;
> +
> +	preempt_disable();
> +	ret = smp_call_function_mask(cpu_online_map, func, info, wait);
> +	preempt_enable();
> +	return ret;
> +}
> +EXPORT_SYMBOL(smp_call_function);
> -- 
> 1.5.6.rc0.40.gd683
> 
