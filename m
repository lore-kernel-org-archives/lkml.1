Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbXGKNfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbXGKNfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763075AbXGKNfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:35:22 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:61556 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761713AbXGKNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:35:18 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, jdmason@kudzu.us
Subject: [PATCH 3/4] x86-64: Calgary - fold in redundant functions
Date: Wed, 11 Jul 2007 16:35:13 +0300
Message-Id: <11841609143965-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11841609142004-git-send-email-muli@il.ibm.com>
References: <11841609143732-git-send-email-muli@il.ibm.com>
 <11841609141802-git-send-email-muli@il.ibm.com>
 <11841609142004-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

After the bitmap changes we can get rid of the unlocked versions of
calgary_unmap_sg and iommu_free. Fold __calgary_unmap_sg and
__iommu_free into their calgary_unmap_sg and iommu_free, respectively.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   30 +++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 28ce2b3..c0cdba7 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -323,7 +323,7 @@ error:
 	return bad_dma_address;
 }
 
-static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
+static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned int npages)
 {
 	unsigned long entry;
@@ -361,12 +361,6 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
-static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
-	unsigned int npages)
-{
-	__iommu_free(tbl, dma_addr, npages);
-}
-
 static inline struct iommu_table *find_iommu_table(struct device *dev)
 {
 	struct pci_dev *pdev;
@@ -389,9 +383,14 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 	return tbl;
 }
 
-static void __calgary_unmap_sg(struct iommu_table *tbl,
+static void calgary_unmap_sg(struct device *dev,
 	struct scatterlist *sglist, int nelems, int direction)
 {
+	struct iommu_table *tbl = find_iommu_table(dev);
+
+	if (!translate_phb(to_pci_dev(dev)))
+		return;
+
 	while (nelems--) {
 		unsigned int npages;
 		dma_addr_t dma = sglist->dma_address;
@@ -401,22 +400,11 @@ static void __calgary_unmap_sg(struct iommu_table *tbl,
 			break;
 
 		npages = num_dma_pages(dma, dmalen);
-		__iommu_free(tbl, dma, npages);
+		iommu_free(tbl, dma, npages);
 		sglist++;
 	}
 }
 
-void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
-		      int nelems, int direction)
-{
-	struct iommu_table *tbl = find_iommu_table(dev);
-
-	if (!translate_phb(to_pci_dev(dev)))
-		return;
-
-	__calgary_unmap_sg(tbl, sglist, nelems, direction);
-}
-
 static int calgary_nontranslate_map_sg(struct device* dev,
 	struct scatterlist *sg, int nelems, int direction)
 {
@@ -468,7 +456,7 @@ int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 
 	return nelems;
 error:
-	__calgary_unmap_sg(tbl, sg, nelems, direction);
+	calgary_unmap_sg(dev, sg, nelems, direction);
 	for (i = 0; i < nelems; i++) {
 		sg[i].dma_address = bad_dma_address;
 		sg[i].dma_length = 0;
-- 
1.5.2

