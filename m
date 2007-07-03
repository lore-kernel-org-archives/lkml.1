Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXGCMK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXGCMK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbXGCMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:10:19 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:9566 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbXGCMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:10:15 -0400
Message-Id: <20070703121228.479973636@de.ibm.com>
References: <20070703111822.418649776@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 13:18:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: akpm@linux-foundation.org, hugh@veritas.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/5] remove ptep_establish.
Content-Disposition: inline; filename=002-ptep-establish.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The last user of ptep_establish in mm/ is long gone. Remove the
architecture primitive as well.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-arm/pgtable.h     |    6 ++---
 include/asm-generic/pgtable.h |   19 ------------------
 include/asm-i386/pgtable.h    |   11 ----------
 include/asm-ia64/pgtable.h    |    6 +++--
 include/asm-s390/pgtable.h    |   43 ++++++++++++++++++------------------------
 5 files changed, 26 insertions(+), 59 deletions(-)

diff -urpN linux-2.6/include/asm-arm/pgtable.h linux-2.6-patched/include/asm-arm/pgtable.h
--- linux-2.6/include/asm-arm/pgtable.h	2007-05-09 09:58:15.000000000 +0200
+++ linux-2.6-patched/include/asm-arm/pgtable.h	2007-07-03 12:56:47.000000000 +0200
@@ -83,14 +83,14 @@
  * means that a write to a clean page will cause a permission fault, and
  * the Linux MM layer will mark the page dirty via handle_pte_fault().
  * For the hardware to notice the permission change, the TLB entry must
- * be flushed, and ptep_establish() does that for us.
+ * be flushed, and ptep_set_access_flags() does that for us.
  *
  * The "accessed" or "young" bit is emulated by a similar method; we only
  * allow accesses to the page if the "young" bit is set.  Accesses to the
  * page will cause a fault, and handle_pte_fault() will set the young bit
  * for us as long as the page is marked present in the corresponding Linux
- * PTE entry.  Again, ptep_establish() will ensure that the TLB is up to
- * date.
+ * PTE entry.  Again, ptep_set_access_flags() will ensure that the TLB is
+ * up to date.
  *
  * However, when the "young" bit is cleared, we deny access to the page
  * by clearing the hardware PTE.  Currently Linux does not flush the TLB
diff -urpN linux-2.6/include/asm-generic/pgtable.h linux-2.6-patched/include/asm-generic/pgtable.h
--- linux-2.6/include/asm-generic/pgtable.h	2007-06-18 09:43:22.000000000 +0200
+++ linux-2.6-patched/include/asm-generic/pgtable.h	2007-07-03 12:56:47.000000000 +0200
@@ -3,25 +3,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifndef __HAVE_ARCH_PTEP_ESTABLISH
-/*
- * Establish a new mapping:
- *  - flush the old one
- *  - update the page tables
- *  - inform the TLB about the new one
- *
- * We hold the mm semaphore for reading, and the pte lock.
- *
- * Note: the old pte is known to not be writable, so we don't need to
- * worry about dirty bits etc getting lost.
- */
-#define ptep_establish(__vma, __address, __ptep, __entry)		\
-do {				  					\
-	set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry);	\
-	flush_tlb_page(__vma, __address);				\
-} while (0)
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
  * Largely same as above, but only sets the access flags (dirty,
diff -urpN linux-2.6/include/asm-i386/pgtable.h linux-2.6-patched/include/asm-i386/pgtable.h
--- linux-2.6/include/asm-i386/pgtable.h	2007-06-18 09:43:22.000000000 +0200
+++ linux-2.6-patched/include/asm-i386/pgtable.h	2007-07-03 12:56:47.000000000 +0200
@@ -317,17 +317,6 @@ static inline pte_t native_local_ptep_ge
 	__ret;								\
 })
 
-/*
- * Rules for using ptep_establish: the pte MUST be a user pte, and
- * must be a present->present transition.
- */
-#define __HAVE_ARCH_PTEP_ESTABLISH
-#define ptep_establish(vma, address, ptep, pteval)			\
-do {									\
-	set_pte_present((vma)->vm_mm, address, ptep, pteval);		\
-	flush_tlb_page(vma, address);					\
-} while (0)
-
 #define __HAVE_ARCH_PTEP_CLEAR_DIRTY_FLUSH
 #define ptep_clear_flush_dirty(vma, address, ptep)			\
 ({									\
diff -urpN linux-2.6/include/asm-ia64/pgtable.h linux-2.6-patched/include/asm-ia64/pgtable.h
--- linux-2.6/include/asm-ia64/pgtable.h	2007-06-18 09:43:22.000000000 +0200
+++ linux-2.6-patched/include/asm-ia64/pgtable.h	2007-07-03 12:56:47.000000000 +0200
@@ -546,8 +546,10 @@ extern void lazy_mmu_prot_update (pte_t 
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
 ({									\
 	int __changed = !pte_same(*(__ptep), __entry);			\
-	if (__changed)							\
-		ptep_establish(__vma, __addr, __ptep, __entry);		\
+	if (__changed) {						\
+		set_pte_at((__vma)->vm_mm, (__addr), __ptep, __entry);	\
+		flush_tlb_page(__vma, __addr);				\
+	}								\
 	__changed;							\
 })
 #endif
diff -urpN linux-2.6/include/asm-s390/pgtable.h linux-2.6-patched/include/asm-s390/pgtable.h
--- linux-2.6/include/asm-s390/pgtable.h	2007-06-18 09:43:22.000000000 +0200
+++ linux-2.6-patched/include/asm-s390/pgtable.h	2007-07-03 12:56:47.000000000 +0200
@@ -715,16 +715,19 @@ static inline void __ptep_ipte(unsigned 
 	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
 }
 
-static inline pte_t
-ptep_clear_flush(struct vm_area_struct *vma,
-		 unsigned long address, pte_t *ptep)
+static inline void ptep_invalidate(unsigned long address, pte_t *ptep)
 {
-	pte_t pte = *ptep;
-	pte_t *shadow_pte = get_shadow_pte(ptep);
-
 	__ptep_ipte(address, ptep);
-	if (shadow_pte)
-		__ptep_ipte(address, shadow_pte);
+	ptep = get_shadow_pte(ptep);
+	if (ptep)
+		__ptep_ipte(address, ptep);
+}
+
+static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
+				     unsigned long address, pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	ptep_invalidate(address, ptep);
 	return pte;
 }
 
@@ -734,21 +737,14 @@ static inline void ptep_set_wrprotect(st
 	set_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
 }
 
-static inline void
-ptep_establish(struct vm_area_struct *vma, 
-	       unsigned long address, pte_t *ptep,
-	       pte_t entry)
-{
-	ptep_clear_flush(vma, address, ptep);
-	set_pte(ptep, entry);
-}
-
-#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-({									  \
-	int __changed = !pte_same(*(__ptep), __entry);			  \
-	if (__changed)							  \
-		ptep_establish(__vma, __address, __ptep, __entry);	  \
-	__changed;							  \
+#define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __dirty)	\
+({									\
+	int __changed = !pte_same(*(__ptep), __entry);			\
+	if (__changed) {						\
+		ptep_invalidate(__addr, __ptep);			\
+		set_pte_at((__vma)->vm_mm, __addr, __ptep, __entry);	\
+	}								\
+	__changed;							\
 })
 
 /*
@@ -948,7 +944,6 @@ extern int remove_shared_memory(unsigned
 #define __HAVE_ARCH_MEMMAP_INIT
 extern void memmap_init(unsigned long, int, unsigned long, unsigned long);
 
-#define __HAVE_ARCH_PTEP_ESTABLISH
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

