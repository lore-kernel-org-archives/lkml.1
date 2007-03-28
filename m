Return-Path: <linux-kernel-owner+w=401wt.eu-S965739AbXC1UM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965739AbXC1UM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965752AbXC1UM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:12:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42590 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965751AbXC1UM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:12:57 -0400
Date: Wed, 28 Mar 2007 13:12:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-kernel@vger.kernel.org
cc: William Lee Irwin III <wli@holomorphy.com>, akpm@linux-foundation.org
Subject: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The benefit of preconstructed pgds and pmds in the i386 arch code seem to
be debatable. The performance measurements indicate that there may be a slight
benefit but it seems to almost vanish in the noise ratio.

Method used (i386 1G memory):

1. Boot kernel
2. make clean
3. time make all

Results:

2.6.21-rc5:

real    8m45.505s
user    8m0.910s
sys     0m34.550s

real    8m45.780s
user    8m1.380s
sys     0m33.890s

real    8m47.247s
user    8m1.420s
sys     0m33.980s

real    8m49.382s
user    8m2.460s
sys     0m32.950s

2.6.21-rc5 with patch below:

real    8m47.352s
user    8m3.190s
sys     0m33.070s

real    8m46.747s
user    8m2.680s
sys     0m33.750s

real    8m48.987s
user    8m1.850s
sys     0m34.690s

real    8m49.341s
user    8m2.560s
sys     0m34.220s

i386 only provides support for caching constructed pgd and pmds. These are
comparatively rare to ptes so it may be no surprise that the current 
approach has only minimal effect. An implementation that would also cache 
ptes in their zeroed state may led to a benefit but maybe that could be 
done after this patch was merged? However, such an implementation requires
modifications to the tlb shootdown logic and funky things with highmem(!).

Removal of the slabs avoids concurrent use of page structs by
the slab allocators and i386 arch code.

This means:

1. We can modify SLAB to allow debugging of page order slab caches.

2. SLUB avoids the special casing for page size slabs and also allow
   debugging of all slab caches.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: William Lee Irwin III <wli@holomorphy.com>

