Return-Path: <linux-kernel-owner+w=401wt.eu-S1761129AbZEOC0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129AbZEOC0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 22:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbZEOCYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 22:24:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:39949 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbZEOCY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 22:24:29 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 4/4] sparc: remove dma-mapping_{32|64}.h
Date: Fri, 15 May 2009 11:23:11 +0900
Message-Id: <1242354191-6232-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 11:24:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies SPARC32 to use struct dma_map ops. It means that we can
remove dma-mapping_{32|64}.h.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc/include/asm/dma-mapping.h    |  148 +++++++++++++++++++++++++++----
 arch/sparc/include/asm/dma-mapping_32.h |   42 ---------
 arch/sparc/include/asm/dma-mapping_64.h |  121 -------------------------
 arch/sparc/kernel/dma.c                 |   99 ++++++++------------
 4 files changed, 172 insertions(+), 238 deletions(-)
 delete mode 100644 arch/sparc/include/asm/dma-mapping_32.h
 delete mode 100644 arch/sparc/include/asm/dma-mapping_64.h

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 8c911ea..204e4bf 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -1,33 +1,134 @@
 #ifndef ___ASM_SPARC_DMA_MAPPING_H
 #define ___ASM_SPARC_DMA_MAPPING_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/dma-mapping_64.h>
-#else
-#include <asm/dma-mapping_32.h>
-#endif
+
+#include <linux/scatterlist.h>
+#include <linux/mm.h>
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
 extern int dma_supported(struct device *dev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 dma_mask);
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+#define dma_is_consistent(d, h)	(1)
+
+struct dma_ops {
+	void *(*alloc_coherent)(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t flag);
+	void (*free_coherent)(struct device *dev, size_t size,
+			      void *cpu_addr, dma_addr_t dma_handle);
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction direction);
+	void (*unmap_page)(struct device *dev, dma_addr_t dma_addr,
+			   size_t size,
+			   enum dma_data_direction direction);
+	int (*map_sg)(struct device *dev, struct scatterlist *sg, int nents,
+		      enum dma_data_direction direction);
+	void (*unmap_sg)(struct device *dev, struct scatterlist *sg,
+			 int nhwentries,
+			 enum dma_data_direction direction);
+	void (*sync_single_for_cpu)(struct device *dev,
+				    dma_addr_t dma_handle, size_t size,
+				    enum dma_data_direction direction);
+	void (*sync_single_for_device)(struct device *dev,
+				       dma_addr_t dma_handle, size_t size,
+				       enum dma_data_direction direction);
+	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
+				int nelems,
+				enum dma_data_direction direction);
+	void (*sync_sg_for_device)(struct device *dev,
+				   struct scatterlist *sg, int nents,
+				   enum dma_data_direction dir);
+};
+extern const struct dma_ops *dma_ops;
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	return (dma_addr == DMA_ERROR_CODE);
+	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
 }
 
-static inline int dma_get_cache_alignment(void)
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	/*
-	 * no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe
-	 */
-	return (1 << INTERNODE_CACHE_SHIFT);
+	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
+static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
+					size_t size,
+					enum dma_data_direction direction)
+{
+	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
+				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
+				 direction);
+}
+
+static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+				    size_t size,
+				    enum dma_data_direction direction)
+{
+	dma_ops->unmap_page(dev, dma_addr, size, direction);
+}
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction direction)
+{
+	return dma_ops->map_page(dev, page, offset, size, direction);
+}
+
+static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+				  size_t size,
+				  enum dma_data_direction direction)
+{
+	dma_ops->unmap_page(dev, dma_address, size, direction);
+}
+
+static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
+			     int nents, enum dma_data_direction direction)
+{
+	return dma_ops->map_sg(dev, sg, nents, direction);
+}
+
+static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+				int nents, enum dma_data_direction direction)
+{
+	dma_ops->unmap_sg(dev, sg, nents, direction);
+}
+
+static inline void dma_sync_single_for_cpu(struct device *dev,
+					   dma_addr_t dma_handle, size_t size,
+					   enum dma_data_direction direction)
+{
+	dma_ops->sync_single_for_cpu(dev, dma_handle, size, direction);
+}
+
+static inline void dma_sync_single_for_device(struct device *dev,
+					      dma_addr_t dma_handle,
+					      size_t size,
+					      enum dma_data_direction direction)
+{
+	if (dma_ops->sync_single_for_device)
+		dma_ops->sync_single_for_device(dev, dma_handle, size,
+						direction);
+}
+
+static inline void dma_sync_sg_for_cpu(struct device *dev,
+				       struct scatterlist *sg, int nelems,
+				       enum dma_data_direction direction)
+{
+	dma_ops->sync_sg_for_cpu(dev, sg, nelems, direction);
+}
+
+static inline void dma_sync_sg_for_device(struct device *dev,
+					  struct scatterlist *sg, int nelems,
+					  enum dma_data_direction direction)
+{
+	if (dma_ops->sync_sg_for_device)
+		dma_ops->sync_sg_for_device(dev, sg, nelems, direction);
+}
 
 static inline void dma_sync_single_range_for_cpu(struct device *dev,
 						 dma_addr_t dma_handle,
@@ -47,4 +148,19 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 	dma_sync_single_for_device(dev, dma_handle+offset, size, dir);
 }
 
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return (dma_addr == DMA_ERROR_CODE);
+}
+
+static inline int dma_get_cache_alignment(void)
+{
+	/*
+	 * no easy way to get cache size on all processors, so return
+	 * the maximum possible, to be safe
+	 */
+	return (1 << INTERNODE_CACHE_SHIFT);
+}
+
 #endif
