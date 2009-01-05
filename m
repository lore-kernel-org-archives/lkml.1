Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZAEOvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZAEOvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZAEOui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:50:38 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57763 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbZAEOug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:50:36 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/8] swiotlb: add map_page and unmap_page
Date: Mon,  5 Jan 2009 23:47:22 +0900
Message-Id: <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of struct dma_mapping_ops unification. We use
map_page and unmap_page instead of map_single and unmap_single.

This is sorta temporary workaround. We will move them to lib/swiotlb.c
to enable x86's swiotlb code to directly use them.

We will remove map_single and unmap_single hooks in the last patch in
this patchset.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb_64.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index d59c917..d1c0366 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -45,6 +45,23 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
+/* these will be moved to lib/swiotlb.c later on */
+
+static dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
+{
+	return swiotlb_map_single(dev, page_address(page) + offset, size, dir);
+}
+
+static void swiotlb_unmap_page(struct device *dev, dma_addr_t dma_handle,
+			       size_t size, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
+{
+	swiotlb_unmap_single(dev, dma_handle, size, dir);
+}
+
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
@@ -71,6 +88,8 @@ struct dma_mapping_ops swiotlb_dma_ops = {
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
 	.map_sg = swiotlb_map_sg,
 	.unmap_sg = swiotlb_unmap_sg,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
 	.dma_supported = NULL,
 };
 
-- 
1.6.0.6

