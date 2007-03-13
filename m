Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbXCMHOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbXCMHOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXCMHNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:13:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38825 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753165AbXCMHNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:13:41 -0400
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Message-Id: <20070313071341.4920.30555.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
Subject: [QUICKLIST 3/4] Quicklist support for x86_64
Date: Mon, 12 Mar 2007 23:13:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conver x86_64 to using quicklists

This adds caching of pgds and puds, pmds, pte. That way we can
avoid costly zeroing and initialization of special mappings in the
pgd.

A second quicklist is useful to separate out PGD handling. We can carry
the initialized pgds over to the next process needing them.

Also clean up the pgd_list handling to use regular list macros.
There is no need anymore to avoid the lru field.

Move the add/removal of the pgds to the pgdlist into the
constructor / destructor. That way the implementation is
congruent with i386.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86_64/Kconfig          |    4 ++
 arch/x86_64/kernel/process.c |    1 
 arch/x86_64/kernel/smp.c     |    2 -
 arch/x86_64/mm/fault.c       |    5 +-
 include/asm-x86_64/pgalloc.h |   76 +++++++++++++++++++++----------------------
 include/asm-x86_64/pgtable.h |    3 -
 mm/Kconfig                   |    5 ++
 7 files changed, 52 insertions(+), 44 deletions(-)

Index: linux-2.6.21-rc3-mm2/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/x86_64/Kconfig	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/x86_64/Kconfig	2007-03-12 22:53:28.000000000 -0700
@@ -56,6 +56,10 @@ config ZONE_DMA
 	bool
 	default y
 
+config NR_QUICK
+	int
+	default 2
+
 config ISA
 	bool
 
Index: linux-2.6.21-rc3-mm2/include/asm-x86_64/pgalloc.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/asm-x86_64/pgalloc.h	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/include/asm-x86_64/pgalloc.h	2007-03-12 22:53:28.000000000 -0700
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
@@ -20,86 +24,77 @@ static inline void pmd_populate(struct m
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
 
-static inline void pgd_list_add(pgd_t *pgd)
+static inline void pgd_ctor(void *x)
 {
+	unsigned boundary;
+	pgd_t *pgd = x;
 	struct page *page = virt_to_page(pgd);
 
+	/*
+	 * Copy kernel pointers in from init.
+	 */
+	boundary = pgd_index(__PAGE_OFFSET);
+	memcpy(pgd + boundary,
+		init_level4_pgt + boundary,
+		(PTRS_PER_PGD - boundary) * sizeof(pgd_t));
+
 	spin_lock(&pgd_lock);
-	page->index = (pgoff_t)pgd_list;
-	if (pgd_list)
-		pgd_list->private = (unsigned long)&page->index;
-	pgd_list = page;
-	page->private = (unsigned long)&pgd_list;
+	list_add(&page->lru, &pgd_list);
 	spin_unlock(&pgd_lock);
 }
 
-static inline void pgd_list_del(pgd_t *pgd)
+static inline void pgd_dtor(void *x)
 {
-	struct page *next, **pprev, *page = virt_to_page(pgd);
+	pgd_t *pgd = x;
+	struct page *page = virt_to_page(pgd);
 
 	spin_lock(&pgd_lock);
-	next = (struct page *)page->index;
-	pprev = (struct page **)page->private;
-	*pprev = next;
-	if (next)
-		next->private = (unsigned long)pprev;
+	list_del(&page->lru);
 	spin_unlock(&pgd_lock);
 }
 
+
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	unsigned boundary;
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
-	if (!pgd)
-		return NULL;
-	pgd_list_add(pgd);
-	/*
-	 * Copy kernel pointers in from init.
-	 * Could keep a freelist or slab cache of those because the kernel
-	 * part never changes.
-	 */
-	boundary = pgd_index(__PAGE_OFFSET);
-	memset(pgd, 0, boundary * sizeof(pgd_t));
-	memcpy(pgd + boundary,
-	       init_level4_pgt + boundary,
-	       (PTRS_PER_PGD - boundary) * sizeof(pgd_t));
+	pgd_t *pgd = (pgd_t *)quicklist_alloc(QUICK_PGD,
+			 GFP_KERNEL|__GFP_REPEAT, pgd_ctor);
+
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
 	if (!p)
 		return NULL;
 	return virt_to_page(p);
@@ -111,17 +106,22 @@ static inline struct page *pte_alloc_one
 static inline void pte_free_kernel(pte_t *pte)
 {
 	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
-	free_page((unsigned long)pte); 
+	quicklist_free(QUICK_PT, NULL, pte);
 }
 
 static inline void pte_free(struct page *pte)
 {
 	__free_page(pte);
-} 
+}
 
 #define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
 
 #define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
 #define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
 
