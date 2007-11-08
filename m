Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbXKHCee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbXKHCee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbXKHCdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:33:39 -0500
Received: from gw.goop.org ([64.81.55.164]:57057 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbXKHCdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:33:37 -0500
Message-Id: <20071108015310.467868276@goop.org>
References: <20071108015008.660012621@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Nov 2007 17:50:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Zach Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH RFC 5/7] x86: simplify pagetable-related operationsin paravirt.h
Content-Disposition: inline; filename=x86-simplify-paravirt_h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify paravirt.h using the unified page/pgtable.h infrastructure.
This removes a fair amount of duplication of the ops function pointers
themselves, but also of PVOP_*CALL* wrappers.

The wrappers are complicated by the fact that on a 32-bit PAE system,
literal 64-bit values are passed in two arguments, and so a different
form of the call must be used compared to 64-bit or 32-bit non-PAE,
where all the arguments are less than or equal to the native register
size.

The code chooses the appropriate form to use by using the compile-time
comparison of sizeof(pteval_t) and sizeof(unsigned long).  This does
not need to be done for calls which are either PAE or 64-bit specific.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 include/asm-x86/paravirt.h |  324 +++++++++++++++++++-------------------------
 1 file changed, 141 insertions(+), 183 deletions(-)

===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -240,40 +240,38 @@ struct pv_mmu_ops {
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
 
+	pteval_t (*pte_val)(pte_t);
+	pgdval_t (*pgd_val)(pgd_t);
+
+	pte_t (*make_pte)(pteval_t pte);
+	pgd_t (*make_pgd)(pgdval_t pgd);
+
+#if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
 	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
 #endif
-#if defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
-	void (*set_pud)(pud_t *pudp, pud_t pudval);
+
 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
 
-	unsigned long long (*pte_val)(pte_t);
-	unsigned long long (*pmd_val)(pmd_t);
-	unsigned long long (*pgd_val)(pgd_t);
+	pmdval_t (*pmd_val)(pmd_t);
+	pmd_t (*make_pmd)(pmdval_t pmd);
 
-	pte_t (*make_pte)(unsigned long long pte);
-	pmd_t (*make_pmd)(unsigned long long pmd);
-	pgd_t (*make_pgd)(unsigned long long pgd);
-  #ifdef CONFIG_X86_64
+	void (*set_pud)(pud_t *pudp, pud_t pudval);
+
+#if PAGETABLE_LEVELS == 4
 	void (*set_pgd)(pgd_t *pgdp, pgd_t pgdval);
 
 	void (*pud_clear)(pud_t *pudp);
 	void (*pgd_clear)(pgd_t *pgdp);
 
-	unsigned long long (*pud_val)(pud_t);
+	pudval_t (*pud_val)(pud_t);
 
-	pud_t (*make_pud)(unsigned long long pud);
-  #endif
-#else
-	unsigned long (*pte_val)(pte_t);
-	unsigned long (*pgd_val)(pgd_t);
-
-	pte_t (*make_pte)(unsigned long pte);
-	pgd_t (*make_pgd)(unsigned long pgd);
-#endif
+	pud_t (*make_pud)(pudval_t pud);
+#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* PAGETABLE_LEVELS >= 3 */
 
 #ifdef CONFIG_HIGHPTE
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
@@ -958,85 +956,137 @@ static inline void pte_update_defer(stru
 	PVOP_VCALL3(pv_mmu_ops.pte_update_defer, mm, addr, ptep);
 }
 
-#ifdef CONFIG_X86_PAE
-static inline pte_t __pte(unsigned long long val)
+/*
+ * Pagetable manipulators
+ *
+ * There are three cases to deal with:
+ * 32-bit processor, non-PAE:	2-level pagetable with 32-bit entries
+ * 32-bit processor, PAE:	3-level pagetable with 64-bit entries
+ * 64-bit processor:		4-level pagetable with 64-bit entries
+ *
+ * In 32-bit mode, passing 64-bit parameters must be done in two
+ * 32-bit chunks, so we need to use a separate PVOP_CALLx macro from
+ * either 64-bit mode or 32-bit/non-PAE.
+ *
+ * We rely on the predefined native_make_X/native_X_val to do
+ * packing/unpacking of the current pagetable type.
+ */
+static inline pte_t __pte(pteval_t val)
 {
-	unsigned long long ret = PVOP_CALL2(unsigned long long,
-					    pv_mmu_ops.make_pte,
-					    val, val >> 32);
-	return (pte_t) { ret, ret >> 32 };
+	pteval_t ret;
+
+	if (sizeof(val) > sizeof(unsigned long))
+		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.make_pte,
+				 val, (u64)val>>32);
+	else
+		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.make_pte, val);
+
+	return native_make_pte(ret);
 }
 
