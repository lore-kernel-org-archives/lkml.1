Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYIIQJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYIIQJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbYIIQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:54 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35996 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbYIIQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 3/4] x86: convert pci-nommu to use is_buffer_dma_capable helper function
Date: Wed, 10 Sep 2008 01:06:48 +0900
Message-Id: <1220976409-8417-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220976409-8417-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220976409-8417-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 8e398b5..1c1c98a 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -14,7 +14,7 @@
 static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 {
-	if (hwdev && bus + size > *hwdev->dma_mask) {
+	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
 		if (*hwdev->dma_mask >= DMA_32BIT_MASK)
 			printk(KERN_ERR
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
@@ -79,6 +79,7 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	unsigned long dma_mask;
 	int node;
 	struct page *page;
+	dma_addr_t addr;
 
 	dma_mask = dma_alloc_coherent_mask(hwdev, gfp);
 
@@ -90,14 +91,15 @@ again:
 	if (!page)
 		return NULL;
 
-	if ((page_to_phys(page) + size > dma_mask) && !(gfp & GFP_DMA)) {
+	addr = page_to_phys(page);
+	if (!is_buffer_dma_capable(dma_mask, addr, size) && !(gfp & GFP_DMA)) {
 		free_pages((unsigned long)page_address(page), get_order(size));
 		gfp |= GFP_DMA;
 		goto again;
 	}
 
-	*dma_addr = page_to_phys(page);
-	if (check_addr("alloc_coherent", hwdev, *dma_addr, size)) {
+	if (check_addr("alloc_coherent", hwdev, addr, size)) {
+		*dma_addr = addr;
 		flush_write_buffers();
 		return page_address(page);
 	}
-- 
1.5.4.2

