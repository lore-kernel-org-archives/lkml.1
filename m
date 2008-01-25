Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYAYVyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYAYVyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbYAYVwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:25 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37916 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756174AbYAYVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 11] x86: don't special-case pmd allocations as much
X-Mercurial-Node: 879098bf2f123dc9db8b6980c97338aa8b2ccfda
Message-Id: <879098bf2f123dc9db8b.1201296196@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In x86 PAE mode, stop treating pmds as a special case.  Previously
they were always allocated and freed with the pgd.  The modifies the
code to be the same as 64-bit mode, where they are allocated on
demand.

This is a step on the way to unifying 32/64-bit pagetable allocation
as much as possible.

There is a complicating wart, however.  When you install a new
reference to a pmd in the pgd, the processor isn't guaranteed to see
it unless you reload cr3.  Since reloading cr3 also has the
side-effect of flushing the tlb, this is an expense that we want to
avoid whereever possible.

This patch simply avoids reloading cr3 unless the update is to the
current pagetable.  Later patches will optimise this further.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: William Irwin <wli@holomorphy.com>
---
 arch/x86/mm/init_32.c            |   13 -------
 arch/x86/mm/pgtable_32.c         |   68 --------------------------------------
 include/asm-x86/pgalloc_32.h     |   22 ++++++++++--
 include/asm-x86/pgtable-3level.h |   39 +++++++++++++++------
 include/asm-x86/pgtable_32.h     |    3 -
 5 files changed, 47 insertions(+), 98 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -709,19 +709,6 @@ int arch_add_memory(int nid, u64 start, 
 }
 #endif
 
-struct kmem_cache *pmd_cache;
-
-void __init pgtable_cache_init(void)
-{
-	if (PTRS_PER_PMD > 1) {
-		pmd_cache = kmem_cache_create("pmd",
-					      PTRS_PER_PMD*sizeof(pmd_t),
-					      PTRS_PER_PMD*sizeof(pmd_t),
-					      SLAB_PANIC,
-					      pmd_ctor);
-	}
-}
-
 /*
  * This function cannot be __init, since exceptions don't work in that
  * section.  Put this after the callers, so that it cannot be inlined.
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -195,11 +195,6 @@ struct page *pte_alloc_one(struct mm_str
 	return pte;
 }
 
-void pmd_ctor(struct kmem_cache *cache, void *pmd)
-{
-	memset(pmd, 0, PTRS_PER_PMD*sizeof(pmd_t));
-}
-
 /*
  * List of all pgd's needed for non-PAE so it can invalidate entries
  * in both cached and uncached pgd's; not needed for PAE since the
@@ -258,85 +253,22 @@ static void pgd_dtor(void *pgd)
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
 	spin_lock_irqsave(&pgd_lock, flags);
 	pgd_list_del(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
-/* If we allocate a pmd for part of the kernel address space, then
-   make sure its initialized with the appropriate kernel mappings.
-   Otherwise use a cached zeroed pmd.  */
-static pmd_t *pmd_cache_alloc(int idx)
-{
-	pmd_t *pmd;
-
-	if (idx >= USER_PTRS_PER_PGD) {
-		pmd = (pmd_t *)__get_free_page(GFP_KERNEL);
-
-		if (pmd)
-			memcpy(pmd,
-			       (void *)pgd_page_vaddr(swapper_pg_dir[idx]),
-			       sizeof(pmd_t) * PTRS_PER_PMD);
-	} else
-		pmd = kmem_cache_alloc(pmd_cache, GFP_KERNEL);
-
-	return pmd;
-}
-
-static void pmd_cache_free(pmd_t *pmd, int idx)
-{
-	if (idx >= USER_PTRS_PER_PGD)
-		free_page((unsigned long)pmd);
-	else
-		kmem_cache_free(pmd_cache, pmd);
-}
-
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	int i;
 	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
-
-	if (PTRS_PER_PMD == 1 || !pgd)
-		return pgd;
 
 	mm->pgd = pgd;		/* so that alloc_pd can use it */
 
- 	for (i = 0; i < UNSHARED_PTRS_PER_PGD; ++i) {
-		pmd_t *pmd = pmd_cache_alloc(i);
-
-		if (!pmd)
-			goto out_oom;
-
-		paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
-		set_pgd(&pgd[i], __pgd(1 + __pa(pmd)));
-	}
 	return pgd;