-static inline pmd_t __pmd(unsigned long long val)
+static inline pteval_t pte_val(pte_t x)
 {
-	return (pmd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pmd,
-				    val, val >> 32) };
+	pteval_t val = native_pte_val(x);
+	if (sizeof(pteval_t) > sizeof(unsigned long))
+		return PVOP_CALL2(pteval_t, pv_mmu_ops.pte_val,
+				  val, (u64)val>>32);
+	else
+		return PVOP_CALL1(pteval_t, pv_mmu_ops.pte_val, val);
 }
 
-static inline pgd_t __pgd(unsigned long long val)
+static inline pgd_t __pgd(pgdval_t val)
 {
-	return (pgd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pgd,
-				    val, val >> 32) };
+	pgdval_t pgd;
+
+	if (sizeof(val) > sizeof(unsigned long))
+		pgd = PVOP_CALL2(pgdval_t, pv_mmu_ops.make_pgd,
+				 val, (u64)val>>32);
+	else
+		pgd = PVOP_CALL1(pgdval_t, pv_mmu_ops.make_pgd, val);
+
+	return native_make_pgd(pgd);
 }
 
-static inline unsigned long long pte_val(pte_t x)
+static inline pgdval_t pgd_val(pgd_t x)
 {
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pte_val,
-			  x.pte_low, x.pte_high);
-}
-
-static inline unsigned long long pmd_val(pmd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pmd_val,
-			  x.pmd, x.pmd >> 32);
-}
-
-static inline unsigned long long pgd_val(pgd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pgd_val,
-			  x.pgd, x.pgd >> 32);
+	pgdval_t val = native_pgd_val(x);
+	if (sizeof(pgdval_t) > sizeof(unsigned long))
+		return PVOP_CALL2(pgdval_t, pv_mmu_ops.pgd_val,
+				  val, (u64)val>>32);
+	else
+		return PVOP_CALL1(pgdval_t, pv_mmu_ops.pgd_val, val);
 }
 
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
-	PVOP_VCALL3(pv_mmu_ops.set_pte, ptep, pteval.pte_low, pteval.pte_high);
+	pteval_t val = native_pte_val(pteval);
+	if (sizeof(pteval_t) > sizeof(unsigned long))
+		PVOP_VCALL3(pv_mmu_ops.set_pte, ptep, val, (u64)val>>32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, val);
 }
 
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pteval)
 {
-	/* 5 arg words */
-	pv_mmu_ops.set_pte_at(mm, addr, ptep, pteval);
+	if (sizeof(pteval_t) > sizeof(unsigned long))
+		pv_mmu_ops.set_pte_at(mm, addr, ptep, pteval);
+	else
+		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr,
+			    ptep, native_pte_val(pteval));
+}
+
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	pmdval_t val = native_pmd_val(pmdval);
+	if (sizeof(val) > sizeof(unsigned long))
+		PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp, val, (u64)val>>32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, val);
+}
+
+#if PAGETABLE_LEVELS >= 3
+#ifdef CONFIG_X86_PAE
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	pv_mmu_ops.set_pte_present(mm, addr, ptep, pte);
 }
 
 static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
-	PVOP_VCALL3(pv_mmu_ops.set_pte_atomic, ptep,
-		    pteval.pte_low, pteval.pte_high);
+	pteval_t val = native_pte_val(pteval);
+
+	PVOP_VCALL3(pv_mmu_ops.set_pte_atomic, ptep, val, (u64)val>>32);
 }
-
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
-{
-	/* 5 arg words */
-	pv_mmu_ops.set_pte_present(mm, addr, ptep, pte);
-}
-
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp,
-		    pmdval.pmd, pmdval.pmd >> 32);
-}
-
-static inline void set_pud(pud_t *pudp, pud_t pudval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
-		    pudval.pgd.pgd, pudval.pgd.pgd >> 32);
-}
+#endif	/* X86_PAE */
 
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
+}
+
+static inline pmd_t __pmd(pmdval_t val)
+{
+	pmdval_t pmd;
+
+	if (sizeof(val) > sizeof(unsigned long))
+		pmd = PVOP_CALL2(pmdval_t, pv_mmu_ops.make_pmd,
+				 val, (u64)val>>32);
+	else
+		pmd = PVOP_CALL1(pmdval_t, pv_mmu_ops.make_pmd, val);
+
+	return native_make_pmd(pmd);
+}
+
+static inline pmdval_t pmd_val(pmd_t x)
+{
+	pmdval_t val = native_pmd_val(x);
+	if (sizeof(val) > sizeof(unsigned long))
+		return PVOP_CALL2(pmdval_t, pv_mmu_ops.pmd_val,
+				  val, (u64)val>>32);
+	else
+		return PVOP_CALL1(pmdval_t, pv_mmu_ops.pmd_val, val);
 }
 
 static inline void pmd_clear(pmd_t *pmdp)
