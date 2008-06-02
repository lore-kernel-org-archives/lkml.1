Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbYFBTzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbYFBTzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYFBTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:54:56 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52457 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYFBTyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:54:46 -0400
Date: Mon, 2 Jun 2008 15:54:39 -0400
To: Jon Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: mv DMA-* to separate DMA/ subdirectory
Message-ID: <20080602195439.GA27583@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Every now and then as I'm looking for something in Documentation/ I get
annoyed at how cluttered that directory is, and go look for a few files
that could be grouped into a subdirectory.  This seemed like one
candidate, though a lot of referenes to DMA-mapping.txt require fixing.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---

A Documentation/arch directory would take out another dozen entries or
so, but I haven't had the energy.--b.

 Documentation/00-INDEX               |    4 -
 Documentation/DMA-API.txt            |  614 ---------------------------
 Documentation/DMA-ISA-LPC.txt        |  151 -------
 Documentation/DMA-attributes.txt     |   24 -
 Documentation/DMA-mapping.txt        |  766 ----------------------------------
 Documentation/DMA/00-INDEX           |   10 +
 Documentation/DMA/DMA-API.txt        |  614 +++++++++++++++++++++++++++
 Documentation/DMA/DMA-ISA-LPC.txt    |  151 +++++++
 Documentation/DMA/DMA-attributes.txt |   24 +
 Documentation/DMA/DMA-mapping.txt    |  766 ++++++++++++++++++++++++++++++++++
 Documentation/IO-mapping.txt         |    2 +-
 Documentation/PCI/pci.txt            |    6 +-
 Documentation/block/biodoc.txt       |    5 +-
 Documentation/memory-barriers.txt    |    2 +-
 Documentation/usb/dma.txt            |   13 +-
 arch/ia64/hp/common/sba_iommu.c      |   12 +-
 arch/ia64/sn/pci/pci_dma.c           |    4 +-
 arch/parisc/kernel/pci-dma.c         |    2 +-
 arch/x86/kernel/pci-gart_64.c        |    2 +-
 drivers/net/tehuti.c                 |    2 +-
 drivers/parisc/sba_iommu.c           |   18 +-
 include/asm-ia64/dma-mapping.h       |    2 +-
 include/asm-parisc/dma-mapping.h     |    2 +-
 include/asm-x86/dma-mapping.h        |    2 +-
 include/linux/dma-attrs.h            |    2 +-
 include/media/videobuf-dma-sg.h      |    2 +-
 26 files changed, 1605 insertions(+), 1597 deletions(-)
 delete mode 100644 Documentation/DMA-API.txt
 delete mode 100644 Documentation/DMA-ISA-LPC.txt
 delete mode 100644 Documentation/DMA-attributes.txt
 delete mode 100644 Documentation/DMA-mapping.txt
 create mode 100644 Documentation/DMA/00-INDEX
 create mode 100644 Documentation/DMA/DMA-API.txt
 create mode 100644 Documentation/DMA/DMA-ISA-LPC.txt
 create mode 100644 Documentation/DMA/DMA-attributes.txt
 create mode 100644 Documentation/DMA/DMA-mapping.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 1977fab..21b6171 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -21,10 +21,6 @@ Changes
 	- list of changes that break older software packages.
 CodingStyle
 	- how the boss likes the C code in the kernel to look.
