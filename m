Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYFHXdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYFHXdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 19:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYFHXdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 19:33:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048AbYFHXdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 19:33:32 -0400
Date: Sun, 8 Jun 2008 16:32:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 00/14] bootmem rewrite v4
Message-Id: <20080608163237.71463df0.akpm@linux-foundation.org>
In-Reply-To: <87fxrnmw5s.fsf@saeurebad.de>
References: <20080605224940.434439989@saeurebad.de>
	<20080608133447.e5293600.akpm@linux-foundation.org>
	<87fxrnmw5s.fsf@saeurebad.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jun 2008 23:52:47 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:

> Hi,
> 
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Fri, 06 Jun 2008 00:49:40 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:
> >
> >> This is a complete overhaul of the bootmem allocator while preserving
> >> most of its original functionality.
> >
> > Confused.  This conflicts with patches from yourself which I have already
> > merged.
> 
> Hum.  I just tried again:
> 
> - checkout v2.6.26-rc5
> - get latest mmotm broken-out tarball (stamp-2008-06-07-02-27)
> - git-quiltimport
> - apply the bootmem series
> 
> and no conflicts.  Anything I missed?  Which files are conflicting, btw?
> 

bootmem-reorder-code-to-match-new-bootmem-structure.patch spits:

***************
*** 575,609 ****
  	return ptr;
  }
  #endif
- 
- #ifndef ARCH_LOW_ADDRESS_LIMIT
- #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
- #endif
- 
- void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
- 				  unsigned long goal)
- {
- 	bootmem_data_t *bdata;
- 	void *ptr;
- 
- 	list_for_each_entry(bdata, &bdata_list, list) {
- 		ptr = alloc_bootmem_core(bdata, size, align, goal,
- 					ARCH_LOW_ADDRESS_LIMIT);
- 		if (ptr)
- 			return ptr;
- 	}
- 
- 	/*
- 	 * Whoops, we cannot satisfy the allocation request.
- 	 */
- 	printk(KERN_ALERT "low bootmem alloc of %lu bytes failed!\n", size);
- 	panic("Out of low memory");
- 	return NULL;
- }
- 
- void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
- 				       unsigned long align, unsigned long goal)
- {
- 	return alloc_bootmem_core(pgdat->bdata, size, align, goal,
- 				ARCH_LOW_ADDRESS_LIMIT);
- }
--- 606,608 ----
  	return ptr;
  }
  #endif

and

***************
*** 79,107 ****
  	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
  #define alloc_bootmem_low_pages(x) \
  	__alloc_bootmem_low(x, PAGE_SIZE, 0)
- #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
- 
- extern unsigned long free_all_bootmem(void);
- extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
- extern void *__alloc_bootmem_node(pg_data_t *pgdat,
- 				  unsigned long size,
- 				  unsigned long align,
- 				  unsigned long goal);
- extern unsigned long init_bootmem_node(pg_data_t *pgdat,
- 				       unsigned long freepfn,
- 				       unsigned long startpfn,
- 				       unsigned long endpfn);
- extern void reserve_bootmem_node(pg_data_t *pgdat,
- 				 unsigned long physaddr,
- 				 unsigned long size,
- 				 int flags);
- extern void free_bootmem_node(pg_data_t *pgdat,
- 			      unsigned long addr,
- 			      unsigned long size);
- extern void *alloc_bootmem_section(unsigned long size,
- 				   unsigned long section_nr);
- 
- #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
  #define alloc_bootmem_node(pgdat, x) \
  	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
  #define alloc_bootmem_pages_node(pgdat, x) \
--- 101,106 ----
  	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
  #define alloc_bootmem_low_pages(x) \
  	__alloc_bootmem_low(x, PAGE_SIZE, 0)
  #define alloc_bootmem_node(pgdat, x) \
  	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
  #define alloc_bootmem_pages_node(pgdat, x) \

Seems that Nick's mm-introduce-non-panic-alloc_bootmem.patch mucked
things up.  I'll have a go at fixing things.

