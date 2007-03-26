Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXCZOML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXCZOML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXCZOMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:12:08 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:22904
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbXCZOME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:12:04 -0400
Message-Id: <4607F0EF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 26 Mar 2007 15:12:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove pci_dac_dma_... APIs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Based on replies to a respective query, remove the pci_dac_dma_...() APIs
(except for pci_dac_dma_supported() on Alpha, where this function is used
in non-DAC PCI DMA code).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jesse Barnes <jesse.barnes@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>

--- linux-2.6.21-rc5/Documentation/DMA-mapping.txt	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/Documentation/DMA-mapping.txt	2007-03-23 17:46:37.000000000 +0100
@@ -664,109 +664,6 @@ It is that simple.
 Well, not for some odd devices.  See the next section for information
 about that.
 
-	DAC Addressing for Address Space Hungry Devices
-
-There exists a class of devices which do not mesh well with the PCI
-DMA mapping API.  By definition these "mappings" are a finite
-resource.  The number of total available mappings per bus is platform
-specific, but there will always be a reasonable amount.
-
-What is "reasonable"?  Reasonable means that networking and block I/O
-devices need not worry about using too many mappings.
-
-As an example of a problematic device, consider compute cluster cards.
-They can potentially need to access gigabytes of memory at once via
-DMA.  Dynamic mappings are unsuitable for this kind of access pattern.
-
-To this end we've provided a small API by which a device driver
-may use DAC cycles to directly address all of physical memory.
-Not all platforms support this, but most do.  It is easy to determine
-whether the platform will work properly at probe time.
-
-First, understand that there may be a SEVERE performance penalty for
-using these interfaces on some platforms.  Therefore, you MUST only
-use these interfaces if it is absolutely required.  %99 of devices can
-use the normal APIs without any problems.
-
-Note that for streaming type mappings you must either use these
-interfaces, or the dynamic mapping interfaces above.  You may not mix
-usage of both for the same device.  Such an act is illegal and is
-guaranteed to put a banana in your tailpipe.
-
-However, consistent mappings may in fact be used in conjunction with
-these interfaces.  Remember that, as defined, consistent mappings are
-always going to be SAC addressable.
-
-The first thing your driver needs to do is query the PCI platform
-layer if it is capable of handling your devices DAC addressing
-capabilities:
-
-	int pci_dac_dma_supported(struct pci_dev *hwdev, u64 mask);
-
-You may not use the following interfaces if this routine fails.
-
-Next, DMA addresses using this API are kept track of using the
-dma64_addr_t type.  It is guaranteed to be big enough to hold any
-DAC address the platform layer will give to you from the following
-routines.  If you have consistent mappings as well, you still
-use plain dma_addr_t to keep track of those.
-
-All mappings obtained here will be direct.  The mappings are not
-translated, and this is the purpose of this dialect of the DMA API.
-
-All routines work with page/offset pairs.  This is the _ONLY_ way to 
-portably refer to any piece of memory.  If you have a cpu pointer
-(which may be validly DMA'd too) you may easily obtain the page
-and offset using something like this:
-
-	struct page *page = virt_to_page(ptr);
-	unsigned long offset = offset_in_page(ptr);
-
-Here are the interfaces:
-
-	dma64_addr_t pci_dac_page_to_dma(struct pci_dev *pdev,
-					 struct page *page,
-					 unsigned long offset,
-					 int direction);
-
-The DAC address for the tuple PAGE/OFFSET are returned.  The direction
-argument is the same as for pci_{map,unmap}_single().  The same rules
-for cpu/device access apply here as for the streaming mapping
-interfaces.  To reiterate:
-
-	The cpu may touch the buffer before pci_dac_page_to_dma.
-	The device may touch the buffer after pci_dac_page_to_dma
-	is made, but the cpu may NOT.
-
-When the DMA transfer is complete, invoke:
-
-	void pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev,
-					     dma64_addr_t dma_addr,
-					     size_t len, int direction);
-
-This must be done before the CPU looks at the buffer again.
-This interface behaves identically to pci_dma_sync_{single,sg}_for_cpu().
-
-And likewise, if you wish to let the device get back at the buffer after
-the cpu has read/written it, invoke:
-
-	void pci_dac_dma_sync_single_for_device(struct pci_dev *pdev,
-						dma64_addr_t dma_addr,
-						size_t len, int direction);
-
-before letting the device access the DMA area again.
-
-If you need to get back to the PAGE/OFFSET tuple from a dma64_addr_t
-the following interfaces are provided:
-
-	struct page *pci_dac_dma_to_page(struct pci_dev *pdev,
-					 dma64_addr_t dma_addr);
-	unsigned long pci_dac_dma_to_offset(struct pci_dev *pdev,
-					    dma64_addr_t dma_addr);
-
-This is possible with the DAC interfaces purely because they are
-not translated in any way.
-
 		Optimizing Unmap State Space Consumption
 
 On many platforms, pci_unmap_{single,page}() is simply a nop.
