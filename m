Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbXLTBJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbXLTBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXLTBIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:08:30 -0500
Received: from 225.sub-75-208-182.myvzw.com ([75.208.182.225]:53528 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753141AbXLTBI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:08:28 -0500
X-Greylist: delayed 2657 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2007 20:08:23 EST
Message-Id: <20071219223604.673695744@goop.org>
References: <20071219223534.129042140@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 14:35:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH 4/5] x86: use a uniform structure for pte_t
Content-Disposition: inline; filename=x86-use-pte-union.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pte_t have the same basic structure for all pagetable formats so
that it can be accessed in a uniform way.

This allows a number of follow-on opportunities for sharing code.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
---
 arch/x86/kernel/efi_64.c              |    2 
 arch/x86/kernel/vmi_32.c              |   10 -
 arch/x86/mach-voyager/voyager_basic.c |    1 
 arch/x86/xen/mmu.c                    |    4 
 include/asm-x86/page.h                |   56 ++++------
 include/asm-x86/paravirt.h            |  157 +++++++++++++++++------------
 include/asm-x86/pgtable-2level.h      |   33 +++---
 include/asm-x86/pgtable-3level.h      |   17 +--
 include/asm-x86/pgtable.h             |  177 +++++++++++++++++++++++++++------
 include/asm-x86/pgtable_32.h          |   55 ----------
 include/asm-x86/pgtable_64.h          |   52 ++-------
 include/asm-x86/tlbflush.h            |    1 
 include/xen/page.h                    |    4 
 13 files changed, 313 insertions(+), 256 deletions(-)

===================================================================
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -91,7 +91,7 @@ void __init efi_call_phys_prelog(void)
 	local_irq_save(efi_flags);
 	early_runtime_code_mapping_set_exec(1);
 	vaddress = (unsigned long)__va(0x0UL);
-	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
+	save_pgd = *pgd_offset_k(0x0UL);
 	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
 	__flush_tlb_all();
 }
