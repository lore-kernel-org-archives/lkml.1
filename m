Return-Path: <linux-kernel-owner+w=401wt.eu-S1762437AbZBETki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762437AbZBETki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZBETcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:36 -0500
Received: from gw.goop.org ([64.81.55.164]:40071 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613AbZBETcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:23 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 34 of 36] x86: add and use pgd/pud/pmd_flags
X-Mercurial-Node: f30a907410659b663f96c4a5ae0f61807b1f0634
Message-Id: <f30a907410659b663f96.1233862276@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pgd/pud/pmd_flags which are analogous to pte_flags, and use them
where-ever we only care about testing the flags portions of the
respective entries.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/page.h    |   15 +++++++++++++++
 arch/x86/include/asm/pgtable.h |   16 ++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -95,6 +95,11 @@
 	return pgd.pgd;
 }
 
+static inline pgdval_t pgd_flags(pgd_t pgd)
+{
+	return native_pgd_val(pgd) & PTE_FLAGS_MASK;
+}
+
 #if PAGETABLE_LEVELS >= 3
 #if PAGETABLE_LEVELS == 4
 typedef struct { pudval_t pud; } pud_t;
@@ -117,6 +122,11 @@
 }
 #endif	/* PAGETABLE_LEVELS == 4 */
 
+static inline pudval_t pud_flags(pud_t pud)
+{
+	return native_pud_val(pud) & PTE_FLAGS_MASK;
+}
+
 typedef struct { pmdval_t pmd; } pmd_t;
 
 static inline pmd_t native_make_pmd(pmdval_t val)
@@ -128,6 +138,11 @@
 {
 	return pmd.pmd;
 }
+
+static inline pmdval_t pmd_flags(pmd_t pmd)
+{
+	return native_pmd_val(pmd) & PTE_FLAGS_MASK;
+}
 #else  /* PAGETABLE_LEVELS == 2 */
 #include <asm-generic/pgtable-nopmd.h>
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -241,7 +241,7 @@
 
 static inline int pmd_large(pmd_t pte)
 {
-	return (pmd_val(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
+	return (pmd_flags(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
 		(_PAGE_PSE | _PAGE_PRESENT);
 }
 
@@ -496,7 +496,7 @@
 
 static inline int pmd_present(pmd_t pmd)
 {
-	return pmd_val(pmd) & _PAGE_PRESENT;
+	return pmd_flags(pmd) & _PAGE_PRESENT;
 }
 
 static inline int pmd_none(pmd_t pmd)
@@ -554,7 +554,7 @@
 
 static inline int pmd_bad(pmd_t pmd)
 {
-	return (pmd_val(pmd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pmd_flags(pmd) & ~_PAGE_USER) != _KERNPG_TABLE;
 }
 
 static inline unsigned long pages_to_mb(unsigned long npg)
@@ -573,7 +573,7 @@
 
 static inline int pud_present(pud_t pud)
 {
-	return pud_val(pud) & _PAGE_PRESENT;
+	return pud_flags(pud) & _PAGE_PRESENT;
 }
 
 static inline unsigned long pud_page_vaddr(pud_t pud)
@@ -599,20 +599,20 @@
 
 static inline int pud_large(pud_t pud)
 {
-	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
+	return (pud_flags(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
 		(_PAGE_PSE | _PAGE_PRESENT);
 }
 
 static inline int pud_bad(pud_t pud)
 {
-	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+	return (pud_flags(pud) & ~(_KERNPG_TABLE | _PAGE_USER)) != 0;
 }
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #if PAGETABLE_LEVELS > 3
 static inline int pgd_present(pgd_t pgd)
 {
-	return pgd_val(pgd) & _PAGE_PRESENT;
+	return pgd_flags(pgd) & _PAGE_PRESENT;
 }
 
 static inline unsigned long pgd_page_vaddr(pgd_t pgd)
@@ -638,7 +638,7 @@
 
 static inline int pgd_bad(pgd_t pgd)
 {
-	return (pgd_val(pgd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
+	return (pgd_flags(pgd) & ~_PAGE_USER) != _KERNPG_TABLE;
 }
 
 static inline int pgd_none(pgd_t pgd)


