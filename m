Return-Path: <linux-kernel-owner+w=401wt.eu-S934216AbXC0Wmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbXC0Wmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbXC0Wmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:42:38 -0400
Received: from xenotime.net ([66.160.160.81]:36520 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934216AbXC0Wmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:42:36 -0400
Date: Tue, 27 Mar 2007 15:43:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] Simplify smp_call_function*() by using common
 implementation
Message-Id: <20070327154357.f9335623.rdunlap@xenotime.net>
In-Reply-To: <46099709.2000304@goop.org>
References: <46099709.2000304@goop.org>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 15:13:29 -0700 Jeremy Fitzhardinge wrote:

> smp_call_function and smp_call_function_single are almost complete
> duplicates of the same logic.  This patch combines them by
> implementing them in terms of the more general
> smp_call_function_mask().
> 
> [ Jan, Andi: This only changes arch/i386; can x86_64 be changed in the
>   same way? ]
> 
> [ Rebased onto Jan's x86_64-mm-consolidate-smp_send_stop patch ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Jan Beulich <jbeulich@novell.com>
> Cc: Stephane Eranian <eranian@hpl.hp.com>
> Cc: Andrew Morton <akpm@osdl.org>
> Cc: Andi Kleen <ak@suse.de>
> Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> ---
>  arch/i386/kernel/smp.c |  177 +++++++++++++++++++++++-------------------------
>  1 file changed, 86 insertions(+), 91 deletions(-)
> 
> ===================================================================
> --- a/arch/i386/kernel/smp.c
> +++ b/arch/i386/kernel/smp.c

> @@ -544,6 +559,34 @@ static void __smp_call_function(void (*f
>  	if (wait)
>  		while (atomic_read(&data.finished) != cpus)
>  			cpu_relax();
> +
> +	return 0;
> +}
> +
> +/**
> + * smp_call_function_mask(): Run a function on a set of other CPUs.
> + * @mask: The set of cpus to run on.  Must not include the current cpu.
> + * @func: The function to run. This must be fast and non-blocking.
> + * @info: An arbitrary pointer to pass to the function.
> + * @wait: If true, wait (atomically) until function has completed on other CPUs.
> + *
> + * Returns 0 on success, else a negative status code. Does not return until
> + * remote CPUs are nearly ready to execute <<func>> or are or have finished.

                                              func() or <what>??
      and what does "nearly ready" mean?

> + *
> + * You must not call this function with disabled interrupts or from a
> + * hardware interrupt handler or from a bottom half handler.
> + */
> +int smp_call_function_mask(cpumask_t mask,
> +			     void (*func)(void *), void *info,
> +			     int wait)
> +{
> +	int ret;
> +
> +	spin_lock(&call_lock);
> +	ret = __smp_call_function_mask(mask, func, info, wait);
> +	spin_unlock(&call_lock);
> +
> +	return ret;
>  }
>  
>  /**
> @@ -559,20 +602,43 @@ static void __smp_call_function(void (*f
>   * You must not call this function with disabled interrupts or from a
>   * hardware interrupt handler or from a bottom half handler.
>   */
> -int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
> -			int wait)
> -{
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
> -	/* Holding any lock stops cpus from going down. */
> -	spin_lock(&call_lock);
> -	__smp_call_function(func, info, nonatomic, wait);
> -	spin_unlock(&call_lock);
> -
> -	return 0;
> +int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
> +		      int wait)
> +{
> +	return smp_call_function_mask(cpu_online_map, func, info, wait);
>  }
>  EXPORT_SYMBOL(smp_call_function);
> +
> +/*

   /**

> + * smp_call_function_single - Run a function on another CPU
> + * @func: The function to run. This must be fast and non-blocking.
> + * @info: An arbitrary pointer to pass to the function.
> + * @nonatomic: Currently unused.
> + * @wait: If true, wait until function has completed on other CPUs.
> + *
> + * Retrurns 0 on success, else a negative status code.

      Returns

> + *
> + * Does not return until the remote CPU is nearly ready to execute <func>

Same comments:  what is "nearly ready"?  and s/<func>/func()/

> + * or is or has executed.

      Huh?  or what??

> + */
> +int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> +			     int nonatomic, int wait)
> +{
> +	/* prevent preemption and reschedule on another processor */
> +	int ret;
> +	int me = get_cpu();
> +	if (cpu == me) {
> +		WARN_ON(1);
> +		put_cpu();
> +		return -EBUSY;
> +	}
> +
> +	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
> +
> +	put_cpu();
> +	return ret;
> +}
> +EXPORT_SYMBOL(smp_call_function_single);
>  
>  static void stop_this_cpu (void * dummy)
>  {

> @@ -641,77 +707,6 @@ fastcall void smp_call_function_interrup
>  	}
>  }
>  
> -/*
> - * this function sends a 'generic call function' IPI to one other CPU
> - * in the system.
> - *
> - * cpu is a standard Linux logical CPU number.
> - */
> -static void
> -__smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> -				int nonatomic, int wait)
> -{
> -	struct call_data_struct data;
> -	int cpus = 1;
> -
> -	data.func = func;
> -	data.info = info;
> -	atomic_set(&data.started, 0);
> -	data.wait = wait;
> -	if (wait)
> -		atomic_set(&data.finished, 0);
> -
> -	call_data = &data;
> -	wmb();
> -	/* Send a message to all other CPUs and wait for them to respond */
> -	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_VECTOR);
> -
> -	/* Wait for response */
> -	while (atomic_read(&data.started) != cpus)
> -		cpu_relax();
> -
> -	if (!wait)
> -		return;
> -
> -	while (atomic_read(&data.finished) != cpus)
> -		cpu_relax();
> -}
> -
> -/*
> - * smp_call_function_single - Run a function on another CPU
> - * @func: The function to run. This must be fast and non-blocking.
> - * @info: An arbitrary pointer to pass to the function.
> - * @nonatomic: Currently unused.
> - * @wait: If true, wait until function has completed on other CPUs.
> - *
> - * Retrurns 0 on success, else a negative status code.
> - *
> - * Does not return until the remote CPU is nearly ready to execute <func>
> - * or is or has executed.
> - */
> -
> -int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> -			int nonatomic, int wait)
> -{
> -	/* prevent preemption and reschedule on another processor */
> -	int me = get_cpu();
> -	if (cpu == me) {
> -		WARN_ON(1);
> -		put_cpu();
> -		return -EBUSY;
> -	}
> -
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
> -	spin_lock_bh(&call_lock);
> -	__smp_call_function_single(cpu, func, info, nonatomic, wait);
> -	spin_unlock_bh(&call_lock);
> -	put_cpu();
> -	return 0;
> -}
> -EXPORT_SYMBOL(smp_call_function_single);
> -
>  static int convert_apicid_to_cpu(int apic_id)
>  {
>  	int i;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
