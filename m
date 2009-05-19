Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZESQX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZESQX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZESQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:23:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbZESQXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:23:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
Date: Tue, 19 May 2009 18:22:47 +0200
User-Agent: KMail/1.9.9
Cc: jgarzik@pobox.com, hancockrwd@gmail.com, htejun@gmail.com,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
References: <200905172245.23774.arnd@arndb.de> <200905181645.26305.arnd@arndb.de> <20090519074355P.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090519074355P.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191822.48420.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Y1Bz44Vibn4rd0uYRhXBcbgedcpwlZIGx2+0
 gTvjTErFHbV55l8/6M3rmqZWkAIhWA3IMlZzUmDOWw6QFnR5Xl
 37llD4TYb5unQfoQIzsPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009, FUJITA Tomonori wrote:
> > Would you agree to a patch that works with the same
> > code on e.g. arm, microblaze, mn10300 and sh and
> > uses only a few #ifdefs?
> 
> Having such helper for a linear mapping might be helpful but your
> approach is wrong.

Do you like this approach better? I've merged a few architectures
that were relatively simple. This file should be usable by all
architectures that have a linear mapping and are either fully coherent
(like cris) or just require flushing the dcache when passing a
buffer to the device.

It's become pretty obvious where some of my bugs were in the previous
code, I hopefully did better this time and maybe you find the rest.
I've also added the dma debugging stuff in here and fixed a number
of bugs in all the different architectures on the way, but I can
send separate patches for those before doing the merge.

I've also tried merging frv and m68k, but they have some peculiarities
that made it slightly harder.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 include/asm-generic/dma-mapping-linear.h |  391 +++++++++++++++++++++++++++++
 arch/avr32/include/asm/dma-mapping.h     |  408 ++++---------------------------
 arch/blackfin/include/asm/dma-mapping.h  |  118 +-------
 arch/cris/include/asm/dma-mapping.h      |  194 +-------------
 arch/mn10300/include/asm/dma-mapping.h   |  266 ++------------------
 arch/sh/include/asm/dma-mapping.h        |  258 ++-----------------
 arch/xtensa/include/asm/dma-mapping.h    |  220 +++-------------
 7 files changed, 606 insertions(+), 1249 deletions(-)

