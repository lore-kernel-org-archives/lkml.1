Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYAHWQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYAHWQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAHWPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:37 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47851
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751937AbYAHWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 10] x86: pgtable: unify pte accessors
X-Mercurial-Node: dbbbaca3c9a0929b8eb8c23a8e9bdb354f9588fe
Message-Id: <dbbbaca3c9a0929b8eb8.1199829610@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make various pte accessors common.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/pgtable-2level.h |    1
 include/asm-x86/pgtable-3level.h |    1
 include/asm-x86/pgtable.h        |  110 +++++++++++++++++++++++++++++++++++++-
 include/asm-x86/pgtable_32.h     |  101 ----------------------------------
 include/asm-x86/pgtable_64.h     |   43 +-------------
 5 files changed, 113 insertions(+), 143 deletions(-)

diff --git a/include/asm-x86/pgtable-2level.h b/include/asm-x86/pgtable-2level.h
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -33,7 +33,6 @@ static inline void native_set_pmd(pmd_t 
 #define set_pte_atomic(pteptr, pteval) set_pte(pteptr,pteval)
 #define set_pte_present(mm,addr,ptep,pteval) set_pte_at(mm,addr,ptep,pteval)
 
-#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
 static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -101,7 +101,6 @@ static inline void native_pmd_clear(pmd_
 #define set_pte_atomic(ptep, pte)		native_set_pte_atomic(ptep, pte)
 #define set_pmd(pmdp, pmd)			native_set_pmd(pmdp, pmd)
 #define set_pud(pudp, pud)			native_set_pud(pudp, pud)
-#define pte_clear(mm, addr, ptep)		native_pte_clear(mm, addr, ptep)
 #define pmd_clear(pmd)				native_pmd_clear(pmd)
 #endif
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -110,6 +110,7 @@ extern unsigned long long __PAGE_KERNEL,
 #define __S111	PAGE_SHARED_EXEC
 
 #ifndef __ASSEMBLER__
+
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
@@ -166,7 +167,6 @@ static inline pte_t pte_modify(pte_t pte
 	return __pte(val);
 }
 
-
 #endif	/* __ASSEMBLER__ */
 
 #ifdef CONFIG_X86_32
@@ -175,4 +175,112 @@ static inline pte_t pte_modify(pte_t pte
 # include "pgtable_64.h"
 #endif
 
+#ifndef __ASSEMBLER__
+
+#ifndef CONFIG_PARAVIRT
+/*
+ * Rules for using pte_update - it must be called after any PTE update which
+ * has not been done using the set_pte / clear_pte interfaces.  It is used by
+ * shadow mode hypervisors to resynchronize the shadow page tables.  Kernel PTE
+ * updates should either be sets, clears, or set_pte_atomic for P->P
+ * transitions, which means this hook should only be called for user PTEs.
+ * This hook implies a P->P protection or access change has taken place, which
+ * requires a subsequent TLB flush.  The notification can optionally be delayed
+ * until the TLB flush event by using the pte_update_defer form of the
+ * interface, but care must be taken to assure that the flush happens while
+ * still holding the same page table lock so that the shadow and primary pages
+ * do not become out of sync on SMP.
+ */
+#define pte_update(mm, addr, ptep)		do { } while (0)
+#define pte_update_defer(mm, addr, ptep)	do { } while (0)
+#endif
+
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res = *ptep;
+
+	/* Pure native function needs no input for mm, addr */
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
+/*
+ * We only update the dirty/accessed state if we set
+ * the dirty bit by hand in the kernel, since the hardware
+ * will do the accessed bit for us, and we don't want to
+ * race with other CPU's that might be updating the dirty
+ * bit at the same time.
+ */
+#define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+#define ptep_set_access_flags(vma, address, ptep, entry, dirty)		\
+({									\
+	int __changed = !pte_same(*(ptep), entry);			\
+	if (__changed && dirty) {					\
+		*ptep = entry;						\
+		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
+		flush_tlb_page(vma, address);				\
+	}								\
+	__changed;							\
+})
+
+#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+#define ptep_test_and_clear_young(vma, addr, ptep) ({			\
+	int __ret = 0;							\
+	if (pte_young(*(ptep)))						\
+		__ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,		\
+					   &(ptep)->pte);		\
+	if (__ret)							\
+		pte_update((vma)->vm_mm, addr, ptep);			\
+	__ret;								\
+})
+
+#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+#define ptep_clear_flush_young(vma, address, ptep)			\
+({									\
+	int __young;							\
+	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
+	if (__young)							\
+		flush_tlb_page(vma, address);				\
+	__young;							\
+})
+
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = native_ptep_get_and_clear(ptep);
+	pte_update(mm, addr, ptep);
+	return pte;
+}
+
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
+static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
+{
+	pte_t pte;
+	if (full) {
+		/*
+		 * Full address destruction in progress; paravirt does not
+		 * care about updates and native needs no locking
+		 */
+		pte = native_local_ptep_get_and_clear(ptep);
+	} else {
+		pte = ptep_get_and_clear(mm, addr, ptep);
+	}
+	return pte;
+}
+
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	clear_bit(_PAGE_BIT_RW, &ptep->pte);
+	pte_update(mm, addr, ptep);
+}
+
+#ifndef CONFIG_PARAVIRT
+#define pte_clear(mm, addr, ptep)		native_pte_clear(mm, addr, ptep)
+#endif	/* !CONFIG_PARAVIRT */
+
+#include <asm-generic/pgtable.h>
+#endif	/* __ASSEMBLER__ */
+
 #endif	/* _ASM_X86_PGTABLE_H */
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -106,105 +106,6 @@ extern unsigned long pg0[];
 #else
 # include <asm/pgtable-2level.h>
 #endif
