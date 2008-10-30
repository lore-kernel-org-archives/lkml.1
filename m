Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYJ3HVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYJ3HVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYJ3HVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:21:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49588 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYJ3HVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:21:43 -0400
Date: Thu, 30 Oct 2008 08:20:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, jeremy.fitzhardinge@citrix.com,
       nickpiggin@yahoo.com.au, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, asit.k.mallick@intel.com
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081030072029.GK31673@kernel.dk>
References: <20081029224229.GK30573@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029224229.GK30573@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29 2008, Suresh Siddha wrote:
> While looking at some other issue recently, we encountered this smp_mb()
> placement issue.  x86 specific code also needs some similar fixes. Patch for
> that will follow soon.
> 
> Please review the appended generic-ipi fix.

Looks good, nice debugging! A few comments below.

> 
> thanks,
> suresh
> ---
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: generic-ipi: fix the smp_mb() placement
> 
> smp_mb() is needed (to make the memory operations visible globally) before
> sending the ipi on the sender and the receiver (on Alpha atleast) needs
> smp_read_barrier_depends() in the handler before reading the call_single_queue
> list in a lock-free fashion.
> 
> On x86, x2apic mode register accesses for sending IPI's don't have serializing
> semantics. So the need for smp_mb() before sending the IPI becomes more
> critical in x2apic mode.
> 
> Remove the unnecessary smp_mb() in csd_flag_wait(), as the presence of that
> smp_mb() doesn't mean anything on the sender, when the ipi receiver is not
> doing any thing special (like memory fence) after clearing the CSD_FLAG_WAIT.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index f362a85..75c8dde 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -51,10 +51,6 @@ static void csd_flag_wait(struct call_single_data *data)
>  {
>  	/* Wait for response */
>  	do {
> -		/*
> -		 * We need to see the flags store in the IPI handler
> -		 */
> -		smp_mb();
>  		if (!(data->flags & CSD_FLAG_WAIT))
>  			break;
>  		cpu_relax();
> @@ -76,6 +72,11 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
>  	list_add_tail(&data->list, &dst->list);
>  	spin_unlock_irqrestore(&dst->lock, flags);
>  
> +	/*
> +	 * Make the list addition visible before sending the ipi.
> +	 */
> +	smp_mb();
> +
>  	if (ipi)
>  		arch_send_call_function_single_ipi(cpu);

We can downgrade this to a smp_wmb().

>  
> @@ -157,7 +158,7 @@ void generic_smp_call_function_single_interrupt(void)
>  	 * Need to see other stores to list head for checking whether
>  	 * list is empty without holding q->lock
>  	 */
> -	smp_mb();
> +	smp_read_barrier_depends();
>  	while (!list_empty(&q->list)) {
>  		unsigned int data_flags;
>  
> @@ -191,7 +192,7 @@ void generic_smp_call_function_single_interrupt(void)
>  		/*
>  		 * See comment on outer loop
>  		 */
> -		smp_mb();
> +		smp_read_barrier_depends();
>  	}
>  }
>  
> @@ -370,6 +371,11 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
>  	list_add_tail_rcu(&data->csd.list, &call_function_queue);
>  	spin_unlock_irqrestore(&call_function_lock, flags);
>  
> +	/*
> +	 * Make the list addition visible before sending the ipi.
> +	 */
> +	smp_mb();
> +
>  	/* Send a message to all CPUs in the map */
>  	arch_send_call_function_ipi(mask);

Ditto

-- 
Jens Axboe

