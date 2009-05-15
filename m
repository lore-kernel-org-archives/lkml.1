Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbZEOCZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbZEOCZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 22:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbZEOCYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 22:24:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:39950 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbZEOCY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 22:24:29 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 3/4] sparc: use dma_map_page instead of dma_map_single
Date: Fri, 15 May 2009 11:23:10 +0900
Message-Id: <1242354191-6232-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 11:24:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts dma_map_single and dma_unmap_single to use
map_page and unmap_page respectively and removes unnecessary
map_single and unmap_single. map_page can be used to implement
map_single but the opposite is impossible. Having only dma_map_page in
struct dma_ops is enough.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc/include/asm/dma-mapping_64.h |   23 ++++++++++++-----------
 arch/sparc/kernel/iommu.c               |   15 ++++++++-------
 arch/sparc/kernel/pci_sun4v.c           |   15 ++++++++-------
 3 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/arch/sparc/include/asm/dma-mapping_64.h b/arch/sparc/include/asm/dma-mapping_64.h
index 0c4fb1f..579757e 100644
--- a/arch/sparc/include/asm/dma-mapping_64.h
+++ b/arch/sparc/include/asm/dma-mapping_64.h
@@ -9,12 +9,12 @@ struct dma_ops {
 				dma_addr_t *dma_handle, gfp_t flag);
 	void (*free_coherent)(struct device *dev, size_t size,
 			      void *cpu_addr, dma_addr_t dma_handle);
-	dma_addr_t (*map_single)(struct device *dev, void *cpu_addr,
-				 size_t size,
-				 enum dma_data_direction direction);
-	void (*unmap_single)(struct device *dev, dma_addr_t dma_addr,
-			     size_t size,
-			     enum dma_data_direction direction);
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction direction);
+	void (*unmap_page)(struct device *dev, dma_addr_t dma_addr,
+			   size_t size,
+			   enum dma_data_direction direction);
 	int (*map_sg)(struct device *dev, struct scatterlist *sg, int nents,
 		      enum dma_data_direction direction);
 	void (*unmap_sg)(struct device *dev, struct scatterlist *sg,
@@ -51,29 +51,30 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
 					size_t size,
 					enum dma_data_direction direction)
 {
-	return dma_ops->map_single(dev, cpu_addr, size, direction);
+	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
+				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
+				 direction);
 }
 
 static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
 				    size_t size,
 				    enum dma_data_direction direction)
 {
-	dma_ops->unmap_single(dev, dma_addr, size, direction);
+	dma_ops->unmap_page(dev, dma_addr, size, direction);
 }
 
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      unsigned long offset, size_t size,
 				      enum dma_data_direction direction)
 {
-	return dma_ops->map_single(dev, page_address(page) + offset,
-				   size, direction);
+	return dma_ops->map_page(dev, page, offset, size, direction);
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 				  size_t size,
 				  enum dma_data_direction direction)
 {
-	dma_ops->unmap_single(dev, dma_address, size, direction);
+	dma_ops->unmap_page(dev, dma_address, size, direction);
 }
 
 static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index d8900e1..0aeaefe 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -351,8 +351,9 @@ static void dma_4u_free_coherent(struct device *dev, size_t size,
 		free_pages((unsigned long)cpu, order);
 }
 
-static dma_addr_t dma_4u_map_single(struct device *dev, void *ptr, size_t sz,
-				    enum dma_data_direction direction)
+static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
+				  unsigned long offset, size_t sz,
+				  enum dma_data_direction direction)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -368,7 +369,7 @@ static dma_addr_t dma_4u_map_single(struct device *dev, void *ptr, size_t sz,
 	if (unlikely(direction == DMA_NONE))
 		goto bad_no_ctx;
 
-	oaddr = (unsigned long)ptr;
+	oaddr = (unsigned long)(page_address(page) + offset);
 	npages = IO_PAGE_ALIGN(oaddr + sz) - (oaddr & IO_PAGE_MASK);
 	npages >>= IO_PAGE_SHIFT;
 
@@ -472,8 +473,8 @@ do_flush_sync:
 		       vaddr, ctx, npages);
 }
 
-static void dma_4u_unmap_single(struct device *dev, dma_addr_t bus_addr,
-				size_t sz, enum dma_data_direction direction)
+static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
+			      size_t sz, enum dma_data_direction direction)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -824,8 +825,8 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 static const struct dma_ops sun4u_dma_ops = {
 	.alloc_coherent		= dma_4u_alloc_coherent,
 	.free_coherent		= dma_4u_free_coherent,
-	.map_single		= dma_4u_map_single,
-	.unmap_single		= dma_4u_unmap_single,
+	.map_page		= dma_4u_map_page,
+	.unmap_page		= dma_4u_unmap_page,
 	.map_sg			= dma_4u_map_sg,
 	.unmap_sg		= dma_4u_unmap_sg,
 	.sync_single_for_cpu	= dma_4u_sync_single_for_cpu,
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 5db5ebe..2485eaa 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -230,8 +230,9 @@ static void dma_4v_free_coherent(struct device *dev, size_t size, void *cpu,
 		free_pages((unsigned long)cpu, order);
 }
 
-static dma_addr_t dma_4v_map_single(struct device *dev, void *ptr, size_t sz,
-				    enum dma_data_direction direction)
+static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
+				  unsigned long offset, size_t sz,
+				  enum dma_data_direction direction)
 {
 	struct iommu *iommu;
 	unsigned long flags, npages, oaddr;
@@ -245,7 +246,7 @@ static dma_addr_t dma_4v_map_single(struct device *dev, void *ptr, size_t sz,
 	if (unlikely(direction == DMA_NONE))
 		goto bad;
 
-	oaddr = (unsigned long)ptr;
+	oaddr = (unsigned long)(page_address(page) + offset);
 	npages = IO_PAGE_ALIGN(oaddr + sz) - (oaddr & IO_PAGE_MASK);
 	npages >>= IO_PAGE_SHIFT;
 
@@ -294,8 +295,8 @@ iommu_map_fail:
 	return DMA_ERROR_CODE;
 }
 
-static void dma_4v_unmap_single(struct device *dev, dma_addr_t bus_addr,
-				size_t sz, enum dma_data_direction direction)
+static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
+			      size_t sz, enum dma_data_direction direction)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -537,8 +538,8 @@ static void dma_4v_sync_sg_for_cpu(struct device *dev,
 static const struct dma_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
-	.map_single			= dma_4v_map_single,
-	.unmap_single			= dma_4v_unmap_single,
+	.map_page			= dma_4v_map_page,
+	.unmap_page			= dma_4v_unmap_page,
 	.map_sg				= dma_4v_map_sg,
 	.unmap_sg			= dma_4v_unmap_sg,
 	.sync_single_for_cpu		= dma_4v_sync_single_for_cpu,
-- 
1.6.0.6

