Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKSUXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKSUXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYKSUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:23:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:57829 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYKSUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:23:31 -0500
Message-ID: <492475BF.6090502@ct.jp.nec.com>
Date: Wed, 19 Nov 2008 12:23:27 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, npiggin@suse.de,
       axboe@kernel.dk
Subject: Re: [PATCH 1/1] cpumask: smp_call_function_many()
References: <20081119144710.59CA1DDDDB@ozlabs.org>
In-Reply-To: <20081119144710.59CA1DDDDB@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Actually change smp_call_function_mask() to smp_call_function_many().
> 
> S390 has its own version, so we do trivial conversion on that too.
> 
> We have to do some dancing to figure out if 0 or 1 other cpus are in
> the mask supplied and the online mask without allocating a tmp
> cpumask.  It's still fairly cheap.
> 
> We allocate the cpumask at the end of the call_function_data
> structure: if allocation fails we fallback to smp_call_function_single
> rather than using the baroque quiescing code.
> 
> (Thanks to Hiroshi Shimamoto for spotting several bugs in previous versions!)
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Cc: schwidefsky@de.ibm.com
> Cc: heiko.carstens@de.ibm.com
> Cc: npiggin@suse.de
> Cc: axboe@kernel.dk
> ---
>  arch/s390/include/asm/smp.h |    3 
>  arch/s390/kernel/smp.c      |    9 +-
>  include/linux/smp.h         |   15 ++--
>  kernel/smp.c                |  137 +++++++++++++++-----------------------------
>  4 files changed, 60 insertions(+), 104 deletions(-)
> 
> diff -r a701ec4491ec arch/s390/include/asm/smp.h
> --- a/arch/s390/include/asm/smp.h	Tue Nov 18 12:08:41 2008 +1030
> +++ b/arch/s390/include/asm/smp.h	Tue Nov 18 12:10:56 2008 +1030
> @@ -90,9 +90,6 @@
>  
>  extern struct mutex smp_cpu_state_mutex;
>  extern int smp_cpu_polarization[];
> -
> -extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
> -	void *info, int wait);
>  #endif
>  
>  #ifndef CONFIG_SMP
> diff -r a701ec4491ec arch/s390/kernel/smp.c
> --- a/arch/s390/kernel/smp.c	Tue Nov 18 12:08:41 2008 +1030
> +++ b/arch/s390/kernel/smp.c	Tue Nov 18 12:10:56 2008 +1030
> @@ -199,7 +199,7 @@
>  EXPORT_SYMBOL(smp_call_function_single);
>  
>  /**
> - * smp_call_function_mask(): Run a function on a set of other CPUs.
> + * smp_call_function_many(): Run a function on a set of other CPUs.
>   * @mask: The set of cpus to run on.  Must not include the current cpu.
>   * @func: The function to run. This must be fast and non-blocking.
>   * @info: An arbitrary pointer to pass to the function.
> @@ -213,16 +213,17 @@
>   * You must not call this function with disabled interrupts or from a
>   * hardware interrupt handler or from a bottom half handler.
>   */
> -int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> -			   int wait)
> +int smp_call_function_many(const struct cpumask *maskp,
> +			   void (*func)(void *), void *info, bool wait)
>  {
> +	cpumask_t mask = *maskp;
>  	spin_lock(&call_lock);
>  	cpu_clear(smp_processor_id(), mask);
>  	__smp_call_function_map(func, info, wait, mask);
>  	spin_unlock(&call_lock);
>  	return 0;
>  }
> -EXPORT_SYMBOL(smp_call_function_mask);
> +EXPORT_SYMBOL(smp_call_function_many);
>  
>  void smp_send_stop(void)
>  {
> diff -r a701ec4491ec include/linux/smp.h
> --- a/include/linux/smp.h	Tue Nov 18 12:08:41 2008 +1030
> +++ b/include/linux/smp.h	Tue Nov 18 12:10:56 2008 +1030
> @@ -64,15 +64,16 @@
>   * Call a function on all other processors
>   */
>  int smp_call_function(void(*func)(void *info), void *info, int wait);
> -/* Deprecated: use smp_call_function_many() which uses a cpumask ptr. */
> -int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
> -				int wait);
> +void smp_call_function_many(const struct cpumask *mask,
> +			    void (*func)(void *info), void *info, bool wait);
>  
> -static inline void smp_call_function_many(const struct cpumask *mask,
> -					  void (*func)(void *info), void *info,
> -					  int wait)
> +/* Deprecated: Use smp_call_function_many which takes a pointer to the mask. */
> +static inline int
> +smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
> +		       int wait)
>  {
> -	smp_call_function_mask(*mask, func, info, wait);
> +	smp_call_function_many(&mask, func, info, wait);
> +	return 0;
>  }
>  
>  int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
> diff -r a701ec4491ec kernel/smp.c
> --- a/kernel/smp.c	Tue Nov 18 12:08:41 2008 +1030
> +++ b/kernel/smp.c	Tue Nov 18 12:10:56 2008 +1030
> @@ -24,8 +24,8 @@
>  	struct call_single_data csd;
>  	spinlock_t lock;
>  	unsigned int refs;
> -	cpumask_t cpumask;
>  	struct rcu_head rcu_head;
> +	unsigned long cpumask_bits[];
>  };
>  
>  struct call_single_queue {
> @@ -110,13 +110,13 @@
>  	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
>  		int refs;
>  
> -		if (!cpu_isset(cpu, data->cpumask))
> +		if (!cpumask_test_cpu(cpu, to_cpumask(data->cpumask_bits)))
>  			continue;
>  
>  		data->csd.func(data->csd.info);
>  
>  		spin_lock(&data->lock);
> -		cpu_clear(cpu, data->cpumask);
> +		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
>  		WARN_ON(data->refs == 0);
>  		data->refs--;
>  		refs = data->refs;
> @@ -266,50 +266,12 @@
>  	generic_exec_single(cpu, data);
>  }
>  
> -/* Dummy function */
> -static void quiesce_dummy(void *unused)
> -{
> -}
> -
> -/*
> - * Ensure stack based data used in call function mask is safe to free.
> - *
> - * This is needed by smp_call_function_mask when using on-stack data, because
> - * a single call function queue is shared by all CPUs, and any CPU may pick up
> - * the data item on the queue at any time before it is deleted. So we need to
> - * ensure that all CPUs have transitioned through a quiescent state after
> - * this call.
> - *
> - * This is a very slow function, implemented by sending synchronous IPIs to
> - * all possible CPUs. For this reason, we have to alloc data rather than use
> - * stack based data even in the case of synchronous calls. The stack based
> - * data is then just used for deadlock/oom fallback which will be very rare.
> - *
> - * If a faster scheme can be made, we could go back to preferring stack based
> - * data -- the data allocation/free is non-zero cost.
> - */
> -static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
> -{
> -	struct call_single_data data;
> -	int cpu;
> -
> -	data.func = quiesce_dummy;
> -	data.info = NULL;
> -
> -	for_each_cpu_mask(cpu, mask) {
> -		data.flags = CSD_FLAG_WAIT;
> -		generic_exec_single(cpu, &data);
> -	}
> -}
> -
>  /**
> - * smp_call_function_mask(): Run a function on a set of other CPUs.
> - * @mask: The set of cpus to run on.
> + * smp_call_function_many(): Run a function on a set of other CPUs.
> + * @mask: The set of cpus to run on (only runs on online subset).
>   * @func: The function to run. This must be fast and non-blocking.
>   * @info: An arbitrary pointer to pass to the function.
>   * @wait: If true, wait (atomically) until function has completed on other CPUs.
> - *
> - * Returns 0 on success, else a negative status code.
>   *
>   * If @wait is true, then returns once @func has returned. Note that @wait
>   * will be implicitly turned on in case of allocation failures, since
> @@ -319,53 +281,55 @@
>   * hardware interrupt handler or from a bottom half handler. Preemption
>   * must be disabled when calling this function.
>   */
> -int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> -			   int wait)
> +void smp_call_function_many(const struct cpumask *mask,
> +			    void (*func)(void *), void *info,
> +			    bool wait)
>  {
> -	struct call_function_data d;
> -	struct call_function_data *data = NULL;
> -	cpumask_t allbutself;
> +	struct call_function_data *data;
>  	unsigned long flags;
> -	int cpu, num_cpus;
> -	int slowpath = 0;
> +	int cpu, next_cpu;
>  
>  	/* Can deadlock when called with interrupts disabled */
>  	WARN_ON(irqs_disabled());
>  
> -	cpu = smp_processor_id();
> -	allbutself = cpu_online_map;
> -	cpu_clear(cpu, allbutself);
> -	cpus_and(mask, mask, allbutself);
> -	num_cpus = cpus_weight(mask);
> +	/* So, what's a CPU they want?  Ignoring this one. */
> +	cpu = cpumask_first_and(mask, cpu_online_mask);
> +	if (cpu == smp_processor_id())
> +		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
> +	/* No online cpus?  We're done. */
> +	if (cpu >= nr_cpu_ids)
> +		return;
>  
> -	/*
> -	 * If zero CPUs, return. If just a single CPU, turn this request
> -	 * into a targetted single call instead since it's faster.
> -	 */
> -	if (!num_cpus)
> -		return 0;
> -	else if (num_cpus == 1) {
> -		cpu = first_cpu(mask);
> -		return smp_call_function_single(cpu, func, info, wait);
> -	}
> +	/* Do we have another CPU which isn't us? */
> +	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
> +	if (next_cpu == smp_processor_id())
> +		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
>  
> -	data = kmalloc(sizeof(*data), GFP_ATOMIC);
> -	if (data) {
> -		data->csd.flags = CSD_FLAG_ALLOC;
> -		if (wait)
> -			data->csd.flags |= CSD_FLAG_WAIT;
> -	} else {
> -		data = &d;
> -		data->csd.flags = CSD_FLAG_WAIT;
> -		wait = 1;
> -		slowpath = 1;
> +	/* Fastpath: do that cpu by itself. */
> +	if (next_cpu >= nr_cpu_ids)
> +		smp_call_function_single(cpu, func, info, wait);

Hi Rusty,

I think, return is needed here. If not func will be called twice.

	if (next_cpu >= nr_cpu_ids) {
		smp_call_function_single(cpu, func, info, wait);
		return;
	}

thanks,
Hiroshi Shimamoto

> +
> +	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
> +	if (unlikely(!data)) {
> +		/* Slow path. */
> +		for_each_online_cpu(cpu) {
> +			if (cpu == smp_processor_id())
> +				continue;
> +			if (cpumask_test_cpu(cpu, mask))
> +				smp_call_function_single(cpu, func, info, wait);
> +		}
> +		return;
>  	}
>  
>  	spin_lock_init(&data->lock);
> +	data->csd.flags = CSD_FLAG_ALLOC;
> +	if (wait)
> +		data->csd.flags |= CSD_FLAG_WAIT;
>  	data->csd.func = func;
>  	data->csd.info = info;
> -	data->refs = num_cpus;
> -	data->cpumask = mask;
> +	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
> +	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
> +	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
>  
>  	spin_lock_irqsave(&call_function_lock, flags);
>  	list_add_tail_rcu(&data->csd.list, &call_function_queue);
> @@ -377,18 +341,13 @@
>  	smp_mb();
>  
>  	/* Send a message to all CPUs in the map */
> -	arch_send_call_function_ipi(mask);
> +	arch_send_call_function_ipi(*to_cpumask(data->cpumask_bits));
>  
>  	/* optionally wait for the CPUs to complete */
> -	if (wait) {
> +	if (wait)
>  		csd_flag_wait(&data->csd);
> -		if (unlikely(slowpath))
> -			smp_call_function_mask_quiesce_stack(mask);
> -	}
> -
> -	return 0;
>  }
> -EXPORT_SYMBOL(smp_call_function_mask);
> +EXPORT_SYMBOL(smp_call_function_many);
>  
>  /**
>   * smp_call_function(): Run a function on all other CPUs.
> @@ -396,7 +355,7 @@
>   * @info: An arbitrary pointer to pass to the function.
>   * @wait: If true, wait (atomically) until function has completed on other CPUs.
>   *
> - * Returns 0 on success, else a negative status code.
> + * Returns 0.
>   *
>   * If @wait is true, then returns once @func has returned; otherwise
>   * it returns just before the target cpu calls @func. In case of allocation
> @@ -407,12 +366,10 @@
>   */
>  int smp_call_function(void (*func)(void *), void *info, int wait)
>  {
> -	int ret;
> -
>  	preempt_disable();
> -	ret = smp_call_function_mask(cpu_online_map, func, info, wait);
> +	smp_call_function_many(cpu_online_mask, func, info, wait);
>  	preempt_enable();
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL(smp_call_function);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

