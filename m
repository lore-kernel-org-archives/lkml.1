Return-Path: <linux-kernel-owner+w=401wt.eu-S1763920AbZE1UFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763920AbZE1UFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbZE1UFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:05:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228AbZE1UFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:05:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Thu, 28 May 2009 21:04:55 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200905282104.55818.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+7h1iD2Iq3Ru9FFZp4msomMFGAqejr0NDv4Wg
 Yga7QXiEUYBBLX8m0rh5O5RrR0lGWjg4Wl7LSRqzKwFyQD/g7S
 UpeFfmV3HG7BFl9j7cm5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a version of the dma-mapping API to asm-generic that can be
used by most architectures that only need a linear mapping.

An architecture using this still needs to provide definitions for
dma_get_cache_alignment, dma_cache_sync and a new dma_coherent_dev
function as well as out-of-line versions of dma_alloc_coherent and
dma_free_coherent.

Thanks to Fujita-san for an endless supply of feedback.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
 include/asm-generic/dma-mapping-linear.h |  336 ++++++++++++++++++++++++++++++
 1 files changed, 336 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/dma-mapping-linear.h

---

I've added this version to
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic#next

I also have patches to convert the existing architectures to use
it, but I plan to submit those to the arch maintainers once asm-generic
series has been merged.

Please ack if you are happy with this version.

