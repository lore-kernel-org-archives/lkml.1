Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYHVBxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYHVBxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYHVBxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:53:22 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:34608 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751149AbYHVBxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:53:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e8lCfFkgFIU+w9lOQOXWGYEl/oOCpJkXAS7tl6bkPHL78C9AKAXs5xrqhaY+E4Pl/m44De3POdjeurubCnXYUI0dCJ52xvZEhK+aJmd/9i2cYowC/V/V5BgHw6BbppkTUtOuH3Wv0g16F1G2YzdMymeg36QHPtzQLsNI0f5EsjE=  ;
X-YMail-OSG: LL48YnIVM1m_3TZf7tgIkK0j9hMDodqP_W2UO_zry280DKWy8DuahSPSUFSbSWY_wfAm2NEwRNl5Fo32hpfHLsFeWBV6NdD7ZzdpRmLJRRFkhyOj49ujzY9Hiz8TxPxl7xN5IS6ayHQ9xGQ0EtGFowoLlRAdoy.sBAY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather than rcu
Date: Fri, 22 Aug 2008 11:53:13 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48AE0883.6050701@goop.org>
In-Reply-To: <48AE0883.6050701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221153.13889.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 10:29, Jeremy Fitzhardinge wrote:
> RCU can only control the lifetime of allocated memory blocks, which
> forces all the call structures to be allocated.  This is expensive
> compared to allocating them on the stack, which is the common case for
> synchronous calls.
>
> This patch takes a different approach.  Rather than using RCU, the
> queues are managed under rwlocks.  Adding or removing from the queue
> requires holding the lock for writing, but multiple CPUs can walk the
> queues to process function calls under read locks.  In the common
> case, where the structures are stack allocated, the calling CPU need
> only wait for its call to be done, take the lock for writing and
> remove the call structure.
>
> Lock contention - particularly write vs read - is reduced by using
> multiple queues.

Could be reasonable. Still, it's adding like 4 or 5 more atomic
operations, which will be approaching the cost of a slab allocation.

Another approach to reduce slab allocation cost would be to do the
call_rcu at the caller, in the wait case so we hit the CPU-local
freeing path in slab.


