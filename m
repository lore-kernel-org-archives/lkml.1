Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZGMG3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZGMG3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZGMG3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:29:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:60453 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbZGMG2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:52 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH 3/8] sparc: use dma_map_ops struct
Date: Mon, 13 Jul 2009 15:25:55 +0900
Message-Id: <1247466360-13330-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
---
 arch/sparc/include/asm/dma-mapping.h |   43 +++++----------------------------
 arch/sparc/kernel/dma.c              |   16 ++++++++----
 arch/sparc/kernel/iommu.c            |   16 ++++++++----
 arch/sparc/kernel/pci_sun4v.c        |   14 +++++++----
 4 files changed, 36 insertions(+), 53 deletions(-)

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 204e4bf..893f3ec 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -13,36 +13,7 @@ extern int dma_set_mask(struct device *dev, u64 dma_mask);
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
 
-struct dma_ops {
-	void *(*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t flag);
-	void (*free_coherent)(struct device *dev, size_t size,
-			      void *cpu_addr, dma_addr_t dma_handle);
-	dma_addr_t (*map_page)(struct device *dev, struct page *page,
-			       unsigned long offset, size_t size,
-			       enum dma_data_direction direction);
-	void (*unmap_page)(struct device *dev, dma_addr_t dma_addr,
-			   size_t size,
-			   enum dma_data_direction direction);
-	int (*map_sg)(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction direction);
-	void (*unmap_sg)(struct device *dev, struct scatterlist *sg,
-			 int nhwentries,
-			 enum dma_data_direction direction);
-	void (*sync_single_for_cpu)(struct device *dev,
-				    dma_addr_t dma_handle, size_t size,
-				    enum dma_data_direction direction);
-	void (*sync_single_for_device)(struct device *dev,
-				       dma_addr_t dma_handle, size_t size,
-				       enum dma_data_direction direction);
-	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
-				int nelems,
-				enum dma_data_direction direction);
-	void (*sync_sg_for_device)(struct device *dev,
-				   struct scatterlist *sg, int nents,
-				   enum dma_data_direction dir);
-};
-extern const struct dma_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
@@ -62,40 +33,40 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
 {
 	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
 				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
-				 direction);
+				 direction, NULL);
 }
 
 static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
 				    size_t size,
 				    enum dma_data_direction direction)
 {
-	dma_ops->unmap_page(dev, dma_addr, size, direction);
+	dma_ops->unmap_page(dev, dma_addr, size, direction, NULL);
 }
 
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      unsigned long offset, size_t size,
 				      enum dma_data_direction direction)
 {
-	return dma_ops->map_page(dev, page, offset, size, direction);
+	return dma_ops->map_page(dev, page, offset, size, direction, NULL);
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 				  size_t size,
 				  enum dma_data_direction direction)
 {
-	dma_ops->unmap_page(dev, dma_address, size, direction);
+	dma_ops->unmap_page(dev, dma_address, size, direction, NULL);
 }
 
 static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
 			     int nents, enum dma_data_direction direction)
 {
-	return dma_ops->map_sg(dev, sg, nents, direction);
+	return dma_ops->map_sg(dev, sg, nents, direction, NULL);
 }
 
 static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 				int nents, enum dma_data_direction direction)
 {
-	dma_ops->unmap_sg(dev, sg, nents, direction);
+	dma_ops->unmap_sg(dev, sg, nents, direction, NULL);
 }
 
 static inline void dma_sync_single_for_cpu(struct device *dev,
diff --git a/arch/sparc/kernel/dma.c b/arch/sparc/kernel/dma.c
index 524c32f..473a3fc 100644
--- a/arch/sparc/kernel/dma.c
+++ b/arch/sparc/kernel/dma.c
@@ -60,7 +60,8 @@ static void dma32_free_coherent(struct device *dev, size_t size,
 
 static dma_addr_t dma32_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
+				 enum dma_data_direction direction,
+				 struct dma_attrs *attrs)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -72,7 +73,8 @@ static dma_addr_t dma32_map_page(struct device *dev, struct page *page,
 }
 
 static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
-			     size_t size, enum dma_data_direction direction)
+			     size_t size, enum dma_data_direction direction,
+			     struct dma_attrs *attrs)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -85,7 +87,8 @@ static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
 }
 
 static int dma32_map_sg(struct device *dev, struct scatterlist *sg,
-			int nents, enum dma_data_direction direction)
+			int nents, enum dma_data_direction direction,
+			struct dma_attrs *attrs)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -95,7 +98,8 @@ static int dma32_map_sg(struct device *dev, struct scatterlist *sg,
 }
 
 void dma32_unmap_sg(struct device *dev, struct scatterlist *sg,
-		    int nents, enum dma_data_direction direction)
+		    int nents, enum dma_data_direction direction,
+		    struct dma_attrs *attrs)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -161,7 +165,7 @@ static void dma32_sync_sg_for_device(struct device *dev,
 	BUG();
 }
 
