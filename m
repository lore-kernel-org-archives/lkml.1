Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZAEOwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZAEOwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZAEOuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:50:44 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53986 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZAEOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:50:43 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/8] AMD IOMMU: add map_page and unmap_page
Date: Mon,  5 Jan 2009 23:47:25 +0900
Message-Id: <1231166848-20149-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of struct dma_mapping_ops unification. We use
map_page and unmap_page instead of map_single and unmap_single.

We will remove map_single and unmap_single hooks in the last patch in
this patchset.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5113c08..8570441 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -22,6 +22,7 @@
 #include <linux/bitops.h>
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 #include <linux/iommu-helper.h>
 #ifdef CONFIG_IOMMU_API
 #include <linux/iommu.h>
@@ -1297,8 +1298,10 @@ static void __unmap_single(struct amd_iommu *iommu,
 /*
  * The exported map_single function for dma_ops.
  */
-static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
-			     size_t size, int dir)
+static dma_addr_t map_page(struct device *dev, struct page *page,
+			   unsigned long offset, size_t size,
+			   enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1306,6 +1309,7 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	u16 devid;
 	dma_addr_t addr;
 	u64 dma_mask;
+	phys_addr_t paddr = page_to_phys(page) + offset;
 
 	INC_STATS_COUNTER(cnt_map_single);
 
@@ -1337,11 +1341,18 @@ out:
 	return addr;
 }
 
+static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
+			     size_t size, int dir)
+{
+	return map_page(dev, pfn_to_page(paddr >> PAGE_SHIFT),
+			paddr & ~PAGE_MASK, size, dir, NULL);
+}
+
 /*
  * The exported unmap_single function for dma_ops.
  */
-static void unmap_single(struct device *dev, dma_addr_t dma_addr,
-			 size_t size, int dir)
+static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1367,6 +1378,12 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
+static void unmap_single(struct device *dev, dma_addr_t dma_addr,
+			 size_t size, int dir)
+{
+	return unmap_page(dev, dma_addr, size, dir, NULL);
+}
+
 /*
  * This is a special map_sg function which is used if we should map a
  * device which is not handled by an AMD IOMMU in the system.
@@ -1649,6 +1666,8 @@ static struct dma_mapping_ops amd_iommu_dma_ops = {
 	.free_coherent = free_coherent,
 	.map_single = map_single,
 	.unmap_single = unmap_single,
+	.map_page = map_page,
+	.unmap_page = unmap_page,
 	.map_sg = map_sg,
 	.unmap_sg = unmap_sg,
 	.dma_supported = amd_iommu_dma_supported,
-- 
1.6.0.6

