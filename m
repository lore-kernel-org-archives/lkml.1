Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYHSOd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYHSOd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYHSOc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:32:59 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:41051 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbYHSOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:32:58 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K5UR2L-03-AJ4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/8] x86: add alloc_coherent dma_ops callback to NOMMU driver
Date: Tue, 19 Aug 2008 16:32:42 +0200
Message-ID: <1219156366-32498-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0640 (UTC) FILETIME=[72D62300:01C90208]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-nommu.c |   55 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 3f91f71..b8ce83c 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -72,7 +72,62 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
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
+	if (dma_mask < DMA_24BIT_MASK)
+		return NULL;
+
+	node = dev_to_node(hwdev);
+
+#ifdef CONFIG_X86_64
+	if (dma_mask <= DMA_32BIT_MASK)
+		gfp |= GFP_DMA32;
+#endif
+
+	/* No alloc-free penalty for ISA devices */
+	if (dma_mask == DMA_24BIT_MASK)
+		gfp |= GFP_DMA;
+
+again:
+	page = alloc_pages_node(node, gfp, get_order(size));
+	if (!page)
+		return NULL;
+
+	if ((page_to_phys(page) + size > dma_mask) && !(gfp & GFP_DMA)) {
+		free_pages((unsigned long)page_address(page), get_order(size));
+		gfp |= GFP_DMA;
+		goto again;
+	}
+
+	*dma_addr = page_to_phys(page);
+	if (check_addr("alloc_coherent", hwdev, *dma_addr, size)) {
+		flush_write_buffers();
+		return page_address(page);
+	}
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


