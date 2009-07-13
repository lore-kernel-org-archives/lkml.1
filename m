Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZGMG33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZGMG33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZGMG30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:29:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:60444 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZGMG2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:44 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH 7/8] sparc: use asm-generic/pci-dma-compat
Date: Mon, 13 Jul 2009 15:25:59 +0900
Message-Id: <1247466360-13330-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts SPARC to use asm-generic/pci-dma-compat instead of the
homegrown mechnism.

SPARC32 has two dma_map_ops structures for pci and sbus (removing
arch/sparc/kernel/dma.c, PCI and SBUS DMA accessor). The global
'dma_ops' is set to sbus_dma_ops and get_dma_ops() returns
pci32_dma_ops for pci devices so we can use the appropriate dma
mapping operations.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
---
 arch/sparc/include/asm/dma-mapping.h |    7 ++-
 arch/sparc/include/asm/pci.h         |    3 +
 arch/sparc/include/asm/pci_32.h      |  105 ----------------------
 arch/sparc/include/asm/pci_64.h      |   88 ------------------
 arch/sparc/kernel/dma.c              |  155 ++-------------------------------
 arch/sparc/kernel/dma.h              |   14 ---
 arch/sparc/kernel/iommu.c            |    4 +-
 arch/sparc/kernel/ioport.c           |  162 ++++++++++++++++------------------
 arch/sparc/kernel/pci.c              |    2 +-
 9 files changed, 96 insertions(+), 444 deletions(-)
 delete mode 100644 arch/sparc/kernel/dma.h

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 34c9226..2677818 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -14,10 +14,15 @@ extern int dma_set_mask(struct device *dev, u64 dma_mask);
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
 
-extern struct dma_map_ops *dma_ops;
+extern struct dma_map_ops *dma_ops, pci32_dma_ops;
+extern struct bus_type pci_bus_type;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
+#if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
+	if (dev->bus == &pci_bus_type)
+		return &pci32_dma_ops;
+#endif
 	return dma_ops;
 }
 
diff --git a/arch/sparc/include/asm/pci.h b/arch/sparc/include/asm/pci.h
index 6e14fd1..d9c031f 100644
--- a/arch/sparc/include/asm/pci.h
+++ b/arch/sparc/include/asm/pci.h
@@ -5,4 +5,7 @@
 #else
 #include <asm/pci_32.h>
 #endif
+
+#include <asm-generic/pci-dma-compat.h>
+
 #endif
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index b41c4c1..ac0e836 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -31,42 +31,8 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS	(0)
 
-#include <asm/scatterlist.h>
-
 struct pci_dev;
 
