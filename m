Return-Path: <linux-kernel-owner+w=401wt.eu-S1030752AbXCSXhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030752AbXCSXhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030753AbXCSXhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:37:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33421 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030752AbXCSXhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:37:21 -0400
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Message-Id: <20070319233721.13775.42022.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
Subject: [QUICKLIST 2/5] Quicklist support for IA64
Date: Mon, 19 Mar 2007 16:37:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quicklist for IA64

IA64 is the origin of the quicklist implementation. So cut out the pieces
that are now in core code and modify the functions called.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc3-mm2/arch/ia64/mm/init.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/ia64/mm/init.c	2007-03-16 02:15:24.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/ia64/mm/init.c	2007-03-16 02:33:46.000000000 -0700
@@ -39,9 +39,6 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-DEFINE_PER_CPU(unsigned long *, __pgtable_quicklist);
-DEFINE_PER_CPU(long, __pgtable_quicklist_size);
-
 extern void ia64_tlb_init (void);
 
 unsigned long MAX_DMA_ADDRESS = PAGE_OFFSET + 0x100000000UL;
@@ -56,54 +53,6 @@ EXPORT_SYMBOL(vmem_map);
 struct page *zero_page_memmap_ptr;	/* map entry for zero page */
 EXPORT_SYMBOL(zero_page_memmap_ptr);
 
