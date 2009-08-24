Return-Path: <linux-kernel-owner+w=401wt.eu-S1751509AbZHXFk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbZHXFk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 01:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZHXFk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 01:40:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZHXFk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 01:40:26 -0400
Date: Mon, 24 Aug 2009 07:40:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/pat] generic-ipi: Allow cpus not yet online to call smp_call_function with irqs disabled
Message-ID: <20090824054026.GR25721@wotan.suse.de>
References: <tip-269c861baa2fe7c114c3bc7831292758d29eb336@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-269c861baa2fe7c114c3bc7831292758d29eb336@git.kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 11:51:50PM +0000, Suresh B wrote:
> Commit-ID:  269c861baa2fe7c114c3bc7831292758d29eb336
> Gitweb:     http://git.kernel.org/tip/269c861baa2fe7c114c3bc7831292758d29eb336
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Wed, 19 Aug 2009 18:05:35 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 21 Aug 2009 16:25:43 -0700
> 
> generic-ipi: Allow cpus not yet online to call smp_call_function with irqs disabled
> 
> Because of deadlock possiblities smp_call_function() is not allowed to
> be called with interrupts disabled. Add an exception for the cpu not
> yet online, as no one else can send smp call function interrupt to this
> cpu that is not yet online and as such deadlock condition is not possible.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Acked-by: Nick Piggin <npiggin@suse.de>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

I don't know if we should allow the use of smp_call_function here --
only call_function_single. CPU hotplug code is required to set up
some call_function data and if the cpu is offline then it might not
be set up correctly.

Also, I would say that we should just restrict this to wait==1 case
because in that case the stack can trivially be used for data. In
the wait==0 case, it is more complex. In the current implementation
it should be OK (it uses per-cpu data), but we've used kmalloc
there in the past, which probably wouldn't work either.


> ---
>  kernel/smp.c |   40 ++++++++++++++++++++++++++++++++++------
>  1 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index ad63d85..2accdf6 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -177,6 +177,11 @@ void generic_smp_call_function_interrupt(void)
>  	int cpu = get_cpu();
>  
>  	/*
> +	 * Shouldn't receive this interrupt on a cpu that is not yet online.
> +	 */
> +	WARN_ON_ONCE(!cpu_online(cpu));
> +
> +	/*
>  	 * Ensure entry is visible on call_function_queue after we have
>  	 * entered the IPI. See comment in smp_call_function_many.
>  	 * If we don't have this, then we may miss an entry on the list
> @@ -230,6 +235,11 @@ void generic_smp_call_function_single_interrupt(void)
>  	unsigned int data_flags;
>  	LIST_HEAD(list);
>  
> +	/*
> +	 * Shouldn't receive this interrupt on a cpu that is not yet online.
> +	 */
> +	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
> +
>  	spin_lock(&q->lock);
>  	list_replace_init(&q->list, &list);
>  	spin_unlock(&q->lock);
> @@ -285,8 +295,14 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  	 */
>  	this_cpu = get_cpu();
>  
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
> +	/*
> +	 * Can deadlock when called with interrupts disabled.
> +	 * We allow cpu's that are not yet online though, as no one else can
> +	 * send smp call function interrupt to this cpu and as such deadlocks
> +	 * can't happen.
> +	 */
> +	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> +		     && !oops_in_progress);
>  
>  	if (cpu == this_cpu) {
>  		local_irq_save(flags);
> @@ -329,8 +345,14 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
>  {
>  	csd_lock(data);
>  
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON_ONCE(wait && irqs_disabled() && !oops_in_progress);
> +	/*
> +	 * Can deadlock when called with interrupts disabled.
> +	 * We allow cpu's that are not yet online though, as no one else can
> +	 * send smp call function interrupt to this cpu and as such deadlocks
> +	 * can't happen.
> +	 */
> +	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
> +		     && !oops_in_progress);
>  
>  	generic_exec_single(cpu, data, wait);
>  }
> @@ -365,8 +387,14 @@ void smp_call_function_many(const struct cpumask *mask,
>  	unsigned long flags;
>  	int cpu, next_cpu, this_cpu = smp_processor_id();
>  
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
> +	/*
> +	 * Can deadlock when called with interrupts disabled.
> +	 * We allow cpu's that are not yet online though, as no one else can
> +	 * send smp call function interrupt to this cpu and as such deadlocks
> +	 * can't happen.
> +	 */
> +	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> +		     && !oops_in_progress);
>  
>  	/* So, what's a CPU they want? Ignoring this one. */
>  	cpu = cpumask_first_and(mask, cpu_online_mask);
