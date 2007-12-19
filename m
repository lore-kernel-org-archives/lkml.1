Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbXLTBJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbXLTBJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXLTBId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:08:33 -0500
Received: from 225.sub-75-208-182.myvzw.com ([75.208.182.225]:53532 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753622AbXLTBIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:08:31 -0500
Message-Id: <20071219223604.519474386@goop.org>
References: <20071219223534.129042140@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 14:35:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH 2/5] x86: unify pgtable*.h
Content-Disposition: inline; filename=x86-unify-pgtable_h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All x86 modes and architectures have very similar pagetable
structures: the page flags, the accessors for testing/setting them,
and the combinations of page flags used for kernel and usermode
mappings are all the same.  The main difference is between 32 and
64-bit pagetable entries, with the latter supporting the NX bit.

The most significant difference between the modes/architectures is the
number of levels in the pagetable (4 for 64-bit, 3 for 32-bit/PAE, 2
for non-PAE 32-bit).  This accounts for the remaining code in the
various mode-specific headers.

I've tried to avoid changing formatting as much as possible, so that
the code motion is more obvious.  A subsequent patch will clean things
up in place.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 include/asm-x86/pgtable-2level.h |   17 -
 include/asm-x86/pgtable-3level.h |   38 ----
 include/asm-x86/pgtable.h        |  345 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/pgtable_32.h     |  229 -------------------------
 include/asm-x86/pgtable_64.h     |  287 ++++++-------------------------
 5 files changed, 413 insertions(+), 503 deletions(-)

===================================================================
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -15,25 +15,24 @@ static inline void native_set_pte(pte_t 
 {
 	*ptep = pte;
 }
+
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
 				     pte_t *ptep , pte_t pte)
 {
 	native_set_pte(ptep, pte);
 }
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
 
+#undef set_pte_atomic
 #define set_pte_atomic(pteptr, pteval) set_pte(pteptr,pteval)
 #define set_pte_present(mm,addr,ptep,pteval) set_pte_at(mm,addr,ptep,pteval)
 
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+#undef pmd_clear
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
 static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
@@ -50,12 +49,6 @@ static inline pte_t native_ptep_get_and_
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
-#define pte_page(x)		pfn_to_page(pte_pfn(x))
-#define pte_none(x)		(!(x).pte_low)
-#define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
-#define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-
 /*
  * All present pages are kernel-executable:
  */
@@ -63,6 +56,8 @@ static inline int pte_exec_kernel(pte_t 
 {
 	return 1;
 }
+
+#define __supported_pte_mask	(~0ul)
 
 /*
  * Bits 0, 6 and 7 are taken, split up the 29 bits of offset
===================================================================
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -94,17 +94,6 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
-#ifndef CONFIG_PARAVIRT
-#define set_pte(ptep, pte)			native_set_pte(ptep, pte)
-#define set_pte_at(mm, addr, ptep, pte)		native_set_pte_at(mm, addr, ptep, pte)
-#define set_pte_present(mm, addr, ptep, pte)	native_set_pte_present(mm, addr, ptep, pte)
-#define set_pte_atomic(ptep, pte)		native_set_pte_atomic(ptep, pte)
-#define set_pmd(pmdp, pmd)			native_set_pmd(pmdp, pmd)
-#define set_pud(pudp, pud)			native_set_pud(pudp, pud)
-#define pte_clear(mm, addr, ptep)		native_pte_clear(mm, addr, ptep)
-#define pmd_clear(pmd)				native_pmd_clear(pmd)
-#endif
-
 /*
  * Pentium-II erratum A13: in PAE mode we explicitly have to flush
  * the TLB via cr3 if the top-level pgd is changed...
@@ -119,10 +108,6 @@ static inline void pud_clear (pud_t * pu
 #define pud_page_vaddr(pud) \
 ((unsigned long) __va(pud_val(pud) & PAGE_MASK))
 
-
-/* Find an entry in the second-level page table.. */
-#define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
-			pmd_index(address))
 
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
@@ -146,31 +131,8 @@ static inline int pte_same(pte_t a, pte_
 	return a.pte_low == b.pte_low && a.pte_high == b.pte_high;
 }
 
