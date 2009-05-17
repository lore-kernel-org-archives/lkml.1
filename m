Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZEQWsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZEQWsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZEQWsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:48:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbZEQWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:48:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] asm-generic: add a dma-mapping.h file
Date: Sun, 17 May 2009 22:45:21 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <htejun@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
References: <20090513043409.GA13577@cynthia.pants.nu> <200905172138.55145.arnd@arndb.de> <4A106E22.1010705@pobox.com>
In-Reply-To: <4A106E22.1010705@pobox.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905172245.23774.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX182mZDfA0QkaD17toeanYI7gQo+7b/bflnpLHb
 OYCugnrAOkCbsDTRs4ieCRP6z2TYrKyhq8UBiricbRKmBF46Cc
 89AQsvNSRhR/lbxyqrHvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h8300 and m32r currently do not provide a DMA mapping API
and therefore cannot use the ATA drivers. This adds a
generic version of dma-mapping.h for architectures that
have none or very minimal actual support for DMA in hardware
and makes the two architectures use it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Sunday 17 May 2009 20:05:54 Jeff Garzik wrote:

> That's what needs to happen.  We provide no-op functions for e.g. PCI 
> and x86 DMI, for platforms where this support does not exist.
> 
> Pretty much all architectures support some form of ATA.  m68k, m32r, 
> h8300 and microblaze all have IDE interface, which means that libata 
> needs to work on that platform.
> 
> The only !ATA arch in the entire kernel is s390, AFAICT.

m68k only defines NO_DMA for Sun3 and Dragonball. Sun3 does
not have ATA, Dragonball could probably just enable HAS_DMA.

---
 arch/h8300/Kconfig                   |    2 +-
 arch/h8300/include/asm/dma-mapping.h |    1 +
 arch/m32r/Kconfig                    |    2 +-
 arch/m32r/include/asm/dma-mapping.h  |    1 +
 include/asm-generic/dma-mapping.h    |  399 ++++++++++++++++++++++++++++++++++
 5 files changed, 403 insertions(+), 2 deletions(-)
 create mode 100644 arch/h8300/include/asm/dma-mapping.h
 create mode 100644 arch/m32r/include/asm/dma-mapping.h
 create mode 100644 include/asm-generic/dma-mapping.h

diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 9420648..36a037d 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -74,7 +74,7 @@ config NO_IOPORT
 	def_bool y
 
 config NO_DMA
-	def_bool y
+	def_bool n
 
 config ISA
 	bool
diff --git a/arch/h8300/include/asm/dma-mapping.h b/arch/h8300/include/asm/dma-mapping.h
new file mode 100644
index 0000000..e7e1690
--- /dev/null
+++ b/arch/h8300/include/asm/dma-mapping.h
@@ -0,0 +1 @@
+#include <asm-generic/dma-mapping.h>
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index cabba33..57ad603 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -35,7 +35,7 @@ config NO_IOPORT
 	def_bool y
 
 config NO_DMA
-	def_bool y
+	def_bool n
 
 config HZ
 	int
