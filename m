Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYADFk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYADFk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYADFjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:36 -0500
Received: from gw.goop.org ([64.81.55.164]:48761 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYADFjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 8] x86: page.h: move and unify types for pagetable entry
	definitions
X-Mercurial-Node: 3bd7db6e85e66e7f3362874802df26a82fcb2d92
Message-Id: <3bd7db6e85e66e7f3362.1199391061@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:11:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Jeremy Fitzhardinge <jeremy@xensource.com>
# Date 1199319654 28800
# Node ID 3bd7db6e85e66e7f3362874802df26a82fcb2d92
# Parent  f7e7db3facd9406545103164f9be8f9ba1a2b549
x86: page.h: move and unify types for pagetable entry definitions

This patch:

1. Defines arch-specific types for the contents of a pagetable entry.
That is, 32-bit entries for 32-bit non-PAE, and 64-bit entries for
32-bit PAE and 64-bit.  However, even though the latter two are the
same size, they're defined with different types in order to retain
compatibility with printk format strings, etc.

2. Defines arch-specific pte_t.  This is different because 32-bit PAE
defines it in two halves, whereas 32-bit PAE and 64-bit define it as a
single entry.  All the other pagetable levels can be defined in a
common way.  This also defines arch-specific pte_val/make_pte functions.

3. Define PAGETABLE_LEVELS for each architecture variation, for later use.

4. Define common pagetable entry accessors in a paravirt-compatible
way. (64-bit does not yet use paravirt-ops in any way).

5. Convert a few instances of using a *_val() as an lvalue where it is
no longer a macro.  There are still places in the 64-bit code which
use pte_val() as an lvalue.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/page.h       |  139 +++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/page_32.h    |   83 -------------------------
 include/asm-x86/page_64.h    |   22 ------
 include/asm-x86/pgtable_64.h |    6 -
 4 files changed, 141 insertions(+), 109 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -9,6 +9,7 @@
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
+#define PTE_MASK		PHYSICAL_PAGE_MASK
 
 #define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
 #define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
@@ -21,11 +22,16 @@
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
-#define __PHYSICAL_MASK		((_AC(1,UL) << __PHYSICAL_MASK_SHIFT) - 1)
+#define __PHYSICAL_MASK		_AT(phys_addr_t, (_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
+#ifndef __ASSEMBLER__
+#include <linux/types.h>
+#endif
 
 #ifdef CONFIG_X86_64
+#define PAGETABLE_LEVELS	4
+
 #define THREAD_ORDER	1
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE-1))
@@ -73,6 +79,22 @@
 #ifndef __ASSEMBLY__
 void clear_page(void *page);
 void copy_page(void *to, void *from);
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef unsigned long	pteval_t;
+typedef unsigned long	pmdval_t;
+typedef unsigned long	pudval_t;
+typedef unsigned long	pgdval_t;
+typedef unsigned long	pgprotval_t;
+typedef unsigned long	phys_addr_t;
+
+typedef struct { pteval_t pte; } pte_t;
+
+#define native_pte_val(x)	((x).pte)
+#define native_make_pte(x) ((pte_t) { (x) } )
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif	/* CONFIG_X86_64 */
@@ -94,9 +116,57 @@ void copy_page(void *to, void *from);
 #ifdef CONFIG_X86_PAE
 #define __PHYSICAL_MASK_SHIFT	36
 #define __VIRTUAL_MASK_SHIFT	32
+#define PAGETABLE_LEVELS	3
+
+#ifndef __ASSEMBLY__
+typedef u64	pteval_t;
+typedef u64	pmdval_t;
+typedef u64	pudval_t;
+typedef u64	pgdval_t;
+typedef u64	pgprotval_t;
+typedef u64	phys_addr_t;
+
+typedef struct { unsigned long pte_low, pte_high; } pte_t;
+
+static inline unsigned long long native_pte_val(pte_t pte)
+{
+	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
+}
+
+static inline pte_t native_make_pte(unsigned long long val)
+{
+	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
+}
+
+#endif	/* __ASSEMBLY__
+ */
 #else  /* !CONFIG_X86_PAE */
 #define __PHYSICAL_MASK_SHIFT	32
 #define __VIRTUAL_MASK_SHIFT	32