-DMA-API.txt
-	- DMA API, pci_ API & extensions for non-consistent memory machines.
-DMA-ISA-LPC.txt
-	- How to do DMA with ISA (and LPC) devices.
 DocBook/
 	- directory with DocBook templates etc. for kernel documentation.
 HOWTO
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
deleted file mode 100644
index 80d1504..0000000
--- a/Documentation/DMA-API.txt
+++ /dev/null
@@ -1,614 +0,0 @@
-               Dynamic DMA mapping using the generic device
-               ============================================
-
-        James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
-
-This document describes the DMA API.  For a more gentle introduction
-phrased in terms of the pci_ equivalents (and actual examples) see
-DMA-mapping.txt
-
-This API is split into two pieces.  Part I describes the API and the
-corresponding pci_ API.  Part II describes the extensions to the API
-for supporting non-consistent memory machines.  Unless you know that
-your driver absolutely has to support non-consistent platforms (this
-is usually only legacy platforms) you should only use the API
-described in part I.
-
-Part I - pci_ and dma_ Equivalent API 
--------------------------------------
-
-To get the pci_ API, you must #include <linux/pci.h>
-To get the dma_ API, you must #include <linux/dma-mapping.h>
-
-
-Part Ia - Using large dma-coherent buffers
-------------------------------------------
-
-void *
-dma_alloc_coherent(struct device *dev, size_t size,
-			     dma_addr_t *dma_handle, gfp_t flag)
-void *
-pci_alloc_consistent(struct pci_dev *dev, size_t size,
-			     dma_addr_t *dma_handle)
-
-Consistent memory is memory for which a write by either the device or
-the processor can immediately be read by the processor or device
-without having to worry about caching effects.  (You may however need
-to make sure to flush the processor's write buffers before telling
-devices to read that memory.)
-
-This routine allocates a region of <size> bytes of consistent memory.
-It also returns a <dma_handle> which may be cast to an unsigned
-integer the same width as the bus and used as the physical address
-base of the region.
-
-Returns: a pointer to the allocated region (in the processor's virtual
-address space) or NULL if the allocation failed.
-
-Note: consistent memory can be expensive on some platforms, and the
-minimum allocation length may be as big as a page, so you should
-consolidate your requests for consistent memory as much as possible.
-The simplest way to do that is to use the dma_pool calls (see below).
-
-The flag parameter (dma_alloc_coherent only) allows the caller to
-specify the GFP_ flags (see kmalloc) for the allocation (the
-implementation may choose to ignore flags that affect the location of
-the returned memory, like GFP_DMA).  For pci_alloc_consistent, you
-must assume GFP_ATOMIC behaviour.
-
-void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-			   dma_addr_t dma_handle)
-void
-pci_free_consistent(struct pci_dev *dev, size_t size, void *cpu_addr,
-			   dma_addr_t dma_handle)
-
-Free the region of consistent memory you previously allocated.  dev,
-size and dma_handle must all be the same as those passed into the
-consistent allocate.  cpu_addr must be the virtual address returned by
-the consistent allocate.
-
-Note that unlike their sibling allocation calls, these routines
-may only be called with IRQs enabled.
-
-
-Part Ib - Using small dma-coherent buffers
-------------------------------------------
-
-To get this part of the dma_ API, you must #include <linux/dmapool.h>
-
-Many drivers need lots of small dma-coherent memory regions for DMA
-descriptors or I/O buffers.  Rather than allocating in units of a page
-or more using dma_alloc_coherent(), you can use DMA pools.  These work
-much like a struct kmem_cache, except that they use the dma-coherent allocator,
-not __get_free_pages().  Also, they understand common hardware constraints
-for alignment, like queue heads needing to be aligned on N-byte boundaries.
-
-
-	struct dma_pool *
-	dma_pool_create(const char *name, struct device *dev,
-			size_t size, size_t align, size_t alloc);
-
-	struct pci_pool *
-	pci_pool_create(const char *name, struct pci_device *dev,
-			size_t size, size_t align, size_t alloc);
-
-The pool create() routines initialize a pool of dma-coherent buffers
-for use with a given device.  It must be called in a context which
-can sleep.
-
-The "name" is for diagnostics (like a struct kmem_cache name); dev and size
-are like what you'd pass to dma_alloc_coherent().  The device's hardware
-alignment requirement for this type of data is "align" (which is expressed
-in bytes, and must be a power of two).  If your device has no boundary
-crossing restrictions, pass 0 for alloc; passing 4096 says memory allocated
-from this pool must not cross 4KByte boundaries.
-
-
-	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
-			dma_addr_t *dma_handle);
-
-	void *pci_pool_alloc(struct pci_pool *pool, gfp_t gfp_flags,
-			dma_addr_t *dma_handle);
-
-This allocates memory from the pool; the returned memory will meet the size
-and alignment requirements specified at creation time.  Pass GFP_ATOMIC to
-prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks),
-pass GFP_KERNEL to allow blocking.  Like dma_alloc_coherent(), this returns
-two values:  an address usable by the cpu, and the dma address usable by the
-pool's device.
-
-
-	void dma_pool_free(struct dma_pool *pool, void *vaddr,
-			dma_addr_t addr);
-
-	void pci_pool_free(struct pci_pool *pool, void *vaddr,
-			dma_addr_t addr);
-
-This puts memory back into the pool.  The pool is what was passed to
-the pool allocation routine; the cpu (vaddr) and dma addresses are what
-were returned when that routine allocated the memory being freed.
-
-
-	void dma_pool_destroy(struct dma_pool *pool);
-
-	void pci_pool_destroy(struct pci_pool *pool);
-
-The pool destroy() routines free the resources of the pool.  They must be
-called in a context which can sleep.  Make sure you've freed all allocated
-memory back to the pool before you destroy it.
-
-
-Part Ic - DMA addressing limitations
-------------------------------------
-
-int
-dma_supported(struct device *dev, u64 mask)
-int
-pci_dma_supported(struct pci_dev *hwdev, u64 mask)
-
-Checks to see if the device can support DMA to the memory described by
-mask.
-
-Returns: 1 if it can and 0 if it can't.
-
-Notes: This routine merely tests to see if the mask is possible.  It
-won't change the current mask settings.  It is more intended as an
-internal API for use by the platform than an external API for use by
-driver writers.
-
-int
-dma_set_mask(struct device *dev, u64 mask)
-int
-pci_set_dma_mask(struct pci_device *dev, u64 mask)
-
-Checks to see if the mask is possible and updates the device
-parameters if it is.
-
-Returns: 0 if successful and a negative error if not.
-
-u64
-dma_get_required_mask(struct device *dev)
-
-After setting the mask with dma_set_mask(), this API returns the
-actual mask (within that already set) that the platform actually
-requires to operate efficiently.  Usually this means the returned mask
-is the minimum required to cover all of memory.  Examining the
-required mask gives drivers with variable descriptor sizes the
-opportunity to use smaller descriptors as necessary.
-
-Requesting the required mask does not alter the current mask.  If you
-wish to take advantage of it, you should issue another dma_set_mask()
-call to lower the mask again.
-
-
-Part Id - Streaming DMA mappings
---------------------------------
-
-dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-		      enum dma_data_direction direction)
-dma_addr_t
-pci_map_single(struct pci_dev *hwdev, void *cpu_addr, size_t size,
-		      int direction)
-
-Maps a piece of processor virtual memory so it can be accessed by the
-device and returns the physical handle of the memory.
-
-The direction for both api's may be converted freely by casting.
-However the dma_ API uses a strongly typed enumerator for its
-direction:
-
-DMA_NONE		= PCI_DMA_NONE		no direction (used for
-						debugging)
-DMA_TO_DEVICE		= PCI_DMA_TODEVICE	data is going from the
-						memory to the device
-DMA_FROM_DEVICE		= PCI_DMA_FROMDEVICE	data is coming from
-						the device to the
-						memory
-DMA_BIDIRECTIONAL	= PCI_DMA_BIDIRECTIONAL	direction isn't known
-
-Notes:  Not all memory regions in a machine can be mapped by this
-API.  Further, regions that appear to be physically contiguous in
-kernel virtual space may not be contiguous as physical memory.  Since
-this API does not provide any scatter/gather capability, it will fail
-if the user tries to map a non-physically contiguous piece of memory.
-For this reason, it is recommended that memory mapped by this API be
-obtained only from sources which guarantee it to be physically contiguous
-(like kmalloc).
-
-Further, the physical address of the memory must be within the
-dma_mask of the device (the dma_mask represents a bit mask of the
-addressable region for the device.  I.e., if the physical address of
-the memory anded with the dma_mask is still equal to the physical
-address, then the device can perform DMA to the memory).  In order to
-ensure that the memory allocated by kmalloc is within the dma_mask,
-the driver may specify various platform-dependent flags to restrict
-the physical memory range of the allocation (e.g. on x86, GFP_DMA
-guarantees to be within the first 16Mb of available physical memory,
-as required by ISA devices).
-
-Note also that the above constraints on physical contiguity and
-dma_mask may not apply if the platform has an IOMMU (a device which
-supplies a physical to virtual mapping between the I/O memory bus and
-the device).  However, to be portable, device driver writers may *not*
-assume that such an IOMMU exists.
-
-Warnings:  Memory coherency operates at a granularity called the cache
-line width.  In order for memory mapped by this API to operate
-correctly, the mapped region must begin exactly on a cache line
-boundary and end exactly on one (to prevent two separately mapped
-regions from sharing a single cache line).  Since the cache line size
-may not be known at compile time, the API will not enforce this
-requirement.  Therefore, it is recommended that driver writers who
-don't take special care to determine the cache line size at run time
-only map virtual regions that begin and end on page boundaries (which
-are guaranteed also to be cache line boundaries).
-
-DMA_TO_DEVICE synchronisation must be done after the last modification
-of the memory region by the software and before it is handed off to
-the driver.  Once this primitive is used, memory covered by this
-primitive should be treated as read-only by the device.  If the device
-may write to it at any point, it should be DMA_BIDIRECTIONAL (see
-below).
-
-DMA_FROM_DEVICE synchronisation must be done before the driver
-accesses data that may be changed by the device.  This memory should
-be treated as read-only by the driver.  If the driver needs to write
-to it at any point, it should be DMA_BIDIRECTIONAL (see below).
-
-DMA_BIDIRECTIONAL requires special handling: it means that the driver
-isn't sure if the memory was modified before being handed off to the
-device and also isn't sure if the device will also modify it.  Thus,
-you must always sync bidirectional memory twice: once before the
-memory is handed off to the device (to make sure all memory changes
-are flushed from the processor) and once before the data may be
-accessed after being used by the device (to make sure any processor
-cache lines are updated with data that the device may have changed).
-
-void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-void
-pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
-		 size_t size, int direction)
-
-Unmaps the region previously mapped.  All the parameters passed in
-must be identical to those passed in (and returned) by the mapping
-API.
-
-dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-		    unsigned long offset, size_t size,
-		    enum dma_data_direction direction)
-dma_addr_t
-pci_map_page(struct pci_dev *hwdev, struct page *page,
-		    unsigned long offset, size_t size, int direction)
-void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-void
-pci_unmap_page(struct pci_dev *hwdev, dma_addr_t dma_address,
-	       size_t size, int direction)
-
-API for mapping and unmapping for pages.  All the notes and warnings
-for the other mapping APIs apply here.  Also, although the <offset>
-and <size> parameters are provided to do partial page mapping, it is
-recommended that you never use these unless you really know what the
-cache width is.
-
-int
-dma_mapping_error(dma_addr_t dma_addr)
-
-int
-pci_dma_mapping_error(dma_addr_t dma_addr)
-
-In some circumstances dma_map_single and dma_map_page will fail to create
-a mapping. A driver can check for these errors by testing the returned
-dma address with dma_mapping_error(). A non-zero return value means the mapping
-could not be created and the driver should take appropriate action (e.g.
-reduce current DMA mapping usage or delay and try again later).
-
-	int
-	dma_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction direction)
-	int
-	pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-		int nents, int direction)
-
-Maps a scatter gather list from the block layer.
-
-Returns: the number of physical segments mapped (this may be shorter
-than <nents> passed in if the block layer determines that some
-elements of the scatter/gather list are physically adjacent and thus
-may be mapped with a single entry).
-
-Please note that the sg cannot be mapped again if it has been mapped once.
-The mapping process is allowed to destroy information in the sg.
-
-As with the other mapping interfaces, dma_map_sg can fail. When it
-does, 0 is returned and a driver must take appropriate action. It is
-critical that the driver do something, in the case of a block driver
-aborting the request or even oopsing is better than doing nothing and
-corrupting the filesystem.
-
-With scatterlists, you use the resulting mapping like this:
-
-	int i, count = dma_map_sg(dev, sglist, nents, direction);
-	struct scatterlist *sg;
-
-	for (i = 0, sg = sglist; i < count; i++, sg++) {
-		hw_address[i] = sg_dma_address(sg);
-		hw_len[i] = sg_dma_len(sg);
-	}
-
-where nents is the number of entries in the sglist.
-
-The implementation is free to merge several consecutive sglist entries
-into one (e.g. with an IOMMU, or if several pages just happen to be
-physically contiguous) and returns the actual number of sg entries it
-mapped them to. On failure 0, is returned.
-
-Then you should loop count times (note: this can be less than nents times)
-and use sg_dma_address() and sg_dma_len() macros where you previously
-accessed sg->address and sg->length as shown above.
-
-	void
-	dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nhwentries, enum dma_data_direction direction)
-	void
-	pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-		int nents, int direction)
-
-Unmap the previously mapped scatter/gather list.  All the parameters
-must be the same as those and passed in to the scatter/gather mapping
-API.
-
-Note: <nents> must be the number you passed in, *not* the number of
-physical entries returned.
-
-void
-dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
-		enum dma_data_direction direction)
-void
-pci_dma_sync_single(struct pci_dev *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
-void
-dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
-			  enum dma_data_direction direction)
-void
-pci_dma_sync_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
-
-Synchronise a single contiguous or scatter/gather mapping.  All the
-parameters must be the same as those passed into the single mapping
-API.
-
-Notes:  You must do this:
-
-- Before reading values that have been written by DMA from the device
-  (use the DMA_FROM_DEVICE direction)
-- After writing values that will be written to the device using DMA
-  (use the DMA_TO_DEVICE) direction
-- before *and* after handing memory to the device if the memory is
-  DMA_BIDIRECTIONAL
-
-See also dma_map_single().
-
-dma_addr_t
-dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
-		     enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
-
-void
-dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
-		       size_t size, enum dma_data_direction dir,
-		       struct dma_attrs *attrs)
-
-int
-dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
-		 int nents, enum dma_data_direction dir,
-		 struct dma_attrs *attrs)
-
-void
-dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
-		   int nents, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
-
-The four functions above are just like the counterpart functions
-without the _attrs suffixes, except that they pass an optional
-struct dma_attrs*.
-
-struct dma_attrs encapsulates a set of "dma attributes". For the
-definition of struct dma_attrs see linux/dma-attrs.h.
-
-The interpretation of dma attributes is architecture-specific, and
-each attribute should be documented in Documentation/DMA-attributes.txt.
-
-If struct dma_attrs* is NULL, the semantics of each of these
-functions is identical to those of the corresponding function
-without the _attrs suffix. As a result dma_map_single_attrs()
-can generally replace dma_map_single(), etc.
-
-As an example of the use of the *_attrs functions, here's how
-you could pass an attribute DMA_ATTR_FOO when mapping memory
-for DMA:
-
-#include <linux/dma-attrs.h>
-/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
- * documented in Documentation/DMA-attributes.txt */
-...
-
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_FOO, &attrs);
-	....
-	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
-	....
-
-Architectures that care about DMA_ATTR_FOO would check for its
-presence in their implementations of the mapping and unmapping
-routines, e.g.:
-
-void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
-			     size_t size, enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
-{
-	....
-	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
-	....
-	if (foo)
-		/* twizzle the frobnozzle */
-	....
-
-
-Part II - Advanced dma_ usage
------------------------------
-
-Warning: These pieces of the DMA API have no PCI equivalent.  They
-should also not be used in the majority of cases, since they cater for
-unlikely corner cases that don't belong in usual drivers.
-
-If you don't understand how cache line coherency works between a
-processor and an I/O device, you should not be using this part of the
-API at all.
-
-void *
-dma_alloc_noncoherent(struct device *dev, size_t size,
-			       dma_addr_t *dma_handle, gfp_t flag)
-
-Identical to dma_alloc_coherent() except that the platform will
-choose to return either consistent or non-consistent memory as it sees
-fit.  By using this API, you are guaranteeing to the platform that you
-have all the correct and necessary sync points for this memory in the
-driver should it choose to return non-consistent memory.
-
-Note: where the platform can return consistent memory, it will
-guarantee that the sync points become nops.
-
-Warning:  Handling non-consistent memory is a real pain.  You should
-only ever use this API if you positively know your driver will be
-required to work on one of the rare (usually non-PCI) architectures
-that simply cannot make consistent memory.
-
-void
-dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
-			      dma_addr_t dma_handle)
-
-Free memory allocated by the nonconsistent API.  All parameters must
-be identical to those passed in (and returned by
-dma_alloc_noncoherent()).
-
-int
-dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
-
-Returns true if the device dev is performing consistent DMA on the memory
-area pointed to by the dma_handle.
-
-int
-dma_get_cache_alignment(void)
-
-Returns the processor cache alignment.  This is the absolute minimum
-alignment *and* width that you must observe when either mapping
-memory or doing partial flushes.
-
-Notes: This API may return a number *larger* than the actual cache
-line, but it will guarantee that one or more cache lines fit exactly
-into the width returned by this call.  It will also always be a power
-of two for easy alignment.
-
-void
-dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-
-Does a partial sync, starting at offset and continuing for size.  You
-must be careful to observe the cache alignment and width when doing
-anything like this.  You must also be extra careful about accessing
-memory you intend to sync partially.
-
-void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-
-Do a partial sync of memory that was allocated by
-dma_alloc_noncoherent(), starting at virtual address vaddr and
-continuing on for size.  Again, you *must* observe the cache line
-boundaries when doing this.
-
-int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int
-			    flags)
-
-Declare region of memory to be handed out by dma_alloc_coherent when
-it's asked for coherent memory for this device.
-
-bus_addr is the physical address to which the memory is currently
-assigned in the bus responding region (this will be used by the
-platform to perform the mapping).
-
-device_addr is the physical address the device needs to be programmed
-with actually to address this memory (this will be handed out as the
-dma_addr_t in dma_alloc_coherent()).
-
-size is the size of the area (must be multiples of PAGE_SIZE).
-
-flags can be or'd together and are:
-
-DMA_MEMORY_MAP - request that the memory returned from
-dma_alloc_coherent() be directly writable.
-
-DMA_MEMORY_IO - request that the memory returned from
-dma_alloc_coherent() be addressable using read/write/memcpy_toio etc.
-
-One or both of these flags must be present.
-
-DMA_MEMORY_INCLUDES_CHILDREN - make the declared memory be allocated by
-dma_alloc_coherent of any child devices of this one (for memory residing
-on a bridge).
-
-DMA_MEMORY_EXCLUSIVE - only allocate memory from the declared regions. 
-Do not allow dma_alloc_coherent() to fall back to system memory when
-it's out of memory in the declared region.
-
-The return value will be either DMA_MEMORY_MAP or DMA_MEMORY_IO and
-must correspond to a passed in flag (i.e. no returning DMA_MEMORY_IO
-if only DMA_MEMORY_MAP were passed in) for success or zero for
-failure.
-
-Note, for DMA_MEMORY_IO returns, all subsequent memory returned by
-dma_alloc_coherent() may no longer be accessed directly, but instead
-must be accessed using the correct bus functions.  If your driver
-isn't prepared to handle this contingency, it should not specify
-DMA_MEMORY_IO in the input flags.
-
-As a simplification for the platforms, only *one* such region of
-memory may be declared per device.
-
-For reasons of efficiency, most platforms choose to track the declared
-region only at the granularity of a page.  For smaller allocations,
-you should use the dma_pool() API.
-
-void
-dma_release_declared_memory(struct device *dev)
-
-Remove the memory region previously declared from the system.  This
-API performs *no* in-use checking for this region and will return
-unconditionally having removed all the required structures.  It is the
-driver's job to ensure that no parts of this memory region are
-currently in use.
-
-void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size)
-
-This is used to occupy specific regions of the declared space
-(dma_alloc_coherent() will hand out the first free region it finds).
-
-device_addr is the *device* address of the region requested.
-
-size is the size (and should be a page-sized multiple).
-
-The return value will be either a pointer to the processor virtual
-address of the memory, or an error (via PTR_ERR()) if any part of the
-region is occupied.
diff --git a/Documentation/DMA-ISA-LPC.txt b/Documentation/DMA-ISA-LPC.txt
deleted file mode 100644
index e767805..0000000
--- a/Documentation/DMA-ISA-LPC.txt
+++ /dev/null
@@ -1,151 +0,0 @@
-                        DMA with ISA and LPC devices
-                        ============================
-
-                      Pierre Ossman <drzeus@drzeus.cx>
-
-This document describes how to do DMA transfers using the old ISA DMA
-controller. Even though ISA is more or less dead today the LPC bus
-uses the same DMA system so it will be around for quite some time.
-
-Part I - Headers and dependencies
----------------------------------
-
-To do ISA style DMA you need to include two headers:
-
-#include <linux/dma-mapping.h>
-#include <asm/dma.h>
-
-The first is the generic DMA API used to convert virtual addresses to
-physical addresses (see Documentation/DMA-API.txt for details).
-
-The second contains the routines specific to ISA DMA transfers. Since
-this is not present on all platforms make sure you construct your
-Kconfig to be dependent on ISA_DMA_API (not ISA) so that nobody tries
-to build your driver on unsupported platforms.
-
-Part II - Buffer allocation
----------------------------
-
-The ISA DMA controller has some very strict requirements on which
-memory it can access so extra care must be taken when allocating
-buffers.
-
-(You usually need a special buffer for DMA transfers instead of
-transferring directly to and from your normal data structures.)
-
-The DMA-able address space is the lowest 16 MB of _physical_ memory.
-Also the transfer block may not cross page boundaries (which are 64
-or 128 KiB depending on which channel you use).
-
-In order to allocate a piece of memory that satisfies all these
-requirements you pass the flag GFP_DMA to kmalloc.
-
-Unfortunately the memory available for ISA DMA is scarce so unless you
-allocate the memory during boot-up it's a good idea to also pass
-__GFP_REPEAT and __GFP_NOWARN to make the allocater try a bit harder.
-
-(This scarcity also means that you should allocate the buffer as
-early as possible and not release it until the driver is unloaded.)
-
-Part III - Address translation
-------------------------------
-
-To translate the virtual address to a physical use the normal DMA
-API. Do _not_ use isa_virt_to_phys() even though it does the same
-thing. The reason for this is that the function isa_virt_to_phys()
-will require a Kconfig dependency to ISA, not just ISA_DMA_API which
-is really all you need. Remember that even though the DMA controller
-has its origins in ISA it is used elsewhere.
-
-Note: x86_64 had a broken DMA API when it came to ISA but has since
-been fixed. If your arch has problems then fix the DMA API instead of
-reverting to the ISA functions.
-
-Part IV - Channels
-------------------
-
-A normal ISA DMA controller has 8 channels. The lower four are for
-8-bit transfers and the upper four are for 16-bit transfers.
-
-(Actually the DMA controller is really two separate controllers where
-channel 4 is used to give DMA access for the second controller (0-3).
-This means that of the four 16-bits channels only three are usable.)
-
-You allocate these in a similar fashion as all basic resources:
-
-extern int request_dma(unsigned int dmanr, const char * device_id);
-extern void free_dma(unsigned int dmanr);
-
-The ability to use 16-bit or 8-bit transfers is _not_ up to you as a
-driver author but depends on what the hardware supports. Check your
-specs or test different channels.
-
-Part V - Transfer data
-----------------------
-
-Now for the good stuff, the actual DMA transfer. :)
-
-Before you use any ISA DMA routines you need to claim the DMA lock
-using claim_dma_lock(). The reason is that some DMA operations are
-not atomic so only one driver may fiddle with the registers at a
-time.
-
-The first time you use the DMA controller you should call
-clear_dma_ff(). This clears an internal register in the DMA
-controller that is used for the non-atomic operations. As long as you
-(and everyone else) uses the locking functions then you only need to
-reset this once.
-
-Next, you tell the controller in which direction you intend to do the
-transfer using set_dma_mode(). Currently you have the options
-DMA_MODE_READ and DMA_MODE_WRITE.
-
-Set the address from where the transfer should start (this needs to
-be 16-bit aligned for 16-bit transfers) and how many bytes to
-transfer. Note that it's _bytes_. The DMA routines will do all the
-required translation to values that the DMA controller understands.
-
-The final step is enabling the DMA channel and releasing the DMA
-lock.
-
-Once the DMA transfer is finished (or timed out) you should disable
-the channel again. You should also check get_dma_residue() to make
-sure that all data has been transferred.
-
-Example:
-
-int flags, residue;
-
-flags = claim_dma_lock();
-
-clear_dma_ff();
-
-set_dma_mode(channel, DMA_MODE_WRITE);
-set_dma_addr(channel, phys_addr);
-set_dma_count(channel, num_bytes);
-
-dma_enable(channel);
-
-release_dma_lock(flags);
-
-while (!device_done());
-
-flags = claim_dma_lock();
-
-dma_disable(channel);
-
-residue = dma_get_residue(channel);
-if (residue != 0)
-	printk(KERN_ERR "driver: Incomplete DMA transfer!"
-		" %d bytes left!\n", residue);
-
-release_dma_lock(flags);
-
-Part VI - Suspend/resume
-------------------------
-
-It is the driver's responsibility to make sure that the machine isn't
-suspended while a DMA transfer is in progress. Also, all DMA settings
-are lost when the system suspends so if your driver relies on the DMA
-controller being in a certain state then you have to restore these
-registers upon resume.
diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
deleted file mode 100644
index 6d772f8..0000000
--- a/Documentation/DMA-attributes.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-			DMA attributes
-			==============
-
-This document describes the semantics of the DMA attributes that are
-defined in linux/dma-attrs.h.
-
-DMA_ATTR_WRITE_BARRIER
-----------------------
-
-DMA_ATTR_WRITE_BARRIER is a (write) barrier attribute for DMA.  DMA
-to a memory region with the DMA_ATTR_WRITE_BARRIER attribute forces
-all pending DMA writes to complete, and thus provides a mechanism to
-strictly order DMA from a device across all intervening busses and
-bridges.  This barrier is not specific to a particular type of
-interconnect, it applies to the system as a whole, and so its
-implementation must account for the idiosyncracies of the system all
-the way from the DMA device to memory.
-
-As an example of a situation where DMA_ATTR_WRITE_BARRIER would be
-useful, suppose that a device does a DMA write to indicate that data is
-ready and available in memory.  The DMA of the "completion indication"
-could race with data DMA.  Mapping the memory used for completion
-indications with DMA_ATTR_WRITE_BARRIER would prevent the race.
-
diff --git a/Documentation/DMA-mapping.txt b/Documentation/DMA-mapping.txt
deleted file mode 100644
index b463ecd..0000000
--- a/Documentation/DMA-mapping.txt
+++ /dev/null
@@ -1,766 +0,0 @@
-			Dynamic DMA mapping
-			===================
-
-		 David S. Miller <davem@redhat.com>
-		 Richard Henderson <rth@cygnus.com>
-		  Jakub Jelinek <jakub@redhat.com>
-
-This document describes the DMA mapping system in terms of the pci_
-API.  For a similar API that works for generic devices, see
-DMA-API.txt.
-
-Most of the 64bit platforms have special hardware that translates bus
-addresses (DMA addresses) into physical addresses.  This is similar to
-how page tables and/or a TLB translates virtual addresses to physical
-addresses on a CPU.  This is needed so that e.g. PCI devices can
-access with a Single Address Cycle (32bit DMA address) any page in the
-64bit physical address space.  Previously in Linux those 64bit
-platforms had to set artificial limits on the maximum RAM size in the
-system, so that the virt_to_bus() static scheme works (the DMA address
-translation tables were simply filled on bootup to map each bus
-address to the physical page __pa(bus_to_virt())).
-
-So that Linux can use the dynamic DMA mapping, it needs some help from the
-drivers, namely it has to take into account that DMA addresses should be
-mapped only for the time they are actually used and unmapped after the DMA
-transfer.
-
-The following API will work of course even on platforms where no such
-hardware exists, see e.g. include/asm-i386/pci.h for how it is implemented on
-top of the virt_to_bus interface.
-
-First of all, you should make sure
-
-#include <linux/pci.h>
-
-is in your driver. This file will obtain for you the definition of the
-dma_addr_t (which can hold any valid DMA address for the platform)
-type which should be used everywhere you hold a DMA (bus) address
-returned from the DMA mapping functions.
-
-			 What memory is DMA'able?
-
-The first piece of information you must know is what kernel memory can
-be used with the DMA mapping facilities.  There has been an unwritten
-set of rules regarding this, and this text is an attempt to finally
-write them down.
-
-If you acquired your memory via the page allocator
-(i.e. __get_free_page*()) or the generic memory allocators
-(i.e. kmalloc() or kmem_cache_alloc()) then you may DMA to/from
-that memory using the addresses returned from those routines.
-
-This means specifically that you may _not_ use the memory/addresses
-returned from vmalloc() for DMA.  It is possible to DMA to the
-_underlying_ memory mapped into a vmalloc() area, but this requires
-walking page tables to get the physical addresses, and then
-translating each of those pages back to a kernel address using
-something like __va().  [ EDIT: Update this when we integrate
-Gerd Knorr's generic code which does this. ]
-
-This rule also means that you may use neither kernel image addresses
-(items in data/text/bss segments), nor module image addresses, nor
-stack addresses for DMA.  These could all be mapped somewhere entirely
-different than the rest of physical memory.  Even if those classes of
-memory could physically work with DMA, you'd need to ensure the I/O
-buffers were cacheline-aligned.  Without that, you'd see cacheline
-sharing problems (data corruption) on CPUs with DMA-incoherent caches.
-(The CPU could write to one word, DMA would write to a different one
-in the same cache line, and one of them could be overwritten.)
-
-Also, this means that you cannot take the return of a kmap()
-call and DMA to/from that.  This is similar to vmalloc().
-
-What about block I/O and networking buffers?  The block I/O and
-networking subsystems make sure that the buffers they use are valid
-for you to DMA from/to.
-
-			DMA addressing limitations
-
-Does your device have any DMA addressing limitations?  For example, is
-your device only capable of driving the low order 24-bits of address
-on the PCI bus for SAC DMA transfers?  If so, you need to inform the
-PCI layer of this fact.
-
-By default, the kernel assumes that your device can address the full
-32-bits in a SAC cycle.  For a 64-bit DAC capable device, this needs
-to be increased.  And for a device with limitations, as discussed in
-the previous paragraph, it needs to be decreased.
-
-pci_alloc_consistent() by default will return 32-bit DMA addresses.
-PCI-X specification requires PCI-X devices to support 64-bit
-addressing (DAC) for all transactions. And at least one platform (SGI
-SN2) requires 64-bit consistent allocations to operate correctly when
-the IO bus is in PCI-X mode. Therefore, like with pci_set_dma_mask(),
-it's good practice to call pci_set_consistent_dma_mask() to set the
-appropriate mask even if your device only supports 32-bit DMA
-(default) and especially if it's a PCI-X device.
-
-For correct operation, you must interrogate the PCI layer in your
-device probe routine to see if the PCI controller on the machine can
-properly support the DMA addressing limitation your device has.  It is
-good style to do this even if your device holds the default setting,
-because this shows that you did think about these issues wrt. your
-device.
-
-The query is performed via a call to pci_set_dma_mask():
-
-	int pci_set_dma_mask(struct pci_dev *pdev, u64 device_mask);
-
-The query for consistent allocations is performed via a call to
-pci_set_consistent_dma_mask():
-
-	int pci_set_consistent_dma_mask(struct pci_dev *pdev, u64 device_mask);
-
-Here, pdev is a pointer to the PCI device struct of your device, and
-device_mask is a bit mask describing which bits of a PCI address your
-device supports.  It returns zero if your card can perform DMA
-properly on the machine given the address mask you provided.
-
-If it returns non-zero, your device cannot perform DMA properly on
-this platform, and attempting to do so will result in undefined
-behavior.  You must either use a different mask, or not use DMA.
-
-This means that in the failure case, you have three options:
-
-1) Use another DMA mask, if possible (see below).
-2) Use some non-DMA mode for data transfer, if possible.
-3) Ignore this device and do not initialize it.
-
-It is recommended that your driver print a kernel KERN_WARNING message
-when you end up performing either #2 or #3.  In this manner, if a user
-of your driver reports that performance is bad or that the device is not
-even detected, you can ask them for the kernel messages to find out
-exactly why.
-
-The standard 32-bit addressing PCI device would do something like
-this:
-
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
-		goto ignore_this_device;
-	}
-
-Another common scenario is a 64-bit capable device.  The approach
-here is to try for 64-bit DAC addressing, but back down to a
-32-bit mask should that fail.  The PCI platform code may fail the
-64-bit mask not because the platform is not capable of 64-bit
-addressing.  Rather, it may fail in this case simply because
-32-bit SAC addressing is done more efficiently than DAC addressing.
-Sparc64 is one platform which behaves in this way.
-
-Here is how you would handle a 64-bit capable device which can drive
-all 64-bits when accessing streaming DMA:
-
-	int using_dac;
-
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		using_dac = 1;
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
-		using_dac = 0;
-	} else {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
-		goto ignore_this_device;
-	}
-
-If a card is capable of using 64-bit consistent allocations as well,
-the case would look like this:
-
-	int using_dac, consistent_using_dac;
-
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		using_dac = 1;
-	   	consistent_using_dac = 1;
-		pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
-		using_dac = 0;
-		consistent_using_dac = 0;
-		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
-	} else {
-		printk(KERN_WARNING
-		       "mydev: No suitable DMA available.\n");
-		goto ignore_this_device;
-	}
-
-pci_set_consistent_dma_mask() will always be able to set the same or a
-smaller mask as pci_set_dma_mask(). However for the rare case that a
-device driver only uses consistent allocations, one would have to
-check the return value from pci_set_consistent_dma_mask().
-
-Finally, if your device can only drive the low 24-bits of
-address during PCI bus mastering you might do something like:
-
-	if (pci_set_dma_mask(pdev, DMA_24BIT_MASK)) {
-		printk(KERN_WARNING
-		       "mydev: 24-bit DMA addressing not available.\n");
-		goto ignore_this_device;
-	}
-
-When pci_set_dma_mask() is successful, and returns zero, the PCI layer
-saves away this mask you have provided.  The PCI layer will use this
-information later when you make DMA mappings.
-
-There is a case which we are aware of at this time, which is worth
-mentioning in this documentation.  If your device supports multiple
-functions (for example a sound card provides playback and record
-functions) and the various different functions have _different_
-DMA addressing limitations, you may wish to probe each mask and
-only provide the functionality which the machine can handle.  It
-is important that the last call to pci_set_dma_mask() be for the
-most specific mask.
-
-Here is pseudo-code showing how this might be done:
-
-	#define PLAYBACK_ADDRESS_BITS	DMA_32BIT_MASK
-	#define RECORD_ADDRESS_BITS	0x00ffffff
-
-	struct my_sound_card *card;
-	struct pci_dev *pdev;
-
-	...
-	if (!pci_set_dma_mask(pdev, PLAYBACK_ADDRESS_BITS)) {
-		card->playback_enabled = 1;
-	} else {
-		card->playback_enabled = 0;
-		printk(KERN_WARN "%s: Playback disabled due to DMA limitations.\n",
-		       card->name);
-	}
-	if (!pci_set_dma_mask(pdev, RECORD_ADDRESS_BITS)) {
-		card->record_enabled = 1;
-	} else {
-		card->record_enabled = 0;
-		printk(KERN_WARN "%s: Record disabled due to DMA limitations.\n",
-		       card->name);
-	}
-
-A sound card was used as an example here because this genre of PCI
-devices seems to be littered with ISA chips given a PCI front end,
-and thus retaining the 16MB DMA addressing limitations of ISA.
-
-			Types of DMA mappings
-
-There are two types of DMA mappings:
-
-- Consistent DMA mappings which are usually mapped at driver
-  initialization, unmapped at the end and for which the hardware should
-  guarantee that the device and the CPU can access the data
-  in parallel and will see updates made by each other without any
-  explicit software flushing.
-
-  Think of "consistent" as "synchronous" or "coherent".
-
-  The current default is to return consistent memory in the low 32
-  bits of the PCI bus space.  However, for future compatibility you
-  should set the consistent mask even if this default is fine for your
-  driver.
-
-  Good examples of what to use consistent mappings for are:
-
-	- Network card DMA ring descriptors.
-	- SCSI adapter mailbox command data structures.
-	- Device firmware microcode executed out of
-	  main memory.
-
-  The invariant these examples all require is that any CPU store
-  to memory is immediately visible to the device, and vice
-  versa.  Consistent mappings guarantee this.
-
-  IMPORTANT: Consistent DMA memory does not preclude the usage of
-             proper memory barriers.  The CPU may reorder stores to
-	     consistent memory just as it may normal memory.  Example:
-	     if it is important for the device to see the first word
-	     of a descriptor updated before the second, you must do
-	     something like:
-
-		desc->word0 = address;
-		wmb();
-		desc->word1 = DESC_VALID;
-
-             in order to get correct behavior on all platforms.
-
-	     Also, on some platforms your driver may need to flush CPU write
-	     buffers in much the same way as it needs to flush write buffers
-	     found in PCI bridges (such as by reading a register's value
-	     after writing it).
-
-- Streaming DMA mappings which are usually mapped for one DMA transfer,
-  unmapped right after it (unless you use pci_dma_sync_* below) and for which
-  hardware can optimize for sequential accesses.
-
-  This of "streaming" as "asynchronous" or "outside the coherency
-  domain".
-
-  Good examples of what to use streaming mappings for are:
-
-	- Networking buffers transmitted/received by a device.
-	- Filesystem buffers written/read by a SCSI device.
-
-  The interfaces for using this type of mapping were designed in
-  such a way that an implementation can make whatever performance
-  optimizations the hardware allows.  To this end, when using
-  such mappings you must be explicit about what you want to happen.
-
-Neither type of DMA mapping has alignment restrictions that come
-from PCI, although some devices may have such restrictions.
-Also, systems with caches that aren't DMA-coherent will work better
-when the underlying buffers don't share cache lines with other data.
-
-
-		 Using Consistent DMA mappings.
-
-To allocate and map large (PAGE_SIZE or so) consistent DMA regions,
-you should do:
-
-	dma_addr_t dma_handle;
-
-	cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
-
-where pdev is a struct pci_dev *. This may be called in interrupt context.
-You should use dma_alloc_coherent (see DMA-API.txt) for buses
-where devices don't have struct pci_dev (like ISA, EISA).
-
-This argument is needed because the DMA translations may be bus
-specific (and often is private to the bus which the device is attached
-to).
-
-Size is the length of the region you want to allocate, in bytes.
-
-This routine will allocate RAM for that region, so it acts similarly to
-__get_free_pages (but takes size instead of a page order).  If your
-driver needs regions sized smaller than a page, you may prefer using
-the pci_pool interface, described below.
-
-The consistent DMA mapping interfaces, for non-NULL pdev, will by
-default return a DMA address which is SAC (Single Address Cycle)
-addressable.  Even if the device indicates (via PCI dma mask) that it
-may address the upper 32-bits and thus perform DAC cycles, consistent
-allocation will only return > 32-bit PCI addresses for DMA if the
-consistent dma mask has been explicitly changed via
-pci_set_consistent_dma_mask().  This is true of the pci_pool interface
-as well.
-
-pci_alloc_consistent returns two values: the virtual address which you
-can use to access it from the CPU and dma_handle which you pass to the
-card.
-
-The cpu return address and the DMA bus master address are both
-guaranteed to be aligned to the smallest PAGE_SIZE order which
-is greater than or equal to the requested size.  This invariant
-exists (for example) to guarantee that if you allocate a chunk
-which is smaller than or equal to 64 kilobytes, the extent of the
-buffer you receive will not cross a 64K boundary.
-
-To unmap and free such a DMA region, you call:
-
-	pci_free_consistent(pdev, size, cpu_addr, dma_handle);
-
-where pdev, size are the same as in the above call and cpu_addr and
-dma_handle are the values pci_alloc_consistent returned to you.
-This function may not be called in interrupt context.
-
-If your driver needs lots of smaller memory regions, you can write
-custom code to subdivide pages returned by pci_alloc_consistent,
-or you can use the pci_pool API to do that.  A pci_pool is like
-a kmem_cache, but it uses pci_alloc_consistent not __get_free_pages.
-Also, it understands common hardware constraints for alignment,
-like queue heads needing to be aligned on N byte boundaries.
-
-Create a pci_pool like this:
-
-	struct pci_pool *pool;
-
-	pool = pci_pool_create(name, pdev, size, align, alloc);
-
-The "name" is for diagnostics (like a kmem_cache name); pdev and size
-are as above.  The device's hardware alignment requirement for this
-type of data is "align" (which is expressed in bytes, and must be a
-power of two).  If your device has no boundary crossing restrictions,
-pass 0 for alloc; passing 4096 says memory allocated from this pool
-must not cross 4KByte boundaries (but at that time it may be better to
-go for pci_alloc_consistent directly instead).
-
-Allocate memory from a pci pool like this:
-
-	cpu_addr = pci_pool_alloc(pool, flags, &dma_handle);
-
-flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
-holding SMP locks), SLAB_ATOMIC otherwise.  Like pci_alloc_consistent,
-this returns two values, cpu_addr and dma_handle.
-
-Free memory that was allocated from a pci_pool like this:
-
-	pci_pool_free(pool, cpu_addr, dma_handle);
-
-where pool is what you passed to pci_pool_alloc, and cpu_addr and
-dma_handle are the values pci_pool_alloc returned. This function
-may be called in interrupt context.
-
-Destroy a pci_pool by calling:
-
-	pci_pool_destroy(pool);
-
-Make sure you've called pci_pool_free for all memory allocated
-from a pool before you destroy the pool. This function may not
-be called in interrupt context.
-
-			DMA Direction
-
-The interfaces described in subsequent portions of this document
-take a DMA direction argument, which is an integer and takes on
-one of the following values:
-
- PCI_DMA_BIDIRECTIONAL
- PCI_DMA_TODEVICE
- PCI_DMA_FROMDEVICE
- PCI_DMA_NONE
-
-One should provide the exact DMA direction if you know it.
-
-PCI_DMA_TODEVICE means "from main memory to the PCI device"
-PCI_DMA_FROMDEVICE means "from the PCI device to main memory"
-It is the direction in which the data moves during the DMA
-transfer.
-
-You are _strongly_ encouraged to specify this as precisely
-as you possibly can.
-
-If you absolutely cannot know the direction of the DMA transfer,
-specify PCI_DMA_BIDIRECTIONAL.  It means that the DMA can go in
-either direction.  The platform guarantees that you may legally
-specify this, and that it will work, but this may be at the
-cost of performance for example.
-
-The value PCI_DMA_NONE is to be used for debugging.  One can
-hold this in a data structure before you come to know the
-precise direction, and this will help catch cases where your
-direction tracking logic has failed to set things up properly.
-
-Another advantage of specifying this value precisely (outside of
-potential platform-specific optimizations of such) is for debugging.
-Some platforms actually have a write permission boolean which DMA
-mappings can be marked with, much like page protections in the user
-program address space.  Such platforms can and do report errors in the
-kernel logs when the PCI controller hardware detects violation of the
-permission setting.
-
-Only streaming mappings specify a direction, consistent mappings
-implicitly have a direction attribute setting of
-PCI_DMA_BIDIRECTIONAL.
-
-The SCSI subsystem tells you the direction to use in the
-'sc_data_direction' member of the SCSI command your driver is
-working on.
-
-For Networking drivers, it's a rather simple affair.  For transmit
-packets, map/unmap them with the PCI_DMA_TODEVICE direction
-specifier.  For receive packets, just the opposite, map/unmap them
-with the PCI_DMA_FROMDEVICE direction specifier.
-
-		  Using Streaming DMA mappings
-
-The streaming DMA mapping routines can be called from interrupt
-context.  There are two versions of each map/unmap, one which will
-map/unmap a single memory region, and one which will map/unmap a
-scatterlist.
-
-To map a single region, you do:
-
-	struct pci_dev *pdev = mydev->pdev;
-	dma_addr_t dma_handle;
-	void *addr = buffer->ptr;
-	size_t size = buffer->len;
-
-	dma_handle = pci_map_single(pdev, addr, size, direction);
-
-and to unmap it:
-
-	pci_unmap_single(pdev, dma_handle, size, direction);
-
-You should call pci_unmap_single when the DMA activity is finished, e.g.
-from the interrupt which told you that the DMA transfer is done.
-
-Using cpu pointers like this for single mappings has a disadvantage,
-you cannot reference HIGHMEM memory in this way.  Thus, there is a
-map/unmap interface pair akin to pci_{map,unmap}_single.  These
-interfaces deal with page/offset pairs instead of cpu pointers.
-Specifically:
-
-	struct pci_dev *pdev = mydev->pdev;
-	dma_addr_t dma_handle;
-	struct page *page = buffer->page;
-	unsigned long offset = buffer->offset;
-	size_t size = buffer->len;
-
-	dma_handle = pci_map_page(pdev, page, offset, size, direction);
-
-	...
-
-	pci_unmap_page(pdev, dma_handle, size, direction);
-
-Here, "offset" means byte offset within the given page.
-
-With scatterlists, you map a region gathered from several regions by:
-
-	int i, count = pci_map_sg(pdev, sglist, nents, direction);
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, count, i) {
-		hw_address[i] = sg_dma_address(sg);
-		hw_len[i] = sg_dma_len(sg);
-	}
-
-where nents is the number of entries in the sglist.
-
-The implementation is free to merge several consecutive sglist entries
-into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
-consecutive sglist entries can be merged into one provided the first one
-ends and the second one starts on a page boundary - in fact this is a huge
-advantage for cards which either cannot do scatter-gather or have very
-limited number of scatter-gather entries) and returns the actual number
-of sg entries it mapped them to. On failure 0 is returned.
-
-Then you should loop count times (note: this can be less than nents times)
-and use sg_dma_address() and sg_dma_len() macros where you previously
-accessed sg->address and sg->length as shown above.
-
-To unmap a scatterlist, just call:
-
-	pci_unmap_sg(pdev, sglist, nents, direction);
-
-Again, make sure DMA activity has already finished.
-
-PLEASE NOTE:  The 'nents' argument to the pci_unmap_sg call must be
-              the _same_ one you passed into the pci_map_sg call,
-	      it should _NOT_ be the 'count' value _returned_ from the
-              pci_map_sg call.
-
-Every pci_map_{single,sg} call should have its pci_unmap_{single,sg}
-counterpart, because the bus address space is a shared resource (although
-in some ports the mapping is per each BUS so less devices contend for the
-same bus address space) and you could render the machine unusable by eating
-all bus addresses.
-
-If you need to use the same streaming DMA region multiple times and touch
-the data in between the DMA transfers, the buffer needs to be synced
-properly in order for the cpu and device to see the most uptodate and
-correct copy of the DMA buffer.
-
-So, firstly, just map it with pci_map_{single,sg}, and after each DMA
-transfer call either:
-
-	pci_dma_sync_single_for_cpu(pdev, dma_handle, size, direction);
-
-or:
-
-	pci_dma_sync_sg_for_cpu(pdev, sglist, nents, direction);
-
-as appropriate.
-
-Then, if you wish to let the device get at the DMA area again,
-finish accessing the data with the cpu, and then before actually
-giving the buffer to the hardware call either:
-
-	pci_dma_sync_single_for_device(pdev, dma_handle, size, direction);
-
-or:
-
-	pci_dma_sync_sg_for_device(dev, sglist, nents, direction);
-
-as appropriate.
-
-After the last DMA transfer call one of the DMA unmap routines
-pci_unmap_{single,sg}. If you don't touch the data from the first pci_map_*
-call till pci_unmap_*, then you don't have to call the pci_dma_sync_*
-routines at all.
-
-Here is pseudo code which shows a situation in which you would need
-to use the pci_dma_sync_*() interfaces.
-
-	my_card_setup_receive_buffer(struct my_card *cp, char *buffer, int len)
-	{
-		dma_addr_t mapping;
-
-		mapping = pci_map_single(cp->pdev, buffer, len, PCI_DMA_FROMDEVICE);
-
-		cp->rx_buf = buffer;
-		cp->rx_len = len;
-		cp->rx_dma = mapping;
-
-		give_rx_buf_to_card(cp);
-	}
-
-	...
-
-	my_card_interrupt_handler(int irq, void *devid, struct pt_regs *regs)
-	{
-		struct my_card *cp = devid;
-
-		...
-		if (read_card_status(cp) == RX_BUF_TRANSFERRED) {
-			struct my_card_header *hp;
-
-			/* Examine the header to see if we wish
-			 * to accept the data.  But synchronize
-			 * the DMA transfer with the CPU first
-			 * so that we see updated contents.
-			 */
-			pci_dma_sync_single_for_cpu(cp->pdev, cp->rx_dma,
-						    cp->rx_len,
-						    PCI_DMA_FROMDEVICE);
-
-			/* Now it is safe to examine the buffer. */
-			hp = (struct my_card_header *) cp->rx_buf;
-			if (header_is_ok(hp)) {
-				pci_unmap_single(cp->pdev, cp->rx_dma, cp->rx_len,
-						 PCI_DMA_FROMDEVICE);
-				pass_to_upper_layers(cp->rx_buf);
-				make_and_setup_new_rx_buf(cp);
-			} else {
-				/* Just sync the buffer and give it back
-				 * to the card.
-				 */
-				pci_dma_sync_single_for_device(cp->pdev,
-							       cp->rx_dma,
-							       cp->rx_len,
-							       PCI_DMA_FROMDEVICE);
-				give_rx_buf_to_card(cp);
-			}
-		}
-	}
-
-Drivers converted fully to this interface should not use virt_to_bus any
-longer, nor should they use bus_to_virt. Some drivers have to be changed a
-little bit, because there is no longer an equivalent to bus_to_virt in the
-dynamic DMA mapping scheme - you have to always store the DMA addresses
-returned by the pci_alloc_consistent, pci_pool_alloc, and pci_map_single
-calls (pci_map_sg stores them in the scatterlist itself if the platform
-supports dynamic DMA mapping in hardware) in your driver structures and/or
-in the card registers.
-
-All PCI drivers should be using these interfaces with no exceptions.
-It is planned to completely remove virt_to_bus() and bus_to_virt() as
-they are entirely deprecated.  Some ports already do not provide these
-as it is impossible to correctly support them.
-
-		Optimizing Unmap State Space Consumption
-
-On many platforms, pci_unmap_{single,page}() is simply a nop.
-Therefore, keeping track of the mapping address and length is a waste
-of space.  Instead of filling your drivers up with ifdefs and the like
-to "work around" this (which would defeat the whole purpose of a
-portable API) the following facilities are provided.
-
-Actually, instead of describing the macros one by one, we'll
-transform some example code.
-
-1) Use DECLARE_PCI_UNMAP_{ADDR,LEN} in state saving structures.
-   Example, before:
-
-	struct ring_state {
-		struct sk_buff *skb;
-		dma_addr_t mapping;
-		__u32 len;
-	};
-
-   after:
-
-	struct ring_state {
-		struct sk_buff *skb;
-		DECLARE_PCI_UNMAP_ADDR(mapping)
-		DECLARE_PCI_UNMAP_LEN(len)
-	};
-
-   NOTE: DO NOT put a semicolon at the end of the DECLARE_*()
-         macro.
-
-2) Use pci_unmap_{addr,len}_set to set these values.
-   Example, before:
-
-	ringp->mapping = FOO;
-	ringp->len = BAR;
-
-   after:
-
-	pci_unmap_addr_set(ringp, mapping, FOO);
-	pci_unmap_len_set(ringp, len, BAR);
-
-3) Use pci_unmap_{addr,len} to access these values.
-   Example, before:
-
-	pci_unmap_single(pdev, ringp->mapping, ringp->len,
-			 PCI_DMA_FROMDEVICE);
-
-   after:
-
-	pci_unmap_single(pdev,
-			 pci_unmap_addr(ringp, mapping),
-			 pci_unmap_len(ringp, len),
-			 PCI_DMA_FROMDEVICE);
-
-It really should be self-explanatory.  We treat the ADDR and LEN
-separately, because it is possible for an implementation to only
-need the address in order to perform the unmap operation.
-
-			Platform Issues
-
-If you are just writing drivers for Linux and do not maintain
-an architecture port for the kernel, you can safely skip down
-to "Closing".
-
-1) Struct scatterlist requirements.
-
-   Struct scatterlist must contain, at a minimum, the following
-   members:
-
-	struct page *page;
-	unsigned int offset;
-	unsigned int length;
-
-   The base address is specified by a "page+offset" pair.
-
-   Previous versions of struct scatterlist contained a "void *address"
-   field that was sometimes used instead of page+offset.  As of Linux
-   2.5., page+offset is always used, and the "address" field has been
-   deleted.
-
-2) More to come...
-
-			Handling Errors
-
-DMA address space is limited on some architectures and an allocation
-failure can be determined by:
-
-- checking if pci_alloc_consistent returns NULL or pci_map_sg returns 0
-
-- checking the returned dma_addr_t of pci_map_single and pci_map_page
-  by using pci_dma_mapping_error():
-
-	dma_addr_t dma_handle;
-
-	dma_handle = pci_map_single(pdev, addr, size, direction);
-	if (pci_dma_mapping_error(dma_handle)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-	}
-
-			   Closing
-
-This document, and the API itself, would not be in it's current
-form without the feedback and suggestions from numerous individuals.
-We would like to specifically mention, in no particular order, the
-following people:
-
-	Russell King <rmk@arm.linux.org.uk>
-	Leo Dagum <dagum@barrel.engr.sgi.com>
-	Ralf Baechle <ralf@oss.sgi.com>
-	Grant Grundler <grundler@cup.hp.com>
-	Jay Estabrook <Jay.Estabrook@compaq.com>
-	Thomas Sailer <sailer@ife.ee.ethz.ch>
-	Andrea Arcangeli <andrea@suse.de>
-	Jens Axboe <jens.axboe@oracle.com>
-	David Mosberger-Tang <davidm@hpl.hp.com>
diff --git a/Documentation/DMA/00-INDEX b/Documentation/DMA/00-INDEX
new file mode 100644
index 0000000..67d99a6
--- /dev/null
+++ b/Documentation/DMA/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file.
+DMA-API.txt
+	- DMA API, pci_ API & extensions for non-consistent memory machines.
+DMA-ISA-LPC.txt
+	- How to do DMA with ISA (and LPC) devices.
+DMA-attributes.txt
+	- Semantics of DMA attributes defined in linux/dma-attrs.h
+DMA-mapping.txt
+	- the DMA mapping system described in terms of the pci_ API
diff --git a/Documentation/DMA/DMA-API.txt b/Documentation/DMA/DMA-API.txt
new file mode 100644
index 0000000..80d1504
--- /dev/null
+++ b/Documentation/DMA/DMA-API.txt
@@ -0,0 +1,614 @@
+               Dynamic DMA mapping using the generic device
+               ============================================
+
+        James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
+
+This document describes the DMA API.  For a more gentle introduction
+phrased in terms of the pci_ equivalents (and actual examples) see
+DMA-mapping.txt
+
+This API is split into two pieces.  Part I describes the API and the
+corresponding pci_ API.  Part II describes the extensions to the API
+for supporting non-consistent memory machines.  Unless you know that
+your driver absolutely has to support non-consistent platforms (this
+is usually only legacy platforms) you should only use the API
+described in part I.
+
+Part I - pci_ and dma_ Equivalent API 
+-------------------------------------
+
+To get the pci_ API, you must #include <linux/pci.h>
+To get the dma_ API, you must #include <linux/dma-mapping.h>
+
+
+Part Ia - Using large dma-coherent buffers
+------------------------------------------
+
+void *
+dma_alloc_coherent(struct device *dev, size_t size,
+			     dma_addr_t *dma_handle, gfp_t flag)
+void *
+pci_alloc_consistent(struct pci_dev *dev, size_t size,
+			     dma_addr_t *dma_handle)
+
+Consistent memory is memory for which a write by either the device or
+the processor can immediately be read by the processor or device
+without having to worry about caching effects.  (You may however need
+to make sure to flush the processor's write buffers before telling
+devices to read that memory.)
+
+This routine allocates a region of <size> bytes of consistent memory.
+It also returns a <dma_handle> which may be cast to an unsigned
+integer the same width as the bus and used as the physical address
+base of the region.
+
+Returns: a pointer to the allocated region (in the processor's virtual
+address space) or NULL if the allocation failed.
+
+Note: consistent memory can be expensive on some platforms, and the
+minimum allocation length may be as big as a page, so you should
+consolidate your requests for consistent memory as much as possible.
+The simplest way to do that is to use the dma_pool calls (see below).
+
+The flag parameter (dma_alloc_coherent only) allows the caller to
+specify the GFP_ flags (see kmalloc) for the allocation (the
+implementation may choose to ignore flags that affect the location of
+the returned memory, like GFP_DMA).  For pci_alloc_consistent, you
+must assume GFP_ATOMIC behaviour.
+
+void
+dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
+			   dma_addr_t dma_handle)
+void
+pci_free_consistent(struct pci_dev *dev, size_t size, void *cpu_addr,
+			   dma_addr_t dma_handle)
+
+Free the region of consistent memory you previously allocated.  dev,
+size and dma_handle must all be the same as those passed into the
+consistent allocate.  cpu_addr must be the virtual address returned by
+the consistent allocate.
+
+Note that unlike their sibling allocation calls, these routines
+may only be called with IRQs enabled.
+
+
+Part Ib - Using small dma-coherent buffers
+------------------------------------------
+
+To get this part of the dma_ API, you must #include <linux/dmapool.h>
+
+Many drivers need lots of small dma-coherent memory regions for DMA
+descriptors or I/O buffers.  Rather than allocating in units of a page
+or more using dma_alloc_coherent(), you can use DMA pools.  These work
+much like a struct kmem_cache, except that they use the dma-coherent allocator,
+not __get_free_pages().  Also, they understand common hardware constraints
+for alignment, like queue heads needing to be aligned on N-byte boundaries.
+
+
+	struct dma_pool *
+	dma_pool_create(const char *name, struct device *dev,
+			size_t size, size_t align, size_t alloc);
+
+	struct pci_pool *
+	pci_pool_create(const char *name, struct pci_device *dev,
+			size_t size, size_t align, size_t alloc);
+
+The pool create() routines initialize a pool of dma-coherent buffers
+for use with a given device.  It must be called in a context which
+can sleep.
+
+The "name" is for diagnostics (like a struct kmem_cache name); dev and size
+are like what you'd pass to dma_alloc_coherent().  The device's hardware
+alignment requirement for this type of data is "align" (which is expressed
+in bytes, and must be a power of two).  If your device has no boundary
+crossing restrictions, pass 0 for alloc; passing 4096 says memory allocated
+from this pool must not cross 4KByte boundaries.
+
+
+	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
+			dma_addr_t *dma_handle);
+
+	void *pci_pool_alloc(struct pci_pool *pool, gfp_t gfp_flags,
+			dma_addr_t *dma_handle);
+
+This allocates memory from the pool; the returned memory will meet the size
+and alignment requirements specified at creation time.  Pass GFP_ATOMIC to
+prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks),
+pass GFP_KERNEL to allow blocking.  Like dma_alloc_coherent(), this returns
+two values:  an address usable by the cpu, and the dma address usable by the
+pool's device.
+
+
+	void dma_pool_free(struct dma_pool *pool, void *vaddr,
+			dma_addr_t addr);
+
+	void pci_pool_free(struct pci_pool *pool, void *vaddr,
+			dma_addr_t addr);
+
+This puts memory back into the pool.  The pool is what was passed to
+the pool allocation routine; the cpu (vaddr) and dma addresses are what
+were returned when that routine allocated the memory being freed.
+
+
+	void dma_pool_destroy(struct dma_pool *pool);
+
+	void pci_pool_destroy(struct pci_pool *pool);
+
+The pool destroy() routines free the resources of the pool.  They must be
+called in a context which can sleep.  Make sure you've freed all allocated
+memory back to the pool before you destroy it.
+
+
+Part Ic - DMA addressing limitations
+------------------------------------
+
+int
+dma_supported(struct device *dev, u64 mask)
+int
+pci_dma_supported(struct pci_dev *hwdev, u64 mask)
+
+Checks to see if the device can support DMA to the memory described by
+mask.
+
+Returns: 1 if it can and 0 if it can't.
+
+Notes: This routine merely tests to see if the mask is possible.  It
+won't change the current mask settings.  It is more intended as an
+internal API for use by the platform than an external API for use by
+driver writers.
+
+int
+dma_set_mask(struct device *dev, u64 mask)
+int
+pci_set_dma_mask(struct pci_device *dev, u64 mask)
+
+Checks to see if the mask is possible and updates the device
+parameters if it is.
+
+Returns: 0 if successful and a negative error if not.
+
+u64
+dma_get_required_mask(struct device *dev)
+
+After setting the mask with dma_set_mask(), this API returns the
+actual mask (within that already set) that the platform actually
+requires to operate efficiently.  Usually this means the returned mask
+is the minimum required to cover all of memory.  Examining the
+required mask gives drivers with variable descriptor sizes the
+opportunity to use smaller descriptors as necessary.
+
+Requesting the required mask does not alter the current mask.  If you
+wish to take advantage of it, you should issue another dma_set_mask()
+call to lower the mask again.
+
+
+Part Id - Streaming DMA mappings
+--------------------------------
+
+dma_addr_t
+dma_map_single(struct device *dev, void *cpu_addr, size_t size,
+		      enum dma_data_direction direction)
+dma_addr_t
+pci_map_single(struct pci_dev *hwdev, void *cpu_addr, size_t size,
+		      int direction)
+
+Maps a piece of processor virtual memory so it can be accessed by the
+device and returns the physical handle of the memory.
+
+The direction for both api's may be converted freely by casting.
+However the dma_ API uses a strongly typed enumerator for its
+direction:
+
+DMA_NONE		= PCI_DMA_NONE		no direction (used for
+						debugging)
+DMA_TO_DEVICE		= PCI_DMA_TODEVICE	data is going from the
+						memory to the device
+DMA_FROM_DEVICE		= PCI_DMA_FROMDEVICE	data is coming from
+						the device to the
+						memory
+DMA_BIDIRECTIONAL	= PCI_DMA_BIDIRECTIONAL	direction isn't known
+
+Notes:  Not all memory regions in a machine can be mapped by this
+API.  Further, regions that appear to be physically contiguous in
+kernel virtual space may not be contiguous as physical memory.  Since
+this API does not provide any scatter/gather capability, it will fail
+if the user tries to map a non-physically contiguous piece of memory.
+For this reason, it is recommended that memory mapped by this API be
+obtained only from sources which guarantee it to be physically contiguous
+(like kmalloc).
+
+Further, the physical address of the memory must be within the
+dma_mask of the device (the dma_mask represents a bit mask of the
+addressable region for the device.  I.e., if the physical address of
+the memory anded with the dma_mask is still equal to the physical
+address, then the device can perform DMA to the memory).  In order to
+ensure that the memory allocated by kmalloc is within the dma_mask,
+the driver may specify various platform-dependent flags to restrict
+the physical memory range of the allocation (e.g. on x86, GFP_DMA
+guarantees to be within the first 16Mb of available physical memory,
+as required by ISA devices).
+
+Note also that the above constraints on physical contiguity and
+dma_mask may not apply if the platform has an IOMMU (a device which
+supplies a physical to virtual mapping between the I/O memory bus and
+the device).  However, to be portable, device driver writers may *not*
+assume that such an IOMMU exists.
+
+Warnings:  Memory coherency operates at a granularity called the cache
+line width.  In order for memory mapped by this API to operate
+correctly, the mapped region must begin exactly on a cache line
+boundary and end exactly on one (to prevent two separately mapped
+regions from sharing a single cache line).  Since the cache line size
+may not be known at compile time, the API will not enforce this
+requirement.  Therefore, it is recommended that driver writers who
+don't take special care to determine the cache line size at run time
+only map virtual regions that begin and end on page boundaries (which
+are guaranteed also to be cache line boundaries).
+
+DMA_TO_DEVICE synchronisation must be done after the last modification
+of the memory region by the software and before it is handed off to
+the driver.  Once this primitive is used, memory covered by this
+primitive should be treated as read-only by the device.  If the device
+may write to it at any point, it should be DMA_BIDIRECTIONAL (see
+below).
+
+DMA_FROM_DEVICE synchronisation must be done before the driver
+accesses data that may be changed by the device.  This memory should
+be treated as read-only by the driver.  If the driver needs to write
+to it at any point, it should be DMA_BIDIRECTIONAL (see below).
+
+DMA_BIDIRECTIONAL requires special handling: it means that the driver
+isn't sure if the memory was modified before being handed off to the
+device and also isn't sure if the device will also modify it.  Thus,
+you must always sync bidirectional memory twice: once before the
+memory is handed off to the device (to make sure all memory changes
+are flushed from the processor) and once before the data may be
+accessed after being used by the device (to make sure any processor
+cache lines are updated with data that the device may have changed).
+
+void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction)
+void
+pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
+		 size_t size, int direction)
+
+Unmaps the region previously mapped.  All the parameters passed in
+must be identical to those passed in (and returned) by the mapping
+API.
+
+dma_addr_t
+dma_map_page(struct device *dev, struct page *page,
+		    unsigned long offset, size_t size,
+		    enum dma_data_direction direction)
+dma_addr_t
+pci_map_page(struct pci_dev *hwdev, struct page *page,
+		    unsigned long offset, size_t size, int direction)
+void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction)
+void
+pci_unmap_page(struct pci_dev *hwdev, dma_addr_t dma_address,
+	       size_t size, int direction)
+
+API for mapping and unmapping for pages.  All the notes and warnings
+for the other mapping APIs apply here.  Also, although the <offset>
+and <size> parameters are provided to do partial page mapping, it is
+recommended that you never use these unless you really know what the
+cache width is.
+
+int
+dma_mapping_error(dma_addr_t dma_addr)
+
+int
+pci_dma_mapping_error(dma_addr_t dma_addr)
+
+In some circumstances dma_map_single and dma_map_page will fail to create
+a mapping. A driver can check for these errors by testing the returned
+dma address with dma_mapping_error(). A non-zero return value means the mapping
+could not be created and the driver should take appropriate action (e.g.
+reduce current DMA mapping usage or delay and try again later).
+
+	int
+	dma_map_sg(struct device *dev, struct scatterlist *sg,
+		int nents, enum dma_data_direction direction)
+	int
+	pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
+		int nents, int direction)
+
+Maps a scatter gather list from the block layer.
+
+Returns: the number of physical segments mapped (this may be shorter
+than <nents> passed in if the block layer determines that some
+elements of the scatter/gather list are physically adjacent and thus
+may be mapped with a single entry).
+
+Please note that the sg cannot be mapped again if it has been mapped once.
+The mapping process is allowed to destroy information in the sg.
+
+As with the other mapping interfaces, dma_map_sg can fail. When it
+does, 0 is returned and a driver must take appropriate action. It is
+critical that the driver do something, in the case of a block driver
+aborting the request or even oopsing is better than doing nothing and
+corrupting the filesystem.
+
+With scatterlists, you use the resulting mapping like this:
+
+	int i, count = dma_map_sg(dev, sglist, nents, direction);
+	struct scatterlist *sg;
+
+	for (i = 0, sg = sglist; i < count; i++, sg++) {
+		hw_address[i] = sg_dma_address(sg);
+		hw_len[i] = sg_dma_len(sg);
+	}
+
+where nents is the number of entries in the sglist.
+
+The implementation is free to merge several consecutive sglist entries
+into one (e.g. with an IOMMU, or if several pages just happen to be
+physically contiguous) and returns the actual number of sg entries it
+mapped them to. On failure 0, is returned.
+
+Then you should loop count times (note: this can be less than nents times)
+and use sg_dma_address() and sg_dma_len() macros where you previously
+accessed sg->address and sg->length as shown above.
+
+	void
+	dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+		int nhwentries, enum dma_data_direction direction)
+	void
+	pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg,
+		int nents, int direction)
+
+Unmap the previously mapped scatter/gather list.  All the parameters
+must be the same as those and passed in to the scatter/gather mapping
+API.
+
+Note: <nents> must be the number you passed in, *not* the number of
+physical entries returned.
+
+void
+dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
+		enum dma_data_direction direction)
+void
+pci_dma_sync_single(struct pci_dev *hwdev, dma_addr_t dma_handle,
+			   size_t size, int direction)
+void
+dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
+			  enum dma_data_direction direction)
+void
+pci_dma_sync_sg(struct pci_dev *hwdev, struct scatterlist *sg,
+		       int nelems, int direction)
+
+Synchronise a single contiguous or scatter/gather mapping.  All the
+parameters must be the same as those passed into the single mapping
+API.
+
+Notes:  You must do this:
+
+- Before reading values that have been written by DMA from the device
+  (use the DMA_FROM_DEVICE direction)
+- After writing values that will be written to the device using DMA
+  (use the DMA_TO_DEVICE) direction
+- before *and* after handing memory to the device if the memory is
+  DMA_BIDIRECTIONAL
+
+See also dma_map_single().
+
+dma_addr_t
+dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
+		     enum dma_data_direction dir,
+		     struct dma_attrs *attrs)
+
+void
+dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
+		       size_t size, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
+
+int
+dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
+		 int nents, enum dma_data_direction dir,
+		 struct dma_attrs *attrs)
+
+void
+dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
+		   int nents, enum dma_data_direction dir,
+		   struct dma_attrs *attrs)
+
+The four functions above are just like the counterpart functions
+without the _attrs suffixes, except that they pass an optional
+struct dma_attrs*.
+
+struct dma_attrs encapsulates a set of "dma attributes". For the
+definition of struct dma_attrs see linux/dma-attrs.h.
+
+The interpretation of dma attributes is architecture-specific, and
+each attribute should be documented in Documentation/DMA-attributes.txt.
+
+If struct dma_attrs* is NULL, the semantics of each of these
+functions is identical to those of the corresponding function
+without the _attrs suffix. As a result dma_map_single_attrs()
+can generally replace dma_map_single(), etc.
+
+As an example of the use of the *_attrs functions, here's how
+you could pass an attribute DMA_ATTR_FOO when mapping memory
+for DMA:
+
+#include <linux/dma-attrs.h>
+/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
+ * documented in Documentation/DMA-attributes.txt */
+...
+
+	DEFINE_DMA_ATTRS(attrs);
+	dma_set_attr(DMA_ATTR_FOO, &attrs);
+	....
+	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
+	....
+
+Architectures that care about DMA_ATTR_FOO would check for its
+presence in their implementations of the mapping and unmapping
+routines, e.g.:
+
+void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
+			     size_t size, enum dma_data_direction dir,
+			     struct dma_attrs *attrs)
+{
+	....
+	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
+	....
+	if (foo)
+		/* twizzle the frobnozzle */
+	....
+
+
+Part II - Advanced dma_ usage
+-----------------------------
+
+Warning: These pieces of the DMA API have no PCI equivalent.  They
+should also not be used in the majority of cases, since they cater for
+unlikely corner cases that don't belong in usual drivers.
+
+If you don't understand how cache line coherency works between a
+processor and an I/O device, you should not be using this part of the
+API at all.
+
+void *
+dma_alloc_noncoherent(struct device *dev, size_t size,
+			       dma_addr_t *dma_handle, gfp_t flag)
+
+Identical to dma_alloc_coherent() except that the platform will
+choose to return either consistent or non-consistent memory as it sees
+fit.  By using this API, you are guaranteeing to the platform that you
+have all the correct and necessary sync points for this memory in the
+driver should it choose to return non-consistent memory.
+
+Note: where the platform can return consistent memory, it will
+guarantee that the sync points become nops.
+
+Warning:  Handling non-consistent memory is a real pain.  You should
+only ever use this API if you positively know your driver will be
+required to work on one of the rare (usually non-PCI) architectures
+that simply cannot make consistent memory.
+
+void
+dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
+			      dma_addr_t dma_handle)
+
+Free memory allocated by the nonconsistent API.  All parameters must
+be identical to those passed in (and returned by
+dma_alloc_noncoherent()).
+
+int
+dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
+
+Returns true if the device dev is performing consistent DMA on the memory
+area pointed to by the dma_handle.
+
+int
+dma_get_cache_alignment(void)
+
+Returns the processor cache alignment.  This is the absolute minimum
+alignment *and* width that you must observe when either mapping
+memory or doing partial flushes.
+
+Notes: This API may return a number *larger* than the actual cache
+line, but it will guarantee that one or more cache lines fit exactly
+into the width returned by this call.  It will also always be a power
+of two for easy alignment.
+
+void
+dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
+		      unsigned long offset, size_t size,
+		      enum dma_data_direction direction)
+
+Does a partial sync, starting at offset and continuing for size.  You
+must be careful to observe the cache alignment and width when doing
+anything like this.  You must also be extra careful about accessing
+memory you intend to sync partially.
+
+void
+dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+	       enum dma_data_direction direction)
+
+Do a partial sync of memory that was allocated by
+dma_alloc_noncoherent(), starting at virtual address vaddr and
+continuing on for size.  Again, you *must* observe the cache line
+boundaries when doing this.
+
+int
+dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+			    dma_addr_t device_addr, size_t size, int
+			    flags)
+
+Declare region of memory to be handed out by dma_alloc_coherent when
+it's asked for coherent memory for this device.
+
+bus_addr is the physical address to which the memory is currently
+assigned in the bus responding region (this will be used by the
+platform to perform the mapping).
+
+device_addr is the physical address the device needs to be programmed
+with actually to address this memory (this will be handed out as the
+dma_addr_t in dma_alloc_coherent()).
+
+size is the size of the area (must be multiples of PAGE_SIZE).
+
+flags can be or'd together and are:
+
+DMA_MEMORY_MAP - request that the memory returned from
+dma_alloc_coherent() be directly writable.
+
+DMA_MEMORY_IO - request that the memory returned from
+dma_alloc_coherent() be addressable using read/write/memcpy_toio etc.
+
+One or both of these flags must be present.
+
+DMA_MEMORY_INCLUDES_CHILDREN - make the declared memory be allocated by
+dma_alloc_coherent of any child devices of this one (for memory residing
+on a bridge).
+
+DMA_MEMORY_EXCLUSIVE - only allocate memory from the declared regions. 
+Do not allow dma_alloc_coherent() to fall back to system memory when
+it's out of memory in the declared region.
+
+The return value will be either DMA_MEMORY_MAP or DMA_MEMORY_IO and
+must correspond to a passed in flag (i.e. no returning DMA_MEMORY_IO
+if only DMA_MEMORY_MAP were passed in) for success or zero for
+failure.
+
+Note, for DMA_MEMORY_IO returns, all subsequent memory returned by
+dma_alloc_coherent() may no longer be accessed directly, but instead
+must be accessed using the correct bus functions.  If your driver
+isn't prepared to handle this contingency, it should not specify
+DMA_MEMORY_IO in the input flags.
+
+As a simplification for the platforms, only *one* such region of
+memory may be declared per device.
+
+For reasons of efficiency, most platforms choose to track the declared
+region only at the granularity of a page.  For smaller allocations,
+you should use the dma_pool() API.
+
+void
+dma_release_declared_memory(struct device *dev)
+
+Remove the memory region previously declared from the system.  This
+API performs *no* in-use checking for this region and will return
+unconditionally having removed all the required structures.  It is the
+driver's job to ensure that no parts of this memory region are
+currently in use.
+
+void *
+dma_mark_declared_memory_occupied(struct device *dev,
+				  dma_addr_t device_addr, size_t size)
+
+This is used to occupy specific regions of the declared space
+(dma_alloc_coherent() will hand out the first free region it finds).
+
+device_addr is the *device* address of the region requested.
+
+size is the size (and should be a page-sized multiple).
+
+The return value will be either a pointer to the processor virtual
+address of the memory, or an error (via PTR_ERR()) if any part of the
+region is occupied.
diff --git a/Documentation/DMA/DMA-ISA-LPC.txt b/Documentation/DMA/DMA-ISA-LPC.txt
new file mode 100644
index 0000000..e767805
--- /dev/null
+++ b/Documentation/DMA/DMA-ISA-LPC.txt
@@ -0,0 +1,151 @@
+                        DMA with ISA and LPC devices
+                        ============================
+
+                      Pierre Ossman <drzeus@drzeus.cx>
+
+This document describes how to do DMA transfers using the old ISA DMA
+controller. Even though ISA is more or less dead today the LPC bus
+uses the same DMA system so it will be around for quite some time.
+
+Part I - Headers and dependencies
+---------------------------------
+
+To do ISA style DMA you need to include two headers:
+
+#include <linux/dma-mapping.h>
+#include <asm/dma.h>
+
+The first is the generic DMA API used to convert virtual addresses to
+physical addresses (see Documentation/DMA-API.txt for details).
+
+The second contains the routines specific to ISA DMA transfers. Since
+this is not present on all platforms make sure you construct your
+Kconfig to be dependent on ISA_DMA_API (not ISA) so that nobody tries
+to build your driver on unsupported platforms.
+
+Part II - Buffer allocation
+---------------------------
+
+The ISA DMA controller has some very strict requirements on which
+memory it can access so extra care must be taken when allocating
+buffers.
+
+(You usually need a special buffer for DMA transfers instead of
+transferring directly to and from your normal data structures.)
+
+The DMA-able address space is the lowest 16 MB of _physical_ memory.
+Also the transfer block may not cross page boundaries (which are 64
+or 128 KiB depending on which channel you use).
+
+In order to allocate a piece of memory that satisfies all these
+requirements you pass the flag GFP_DMA to kmalloc.
+
+Unfortunately the memory available for ISA DMA is scarce so unless you
+allocate the memory during boot-up it's a good idea to also pass
+__GFP_REPEAT and __GFP_NOWARN to make the allocater try a bit harder.
+
+(This scarcity also means that you should allocate the buffer as
+early as possible and not release it until the driver is unloaded.)
+
+Part III - Address translation
+------------------------------
+
+To translate the virtual address to a physical use the normal DMA
+API. Do _not_ use isa_virt_to_phys() even though it does the same
+thing. The reason for this is that the function isa_virt_to_phys()
+will require a Kconfig dependency to ISA, not just ISA_DMA_API which
+is really all you need. Remember that even though the DMA controller
+has its origins in ISA it is used elsewhere.
+
+Note: x86_64 had a broken DMA API when it came to ISA but has since
+been fixed. If your arch has problems then fix the DMA API instead of
+reverting to the ISA functions.
+
+Part IV - Channels
+------------------
+
+A normal ISA DMA controller has 8 channels. The lower four are for
+8-bit transfers and the upper four are for 16-bit transfers.
+
+(Actually the DMA controller is really two separate controllers where
+channel 4 is used to give DMA access for the second controller (0-3).
+This means that of the four 16-bits channels only three are usable.)
+
+You allocate these in a similar fashion as all basic resources:
+
+extern int request_dma(unsigned int dmanr, const char * device_id);
+extern void free_dma(unsigned int dmanr);
+
+The ability to use 16-bit or 8-bit transfers is _not_ up to you as a
+driver author but depends on what the hardware supports. Check your
+specs or test different channels.
+
+Part V - Transfer data
+----------------------
+
+Now for the good stuff, the actual DMA transfer. :)
+
+Before you use any ISA DMA routines you need to claim the DMA lock
+using claim_dma_lock(). The reason is that some DMA operations are
+not atomic so only one driver may fiddle with the registers at a
+time.
+
+The first time you use the DMA controller you should call
+clear_dma_ff(). This clears an internal register in the DMA
+controller that is used for the non-atomic operations. As long as you
+(and everyone else) uses the locking functions then you only need to
+reset this once.
+
+Next, you tell the controller in which direction you intend to do the
+transfer using set_dma_mode(). Currently you have the options
+DMA_MODE_READ and DMA_MODE_WRITE.
+
+Set the address from where the transfer should start (this needs to
+be 16-bit aligned for 16-bit transfers) and how many bytes to
+transfer. Note that it's _bytes_. The DMA routines will do all the
+required translation to values that the DMA controller understands.
+
+The final step is enabling the DMA channel and releasing the DMA
+lock.
+
+Once the DMA transfer is finished (or timed out) you should disable
+the channel again. You should also check get_dma_residue() to make
+sure that all data has been transferred.
+
+Example:
+
+int flags, residue;
+
+flags = claim_dma_lock();
+
+clear_dma_ff();
+
+set_dma_mode(channel, DMA_MODE_WRITE);
+set_dma_addr(channel, phys_addr);
+set_dma_count(channel, num_bytes);
+
+dma_enable(channel);
+
+release_dma_lock(flags);
+
+while (!device_done());
+
+flags = claim_dma_lock();
+
+dma_disable(channel);
+
+residue = dma_get_residue(channel);
+if (residue != 0)
+	printk(KERN_ERR "driver: Incomplete DMA transfer!"
+		" %d bytes left!\n", residue);
+
+release_dma_lock(flags);
+
+Part VI - Suspend/resume
+------------------------
+
+It is the driver's responsibility to make sure that the machine isn't
+suspended while a DMA transfer is in progress. Also, all DMA settings
+are lost when the system suspends so if your driver relies on the DMA
+controller being in a certain state then you have to restore these
+registers upon resume.
diff --git a/Documentation/DMA/DMA-attributes.txt b/Documentation/DMA/DMA-attributes.txt
new file mode 100644
index 0000000..6d772f8
--- /dev/null
+++ b/Documentation/DMA/DMA-attributes.txt
@@ -0,0 +1,24 @@
+			DMA attributes
+			==============
+
+This document describes the semantics of the DMA attributes that are
+defined in linux/dma-attrs.h.
+
+DMA_ATTR_WRITE_BARRIER
+----------------------
+
+DMA_ATTR_WRITE_BARRIER is a (write) barrier attribute for DMA.  DMA
+to a memory region with the DMA_ATTR_WRITE_BARRIER attribute forces
+all pending DMA writes to complete, and thus provides a mechanism to
+strictly order DMA from a device across all intervening busses and
+bridges.  This barrier is not specific to a particular type of
+interconnect, it applies to the system as a whole, and so its
+implementation must account for the idiosyncracies of the system all
+the way from the DMA device to memory.
+
+As an example of a situation where DMA_ATTR_WRITE_BARRIER would be
+useful, suppose that a device does a DMA write to indicate that data is
+ready and available in memory.  The DMA of the "completion indication"
+could race with data DMA.  Mapping the memory used for completion
+indications with DMA_ATTR_WRITE_BARRIER would prevent the race.
+
diff --git a/Documentation/DMA/DMA-mapping.txt b/Documentation/DMA/DMA-mapping.txt
new file mode 100644
index 0000000..b463ecd
--- /dev/null
+++ b/Documentation/DMA/DMA-mapping.txt
@@ -0,0 +1,766 @@
+			Dynamic DMA mapping
+			===================
+
+		 David S. Miller <davem@redhat.com>
+		 Richard Henderson <rth@cygnus.com>
+		  Jakub Jelinek <jakub@redhat.com>
+
+This document describes the DMA mapping system in terms of the pci_
+API.  For a similar API that works for generic devices, see
+DMA-API.txt.
+
+Most of the 64bit platforms have special hardware that translates bus
+addresses (DMA addresses) into physical addresses.  This is similar to
+how page tables and/or a TLB translates virtual addresses to physical
+addresses on a CPU.  This is needed so that e.g. PCI devices can
+access with a Single Address Cycle (32bit DMA address) any page in the
+64bit physical address space.  Previously in Linux those 64bit
+platforms had to set artificial limits on the maximum RAM size in the
+system, so that the virt_to_bus() static scheme works (the DMA address
+translation tables were simply filled on bootup to map each bus
+address to the physical page __pa(bus_to_virt())).
+
+So that Linux can use the dynamic DMA mapping, it needs some help from the
+drivers, namely it has to take into account that DMA addresses should be
+mapped only for the time they are actually used and unmapped after the DMA
+transfer.
+
+The following API will work of course even on platforms where no such
+hardware exists, see e.g. include/asm-i386/pci.h for how it is implemented on
+top of the virt_to_bus interface.
+
+First of all, you should make sure
+
+#include <linux/pci.h>
+
+is in your driver. This file will obtain for you the definition of the
+dma_addr_t (which can hold any valid DMA address for the platform)
+type which should be used everywhere you hold a DMA (bus) address
+returned from the DMA mapping functions.
+
+			 What memory is DMA'able?
+
+The first piece of information you must know is what kernel memory can
+be used with the DMA mapping facilities.  There has been an unwritten
+set of rules regarding this, and this text is an attempt to finally
+write them down.
+
+If you acquired your memory via the page allocator
+(i.e. __get_free_page*()) or the generic memory allocators
+(i.e. kmalloc() or kmem_cache_alloc()) then you may DMA to/from
+that memory using the addresses returned from those routines.
+
+This means specifically that you may _not_ use the memory/addresses
+returned from vmalloc() for DMA.  It is possible to DMA to the
+_underlying_ memory mapped into a vmalloc() area, but this requires
+walking page tables to get the physical addresses, and then
+translating each of those pages back to a kernel address using
+something like __va().  [ EDIT: Update this when we integrate
+Gerd Knorr's generic code which does this. ]
+
+This rule also means that you may use neither kernel image addresses
+(items in data/text/bss segments), nor module image addresses, nor
+stack addresses for DMA.  These could all be mapped somewhere entirely
+different than the rest of physical memory.  Even if those classes of
+memory could physically work with DMA, you'd need to ensure the I/O
+buffers were cacheline-aligned.  Without that, you'd see cacheline
+sharing problems (data corruption) on CPUs with DMA-incoherent caches.
+(The CPU could write to one word, DMA would write to a different one
+in the same cache line, and one of them could be overwritten.)
+
+Also, this means that you cannot take the return of a kmap()
+call and DMA to/from that.  This is similar to vmalloc().
+
+What about block I/O and networking buffers?  The block I/O and
+networking subsystems make sure that the buffers they use are valid
+for you to DMA from/to.
+
+			DMA addressing limitations
+
+Does your device have any DMA addressing limitations?  For example, is
+your device only capable of driving the low order 24-bits of address
+on the PCI bus for SAC DMA transfers?  If so, you need to inform the
+PCI layer of this fact.
+
+By default, the kernel assumes that your device can address the full
+32-bits in a SAC cycle.  For a 64-bit DAC capable device, this needs
+to be increased.  And for a device with limitations, as discussed in
+the previous paragraph, it needs to be decreased.
+
+pci_alloc_consistent() by default will return 32-bit DMA addresses.
+PCI-X specification requires PCI-X devices to support 64-bit
+addressing (DAC) for all transactions. And at least one platform (SGI
+SN2) requires 64-bit consistent allocations to operate correctly when
+the IO bus is in PCI-X mode. Therefore, like with pci_set_dma_mask(),
+it's good practice to call pci_set_consistent_dma_mask() to set the
+appropriate mask even if your device only supports 32-bit DMA
+(default) and especially if it's a PCI-X device.
+
+For correct operation, you must interrogate the PCI layer in your
+device probe routine to see if the PCI controller on the machine can
+properly support the DMA addressing limitation your device has.  It is
+good style to do this even if your device holds the default setting,
+because this shows that you did think about these issues wrt. your
+device.
+
+The query is performed via a call to pci_set_dma_mask():
+
+	int pci_set_dma_mask(struct pci_dev *pdev, u64 device_mask);
+
+The query for consistent allocations is performed via a call to
+pci_set_consistent_dma_mask():
+
+	int pci_set_consistent_dma_mask(struct pci_dev *pdev, u64 device_mask);
+
+Here, pdev is a pointer to the PCI device struct of your device, and
+device_mask is a bit mask describing which bits of a PCI address your
+device supports.  It returns zero if your card can perform DMA
+properly on the machine given the address mask you provided.
+
+If it returns non-zero, your device cannot perform DMA properly on
+this platform, and attempting to do so will result in undefined
+behavior.  You must either use a different mask, or not use DMA.
+
+This means that in the failure case, you have three options:
+
+1) Use another DMA mask, if possible (see below).
+2) Use some non-DMA mode for data transfer, if possible.
+3) Ignore this device and do not initialize it.
+
+It is recommended that your driver print a kernel KERN_WARNING message
+when you end up performing either #2 or #3.  In this manner, if a user
+of your driver reports that performance is bad or that the device is not
+even detected, you can ask them for the kernel messages to find out
+exactly why.
+
+The standard 32-bit addressing PCI device would do something like
+this:
+
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		printk(KERN_WARNING
+		       "mydev: No suitable DMA available.\n");
+		goto ignore_this_device;
+	}
+
+Another common scenario is a 64-bit capable device.  The approach
+here is to try for 64-bit DAC addressing, but back down to a
+32-bit mask should that fail.  The PCI platform code may fail the
+64-bit mask not because the platform is not capable of 64-bit
+addressing.  Rather, it may fail in this case simply because
+32-bit SAC addressing is done more efficiently than DAC addressing.
+Sparc64 is one platform which behaves in this way.
+
+Here is how you would handle a 64-bit capable device which can drive
+all 64-bits when accessing streaming DMA:
+
+	int using_dac;
+
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		using_dac = 1;
+	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		using_dac = 0;
+	} else {
+		printk(KERN_WARNING
+		       "mydev: No suitable DMA available.\n");
+		goto ignore_this_device;
+	}
+
+If a card is capable of using 64-bit consistent allocations as well,
+the case would look like this:
+
+	int using_dac, consistent_using_dac;
+
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		using_dac = 1;
+	   	consistent_using_dac = 1;
+		pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		using_dac = 0;
+		consistent_using_dac = 0;
+		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	} else {
+		printk(KERN_WARNING
+		       "mydev: No suitable DMA available.\n");
+		goto ignore_this_device;
+	}
+
+pci_set_consistent_dma_mask() will always be able to set the same or a
+smaller mask as pci_set_dma_mask(). However for the rare case that a
+device driver only uses consistent allocations, one would have to
+check the return value from pci_set_consistent_dma_mask().
+
+Finally, if your device can only drive the low 24-bits of
+address during PCI bus mastering you might do something like:
+
+	if (pci_set_dma_mask(pdev, DMA_24BIT_MASK)) {
+		printk(KERN_WARNING
+		       "mydev: 24-bit DMA addressing not available.\n");
+		goto ignore_this_device;
+	}
+
+When pci_set_dma_mask() is successful, and returns zero, the PCI layer
+saves away this mask you have provided.  The PCI layer will use this
+information later when you make DMA mappings.
+
+There is a case which we are aware of at this time, which is worth
+mentioning in this documentation.  If your device supports multiple
+functions (for example a sound card provides playback and record
+functions) and the various different functions have _different_
+DMA addressing limitations, you may wish to probe each mask and
+only provide the functionality which the machine can handle.  It
+is important that the last call to pci_set_dma_mask() be for the
+most specific mask.
+
+Here is pseudo-code showing how this might be done:
+
+	#define PLAYBACK_ADDRESS_BITS	DMA_32BIT_MASK
+	#define RECORD_ADDRESS_BITS	0x00ffffff
+
+	struct my_sound_card *card;
+	struct pci_dev *pdev;
+
+	...
+	if (!pci_set_dma_mask(pdev, PLAYBACK_ADDRESS_BITS)) {
+		card->playback_enabled = 1;
+	} else {
+		card->playback_enabled = 0;
+		printk(KERN_WARN "%s: Playback disabled due to DMA limitations.\n",
+		       card->name);
+	}
+	if (!pci_set_dma_mask(pdev, RECORD_ADDRESS_BITS)) {
+		card->record_enabled = 1;
+	} else {
+		card->record_enabled = 0;
+		printk(KERN_WARN "%s: Record disabled due to DMA limitations.\n",
+		       card->name);
+	}
+
+A sound card was used as an example here because this genre of PCI
+devices seems to be littered with ISA chips given a PCI front end,
+and thus retaining the 16MB DMA addressing limitations of ISA.
+
+			Types of DMA mappings
+
+There are two types of DMA mappings:
+
+- Consistent DMA mappings which are usually mapped at driver
+  initialization, unmapped at the end and for which the hardware should
+  guarantee that the device and the CPU can access the data
+  in parallel and will see updates made by each other without any
+  explicit software flushing.
+
+  Think of "consistent" as "synchronous" or "coherent".
+
+  The current default is to return consistent memory in the low 32
+  bits of the PCI bus space.  However, for future compatibility you
+  should set the consistent mask even if this default is fine for your
+  driver.
+
+  Good examples of what to use consistent mappings for are:
+
+	- Network card DMA ring descriptors.
+	- SCSI adapter mailbox command data structures.
+	- Device firmware microcode executed out of
+	  main memory.
+
+  The invariant these examples all require is that any CPU store
+  to memory is immediately visible to the device, and vice
+  versa.  Consistent mappings guarantee this.
+
+  IMPORTANT: Consistent DMA memory does not preclude the usage of
+             proper memory barriers.  The CPU may reorder stores to
+	     consistent memory just as it may normal memory.  Example:
+	     if it is important for the device to see the first word
+	     of a descriptor updated before the second, you must do
+	     something like:
+
+		desc->word0 = address;
+		wmb();
+		desc->word1 = DESC_VALID;
+
+             in order to get correct behavior on all platforms.
+
+	     Also, on some platforms your driver may need to flush CPU write
+	     buffers in much the same way as it needs to flush write buffers
+	     found in PCI bridges (such as by reading a register's value
+	     after writing it).
+
+- Streaming DMA mappings which are usually mapped for one DMA transfer,
+  unmapped right after it (unless you use pci_dma_sync_* below) and for which
+  hardware can optimize for sequential accesses.
+
+  This of "streaming" as "asynchronous" or "outside the coherency
+  domain".
+
+  Good examples of what to use streaming mappings for are:
+
+	- Networking buffers transmitted/received by a device.
+	- Filesystem buffers written/read by a SCSI device.
+
+  The interfaces for using this type of mapping were designed in
+  such a way that an implementation can make whatever performance
+  optimizations the hardware allows.  To this end, when using
+  such mappings you must be explicit about what you want to happen.
+
+Neither type of DMA mapping has alignment restrictions that come
+from PCI, although some devices may have such restrictions.
+Also, systems with caches that aren't DMA-coherent will work better
+when the underlying buffers don't share cache lines with other data.
+
+
+		 Using Consistent DMA mappings.
+
+To allocate and map large (PAGE_SIZE or so) consistent DMA regions,
+you should do:
+
+	dma_addr_t dma_handle;
+
+	cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
+
+where pdev is a struct pci_dev *. This may be called in interrupt context.
+You should use dma_alloc_coherent (see DMA-API.txt) for buses
+where devices don't have struct pci_dev (like ISA, EISA).
+
+This argument is needed because the DMA translations may be bus
+specific (and often is private to the bus which the device is attached
+to).
+
+Size is the length of the region you want to allocate, in bytes.
+
+This routine will allocate RAM for that region, so it acts similarly to
+__get_free_pages (but takes size instead of a page order).  If your
+driver needs regions sized smaller than a page, you may prefer using
+the pci_pool interface, described below.
+
+The consistent DMA mapping interfaces, for non-NULL pdev, will by
+default return a DMA address which is SAC (Single Address Cycle)
+addressable.  Even if the device indicates (via PCI dma mask) that it
+may address the upper 32-bits and thus perform DAC cycles, consistent
+allocation will only return > 32-bit PCI addresses for DMA if the
+consistent dma mask has been explicitly changed via
+pci_set_consistent_dma_mask().  This is true of the pci_pool interface
+as well.
+
+pci_alloc_consistent returns two values: the virtual address which you
+can use to access it from the CPU and dma_handle which you pass to the
+card.
+
+The cpu return address and the DMA bus master address are both
+guaranteed to be aligned to the smallest PAGE_SIZE order which
+is greater than or equal to the requested size.  This invariant
+exists (for example) to guarantee that if you allocate a chunk
+which is smaller than or equal to 64 kilobytes, the extent of the
+buffer you receive will not cross a 64K boundary.
+
+To unmap and free such a DMA region, you call:
+
+	pci_free_consistent(pdev, size, cpu_addr, dma_handle);
+
+where pdev, size are the same as in the above call and cpu_addr and
+dma_handle are the values pci_alloc_consistent returned to you.
+This function may not be called in interrupt context.
+
+If your driver needs lots of smaller memory regions, you can write
+custom code to subdivide pages returned by pci_alloc_consistent,
+or you can use the pci_pool API to do that.  A pci_pool is like
+a kmem_cache, but it uses pci_alloc_consistent not __get_free_pages.
+Also, it understands common hardware constraints for alignment,
+like queue heads needing to be aligned on N byte boundaries.
+
+Create a pci_pool like this:
+
+	struct pci_pool *pool;
+
+	pool = pci_pool_create(name, pdev, size, align, alloc);
+
+The "name" is for diagnostics (like a kmem_cache name); pdev and size
+are as above.  The device's hardware alignment requirement for this
+type of data is "align" (which is expressed in bytes, and must be a
+power of two).  If your device has no boundary crossing restrictions,
+pass 0 for alloc; passing 4096 says memory allocated from this pool
+must not cross 4KByte boundaries (but at that time it may be better to
+go for pci_alloc_consistent directly instead).
+
+Allocate memory from a pci pool like this:
+
+	cpu_addr = pci_pool_alloc(pool, flags, &dma_handle);
+
+flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
+holding SMP locks), SLAB_ATOMIC otherwise.  Like pci_alloc_consistent,
+this returns two values, cpu_addr and dma_handle.
+
+Free memory that was allocated from a pci_pool like this:
+
+	pci_pool_free(pool, cpu_addr, dma_handle);
+
+where pool is what you passed to pci_pool_alloc, and cpu_addr and
+dma_handle are the values pci_pool_alloc returned. This function
+may be called in interrupt context.
+
+Destroy a pci_pool by calling:
+
+	pci_pool_destroy(pool);
+
+Make sure you've called pci_pool_free for all memory allocated
+from a pool before you destroy the pool. This function may not
+be called in interrupt context.
+
+			DMA Direction
+
+The interfaces described in subsequent portions of this document
+take a DMA direction argument, which is an integer and takes on
+one of the following values:
+
+ PCI_DMA_BIDIRECTIONAL
+ PCI_DMA_TODEVICE
+ PCI_DMA_FROMDEVICE
+ PCI_DMA_NONE
+
+One should provide the exact DMA direction if you know it.
+
+PCI_DMA_TODEVICE means "from main memory to the PCI device"
+PCI_DMA_FROMDEVICE means "from the PCI device to main memory"
+It is the direction in which the data moves during the DMA
+transfer.
+
+You are _strongly_ encouraged to specify this as precisely
+as you possibly can.
+
+If you absolutely cannot know the direction of the DMA transfer,
+specify PCI_DMA_BIDIRECTIONAL.  It means that the DMA can go in
+either direction.  The platform guarantees that you may legally
+specify this, and that it will work, but this may be at the
+cost of performance for example.
+
+The value PCI_DMA_NONE is to be used for debugging.  One can
+hold this in a data structure before you come to know the
+precise direction, and this will help catch cases where your
+direction tracking logic has failed to set things up properly.
+
+Another advantage of specifying this value precisely (outside of
+potential platform-specific optimizations of such) is for debugging.
+Some platforms actually have a write permission boolean which DMA
+mappings can be marked with, much like page protections in the user
+program address space.  Such platforms can and do report errors in the
+kernel logs when the PCI controller hardware detects violation of the
+permission setting.
+
+Only streaming mappings specify a direction, consistent mappings
+implicitly have a direction attribute setting of
+PCI_DMA_BIDIRECTIONAL.
+
+The SCSI subsystem tells you the direction to use in the
+'sc_data_direction' member of the SCSI command your driver is
+working on.
+
+For Networking drivers, it's a rather simple affair.  For transmit
+packets, map/unmap them with the PCI_DMA_TODEVICE direction
+specifier.  For receive packets, just the opposite, map/unmap them
+with the PCI_DMA_FROMDEVICE direction specifier.
+
+		  Using Streaming DMA mappings
+
+The streaming DMA mapping routines can be called from interrupt
+context.  There are two versions of each map/unmap, one which will
+map/unmap a single memory region, and one which will map/unmap a
+scatterlist.
+
+To map a single region, you do:
+
+	struct pci_dev *pdev = mydev->pdev;
+	dma_addr_t dma_handle;
+	void *addr = buffer->ptr;
+	size_t size = buffer->len;
+
+	dma_handle = pci_map_single(pdev, addr, size, direction);
+
+and to unmap it:
+
+	pci_unmap_single(pdev, dma_handle, size, direction);
+
+You should call pci_unmap_single when the DMA activity is finished, e.g.
+from the interrupt which told you that the DMA transfer is done.
+
+Using cpu pointers like this for single mappings has a disadvantage,
+you cannot reference HIGHMEM memory in this way.  Thus, there is a
+map/unmap interface pair akin to pci_{map,unmap}_single.  These
+interfaces deal with page/offset pairs instead of cpu pointers.
+Specifically:
+
+	struct pci_dev *pdev = mydev->pdev;
+	dma_addr_t dma_handle;
+	struct page *page = buffer->page;
+	unsigned long offset = buffer->offset;
+	size_t size = buffer->len;
+
+	dma_handle = pci_map_page(pdev, page, offset, size, direction);
+
+	...
+
+	pci_unmap_page(pdev, dma_handle, size, direction);
+
+Here, "offset" means byte offset within the given page.
+
+With scatterlists, you map a region gathered from several regions by:
+
+	int i, count = pci_map_sg(pdev, sglist, nents, direction);
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, count, i) {
+		hw_address[i] = sg_dma_address(sg);
+		hw_len[i] = sg_dma_len(sg);
+	}
+
+where nents is the number of entries in the sglist.
+
+The implementation is free to merge several consecutive sglist entries
+into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
+consecutive sglist entries can be merged into one provided the first one
+ends and the second one starts on a page boundary - in fact this is a huge
+advantage for cards which either cannot do scatter-gather or have very
+limited number of scatter-gather entries) and returns the actual number
+of sg entries it mapped them to. On failure 0 is returned.
+
+Then you should loop count times (note: this can be less than nents times)
+and use sg_dma_address() and sg_dma_len() macros where you previously
+accessed sg->address and sg->length as shown above.
+
+To unmap a scatterlist, just call:
+
+	pci_unmap_sg(pdev, sglist, nents, direction);
+
+Again, make sure DMA activity has already finished.
+
+PLEASE NOTE:  The 'nents' argument to the pci_unmap_sg call must be
+              the _same_ one you passed into the pci_map_sg call,
+	      it should _NOT_ be the 'count' value _returned_ from the
+              pci_map_sg call.
+
+Every pci_map_{single,sg} call should have its pci_unmap_{single,sg}
+counterpart, because the bus address space is a shared resource (although
+in some ports the mapping is per each BUS so less devices contend for the
+same bus address space) and you could render the machine unusable by eating
+all bus addresses.
+
+If you need to use the same streaming DMA region multiple times and touch
+the data in between the DMA transfers, the buffer needs to be synced
+properly in order for the cpu and device to see the most uptodate and
+correct copy of the DMA buffer.
+
+So, firstly, just map it with pci_map_{single,sg}, and after each DMA
+transfer call either:
+
+	pci_dma_sync_single_for_cpu(pdev, dma_handle, size, direction);
+
+or:
+
+	pci_dma_sync_sg_for_cpu(pdev, sglist, nents, direction);
+
+as appropriate.
+
+Then, if you wish to let the device get at the DMA area again,
+finish accessing the data with the cpu, and then before actually
+giving the buffer to the hardware call either:
+
+	pci_dma_sync_single_for_device(pdev, dma_handle, size, direction);
+
+or:
+
+	pci_dma_sync_sg_for_device(dev, sglist, nents, direction);
+
+as appropriate.
+
+After the last DMA transfer call one of the DMA unmap routines
+pci_unmap_{single,sg}. If you don't touch the data from the first pci_map_*
+call till pci_unmap_*, then you don't have to call the pci_dma_sync_*
+routines at all.
+
+Here is pseudo code which shows a situation in which you would need
+to use the pci_dma_sync_*() interfaces.
+
+	my_card_setup_receive_buffer(struct my_card *cp, char *buffer, int len)
+	{
+		dma_addr_t mapping;
+
+		mapping = pci_map_single(cp->pdev, buffer, len, PCI_DMA_FROMDEVICE);
+
+		cp->rx_buf = buffer;
+		cp->rx_len = len;
+		cp->rx_dma = mapping;
+
+		give_rx_buf_to_card(cp);
+	}
+
+	...
+
+	my_card_interrupt_handler(int irq, void *devid, struct pt_regs *regs)
+	{
+		struct my_card *cp = devid;
+
+		...
+		if (read_card_status(cp) == RX_BUF_TRANSFERRED) {
+			struct my_card_header *hp;
+
+			/* Examine the header to see if we wish
+			 * to accept the data.  But synchronize
+			 * the DMA transfer with the CPU first
+			 * so that we see updated contents.
+			 */
+			pci_dma_sync_single_for_cpu(cp->pdev, cp->rx_dma,
+						    cp->rx_len,
+						    PCI_DMA_FROMDEVICE);
+
+			/* Now it is safe to examine the buffer. */
+			hp = (struct my_card_header *) cp->rx_buf;
+			if (header_is_ok(hp)) {
+				pci_unmap_single(cp->pdev, cp->rx_dma, cp->rx_len,
+						 PCI_DMA_FROMDEVICE);
+				pass_to_upper_layers(cp->rx_buf);
+				make_and_setup_new_rx_buf(cp);
+			} else {
+				/* Just sync the buffer and give it back
+				 * to the card.
+				 */
+				pci_dma_sync_single_for_device(cp->pdev,
+							       cp->rx_dma,
+							       cp->rx_len,
+							       PCI_DMA_FROMDEVICE);
+				give_rx_buf_to_card(cp);
+			}
+		}
+	}
+
+Drivers converted fully to this interface should not use virt_to_bus any
+longer, nor should they use bus_to_virt. Some drivers have to be changed a
+little bit, because there is no longer an equivalent to bus_to_virt in the
+dynamic DMA mapping scheme - you have to always store the DMA addresses
+returned by the pci_alloc_consistent, pci_pool_alloc, and pci_map_single
+calls (pci_map_sg stores them in the scatterlist itself if the platform
+supports dynamic DMA mapping in hardware) in your driver structures and/or
+in the card registers.
+
+All PCI drivers should be using these interfaces with no exceptions.
+It is planned to completely remove virt_to_bus() and bus_to_virt() as
+they are entirely deprecated.  Some ports already do not provide these
+as it is impossible to correctly support them.
+
+		Optimizing Unmap State Space Consumption
+
+On many platforms, pci_unmap_{single,page}() is simply a nop.
+Therefore, keeping track of the mapping address and length is a waste
+of space.  Instead of filling your drivers up with ifdefs and the like
+to "work around" this (which would defeat the whole purpose of a
+portable API) the following facilities are provided.
+
+Actually, instead of describing the macros one by one, we'll
+transform some example code.
+
+1) Use DECLARE_PCI_UNMAP_{ADDR,LEN} in state saving structures.
+   Example, before:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		dma_addr_t mapping;
+		__u32 len;
+	};
+
+   after:
+
+	struct ring_state {
+		struct sk_buff *skb;
+		DECLARE_PCI_UNMAP_ADDR(mapping)
+		DECLARE_PCI_UNMAP_LEN(len)
+	};
+
+   NOTE: DO NOT put a semicolon at the end of the DECLARE_*()
+         macro.
+
+2) Use pci_unmap_{addr,len}_set to set these values.
+   Example, before:
+
+	ringp->mapping = FOO;
+	ringp->len = BAR;
+
+   after:
+
+	pci_unmap_addr_set(ringp, mapping, FOO);
+	pci_unmap_len_set(ringp, len, BAR);
+
+3) Use pci_unmap_{addr,len} to access these values.
+   Example, before:
+
+	pci_unmap_single(pdev, ringp->mapping, ringp->len,
+			 PCI_DMA_FROMDEVICE);
+
+   after:
+
+	pci_unmap_single(pdev,
+			 pci_unmap_addr(ringp, mapping),
+			 pci_unmap_len(ringp, len),
+			 PCI_DMA_FROMDEVICE);
+
+It really should be self-explanatory.  We treat the ADDR and LEN
+separately, because it is possible for an implementation to only
+need the address in order to perform the unmap operation.
+
+			Platform Issues
+
+If you are just writing drivers for Linux and do not maintain
+an architecture port for the kernel, you can safely skip down
+to "Closing".
+
+1) Struct scatterlist requirements.
+
+   Struct scatterlist must contain, at a minimum, the following
+   members:
+
+	struct page *page;
+	unsigned int offset;
+	unsigned int length;
+
+   The base address is specified by a "page+offset" pair.
+
+   Previous versions of struct scatterlist contained a "void *address"
+   field that was sometimes used instead of page+offset.  As of Linux
+   2.5., page+offset is always used, and the "address" field has been
+   deleted.
+
+2) More to come...
+
+			Handling Errors
+
+DMA address space is limited on some architectures and an allocation
+failure can be determined by:
+
+- checking if pci_alloc_consistent returns NULL or pci_map_sg returns 0
+
+- checking the returned dma_addr_t of pci_map_single and pci_map_page
+  by using pci_dma_mapping_error():
+
+	dma_addr_t dma_handle;
+
+	dma_handle = pci_map_single(pdev, addr, size, direction);
+	if (pci_dma_mapping_error(dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+	}
+
+			   Closing
+
+This document, and the API itself, would not be in it's current
+form without the feedback and suggestions from numerous individuals.
+We would like to specifically mention, in no particular order, the
+following people:
+
+	Russell King <rmk@arm.linux.org.uk>
+	Leo Dagum <dagum@barrel.engr.sgi.com>
+	Ralf Baechle <ralf@oss.sgi.com>
+	Grant Grundler <grundler@cup.hp.com>
+	Jay Estabrook <Jay.Estabrook@compaq.com>
+	Thomas Sailer <sailer@ife.ee.ethz.ch>
+	Andrea Arcangeli <andrea@suse.de>
+	Jens Axboe <jens.axboe@oracle.com>
+	David Mosberger-Tang <davidm@hpl.hp.com>
diff --git a/Documentation/IO-mapping.txt b/Documentation/IO-mapping.txt
index 86edb61..9d85597 100644
--- a/Documentation/IO-mapping.txt
+++ b/Documentation/IO-mapping.txt
@@ -1,6 +1,6 @@
 [ NOTE: The virt_to_bus() and bus_to_virt() functions have been
 	superseded by the functionality provided by the PCI DMA
-	interface (see Documentation/DMA-mapping.txt).  They continue
+	interface (see Documentation/DMA/DMA-mapping.txt).  They continue
 	to be documented below for historical purposes, but new code
 	must not use them. --davidm 00/12/12 ]
 
diff --git a/Documentation/PCI/pci.txt b/Documentation/PCI/pci.txt
index 8d4dc62..709dce1 100644
--- a/Documentation/PCI/pci.txt
+++ b/Documentation/PCI/pci.txt
@@ -333,7 +333,7 @@ Also see pci_request_selected_regions() below.
 3.3 Set the DMA mask size
 ~~~~~~~~~~~~~~~~~~~~~~~~~
 [ If anything below doesn't make sense, please refer to
-  Documentation/DMA-API.txt. This section is just a reminder that
+  Documentation/DMA/DMA-API.txt. This section is just a reminder that
   drivers need to indicate DMA capabilities of the device and is not
   an authoritative source for DMA interfaces. ]
 
@@ -359,7 +359,7 @@ Many 64-bit "PCI" devices (before PCI-X) and some PCI-X devices are
 3.4 Setup shared control data
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Once the DMA masks are set, the driver can allocate "consistent" (a.k.a. shared)
-memory.  See Documentation/DMA-API.txt for a full description of
+memory.  See Documentation/DMA/DMA-API.txt for a full description of
 the DMA APIs. This section is just a reminder that it needs to be done
 before enabling DMA on the device.
 
@@ -489,7 +489,7 @@ owners if there is one.
 
 Then clean up "consistent" buffers which contain the control data.
 
-See Documentation/DMA-API.txt for details on unmapping interfaces.
+See Documentation/DMA/DMA-API.txt for details on unmapping interfaces.
 
 
 4.5 Unregister from other subsystems
diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 4dbb8be..28786a6 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -186,8 +186,9 @@ a virtual address mapping (unlike the earlier scheme of virtual address
 do not have a corresponding kernel virtual address space mapping) and
 low-memory pages.
 
-Note: Please refer to DMA-mapping.txt for a discussion on PCI high mem DMA
-aspects and mapping of scatter gather lists, and support for 64 bit PCI.
+Note: Please refer to Documentation/DMA/DMA-mapping.txt for a discussion
+on PCI high mem DMA aspects and mapping of scatter gather lists, and
+support for 64 bit PCI.
 
 Special handling is required only for cases where i/o needs to happen on
 pages at physical memory addresses beyond what the device can support. In these
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f5b7127..caa0bb7 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -432,7 +432,7 @@ There are certain things that the Linux kernel memory barriers do not guarantee:
 
 	    Documentation/PCI/pci.txt
 	    Documentation/PCI/PCI-DMA-mapping.txt
-	    Documentation/DMA-API.txt
+	    Documentation/DMA/DMA-API.txt
 
 
 DATA DEPENDENCY BARRIERS
diff --git a/Documentation/usb/dma.txt b/Documentation/usb/dma.txt
index e8b50b7..d382274 100644
--- a/Documentation/usb/dma.txt
+++ b/Documentation/usb/dma.txt
@@ -5,9 +5,10 @@ in the kernel usb programming guide (kerneldoc, from the source code).
 
 API OVERVIEW
 
-The big picture is that USB drivers can continue to ignore most DMA issues,
-though they still must provide DMA-ready buffers (see DMA-mapping.txt).
-That's how they've worked through the 2.4 (and earlier) kernels.
+The big picture is that USB drivers can continue to ignore most DMA
+issues, though they still must provide DMA-ready buffers (see
+Documentation/DMA/DMA-mapping.txt).  That's how they've worked through
+the 2.4 (and earlier) kernels.
 
 OR:  they can now be DMA-aware.
 
@@ -62,8 +63,8 @@ and effects like cache-trashing can impose subtle penalties.
   force a consistent memory access ordering by using memory barriers.  It's
   not using a streaming DMA mapping, so it's good for small transfers on
   systems where the I/O would otherwise thrash an IOMMU mapping.  (See
-  Documentation/DMA-mapping.txt for definitions of "coherent" and "streaming"
-  DMA mappings.)
+  Documentation/DMA/DMA-mapping.txt for definitions of "coherent" and
+  "streaming" DMA mappings.)
 
   Asking for 1/Nth of a page (as well as asking for N pages) is reasonably
   space-efficient.