-#define pte_page(x)	pfn_to_page(pte_pfn(x))
-
-static inline int pte_none(pte_t pte)
-{
-	return !pte.pte_low && !pte.pte_high;
-}
-
-static inline unsigned long pte_pfn(pte_t pte)
-{
-	return pte_val(pte) >> PAGE_SHIFT;
-}
-
 extern unsigned long long __supported_pte_mask;
 
-static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
-{
-	return __pte((((unsigned long long)page_nr << PAGE_SHIFT) |
-		      pgprot_val(pgprot)) & __supported_pte_mask);
-}
-
-static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
-{
-	return __pmd((((unsigned long long)page_nr << PAGE_SHIFT) |
-		      pgprot_val(pgprot)) & __supported_pte_mask);
-}
 
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -1,5 +1,350 @@
+#ifndef _ASM_X86_PGTABLE_H
+#define _ASM_X86_PGTABLE_H
+
+#include <linux/const.h>
+#include <asm/page.h>
+
+#ifndef __ASSEMBLY__
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
+#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
+
+void paging_init(void);
+
+#endif /* !__ASSEMBLY__ */
+
+
+/*
+ * _PAGE_PSE set in the page directory entry just means that
+ * the page directory entry points directly to a 4MB-aligned block of
+ * memory.
+ */
+#define _PAGE_BIT_PRESENT	0
+#define _PAGE_BIT_RW		1
+#define _PAGE_BIT_USER		2
+#define _PAGE_BIT_PWT		3
+#define _PAGE_BIT_PCD		4
+#define _PAGE_BIT_ACCESSED	5
+#define _PAGE_BIT_DIRTY		6
+#define _PAGE_BIT_FILE		6
+#define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
+#define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
+#define _PAGE_BIT_UNUSED1	9	/* available for programmer */
+#define _PAGE_BIT_UNUSED2	10
+#define _PAGE_BIT_UNUSED3	11
+#define _PAGE_BIT_NX		63	/* No execute: only valid after cpuid check */
+
+
+#define _PAGE_PRESENT	(_AC(1, UL) << _PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AC(1, UL) << _PAGE_BIT_RW)
+#define _PAGE_USER	(_AC(1, UL) << _PAGE_BIT_USER)
+#define _PAGE_PWT	(_AC(1, UL) << _PAGE_BIT_PWT)
+#define _PAGE_PCD	(_AC(1, UL) << _PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	(_AC(1, UL) << _PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AC(1, UL) << _PAGE_BIT_DIRTY)
+#define _PAGE_PSE	(_AC(1, UL) << _PAGE_BIT_PSE)
+#define _PAGE_GLOBAL	(_AC(1, UL) << _PAGE_BIT_GLOBAL)
+#define _PAGE_UNUSED1	(_AC(1, UL) << _PAGE_BIT_UNUSED1)
+#define _PAGE_UNUSED2	(_AC(1, UL) << _PAGE_BIT_UNUSED2)
+#define _PAGE_UNUSED3	(_AC(1, UL) << _PAGE_BIT_UNUSED3)
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+#define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
+#else
+#define _PAGE_NX	0
+#endif
+
+/* If _PAGE_PRESENT is clear, we use these: */
+#define _PAGE_FILE	_PAGE_DIRTY	/* nonlinear file mapping, saved PTE; unset:swap */
+#define _PAGE_PROTNONE	_PAGE_PSE	/* if the user mapped it with PROT_NONE;
+					   pte_present gives true */
+
+#ifndef __ASSEMBLY__
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
+static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
+
+#endif	/* __ASSEMBLY__ */
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define set_pte(ptep, pte)			native_set_pte(ptep, pte)
+#define set_pte_at(mm, addr, ptep, pte)		\
+	native_set_pte_at(mm, addr, ptep, pte)
+
+#define set_pte_present(mm, addr, ptep, pte)		\
+	native_set_pte_present(mm, addr, ptep, pte)
+#define set_pte_atomic(ptep, pte)		\
+	native_set_pte_atomic(ptep, pte)
+
+#define set_pmd(pmdp, pmd)			native_set_pmd(pmdp, pmd)
+
+#ifndef __PAGETABLE_PUD_FOLDED
+#define set_pgd(pgdp, pgd)			native_set_pgd(pgdp, pgd)
+#define set_pud(pudp, pud)			native_set_pud(pudp, pud)
+#define pgd_clear(pgd)				native_pgd_clear(pgd)
+#endif
+
+#ifndef __PAGETABLE_PMD_FOLDED
+#define pud_clear(pud)				native_pud_clear(pud)
+#endif
+
+#define pte_clear(mm, addr, ptep)		native_pte_clear(mm, addr, ptep)
+#define pmd_clear(pmd)				native_pmd_clear(pmd)
+
+#define pte_update(mm, addr, ptep)              do { } while (0)
+#define pte_update_defer(mm, addr, ptep)        do { } while (0)
+
+#endif	/* CONFIG_PARAVIRT */
+
 #ifdef CONFIG_X86_32
 # include "pgtable_32.h"
 #else
 # include "pgtable_64.h"
 #endif
