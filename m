Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZEVJUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZEVJUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZEVJUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:20:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:33437 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbZEVJUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:20:45 -0400
Subject: Re: can't flush tlb on e500
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hideo Saito <hsaito.ppc@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090522.095720.68565257.saito@densan.co.jp>
References: <d50492d40905200312r729608a3nf244b153892ac257@mail.gmail.com>
	 <20090522.095720.68565257.saito@densan.co.jp>
Content-Type: text/plain
Date: Fri, 22 May 2009 19:20:41 +1000
Message-Id: <1242984041.26104.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 09:57 +0900, Hideo Saito wrote:
> How about following changes because all TLB entries are flushed
> repeatedly if processes overflow at the table mapping the context.
> I think that the table should be initialized again because _tlbil_pid()
> flushes all TLB entries and tlbilx instruction isn't supported on E500(MPC8548).

Not in this version of the CPU but in others... so we need to be a bit
more careful.

It's true that the current code will mark one context as stale but will
end up flushing them all from the TLB. This does have the
disadvantage that subsequent context switch might want to proceed to
more stealing with flush despite the fact that the TLB is indeed empty.

Your approach seems a bit hackish in the implementation but makes
somewhat sense in effectively disconnecting all context numbers when the
TLB is flushed. It's however not necessarily useable as-is on SMP.

One thing I would try to do in the future for example is to have a
lockless scenario when a context is already assigned. Your approach
would cause, under pressure, contexts to be de-assigned a bit to
aggressively. There are other reasons also why I wouldn't be so eager to
recycle PIDs.

Maybe a better option is to keep separate maps, between assigned
contexts and "dirty" contexts. IE. The current map means assigned. A
context that is switch_mm'ed is marked dirty. We could maybe use that to
make smarter decisions as to when re-assign a PID and when use one that
we know has been flushed out and not re-dirty'ed yet.

Also, it would also make some sense to have flush_tlb_mm() clear the
dirty map in that case as well. In fact, there's a patch coming from
Dave Kleikamp that implements lazy flushing by effectively just
recycling PIDs for flush_tlb_mm() and only do a flush when running out.

Cheers,
Ben.

> --- arch/powerpc/mm/mmu_context_nohash.c.orig	2009-03-24 08:12:14.000000000 +0900
> +++ arch/powerpc/mm/mmu_context_nohash.c	2009-05-21 16:35:09.000000000 +0900
> @@ -107,39 +107,69 @@ static unsigned int steal_context_smp(un
>  	 */
>  	spin_unlock(&context_lock);
>  	cpu_relax();
>  	spin_lock(&context_lock);
>  	goto again;
>  }
>  #endif  /* CONFIG_SMP */
>  
> +/*
> + * We're flushed using the all context
> + */
> +static void flush_all_context(int cpu)
> +{
> +	struct mm_struct *mm;
> +	int n;
> +
> +	for (n = first_context; n <= last_context; n++) {
> +
> +		mm = context_mm[n];
> +		if (mm == NULL || mm->context.id == MMU_NO_CONTEXT)
> +			continue;
> +
> +		WARN_ON(mm->context.active != 0);
> +
> +		mm->context.id = MMU_NO_CONTEXT;
> +	}
> +	memset(stale_map[cpu], 0, CTX_MAP_SIZE);
> +	memset(context_map, 0, CTX_MAP_SIZE);
> +	context_map[0] = (1 << first_context) - 1;
> +	nr_free_contexts = last_context - first_context + 1;
> +}
> +
>  /* Note that this will also be called on SMP if all other CPUs are
>   * offlined, which means that it may be called for cpu != 0. For
>   * this to work, we somewhat assume that CPUs that are onlined
>   * come up with a fully clean TLB (or are cleaned when offlined)
>   */
>  static unsigned int steal_context_up(unsigned int id)
>  {
>  	struct mm_struct *mm;
>  	int cpu = smp_processor_id();
>  
>  	/* Pick up the victim mm */
>  	mm = context_mm[id];
>  
>  	pr_debug("[%d] steal context %d from mm @%p\n", cpu, id, mm);
>  
> -	/* Mark this mm has having no context anymore */
> -	mm->context.id = MMU_NO_CONTEXT;
> -
>  	/* Flush the TLB for that context */
>  	local_flush_tlb_mm(mm);
>  
> +#ifdef CONFIG_FSL_BOOKE
> +	flush_all_context(cpu);
> +	__set_bit(id, context_map);
> +	nr_free_contexts--;
> +#else
> +	/* Mark this mm has having no context anymore */
> +	mm->context.id = MMU_NO_CONTEXT;
> +
>  	/* XXX This clear should ultimately be part of local_flush_tlb_mm */
>  	__clear_bit(id, stale_map[cpu]);
> +#endif
>  
>  	return id;
>  }
>  
>  #ifdef DEBUG_MAP_CONSISTENCY
>  static void context_check_map(void)
>  {
>  	unsigned int id, nrf, nact;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

