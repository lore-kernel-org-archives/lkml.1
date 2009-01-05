Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZAEPA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZAEPA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZAEO7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:59:46 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58523 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZAEO7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:59:45 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: tony.luck@intel.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] add common struct for dma map operations
Date: Mon,  5 Jan 2009 23:59:01 +0900
Message-Id: <1231167543-20259-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231167543-20259-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231167543-20259-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds struct dma_map_ops include/linux/dma-mapping.h, which, is
used to handle multiple sets of dma mapping API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |   48 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ba9114e..d7d090d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -3,6 +3,8 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/dma-attrs.h>
+#include <linux/scatterlist.h>
 
 /* These definitions mirror those in pci.h, so they can be used
  * interchangeably with their PCI_ counterparts */
@@ -13,6 +15,52 @@ enum dma_data_direction {
 	DMA_NONE = 3,
 };
 
+struct dma_map_ops {
+	void* (*alloc_coherent)(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t gfp);
+	void (*free_coherent)(struct device *dev, size_t size,
+			      void *vaddr, dma_addr_t dma_handle);
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction dir,
+			       struct dma_attrs *attrs);
+	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
+			   size_t size, enum dma_data_direction dir,
+			   struct dma_attrs *attrs);
+	int (*map_sg)(struct device *dev, struct scatterlist *sg,
+		      int nents, enum dma_data_direction dir,
+		      struct dma_attrs *attrs);
+	void (*unmap_sg)(struct device *dev,
+			 struct scatterlist *sg, int nents,
+			 enum dma_data_direction dir,
+			 struct dma_attrs *attrs);
+	void (*sync_single_for_cpu)(struct device *dev,
+				    dma_addr_t dma_handle, size_t size,
+				    enum dma_data_direction dir);
+	void (*sync_single_for_device)(struct device *dev,
+				       dma_addr_t dma_handle, size_t size,
+				       enum dma_data_direction dir);
+	void (*sync_single_range_for_cpu)(struct device *dev,
+					  dma_addr_t dma_handle,
+					  unsigned long offset,
+					  size_t size,
+					  enum dma_data_direction dir);
+	void (*sync_single_range_for_device)(struct device *dev,
+					     dma_addr_t dma_handle,
+					     unsigned long offset,
+					     size_t size,
+					     enum dma_data_direction dir);
+	void (*sync_sg_for_cpu)(struct device *dev,
+				struct scatterlist *sg, int nents,
+				enum dma_data_direction dir);
+	void (*sync_sg_for_device)(struct device *dev,
+				   struct scatterlist *sg, int nents,
+				   enum dma_data_direction dir);
+	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
+	int (*dma_supported)(struct device *dev, u64 mask);
+	int is_phys;
+};
+
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
 /*
-- 
1.6.0.6