+
+#ifndef __PAGETABLE_PUD_FOLDED
+#define PUD_SIZE	(_AC(1,UL) << PUD_SHIFT)
+#define PUD_MASK	(~(PUD_SIZE-1))
+#endif
+
+#ifndef __PAGETABLE_PMD_FOLDED
+#define PMD_SIZE	(_AC(1,UL) << PMD_SHIFT)
+#define PMD_MASK	(~(PMD_SIZE-1))
+#endif
+
+#define PGDIR_SIZE	(_AC(1,UL) << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE-1))
+
+#define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
+
+#define FIRST_USER_ADDRESS	0
+
+#define USER_PGD_PTRS (PAGE_OFFSET >> PGDIR_SHIFT)
+#define KERNEL_PGD_PTRS (PTRS_PER_PGD-USER_PGD_PTRS)
+
+#define _PAGE_TABLE	\
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _KERNPG_TABLE	\
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_CHG_MASK	\
+	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+
+#ifndef __ASSEMBLY__
+
+#define PAGE_NONE	\
+	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
+#define PAGE_SHARED	\
+	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
+
+#define PAGE_SHARED_EXEC	\
+	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_COPY_NOEXEC	\
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
+#define PAGE_COPY_EXEC		\
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_COPY		\
+	PAGE_COPY_NOEXEC
+#define PAGE_READONLY		\
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
+#define PAGE_READONLY_EXEC	\
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
+#endif	/* __ASSEMBLY__ */
+
+#define _PAGE_KERNEL		\
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
+#define _PAGE_KERNEL_EXEC	\
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
+
+
+#define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
+#define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
+#define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
+#define __PAGE_KERNEL_VSYSCALL		\
+	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
+#define __PAGE_KERNEL_VSYSCALL_NOCACHE	\
+	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD | _PAGE_PWT)
+
+
+#define PAGE_KERNEL		__pgprot(__PAGE_KERNEL)
+#define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
+#define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_VSYSCALL32	__pgprot(__PAGE_KERNEL_VSYSCALL)
+#define PAGE_KERNEL_VSYSCALL	__pgprot(__PAGE_KERNEL_VSYSCALL)
+#define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
+#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+
+/*
+ * Without NX, the i386 can't do page protection for execute, and
+ * considers that the same are read. Also, write permissions imply
+ * read permissions.  This is the closest we can get..
+ */
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY
+#define __P010	PAGE_COPY
+#define __P011	PAGE_COPY
+#define __P100	PAGE_READONLY_EXEC
+#define __P101	PAGE_READONLY_EXEC
+#define __P110	PAGE_COPY_EXEC
+#define __P111	PAGE_COPY_EXEC
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY
+#define __S010	PAGE_SHARED
+#define __S011	PAGE_SHARED
+#define __S100	PAGE_READONLY_EXEC
+#define __S101	PAGE_READONLY_EXEC
+#define __S110	PAGE_SHARED_EXEC
+#define __S111	PAGE_SHARED_EXEC
+
+#ifndef __ASSEMBLY__
+
+static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
+static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
+static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW)); return pte; }
+static inline pte_t pte_mkexec(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_NX)); return pte; }
+static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
+static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
+static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW)); return pte; }
+static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE)); return pte; }
+static inline pte_t pte_clrhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE)); return pte; }
+
+#ifndef __PAGETABLE_PUD_FOLDED
+static inline bool pgd_bad(pgd_t pgd)
+{
+	return (pgd_val(pgd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+}
+
+static inline bool pud_bad(pud_t pud)
+{
+	return (pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+}
+#endif
+
+static inline bool pmd_bad(pmd_t pmd)
+{
+	return (pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+}
+
+/* Change flags of a PTE */
+static inline pte_t pte_modify(pte_t pte_old, pgprot_t newprot)
+{
+	pteval_t pte = pte_val(pte_old);
+	pte &= _PAGE_CHG_MASK;
+	pte |= pgprot_val(newprot);
+	pte &= __supported_pte_mask;
+	return __pte(pte);
+}
+
+/* page, protection -> pte */
+#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
+
+static inline int pmd_large(pmd_t pte)
+{
+	return (pmd_val(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
+		((_PAGE_PSE | _PAGE_PRESENT));
+}
+
+/* PMD  - Level 2 access */
+#define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PTE_MASK))
+#define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
+
+/*
+ * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
+ *
+ * this macro returns the index of the entry in the pmd page which would
+ * control the given virtual address
+ */
+#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+
+static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
+{
+	return __pmd((((unsigned long long)page_nr << PAGE_SHIFT) |
+		      pgprot_val(pgprot)) & __supported_pte_mask);
+}
+
+#ifndef __PAGETABLE_PMD_FOLDED
+/* Find an entry in the second-level page table.. */
+#define pmd_offset(dir, address)		\
+	((pmd_t *) pud_page_vaddr(*(dir)) + pmd_index(address))
+
+#define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
+
+#endif	/* PAGETABLE_PMD_FOLDED */
+
+/* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
+#define pmd_none(x)	(!(unsigned long)pmd_val(x))
+#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
+
+/*
+ * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ *
+ * this macro returns the index of the entry in the pte page which would
+ * control the given virtual address
+ */
+#define pte_index(address)					\
+	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset_kernel(dir, address)					\
+	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
+
+#define pte_none(x)	(!pte_val(x))
+#define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
+
+#define pages_to_mb(x)	((unsigned long)((x) >> (20-PAGE_SHIFT)))
+#define pte_page(x)	pfn_to_page(pte_pfn(x))
+#define pte_pfn(x)	((unsigned long)((pte_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT))
+
+static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
+{
+	pteval_t pte;
+	pte = (page_nr << PAGE_SHIFT);
+	pte |= pgprot_val(pgprot);
+	pte &= __supported_pte_mask;
+	return __pte(pte);
+}
+
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = native_ptep_get_and_clear(ptep);
+	pte_update(mm, addr, ptep);
+	return pte;
+}
+
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
+
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
+
+#include <asm-generic/pgtable.h>
+
+#endif	/* __ASSEMBLY__ */
+#endif	/* _ASM_X86_PGTABLE_H */
===================================================================
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -25,12 +25,6 @@ struct mm_struct;
 struct mm_struct;
 struct vm_area_struct;
 
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
-extern unsigned long empty_zero_page[1024];
 extern pgd_t swapper_pg_dir[1024];
 extern struct kmem_cache *pmd_cache;
 extern spinlock_t pgd_lock;
@@ -39,8 +33,8 @@ void check_pgt_cache(void);
 
 void pmd_ctor(struct kmem_cache *, void *);
 void pgtable_cache_init(void);
-void paging_init(void);
 
+extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 
 /*
  * The Linux x86 paging architecture is 'compile-time dual-mode', it
@@ -49,20 +43,9 @@ void paging_init(void);
  */
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level-defs.h>
-# define PMD_SIZE	(1UL << PMD_SHIFT)
-# define PMD_MASK	(~(PMD_SIZE-1))
 #else
 # include <asm/pgtable-2level-defs.h>
 #endif
-
-#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
-#define PGDIR_MASK	(~(PGDIR_SIZE-1))
-
-#define USER_PTRS_PER_PGD	(TASK_SIZE/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
-
-#define USER_PGD_PTRS (PAGE_OFFSET >> PGDIR_SHIFT)
-#define KERNEL_PGD_PTRS (PTRS_PER_PGD-USER_PGD_PTRS)
 
 #define TWOLEVEL_PGDIR_SHIFT	22
 #define BOOT_USER_PGD_PTRS (__PAGE_OFFSET >> TWOLEVEL_PGDIR_SHIFT)
@@ -85,113 +68,6 @@ void paging_init(void);
 #endif
 
 /*
- * _PAGE_PSE set in the page directory entry just means that
- * the page directory entry points directly to a 4MB-aligned block of
- * memory. 
- */
-#define _PAGE_BIT_PRESENT	0
-#define _PAGE_BIT_RW		1
-#define _PAGE_BIT_USER		2
-#define _PAGE_BIT_PWT		3
-#define _PAGE_BIT_PCD		4
-#define _PAGE_BIT_ACCESSED	5
-#define _PAGE_BIT_DIRTY		6
-#define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page, Pentium+, if present.. */
-#define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
-#define _PAGE_BIT_UNUSED1	9	/* available for programmer */
-#define _PAGE_BIT_UNUSED2	10
-#define _PAGE_BIT_UNUSED3	11
-#define _PAGE_BIT_NX		63
-
-#define _PAGE_PRESENT	0x001
-#define _PAGE_RW	0x002
-#define _PAGE_USER	0x004
-#define _PAGE_PWT	0x008
-#define _PAGE_PCD	0x010
-#define _PAGE_ACCESSED	0x020
-#define _PAGE_DIRTY	0x040
-#define _PAGE_PSE	0x080	/* 4 MB (or 2MB) page, Pentium+, if present.. */
-#define _PAGE_GLOBAL	0x100	/* Global TLB entry PPro+ */
-#define _PAGE_UNUSED1	0x200	/* available for programmer */
-#define _PAGE_UNUSED2	0x400
-#define _PAGE_UNUSED3	0x800
-
-/* If _PAGE_PRESENT is clear, we use these: */
-#define _PAGE_FILE	0x040	/* nonlinear file mapping, saved PTE; unset:swap */
-#define _PAGE_PROTNONE	0x080	/* if the user mapped it with PROT_NONE;
-				   pte_present gives true */
-#ifdef CONFIG_X86_PAE
-#define _PAGE_NX	(1ULL<<_PAGE_BIT_NX)
-#else
-#define _PAGE_NX	0
-#endif
-
-#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
-
-#define PAGE_NONE \
-	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
-#define PAGE_SHARED \
-	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
-
-#define PAGE_SHARED_EXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_COPY_NOEXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_COPY_EXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_COPY \
-	PAGE_COPY_NOEXEC
-#define PAGE_READONLY \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_READONLY_EXEC \
-	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-
-#define _PAGE_KERNEL \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
-#define _PAGE_KERNEL_EXEC \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
-
-extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
-#define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
-#define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
-#define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
-
-#define PAGE_KERNEL		__pgprot(__PAGE_KERNEL)
-#define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
-#define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX)
-#define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
-
-/*
- * The i386 can't do page protection for execute, and considers that
- * the same are read. Also, write permissions imply read permissions.
- * This is the closest we can get..
- */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY_EXEC
-#define __P101	PAGE_READONLY_EXEC
-#define __P110	PAGE_COPY_EXEC
-#define __P111	PAGE_COPY_EXEC
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY_EXEC
-#define __S101	PAGE_READONLY_EXEC
-#define __S110	PAGE_SHARED_EXEC
-#define __S111	PAGE_SHARED_EXEC
-
-/*
  * Define this if things work differently on an i386 and an i486:
  * it will (on an i486) warn about kernel memory accesses that are
  * done without a 'access_ok(VERIFY_WRITE,..)'
@@ -201,37 +77,6 @@ extern unsigned long long __PAGE_KERNEL,
 /* The boot page tables (all created as a single array) */
 extern unsigned long pg0[];
 
-#define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
-
-/* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
-#define pmd_none(x)	(!(unsigned long)pmd_val(x))
-#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
-
-
-#define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
-
-/*
- * The following only work if pte_present() is true.
- * Undefined behaviour if not..
- */
-static inline int pte_dirty(pte_t pte)		{ return (pte).pte_low & _PAGE_DIRTY; }
-static inline int pte_young(pte_t pte)		{ return (pte).pte_low & _PAGE_ACCESSED; }
-static inline int pte_write(pte_t pte)		{ return (pte).pte_low & _PAGE_RW; }
-static inline int pte_huge(pte_t pte)		{ return (pte).pte_low & _PAGE_PSE; }
-
-/*
- * The following only works if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)		{ return (pte).pte_low & _PAGE_FILE; }
-
-static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte_low &= ~_PAGE_DIRTY; return pte; }
-static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte_low &= ~_PAGE_ACCESSED; return pte; }
-static inline pte_t pte_wrprotect(pte_t pte)	{ (pte).pte_low &= ~_PAGE_RW; return pte; }
-static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte_low |= _PAGE_DIRTY; return pte; }
-static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte_low |= _PAGE_ACCESSED; return pte; }
-static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
-static inline pte_t pte_mkhuge(pte_t pte)	{ (pte).pte_low |= _PAGE_PSE; return pte; }
 
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level.h>
@@ -307,30 +152,6 @@ static inline pte_t native_local_ptep_ge
 	__young;							\
 })
 
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
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
@@ -365,27 +186,6 @@ static inline void clone_pgd_range(pgd_t
  * and a page entry and page directory to the page they refer to.
  */
 
-#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
-
-static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
-{
-	pte.pte_low &= _PAGE_CHG_MASK;
-	pte.pte_low |= pgprot_val(newprot);
-#ifdef CONFIG_X86_PAE
-	/*
-	 * Chop off the NX bit (if present), and add the NX portion of
-	 * the newprot (if present):
-	 */
-	pte.pte_high &= ~(1 << (_PAGE_BIT_NX - 32));
-	pte.pte_high |= (pgprot_val(newprot) >> 32) & \
-					(__supported_pte_mask >> 32);
-#endif
-	return pte;
-}
-
-#define pmd_large(pmd) \
-((pmd_val(pmd) & (_PAGE_PSE|_PAGE_PRESENT)) == (_PAGE_PSE|_PAGE_PRESENT))
-
 /*
  * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
  *
@@ -406,31 +206,6 @@ static inline pte_t pte_modify(pte_t pte
  * of a process's
  */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/*
- * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
- *
- * this macro returns the index of the entry in the pmd page which would
- * control the given virtual address
- */
-#define pmd_index(address) \
-		(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-/*
- * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
- *
- * this macro returns the index of the entry in the pte page which would
- * control the given virtual address
- */
-#define pte_index(address) \
-		(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
-
-#define pmd_page(pmd) (pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
-
-#define pmd_page_vaddr(pmd) \
-		((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 
 /*
  * Helper function that returns the kernel pagetable entry controlling
@@ -510,6 +285,4 @@ static inline void paravirt_pagetable_se
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#include <asm-generic/pgtable.h>
-
 #endif /* _I386_PGTABLE_H */
===================================================================
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -21,17 +21,14 @@ extern unsigned long __supported_pte_mas
 
 #define swapper_pg_dir init_level4_pgt
 
-extern void paging_init(void);
 extern void clear_kernel_mapping(unsigned long addr, unsigned long size);
 
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
-#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
+#endif /* !__ASSEMBLY__ */
 
-#endif /* !__ASSEMBLY__ */
+#define __PAGE_KERNEL \
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX | _PAGE_GLOBAL)
+#define __PAGE_KERNEL_EXEC \
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
 
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
@@ -71,51 +68,71 @@ extern unsigned long empty_zero_page[PAG
 #define pgd_none(x)	(!pgd_val(x))
 #define pud_none(x)	(!pud_val(x))
 
-static inline void set_pte(pte_t *dst, pte_t val)
+struct mm_struct;
+
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
 {
-	*dst = val;
-} 
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
-
-static inline void set_pmd(pmd_t *dst, pmd_t val)
-{
-        *dst = val;
-} 
-
-static inline void set_pud(pud_t *dst, pud_t val)
-{
-	*dst = val;
+	*xp = native_make_pte(0);
 }
 
-static inline void pud_clear (pud_t *pud)
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
 {
-	set_pud(pud, __pud(0));
+	pte_t res = *ptep;
+
+	/* Pure native function needs no input for mm, addr */
+	native_pte_clear(NULL, 0, ptep);
+	return res;
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
+	return native_local_ptep_get_and_clear(xp);
+#endif
 }
 
-#define ptep_get_and_clear(mm,addr,xp)	__pte(xchg(&(xp)->pte, 0))
+static inline void native_set_pte(pte_t *ptep , pte_t pte)
+{
+	*ptep = pte;
+}
 
-struct mm_struct;
+static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
+				     pte_t *ptep , pte_t pte)
+{
+	native_set_pte(ptep, pte);
+}
 
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
+static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
-	pte_t pte;
-	if (full) {
-		pte = *ptep;
-		*ptep = __pte(0);
-	} else {
-		pte = ptep_get_and_clear(mm, addr, ptep);
-	}
-	return pte;
+	*pmdp = pmd;
+}
+
+static inline void native_pmd_clear(pmd_t *pmd)
+{
+	native_set_pmd(pmd, native_make_pmd(0));
+}
+
+static inline void native_set_pud(pud_t *pudp, pud_t pud)
+{
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
@@ -124,16 +141,6 @@ static inline pte_t ptep_get_and_clear_f
 
 #endif /* !__ASSEMBLY__ */
 
-#define PMD_SIZE	(_AC(1,UL) << PMD_SHIFT)
-#define PMD_MASK	(~(PMD_SIZE-1))
-#define PUD_SIZE	(_AC(1,UL) << PUD_SHIFT)
-#define PUD_MASK	(~(PUD_SIZE-1))
-#define PGDIR_SIZE	(_AC(1,UL) << PGDIR_SHIFT)
-#define PGDIR_MASK	(~(PGDIR_SIZE-1))
-
-#define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
-#define FIRST_USER_ADDRESS	0
-
 #define MAXMEM		 _AC(0x3fffffffffff, UL)
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
@@ -141,150 +148,6 @@ static inline pte_t ptep_get_and_clear_f
 #define MODULES_VADDR    _AC(0xffffffff88000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
-
-#define _PAGE_BIT_PRESENT	0
-#define _PAGE_BIT_RW		1
-#define _PAGE_BIT_USER		2
-#define _PAGE_BIT_PWT		3
-#define _PAGE_BIT_PCD		4
-#define _PAGE_BIT_ACCESSED	5
-#define _PAGE_BIT_DIRTY		6
-#define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
-#define _PAGE_BIT_FILE		6
-#define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
-#define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
-
-#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1, UL)<<_PAGE_BIT_PCD)
-#define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
-/* 2MB page */
-#define _PAGE_PSE	(_AC(1, UL)<<_PAGE_BIT_PSE)
-/* nonlinear file mapping, saved PTE; unset:swap */
-#define _PAGE_FILE	(_AC(1, UL)<<_PAGE_BIT_FILE)
-/* Global TLB entry */
-#define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)
-
-#define _PAGE_PROTNONE	0x080	/* If not present */
-#define _PAGE_NX        (_AC(1, UL)<<_PAGE_BIT_NX)
-
-#define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
-
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
-
-#define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
-#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_SHARED_EXEC __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_COPY_NOEXEC __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_COPY PAGE_COPY_NOEXEC
-#define PAGE_COPY_EXEC __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
-#define PAGE_READONLY_EXEC __pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define __PAGE_KERNEL \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
-#define __PAGE_KERNEL_EXEC \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
-#define __PAGE_KERNEL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_PCD | _PAGE_PWT | _PAGE_ACCESSED | _PAGE_NX)
-#define __PAGE_KERNEL_RO \
-	(_PAGE_PRESENT | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_NX)
-#define __PAGE_KERNEL_VSYSCALL \
-	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE \
-	(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_LARGE \
-	(__PAGE_KERNEL | _PAGE_PSE)
-#define __PAGE_KERNEL_LARGE_EXEC \
-	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
-
-#define MAKE_GLOBAL(x) __pgprot((x) | _PAGE_GLOBAL)
-
-#define PAGE_KERNEL MAKE_GLOBAL(__PAGE_KERNEL)
-#define PAGE_KERNEL_EXEC MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
-#define PAGE_KERNEL_RO MAKE_GLOBAL(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_NOCACHE MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_VSYSCALL32 __pgprot(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_LARGE MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL_NOCACHE)
-
-/*         xwr */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY_EXEC
-#define __P101	PAGE_READONLY_EXEC
-#define __P110	PAGE_COPY_EXEC
-#define __P111	PAGE_COPY_EXEC
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY_EXEC
-#define __S101	PAGE_READONLY_EXEC
-#define __S110	PAGE_SHARED_EXEC
-#define __S111	PAGE_SHARED_EXEC
-
-#ifndef __ASSEMBLY__
-
-static inline unsigned long pgd_bad(pgd_t pgd)
-{
-	return pgd_val(pgd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
-}
-
-static inline unsigned long pud_bad(pud_t pud)
-{
-	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
-}
-
-static inline unsigned long pmd_bad(pmd_t pmd)
-{
-	return pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
-}
-
-#define pte_none(x)	(!pte_val(x))
-#define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
-#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
-
-#define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this right? */
-#define pte_page(x)	pfn_to_page(pte_pfn(x))
-#define pte_pfn(x)  ((pte_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
-
-static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
-{
-	pteval_t pte;
-	pte = (page_nr << PAGE_SHIFT);
-	pte |= pgprot_val(pgprot);
-	pte &= __supported_pte_mask;
-	return __pte(pte);
-}
-
-/*
- * The following only work if pte_present() is true.
- * Undefined behaviour if not..
- */
-#define __LARGE_PTE (_PAGE_PSE|_PAGE_PRESENT)
-static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
-static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
-static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
-
-static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
-static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
-static inline pte_t pte_wrprotect(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_RW)); return pte; }
-static inline pte_t pte_mkexec(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_NX)); return pte; }
-static inline pte_t pte_mkdirty(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_DIRTY)); return pte; }
-static inline pte_t pte_mkyoung(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_ACCESSED)); return pte; }
-static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW)); return pte; }
-static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE)); return pte; }
-static inline pte_t pte_clrhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE)); return pte; }
 
 struct vm_area_struct;
 
