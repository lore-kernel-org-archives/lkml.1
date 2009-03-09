Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZCISVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZCISVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZCISVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:21:14 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45906 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZCISVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:21:13 -0400
Date: Mon, 9 Mar 2009 18:20:31 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Aaro Koskinen <aaro.koskinen@nokia.com>
cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] mm: tlb: Add range to tlb_start_vma() and
 tlb_end_vma()
In-Reply-To: <49B54B2A.9090408@nokia.com>
Message-ID: <Pine.LNX.4.64.0903091810400.17134@blonde.anvils>
References: <49B511E9.8030405@nokia.com> <1236603597-1646-1-git-send-email-Aaro.Koskinen@nokia.com>
 <Pine.LNX.4.64.0903091352430.28665@blonde.anvils> <49B54B2A.9090408@nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Aaro Koskinen wrote:
> Hugh Dickins wrote:
> 
> > I don't see that you need to change the interface and other arches
> > at all.  What prevents ARM from noting the first and last addresses
> > freed in its struct mmu_gather when tlb_remove_tlb_entry() is called
> > (see arch/um/include/asm/tlb.h for an example of that), then using
> > that in its tlb_end_vma() TLB flushing?
> 
> This would probably work, thanks for pointing it out. I should have taken a
> better look of the full API, not just what was implemented in ARM.
> 
> So, there's a new ARM-only patch draft below based on this idea, adding also
> linux-arm-kernel again.

This one is much better, thank you.  I would think it more natural
to do the initialization of range_start and range_end in your
tlb_start_vma() - to complement tlb_end_vma() where you deal with
the final result - rather than in two places you have sited it;
but that's somewhat a matter of taste, your patch should work as is.

Hugh

> 
> ---
> 
> From: Aaro Koskinen <Aaro.Koskinen@nokia.com>
> Subject: [RFC PATCH] [ARM] Flush only the needed range when unmapping VMA
> 
> Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
> ---
>  arch/arm/include/asm/tlb.h |   25 ++++++++++++++++++++++---
>  1 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
> index 857f1df..2729fb9 100644
> --- a/arch/arm/include/asm/tlb.h
> +++ b/arch/arm/include/asm/tlb.h
> @@ -36,6 +36,8 @@
>  struct mmu_gather {
>  	struct mm_struct	*mm;
>  	unsigned int		fullmm;
> +	unsigned long		range_start;
> +	unsigned long		range_end;
>  };
> 
>  DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
> @@ -47,6 +49,8 @@ tlb_gather_mmu(struct mm_struct *mm, unsigned int
> full_mm_flush)
> 
>  	tlb->mm = mm;
>  	tlb->fullmm = full_mm_flush;
> +	tlb->range_start = TASK_SIZE;
> +	tlb->range_end = 0;
> 
>  	return tlb;
>  }
> @@ -63,7 +67,19 @@ tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start,
> unsigned long end)
>  	put_cpu_var(mmu_gathers);
>  }
> 
> -#define tlb_remove_tlb_entry(tlb,ptep,address)	do { } while (0)
> +/*
> + * Memorize the range for the TLB flush.
> + */
> +static inline void
> +tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long addr)
> +{
> +	if (!tlb->fullmm) {
> +		if (addr < tlb->range_start)
> +			tlb->range_start = addr;
> +		if (addr + PAGE_SIZE > tlb->range_end)
> +			tlb->range_end = addr + PAGE_SIZE;
> +	}
> +}
> 
>  /*
>   * In the case of tlb vma handling, we can optimise these away in the
> @@ -80,8 +96,11 @@ tlb_start_vma(struct mmu_gather *tlb, struct vm_area_struct
> *vma)
>  static inline void
>  tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
>  {
> -	if (!tlb->fullmm)
> -		flush_tlb_range(vma, vma->vm_start, vma->vm_end);
> +	if (!tlb->fullmm && tlb->range_end > 0) {
> +		flush_tlb_range(vma, tlb->range_start, tlb->range_end);
> +		tlb->range_start = TASK_SIZE;
> +		tlb->range_end = 0;
> +	}
>  }
> 
>  #define tlb_remove_page(tlb,page)	free_page_and_swap_cache(page)
> -- 
> 1.5.4.3