-/* Allocate and map kernel buffer using consistent mode DMA for a device.
- * hwdev should be valid struct pci_dev pointer for PCI devices.
- */
-extern void *pci_alloc_consistent(struct pci_dev *hwdev, size_t size, dma_addr_t *dma_handle);
-
-/* Free and unmap a consistent DMA buffer.
- * cpu_addr is what was returned from pci_alloc_consistent,
- * size must be the same as what as passed into pci_alloc_consistent,
- * and likewise dma_addr must be the same as what *dma_addrp was set to.
- *
- * References to the memory and mappings assosciated with cpu_addr/dma_addr
- * past this call are illegal.
- */
-extern void pci_free_consistent(struct pci_dev *hwdev, size_t size, void *vaddr, dma_addr_t dma_handle);
-
-/* Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single_for_cpu is performed.
- */
-extern dma_addr_t pci_map_single(struct pci_dev *hwdev, void *ptr, size_t size, int direction);
-
-/* Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-extern void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr, size_t size, int direction);
-
 /* pci_unmap_{single,page} is not a nop, thus... */
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
@@ -81,69 +47,6 @@ extern void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr, size_t
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-/*
- * Same as above, only with pages instead of mapped addresses.
- */
-extern dma_addr_t pci_map_page(struct pci_dev *hwdev, struct page *page,
-			unsigned long offset, size_t size, int direction);
-extern void pci_unmap_page(struct pci_dev *hwdev,
-			dma_addr_t dma_address, size_t size, int direction);
-
-/* Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are
- * the same here.
- */
-extern int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg, int nents, int direction);
-
-/* Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-extern void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg, int nhwents, int direction);
-
-/* Make physical memory consistent for a single
- * streaming mode DMA translation after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the PCI dma
- * mapping, you must call this function before doing so.  At the
- * next point you give the PCI dma address back to the card, you
- * must first perform a pci_dma_sync_for_device, and then the device
- * again owns the buffer.
- */
-extern void pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t dma_handle, size_t size, int direction);
-extern void pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t dma_handle, size_t size, int direction);
-
-/* Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as pci_dma_sync_single_* but for a scatter-gather list,
- * same rules and usage.
- */
-extern void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sg, int nelems, int direction);
-extern void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg, int nelems, int direction);
-
-/* Return whether the given PCI device DMA address mask can
- * be supported properly.  For example, if your device can
- * only drive the low 24-bits during PCI bus mastering, then
- * you would pass 0x00ffffff as the mask to this function.
- */
-static inline int pci_dma_supported(struct pci_dev *hwdev, u64 mask)
-{
-	return 1;
-}
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
@@ -154,14 +57,6 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 }
 #endif
 
-#define PCI_DMA_ERROR_CODE      (~(dma_addr_t)0x0)
-
-static inline int pci_dma_mapping_error(struct pci_dev *pdev,
-					dma_addr_t dma_addr)
-{
-        return (dma_addr == PCI_DMA_ERROR_CODE);
-}
-
 struct device_node;
 extern struct device_node *pci_device_to_OF_node(struct pci_dev *pdev);
 
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index 7a1e356..5cc9f6a 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -35,37 +35,6 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS	(0)
 
