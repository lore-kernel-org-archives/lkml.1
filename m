Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZAEOxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZAEOxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbZAEOuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:50:55 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57790 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbZAEOuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:50:54 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 6/8] intel-iommu: add map_page and unmap_page
Date: Mon,  5 Jan 2009 23:47:26 +0900
Message-Id: <1231166848-20149-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166848-20149-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of struct dma_mapping_ops unification. We use
map_page and unmap_page instead of map_single and unmap_single.

This uses a temporary workaround, ifdef X86_64 to avoid IA64
build. The workaround will be removed after the unification. Well,
changing x86's struct dma_mapping_ops could break IA64. It's just
wrong. It's one of problems that this patchset fixes.

We will remove map_single and unmap_single hooks in the last patch in
this patchset.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/pci/intel-iommu.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 235fb7a..60258ec 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2273,6 +2273,15 @@ error:
 	return 0;
 }
 
+static dma_addr_t intel_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction dir,
+				 struct dma_attrs *attrs)
+{
+	return __intel_map_single(dev, page_to_phys(page) + offset, size,
+				  dir, to_pci_dev(dev)->dma_mask);
+}
+
 dma_addr_t intel_map_single(struct device *hwdev, phys_addr_t paddr,
 			    size_t size, int dir)
 {
@@ -2341,8 +2350,9 @@ static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
 }
 
-void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
-			int dir)
+static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
+			     size_t size, enum dma_data_direction dir,
+			     struct dma_attrs *attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
@@ -2386,6 +2396,12 @@ void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
 	}
 }
 
+void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
+			int dir)
+{
+	intel_unmap_page(dev, dev_addr, size, dir, NULL);
+}
+
 void *intel_alloc_coherent(struct device *hwdev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flags)
 {
@@ -2570,6 +2586,10 @@ static struct dma_mapping_ops intel_dma_ops = {
 	.unmap_single = intel_unmap_single,
 	.map_sg = intel_map_sg,
 	.unmap_sg = intel_unmap_sg,
+#ifdef CONFIG_X86_64
+	.map_page = intel_map_page,
+	.unmap_page = intel_unmap_page,
+#endif
 };
 
 static inline int iommu_domain_cache_init(void)
-- 
1.6.0.6