-#define MIN_PGT_PAGES			25UL
-#define MAX_PGT_FREES_PER_PASS		16L
-#define PGT_FRACTION_OF_NODE_MEM	16
-
-static inline long
-max_pgt_pages(void)
-{
-	u64 node_free_pages, max_pgt_pages;
-
-#ifndef	CONFIG_NUMA
-	node_free_pages = nr_free_pages();
-#else
-	node_free_pages = node_page_state(numa_node_id(), NR_FREE_PAGES);
-#endif
-	max_pgt_pages = node_free_pages / PGT_FRACTION_OF_NODE_MEM;
-	max_pgt_pages = max(max_pgt_pages, MIN_PGT_PAGES);
-	return max_pgt_pages;
-}
-
-static inline long
-min_pages_to_free(void)
-{
-	long pages_to_free;
-
-	pages_to_free = pgtable_quicklist_size - max_pgt_pages();
-	pages_to_free = min(pages_to_free, MAX_PGT_FREES_PER_PASS);
-	return pages_to_free;
-}
-
-void
-check_pgt_cache(void)
-{
-	long pages_to_free;
-
-	if (unlikely(pgtable_quicklist_size <= MIN_PGT_PAGES))
-		return;
-
-	preempt_disable();
-	while (unlikely((pages_to_free = min_pages_to_free()) > 0)) {
-		while (pages_to_free--) {
-			free_page((unsigned long)pgtable_quicklist_alloc());
-		}
-		preempt_enable();
-		preempt_disable();
-	}
-	preempt_enable();
-}
-
 void
 lazy_mmu_prot_update (pte_t pte)
 {
Index: linux-2.6.21-rc3-mm2/include/asm-ia64/pgalloc.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/asm-ia64/pgalloc.h	2007-03-16 02:15:24.000000000 -0700
+++ linux-2.6.21-rc3-mm2/include/asm-ia64/pgalloc.h	2007-03-16 02:33:46.000000000 -0700
@@ -18,71 +18,18 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/threads.h>
+#include <linux/quicklist.h>
 
 #include <asm/mmu_context.h>
 
-DECLARE_PER_CPU(unsigned long *, __pgtable_quicklist);
-#define pgtable_quicklist __ia64_per_cpu_var(__pgtable_quicklist)
-DECLARE_PER_CPU(long, __pgtable_quicklist_size);
-#define pgtable_quicklist_size __ia64_per_cpu_var(__pgtable_quicklist_size)
-
-static inline long pgtable_quicklist_total_size(void)
-{
-	long ql_size = 0;
-	int cpuid;
-
-	for_each_online_cpu(cpuid) {
-		ql_size += per_cpu(__pgtable_quicklist_size, cpuid);
-	}
-	return ql_size;
-}
-
-static inline void *pgtable_quicklist_alloc(void)
-{
-	unsigned long *ret = NULL;
-
-	preempt_disable();
-
-	ret = pgtable_quicklist;
-	if (likely(ret != NULL)) {
-		pgtable_quicklist = (unsigned long *)(*ret);
-		ret[0] = 0;
-		--pgtable_quicklist_size;
-		preempt_enable();
-	} else {
-		preempt_enable();
-		ret = (unsigned long *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-	}
-
-	return ret;
-}
-
-static inline void pgtable_quicklist_free(void *pgtable_entry)
-{
-#ifdef CONFIG_NUMA
-	int nid = page_to_nid(virt_to_page(pgtable_entry));
-
-	if (unlikely(nid != numa_node_id())) {
-		free_page((unsigned long)pgtable_entry);
-		return;
-	}
-#endif
-
-	preempt_disable();
-	*(unsigned long *)pgtable_entry = (unsigned long)pgtable_quicklist;
-	pgtable_quicklist = (unsigned long *)pgtable_entry;
-	++pgtable_quicklist_size;
-	preempt_enable();
-}
-
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pgd_free(pgd_t * pgd)
 {
-	pgtable_quicklist_free(pgd);
+	quicklist_free(0, NULL, pgd);
 }
 
 #ifdef CONFIG_PGTABLE_4
@@ -94,12 +41,12 @@ pgd_populate(struct mm_struct *mm, pgd_t
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pud_free(pud_t * pud)
 {
-	pgtable_quicklist_free(pud);
+	quicklist_free(0, NULL, pud);
 }
 #define __pud_free_tlb(tlb, pud)	pud_free(pud)
 #endif /* CONFIG_PGTABLE_4 */
@@ -112,12 +59,12 @@ pud_populate(struct mm_struct *mm, pud_t
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pmd_free(pmd_t * pmd)
 {
-	pgtable_quicklist_free(pmd);
+	quicklist_free(0, NULL, pmd);
 }
 
 #define __pmd_free_tlb(tlb, pmd)	pmd_free(pmd)
@@ -137,28 +84,31 @@ pmd_populate_kernel(struct mm_struct *mm
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
 					 unsigned long addr)
 {
-	void *pg = pgtable_quicklist_alloc();
+	void *pg = quicklist_alloc(0, GFP_KERNEL, NULL);
 	return pg ? virt_to_page(pg) : NULL;
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long addr)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pte_free(struct page *pte)
 {
-	pgtable_quicklist_free(page_address(pte));
+	quicklist_free(0, NULL, page_address(pte));
 }
 
 static inline void pte_free_kernel(pte_t * pte)
 {
-	pgtable_quicklist_free(pte);
+	quicklist_free(0, NULL, pte);
 }
 
-#define __pte_free_tlb(tlb, pte)	pte_free(pte)
+static inline void check_pgt_cache(void)
+{
+	quicklist_check(0, NULL);
+}
 
-extern void check_pgt_cache(void);
+#define __pte_free_tlb(tlb, pte)	pte_free(pte)
 
 #endif				/* _ASM_IA64_PGALLOC_H */
Index: linux-2.6.21-rc3-mm2/arch/ia64/mm/contig.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/ia64/mm/contig.c	2007-03-16 02:15:24.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/ia64/mm/contig.c	2007-03-16 02:33:46.000000000 -0700
@@ -88,7 +88,7 @@ void show_mem(void)
 	printk(KERN_INFO "%d pages shared\n", total_shared);
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       pgtable_quicklist_total_size());
+	       quicklist_total_size());
 	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
 }
 
Index: linux-2.6.21-rc3-mm2/arch/ia64/mm/discontig.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/ia64/mm/discontig.c	2007-03-16 02:15:24.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/ia64/mm/discontig.c	2007-03-16 02:33:46.000000000 -0700
@@ -563,7 +563,7 @@ void show_mem(void)
 	printk(KERN_INFO "%d pages shared\n", total_shared);
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       pgtable_quicklist_total_size());
+	       quicklist_total_size());
 	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
 }
 
Index: linux-2.6.21-rc3-mm2/arch/ia64/Kconfig
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/ia64/Kconfig	2007-03-16 02:15:24.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/ia64/Kconfig	2007-03-16 02:33:46.000000000 -0700
@@ -29,6 +29,10 @@ config ZONE_DMA
 	def_bool y
 	depends on !IA64_SGI_SN2
 
+config QUICKLIST
+	bool
+	default y
+
 config MMU
 	bool
 	default y
