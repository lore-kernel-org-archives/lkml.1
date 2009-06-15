Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZFOLix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZFOLix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZFOLip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:38:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63054 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZFOLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:38:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 10/17] Blackfin: convert dma/pci to asm-generic
Date: Mon, 15 Jun 2009 13:37:16 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> <1244980878-2124-11-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244980878-2124-11-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906151337.17066.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+as5wVDSA/OsuWL9GBOGS8JWU3ix143ReNLcv
 9IvFBULiBEgyXrQDi5f3uGWOGd2HB9+p9vt0VHVfGTbqFf4heO
 ixnNuZPgr5rnAjPnyBJ9DmO5UbmGPx9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> --- a/arch/blackfin/include/asm/dma-mapping.h
> +++ b/arch/blackfin/include/asm/dma-mapping.h
> @@ -2,97 +2,28 @@
>  #define _BLACKFIN_DMA_MAPPING_H
>  
>  #include <asm/scatterlist.h>
> +#include <asm-generic/dma-mapping-broken.h>

I would leave this one alone, I don't think that moving
to dma-mapping-broken.h helps here. I have a dma-mapping
branch in my asm-generic repository. While I could not
get an agreement on an approach for a common dma-mapping.h
file for asm-generic, I did a number of cleanups on a few
architectures. Feel free to take this patch as a base for
your work.

Completely untested, of course.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index d7d9148..3be8f93 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -3,63 +3,101 @@
 
 #include <asm/scatterlist.h>
 
-void dma_alloc_init(unsigned long start, unsigned long end);
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t gfp);
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-		       dma_addr_t dma_handle);
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
 
-/*
- * Now for the API extensions over the pci_ one
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
  */
+extern void
+dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
+		  dma_addr_t dma_handle);
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-static inline
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
+/**
+ * dma_map_single - map a single buffer for streaming DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @cpu_addr: CPU direct mapped address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Ensure that any data held in the cache is appropriately discarded
+ * or written back.
  *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
+ * The device owns this memory once this call has completed.  The CPU
+ * can regain ownership by calling dma_unmap_single() or dma_sync_single().
  */
-extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-				 enum dma_data_direction direction);
-
 static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction dir)
+dma_map_single(struct device *dev, void *ptr, size_t size,
+	       enum dma_data_direction direction)
 {
-	return dma_map_single(dev, page_address(page) + offset, size, dir);
+	dma_addr_t dma_addr = virt_to_bus(ptr);
+	BUG_ON(!valid_dma_direction(direction));
+
+	invalidate_dcache_range((unsigned long)ptr,
+			(unsigned long)ptr + size);
+
+	debug_dma_map_page(dev, virt_to_page(ptr),
+			   (unsigned long)ptr & ~PAGE_MASK, size,
+			   direction, dma_addr, true);
+
+	return dma_addr;
 }
 
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
+/**
+ * dma_unmap_single - unmap a single buffer previously mapped
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
  *
- * After this call, reads by the cpu to the buffer are guarenteed to see
+ * Unmap a single streaming mode DMA translation.  The handle and size
+ * must match what was provided in the previous dma_map_single() call.
+ * All other usages are undefined.
+ *
+ * After this call, reads by the CPU to the buffer are guaranteed to see
  * whatever the device wrote there.
  */
-extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-			  enum dma_data_direction direction);
-
 static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-	       enum dma_data_direction dir)
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction)
 {
-	dma_unmap_single(dev, dma_addr, size, dir);
+	debug_dma_unmap_page(dev, dma_addr, size, direction, true);
 }
 
-/*
+/**
+ * dma_map_sg - map a set of SG buffers for streaming mode DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @sg: list of buffers
+ * @nents: number of buffers to map
+ * @dir: DMA transfer direction
+ *
  * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
+ * mode for DMA.  This is the scatter-gather version of the
  * above pci_map_single interface.  Here the scatter gather list
  * elements are each tagged with the appropriate dma address
  * and length.  They are obtained via sg_dma_{address,length}(SG).
@@ -73,26 +111,229 @@ dma_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
  * Device ownership issues as mentioned above for pci_map_single are
  * the same here.
  */
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction direction);
+static inline int
+dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
+	   enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i, sync;
 
-/*
+	BUG_ON(!valid_dma_direction(direction));
+	WARN_ON(nents == 0 || sglist[0].length == 0);
+
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg_page(sg));
+
+		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
+		sg_dma_len(sg) = sg->length;
+
+		invalidate_dcache_range(sg_dma_address(sg),
+					sg_dma_address(sg) +
+					sg_dma_len(sg));
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
  * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
+ * Again, CPU read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		      int nhwentries, enum dma_data_direction direction);
+static inline void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction)
+{
+	debug_dma_unmap_sg(dev, sg, nhwentries, direction);
+}
 
-static inline void dma_sync_single_for_cpu(struct device *dev,
-					dma_addr_t handle, size_t size,
-					enum dma_data_direction dir)
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
 {
+	return dma_map_single(dev, page_address(page) + offset,
+			      size, direction);
 }
 
-static inline void dma_sync_single_for_device(struct device *dev,
-					dma_addr_t handle, size_t size,
-					enum dma_data_direction dir)
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
 {
+	dma_unmap_single(dev, dma_address, size, direction);
 }
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
+	invalidate_dcache_range(bus_to_virt(dma_handle),
+			bus_to_virt(dma_handle) + size);
+
+	debug_dma_sync_single_for_device(dev, dma_handle, size, direction);
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	invalidate_dcache_range(bus_to_virt(dma_handle),
+			bus_to_virt(dma_handle) + size);
+
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
+	for_each_sg(sglist, sg, nents, i)
+		invalidate_dcache_range(sg_virt(sg), sg_virt(sg) + sg->length);
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
+	return 0;
+}
+
+static inline void
+dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction)
+{
+	invalidate_dcache_range(cpu_addr, cpu_addr + size);
+}
+
+void dma_alloc_init(unsigned long start, unsigned long end);
+
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
index 2f62a9f..bbd4874 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -134,54 +134,3 @@ dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 	__free_dma_pages((unsigned long)vaddr, get_pages(size));
 }
 EXPORT_SYMBOL(dma_free_coherent);
-
-/*
- * Dummy functions defined for some existing drivers
- */
-
-dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-
-	invalidate_dcache_range((unsigned long)ptr,
-			(unsigned long)ptr + size);
-
-	return (dma_addr_t) ptr;
-}
-EXPORT_SYMBOL(dma_map_single);
-
-int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	int i;
-
-	BUG_ON(direction == DMA_NONE);
-
-	for (i = 0; i < nents; i++, sg++) {
-		sg->dma_address = (dma_addr_t) sg_virt(sg);
-
-		invalidate_dcache_range(sg_dma_address(sg),
-					sg_dma_address(sg) +
-					sg_dma_len(sg));
-	}
-
-	return nents;
-}
-EXPORT_SYMBOL(dma_map_sg);
-
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-EXPORT_SYMBOL(dma_unmap_single);
-
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nhwentries, enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-EXPORT_SYMBOL(dma_unmap_sg);
