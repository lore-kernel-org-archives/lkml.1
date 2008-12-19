Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYLSFNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYLSFNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYLSFLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:32 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42901 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 01/11] swiotlb: Drop SG_ENT_VIRT_ADDRESS macro
Date: Thu, 18 Dec 2008 23:11:12 -0600
Message-Id: <1229663480-10757-2-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All SG_ENT_VIRT_ADDRESS does is call sg_virt(), get rid of
this needless layer of complexity.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 96e8b10..3d9ac10 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -36,8 +36,7 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
-#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
+#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(sg_virt(sg))
 
 /*
  * Maximum allowable number of contiguous slabs to map,
@@ -721,7 +720,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		addr = SG_ENT_VIRT_ADDRESS(sg);
+		addr = sg_virt(sg);
 		dev_addr = virt_to_bus(addr);
 		if (swiotlb_force ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
@@ -769,7 +768,7 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			unmap_single(hwdev, bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(sg_virt(sg), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -802,7 +801,7 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 			sync_single(hwdev, bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(sg_virt(sg), sg->dma_length);
 	}
 }
 
-- 
1.5.6.5

