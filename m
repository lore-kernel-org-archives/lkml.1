Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYIBO2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYIBO2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYIBO2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:28:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYIBO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:28:09 -0400
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the
	system has paniced
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080902134923.9A7EF3E6A01@basil.firstfloor.org>
References: <20080902349.573187695@firstfloor.org>
	 <20080902134923.9A7EF3E6A01@basil.firstfloor.org>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 16:28:03 +0200
Message-Id: <1220365683.8609.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 15:49 +0200, Andi Kleen wrote:
> panic calls smp_send_stop which eventually calls smp_call_function_*.
> smp_call_function warns about disabled interrupts. But it's legal
> to call panic in this case. When this happens panic() prints
> several ugly backtraces. So don't check for disabled interrupts
> in panic state.

While it might be legal for panic to be called from such contexts, I
understand those warnings are there to warn of deadlocks.

So with the below patch you allow panic to deadlock if I understand
things correctly.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Index: linux/kernel/smp.c
> ===================================================================
> --- linux.orig/kernel/smp.c
> +++ linux/kernel/smp.c
> @@ -216,7 +216,7 @@ int smp_call_function_single(int cpu, vo
>  	int err = 0;
>  
>  	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> +	WARN_ON(system_state < SYSTEM_PANIC && irqs_disabled());
>  
>  	if (cpu == me) {
>  		local_irq_save(flags);
> @@ -260,7 +260,8 @@ EXPORT_SYMBOL(smp_call_function_single);
>  void __smp_call_function_single(int cpu, struct call_single_data *data)
>  {
>  	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
> +	WARN_ON(system_state < SYSTEM_PANIC &&
> +		(data->flags & CSD_FLAG_WAIT) && irqs_disabled());
>  
>  	generic_exec_single(cpu, data);
>  }
> @@ -329,7 +330,7 @@ int smp_call_function_mask(cpumask_t mas
>  	int slowpath = 0;
>  
>  	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> +	WARN_ON(system_state < SYSTEM_PANIC && irqs_disabled());
>  
>  	cpu = smp_processor_id();
>  	allbutself = cpu_online_map;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