@@ -300,15 +163,11 @@ static inline void ptep_set_wrprotect(st
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
 }
 
+#ifndef __ASSEMBLY__
 /*
  * Macro to mark a page protection value as "uncacheable".
  */
 #define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))
-
-static inline int pmd_large(pmd_t pte) { 
-	return (pmd_val(pte) & __LARGE_PTE) == __LARGE_PTE; 
-} 	
-
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
@@ -326,7 +185,7 @@ static inline int pmd_large(pmd_t pte) {
 #define pgd_present(pgd) (pgd_val(pgd) & _PAGE_PRESENT)
 #define mk_kernel_pgd(address) ((pgd_t){ (address) | _KERNPG_TABLE })
 
-/* PUD - Level3 access */
+/* PUD - Level 3 access */
 /* to find an entry in a page-table-directory. */
 #define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PHYSICAL_PAGE_MASK))
 #define pud_page(pud)		(pfn_to_page(pud_val(pud) >> PAGE_SHIFT))
@@ -341,36 +200,14 @@ static inline int pmd_large(pmd_t pte) {
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 #define pmd_offset(dir, address) ((pmd_t *) pud_page_vaddr(*(dir)) + \
 			pmd_index(address))
-#define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
-#define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
-#define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
 #define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
 #define pgoff_to_pte(off) ((pte_t) { ((off) << PAGE_SHIFT) | _PAGE_FILE })
 #define PTE_FILE_MAX_BITS __PHYSICAL_MASK_SHIFT
 
 /* PTE - Level 1 access. */
-
-/* page, protection -> pte */
-#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
  
-/* Change flags of a PTE */
-static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
-{ 
-	pteval_t val = pte_val(pte);
-	val &= _PAGE_CHG_MASK;
-	val |= pgprot_val(newprot);
-	val &= __supported_pte_mask;
-	return __pte(val);
-}
-
-#define pte_index(address) \
-		(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address) ((pte_t *) pmd_page_vaddr(*(dir)) + \
-			pte_index(address))
-
 /* x86-64 always has all page tables mapped. */
 #define pte_offset_map(dir,address) pte_offset_kernel(dir,address)
 #define pte_offset_map_nested(dir,address) pte_offset_kernel(dir,address)
@@ -427,11 +264,9 @@ pte_t *lookup_address(unsigned long addr
    (((o) & (1UL << (__VIRTUAL_MASK_SHIFT-1))) ? ((o) | (~__VIRTUAL_MASK)) : (o))
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
-#include <asm-generic/pgtable.h>
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _X86_64_PGTABLE_H */

-- 