diff --git a/include/asm-generic/dma-mapping-linear.h b/include/asm-generic/dma-mapping-linear.h
new file mode 100644
index 0000000..13f37db
--- /dev/null
+++ b/include/asm-generic/dma-mapping-linear.h
@@ -0,0 +1,391 @@
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
+#ifdef CONFIG_DMA_COHERENT
+/*
+ * An architecture should override these if it needs to
+ * perform cache flushes before passing bus addresses
+ * to a device.
+ * It can either do a full flush in dma_coherent_dev
+ * and return 1 from there, or implement more specific
+ * synchronization in dma_cache_sync, which will be
+ * applied separately to each sg element.
+ */
+static inline int
+dma_coherent_dev(struct device *dev)
+{
+	return 1;
+}
+
+static inline void
+dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction)
+{
+}
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
+void *dma_alloc_coherent(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *ret;
+	struct page *page;
+	int node = dev_to_node(dev);
+
+	/* ignore region specifiers */
+	flag  &= ~(__GFP_HIGHMEM);
+
+	page = alloc_pages_node(node, flag, get_order(size));
+	if (page == NULL)
+		return NULL;
+	ret = page_address(page);
+	memset(ret, 0, size);
+	*dma_handle = virt_to_abs(ret) + get_dma_direct_offset(dev);
+
+	return ret;
+}
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
+void dma_free_coherent(struct device *dev, size_t size,
+			      void *vaddr, dma_addr_t dma_handle)
+{
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+#else
+extern void *
+dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		   gfp_t flag);
+
+extern void
+dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
+		  dma_addr_t dma_handle);
+#endif
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
+dma_get_cache_alignment(void)
+{
+	return L1_CACHE_BYTES;
+}
+
+static inline int
+dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
+{
+	return dma_coherent_dev(dev);
+}
+
+#endif /* __ASM_GENERIC_DMA_MAPPING_H */
diff --git a/arch/avr32/include/asm/dma-mapping.h b/arch/avr32/include/asm/dma-mapping.h
dissimilarity index 86%
index 0399359..b1d73fb 100644
--- a/arch/avr32/include/asm/dma-mapping.h
+++ b/arch/avr32/include/asm/dma-mapping.h
@@ -1,349 +1,59 @@
-#ifndef __ASM_AVR32_DMA_MAPPING_H
-#define __ASM_AVR32_DMA_MAPPING_H
-
-#include <linux/mm.h>
-#include <linux/device.h>
-#include <linux/scatterlist.h>
-#include <asm/processor.h>
-#include <asm/cacheflush.h>
-#include <asm/io.h>
-
-extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	int direction);
-
-/*
- * Return whether the given device DMA address mask can be supported
- * properly.  For example, if your device can only drive the low 24-bits
- * during bus mastering, then you would pass 0x00ffffff as the mask
- * to this function.
- */
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	/* Fix when needed. I really don't know of any limitations */
-	return 1;
-}
-
-static inline int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
-		return -EIO;
-
-	*dev->dma_mask = dma_mask;
-	return 0;
-}
-
-/*
- * dma_map_single can't fail as it is implemented now.
- */
-static inline int dma_mapping_error(struct device *dev, dma_addr_t addr)
-{
-	return 0;
-}
-
-/**
- * dma_alloc_coherent - allocate consistent memory for DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: required memory size
- * @handle: bus-specific DMA address
- *
- * Allocate some uncached, unbuffered memory for a device for
- * performing DMA.  This function allocates pages, and will
- * return the CPU-viewed address, and sets @handle to be the
- * device-viewed address.
- */
-extern void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *handle, gfp_t gfp);
-
-/**
- * dma_free_coherent - free memory allocated by dma_alloc_coherent
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: size of memory originally requested in dma_alloc_coherent
- * @cpu_addr: CPU-view address returned from dma_alloc_coherent
- * @handle: device-view address returned from dma_alloc_coherent
- *
- * Free (and unmap) a DMA buffer previously allocated by
- * dma_alloc_coherent().
- *
- * References to memory and mappings associated with cpu_addr/handle
- * during and after this call executing are illegal.
- */
-extern void dma_free_coherent(struct device *dev, size_t size,
-			      void *cpu_addr, dma_addr_t handle);
-
-/**
- * dma_alloc_writecombine - allocate write-combining memory for DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: required memory size
- * @handle: bus-specific DMA address
- *
- * Allocate some uncached, buffered memory for a device for
- * performing DMA.  This function allocates pages, and will
- * return the CPU-viewed address, and sets @handle to be the
- * device-viewed address.
- */
-extern void *dma_alloc_writecombine(struct device *dev, size_t size,
-				    dma_addr_t *handle, gfp_t gfp);
-
-/**
- * dma_free_coherent - free memory allocated by dma_alloc_writecombine
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: size of memory originally requested in dma_alloc_writecombine
- * @cpu_addr: CPU-view address returned from dma_alloc_writecombine
- * @handle: device-view address returned from dma_alloc_writecombine
- *
- * Free (and unmap) a DMA buffer previously allocated by
- * dma_alloc_writecombine().
- *
- * References to memory and mappings associated with cpu_addr/handle
- * during and after this call executing are illegal.
- */
-extern void dma_free_writecombine(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t handle);
-
-/**
- * dma_map_single - map a single buffer for streaming DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @cpu_addr: CPU direct mapped address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Ensure that any data held in the cache is appropriately discarded
- * or written back.
- *
- * The device owns this memory once this call has completed.  The CPU
- * can regain ownership by calling dma_unmap_single() or dma_sync_single().
- */
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-	       enum dma_data_direction direction)
-{
-	dma_cache_sync(dev, cpu_addr, size, direction);
-	return virt_to_bus(cpu_addr);
-}
-
-/**
- * dma_unmap_single - unmap a single buffer previously mapped
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @handle: DMA address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Unmap a single streaming mode DMA translation.  The handle and size
- * must match what was provided in the previous dma_map_single() call.
- * All other usages are undefined.
- *
- * After this call, reads by the CPU to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-
-}
-
-/**
- * dma_map_page - map a portion of a page for streaming DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @page: page that buffer resides in
- * @offset: offset into page for start of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Ensure that any data held in the cache is appropriately discarded
- * or written back.
- *
- * The device owns this memory once this call has completed.  The CPU
- * can regain ownership by calling dma_unmap_page() or dma_sync_single().
- */
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction direction)
-{
-	return dma_map_single(dev, page_address(page) + offset,
-			      size, direction);
-}
-
-/**
- * dma_unmap_page - unmap a buffer previously mapped through dma_map_page()
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @handle: DMA address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Unmap a single streaming mode DMA translation.  The handle and size
- * must match what was provided in the previous dma_map_single() call.
- * All other usages are undefined.
- *
- * After this call, reads by the CPU to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	dma_unmap_single(dev, dma_address, size, direction);
-}
-
-/**
- * dma_map_sg - map a set of SG buffers for streaming mode DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @sg: list of buffers
- * @nents: number of buffers to map
- * @dir: DMA transfer direction
- *
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scatter-gather version of the
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
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	int i;
-
-	for (i = 0; i < nents; i++) {
-		char *virt;
-
-		sg[i].dma_address = page_to_bus(sg_page(&sg[i])) + sg[i].offset;
-		virt = sg_virt(&sg[i]);
-		dma_cache_sync(dev, virt, sg[i].length, direction);
-	}
-
-	return nents;
-}
-
-/**
- * dma_unmap_sg - unmap a set of SG buffers mapped by dma_map_sg
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @sg: list of buffers
- * @nents: number of buffers to map
- * @dir: DMA transfer direction
- *
- * Unmap a set of streaming mode DMA translations.
- * Again, CPU read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-
-}
-
-/**
- * dma_sync_single_for_cpu
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @handle: DMA address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Make physical memory consistent for a single streaming mode DMA
- * translation after a transfer.
- *
- * If you perform a dma_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the DMA mapping,
- * you must call this function before doing so.  At the next point you
- * give the DMA address back to the card, you must first perform a
- * dma_sync_single_for_device, and then the device again owns the
- * buffer.
- */
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			size_t size, enum dma_data_direction direction)
-{
-	/*
-	 * No need to do anything since the CPU isn't supposed to
-	 * touch this memory after we flushed it at mapping- or
-	 * sync-for-device time.
-	 */
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-			   size_t size, enum dma_data_direction direction)
-{
-	dma_cache_sync(dev, bus_to_virt(dma_handle), size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
-}
-
-/**
- * dma_sync_sg_for_cpu
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @sg: list of buffers
- * @nents: number of buffers to map
- * @dir: DMA transfer direction
- *
- * Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as dma_sync_single_for_* but for a scatter-gather list,
- * same rules and usage.
- */
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-		    int nents, enum dma_data_direction direction)
-{
-	/*
-	 * No need to do anything since the CPU isn't supposed to
-	 * touch this memory after we flushed it at mapping- or
-	 * sync-for-device time.
-	 */
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-		       int nents, enum dma_data_direction direction)
-{
-	int i;
-
-	for (i = 0; i < nents; i++) {
-		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, direction);
-	}
-}
-
-/* Now for the API extensions over the pci_ one */
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return 1;
-}
-
-static inline int dma_get_cache_alignment(void)
-{
-	return boot_cpu_data.dcache.linesz;
-}
-
-#endif /* __ASM_AVR32_DMA_MAPPING_H */
+#ifndef __ASM_AVR32_DMA_MAPPING_H
+#define __ASM_AVR32_DMA_MAPPING_H
+
+#include <linux/mm.h>
+#include <linux/device.h>
+#include <linux/scatterlist.h>
+#include <asm/processor.h>
+#include <asm/cacheflush.h>
+#include <asm/io.h>
+
+static inline int
+dma_coherent_dev(struct device *dev)
+{
+	return 0;
+}
+
+extern void
+dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction);
+
+static inline int
+dma_get_cache_alignment(void)
+{
+	return boot_cpu_data.dcache.linesz;
+}
+
+/**
+ * dma_alloc_writecombine - allocate write-combining memory for DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @size: required memory size
+ * @handle: bus-specific DMA address
+ *
+ * Allocate some uncached, buffered memory for a device for
+ * performing DMA.  This function allocates pages, and will
+ * return the CPU-viewed address, and sets @handle to be the
+ * device-viewed address.
+ */
+extern void *dma_alloc_writecombine(struct device *dev, size_t size,
+				    dma_addr_t *handle, gfp_t gfp);
+
+/**
+ * dma_free_writecombine - free memory allocated by dma_alloc_writecombine
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @size: size of memory originally requested in dma_alloc_writecombine
+ * @cpu_addr: CPU-view address returned from dma_alloc_writecombine
+ * @handle: device-view address returned from dma_alloc_writecombine
+ *
+ * Free (and unmap) a DMA buffer previously allocated by
+ * dma_alloc_writecombine().
+ *
+ * References to memory and mappings associated with cpu_addr/handle
+ * during and after this call executing are illegal.
+ */
+extern void dma_free_writecombine(struct device *dev, size_t size,
+				  void *cpu_addr, dma_addr_t handle);
+
+#include <asm-generic/dma-mapping-linear.h>
+
+#endif /* __ASM_AVR32_DMA_MAPPING_H */
diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
dissimilarity index 95%
index d7d9148..169d82d 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -1,98 +1,20 @@
-#ifndef _BLACKFIN_DMA_MAPPING_H
-#define _BLACKFIN_DMA_MAPPING_H
-
-#include <asm/scatterlist.h>
-
-void dma_alloc_init(unsigned long start, unsigned long end);
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
-
-static inline
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
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
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-	       enum dma_data_direction dir)
-{
-	dma_unmap_single(dev, dma_addr, size, dir);
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
-
-static inline void dma_sync_single_for_cpu(struct device *dev,
-					dma_addr_t handle, size_t size,
-					enum dma_data_direction dir)
-{
-}
-
-static inline void dma_sync_single_for_device(struct device *dev,
-					dma_addr_t handle, size_t size,
-					enum dma_data_direction dir)
-{
-}
-#endif				/* _BLACKFIN_DMA_MAPPING_H */
+#ifndef _BLACKFIN_DMA_MAPPING_H
+#define _BLACKFIN_DMA_MAPPING_H
+
+static inline int
+dma_coherent_dev(struct device *dev)
+{
+	return 0;
+}
+
+static inline void
+dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction)
+{
+}
+
+extern void dma_alloc_init(unsigned long start, unsigned long end);
+
+#include <asm-generic/dma-mapping-linear.h>
+
+#endif				/* _BLACKFIN_DMA_MAPPING_H */
diff --git a/arch/cris/include/asm/dma-mapping.h b/arch/cris/include/asm/dma-mapping.h
dissimilarity index 91%
index da8ef8e..75c837e 100644
--- a/arch/cris/include/asm/dma-mapping.h
+++ b/arch/cris/include/asm/dma-mapping.h
@@ -1,170 +1,24 @@
-/* DMA mapping. Nothing tricky here, just virt_to_phys */
-
-#ifndef _ASM_CRIS_DMA_MAPPING_H
-#define _ASM_CRIS_DMA_MAPPING_H
-
-#include <linux/mm.h>
-#include <linux/kernel.h>
-
-#include <asm/cache.h>
-#include <asm/io.h>
-#include <asm/scatterlist.h>
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-#ifdef CONFIG_PCI
-#include <asm-generic/dma-coherent.h>
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
-#else
-static inline void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-                   gfp_t flag)
-{
-        BUG();
-        return NULL;
-}
-
-static inline void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-                    dma_addr_t dma_handle)
-{
-        BUG();
-}
-#endif
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	return virt_to_phys(ptr);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	printk("Map sg\n");
-	return nents;
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-	     size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	return page_to_phys(page) + offset;
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
-{
-}
-
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-        /*
-         * we fall back to GFP_DMA when the mask isn't all 1s,
-         * so we can't guarantee allocations that must be
-         * within a tighter range than GFP_DMA..
-         */
-        if(mask < 0x00ffffff)
-                return 0;
-
-	return 1;
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	if(!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
-static inline int
-dma_get_cache_alignment(void)
-{
-	return (1 << INTERNODE_CACHE_SHIFT);
-}
-
-#define dma_is_consistent(d, h)	(1)
-
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-{
-}
-
-
-#endif
+#ifndef _ASM_CRIS_DMA_MAPPING_H
+#define _ASM_CRIS_DMA_MAPPING_H
+
+#include <linux/mm.h>
+#include <linux/kernel.h>
+
+#include <asm/cache.h>
+#include <asm/io.h>
+#include <asm/scatterlist.h>
+#include <asm-generic/dma-mapping-linear.h>
+
+#ifdef CONFIG_PCI
+#include <asm-generic/dma-coherent.h>
+#endif
+
+static inline int
+cris_dma_get_cache_alignment(void)
+{
+	return (1 << INTERNODE_CACHE_SHIFT);
+}
+
+#define dma_get_cache_alignment cris_dma_get_cache_alignment
+
+#endif
diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
dissimilarity index 90%
index ccae8f6..d888fd1 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -1,234 +1,32 @@
-/* DMA mapping routines for the MN10300 arch
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_DMA_MAPPING_H
-#define _ASM_DMA_MAPPING_H
-
-#include <linux/mm.h>
-#include <linux/scatterlist.h>
-
-#include <asm/cache.h>
-#include <asm/io.h>
-
-extern void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, int flag);
-
-extern void dma_free_coherent(struct device *dev, size_t size,
-			      void *vaddr, dma_addr_t dma_handle);
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
-#define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
-
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.  The
- * 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory until
- * either pci_unmap_single or pci_dma_sync_single is performed.
- */
-static inline
-dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-			  enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	mn10300_dcache_flush_inv();
-	return virt_to_bus(ptr);
-}
-
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size must
- * match what was provided for in a previous pci_map_single call.  All other
- * usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
-static inline
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		      enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-/*
- * Map a set of buffers described by scatterlist in streaming mode for DMA.
- * This is the scather-gather version of the above pci_map_single interface.
- * Here the scatter gather list elements are each tagged with the appropriate
- * dma address and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of DMA
- *       address/length pairs than there are SG table elements.  (for example
- *       via virtual mapping capabilities) The routine returns the number of
- *       addr/length pairs actually used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are the same
- * here.
- */
-static inline
-int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	       enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	int i;
-
-	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nents == 0 || sglist[0].length == 0);
-
-	for_each_sg(sglist, sg, nents, i) {
-		BUG_ON(!sg_page(sg));
-
-		sg->dma_address = sg_phys(sg);
-	}
-
-	mn10300_dcache_flush_inv();
-	return nents;
-}
-
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-static inline
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-		  enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
-/*
- * pci_{map,unmap}_single_page maps a kernel page to a dma_addr_t. identical
- * to pci_map_single, but takes a struct page instead of a virtual address
- */
-static inline
-dma_addr_t dma_map_page(struct device *dev, struct page *page,
-			unsigned long offset, size_t size,
-			enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	return page_to_bus(page) + offset;
-}
-
-static inline
-void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-		    enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-/*
- * Make physical memory consistent for a single streaming mode DMA translation
- * after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the buffer using
- * the cpu, yet do not wish to teardown the PCI dma mapping, you must call this
- * function before doing so.  At the next point you give the PCI dma address
- * back to the card, the device again owns the buffer.
- */
-static inline
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			     size_t size, enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-				size_t size, enum dma_data_direction direction)
-{
-	mn10300_dcache_flush_inv();
-}
-
-static inline
-void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				   unsigned long offset, size_t size,
-				   enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	mn10300_dcache_flush_inv();
-}
-
-
-/*
- * Make physical memory consistent for a set of streaming mode DMA translations
- * after a transfer.
- *
- * The same as pci_dma_sync_single but for a scatter-gather list, same rules
- * and usage.
- */
-static inline
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-			 int nelems, enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-			    int nelems, enum dma_data_direction direction)
-{
-	mn10300_dcache_flush_inv();
-}
-
-static inline
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-/*
- * Return whether the given PCI device DMA address mask can be supported
- * properly.  For example, if your device can only drive the low 24-bits during
- * PCI bus mastering, then you would pass 0x00ffffff as the mask to this
- * function.
- */
-static inline
-int dma_supported(struct device *dev, u64 mask)
-{
-	/*
-	 * we fall back to GFP_DMA when the mask isn't all 1s, so we can't
-	 * guarantee allocations that must be within a tighter range than
-	 * GFP_DMA
-	 */
-	if (mask < 0x00ffffff)
-		return 0;
-	return 1;
-}
-
-static inline
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-	return 0;
-}
-
-static inline
-int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
-#define dma_is_consistent(d)	(1)
-
-static inline
-void dma_cache_sync(void *vaddr, size_t size,
-		    enum dma_data_direction direction)
-{
-	mn10300_dcache_flush_inv();
-}
-
-#endif
+/* DMA mapping routines for the MN10300 arch
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_DMA_MAPPING_H
+#define _ASM_DMA_MAPPING_H
+
+#include <linux/mm.h>
+#include <asm/cache.h>
+#include <asm/io.h>
+static inline int
+dma_coherent_dev(struct device *dev)
+{
+	return 0;
+}
+
+static inline void
+dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction)
+{
+	mn10300_dcache_flush_inv();
+}
+
+#include <asm-generic/dma-mapping-linear.h>
+
+#endif
diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
dissimilarity index 87%
index ea9d4f4..6b0361c 100644
--- a/arch/sh/include/asm/dma-mapping.h
+++ b/arch/sh/include/asm/dma-mapping.h
@@ -1,219 +1,39 @@
-#ifndef __ASM_SH_DMA_MAPPING_H
-#define __ASM_SH_DMA_MAPPING_H
-
-#include <linux/mm.h>
-#include <linux/scatterlist.h>
-#include <linux/dma-debug.h>
-#include <asm/cacheflush.h>
-#include <asm/io.h>
-#include <asm-generic/dma-coherent.h>
-
-extern struct bus_type pci_bus_type;
-
-#define dma_supported(dev, mask)	(1)
-
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-		       void *vaddr, dma_addr_t dma_handle);
-
-void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-		    enum dma_data_direction dir);
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h) (1)
-
-static inline dma_addr_t dma_map_single(struct device *dev,
-					void *ptr, size_t size,
-					enum dma_data_direction dir)
-{
-	dma_addr_t addr = virt_to_phys(ptr);
-
-#if defined(CONFIG_PCI) && !defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-	if (dev->bus == &pci_bus_type)
-		return addr;
-#endif
-	dma_cache_sync(dev, ptr, size, dir);
-
-	debug_dma_map_page(dev, virt_to_page(ptr),
-			   (unsigned long)ptr & ~PAGE_MASK, size,
-			   dir, addr, true);
-
-	return addr;
-}
-
-static inline void dma_unmap_single(struct device *dev, dma_addr_t addr,
-				    size_t size, enum dma_data_direction dir)
-{
-	debug_dma_unmap_page(dev, addr, size, dir, true);
-}
-
-static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     int nents, enum dma_data_direction dir)
-{
-	int i;
-
-	for (i = 0; i < nents; i++) {
-#if !defined(CONFIG_PCI) || defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, dir);
-#endif
-		sg[i].dma_address = sg_phys(&sg[i]);
-		sg[i].dma_length = sg[i].length;
-	}
-
-	debug_dma_map_sg(dev, sg, nents, i, dir);
-
-	return nents;
-}
-
-static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction dir)
-{
-	debug_dma_unmap_sg(dev, sg, nents, dir);
-}
-
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction dir)
-{
-	return dma_map_single(dev, page_address(page) + offset, size, dir);
-}
-
-static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-				  size_t size, enum dma_data_direction dir)
-{
-	dma_unmap_single(dev, dma_address, size, dir);
-}
-
-static inline void dma_sync_single(struct device *dev, dma_addr_t dma_handle,
-				   size_t size, enum dma_data_direction dir)
-{
-#if defined(CONFIG_PCI) && !defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-	if (dev->bus == &pci_bus_type)
-		return;
-#endif
-	dma_cache_sync(dev, phys_to_virt(dma_handle), size, dir);
-}
-
-static inline void dma_sync_single_range(struct device *dev,
-					 dma_addr_t dma_handle,
-					 unsigned long offset, size_t size,
-					 enum dma_data_direction dir)
-{
-#if defined(CONFIG_PCI) && !defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-	if (dev->bus == &pci_bus_type)
-		return;
-#endif
-	dma_cache_sync(dev, phys_to_virt(dma_handle) + offset, size, dir);
-}
-
-static inline void dma_sync_sg(struct device *dev, struct scatterlist *sg,
-			       int nelems, enum dma_data_direction dir)
-{
-	int i;
-
-	for (i = 0; i < nelems; i++) {
-#if !defined(CONFIG_PCI) || defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, dir);
-#endif
-		sg[i].dma_address = sg_phys(&sg[i]);
-		sg[i].dma_length = sg[i].length;
-	}
-}
-
-static inline void dma_sync_single_for_cpu(struct device *dev,
-					   dma_addr_t dma_handle, size_t size,
-					   enum dma_data_direction dir)
-{
-	dma_sync_single(dev, dma_handle, size, dir);
-	debug_dma_sync_single_for_cpu(dev, dma_handle, size, dir);
-}
-
-static inline void dma_sync_single_for_device(struct device *dev,
-					      dma_addr_t dma_handle,
-					      size_t size,
-					      enum dma_data_direction dir)
-{
-	dma_sync_single(dev, dma_handle, size, dir);
-	debug_dma_sync_single_for_device(dev, dma_handle, size, dir);
-}
-
-static inline void dma_sync_single_range_for_cpu(struct device *dev,
-						 dma_addr_t dma_handle,
-						 unsigned long offset,
-						 size_t size,
-						 enum dma_data_direction direction)
-{
-	dma_sync_single_for_cpu(dev, dma_handle+offset, size, direction);
-	debug_dma_sync_single_range_for_cpu(dev, dma_handle,
-					    offset, size, direction);
-}
-
-static inline void dma_sync_single_range_for_device(struct device *dev,
-						    dma_addr_t dma_handle,
-						    unsigned long offset,
-						    size_t size,
-						    enum dma_data_direction direction)
-{
-	dma_sync_single_for_device(dev, dma_handle+offset, size, direction);
-	debug_dma_sync_single_range_for_device(dev, dma_handle,
-					       offset, size, direction);
-}
-
-
-static inline void dma_sync_sg_for_cpu(struct device *dev,
-				       struct scatterlist *sg, int nelems,
-				       enum dma_data_direction dir)
-{
-	dma_sync_sg(dev, sg, nelems, dir);
-	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-}
-
-static inline void dma_sync_sg_for_device(struct device *dev,
-					  struct scatterlist *sg, int nelems,
-					  enum dma_data_direction dir)
-{
-	dma_sync_sg(dev, sg, nelems, dir);
-	debug_dma_sync_sg_for_device(dev, sg, nelems, dir);
-}
-
-static inline int dma_get_cache_alignment(void)
-{
-	/*
-	 * Each processor family will define its own L1_CACHE_SHIFT,
-	 * L1_CACHE_BYTES wraps to this, so this is always safe.
-	 */
-	return L1_CACHE_BYTES;
-}
-
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return dma_addr == 0;
-}
-
-#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
-
-extern void
-dma_release_declared_memory(struct device *dev);
-
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
-
-#endif /* __ASM_SH_DMA_MAPPING_H */
+#ifndef __ASM_SH_DMA_MAPPING_H
+#define __ASM_SH_DMA_MAPPING_H
+
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-debug.h>
+#include <asm/cacheflush.h>
+#include <asm/io.h>
+#include <asm-generic/dma-coherent.h>
+
+static inline int dma_coherent_dev(struct device *dev)
+{
+#if defined(CONFIG_PCI) && !defined(CONFIG_SH_PCIDMA_NONCOHERENT)
+	if (dev->bus == &pci_bus_type)
+		return 1;
+#endif
+	return 0;
+}
+
+extern void
+dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction);
+
+#include <asm-generic/dma-mapping-linear.h>
+
+extern void
+dma_release_declared_memory(struct device *dev);
+
+extern void *
+dma_mark_declared_memory_occupied(struct device *dev,
+				  dma_addr_t device_addr, size_t size);
+
+#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
+
+extern int
+dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+			    dma_addr_t device_addr, size_t size, int flags);
+
+#endif /* __ASM_SH_DMA_MAPPING_H */
diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
dissimilarity index 82%
index 51882ae..4134617 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -1,179 +1,41 @@
-/*
- * include/asm-xtensa/dma-mapping.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2003 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_DMA_MAPPING_H
-#define _XTENSA_DMA_MAPPING_H
-
-#include <asm/cache.h>
-#include <asm/io.h>
-#include <linux/mm.h>
-#include <linux/scatterlist.h>
-
-/*
- * DMA-consistent mapping functions.
- */
-
-extern void *consistent_alloc(int, size_t, dma_addr_t, unsigned long);
-extern void consistent_free(void*, size_t, dma_addr_t);
-extern void consistent_sync(void*, size_t, int);
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
-
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	consistent_sync(ptr, size, direction);
-	return virt_to_phys(ptr);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	int i;
-
-	BUG_ON(direction == DMA_NONE);
-
-	for (i = 0; i < nents; i++, sg++ ) {
-		BUG_ON(!sg_page(sg));
-
-		sg->dma_address = sg_phys(sg);
-		consistent_sync(sg_virt(sg), sg->length, direction);
-	}
-
-	return nents;
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-	     size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	return (dma_addr_t)(page_to_pfn(page)) * PAGE_SIZE + offset;
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-		enum dma_data_direction direction)
-{
-	consistent_sync((void *)bus_to_virt(dma_handle), size, direction);
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-		enum dma_data_direction direction)
-{
-	consistent_sync((void *)bus_to_virt(dma_handle), size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-{
-
-	consistent_sync((void *)bus_to_virt(dma_handle)+offset,size,direction);
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-{
-
-	consistent_sync((void *)bus_to_virt(dma_handle)+offset,size,direction);
-}
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		 enum dma_data_direction dir)
-{
-	int i;
-	for (i = 0; i < nelems; i++, sg++)
-		consistent_sync(sg_virt(sg), sg->length, dir);
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		 enum dma_data_direction dir)
-{
-	int i;
-	for (i = 0; i < nelems; i++, sg++)
-		consistent_sync(sg_virt(sg), sg->length, dir);
-}
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	return 1;
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	if(!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
-static inline int
-dma_get_cache_alignment(void)
-{
-	return L1_CACHE_BYTES;
-}
-
-#define dma_is_consistent(d, h)	(1)
-
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-{
-	consistent_sync(vaddr, size, direction);
-}
-
-#endif	/* _XTENSA_DMA_MAPPING_H */
+/*
+ * include/asm-xtensa/dma-mapping.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2003 - 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_DMA_MAPPING_H
+#define _XTENSA_DMA_MAPPING_H
+
+#include <asm/cache.h>
+#include <asm/io.h>
+#include <linux/mm.h>
+
+/*
+ * DMA-consistent mapping functions.
+ */
+
+extern void *consistent_alloc(int, size_t, dma_addr_t, unsigned long);
+extern void consistent_free(void*, size_t, dma_addr_t);
+extern void consistent_sync(void*, size_t, int);
+
+static inline int
+dma_coherent_dev(struct device *dev)
+{
+	return 0;
+}
+
+static inline void
+dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction)
+{
+	consistent_sync(cpu_addr, size, direction);
+}
+
+#include <asm-generic/dma-mapping-linear.h>
+
+#endif	/* _XTENSA_DMA_MAPPING_H */

