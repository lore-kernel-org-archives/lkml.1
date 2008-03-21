Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbYCURmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbYCURmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbYCURmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:42:19 -0400
Received: from www.tglx.de ([62.245.132.106]:32963 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022AbYCURmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:42:18 -0400
Date: Fri, 21 Mar 2008 18:41:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/7] CPA: Add statistics about state of direct mapping
 v2
In-Reply-To: <20080312025333.BAF5F1B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211822220.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025333.BAF5F1B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Andi Kleen wrote:
> Add information about the mapping state of the direct mapping to 
> /proc/meminfo.

Please use debugfs for this.
 
> This way we can see how many large pages are really used for it and how
> many are split.
> 
> Useful for debugging and general insight into the kernel.
> 
> v2: Add hotplug locking to 64bit to plug a very obscure theoretical race. 
>     32bit doesn't need it because it doesn't support hotadd for lowmem.
>     Fix some typos
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/init_32.c     |    2 ++
>  arch/x86/mm/init_64.c     |    2 ++
>  arch/x86/mm/pageattr.c    |   24 ++++++++++++++++++++++++
>  fs/proc/proc_misc.c       |    7 +++++++
>  include/asm-x86/pgtable.h |    3 +++
>  5 files changed, 38 insertions(+)
> 
> Index: linux/arch/x86/mm/init_64.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_64.c
> +++ linux/arch/x86/mm/init_64.c
> @@ -319,6 +319,8 @@ __meminit void early_iounmap(void *addr,
>  static unsigned long __meminit
>  phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
>  {
> +	unsigned long flags;
> +	unsigned pages = 0;

Can we use unsigned long for both please and safe one line ?

>  	int i = pmd_index(address);
>  
>  	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
> @@ -335,9 +337,15 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
>  		if (pmd_val(*pmd))
>  			continue;
>  
> +		pages++;
>  		set_pte((pte_t *)pmd,
>  			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
>  	}
> +
> +	/* Protect against CPA */
> +	spin_lock_irqsave(&pgd_lock, flags);
> +	dpages_cnt[PG_LEVEL_2M] += pages;
> +	spin_unlock_irqrestore(&pgd_lock, flags);

Please make the update a debugfs conditional function in the CPA
code. That way it can be compile out and the statistic internals are
not scattered all over the place.

> @@ -356,6 +364,8 @@ phys_pmd_update(pud_t *pud, unsigned lon
>  static unsigned long __meminit
>  phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
>  {
> +	unsigned long flags;
> +	unsigned pages = 0;
>  	unsigned long true_end = end;

See above.

>  	int i = pud_index(addr);
>  
> @@ -380,6 +390,7 @@ phys_pud_init(pud_t *pud_page, unsigned 
>  		}
>  
>  		if (direct_gbpages) {
> +			dpages_cnt[PG_LEVEL_1G]++;
>  			set_pte((pte_t *)pud,
>  				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
>  			true_end = (addr & PUD_MASK) + PUD_SIZE;
> @@ -397,6 +408,11 @@ phys_pud_init(pud_t *pud_page, unsigned 
>  	}
>  	__flush_tlb_all();
>  
> +	/* Protect against CPA */
> +	spin_lock_irqsave(&pgd_lock, flags);
> +	dpages_cnt[PG_LEVEL_1G] += pages;
> +	spin_unlock_irqrestore(&pgd_lock, flags);
> +

See above

>  	return true_end >> PAGE_SHIFT;
>  }
>  
> Index: linux/arch/x86/mm/pageattr.c
> ===================================================================
> --- linux.orig/arch/x86/mm/pageattr.c
> +++ linux/arch/x86/mm/pageattr.c
> @@ -18,6 +18,8 @@
>  #include <asm/pgalloc.h>
>  #include <asm/proto.h>
>  
> +unsigned long dpages_cnt[PG_LEVEL_NUM];

Can we have some intuitive name for that like direct_pages_stats, so
it's clear that it is debug/statistics info ?

>  /*
>   * The current flushing context - we pass it instead of 5 arguments:
>   */
> @@ -499,6 +501,12 @@ static int split_large_page(pte_t *kpte,
>  	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
>  		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
>  
> +	if (address >= (unsigned long)__va(0) &&
> +		address < (unsigned long)__va(end_pfn_map << PAGE_SHIFT)) {
> +		dpages_cnt[level]--;
> +		dpages_cnt[level - 1] += PTRS_PER_PTE;

  inline conditional on DEBUGFS please

> +	}
> +
>  	/*
>  	 * Install the new, split up pagetable. Important details here:
>  	 *
> @@ -948,6 +956,22 @@ bool kernel_page_present(struct page *pa
>  
>  #endif /* CONFIG_DEBUG_PAGEALLOC */
>  
> +#ifdef CONFIG_PROC_FS

debugfs please

Thanks,

	tglx
