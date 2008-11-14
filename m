Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbYKNCUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbYKNCUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYKNCUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:20:09 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:44246 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750948AbYKNCUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:20:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=10g3ACSjluC7cyJxfOt9ubxw8UFtMblcuPuWnViDZsccrgtNuHlzHR8GX/mPty+EkGytEeloSPJ922o3LvR7UosCwYnyO2oNpC6zPU6ZhHo3I5Rx7/zZYp7ezNXXZvrnb81a2Vu1yyFqKdb5uFGvl9v3wR1di2vQ837Dsclz6ec=  ;
X-YMail-OSG: 4.JES6MVM1k.PWq9iSJfR7umn6mNg_RcoAlV2kfJUL58qi7PmUXg61QSm.Sz4PxqbOSwCkldEP3EWmdkfBnnBLv_lX6Wo61OeCidEQi3bESX0hf6af8M_Ale26cynkV0s.J7Rb33VDHc7oCSHAVfj.e_TUeYMdf6t0GjYIf2MRHGOxsEYjzcjuOgEIAf
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
Date: Fri, 14 Nov 2008 13:19:56 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
References: <491C61B1.10005@goop.org>
In-Reply-To: <491C61B1.10005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811141319.56713.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008 04:19, Jeremy Fitzhardinge wrote:
> remap_pte_range() just wants to apply a function over a range of ptes
> corresponding to a virtual address range.  That's exactly what
> apply_to_page_range() does, so use it.

This isn't performance critical to anyone?

I see DRM, IB, GRU, other media and video drivers use it.

It IS exactly what apply_to_page_range does, I grant you. But so does
our traditional set of nested loops. So is there any particular reason
to change it? You're not planning to change fork/exit next, are you? :)


> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  mm/memory.c |   92
> ++++++++++++----------------------------------------------- 1 file changed,
> 20 insertions(+), 72 deletions(-)
>
> ===================================================================
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1472,69 +1472,20 @@
>  }
>  EXPORT_SYMBOL(vm_insert_mixed);
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
>  {
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
>  	return 0;
>  }
>
> @@ -1551,10 +1502,9 @@
>  int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
>  		    unsigned long pfn, unsigned long size, pgprot_t prot)
>  {
> -	pgd_t *pgd;
> -	unsigned long next;
>  	unsigned long end = addr + PAGE_ALIGN(size);
>  	struct mm_struct *mm = vma->vm_mm;
> +	struct remap_data rmd;
>  	int err;
>
>  	/*
> @@ -1584,16 +1534,14 @@
>  	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
>
>  	BUG_ON(addr >= end);
> -	pfn -= addr >> PAGE_SHIFT;
> -	pgd = pgd_offset(mm, addr);
> -	flush_cache_range(vma, addr, end);
> -	do {
> -		next = pgd_addr_end(addr, end);
> -		err = remap_pud_range(mm, pgd, addr, next,
> -				pfn + (addr >> PAGE_SHIFT), prot);
> -		if (err)
> -			break;
> -	} while (pgd++, addr = next, addr != end);
> +
> +	rmd.mm = mm;
> +	rmd.pfn = pfn;
> +	rmd.prot = prot;
> +
> +	err = apply_to_page_range(mm, addr, end - addr,
> +				  remap_area_pte_fn, &rmd);
> +
>  	return err;
>  }
>  EXPORT_SYMBOL(remap_pfn_range);
