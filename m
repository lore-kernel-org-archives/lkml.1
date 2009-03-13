Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbZCMIzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbZCMIzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZCMIzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:55:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:38661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZCMIzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:55:06 -0400
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious pointless
 WARN_ON()s
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
References: <49B91A7E.76E4.0078.0@novell.com>
	 <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 09:54:51 +0100
Message-Id: <1236934491.5188.209.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 01:39 +0000, Jan Beulich wrote:
> Commit-ID:  6a09dfa870ba0ed21b1124539968a36b42660661
> Gitweb:     http://git.kernel.org/tip/6a09dfa870ba0ed21b1124539968a36b42660661
> Author:     Jan Beulich <jbeulich@novell.com>
> AuthorDate: Thu, 12 Mar 2009 13:21:50 +0000
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 02:14:41 +0100
> 
> generic-ipi: eliminate spurious pointless WARN_ON()s
> 
> Namely during early boot, the panic() or BUG() paths may end up in
> smp_call_function_*() with just a single online CPU. In that situation
> the warnings generated are not only meaningless, but also result in
> relevant output being cluttered.
> 
> Therefore, defer the WARN_ON() checks until after the (unaffected from
> the problem that is being attempted to be detected here) cases have
> been handled.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> LKML-Reference: <49B91A7E.76E4.0078.0@novell.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

I don't really like this,.. it moves the WARN_ON to weird locations
without an explanatory comment.

Wouldn't leaving them in place but changing them to:

WARN_ON(irqs_disabled() && system_state == SYSTEM_RUNNING);

be clearer?

> ---
>  kernel/smp.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 7ad2262..37b90a9 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -284,9 +284,6 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  	 */
>  	this_cpu = get_cpu();
>  
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
>  	if (cpu == this_cpu) {
>  		local_irq_save(flags);
>  		func(info);
> @@ -295,6 +292,9 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
>  			struct call_single_data *data = &d;
>  
> +			/* Can deadlock when called with interrupts disabled */
> +			WARN_ON(irqs_disabled());
> +
>  			if (!wait)
>  				data = &__get_cpu_var(csd_data);
>  
> @@ -364,9 +364,6 @@ void smp_call_function_many(const struct cpumask *mask,
>  	unsigned long flags;
>  	int cpu, next_cpu, this_cpu = smp_processor_id();
>  
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
>  	/* So, what's a CPU they want? Ignoring this one. */
>  	cpu = cpumask_first_and(mask, cpu_online_mask);
>  	if (cpu == this_cpu)
> @@ -387,6 +384,9 @@ void smp_call_function_many(const struct cpumask *mask,
>  		return;
>  	}
>  
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
>  	data = &__get_cpu_var(cfd_data);
>  	csd_lock(&data->csd);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