-
-out_oom:
-	for (i--; i >= 0; i--) {
-		pgd_t pgdent = pgd[i];
-		void* pmd = (void *)__va(pgd_val(pgdent)-1);
-		paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-		pmd_cache_free(pmd, i);
-	}
-	quicklist_free(0, pgd_dtor, pgd);
-	return NULL;
 }
 
 void pgd_free(pgd_t *pgd)
 {
-	int i;
-
-	/* in the PAE case user pgd entries are overwritten before usage */
-	if (PTRS_PER_PMD > 1)
-		for (i = 0; i < UNSHARED_PTRS_PER_PGD; ++i) {
-			pgd_t pgdent = pgd[i];
-			void* pmd = (void *)__va(pgd_val(pgdent)-1);
-			paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-			pmd_cache_free(pmd, i);
-		}
-	/* in the non-PAE case, free_pgtables() clears user pgd entries */
 	quicklist_free(0, pgd_dtor, pgd);
 }
 
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -63,21 +63,35 @@ static inline void __pte_free_tlb(struct
  */
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	BUG();
-	return (pmd_t *)2;
+	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
 }
 
 static inline void pmd_free(pmd_t *pmd)
 {
+	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	free_page((unsigned long)pmd);
 }
 
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
+	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
+	tlb_remove_page(tlb, virt_to_page(pmd));
 }
 
-static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 {
-	BUG();
+	paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
+
+	/* Note: almost everything apart from _PAGE_PRESENT is
+	   reserved at the pmd (PDPT) level. */
+	set_pud(pudp, __pud(__pa(pmd) | _PAGE_PRESENT));
+
+	/*
+	 * Pentium-II erratum A13: in PAE mode we explicitly have to flush
+	 * the TLB via cr3 if the top-level pgd is changed...
+	 */
+	if (mm == current->active_mm)
+		write_cr3(read_cr3());
 }
 #endif	/* CONFIG_X86_PAE */
 
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -15,9 +15,19 @@
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %p(%016Lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
 
-#define pud_none(pud)				0
-#define pud_bad(pud)				0
-#define pud_present(pud)			1
+
+static inline int pud_none(pud_t pud)
+{
+	return pud_val(pud) == 0;
+}
+static inline int pud_bad(pud_t pud)
+{
+	return (pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+}
+static inline int pud_present(pud_t pud)
+{
+	return pud_val(pud) & _PAGE_PRESENT;
+}
 
 /* Rules for using set_pte: the pte being assigned *must* be
  * either not present or in a state where the hardware will
@@ -58,7 +68,7 @@ static inline void native_set_pmd(pmd_t 
 }
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
-	*pudp = pud;
+	set_64bit((unsigned long long *)(pudp),native_pud_val(pud));
 }
 
 /*
@@ -81,13 +91,20 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
-/*
- * Pentium-II erratum A13: in PAE mode we explicitly have to flush
- * the TLB via cr3 if the top-level pgd is changed...
- * We do not let the generic code free and clear pgd entries due to
- * this erratum.
- */
-static inline void pud_clear (pud_t * pud) { }
+static inline void pud_clear(pud_t *pudp)
+{
+	set_pud(pudp, __pud(0));
+
+	/*
+	 * Pentium-II erratum A13: in PAE mode we explicitly have to flush
+	 * the TLB via cr3 if the top-level pgd is changed...
+	 *
+	 * XXX I don't think we need to worry about this here, since
+	 * when clearing the pud, the calling code needs to flush the
+	 * tlb anyway.  But do it now for safety's sake. - jsgf
+	 */
+	write_cr3(read_cr3());
+}
 
 #define pud_page(pud) \
 ((struct page *) __va(pud_val(pud) & PAGE_MASK))
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -29,8 +29,7 @@ extern struct kmem_cache *pmd_cache;
 extern struct kmem_cache *pmd_cache;
 void check_pgt_cache(void);
 
-void pmd_ctor(struct kmem_cache *, void *);
-void pgtable_cache_init(void);
+static inline void pgtable_cache_init(void) {}
 void paging_init(void);
 
 