-static const struct dma_ops dma32_dma_ops = {
+static const struct dma_map_ops dma32_dma_ops = {
 	.alloc_coherent		= dma32_alloc_coherent,
 	.free_coherent		= dma32_free_coherent,
 	.map_page		= dma32_map_page,
@@ -174,5 +178,5 @@ static const struct dma_ops dma32_dma_ops = {
 	.sync_sg_for_device	= dma32_sync_sg_for_device,
 };
 
-const struct dma_ops *dma_ops = &dma32_dma_ops;
+const struct dma_map_ops *dma_ops = &dma32_dma_ops;
 EXPORT_SYMBOL(dma_ops);
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 0aeaefe..a9f0ad9 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -353,7 +353,8 @@ static void dma_4u_free_coherent(struct device *dev, size_t size,
 
 static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
-				  enum dma_data_direction direction)
+				  enum dma_data_direction direction,
+				  struct dma_attrs *attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -474,7 +475,8 @@ do_flush_sync:
 }
 
 static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
-			      size_t sz, enum dma_data_direction direction)
+			      size_t sz, enum dma_data_direction direction,
+			      struct dma_attrs *attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -520,7 +522,8 @@ static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
 }
 
 static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
-			 int nelems, enum dma_data_direction direction)
+			 int nelems, enum dma_data_direction direction,
+			 struct dma_attrs *attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot, ctx;
@@ -691,7 +694,8 @@ static unsigned long fetch_sg_ctx(struct iommu *iommu, struct scatterlist *sg)
 }
 
 static void dma_4u_unmap_sg(struct device *dev, struct scatterlist *sglist,
-			    int nelems, enum dma_data_direction direction)
+			    int nelems, enum dma_data_direction direction,
+			    struct dma_attrs *attrs)
 {
 	unsigned long flags, ctx;
 	struct scatterlist *sg;
@@ -822,7 +826,7 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static const struct dma_ops sun4u_dma_ops = {
+static const struct dma_map_ops sun4u_dma_ops = {
 	.alloc_coherent		= dma_4u_alloc_coherent,
 	.free_coherent		= dma_4u_free_coherent,
 	.map_page		= dma_4u_map_page,
@@ -833,7 +837,7 @@ static const struct dma_ops sun4u_dma_ops = {
 	.sync_sg_for_cpu	= dma_4u_sync_sg_for_cpu,
 };
 
-const struct dma_ops *dma_ops = &sun4u_dma_ops;
+const struct dma_map_ops *dma_ops = &sun4u_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 int dma_supported(struct device *dev, u64 device_mask)
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 2485eaa..c4f7dce 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -232,7 +232,8 @@ static void dma_4v_free_coherent(struct device *dev, size_t size, void *cpu,
 
 static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
-				  enum dma_data_direction direction)
+				  enum dma_data_direction direction,
+				  struct dma_attrs *attrs)
 {
 	struct iommu *iommu;
 	unsigned long flags, npages, oaddr;
@@ -296,7 +297,8 @@ iommu_map_fail:
 }
 
 static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
-			      size_t sz, enum dma_data_direction direction)
+			      size_t sz, enum dma_data_direction direction,
+			      struct dma_attrs *attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -336,7 +338,8 @@ static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
 }
 
 static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
-			 int nelems, enum dma_data_direction direction)
+			 int nelems, enum dma_data_direction direction,
+			 struct dma_attrs *attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot;
@@ -478,7 +481,8 @@ iommu_map_failed:
 }
 
 static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
-			    int nelems, enum dma_data_direction direction)
+			    int nelems, enum dma_data_direction direction,
+			    struct dma_attrs *attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct scatterlist *sg;
@@ -535,7 +539,7 @@ static void dma_4v_sync_sg_for_cpu(struct device *dev,
 	/* Nothing to do... */
 }
 
-static const struct dma_ops sun4v_dma_ops = {
+static const struct dma_map_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
 	.map_page			= dma_4v_map_page,
-- 
1.6.0.6

