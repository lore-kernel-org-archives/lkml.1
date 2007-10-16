Return-Path: <linux-kernel-owner+w=401wt.eu-S1765968AbXJPE6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765968AbXJPE6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 00:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765815AbXJPE6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 00:58:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50628 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765493AbXJPE6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 00:58:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=D763J9KHGwCO6ZVA8lgxFFAqvuLBYd5ystHd9XHUca3yWl3SP8wSEcyU27CtAdTFW
	G9DH7Yn+NR0MuIBuAk9gg==
Date: Mon, 15 Oct 2007 21:58:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 4/11] maps3: introduce a generic page walker
In-Reply-To: <5.290135367@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710152156420.8159@chino.kir.corp.google.com>
References: <5.290135367@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Matt Mackall wrote:

> Introduce a general page table walker
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> Index: l/include/linux/mm.h
> ===================================================================
> --- l.orig/include/linux/mm.h	2007-10-09 17:37:59.000000000 -0500
> +++ l/include/linux/mm.h	2007-10-10 11:46:37.000000000 -0500
> @@ -773,6 +773,17 @@ unsigned long unmap_vmas(struct mmu_gath
>  		struct vm_area_struct *start_vma, unsigned long start_addr,
>  		unsigned long end_addr, unsigned long *nr_accounted,
>  		struct zap_details *);
> +
> +struct mm_walk {
> +	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
> +	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
> +	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
> +	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
> +	int (*pte_hole) (unsigned long, unsigned long, void *);
> +};
> +
> +int walk_page_range(struct mm_struct *, unsigned long addr, unsigned long end,
> +		    struct mm_walk *walk, void *private);

The struct mm_walk * can be qualified as const.

> Index: l/mm/pagewalk.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ l/mm/pagewalk.c	2007-10-10 11:46:37.000000000 -0500
> @@ -0,0 +1,120 @@
> +#include <linux/mm.h>
> +#include <linux/highmem.h>
> +#include <linux/sched.h>
> +
> +static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> +			  struct mm_walk *walk, void *private)
> +{
> +	pte_t *pte;
> +	int err = 0;
> +
> +	pte = pte_offset_map(pmd, addr);
> +	do {
> +		err = walk->pte_entry(pte, addr, addr, private);
> +		if (err)
> +		       break;
> +	} while (pte++, addr += PAGE_SIZE, addr != end);
> +
> +	pte_unmap(pte);
> +	return err;
> +}
> +
> +static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> +			  struct mm_walk *walk, void *private)
> +{
> +	pmd_t *pmd;
> +	unsigned long next;
> +	int err = 0;
> +
> +	pmd = pmd_offset(pud, addr);
> +	do {
> +		next = pmd_addr_end(addr, end);
> +		if (pmd_none_or_clear_bad(pmd)) {
> +			if (walk->pte_hole)
> +				err = walk->pte_hole(addr, next, private);
> +			if (err)
> +				break;
> +			continue;
> +		}
> +		if (walk->pmd_entry)
> +			err = walk->pmd_entry(pmd, addr, next, private);
> +		if (!err && walk->pte_entry)
> +			err = walk_pte_range(pmd, addr, next, walk, private);
> +		if (err)
> +			break;
> +	} while (pmd++, addr = next, addr != end);
> +
> +	return err;
> +}
> +
> +static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
> +			  struct mm_walk *walk, void *private)
> +{
> +	pud_t *pud;
> +	unsigned long next;
> +	int err = 0;
> +
> +	pud = pud_offset(pgd, addr);
> +	do {
> +		next = pud_addr_end(addr, end);
> +		if (pud_none_or_clear_bad(pud)) {
> +			if (walk->pte_hole)
> +				err = walk->pte_hole(addr, next, private);
> +			if (err)
> +				break;
> +			continue;
> +		}
> +		if (walk->pud_entry)
> +			err = walk->pud_entry(pud, addr, next, private);
> +		if (!err && (walk->pmd_entry || walk->pte_entry))
> +			err = walk_pmd_range(pud, addr, next, walk, private);
> +		if (err)
> +			break;
> +	} while (pud++, addr = next, addr != end);
> +
> +	return err;
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
> +	int err = 0;
> +
> +	if (addr >= end)
> +		return err;

unlikely?

> +
> +	pgd = pgd_offset(mm, addr);
> +	do {
> +		next = pgd_addr_end(addr, end);
> +		if (pgd_none_or_clear_bad(pgd)) {
> +			if (walk->pte_hole)
> +				err = walk->pte_hole(addr, next, private);
> +			if (err)
> +				break;
> +			continue;
> +		}
> +		if (walk->pgd_entry)
> +			err = walk->pgd_entry(pgd, addr, next, private);
> +		if (!err &&
> +		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
> +			err = walk_pud_range(pgd, addr, next, walk, private);
> +		if (err)
> +			return err;

break instead.

> +	} while (pgd++, addr = next, addr != end);
> +
> +	return err;
> +}

Should walk_page_range be exported?

Is it trivial to convert ioremap to use this new pte walker?