===================================================================
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -475,10 +475,10 @@ static void vmi_set_pmd(pmd_t *pmdp, pmd
 static void vmi_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 #ifdef CONFIG_X86_PAE
-	const pte_t pte = { pmdval.pmd, pmdval.pmd >> 32 };
+	const pte_t pte = { .pte = pmdval.pmd };
 	vmi_check_page_type(__pa(pmdp) >> PAGE_SHIFT, VMI_PAGE_PMD);
 #else
-	const pte_t pte = { pmdval.pud.pgd.pgd };
+	const pte_t pte = { .pte = pmdval.pud.pgd.pgd };
 	vmi_check_page_type(__pa(pmdp) >> PAGE_SHIFT, VMI_PAGE_PGD);
 #endif
 	vmi_ops.set_pte(pte, (pte_t *)pmdp, VMI_PAGE_PD);
@@ -508,21 +508,21 @@ static void vmi_set_pud(pud_t *pudp, pud
 static void vmi_set_pud(pud_t *pudp, pud_t pudval)
 {
 	/* Um, eww */
-	const pte_t pte = { pudval.pgd.pgd, pudval.pgd.pgd >> 32 };
+	const pte_t pte = { .pte = pudval.pgd.pgd };
 	vmi_check_page_type(__pa(pudp) >> PAGE_SHIFT, VMI_PAGE_PGD);
 	vmi_ops.set_pte(pte, (pte_t *)pudp, VMI_PAGE_PDP);
 }
 
 static void vmi_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	const pte_t pte = { 0 };
+	const pte_t pte = { .pte = 0 };
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
 static void vmi_pmd_clear(pmd_t *pmd)
 {
-	const pte_t pte = { 0 };
+	const pte_t pte = { .pte = 0 };
 	vmi_check_page_type(__pa(pmd) >> PAGE_SHIFT, VMI_PAGE_PMD);
 	vmi_ops.set_pte(pte, (pte_t *)pmd, VMI_PAGE_PD);
 }
===================================================================
--- a/arch/x86/mach-voyager/voyager_basic.c
+++ b/arch/x86/mach-voyager/voyager_basic.c
@@ -25,6 +25,7 @@
 #include <linux/smp.h>
 #include <linux/nodemask.h>
 #include <asm/io.h>
+#include <asm/pgtable.h>
 #include <asm/voyager.h>
 #include <asm/vic.h>
 #include <linux/pm.h>
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -248,7 +248,7 @@ pte_t xen_make_pte(unsigned long long pt
 
 	pte &= ~_PAGE_PCD;
 
-	return (pte_t){ pte, pte >> 32 };
+	return (pte_t){ .pte = pte };
 }
 
 pmd_t xen_make_pmd(unsigned long long pmd)
@@ -299,7 +299,7 @@ pte_t xen_make_pte(unsigned long pte)
 
 	pte &= ~_PAGE_PCD;
 
-	return (pte_t){ pte };
+	return (pte_t){ .pte = pte };
 }
 
 pgd_t xen_make_pgd(unsigned long pgd)
===================================================================
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -82,17 +82,8 @@ typedef u32	pgdval_t;
 typedef u32	pgdval_t;
 typedef u32	pgprotval_t;
 
-typedef struct { unsigned long pte_low; } pte_t, boot_pte_t;
+typedef union { unsigned long pte, pte_low; } pte_t, boot_pte_t;
 
-static inline pteval_t native_pte_val(pte_t pte)
-{
-	return pte.pte_low;
-}
-
-static inline pte_t native_make_pte(pteval_t val)
-{
-	return (pte_t) { val };
-}
 #endif	/* __ASSEMBLY__ */
 
 #else	/* CONFIG_X86_PAE */
@@ -111,17 +102,13 @@ typedef u64	pgdval_t;
 typedef u64	pgdval_t;
 typedef u64	pgprotval_t;
 
-typedef struct { unsigned long pte_low, pte_high; } pte_t;
+typedef union {
+	struct {
+		u32 pte_low, pte_high;
+	};
+	pteval_t pte;
+} pte_t;
 
-static inline pteval_t native_pte_val(pte_t pte)
-{
-	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
-}
-
-static inline pte_t native_make_pte(pteval_t val)
-{
-	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
-}
 #endif	/* __ASSEMBLY__ */
 
 #endif	 /* CONFIG_X86_PAE */
@@ -142,17 +129,12 @@ typedef u64	pgdval_t;
 typedef u64	pgdval_t;
 typedef u64	pgprotval_t;
 
-typedef struct { pteval_t pte; } pte_t;
-
-static inline pteval_t native_pte_val(pte_t pte)
-{
-	return pte.pte;
-}
-
-static inline pte_t native_make_pte(pteval_t pte)
-{
-	return (pte_t){ pte };
-}
+typedef union {
+	struct {
+		u32 pte_low, pte_high;
+	};
+	pteval_t pte;
+} pte_t;
 
 extern unsigned long phys_base;
 extern unsigned long end_pfn;
@@ -246,6 +228,16 @@ static inline pgd_t native_make_pgd(pgdv
 	return (pgd_t) { val };
 }
 
+static inline pteval_t native_pte_val(pte_t pte)
+{
+	return pte.pte;
+}
+
+static inline pte_t native_make_pte(pteval_t val)
+{
+	return (pte_t) { .pte = val };
+}
+
 #if PAGETABLE_LEVELS >= 3
 
 typedef struct { pmdval_t pmd; } pmd_t;
@@ -275,9 +267,11 @@ static inline pudval_t native_pud_val(pu
 }
 #else  /* PAGETABLE_LEVELS == 3 */
 #include <asm-generic/pgtable-nopud.h>
+#define native_pud_val(x)	native_pgd_val((x).pgd)
 #endif	/* PAGETABLE_LEVELS == 4 */
 #else  /* PAGETABLE_LEVELS == 2 */
 #include <asm-generic/pgtable-nopmd.h>
+#define native_pmd_val(x)	native_pud_val((x).pgd)
 #endif	/* PAGETABLE_LEVELS >= 3 */
 #endif	/* __ASSEMBLY__ */
 
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -829,54 +829,16 @@ static inline void pte_update_defer(stru
 }
 
 #ifdef CONFIG_X86_PAE
-static inline pte_t __pte(unsigned long long val)
+static inline pmd_t __pmd(pmdval_t val)
 {
-	unsigned long long ret = PVOP_CALL2(unsigned long long,
-					    pv_mmu_ops.make_pte,
-					    val, val >> 32);
-	return (pte_t) { ret, ret >> 32 };
-}
-
-static inline pmd_t __pmd(unsigned long long val)
-{
-	return (pmd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pmd,
+	return (pmd_t) { PVOP_CALL2(pmdval_t, pv_mmu_ops.make_pmd,
 				    val, val >> 32) };
 }
 
-static inline pgd_t __pgd(unsigned long long val)
+static inline pmdval_t pmd_val(pmd_t x)
 {
-	return (pgd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pgd,
-				    val, val >> 32) };
-}
-
-static inline unsigned long long pte_val(pte_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pte_val,
-			  x.pte_low, x.pte_high);
-}
-
-static inline unsigned long long pmd_val(pmd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pmd_val,
+	return PVOP_CALL2(pmdval_t, pv_mmu_ops.pmd_val,
 			  x.pmd, x.pmd >> 32);
-}
-
-static inline unsigned long long pgd_val(pgd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pgd_val,
-			  x.pgd, x.pgd >> 32);
-}
-
-static inline void set_pte(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pte, ptep, pteval.pte_low, pteval.pte_high);
-}
-
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	/* 5 arg words */
-	pv_mmu_ops.set_pte_at(mm, addr, ptep, pteval);
 }
 
 static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
