Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYAHWSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYAHWSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYAHWPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:40 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47854
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752093AbYAHWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:34 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 10] x86: unify paravirt pagetable accessors
X-Mercurial-Node: a51860f4c83d96cc4800df7f20d7fcff0817027e
Message-Id: <a51860f4c83d96cc4800.1199829612@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put all the defines for mapping pagetable operations to their native
versions (for the non-paravirt case) into one place.  Make the
corresponding changes to paravirt.h.

The tricky part here is that when a pagetable entry can't be updated
atomically (ie, 32-bit PAE), we need special handlers for pte_clear,
set_pte_atomic and set_pte_present.  However, the other two modes
don't need special handling for these, and can use a common
set_pte(_at) path.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/paravirt.h       |   21 ++++++++++
 include/asm-x86/pgtable-2level.h |   30 ++++++++-------
 include/asm-x86/pgtable-3level.h |   15 -------
 include/asm-x86/pgtable.h        |   60 +++++++++++++++++++++++-------
 include/asm-x86/pgtable_64.h     |   76 ++++++++++++++++++++------------------
 5 files changed, 124 insertions(+), 78 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1039,6 +1039,27 @@ static inline void set_pmd(pmd_t *pmdp, 
 {
 	PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, pmdval.pud.pgd.pgd);
 }
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	set_pmd(pmdp, __pmd(0));
+}
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	set_pte_at(mm, addr, ptep, __pte(0));
+}
+
+static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	set_pte(ptep, pte);
+}
+
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	set_pte(ptep, pte);
+}
 #endif	/* CONFIG_X86_PAE */
 
 /* Lazy mode for batching updates / context switch */
diff --git a/include/asm-x86/pgtable-2level.h b/include/asm-x86/pgtable-2level.h
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -15,29 +15,31 @@ static inline void native_set_pte(pte_t 
 {
 	*ptep = pte;
 }
-static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
-				     pte_t *ptep , pte_t pte)
-{
-	native_set_pte(ptep, pte);
-}
+
 static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
 	*pmdp = pmd;
 }
-#ifndef CONFIG_PARAVIRT
-#define set_pte(pteptr, pteval)		native_set_pte(pteptr, pteval)
-#define set_pte_at(mm,addr,ptep,pteval) native_set_pte_at(mm, addr, ptep, pteval)
-#define set_pmd(pmdptr, pmdval)		native_set_pmd(pmdptr, pmdval)
-#endif
 
-#define set_pte_atomic(pteptr, pteval) set_pte(pteptr,pteval)
-#define set_pte_present(mm,addr,ptep,pteval) set_pte_at(mm,addr,ptep,pteval)
+static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	native_set_pte(ptep, pte);
+}
 
-#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
+static inline void native_set_pte_present(struct mm_struct *mm, unsigned long addr,
+					  pte_t *ptep, pte_t pte)
+{
+	native_set_pte(ptep, pte);
+}
+
+static inline void native_pmd_clear(pmd_t *pmdp)
+{
+	native_set_pmd(pmdp, __pmd(0));
+}
 
 static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
 {
-	*xp = __pte(0);
+	*xp = native_make_pte(0);
 }
 
 #ifdef CONFIG_SMP
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -38,11 +38,6 @@ static inline void native_set_pte(pte_t 
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
-}
-static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
-				     pte_t *ptep , pte_t pte)
-{
-	native_set_pte(ptep, pte);
 }
 
 /*
@@ -93,16 +88,6 @@ static inline void native_pmd_clear(pmd_
 	smp_wmb();
 	*(tmp + 1) = 0;
 }
-
-#ifndef CONFIG_PARAVIRT
-#define set_pte(ptep, pte)			native_set_pte(ptep, pte)
-#define set_pte_at(mm, addr, ptep, pte)		native_set_pte_at(mm, addr, ptep, pte)
-#define set_pte_present(mm, addr, ptep, pte)	native_set_pte_present(mm, addr, ptep, pte)
-#define set_pte_atomic(ptep, pte)		native_set_pte_atomic(ptep, pte)
-#define set_pmd(pmdp, pmd)			native_set_pmd(pmdp, pmd)
-#define set_pud(pudp, pud)			native_set_pud(pudp, pud)
-#define pmd_clear(pmd)				native_pmd_clear(pmd)
-#endif
 
 /*
  * Pentium-II erratum A13: in PAE mode we explicitly have to flush
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -175,6 +175,36 @@ static inline pte_t pte_modify(pte_t pte
 	return __pte(val);
 }
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else  /* !CONFIG_PARAVIRT */
+#define set_pte(ptep, pte)		native_set_pte(ptep, pte)
+#define set_pte_at(mm, addr, ptep, pte)	native_set_pte_at(mm, addr, ptep, pte)
+
+#define set_pte_present(mm, addr, ptep, pte)				\
+	native_set_pte_present(mm, addr, ptep, pte)
+#define set_pte_atomic(ptep, pte)					\
+	native_set_pte_atomic(ptep, pte)
+
+#define set_pmd(pmdp, pmd)		native_set_pmd(pmdp, pmd)
+
+#ifndef __PAGETABLE_PUD_FOLDED
+#define set_pgd(pgdp, pgd)		native_set_pgd(pgdp, pgd)
+#define set_pud(pudp, pud)		native_set_pud(pudp, pud)
+#define pgd_clear(pgd)			native_pgd_clear(pgd)
+#endif
+
+#ifndef __PAGETABLE_PMD_FOLDED
+#define pud_clear(pud)			native_pud_clear(pud)
+#endif
+
+#define pte_clear(mm, addr, ptep)	native_pte_clear(mm, addr, ptep)
+#define pmd_clear(pmd)			native_pmd_clear(pmd)
+
+#define pte_update(mm, addr, ptep)              do { } while (0)
+#define pte_update_defer(mm, addr, ptep)        do { } while (0)
+#endif	/* CONFIG_PARAVIRT */
+
 #endif	/* __ASSEMBLER__ */
 
 #ifdef CONFIG_X86_32
