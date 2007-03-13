Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbXCMHOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbXCMHOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbXCMHNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:13:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56684 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753171AbXCMHNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:13:36 -0400
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Message-Id: <20070313071335.4920.37060.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
Subject: [QUICKLIST 2/4] Quicklist support for i386
Date: Tue, 13 Mar 2007 00:13:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386: Convert to quicklists

Implement the i386 management of pgd and pmds using quicklists.

The i386 management of page table pages currently uses page sized slabs.
The page state is therefore mainly determined by the slab code. However,
i386 also uses its own fields in the page struct to mark special pages
and to build a list of pgds using the ->private and ->index field (yuck!).
This has been finely tuned to work right with SLAB but SLUB needs more
control over the page struct. Currently the only way for SLUB to support
these slabs is through special casing PAGE_SIZE slabs.

If we use quicklists instead then we can avoid the mess, and also the
overhead of manipulating page sized objects through slab.

It also allows us to use standard list manipulation macros for the
pgd list using page->lru thereby simplifying the code.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/i386/Kconfig          |    4 ++
 arch/i386/kernel/process.c |    1 
 arch/i386/kernel/smp.c     |    2 -
 arch/i386/mm/fault.c       |    5 +--
 arch/i386/mm/init.c        |   25 -----------------
 arch/i386/mm/pageattr.c    |    2 -
 arch/i386/mm/pgtable.c     |   63 +++++++++++++++++----------------------------
 include/asm-i386/pgalloc.h |    2 -
 include/asm-i386/pgtable.h |   13 +++------
 9 files changed, 39 insertions(+), 78 deletions(-)

Index: linux-2.6.21-rc3-mm2/arch/i386/mm/init.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/i386/mm/init.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/i386/mm/init.c	2007-03-12 22:53:27.000000000 -0700
@@ -695,31 +695,6 @@ int remove_memory(u64 start, u64 size)
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif
 
-struct kmem_cache *pgd_cache;
-struct kmem_cache *pmd_cache;
-
-void __init pgtable_cache_init(void)
-{
-	if (PTRS_PER_PMD > 1) {
-		pmd_cache = kmem_cache_create("pmd",
-					PTRS_PER_PMD*sizeof(pmd_t),
-					PTRS_PER_PMD*sizeof(pmd_t),
-					0,
-					pmd_ctor,
-					NULL);
-		if (!pmd_cache)
-			panic("pgtable_cache_init(): cannot create pmd cache");
-	}
-	pgd_cache = kmem_cache_create("pgd",
-				PTRS_PER_PGD*sizeof(pgd_t),
-				PTRS_PER_PGD*sizeof(pgd_t),
-				0,
-				pgd_ctor,
-				PTRS_PER_PMD == 1 ? pgd_dtor : NULL);
-	if (!pgd_cache)
-		panic("pgtable_cache_init(): Cannot create pgd cache");
-}
-
 /*
  * This function cannot be __init, since exceptions don't work in that
  * section.  Put this after the callers, so that it cannot be inlined.
Index: linux-2.6.21-rc3-mm2/arch/i386/mm/pgtable.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/i386/mm/pgtable.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/i386/mm/pgtable.c	2007-03-12 22:53:27.000000000 -0700
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
+#include <linux/quicklist.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -181,9 +182,12 @@ void reserve_top_address(unsigned long r
 #endif
 }
 
+#define QUICK_PGD 0
+#define QUICK_PT 1
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	return (pte_t *)quicklist_alloc(QUICK_PT, GFP_KERNEL, NULL);
 }
 
 struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
@@ -198,11 +202,6 @@ struct page *pte_alloc_one(struct mm_str
 	return pte;
 }
 
-void pmd_ctor(void *pmd, struct kmem_cache *cache, unsigned long flags)
-{
-	memset(pmd, 0, PTRS_PER_PMD*sizeof(pmd_t));
-}
-
 /*
  * List of all pgd's needed for non-PAE so it can invalidate entries
  * in both cached and uncached pgd's; not needed for PAE since the
@@ -211,36 +210,15 @@ void pmd_ctor(void *pmd, struct kmem_cac
  * against pageattr.c; it is the unique case in which a valid change
  * of kernel pagetables can't be lazily synchronized by vmalloc faults.
  * vmalloc faults work because attached pagetables are never freed.
- * The locking scheme was chosen on the basis of manfred's
- * recommendations and having no core impact whatsoever.
  * -- wli
  */
 DEFINE_SPINLOCK(pgd_lock);