diff --git a/arch/m32r/include/asm/dma-mapping.h b/arch/m32r/include/asm/dma-mapping.h
new file mode 100644
index 0000000..e7e1690
--- /dev/null
+++ b/arch/m32r/include/asm/dma-mapping.h
@@ -0,0 +1 @@
+#include <asm-generic/dma-mapping.h>
diff --git a/include/asm-generic/dma-mapping.h b/include/asm-generic/dma-mapping.h
new file mode 100644
index 0000000..5a14fed
--- /dev/null
+++ b/include/asm-generic/dma-mapping.h
@@ -0,0 +1,399 @@
+#ifndef _ASM_GENERIC_DMA_MAPPING_H
+#define _ASM_GENERIC_DMA_MAPPING_H
+/*
+ * This provides a no-op variant of the DMA mapping API,
+ * for use by architectures that do not actually support
+ * DMA, or that are fully consistent and linear-mapped
+ * in their DMA implementation.
+ */
+
+#include <asm/scatterlist.h>
+
+/*
+ * If any driver asks for DMA, it's not supported.
+ */
+#ifndef dma_supported
+static inline int
+dma_supported(struct device *dev, u64 mask)
+{
+	return 0;
+}
+#endif
+
+#ifndef dma_set_mask
+static inline int
+dma_set_mask(struct device *dev, u64 dma_mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
+		return -EIO;
+
+	*dev->dma_mask = dma_mask;
+	return 0;
+}
+#endif
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
+#ifndef dma_alloc_coherent
+static inline void *
+dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		   gfp_t flag)
+{
+	void *virt = kmalloc(size, flag);
+	*dma_handle = virt_to_phys(virt);
+
+	return virt;
+}
+#endif
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
+#ifndef dma_free_coherent
+static inline void
+dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
+		  dma_addr_t dma_handle)
+{
+	kfree(cpu_addr);
+}
+#endif
+
+#ifndef dma_alloc_noncoherent
+static inline void *
+dma_alloc_noncoherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		   gfp_t flag)
+{
+	return dma_alloc_coherent(dev, size, dma_handle, flag);
+}
+#endif
+
+#ifndef dma_free_noncoherent
+static inline void
+dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
+		  dma_addr_t dma_handle)
+{
+	return dma_free_coherent(dev, size, cpu_addr, dma_handle);
+}
+#endif
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
+#ifndef dma_map_single
+static inline dma_addr_t
+dma_map_single(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction direction)
+{
+	return virt_to_phys(cpu_addr);
+}
+#endif
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
+#ifndef dma_unmap_single
+static inline void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction)
+{
+}
+#endif
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
+#ifndef dma_map_page
+static inline dma_addr_t
+dma_map_page(struct device *dev, struct page *page,
+	     unsigned long offset, size_t size,
+	     enum dma_data_direction direction)
+{
+	return dma_map_single(dev, page_to_virt(page), size, direction);
+}
+#endif
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
+#ifndef dma_unmap_page
+static inline void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction)
+{
+	dma_unmap_single(dev, dma_address, size, direction);
+}
+#endif
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
+#ifndef dma_map_sg
+static inline int
+dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
+	   enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+        for_each_sg(sgl, sg, nents, i) {
+                sg->dma_address = sg_phys(sg);
+                sg->dma_length = sg->length;
+        }
+
+	return nents;
+}
+#endif
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
+#ifndef dma_unmap_sg
+static inline void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction)
+{
+}
+#endif
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
+#ifndef dma_sync_single_for_cpu
+static inline void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			 size_t size, enum dma_data_direction direction)
+{
+}
+#endif
+
+/**
+ * dma_sync_single_for_device
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Make physical memory consistent for a single streaming mode DMA
+ * translation before a transfer.
+ */
+#ifndef dma_sync_single_for_cpu
+static inline void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+			 size_t size, enum dma_data_direction direction)
+{
+	return dma_sync_single_for_cpu(dev, dma_handle, size, direction);
+}
+#endif
+
+#ifndef dma_sync_single_range_for_cpu
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
+}
+#endif
+
+#ifndef dma_sync_single_range_for_device
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
+}
+#endif
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
+ * The same as dma_sync_single_for_cpu but for a
+ * scatter-gather list, same rules and usage.
+ */
+#ifndef dma_sync_sg_for_cpu
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sgl,
+		 int nelems, enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+        for_each_sg(sgl, sg, nelems, i) {
+		dma_sync_single_for_cpu(dev, sg->dma_address,
+			 sg->dma_length, direction);
+        }
+}
+#endif
+
+/**
+ * dma_sync_sg_for_device
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @sg: list of buffers
+ * @nents: number of buffers to map
+ * @dir: DMA transfer direction
+ *
+ * Make physical memory consistent for a set of streaming
+ * mode DMA translations before a transfer.
+ *
+ * The same as dma_sync_single_for_device but for a
+ * scatter-gather list, same rules and usage.
+ */
+#ifndef dma_sync_sg_for_device
+static inline void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
+		 int nelems, enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+        for_each_sg(sgl, sg, nelems, i) {
+		dma_sync_single_for_device(dev, sg->dma_address,
+			 sg->dma_length, direction);
+        }
+}
+#endif
+
+#ifndef dma_is_consistent
+static inline int
+dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
+{
+	return 1;
+}
+#endif
+
+#ifndef dma_get_cache_alignment
+static inline int
+dma_get_cache_alignment(void)
+{
+	return 1;
+}
+#endif
+
+#ifndef dma_mapping_error
+static inline int
+dma_mapping_error(struct device *dev, dma_addr_t dma_handle)
+{
+	return 0;
+}
+#endif
+
+#ifndef dma_cache_sync
+static inline void
+dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+	       enum dma_data_direction direction)
+{
+}
+#endif
+
+#endif
-- 
1.6.0.4