@@ -892,16 +854,15 @@ static inline void set_pte_present(struc
 	pv_mmu_ops.set_pte_present(mm, addr, ptep, pte);
 }
 
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp,
-		    pmdval.pmd, pmdval.pmd >> 32);
-}
-
 static inline void set_pud(pud_t *pudp, pud_t pudval)
 {
 	PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
 		    pudval.pgd.pgd, pudval.pgd.pgd >> 32);
+}
+
+static inline void pud_clear(pud_t *pudp)
+{
+	/* unused in 32-bit */
 }
 
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
@@ -913,50 +874,120 @@ static inline void pmd_clear(pmd_t *pmdp
 {
 	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
 }
+#endif	/* CONFIG_X86_PAE */
 
-#else  /* !CONFIG_X86_PAE */
+static inline pte_t __pte(pteval_t val)
+{
+	pteval_t ret;
 
-static inline pte_t __pte(unsigned long val)
-{
-	return (pte_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pte, val) };
+	if (sizeof(pteval_t) > sizeof(long))
+		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.make_pte,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.make_pte, val);
+
+	return native_make_pte(ret);
 }
 
-static inline pgd_t __pgd(unsigned long val)
+static inline pteval_t pte_val(pte_t x)
 {
-	return (pgd_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pgd, val) };
+	pteval_t ret, val;
+
+	val = native_pte_val(x);
+
+	if (sizeof(pteval_t) > sizeof(long))
+		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_val,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_val, val);
+
+	return ret;
 }
 
-static inline unsigned long pte_val(pte_t x)
+static inline pgd_t __pgd(pgdval_t val)
 {
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pte_val, x.pte_low);
+	pgdval_t ret;
+
+	if (sizeof(pgdval_t) > sizeof(long))
+		ret = PVOP_CALL2(pgdval_t, pv_mmu_ops.make_pgd,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pgdval_t, pv_mmu_ops.make_pgd,
+				 val);
+
+	return native_make_pgd(ret);
 }
 
-static inline unsigned long pgd_val(pgd_t x)
+static inline pgdval_t pgd_val(pgd_t x)
 {
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pgd_val, x.pgd);
+	pgdval_t ret;
+
+	if (sizeof(pgdval_t) > sizeof(long))
+		ret = PVOP_CALL2(pgdval_t, pv_mmu_ops.pgd_val,
+				 x.pgd, (u64)x.pgd >> 32);
+	else
+		ret = PVOP_CALL1(pgdval_t, pv_mmu_ops.pgd_val,
+				 x.pgd);
+
+	return ret;
 }
 
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
-	PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, pteval.pte_low);
+	pteval_t val = native_pte_val(pteval);
+
+	if (sizeof(val) > sizeof(long))
+		PVOP_VCALL3(pv_mmu_ops.set_pte, ptep, val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, val);
 }
 
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pteval)
 {
-	PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pteval.pte_low);
+	pteval_t val = native_pte_val(pteval);
+
+	if (sizeof(val) > sizeof(long))
+		/* 5 arg words */
+		pv_mmu_ops.set_pte_at(mm, addr, ptep, pteval);
+	else
+		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, val);
 }
 
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	pmdval_t val = pmd_val(pmdval);
+
+	if (sizeof(val) > sizeof(long))
+		PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp, val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, val);
+}
+
+#ifndef CONFIG_X86_PAE
+static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
+{
+	set_pte(ptep, pteval);
+}
+
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	set_pte_at(mm, addr, ptep, pte);
+}
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep)
 {
 	set_pte_at(mm, addr, ptep, __pte(0));
 }
 
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+static inline void pmd_clear(pmd_t *pmdp)
 {
-	PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, pmdval.pud.pgd.pgd);
+	set_pmd(pmdp, __pmd(0));
 }
 #endif	/* CONFIG_X86_PAE */