-
-#ifndef CONFIG_PARAVIRT
-/*
- * Rules for using pte_update - it must be called after any PTE update which
- * has not been done using the set_pte / clear_pte interfaces.  It is used by
- * shadow mode hypervisors to resynchronize the shadow page tables.  Kernel PTE
- * updates should either be sets, clears, or set_pte_atomic for P->P
- * transitions, which means this hook should only be called for user PTEs.
- * This hook implies a P->P protection or access change has taken place, which
- * requires a subsequent TLB flush.  The notification can optionally be delayed
- * until the TLB flush event by using the pte_update_defer form of the
- * interface, but care must be taken to assure that the flush happens while
- * still holding the same page table lock so that the shadow and primary pages
- * do not become out of sync on SMP.
- */
-#define pte_update(mm, addr, ptep)		do { } while (0)
-#define pte_update_defer(mm, addr, ptep)	do { } while (0)
-#endif
-
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res = *ptep;
-
-	/* Pure native function needs no input for mm, addr */
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
-/*
- * We only update the dirty/accessed state if we set
- * the dirty bit by hand in the kernel, since the hardware
- * will do the accessed bit for us, and we don't want to
- * race with other CPU's that might be updating the dirty
- * bit at the same time.
- */
-#define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-#define ptep_set_access_flags(vma, address, ptep, entry, dirty)		\
-({									\
-	int __changed = !pte_same(*(ptep), entry);			\
-	if (__changed && dirty) {					\
-		(ptep)->pte_low = (entry).pte_low;			\
-		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
-		flush_tlb_page(vma, address);				\
-	}								\
-	__changed;							\
-})
-
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define ptep_test_and_clear_young(vma, addr, ptep) ({			\
-	int __ret = 0;							\
-	if (pte_young(*(ptep)))						\
-		__ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,		\
-						&(ptep)->pte_low);	\
-	if (__ret)							\
-		pte_update((vma)->vm_mm, addr, ptep);			\
-	__ret;								\
-})
-
-#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-#define ptep_clear_flush_young(vma, address, ptep)			\
-({									\
-	int __young;							\
-	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
-	if (__young)							\
-		flush_tlb_page(vma, address);				\
-	__young;							\
-})
-
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	pte_t pte = native_ptep_get_and_clear(ptep);
-	pte_update(mm, addr, ptep);
-	return pte;
-}
-
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
-{
-	pte_t pte;
-	if (full) {
-		/*
-		 * Full address destruction in progress; paravirt does not
-		 * care about updates and native needs no locking
-		 */
-		pte = native_local_ptep_get_and_clear(ptep);
-	} else {
-		pte = ptep_get_and_clear(mm, addr, ptep);
-	}
-	return pte;
-}
-
-#define __HAVE_ARCH_PTEP_SET_WRPROTECT
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	clear_bit(_PAGE_BIT_RW, &ptep->pte_low);
-	pte_update(mm, addr, ptep);
-}
 
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
@@ -359,6 +260,4 @@ static inline void paravirt_pagetable_se
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#include <asm-generic/pgtable.h>
-
 #endif /* _I386_PGTABLE_H */
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -101,18 +101,18 @@ static inline void pgd_clear (pgd_t * pg
 	set_pgd(pgd, __pgd(0));
 }
 
-#define ptep_get_and_clear(mm,addr,xp)	__pte(xchg(&(xp)->pte, 0))
+#define native_ptep_get_and_clear(xp) __pte(xchg(&(xp)->pte, 0))
 
 struct mm_struct;
 
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
+static inline pte_t native_ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
 {
 	pte_t pte;
 	if (full) {
 		pte = *ptep;
 		*ptep = __pte(0);
 	} else {
-		pte = ptep_get_and_clear(mm, addr, ptep);
+		pte = native_ptep_get_and_clear(ptep);
 	}
 	return pte;
 }
@@ -158,25 +158,11 @@ static inline unsigned long pmd_bad(pmd_
 
 #define pte_none(x)	(!pte_val(x))
 #define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
-#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+#define native_pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this right? */
 #define pte_page(x)	pfn_to_page(pte_pfn(x))
 #define pte_pfn(x)  ((pte_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
-
-struct vm_area_struct;
-
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	if (!pte_young(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte);
-}
-
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	clear_bit(_PAGE_BIT_RW, &ptep->pte);
-}
 
 /*
  * Macro to mark a page protection value as "uncacheable".
@@ -243,22 +229,6 @@ static inline void ptep_set_wrprotect(st
 
 #define update_mmu_cache(vma,address,pte) do { } while (0)
 
-/* We only update the dirty/accessed state if we set
- * the dirty bit by hand in the kernel, since the hardware
- * will do the accessed bit for us, and we don't want to
- * race with other CPU's that might be updating the dirty
- * bit at the same time. */
-#define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-({									  \
-	int __changed = !pte_same(*(__ptep), __entry);			  \
-	if (__changed && __dirty) {					  \
-		set_pte(__ptep, __entry);			  	  \
-		flush_tlb_page(__vma, __address);		  	  \
-	}								  \
-	__changed;							  \
-})
-
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x3f)
 #define __swp_offset(x)			((x).val >> 8)
@@ -290,12 +260,7 @@ pte_t *lookup_address(unsigned long addr
 #define	kc_offset_to_vaddr(o) \
    (((o) & (1UL << (__VIRTUAL_MASK_SHIFT-1))) ? ((o) | (~__VIRTUAL_MASK)) : (o))
 
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
-#define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
-#include <asm-generic/pgtable.h>
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _X86_64_PGTABLE_H */


