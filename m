Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYIEJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYIEJDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbYIEJD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:03:28 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34915 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbYIEJDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:03:25 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH] x86: fix nommu_alloc_coherent allocation with NULL device argument
Date: Fri,  5 Sep 2008 17:58:47 +0900
Message-Id: <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use __GFP_DMA for NULL device argument (fallback_dev) with
pci-nommu. It's a hack for ISA (and some old code) so we need to use
GFP_DMA.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c   |    5 +----
 include/asm-x86/dma-mapping.h |    2 ++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 73853d3..526b2db 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -83,7 +83,6 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	if (hwdev->dma_mask == NULL)
 		return NULL;
 
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 	gfp |= __GFP_ZERO;
 
 	dma_mask = hwdev->coherent_dma_mask;
@@ -96,14 +95,12 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	node = dev_to_node(hwdev);
 
 #ifdef CONFIG_X86_64
-	if (dma_mask <= DMA_32BIT_MASK)
+	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
-
 	/* No alloc-free penalty for ISA devices */
 	if (dma_mask == DMA_24BIT_MASK)
 		gfp |= GFP_DMA;
-
 again:
 	page = alloc_pages_node(node, gfp, get_order(size));
 	if (!page)
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 3a9a6f5..de4495e 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -246,6 +246,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	void *memory;
 
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
 
-- 
1.5.4.2

