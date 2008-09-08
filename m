Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYIHJNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYIHJNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYIHJMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:12:31 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:42532 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbYIHJMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:12:30 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, joerg.roedel@amd.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/5] x86: move pci-nommu's dma_mask check to common code
Date: Mon,  8 Sep 2008 18:10:11 +0900
Message-Id: <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check to see if dev->dma_mask is NULL in pci-nommu is more
appropriate for dma_alloc_coherent().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c   |    3 ---
 include/asm-x86/dma-mapping.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 73853d3..0f51883 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -80,9 +80,6 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	int node;
 	struct page *page;
 
-	if (hwdev->dma_mask == NULL)
-		return NULL;
-
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 	gfp |= __GFP_ZERO;
 
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index bc6c8df..39d3641 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -256,6 +256,9 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp |= GFP_DMA;
 	}
 
+	if (!dev->dma_mask)
+		return NULL;
+
 	if (ops->alloc_coherent)
 		return ops->alloc_coherent(dev, size,
 				dma_handle, gfp);
-- 
1.5.5.GIT

