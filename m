Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZLNAR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZLNAR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZLMX5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZLMX5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:46 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, benh@kernel.crashing.org,
       paulus@samba.org, galak@kernel.crashing.org, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH 10/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:25 +0100
Message-Id: <0511a5551dac4b79c63353a22417407bec29bb09.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/powerpc/include/asm/device.h      |    2 +-
 arch/powerpc/include/asm/dma-mapping.h |   18 +++++++++---------
 arch/powerpc/include/asm/iommu.h       |    3 +++
 arch/powerpc/include/asm/pci.h         |    4 ++--
 arch/powerpc/include/asm/swiotlb.h     |    2 +-
 arch/powerpc/kernel/dma-iommu.c        |    4 ++--
 arch/powerpc/kernel/dma-swiotlb.c      |    2 +-
 arch/powerpc/kernel/dma.c              |    2 +-
 arch/powerpc/kernel/ibmebus.c          |    2 +-
 9 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 6d94d27..50d4cad 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -14,7 +14,7 @@ struct dev_archdata {
 	struct device_node	*of_node;
 
 	/* DMA operations on that device */
-	struct dma_map_ops	*dma_ops;
+	const struct dma_map_ops	*dma_ops;
 
 	/*
 	 * When an iommu is in use, dma_data is used as a ptr to the base of the
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index e281dae..f025ef0 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -67,11 +67,11 @@ static inline unsigned long device_to_mask(struct device *dev)
  * Available generic sets of operations
  */
 #ifdef CONFIG_PPC64
-extern struct dma_map_ops dma_iommu_ops;
+extern const struct dma_map_ops dma_iommu_ops;
 #endif
-extern struct dma_map_ops dma_direct_ops;
+extern const struct dma_map_ops dma_direct_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	/* We don't handle the NULL dev case for ISA for now. We could
 	 * do it via an out of line call but it is not needed for now. The
@@ -84,7 +84,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 	return dev->archdata.dma_ops;
 }
 
-static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
+static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
 	dev->archdata.dma_ops = ops;
 }
@@ -118,7 +118,7 @@ static inline void set_dma_offset(struct device *dev, dma_addr_t off)
 
 static inline int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (unlikely(dma_ops == NULL))
 		return 0;
@@ -132,7 +132,7 @@ static inline int dma_supported(struct device *dev, u64 mask)
 
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (unlikely(dma_ops == NULL))
 		return -EIO;
@@ -147,7 +147,7 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 	void *cpu_addr;
 
 	BUG_ON(!dma_ops);
@@ -162,7 +162,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -173,7 +173,7 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (dma_ops->mapping_error)
 		return dma_ops->mapping_error(dev, dma_addr);
diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index edfc980..1766f59 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -116,6 +116,9 @@ extern void iommu_init_early_iSeries(void);
 extern void iommu_init_early_dart(void);
 extern void iommu_init_early_pasemi(void);
 
+/* dma-iommu.c */
+extern int dma_iommu_dma_supported(struct device *dev, u64 mask);
+
 #ifdef CONFIG_PCI
 extern void pci_iommu_init(void);
 extern void pci_direct_iommu_init(void);
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index b5ea626..4030822 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -65,8 +65,8 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 }
 
 #ifdef CONFIG_PCI
-extern void set_pci_dma_ops(struct dma_map_ops *dma_ops);
-extern struct dma_map_ops *get_pci_dma_ops(void);
+extern void set_pci_dma_ops(const struct dma_map_ops *dma_ops);
+extern const struct dma_map_ops *get_pci_dma_ops(void);
 #else	/* CONFIG_PCI */
 #define set_pci_dma_ops(d)
 #define get_pci_dma_ops()	NULL
diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/include/asm/swiotlb.h
index 8979d4c..d2fd0d3 100644
--- a/arch/powerpc/include/asm/swiotlb.h
+++ b/arch/powerpc/include/asm/swiotlb.h
@@ -13,7 +13,7 @@
 
 #include <linux/swiotlb.h>
 
-extern struct dma_map_ops swiotlb_dma_ops;
+extern const struct dma_map_ops swiotlb_dma_ops;
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 37771a5..70f69e7 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -70,7 +70,7 @@ static void dma_iommu_unmap_sg(struct device *dev, struct scatterlist *sglist,
 }
 
 /* We support DMA to/from any memory page via the iommu */
-static int dma_iommu_dma_supported(struct device *dev, u64 mask)
+int dma_iommu_dma_supported(struct device *dev, u64 mask)
 {
 	struct iommu_table *tbl = get_iommu_table_base(dev);
 
@@ -89,7 +89,7 @@ static int dma_iommu_dma_supported(struct device *dev, u64 mask)
 		return 1;
 }
 
-struct dma_map_ops dma_iommu_ops = {
+const struct dma_map_ops dma_iommu_ops = {
 	.alloc_coherent	= dma_iommu_alloc_coherent,
 	.free_coherent	= dma_iommu_free_coherent,
 	.map_sg		= dma_iommu_map_sg,
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index e96cbbd..bdd6d41 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -31,7 +31,7 @@ unsigned int ppc_swiotlb_enable;
  * map_page, and unmap_page on highmem, use normal dma_ops
  * for everything else.
  */
-struct dma_map_ops swiotlb_dma_ops = {
+const struct dma_map_ops swiotlb_dma_ops = {
 	.alloc_coherent = dma_direct_alloc_coherent,
 	.free_coherent = dma_direct_free_coherent,
 	.map_sg = swiotlb_map_sg_attrs,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 6215062..ebea59c 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -134,7 +134,7 @@ static inline void dma_direct_sync_single_range(struct device *dev,
 }
 #endif
 
-struct dma_map_ops dma_direct_ops = {
+const struct dma_map_ops dma_direct_ops = {
 	.alloc_coherent	= dma_direct_alloc_coherent,
 	.free_coherent	= dma_direct_free_coherent,
 	.map_sg		= dma_direct_map_sg,
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index a4c8b38..1b09ad9 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -127,7 +127,7 @@ static int ibmebus_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static struct dma_map_ops ibmebus_dma_ops = {
+static const struct dma_map_ops ibmebus_dma_ops = {
 	.alloc_coherent = ibmebus_alloc_coherent,
 	.free_coherent  = ibmebus_free_coherent,
 	.map_sg         = ibmebus_map_sg,
-- 
1.6.5.3

