Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbZETSaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbZETSaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbZETSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35144 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbZETSZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:23 -0400
Subject: [RFC v2][PATCH 14/35] powerpc: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:07 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182507.3317D55D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/powerpc/include/asm/pgtable-ppc32.h |    8 ----
 linux-2.6.git-dave/arch/powerpc/include/asm/pgtable-ppc64.h |    5 --
 linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h        |   23 ++++++++++++
 3 files changed, 24 insertions(+), 12 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable-ppc32.h~powerpc-ptemaph arch/powerpc/include/asm/pgtable-ppc32.h
--- linux-2.6.git/arch/powerpc/include/asm/pgtable-ppc32.h~powerpc-ptemaph	2009-04-30 15:11:00.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/include/asm/pgtable-ppc32.h	2009-04-30 15:11:00.000000000 -0700
@@ -284,14 +284,6 @@ static inline void __ptep_set_access_fla
 	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir, addr)	\
 	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
-#define pte_offset_map_nested(dir, addr)	\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
-
-#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
-
 /*
  * Encode and decode a swap entry.
  * Note that the bits we use in a PTE for representing a swap entry
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-ptemaph arch/powerpc/include/asm/pgtable-ppc64.h
--- linux-2.6.git/arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-ptemaph	2009-04-30 15:11:00.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/include/asm/pgtable-ppc64.h	2009-04-30 15:11:00.000000000 -0700
@@ -162,10 +162,7 @@
 #define pte_offset_kernel(dir,addr) \
   (((pte_t *) pmd_page_vaddr(*(dir))) + (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir), (addr))
-#define pte_unmap(pte)			do { } while(0)
-#define pte_unmap_nested(pte)		do { } while(0)
+#include <asm/ptemap.h>
 
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
diff -puN /dev/null arch/powerpc/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h	2009-04-30 15:11:00.000000000 -0700
@@ -0,0 +1,23 @@
+#ifndef _POWERPC_ASM_PTEMAP_H
+#define _POWERPC_ASM_PTEMAP_H
+
+#ifndef __powerpc64__
+
+#define pte_offset_map(dir, addr)		\
+	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
+#define pte_offset_map_nested(dir, addr)	\
+	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
+
+#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
+#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
+
+#else /* __powerpc64__ */
+
+#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
+#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir), (addr))
+#define pte_unmap(pte)			do { } while(0)
+#define pte_unmap_nested(pte)		do { } while(0)
+
+#endif
+
+#endif /* _POWERPC_ASM_PTEMAP_H */
_
