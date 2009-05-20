Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZETSdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZETSdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZETSZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44499 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbZETSZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:39 -0400
Subject: [RFC v2][PATCH 34/35] powerpc use generic ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:38 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182538.3CAE37FD@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


powerpc is a bid of an oddball here.  It seems to have CONFIG_HIGHPTE
behavior at all times when compiled as 32-bit.  There's even an
#ifdef CONFIG_HIGHPTE in arch/powerpc/mm/pgtable_32.c, but there's no
trace of HIGHPTE in Kconfig anywhere.

This gives ppc32 an explicit HIGHPTE in Kconfig so that we can use
the #ifdef in asm-generic/ptemap.h and let ppc use the generic code
with x86 and frv.

It also removes the HIGHPTE #ifdef on ppc32 since it will be on
unconditionally.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/powerpc/Kconfig              |   14 ++++++++++++++
 linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h |   14 ++------------
 linux-2.6.git-dave/arch/powerpc/mm/pgtable_32.c      |    4 ----
 linux-2.6.git-dave/orphan.dir/ptemap-overview.txt    |    5 +++++
 4 files changed, 21 insertions(+), 16 deletions(-)

diff -puN arch/powerpc/include/asm/ptemap.h~powerpc-pte_offset_kernel arch/powerpc/include/asm/ptemap.h
--- linux-2.6.git/arch/powerpc/include/asm/ptemap.h~powerpc-pte_offset_kernel	2009-05-20 10:58:56.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h	2009-05-20 10:58:56.000000000 -0700
@@ -2,19 +2,9 @@
 #define _POWERPC_ASM_PTEMAP_H
 
 #ifndef __powerpc64__
-
-#define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
-#define pte_offset_map_nested(dir, addr)	\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
-
-#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
-
-#else /* __powerpc64__ */
+#define kmap_atomic_pte(page, type) kmap_atomic(page, type)
+#endif
 
 #include <asm-generic/ptemap.h>
 
-#endif
-
 #endif /* _POWERPC_ASM_PTEMAP_H */
diff -puN arch/powerpc/Kconfig~powerpc-pte_offset_kernel arch/powerpc/Kconfig
--- linux-2.6.git/arch/powerpc/Kconfig~powerpc-pte_offset_kernel	2009-05-20 10:58:56.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/Kconfig	2009-05-20 11:05:58.000000000 -0700
@@ -248,6 +248,20 @@ config HIGHMEM
 	bool "High memory support"
 	depends on PPC32
 
+config HIGHPTE
+	bool "Put PTE pages in high memory"
+	default n
+	depends on HIGHMEM && 6xx && EXPERIMENTAL
+	---help---
+	  The VM uses one page table entry for each page of physical memory.
+	  For 32-bit systems with a lot of RAM, this can be wasteful of
+	  precious low memory.  Setting this option will put user-space page
+	  table entries in high memory.
+
+	  This option is highly experimental.  Do not enable unless you are
+	  testing the VM.
+
+
 source kernel/time/Kconfig
 source kernel/Kconfig.hz
 source kernel/Kconfig.preempt
diff -puN arch/powerpc/mm/pgtable_32.c~powerpc-pte_offset_kernel arch/powerpc/mm/pgtable_32.c
--- linux-2.6.git/arch/powerpc/mm/pgtable_32.c~powerpc-pte_offset_kernel	2009-05-20 10:58:56.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/mm/pgtable_32.c	2009-05-20 10:58:56.000000000 -0700
@@ -114,11 +114,7 @@ pgtable_t pte_alloc_one(struct mm_struct
 {
 	struct page *ptepage;
 
-#ifdef CONFIG_HIGHPTE
 	gfp_t flags = GFP_KERNEL | __GFP_HIGHMEM | __GFP_REPEAT | __GFP_ZERO;
-#else
-	gfp_t flags = GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO;
-#endif
 
 	ptepage = alloc_pages(flags, 0);
 	if (!ptepage)