--- linux-2.6.21-rc5/arch/alpha/kernel/pci_iommu.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/arch/alpha/kernel/pci_iommu.c	2007-03-26 08:51:16.000000000 +0200
@@ -206,6 +206,10 @@ iommu_arena_free(struct pci_iommu_arena 
 		p[i] = 0;
 }
 
+/* True if the machine supports DAC addressing, and DEV can
+   make use of it given MASK.  */
+static int pci_dac_dma_supported(struct pci_dev *hwdev, u64 mask);
+
 /* Map a single buffer of the indicated size for PCI DMA in streaming
    mode.  The 32-bit PCI bus mastering address to use is returned.
    Once the device is given the dma address, the device owns this memory
@@ -896,7 +900,7 @@ iommu_unbind(struct pci_iommu_arena *are
 /* True if the machine supports DAC addressing, and DEV can
    make use of it given MASK.  */
 
-int
+static int
 pci_dac_dma_supported(struct pci_dev *dev, u64 mask)
 {
 	dma64_addr_t dac_offset = alpha_mv.pci_dac_offset;
@@ -916,32 +920,6 @@ pci_dac_dma_supported(struct pci_dev *de
 
 	return ok;
 }
-EXPORT_SYMBOL(pci_dac_dma_supported);
-
-dma64_addr_t
-pci_dac_page_to_dma(struct pci_dev *pdev, struct page *page,
-		    unsigned long offset, int direction)
-{
-	return (alpha_mv.pci_dac_offset
-		+ __pa(page_address(page)) 
-		+ (dma64_addr_t) offset);
-}
-EXPORT_SYMBOL(pci_dac_page_to_dma);
-
-struct page *
-pci_dac_dma_to_page(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	unsigned long paddr = (dma_addr & PAGE_MASK) - alpha_mv.pci_dac_offset;
-	return virt_to_page(__va(paddr));
-}
-EXPORT_SYMBOL(pci_dac_dma_to_page);
-
-unsigned long
-pci_dac_dma_to_offset(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return (dma_addr & ~PAGE_MASK);
-}
-EXPORT_SYMBOL(pci_dac_dma_to_offset);
 
 /* Helper for generic DMA-mapping functions. */
 
--- linux-2.6.21-rc5/arch/mips/pci/Makefile	2007-03-26 15:20:05.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/arch/mips/pci/Makefile	2007-03-23 17:12:46.000000000 +0100
@@ -2,7 +2,7 @@
 # Makefile for the PCI specific kernel interface routines under Linux.
 #
 
-obj-y				+= pci.o pci-dac.o
+obj-y				+= pci.o
 
 #
 # PCI bus host bridge specific code
--- linux-2.6.21-rc5/arch/mips/pci/pci-dac.c	2007-03-26 15:20:05.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/arch/mips/pci/pci-dac.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,79 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2000  Ani Joshi <ajoshi@unixbox.com>
- * Copyright (C) 2000, 2001, 06  Ralf Baechle <ralf@linux-mips.org>
- * swiped from i386, and cloned for MIPS by Geert, polished by Ralf.
- */
-
-#include <linux/types.h>
-#include <linux/dma-mapping.h>
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-#include <asm/cache.h>
-#include <asm/io.h>
-
-#include <dma-coherence.h>
-
-#include <linux/pci.h>
-
-dma64_addr_t pci_dac_page_to_dma(struct pci_dev *pdev,
-	struct page *page, unsigned long offset, int direction)
-{
-	struct device *dev = &pdev->dev;
-
-	BUG_ON(direction == DMA_NONE);
-
-	if (!plat_device_is_coherent(dev)) {
-		unsigned long addr;
-
-		addr = (unsigned long) page_address(page) + offset;
-		dma_cache_wback_inv(addr, PAGE_SIZE);
-	}
-
-	return plat_map_dma_mem_page(dev, page) + offset;
-}
-
-EXPORT_SYMBOL(pci_dac_page_to_dma);
-
-struct page *pci_dac_dma_to_page(struct pci_dev *pdev,
-	dma64_addr_t dma_addr)
-{
-	return pfn_to_page(plat_dma_addr_to_phys(dma_addr) >> PAGE_SHIFT);
-}
-
-EXPORT_SYMBOL(pci_dac_dma_to_page);
-
-unsigned long pci_dac_dma_to_offset(struct pci_dev *pdev,
-	dma64_addr_t dma_addr)
-{
-	return dma_addr & ~PAGE_MASK;
-}
-
-EXPORT_SYMBOL(pci_dac_dma_to_offset);
-
-void pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev,
-	dma64_addr_t dma_addr, size_t len, int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-
-	if (!plat_device_is_coherent(&pdev->dev))
-		dma_cache_wback_inv(dma_addr + PAGE_OFFSET, len);
-}
-
-EXPORT_SYMBOL(pci_dac_dma_sync_single_for_cpu);
-
-void pci_dac_dma_sync_single_for_device(struct pci_dev *pdev,
-	dma64_addr_t dma_addr, size_t len, int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-
-	if (!plat_device_is_coherent(&pdev->dev))
-		dma_cache_wback_inv(dma_addr + PAGE_OFFSET, len);
-}
-
-EXPORT_SYMBOL(pci_dac_dma_sync_single_for_device);
--- linux-2.6.21-rc5/arch/x86_64/kernel/pci-dma.c	2007-03-26 15:20:12.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/arch/x86_64/kernel/pci-dma.c	2007-03-23 17:37:07.000000000 +0100
@@ -22,8 +22,7 @@ EXPORT_SYMBOL(bad_dma_address);
 int iommu_bio_merge __read_mostly = 0;
 EXPORT_SYMBOL(iommu_bio_merge);
 
