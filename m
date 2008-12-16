Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbYLPLsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbYLPLsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYLPLsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:48:32 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:40018 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYLPLsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:48:32 -0500
Message-Id: <4947A3B3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:48:51 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: consolidate __swp_...() macros
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the resend, the XXX in the original subject was rejected by lkml.)

The __swp_...() macros silently relied upon which bits are used for
_PAGE_FILE and _PAGE_PROTNONE. After having changed _PAGE_PROTNONE in
our Xen kernel to no longer overlap _PAGE_PAT, live locks and crashes
were reported that could have been avoided if these macros properly
used the symbolic constants. Since, as pointed out earlier, for Xen
Dom0 support mainline likewise will need to eliminate the conflict
between _PAGE_PAT and _PAGE_PROTNONE, this patch does all the necessary
adjustments, plus it introduces a mechanism to check consistency
between MAX_SWAPFILES_SHIFT and the actual encoding macros.

This also fixes a latent bug in that x86-64 used a 6-bit mask in
__swp_type(), and if MAX_SWAPFILES_SHIFT was increased beyond 5 in (the
seemingly unrelated) linux/swap.h, this would have resulted in a
collision with _PAGE_FILE.

Non-PAE 32-bit code gets similarly adjusted for its pte_to_pgoff() and
pgoff_to_pte() calculations.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

---
 arch/x86/include/asm/pgtable-2level.h |   50 +++++++++++++++++++++++++++-------
 arch/x86/include/asm/pgtable-3level.h |    1 
 arch/x86/include/asm/pgtable.h        |   14 +++++----
 arch/x86/include/asm/pgtable_64.h     |   20 ++++++++++---
 mm/swapfile.c                         |    9 ++++++
 5 files changed, 75 insertions(+), 19 deletions(-)

--- linux-2.6.28-rc8/arch/x86/include/asm/pgtable-2level.h	2008-12-11 14:36:51.000000000 +0100
+++ 2.6.28-rc8-x86-swp-entry/arch/x86/include/asm/pgtable-2level.h	2008-10-24 10:53:47.000000000 +0200
@@ -56,23 +56,55 @@ static inline pte_t native_ptep_get_and_
 #define pte_none(x)		(!(x).pte_low)
 
 /*
- * Bits 0, 6 and 7 are taken, split up the 29 bits of offset
- * into this range:
+ * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE and _PAGE_BIT_PROTNONE are taken,
+ * split up the 29 bits of offset into this range:
  */
 #define PTE_FILE_MAX_BITS	29
+#define PTE_FILE_SHIFT1		(_PAGE_BIT_PRESENT + 1)
+#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
+#define PTE_FILE_SHIFT2		(_PAGE_BIT_FILE + 1)
+#define PTE_FILE_SHIFT3		(_PAGE_BIT_PROTNONE + 1)
+#else
+#define PTE_FILE_SHIFT2		(_PAGE_BIT_PROTNONE + 1)
+#define PTE_FILE_SHIFT3		(_PAGE_BIT_FILE + 1)
+#endif
+#define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
+#define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 
 #define pte_to_pgoff(pte)						\
-	((((pte).pte_low >> 1) & 0x1f) + (((pte).pte_low >> 8) << 5))
+	((((pte).pte_low >> PTE_FILE_SHIFT1)				\
+	  & ((1U << PTE_FILE_BITS1) - 1))				\
+	 + ((((pte).pte_low >> PTE_FILE_SHIFT2)				\
+	     & ((1U << PTE_FILE_BITS2) - 1)) << PTE_FILE_BITS1)		\
+	 + (((pte).pte_low >> PTE_FILE_SHIFT3)				\
+	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2)))
 
 #define pgoff_to_pte(off)						\
