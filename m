Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbYKTDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbYKTDWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 22:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKTDWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 22:22:04 -0500
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:41084 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751918AbYKTDWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 22:22:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bDsu/+gDZi1lGnAQPG6+P1ZngMotkVewY3FeQVJuvqonmOWt4x+8z9C3tmOnNYym5l9tof/9OD2w8xIPlk1kKBTjKfxW8cdhZiCudjSLHVlrkUOGUtF5Hsj7HKkxnNkAyiI2HCp4kiJOYx5c5U1aVUL0+irYY3BvCaVfKE4CTms=  ;
X-YMail-OSG: zxdjQpIVM1nZf6R_Tkya9pyHQewgeJqsSpZTo_qHI_qIup_0Yv2WSdNnisOC1bULTHsCmBUl3IostjzNL6Fu1RdTyP0ML_KEjuwYFe6wHEDJ_kaLFOJdCO1ExnOSUCgJxenFAXIcsAA_gkb3PAfBd5Yg.u5Q7baeUT5wo.o0fYfC2cGXsqxv756uTRt8Uvu79B7smu8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] cpumask: smp_call_function_many()
Date: Thu, 20 Nov 2008 14:21:49 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, npiggin@suse.de, axboe@kernel.dk
References: <20081119144710.59CA1DDDDB@ozlabs.org>
In-Reply-To: <20081119144710.59CA1DDDDB@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201421.50518.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008 01:45, Rusty Russell wrote:

>  /**
> - * smp_call_function_mask(): Run a function on a set of other CPUs.
> - * @mask: The set of cpus to run on.
> + * smp_call_function_many(): Run a function on a set of other CPUs.
> + * @mask: The set of cpus to run on (only runs on online subset).
>   * @func: The function to run. This must be fast and non-blocking.
>   * @info: An arbitrary pointer to pass to the function.
>   * @wait: If true, wait (atomically) until function has completed on other
> CPUs. - *
> - * Returns 0 on success, else a negative status code.
>   *
>   * If @wait is true, then returns once @func has returned. Note that @wait
>   * will be implicitly turned on in case of allocation failures, since
> @@ -319,53 +281,55 @@
>   * hardware interrupt handler or from a bottom half handler. Preemption
>   * must be disabled when calling this function.
>   */
> -int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void
> *info, -			   int wait)
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

I don't like changing of this whole smp_call_function_many scheme
with no justification or even hint of it in the changelog.

Of course it is obvious that smp_call_function_mask can be implemented
with multiple call singles. But some architectures that can do
broadcast IPIs (or otherwise a little extra work eg. in programming
the interrupt controller) will lose here.

Also the locking and cacheline behaviour is probably actually worse.
Having the calling CPU have to bring in remote cachelines from N
other CPUs, then to have the remote CPUs bring them back is not
necessarily better than having the calling CPU bring in one cacheline,
then have the remote CPUs share it amongst one another. Actually it
seems like it could easily be worse. Not to mention taking N locks
and doing N allocations and other "straight line" slowdowns.

Actually, if "mask" tends to be quite a bit smaller than the size of
the system, doing multiple call singles probably is a better idea as
it actually could scale better. But what does that? IPI user TLB
flushing at least on x86 goes via a different route. Kernel TLB
flushing (which is what I was concerned about when working on this
code) always calls out to all CPUs.
