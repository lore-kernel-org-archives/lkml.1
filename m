Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZE2Iq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZE2Iq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbZE2IoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:44:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41310 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbZE2IoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:44:17 -0400
X-IronPort-AV: E=Sophos;i="4.41,270,1241409600"; 
   d="scan'208";a="53001215"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Olaf Kirch <okir@suse.de>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 9/9] swiotlb: rename swiotlb_virt_to_bus as virt_to_dma
Date: Fri, 29 May 2009 09:44:03 +0100
Message-ID: <1243586643-5554-10-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename swiotlb_virt_to_bus as swiotlb_virt_to_dma for consistency with
phys_to_dma.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 lib/swiotlb.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index c50a5ed..8479ed9 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -124,14 +124,14 @@ void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
-static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
+static dma_addr_t swiotlb_virt_to_dma(struct device *hwdev,
 				      volatile void *address)
 {
 	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
 #ifdef CONFIG_HIGHMEM
-static void * swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
+static void * swiotlb_dma_to_virt(struct device *hwdev, dma_addr_t address)
 {
 	unsigned long pfn = PFN_DOWN(dma_to_phys(hwdev, addr));
 	void *pageaddr = page_address(pfn_to_page(pfn));
@@ -141,7 +141,7 @@ static void * swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 	return NULL;
 }
 #else
-static void * swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
+static void * swiotlb_dma_to_virt(struct device *hwdev, dma_addr_t address)
 {
 	return phys_to_virt(dma_to_phys(hwdev, address));
 }
@@ -368,7 +368,7 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_dma(hwdev, io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
@@ -669,7 +669,7 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			 size_t size, int dir)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	char *dma_addr = swiotlb_dma_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -706,7 +706,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	char *dma_addr = swiotlb_dma_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -893,19 +893,19 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_dma(hwdev, io_tlb_overflow_buffer));
 }
 EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
- * during bus mastering, then you would pass 0x00ffffff as the mask to
+ * during dma mastering, then you would pass 0x00ffffff as the mask to
  * this function.
  */
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_dma(hwdev, io_tlb_end - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);
-- 
1.5.6.5