-static inline void *pci_alloc_consistent(struct pci_dev *pdev, size_t size,
-					 dma_addr_t *dma_handle)
-{
-	return dma_alloc_coherent(&pdev->dev, size, dma_handle, GFP_ATOMIC);
-}
-
-static inline void pci_free_consistent(struct pci_dev *pdev, size_t size,
-				       void *vaddr, dma_addr_t dma_handle)
-{
-	return dma_free_coherent(&pdev->dev, size, vaddr, dma_handle);
-}
-
-static inline dma_addr_t pci_map_single(struct pci_dev *pdev, void *ptr,
-					size_t size, int direction)
-{
-	return dma_map_single(&pdev->dev, ptr, size,
-			      (enum dma_data_direction) direction);
-}
-
-static inline void pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr,
-				    size_t size, int direction)
-{
-	dma_unmap_single(&pdev->dev, dma_addr, size,
-			 (enum dma_data_direction) direction);
-}
-
-#define pci_map_page(dev, page, off, size, dir) \
-	pci_map_single(dev, (page_address(page) + (off)), size, dir)
-#define pci_unmap_page(dev,addr,sz,dir) \
-	pci_unmap_single(dev,addr,sz,dir)
-
 /* pci_unmap_{single,page} is not a nop, thus... */
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
@@ -80,57 +49,6 @@ static inline void pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr,
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-static inline int pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg,
-			     int nents, int direction)
-{
-	return dma_map_sg(&pdev->dev, sg, nents,
-			  (enum dma_data_direction) direction);
-}
-
-static inline void pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg,
-				int nents, int direction)
-{
-	dma_unmap_sg(&pdev->dev, sg, nents,
-		     (enum dma_data_direction) direction);
-}
-
-static inline void pci_dma_sync_single_for_cpu(struct pci_dev *pdev,
-					       dma_addr_t dma_handle,
-					       size_t size, int direction)
-{
-	dma_sync_single_for_cpu(&pdev->dev, dma_handle, size,
-				(enum dma_data_direction) direction);
-}
-
-static inline void pci_dma_sync_single_for_device(struct pci_dev *pdev,
-						  dma_addr_t dma_handle,
-						  size_t size, int direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-static inline void pci_dma_sync_sg_for_cpu(struct pci_dev *pdev,
-					   struct scatterlist *sg,
-					   int nents, int direction)
-{
-	dma_sync_sg_for_cpu(&pdev->dev, sg, nents,
-			    (enum dma_data_direction) direction);
-}
-
-static inline void pci_dma_sync_sg_for_device(struct pci_dev *pdev,
-					      struct scatterlist *sg,
-					      int nelems, int direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-/* Return whether the given PCI device DMA address mask can
- * be supported properly.  For example, if your device can
- * only drive the low 24-bits during PCI bus mastering, then
- * you would pass 0x00ffffff as the mask to this function.
- */
-extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
-
 /* PCI IOMMU mapping bypass support. */
 
 /* PCI 64-bit addressing works for all slots on all controller
@@ -140,12 +58,6 @@ extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
 #define PCI64_REQUIRED_MASK	(~(dma64_addr_t)0)
 #define PCI64_ADDR_BASE		0xfffc000000000000UL
 
-static inline int pci_dma_mapping_error(struct pci_dev *pdev,
-					dma_addr_t dma_addr)
-{
-	return dma_mapping_error(&pdev->dev, dma_addr);
-}
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff --git a/arch/sparc/kernel/dma.c b/arch/sparc/kernel/dma.c
index a5d50da..b2fa312 100644
--- a/arch/sparc/kernel/dma.c
+++ b/arch/sparc/kernel/dma.c
@@ -13,13 +13,17 @@
 #include <linux/pci.h>
 #endif
 
-#include "dma.h"
-
+/*
+ * Return whether the given PCI device DMA address mask can be
+ * supported properly.  For example, if your device can only drive the
+ * low 24-bits during PCI bus mastering, then you would pass
+ * 0x00ffffff as the mask to this function.
+ */
 int dma_supported(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
-		return pci_dma_supported(to_pci_dev(dev), mask);
+		return 1;
 #endif
 	return 0;
 }
@@ -34,148 +38,3 @@ int dma_set_mask(struct device *dev, u64 dma_mask)
 	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(dma_set_mask);
-
-static void *dma32_alloc_coherent(struct device *dev, size_t size,
-				  dma_addr_t *dma_handle, gfp_t flag)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_alloc_consistent(to_pci_dev(dev), size, dma_handle);
-#endif
-	return sbus_alloc_consistent(dev, size, dma_handle);
-}
-
-static void dma32_free_coherent(struct device *dev, size_t size,
-				void *cpu_addr, dma_addr_t dma_handle)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_free_consistent(to_pci_dev(dev), size,
-				    cpu_addr, dma_handle);
-		return;
-	}
-#endif
-	sbus_free_consistent(dev, size, cpu_addr, dma_handle);
-}
-
-static dma_addr_t dma32_map_page(struct device *dev, struct page *page,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction,
-				 struct dma_attrs *attrs)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_map_page(to_pci_dev(dev), page, offset,
-				    size, (int)direction);
-#endif
-	return sbus_map_page(dev, page, offset, size, (int)direction);
-}
-
-static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
-			     size_t size, enum dma_data_direction direction,
-			     struct dma_attrs *attrs)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_unmap_page(to_pci_dev(dev), dma_address,
-			       size, (int)direction);
-		return;
-	}
-#endif
-	sbus_unmap_page(dev, dma_address, size, (int)direction);
-}
-
-static int dma32_map_sg(struct device *dev, struct scatterlist *sg,
-			int nents, enum dma_data_direction direction,
-			struct dma_attrs *attrs)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_map_sg(to_pci_dev(dev), sg, nents, (int)direction);
-#endif
-	return sbus_map_sg(dev, sg, nents, direction);
-}
-
-void dma32_unmap_sg(struct device *dev, struct scatterlist *sg,
-		    int nents, enum dma_data_direction direction,
-		    struct dma_attrs *attrs)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_unmap_sg(to_pci_dev(dev), sg, nents, (int)direction);
-		return;
-	}
-#endif
-	sbus_unmap_sg(dev, sg, nents, (int)direction);
-}
-
-static void dma32_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				      size_t size,
-				      enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_single_for_cpu(to_pci_dev(dev), dma_handle,
-					    size, (int)direction);
-		return;
-	}
-#endif
-	sbus_dma_sync_single_for_cpu(dev, dma_handle, size, (int) direction);
-}
-
-static void dma32_sync_single_for_device(struct device *dev,
-					 dma_addr_t dma_handle, size_t size,
-					 enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_single_for_device(to_pci_dev(dev), dma_handle,
-					       size, (int)direction);
-		return;
-	}
-#endif
-	sbus_dma_sync_single_for_device(dev, dma_handle, size, (int) direction);
-}
-
-static void dma32_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-				  int nelems, enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_sg_for_cpu(to_pci_dev(dev), sg,
-					nelems, (int)direction);
-		return;
-	}
-#endif
-	BUG();
-}
-
-static void dma32_sync_sg_for_device(struct device *dev,
-				     struct scatterlist *sg, int nelems,
-				     enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_sg_for_device(to_pci_dev(dev), sg,
-					   nelems, (int)direction);
-		return;
-	}
-#endif
-	BUG();
-}
-
-static struct dma_map_ops dma32_dma_ops = {
-	.alloc_coherent		= dma32_alloc_coherent,
-	.free_coherent		= dma32_free_coherent,
-	.map_page		= dma32_map_page,
-	.unmap_page		= dma32_unmap_page,
-	.map_sg			= dma32_map_sg,
-	.unmap_sg		= dma32_unmap_sg,
-	.sync_single_for_cpu	= dma32_sync_single_for_cpu,
-	.sync_single_for_device	= dma32_sync_single_for_device,
-	.sync_sg_for_cpu	= dma32_sync_sg_for_cpu,
-	.sync_sg_for_device	= dma32_sync_sg_for_device,
-};
-
-struct dma_map_ops *dma_ops = &dma32_dma_ops;
-EXPORT_SYMBOL(dma_ops);
diff --git a/arch/sparc/kernel/dma.h b/arch/sparc/kernel/dma.h
deleted file mode 100644
index 680351e..0000000
--- a/arch/sparc/kernel/dma.h
+++ /dev/null
@@ -1,14 +0,0 @@
-void *sbus_alloc_consistent(struct device *dev, long len, u32 *dma_addrp);
-void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba);
-dma_addr_t sbus_map_page(struct device *dev, struct page *page,
-			 unsigned long offset, size_t len, int direction);
-void sbus_unmap_page(struct device *dev, dma_addr_t ba,
-		       size_t n, int direction);
-int sbus_map_sg(struct device *dev, struct scatterlist *sg,
-		int n, int direction);
-void sbus_unmap_sg(struct device *dev, struct scatterlist *sg,
-		   int n, int direction);
-void sbus_dma_sync_single_for_cpu(struct device *dev, dma_addr_t ba,
-				  size_t size, int direction);
-void sbus_dma_sync_single_for_device(struct device *dev, dma_addr_t ba,
-				     size_t size, int direction);
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 74b289c..7690cc2 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -840,6 +840,8 @@ static struct dma_map_ops sun4u_dma_ops = {
 struct dma_map_ops *dma_ops = &sun4u_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
+extern int pci64_dma_supported(struct pci_dev *pdev, u64 device_mask);
+
 int dma_supported(struct device *dev, u64 device_mask)
 {
 	struct iommu *iommu = dev->archdata.iommu;
@@ -853,7 +855,7 @@ int dma_supported(struct device *dev, u64 device_mask)
 
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
-		return pci_dma_supported(to_pci_dev(dev), device_mask);
+		return pci64_dma_supported(to_pci_dev(dev), device_mask);
 #endif
 
 	return 0;
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 39ff1e0..1eb6043 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -48,8 +48,6 @@
 #include <asm/iommu.h>
 #include <asm/io-unit.h>
 
-#include "dma.h"
-
 #define mmu_inval_dma_area(p, l)	/* Anton pulled it out for 2.4.0-xx */
 
 static struct resource *_sparc_find_resource(struct resource *r,
@@ -246,7 +244,8 @@ EXPORT_SYMBOL(sbus_set_sbus64);
  * Typically devices use them for control blocks.
  * CPU may access them without any explicit flushing.
  */
-void *sbus_alloc_consistent(struct device *dev, long len, u32 *dma_addrp)
+static void *sbus_alloc_coherent(struct device *dev, size_t len,
+				 dma_addr_t *dma_addrp, gfp_t gfp)
 {
 	struct of_device *op = to_of_device(dev);
 	unsigned long len_total = (len + PAGE_SIZE-1) & PAGE_MASK;
@@ -299,7 +298,8 @@ err_nopages:
 	return NULL;
 }
 
-void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba)
+static void sbus_free_coherent(struct device *dev, size_t n, void *p,
+			       dma_addr_t ba)
 {
 	struct resource *res;
 	struct page *pgv;
@@ -317,7 +317,7 @@ void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba)
 
 	n = (n + PAGE_SIZE-1) & PAGE_MASK;
 	if ((res->end-res->start)+1 != n) {
-		printk("sbus_free_consistent: region 0x%lx asked 0x%lx\n",
+		printk("sbus_free_consistent: region 0x%lx asked 0x%zx\n",
 		    (long)((res->end-res->start)+1), n);
 		return;
 	}
@@ -337,8 +337,10 @@ void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba)
  * CPU view of this memory may be inconsistent with
  * a device view and explicit flushing is necessary.
  */
-dma_addr_t sbus_map_page(struct device *dev, struct page *page,
-			 unsigned long offset, size_t len, int direction)
+static dma_addr_t sbus_map_page(struct device *dev, struct page *page,
+				unsigned long offset, size_t len,
+				enum dma_data_direction dir,
+				struct dma_attrs *attrs)
 {
 	void *va = page_address(page) + offset;
 
@@ -353,12 +355,14 @@ dma_addr_t sbus_map_page(struct device *dev, struct page *page,
 	return mmu_get_scsi_one(dev, va, len);
 }
 
-void sbus_unmap_page(struct device *dev, dma_addr_t ba, size_t n, int direction)
+static void sbus_unmap_page(struct device *dev, dma_addr_t ba, size_t n,
+			    enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	mmu_release_scsi_one(dev, ba, n);
 }
 
-int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n, int direction)
+static int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n,
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	mmu_get_scsi_sgl(dev, sg, n);
 
@@ -369,19 +373,38 @@ int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n, int direction
 	return n;
 }
 
-void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n, int direction)
+static void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n,
+			  enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	mmu_release_scsi_sgl(dev, sg, n);
 }
 