+
 
 /* Lazy mode for batching updates / context switch */
 enum paravirt_lazy_mode {
===================================================================
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -27,37 +27,40 @@ static inline void native_set_pmd(pmd_t 
 	*pmdp = pmd;
 }
 
-#undef set_pte_atomic
-static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
+static inline void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
-	set_pte(ptep, pteval);
+	native_set_pte(ptep, pteval);
 }
 
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pteval)
+static inline void native_set_pte_present(struct mm_struct *mm, unsigned long addr,
+					  pte_t *ptep, pte_t pteval)
 {
-	set_pte_at(mm, addr, ptep, pteval);
+	native_set_pte_at(mm, addr, ptep, pteval);
 }
 
 static inline void native_pte_clear(struct mm_struct *mm,
 				    unsigned long addr, pte_t *ptep)
 {
-	set_pte_at(mm, addr, ptep, __pte(0));
+	native_set_pte_at(mm, addr, ptep, __pte(0));
 }
 
-#undef pmd_clear
-static inline void pmd_clear(pmd_t *pmdp)
+static inline void native_pmd_clear(pmd_t *pmdp)
 {
-	set_pmd(pmdp, __pmd(0));
+	native_set_pmd(pmdp, __pmd(0));
 }
 
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
+	pte_t ret;
+
 #ifdef CONFIG_SMP
-	return __pte(xchg(&xp->pte_low, 0));
+	ret = __pte(xchg(&xp->pte_low, 0));
 #else
-	return native_local_ptep_get_and_clear(xp);
+	ret = *xp;
+	native_pte_clear(NULL, 0, xp);
 #endif
+
+	return ret;
 }
 
 /*
@@ -80,14 +83,14 @@ static inline int pte_exec_kernel(pte_t 
 	((((pte).pte_low >> 1) & 0x1f ) + (((pte).pte_low >> 8) << 5 ))
 
 #define pgoff_to_pte(off) \
-	((pte_t) { (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
+	((pte_t) { .pte = (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
 #define __swp_entry(type, offset)	\
 	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
-#define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
-#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
+#define __pte_to_swp_entry(pte)		((swp_entry_t){.val = native_pte_val(pte)})
+#define __swp_entry_to_pte(x)		(native_make_pte((x).val))
 
 #endif /* _I386_PGTABLE_2LEVEL_H */
===================================================================
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -105,7 +105,7 @@ static inline void native_pmd_clear(pmd_
  * We do not let the generic code free and clear pgd entries due to
  * this erratum.
  */
-static inline void pud_clear(pud_t * pud) { }
+static inline void native_pud_clear(pud_t * pud) { }
 
 #define pud_page(pud)					\
 	((struct page *) __va(pud_val(pud) & PAGE_MASK))
@@ -124,16 +124,11 @@ static inline pte_t native_ptep_get_and_
 	res.pte_high = ptep->pte_high;
 	ptep->pte_high = 0;
 #else
-	res = native_local_ptep_get_and_clear(xp);
+	res = *ptep;
+	native_pte_clear(NULL, 0, ptep);
 #endif
 
 	return res;
-}
-
-#define __HAVE_ARCH_PTE_SAME
-static inline int pte_same(pte_t a, pte_t b)
-{
-	return a.pte_low == b.pte_low && a.pte_high == b.pte_high;
 }
 
 extern unsigned long long __supported_pte_mask;
@@ -144,15 +139,15 @@ extern unsigned long long __supported_pt
  * put the 32 bits of offset into the high part.
  */
 #define pte_to_pgoff(pte) ((pte).pte_high)
-#define pgoff_to_pte(off) ((pte_t) { _PAGE_FILE, (off) })
+#define pgoff_to_pte(off) ((pte_t) { { .pte_low = _PAGE_FILE, .pte_high = (off) } })
 #define PTE_FILE_MAX_BITS       32
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val) & 0x1f)
 #define __swp_offset(x)			((x).val >> 5)
 #define __swp_entry(type, offset)	((swp_entry_t){(type) | (offset) << 5})
