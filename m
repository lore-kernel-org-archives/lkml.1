Return-Path: <linux-kernel-owner+w=401wt.eu-S1761735AbXJOXc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735AbXJOXc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXJOXcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:32:16 -0400
Received: from waste.org ([66.93.16.53]:59981 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbXJOXcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:32:15 -0400
Date: Mon, 15 Oct 2007 18:30:46 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 4/11] maps3: introduce a generic page walker
Message-ID: <20071015233046.GY19691@waste.org>
References: <5.290135367@selenic.com> <4713EC5B.7050000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713EC5B.7050000@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 03:40:27PM -0700, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> > Introduce a general page table walker
> >   
> 
> Definitely approve in principle, but some comments:
> 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> >
> > Index: l/include/linux/mm.h
> > ===================================================================
> > --- l.orig/include/linux/mm.h	2007-10-09 17:37:59.000000000 -0500
> > +++ l/include/linux/mm.h	2007-10-10 11:46:37.000000000 -0500
> > @@ -773,6 +773,17 @@ unsigned long unmap_vmas(struct mmu_gath
> >  		struct vm_area_struct *start_vma, unsigned long start_addr,
> >  		unsigned long end_addr, unsigned long *nr_accounted,
> >  		struct zap_details *);
> > +
> > +struct mm_walk {
> > +	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
> > +	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
> > +	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
> > +	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
> > +	int (*pte_hole) (unsigned long, unsigned long, void *);
> > +};
> >   
> 
> It would be nice to have some clue about when each of these functions
> are called (depth first? pre or post order?), and what their params
> are.  Does it call a callback for folded pagetable levels?
> 
> Can pte_hole be used to create new mappings while we're traversing the
> pagetable?  Apparently not, because it continues after calling it.
> 
> > +
> > +int walk_page_range(struct mm_struct *, unsigned long addr, unsigned long end,
> > +		    struct mm_walk *walk, void *private);
> >  void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
> >  		unsigned long end, unsigned long floor, unsigned long ceiling);
> >  void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
> > Index: l/mm/Makefile
> > ===================================================================
> > --- l.orig/mm/Makefile	2007-10-09 17:37:59.000000000 -0500
> > +++ l/mm/Makefile	2007-10-10 11:46:37.000000000 -0500
> > @@ -5,7 +5,7 @@
> >  mmu-y			:= nommu.o
> >  mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
> >  			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
> > -			   vmalloc.o
> > +			   vmalloc.o pagewalk.o
> >  
> >  obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
> >  			   page_alloc.o page-writeback.o pdflush.o \
> > Index: l/mm/pagewalk.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ l/mm/pagewalk.c	2007-10-10 11:46:37.000000000 -0500
> > @@ -0,0 +1,120 @@
> > +#include <linux/mm.h>
> > +#include <linux/highmem.h>
> > +#include <linux/sched.h>
> > +
> > +static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > +			  struct mm_walk *walk, void *private)
> > +{
> > +	pte_t *pte;
> > +	int err = 0;
> > +
> > +	pte = pte_offset_map(pmd, addr);
> > +	do {
> > +		err = walk->pte_entry(pte, addr, addr, private);
> >   
> 
> Should this be (pte, addr, addr+PAGE_SIZE, private)?

Probably - the pattern is [start, end). Either that or we should have
one arg.
 
> > +/*
> > + * walk_page_range - walk a memory map's page tables with a callback
> > + * @mm - memory map to walk
> > + * @addr - starting address
> > + * @end - ending address
> > + * @walk - set of callbacks to invoke for each level of the tree
> > + * @private - private data passed to the callback function
> > + *
> > + * Recursively walk the page table for the memory area in a VMA, calling
> > + * a callback for every bottom-level (PTE) page table.
> >   
> 
> It calls a callback for every level of the pagetable.

Oops.

-- 
Mathematics is the supreme nostalgia of our time.
