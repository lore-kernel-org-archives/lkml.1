Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYAHWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYAHWPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYAHWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:33 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47846
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750871AbYAHWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:32 -0500
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 17:15:32 EST
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 10] x86: unify pgtable accessors which use
	supported_pte_mask
X-Mercurial-Node: aecbf28ecb53fb7b2830b8d2629289c0a466fd93
Message-Id: <aecbf28ecb53fb7b2830.1199829607@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make users of supported_pte_mask common.  This has the side-effect of
introducing the variable for 32-bit non-PAE, but I think its a pretty
small cost to simplify the code.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/mm/init_32.c            |    5 +++--
 include/asm-x86/pgtable-2level.h |    2 --
 include/asm-x86/pgtable-3level.h |   14 --------------
 include/asm-x86/pgtable.h        |   32 ++++++++++++++++++++++++++++++++
 include/asm-x86/pgtable_32.h     |   16 ----------------
 include/asm-x86/pgtable_64.h     |   18 ------------------
 6 files changed, 35 insertions(+), 52 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -473,11 +473,12 @@ void zap_low_mappings (void)
 
 int nx_enabled = 0;
 
+pteval_t __supported_pte_mask __read_mostly = ~_PAGE_NX;
+EXPORT_SYMBOL_GPL(__supported_pte_mask);
+
 #ifdef CONFIG_X86_PAE
 
 static int disable_nx __initdata = 0;
-u64 __supported_pte_mask __read_mostly = ~_PAGE_NX;
-EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 /*
  * noexec = on|off
diff --git a/include/asm-x86/pgtable-2level.h b/include/asm-x86/pgtable-2level.h
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -53,8 +53,6 @@ static inline pte_t native_ptep_get_and_
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 #define pte_none(x)		(!(x).pte_low)
 #define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
-#define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 /*
  * All present pages are kernel-executable:
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -158,20 +158,6 @@ static inline unsigned long pte_pfn(pte_
 	return pte_val(pte) >> PAGE_SHIFT;
 }
 
-extern unsigned long long __supported_pte_mask;
-
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
-
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -135,6 +135,38 @@ static inline pte_t pte_mkhuge(pte_t pte
 static inline pte_t pte_mkhuge(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_PSE); }
 static inline pte_t pte_clrhuge(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_PSE); }
 
+extern pteval_t __supported_pte_mask;
+
+static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
+{
+	return __pte((((phys_addr_t)page_nr << PAGE_SHIFT) |
+		      pgprot_val(pgprot)) & __supported_pte_mask);
+}
+
+static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
+{
+	return __pmd((((phys_addr_t)page_nr << PAGE_SHIFT) |
+		      pgprot_val(pgprot)) & __supported_pte_mask);
+}
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	pteval_t val = pte_val(pte);
+
+	val &= _PAGE_CHG_MASK;
+	val |= pgprot_val(newprot);
+
+	/*
+	 * Chop off the NX bit (if present), and add the NX portion of
+	 * the newprot (if present):
+	 */
+	val &= ~_PAGE_NX;
+	val |= pgprot_val(newprot) & __supported_pte_mask;
+
+	return __pte(val);
+}
+
+
 #endif	/* __ASSEMBLER__ */
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -235,22 +235,6 @@ static inline void clone_pgd_range(pgd_t
 
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 
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
 /*
  * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
  *
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -17,7 +17,6 @@ extern pud_t level3_ident_pgt[512];
 extern pud_t level3_ident_pgt[512];
 extern pmd_t level2_kernel_pgt[512];
 extern pgd_t init_level4_pgt[];
-extern unsigned long __supported_pte_mask;
 
 #define swapper_pg_dir init_level4_pgt
 
@@ -165,14 +164,6 @@ static inline unsigned long pmd_bad(pmd_
 #define pte_page(x)	pfn_to_page(pte_pfn(x))
 #define pte_pfn(x)  ((pte_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
-static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
-{
-	pte_t pte;
-	pte_val(pte) = (page_nr << PAGE_SHIFT);
-	pte_val(pte) |= pgprot_val(pgprot);
-	pte_val(pte) &= __supported_pte_mask;
-	return pte;
-}
 struct vm_area_struct;
 
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
@@ -239,15 +230,6 @@ static inline void ptep_set_wrprotect(st
 /* page, protection -> pte */
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
  
-/* Change flags of a PTE */
-static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
-{ 
-	pte_val(pte) &= _PAGE_CHG_MASK;
-	pte_val(pte) |= pgprot_val(newprot);
-	pte_val(pte) &= __supported_pte_mask;
-       return pte; 
-}
-
 #define pte_index(address) \
 		(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, address) ((pte_t *) pmd_page_vaddr(*(dir)) + \


