Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYIRRCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYIRRCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYIRRCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:02:37 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:33087 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbYIRRCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:02:36 -0400
Date: Fri, 19 Sep 2008 02:02:05 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: [PATCH] convert swiotlb to use dma_get_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919020137Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against tip/x86/iommu.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] convert swiotlb to use dma_get_mask

swiotlb can use dma_get_mask() instead of the homegrown function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |    2 +-
 lib/swiotlb.c               |    6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 0dba743..ba9114e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -65,7 +65,7 @@ static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
 
 static inline u64 dma_get_mask(struct device *dev)
 {
-	if (dev->dma_mask && *dev->dma_mask)
+	if (dev && dev->dma_mask && *dev->dma_mask)
 		return *dev->dma_mask;
 	return DMA_32BIT_MASK;
 }
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 240a67c..f8eebd4 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -276,11 +276,7 @@ cleanup1:
 static int
 address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 {
-	dma_addr_t mask = 0xffffffff;
-	/* If the device has a mask, use it, otherwise default to 32 bits */
-	if (hwdev && hwdev->dma_mask)
-		mask = *hwdev->dma_mask;
-	return !is_buffer_dma_capable(mask, addr, size);
+	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
 }
 
 static int is_swiotlb_buffer(char *addr)
-- 
1.5.4.2

