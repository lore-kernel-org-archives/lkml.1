Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYESGek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYESGek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYESGeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:34:19 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:46508 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbYESGeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:34:17 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: amit.shah@qumranet.com, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com, andi@firstfloor.org,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 2/2] x86: per-device dma_mapping_ops support
Date: Mon, 19 May 2008 15:31:29 +0900
Message-Id: <1211178689-3507-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1211178689-3507-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1211178689-3507-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds per-device dma_mapping_ops support for CONFIG_X86_64.

A pointer to dma_mapping_ops to struct dev_archdata is added. If the
pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
it's NULL, the system-wide dma_ops pointer is used as before.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 arch/x86/kernel/pci-dma.c        |    2 +-
 arch/x86/kernel/pci-gart_64.c    |    2 +-
 arch/x86/kernel/pci-nommu.c      |   14 +-----
 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 include/asm-x86/device.h         |    3 +
 include/asm-x86/dma-mapping.h    |   95 ++++++++++++++++++++++++++------------
 7 files changed, 74 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index e28ec49..dca9a82 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -541,7 +541,7 @@ error:
 	return ret;
 }
 
-static const struct dma_mapping_ops calgary_dma_ops = {
+static struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 9c4614a..d2f2304 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -11,7 +11,7 @@
 int forbid_dac __read_mostly;
 EXPORT_SYMBOL(forbid_dac);
 
-const struct dma_mapping_ops *dma_ops;
+struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 020cadd..638c214 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -619,7 +619,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 extern int agp_amd64_init(void);
 
-static const struct dma_mapping_ops gart_dma_ops = {
+static struct dma_mapping_ops gart_dma_ops = {
 	.map_single			= gart_map_single,
 	.map_simple			= gart_map_simple,
 	.unmap_single			= gart_unmap_single,
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 05d70b8..67cc5ee 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -72,21 +72,9 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
-/* Make sure we keep the same behaviour */
-static int nommu_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
-{
-#ifdef CONFIG_X86_32
-	return 0;
-#else
-	return (dma_addr == bad_dma_address);
-#endif
-}
-
-
-const struct dma_mapping_ops nommu_dma_ops = {
+struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
-	.mapping_error = nommu_mapping_error,
 	.is_phys = 1,
 };
 
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 490da7f..a464016 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,7 +18,7 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
-const struct dma_mapping_ops swiotlb_dma_ops = {
+struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff --git a/include/asm-x86/device.h b/include/asm-x86/device.h
index 87a7153..3c034f4 100644
--- a/include/asm-x86/device.h
+++ b/include/asm-x86/device.h
@@ -5,6 +5,9 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
+#ifdef CONFIG_X86_64
+struct dma_mapping_ops *dma_ops;
+#endif
 #ifdef CONFIG_DMAR
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 69626b6..feb9a53 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -58,14 +58,33 @@ struct dma_mapping_ops {
 	int		is_phys;
 };
 
-extern const struct dma_mapping_ops *dma_ops;
+extern struct dma_mapping_ops *dma_ops;
 
+static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
+{
+#ifdef CONFIG_X86_32
+	return dma_ops;
+#else
+	if (unlikely(!dev) || !dev->archdata.dma_ops)
+		return dma_ops;
+	else
+		return dev->archdata.dma_ops;
+#endif
+}
+
+/* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dev, dma_addr);
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
+#ifdef CONFIG_X86_32
+	return 0;
+#else
+	if (ops->mapping_error)
+		return ops->mapping_error(dev, dma_addr);
 
 	return (dma_addr == bad_dma_address);
+#endif
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
@@ -85,44 +104,53 @@ static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
+	return ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
 }
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
 		 int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, addr, size, direction);
+	if (ops->unmap_single)
+		ops->unmap_single(dev, addr, size, direction);
 }
 
 static inline int
 dma_map_sg(struct device *hwdev, struct scatterlist *sg,
 	   int nents, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_sg(hwdev, sg, nents, direction);
+	return ops->map_sg(hwdev, sg, nents, direction);
 }
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 	     int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->unmap_sg)
-		dma_ops->unmap_sg(hwdev, sg, nents, direction);
+	if (ops->unmap_sg)
+		ops->unmap_sg(hwdev, sg, nents, direction);
 }
 
 static inline void
 dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 			size_t size, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_for_cpu)
-		dma_ops->sync_single_for_cpu(hwdev, dma_handle, size,
-					     direction);
+	if (ops->sync_single_for_cpu)
+		ops->sync_single_for_cpu(hwdev, dma_handle, size, direction);
 	flush_write_buffers();
 }
 
@@ -130,10 +158,11 @@ static inline void
 dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
 			   size_t size, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_for_device)
-		dma_ops->sync_single_for_device(hwdev, dma_handle, size,
-						direction);
+	if (ops->sync_single_for_device)
+		ops->sync_single_for_device(hwdev, dma_handle, size, direction);
 	flush_write_buffers();
 }
 
@@ -141,11 +170,12 @@ static inline void
 dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 			      unsigned long offset, size_t size, int direction)
 {
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_cpu)
-		dma_ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
-						   size, direction);
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
+	BUG_ON(!valid_dma_direction(direction));
+	if (ops->sync_single_range_for_cpu)
+		ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
+					       size, direction);
 	flush_write_buffers();
 }
 
@@ -154,11 +184,12 @@ dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 				 unsigned long offset, size_t size,
 				 int direction)
 {
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_device)
-		dma_ops->sync_single_range_for_device(hwdev, dma_handle,
-						      offset, size, direction);
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
+	BUG_ON(!valid_dma_direction(direction));
+	if (ops->sync_single_range_for_device)
+		ops->sync_single_range_for_device(hwdev, dma_handle,
+						  offset, size, direction);
 	flush_write_buffers();
 }
 
@@ -166,9 +197,11 @@ static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 		    int nelems, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_sg_for_cpu)
-		dma_ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
+	if (ops->sync_sg_for_cpu)
+		ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
 	flush_write_buffers();
 }
 
@@ -176,9 +209,11 @@ static inline void
 dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 		       int nelems, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_sg_for_device)
-		dma_ops->sync_sg_for_device(hwdev, sg, nelems, direction);
+	if (ops->sync_sg_for_device)
+		ops->sync_sg_for_device(hwdev, sg, nelems, direction);
 
 	flush_write_buffers();
 }
@@ -187,9 +222,11 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
 				      int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_single(dev, page_to_phys(page)+offset,
-				   size, direction);
+	return ops->map_single(dev, page_to_phys(page) + offset,
+			       size, direction);
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-- 
1.5.4.2

