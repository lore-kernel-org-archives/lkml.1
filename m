Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYJXVqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYJXVqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbYJXVqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:46:12 -0400
Received: from homer.mvista.com ([63.81.120.158]:12054 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYJXVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:46:12 -0400
Message-ID: <49024220.5000908@ct.jp.nec.com>
Date: Fri, 24 Oct 2008 14:46:08 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of call_function_data
References: <49015358.9050308@ct.jp.nec.com> <200810242205.47181.rusty@rustcorp.com.au>
In-Reply-To: <200810242205.47181.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 24 October 2008 15:47:20 Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> The following assignment in smp_call_function_many() may cause unexpected
>> behavior, when !CPUMASK_OFFSTACK.
>> 	data->cpumask = allbutself;
>>
>> Because it copys pointer of stack and the value will be modified after
>> exit from smp_call_function_many().
> 
> Good catch!
> 
>> The type of cpumask field of call_function_data structure should be
>> cpumask_var_t and an operation to assign is needed.
> 
> This makes the lifetime rules dependent on the config option, which is
> complicated.

Okay, I see.

> 
> Your insight into this issue is appreciated: this code is not simple!
> 
> How's this version instead?  It puts the cpumask at the end of the kmalloc,
> and falls back to smp_call_function_single instead of doing obscure
> quiescing stuff.
> 
> (Compiles, untested).

comments below, not tested.

> 
> Thanks!
> Rusty.
> 
> diff -r 60e2190a18cd kernel/smp.c
> --- a/kernel/smp.c	Fri Oct 24 20:22:52 2008 +1100
> +++ b/kernel/smp.c	Fri Oct 24 22:02:59 2008 +1100
> @@ -24,8 +24,8 @@ struct call_function_data {
>  	struct call_single_data csd;
>  	spinlock_t lock;
>  	unsigned int refs;
> -	struct cpumask *cpumask;
>  	struct rcu_head rcu_head;
> +	unsigned long cpumask_bits[];
>  };
>  
>  struct call_single_queue {
> @@ -109,13 +109,13 @@ void generic_smp_call_function_interrupt
>  	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
>  		int refs;
>  
> -		if (!cpumask_test_cpu(cpu, data->cpumask))
> +		if (!cpumask_test_cpu(cpu, to_cpumask(data->cpumask_bits)))
>  			continue;
>  
>  		data->csd.func(data->csd.info);
>  
>  		spin_lock(&data->lock);
> -		cpumask_clear_cpu(cpu, data->cpumask);
> +		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
>  		WARN_ON(data->refs == 0);
>  		data->refs--;
>  		refs = data->refs;
> @@ -265,42 +265,6 @@ void __smp_call_function_single(int cpu,
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
> - * This is needed by smp_call_function_many when using on-stack data, because
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
> -static void smp_call_function_mask_quiesce_stack(const struct cpumask *mask)
> -{
> -	struct call_single_data data;
> -	int cpu;
> -
> -	data.func = quiesce_dummy;
> -	data.info = NULL;
> -
> -	for_each_cpu(cpu, mask) {
> -		data.flags = CSD_FLAG_WAIT;
> -		generic_exec_single(cpu, &data);
> -	}
> -}
> -
>  /**
>   * smp_call_function_many(): Run a function on a set of other CPUs.
>   * @mask: The set of cpus to run on (only runs on online subset).
> @@ -320,73 +284,59 @@ void smp_call_function_many(const struct
>  			    void (*func)(void *), void *info,
>  			    bool wait)
>  {
> -	struct call_function_data d;
> -	struct call_function_data *data = NULL;
> -	cpumask_var_t allbutself;
> +	struct call_function_data *data;
>  	unsigned long flags;
> -	int cpu, num_cpus;
> -	int slowpath = 0;
> +	int cpu, next_cpu;
>  
>  	/* Can deadlock when called with interrupts disabled */
>  	WARN_ON(irqs_disabled());
>  
> -	if (!alloc_cpumask_var(&allbutself, GFP_ATOMIC)) {
> +	/* So, what's a CPU they want?  Ignoring this one. */
> +	cpu = cpumask_first_and(mask, cpu_online_mask);
> +	if (cpu == smp_processor_id())
> +		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
> +	/* Nothing?  We're done. */
> +	if (cpu >= nr_cpu_ids)
> +		return;
> +
> +	/* Do we have another CPU which isn't us? */
> +	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);

I'm not sure,
if next_cpu == smp_processor_id() &&
	cpumask_next_and(next_cpu, ...) >= nr_cpu_ids

we can go fastpath, right?

> +	if (cpu == smp_processor_id())

so, next_cpu == smp_processor_id() ?

> +		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
> +
> +	/* Nope!  Fastpath: do that cpu by itself. */
> +	if (next_cpu >= nr_cpu_ids)
> +		smp_call_function_single(cpu, func, info, wait);

first path, should return here?

> +
> +	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
> +	if (unlikely(!data)) {
>  		/* Slow path. */
>  		for_each_online_cpu(cpu) {
>  			if (cpumask_test_cpu(cpu, mask))

I guess, another issue, should skip when cpu == smp_processor_id().

>  				smp_call_function_single(cpu, func, info, wait);
>  		}
> -		return;
> -	}
> -	cpumask_and(allbutself, cpu_online_mask, mask);
> -	cpumask_clear_cpu(smp_processor_id(), allbutself);
> -	num_cpus = cpumask_weight(allbutself);
> -
> -	/*
> -	 * If zero CPUs, return. If just a single CPU, turn this request
> -	 * into a targetted single call instead since it's faster.
> -	 */
> -	if (!num_cpus)
> -		return;
> -	else if (num_cpus == 1) {
> -		cpu = cpumask_first(allbutself);
> -		smp_call_function_single(cpu, func, info, wait);
> -		goto out;
> -	}
> -
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
> -	data->cpumask = allbutself;
> +	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);

I guess, clear itself is needed.

thanks,
Hiroshi Shimamoto

> +	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
>  
>  	spin_lock_irqsave(&call_function_lock, flags);
>  	list_add_tail_rcu(&data->csd.list, &call_function_queue);
>  	spin_unlock_irqrestore(&call_function_lock, flags);
>  
>  	/* Send a message to all CPUs in the map */
> -	arch_send_call_function_ipi((cpumask_t)*allbutself);
> +	arch_send_call_function_ipi(*to_cpumask(data->cpumask_bits));
>  
>  	/* optionally wait for the CPUs to complete */
> -	if (wait) {
> +	if (wait)
>  		csd_flag_wait(&data->csd);
> -		if (unlikely(slowpath))
> -			smp_call_function_mask_quiesce_stack(allbutself);
> -	}
> -out:
> -	free_cpumask_var(allbutself);
>  }
>  EXPORT_SYMBOL(smp_call_function_many);
>  
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