-void sbus_dma_sync_single_for_cpu(struct device *dev, dma_addr_t ba, size_t size, int direction)
+static void sbus_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+				 int n,	enum dma_data_direction dir)
 {
+	BUG();
 }
 
-void sbus_dma_sync_single_for_device(struct device *dev, dma_addr_t ba, size_t size, int direction)
+static void sbus_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				    int n, enum dma_data_direction dir)
 {
+	BUG();
 }
 
+struct dma_map_ops sbus_dma_ops = {
+	.alloc_coherent		= sbus_alloc_coherent,
+	.free_coherent		= sbus_free_coherent,
+	.map_page		= sbus_map_page,
+	.unmap_page		= sbus_unmap_page,
+	.map_sg			= sbus_map_sg,
+	.unmap_sg		= sbus_unmap_sg,
+	.sync_sg_for_cpu	= sbus_sync_sg_for_cpu,
+	.sync_sg_for_device	= sbus_sync_sg_for_device,
+};
+
+struct dma_map_ops *dma_ops = &sbus_dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
 static int __init sparc_register_ioport(void)
 {
 	register_proc_sparc_ioport();
@@ -398,7 +421,8 @@ arch_initcall(sparc_register_ioport);
 /* Allocate and map kernel buffer using consistent mode DMA for a device.
  * hwdev should be valid struct pci_dev pointer for PCI devices.
  */
-void *pci_alloc_consistent(struct pci_dev *pdev, size_t len, dma_addr_t *pba)
+static void *pci32_alloc_coherent(struct device *dev, size_t len,
+				  dma_addr_t *pba, gfp_t gfp)
 {
 	unsigned long len_total = (len + PAGE_SIZE-1) & PAGE_MASK;
 	unsigned long va;
@@ -442,7 +466,6 @@ void *pci_alloc_consistent(struct pci_dev *pdev, size_t len, dma_addr_t *pba)
 	*pba = virt_to_phys(va); /* equals virt_to_bus (R.I.P.) for us. */
 	return (void *) res->start;
 }
-EXPORT_SYMBOL(pci_alloc_consistent);
 
 /* Free and unmap a consistent DMA buffer.
  * cpu_addr is what was returned from pci_alloc_consistent,
@@ -452,7 +475,8 @@ EXPORT_SYMBOL(pci_alloc_consistent);
  * References to the memory and mappings associated with cpu_addr/dma_addr
  * past this call are illegal.
  */
-void pci_free_consistent(struct pci_dev *pdev, size_t n, void *p, dma_addr_t ba)
+static void pci32_free_coherent(struct device *dev, size_t n, void *p,
+				dma_addr_t ba)
 {
 	struct resource *res;
 	unsigned long pgp;
@@ -484,60 +508,18 @@ void pci_free_consistent(struct pci_dev *pdev, size_t n, void *p, dma_addr_t ba)
 
 	free_pages(pgp, get_order(n));
 }
-EXPORT_SYMBOL(pci_free_consistent);
-
-/* Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single_* is performed.
- */
-dma_addr_t pci_map_single(struct pci_dev *hwdev, void *ptr, size_t size,
-    int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-	/* IIep is write-through, not flushing. */
-	return virt_to_phys(ptr);
-}
-EXPORT_SYMBOL(pci_map_single);
-
-/* Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t ba, size_t size,
-    int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
-		mmu_inval_dma_area((unsigned long)phys_to_virt(ba),
-		    (size + PAGE_SIZE-1) & PAGE_MASK);
-	}
-}
-EXPORT_SYMBOL(pci_unmap_single);
 
 /*
  * Same as pci_map_single, but with pages.
  */
-dma_addr_t pci_map_page(struct pci_dev *hwdev, struct page *page,
-			unsigned long offset, size_t size, int direction)
+static dma_addr_t pci32_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction dir,
+				 struct dma_attrs *attrs)
 {
-	BUG_ON(direction == PCI_DMA_NONE);
 	/* IIep is write-through, not flushing. */
 	return page_to_phys(page) + offset;
 }