-struct page *pgd_list;
-
-static inline void pgd_list_add(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-	page->index = (unsigned long)pgd_list;
-	if (pgd_list)
-		set_page_private(pgd_list, (unsigned long)&page->index);
-	pgd_list = page;
-	set_page_private(page, (unsigned long)&pgd_list);
-}
+LIST_HEAD(pgd_list);
 
-static inline void pgd_list_del(pgd_t *pgd)
-{
-	struct page *next, **pprev, *page = virt_to_page(pgd);
-	next = (struct page *)page->index;
-	pprev = (struct page **)page_private(page);
-	*pprev = next;
-	if (next)
-		set_page_private(next, (unsigned long)pprev);
-}
-
-void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+void pgd_ctor(void *pgd)
 {
 	unsigned long flags;
+	struct page *page = virt_to_page(pgd);
 
 	if (PTRS_PER_PMD == 1) {
 		memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
@@ -259,31 +237,32 @@ void pgd_ctor(void *pgd, struct kmem_cac
 			__pa(swapper_pg_dir) >> PAGE_SHIFT,
 			USER_PTRS_PER_PGD, PTRS_PER_PGD - USER_PTRS_PER_PGD);
 
-	pgd_list_add(pgd);
+	list_add(&page->lru, &pgd_list);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
 /* never called when PTRS_PER_PMD > 1 */
-void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+void pgd_dtor(void *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
+	struct page *page = virt_to_page(pgd);
 
 	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
 	spin_lock_irqsave(&pgd_lock, flags);
-	pgd_list_del(pgd);
+	list_del(&page->lru);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	int i;
-	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
+	pgd_t *pgd = quicklist_alloc(QUICK_PGD, GFP_KERNEL, pgd_ctor);
 
 	if (PTRS_PER_PMD == 1 || !pgd)
 		return pgd;
 
 	for (i = 0; i < USER_PTRS_PER_PGD; ++i) {
-		pmd_t *pmd = kmem_cache_alloc(pmd_cache, GFP_KERNEL);
+		pmd_t *pmd = quicklist_alloc(QUICK_PT, GFP_KERNEL, NULL);
 		if (!pmd)
 			goto out_oom;
 		paravirt_alloc_pd(__pa(pmd) >> PAGE_SHIFT);
@@ -296,9 +275,9 @@ out_oom:
 		pgd_t pgdent = pgd[i];
 		void* pmd = (void *)__va(pgd_val(pgdent)-1);
 		paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-		kmem_cache_free(pmd_cache, pmd);
+		quicklist_free(QUICK_PT, NULL, pmd);
 	}
-	kmem_cache_free(pgd_cache, pgd);
+	quicklist_free(QUICK_PGD, pgd_dtor, pgd);
 	return NULL;
 }
 
@@ -312,8 +291,14 @@ void pgd_free(pgd_t *pgd)
 			pgd_t pgdent = pgd[i];
 			void* pmd = (void *)__va(pgd_val(pgdent)-1);
 			paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-			kmem_cache_free(pmd_cache, pmd);
+			quicklist_free(QUICK_PT, NULL, pmd);
 		}
 	/* in the non-PAE case, free_pgtables() clears user pgd entries */
-	kmem_cache_free(pgd_cache, pgd);
+	quicklist_free(QUICK_PGD, pgd_ctor, pgd);
+}
+
+void check_pgt_cache(void)
+{
+	quicklist_check(QUICK_PGD, pgd_dtor);
+	quicklist_check(QUICK_PT, NULL);
 }
