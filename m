Return-Path: <linux-kernel-owner+w=401wt.eu-S1765440AbXHHHQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765440AbXHHHQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXHHHIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbXHHHIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:48 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 12/25] [PATCH] native versions for set pagetables
Date: Wed,  8 Aug 2007 01:18:59 -0300
Message-Id: <11865468003673-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865467973510-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com>
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
---
 include/asm-x86_64/pgtable.h |  152 ++++++++++++++++++++++++-----------------
 1 files changed, 89 insertions(+), 63 deletions(-)

diff --git a/include/asm-x86_64/pgtable.h b/include/asm-x86_64/pgtable.h
index c9d8764..dd572a2 100644
--- a/include/asm-x86_64/pgtable.h
+++ b/include/asm-x86_64/pgtable.h
@@ -57,55 +57,77 @@ extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
  */
 #define PTRS_PER_PTE	512
 
-#ifndef __ASSEMBLY__
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
 
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), pte_val(e))
-#define pmd_ERROR(e) \
-	printk("%s:%d: bad pmd %p(%016lx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
-#define pud_ERROR(e) \
-	printk("%s:%d: bad pud %p(%016lx).\n", __FILE__, __LINE__, &(e), pud_val(e))
-#define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd %p(%016lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
+#define set_pte native_set_pte
+#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
+#define set_pmd native_set_pmd
+#define set_pud native_set_pud
+#define set_pgd native_set_pgd
+#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
+#define pud_clear native_pud_clear
+#define pgd_clear native_pgd_clear
+#define pte_update(mm, addr, ptep)              do { } while (0)
+#define pte_update_defer(mm, addr, ptep)        do { } while (0)
 
-#define pgd_none(x)	(!pgd_val(x))
-#define pud_none(x)	(!pud_val(x))
+#endif
+
+#ifndef __ASSEMBLY__
 
-static inline void set_pte(pte_t *dst, pte_t val)
+static inline void native_set_pte(pte_t *dst, pte_t val)
 {
-	pte_val(*dst) = pte_val(val);
+	dst->pte = pte_val(val);
 } 
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
-static inline void set_pmd(pmd_t *dst, pmd_t val)
+
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
-
-static inline void set_pgd(pgd_t *dst, pgd_t val)
+static inline void native_pud_clear (pud_t *pud)
 {
-	pgd_val(*dst) = pgd_val(val); 
-} 
+	set_pud(pud, __pud(0));
+}
 
-static inline void pgd_clear (pgd_t * pgd)
+static inline void native_pgd_clear (pgd_t * pgd)
 {
 	set_pgd(pgd, __pgd(0));
 }
 
-#define ptep_get_and_clear(mm,addr,xp)	__pte(xchg(&(xp)->pte, 0))
+#define pte_ERROR(e) \
+	printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), pte_val(e))
+#define pmd_ERROR(e) \
+	printk("%s:%d: bad pmd %p(%016lx).\n", __FILE__, __LINE__, &(e), pmd_val(e))
+#define pud_ERROR(e) \
+	printk("%s:%d: bad pud %p(%016lx).\n", __FILE__, __LINE__, &(e), pud_val(e))
+#define pgd_ERROR(e) \
+	printk("%s:%d: bad pgd %p(%016lx).\n", __FILE__, __LINE__, &(e), pgd_val(e))
+
+#define pgd_none(x)	(!pgd_val(x))
+#define pud_none(x)	(!pud_val(x))
 
 struct mm_struct;
 
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = __pte(xchg(&ptep->pte, 0));
+	pte_update(mm, addr, ptep);
+	return pte;
+}
+
 static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long addr, pte_t *ptep, int full)
 {
 	pte_t pte;
@@ -245,7 +267,6 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 
 #define pte_none(x)	(!pte_val(x))
 #define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
-#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this
 						   right? */
@@ -254,11 +275,11 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 
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
@@ -282,30 +303,6 @@ static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) |
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
@@ -339,7 +336,6 @@ static inline int pmd_large(pmd_t pte) {
 			pmd_index(address))
 #define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
 #define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
@@ -352,14 +348,43 @@ static inline int pmd_large(pmd_t pte) {
 /* page, protection -> pte */
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 #define mk_pte_huge(entry) (pte_val(entry) |= _PAGE_PRESENT | _PAGE_PSE)
- 
+
+struct vm_area_struct;
+
+#include <linux/mm.h>
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+{
+	int ret = 0;
+	if (!pte_young(*ptep))
+		return 0;
+	ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte);
+	pte_update(vma->vm_mm, addr, ptep);
+	return ret;
+}
+
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
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
+static inline int pmd_large(pmd_t pte) {
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
@@ -386,6 +411,7 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 	int __changed = !pte_same(*(__ptep), __entry);			  \
 	if (__changed && __dirty) {					  \
 		set_pte(__ptep, __entry);			  	  \
+		pte_update_defer((__vma)->vm_mm, (__address), (__ptep));  \
 		flush_tlb_page(__vma, __address);		  	  \
 	}								  \
 	__changed;							  \
-- 
1.4.4.2

