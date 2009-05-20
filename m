Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZETSaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZETSaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZETSZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35464 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbZETSZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:27 -0400
Subject: [RFC v2][PATCH 19/35] x86: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:15 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182515.159B1E09@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/include/asm/pgtable_32.h |   17 ---------
 linux-2.6.git-dave/arch/x86/include/asm/pgtable_64.h |    6 ---
 linux-2.6.git-dave/arch/x86/include/asm/ptemap.h     |   34 +++++++++++++++++++
 3 files changed, 36 insertions(+), 21 deletions(-)

diff -puN arch/x86/include/asm/pgtable_32.h~x86-ptemaph arch/x86/include/asm/pgtable_32.h
--- linux-2.6.git/arch/x86/include/asm/pgtable_32.h~x86-ptemaph	2009-04-30 15:11:03.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable_32.h	2009-04-30 15:11:03.000000000 -0700
@@ -48,22 +48,7 @@ extern void set_pmd_pfn(unsigned long, u
 # include <asm/pgtable-2level.h>
 #endif
 
-#if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
-	 pte_index((address)))
-#define pte_offset_map_nested(dir, address)				\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
-	 pte_index((address)))
-#define pte_unmap(pte) kunmap_atomic((pte), KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
-#else
-#define pte_offset_map(dir, address)					\
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))
-#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-#endif
+#include <asm/ptemap.h>
 
 /* Clear a kernel PTE and flush it from the TLB */
 #define kpte_clear_flush(ptep, vaddr)		\
diff -puN arch/x86/include/asm/pgtable_64.h~x86-ptemaph arch/x86/include/asm/pgtable_64.h
--- linux-2.6.git/arch/x86/include/asm/pgtable_64.h~x86-ptemaph	2009-04-30 15:11:03.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable_64.h	2009-04-30 15:11:03.000000000 -0700
@@ -127,11 +127,7 @@ static inline int pgd_large(pgd_t pgd) {
 
 /* PTE - Level 1 access. */
 
-/* x86-64 always has all page tables mapped. */
-#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
-#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
-#define pte_unmap(pte) /* NOP */
-#define pte_unmap_nested(pte) /* NOP */
+#include <asm/ptemap.h>
 
 #define update_mmu_cache(vma, address, pte) do { } while (0)
 
diff -puN /dev/null arch/x86/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/ptemap.h	2009-04-30 15:11:03.000000000 -0700
@@ -0,0 +1,34 @@
+#ifndef _X86_ASM_PTEMAP_H
+#define _X86_ASM_PTEMAP_H
+
+#ifdef CONFIG_X86_32
+
+#if defined(CONFIG_HIGHPTE)
+
+#define pte_offset_map(dir, address)					\
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
+	 pte_index((address)))
+#define pte_offset_map_nested(dir, address)				\
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
+	 pte_index((address)))
+#define pte_unmap(pte) kunmap_atomic((pte), KM_PTE0)
+#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+#else
+#define pte_offset_map(dir, address)					\
+	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))
+#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
+#define pte_unmap(pte) do { } while (0)
+#define pte_unmap_nested(pte) do { } while (0)
+#endif
+
+#else /* x86-64 */
+
+/* x86-64 always has all page tables mapped. */
+#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
+#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
+#define pte_unmap(pte) /* NOP */
+#define pte_unmap_nested(pte) /* NOP */
+
+#endif
+
+#endif /* _X86_ASM_PTEMAP_H */
_
