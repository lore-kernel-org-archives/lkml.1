Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYICPEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYICPEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbYICPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:04:24 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:29810 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbYICPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:04:23 -0400
X-BigFish: VPS7(zz853kzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K6MKIJ-04-FN8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, tony.luck@intel.com
Subject: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures with swiotlb
Date: Wed, 3 Sep 2008 17:03:44 +0200
Message-ID: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 03 Sep 2008 15:03:44.0553 (UTC) FILETIME=[426F6990:01C90DD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SWIOTLB version of dma_alloc_coherent allocates all memory with
GFP_DMA unconditionally. This leads sometimes unnecessary to allocation
failures. This patch makes the allocation strategy to use the DMA32 zone
first if this is possible. The changes are boot tested on AMD64 and
compile tested for i386 and IA64.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: tony.luck@intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/swiotlb.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 977edbd..6ba077f 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -466,13 +466,24 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dma_addr_t dev_addr;
 	void *ret;
 	int order = get_order(size);
+	unsigned long dma_mask;
 
-	/*
-	 * XXX fix me: the DMA API should pass us an explicit DMA mask
-	 * instead, or use ZONE_DMA32 (ia64 overloads ZONE_DMA to be a ~32
-	 * bit range instead of a 16MB one).
-	 */
-	flags |= GFP_DMA;
+	if (hwdev->dma_mask == NULL)
+		return NULL;
+
+	flags &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	flags |= __GFP_ZERO;
+
+	dma_mask = hwdev->coherent_dma_mask;
+	if (!dma_mask)
+		dma_mask = *(hwdev->dma_mask);
+
+	if (dma_mask <= ISA_DMA_THRESHOLD)
+		flags |= GFP_DMA;
+#ifdef CONFIG_X86_64
+	else if (dma_mask <= DMA_32BIT_MASK)
+		flags |= GFP_DMA32;
+#endif
 
 	ret = (void *)__get_free_pages(flags, order);
 	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
-- 
1.5.3.7


