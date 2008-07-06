Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYGFRVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYGFRVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYGFRV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:21:29 -0400
Received: from gw.goop.org ([64.81.55.164]:40406 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYGFRV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:21:28 -0400
Message-ID: <4870FF0E.80200@goop.org>
Date: Sun, 06 Jul 2008 10:21:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
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
>   

Does this have any users?  Proposed users?

> +{
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
>   

Can it be reasonably be used without FLAG_WAIT set?  If it doesn't have 
FLAG_WAIT, it must have FLAG_ALLOC set, but it can't have FLAG_ALLOC if 
the csd structure is embedded in something else.

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
>   

What prevents us from changing cpus?  Are all callers supposed to 
disable preemption?  If so, should we WARN for it?

> +	allbutself = cpu_online_map;
> +	cpu_clear(cpu, allbutself);
> +	cpus_and(mask, mask, allbutself);
> +	num_cpus = cpus_weight(mask);
>   

Ditto: What prevents the online map changing under our feet?  Is 
disabling preemption enough?

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
>   

It's weirdly inconsistent that smp_call_function_mask will ignore the 
current cpu if its in the mask, but smp_call_function_single will call 
the function locally if the specified cpu is the current one.  I know 
this is a hold-over from the old code, but could we finally fix it now?  
I guess it's still reasonable for smp_call_function to call on 
everywhere but current cpu, but it can do its own mask manipulation to 
sort that out.

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
>   
Should this test for data->csd.flags & CDS_FLAG_WAIT?  Or should the "if 
(!data)" path above also set "wait"?

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
>   

