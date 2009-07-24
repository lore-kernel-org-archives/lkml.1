Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZGXD1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZGXD1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZGXD1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:27:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:45088 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbZGXD1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:27:19 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linuxppc-dev@lists.ozlabs.org
Cc: beckyb@kernel.crashing.org, galak@kernel.crashing.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/5] powerpc: use dma_map_ops struct
Date: Fri, 24 Jul 2009 12:24:14 +0900
Message-Id: <1248405855-15546-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 24 Jul 2009 12:27:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts uses dma_map_ops struct (in include/linux/dma-mapping.h)
instead of POWERPC homegrown dma_mapping_ops.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/include/asm/device.h       |    4 +-
 arch/powerpc/include/asm/dma-mapping.h  |   84 ++++++++-----------------------
 arch/powerpc/include/asm/pci.h          |    4 +-
 arch/powerpc/include/asm/swiotlb.h      |    2 +-
 arch/powerpc/kernel/dma-iommu.c         |    2 +-
 arch/powerpc/kernel/dma-swiotlb.c       |    2 +-
 arch/powerpc/kernel/dma.c               |    2 +-
 arch/powerpc/kernel/ibmebus.c           |    2 +-
 arch/powerpc/kernel/pci-common.c        |    6 +-
 arch/powerpc/kernel/vio.c               |    2 +-
 arch/powerpc/platforms/cell/iommu.c     |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c |    4 +-
 12 files changed, 37 insertions(+), 79 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 0086f8d..67fcd7f 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -6,7 +6,7 @@
 #ifndef _ASM_POWERPC_DEVICE_H
 #define _ASM_POWERPC_DEVICE_H
 
-struct dma_mapping_ops;
+struct dma_map_ops;
 struct device_node;
 
 struct dev_archdata {
@@ -14,7 +14,7 @@ struct dev_archdata {
 	struct device_node	*of_node;
 
 	/* DMA operations on that device */
-	struct dma_mapping_ops	*dma_ops;
+	struct dma_map_ops	*dma_ops;
 	void			*dma_data;
 #ifdef CONFIG_SWIOTLB
 	dma_addr_t		max_direct_dma_addr;
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 1765c37..8ca2b51 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -64,56 +64,14 @@ static inline unsigned long device_to_mask(struct device *dev)
 }
 
 /*
- * DMA operations are abstracted for G5 vs. i/pSeries, PCI vs. VIO
- */
-struct dma_mapping_ops {
-	void *		(*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t flag);
-	void		(*free_coherent)(struct device *dev, size_t size,
-				void *vaddr, dma_addr_t dma_handle);
-	int		(*map_sg)(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction direction,
-				struct dma_attrs *attrs);
-	void		(*unmap_sg)(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction direction,
-				struct dma_attrs *attrs);
-	int		(*dma_supported)(struct device *dev, u64 mask);
-	int		(*set_dma_mask)(struct device *dev, u64 dma_mask);
-	dma_addr_t 	(*map_page)(struct device *dev, struct page *page,
-				unsigned long offset, size_t size,
-				enum dma_data_direction direction,
-				struct dma_attrs *attrs);
-	void		(*unmap_page)(struct device *dev,
-				dma_addr_t dma_address, size_t size,
-				enum dma_data_direction direction,
-				struct dma_attrs *attrs);
-#ifdef CONFIG_PPC_NEED_DMA_SYNC_OPS
-	void            (*sync_single_range_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size,
-				enum dma_data_direction direction);
-	void            (*sync_single_range_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size,
-				enum dma_data_direction direction);
-	void            (*sync_sg_for_cpu)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				enum dma_data_direction direction);
-	void            (*sync_sg_for_device)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				enum dma_data_direction direction);
-#endif
-};
-
-/*
  * Available generic sets of operations
  */
 #ifdef CONFIG_PPC64
-extern struct dma_mapping_ops dma_iommu_ops;
+extern struct dma_map_ops dma_iommu_ops;
 #endif
-extern struct dma_mapping_ops dma_direct_ops;
+extern struct dma_map_ops dma_direct_ops;
 
