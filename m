Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbZAOLEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbZAOLEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZAOLEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:04:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbZAOLEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:04:10 -0500
Date: Thu, 15 Jan 2009 12:03:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: fix assumed to be contiguous leaf page tables
	for kmap_atomic region
Message-ID: <20090115110352.GC16253@elte.hu>
References: <496DE759.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496DE759.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Debugging and original patch from Nick Piggin <npiggin@suse.de>
> 
> The early fixmap pmd entry inserted at the very top of the KVA is causing the
> subsequent fixmap mapping code to not provide physically linear pte pages over
> the kmap atomic portion of the fixmap (which relies on said property to
> calculate pte addresses).
> 
> This has caused weird boot failures in kmap_atomic much later in the boot
> process (initial userspace faults) on a 32-bit PAE system with a larger number
> of CPUs (smaller CPU counts tend not to run over into the next page so don't
> show up the problem).
> 
> Solve this by attempting to clear out the page table, and copy any of its
> entries to the new one. Also, add a bug if a nonlinear condition is encounted
> and can't be resolved, which might save some hours of debugging if this fragile
> scheme ever breaks again...
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> Once we have such logic, we can also use it to eliminate the early ioremap
> trickery around the page table setup for the fixmap area. This also fixes
> potential issues with FIX_* entries sharing the leaf page table with the early
> ioremap ones getting discarded by early_ioremap_clear() and not restored by
> early_ioremap_reset(). It at once eliminates the temporary (and configuration,
> namely NR_CPUS, dependent) unavailability of early fixed mappings during the
> time the fixmap area page tables get constructed.
> 
> Finally, also replace the hard coded calculation of the initial table space
> needed for the fixmap area with a proper one, allowing kernels configured for
> large CPU counts to actually boot.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/include/asm/io.h |    1 -
>  arch/x86/mm/init_32.c     |   46 +++++++++++++++++++++++++++++++++++++++++++---
>  arch/x86/mm/ioremap.c     |   25 -------------------------
>  3 files changed, 43 insertions(+), 29 deletions(-)

looks good, but could you please do the following cleanup:

> @@ -154,6 +154,11 @@ page_table_range_init(unsigned long star
>  	unsigned long vaddr;
>  	pgd_t *pgd;
>  	pmd_t *pmd;
> +#ifdef CONFIG_HIGHMEM
> +	pte_t *lastpte = NULL;
> +	int pmd_idx_kmap_begin = fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
> +	int pmd_idx_kmap_end = fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
> +#endif
>  
>  	vaddr = start;
>  	pgd_idx = pgd_index(vaddr);
> @@ -165,7 +170,43 @@ page_table_range_init(unsigned long star
>  		pmd = pmd + pmd_index(vaddr);
>  		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
>  							pmd++, pmd_idx++) {
> -			one_page_table_init(pmd);
> +			pte_t *pte;
> +
> +			pte = one_page_table_init(pmd);
> +#ifdef CONFIG_HIGHMEM
> +			/*
> +			 * Something (early fixmap) may already have put a pte
> +			 * page here, which causes the page table allocation
> +			 * to become nonlinear. Attempt to fix it, and if it
> +			 * is still nonlinear then we have to bug.
> +			 */
> +			if (pmd_idx_kmap_begin != pmd_idx_kmap_end
> +			    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
> +			    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
> +			    && ((__pa(pte) >> PAGE_SHIFT) < table_start
> +				|| (__pa(pte) >> PAGE_SHIFT) >= table_end)) {
> +				pte_t *newpte;
> +				int i;
> +
> +				BUG_ON(after_init_bootmem);
> +				newpte = alloc_low_page();
> +				for (i = 0; i < PTRS_PER_PTE; i++)
> +					set_pte(newpte + i, pte[i]);
> +
> +				paravirt_alloc_pte(&init_mm,
> +						   __pa(newpte) >> PAGE_SHIFT);
> +				set_pmd(pmd, __pmd(__pa(newpte)|_PAGE_TABLE));
> +				BUG_ON(newpte != pte_offset_kernel(pmd, 0));
> +				__flush_tlb_all();
> +
> +				paravirt_release_pte(__pa(pte) >> PAGE_SHIFT);
> +				pte = newpte;
> +			}
> +			BUG_ON(vaddr < fix_to_virt(FIX_KMAP_BEGIN - 1)
> +			       && vaddr > fix_to_virt(FIX_KMAP_END)
> +			       && lastpte && lastpte + PTRS_PER_PTE != pte);
> +			lastpte = pte;
> +#endif

please introduce a helper function here. That way both the ugly #ifdefs 
move out of this function (to a more logical place), and the very visible 
80-line length artifacts from the code vanish as well.

Thanks,

	Ingo
