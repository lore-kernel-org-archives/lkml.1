Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZAEOwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZAEOwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZAEOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:50:42 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53984 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZAEOul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:50:41 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 7/8] pci-nommu: add map_page
Date: Mon,  5 Jan 2009 23:47:27 +0900
Message-Id: <1231166848-20149-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166848-20149-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of struct dma_mapping_ops unification. We use
map_page and unmap_page instead of map_single and unmap_single.

We will remove map_single hook in the last patch in this patchset.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index c70ab5a..5a73a82 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -25,18 +25,25 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 	return 1;
 }
 
-static dma_addr_t
-nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
-	       int direction)
+static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction dir,
+				 struct dma_attrs *attrs)
 {
-	dma_addr_t bus = paddr;
+	dma_addr_t bus = page_to_phys(page) + offset;
 	WARN_ON(size == 0);
-	if (!check_addr("map_single", hwdev, bus, size))
-				return bad_dma_address;
+	if (!check_addr("map_single", dev, bus, size))
+		return bad_dma_address;
 	flush_write_buffers();
 	return bus;
 }
 
+static dma_addr_t nommu_map_single(struct device *hwdev, phys_addr_t paddr,
+				   size_t size, int direction)
+{
+	return nommu_map_page(hwdev, pfn_to_page(paddr >> PAGE_SHIFT),
+			      paddr & ~PAGE_MASK, size, direction, NULL);
+}
 
 /* Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scatter-gather version of the
@@ -83,6 +90,7 @@ struct dma_mapping_ops nommu_dma_ops = {
 	.free_coherent = nommu_free_coherent,
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
+	.map_page = nommu_map_page,
 	.is_phys = 1,
 };
 
-- 
1.6.0.6

