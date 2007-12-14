Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbXLNHMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbXLNHMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXLNHMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:12:24 -0500
Received: from gw.goop.org ([64.81.55.164]:60733 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXLNHMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:12:23 -0500
Message-ID: <47622CC5.3060903@goop.org>
Date: Thu, 13 Dec 2007 23:12:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix ref-counting bug in change_page_attr()
References: <47610AB5.76E4.0078.0@novell.com>
In-Reply-To: <47610AB5.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> When either calling change_page_attr() with the default attributes
> pages in the direct mapping have and a page's attributes already were
> set to the default or when changing the attributes from one non-default
> value to another, the reference counting broke, leading to either
> premature restoration of a large page or missing the opportunity to do
> so.
>
> At the same time, make __PHYSICAL_MASK_SHIFT on 64-bits the value it
> architecturally ought to have.
>   

Could you put this in a separate patch?  I have a bunch of page*.h and
pgtable*.h refactoring patches which will conflict with this.

    J

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Andi Kleen <ak@suse.de>
>
>  arch/x86/mm/ioremap_64.c     |    4 +-
>  arch/x86/mm/pageattr_32.c    |   84 +++++++++++++++++++++++++++++--------------
>  arch/x86/mm/pageattr_64.c    |   57 +++++++++++++++++++----------
>  include/asm-x86/page_32.h    |   10 +++++
>  include/asm-x86/page_64.h    |    2 -
>  include/asm-x86/pgtable_32.h |    3 +
>  include/asm-x86/pgtable_64.h |    4 +-
>  7 files changed, 114 insertions(+), 50 deletions(-)
>
> --- linux-2.6.24-rc5/arch/x86/mm/ioremap_64.c	2007-12-12 11:28:18.000000000 +0100
> +++ 2.6.24-rc5-x86-change_page_attr/arch/x86/mm/ioremap_64.c	2007-12-04 16:01:11.000000000 +0100
> @@ -48,7 +48,7 @@ ioremap_change_attr(unsigned long phys_a
>   		 * Must use a address here and not struct page because the phys addr
>  		 * can be a in hole between nodes and not have an memmap entry.
>  		 */
> -		err = change_page_attr_addr(vaddr,npages,__pgprot(__PAGE_KERNEL|flags));
> +		err = change_page_attr_addr(vaddr,npages,MAKE_GLOBAL(__PAGE_KERNEL|flags));
>  		if (!err)
>  			global_flush_tlb();
>  	}
> @@ -199,7 +199,7 @@ void iounmap(volatile void __iomem *addr
>  
>  	/* Reset the direct mapping. Can block */
>  	if (p->flags >> 20)
> -		ioremap_change_attr(p->phys_addr, p->size, 0);
> +		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
>  
>  	/* Finally remove it */
>  	o = remove_vm_area((void *)addr);
> --- linux-2.6.24-rc5/arch/x86/mm/pageattr_32.c	2007-12-12 11:28:18.000000000 +0100
> +++ 2.6.24-rc5-x86-change_page_attr/arch/x86/mm/pageattr_32.c	2007-12-04 16:01:11.000000000 +0100
> @@ -116,24 +116,22 @@ static void set_pmd_pte(pte_t *kpte, uns
>  	spin_unlock_irqrestore(&pgd_lock, flags);
>  }
>  
> +static pgprot_t _ref_prot[KERNEL_PGD_PTRS * PTRS_PER_PMD];
> +#define ref_prot(addr) _ref_prot[__pa(addr) >> PMD_SHIFT]
> +
>  /* 
>   * No more special protections in this 2/4MB area - revert to a
>   * large page again. 
>   */
>  static inline void revert_page(struct page *kpte_page, unsigned long address)
>  {
> -	pgprot_t ref_prot;
>  	pte_t *linear;
>  
> -	ref_prot =
> -	((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
> -		? PAGE_KERNEL_LARGE_EXEC : PAGE_KERNEL_LARGE;
> -
>  	linear = (pte_t *)
>  		pmd_offset(pud_offset(pgd_offset_k(address), address), address);
>  	set_pmd_pte(linear,  address,
> -		    pfn_pte((__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT,
> -			    ref_prot));
> +		    pte_mkhuge(pfn_pte((__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT,
> +				       ref_prot(address))));
>  }
>  
>  static inline void save_page(struct page *kpte_page)
> @@ -142,12 +140,22 @@ static inline void save_page(struct page
>  		list_add(&kpte_page->lru, &df_list);
>  }
>  
> +static inline int pgprot_match(pgprot_t prot1, pgprot_t prot2)
> +{
> +	return !((pgprot_val(prot1) ^ pgprot_val(prot2))
> +#ifdef CONFIG_X86_PAE
> +		 & __supported_pte_mask
> +#endif
> +		 & ~(_PAGE_ACCESSED|_PAGE_DIRTY));
> +}
> +
>  static int
>  __change_page_attr(struct page *page, pgprot_t prot)
>  { 
>  	pte_t *kpte; 
>  	unsigned long address;
>  	struct page *kpte_page;
> +	pgprot_t old_prot, ref_prot;
>  
>  	BUG_ON(PageHighMem(page));
>  	address = (unsigned long)page_address(page);
> @@ -159,29 +167,31 @@ __change_page_attr(struct page *page, pg
>  	BUG_ON(PageLRU(kpte_page));
>  	BUG_ON(PageCompound(kpte_page));
>  
> -	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
> +	old_prot = pte_pgprot(pte_clrhuge(*kpte));
> +	ref_prot = ref_prot(address);
> +	if (!pgprot_match(prot, ref_prot)) {
>  		if (!pte_huge(*kpte)) {
>  			set_pte_atomic(kpte, mk_pte(page, prot)); 
>  		} else {
> -			pgprot_t ref_prot;
> -			struct page *split;
> -
> -			ref_prot =
> -			((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
> -				? PAGE_KERNEL_EXEC : PAGE_KERNEL;
> -			split = split_large_page(address, prot, ref_prot);
> -			if (!split)
> +			BUG_ON(!pgprot_match(old_prot, ref_prot));
> +			kpte_page = split_large_page(address, prot, ref_prot);
> +			if (!kpte_page)
>  				return -ENOMEM;
> -			set_pmd_pte(kpte,address,mk_pte(split, ref_prot));
> -			kpte_page = split;
> +			set_pmd_pte(kpte, address,
> +				    mk_pte(kpte_page, PAGE_KERNEL_EXEC));
> +		}
> +		if (!PageReserved(kpte_page)
> +		    && pgprot_match(old_prot, ref_prot))
> +			page_private(kpte_page)++;
> +	} else if (!pgprot_match(ref_prot, old_prot)) {
> +		BUG_ON(pte_huge(*kpte));
> +		set_pte_atomic(kpte, mk_pte(page, ref_prot));
> +		if (!PageReserved(kpte_page)) {
> +			BUG_ON(page_private(kpte_page) == 0);
> +			page_private(kpte_page)--;
>  		}
> -		page_private(kpte_page)++;
> -	} else if (!pte_huge(*kpte)) {
> -		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
> -		BUG_ON(page_private(kpte_page) == 0);
> -		page_private(kpte_page)--;
>  	} else
> -		BUG();
> +		return 0;
>  
>  	/*
>  	 * If the pte was reserved, it means it was created at boot
> @@ -190,8 +200,17 @@ __change_page_attr(struct page *page, pg
>  	 */
>  
>  	save_page(kpte_page);
> -	if (!PageReserved(kpte_page)) {
> -		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
> +	if (!PageReserved(kpte_page) && cpu_has_pse) {
> +		if (page_private(kpte_page) == PTRS_PER_PTE) {
> +			unsigned i;
> +
> +			kpte = page_address(kpte_page);
> +			for (i = 0; i < PTRS_PER_PTE; ++i, ++kpte)
> +				if (pgprot_match(pte_pgprot(*kpte), prot))
> +					page_private(kpte_page)--;
> +			ref_prot(address) = prot;
> +		}
> +		if (page_private(kpte_page) == 0) {
>  			paravirt_release_pt(page_to_pfn(kpte_page));
>  			revert_page(kpte_page, address);
>  		}
> @@ -222,8 +241,21 @@ int change_page_attr(struct page *page, 
>  	int err = 0; 
>  	int i; 
>  	unsigned long flags;
> +	static char first = 1;
>  
>  	spin_lock_irqsave(&cpa_lock, flags);
> +
> +	if (unlikely(first)) {
> +		unsigned long addr = PAGE_OFFSET & PMD_MASK;
> +
> +		/* This must match is_kernel_text(). */
> +		for (; addr <= (unsigned long)__init_end; addr += PMD_SIZE)
> +			ref_prot(addr) = PAGE_KERNEL_EXEC;
> +		for (; addr > PAGE_OFFSET; addr += PMD_SIZE)
> +			ref_prot(addr) = PAGE_KERNEL;
> +		first = 0;
> +	}
> +
>  	for (i = 0; i < numpages; i++, page++) { 
>  		err = __change_page_attr(page, prot);
>  		if (err) 
> --- linux-2.6.24-rc5/arch/x86/mm/pageattr_64.c	2007-12-12 11:28:18.000000000 +0100
> +++ 2.6.24-rc5-x86-change_page_attr/arch/x86/mm/pageattr_64.c	2007-12-04 16:01:11.000000000 +0100
> @@ -98,8 +98,14 @@ static inline void save_page(struct page
>  		list_add(&fpage->lru, &deferred_pages);
>  }
>  
> +/* protected by init_mm.mmap_sem */
> +static pgprot_t kref_prot[] =	{
> +	[0 ... (KERNEL_TEXT_SIZE - 1) >> PMD_SHIFT] = PAGE_KERNEL_EXEC
> +};
> +#define kref_prot(kaddr) kref_prot[((kaddr) - __START_KERNEL_map) >> PMD_SHIFT]
> +
>  /* 
> - * No more special protections in this 2/4MB area - revert to a
> + * No more special protections in this 2MB area - revert to a
>   * large page again. 
>   */
>  static void revert_page(unsigned long address, pgprot_t ref_prot)
> @@ -122,55 +128,68 @@ static void revert_page(unsigned long ad
>  	set_pte((pte_t *)pmd, large_pte);
>  }      
>  
> +static inline int pgprot_match(pgprot_t prot1, pgprot_t prot2)
> +{
> +	return !((pgprot_val(prot1) ^ pgprot_val(prot2))
> +		 & __supported_pte_mask & ~(_PAGE_ACCESSED|_PAGE_DIRTY));
> +}
> +
>  static int
>  __change_page_attr(unsigned long address, unsigned long pfn, pgprot_t prot,
>  				   pgprot_t ref_prot)
>  { 
>  	pte_t *kpte; 
>  	struct page *kpte_page;
> -	pgprot_t ref_prot2;
> +	pgprot_t old_prot;
>  
>  	kpte = lookup_address(address);
>  	if (!kpte) return 0;
> -	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
> +	kpte_page = virt_to_page(kpte);
>  	BUG_ON(PageLRU(kpte_page));
>  	BUG_ON(PageCompound(kpte_page));
> -	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
> +	old_prot = pte_pgprot(pte_clrhuge(*kpte));
> +	if (!pgprot_match(prot, ref_prot)) {
>  		if (!pte_huge(*kpte)) {
>  			set_pte(kpte, pfn_pte(pfn, prot));
>  		} else {
> - 			/*
> -			 * split_large_page will take the reference for this
> -			 * change_page_attr on the split page.
> - 			 */
> -			struct page *split;
> -			ref_prot2 = pte_pgprot(pte_clrhuge(*kpte));
> -			split = split_large_page(address, prot, ref_prot2);
> -			if (!split)
> +			BUG_ON(!pgprot_match(old_prot, ref_prot));
> +			kpte_page = split_large_page(address, prot, ref_prot);
> +			if (!kpte_page)
>  				return -ENOMEM;
> -			pgprot_val(ref_prot2) &= ~_PAGE_NX;
> -			set_pte(kpte, mk_pte(split, ref_prot2));
> -			kpte_page = split;
> +			set_pte(kpte, mk_pte(kpte_page, PAGE_KERNEL_EXEC));
>  		}
> -		page_private(kpte_page)++;
> -	} else if (!pte_huge(*kpte)) {
> +		if (pgprot_match(old_prot, ref_prot))
> +			page_private(kpte_page)++;
> +	} else if (!pgprot_match(ref_prot, old_prot)) {
> +		BUG_ON(pte_huge(*kpte));
>  		set_pte(kpte, pfn_pte(pfn, ref_prot));
>  		BUG_ON(page_private(kpte_page) == 0);
>  		page_private(kpte_page)--;
>  	} else
> -		BUG();
> +		return 0;
>  
>  	/* on x86-64 the direct mapping set at boot is not using 4k pages */
>   	BUG_ON(PageReserved(kpte_page));
>  
>  	save_page(kpte_page);
> +	if (page_private(kpte_page) == PTRS_PER_PTE
> +	    && address >= __START_KERNEL_map
> +	    && address < __START_KERNEL_map + KERNEL_TEXT_SIZE) {
> +		unsigned i;
> +
> +		kpte = page_address(kpte_page);
> +		for (i = 0; i < PTRS_PER_PTE; ++i, ++kpte)
> +			if (pgprot_match(pte_pgprot(*kpte), prot))
> +				page_private(kpte_page)--;
> +		kref_prot(address) = ref_prot = prot;
> +	}
>  	if (page_private(kpte_page) == 0)
>  		revert_page(address, ref_prot);
>  	return 0;
>  } 
>  
>  /*
> - * Change the page attributes of an page in the linear mapping.
> + * Change the page attributes of a page in the linear mapping.
>   *
>   * This should be used when a page is mapped with a different caching policy
>   * than write-back somewhere - some CPUs do not like it when mappings with
> --- linux-2.6.24-rc5/include/asm-x86/page_32.h	2007-12-12 11:29:30.000000000 +0100
> +++ 2.6.24-rc5-x86-change_page_attr/include/asm-x86/page_32.h	2007-12-04 16:01:11.000000000 +0100
> @@ -6,6 +6,16 @@
>  #define PAGE_SIZE	(1UL << PAGE_SHIFT)
>  #define PAGE_MASK	(~(PAGE_SIZE-1))
>  
> +#ifdef CONFIG_X86_PAE
> +#define __PHYSICAL_MASK_SHIFT	52
> +#define __PHYSICAL_MASK		((1ULL << __PHYSICAL_MASK_SHIFT) - 1)
> +#define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE - 1ULL) & __PHYSICAL_MASK)
> +#else
> +#define __PHYSICAL_MASK_SHIFT	32
> +#define __PHYSICAL_MASK		(~0UL)
> +#define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
> +#endif
> +
>  #define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
>  #define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
>  
> --- linux-2.6.24-rc5/include/asm-x86/page_64.h	2007-12-12 11:29:30.000000000 +0100
> +++ 2.6.24-rc5-x86-change_page_attr/include/asm-x86/page_64.h	2007-12-04 16:01:11.000000000 +0100
> @@ -98,7 +98,7 @@ extern unsigned long phys_base;
>  #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
>  
>  /* See Documentation/x86_64/mm.txt for a description of the memory map. */
> -#define __PHYSICAL_MASK_SHIFT	46
> +#define __PHYSICAL_MASK_SHIFT	52
>  #define __PHYSICAL_MASK		((_AC(1,UL) << __PHYSICAL_MASK_SHIFT) - 1)
>  #define __VIRTUAL_MASK_SHIFT	48
>  #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
> --- linux-2.6.24-rc5/include/asm-x86/pgtable_32.h	2007-12-12 11:29:30.000000000 +0100
> +++ 2.6.24-rc5-x86-change_page_attr/include/asm-x86/pgtable_32.h	2007-12-04 16:01:11.000000000 +0100
> @@ -228,11 +228,14 @@ static inline int pte_file(pte_t pte)		{
>  static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte_low &= ~_PAGE_DIRTY; return pte; }
>  static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte_low &= ~_PAGE_ACCESSED; return pte; }
>  static inline pte_t pte_wrprotect(pte_t pte)	{ (pte).pte_low &= ~_PAGE_RW; return pte; }
> +static inline pte_t pte_clrhuge(pte_t pte)	{ (pte).pte_low &= ~_PAGE_PSE; return pte; }
>  static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte_low |= _PAGE_DIRTY; return pte; }
>  static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte_low |= _PAGE_ACCESSED; return pte; }
>  static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
>  static inline pte_t pte_mkhuge(pte_t pte)	{ (pte).pte_low |= _PAGE_PSE; return pte; }
>  
> +#define pte_pgprot(pte) (__pgprot(pte_val(pte) & ~PHYSICAL_PAGE_MASK))
> +
>  #ifdef CONFIG_X86_PAE
>  # include <asm/pgtable-3level.h>
>  #else
> --- linux-2.6.24-rc5/include/asm-x86/pgtable_64.h	2007-12-12 11:29:30.000000000 +0100
> +++ 2.6.24-rc5-x86-change_page_attr/include/asm-x86/pgtable_64.h	2007-12-04 16:01:11.000000000 +0100
> @@ -344,9 +344,9 @@ static inline int pmd_large(pmd_t pte) {
>  #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
>  #define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
>  
> -#define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
> +#define pte_to_pgoff(pte) (pte_val(pte) >> PAGE_SHIFT)
>  #define pgoff_to_pte(off) ((pte_t) { ((off) << PAGE_SHIFT) | _PAGE_FILE })
> -#define PTE_FILE_MAX_BITS __PHYSICAL_MASK_SHIFT
> +#define PTE_FILE_MAX_BITS (64 - PAGE_SHIFT)
>  
>  /* PTE - Level 1 access. */
>  
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

