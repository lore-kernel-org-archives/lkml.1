Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXGZOj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXGZOj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbXGZOjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:39:49 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3043 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbXGZOjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:39:48 -0400
Message-ID: <46A8B22E.1060000@shadowen.org>
Date: Thu, 26 Jul 2007 15:39:42 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: 2.6.23-rc1-mm1 sparsemem_vmemamp fix.
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070726215840.efd7b85f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070726215840.efd7b85f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Fix sparsemem_vmemmap init. sorry if known bug.
> 
> This patch fixes page table handling in sparsemem_vmammap.
> 
> Without this, part of vmem_map is not mapped because each section's start addr of
> mem_map is not aligned to PGD/PMD/PUD. 
> (In ia64, secion's mem_map size is 3670016bytes. )
> 
> for example, 
> 
>  addr     pmd_addr_end(addr_end)         addr + PMD_SIZE
>   |XXXXXXXXXX|??????????????????????????????|XXXXXXXXXXXXXXXXXX
> 
>   X ... initialized vmem_map
>   ? ... not intialized
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I think the code change below is safe enough.  I have not found it easy
to understand your description above but I think that you are saying
that if the section we are initialising is bigger than a PMD size, but
falls offset from the PMD start we will initialise the end of the first
PMD and the end of the second PMD and so on.  The "start" of the second
PMD is missed.

Ahh yes, that I think is what your diagram shows.  Yes this is pretty
clearly wrong for any sort of offset initialisation, and would be worse
lower down in the hierachy.  This seems like a clean way to fix the bug.
 Thanks for finding this.

Acked-by: Andy Whitcroft <apw@shadowen.org>

> 
> 
> 
> ---
>  mm/sparse.c |   24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> Index: devel-2.6.23-rc1-mm1/mm/sparse.c
> ===================================================================
> --- devel-2.6.23-rc1-mm1.orig/mm/sparse.c
> +++ devel-2.6.23-rc1-mm1/mm/sparse.c
> @@ -320,7 +320,7 @@ static int __meminit vmemmap_populate_pt
>  {
>  	pte_t *pte;
>  
> -	for (pte = pte_offset_map(pmd, addr); addr < end;
> +	for (pte = pte_offset_kernel(pmd, addr); addr < end;
>  						pte++, addr += PAGE_SIZE)
>  		if (pte_none(*pte)) {
>  			pte_t entry;
> @@ -345,9 +345,10 @@ int __meminit vmemmap_populate_pmd(pud_t
>  {
>  	pmd_t *pmd;
>  	int error = 0;
> +	unsigned long next;
>  
>  	for (pmd = pmd_offset(pud, addr); addr < end && !error;
> -						pmd++, addr += PMD_SIZE) {
> +						pmd++, addr = next) {
>  		if (pmd_none(*pmd)) {
>  			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
>  			if (!p)
> @@ -357,9 +358,8 @@ int __meminit vmemmap_populate_pmd(pud_t
>  		} else
>  			vmemmap_verify((pte_t *)pmd, node,
>  					pmd_addr_end(addr, end), end);
> -
> -		error = vmemmap_populate_pte(pmd, addr,
> -					pmd_addr_end(addr, end), node);
> +		next = pmd_addr_end(addr, end);
> +		error = vmemmap_populate_pte(pmd, addr, next, node);
>  	}
>  	return error;
>  }
> @@ -370,9 +370,10 @@ static int __meminit vmemmap_populate_pu
>  {
>  	pud_t *pud;
>  	int error = 0;
> +	unsigned long next;
>  
>  	for (pud = pud_offset(pgd, addr); addr < end && !error;
> -						pud++, addr += PUD_SIZE) {
> +						pud++, addr = next) {
>  		if (pud_none(*pud)) {
>  			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
>  			if (!p)
> @@ -380,8 +381,8 @@ static int __meminit vmemmap_populate_pu
>  
>  			pud_populate(&init_mm, pud, p);
>  		}
> -		error = vmemmap_populate_pmd(pud, addr,
> -					pud_addr_end(addr, end), node);
> +		next = pud_addr_end(addr, end);
> +		error = vmemmap_populate_pmd(pud, addr, next, node);
>  	}
>  	return error;
>  }
> @@ -392,13 +393,14 @@ int __meminit vmemmap_populate(struct pa
>  	pgd_t *pgd;
>  	unsigned long addr = (unsigned long)start_page;
>  	unsigned long end = (unsigned long)(start_page + nr);
> +	unsigned long next;
>  	int error = 0;
>  
>  	printk(KERN_DEBUG "[%lx-%lx] Virtual memory section"
>  		" (%ld pages) node %d\n", addr, end - 1, nr, node);
>  
>  	for (pgd = pgd_offset_k(addr); addr < end && !error;
> -					pgd++, addr += PGDIR_SIZE) {
> +					pgd++, addr = next) {
>  		if (pgd_none(*pgd)) {
>  			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
>  			if (!p)
> @@ -406,8 +408,8 @@ int __meminit vmemmap_populate(struct pa
>  
>  			pgd_populate(&init_mm, pgd, p);
>  		}
> -		error = vmemmap_populate_pud(pgd, addr,
> -					pgd_addr_end(addr, end), node);
> +		next = pgd_addr_end(addr,end);
> +		error = vmemmap_populate_pud(pgd, addr, next, node);
>  	}
>  	return error;
>  }

-apw

