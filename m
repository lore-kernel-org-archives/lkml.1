Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXDKGgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXDKGgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXDKGgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:36:04 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:29065 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161224AbXDKGgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:36:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=qml3sOryLytSxXlqFD07Ej7RY7WIrNBZv/ndmEsuKfdEcR1DrVuyZVze3Pl/lZGt+SEpgzXupXKroYzokc28lXZ+2Vt6OkBanScgqoIKCU/EMBY31uZC77MDLcaW+ekY9AgT4MX+L6iOcxB7mZ0amG0eHUFzy9UCw+U9avTT7vg=  ;
X-YMail-OSG: 6YZkleoVM1mkDOBmKf59lmpB0Ic6ioaOOjl.uAt4wESTtQ.pTZqTDzNzKuK83ahWNGbqi5XOpHUCTWUSCMcxGazLwvnGmRQMRoRID_rFcZfGUrgz_Ig-
Message-ID: <461C81C0.9040003@yahoo.com.au>
Date: Wed, 11 Apr 2007 16:35:44 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps#2: Move the page walker code to lib/
References: <7.469046093@selenic.com>
In-Reply-To: <7.469046093@selenic.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> Move the page walker code to lib/
> 
> This lets it get shared outside of proc/ and linked in only when
> needed.

Still should go into mm/

If it had, you might have also noticed your pagetable walking code
is completely different from how everyone else does it, and fixed
that too.

BTW. Is it the case that unused and unexported symbols don't get
pruned by the linker except inside lib/?

> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> Index: mm/fs/proc/task_mmu.c
> ===================================================================
> --- mm.orig/fs/proc/task_mmu.c	2007-03-27 22:13:43.000000000 -0500
> +++ mm/fs/proc/task_mmu.c	2007-03-27 22:13:51.000000000 -0500
> @@ -280,123 +280,6 @@ static int clear_refs_pte_range(pmd_t *p
>  	return 0;
>  }
>  
> -struct mm_walk {
> -	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
> -	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
> -	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
> -	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
> -};
> -
> -static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> -			  struct mm_walk *walk, void *private)
> -{
> -	pte_t *pte;
> -	int err;
> -
> -	for (pte = pte_offset_map(pmd, addr); addr != end;
> -	     addr += PAGE_SIZE, pte++) {
> -		if (pte_none(*pte))
> -			continue;
> -		err = walk->pte_entry(pte, addr, addr, private);
> -		if (err) {
> -			pte_unmap(pte);
> -			return err;
> -		}
> -	}
> -	pte_unmap(pte);
> -	return 0;
> -}
> -
> -static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> -			  struct mm_walk *walk, void *private)
> -{
> -	pmd_t *pmd;
> -	unsigned long next;
> -	int err;
> -
> -	for (pmd = pmd_offset(pud, addr); addr != end;
> -	     pmd++, addr = next) {
> -		next = pmd_addr_end(addr, end);
> -		if (pmd_none_or_clear_bad(pmd))
> -			continue;
> -		if (walk->pmd_entry) {
> -			err = walk->pmd_entry(pmd, addr, next, private);
> -			if (err)
> -				return err;
> -		}
> -		if (walk->pte_entry) {
> -			err = walk_pte_range(pmd, addr, next, walk, private);
> -			if (err)
> -				return err;
> -		}
> -	}
> -	return 0;
> -}
> -
> -static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
> -			  struct mm_walk *walk, void *private)
> -{
> -	pud_t *pud;
> -	unsigned long next;
> -	int err;
> -
> -	for (pud = pud_offset(pgd, addr); addr != end;
> -	     pud++, addr = next) {
> -		next = pud_addr_end(addr, end);
> -		if (pud_none_or_clear_bad(pud))
> -			continue;
> -		if (walk->pud_entry) {
> -			err = walk->pud_entry(pud, addr, next, private);
> -			if (err)
> -				return err;
> -		}
> -		if (walk->pmd_entry || walk->pte_entry) {
> -			err = walk_pmd_range(pud, addr, next, walk, private);
> -			if (err)
> -				return err;
> -		}
> -	}
> -	return 0;
> -}
> -
> -/*
> - * walk_page_range - walk a memory map's page tables with a callback
> - * @mm - memory map to walk
> - * @addr - starting address
> - * @end - ending address
> - * @action - callback invoked for every bottom-level (PTE) page table
> - * @private - private data passed to the callback function
> - *
> - * Recursively walk the page table for the memory area in a VMA, calling
> - * a callback for every bottom-level (PTE) page table.
> - */
> -static int walk_page_range(struct mm_struct *mm,
> -			   unsigned long addr, unsigned long end,
> -			   struct mm_walk *walk, void *private)
> -{
> -	pgd_t *pgd;
> -	unsigned long next;
> -	int err;
> -
> -	for (pgd = pgd_offset(mm, addr); addr != end;
> -	     pgd++, addr = next) {
> -		next = pgd_addr_end(addr, end);
> -		if (pgd_none_or_clear_bad(pgd))
> -			continue;
> -		if (walk->pgd_entry) {
> -			err = walk->pgd_entry(pgd, addr, next, private);
> -			if (err)
> -				return err;
> -		}
> -		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
> -			err = walk_pud_range(pgd, addr, next, walk, private);
> -			if (err)
> -				return err;
> -		}
> -	}
> -	return 0;
> -}
> -
>  static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
>  
>  static int show_smap(struct seq_file *m, void *v)
> Index: mm/include/linux/mm.h
> ===================================================================
> --- mm.orig/include/linux/mm.h	2007-03-27 22:13:42.000000000 -0500
> +++ mm/include/linux/mm.h	2007-03-27 22:13:51.000000000 -0500
> @@ -747,6 +747,16 @@ unsigned long unmap_vmas(struct mmu_gath
>  		struct vm_area_struct *start_vma, unsigned long start_addr,
>  		unsigned long end_addr, unsigned long *nr_accounted,
>  		struct zap_details *);
> +
> +struct mm_walk {
> +	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
> +	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
> +	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
> +	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
> +};
> +
> +int walk_page_range(struct mm_struct *, unsigned long addr, unsigned long end,
> +		    struct mm_walk *walk, void *private);
>  void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
>  		unsigned long end, unsigned long floor, unsigned long ceiling);
>  void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
> Index: mm/lib/Makefile
> ===================================================================
> --- mm.orig/lib/Makefile	2007-03-27 22:14:09.000000000 -0500
> +++ mm/lib/Makefile	2007-03-27 22:16:49.000000000 -0500
> @@ -7,7 +7,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
>  	 idr.o div64.o int_sqrt.o bitmap.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o
>  
> -lib-$(CONFIG_MMU) += ioremap.o
> +lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
>  lib-$(CONFIG_SMP) += cpumask.o
>  
>  lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
> Index: mm/lib/pagewalk.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ mm/lib/pagewalk.c	2007-03-27 22:18:37.000000000 -0500
> @@ -0,0 +1,111 @@
> +#include <linux/mm.h>
> +
> +static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> +			  struct mm_walk *walk, void *private)
> +{
> +	pte_t *pte;
> +	int err;
> +
> +	for (pte = pte_offset_map(pmd, addr); addr != end;
> +	     addr += PAGE_SIZE, pte++) {
> +		if (pte_none(*pte))
> +			continue;
> +		err = walk->pte_entry(pte, addr, addr, private);
> +		if (err) {
> +			pte_unmap(pte);
> +			return err;
> +		}
> +	}
> +	pte_unmap(pte);
> +	return 0;
> +}
> +
> +static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> +			  struct mm_walk *walk, void *private)
> +{
> +	pmd_t *pmd;
> +	unsigned long next;
> +	int err;
> +
> +	for (pmd = pmd_offset(pud, addr); addr != end;
> +	     pmd++, addr = next) {
> +		next = pmd_addr_end(addr, end);
> +		if (pmd_none_or_clear_bad(pmd))
> +			continue;
> +		if (walk->pmd_entry) {
> +			err = walk->pmd_entry(pmd, addr, next, private);
> +			if (err)
> +				return err;
> +		}
> +		if (walk->pte_entry) {
> +			err = walk_pte_range(pmd, addr, next, walk, private);
> +			if (err)
> +				return err;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
> +			  struct mm_walk *walk, void *private)
> +{
> +	pud_t *pud;
> +	unsigned long next;
> +	int err;
> +
> +	for (pud = pud_offset(pgd, addr); addr != end;
> +	     pud++, addr = next) {
> +		next = pud_addr_end(addr, end);
> +		if (pud_none_or_clear_bad(pud))
> +			continue;
> +		if (walk->pud_entry) {
> +			err = walk->pud_entry(pud, addr, next, private);
> +			if (err)
> +				return err;
> +		}
> +		if (walk->pmd_entry || walk->pte_entry) {
> +			err = walk_pmd_range(pud, addr, next, walk, private);
> +			if (err)
> +				return err;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * walk_page_range - walk a memory map's page tables with a callback
> + * @mm - memory map to walk
> + * @addr - starting address
> + * @end - ending address
> + * @walk - set of callbacks to invoke for each level of the tree
> + * @private - private data passed to the callback function
> + *
> + * Recursively walk the page table for the memory area in a VMA, calling
> + * a callback for every bottom-level (PTE) page table.
> + */
> +int walk_page_range(struct mm_struct *mm,
> +		    unsigned long addr, unsigned long end,
> +		    struct mm_walk *walk, void *private)
> +{
> +	pgd_t *pgd;
> +	unsigned long next;
> +	int err;
> +
> +	for (pgd = pgd_offset(mm, addr); addr != end;
> +	     pgd++, addr = next) {
> +		next = pgd_addr_end(addr, end);
> +		if (pgd_none_or_clear_bad(pgd))
> +			continue;
> +		if (walk->pgd_entry) {
> +			err = walk->pgd_entry(pgd, addr, next, private);
> +			if (err)
> +				return err;
> +		}
> +		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
> +			err = walk_pud_range(pgd, addr, next, walk, private);
> +			if (err)
> +				return err;
> +		}
> +	}
> +	return 0;
> +}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
SUSE Labs, Novell Inc.
