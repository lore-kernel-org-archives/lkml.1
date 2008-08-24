Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYHXIJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYHXIJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYHXIIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:08:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:34429 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbYHXIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:08:50 -0400
Message-ID: <48B1170C.4050706@colorfullife.com>
Date: Sun, 24 Aug 2008 10:08:44 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com>
In-Reply-To: <20080821234318.GA1754@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> +/*
> + * Definition for node within the RCU grace-period-detection hierarchy.
> + */
> +struct rcu_node {
> +	spinlock_t lock;
> +	unsigned long	qsmask;	/* CPUs or groups that need to switch in      */
> +				/*  order for current grace period to proceed.*/
> +	unsigned long	qsmaskinit;
> +				/* Per-GP initialization for qsmask.	      */
>   
I'm not sure if a bitmap is the right storage. If I understand the code 
correctly, it contains two information:
1) If the bitmap is clear, then all cpus have completed whatever they 
need to do.
A counter is more efficient than a bitmap. Especially: It would allow to 
choose the optimal fan-out, independent from 32/64 bits.
2) The information if the current cpu must do something to complete the 
current period.non
This is a local information, usually (always?) only the current cpu 
needs to know if it must do something.
But this doesn't need to be stored in a shared structure, the 
information could be stored in a per-cpu structure.

> +	/*
> +	 * Extract the list of ready callbacks, disabling to prevent
> +	 * races with call_rcu() from interrupt handlers.
> +	 */
> +	local_irq_save(flags);
> +	list = rdp->nxtlist;
> +	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
> +	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
> +	tail = rdp->nxttail[RCU_DONE_TAIL];
> +	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
> +		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
> +			rdp->nxttail[count] = &rdp->nxtlist;
> +	local_irq_restore(flags);
>   
Do you have a description of the events between call_rcu() and the rcu 
callback?
Is the following description correct?

__call_rcu() queues in RCU_NEXT_TAIL.
In the middle of the current grace period: rcu_check_quiescent_state() 
calls rcu_next_callbacks_are_ready().
Entry now in RCU_NEXT_READY_TAIL
** 0.5 cycles: wait until all cpus have completed the current cycle.
rcu_process_gp_end() moves from NEXT_READY_TAIL to WAIT_TAIL

** full grace period
rcu_process_gp_end() moves from WAIT_TAIL to DONE_TAIL
rcu_do_batch() finds the entries in DONE_TAIL and calls the callback.


> +/*
> + * Do softirq processing for the current CPU.
> + */
>  static void rcu_process_callbacks(struct softirq_action *unused)
>  {
>  	/*
>  	 * Memory references from any prior RCU read-side critical sections
> -	 * executed by the interrupted code must be see before any RCU
> +	 * executed by the interrupted code must be seen before any RCU
>  	 * grace-period manupulations below.
>  	 */
>  
>  	smp_mb(); /* See above block comment. */
>   
Why this mb()? There was a grace period between the last read side 
critical section that might have accessed the pointer.
The rcu internal code already does spin_lock()+spin_unlock(). Isn't that 
sufficient?

>  
> -	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
> -	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
> +	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
> +	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
>   
Have you considered merging RCU_DONE_TAIL for rcu_data and rcu_bh_data?

> +
> +/**
> + * call_rcu - Queue an RCU callback for invocation after a grace period.
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual update function to be invoked after the grace period
> + *
> + * The update function will be invoked some time after a full grace
> + * period elapses, in other words after all currently executing RCU
> + * read-side critical sections have completed.  RCU read-side critical
> + * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
> + * and may be nested.
> + */
>   
The docbook entry is duplicated: They are in include/linux/rcupdate.h 
and here.
What about removing one of them?
I would go one step further:
Even add call_rcu_sched() into rcupdate.h. Add a Kconfig bool 
"RCU_NEEDS_SCHED" and automatically define either the extern or the #define.

--
    Manfred