-int iommu_sac_force __read_mostly = 0;
-EXPORT_SYMBOL(iommu_sac_force);
+static int iommu_sac_force __read_mostly = 0;
 
 int no_iommu __read_mostly;
 #ifdef CONFIG_IOMMU_DEBUG
--- linux-2.6.21-rc5/include/asm-alpha/pci.h	2007-03-26 15:20:49.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-alpha/pci.h	2007-03-26 08:50:07.000000000 +0200
@@ -199,30 +199,6 @@ pci_dma_sync_sg_for_device(struct pci_de
 
 extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
 
-/* True if the machine supports DAC addressing, and DEV can
-   make use of it given MASK.  */
-extern int pci_dac_dma_supported(struct pci_dev *hwdev, u64 mask);
-
-/* Convert to/from DAC dma address and struct page.  */
-extern dma64_addr_t pci_dac_page_to_dma(struct pci_dev *, struct page *,
-					unsigned long, int);
-extern struct page *pci_dac_dma_to_page(struct pci_dev *, dma64_addr_t);
-extern unsigned long pci_dac_dma_to_offset(struct pci_dev *, dma64_addr_t);
-
-static inline void
-pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev, dma64_addr_t dma_addr,
-				size_t len, int direction)
-{
-	/* Nothing to do. */
-}
-
-static inline void
-pci_dac_dma_sync_single_for_device(struct pci_dev *pdev, dma64_addr_t dma_addr,
-				   size_t len, int direction)
-{
-	/* Nothing to do. */
-}
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
--- linux-2.6.21-rc5/include/asm-arm/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-arm/pci.h	2007-03-23 17:29:03.000000000 +0100
@@ -26,11 +26,6 @@ static inline void pcibios_penalize_isa_
 #define PCI_DMA_BUS_IS_PHYS     (0)
 
 /*
- * We don't support DAC DMA cycles.
- */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
-
-/*
  * Whether pci_unmap_{single,page} is a nop depends upon the
  * configuration.
  */