Index: linux-2.6.21-rc3-mm2/arch/i386/Kconfig
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/i386/Kconfig	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/i386/Kconfig	2007-03-12 22:53:27.000000000 -0700
@@ -55,6 +55,10 @@ config ZONE_DMA
 	bool
 	default y
 
+config NR_QUICK
+	int
+	default 2
+
 config SBUS
 	bool
 
Index: linux-2.6.21-rc3-mm2/include/asm-i386/pgtable.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/asm-i386/pgtable.h	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/include/asm-i386/pgtable.h	2007-03-12 22:53:27.000000000 -0700
@@ -35,15 +35,12 @@ struct vm_area_struct;
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 extern unsigned long empty_zero_page[1024];
 extern pgd_t swapper_pg_dir[1024];
-extern struct kmem_cache *pgd_cache;
-extern struct kmem_cache *pmd_cache;
-extern spinlock_t pgd_lock;
-extern struct page *pgd_list;
 
-void pmd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_dtor(void *, struct kmem_cache *, unsigned long);
-void pgtable_cache_init(void);
+void check_pgt_cache(void);
+
+extern spinlock_t pgd_lock;
+extern struct list_head pgd_list;
+static inline void pgtable_cache_init(void) {};
 void paging_init(void);
 
 /*
Index: linux-2.6.21-rc3-mm2/arch/i386/kernel/smp.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/i386/kernel/smp.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/i386/kernel/smp.c	2007-03-12 22:53:27.000000000 -0700
@@ -437,7 +437,7 @@ void flush_tlb_mm (struct mm_struct * mm
 	}
 	if (!cpus_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
-
+	check_pgt_cache();
 	preempt_enable();
 }
 
Index: linux-2.6.21-rc3-mm2/arch/i386/kernel/process.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/i386/kernel/process.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/i386/kernel/process.c	2007-03-12 22:53:27.000000000 -0700
@@ -181,6 +181,7 @@ void cpu_idle(void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
 
Index: linux-2.6.21-rc3-mm2/include/asm-i386/pgalloc.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/asm-i386/pgalloc.h	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/include/asm-i386/pgalloc.h	2007-03-12 22:53:27.000000000 -0700
@@ -65,6 +65,6 @@ do {									\
 #define pud_populate(mm, pmd, pte)	BUG()
 #endif
 
-#define check_pgt_cache()	do { } while (0)
+extern void check_pgt_cache(void);
 
 #endif /* _I386_PGALLOC_H */
Index: linux-2.6.21-rc3-mm2/arch/i386/mm/fault.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/i386/mm/fault.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/i386/mm/fault.c	2007-03-12 22:53:27.000000000 -0700
@@ -623,11 +623,10 @@ void vmalloc_sync_all(void)
 			struct page *page;
 
 			spin_lock_irqsave(&pgd_lock, flags);
-			for (page = pgd_list; page; page =
-					(struct page *)page->index)
+			list_for_each_entry(page, &pgd_list, lru)
 				if (!vmalloc_sync_one(page_address(page),
 								address)) {
-					BUG_ON(page != pgd_list);
+					BUG();
 					break;
 				}
 			spin_unlock_irqrestore(&pgd_lock, flags);
Index: linux-2.6.21-rc3-mm2/arch/i386/mm/pageattr.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/arch/i386/mm/pageattr.c	2007-03-12 22:49:20.000000000 -0700
+++ linux-2.6.21-rc3-mm2/arch/i386/mm/pageattr.c	2007-03-12 22:53:27.000000000 -0700
@@ -95,7 +95,7 @@ static void set_pmd_pte(pte_t *kpte, uns
 		return;
 
 	spin_lock_irqsave(&pgd_lock, flags);
-	for (page = pgd_list; page; page = (struct page *)page->index) {
+	list_for_each_entry(page, &pgd_list, lru) {
 		pgd_t *pgd;
 		pud_t *pud;
 		pmd_t *pmd;
