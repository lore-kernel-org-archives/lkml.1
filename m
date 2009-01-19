Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbZASOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbZASOtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZASOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:22 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54216 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZASOrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:18 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QK-03-6AL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/16] dma-debug: x86 architecture bindings
Date: Mon, 19 Jan 2009 15:47:02 +0100
Message-ID: <1232376423-11067-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:04.0141 (UTC) FILETIME=[CB2627D0:01C97A44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make use of DMA-API debugging code in x86

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/dma-mapping.h |   45 +++++++++++++++++++++++++++++++----
 arch/x86/kernel/pci-dma.c          |    6 ++++
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 73f7fe8..9e7aa97 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,6 +40,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_DMA_API_DEBUG
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 5a34780..6a5e070 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/scatterlist.h>
+#include <linux/dma-debug.h>
 #include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
@@ -56,11 +57,16 @@ dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       enum dma_data_direction dir)
 {
 	struct dma_map_ops *ops = get_dma_ops(hwdev);
+	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
-	return ops->map_page(hwdev, virt_to_page(ptr),
+	addr = ops->map_page(hwdev, virt_to_page(ptr),
 			     (unsigned long)ptr & ~PAGE_MASK, size,
 			     dir, NULL);
+	debug_dma_map_page(hwdev, virt_to_page(ptr),
+			   (unsigned long)ptr & ~PAGE_MASK, size,
+			   dir, addr, true);
+	return addr;
 }
 
 static inline void
@@ -72,6 +78,7 @@ dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
 		ops->unmap_page(dev, addr, size, dir, NULL);
+	debug_dma_unmap_page(dev, addr, size, dir, true);
 }
 
 static inline int
@@ -79,9 +86,13 @@ dma_map_sg(struct device *hwdev, struct scatterlist *sg,
 	   int nents, enum dma_data_direction dir)
 {
 	struct dma_map_ops *ops = get_dma_ops(hwdev);
+	int ents;
 
 	BUG_ON(!valid_dma_direction(dir));
-	return ops->map_sg(hwdev, sg, nents, dir, NULL);
+	ents = ops->map_sg(hwdev, sg, nents, dir, NULL);
+	debug_dma_map_sg(hwdev, sg, ents, dir);
+
+	return ents;
 }
 
 static inline void
@@ -91,6 +102,7 @@ dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
 	BUG_ON(!valid_dma_direction(dir));
+	debug_dma_unmap_sg(hwdev, sg, nents, dir);
 	if (ops->unmap_sg)
 		ops->unmap_sg(hwdev, sg, nents, dir, NULL);
 }
@@ -104,6 +116,7 @@ dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(hwdev, dma_handle, size, dir);
+	debug_dma_sync_single_for_cpu(hwdev, dma_handle, size, dir);
 	flush_write_buffers();
 }
 
@@ -116,6 +129,7 @@ dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
 		ops->sync_single_for_device(hwdev, dma_handle, size, dir);
+	debug_dma_sync_single_for_device(hwdev, dma_handle, size, dir);
 	flush_write_buffers();
 }
 
@@ -130,6 +144,8 @@ dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 	if (ops->sync_single_range_for_cpu)
 		ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
 					       size, dir);
+	debug_dma_sync_single_range_for_cpu(hwdev, dma_handle,
+					    offset, size, dir);
 	flush_write_buffers();
 }
 
@@ -144,6 +160,8 @@ dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 	if (ops->sync_single_range_for_device)
 		ops->sync_single_range_for_device(hwdev, dma_handle,
 						  offset, size, dir);
+	debug_dma_sync_single_range_for_device(hwdev, dma_handle,
+					       offset, size, dir);
 	flush_write_buffers();
 }
 
@@ -156,6 +174,7 @@ dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(hwdev, sg, nelems, dir);
+	debug_dma_sync_sg_for_cpu(hwdev, sg, nelems, dir);
 	flush_write_buffers();
 }
 
@@ -168,6 +187,7 @@ dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
 		ops->sync_sg_for_device(hwdev, sg, nelems, dir);
+	debug_dma_sync_sg_for_device(hwdev, sg, nelems, dir);
 
 	flush_write_buffers();
 }
@@ -177,15 +197,24 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      enum dma_data_direction dir)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
+	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
-	return ops->map_page(dev, page, offset, size, dir, NULL);
+	addr = ops->map_page(dev, page, offset, size, dir, NULL);
+	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
+
+	return addr;
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
 				  size_t size, enum dma_data_direction dir)
 {
-	dma_unmap_single(dev, addr, size, dir);
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->unmap_page)
+		ops->unmap_page(dev, addr, size, dir, NULL);
+	debug_dma_unmap_page(dev, addr, size, dir, false);
 }
 
 static inline void
@@ -250,8 +279,11 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (!ops->alloc_coherent)
 		return NULL;
 
-	return ops->alloc_coherent(dev, size, dma_handle,
-				   dma_alloc_coherent_gfp_flags(dev, gfp));
+	memory = ops->alloc_coherent(dev, size, dma_handle,
+				     dma_alloc_coherent_gfp_flags(dev, gfp));
+	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
+
+	return memory;
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
@@ -264,6 +296,7 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 	if (dma_release_from_coherent(dev, get_order(size), vaddr))
 		return;
 
+	debug_dma_free_coherent(dev, size, vaddr, bus);
 	if (ops->free_coherent)
 		ops->free_coherent(dev, size, vaddr, bus);
 }
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f293a8d..50d28eb 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,4 +1,5 @@
 #include <linux/dma-mapping.h>
+#include <linux/dma-debug.h>
 #include <linux/dmar.h>
 #include <linux/bootmem.h>
 #include <linux/pci.h>
@@ -44,6 +45,9 @@ struct device x86_dma_fallback_dev = {
 };
 EXPORT_SYMBOL(x86_dma_fallback_dev);
 
+/* Number of entries preallocated for DMA-API debugging */
+#define PREALLOC_DMA_DEBUG_ENTRIES       8192    /* needs 512kb */
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
@@ -265,6 +269,8 @@ EXPORT_SYMBOL(dma_supported);
 
 static int __init pci_iommu_init(void)
 {
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+
 	calgary_iommu_init();
 
 	intel_iommu_init();
-- 
1.5.6.4