Index: linux-2.6.21-rc5/arch/i386/mm/init.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/mm/init.c	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/arch/i386/mm/init.c	2007-03-28 18:23:51.000000000 +0000
@@ -695,31 +695,6 @@
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
Index: linux-2.6.21-rc5/arch/i386/mm/pageattr.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/mm/pageattr.c	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/arch/i386/mm/pageattr.c	2007-03-28 18:23:51.000000000 +0000
@@ -87,24 +87,23 @@
 
 static void set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte) 
 { 
-	struct page *page;
-	unsigned long flags;
+	struct mm_struct *mm;
 
 	set_pte_atomic(kpte, pte); 	/* change init_mm */
 	if (PTRS_PER_PMD > 1)
 		return;
 
-	spin_lock_irqsave(&pgd_lock, flags);
-	for (page = pgd_list; page; page = (struct page *)page->index) {
-		pgd_t *pgd;
+	spin_lock(&mmlist_lock);
+	list_for_each_entry(mm, &init_mm.mmlist, mmlist) {
+		pgd_t *pgd = mm->pgd;
 		pud_t *pud;
 		pmd_t *pmd;
-		pgd = (pgd_t *)page_address(page) + pgd_index(address);
+
 		pud = pud_offset(pgd, address);
 		pmd = pmd_offset(pud, address);
 		set_pte_atomic((pte_t *)pmd, pte);
 	}
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&mmlist_lock);
 }
 
 /* 
Index: linux-2.6.21-rc5/arch/i386/mm/pgtable.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/mm/pgtable.c	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/arch/i386/mm/pgtable.c	2007-03-28 18:23:51.000000000 +0000
@@ -181,109 +181,39 @@
 #endif
 }
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-}
-
-struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	struct page *pte;
-
-#ifdef CONFIG_HIGHPTE
-	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO, 0);
-#else
-	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
-#endif
-	return pte;
-}
-
-void pmd_ctor(void *pmd, struct kmem_cache *cache, unsigned long flags)
-{
-	memset(pmd, 0, PTRS_PER_PMD*sizeof(pmd_t));
-}
-
-/*
- * List of all pgd's needed for non-PAE so it can invalidate entries
- * in both cached and uncached pgd's; not needed for PAE since the
- * kernel pmd is shared. If PAE were not to share the pmd a similar
- * tactic would be needed. This is essentially codepath-based locking
- * against pageattr.c; it is the unique case in which a valid change
- * of kernel pagetables can't be lazily synchronized by vmalloc faults.
- * vmalloc faults work because attached pagetables are never freed.
- * The locking scheme was chosen on the basis of manfred's
- * recommendations and having no core impact whatsoever.
- * -- wli
- */
-DEFINE_SPINLOCK(pgd_lock);
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
-
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
-{
-	unsigned long flags;
-
-	if (PTRS_PER_PMD == 1) {
-		memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
-		spin_lock_irqsave(&pgd_lock, flags);
-	}
-
-	clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
-			swapper_pg_dir + USER_PTRS_PER_PGD,
-			KERNEL_PGD_PTRS);
-
-	if (PTRS_PER_PMD > 1)
-		return;
-
-	/* must happen under lock */
-	paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
-			__pa(swapper_pg_dir) >> PAGE_SHIFT,
-			USER_PTRS_PER_PGD, PTRS_PER_PGD - USER_PTRS_PER_PGD);
-
-	pgd_list_add(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-
-/* never called when PTRS_PER_PMD > 1 */
-void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
-{
-	unsigned long flags; /* can be called from interrupt context */
-
-	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
-	spin_lock_irqsave(&pgd_lock, flags);
-	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
+#ifdef CONFIG_HIGHMEM64G
+#define __pgd_alloc()		kmem_cache_alloc(pgd_cache, GFP_KERNEL|__GFP_REPEAT)
+#define __pgd_free(pgd)		kmem_cache_free(pgd_cache, pgd)
+
+static struct kmem_cache *pgd_cache;
+
+void __init pgtable_cache_init(void)
+{
+	pgd_cache = kmem_cache_create("pgd",
+				PTRS_PER_PGD*sizeof(pgd_t),
+				PTRS_PER_PGD*sizeof(pgd_t),
+				SLAB_PANIC,
+				NULL,
+				NULL);
+}
+#else /* !CONFIG_HIGHMEM64G */
+#define __pgd_alloc()		((pgd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT))
+#define __pgd_free(pgd)		free_page((unsigned long)(pgd))
+#endif /* !CONFIG_HIGHMEM64G */
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	int i;
-	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
+	pgd_t *pgd = __pgd_alloc();
 
-	if (PTRS_PER_PMD == 1 || !pgd)
+	if (!pgd)
+		return NULL;
+	memcpy(&pgd[USER_PTRS_PER_PGD], &swapper_pg_dir[USER_PTRS_PER_PGD],
+						KERNEL_PGD_PTRS*sizeof(pgd_t));
+	if (PTRS_PER_PMD == 1)
 		return pgd;
-
 	for (i = 0; i < USER_PTRS_PER_PGD; ++i) {
-		pmd_t *pmd = kmem_cache_alloc(pmd_cache, GFP_KERNEL);
+		pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
 		if (!pmd)
 			goto out_oom;
 		paravirt_alloc_pd(__pa(pmd) >> PAGE_SHIFT);
@@ -296,9 +226,9 @@
 		pgd_t pgdent = pgd[i];
 		void* pmd = (void *)__va(pgd_val(pgdent)-1);
 		paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-		kmem_cache_free(pmd_cache, pmd);
+		free_page((unsigned long)pmd);
 	}
-	kmem_cache_free(pgd_cache, pgd);
+	__pgd_free(pgd);
 	return NULL;
 }
 
@@ -312,8 +242,8 @@
 			pgd_t pgdent = pgd[i];
 			void* pmd = (void *)__va(pgd_val(pgdent)-1);
 			paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-			kmem_cache_free(pmd_cache, pmd);
+			free_page((unsigned long)pmd);
 		}
 	/* in the non-PAE case, free_pgtables() clears user pgd entries */