diff --git a/include/asm-generic/dma-mapping-linear.h b/include/asm-generic/dma-mapping-linear.h
new file mode 100644
index 0000000..c3b987d
--- /dev/null
+++ b/include/asm-generic/dma-mapping-linear.h
@@ -0,0 +1,336 @@
+#ifndef __ASM_GENERIC_DMA_MAPPING_H
+#define __ASM_GENERIC_DMA_MAPPING_H
+
+#include <linux/mm.h>
+#include <linux/device.h>
+#include <linux/dma-debug.h>
+#include <linux/scatterlist.h>
+#include <asm/cacheflush.h>
+#include <asm/io.h>
+
+/**
+ * dma_alloc_coherent - allocate consistent memory for DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @size: required memory size
+ * @handle: bus-specific DMA address
+ *
+ * Allocate some uncached, unbuffered memory for a device for
+ * performing DMA.  This function allocates pages, and will
+ * return the CPU-viewed address, and sets @handle to be the
+ * device-viewed address.
+ */
+extern void *
+dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		   gfp_t flag);
+
+/**
+ * dma_free_coherent - free memory allocated by dma_alloc_coherent
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @size: size of memory originally requested in dma_alloc_coherent
+ * @cpu_addr: CPU-view address returned from dma_alloc_coherent
+ * @handle: device-view address returned from dma_alloc_coherent
+ *
+ * Free (and unmap) a DMA buffer previously allocated by
+ * dma_alloc_coherent().
+ *
+ * References to memory and mappings associated with cpu_addr/handle
+ * during and after this call executing are illegal.
+ */
+extern void
+dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
+		  dma_addr_t dma_handle);
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+/**
+ * dma_map_single - map a single buffer for streaming DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @cpu_addr: CPU direct mapped address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Ensure that any data held in the cache is appropriately discarded
+ * or written back.
+ *
+ * The device owns this memory once this call has completed.  The CPU
+ * can regain ownership by calling dma_unmap_single() or dma_sync_single().
+ */
+static inline dma_addr_t
+dma_map_single(struct device *dev, void *ptr, size_t size,
+	       enum dma_data_direction direction)
+{
+	dma_addr_t dma_addr = virt_to_bus(ptr);
+	BUG_ON(!valid_dma_direction(direction));
+
+	if (!dma_coherent_dev(dev))
+		dma_cache_sync(dev, ptr, size, direction);
+
+	debug_dma_map_page(dev, virt_to_page(ptr),
+			   (unsigned long)ptr & ~PAGE_MASK, size,
+			   direction, dma_addr, true);
+
+	return dma_addr;
+}
+
+/**
+ * dma_unmap_single - unmap a single buffer previously mapped
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Unmap a single streaming mode DMA translation.  The handle and size
+ * must match what was provided in the previous dma_map_single() call.
+ * All other usages are undefined.
+ *
+ * After this call, reads by the CPU to the buffer are guaranteed to see
+ * whatever the device wrote there.
+ */
+static inline void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction)
+{
+	debug_dma_unmap_page(dev, dma_addr, size, direction, true);
+}
+
+/**
+ * dma_map_sg - map a set of SG buffers for streaming mode DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @sg: list of buffers
+ * @nents: number of buffers to map
+ * @dir: DMA transfer direction
+ *
+ * Map a set of buffers described by scatterlist in streaming
+ * mode for DMA.  This is the scatter-gather version of the
+ * above pci_map_single interface.  Here the scatter gather list
+ * elements are each tagged with the appropriate dma address
+ * and length.  They are obtained via sg_dma_{address,length}(SG).
+ *
+ * NOTE: An implementation may be able to use a smaller number of
+ *       DMA address/length pairs than there are SG table elements.
+ *       (for example via virtual mapping capabilities)
+ *       The routine returns the number of addr/length pairs actually
+ *       used, at most nents.
+ *
+ * Device ownership issues as mentioned above for pci_map_single are
+ * the same here.
+ */
+static inline int
+dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
+	   enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i, sync;
+
+	BUG_ON(!valid_dma_direction(direction));
+	WARN_ON(nents == 0 || sglist[0].length == 0);
+
+	sync = !dma_coherent_dev(dev);
+
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg_page(sg));
+
+		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
+		sg_dma_len(sg) = sg->length;
+		if (sync)
+			dma_cache_sync(dev, sg_virt(sg), sg->length, direction);
+	}
+
+	debug_dma_map_sg(dev, sg, nents, i, direction);
+
+	return nents;
+}
+
+/**
+ * dma_unmap_sg - unmap a set of SG buffers mapped by dma_map_sg
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @sg: list of buffers
+ * @nents: number of buffers to map
+ * @dir: DMA transfer direction
+ *
+ * Unmap a set of streaming mode DMA translations.
+ * Again, CPU read rules concerning calls here are the same as for
+ * pci_unmap_single() above.
+ */
+static inline void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction)
+{
+	debug_dma_unmap_sg(dev, sg, nhwentries, direction);
+}
+
+/**
+ * dma_map_page - map a portion of a page for streaming DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @page: page that buffer resides in
+ * @offset: offset into page for start of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Ensure that any data held in the cache is appropriately discarded
+ * or written back.
+ *
+ * The device owns this memory once this call has completed.  The CPU
+ * can regain ownership by calling dma_unmap_page() or dma_sync_single().
+ */
+static inline dma_addr_t
+dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+	     size_t size, enum dma_data_direction direction)
+{
+	return dma_map_single(dev, page_address(page) + offset,
+			      size, direction);
+}
+
+/**
+ * dma_unmap_page - unmap a buffer previously mapped through dma_map_page()
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Unmap a single streaming mode DMA translation.  The handle and size
+ * must match what was provided in the previous dma_map_single() call.
+ * All other usages are undefined.
+ *
+ * After this call, reads by the CPU to the buffer are guaranteed to see
+ * whatever the device wrote there.
+ */
+static inline void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction)
+{
+	dma_unmap_single(dev, dma_address, size, direction);
+}
+
+/**
+ * dma_sync_single_for_cpu
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Make physical memory consistent for a single streaming mode DMA
+ * translation after a transfer.
+ *
+ * If you perform a dma_map_single() but wish to interrogate the
+ * buffer using the cpu, yet do not wish to teardown the DMA mapping,
+ * you must call this function before doing so.  At the next point you
+ * give the DMA address back to the card, you must first perform a
+ * dma_sync_single_for_device, and then the device again owns the
+ * buffer.
+ */
+static inline void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction)
+{
+	debug_dma_sync_single_for_cpu(dev, dma_handle, size, direction);
+}
+
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	debug_dma_sync_single_range_for_cpu(dev, dma_handle,
+					    offset, size, direction);
+}
+
+/**
+ * dma_sync_sg_for_cpu
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @sg: list of buffers
+ * @nents: number of buffers to map
+ * @dir: DMA transfer direction
+ *
+ * Make physical memory consistent for a set of streaming
+ * mode DMA translations after a transfer.
+ *
+ * The same as dma_sync_single_for_* but for a scatter-gather list,
+ * same rules and usage.
+ */
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nents,
+		    enum dma_data_direction direction)
+{
+	debug_dma_sync_sg_for_cpu(dev, sg, nents, direction);
+}
+
+static inline void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+			   size_t size, enum dma_data_direction direction)
+{
+	if (!dma_coherent_dev(dev))
+		dma_cache_sync(dev, bus_to_virt(dma_handle), size, direction);
+	debug_dma_sync_single_for_device(dev, dma_handle, size, direction);
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	if (!dma_coherent_dev(dev))
+		dma_cache_sync(dev, bus_to_virt(dma_handle), size, direction);
+	debug_dma_sync_single_range_for_device(dev, dma_handle,
+					       offset, size, direction);
+}
+
+static inline void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
+		       int nents, enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+	if (!dma_coherent_dev(dev))
+		for_each_sg(sglist, sg, nents, i)
+			dma_cache_sync(dev, sg_virt(sg), sg->length, direction);
+
+	debug_dma_sync_sg_for_device(dev, sg, nents, direction);
+}
+
+static inline int
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+/*
+ * Return whether the given device DMA address mask can be supported
+ * properly.  For example, if your device can only drive the low 24-bits
+ * during bus mastering, then you would pass 0x00ffffff as the mask
+ * to this function.
+ */
+static inline int
+dma_supported(struct device *dev, u64 mask)
+{
+	/*
+	 * we fall back to GFP_DMA when the mask isn't all 1s,
+	 * so we can't guarantee allocations that must be
+	 * within a tighter range than GFP_DMA.
+	 */
+	if (mask < 0x00ffffff)
+		return 0;
+
+	return 1;
+}
+
+static inline int
+dma_set_mask(struct device *dev, u64 dma_mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
+		return -EIO;
+
+	*dev->dma_mask = dma_mask;
+
+	return 0;
+}
+
+static inline int
+dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
+{
+	return dma_coherent_dev(dev);
+}
+
+#endif /* __ASM_GENERIC_DMA_MAPPING_H */
-- 
1.6.3.1

