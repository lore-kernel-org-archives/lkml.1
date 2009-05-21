Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZEUKd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZEUKd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZEUKdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:33:20 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:43702 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbZEUKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:33:20 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       gregkh@suse.de, okir@suse.de, beckyb@kernel.crashing.org
In-Reply-To: <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
References: <20090520002955R.fujita.tomonori@lab.ntt.co.jp>
	 <1242748597.22654.44.camel@zakaz.uk.xensource.com>
	 <4A143885.1050502@goop.org> <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 21 May 2009 11:27:10 +0100
Message-Id: <1242901630.22654.135.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Where do we stand with the Xen patches?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=GMTY6ZCfsGoA:10 a=UU1a1liyotcA:10 a=tHz9FfFoAAAA:8 a=y4WBh0H_RwssaAvqKQUA:9 a=X2ZDOq5uLz1N9X7niAYA:7 a=P2xFJzx4offaHN01y8sjNcj_aE8A:4 a=6O0IECtVFhoA:10 a=uZZYBxH1VLNjt4dY:21 a=3jpEN4pNycStCAQj:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 17:54 +0900, FUJITA Tomonori wrote:
> 
> What I want to remove all the __weak hacks and use the architecture
> abstraction. For example, the following patch is killing
> swiotlb_arch_address_needs_mapping() and
> swiotlb_arch_range_needs_mapping().

I think the swiotlb_arch_address_needs_mapping()/is_buffer_dma_capable()
aspects of this are fine from the Xen POV but a hook along the lines of
swiotlb_arch_range_needs_mapping() is unfortunately still required to
handle potential discontigousness in multipage buffers. There's no
reason this can't be handled in a similar way though. e.g. the following
updated patch is based on yours but also moves the swiotlb_range_needs
mapping hook to dma-mapping.h. The corresponding the Xen updates will.

Subject: swiotlb: is_buffer_dma_capable and swiotlb_range_needs_mapping are arch-specific

This moves is_buffer_dma_capable() from include/linux/dma-mapping.h to
arch/*/include/asm/dma-mapping.h because it's architecture-specific;
we shouldn't have added it in the generic place.

This function is used only in swiotlb (supported by x86 and IA64, and
POWERPC shortly).

POWERPC needs struct device to see if an address is DMA-capable or
not. How POWERPC implements is_buffer_dma_capable() is still under
discussion. So this patch doesn't add POWERPC's one.

The range_needs_mapping hook is needed by Xen PCI to support multipage
buffers which are potentially discontiguous in the DMA address space.

Based on original patch by FUJITA Tomonori.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 36c0009..cc25a4a 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -174,4 +174,15 @@ dma_cache_sync (struct device *dev, void *vaddr, size_t size,
 
 #define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
 
+static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
+					dma_addr_t addr, size_t size)
+{
+	return addr + size <= mask;
+}
+
+static int inline swiotlb_range_needs_mapping(phys_addr_t paddr, size_t size)
+{
+       return 0;
+}
+
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 916cbb6..a80139a 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -309,4 +309,15 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 		ops->free_coherent(dev, size, vaddr, bus);
 }
 
+static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
+					dma_addr_t addr, size_t size)
+{
+	return addr + size <= mask;
+}
+
+static int inline swiotlb_range_needs_mapping(phys_addr_t paddr, size_t size)
+{
+	return 0;
+}
+
 #endif
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 2fffc22..587cc6a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -146,7 +146,7 @@ again:
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
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cb1a663..32f4fa4 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -32,8 +32,6 @@ extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
 				       dma_addr_t address);
 
-extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
-
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index cec5f62..bde376c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -147,17 +147,6 @@ void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
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
@@ -318,15 +307,9 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static inline int
-address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
-{
-	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
-}
-
 static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
 {
-	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr, size);
+	return swiotlb_force || swiotlb_range_needs_mapping(paddr, size);
 }
 
 static int is_swiotlb_buffer(char *addr)
@@ -564,9 +547,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
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
@@ -588,7 +570,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
+	if (!is_buffer_dma_capable(hwdev, dma_mask, dev_addr, size)) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
@@ -658,7 +640,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(dev, dev_addr, size) &&
+	if (is_buffer_dma_capable(dev, dma_get_mask(dev), dev_addr, size) &&
 	    !range_needs_mapping(phys, size))
 		return dev_addr;
 
@@ -676,7 +658,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(dev, dev_addr, size))
+	if (!is_buffer_dma_capable(dev, dma_get_mask(dev), dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -823,7 +805,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
 		if (range_needs_mapping(paddr, sg->length) ||
-		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
+		    !is_buffer_dma_capable(hwdev, dma_get_mask(hwdev), dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
 			if (!map) {

-- 
Ian Campbell
Current Noise: Dark Fortress - Edge Of Night

Yow!  Is this sexual intercourse yet??  Is it, huh, is it??

