Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbZALW5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbZALW5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763180AbZALWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:54:29 -0500
Received: from relay3.sgi.com ([192.48.171.31]:58183 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763292AbZALWy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:54:28 -0500
Message-ID: <496BCA21.2010709@sgi.com>
Date: Mon, 12 Jan 2009 14:54:25 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
CC: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
References: <20090112213539.GA10720@gambetta>
In-Reply-To: <20090112213539.GA10720@gambetta>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> Hi,
> 
> On x86_64 flush tlb data is stored in per_cpu variables. This is
> unnecessary because only the first NUM_INVALIDATE_TLB_VECTORS entries
> are accessed.
> This patch aims at making the code less confusing (there's nothing
> really "per_cpu") by using a plain array. It also would save some memory
> on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).
> 
> Regards,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

Here is the net change in memory usage with this patch on a allyesconfig
with NR_CPUS=4096.

====== Data (-l 500)

    1 - initial
    2 - change-flush-tlb

  .1.    .2.  .delta.
    0   5120   +5120      .  flush_state(.bss)

====== Sections (-l 500)

        .1.    .2.  .delta.
   12685496 12693688       +8192 +0.06%  .bss
    1910176  1909408        -768 -0.04%  .data.percpu

> 
> diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
> index f8be6f1..c177a1f 100644
> --- a/arch/x86/kernel/tlb_64.c
> +++ b/arch/x86/kernel/tlb_64.c
> @@ -33,7 +33,7 @@
>   *	To avoid global state use 8 different call vectors.
>   *	Each CPU uses a specific vector to trigger flushes on other
>   *	CPUs. Depending on the received vector the target CPUs look into
> - *	the right per cpu variable for the flush data.
> + *	the right array slot for the flush data.
>   *
>   *	With more than 8 CPUs they are hashed to the 8 available
>   *	vectors. The limited global vector space forces us to this right now.
> @@ -54,7 +54,7 @@ union smp_flush_state {
>  /* State is put into the per CPU data section, but padded
>     to a full cache line because other CPUs can access it and we don't
>     want false sharing in the per cpu data segment. */
> -static DEFINE_PER_CPU(union smp_flush_state, flush_state);
> +static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
>  
>  /*
>   * We cannot call mmdrop() because we are in interrupt context,
> @@ -129,7 +129,7 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
>  	 * Use that to determine where the sender put the data.
>  	 */
>  	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
> -	f = &per_cpu(flush_state, sender);
> +	f = &flush_state[sender];
>  
>  	if (!cpu_isset(cpu, f->flush_cpumask))
>  		goto out;
> @@ -169,7 +169,7 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
>  
>  	/* Caller has disabled preemption */
>  	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
> -	f = &per_cpu(flush_state, sender);
> +	f = &flush_state[sender];
>  
>  	/*
>  	 * Could avoid this lock when
> @@ -205,8 +205,8 @@ static int __cpuinit init_smp_flush(void)
>  {
>  	int i;
>  
> -	for_each_possible_cpu(i)
> -		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
> +	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
> +		spin_lock_init(&flush_state[i].tlbstate_lock);
>  
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

