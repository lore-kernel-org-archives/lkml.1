Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYGaSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYGaSsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYGaSsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:48:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:53729 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbYGaSsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:48:42 -0400
Date: Thu, 31 Jul 2008 13:48:31 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linuxppc-dev@ozlabs.org
cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, npiggin@suse.de
Subject: [PATCH] powerpc/mm: Implement _PAGE_SPECIAL & pte_special() for
 32-bit
Message-ID: <Pine.LNX.4.64.0807311345380.8012@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement _PAGE_SPECIAL and pte_special() for 32-bit powerpc. This bit will
be used by the fast get_user_pages() to differenciate PTEs that correspond
to a valid struct page from special mappings that don't such as IO mappings
obtained via io_remap_pfn_ranges().

We currently only implement this on sub-arch that support SMP or will so
in the future (6xx, 44x, FSL-BookE) and not (8xx, 40x).

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
Nick, do you forsee using _PAGE_SPECIAL for other applications that would
be of interested to non-SMP hw?

We can look at adding it into 8xx and 40x, but was being lazy as I assume
there is no point.

- k

 include/asm-powerpc/pgtable-ppc32.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/asm-powerpc/pgtable-ppc32.h b/include/asm-powerpc/pgtable-ppc32.h
index 6fe39e3..58afaee 100644
--- a/include/asm-powerpc/pgtable-ppc32.h
+++ b/include/asm-powerpc/pgtable-ppc32.h
@@ -261,6 +261,7 @@ extern int icache_44x_need_flush;
 #define _PAGE_HWEXEC	0x00000004		/* H: Execute permission */
 #define _PAGE_ACCESSED	0x00000008		/* S: Page referenced */
 #define _PAGE_DIRTY	0x00000010		/* S: Page dirty */
+#define _PAGE_SPECIAL	0x00000020		/* S: Special page */
 #define _PAGE_USER	0x00000040		/* S: User page */
 #define _PAGE_ENDIAN	0x00000080		/* H: E bit */
 #define _PAGE_GUARDED	0x00000100		/* H: G bit */
@@ -276,6 +277,7 @@ extern int icache_44x_need_flush;
 /* ERPN in a PTE never gets cleared, ignore it */
 #define _PTE_NONE_MASK	0xffffffff00000000ULL

+#define __HAVE_ARCH_PTE_SPECIAL

 #elif defined(CONFIG_FSL_BOOKE)
 /*
@@ -305,6 +307,7 @@ extern int icache_44x_need_flush;
 #define _PAGE_COHERENT	0x00100	/* H: M bit */
 #define _PAGE_NO_CACHE	0x00200	/* H: I bit */
 #define _PAGE_WRITETHRU	0x00400	/* H: W bit */
+#define _PAGE_SPECIAL	0x00800 /* S: Special page */

 #ifdef CONFIG_PTE_64BIT
 /* ERPN in a PTE never gets cleared, ignore it */
@@ -315,6 +318,8 @@ extern int icache_44x_need_flush;
 #define _PMD_PRESENT_MASK (PAGE_MASK)
 #define _PMD_BAD	(~PAGE_MASK)

+#define __HAVE_ARCH_PTE_SPECIAL
+
 #elif defined(CONFIG_8xx)
 /* Definitions for 8xx embedded chips. */
 #define _PAGE_PRESENT	0x0001	/* Page is valid */
@@ -362,6 +367,7 @@ extern int icache_44x_need_flush;
 #define _PAGE_ACCESSED	0x100	/* R: page referenced */
 #define _PAGE_EXEC	0x200	/* software: i-cache coherency required */
 #define _PAGE_RW	0x400	/* software: user write access allowed */
+#define _PAGE_SPECIAL	0x800	/* software: Special page */

 #define _PTE_NONE_MASK	_PAGE_HASHPTE

@@ -372,6 +378,8 @@ extern int icache_44x_need_flush;
 /* Hash table based platforms need atomic updates of the linux PTE */
 #define PTE_ATOMIC_UPDATES	1

+#define __HAVE_ARCH_PTE_SPECIAL
+
 #endif

 /*
@@ -404,6 +412,9 @@ extern int icache_44x_need_flush;
 #ifndef _PAGE_WRITETHRU
 #define _PAGE_WRITETHRU	0
 #endif
+#ifndef _PAGE_SPECIAL
+#define _PAGE_SPECIAL	0
+#endif
 #ifndef _PMD_PRESENT_MASK
 #define _PMD_PRESENT_MASK	_PMD_PRESENT
 #endif
@@ -533,7 +544,7 @@ static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
-static inline int pte_special(pte_t pte)	{ return 0; }
+static inline int pte_special(pte_t pte)	{ return pte_val(pte) & _PAGE_SPECIAL; }

 static inline void pte_uncache(pte_t pte)       { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)         { pte_val(pte) &= ~_PAGE_NO_CACHE; }
@@ -552,7 +563,7 @@ static inline pte_t pte_mkdirty(pte_t pte) {
 static inline pte_t pte_mkyoung(pte_t pte) {
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
-	return pte; }
+	pte_val(pte) |= _PAGE_SPECIAL; return pte; }
 static inline unsigned long pte_pgprot(pte_t pte)
 {
 	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS;
-- 
1.5.5.1

