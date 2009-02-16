Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZBPTOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZBPTOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZBPTO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:14:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38194 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZBPTO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:14:28 -0500
Date: Mon, 16 Feb 2009 20:10:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] generic-smp: remove single ipi fallback for
	smp_call_function_many()
Message-ID: <20090216191008.GA1521@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216164114.433430761@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Peter Zijlstra wrote:
>
> @@ -347,31 +384,32 @@ void smp_call_function_many(const struct
>  		return;
>  	}
>
> -	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
> -	if (unlikely(!data)) {
> -		/* Slow path. */
> -		for_each_online_cpu(cpu) {
> -			if (cpu == smp_processor_id())
> -				continue;
> -			if (cpumask_test_cpu(cpu, mask))
> -				smp_call_function_single(cpu, func, info, wait);
> -		}
> -		return;
> +	data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +	if (data)
> +		data->csd.flags = CSD_FLAG_ALLOC;
> +	else {
> +		data = &per_cpu(cfd_data, me);
> +		/*
> +		 * We need to wait for all previous users to go away.
> +		 */
> +		while (data->csd.flags & CSD_FLAG_LOCK)
> +			cpu_relax();
> +		data->csd.flags = CSD_FLAG_LOCK;
>  	}
>
>  	spin_lock_init(&data->lock);
> -	data->csd.flags = CSD_FLAG_ALLOC;
>  	if (wait)
>  		data->csd.flags |= CSD_FLAG_WAIT;
>  	data->csd.func = func;
>  	data->csd.info = info;
> -	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
> -	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
> -	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
> -
> -	spin_lock_irqsave(&call_function_lock, flags);
> -	list_add_tail_rcu(&data->csd.list, &call_function_queue);
> -	spin_unlock_irqrestore(&call_function_lock, flags);
> +	cpumask_and(&data->cpumask, mask, cpu_online_mask);
> +	cpumask_clear_cpu(smp_processor_id(), &data->cpumask);

(perhaps it makes sense to use "me" instead of smp_processor_id())

> +	data->refs = cpumask_weight(&data->cpumask);
> +
> +	spin_lock_irqsave(&call_function.lock, flags);
> +	call_function.counter++;
> +	list_add_tail_rcu(&data->csd.list, &call_function.queue);
> +	spin_unlock_irqrestore(&call_function.lock, flags);

What if the initialization above leaks into the critical section?

I mean, generic_smp_call_function_interrupt() running on another CPU
can see the result of list_add_tail_rcu() and cpumask_and(data->cpumask)
but not (say) "data->refs = ...".


Actually I don't understand the counter/free_list logic.

	generic_smp_call_function_interrupt:

			/*
			 * When the global queue is empty, its guaranteed that no cpu
			 * is still observing any entry on the free_list, therefore
			 * we can go ahead and unlock them.
			 */
			if (!--call_function.counter)
				list_splice_init(&call_function.free_list, &free_list);

I can't see why "its guaranteed that no cpu ...". Let's suppose CPU 0
"hangs" for some reason in generic_smp_call_function_interrupt() right
before "if (!cpumask_test_cpu(cpu, data->cpumask))" test. Then it is
possible that another CPU removes the single entry (which doesn't have
CPU 0 in data->cpumask) from call_function.queue.

Now, if that entry is re-added, we can have a problem if CPU 0 sees
the partly initialized entry.

But why do we need counter/free_list at all?
Can't we do the following:

	- initialize call_function_data.lock at boot time

	- change smp_call_function_many() to initialize cfd_data
	  under ->lock

	- change generic_smp_call_function_interrupt() to do

		list_for_each_entry_rcu(data) {

			if (!cpumask_test_cpu(cpu, data->cpumask))
				continue;

			spin_lock(&data->lock);
			if (!cpumask_test_cpu(cpu, data->cpumask)) {
				spin_unlock(data->lock);
				continue;
			}

			cpumask_clear_cpu(cpu, data->cpumask);
			refs = --data->refs;

			func = data->func;
			info = data->info;
			spin_unlock(&data->lock);

			func(info);

			if (refs)
				continue;

			...
		}

Afaics, it is OK if smp_call_function_many() sees the "unneeded" entry on
list, the only thing we must ensure is that we can't "misunderstand" this
entry.

No?


Off-topic question, looks like smp_call_function_single() must not be
called from interrupt/bh handler, right? But the comment says nothing.

And,
	smp_call_function_single:

		/* Can deadlock when called with interrupts disabled */
		WARN_ON(irqs_disabled());
	
Just curious, we can only deadlock if wait = T, right?

Oleg.

