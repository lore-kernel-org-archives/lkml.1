Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbYCYVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbYCYVnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbYCYViu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760743AbYCYVis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:48 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 20/20] x86: delete the arch-specific dma-mapping headers.
Date: Tue, 25 Mar 2008 18:36:39 -0300
Message-Id: <1206480999-21767-21-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-20-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
 <1206480999-21767-6-git-send-email-gcosta@redhat.com>
 <1206480999-21767-7-git-send-email-gcosta@redhat.com>
 <1206480999-21767-8-git-send-email-gcosta@redhat.com>
 <1206480999-21767-9-git-send-email-gcosta@redhat.com>
 <1206480999-21767-10-git-send-email-gcosta@redhat.com>
 <1206480999-21767-11-git-send-email-gcosta@redhat.com>
 <1206480999-21767-12-git-send-email-gcosta@redhat.com>
 <1206480999-21767-13-git-send-email-gcosta@redhat.com>
 <1206480999-21767-14-git-send-email-gcosta@redhat.com>
 <1206480999-21767-15-git-send-email-gcosta@redhat.com>
 <1206480999-21767-16-git-send-email-gcosta@redhat.com>
 <1206480999-21767-17-git-send-email-gcosta@redhat.com>
 <1206480999-21767-18-git-send-email-gcosta@redhat.com>
 <1206480999-21767-19-git-send-email-gcosta@redhat.com>
 <1206480999-21767-20-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all the code that is left is ready to be merged as-is
in dma-mapping.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/dma-mapping.h    |   19 +++++++++++++------
 include/asm-x86/dma-mapping_32.h |   23 -----------------------
 include/asm-x86/dma-mapping_64.h |   17 -----------------
 3 files changed, 13 insertions(+), 46 deletions(-)
 delete mode 100644 include/asm-x86/dma-mapping_32.h
 delete mode 100644 include/asm-x86/dma-mapping_64.h

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 9548b19..3809b35 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -11,6 +11,9 @@
 #include <asm/swiotlb.h>
 
 extern dma_addr_t bad_dma_address;
+extern int iommu_merge;
+extern struct device fallback_dev;
+extern int panic_on_overflow;
 
 struct dma_mapping_ops {
 	int             (*mapping_error)(dma_addr_t dma_addr);
@@ -75,12 +78,6 @@ void dma_free_coherent(struct device *dev, size_t size,
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
-#ifdef CONFIG_X86_32
-# include "dma-mapping_32.h"
-#else
-# include "dma-mapping_64.h"
-#endif
-
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       int direction)
@@ -203,6 +200,15 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	flush_write_buffers();
 }
 
+static inline int dma_get_cache_alignment(void)
+{
+	/* no easy way to get cache size on all x86, so return the
+	 * maximum possible, to be safe */
+	return boot_cpu_data.x86_clflush_size;
+}
+
+#define dma_is_consistent(d, h)	(1)
+
 #ifdef CONFIG_X86_32
 #  define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
 extern int
@@ -215,5 +221,6 @@ dma_release_declared_memory(struct device *dev);
 extern void *
 dma_mark_declared_memory_occupied(struct device *dev,
 				  dma_addr_t device_addr, size_t size);
+extern int forbid_dac;
 #endif /* CONFIG_X86_32 */
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
deleted file mode 100644
index 4ec4f45..0000000
--- a/include/asm-x86/dma-mapping_32.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _ASM_I386_DMA_MAPPING_H
-#define _ASM_I386_DMA_MAPPING_H
-
-#include <linux/mm.h>
-#include <linux/scatterlist.h>
-
-#include <asm/cache.h>
-#include <asm/io.h>
-#include <asm/bug.h>
-
-extern int forbid_dac;
-
-static inline int
-dma_get_cache_alignment(void)
-{
-	/* no easy way to get cache size on all x86, so return the
-	 * maximum possible, to be safe */
-	return boot_cpu_data.x86_clflush_size;
-}
-
-#define dma_is_consistent(d, h)	(1)
-
-#endif
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
deleted file mode 100644
index 8353025..0000000
--- a/include/asm-x86/dma-mapping_64.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _X8664_DMA_MAPPING_H
-#define _X8664_DMA_MAPPING_H 1
-
-extern int iommu_merge;
-
-/* same for gart, swiotlb, and nommu */
-static inline int dma_get_cache_alignment(void)
-{
-	return boot_cpu_data.x86_clflush_size;
-}
-
-#define dma_is_consistent(d, h) 1
-
-extern struct device fallback_dev;
-extern int panic_on_overflow;
-
-#endif /* _X8664_DMA_MAPPING_H */
-- 
1.5.0.6

