Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZGMG3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZGMG3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZGMG3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:29:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:60452 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbZGMG2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:52 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH 4/8] sparc: use asm-generic/dma-mapping-common.h
Date: Mon, 13 Jul 2009 15:25:56 +0900
Message-Id: <1247466360-13330-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
 arch/sparc/Kconfig                   |    1 +
 arch/sparc/include/asm/dma-mapping.h |  107 ++++-----------------------------
 arch/sparc/kernel/dma.c              |    4 +-
 arch/sparc/kernel/iommu.c            |    4 +-
 arch/sparc/kernel/pci_sun4v.c        |    2 +-
 5 files changed, 19 insertions(+), 99 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3f8b6a9..5f2df99 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -25,6 +25,7 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
+	select HAVE_DMA_ATTRS
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 893f3ec..34c9226 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -3,6 +3,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
+#include <linux/dma-debug.h>
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
@@ -13,113 +14,31 @@ extern int dma_set_mask(struct device *dev, u64 dma_mask);
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
 
-extern const struct dma_map_ops *dma_ops;
+extern struct dma_map_ops *dma_ops;
 
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag)
-{
-	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
-}
-
-static inline void dma_free_coherent(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle)
-{
-	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
-}
-
-static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-					size_t size,
-					enum dma_data_direction direction)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
-				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
-				 direction, NULL);
+	return dma_ops;
 }
 
-static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-				    size_t size,
-				    enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_addr, size, direction, NULL);
-}
-
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction direction)
-{
-	return dma_ops->map_page(dev, page, offset, size, direction, NULL);
-}
+#include <asm-generic/dma-mapping-common.h>
 
-static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-				  size_t size,
-				  enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_address, size, direction, NULL);
-}
-
-static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     int nents, enum dma_data_direction direction)
-{
-	return dma_ops->map_sg(dev, sg, nents, direction, NULL);
-}
-
-static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction direction)
-{
-	dma_ops->unmap_sg(dev, sg, nents, direction, NULL);
-}
-
-static inline void dma_sync_single_for_cpu(struct device *dev,
-					   dma_addr_t dma_handle, size_t size,
-					   enum dma_data_direction direction)
-{
-	dma_ops->sync_single_for_cpu(dev, dma_handle, size, direction);
-}
-
-static inline void dma_sync_single_for_device(struct device *dev,
-					      dma_addr_t dma_handle,
-					      size_t size,
-					      enum dma_data_direction direction)
-{
-	if (dma_ops->sync_single_for_device)
-		dma_ops->sync_single_for_device(dev, dma_handle, size,
-						direction);
-}
-
-static inline void dma_sync_sg_for_cpu(struct device *dev,
-				       struct scatterlist *sg, int nelems,
-				       enum dma_data_direction direction)
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	dma_ops->sync_sg_for_cpu(dev, sg, nelems, direction);
-}
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
-static inline void dma_sync_sg_for_device(struct device *dev,
-					  struct scatterlist *sg, int nelems,
-					  enum dma_data_direction direction)
-{
-	if (dma_ops->sync_sg_for_device)
-		dma_ops->sync_sg_for_device(dev, sg, nelems, direction);
+	return ops->alloc_coherent(dev, size, dma_handle, flag);
 }
 
-static inline void dma_sync_single_range_for_cpu(struct device *dev,
-						 dma_addr_t dma_handle,
-						 unsigned long offset,
-						 size_t size,
-						 enum dma_data_direction dir)
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	dma_sync_single_for_cpu(dev, dma_handle+offset, size, dir);
-}
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
-static inline void dma_sync_single_range_for_device(struct device *dev,
-						    dma_addr_t dma_handle,
-						    unsigned long offset,
-						    size_t size,
-						    enum dma_data_direction dir)
-{
-	dma_sync_single_for_device(dev, dma_handle+offset, size, dir);
+	ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return (dma_addr == DMA_ERROR_CODE);
diff --git a/arch/sparc/kernel/dma.c b/arch/sparc/kernel/dma.c
index 473a3fc..15820a9 100644
--- a/arch/sparc/kernel/dma.c
+++ b/arch/sparc/kernel/dma.c
@@ -165,7 +165,7 @@ static void dma32_sync_sg_for_device(struct device *dev,
 	BUG();
 }
 
-static const struct dma_map_ops dma32_dma_ops = {
+static struct dma_map_ops dma32_dma_ops = {
 	.alloc_coherent		= dma32_alloc_coherent,
 	.free_coherent		= dma32_free_coherent,
 	.map_page		= dma32_map_page,
@@ -178,5 +178,5 @@ static const struct dma_map_ops dma32_dma_ops = {
 	.sync_sg_for_device	= dma32_sync_sg_for_device,
 };
 
-const struct dma_map_ops *dma_ops = &dma32_dma_ops;
+struct dma_map_ops *dma_ops = &dma32_dma_ops;
 EXPORT_SYMBOL(dma_ops);
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index a9f0ad9..74b289c 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -826,7 +826,7 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static const struct dma_map_ops sun4u_dma_ops = {
+static struct dma_map_ops sun4u_dma_ops = {
 	.alloc_coherent		= dma_4u_alloc_coherent,
 	.free_coherent		= dma_4u_free_coherent,
 	.map_page		= dma_4u_map_page,
@@ -837,7 +837,7 @@ static const struct dma_map_ops sun4u_dma_ops = {
 	.sync_sg_for_cpu	= dma_4u_sync_sg_for_cpu,
 };
 
-const struct dma_map_ops *dma_ops = &sun4u_dma_ops;
+struct dma_map_ops *dma_ops = &sun4u_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 int dma_supported(struct device *dev, u64 device_mask)
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index c4f7dce..ee800f9 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -539,7 +539,7 @@ static void dma_4v_sync_sg_for_cpu(struct device *dev,
 	/* Nothing to do... */
 }
 
-static const struct dma_map_ops sun4v_dma_ops = {
+static struct dma_map_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
 	.map_page			= dma_4v_map_page,
-- 
1.6.0.6