-#define __pte_to_swp_entry(pte)		((swp_entry_t){ (pte).pte_high })
-#define __swp_entry_to_pte(x)		((pte_t){ 0, (x).val })
+#define __pte_to_swp_entry(pte)		((swp_entry_t){.val = native_pte_val(pte) >> 32})
+#define __swp_entry_to_pte(x)		(native_make_pte((pteval_t)(x).val << 32))
 
 #define __pmd_free_tlb(tlb, x)		do { } while (0)
 
===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -5,6 +5,9 @@
 #include <asm/page.h>
 
 #ifndef __ASSEMBLY__
+#include <linux/mm_types.h>
+#include <asm/tlbflush.h>
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
@@ -94,43 +97,153 @@ static inline int pte_huge(pte_t pte)
 
 #endif	/* __ASSEMBLY__ */
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define set_pte(ptep, pte)			native_set_pte(ptep, pte)
-#define set_pte_at(mm, addr, ptep, pte)		\
-	native_set_pte_at(mm, addr, ptep, pte)
-
-#define set_pte_present(mm, addr, ptep, pte)		\
-	native_set_pte_present(mm, addr, ptep, pte)
-#define set_pte_atomic(ptep, pte)		\
-	native_set_pte_atomic(ptep, pte)
-
-#define set_pmd(pmdp, pmd)			native_set_pmd(pmdp, pmd)
-
-#ifndef __PAGETABLE_PUD_FOLDED
-#define set_pgd(pgdp, pgd)			native_set_pgd(pgdp, pgd)
-#define set_pud(pudp, pud)			native_set_pud(pudp, pud)
-#define pgd_clear(pgd)				native_pgd_clear(pgd)
-#endif
-
-#ifndef __PAGETABLE_PMD_FOLDED
-#define pud_clear(pud)				native_pud_clear(pud)
-#endif
-
-#define pte_clear(mm, addr, ptep)		native_pte_clear(mm, addr, ptep)
-#define pmd_clear(pmd)				native_pmd_clear(pmd)
-
-#define pte_update(mm, addr, ptep)              do { } while (0)
-#define pte_update_defer(mm, addr, ptep)        do { } while (0)
-
-#endif	/* CONFIG_PARAVIRT */
-
 #ifdef CONFIG_X86_32
 # include "pgtable_32.h"
 #else
 # include "pgtable_64.h"
 #endif
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else  /* !CONFIG_PARAVIRT */
+
+static inline void set_pte(pte_t *ptep, pte_t pte)
+{
+	native_set_pte(ptep, pte);
+}
+
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pte)
+{
+	native_set_pte_at(mm, addr, ptep, pte);
+}
+
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	native_set_pte_present(mm, addr, ptep, pte);
+}
+
+static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	native_set_pte_atomic(ptep, pte);
+}
+
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	native_set_pmd(pmdp, pmd);
+}
+
+#ifndef __PAGETABLE_PUD_FOLDED
+static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
+{
+	native_set_pgd(pgdp, pgd);
+}
+
+static inline void pgd_clear(pgd_t *pgdp)
+{
+	native_pgd_clear(pgdp);
+}
+#endif	/* PUD_FOLDED */
+
+#ifndef __PAGETABLE_PMD_FOLDED
+static inline void pud_clear(pud_t *pudp)
+{
+	native_pud_clear(pudp);
+}
+
+static inline void set_pud(pud_t *pudp, pud_t pud)
+{
+	native_set_pud(pudp, pud);
+}
+#endif	/* PMD_FOLDED */
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	native_pte_clear(mm, addr, ptep);
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	native_pmd_clear(pmdp);
+}
+
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
+static inline void pte_update(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+}
+
+static inline void pte_update_defer(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep)
+{
+}
+#endif	/* CONFIG_PARAVIRT */
+
+#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep)
+{
+	int ret = 0;
+
+	if (pte_young(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, (unsigned long *)&ptep->pte);
+	if (ret)
+		pte_update(vma->vm_mm, addr, ptep);
+
+	return ret;
+}
+
+#define __HAVE_ARCH_PTE_SAME
+static inline int pte_same(pte_t a, pte_t b)
+{
+	return a.pte == b.pte;
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
+static inline int ptep_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address,
+					pte_t *ptep, pte_t entry, int dirty)
+{
+	int changed = !pte_same(*ptep, entry);
+
+	if (changed && dirty) {
+		set_pte(ptep, entry);
+		pte_update_defer(vma->vm_mm, address, ptep);
+		flush_tlb_page(vma, address);
+	}
+	return changed;
+}
+
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
+	pte_update(mm, addr, ptep);
+}
+
+#endif	/* __ASSEMBLY__ */
+
 
 #ifndef __PAGETABLE_PUD_FOLDED
 #define PUD_SIZE	(_AC(1,UL) << PUD_SHIFT)
