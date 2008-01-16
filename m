Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYAPW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYAPW0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbYAPWPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:50 -0500
Received: from ns.suse.de ([195.135.220.2]:55285 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYAPWPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:35 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [33/36] CPA: Make kernel_text test match boot mapping initialization
Message-Id: <20080116221533.7B485150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The boot direct mapping initialization used a different test to check if a 
page was part of the kernel mapping than c_p_a(). Make them use
a common function. 

Also round up to a large page size to be sure and check for the beginning
of the kernel address to handle highly loaded kernels better.

This gives a small semantic change of NX applying to always 2MB areas 
on !PSE && NX systems, but that's an obscure case even considering
DEBUG_PAGEALLOC.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_32.c        |   16 ++--------------
 arch/x86/mm/pageattr_32.c    |    9 ++++++++-
 include/asm-x86/pgtable_32.h |    2 +-
 3 files changed, 11 insertions(+), 16 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -184,6 +184,13 @@ static int cache_attr_changed(pte_t pte,
 	return a != (pgprot_val(prot) & _PAGE_CACHE);
 }
 
+int text_address(unsigned long addr)
+{
+	unsigned long start = ((unsigned long)&_text) & LARGE_PAGE_MASK;
+	unsigned long end = ((unsigned long)&__init_end) & LARGE_PAGE_MASK;
+	return addr >= start && addr < end + LARGE_PAGE_SIZE;
+}
+
 /*
  * Mark the address for flushing later in global_tlb_flush().
  *
@@ -238,7 +245,7 @@ __change_page_attr(struct page *page, pg
 	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level),
 			level < 3);
 
-	if ((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
+	if (text_address(address))
 		ref_prot = PAGE_KERNEL_EXEC;
 
 	ref_prot = canon_pgprot(ref_prot);
Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -136,13 +136,6 @@ static void __init page_table_range_init
 	}
 }
 
-static inline int is_kernel_text(unsigned long addr)
-{
-	if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
-		return 1;
-	return 0;
-}
-
 /*
  * This maps the physical memory to kernel virtual address space, a total 
  * of max_low_pfn pages, by creating page tables starting from address 
@@ -176,14 +169,9 @@ static void __init kernel_physical_mappi
 			 */
 			if (cpu_has_pse &&
 			    is_memory_all_valid(paddr, paddr + PMD_SIZE)) {
-				unsigned int address2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
 
-				address2 = (pfn + PTRS_PER_PTE) * PAGE_SIZE +
-				           PAGE_OFFSET - 1;
-
-				if (is_kernel_text(address) ||
-				    is_kernel_text(address2))
+				if (text_address(address))
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
 				set_pmd(pmd, pfn_pmd(pfn, prot));
@@ -216,7 +204,7 @@ static void __init kernel_physical_mappi
 					continue;
 				}
 
-				if (is_kernel_text(address))
+				if (text_address(address))
 					prot = PAGE_KERNEL_EXEC;
 
 				set_pte(pte, pfn_pte(pfn, prot));
Index: linux/include/asm-x86/pgtable_32.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_32.h
+++ linux/include/asm-x86/pgtable_32.h
@@ -34,7 +34,7 @@ void check_pgt_cache(void);
 void pmd_ctor(struct kmem_cache *, void *);
 void pgtable_cache_init(void);
 void paging_init(void);
-
+int text_address(unsigned long);
 
 /*
  * The Linux x86 paging architecture is 'compile-time dual-mode', it