+#define PAGETABLE_LEVELS	2
+
+#ifndef __ASSEMBLY__
+typedef unsigned long	pteval_t;
+typedef unsigned long	pmdval_t;
+typedef unsigned long	pudval_t;
+typedef unsigned long	pgdval_t;
+typedef unsigned long	pgprotval_t;
+typedef unsigned long	phys_addr_t;
+
+typedef struct { pteval_t pte_low; } pte_t;
+typedef pte_t boot_pte_t;
+
+static inline unsigned long native_pte_val(pte_t pte)
+{
+	return pte.pte_low;
+}
+
+static inline pte_t native_make_pte(unsigned long val)
+{
+	return (pte_t) { .pte_low = val };
+}
+
+#endif	/* __ASSEMBLY__ */
 #endif	/* CONFIG_X86_PAE */
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -159,6 +229,76 @@ static void inline copy_user_page(void *
 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
+typedef struct { pgdval_t pgd; } pgd_t;
+typedef struct { pgprotval_t pgprot; } pgprot_t;
+
+static inline pgd_t native_make_pgd(pgdval_t val)
+{
+	return (pgd_t) { val };
+}
+
+static inline pgdval_t native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+#if PAGETABLE_LEVELS >= 3
+#if PAGETABLE_LEVELS == 4
+typedef struct { pudval_t pud; } pud_t;
+
+static inline pud_t native_make_pud(pmdval_t val)
+{
+	return (pud_t) { val };
+}
+
+static inline pudval_t native_pud_val(pud_t pud)
+{
+	return pud.pud;
+}
+#else	/* PAGETABLE_LEVELS == 3 */
+#include <asm-generic/pgtable-nopud.h>
+#endif	/* PAGETABLE_LEVELS == 4 */
+
+typedef struct { pmdval_t pmd; } pmd_t;
+
+static inline pmd_t native_make_pmd(pmdval_t val)
+{
+	return (pmd_t) { val };
+}
+
+static inline pmdval_t native_pmd_val(pmd_t pmd)
+{
+	return pmd.pmd;
+}
+#else  /* PAGETABLE_LEVELS == 2 */
+#include <asm-generic/pgtable-nopmd.h>
+#endif	/* PAGETABLE_LEVELS >= 3 */
+
+#define pgprot_val(x)	((x).pgprot)
+#define __pgprot(x)	((pgprot_t) { (x) } )
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else  /* !CONFIG_PARAVIRT */
+
+#define pgd_val(x)	native_pgd_val(x)
+#define __pgd(x)	native_make_pgd(x)
+
+#ifndef __PAGETABLE_PUD_FOLDED
+#define pud_val(x)	native_pud_val(x)
+#define __pud(x)	native_make_pud(x)
+#endif
+
+#ifndef __PAGETABLE_PMD_FOLDED
+#define pmd_val(x)	native_pmd_val(x)
+#define __pmd(x)	native_make_pmd(x)
+#endif
+
+#define pte_val(x)	native_pte_val(x)
+#define __pte(x)	native_make_pte(x)
+
+#endif	/* CONFIG_PARAVIRT */
+
 #endif	/* __ASSEMBLY__ */
 
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -8,89 +8,6 @@
  * These are used to make use of C type-checking..
  */
 extern int nx_enabled;
-
-#ifdef CONFIG_X86_PAE
-typedef struct { unsigned long pte_low, pte_high; } pte_t;
-typedef struct { unsigned long long pmd; } pmd_t;
-typedef struct { unsigned long long pgd; } pgd_t;
-typedef struct { unsigned long long pgprot; } pgprot_t;
-
-static inline unsigned long long native_pgd_val(pgd_t pgd)
-{
-	return pgd.pgd;
-}
-
-static inline unsigned long long native_pmd_val(pmd_t pmd)
-{
-	return pmd.pmd;
-}
-
-static inline unsigned long long native_pte_val(pte_t pte)
-{
-	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
-}
-
-static inline pgd_t native_make_pgd(unsigned long long val)
-{
-	return (pgd_t) { val };
-}
-
-static inline pmd_t native_make_pmd(unsigned long long val)
-{
-	return (pmd_t) { val };
-}
-
-static inline pte_t native_make_pte(unsigned long long val)
-{
-	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
-}
-
-#ifndef CONFIG_PARAVIRT
-#define pmd_val(x)	native_pmd_val(x)
-#define __pmd(x)	native_make_pmd(x)
-#endif
-
-#include <asm-generic/pgtable-nopud.h>
-#else  /* !CONFIG_X86_PAE */
-typedef struct { unsigned long pte_low; } pte_t;
-typedef struct { unsigned long pgd; } pgd_t;
-typedef struct { unsigned long pgprot; } pgprot_t;
-#define boot_pte_t pte_t /* or would you rather have a typedef */
-
-static inline unsigned long native_pgd_val(pgd_t pgd)
-{
-	return pgd.pgd;
-}
-
-static inline unsigned long native_pte_val(pte_t pte)
-{
-	return pte.pte_low;
-}
-
-static inline pgd_t native_make_pgd(unsigned long val)
-{
-	return (pgd_t) { val };
-}
-
-static inline pte_t native_make_pte(unsigned long val)
-{
-	return (pte_t) { .pte_low = val };
-}
-
-#include <asm-generic/pgtable-nopmd.h>
-#endif	/* CONFIG_X86_PAE */
-
-#define PTE_MASK	PAGE_MASK
-
-#define pgprot_val(x)	((x).pgprot)
-#define __pgprot(x)	((pgprot_t) { (x) } )
-
-#ifndef CONFIG_PARAVIRT
-#define pgd_val(x)	native_pgd_val(x)
-#define __pgd(x)	native_make_pgd(x)
-#define pte_val(x)	native_pte_val(x)
-#define __pte(x)	native_make_pte(x)
-#endif
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -7,30 +7,8 @@ extern unsigned long end_pfn;
 extern unsigned long end_pfn;
 extern unsigned long end_pfn_map;
 
-/*
- * These are used to make use of C type-checking..
- */
-typedef struct { unsigned long pte; } pte_t;
-typedef struct { unsigned long pmd; } pmd_t;
-typedef struct { unsigned long pud; } pud_t;
-typedef struct { unsigned long pgd; } pgd_t;
-#define PTE_MASK	PHYSICAL_PAGE_MASK
-
-typedef struct { unsigned long pgprot; } pgprot_t;
 
 extern unsigned long phys_base;
-
-#define pte_val(x)	((x).pte)
-#define pmd_val(x)	((x).pmd)
-#define pud_val(x)	((x).pud)
-#define pgd_val(x)	((x).pgd)
-#define pgprot_val(x)	((x).pgprot)
-
-#define __pte(x) ((pte_t) { (x) } )
-#define __pmd(x) ((pmd_t) { (x) } )
-#define __pud(x) ((pud_t) { (x) } )
-#define __pgd(x) ((pgd_t) { (x) } )
-#define __pgprot(x)	((pgprot_t) { (x) } )
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -79,12 +79,12 @@ static inline void set_pte(pte_t *dst, p
 
 static inline void set_pmd(pmd_t *dst, pmd_t val)
 {
-        pmd_val(*dst) = pmd_val(val); 
+	*dst = val;
 } 
 
 static inline void set_pud(pud_t *dst, pud_t val)
 {
-	pud_val(*dst) = pud_val(val);
+	*dst = val;
 }
 
 static inline void pud_clear (pud_t *pud)
@@ -94,7 +94,7 @@ static inline void pud_clear (pud_t *pud
 
 static inline void set_pgd(pgd_t *dst, pgd_t val)
 {
-	pgd_val(*dst) = pgd_val(val); 
+	*dst = val;
 } 
 
 static inline void pgd_clear (pgd_t * pgd)