--- linux-2.6.21-rc5/include/asm-cris/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-cris/pci.h	2007-03-23 17:27:34.000000000 +0100
@@ -52,38 +52,6 @@ struct pci_dev;
 #define pci_unmap_len(PTR, LEN_NAME)		(0)
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
 
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(1)
-
-static inline dma64_addr_t
-pci_dac_page_to_dma(struct pci_dev *pdev, struct page *page, unsigned long offset, int direction)
-{
-	return ((dma64_addr_t) page_to_phys(page) +
-		(dma64_addr_t) offset);
-}
-
-static inline struct page *
-pci_dac_dma_to_page(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return pfn_to_page(dma_addr >> PAGE_SHIFT);
-}
-
-static inline unsigned long
-pci_dac_dma_to_offset(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return (dma_addr & ~PAGE_MASK);
-}
-
-static inline void
-pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-}
-
-static inline void
-pci_dac_dma_sync_single_for_device(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-}
-
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			       enum pci_mmap_state mmap_state, int write_combine);
--- linux-2.6.21-rc5/include/asm-frv/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-frv/pci.h	2007-03-23 17:29:20.000000000 +0100
@@ -44,9 +44,6 @@ extern void *pci_alloc_consistent(struct
 extern void pci_free_consistent(struct pci_dev *hwdev, size_t size,
 				void *vaddr, dma_addr_t dma_handle);
 
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(1)
-
 /* Return the index of the PCI controller for device PDEV. */
 #define pci_controller_num(PDEV)	(0)
 
--- linux-2.6.21-rc5/include/asm-i386/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-i386/pci.h	2007-03-23 17:27:01.000000000 +0100
@@ -56,39 +56,6 @@ struct pci_dev;
 #define pci_unmap_len(PTR, LEN_NAME)		(0)
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
 
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(1)
-
-static inline dma64_addr_t
-pci_dac_page_to_dma(struct pci_dev *pdev, struct page *page, unsigned long offset, int direction)
-{
-	return ((dma64_addr_t) page_to_phys(page) +
-		(dma64_addr_t) offset);
-}
-
-static inline struct page *
-pci_dac_dma_to_page(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return pfn_to_page(dma_addr >> PAGE_SHIFT);
-}
-
-static inline unsigned long
-pci_dac_dma_to_offset(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return (dma_addr & ~PAGE_MASK);
-}
-
-static inline void
-pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-}
-
-static inline void
-pci_dac_dma_sync_single_for_device(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-	flush_write_buffers();
-}
-
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			       enum pci_mmap_state mmap_state, int write_combine);
--- linux-2.6.21-rc5/include/asm-ia64/pci.h	2007-03-26 15:20:50.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-ia64/pci.h	2007-03-23 17:28:00.000000000 +0100
@@ -71,14 +71,6 @@ pcibios_penalize_isa_irq (int irq, int a
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-/* The ia64 platform always supports 64-bit addressing. */
-#define pci_dac_dma_supported(pci_dev, mask)		(1)
-#define pci_dac_page_to_dma(dev,pg,off,dir)		((dma_addr_t) page_to_bus(pg) + (off))
-#define pci_dac_dma_to_page(dev,dma_addr)		(virt_to_page(bus_to_virt(dma_addr)))
-#define pci_dac_dma_to_offset(dev,dma_addr)		offset_in_page(dma_addr)
-#define pci_dac_dma_sync_single_for_cpu(dev,dma_addr,len,dir)	do { } while (0)
-#define pci_dac_dma_sync_single_for_device(dev,dma_addr,len,dir)	do { mb(); } while (0)
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
--- linux-2.6.21-rc5/include/asm-m68knommu/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-m68knommu/pci.h	2007-03-23 17:17:08.000000000 +0100
@@ -24,12 +24,6 @@ static inline int pci_dma_supported(stru
 	return 1;
 }
 
-/*
- * Not supporting more than 32-bit PCI bus addresses now, but
- * must satisfy references to this function.  Change if needed.
- */
-#define pci_dac_dma_supported(pci_dev, mask) (0)
-
 static inline void pcibios_add_platform_entries(struct pci_dev *dev)
 {
 }
--- linux-2.6.21-rc5/include/asm-mips/pci.h	2007-03-26 15:20:50.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-mips/pci.h	2007-03-23 17:28:20.000000000 +0100
@@ -121,20 +121,6 @@ extern unsigned int PCI_DMA_BUS_IS_PHYS;
 
 #endif /* CONFIG_DMA_NEED_PCI_MAP_STATE  */
 
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(1)
-
-extern dma64_addr_t pci_dac_page_to_dma(struct pci_dev *pdev,
-	struct page *page, unsigned long offset, int direction);
-extern struct page *pci_dac_dma_to_page(struct pci_dev *pdev,
-	dma64_addr_t dma_addr);
-extern unsigned long pci_dac_dma_to_offset(struct pci_dev *pdev,
-	dma64_addr_t dma_addr);
-extern void pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev,
-	dma64_addr_t dma_addr, size_t len, int direction);
-extern void pci_dac_dma_sync_single_for_device(struct pci_dev *pdev,
-	dma64_addr_t dma_addr, size_t len, int direction);
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
--- linux-2.6.21-rc5/include/asm-parisc/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-parisc/pci.h	2007-03-23 17:19:48.000000000 +0100
@@ -238,9 +238,6 @@ extern inline void pcibios_register_hba(
 #define PCIBIOS_MIN_IO          0x10
 #define PCIBIOS_MIN_MEM         0x1000 /* NBPG - but pci/setup-res.c dies */
 
-/* Don't support DAC yet. */
-#define pci_dac_dma_supported(pci_dev, mask)   (0)
-
 /* export the pci_ DMA API in terms of the dma_ one */
 #include <asm-generic/pci-dma-compat.h>
 
--- linux-2.6.21-rc5/include/asm-powerpc/dma-mapping.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-powerpc/dma-mapping.h	2007-03-23 17:19:09.000000000 +0100
@@ -61,7 +61,6 @@ struct dma_mapping_ops {
 	void		(*unmap_sg)(struct device *dev, struct scatterlist *sg,
 				int nents, enum dma_data_direction direction);
 	int		(*dma_supported)(struct device *dev, u64 mask);
-	int		(*dac_dma_supported)(struct device *dev, u64 mask);
 	int		(*set_dma_mask)(struct device *dev, u64 dma_mask);
 };
 
--- linux-2.6.21-rc5/include/asm-powerpc/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-powerpc/pci.h	2007-03-23 17:18:00.000000000 +0100
@@ -72,16 +72,6 @@ static inline int pci_get_legacy_ide_irq
 
 extern struct dma_mapping_ops *pci_dma_ops;
 
-/* For DAC DMA, we currently don't support it by default, but
- * we let 64-bit platforms override this.
- */
-static inline int pci_dac_dma_supported(struct pci_dev *hwdev,u64 mask)
-{
-	if (pci_dma_ops && pci_dma_ops->dac_dma_supported)
-		return pci_dma_ops->dac_dma_supported(&hwdev->dev, mask);
-	return 0;
-}
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
@@ -118,12 +108,6 @@ static inline void pci_dma_burst_advice(
 }
 #endif
 
-/*
- * At present there are very few 32-bit PPC machines that can have
- * memory above the 4GB point, and we don't support that.
- */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
-
 /* Return the index of the PCI controller for device PDEV. */
 #define pci_domain_nr(bus) ((struct pci_controller *)(bus)->sysdata)->index
 
--- linux-2.6.21-rc5/include/asm-ppc/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-ppc/pci.h	2007-03-23 17:29:39.000000000 +0100
@@ -102,12 +102,6 @@ static inline void pci_dma_burst_advice(
 }
 #endif
 
-/*
- * At present there are very few 32-bit PPC machines that can have
- * memory above the 4GB point, and we don't support that.
- */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
-
 /* Return the index of the PCI controller for device PDEV. */
 #define pci_domain_nr(bus) ((struct pci_controller *)(bus)->sysdata)->index
 
--- linux-2.6.21-rc5/include/asm-sh/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-sh/pci.h	2007-03-23 17:19:32.000000000 +0100
@@ -110,11 +110,6 @@ static inline void pcibios_penalize_isa_
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
 #endif
 
-/* Not supporting more than 32-bit PCI bus addresses now, but
- * must satisfy references to this function.  Change if needed.
- */
-#define pci_dac_dma_supported(pci_dev, mask) (0)
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
--- linux-2.6.21-rc5/include/asm-sh64/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-sh64/pci.h	2007-03-23 17:28:53.000000000 +0100
@@ -72,11 +72,6 @@ static inline void pcibios_penalize_isa_
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
 #endif
 
-/* Not supporting more than 32-bit PCI bus addresses now, but
- * must satisfy references to this function.  Change if needed.
- */
-#define pci_dac_dma_supported(pci_dev, mask) (0)
-
 /* These macros should be used after a pci_map_sg call has been done
  * to get bus addresses of each of the SG entries and their lengths.
  * You should only work with the number of sg entries pci_map_sg
--- linux-2.6.21-rc5/include/asm-sparc/pci.h	2007-03-26 15:20:51.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-sparc/pci.h	2007-03-23 17:26:40.000000000 +0100
@@ -142,8 +142,6 @@ static inline int pci_dma_supported(stru
 	return 1;
 }
 
-#define pci_dac_dma_supported(dev, mask)	(0)
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
--- linux-2.6.21-rc5/include/asm-sparc64/pci.h	2007-03-26 15:20:51.000000000 +0200
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-sparc64/pci.h	2007-03-23 17:29:59.000000000 +0100
@@ -206,49 +206,6 @@ extern int pci_dma_supported(struct pci_
 #define PCI64_REQUIRED_MASK	(~(dma64_addr_t)0)
 #define PCI64_ADDR_BASE		0xfffc000000000000UL
 
-/* Usage of the pci_dac_foo interfaces is only valid if this
- * test passes.
- */
-#define pci_dac_dma_supported(pci_dev, mask) \
-	((((mask) & PCI64_REQUIRED_MASK) == PCI64_REQUIRED_MASK) ? 1 : 0)
-
-static inline dma64_addr_t
-pci_dac_page_to_dma(struct pci_dev *pdev, struct page *page, unsigned long offset, int direction)
-{
-	return (PCI64_ADDR_BASE +
-		__pa(page_address(page)) + offset);
-}
-
-static inline struct page *
-pci_dac_dma_to_page(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	unsigned long paddr = (dma_addr & PAGE_MASK) - PCI64_ADDR_BASE;
-
-	return virt_to_page(__va(paddr));
-}
-
-static inline unsigned long
-pci_dac_dma_to_offset(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return (dma_addr & ~PAGE_MASK);
-}
-
-static inline void
-pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-	/* DAC cycle addressing does not make use of the
-	 * PCI controller's streaming cache, so nothing to do.
-	 */
-}
-
-static inline void
-pci_dac_dma_sync_single_for_device(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-	/* DAC cycle addressing does not make use of the
-	 * PCI controller's streaming cache, so nothing to do.
-	 */
-}
-
 #define PCI_DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
 static inline int pci_dma_mapping_error(dma_addr_t dma_addr)
