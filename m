Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYF2CWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYF2CWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 22:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYF2CW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 22:22:29 -0400
Received: from gw.goop.org ([64.81.55.164]:34647 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbYF2CW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 22:22:28 -0400
Message-ID: <4866F1DF.50203@goop.org>
Date: Sat, 28 Jun 2008 19:22:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v4
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806271538.46829.yhlu.kernel@gmail.com> <200806272247.11971.yhlu.kernel@gmail.com> <200806281749.02000.yhlu.kernel@gmail.com>
In-Reply-To: <200806281749.02000.yhlu.kernel@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> some end boundary is only page alignment, instead of 2M alignment,
> so call ker_phycial_mapping_init three times.
> then don't overmap above the max_low_pfn
>
> v2: make init_memory_mapping more solid: start could be any value other than 0
> v3: fix NON PAE by handling left over in kernel_physical_mapping
> v4: revert back to v2, and use PMD_SHIFT to calculate boundary
>     also adjust size for pre-allocated table size
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> ---
>  arch/x86/mm/init_32.c |  101 +++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 75 insertions(+), 26 deletions(-)
>
> Index: linux-2.6/arch/x86/mm/init_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init_32.c
> +++ linux-2.6/arch/x86/mm/init_32.c
> @@ -184,8 +184,9 @@ static inline int is_kernel_text(unsigne
>   * PAGE_OFFSET:
>   */
>  static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
> -						unsigned long start,
> -						unsigned long end)
> +						unsigned long start_pfn,
> +						unsigned long end_pfn,
> +						int use_pse)
>  {
>  	int pgd_idx, pmd_idx, pte_ofs;
>  	unsigned long pfn;
> @@ -193,32 +194,33 @@ static void __init kernel_physical_mappi
>  	pmd_t *pmd;
>  	pte_t *pte;
>  	unsigned pages_2m = 0, pages_4k = 0;
> -	unsigned limit_pfn = end >> PAGE_SHIFT;
>  
> -	pgd_idx = pgd_index(PAGE_OFFSET);
> -	pgd = pgd_base + pgd_idx;
> -	pfn = start >> PAGE_SHIFT;
> +	if (!cpu_has_pse)
> +		use_pse = 0;
>  
> +	pfn = start_pfn;
> +	pgd_idx = pgd_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
> +	pgd = pgd_base + pgd_idx;
>  	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
>  		pmd = one_md_table_init(pgd);
> -		if (pfn >= limit_pfn)
> -			continue;
>  
> -		for (pmd_idx = 0;
> -		     pmd_idx < PTRS_PER_PMD && pfn < limit_pfn;
> +		if (pfn >= end_pfn)
> +			continue;
> +#ifdef CONFIG_X86_PAE
> +		pmd_idx = pmd_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
> +		pmd += pmd_idx;
> +#else
> +		pmd_idx = 0;
> +#endif
>   

We should really define X_index() to return 0 for folded pagetable level 
X.  I've had to put similar #ifdefs in other code.  Also, for the 
purposes of making this code more unifiable, it's probably better to 
test for "#if PAGETABLE_LEVELS >= 3" rather than for PAE specifically.

> +		for (; pmd_idx < PTRS_PER_PMD && pfn < end_pfn;
>  		     pmd++, pmd_idx++) {
>  			unsigned int addr = pfn * PAGE_SIZE + PAGE_OFFSET;
>  
>  			/*
>  			 * Map with big pages if possible, otherwise
>  			 * create normal page tables:
> -			 *
> -			 * Don't use a large page for the first 2/4MB of memory
> -			 * because there are often fixed size MTRRs in there
> -			 * and overlapping MTRRs into large pages can cause
> -			 * slowdowns.
>  			 */
> -			if (cpu_has_pse && !(pgd_idx == 0 && pmd_idx == 0)) {
> +			if (use_pse) {
>  				unsigned int addr2;
>  				pgprot_t prot = PAGE_KERNEL_LARGE;
>  
> @@ -233,13 +235,13 @@ static void __init kernel_physical_mappi
>  				set_pmd(pmd, pfn_pmd(pfn, prot));
>  
>  				pfn += PTRS_PER_PTE;
> -				max_pfn_mapped = pfn;
>  				continue;
>  			}
>  			pte = one_page_table_init(pmd);
>  
> -			for (pte_ofs = 0;
> -			     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
> +			pte_ofs = pte_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
> +			pte += pte_ofs;
> +			for (; pte_ofs < PTRS_PER_PTE && pfn < end_pfn;
>  			     pte++, pfn++, pte_ofs++, addr += PAGE_SIZE) {
>  				pgprot_t prot = PAGE_KERNEL;
>  
> @@ -249,7 +251,6 @@ static void __init kernel_physical_mappi
>  				pages_4k++;
>  				set_pte(pte, pfn_pte(pfn, prot));
>  			}
> -			max_pfn_mapped = pfn;
>  		}
>  	}
>  	update_page_count(PG_LEVEL_2M, pages_2m);
> @@ -729,7 +730,7 @@ void __init setup_bootmem_allocator(void
>  
>  static void __init find_early_table_space(unsigned long end)
>  {
> -	unsigned long puds, pmds, tables, start;
> +	unsigned long puds, pmds, ptes, tables, start;
>  
>  	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
>  	tables = PAGE_ALIGN(puds * sizeof(pud_t));
> @@ -737,10 +738,19 @@ static void __init find_early_table_spac
>  	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
>  	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
>  
> -	if (!cpu_has_pse) {
> -		int ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -		tables += PAGE_ALIGN(ptes * sizeof(pte_t));
> -	}
> +	if (cpu_has_pse) {
> +		unsigned long extra;
> +
> +		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
> +		extra += PMD_SIZE;
>   

Is this the same as "extra = (end + PMD_SIZE + 1) & PMD_MASK"?

> +		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	} else
> +		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +
> +	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
> +
> +	/* for fixmap */
> +	tables += PAGE_SIZE * 2;
>   

Why not correct for fixmaps by putting "ptes += 
__end_of_fixed_addresses;" above?

>  	/*
>  	 * RED-PEN putting page tables only on node 0 could
> @@ -766,6 +776,8 @@ unsigned long __init_refok init_memory_m
>  						unsigned long end)
>  {
>  	pgd_t *pgd_base = swapper_pg_dir;
> +	unsigned long start_pfn, end_pfn;
> +	unsigned long big_page_start;
>  
>  	/*
>  	 * Find space for the kernel direct mapping tables.
> @@ -790,7 +802,44 @@ unsigned long __init_refok init_memory_m
>  		__PAGE_KERNEL_EXEC |= _PAGE_GLOBAL;
>  	}
>  
> -	kernel_physical_mapping_init(pgd_base, start, end);
> +	/*
> +	 * Don't use a large page for the first 2/4MB of memory
> +	 * because there are often fixed size MTRRs in there
> +	 * and overlapping MTRRs into large pages can cause
> +	 * slowdowns.
> +	 */
> +	big_page_start = PMD_SIZE;
> +
> +	if (start < big_page_start) {
> +		start_pfn = start >> PAGE_SHIFT;
> +		end_pfn = min(big_page_start>>PAGE_SHIFT, end>>PAGE_SHIFT);
> +	} else {
> +		/* head is not big page alignment ? */
> +		start_pfn = start >> PAGE_SHIFT;
> +		end_pfn = ((start + PMD_SIZE - 1)>>PMD_SHIFT)
> +				 << (PMD_SHIFT - PAGE_SHIFT);
> +	}
> +	if (start_pfn < end_pfn)
> +		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn, 0);
> +
> +	/* big page range */
> +	start_pfn = ((start + PMD_SIZE - 1)>>PMD_SHIFT)
> +			 << (PMD_SHIFT - PAGE_SHIFT);
> +	if (start_pfn < (big_page_start >> PAGE_SHIFT))
> +		start_pfn =  big_page_start >> PAGE_SHIFT;
> +	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
> +	if (start_pfn < end_pfn)
> +		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn,
> +						cpu_has_pse);
> +
> +	/* tail is not big page alignment ? */
> +	start_pfn = end_pfn;
> +	if (start_pfn > (big_page_start>>PAGE_SHIFT)) {
> +		end_pfn = end >> PAGE_SHIFT;
> +		if (start_pfn < end_pfn)
> +			kernel_physical_mapping_init(pgd_base, start_pfn,
> +							 end_pfn, 0);
> +	}
>  
>  	early_ioremap_page_table_range_init(pgd_base);
>  
>   

    J
