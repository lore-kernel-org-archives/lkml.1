Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbXJaXBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbXJaXBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXJaXAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:00:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761478AbXJaXAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:00:49 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7/16] native versions for set pagetables
Date: Wed, 31 Oct 2007 16:14:52 -0300
Message-Id: <11938581403478-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581351064-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the set_p{te,md,ud,gd} functions into their
native_ versions. There is no need to patch any caller.

Also, it adds pte_update() and pte_update_defer() calls whenever
we modify a page table entry. This last part was coded to match
i386 as close as possible.

Pieces of the header are moved to below the #ifdef CONFIG_PARAVIRT
site, as they are users of the newly defined set_* macros.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/pgtable_64.h |  192 ++++++++++++++++++++++++++++--------------
 1 files changed, 128 insertions(+), 64 deletions(-)

diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 9b0ff47..592d613 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -57,56 +57,107 @@ extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
  */
 #define PTRS_PER_PTE	512
 
-#ifndef __ASSEMBLY__
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+
+#define set_pte native_set_pte
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+#define set_pmd native_set_pmd
+#define set_pud native_set_pud
+#define set_pgd native_set_pgd
+#define pte_clear(mm, addr, xp)				\
+do { 							\
+	set_pte_at(mm, addr, xp, __pte(0)); 		\
+} while (0)
 
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), pte_val(e))
-#define pmd_ERROR(e) \
-	printk("%s:%d: bad pmd %p(%016lx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
-#define pud_ERROR(e) \
-	printk("%s:%d: bad pud %p(%016lx).\n", __FILE__, __LINE__, &(e), pud_val(e))
-#define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd %p(%016lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
+#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
+#define pud_clear native_pud_clear
+#define pgd_clear native_pgd_clear
+#define pte_update(mm, addr, ptep)              do { } while (0)
+#define pte_update_defer(mm, addr, ptep)        do { } while (0)
 
-#define pgd_none(x)	(!pgd_val(x))
-#define pud_none(x)	(!pud_val(x))
+#endif
 
-static inline void set_pte(pte_t *dst, pte_t val)
+#ifndef __ASSEMBLY__
+
+static inline void native_set_pte(pte_t *dst, pte_t val)
 {
-	pte_val(*dst) = pte_val(val);
+	dst->pte = pte_val(val);
 } 
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
-static inline void set_pmd(pmd_t *dst, pmd_t val)
+static inline void native_set_pmd(pmd_t *dst, pmd_t val)
 {
-        pmd_val(*dst) = pmd_val(val); 
+	dst->pmd = pmd_val(val);
 } 
 
-static inline void set_pud(pud_t *dst, pud_t val)
+static inline void native_set_pud(pud_t *dst, pud_t val)
 {
-	pud_val(*dst) = pud_val(val);
+	dst->pud = pud_val(val);
 }
 
-static inline void pud_clear (pud_t *pud)
+static inline void native_set_pgd(pgd_t *dst, pgd_t val)
 {
-	set_pud(pud, __pud(0));
+	dst->pgd = pgd_val(val);
 }
 
-static inline void set_pgd(pgd_t *dst, pgd_t val)
+static inline void native_pud_clear(pud_t *pud)
 {
-	pgd_val(*dst) = pgd_val(val); 
-} 
+	set_pud(pud, __pud(0));
+}
 
-static inline void pgd_clear (pgd_t * pgd)
+static inline void native_pgd_clear(pgd_t *pgd)
 {
 	set_pgd(pgd, __pgd(0));
 }
 
