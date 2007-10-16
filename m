Return-Path: <linux-kernel-owner+w=401wt.eu-S935143AbXJPT5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935143AbXJPT5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934667AbXJPT53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:57:29 -0400
Received: from ozlabs.org ([203.10.76.45]:53017 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934252AbXJPT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:57:27 -0400
Date: Tue, 16 Oct 2007 14:54:33 -0500
From: Anton Blanchard <anton@samba.org>
To: torvalds@linux-foundation.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix powerpc breakage in sg chaining code
Message-ID: <20071016195433.GA15297@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 78bdc3106a877cfa50439fa66b52acbc4e7868df PPC: sg chaining support
looks to have removed some unrelated ppc code. Lets put it back in.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index 2af321f..65be95d 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -6,6 +6,149 @@
  */
 #ifndef _ASM_DMA_MAPPING_H
 #define _ASM_DMA_MAPPING_H
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/cache.h>
+/* need struct page definitions */
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <asm/io.h>
+
+#define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
+
+#ifdef CONFIG_NOT_COHERENT_CACHE
+/*
+ * DMA-consistent mapping functions for PowerPCs that don't support
+ * cache snooping.  These allocate/free a region of uncached mapped
+ * memory space for use with DMA devices.  Alternatively, you could
+ * allocate the space "normally" and use the cache management functions
+ * to ensure it is consistent.
+ */
+extern void *__dma_alloc_coherent(size_t size, dma_addr_t *handle, gfp_t gfp);
+extern void __dma_free_coherent(size_t size, void *vaddr);
+extern void __dma_sync(void *vaddr, size_t size, int direction);
+extern void __dma_sync_page(struct page *page, unsigned long offset,
+				 size_t size, int direction);
+
+#else /* ! CONFIG_NOT_COHERENT_CACHE */
+/*
+ * Cache coherent cores.
+ */
+
+#define __dma_alloc_coherent(gfp, size, handle)	NULL
+#define __dma_free_coherent(size, addr)		((void)0)
+#define __dma_sync(addr, size, rw)		((void)0)
+#define __dma_sync_page(pg, off, sz, rw)	((void)0)
+
+#endif /* ! CONFIG_NOT_COHERENT_CACHE */
+
+#ifdef CONFIG_PPC64
+/*
+ * DMA operations are abstracted for G5 vs. i/pSeries, PCI vs. VIO
+ */
+struct dma_mapping_ops {
+	void *		(*alloc_coherent)(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t flag);
+	void		(*free_coherent)(struct device *dev, size_t size,
+				void *vaddr, dma_addr_t dma_handle);
+	dma_addr_t	(*map_single)(struct device *dev, void *ptr,
+				size_t size, enum dma_data_direction direction);
+	void		(*unmap_single)(struct device *dev, dma_addr_t dma_addr,
+				size_t size, enum dma_data_direction direction);
+	int		(*map_sg)(struct device *dev, struct scatterlist *sg,
+				int nents, enum dma_data_direction direction);
+	void		(*unmap_sg)(struct device *dev, struct scatterlist *sg,
+				int nents, enum dma_data_direction direction);
+	int		(*dma_supported)(struct device *dev, u64 mask);
+	int		(*set_dma_mask)(struct device *dev, u64 dma_mask);
+};
+
+static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
+{
+	/* We don't handle the NULL dev case for ISA for now. We could
+	 * do it via an out of line call but it is not needed for now. The
+	 * only ISA DMA device we support is the floppy and we have a hack
+	 * in the floppy driver directly to get a device for us.
+	 */
+	if (unlikely(dev == NULL || dev->archdata.dma_ops == NULL))
+		return NULL;
+	return dev->archdata.dma_ops;
+}
+
+static inline int dma_supported(struct device *dev, u64 mask)
+{
+	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+
+	if (unlikely(dma_ops == NULL))
+		return 0;
+	if (dma_ops->dma_supported == NULL)
+		return 1;
+	return dma_ops->dma_supported(dev, mask);
+}
+
+static inline int dma_set_mask(struct device *dev, u64 dma_mask)
+{
+	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+
+	if (unlikely(dma_ops == NULL))
+		return -EIO;
+	if (dma_ops->set_dma_mask != NULL)
+		return dma_ops->set_dma_mask(dev, dma_mask);
+	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
+		return -EIO;
+	*dev->dma_mask = dma_mask;
+	return 0;
+}
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag)
+{
+	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+
+	BUG_ON(!dma_ops);
+	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
+{
+	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+
+	BUG_ON(!dma_ops);
+	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
+}
+
+static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
+					size_t size,
+					enum dma_data_direction direction)
+{
+	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+
+	BUG_ON(!dma_ops);
+	return dma_ops->map_single(dev, cpu_addr, size, direction);
+}
+
+static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+				    size_t size,
+				    enum dma_data_direction direction)
+{
+	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+
+	BUG_ON(!dma_ops);
+	dma_ops->unmap_single(dev, dma_addr, size, direction);
+}
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction direction)
+{
+	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
+
+	BUG_ON(!dma_ops);
+	return dma_ops->map_single(dev, page_address(page) + offset, size,
+			direction);
+}
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 				  size_t size,
