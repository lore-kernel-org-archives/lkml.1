Return-Path: <linux-kernel-owner+w=401wt.eu-S1765027AbZEAOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765027AbZEAOyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762615AbZEAOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60812 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761365AbZEAOmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:55 -0400
Subject: [RFC][PATCH 33/35] asm-generic/ptemap.h for HIGHPTE users
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:52 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144252.A2BDDE6B@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86 and frv have identical CONFIG_HIGHPTE implementations
of the pte mapping functions.  Consolidate and move these
to asm-generic/ptemap.h.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/frv/include/asm/ptemap.h |   14 --------------
 linux-2.6.git-dave/arch/x86/include/asm/ptemap.h |   19 -------------------
 linux-2.6.git-dave/include/asm-generic/ptemap.h  |   13 +++++++++++++
 3 files changed, 13 insertions(+), 33 deletions(-)

diff -puN arch/frv/include/asm/ptemap.h~asm-generic-ptemap-h-highpte arch/frv/include/asm/ptemap.h
--- linux-2.6.git/arch/frv/include/asm/ptemap.h~asm-generic-ptemap-h-highpte	2009-04-30 15:11:12.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/include/asm/ptemap.h	2009-04-30 15:11:12.000000000 -0700
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
--- linux-2.6.git/arch/x86/include/asm/ptemap.h~asm-generic-ptemap-h-highpte	2009-04-30 15:11:12.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/ptemap.h	2009-04-30 15:11:12.000000000 -0700
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
--- linux-2.6.git/include/asm-generic/ptemap.h~asm-generic-ptemap-h-highpte	2009-04-30 15:11:12.000000000 -0700
+++ linux-2.6.git-dave/include/asm-generic/ptemap.h	2009-04-30 15:11:12.000000000 -0700
@@ -1,6 +1,19 @@
 #ifndef _ASM_GENERIC_PTEMAP_H
 #define _ASM_GENERIC_PTEMAP_H
 
+#include <linux/mm.h>
+
+#ifdef CONFIG_HIGHPTE
+#include <asm/highmem.h>
+#define pte_offset_map(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+#define pte_offset_map_nested(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
+#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
+#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+
+#else /* !CONFIG_HIGHPTE */
+
 #define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
 #define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
 #define pte_unmap(pte)			do { } while (0)
_
