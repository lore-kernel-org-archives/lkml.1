Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZETSbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZETSbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZETSZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52063 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbZETSZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:30 -0400
Subject: [RFC v2][PATCH 28/35] mips: use pte_offset_kernel() as base for pte_offset_map*()
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:29 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182529.0B43B8BD@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some architectures use pte_offset_map() as a basis for
pte_offset_kernel().  Others do the inverse.

Although arbitrary, Using pte_offset_kernel() as the base
seems a wee bit more popular and it also fits in well
with the way I'm breaking out the headers.

Instead of coding the same implementation twice, this
makes pte_offset_map{,_nested}() call pte_offset_kernel()
directly.

On MIPS, it is also obvious at this point that the 32 and
64-bit implementations are identical.  Coalesce them.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/mips/include/asm/pgtable-32.h |    3 +--
 linux-2.6.git-dave/arch/mips/include/asm/pgtable-64.h |    3 +--
 linux-2.6.git-dave/arch/mips/include/asm/ptemap.h     |   17 ++---------------
 3 files changed, 4 insertions(+), 19 deletions(-)

diff -puN arch/mips/include/asm/pgtable-32.h~mips-pte_offset_kernel arch/mips/include/asm/pgtable-32.h
--- linux-2.6.git/arch/mips/include/asm/pgtable-32.h~mips-pte_offset_kernel	2009-04-30 15:11:09.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/pgtable-32.h	2009-04-30 15:11:09.000000000 -0700
@@ -149,8 +149,7 @@ pfn_pte(unsigned long pfn, pgprot_t prot
 	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset(dir, address)					\
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-#define pte_offset_kernel(dir, address)					\
-	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+#define pte_offset_kernel(dir, address) pte_offset(dir, address)
 #include <asm/ptemap.h>
 
 #if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
diff -puN arch/mips/include/asm/pgtable-64.h~mips-pte_offset_kernel arch/mips/include/asm/pgtable-64.h
--- linux-2.6.git/arch/mips/include/asm/pgtable-64.h~mips-pte_offset_kernel	2009-04-30 15:11:09.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/pgtable-64.h	2009-04-30 15:11:09.000000000 -0700
@@ -213,8 +213,7 @@ static inline pmd_t *pmd_offset(pud_t * 
 	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset(dir, address)					\
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-#define pte_offset_kernel(dir, address)					\
-	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+#define pte_offset_kernel(dir, address)	pte_offset(dir, address)
 #include <asm/ptemap.h>
 /*
  * Initialize a new pgd / pmd table with invalid pointers.
diff -puN arch/mips/include/asm/ptemap.h~mips-pte_offset_kernel arch/mips/include/asm/ptemap.h
--- linux-2.6.git/arch/mips/include/asm/ptemap.h~mips-pte_offset_kernel	2009-04-30 15:11:09.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/ptemap.h	2009-04-30 15:11:09.000000000 -0700
@@ -1,22 +1,9 @@
 #ifndef _MIPS_ASM_PTEMAP_H
 #define _MIPS_ASM_PTEMAP_H
 
-#ifdef CONFIG_32BIT
-#define pte_offset_map(dir, address)                                    \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)                             \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
+#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
 #define pte_unmap(pte) ((void)(pte))
 #define pte_unmap_nested(pte) ((void)(pte))
-#endif
-
-#ifdef CONFIG_64BIT
-#define pte_offset_map(dir, address)					\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)				\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_unmap(pte) ((void)(pte))
-#define pte_unmap_nested(pte) ((void)(pte))
-#endif
 
 #endif /* _MIPS_ASM_PTEMAP_H */
_
