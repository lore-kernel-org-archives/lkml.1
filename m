Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbXKHCeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbXKHCeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbXKHCdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:33:32 -0500
Received: from gw.goop.org ([64.81.55.164]:57058 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbXKHCdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:33:31 -0500
Message-Id: <20071108015310.218076184@goop.org>
References: <20071108015008.660012621@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Nov 2007 17:50:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Zach Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH RFC 3/7] x86: clean up asm-x86/page*.h
Content-Disposition: inline; filename=x86-unify-page_h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unify common definitions in page*.h.  To simplify other code, I added
typedefs for the value of pte/pmd/pud/pgd values, so they can be used
symbolically elsewhere without needing to have lots of 32/64/PAE
tests.

Also, add PAGETABLE_LEVELS define so that other definitions can test
for it directly rather than using indirect 32/64/PAE tests.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 include/asm-x86/page.h    |   49 ++++++++++++++++++++++------
 include/asm-x86/page_32.h |   77 +++++++++++++++++++++++++--------------------
 include/asm-x86/page_64.h |   37 +++++++--------------
 3 files changed, 95 insertions(+), 68 deletions(-)

===================================================================
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -1,13 +1,42 @@
+#ifndef _ASM_X86_PAGE_H
+#define _ASM_X86_PAGE_H
+
+#include <linux/const.h>
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT	12
+#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+#define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
+
+#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
+#define LARGE_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
+
 #ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "page_32.h"
-# else
-#  include "page_64.h"
-# endif
+
+#ifdef CONFIG_X86_32
+# include "page_32.h"
 #else
-# ifdef __i386__
-#  include "page_32.h"
-# else
-#  include "page_64.h"
-# endif
+# include "page_64.h"
 #endif
+
+#ifndef CONFIG_PARAVIRT
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
+#endif	/* CONFIG_PARAVIRT */
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_X86_PAGE_H */
===================================================================
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -1,16 +1,13 @@
 #ifndef _I386_PAGE_H
 #define _I386_PAGE_H
 
-/* PAGE_SHIFT determines the page size */
-#define PAGE_SHIFT	12
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
+#ifndef _ASM_X86_PAGE_H
+#error Include asm/page.h
+#endif
 
-#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)
+#ifndef __ASSEMBLY__
 
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
+#include <linux/types.h>
 
 #ifdef CONFIG_X86_USE_3DNOW
 
@@ -43,71 +40,86 @@
  */
 extern int nx_enabled;
 
+/* macro to avoid #include hell */
+#define native_pud_val(pud)	native_pgd_val((pud).pgd)
+
 #ifdef CONFIG_X86_PAE
+#define PAGETABLE_LEVELS	3
+
+typedef u64	pteval_t;
+typedef u64	pmdval_t;
+typedef u64	pudval_t;
+typedef u64	pgdval_t;
+
 typedef struct { unsigned long pte_low, pte_high; } pte_t;
-typedef struct { unsigned long long pmd; } pmd_t;
-typedef struct { unsigned long long pgd; } pgd_t;
+typedef struct { pmdval_t pmd; } pmd_t;
+typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { unsigned long long pgprot; } pgprot_t;
 
-static inline unsigned long long native_pgd_val(pgd_t pgd)
+static inline pgdval_t native_pgd_val(pgd_t pgd)
 {
 	return pgd.pgd;
 }
 
-static inline unsigned long long native_pmd_val(pmd_t pmd)
+static inline pmdval_t native_pmd_val(pmd_t pmd)
 {
 	return pmd.pmd;
 }
 
-static inline unsigned long long native_pte_val(pte_t pte)
+static inline pteval_t native_pte_val(pte_t pte)
 {
 	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
 }
 
-static inline pgd_t native_make_pgd(unsigned long long val)
+static inline pgd_t native_make_pgd(pgdval_t val)
 {
 	return (pgd_t) { val };
 }
 
-static inline pmd_t native_make_pmd(unsigned long long val)
+static inline pmd_t native_make_pmd(pmdval_t val)
 {
 	return (pmd_t) { val };
 }
 
-static inline pte_t native_make_pte(unsigned long long val)
+static inline pte_t native_make_pte(pteval_t val)
 {
 	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
 }
 
-#ifndef CONFIG_PARAVIRT
-#define pmd_val(x)	native_pmd_val(x)
-#define __pmd(x)	native_make_pmd(x)
-#endif
-
 #define HPAGE_SHIFT	21
 #include <asm-generic/pgtable-nopud.h>
 #else  /* !CONFIG_X86_PAE */
