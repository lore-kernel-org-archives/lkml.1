Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZAIScz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZAIScz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZAIScZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:32:25 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48833 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZAIScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:32:24 -0500
X-IronPort-AV: E=Sophos;i="4.37,240,1231131600"; 
   d="scan'208";a="35161176"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jj@chaosbits.net,
       weiyi.huang@gmail.com, Becky Bruce <beckyb@kernel.crashing.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 2/2] swiotlb: do not use sg_virt()
Date: Fri,  9 Jan 2009 18:32:10 +0000
Message-Id: <1231525930-14087-3-git-send-email-Ian.Campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231525930-14087-2-git-send-email-Ian.Campbell@citrix.com>
References: <1231524630.27350.79.camel@zakaz.uk.xensource.com>
 <1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
 <1231525930-14087-2-git-send-email-Ian.Campbell@citrix.com>
X-OriginalArrivalTime: 09 Jan 2009 18:32:23.0353 (UTC) FILETIME=[9D18B290:01C97288]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scatterlists containing HighMem pages do not have a useful virtual
address. Use the physical address instead.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 lib/swiotlb.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 31bae40..32e2bd3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -801,10 +801,10 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		void *addr = sg_virt(sg);
-		dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, addr);
+		phys_addr_t paddr = sg_phys(sg);
+		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
-		if (range_needs_mapping(sg_phys(sg), sg->length) ||
+		if (range_needs_mapping(paddr, sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
@@ -848,11 +848,11 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_virt_to_bus(hwdev, sg_virt(sg)))
+		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(sg_virt(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -882,11 +882,11 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_virt_to_bus(hwdev, sg_virt(sg)))
+		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(sg_virt(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 
-- 
1.5.6.5