===================================================================
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -84,24 +84,6 @@ extern unsigned long pg0[];
 # include <asm/pgtable-2level.h>
 #endif
 
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
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
 {
@@ -112,36 +94,6 @@ static inline pte_t native_local_ptep_ge
 	return res;
 }
 
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
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young(vma, address, ptep)			\
 ({									\
@@ -151,13 +103,6 @@ static inline pte_t native_local_ptep_ge
 		flush_tlb_page(vma, address);				\
 	__young;							\
 })
-
-#define __HAVE_ARCH_PTEP_SET_WRPROTECT
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	clear_bit(_PAGE_BIT_RW, &ptep->pte_low);
-	pte_update(mm, addr, ptep);
-}
 
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
===================================================================
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -135,7 +135,16 @@ static inline void native_pgd_clear(pgd_
 	native_set_pgd(pgd, native_make_pgd(0));
 }
 
-#define pte_same(a, b)		((a).pte == (b).pte)
+static inline void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
+{
+	native_set_pte(ptep, pteval);
+}
+
+static inline void native_set_pte_present(struct mm_struct *mm, unsigned long addr,
+					  pte_t *ptep, pte_t pteval)
+{
+	native_set_pte_at(mm, addr, ptep, pteval);
+}
 
 #define pte_pgprot(a)	(__pgprot((a).pte & ~PHYSICAL_PAGE_MASK))
 
@@ -149,19 +158,6 @@ static inline void native_pgd_clear(pgd_
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
-struct vm_area_struct;
-
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	if (!pte_young(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_ACCESSED, (unsigned long *)&ptep->pte);
-}
-
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
-}
 
 #ifndef __ASSEMBLY__
 /*
@@ -205,8 +201,8 @@ static inline void ptep_set_wrprotect(st
 			pmd_index(address))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
 
-#define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
-#define pgoff_to_pte(off) ((pte_t) { ((off) << PAGE_SHIFT) | _PAGE_FILE })
+#define pte_to_pgoff(pte) ((native_pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
+#define pgoff_to_pte(off) native_make_pte(((off) << PAGE_SHIFT) | _PAGE_FILE)
 #define PTE_FILE_MAX_BITS __PHYSICAL_MASK_SHIFT
 
 /* PTE - Level 1 access. */
@@ -219,29 +215,13 @@ static inline void ptep_set_wrprotect(st
 
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
 #define __swp_entry(type, offset)	\
 	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
-#define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
-#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
+#define __pte_to_swp_entry(pte)		((swp_entry_t) { .val = native_pte_val(pte) })
+#define __swp_entry_to_pte(x)		(native_make_pte((x).val))
 
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
@@ -267,10 +247,6 @@ pte_t *lookup_address(unsigned long addr
 #define	kc_offset_to_vaddr(o) \
    (((o) & (1UL << (__VIRTUAL_MASK_SHIFT-1))) ? ((o) | (~__VIRTUAL_MASK)) : (o))
 
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_SET_WRPROTECT
-#define __HAVE_ARCH_PTE_SAME
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _X86_64_PGTABLE_H */
===================================================================
--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_TLBFLUSH_H
 #define _ASM_X86_TLBFLUSH_H
 
-#include <linux/mm.h>
 #include <linux/sched.h>
 
 #include <asm/processor.h>
===================================================================
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -156,11 +156,11 @@ static inline pte_t mfn_pte(unsigned lon
 
 static inline unsigned long long pte_val_ma(pte_t x)
 {
-	return ((unsigned long long)x.pte_high << 32) | x.pte_low;
+	return x.pte;
 }
 #define pmd_val_ma(v) ((v).pmd)
 #define pud_val_ma(v) ((v).pgd.pgd)
-#define __pte_ma(x)	((pte_t) { .pte_low = (x), .pte_high = (x)>>32 } )
+#define __pte_ma(x)	((pte_t) { .pte = (x) })
 #define __pmd_ma(x)	((pmd_t) { (x) } )
 #else  /* !X86_PAE */
 #define pte_mfn(_pte) ((_pte).pte_low >> PAGE_SHIFT)

-- 