>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  kernel/smp.c |  140
> +++++++++++++++++++++++----------------------------------- 1 file changed,
> 56 insertions(+), 84 deletions(-)
>
> ===================================================================
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -7,8 +7,6 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/percpu.h>
> -#include <linux/rcupdate.h>
> -#include <linux/rculist.h>
>  #include <linux/smp.h>
>  #include <asm/atomic.h>
>
> @@ -26,7 +24,7 @@
>  static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
>  struct ____cacheline_aligned queue {
>  	struct list_head list;
> -	spinlock_t lock;
> +	rwlock_t rwlock;
>  };
>
>  static __cacheline_aligned struct queue call_function_queues[NQUEUES];
> @@ -40,7 +38,7 @@
>  	struct call_single_data csd;
>  	atomic_t refs;
>  	cpumask_t cpumask;
> -	struct rcu_head rcu_head;
> +	struct list_head cull_list;
>  };
>
>  struct call_single_queue {
> @@ -98,15 +96,6 @@
>  		csd_flag_wait(data);
>  }
>
> -static void rcu_free_call_data(struct rcu_head *head)
> -{
> -	struct call_function_data *data;
> -
> -	data = container_of(head, struct call_function_data, rcu_head);
> -
> -	kfree(data);
> -}
> -
>  /*
>   * Invoked by arch to handle an IPI for call function. Must be called with
>   * interrupts disabled.
> @@ -115,17 +104,14 @@
>  {
>  	struct call_function_data *data;
>  	struct queue *queue;
> +	LIST_HEAD(cull_list);
>  	int cpu = get_cpu();
>
>  	queue = &call_function_queues[queue_no];
> -
> -	/*
> -	 * It's ok to use list_for_each_rcu() here even though we may delete
> -	 * 'pos', since list_del_rcu() doesn't clear ->next
> -	 */
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(data, &queue->list, csd.list) {
> -		if (!cpu_isset(cpu, data->cpumask))
> +
> +	read_lock(&queue->rwlock);
> +	list_for_each_entry(data, &queue->list, csd.list) {
> + 		if (!cpu_isset(cpu, data->cpumask))
>  			continue;
>
>  		data->csd.func(data->csd.info);
> @@ -134,22 +120,36 @@
>  		if (!atomic_dec_and_test(&data->refs))
>  			continue;
>
> -		spin_lock(&queue->lock);
> -		list_del_rcu(&data->csd.list);
> -		spin_unlock(&queue->lock);
> -
>  		if (data->csd.flags & CSD_FLAG_WAIT) {
>  			/*
> -			 * serialize stores to data with the flag clear
> -			 * and wakeup
> +			 * Serialize stores to data with the flag
> +			 * clear and wakeup.  Waiter will remove us
> +			 * from the list.
>  			 */
>  			smp_wmb();
>  			data->csd.flags &= ~CSD_FLAG_WAIT;
> +		} else {
> +			/*
> +			 * If there's no waiter, then the data must
> +			 * have been heap-allocated.
> +			 */
> +			BUG_ON(!(data->csd.flags & CSD_FLAG_ALLOC));
> +
> +			list_add_tail(&data->cull_list, &cull_list);
>  		}
> -		if (data->csd.flags & CSD_FLAG_ALLOC)
> -			call_rcu(&data->rcu_head, rcu_free_call_data);
>  	}
> -	rcu_read_unlock();
> +	read_unlock(&queue->rwlock);
> +
> +	if (!list_empty(&cull_list)) {
> +		struct call_function_data *next;
> +
> +		write_lock(&queue->rwlock);
> +		list_for_each_entry_safe(data, next, &cull_list, cull_list) {
> +			list_del(&data->csd.list);
> +			kfree(data);
> +		}
> +		write_unlock(&queue->rwlock);
> +	}
>
>  	put_cpu();
>  }
> @@ -271,42 +271,6 @@
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
> - * This is needed by smp_call_function_mask when using on-stack data,
> because - * a single call function queue is shared by all CPUs, and any CPU
> may pick up - * the data item on the queue at any time before it is
> deleted. So we need to - * ensure that all CPUs have transitioned through a
> quiescent state after - * this call.
> - *
> - * This is a very slow function, implemented by sending synchronous IPIs
> to - * all possible CPUs. For this reason, we have to alloc data rather
> than use - * stack based data even in the case of synchronous calls. The
> stack based - * data is then just used for deadlock/oom fallback which will
> be very rare. - *
> - * If a faster scheme can be made, we could go back to preferring stack
> based - * data -- the data allocation/free is non-zero cost.
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
>   * smp_call_function_mask(): Run a function on a set of other CPUs.
>   * @mask: The set of cpus to run on.
> @@ -332,7 +296,6 @@
>  	cpumask_t allbutself;
>  	unsigned long flags;
>  	int cpu, num_cpus;
> -	int slowpath = 0;
>  	unsigned queue_no;
>  	struct queue *queue;
>
> @@ -359,16 +322,20 @@
>  		return smp_call_function_single(cpu, func, info, wait);
>  	}
>
> -	data = kmalloc(sizeof(*data), GFP_ATOMIC);
> -	if (data) {
> -		data->csd.flags = CSD_FLAG_ALLOC;
> -		if (wait)
> -			data->csd.flags |= CSD_FLAG_WAIT;
> -	} else {
> +	/*
> +	 * Allocate data if it's an async call, otherwise use stack.
> +	 * If the allocation fails, then convert it to a sync call and
> +	 * use the stack anyway.
> +	 */
> +	if (!wait) {
> +		data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +		if (data)
> +			data->csd.flags = CSD_FLAG_ALLOC;
> +	}
> +	if (!data) {
>  		data = &d;
>  		data->csd.flags = CSD_FLAG_WAIT;
>  		wait = 1;
> -		slowpath = 1;
>  	}
>
>  	data->csd.func = func;
> @@ -376,9 +343,9 @@
>  	atomic_set(&data->refs, num_cpus);
>  	data->cpumask = mask;
>
> -	spin_lock_irqsave(&queue->lock, flags);
> -	list_add_tail_rcu(&data->csd.list, &queue->list);
> -	spin_unlock_irqrestore(&queue->lock, flags);
> +	write_lock_irqsave(&queue->rwlock, flags);
> +	list_add_tail(&data->csd.list, &queue->list);
> +	write_unlock_irqrestore(&queue->rwlock, flags);
>
>  	/* Send a message to all CPUs in the map */
>  	arch_send_call_function_ipi(mask);
> @@ -386,8 +353,13 @@
>  	/* optionally wait for the CPUs to complete */
>  	if (wait) {
>  		csd_flag_wait(&data->csd);
> -		if (unlikely(slowpath))
> -			smp_call_function_mask_quiesce_stack(mask);
> +
> +		write_lock_irqsave(&queue->rwlock, flags);
> +		list_del(&data->csd.list);
> +		write_unlock_irqrestore(&queue->rwlock, flags);
> +
> +		/* We should never wait for allocated data. */
> +		BUG_ON(data->csd.flags & CSD_FLAG_ALLOC);
>  	}
>
>  	return 0;
> @@ -425,7 +397,7 @@
>  	int i;
>
>  	for(i = 0; i < NQUEUES; i++)
> -		spin_lock(&call_function_queues[i].lock);
> +		write_lock(&call_function_queues[i].rwlock);
>  }
>
>  void ipi_call_unlock(void)
> @@ -433,7 +405,7 @@
>  	int i;
>
>  	for(i = 0; i < NQUEUES; i++)
> -		spin_unlock(&call_function_queues[i].lock);
> +		write_unlock(&call_function_queues[i].rwlock);
>  }
>
>  void ipi_call_lock_irq(void)
> @@ -443,7 +415,7 @@
>  	spin_lock_irq(&queues_lock);
>
>  	for(i = 0; i < NQUEUES; i++)
> -		spin_lock_nest_lock(&call_function_queues[i].lock, &queues_lock);
> +		write_lock(&call_function_queues[i].rwlock);
>  }
>
>  void ipi_call_unlock_irq(void)
> @@ -451,7 +423,7 @@
>  	int i;
>
>  	for(i = 0; i < NQUEUES; i++)
> -		spin_unlock(&call_function_queues[i].lock);
> +		write_unlock(&call_function_queues[i].rwlock);
>
>  	spin_unlock_irq(&queues_lock);
>  }
> @@ -463,7 +435,7 @@
>
>  	for(i = 0; i < NQUEUES; i++) {
>  		INIT_LIST_HEAD(&call_function_queues[i].list);
> -		spin_lock_init(&call_function_queues[i].lock);
> +		rwlock_init(&call_function_queues[i].rwlock);
>  	}
>
>  	printk(KERN_INFO "smp function calls: using %d/%d queues\n",