-#define ptep_get_and_clear(mm,addr,xp)	__pte(xchg(&(xp)->pte, 0))
+static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
+				     pte_t *ptep, pte_t pteval)
+{
+	native_set_pte(ptep, pteval);
+}
+
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep)
+{
+	native_set_pte_at(mm, addr, ptep, __pte(0));
+}
+
+static inline void native_pmd_clear(pmd_t *pmd)
+{
+	native_set_pmd(pmd, __pmd(0));
+}
+
+
+#define pte_ERROR(e) 					\
+	printk("%s:%d: bad pte %p(%016llx).\n",		\
+	__FILE__, __LINE__, &(e), (u64)pte_val(e))
+#define pmd_ERROR(e) 					\
+	printk("%s:%d: bad pmd %p(%016llx).\n", 	\
+	__FILE__, __LINE__, &(e), (u64)pmd_val(e))
+#define pud_ERROR(e) 					\
+	printk("%s:%d: bad pud %p(%016llx).\n",		\
+	 __FILE__, __LINE__, &(e), (u64)pud_val(e))
+#define pgd_ERROR(e) 					\
+	printk("%s:%d: bad pgd %p(%016llx).\n", 	\
+	__FILE__, __LINE__, &(e), (u64)pgd_val(e))
+
+#define pgd_none(x)	(!pgd_val(x))
+#define pud_none(x)	(!pud_val(x))
 
 struct mm_struct;
 
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
+				       unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = __pte(xchg(&ptep->pte, 0));
+	pte_update(mm, addr, ptep);
+	return pte;
+}
+
+static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep,
+					    int full)
 {
 	pte_t pte;
 	if (full) {
@@ -246,7 +297,6 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 
 #define pte_none(x)	(!pte_val(x))
 #define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
-#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this
 						   right? */
@@ -255,11 +305,11 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
-	pte_t pte;
-	pte_val(pte) = (page_nr << PAGE_SHIFT);
-	pte_val(pte) |= pgprot_val(pgprot);
-	pte_val(pte) &= __supported_pte_mask;
-	return pte;
+	unsigned long pte;
+	pte = (page_nr << PAGE_SHIFT);
+	pte |= pgprot_val(pgprot);
+	pte &= __supported_pte_mask;
+	return __pte(pte);
 }
 
 /*
@@ -283,30 +333,6 @@ static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) |
 static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE)); return pte; }
 static inline pte_t pte_clrhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE)); return pte; }
 
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
-
-/*
- * Macro to mark a page protection value as "uncacheable".
- */
-#define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))
-
-static inline int pmd_large(pmd_t pte) { 
-	return (pmd_val(pte) & __LARGE_PTE) == __LARGE_PTE; 
-} 	
-
-
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
@@ -340,7 +366,6 @@ static inline int pmd_large(pmd_t pte) {
 			pmd_index(address))
 #define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
 #define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
@@ -352,15 +377,53 @@ static inline int pmd_large(pmd_t pte) {
 
 /* page, protection -> pte */
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
-#define mk_pte_huge(entry) (pte_val(entry) |= _PAGE_PRESENT | _PAGE_PSE)
- 
+
+static inline pte_t __mk_pte_huge(pte_t entry)
+{
+	unsigned long pte;
+	pte = pte_val(entry);
+	pte |= _PAGE_PRESENT | _PAGE_PSE;
+	return  __pte(pte);
+}
+#define mk_pte_huge(entry) ((entry) = __mk_pte_huge(entry))
+
+#include <linux/mm_types.h>
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep)
+{
+	int ret = 0;
+	if (!pte_young(*ptep))
+		return 0;
+	ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte);
+	pte_update(vma->vm_mm, addr, ptep);
+	return ret;
+}
+
+static inline void ptep_set_wrprotect(struct mm_struct *mm,
+				      unsigned long addr, pte_t *ptep)
+{
+	clear_bit(_PAGE_BIT_RW, &ptep->pte);
+	pte_update(mm, addr, ptep);
+}
+
+/*
+ * Macro to mark a page protection value as "uncacheable".
+ */
+#define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))
+
+static inline int pmd_large(pmd_t pte)
+{
+	return (pmd_val(pte) & __LARGE_PTE) == __LARGE_PTE;
+}
+
 /* Change flags of a PTE */
-static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+static inline pte_t pte_modify(pte_t pte_old, pgprot_t newprot)
 { 
-	pte_val(pte) &= _PAGE_CHG_MASK;
-	pte_val(pte) |= pgprot_val(newprot);
-	pte_val(pte) &= __supported_pte_mask;
-       return pte; 
+	unsigned long pte = pte_val(pte_old);
+	pte &= _PAGE_CHG_MASK;
+	pte |= pgprot_val(newprot);
+	pte &= __supported_pte_mask;
+	return __pte(pte);
 }
 
 #define pte_index(address) \
@@ -387,6 +450,7 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 	int __changed = !pte_same(*(__ptep), __entry);			  \
 	if (__changed && __dirty) {					  \
 		set_pte(__ptep, __entry);			  	  \
+		pte_update_defer((__vma)->vm_mm, (__address), (__ptep));  \
 		flush_tlb_page(__vma, __address);		  	  \
 	}								  \
 	__changed;							  \
-- 
1.4.4.2

