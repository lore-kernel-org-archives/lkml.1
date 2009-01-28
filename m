Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZA1MzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZA1MzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 07:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZA1MzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 07:55:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:59178 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZA1MzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 07:55:05 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu, tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH -tip 1/3] IA64: fix swiotlb alloc_coherent for non DMA_64BIT_MASK devices
Date: Wed, 28 Jan 2009 21:53:16 +0900
Message-Id: <1233147198-30299-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the dma ops unification, IA64 always uses GFP_DMA for
dma_alloc_coherent like:

#define dma_alloc_coherent(dev, size, handle, gfp)	\
	platform_dma_alloc_coherent(dev, size, handle, (gfp) | GFP_DMA)

This GFP_DMA enforcement doesn't make sense for IOMMUs since they can
do address translation to give addresses that devices can access
to. The IOMMU drivers ignore the zone flag. However, this is still
necessary for swiotlb since it can't do address translation.

We don't always need to use GFP_DMA for swiotlb. We need GFP_DMA for
devices incapable of 64bit DMA.

This patch is sorta updated version of:

http://marc.info/?l=linux-kernel&m=122638215612705&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 arch/ia64/kernel/pci-swiotlb.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 717ad4f..573f02c 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -13,8 +13,16 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
+static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
+					 dma_addr_t *dma_handle, gfp_t gfp)
+{
+	if (dev->coherent_dma_mask != DMA_64BIT_MASK)
+		gfp |= GFP_DMA;
+	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
+}
+
 struct dma_map_ops swiotlb_dma_ops = {
-	.alloc_coherent = swiotlb_alloc_coherent,
+	.alloc_coherent = ia64_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
-- 
1.6.0.6