-static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	/* We don't handle the NULL dev case for ISA for now. We could
 	 * do it via an out of line call but it is not needed for now. The
@@ -126,14 +84,14 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 	return dev->archdata.dma_ops;
 }
 
-static inline void set_dma_ops(struct device *dev, struct dma_mapping_ops *ops)
+static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 {
 	dev->archdata.dma_ops = ops;
 }
 
 static inline int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (unlikely(dma_ops == NULL))
 		return 0;
@@ -147,7 +105,7 @@ static inline int dma_supported(struct device *dev, u64 mask)
 
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (unlikely(dma_ops == NULL))
 		return -EIO;
@@ -161,7 +119,7 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 
 /*
  * map_/unmap_single actually call through to map/unmap_page now that all the
- * dma_mapping_ops have been converted over. We just have to get the page and
+ * dma_map_ops have been converted over. We just have to get the page and
  * offset to pass through to map_page
  */
 static inline dma_addr_t dma_map_single_attrs(struct device *dev,
@@ -170,7 +128,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev,
 					      enum dma_data_direction direction,
 					      struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -185,7 +143,7 @@ static inline void dma_unmap_single_attrs(struct device *dev,
 					  enum dma_data_direction direction,
 					  struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -198,7 +156,7 @@ static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 					    enum dma_data_direction direction,
 					    struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -211,7 +169,7 @@ static inline void dma_unmap_page_attrs(struct device *dev,
 					enum dma_data_direction direction,
 					struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -222,7 +180,7 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 				   int nents, enum dma_data_direction direction,
 				   struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 	return dma_ops->map_sg(dev, sg, nents, direction, attrs);
@@ -234,7 +192,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev,
 				      enum dma_data_direction direction,
 				      struct dma_attrs *attrs)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 	dma_ops->unmap_sg(dev, sg, nhwentries, direction, attrs);
@@ -243,7 +201,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev,
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
@@ -252,7 +210,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
@@ -304,7 +262,7 @@ static inline void dma_sync_single_for_cpu(struct device *dev,
 		dma_addr_t dma_handle, size_t size,
 		enum dma_data_direction direction)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -317,7 +275,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 		dma_addr_t dma_handle, size_t size,
 		enum dma_data_direction direction)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -330,7 +288,7 @@ static inline void dma_sync_sg_for_cpu(struct device *dev,
 		struct scatterlist *sgl, int nents,
 		enum dma_data_direction direction)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -342,7 +300,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 		struct scatterlist *sgl, int nents,
 		enum dma_data_direction direction)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -354,7 +312,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		dma_addr_t dma_handle, unsigned long offset, size_t size,
 		enum dma_data_direction direction)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -367,7 +325,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 		dma_addr_t dma_handle, unsigned long offset, size_t size,
 		enum dma_data_direction direction)
 {
-	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index d9483c5..7ae46d7 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -61,8 +61,8 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 }
 
 #ifdef CONFIG_PCI
-extern void set_pci_dma_ops(struct dma_mapping_ops *dma_ops);
-extern struct dma_mapping_ops *get_pci_dma_ops(void);
+extern void set_pci_dma_ops(struct dma_map_ops *dma_ops);
+extern struct dma_map_ops *get_pci_dma_ops(void);
 #else	/* CONFIG_PCI */
 #define set_pci_dma_ops(d)
 #define get_pci_dma_ops()	NULL
diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/include/asm/swiotlb.h
index 21ce0a3..8979d4c 100644
--- a/arch/powerpc/include/asm/swiotlb.h
+++ b/arch/powerpc/include/asm/swiotlb.h
@@ -13,7 +13,7 @@
 
 #include <linux/swiotlb.h>
 
-extern struct dma_mapping_ops swiotlb_dma_ops;
+extern struct dma_map_ops swiotlb_dma_ops;
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 2983ada..87ddb3f 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -89,7 +89,7 @@ static int dma_iommu_dma_supported(struct device *dev, u64 mask)
 		return 1;
 }
 
