Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYIHJMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYIHJMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYIHJMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:12:21 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48090 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbYIHJMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:12:20 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, joerg.roedel@amd.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 3/5] x86: fix nommu_alloc_coherent allocation with NULL device argument
Date: Mon,  8 Sep 2008 18:10:12 +0900
Message-Id: <1220865014-1169-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use __GFP_DMA for NULL device argument (fallback_dev) with
pci-nommu. It's a hack for ISA (and some old code) so we need to use
GFP_DMA.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c   |    3 +--
 include/asm-x86/dma-mapping.h |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 0f51883..ada1c87 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -80,7 +80,6 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	int node;
 	struct page *page;
 
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 	gfp |= __GFP_ZERO;
 
 	dma_mask = hwdev->coherent_dma_mask;
@@ -93,7 +92,7 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	node = dev_to_node(hwdev);
 
 #ifdef CONFIG_X86_64
-	if (dma_mask <= DMA_32BIT_MASK)
+	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
 
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 39d3641..9d6dcf4 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -248,6 +248,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	void *memory;
 
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
 
-- 
1.5.5.GIT

