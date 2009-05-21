Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZEUQPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZEUQPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZEUQPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:36 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbZEUQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:35 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100759"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb: make is_buffer_dma_capable architecture-specific
Date: Thu, 21 May 2009 17:15:22 +0100
Message-Id: <1242922528-5982-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:36.0406 (UTC) FILETIME=[5FE6F760:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves is_buffer_dma_capable() from include/linux/dma-mapping.h to
arch/*/include/asm/dma-mapping.h because it's architecture-specific;
we shouldn't have added it in the generic place.

This function is used only in swiotlb (supported by x86 and IA64, and
POWERPC shortly).

POWERPC needs struct device to see if an address is DMA-capable or
not. How POWERPC implements is_buffer_dma_capable() is still under
discussion. So this patch doesn't add POWERPC's one.

Based on original patch by FUJITA Tomonori.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>
Cc: xen-devel <xendevel@lists.xensource.com>
Cc: x86 maintainers <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
---
 arch/ia64/include/asm/dma-mapping.h |    6 ++++++
 arch/x86/include/asm/dma-mapping.h  |    6 ++++++
 arch/x86/kernel/pci-dma.c           |    2 +-
 arch/x86/kernel/pci-gart_64.c       |    4 ++--
 arch/x86/kernel/pci-nommu.c         |    3 ++-
 include/linux/dma-mapping.h         |    5 -----
 lib/swiotlb.c                       |   25 +++++++------------------
 7 files changed, 24 insertions(+), 27 deletions(-)

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
index 71d412a..23fa16e 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -14,7 +14,8 @@
 static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 {
-	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
+	if (hwdev &&
+	    !is_buffer_dma_capable(hwdev, *hwdev->dma_mask, bus, size)) {
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
index cec5f62..98726a2 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -147,12 +147,6 @@ void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
 }
 
-int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
-					       dma_addr_t addr, size_t size)
-{
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
-}
-
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
@@ -318,12 +312,6 @@ cleanup1:
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
 	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr, size);
@@ -565,8 +553,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 
 	ret = (void *)__get_free_pages(flags, order);
 	if (ret &&
-	    !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(hwdev, ret),
-				   size)) {
+	    !is_buffer_dma_capable(hwdev, dma_mask,
+				   swiotlb_virt_to_bus(hwdev, ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 */
@@ -588,7 +576,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
+	if (!is_buffer_dma_capable(hwdev, dma_mask, dev_addr, size)) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
@@ -658,7 +646,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(dev, dev_addr, size) &&
+	if (is_buffer_dma_capable(dev, dma_get_mask(dev), dev_addr, size) &&
 	    !range_needs_mapping(phys, size))
 		return dev_addr;
 
@@ -676,7 +664,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(dev, dev_addr, size))
+	if (!is_buffer_dma_capable(dev, dma_get_mask(dev), dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -823,7 +811,8 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
 		if (range_needs_mapping(paddr, sg->length) ||
-		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
+		    !is_buffer_dma_capable(hwdev, dma_get_mask(hwdev),
+					   dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
 			if (!map) {
-- 
1.5.6.5

