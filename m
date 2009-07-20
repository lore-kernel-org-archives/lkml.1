Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZGTO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZGTO1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZGTO1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:27:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:21365 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZGTO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XGzHTjZGvMx+mXxHBUl8FYcNpV14Dk57SKaKx55gNrSY94vhzLSZg5WR9gFeOUSs2y
         vpH3L7o+70NqOju5hpOahbYVKO/hrMS9sWAMBm00wLevSKalUi+dQryIROr1T1fPLfO0
         V/rb7AYb1ZnjmSZS3TSicOHy8cQLy11I5h/Ew=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk, rmk@arm.linux.org.uk
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 3/4] ARM:dma-mapping:Support DMA-API debugging facility on ARM
Date: Mon, 20 Jul 2009 22:25:53 +0800
Message-Id: <1248099954-6666-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1248099954-6666-3-git-send-email-tom.leiming@gmail.com>
References: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
 <1248099954-6666-2-git-send-email-tom.leiming@gmail.com>
 <1248099954-6666-3-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/Kconfig                   |    1 +
 arch/arm/include/asm/dma-mapping.h |   38 ++++++++++++++++++++++++++++++-----
 arch/arm/mm/dma-mapping.c          |   11 ++++++++++
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cc11176..9dd56eb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -18,6 +18,7 @@ config ARM
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_DMA_API_DEBUG
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 86f2964..a288bab 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -5,7 +5,7 @@
 
 #include <linux/mm_types.h>
 #include <linux/scatterlist.h>
-
+#include <linux/dma-debug.h>
 #include <asm-generic/dma-coherent.h>
 #include <asm/memory.h>
 
@@ -146,7 +146,11 @@ extern void __dma_free_coherent(struct device *, size_t, void *, dma_addr_t);
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t *handle, gfp_t gfp)
 {
-	return __dma_alloc_coherent(dev, size, handle, gfp);
+	void *mem;
+
+	mem = __dma_alloc_coherent(dev, size, handle, gfp);
+	debug_dma_alloc_coherent(dev, size, *handle, mem);
+	return mem;
 }
 
 /**
@@ -165,6 +169,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 	void *cpu_addr, dma_addr_t handle)
 {
+	debug_dma_free_coherent(dev, size, cpu_addr, handle);
 	__dma_free_coherent(dev, size, cpu_addr, handle);
 }
 
@@ -333,8 +338,14 @@ static inline void __dma_unmap_single(struct device *dev, dma_addr_t handle,
 static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
 		size_t size, enum dma_data_direction dir)
 {
+	dma_addr_t addr;
 	BUG_ON(!valid_dma_direction(dir));
-	return __dma_map_single(dev, cpu_addr, size, dir);
+
+	addr = __dma_map_single(dev, cpu_addr, size, dir);
+	debug_dma_map_page(dev, virt_to_page(cpu_addr),
+			   (unsigned long)cpu_addr & ~PAGE_MASK, size,
+			   dir, addr, true);
+	return addr;
 }
 
 /**
@@ -354,8 +365,12 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir)
 {
+	dma_addr_t addr;
 	BUG_ON(!valid_dma_direction(dir));
-	return __dma_map_page(dev, page, offset, size, dir);
+
+	addr = __dma_map_page(dev, page, offset, size, dir);
+	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
+	return addr;
 }
 
 /**
@@ -376,6 +391,7 @@ static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir)
 {
 	__dma_unmap_single(dev, handle, size, dir);
+	debug_dma_unmap_page(dev, handle, size, dir, true);
 }
 
 /**
@@ -395,7 +411,8 @@ static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
 static inline void dma_unmap_page(struct device *dev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir)
 {
-	dma_unmap_single(dev, handle, size, dir);
+	__dma_unmap_single(dev, handle, size, dir);
+	debug_dma_unmap_page(dev, handle, size, dir, false);
 }
 
 /**
@@ -422,6 +439,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 {
 	BUG_ON(!valid_dma_direction(dir));
 
+	debug_dma_sync_single_range_for_cpu(dev, handle, offset, size, dir);
 	dmabounce_sync_for_cpu(dev, handle, offset, size, dir);
 }
 
@@ -431,6 +449,8 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 {
 	BUG_ON(!valid_dma_direction(dir));
 
+	debug_dma_sync_single_range_for_device(dev, handle, offset, size, dir);
+
 	if (!dmabounce_sync_for_device(dev, handle, offset, size, dir))
 		return;
 
@@ -465,11 +485,15 @@ extern void __dma_sync_sg_for_device(struct device *, struct scatterlist *, int,
 static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
 		int nents, enum dma_data_direction dir)
 {
-	return __dma_map_sg(dev, sg, nents, dir);
+	int ents;
+	ents = __dma_map_sg(dev, sg, nents, dir);
+	debug_dma_map_sg(dev, sg, nents, ents, dir);
+	return ents;
 }
 static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 		int nents, enum dma_data_direction dir)
 {
+	debug_dma_unmap_sg(dev, sg, nents, dir);
 	 __dma_unmap_sg(dev, sg, nents, dir);
 }
 static inline void dma_sync_sg_for_cpu(struct device *dev,
@@ -477,12 +501,14 @@ static inline void dma_sync_sg_for_cpu(struct device *dev,
 		enum dma_data_direction dir)
 {
 	 __dma_sync_sg_for_cpu(dev, sg, nents, dir);
+	debug_dma_sync_sg_for_cpu(dev, sg, nents, dir);
 }
 static inline void dma_sync_sg_for_device(struct device *dev,
 		struct scatterlist *sg, int nents,
 		enum dma_data_direction dir)
 {
 	 __dma_sync_sg_for_device(dev, sg, nents, dir);
+	debug_dma_sync_sg_for_device(dev, sg, nents, dir);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 654cd82..64e5d82 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/dma-debug.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/memory.h>
@@ -688,3 +689,13 @@ void __dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	}
 }
 EXPORT_SYMBOL(__dma_sync_sg_for_device);
+
+#define PREALLOC_DMA_DEBUG_ENTRIES             8192
+
+static int __init dma_debug_init_arm(void)
+{
+       dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+       return 0;
+}
+fs_initcall(dma_debug_init_arm);
+
-- 
1.6.0.GIT