-	((pte_t) { .pte_low = (((off) & 0x1f) << 1) +			\
-			(((off) >> 5) << 8) + _PAGE_FILE })
+	((pte_t) { .pte_low =						\
+	 (((off) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
+	 + ((((off) >> PTE_FILE_BITS1) & ((1U << PTE_FILE_BITS2) - 1))	\
+	    << PTE_FILE_SHIFT2)						\
+	 + (((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
+	    << PTE_FILE_SHIFT3)						\
+	 + _PAGE_FILE })
 
 /* Encode and de-code a swap entry */
-#define __swp_type(x)			(((x).val >> 1) & 0x1f)
-#define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)				\
-	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
+#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
+#define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
+#define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
+#else
+#define SWP_TYPE_BITS (_PAGE_BIT_PROTNONE - _PAGE_BIT_PRESENT - 1)
+#define SWP_OFFSET_SHIFT (_PAGE_BIT_FILE + 1)
+#endif
+
+#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
+
+#define __swp_type(x)			(((x).val >> (_PAGE_BIT_PRESENT + 1)) \
+					 & ((1U << SWP_TYPE_BITS) - 1))
+#define __swp_offset(x)			((x).val >> SWP_OFFSET_SHIFT)
+#define __swp_entry(type, offset)	((swp_entry_t) { \
+					 ((type) << (_PAGE_BIT_PRESENT + 1)) \
+					 | ((offset) << SWP_OFFSET_SHIFT) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
--- linux-2.6.28-rc8/arch/x86/include/asm/pgtable-3level.h	2008-12-11 14:36:51.000000000 +0100
+++ 2.6.28-rc8-x86-swp-entry/arch/x86/include/asm/pgtable-3level.h	2008-10-24 10:53:47.000000000 +0200
@@ -166,6 +166,7 @@ static inline int pte_none(pte_t pte)
 #define PTE_FILE_MAX_BITS       32
 
 /* Encode and de-code a swap entry */
+#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > 5)
 #define __swp_type(x)			(((x).val) & 0x1f)
 #define __swp_offset(x)			((x).val >> 5)
 #define __swp_entry(type, offset)	((swp_entry_t){(type) | (offset) << 5})
--- linux-2.6.28-rc8/arch/x86/include/asm/pgtable.h	2008-12-11 14:36:51.000000000 +0100
+++ 2.6.28-rc8-x86-swp-entry/arch/x86/include/asm/pgtable.h	2008-10-24 10:53:47.000000000 +0200
@@ -10,7 +10,6 @@
 #define _PAGE_BIT_PCD		4	/* page cache disabled */
 #define _PAGE_BIT_ACCESSED	5	/* was accessed (raised by CPU) */
 #define _PAGE_BIT_DIRTY		6	/* was written to (raised by CPU) */
-#define _PAGE_BIT_FILE		6
 #define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
 #define _PAGE_BIT_PAT		7	/* on 4KB pages */
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
@@ -22,6 +21,12 @@
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_UNUSED1
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
+/* If _PAGE_BIT_PRESENT is clear, we use these: */
+/* - if the user mapped it with PROT_NONE; pte_present gives true */
+#define _PAGE_BIT_PROTNONE	_PAGE_BIT_GLOBAL
+/* - set: nonlinear file mapping, saved PTE; unset:swap */
+#define _PAGE_BIT_FILE		_PAGE_BIT_DIRTY
+
 #define _PAGE_PRESENT	(_AT(pteval_t, 1) << _PAGE_BIT_PRESENT)
 #define _PAGE_RW	(_AT(pteval_t, 1) << _PAGE_BIT_RW)
 #define _PAGE_USER	(_AT(pteval_t, 1) << _PAGE_BIT_USER)
@@ -46,11 +51,8 @@
 #define _PAGE_NX	(_AT(pteval_t, 0))
 #endif
 
-/* If _PAGE_PRESENT is clear, we use these: */
-#define _PAGE_FILE	_PAGE_DIRTY	/* nonlinear file mapping,
-					 * saved PTE; unset:swap */
-#define _PAGE_PROTNONE	_PAGE_PSE	/* if the user mapped it with PROT_NONE;
-					   pte_present gives true */
+#define _PAGE_FILE	(_AT(pteval_t, 1) << _PAGE_BIT_FILE)
+#define _PAGE_PROTNONE	(_AT(pteval_t, 1) << _PAGE_BIT_PROTNONE)
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |	\
 			 _PAGE_ACCESSED | _PAGE_DIRTY)
--- linux-2.6.28-rc8/arch/x86/include/asm/pgtable_64.h	2008-12-11 14:36:51.000000000 +0100
+++ 2.6.28-rc8-x86-swp-entry/arch/x86/include/asm/pgtable_64.h	2008-10-24 10:53:47.000000000 +0200
@@ -250,10 +250,22 @@ static inline int pud_large(pud_t pte)
 extern int direct_gbpages;
 
 /* Encode and de-code a swap entry */
-#define __swp_type(x)			(((x).val >> 1) & 0x3f)
-#define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | \
-							 ((offset) << 8) })
+#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
+#define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
+#define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
+#else
+#define SWP_TYPE_BITS (_PAGE_BIT_PROTNONE - _PAGE_BIT_PRESENT - 1)
+#define SWP_OFFSET_SHIFT (_PAGE_BIT_FILE + 1)
+#endif
+
+#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
+
+#define __swp_type(x)			(((x).val >> (_PAGE_BIT_PRESENT + 1)) \
+					 & ((1U << SWP_TYPE_BITS) - 1))
+#define __swp_offset(x)			((x).val >> SWP_OFFSET_SHIFT)
+#define __swp_entry(type, offset)	((swp_entry_t) { \
+					 ((type) << (_PAGE_BIT_PRESENT + 1)) \
+					 | ((offset) << SWP_OFFSET_SHIFT) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val((pte)) })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
--- linux-2.6.28-rc8/mm/swapfile.c	2008-12-11 14:37:27.000000000 +0100
+++ 2.6.28-rc8-x86-swp-entry/mm/swapfile.c	2008-10-24 10:53:47.000000000 +0200
@@ -1462,6 +1462,15 @@ static int __init procswaps_init(void)
 __initcall(procswaps_init);
 #endif /* CONFIG_PROC_FS */
 
+#ifdef MAX_SWAPFILES_CHECK
+static int __init max_swapfiles_check(void)
+{
+	MAX_SWAPFILES_CHECK();
+	return 0;
+}
+late_initcall(max_swapfiles_check);
+#endif
+
 /*
  * Written 01/25/92 by Simmule Turner, heavily changed by Linus.
  *


