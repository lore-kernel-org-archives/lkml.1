Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZAISci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZAISci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbZAIScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:32:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48833 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZAIScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:32:20 -0500
X-IronPort-AV: E=Sophos;i="4.37,240,1231131600"; 
   d="scan'208";a="35161172"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jj@chaosbits.net,
       weiyi.huang@gmail.com, Becky Bruce <beckyb@kernel.crashing.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 1/2] swiotlb: range_needs_mapping should take a physical address.
Date: Fri,  9 Jan 2009 18:32:09 +0000
Message-Id: <1231525930-14087-2-git-send-email-Ian.Campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
References: <1231524630.27350.79.camel@zakaz.uk.xensource.com>
 <1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
X-OriginalArrivalTime: 09 Jan 2009 18:32:19.0291 (UTC) FILETIME=[9AACE2B0:01C97288]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The swiotlb_arch_range_needs_mapping() hook should take a physical
address rather than a virtual address in order to support highmem pages.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 include/linux/swiotlb.h          |    2 +-
 lib/swiotlb.c                    |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 5e32c4f..34f12e9 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -33,7 +33,7 @@ phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 	return baddr;
 }
 
-int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
+int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
 }
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 493dc17..ac9ff54 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -31,7 +31,7 @@ extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 				      phys_addr_t address);
 extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
 
-extern int swiotlb_arch_range_needs_mapping(void *ptr, size_t size);
+extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 30fe65e..31bae40 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -145,7 +145,7 @@ static void *swiotlb_bus_to_virt(dma_addr_t address)
 	return phys_to_virt(swiotlb_bus_to_phys(address));
 }
 
-int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
+int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
 }
@@ -315,9 +315,9 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
 }
 
-static inline int range_needs_mapping(void *ptr, size_t size)
+static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
 {
-	return swiotlb_force || swiotlb_arch_range_needs_mapping(ptr, size);
+	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr, size);
 }
 
 static int is_swiotlb_buffer(char *addr)
@@ -653,7 +653,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * buffering it.
 	 */
 	if (!address_needs_mapping(dev, dev_addr, size) &&
-	    !range_needs_mapping(ptr, size))
+	    !range_needs_mapping(virt_to_phys(ptr), size))
 		return dev_addr;
 
 	/*
@@ -804,7 +804,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		void *addr = sg_virt(sg);
 		dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, addr);
 
-		if (range_needs_mapping(addr, sg->length) ||
+		if (range_needs_mapping(sg_phys(sg), sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
-- 
1.5.6.5