-EXPORT_SYMBOL(pci_map_page);
-
-void pci_unmap_page(struct pci_dev *hwdev,
-			dma_addr_t dma_address, size_t size, int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-	/* mmu_inval_dma_area XXX */
-}
-EXPORT_SYMBOL(pci_unmap_page);
 
 /* Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scather-gather version of the
@@ -554,13 +536,13 @@ EXPORT_SYMBOL(pci_unmap_page);
  * Device ownership issues as mentioned above for pci_map_single are
  * the same here.
  */
-int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
-    int direction)
+static int pci32_map_sg(struct device *device, struct scatterlist *sgl,
+			int nents, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
 	/* IIep is write-through, not flushing. */
 	for_each_sg(sgl, sg, nents, n) {
 		BUG_ON(page_address(sg_page(sg)) == NULL);
@@ -569,20 +551,19 @@ int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
 	}
 	return nents;
 }
-EXPORT_SYMBOL(pci_map_sg);
 
 /* Unmap a set of streaming mode DMA translations.
  * Again, cpu read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
-    int direction)
+static void pci32_unmap_sg(struct device *dev, struct scatterlist *sgl,
+			   int nents, enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
@@ -591,7 +572,6 @@ void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
 		}
 	}
 }
-EXPORT_SYMBOL(pci_unmap_sg);
 
 /* Make physical memory consistent for a single
  * streaming mode DMA translation before or after a transfer.
@@ -603,25 +583,23 @@ EXPORT_SYMBOL(pci_unmap_sg);
  * must first perform a pci_dma_sync_for_device, and then the
  * device again owns the buffer.
  */
