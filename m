Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYAHWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYAHWQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYAHWPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:36 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47850
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751893AbYAHWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 10] x86/pgtable: unify pagetable accessors
X-Mercurial-Node: 1a1e6da542c9e10ef854ce4dbf5f175d29bae651
Message-Id: <1a1e6da542c9e10ef854.1199829606@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify functions to test and set bits in pagetable entries.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/pgtable.h    |   28 ++++++++++++++++++++++++++++
 include/asm-x86/pgtable_32.h |   25 -------------------------
 include/asm-x86/pgtable_64.h |   26 --------------------------
 3 files changed, 28 insertions(+), 51 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -109,6 +109,34 @@ extern unsigned long long __PAGE_KERNEL,
 #define __S110	PAGE_SHARED_EXEC
 #define __S111	PAGE_SHARED_EXEC
 
+#ifndef __ASSEMBLER__
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
+static inline int pmd_large(pmd_t pte) {
+	return (pmd_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
+		(_PAGE_PSE|_PAGE_PRESENT);
+}
+
+static inline pte_t pte_mkclean(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_DIRTY); }
+static inline pte_t pte_mkold(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_ACCESSED); }
+static inline pte_t pte_wrprotect(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_RW); }
+static inline pte_t pte_mkexec(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_NX); }
+static inline pte_t pte_mkdirty(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_DIRTY); }
+static inline pte_t pte_mkyoung(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_ACCESSED); }
+static inline pte_t pte_mkwrite(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_RW); }
+static inline pte_t pte_mkhuge(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_PSE); }
+static inline pte_t pte_clrhuge(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_PSE); }
+
+#endif	/* __ASSEMBLER__ */
+
 #ifdef CONFIG_X86_32
 # include "pgtable_32.h"
 #else
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -100,28 +100,6 @@ extern unsigned long pg0[];
 
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
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
@@ -273,9 +251,6 @@ static inline pte_t pte_modify(pte_t pte
 	return pte;
 }
 
-#define pmd_large(pmd) \
-((pmd_val(pmd) & (_PAGE_PSE|_PAGE_PRESENT)) == (_PAGE_PSE|_PAGE_PRESENT))
-
 /*
  * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
  *
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -173,28 +173,6 @@ static inline pte_t pfn_pte(unsigned lon
 	pte_val(pte) &= __supported_pte_mask;
 	return pte;
 }
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
-
 struct vm_area_struct;
 
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
@@ -213,10 +191,6 @@ static inline void ptep_set_wrprotect(st
  * Macro to mark a page protection value as "uncacheable".
  */
 #define pgprot_noncached(prot)	(__pgprot(pgprot_val(prot) | _PAGE_PCD | _PAGE_PWT))
-
-static inline int pmd_large(pmd_t pte) { 
-	return (pmd_val(pte) & __LARGE_PTE) == __LARGE_PTE; 
-} 	
 
 
 /*