diff --git a/arch/sparc/include/asm/dma-mapping_32.h b/arch/sparc/include/asm/dma-mapping_32.h
deleted file mode 100644
index 7f09c85..0000000
--- a/arch/sparc/include/asm/dma-mapping_32.h
+++ /dev/null
@@ -1,42 +0,0 @@
-#ifndef _ASM_SPARC_DMA_MAPPING_H
-#define _ASM_SPARC_DMA_MAPPING_H
-
-#include <linux/types.h>
-
-struct device;
-struct scatterlist;
-struct page;
-
-extern void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t flag);
-extern void dma_free_coherent(struct device *dev, size_t size,
-			      void *cpu_addr, dma_addr_t dma_handle);
-extern dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-				 size_t size,
-				 enum dma_data_direction direction);
-extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-			     size_t size,
-			     enum dma_data_direction direction);
-extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
-			       unsigned long offset, size_t size,
-			       enum dma_data_direction direction);
-extern void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-			   size_t size, enum dma_data_direction direction);
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg,
-		      int nents, enum dma_data_direction direction);
-extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-			 int nents, enum dma_data_direction direction);
-extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				    size_t size,
-				    enum dma_data_direction direction);
-extern void dma_sync_single_for_device(struct device *dev,
-				       dma_addr_t dma_handle,
-				       size_t size,
-				       enum dma_data_direction direction);
-extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-				int nelems, enum dma_data_direction direction);
-extern void dma_sync_sg_for_device(struct device *dev,
-				   struct scatterlist *sg, int nelems,
-				   enum dma_data_direction direction);
-
-#endif /* _ASM_SPARC_DMA_MAPPING_H */
diff --git a/arch/sparc/include/asm/dma-mapping_64.h b/arch/sparc/include/asm/dma-mapping_64.h
deleted file mode 100644
index 579757e..0000000
--- a/arch/sparc/include/asm/dma-mapping_64.h
+++ /dev/null
@@ -1,121 +0,0 @@
-#ifndef _ASM_SPARC64_DMA_MAPPING_H
-#define _ASM_SPARC64_DMA_MAPPING_H
-
-#include <linux/scatterlist.h>
-#include <linux/mm.h>
-
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
-
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
-{
-	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
-				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
-				 direction);
-}
-
-static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-				    size_t size,
-				    enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_addr, size, direction);
-}
-
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction direction)
-{
-	return dma_ops->map_page(dev, page, offset, size, direction);
-}
-
-static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-				  size_t size,
-				  enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_address, size, direction);
-}
-
-static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     int nents, enum dma_data_direction direction)
-{
-	return dma_ops->map_sg(dev, sg, nents, direction);
-}
-
-static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction direction)
-{
-	dma_ops->unmap_sg(dev, sg, nents, direction);
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
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-static inline void dma_sync_sg_for_cpu(struct device *dev,
-				       struct scatterlist *sg, int nelems,
-				       enum dma_data_direction direction)
-{
-	dma_ops->sync_sg_for_cpu(dev, sg, nelems, direction);
-}
-
-static inline void dma_sync_sg_for_device(struct device *dev,
-					  struct scatterlist *sg, int nelems,
-					  enum dma_data_direction direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-#endif /* _ASM_SPARC64_DMA_MAPPING_H */
diff --git a/arch/sparc/kernel/dma.c b/arch/sparc/kernel/dma.c
index 3c9ff4f..524c32f 100644
--- a/arch/sparc/kernel/dma.c
+++ b/arch/sparc/kernel/dma.c
@@ -35,8 +35,8 @@ int dma_set_mask(struct device *dev, u64 dma_mask)
 }
 EXPORT_SYMBOL(dma_set_mask);
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t flag)
+static void *dma32_alloc_coherent(struct device *dev, size_t size,
+				  dma_addr_t *dma_handle, gfp_t flag)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -44,10 +44,9 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 #endif
 	return sbus_alloc_consistent(dev, size, dma_handle);
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
-void dma_free_coherent(struct device *dev, size_t size,
-		       void *cpu_addr, dma_addr_t dma_handle)
+static void dma32_free_coherent(struct device *dev, size_t size,
+				void *cpu_addr, dma_addr_t dma_handle)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -58,38 +57,10 @@ void dma_free_coherent(struct device *dev, size_t size,
 #endif
 	sbus_free_consistent(dev, size, cpu_addr, dma_handle);
 }
