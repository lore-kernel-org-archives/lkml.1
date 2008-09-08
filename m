Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYIHJ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYIHJ4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYIHJzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:55:20 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:48721 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYIHJzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:55:18 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tony.luck@intel.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] swiotlb: add is_swiotlb_buffer helper function
Date: Mon,  8 Sep 2008 18:53:50 +0900
Message-Id: <1220867630-1995-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220867630-1995-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220867630-1995-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220867630-1995-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds is_swiotlb_buffer() helper function to see whether a buffer
belongs to the swiotlb buffer or not.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bf61c73..b5f5d11 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -283,6 +283,11 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr)
 	return (addr & ~mask) != 0;
 }
 
+static int is_swiotlb_buffer(char *addr)
+{
+	return addr >= io_tlb_start && addr < io_tlb_end;
+}
+
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
@@ -508,8 +513,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		      dma_addr_t dma_handle)
 {
 	WARN_ON(irqs_disabled());
-	if (!(vaddr >= (void *)io_tlb_start
-                    && vaddr < (void *)io_tlb_end))
+	if (!is_swiotlb_buffer(vaddr))
 		free_pages((unsigned long) vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
@@ -602,7 +606,7 @@ swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
+	if (is_swiotlb_buffer(dma_addr))
 		unmap_single(hwdev, dma_addr, size, dir);
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
@@ -632,7 +636,7 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
+	if (is_swiotlb_buffer(dma_addr))
 		sync_single(hwdev, dma_addr, size, dir, target);
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
@@ -663,7 +667,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = bus_to_virt(dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
-	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
+	if (is_swiotlb_buffer(dma_addr))
 		sync_single(hwdev, dma_addr, size, dir, target);
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
-- 
1.5.5.GIT