--- linux-2.6.21-rc5/include/asm-v850/rte_cb.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-v850/rte_cb.h	2007-03-23 17:28:43.000000000 +0100
@@ -64,7 +64,6 @@
 /* As we don't really support PCI DMA to cpu memory, and use bounce-buffers
    instead, perversely enough, this becomes always true! */
 # define pci_dma_supported(dev, mask)		1
-# define pci_dac_dma_supported(dev, mask)	0
 # define pcibios_assign_all_busses()		1
 
 #endif /* CONFIG_RTE_MB_A_PCI */
--- linux-2.6.21-rc5/include/asm-x86_64/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-x86_64/pci.h	2007-03-26 10:24:34.000000000 +0200
@@ -54,14 +54,6 @@ extern int iommu_setup(char *opt);
 
 #if defined(CONFIG_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
 
-/*
- * x86-64 always supports DAC, but sometimes it is useful to force
- * devices through the IOMMU to get automatic sg list merging.
- * Optional right now.
- */
-extern int iommu_sac_force;
-#define pci_dac_dma_supported(pci_dev, mask)	(!iommu_sac_force)
-
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
 #define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
@@ -78,8 +70,6 @@ extern int iommu_sac_force;
 #else
 /* No IOMMU */
 
-#define pci_dac_dma_supported(pci_dev, mask)    1
-
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
 #define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
 #define pci_unmap_addr(PTR, ADDR_NAME)		(0)