-struct dma_mapping_ops dma_iommu_ops = {
+struct dma_map_ops dma_iommu_ops = {
 	.alloc_coherent	= dma_iommu_alloc_coherent,
 	.free_coherent	= dma_iommu_free_coherent,
 	.map_sg		= dma_iommu_map_sg,
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index ca141e1..d1143a6 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -31,7 +31,7 @@ unsigned int ppc_swiotlb_enable;
  * map_page, and unmap_page on highmem, use normal dma_ops
  * for everything else.
  */
-struct dma_mapping_ops swiotlb_dma_ops = {
+struct dma_map_ops swiotlb_dma_ops = {
 	.alloc_coherent = dma_direct_alloc_coherent,
 	.free_coherent = dma_direct_free_coherent,
 	.map_sg = swiotlb_map_sg_attrs,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 20a60d6..3e8bb9a 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -140,7 +140,7 @@ static inline void dma_direct_sync_single_range(struct device *dev,
 }
 #endif
 
-struct dma_mapping_ops dma_direct_ops = {
+struct dma_map_ops dma_direct_ops = {
 	.alloc_coherent	= dma_direct_alloc_coherent,
 	.free_coherent	= dma_direct_free_coherent,
 	.map_sg		= dma_direct_map_sg,
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 6e3f624..a4c8b38 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -127,7 +127,7 @@ static int ibmebus_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static struct dma_mapping_ops ibmebus_dma_ops = {
+static struct dma_map_ops ibmebus_dma_ops = {
 	.alloc_coherent = ibmebus_alloc_coherent,
 	.free_coherent  = ibmebus_free_coherent,
 	.map_sg         = ibmebus_map_sg,
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 5a56e97..7585f1f 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -50,14 +50,14 @@ resource_size_t isa_mem_base;
 unsigned int ppc_pci_flags = 0;
 
 
-static struct dma_mapping_ops *pci_dma_ops = &dma_direct_ops;
+static struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
 
-void set_pci_dma_ops(struct dma_mapping_ops *dma_ops)
+void set_pci_dma_ops(struct dma_map_ops *dma_ops)
 {
 	pci_dma_ops = dma_ops;
 }
 
-struct dma_mapping_ops *get_pci_dma_ops(void)
+struct dma_map_ops *get_pci_dma_ops(void)
 {
 	return pci_dma_ops;
 }
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 819e59f..bc7b41e 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -601,7 +601,7 @@ static void vio_dma_iommu_unmap_sg(struct device *dev,
 	vio_cmo_dealloc(viodev, alloc_size);
 }
 
-struct dma_mapping_ops vio_dma_mapping_ops = {
+struct dma_map_ops vio_dma_mapping_ops = {
 	.alloc_coherent = vio_dma_iommu_alloc_coherent,
 	.free_coherent  = vio_dma_iommu_free_coherent,
 	.map_sg         = vio_dma_iommu_map_sg,
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 5b34fc2..416db17 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -642,7 +642,7 @@ static int dma_fixed_dma_supported(struct device *dev, u64 mask)
 
 static int dma_set_mask_and_switch(struct device *dev, u64 dma_mask);
 
-struct dma_mapping_ops dma_iommu_fixed_ops = {
+struct dma_map_ops dma_iommu_fixed_ops = {
 	.alloc_coherent = dma_fixed_alloc_coherent,
 	.free_coherent  = dma_fixed_free_coherent,
 	.map_sg         = dma_fixed_map_sg,
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 3f763c5..02ddcc2 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -694,7 +694,7 @@ static int ps3_dma_supported(struct device *_dev, u64 mask)
 	return mask >= DMA_BIT_MASK(32);
 }
 
-static struct dma_mapping_ops ps3_sb_dma_ops = {
+static struct dma_map_ops ps3_sb_dma_ops = {
 	.alloc_coherent = ps3_alloc_coherent,
 	.free_coherent = ps3_free_coherent,
 	.map_sg = ps3_sb_map_sg,
@@ -704,7 +704,7 @@ static struct dma_mapping_ops ps3_sb_dma_ops = {
 	.unmap_page = ps3_unmap_page,
 };
 
-static struct dma_mapping_ops ps3_ioc0_dma_ops = {
+static struct dma_map_ops ps3_ioc0_dma_ops = {
 	.alloc_coherent = ps3_alloc_coherent,
 	.free_coherent = ps3_free_coherent,
 	.map_sg = ps3_ioc0_map_sg,
-- 
1.6.0.6