+static inline void check_pgt_cache(void)
+{
+	quicklist_check(QUICK_PGD, pgd_dtor);
+	quicklist_check(QUICK_PT, NULL);
+}
 #endif /* _X86_64_PGALLOC_H */
Index: linux-2.6.21-rc3-mm2/mm/Kconfig
===================================================================
--- linux-2.6.21-rc3-mm2.orig/mm/Kconfig	2007-03-12 22:49:23.000000000 -0700
+++ linux-2.6.21-rc3-mm2/mm/Kconfig	2007-03-12 22:53:28.000000000 -0700
@@ -225,3 +225,8 @@ config QUICKLIST
 	default y if NR_QUICK != 0
 
 
+config QUICKLIST
+	bool
+	default y if NR_QUICK != 0
+
+
Index: linux-2.6.21-rc3-mm2/arch/x86_64/kernel/process.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/x86_64/kernel/process.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/x86_64/kernel/process.c	2007-03-12 22:53:28.000000000 -0700
@@ -207,6 +207,7 @@ void cpu_idle (void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
 			if (!idle)
Index: linux-2.6.21-rc3-mm2/arch/x86_64/kernel/smp.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/x86_64/kernel/smp.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/x86_64/kernel/smp.c	2007-03-12 22:53:28.000000000 -0700
@@ -242,7 +242,7 @@ void flush_tlb_mm (struct mm_struct * mm
 	}
 	if (!cpus_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
-
+	check_pgt_cache();
 	preempt_enable();
 }
 EXPORT_SYMBOL(flush_tlb_mm);
Index: linux-2.6.21-rc3-mm2/arch/x86_64/mm/fault.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/x86_64/mm/fault.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/x86_64/mm/fault.c	2007-03-12 22:53:28.000000000 -0700
@@ -585,7 +585,7 @@ do_sigbus:
 }
 
 DEFINE_SPINLOCK(pgd_lock);
-struct page *pgd_list;
+LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
@@ -605,8 +605,7 @@ void vmalloc_sync_all(void)
 			if (pgd_none(*pgd_ref))
 				continue;
 			spin_lock(&pgd_lock);
-			for (page = pgd_list; page;
-			     page = (struct page *)page->index) {
+			list_for_each_entry(page, &pgd_list, lru) {
 				pgd_t *pgd;
 				pgd = (pgd_t *)page_address(page) + pgd_index(address);
 				if (pgd_none(*pgd))
Index: linux-2.6.21-rc3-mm2/include/asm-x86_64/pgtable.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/asm-x86_64/pgtable.h	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/include/asm-x86_64/pgtable.h	2007-03-12 22:53:28.000000000 -0700
@@ -402,7 +402,7 @@ static inline pte_t pte_modify(pte_t pte
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
 extern spinlock_t pgd_lock;
-extern struct page *pgd_list;
+extern struct list_head pgd_list;
 void vmalloc_sync_all(void);
 
 #endif /* !__ASSEMBLY__ */
@@ -419,7 +419,6 @@ extern int kern_addr_valid(unsigned long
 #define HAVE_ARCH_UNMAPPED_AREA
 
 #define pgtable_cache_init()   do { } while (0)
-#define check_pgt_cache()      do { } while (0)
 
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
