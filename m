Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbYBBJJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbYBBJJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762269AbYBBJHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:07:03 -0500
Received: from gw.goop.org ([64.81.55.164]:56621 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833AbYBBJG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:06:58 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 7] x86: add common mm/pgtable.c
X-Mercurial-Node: 3c9aba41ee700a239859e5349a6c10c1a418bb18
Message-Id: <3c9aba41ee700a239859.1201943114@localhost>
In-Reply-To: <patchbomb.1201943112@localhost>
Date: Sat, 02 Feb 2008 01:05:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a common arch/x86/mm/pgtable.c file for common pagetable functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/Makefile_32      |    2
 arch/x86/mm/Makefile_64      |    2
 arch/x86/mm/pgtable.c        |  234 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/pgtable_32.c     |  185 ---------------------------------
 include/asm-x86/pgalloc.h    |   19 +++
 include/asm-x86/pgalloc_32.h |   11 -
 include/asm-x86/pgalloc_64.h |   61 ----------
 7 files changed, 255 insertions(+), 259 deletions(-)

diff --git a/arch/x86/mm/Makefile_32 b/arch/x86/mm/Makefile_32
--- a/arch/x86/mm/Makefile_32
+++ b/arch/x86/mm/Makefile_32
@@ -2,7 +2,7 @@
 # Makefile for the linux i386-specific parts of the memory manager.
 #
 
-obj-y	:= init_32.o pgtable_32.o fault.o ioremap.o extable.o pageattr.o mmap.o
+obj-y	:= init_32.o pgtable.o pgtable_32.o fault.o ioremap.o extable.o pageattr.o mmap.o
 
 obj-$(CONFIG_NUMA) += discontig_32.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
diff --git a/arch/x86/mm/Makefile_64 b/arch/x86/mm/Makefile_64
--- a/arch/x86/mm/Makefile_64
+++ b/arch/x86/mm/Makefile_64
@@ -2,7 +2,7 @@
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
 