-EXPORT_SYMBOL(dma_free_coherent);
 
-dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-			  size_t size, enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_map_single(to_pci_dev(dev), cpu_addr,
-				      size, (int)direction);
-#endif
-	return sbus_map_single(dev, cpu_addr, size, (int)direction);
-}
-EXPORT_SYMBOL(dma_map_single);
-
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-		      size_t size,
-		      enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_unmap_single(to_pci_dev(dev), dma_addr,
-				 size, (int)direction);
-		return;
-	}
-#endif
-	sbus_unmap_single(dev, dma_addr, size, (int)direction);
-}
-EXPORT_SYMBOL(dma_unmap_single);
-
-dma_addr_t dma_map_page(struct device *dev, struct page *page,
-			unsigned long offset, size_t size,
-			enum dma_data_direction direction)
+static dma_addr_t dma32_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -99,10 +70,9 @@ dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	return sbus_map_single(dev, page_address(page) + offset,
 			       size, (int)direction);
 }
-EXPORT_SYMBOL(dma_map_page);
 
-void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-		    size_t size, enum dma_data_direction direction)
+static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
+			     size_t size, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -113,10 +83,9 @@ void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 #endif
 	sbus_unmap_single(dev, dma_address, size, (int)direction);
 }
-EXPORT_SYMBOL(dma_unmap_page);
 
-int dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     int nents, enum dma_data_direction direction)
+static int dma32_map_sg(struct device *dev, struct scatterlist *sg,
+			int nents, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -124,10 +93,9 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg,
 #endif
 	return sbus_map_sg(dev, sg, nents, direction);
 }
-EXPORT_SYMBOL(dma_map_sg);
 
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		  int nents, enum dma_data_direction direction)
+void dma32_unmap_sg(struct device *dev, struct scatterlist *sg,
+		    int nents, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -137,10 +105,10 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 #endif
 	sbus_unmap_sg(dev, sg, nents, (int)direction);
 }
-EXPORT_SYMBOL(dma_unmap_sg);
 
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			     size_t size, enum dma_data_direction direction)
+static void dma32_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				      size_t size,
+				      enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -151,10 +119,10 @@ void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 #endif
 	sbus_dma_sync_single_for_cpu(dev, dma_handle, size, (int) direction);
 }
-EXPORT_SYMBOL(dma_sync_single_for_cpu);
 
-void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-				size_t size, enum dma_data_direction direction)
+static void dma32_sync_single_for_device(struct device *dev,
+					 dma_addr_t dma_handle, size_t size,
+					 enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -165,10 +133,9 @@ void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
 #endif
 	sbus_dma_sync_single_for_device(dev, dma_handle, size, (int) direction);
 }
-EXPORT_SYMBOL(dma_sync_single_for_device);
 
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-			 int nelems, enum dma_data_direction direction)
+static void dma32_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+				  int nelems, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -179,11 +146,10 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 #endif
 	BUG();
 }
-EXPORT_SYMBOL(dma_sync_sg_for_cpu);
 
-void dma_sync_sg_for_device(struct device *dev,
-			    struct scatterlist *sg, int nelems,
-			    enum dma_data_direction direction)
+static void dma32_sync_sg_for_device(struct device *dev,
+				     struct scatterlist *sg, int nelems,
+				     enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -194,4 +160,19 @@ void dma_sync_sg_for_device(struct device *dev,
 #endif
 	BUG();
 }
-EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+static const struct dma_ops dma32_dma_ops = {
+	.alloc_coherent		= dma32_alloc_coherent,
+	.free_coherent		= dma32_free_coherent,
+	.map_page		= dma32_map_page,
+	.unmap_page		= dma32_unmap_page,
+	.map_sg			= dma32_map_sg,
+	.unmap_sg		= dma32_unmap_sg,
+	.sync_single_for_cpu	= dma32_sync_single_for_cpu,
+	.sync_single_for_device	= dma32_sync_single_for_device,
+	.sync_sg_for_cpu	= dma32_sync_sg_for_cpu,
+	.sync_sg_for_device	= dma32_sync_sg_for_device,
+};
+
+const struct dma_ops *dma_ops = &dma32_dma_ops;
+EXPORT_SYMBOL(dma_ops);
-- 
1.6.0.6

