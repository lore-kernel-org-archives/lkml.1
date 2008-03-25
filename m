Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbYCYVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbYCYVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbYCYViS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022AbYCYViR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:17 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 01/20] x86: move dma_ops struct definition to dma-mapping.h
Date: Tue, 25 Mar 2008 18:36:20 -0300
Message-Id: <1206480999-21767-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

take it off the x86_64 specific header

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/dma-mapping.h    |   54 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/dma-mapping_64.h |   49 ----------------------------------
 2 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 58f790f..aebd178 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -1,5 +1,59 @@
+#ifndef _ASM_DMA_MAPPING_H_
+#define _ASM_DMA_MAPPING_H_
+
+/*
+ * IOMMU interface. See Documentation/DMA-mapping.txt and DMA-API.txt for
+ * documentation.
+ */
+
+#include <linux/scatterlist.h>
+#include <asm/io.h>
+#include <asm/swiotlb.h>
+
+struct dma_mapping_ops {
+	int             (*mapping_error)(dma_addr_t dma_addr);
+	void*           (*alloc_coherent)(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t gfp);
+	void            (*free_coherent)(struct device *dev, size_t size,
+				void *vaddr, dma_addr_t dma_handle);
+	dma_addr_t      (*map_single)(struct device *hwdev, void *ptr,
+				size_t size, int direction);
+	/* like map_single, but doesn't check the device mask */
+	dma_addr_t      (*map_simple)(struct device *hwdev, char *ptr,
+				size_t size, int direction);
+	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
+				size_t size, int direction);
+	void            (*sync_single_for_cpu)(struct device *hwdev,
+				dma_addr_t dma_handle, size_t size,
+				int direction);
+	void            (*sync_single_for_device)(struct device *hwdev,
+				dma_addr_t dma_handle, size_t size,
+				int direction);
+	void            (*sync_single_range_for_cpu)(struct device *hwdev,
+				dma_addr_t dma_handle, unsigned long offset,
+				size_t size, int direction);
+	void            (*sync_single_range_for_device)(struct device *hwdev,
+				dma_addr_t dma_handle, unsigned long offset,
+				size_t size, int direction);
+	void            (*sync_sg_for_cpu)(struct device *hwdev,
+				struct scatterlist *sg, int nelems,
+				int direction);
+	void            (*sync_sg_for_device)(struct device *hwdev,
+				struct scatterlist *sg, int nelems,
+				int direction);
+	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
+				int nents, int direction);
+	void            (*unmap_sg)(struct device *hwdev,
+				struct scatterlist *sg, int nents,
+				int direction);
+	int             (*dma_supported)(struct device *hwdev, u64 mask);
+	int		is_phys;
+};
+
 #ifdef CONFIG_X86_32
 # include "dma-mapping_32.h"
 #else
 # include "dma-mapping_64.h"
 #endif
+
+#endif
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index ecd0f61..369188a 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -1,55 +1,6 @@
 #ifndef _X8664_DMA_MAPPING_H
 #define _X8664_DMA_MAPPING_H 1
 
-/*
- * IOMMU interface. See Documentation/DMA-mapping.txt and DMA-API.txt for
- * documentation.
- */
-
-#include <linux/scatterlist.h>
-#include <asm/io.h>
-#include <asm/swiotlb.h>
-
-struct dma_mapping_ops {
-	int             (*mapping_error)(dma_addr_t dma_addr);
-	void*           (*alloc_coherent)(struct device *dev, size_t size,
-                                dma_addr_t *dma_handle, gfp_t gfp);
-	void            (*free_coherent)(struct device *dev, size_t size,
-                                void *vaddr, dma_addr_t dma_handle);
-	dma_addr_t      (*map_single)(struct device *hwdev, void *ptr,
-                                size_t size, int direction);
-	/* like map_single, but doesn't check the device mask */
-	dma_addr_t      (*map_simple)(struct device *hwdev, char *ptr,
-                                size_t size, int direction);
-	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-		                size_t size, int direction);
-	void            (*sync_single_for_cpu)(struct device *hwdev,
-		                dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_for_device)(struct device *hwdev,
-                                dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_range_for_cpu)(struct device *hwdev,
-                                dma_addr_t dma_handle, unsigned long offset,
-		                size_t size, int direction);
-	void            (*sync_single_range_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-		                size_t size, int direction);
-	void            (*sync_sg_for_cpu)(struct device *hwdev,
-                                struct scatterlist *sg, int nelems,
-				int direction);
-	void            (*sync_sg_for_device)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-		                int nents, int direction);
-	void            (*unmap_sg)(struct device *hwdev,
-				struct scatterlist *sg, int nents,
-				int direction);
-	int             (*dma_supported)(struct device *hwdev, u64 mask);
-	int		is_phys;
-};
-
 extern dma_addr_t bad_dma_address;
 extern const struct dma_mapping_ops* dma_ops;
 extern int iommu_merge;
-- 
1.5.0.6