+
+#define PAGETABLE_LEVELS	2
+
+typedef u32	pteval_t;
+typedef u32	pmdval_t;
+typedef u32	pgdval_t;
+
 typedef struct { unsigned long pte_low; } pte_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
 #define boot_pte_t pte_t /* or would you rather have a typedef */
 
-static inline unsigned long native_pgd_val(pgd_t pgd)
+static inline pgdval_t native_pgd_val(pgd_t pgd)
 {
 	return pgd.pgd;
 }
 
-static inline unsigned long native_pte_val(pte_t pte)
+static inline pteval_t native_pte_val(pte_t pte)
 {
 	return pte.pte_low;
 }
 
-static inline pgd_t native_make_pgd(unsigned long val)
+/* macro to avoid #include hell */
+#define native_pmd_val(pmd)	native_pud_val((pmd).pud)
+
+static inline pgd_t native_make_pgd(pgdval_t val)
 {
 	return (pgd_t) { val };
 }
 
-static inline pte_t native_make_pte(unsigned long val)
+static inline pte_t native_make_pte(pteval_t val)
 {
 	return (pte_t) { .pte_low = val };
 }
@@ -127,13 +139,6 @@ static inline pte_t native_make_pte(unsi
 
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
-
-#ifndef CONFIG_PARAVIRT
-#define pgd_val(x)	native_pgd_val(x)
-#define __pgd(x)	native_make_pgd(x)
-#define pte_val(x)	native_pte_val(x)
-#define __pte(x)	native_make_pte(x)
-#endif
 
 #endif /* !__ASSEMBLY__ */
 
@@ -175,6 +180,13 @@ extern int page_is_ram(unsigned long pag
 #define __PAGE_OFFSET		((unsigned long)CONFIG_PAGE_OFFSET)
 #endif
 
+#ifdef CONFIG_X86_PAE
+#define __PHYSICAL_MASK_SHIFT	36
+#else
+#define __PHYSICAL_MASK_SHIFT	32
+#endif
+
+#define __PHYSICAL_MASK		((_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)
 
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
@@ -201,6 +213,5 @@ extern int page_is_ram(unsigned long pag
 #include <asm-generic/page.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
-#endif /* __KERNEL__ */
 
 #endif /* _I386_PAGE_H */
===================================================================
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -1,13 +1,13 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
 
+#ifndef _ASM_X86_PAGE_H
+#error Include asm/page.h
+#endif
+
 #include <linux/const.h>
 
-/* PAGE_SHIFT determines the page size */
-#define PAGE_SHIFT	12
-#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
-#define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
+#define PAGETABLE_LEVELS	4
 
 #define THREAD_ORDER 1 
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
@@ -29,16 +29,14 @@
 #define MCE_STACK 5
 #define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
-#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
-
 #define HPAGE_SHIFT PMD_SHIFT
 #define HPAGE_SIZE	(_AC(1,UL) << HPAGE_SHIFT)
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
+
+#include <linux/types.h>
 
 extern unsigned long end_pfn;
 
@@ -59,6 +57,11 @@ typedef struct { unsigned long pud; } pu
 typedef struct { unsigned long pud; } pud_t;
 typedef struct { unsigned long pgd; } pgd_t;
 #define PTE_MASK	PHYSICAL_PAGE_MASK
+
+typedef u64	pteval_t;
+typedef u64	pmdval_t;
+typedef u64	pudval_t;
+typedef u64	pgdval_t;
 
 typedef struct { unsigned long pgprot; } pgprot_t;
 
@@ -104,20 +107,6 @@ static inline pgd_t native_make_pgd(unsi
 {
 	return (pgd_t){ pgd };
 }
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define pte_val(x)	native_pte_val(x)
-#define pmd_val(x)	native_pmd_val(x)
-#define pud_val(x)	native_pud_val(x)
-#define pgd_val(x)	native_pgd_val(x)
-
-#define __pte(x) ((pte_t) { (x) } )
-#define __pmd(x) ((pmd_t) { (x) } )
-#define __pud(x) ((pud_t) { (x) } )
-#define __pgd(x) ((pgd_t) { (x) } )
-#endif /* CONFIG_PARAVIRT */
 
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
@@ -185,6 +174,4 @@ extern unsigned long __phys_addr(unsigne
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _X86_64_PAGE_H */

-- 

