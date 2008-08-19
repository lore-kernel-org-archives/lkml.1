Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYHSOdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYHSOdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYHSOdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:01 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:41193 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYHSOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:32:59 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K5UR2L-04-SOW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>,
       Joerg Roedel <joerg.roede@amd.com>
Subject: [PATCH 7/8] x86: move dma_*_coherent functions to include file
Date: Tue, 19 Aug 2008 16:32:45 +0200
Message-ID: <1219156366-32498-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0692 (UTC) FILETIME=[72DE1240:01C90208]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the x86 DMA-API functions are defined in asm/dma-mapping.h. This patch
moves the dma_*_coherent functions also to this header file because they are
now small enough to do so.
This is done as a separate patch because it also includes some renaming and
restructuring of the dma-mapping.h file.

Signed-off-by: Joerg Roedel <joerg.roede@amd.com>
---
 arch/x86/kernel/pci-dma.c     |   49 ++--------------------------------------
 arch/x86/kernel/pci-gart_64.c |    4 +-
 include/asm-x86/dma-mapping.h |   47 +++++++++++++++++++++++++++++++--------
 3 files changed, 42 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 514f3b8..23882c4 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -41,11 +41,12 @@ EXPORT_SYMBOL(bad_dma_address);
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to older i386. */
-struct device fallback_dev = {
+struct device x86_dma_fallback_dev = {
 	.bus_id = "fallback device",
 	.coherent_dma_mask = DMA_32BIT_MASK,
-	.dma_mask = &fallback_dev.coherent_dma_mask,
+	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
 };
+EXPORT_SYMBOL(x86_dma_fallback_dev);
 
 int dma_set_mask(struct device *dev, u64 mask)
 {
@@ -241,50 +242,6 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-/*
- * Allocate memory for a coherent mapping.
- */
-	void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t gfp)
-{
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
-	void *memory;
-
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
-		return memory;
-
-	if (!dev) {
-		dev = &fallback_dev;
-		gfp |= GFP_DMA;
-	}
-
-	if (ops->alloc_coherent)
-		return ops->alloc_coherent(dev, size,
-				dma_handle, gfp);
-	return NULL;
-}
-EXPORT_SYMBOL(dma_alloc_coherent);
-
-/*
- * Unmap coherent memory.
- * The caller must ensure that the device has finished accessing the mapping.
- */
-void dma_free_coherent(struct device *dev, size_t size,
-		       void *vaddr, dma_addr_t bus)
-{
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
-
-	WARN_ON(irqs_disabled());       /* for portability */
-
-	if (dma_release_from_coherent(dev, get_order(size), vaddr))
-		return;
-
-	if (ops->free_coherent)
-		ops->free_coherent(dev, size, vaddr, bus);
-}
-EXPORT_SYMBOL(dma_free_coherent);
-
 static int __init pci_iommu_init(void)
 {
 	calgary_iommu_init();
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 794d026..92f5c67 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -282,7 +282,7 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 	unsigned long bus;
 
 	if (!dev)
-		dev = &fallback_dev;
+		dev = &x86_dma_fallback_dev;
 
 	if (!need_iommu(dev, paddr, size))
 		return paddr;
@@ -434,7 +434,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 		return 0;
 
 	if (!dev)
-		dev = &fallback_dev;
+		dev = &x86_dma_fallback_dev;
 
 	out = 0;
 	start = 0;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 40688b2..b732c36 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -10,10 +10,11 @@
 #include <linux/scatterlist.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
+#include <asm-generic/dma-coherent.h>
 
 extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
-extern struct device fallback_dev;
+extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
 extern int force_iommu;
 
@@ -88,13 +89,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
-
+#define dma_is_consistent(d, h)	(1)
 
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
@@ -249,7 +244,39 @@ static inline int dma_get_cache_alignment(void)
 	return boot_cpu_data.x86_clflush_size;
 }
 
-#define dma_is_consistent(d, h)	(1)
+static inline void *
+dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		gfp_t gfp)
+{
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	void *memory;
+
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
+		return memory;
+
+	if (!dev) {
+		dev = &x86_dma_fallback_dev;
+		gfp |= GFP_DMA;
+	}
+
+	if (ops->alloc_coherent)
+		return ops->alloc_coherent(dev, size,
+				dma_handle, gfp);
+	return NULL;
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t bus)
+{
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
+	WARN_ON(irqs_disabled());       /* for portability */
+
+	if (dma_release_from_coherent(dev, get_order(size), vaddr))
+		return;
+
+	if (ops->free_coherent)
+		ops->free_coherent(dev, size, vaddr, bus);
+}
 
-#include <asm-generic/dma-coherent.h>
 #endif /* ASM_X86__DMA_MAPPING_H */
-- 
1.5.3.7


