Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYGVGAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYGVGAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 02:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYGVGAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 02:00:10 -0400
Received: from gw.goop.org ([64.81.55.164]:35791 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbYGVGAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 02:00:08 -0400
Message-ID: <4885775C.3010504@goop.org>
Date: Mon, 21 Jul 2008 22:59:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: add PTE_FLAGS_MASK
References: <200807221431.58991.rusty@rustcorp.com.au> <488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au>
In-Reply-To: <200807221540.47161.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTE_PFN_MASK was getting lonely, so I made it a friend.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/mm/dump_pagetables.c |    6 +++---
 arch/x86/xen/mmu.c            |    4 ++--
 include/asm-x86/page.h        |    5 ++++-
 include/asm-x86/pgtable.h     |    2 +-
 include/asm-x86/pgtable_32.h  |    2 +-
 5 files changed, 11 insertions(+), 8 deletions(-)

===================================================================
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -221,7 +221,7 @@
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		st->current_address = normalize_addr(P + i * PMD_LEVEL_MULT);
 		if (!pmd_none(*start)) {
-			pgprotval_t prot = pmd_val(*start) & ~PTE_PFN_MASK;
+			pgprotval_t prot = pmd_val(*start) & PTE_FLAGS_MASK;
 
 			if (pmd_large(*start) || !pmd_present(*start))
 				note_page(m, st, __pgprot(prot), 3);
@@ -253,7 +253,7 @@
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		st->current_address = normalize_addr(P + i * PUD_LEVEL_MULT);
 		if (!pud_none(*start)) {
-			pgprotval_t prot = pud_val(*start) & ~PTE_PFN_MASK;
+			pgprotval_t prot = pud_val(*start) & PTE_FLAGS_MASK;
 
 			if (pud_large(*start) || !pud_present(*start))
 				note_page(m, st, __pgprot(prot), 2);
@@ -288,7 +288,7 @@
 	for (i = 0; i < PTRS_PER_PGD; i++) {
 		st.current_address = normalize_addr(i * PGD_LEVEL_MULT);
 		if (!pgd_none(*start)) {
-			pgprotval_t prot = pgd_val(*start) & ~PTE_PFN_MASK;
+			pgprotval_t prot = pgd_val(*start) & PTE_FLAGS_MASK;
 
 			if (pgd_large(*start) || !pgd_present(*start))
 				note_page(m, &st, __pgprot(prot), 1);
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -344,7 +344,7 @@
 {
 	if (val & _PAGE_PRESENT) {
 		unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
-		pteval_t flags = val & ~PTE_PFN_MASK;
+		pteval_t flags = val & PTE_FLAGS_MASK;
 		val = ((pteval_t)mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
 	}
 
@@ -355,7 +355,7 @@
 {
 	if (val & _PAGE_PRESENT) {
 		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
-		pteval_t flags = val & ~PTE_PFN_MASK;
+		pteval_t flags = val & PTE_FLAGS_MASK;
 		val = ((pteval_t)pfn_to_mfn(pfn) << PAGE_SHIFT) | flags;
 	}
 
===================================================================
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -20,6 +20,9 @@
 
 /* PTE_PFN_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
 #define PTE_PFN_MASK		((pteval_t)PHYSICAL_PAGE_MASK)
+
+/* PTE_FLAGS_MASK extracts the flags from a (pte|pmd|pud|pgd)val_t */
+#define PTE_FLAGS_MASK		(~PTE_PFN_MASK)
 
 #define PMD_PAGE_SIZE		(_AC(1, UL) << PMD_SHIFT)
 #define PMD_PAGE_MASK		(~(PMD_PAGE_SIZE-1))
@@ -146,7 +149,7 @@
 
 static inline pteval_t native_pte_flags(pte_t pte)
 {
-	return native_pte_val(pte) & ~PTE_PFN_MASK;
+	return native_pte_val(pte) & PTE_FLAGS_MASK;
 }
 
 #define pgprot_val(x)	((x).pgprot)
===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -286,7 +286,7 @@
 	return __pgprot(preservebits | addbits);
 }
 
-#define pte_pgprot(x) __pgprot(pte_flags(x) & ~PTE_PFN_MASK)
+#define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
===================================================================
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -94,7 +94,7 @@
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
-#define pmd_bad(x) ((pmd_val(x) & (~PTE_PFN_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define pmd_bad(x) ((pmd_val(x) & (PTE_FLAGS_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 