@@ -1044,95 +1094,25 @@ static inline void pmd_clear(pmd_t *pmdp
 	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
 }
 
-#elif defined(CONFIG_X86_64)
-/* FIXME: There ought to be a way to do it that duplicate less code */
-static inline pte_t __pte(unsigned long long val)
+static inline void set_pud(pud_t *pudp, pud_t pudval)
 {
-	unsigned long long ret;
-	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pte, val);
-	return (pte_t) { ret };
+	pudval_t val = native_pud_val(pudval);
+
+	if (sizeof(val) > sizeof(unsigned long))
+		PVOP_VCALL3(pv_mmu_ops.set_pud, pudp, val, (u64)val>>32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pud, pudp, val);
 }
 
-static inline pmd_t __pmd(unsigned long long val)
-{
-	unsigned long long ret;
-	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pmd, val);
-	return (pmd_t) { ret };
-}
-
-static inline pud_t __pud(unsigned long long val)
-{
-	unsigned long long ret;
-	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pud, val);
-	return (pud_t) { ret };
-}
-
-static inline pgd_t __pgd(unsigned long long val)
-{
-	unsigned long long ret;
-	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pgd, val);
-	return (pgd_t) { ret };
-}
-
-static inline unsigned long long pte_val(pte_t x)
-{
-	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pte_val, x.pte);
-}
-
-static inline unsigned long long pmd_val(pmd_t x)
-{
-	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pmd_val, x.pmd);
-}
-
-static inline unsigned long long pud_val(pud_t x)
-{
-	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pud_val, x.pud);
-}
-
-static inline unsigned long long pgd_val(pgd_t x)
-{
-	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pgd_val, x.pgd);
-}
-
-static inline void set_pte(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, pteval.pte);
-}
-
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pteval.pte);
-}
-
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, pmdval.pmd);
-}
-
-static inline void set_pud(pud_t *pudp, pud_t pudval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pud, pudp, pudval.pud);
-}
+#if PAGETABLE_LEVELS == 4
+/* Always 64-bit processor, so param passing needs no special handling */
+#ifdef CONFIG_X86_32
+#error 4 level pagetables in 32-bit mode?!
+#endif
 
 static inline void set_pgd(pgd_t *pgdp, pgd_t pgdval)
 {
-	PVOP_VCALL2(pv_mmu_ops.set_pgd, pgdp, pgdval.pgd);
-}
-
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
-}
-
-static inline void pmd_clear(pmd_t *pmdp)
-{
-	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
-}
-
-static inline void pud_clear(pud_t *pudp)
-{
-	PVOP_VCALL1(pv_mmu_ops.pud_clear, pudp);
+	PVOP_VCALL2(pv_mmu_ops.set_pgd, pgdp, native_pgd_val(pgdval));
 }
 
 static inline void pgd_clear(pgd_t *pgdp)
@@ -1140,44 +1120,22 @@ static inline void pgd_clear(pgd_t *pgdp
 	PVOP_VCALL1(pv_mmu_ops.pgd_clear, pgdp);
 }
 
-#else  /* !CONFIG_X86_PAE && !CONFIG_X86_64*/
-
-static inline pte_t __pte(unsigned long val)
+static inline pud_t __pud(pudval_t val)
 {
-	return (pte_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pte, val) };
+	return native_make_pud(PVOP_CALL1(pudval_t, pv_mmu_ops.make_pud, val));
 }
 
-static inline pgd_t __pgd(unsigned long val)
+static inline pudval_t pud_val(pud_t x)
 {
-	return (pgd_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pgd, val) };
+	return PVOP_CALL1(pudval_t, pv_mmu_ops.pud_val, native_pud_val(x));
 }
 
-static inline unsigned long pte_val(pte_t x)
+static inline void pud_clear(pud_t *pudp)
 {
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pte_val, x.pte_low);
+	PVOP_VCALL1(pv_mmu_ops.pud_clear, pudp);
 }
-
-static inline unsigned long pgd_val(pgd_t x)
-{
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pgd_val, x.pgd);
-}
-
-static inline void set_pte(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, pteval.pte_low);
-}
-
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pteval.pte_low);
-}
-
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, pmdval.pud.pgd.pgd);
-}
-#endif	/* CONFIG_X86_PAE */
+#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* PAGETABLE_LEVELS >= 3 */
 
 /* Lazy mode for batching updates / context switch */
 enum paravirt_lazy_mode {

-- 

