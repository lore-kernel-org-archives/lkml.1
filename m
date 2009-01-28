Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZA1Qlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZA1Qlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZA1Qle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:41:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61863 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZA1Qld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:41:33 -0500
Date: Wed, 28 Jan 2009 11:41:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901281141010.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Duh! I forgot to CC Jens.

-- Steve


On Wed, 28 Jan 2009, Steven Rostedt wrote:

> 
> While developing the RT git tree I came across this deadlock.
> 
> To avoid touching the memory allocator in smp_call_function_many I forced 
> the stack use case, the path that would be taken if data fails to 
> allocate.
> 
> Here's the current code in kernel/smp.c:
> 
> void smp_call_function_many(const struct cpumask *mask,
>                             void (*func)(void *), void *info,
>                             bool wait)
> {
>         struct call_function_data *data;
> [...]
>         data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
>         if (unlikely(!data)) {
>                 /* Slow path. */
>                 for_each_online_cpu(cpu) {
>                         if (cpu == smp_processor_id())
>                                 continue;
>                         if (cpumask_test_cpu(cpu, mask))
>                                 smp_call_function_single(cpu, func, info, 
> wait);
>                 }
>                 return;
>         }
> [...]
> 
> int smp_call_function_single(int cpu, void (*func) (void *info), void 
> *info,
>                              int wait)
> {
>         struct call_single_data d;
> [...]
>                 if (!wait) {
>                         data = kmalloc(sizeof(*data), GFP_ATOMIC);
>                         if (data)
>                                 data->flags = CSD_FLAG_ALLOC;
>                 }
>                 if (!data) {
>                         data = &d;
>                         data->flags = CSD_FLAG_WAIT;
>                 }
> 
> Note that if data failed to allocate, we force the wait state.
> 
> 
> This immediately caused a deadlock with the mtrr code:
> 
>  arch/x86/kernel/cpu/mtrr/main.c:
> 
> static void set_mtrr(unsigned int reg, unsigned long base,
>                      unsigned long size, mtrr_type type)
> {
>         struct set_mtrr_data data;
> [...]
>         /*  Start the ball rolling on other CPUs  */
>         if (smp_call_function(ipi_handler, &data, 0) != 0)
>                 panic("mtrr: timed out waiting for other CPUs\n");
> 
>         local_irq_save(flags);
> 
>         while(atomic_read(&data.count))
>                 cpu_relax();
> 
>         /* ok, reset count and toggle gate */
>         atomic_set(&data.count, num_booting_cpus() - 1);
>         smp_wmb();
>         atomic_set(&data.gate,1);
> 
> [...]
> 
> static void ipi_handler(void *info)
> /*  [SUMMARY] Synchronisation handler. Executed by "other" CPUs.
>     [RETURNS] Nothing.
> */
> {
> #ifdef CONFIG_SMP
>         struct set_mtrr_data *data = info;
>         unsigned long flags;
> 
>         local_irq_save(flags);
> 
>         atomic_dec(&data->count);
>         while(!atomic_read(&data->gate))
>                 cpu_relax();
> 
> 
> The problem is that if we use the stack, then we must wait for the 
> function to finish. But in the mtrr code, the called functions are waiting 
> for the caller to do something after the smp_call_function. Thus we 
> deadlock! This mtrr code seems to have been there for a while. At least 
> longer than the git history.
> 
> To get around this, I did the following hack. Now this may be good 
> enough to handle the case. I'm posting it for comments.
> 
> The patch creates another flag called CSD_FLAG_RELEASE. If we fail
> to alloc the data and the wait bit is not set, we still use the stack
> but we also set this flag instead of the wait flag. The receiving IPI 
> will copy the data locally, and if this flag is set, it will clear it. The 
> caller, after sending the IPI, will wait on this flag to be cleared.
> 
> The difference between this and the wait bit is that the release bit is 
> just a way to let the callee tell the caller that it copied the data and 
> is continuing. The data can be released with no worries. This prevents the 
> deadlock because the caller can continue without waiting for the functions 
> to be called.
> 
> I tested this patch by forcing the data to be null:
> 
> 	data = NULL; // kmalloc(...);
> 
> Also, when forcing data to be NULL on the latest git tree, without 
> applying the patch, I hit a deadlock in testing of the NMI watchdog. This 
> means there may be other areas in the kernel that think smp_call_function, 
> without the wait bit set, expects that function not to ever wait.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 5cfa0e5..e85881b 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -18,6 +18,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
>  enum {
>  	CSD_FLAG_WAIT		= 0x01,
>  	CSD_FLAG_ALLOC		= 0x02,
> +	CSD_FLAG_RELEASE	= 0x04,
>  };
>  
>  struct call_function_data {
> @@ -168,21 +169,32 @@ void generic_smp_call_function_single_interrupt(void)
>  
>  		while (!list_empty(&list)) {
>  			struct call_single_data *data;
> +			struct call_single_data d;
>  
>  			data = list_entry(list.next, struct call_single_data,
>  						list);
>  			list_del(&data->list);
>  
> +			d = *data;
> +			/* Make sure the data was read before released */
> +			smp_mb();
> +			data->flags &= ~CSD_FLAG_RELEASE;
> +
>  			/*
>  			 * 'data' can be invalid after this call if
>  			 * flags == 0 (when called through
>  			 * generic_exec_single(), so save them away before
>  			 * making the call.
>  			 */
> -			data_flags = data->flags;
> +			data_flags = d.flags;
> +			smp_rmb();
>  
> -			data->func(data->info);
> +			d.func(d.info);
>  
> +			/*
> +			 * data still exists if either of these
> +			 * flags are true. We should not use d.
> +			 */
>  			if (data_flags & CSD_FLAG_WAIT) {
>  				smp_wmb();
>  				data->flags &= ~CSD_FLAG_WAIT;
> @@ -230,6 +242,20 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  			data = kmalloc(sizeof(*data), GFP_ATOMIC);
>  			if (data)
>  				data->flags = CSD_FLAG_ALLOC;
> +			else {
> +				/*
> +				 * There exist callers that call
> +				 * functions that will wait on the caller
> +				 * to do something after calling this.
> +				 * This means we can not wait for the callee
> +				 * function to finish.
> +				 * Use the stack data but have the callee
> +				 * copy it and tell us we can continue
> +				 * before they call the function.
> +				 */
> +				data = &d;
> +				data->flags = CSD_FLAG_RELEASE;
> +			}
>  		}
>  		if (!data) {
>  			data = &d;
> @@ -239,6 +265,9 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  		data->func = func;
>  		data->info = info;
>  		generic_exec_single(cpu, data);
> +
> +		while (data->flags & CSD_FLAG_RELEASE)
> +			cpu_relax();
>  	} else {
>  		err = -ENXIO;	/* CPU not online */
>  	}
> 
