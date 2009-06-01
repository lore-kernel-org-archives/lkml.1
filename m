Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbZFAPgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbZFAPgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZFAPdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:33:39 -0400
Received: from smtp.citrix.com ([66.165.176.89]:62354 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZFAPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:33:38 -0400
X-IronPort-AV: E=Sophos;i="4.41,284,1241409600"; 
   d="scan'208";a="4484698"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Olaf Kirch <okir@suse.de>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 09/11] swiotlb: rename swiotlb_virt_to_bus as virt_to_dma
Date: Mon, 1 Jun 2009 16:33:01 +0100
Message-ID: <1243870383-12954-10-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
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
 lib/swiotlb.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d2b296a..ca8009a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -124,13 +124,13 @@ void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
-static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
+static dma_addr_t swiotlb_virt_to_dma(struct device *hwdev,
 				      volatile void *address)
 {
 	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
-static void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
+static void *swiotlb_dma_to_virt(struct device *hwdev, dma_addr_t address)
 {
 #ifdef CONFIG_HIGHMEM
 	unsigned long pfn = PFN_DOWN(dma_to_phys(hwdev, address));
@@ -365,7 +365,7 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_dma(hwdev, io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
@@ -667,7 +667,7 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			 size_t size, int dir)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	char *dma_addr = swiotlb_dma_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -704,7 +704,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	char *dma_addr = swiotlb_dma_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -892,7 +892,7 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_dma(hwdev, io_tlb_overflow_buffer));
 }
 EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 
@@ -905,6 +905,6 @@ EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_dma(hwdev, io_tlb_end - 1) <= mask;
 }
 EXPORT_SYMBOL(swiotlb_dma_supported);
-- 
1.5.6.5

