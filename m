Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbZFNMEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbZFNMEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbZFNMBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52676 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592AbZFNMBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 10/17] Blackfin: convert dma/pci to asm-generic
Date: Sun, 14 Jun 2009 08:01:11 -0400
Message-Id: <1244980878-2124-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/dma-mapping.h |   91 +++-----------------
 arch/blackfin/include/asm/dma.h         |    5 +-
 arch/blackfin/include/asm/pci.h         |  149 +------------------------------
 arch/blackfin/include/asm/scatterlist.h |   29 +------
 4 files changed, 14 insertions(+), 260 deletions(-)

diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index d7d9148..c1f3010 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -2,97 +2,28 @@
 #define _BLACKFIN_DMA_MAPPING_H
 
 #include <asm/scatterlist.h>
+#include <asm-generic/dma-mapping-broken.h>
 
 void dma_alloc_init(unsigned long start, unsigned long end);
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t gfp);
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-		       dma_addr_t dma_handle);
-
-/*
- * Now for the API extensions over the pci_ one
- */
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
+#define dma_mapping_error __dma_mapping_error
 static inline
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+int __dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
-extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-				 enum dma_data_direction direction);
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction dir)
-{
-	return dma_map_single(dev, page_address(page) + offset, size, dir);
-}
-
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
-extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-			  enum dma_data_direction direction);
+#define dma_map_page(dev, page, offset, size, dir) \
+	dma_map_single(dev, page_address(page) + offset, size, dir)
 
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-	       enum dma_data_direction dir)
-{
+#define dma_unmap_page(dev, dma_addr, size, dir) \
 	dma_unmap_single(dev, dma_addr, size, dir);
-}
-
-/*
- * Map a set of buffers described by scatterlist in streaming
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
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction direction);
-
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		      int nhwentries, enum dma_data_direction direction);
 
-static inline void dma_sync_single_for_cpu(struct device *dev,
-					dma_addr_t handle, size_t size,
-					enum dma_data_direction dir)
+#define dma_sync_single_for_cpu __dma_sync_single_for_cpu
+static inline
+void __dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle,
+                               size_t size, enum dma_data_direction dir)
 {
 }
 
-static inline void dma_sync_single_for_device(struct device *dev,
-					dma_addr_t handle, size_t size,
-					enum dma_data_direction dir)
-{
-}
-#endif				/* _BLACKFIN_DMA_MAPPING_H */
+#endif
diff --git a/arch/blackfin/include/asm/dma.h b/arch/blackfin/include/asm/dma.h
index c9a5962..364ebb9 100644
--- a/arch/blackfin/include/asm/dma.h
+++ b/arch/blackfin/include/asm/dma.h
@@ -10,8 +10,7 @@
 
 #include <linux/interrupt.h>
 #include <mach/dma.h>
-#include <asm/blackfin.h>
-#include <asm/page.h>
+#include <asm-generic/dma.h>
 
 #define MAX_DMA_ADDRESS PAGE_OFFSET
 
@@ -239,8 +238,6 @@ static inline void enable_dma(unsigned int channel)
 	dma_ch[channel].regs->cfg |= DMAEN;
 	dma_ch[channel].chan_status = DMA_CHANNEL_ENABLED;
 }
-void free_dma(unsigned int channel);
-int request_dma(unsigned int channel, const char *device_id);
 int set_dma_callback(unsigned int channel, irq_handler_t callback, void *data);
 
 static inline void dma_disable_irq(unsigned int channel)
diff --git a/arch/blackfin/include/asm/pci.h b/arch/blackfin/include/asm/pci.h
index 6127735..9f0df5f 100644
--- a/arch/blackfin/include/asm/pci.h
+++ b/arch/blackfin/include/asm/pci.h
@@ -1,148 +1 @@
-/* Changed from asm-m68k version, Lineo Inc. 	May 2001	*/
-
-#ifndef _ASM_BFIN_PCI_H
-#define _ASM_BFIN_PCI_H
-
-#include <asm/scatterlist.h>
-
-/*
- *
- * Written by Wout Klaren.
- */
-
-/* Added by Chang Junxiao */
-#define PCIBIOS_MIN_IO 0x00001000
-#define PCIBIOS_MIN_MEM 0x10000000
-
-#define PCI_DMA_BUS_IS_PHYS       (1)
-struct pci_ops;
-
-/*
- * Structure with hardware dependent information and functions of the
- * PCI bus.
- */
-struct pci_bus_info {
-
-	/*
-	 * Resources of the PCI bus.
-	 */
-	struct resource mem_space;
-	struct resource io_space;
-
-	/*
-	 * System dependent functions.
-	 */
-	struct pci_ops *bfin_pci_ops;
-	void (*fixup) (int pci_modify);
-	void (*conf_device) (unsigned char bus, unsigned char device_fn);
-};
-
-#define pcibios_assign_all_busses()	0
-static inline void pcibios_set_master(struct pci_dev *dev)
-{
-
-	/* No special bus mastering setup handling */
-}
-static inline void pcibios_penalize_isa_irq(int irq)
-{
-
-	/* We don't do dynamic PCI IRQ allocation */
-}
-static inline dma_addr_t pci_map_single(struct pci_dev *hwdev, void *ptr,
-					size_t size, int direction)
-{
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
-	 /* return virt_to_bus(ptr); */
-	return (dma_addr_t) ptr;
-}
-
-/* Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
-static inline void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
-				    size_t size, int direction)
-{
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
-	/* Nothing to do */
-}
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
-static inline int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-			     int nents, int direction)
-{
-	if (direction == PCI_DMA_NONE)
-		BUG();
-	return nents;
-}
-
-/* Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-static inline void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-				int nents, int direction)
-{
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
-	/* Nothing to do */
-}
-
-/* Make physical memory consistent for a single
- * streaming mode DMA translation after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the PCI dma
- * mapping, you must call this function before doing so.  At the
- * next point you give the PCI dma address back to the card, the
- * device again owns the buffer.
- */
-static inline void pci_dma_sync_single(struct pci_dev *hwdev,
-				       dma_addr_t dma_handle, size_t size,
-				       int direction)
-{
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
-	/* Nothing to do */
-}
-
-/* Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as pci_dma_sync_single but for a scatter-gather list,
- * same rules and usage.
- */
-static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
-				   struct scatterlist *sg, int nelems,
-				   int direction)
-{
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
-	/* Nothing to do */
-}
-
-#endif				/* _ASM_BFIN_PCI_H */
+#include <asm-generic/pci.h>
diff --git a/arch/blackfin/include/asm/scatterlist.h b/arch/blackfin/include/asm/scatterlist.h
index 04f4487..35d786f 100644
--- a/arch/blackfin/include/asm/scatterlist.h
+++ b/arch/blackfin/include/asm/scatterlist.h
@@ -1,28 +1 @@
-#ifndef _BLACKFIN_SCATTERLIST_H
-#define _BLACKFIN_SCATTERLIST_H
-
-#include <linux/mm.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-	dma_addr_t dma_address;
-	unsigned int length;
-};
-
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)      ((sg)->dma_address)
-#define sg_dma_len(sg)          ((sg)->length)
-
-#define ISA_DMA_THRESHOLD	(0xffffffff)
-
-#endif				/* !(_BLACKFIN_SCATTERLIST_H) */
+#include <asm-generic/scatterlist.h>
-- 
1.6.3.1