-void pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t ba, size_t size, int direction)
+static void pci32_sync_single_for_cpu(struct device *dev, dma_addr_t ba,
+				      size_t size, enum dma_data_direction dir)
 {
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		mmu_inval_dma_area((unsigned long)phys_to_virt(ba),
 		    (size + PAGE_SIZE-1) & PAGE_MASK);
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_single_for_cpu);
 
-void pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t ba, size_t size, int direction)
+static void pci32_sync_single_for_device(struct device *dev, dma_addr_t ba,
+					 size_t size, enum dma_data_direction dir)
 {
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		mmu_inval_dma_area((unsigned long)phys_to_virt(ba),
 		    (size + PAGE_SIZE-1) & PAGE_MASK);
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_single_for_device);
 
 /* Make physical memory consistent for a set of streaming
  * mode DMA translations after a transfer.
@@ -629,13 +607,13 @@ EXPORT_SYMBOL(pci_dma_sync_single_for_device);
  * The same as pci_dma_sync_single_* but for a scatter-gather list,
  * same rules and usage.
  */
-void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sgl, int nents, int direction)
+static void pci32_sync_sg_for_cpu(struct device *dev, struct scatterlist *sgl,
+				  int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
@@ -644,15 +622,14 @@ void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sgl, int
 		}
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_sg_for_cpu);
 