-obj-y	 := init_64.o fault.o ioremap.o extable.o pageattr.o mmap.o
+obj-y	 := init_64.o fault.o ioremap.o extable.o pageattr.o pgtable.o mmap.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
new file mode 100644
--- /dev/null
+++ b/arch/x86/mm/pgtable.c
@@ -0,0 +1,235 @@
+#include <asm/pgalloc.h>
+#include <asm/tlb.h>
+
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+}
+
+struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	struct page *pte;
+
+#ifdef CONFIG_HIGHPTE
+	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO, 0);
+#else
+	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+#endif
+	return pte;
+}
+
+#ifdef CONFIG_X86_64
+static inline void pgd_list_add(pgd_t *pgd)
+{
+	struct page *page = virt_to_page(pgd);
+
+	spin_lock(&pgd_lock);
+	list_add(&page->lru, &pgd_list);
+	spin_unlock(&pgd_lock);
+}
+
+static inline void pgd_list_del(pgd_t *pgd)
+{
+	struct page *page = virt_to_page(pgd);
+
+	spin_lock(&pgd_lock);
+	list_del(&page->lru);
+	spin_unlock(&pgd_lock);
+}
+
+pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	unsigned boundary;
+	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	if (!pgd)
+		return NULL;
+	pgd_list_add(pgd);
+	/*
+	 * Copy kernel pointers in from init.
+	 * Could keep a freelist or slab cache of those because the kernel
+	 * part never changes.
+	 */
+	boundary = pgd_index(__PAGE_OFFSET);
+	memset(pgd, 0, boundary * sizeof(pgd_t));
+	memcpy(pgd + boundary,
+	       init_level4_pgt + boundary,
+	       (PTRS_PER_PGD - boundary) * sizeof(pgd_t));
+	return pgd;
+}
+
+void pgd_free(pgd_t *pgd)
+{
+	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
+	pgd_list_del(pgd);
+	free_page((unsigned long)pgd);
+}
+
+#else
+/*
+ * List of all pgd's needed for non-PAE so it can invalidate entries
+ * in both cached and uncached pgd's; not needed for PAE since the
+ * kernel pmd is shared. If PAE were not to share the pmd a similar
+ * tactic would be needed. This is essentially codepath-based locking
+ * against pageattr.c; it is the unique case in which a valid change
+ * of kernel pagetables can't be lazily synchronized by vmalloc faults.
+ * vmalloc faults work because attached pagetables are never freed.
+ * -- wli
+ */
+static inline void pgd_list_add(pgd_t *pgd)
+{
+	struct page *page = virt_to_page(pgd);
+
+	list_add(&page->lru, &pgd_list);
+}
+
+static inline void pgd_list_del(pgd_t *pgd)
+{
+	struct page *page = virt_to_page(pgd);
+
+	list_del(&page->lru);
+}
+
+#define UNSHARED_PTRS_PER_PGD				\
+	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
+
+static void pgd_ctor(void *p)
+{
+	pgd_t *pgd = p;
+	unsigned long flags;
+
+	/* Clear usermode parts of PGD */
+	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
+
+	spin_lock_irqsave(&pgd_lock, flags);
+
+	/* If the pgd points to a shared pagetable level (either the
+	   ptes in non-PAE, or shared PMD in PAE), then just copy the
+	   references from swapper_pg_dir. */
+	if (PAGETABLE_LEVELS == 2 ||
+	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD)) {
+		clone_pgd_range(pgd + USER_PTRS_PER_PGD,
+				swapper_pg_dir + USER_PTRS_PER_PGD,
+				KERNEL_PGD_PTRS);
+		paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
+					__pa(swapper_pg_dir) >> PAGE_SHIFT,
+					USER_PTRS_PER_PGD,
+					KERNEL_PGD_PTRS);
+	}
+
+	/* list required to sync kernel mapping updates */
+	if (!SHARED_KERNEL_PMD)
+		pgd_list_add(pgd);
+
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
+static void pgd_dtor(void *pgd)
+{
+	unsigned long flags; /* can be called from interrupt context */
+
+	if (SHARED_KERNEL_PMD)
+		return;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+	pgd_list_del(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
+#ifdef CONFIG_X86_PAE
+/*
+ * Mop up any pmd pages which may still be attached to the pgd.
+ * Normally they will be freed by munmap/exit_mmap, but any pmd we
+ * preallocate which never got a corresponding vma will need to be
+ * freed manually.
+ */
+static void pgd_mop_up_pmds(pgd_t *pgdp)
+{
+	int i;
+
+	for(i = 0; i < UNSHARED_PTRS_PER_PGD; i++) {
+		pgd_t pgd = pgdp[i];
+
+		if (pgd_val(pgd) != 0) {
+			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
+
+			pgdp[i] = native_make_pgd(0);
+
+			paravirt_release_pd(pgd_val(pgd) >> PAGE_SHIFT);
+			pmd_free(pmd);
+		}
+	}
+}
+
+/*
+ * In PAE mode, we need to do a cr3 reload (=tlb flush) when
+ * updating the top-level pagetable entries to guarantee the
+ * processor notices the update.  Since this is expensive, and
+ * all 4 top-level entries are used almost immediately in a
+ * new process's life, we just pre-populate them here.
+ *
+ * Also, if we're in a paravirt environment where the kernel pmd is
+ * not shared between pagetables (!SHARED_KERNEL_PMDS), we allocate
+ * and initialize the kernel pmds here.
+ */
+static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
+{
+	pud_t *pud;
+	unsigned long addr;
+	int i;
+
+	pud = pud_offset(pgd, 0);
+ 	for (addr = i = 0; i < UNSHARED_PTRS_PER_PGD;
+	     i++, pud++, addr += PUD_SIZE) {
+		pmd_t *pmd = pmd_alloc_one(mm, addr);
+
+		if (!pmd) {
+			pgd_mop_up_pmds(pgd);
+			return 0;
+		}
+
+		if (i >= USER_PTRS_PER_PGD)
+			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
+			       sizeof(pmd_t) * PTRS_PER_PMD);
+
+		pud_populate(mm, pud, pmd);
+	}
+
+	return 1;
+}
+#else  /* !CONFIG_X86_PAE */
+/* No need to prepopulate any pagetable entries in non-PAE modes. */
+static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
+{
+	return 1;
+}
+
+static void pgd_mop_up_pmds(pgd_t *pgd)
+{
+}
+#endif	/* CONFIG_X86_PAE */
+
+pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
+
+	mm->pgd = pgd;		/* so that alloc_pd can use it */
+
+	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
+		quicklist_free(0, pgd_dtor, pgd);
+		pgd = NULL;
+	}
+
+	return pgd;
+}
+
+void pgd_free(pgd_t *pgd)
+{
+	pgd_mop_up_pmds(pgd);
+	quicklist_free(0, pgd_dtor, pgd);
+}
+
+void check_pgt_cache(void)
+{
+	quicklist_trim(0, pgd_dtor, 25, 16);
+}
+#endif
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -178,191 +178,6 @@
 	__VMALLOC_RESERVE += reserve;
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
-/*
- * List of all pgd's needed for non-PAE so it can invalidate entries
- * in both cached and uncached pgd's; not needed for PAE since the
- * kernel pmd is shared. If PAE were not to share the pmd a similar
- * tactic would be needed. This is essentially codepath-based locking
- * against pageattr.c; it is the unique case in which a valid change
- * of kernel pagetables can't be lazily synchronized by vmalloc faults.
- * vmalloc faults work because attached pagetables are never freed.
- * -- wli
- */
-static inline void pgd_list_add(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_add(&page->lru, &pgd_list);
-}
-
-static inline void pgd_list_del(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_del(&page->lru);
-}
-
-#define UNSHARED_PTRS_PER_PGD				\
-	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
-
-static void pgd_ctor(void *p)
-{
-	pgd_t *pgd = p;
-	unsigned long flags;
-
-	/* Clear usermode parts of PGD */
-	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
-
-	spin_lock_irqsave(&pgd_lock, flags);
-
-	/* If the pgd points to a shared pagetable level (either the
-	   ptes in non-PAE, or shared PMD in PAE), then just copy the
-	   references from swapper_pg_dir. */
-	if (PAGETABLE_LEVELS == 2 ||
-	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD)) {
-		clone_pgd_range(pgd + USER_PTRS_PER_PGD,
-				swapper_pg_dir + USER_PTRS_PER_PGD,
-				KERNEL_PGD_PTRS);
-		paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
-					__pa(swapper_pg_dir) >> PAGE_SHIFT,
-					USER_PTRS_PER_PGD,
-					KERNEL_PGD_PTRS);
-	}
-
-	/* list required to sync kernel mapping updates */
-	if (!SHARED_KERNEL_PMD)
-		pgd_list_add(pgd);
-
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-
-static void pgd_dtor(void *pgd)
-{
-	unsigned long flags; /* can be called from interrupt context */
-
-	if (SHARED_KERNEL_PMD)
-		return;
-
-	spin_lock_irqsave(&pgd_lock, flags);
-	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-
-#ifdef CONFIG_X86_PAE
-/*
- * Mop up any pmd pages which may still be attached to the pgd.
- * Normally they will be freed by munmap/exit_mmap, but any pmd we
- * preallocate which never got a corresponding vma will need to be
- * freed manually.
- */
-static void pgd_mop_up_pmds(pgd_t *pgdp)
-{
-	int i;
-
-	for(i = 0; i < UNSHARED_PTRS_PER_PGD; i++) {
-		pgd_t pgd = pgdp[i];
-
-		if (pgd_val(pgd) != 0) {
-			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
-
-			pgdp[i] = native_make_pgd(0);
-
-			paravirt_release_pd(pgd_val(pgd) >> PAGE_SHIFT);
-			pmd_free(pmd);
-		}
-	}
-}
-
-/*
- * In PAE mode, we need to do a cr3 reload (=tlb flush) when
- * updating the top-level pagetable entries to guarantee the
- * processor notices the update.  Since this is expensive, and
- * all 4 top-level entries are used almost immediately in a
- * new process's life, we just pre-populate them here.
- *
- * Also, if we're in a paravirt environment where the kernel pmd is
- * not shared between pagetables (!SHARED_KERNEL_PMDS), we allocate
- * and initialize the kernel pmds here.
- */
-static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
-{
-	pud_t *pud;
-	unsigned long addr;
-	int i;
-
-	pud = pud_offset(pgd, 0);
- 	for (addr = i = 0; i < UNSHARED_PTRS_PER_PGD;
-	     i++, pud++, addr += PUD_SIZE) {
-		pmd_t *pmd = pmd_alloc_one(mm, addr);
-
-		if (!pmd) {
-			pgd_mop_up_pmds(pgd);
-			return 0;
-		}
-
-		if (i >= USER_PTRS_PER_PGD)
-			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
-			       sizeof(pmd_t) * PTRS_PER_PMD);
-
-		pud_populate(mm, pud, pmd);
-	}
-
-	return 1;
-}
-#else  /* !CONFIG_X86_PAE */
-/* No need to prepopulate any pagetable entries in non-PAE modes. */
-static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
-{
-	return 1;
-}
-
-static void pgd_mop_up_pmds(pgd_t *pgd)
-{
-}
-#endif	/* CONFIG_X86_PAE */
-
-pgd_t *pgd_alloc(struct mm_struct *mm)
-{
-	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
-
-	mm->pgd = pgd;		/* so that alloc_pd can use it */
-
-	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
-		quicklist_free(0, pgd_dtor, pgd);
-		pgd = NULL;
-	}
-
-	return pgd;
-}
-
-void pgd_free(pgd_t *pgd)
-{
-	pgd_mop_up_pmds(pgd);
-	quicklist_free(0, pgd_dtor, pgd);
-}
-
-void check_pgt_cache(void)
-{
-	quicklist_trim(0, pgd_dtor, 25, 16);
-}
-
 void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	paravirt_release_pt(page_to_pfn(pte));
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -1,5 +1,23 @@
+#ifndef _ASM_X86_PGALLOC_H
+#define _ASM_X86_PGALLOC_H
+
+#include <linux/threads.h>
+#include <linux/mm.h>		/* for struct page */
+#include <linux/pagemap.h>
+
+/*
+ * Allocate and free page tables.
+ */
+pgd_t *pgd_alloc(struct mm_struct *mm);
+void pgd_free(pgd_t *pgd);
+
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address);
+struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address);
+
 #ifdef CONFIG_X86_32
 # include "pgalloc_32.h"
 #else
 # include "pgalloc_64.h"
 #endif
