Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYKMTzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYKMTzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYKMTyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:54:54 -0500
Received: from cmpxchg.org ([85.214.51.133]:53382 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYKMTyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:54:52 -0500
Date: Thu, 13 Nov 2008 20:53:41 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
Message-ID: <20081113195341.GA8299@cmpxchg.org>
References: <491C61B1.10005@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491C61B1.10005@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

On Thu, Nov 13, 2008 at 09:19:45AM -0800, Jeremy Fitzhardinge wrote:
> remap_pte_range() just wants to apply a function over a range of ptes
> corresponding to a virtual address range.  That's exactly what
> apply_to_page_range() does, so use it.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> mm/memory.c |   92 
> ++++++++++++-----------------------------------------------
> 1 file changed, 20 insertions(+), 72 deletions(-)
> 
> ===================================================================
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1472,69 +1472,20 @@
> }
> EXPORT_SYMBOL(vm_insert_mixed);
> 
> -/*
> - * maps a range of physical memory into the requested pages. the old
> - * mappings are removed. any references to nonexistent pages results
> - * in null mappings (currently treated as "copy-on-access")
> - */
> -static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
> -			unsigned long addr, unsigned long end,
> -			unsigned long pfn, pgprot_t prot)
> +struct remap_data {
> +	struct mm_struct *mm;
> +	unsigned long pfn;
> +	pgprot_t prot;
> +};
> +
> +static int remap_area_pte_fn(pte_t *ptep, pgtable_t token,
> +			     unsigned long addr, void *data)
> {
> -	pte_t *pte;
> -	spinlock_t *ptl;
> +	struct remap_data *rmd = data;
> +	pte_t pte = pte_mkspecial(pfn_pte(rmd->pfn++, rmd->prot));
> 
> -	pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
> -	if (!pte)
> -		return -ENOMEM;
> -	arch_enter_lazy_mmu_mode();
> -	do {
> -		BUG_ON(!pte_none(*pte));

Dropping by intention?

> -		set_pte_at(mm, addr, pte, pte_mkspecial(pfn_pte(pfn, prot)));
> -		pfn++;
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> -	arch_leave_lazy_mmu_mode();
> -	pte_unmap_unlock(pte - 1, ptl);
> -	return 0;
> -}
> +	set_pte_at(rmd->mm, addr, ptep, pte);
> 
> -static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
> -			unsigned long addr, unsigned long end,
> -			unsigned long pfn, pgprot_t prot)
> -{
> -	pmd_t *pmd;
> -	unsigned long next;
> -
> -	pfn -= addr >> PAGE_SHIFT;
> -	pmd = pmd_alloc(mm, pud, addr);
> -	if (!pmd)
> -		return -ENOMEM;
> -	do {
> -		next = pmd_addr_end(addr, end);
> -		if (remap_pte_range(mm, pmd, addr, next,
> -				pfn + (addr >> PAGE_SHIFT), prot))
> -			return -ENOMEM;
> -	} while (pmd++, addr = next, addr != end);
> -	return 0;
> -}
> -
> -static inline int remap_pud_range(struct mm_struct *mm, pgd_t *pgd,
> -			unsigned long addr, unsigned long end,
> -			unsigned long pfn, pgprot_t prot)
> -{
> -	pud_t *pud;
> -	unsigned long next;
> -
> -	pfn -= addr >> PAGE_SHIFT;
> -	pud = pud_alloc(mm, pgd, addr);
> -	if (!pud)
> -		return -ENOMEM;
> -	do {
> -		next = pud_addr_end(addr, end);
> -		if (remap_pmd_range(mm, pud, addr, next,
> -				pfn + (addr >> PAGE_SHIFT), prot))
> -			return -ENOMEM;
> -	} while (pud++, addr = next, addr != end);
> 	return 0;
> }
> 
> @@ -1551,10 +1502,9 @@
> int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
> 		    unsigned long pfn, unsigned long size, pgprot_t prot)
> {
> -	pgd_t *pgd;
> -	unsigned long next;
> 	unsigned long end = addr + PAGE_ALIGN(size);
> 	struct mm_struct *mm = vma->vm_mm;
> +	struct remap_data rmd;
> 	int err;
> 
> 	/*
> @@ -1584,16 +1534,14 @@
> 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
> 
> 	BUG_ON(addr >= end);
> -	pfn -= addr >> PAGE_SHIFT;
> -	pgd = pgd_offset(mm, addr);
> -	flush_cache_range(vma, addr, end);

Was the flushing redundant?  I can't spot it reappearing anywhere.

	Hannes
