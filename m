Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYHLP0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYHLP0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYHLPZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:25:22 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:49126 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYHLPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:25:21 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K5HUTH-03-1L2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/7] x86: add alloc_coherent dma_ops callback to NOMMU driver
Date: Tue, 12 Aug 2008 17:24:14 +0200
Message-ID: <1218554657-16070-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 15:24:18.0164 (UTC) FILETIME=[7CA30340:01C8FC8F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-nommu.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 3f91f71..4d8cde3 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -72,7 +72,45 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
+static void *
+nommu_alloc_coherent(struct device *hwdev, size_t size,
+		     dma_addr_t *dma_addr, gfp_t gfp)
+{
+	unsigned long dma_mask;
+	int node;
+	struct page *page;
+
+	if (hwdev->dma_mask == NULL)
+		return NULL;
+
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	gfp |= __GFP_ZERO;
+
+	dma_mask = hwdev->coherent_dma_mask;
+	if (!dma_mask)
+		dma_mask = *(hwdev->dma_mask);
+
+	if (dma_mask <= DMA_24BIT_MASK)
+		gfp |= GFP_DMA;
+	else if (dma_mask <= DMA_32BIT_MASK)
+		gfp |= GFP_DMA32;
+
+	node = dev_to_node(hwdev);
+	page = alloc_pages_node(node, gfp, get_order(size));
+	if (!page)
+		return NULL;
+
+	*dma_addr = page_to_phys(page);
+	if (check_addr("alloc_coherent", hwdev, *dma_addr, size))
+		return page_address(page);
+
+	free_pages((unsigned long)page_address(page), get_order(size));
+
+	return NULL;
+}
+
 struct dma_mapping_ops nommu_dma_ops = {
+	.alloc_coherent = nommu_alloc_coherent,
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
 	.is_phys = 1,
-- 
1.5.3.7