@@ -93,7 +94,7 @@ WORKING WITH EXISTING BUFFERS
 Existing buffers aren't usable for DMA without first being mapped into the
 DMA address space of the device.  However, most buffers passed to your
 driver can safely be used with such DMA mapping.  (See the first section
-of DMA-mapping.txt, titled "What memory is DMA-able?")
+of Documentation/DMA/DMA-mapping.txt, titled "What memory is DMA-able?")
 
 - When you're using scatterlists, you can map everything at once.  On some
   systems, this kicks in an IOMMU and turns the scatterlists into single
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 34421ae..b32d390 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -906,7 +906,7 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 dma_addr_t
 sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
@@ -1024,7 +1024,7 @@ sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
 			    int dir, struct dma_attrs *attrs)
@@ -1102,7 +1102,7 @@ EXPORT_SYMBOL(sba_unmap_single_attrs);
  * @size:  number of bytes mapped in driver buffer.
  * @dma_handle:  IOVA of new buffer.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 void *
 sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flags)
@@ -1165,7 +1165,7 @@ sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp
  * @vaddr:  virtual address IOVA of "consistent" buffer.
  * @dma_handler:  IO virtual address of "consistent" buffer.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 void sba_free_coherent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
 {
@@ -1420,7 +1420,7 @@ sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
 		     int dir, struct dma_attrs *attrs)