@@ -184,6 +214,22 @@ static inline pte_t pte_modify(pte_t pte
 #endif
 
 #ifndef __ASSEMBLER__
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
+static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
+				     pte_t *ptep , pte_t pte)
+{
+	native_set_pte(ptep, pte);
+}
 
 #ifndef CONFIG_PARAVIRT
 /*
@@ -202,16 +248,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
 #endif
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
 
 /*
  * We only update the dirty/accessed state if we set
@@ -284,10 +320,6 @@ static inline void ptep_set_wrprotect(st
 	pte_update(mm, addr, ptep);
 }
 
-#ifndef CONFIG_PARAVIRT
-#define pte_clear(mm, addr, ptep)		native_pte_clear(mm, addr, ptep)
-#endif	/* !CONFIG_PARAVIRT */
-
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLER__ */
 
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -63,51 +63,59 @@ extern void clear_kernel_mapping(unsigne
 #define pgd_none(x)	(!pgd_val(x))
 #define pud_none(x)	(!pud_val(x))
 
-static inline void set_pte(pte_t *dst, pte_t val)
+struct mm_struct;
+
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep)
 {
-	*dst = val;
-} 
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
-
-static inline void set_pmd(pmd_t *dst, pmd_t val)
-{
-	*dst = val;
-} 
-
-static inline void set_pud(pud_t *dst, pud_t val)
-{
-	*dst = val;
+	*ptep = native_make_pte(0);
 }
 
-static inline void pud_clear (pud_t *pud)
+static inline void native_set_pte(pte_t *ptep, pte_t pte)
 {
-	set_pud(pud, __pud(0));
+	*ptep = pte;
 }
 
-static inline void set_pgd(pgd_t *dst, pgd_t val)
+static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
-	*dst = val;
-} 
-
-static inline void pgd_clear (pgd_t * pgd)
-{
-	set_pgd(pgd, __pgd(0));
+#ifdef CONFIG_SMP
+	return native_make_pte(xchg(&xp->pte, 0));
+#else
+	/* native_local_ptep_get_and_clear, but duplicated because of cyclic dependency */
+	pte_t ret = *xp;
+	native_pte_clear(NULL, 0, xp);
+	return ret;
+#endif
 }
 
-#define native_ptep_get_and_clear(xp) __pte(xchg(&(xp)->pte, 0))
+static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	*pmdp = pmd;
+}
 
-struct mm_struct;
+static inline void native_pmd_clear(pmd_t *pmd)
+{
+	native_set_pmd(pmd, native_make_pmd(0));
+}
 
-static inline pte_t native_ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
+static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
-	pte_t pte;
-	if (full) {
-		pte = *ptep;
-		*ptep = __pte(0);
-	} else {
-		pte = native_ptep_get_and_clear(ptep);
-	}
-	return pte;
+	*pudp = pud;
+}
+
+static inline void native_pud_clear(pud_t *pud)
+{
+	native_set_pud(pud, native_make_pud(0));
+}
+
+static inline void native_set_pgd(pgd_t *pgdp, pgd_t pgd)
+{
+	*pgdp = pgd;
+}
+
+static inline void native_pgd_clear(pgd_t * pgd)
+{
+	native_set_pgd(pgd, native_make_pgd(0));
 }
 
 #define pte_same(a, b)		((a).pte == (b).pte)
@@ -151,7 +159,6 @@ static inline unsigned long pmd_bad(pmd_
 
 #define pte_none(x)	(!pte_val(x))
 #define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
-#define native_pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this right? */
 #define pte_page(x)	pfn_to_page(pte_pfn(x))
@@ -196,7 +203,6 @@ static inline unsigned long pmd_bad(pmd_
 			pmd_index(address))
 #define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
 #define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 


