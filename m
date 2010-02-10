Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0BJUh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:37:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab0BJUhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:37:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5888"; a="33877072"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH 2/2] dma: fix scatter-gather api to use barrierless map/unmap functions
Date: Wed, 10 Feb 2010 12:37:30 -0800
Message-Id: <1265834250-29170-3-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

dma_map/unmap_sg need to execute barrier only after the last buffer has been
mapped/unmapped. This imporves performance in situations where multiple
buffers need to be mapped for a single DMA operation.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/include/asm/dma-mapping.h |   87 ++++++++++++++++++++++++++++++++++++
 arch/arm/mm/dma-mapping.c          |   59 +++++++++++++++++++++---
 2 files changed, 139 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 256ee1c..06b528d 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -110,6 +110,26 @@ static inline void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
 		___dma_page_dev_to_cpu(page, off, size, dir);
 }
 
+static inline void __dma_page_cpu_to_dev_nobarrier(struct page *page,
+	unsigned long off, size_t size, enum dma_data_direction dir)
+{
+	extern void ___dma_page_cpu_to_dev_nobarrier(struct page *,
+		unsigned long, size_t, enum dma_data_direction);
+
+	if (!arch_is_coherent())
+		___dma_page_cpu_to_dev_nobarrier(page, off, size, dir);
+}
+
+static inline void __dma_page_dev_to_cpu_nobarrier(struct page *page,
+	unsigned long off, size_t size, enum dma_data_direction dir)
+{
+	extern void ___dma_page_dev_to_cpu_nobarrier(struct page *,
+		unsigned long, size_t, enum dma_data_direction);
+
+	if (!arch_is_coherent())
+		___dma_page_dev_to_cpu_nobarrier(page, off, size, dir);
+}
+
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
@@ -305,6 +325,23 @@ extern void dma_unmap_page(struct device *, dma_addr_t, size_t,
 		enum dma_data_direction);
 
 /*
+ * for DMA_BOUNCE we keep the nobarrier version same as their barriered
+ * counterpart
+ */
+static inline dma_addr_t dma_map_page_nobarrier(struct device *dev,
+		struct page *page, unsigned long offset, size_t size,
+		enum dma_data_direction dir)
+{
+	return dma_map_page(dev, page, offset, size, dir);
+}
+
+static inline void dma_unmap_page_nobarrier(struct device *dev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	return dma_unmap_page(dev, handle, size, dir);
+}
+
+/*
  * Private functions
  */
 int dmabounce_sync_for_cpu(struct device *, dma_addr_t, unsigned long,
@@ -374,6 +411,34 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 }
 
 /**
+ * dma_map_page_nobarrier - map a portion of a page for streaming DMA without a
+ * barrier
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @page: page that buffer resides in
+ * @offset: offset into page for start of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Once this call is followed by a barrier it is ensured that any data held
+ * in the cache is appropriately  discarded or written back.
+ *
+ * The device owns this memory once this call has completed and a barrier is
+ * executed.  The CPU
+ * can regain ownership by calling dma_unmap_page() or
+ * dma_unmap_page_nobarrier() followed by a barrier.
+ */
+static inline dma_addr_t dma_map_page_nobarrier(struct device *dev,
+		struct page *page, unsigned long offset, size_t size,
+		enum dma_data_direction dir)
+{
+	BUG_ON(!valid_dma_direction(dir));
+
+	__dma_page_cpu_to_dev_nobarrier(page, offset, size, dir);
+
+	return page_to_dma(dev, page) + offset;
+}
+
+/**
  * dma_unmap_single - unmap a single buffer previously mapped
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
  * @handle: DMA address of buffer
@@ -413,6 +478,28 @@ static inline void dma_unmap_page(struct device *dev, dma_addr_t handle,
 	__dma_page_dev_to_cpu(dma_to_page(dev, handle), handle & ~PAGE_MASK,
 		size, dir);
 }
+
+/**
+ * dma_unmap_page_nobarrier - unmap a buffer previously mapped through dma_map_page()
+ * or dma_map_page_nobarrier() followed by a barrier
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer (same as passed to dma_map_page)
+ * @dir: DMA transfer direction (same as passed to dma_map_page)
+ *
+ * Unmap a page streaming mode DMA translation.  The handle and size
+ * must match what was provided in the previous dma_map_page() call.
+ * All other usages are undefined.
+ *
+ * After this call, followed by a barrier(dsb/dmb), reads by the CPU to the
+ * buffer are guaranteed to see whatever the device wrote there.
+ */
+static inline void dma_unmap_page_nobarrier(struct device *dev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	__dma_page_dev_to_cpu_nobarrier(dma_to_page(dev, handle),
+		handle & ~PAGE_MASK, size, dir);
+}
 #endif /* CONFIG_DMABOUNCE */
 
 /**
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 64daef2..23556ab 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -509,6 +509,37 @@ void ___dma_page_dev_to_cpu(struct page *page, unsigned long off,
 }
 EXPORT_SYMBOL(___dma_page_dev_to_cpu);
 
+
+void ___dma_page_cpu_to_dev_nobarrier(struct page *page, unsigned long off,
+	size_t size, enum dma_data_direction dir)
+{
+	unsigned long paddr;
+
+	dma_cache_maint_page(page, off, size, dir, dmac_map_area_nobarrier);
+
+	paddr = page_to_phys(page) + off;
+	if (dir == DMA_FROM_DEVICE) {
+		outer_inv_range(paddr, paddr + size);
+	} else {
+		outer_clean_range(paddr, paddr + size);
+	}
+	/* FIXME: non-speculating: flush on bidirectional mappings? */
+}
+EXPORT_SYMBOL(___dma_page_cpu_to_dev_nobarrier);
+
+void ___dma_page_dev_to_cpu_nobarrier(struct page *page, unsigned long off,
+	size_t size, enum dma_data_direction dir)
+{
+	unsigned long paddr = page_to_phys(page) + off;
+
+	/* FIXME: non-speculating: not required */
+	/* don't bother invalidating if DMA to device */
+	if (dir != DMA_TO_DEVICE)
+		outer_inv_range(paddr, paddr + size);
+
+	dma_cache_maint_page(page, off, size, dir, dmac_unmap_area_nobarrier);
+}
+EXPORT_SYMBOL(___dma_page_dev_to_cpu_nobarrier);
 /**
  * dma_map_sg - map a set of SG buffers for streaming mode DMA
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
@@ -531,17 +562,28 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	struct scatterlist *s;
 	int i, j;
 
-	for_each_sg(sg, s, nents, i) {
-		s->dma_address = dma_map_page(dev, sg_page(s), s->offset,
-						s->length, dir);
+	for_each_sg(sg, s, nents - 1 , i) {
+		s->dma_address = dma_map_page_nobarrier(dev, sg_page(s),
+					s->offset, s->length, dir);
 		if (dma_mapping_error(dev, s->dma_address))
 			goto bad_mapping;
 	}
+
+	s = sg_next(s);
+	i++;
+	s->dma_address = dma_map_page(dev, sg_page(s), s->offset,
+					s->length, dir);
+	if (dma_mapping_error(dev, s->dma_address))
+		goto bad_mapping;
+
 	return nents;
 
  bad_mapping:
-	for_each_sg(sg, s, i, j)
-		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+	for_each_sg(sg, s, i - 1, j)
+		dma_unmap_page_nobarrier(dev, sg_dma_address(s),
+						sg_dma_len(s), dir);
+	s = sg_next(s);
+	dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
 	return 0;
 }
 EXPORT_SYMBOL(dma_map_sg);
@@ -562,8 +604,11 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 	struct scatterlist *s;
 	int i;
 
-	for_each_sg(sg, s, nents, i)
-		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+	for_each_sg(sg, s, nents - 1, i)
+		dma_unmap_page_nobarrier(dev, sg_dma_address(s),
+						sg_dma_len(s), dir);
+	s = sg_next(s);
+	dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
 }
 EXPORT_SYMBOL(dma_unmap_sg);
 
-- 
1.5.6.3