-	kmem_cache_free(pgd_cache, pgd);
+	__pgd_free(pgd);
 }
Index: linux-2.6.21-rc5/include/asm-i386/pgalloc.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-i386/pgalloc.h	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/include/asm-i386/pgalloc.h	2007-03-28 18:23:51.000000000 +0000
@@ -36,8 +36,22 @@
 extern pgd_t *pgd_alloc(struct mm_struct *);
 extern void pgd_free(pgd_t *pgd);
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
-extern struct page *pte_alloc_one(struct mm_struct *, unsigned long);
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long uvaddr)
+{
+	return (pte_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+}
+
+#ifdef CONFIG_HIGHPTE
+static inline struct page *pte_alloc_one(struct mm_struct *mm, unsigned long uvaddr)
+{
+	return alloc_page(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO);
+}
+#else /* !CONFIG_HIGHPTE */
+static inline struct page *pte_alloc_one(struct mm_struct *mm, unsigned long uvaddr)
+{
+	return alloc_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+}
+#endif /* !CONFIG_HIGHPTE */
 
 static inline void pte_free_kernel(pte_t *pte)
 {
Index: linux-2.6.21-rc5/include/asm-i386/pgtable.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-i386/pgtable.h	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/include/asm-i386/pgtable.h	2007-03-28 18:23:51.000000000 +0000
@@ -35,15 +35,6 @@
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 extern unsigned long empty_zero_page[1024];
 extern pgd_t swapper_pg_dir[1024];
-extern struct kmem_cache *pgd_cache;
-extern struct kmem_cache *pmd_cache;
-extern spinlock_t pgd_lock;
-extern struct page *pgd_list;
-
-void pmd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_dtor(void *, struct kmem_cache *, unsigned long);
-void pgtable_cache_init(void);
 void paging_init(void);
 
 /*
Index: linux-2.6.21-rc5/include/asm-i386/pgtable-2level.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-i386/pgtable-2level.h	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/include/asm-i386/pgtable-2level.h	2007-03-28 18:23:51.000000000 +0000
@@ -67,5 +67,6 @@
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
 void vmalloc_sync_all(void);
+#define pgtable_cache_init()		do { } while (0)
 
 #endif /* _I386_PGTABLE_2LEVEL_H */
Index: linux-2.6.21-rc5/include/asm-i386/pgtable-3level.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-i386/pgtable-3level.h	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/include/asm-i386/pgtable-3level.h	2007-03-28 18:23:51.000000000 +0000
@@ -188,5 +188,6 @@
 #define __pmd_free_tlb(tlb, x)		do { } while (0)
 
 #define vmalloc_sync_all() ((void)0)
+void pgtable_cache_init(void);
 
 #endif /* _I386_PGTABLE_3LEVEL_H */
Index: linux-2.6.21-rc5/arch/i386/mm/fault.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/mm/fault.c	2007-03-25 22:56:23.000000000 +0000
+++ linux-2.6.21-rc5/arch/i386/mm/fault.c	2007-03-28 18:23:51.000000000 +0000
@@ -604,19 +604,19 @@
 	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
 	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
 		if (!test_bit(pgd_index(address), insync)) {
-			unsigned long flags;
-			struct page *page;
+			struct mm_struct *mm;
+			int broken = 0;
 
-			spin_lock_irqsave(&pgd_lock, flags);
-			for (page = pgd_list; page; page =
-					(struct page *)page->index)
-				if (!vmalloc_sync_one(page_address(page),
-								address)) {
-					BUG_ON(page != pgd_list);
-					break;
-				}
-			spin_unlock_irqrestore(&pgd_lock, flags);
-			if (!page)
+			spin_lock(&mmlist_lock);
+			list_for_each_entry(mm, &init_mm.mmlist, mmlist) {
+				if (vmalloc_sync_one(mm->pgd, address))
+					continue;
+				BUG_ON(mm->mmlist.prev != &init_mm.mmlist);
+				broken = 1;
+				break;
+			}
+			spin_unlock(&mmlist_lock);
+			if (!broken)
 				set_bit(pgd_index(address), insync);
 		}
 		if (address == start && test_bit(pgd_index(address), insync))
