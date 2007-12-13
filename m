Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbXLMWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbXLMWwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbXLMWwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:52:41 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50707 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759688AbXLMWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:52:40 -0500
Date: Thu, 13 Dec 2007 14:52:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org
Subject: Re: What was the problem with quicklists and x86-64?
In-Reply-To: <20071213222716.GA20208@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0712131437080.25120@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org> <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
 <20071213222716.GA20208@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007, Siddha, Suresh B wrote:

> <snip>
> Oh, and I see what's wrong: you not only switched "free_page()" to 
> "quicklist_free()", you *also* switched "tlb_remove_page()" to 
> "quicklist_free()".
> </snip>
> 
> The above comment is in reference to below portion of code:
> 
> -#define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
> +#define __pte_free_tlb(tlb,pte) quicklist_free_page(QUICK_PT, NULL,(pte))
> 
> tlb_remove_page() was marking tlb->need_flush. Which is later used
> by tlb_flush_mmu(). With quicklist_free_page() we loose all that..

Aha. So we need to flush if there is a page on the quicklist. Patch 
follows.

> Now in a corner case scenario  with a big munmap() which calls unmap_region()
> and if it so happens that the region getting unmapped just has page
> tables setup but with all PTE's set to NULL, unmap_region() may
> potentially free the page table pages
> 	[ tlb_finish_mmu() calls check_pgt_cache() which trims quicklist ]
> with out flushing the TLB's.
> 	[ (tlb_finish_mmu() calls the tlb_flush_mmu() but it will not do
>            much as need_flush is not set ]
> 
> Similarly Linus brought pre-emptions issues associated with quicklist usage..

AFAICT page table shootdown cannot be preempted. What where the preemption issues?




Index: linux-2.6/include/asm-generic/tlb.h
===================================================================
--- linux-2.6.orig/include/asm-generic/tlb.h	2007-12-13 14:45:38.000000000 -0800
+++ linux-2.6/include/asm-generic/tlb.h	2007-12-13 14:51:07.000000000 -0800
@@ -14,6 +14,7 @@
 #define _ASM_GENERIC__TLB_H
 
 #include <linux/swap.h>
+#include <linux/quicklist.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
@@ -85,6 +86,9 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+#ifdef CONFIG_QUICKLIST
+	tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
+#endif
 	tlb_flush_mmu(tlb, start, end);
 
 	/* keep the page table cache within bounds */