@@ -91,36 +81,6 @@ extern int iommu_sac_force;
 
 #include <asm-generic/pci-dma-compat.h>
 
-static inline dma64_addr_t
-pci_dac_page_to_dma(struct pci_dev *pdev, struct page *page, unsigned long offset, int direction)
-{
-	return ((dma64_addr_t) page_to_phys(page) +
-		(dma64_addr_t) offset);
-}
-
-static inline struct page *
-pci_dac_dma_to_page(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return virt_to_page(__va(dma_addr)); 	
-}
-
-static inline unsigned long
-pci_dac_dma_to_offset(struct pci_dev *pdev, dma64_addr_t dma_addr)
-{
-	return (dma_addr & ~PAGE_MASK);
-}
-
-static inline void
-pci_dac_dma_sync_single_for_cpu(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-}
-
-static inline void
-pci_dac_dma_sync_single_for_device(struct pci_dev *pdev, dma64_addr_t dma_addr, size_t len, int direction)
-{
-	flush_write_buffers();
-}
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
--- linux-2.6.21-rc5/include/asm-xtensa/pci.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-no-pci-dac-dma/include/asm-xtensa/pci.h	2007-03-23 17:25:16.000000000 +0100
@@ -64,9 +64,6 @@ struct pci_dev;
 #define pci_ubnmap_len(PTR, LEN_NAME)		(0)
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
 
-/* We cannot access memory above 4GB */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
-
 /* Map a range of PCI memory or I/O space for a device into user space */
 int pci_mmap_page_range(struct pci_dev *pdev, struct vm_area_struct *vma,
                         enum pci_mmap_state mmap_state, int write_combine);


