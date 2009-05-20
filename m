Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZETSdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZETSdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZETS0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:26:04 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58025 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbZETSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:45 -0400
Subject: [RFC v2][PATCH 33/35] asm-generic/ptemap.h for HIGHPTE implementations
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:37 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182537.AB63BEB5@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86 and frv have identical CONFIG_HIGHPTE implementations
of the pte mapping functions.  Consolidate and move these
to asm-generic/ptemap.h.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/frv/include/asm/ptemap.h  |   14 --------------
 linux-2.6.git-dave/arch/x86/include/asm/ptemap.h  |   19 -------------------
 linux-2.6.git-dave/include/asm-generic/ptemap.h   |   20 ++++++++++++++++++++
 linux-2.6.git-dave/orphan.dir/ptemap-overview.txt |   12 ++++++++++++
 4 files changed, 32 insertions(+), 33 deletions(-)

diff -puN arch/frv/include/asm/ptemap.h~asm-generic-ptemap-h-highpte arch/frv/include/asm/ptemap.h
--- linux-2.6.git/arch/frv/include/asm/ptemap.h~asm-generic-ptemap-h-highpte	2009-05-20 10:58:55.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/include/asm/ptemap.h	2009-05-20 10:58:55.000000000 -0700
@@ -1,15 +1 @@
-#ifndef _FRV_ASM_PTEMAP_H
-#define _FRV_ASM_PTEMAP_H
-
-#if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
-#define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
-#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
-#else
 #include <asm-generic/ptemap.h>
-#endif
-
-#endif /* _FRV_ASM_PTEMAP_H */
diff -puN arch/x86/include/asm/ptemap.h~asm-generic-ptemap-h-highpte arch/x86/include/asm/ptemap.h
--- linux-2.6.git/arch/x86/include/asm/ptemap.h~asm-generic-ptemap-h-highpte	2009-05-20 10:58:55.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/ptemap.h	2009-05-20 10:58:55.000000000 -0700
@@ -1,20 +1 @@
-#ifndef _X86_ASM_PTEMAP_H
-#define _X86_ASM_PTEMAP_H
-
-#if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
-	 pte_index((address)))
-#define pte_offset_map_nested(dir, address)				\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
-	 pte_index((address)))
-#define pte_unmap(pte) kunmap_atomic((pte), KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
-
-#else /* !CONFIG_HIGHPTE */
-
 #include <asm-generic/ptemap.h>
-
-#endif
-
-#endif /* _X86_ASM_PTEMAP_H */
diff -puN include/asm-generic/ptemap.h~asm-generic-ptemap-h-highpte include/asm-generic/ptemap.h
--- linux-2.6.git/include/asm-generic/ptemap.h~asm-generic-ptemap-h-highpte	2009-05-20 10:58:55.000000000 -0700
+++ linux-2.6.git-dave/include/asm-generic/ptemap.h	2009-05-20 10:59:13.000000000 -0700
@@ -5,11 +5,31 @@
  * If your architecture has direct-mapped pte pages (no HIGHPTE)
  * then you just need to implement pte_offset_kernel() and include
  * this in your asm/ptemap.h.
+ *
+ * To support HIGHPTE, you need to have implementations of
+ * kmap_atomic_pte() (which usually just calls kmap_atomic()),
+ * pmd_page() and pmd_index().
  */
 
+#include <linux/mm.h>
+
+#ifdef CONFIG_HIGHPTE
+
+#include <asm/highmem.h>
+#define pte_offset_map(dir, address) \
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+#define pte_offset_map_nested(dir, address) \
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
+#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
+#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+
+#else /* !CONFIG_HIGHPTE */
+
 #define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
 #define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
 #define pte_unmap(pte)			do { } while (0)
 #define pte_unmap_nested(pte)		do { } while (0)
 
+#endif /* CONFIG_HIGHPTE */
+
 #endif /* _ASM_GENERIC_PTEMAP_H */
diff -puN orphan.dir/ptemap-overview.txt~asm-generic-ptemap-h-highpte orphan.dir/ptemap-overview.txt