@@ -1512,7 +1512,7 @@ EXPORT_SYMBOL(sba_map_sg_attrs);
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			int nents, int dir, struct dma_attrs *attrs)
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 52175af..0cfd1ec 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2000,2002-2005 Silicon Graphics, Inc. All rights reserved.
  *
- * Routines for PCI DMA mapping.  See Documentation/DMA-API.txt for
+ * Routines for PCI DMA mapping.  See Documentation/DMA/DMA-API.txt for
  * a description of how these routines should be used.
  */
 
@@ -72,7 +72,7 @@ EXPORT_SYMBOL(sn_dma_set_mask);
  * that @dma_handle will have the %PCIIO_DMA_CMD flag set.
  *
  * This interface is usually used for "command" streams (e.g. the command
- * queue for a SCSI controller).  See Documentation/DMA-API.txt for
+ * queue for a SCSI controller).  See Documentation/DMA/DMA-API.txt for
  * more information.
  */
 void *sn_dma_alloc_coherent(struct device *dev, size_t size,
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index ccd61b9..2a377e6 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -2,7 +2,7 @@
 ** PARISC 1.1 Dynamic DMA mapping support.
 ** This implementation is for PA-RISC platforms that do not support
 ** I/O TLBs (aka DMA address translation hardware).
-** See Documentation/DMA-mapping.txt for interface definitions.
+** See Documentation/DMA/DMA-mapping.txt for interface definitions.
 **
 **      (c) Copyright 1999,2000 Hewlett-Packard Company
 **      (c) Copyright 2000 Grant Grundler
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c07455d..a8d69f9 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -5,7 +5,7 @@
  * This allows to use PCI devices that only support 32bit addresses on systems
  * with more than 4GB.
  *
- * See Documentation/DMA-mapping.txt for the interface specification.
+ * See Documentation/DMA/DMA-mapping.txt for the interface specification.
  *
  * Copyright 2002 Andi Kleen, SuSE Labs.
  * Subject to the GNU General Public License v2 only.
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 432e837..d8dd024 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -1898,7 +1898,7 @@ static void bdx_tx_push_desc_safe(struct bdx_priv *priv, void *data, int size)
  * and a hardware reset occur.
  *
  * functions and their order used as explained in
- * /usr/src/linux/Documentation/DMA-{API,mapping}.txt
+ * /usr/src/linux/Documentation/DMA/DMA-{API,mapping}.txt
  *
  */
 
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index bc73b96..4d1b401 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -668,7 +668,7 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  * @dev: instance of PCI owned by the driver that's asking
  * @mask:  number of address bits this PCI device can handle
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 static int sba_dma_supported( struct device *dev, u64 mask)
 {
@@ -680,8 +680,8 @@ static int sba_dma_supported( struct device *dev, u64 mask)
 		return(0);
 	}
 
-	/* Documentation/DMA-mapping.txt tells drivers to try 64-bit first,
-	 * then fall back to 32-bit if that fails.
+	/* Documentation/DMA/DMA-mapping.txt tells drivers to try 64-bit
+	 * first, * then fall back to 32-bit if that fails.
 	 * We are just "encouraging" 32-bit DMA masks here since we can
 	 * never allow IOMMU bypass unless we add special support for ZX1.
 	 */
@@ -706,7 +706,7 @@ static int sba_dma_supported( struct device *dev, u64 mask)
  * @size:  number of bytes to map in driver buffer.
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 static dma_addr_t
 sba_map_single(struct device *dev, void *addr, size_t size,
@@ -785,7 +785,7 @@ sba_map_single(struct device *dev, void *addr, size_t size,
  * @size:  number of bytes mapped in driver buffer.
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 static void
 sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
@@ -861,7 +861,7 @@ sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
  * @size:  number of bytes mapped in driver buffer.
  * @dma_handle:  IOVA of new buffer.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 static void *sba_alloc_consistent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t gfp)
@@ -892,7 +892,7 @@ static void *sba_alloc_consistent(struct device *hwdev, size_t size,
  * @vaddr:  virtual address IOVA of "consistent" buffer.
  * @dma_handler:  IO virtual address of "consistent" buffer.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 static void
 sba_free_consistent(struct device *hwdev, size_t size, void *vaddr,
@@ -927,7 +927,7 @@ int dump_run_sg = 0;
  * @nents:  number of entries in list
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 static int
 sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
@@ -1011,7 +1011,7 @@ sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
  * @nents:  number of entries in list
  * @direction:  R/W or both.
  *
- * See Documentation/DMA-mapping.txt
+ * See Documentation/DMA/DMA-mapping.txt
  */
 static void 
 sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
diff --git a/include/asm-ia64/dma-mapping.h b/include/asm-ia64/dma-mapping.h
index 9f0df9b..c79ef02 100644
--- a/include/asm-ia64/dma-mapping.h
+++ b/include/asm-ia64/dma-mapping.h
@@ -60,7 +60,7 @@ static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 
 /*
  * Rest of this file is part of the "Advanced DMA API".  Use at your own risk.
- * See Documentation/DMA-API.txt for details.
+ * See Documentation/DMA/DMA-API.txt for details.
  */
 
 #define dma_sync_single_range_for_cpu(dev, dma_handle, offset, size, dir)	\
diff --git a/include/asm-parisc/dma-mapping.h b/include/asm-parisc/dma-mapping.h
index c6c0e9f..869d5a7 100644
--- a/include/asm-parisc/dma-mapping.h
+++ b/include/asm-parisc/dma-mapping.h
@@ -5,7 +5,7 @@
 #include <asm/cacheflush.h>
 #include <asm/scatterlist.h>
 
-/* See Documentation/DMA-mapping.txt */
+/* See Documentation/DMA/DMA-mapping.txt */
 struct hppa_dma_ops {
 	int  (*dma_supported)(struct device *dev, u64 mask);
 	void *(*alloc_consistent)(struct device *dev, size_t size, dma_addr_t *iova, gfp_t flag);
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..9802af2 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -2,7 +2,7 @@
 #define _ASM_DMA_MAPPING_H_
 
 /*
- * IOMMU interface. See Documentation/DMA-mapping.txt and DMA-API.txt for
+ * IOMMU interface. See Documentation/DMA/DMA-mapping.txt and DMA-API.txt for
  * documentation.
  */
 
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index 1677e2b..f2d567e 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -8,7 +8,7 @@
 /**
  * an enum dma_attr represents an attribute associated with a DMA
  * mapping. The semantics of each attribute should be defined in
- * Documentation/DMA-attributes.txt.
+ * Documentation/DMA/DMA-attributes.txt.
  */
 enum dma_attr {
 	DMA_ATTR_WRITE_BARRIER,
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index be8da26..5ac6f76 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -49,7 +49,7 @@ struct scatterlist* videobuf_pages_to_sg(struct page **pages, int nr_pages,
  *	does memory allocation too using vmalloc_32().
  *
  * videobuf_dma_*()
- *	see Documentation/DMA-mapping.txt, these functions to
+ *	see Documentation/DMA/DMA-mapping.txt, these functions to
  *	basically the same.  The map function does also build a
  *	scatterlist for the buffer (and unmap frees it ...)
  *
-- 
1.5.5.rc1

