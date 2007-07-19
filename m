Return-Path: <linux-kernel-owner+w=401wt.eu-S938156AbXGSKT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938156AbXGSKT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759149AbXGSJ4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:33112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbXGSJzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:37 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: clameter@sgi.com, davem@davemloft.net, ak@suse.de, tony.luck@intel.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [43/58] x86_64: Quicklist support for x86_64
Message-Id: <20070719095529.A4D8214E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Lameter <clameter@sgi.com>

This adds caching of pgds and puds, pmds, pte.  That way we can avoid costly
zeroing and initialization of special mappings in the pgd.

A second quicklist is useful to separate out PGD handling.  We can carry the
initialized pgds over to the next process needing them.

Also clean up the pgd_list handling to use regular list macros.  There is no
need anymore to avoid the lru field.

Move the add/removal of the pgds to the pgdlist into the constructor /
destructor.  That way the implementation is congruent with i386.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig          |    8 ++++
 arch/x86_64/kernel/process.c |    1 
 arch/x86_64/kernel/smp.c     |    2 -
 include/asm-x86_64/pgalloc.h |   73 ++++++++++++++++++++++++++++---------------
 include/asm-x86_64/pgtable.h |    1 
 5 files changed, 59 insertions(+), 26 deletions(-)

Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -60,6 +60,14 @@ config ZONE_DMA
 	bool
 	default y
 
+config QUICKLIST
+	bool
+	default y
+
+config NR_QUICK
+	int
+	default 2
+
 config ISA
 	bool
 
Index: linux/arch/x86_64/kernel/process.c
===================================================================
--- linux.orig/arch/x86_64/kernel/process.c
+++ linux/arch/x86_64/kernel/process.c
@@ -207,6 +207,7 @@ void cpu_idle (void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
 			if (!idle)
Index: linux/arch/x86_64/kernel/smp.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smp.c
+++ linux/arch/x86_64/kernel/smp.c
@@ -241,7 +241,7 @@ void flush_tlb_mm (struct mm_struct * mm
 	}
 	if (!cpus_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
-
+	check_pgt_cache();
 	preempt_enable();
 }
 EXPORT_SYMBOL(flush_tlb_mm);
Index: linux/include/asm-x86_64/pgalloc.h
===================================================================
--- linux.orig/include/asm-x86_64/pgalloc.h
+++ linux/include/asm-x86_64/pgalloc.h
@@ -4,6 +4,10 @@
 #include <asm/pda.h>
 #include <linux/threads.h>
 #include <linux/mm.h>
+#include <linux/quicklist.h>
+
+#define QUICK_PGD 0	/* We preserve special mappings over free */
+#define QUICK_PT 1	/* Other page table pages that are zero on free */
 
 #define pmd_populate_kernel(mm, pmd, pte) \
 		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)))
@@ -20,23 +24,23 @@ static inline void pmd_populate(struct m
 static inline void pmd_free(pmd_t *pmd)
 {
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
+	quicklist_free(QUICK_PT, NULL, pmd);
 }
 
 static inline pmd_t *pmd_alloc_one (struct mm_struct *mm, unsigned long addr)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return (pmd_t *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
 }
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return (pud_t *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
 }
 
 static inline void pud_free (pud_t *pud)
 {
 	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	free_page((unsigned long)pud);
+	quicklist_free(QUICK_PT, NULL, pud);
 }
 
 static inline void pgd_list_add(pgd_t *pgd)
@@ -57,41 +61,57 @@ static inline void pgd_list_del(pgd_t *p
 	spin_unlock(&pgd_lock);
 }
 
-static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+static inline void pgd_ctor(void *x)
 {
 	unsigned boundary;
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
-	if (!pgd)
-		return NULL;
-	pgd_list_add(pgd);
+	pgd_t *pgd = x;
+	struct page *page = virt_to_page(pgd);
+
 	/*
 	 * Copy kernel pointers in from init.
-	 * Could keep a freelist or slab cache of those because the kernel
-	 * part never changes.
 	 */
 	boundary = pgd_index(__PAGE_OFFSET);
-	memset(pgd, 0, boundary * sizeof(pgd_t));
 	memcpy(pgd + boundary,
-	       init_level4_pgt + boundary,
-	       (PTRS_PER_PGD - boundary) * sizeof(pgd_t));
+		init_level4_pgt + boundary,
+		(PTRS_PER_PGD - boundary) * sizeof(pgd_t));
+
+	spin_lock(&pgd_lock);
+	list_add(&page->lru, &pgd_list);
+	spin_unlock(&pgd_lock);
+}
+
+static inline void pgd_dtor(void *x)
+{
+	pgd_t *pgd = x;
+	struct page *page = virt_to_page(pgd);
+
+        spin_lock(&pgd_lock);
+	list_del(&page->lru);
+	spin_unlock(&pgd_lock);
+}
+
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = (pgd_t *)quicklist_alloc(QUICK_PGD,
+		GFP_KERNEL|__GFP_REPEAT, pgd_ctor);
 	return pgd;
 }
 
 static inline void pgd_free(pgd_t *pgd)
 {
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	pgd_list_del(pgd);
-	free_page((unsigned long)pgd);
+	quicklist_free(QUICK_PGD, pgd_dtor, pgd);
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	return (pte_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	return (pte_t *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	void *p = (void *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	void *p = (void *)quicklist_alloc(QUICK_PT, GFP_KERNEL|__GFP_REPEAT, NULL);
+
 	if (!p)
 		return NULL;
 	return virt_to_page(p);
@@ -103,17 +123,22 @@ static inline struct page *pte_alloc_one
 static inline void pte_free_kernel(pte_t *pte)
 {
 	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
-	free_page((unsigned long)pte); 
+	quicklist_free(QUICK_PT, NULL, pte);
 }
 
 static inline void pte_free(struct page *pte)
 {
-	__free_page(pte);
-} 
+	quicklist_free_page(QUICK_PT, NULL, pte);
+}
 
-#define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
+#define __pte_free_tlb(tlb,pte) quicklist_free_page(QUICK_PT, NULL,(pte))
 
-#define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
-#define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
+#define __pmd_free_tlb(tlb,x)   quicklist_free(QUICK_PT, NULL, (x))
+#define __pud_free_tlb(tlb,x)   quicklist_free(QUICK_PT, NULL, (x))
 
+static inline void check_pgt_cache(void)
+{
+	quicklist_trim(QUICK_PGD, pgd_dtor, 25, 16);
+	quicklist_trim(QUICK_PT, NULL, 25, 16);
+}
 #endif /* _X86_64_PGALLOC_H */
Index: linux/include/asm-x86_64/pgtable.h
===================================================================
--- linux.orig/include/asm-x86_64/pgtable.h
+++ linux/include/asm-x86_64/pgtable.h
@@ -409,7 +409,6 @@ extern int kern_addr_valid(unsigned long
 #define HAVE_ARCH_UNMAPPED_AREA
 
 #define pgtable_cache_init()   do { } while (0)
-#define check_pgt_cache()      do { } while (0)
 
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
