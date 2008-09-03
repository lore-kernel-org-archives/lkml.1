Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYICSPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYICSPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYICSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:14:59 -0400
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:36078 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYICSO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:14:58 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: joerg.roedel@amd.com, mingo@redhat.com, tony.luck@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com, iommu@lists.linux-foundation.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] x86: set gfp flag properly for swiotlb_alloc_coherent
Date: Thu,  4 Sep 2008 03:04:24 +0900
Message-Id: <1220465065-10533-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220465065-10533-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
 <1220465065-10533-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220465065-10533-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tries to avoid GFP_DMA zone unless absolutely needed (and set gfp
flag to use GFP_DMA zone properly if necessary).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb_64.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index f3d8d0e..3f4d9b4 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -23,11 +23,29 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 static void *x86_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_handle, gfp_t gfp)
 {
+	unsigned long dma_mask;
+
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	if (!dev) {
 		dev = &x86_dma_fallback_dev;
 		gfp |= GFP_DMA;
 	}
 
+	if (!dev->dma_mask)
+		return NULL;
+
+	dma_mask = dev->coherent_dma_mask;
+	if (!dma_mask)
+		dma_mask = gfp & GFP_DMA ? DMA_24BIT_MASK : DMA_32BIT_MASK;
+
+	if (!(gfp & GFP_DMA)) {
+		if (dma_mask <= DMA_24BIT_MASK)
+			gfp |= GFP_DMA;
+		else if (dma_mask <= DMA_32BIT_MASK)
+			gfp |= GFP_DMA32;
+	}
+
 	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
 }
 
-- 
1.5.5.GIT