+
+#endif	/* _ASM_X86_PGALLOC_H */
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -1,11 +1,5 @@
 #ifndef _I386_PGALLOC_H
 #define _I386_PGALLOC_H
-
-#include <linux/threads.h>
-#include <linux/mm.h>		/* for struct page */
-#include <linux/pagemap.h>
-#include <asm/tlb.h>
-#include <asm-generic/tlb.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
@@ -35,11 +29,6 @@
 /*
  * Allocate and free page tables.
  */
-extern pgd_t *pgd_alloc(struct mm_struct *);
-extern void pgd_free(pgd_t *pgd);
-
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
-extern struct page *pte_alloc_one(struct mm_struct *, unsigned long);
 
 static inline void pte_free_kernel(pte_t *pte)
 {
diff --git a/include/asm-x86/pgalloc_64.h b/include/asm-x86/pgalloc_64.h
--- a/include/asm-x86/pgalloc_64.h
+++ b/include/asm-x86/pgalloc_64.h
@@ -1,8 +1,6 @@
 #ifndef _X86_64_PGALLOC_H
 #define _X86_64_PGALLOC_H
 
-#include <linux/threads.h>
-#include <linux/mm.h>
 #include <asm/pda.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
@@ -47,64 +45,6 @@
 	free_page((unsigned long)pud);
 }
 
-static inline void pgd_list_add(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	spin_lock(&pgd_lock);
-	list_add(&page->lru, &pgd_list);
-	spin_unlock(&pgd_lock);
-}
-
-static inline void pgd_list_del(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	spin_lock(&pgd_lock);
-	list_del(&page->lru);
-	spin_unlock(&pgd_lock);
-}
-
-static inline pgd_t *pgd_alloc(struct mm_struct *mm)
-{
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
-	return pgd;
-}
-
-static inline void pgd_free(pgd_t *pgd)
-{
-	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	pgd_list_del(pgd);
-	free_page((unsigned long)pgd);
-}
-
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	return (pte_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-}
-
-static inline struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	void *p = (void *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-	if (!p)
-		return NULL;
-	return virt_to_page(p);
-}
-
 /* Should really implement gc for free page table pages. This could be
    done with a reference count in struct page. */
 


