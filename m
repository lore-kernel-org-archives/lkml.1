Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZEUI4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZEUI4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 04:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbZEUI4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 04:56:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:58795 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZEUI4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 04:56:41 -0400
Date: Thu, 21 May 2009 17:54:54 +0900
To: jeremy@goop.org
Cc: ijc@hellion.org.uk, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, gregkh@suse.de, okir@suse.de,
       beckyb@kernel.crashing.org, beckyb@kernel.crashing.org
Subject: Re: Where do we stand with the Xen patches?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A143885.1050502@goop.org>
References: <20090520002955R.fujita.tomonori@lab.ntt.co.jp>
	<1242748597.22654.44.camel@zakaz.uk.xensource.com>
	<4A143885.1050502@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 21 May 2009 17:54:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 10:06:13 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ian Campbell wrote:
> > On Wed, 2009-05-20 at 00:30 +0900, FUJITA Tomonori wrote:
> >   
> >> We need these hooks but as I wrote above, they are
> >> architecture-specific and we should handle them with the architecture
> >> abstraction (as we handle similar problems) however we can't due to
> >> dom0 support.
> >>     
> >
> > I don't understand this. What exactly about the dom0 support patch
> > prevents future abstraction here?
> >
> > The dom0 hooks would simply move into the per-arch abstractions as
> > appropriate, wouldn't they?
> 
> Fujita-san's suggestion to me was that swiotlb could just use the normal 
> (albeit deprecated) phys_to_bus()/bus_to_phys() interfaces rather than 
> defining its own.  That would be perfectly OK for Xen; we have a single 
> global translation which is unaffected by the target device, etc.
> 
> But I'm not sure it would work for powerpc; Becky's patches which added 
> swiotlb_bus_to_phys/phys_bus made them take a device argument, because 
> (apparently) the bus/phys offset can differ on a per-device or per-bus 
> basis.  The powerpc side of swiotlb doesn't seem to be in mainline yet, 
> so I'm not sure what the details are here (maybe it can be handled with 
> a single big runtime switch, if the offset is always constant on a given 
> machine).
> 
> (Hm, now that I look I see that they're defined as 
> virt_to_bus/bus_to_virt, which doesn't work for highmem at all; it would 
> need to be phys.)
> 
> But I may have misinterpreted what he meant. 

What I want to remove all the __weak hacks and use the architecture
abstraction. For example, the following patch is killing
swiotlb_arch_address_needs_mapping() and
swiotlb_arch_range_needs_mapping().

As you said, POWERPC needs a pair of conversion functions between phys
and bus. I want to use arch/*/include/ for it in the same way.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] make is_buffer_dma_capable architecture-specific

This moves is_buffer_dma_capable() from include/linux/dma-mapping.h to
arch/*/include/asm/dma-mapping.h because it's architecture-specific;
we shouldn't have added it in the generic place.

This function is used only in swiotlb (supported by x86 and IA64, and
POWERPC shortly).

POWERPC needs struct device to see if an address is DMA-capable or
not. How POWERPC implements is_buffer_dma_capable() is still under
discussion. So this patch doesn't add POWERPC's one.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/include/asm/dma-mapping.h |    6 +++++
 arch/x86/include/asm/dma-mapping.h  |    6 +++++
 arch/x86/kernel/pci-dma.c           |    2 +-
 arch/x86/kernel/pci-gart_64.c       |    4 +-
 arch/x86/kernel/pci-nommu.c         |    2 +-
 include/linux/dma-mapping.h         |    5 ----
 lib/swiotlb.c                       |   39 +++++++---------------------------
 7 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 36c0009..a091648 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -174,4 +174,10 @@ dma_cache_sync (struct device *dev, void *vaddr, size_t size,
 
 #define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
 
+static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
+					dma_addr_t addr, size_t size)
+{
+	return addr + size <= mask;
+}
+
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 916cbb6..52b8d36 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -309,4 +309,10 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 		ops->free_coherent(dev, size, vaddr, bus);
 }
 
+static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
+					dma_addr_t addr, size_t size)
+{
+	return addr + size <= mask;
+}
+
 #endif
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 745579b..efb0bd6 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -145,7 +145,7 @@ again:
 		return NULL;
 
 	addr = page_to_phys(page);
-	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
+	if (!is_buffer_dma_capable(dev, dma_mask, addr, size)) {
 		__free_pages(page, get_order(size));
 
 		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 1e8920d..13f5265 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -191,13 +191,13 @@ static inline int
 need_iommu(struct device *dev, unsigned long addr, size_t size)
 {
 	return force_iommu ||
-		!is_buffer_dma_capable(*dev->dma_mask, addr, size);
+		!is_buffer_dma_capable(dev, *dev->dma_mask, addr, size);
 }
 
 static inline int
 nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	return !is_buffer_dma_capable(*dev->dma_mask, addr, size);
+	return !is_buffer_dma_capable(dev, *dev->dma_mask, addr, size);
 }
 
 /* Map a single continuous physical area into the IOMMU.
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 71d412a..df930f3 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -14,7 +14,7 @@
 static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 {
-	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
+	if (hwdev && !is_buffer_dma_capable(hwdev, *hwdev->dma_mask, bus, size)) {
 		if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
 			printk(KERN_ERR
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 8083b6a..85dafa1 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -96,11 +96,6 @@ static inline int is_device_dma_capable(struct device *dev)
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
-static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
-{
-	return addr + size <= mask;
-}
-
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bffe6d7..01c5775 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -145,17 +145,6 @@ void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
 }
 
-int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
-					       dma_addr_t addr, size_t size)
-{
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
-}
-
-int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	return 0;
-}
-
 static void swiotlb_print_info(unsigned long bytes)
 {
 	phys_addr_t pstart, pend;
@@ -315,17 +304,6 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static inline int
-address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
-{
-	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
-}
-
-static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr, size);
-}
-
 static int is_swiotlb_buffer(char *addr)
 {
 	return addr >= io_tlb_start && addr < io_tlb_end;
@@ -561,9 +539,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret &&
-	    !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(hwdev, ret),
-				   size)) {
+	if (ret && !is_buffer_dma_capable(hwdev, dma_mask,
+					  swiotlb_virt_to_bus(hwdev, ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 */
@@ -585,7 +562,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
+	if (!is_buffer_dma_capable(hwdev, dma_mask, dev_addr, size)) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
@@ -655,8 +632,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(dev, dev_addr, size) &&
-	    !range_needs_mapping(phys, size))
+	if (is_buffer_dma_capable(dev, dma_get_mask(dev), dev_addr, size) &&
+	    !swiotlb_force)
 		return dev_addr;
 
 	/*
@@ -673,7 +650,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(dev, dev_addr, size))
+	if (!is_buffer_dma_capable(dev, dma_get_mask(dev), dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -819,8 +796,8 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		phys_addr_t paddr = sg_phys(sg);
 		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
-		if (range_needs_mapping(paddr, sg->length) ||
-		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
+		if (!is_buffer_dma_capable(hwdev, dma_get_mask(hwdev), paddr, sg->length) ||
+		    swiotlb_force) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
 			if (!map) {
-- 
1.6.0.6