-void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sgl, int nents, int direction)
+static void pci32_sync_sg_for_device(struct device *device, struct scatterlist *sgl,
+				     int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
@@ -661,7 +638,20 @@ void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sgl,
 		}
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_sg_for_device);
+
+struct dma_map_ops pci32_dma_ops = {
+	.alloc_coherent		= pci32_alloc_coherent,
+	.free_coherent		= pci32_free_coherent,
+	.map_page		= pci32_map_page,
+	.map_sg			= pci32_map_sg,
+	.unmap_sg		= pci32_unmap_sg,
+	.sync_single_for_cpu	= pci32_sync_single_for_cpu,
+	.sync_single_for_device	= pci32_sync_single_for_device,
+	.sync_sg_for_cpu	= pci32_sync_sg_for_cpu,
+	.sync_sg_for_device	= pci32_sync_sg_for_device,
+};
+EXPORT_SYMBOL(pci32_dma_ops);
+
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_PROC_FS
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 57859ad..c686486 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -1039,7 +1039,7 @@ static void ali_sound_dma_hack(struct pci_dev *pdev, int set_bit)
 	pci_dev_put(ali_isa_bridge);
 }
 
-int pci_dma_supported(struct pci_dev *pdev, u64 device_mask)
+int pci64_dma_supported(struct pci_dev *pdev, u64 device_mask)
 {
 	u64 dma_addr_mask;
 
-- 
1.6.0.6

