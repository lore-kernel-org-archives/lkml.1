Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbXEVIGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbXEVIGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbXEVIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:13 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:62652 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbXEVIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:11 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 5/15] x86-64: Calgary - abstract how we find the iommu_table for a device
Date: Tue, 22 May 2007 04:05:54 -0400
Message-Id: <11798211661041-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <1179821166685-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

... in preparation for doing it differently for CalIOC2.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index acee770..c5f92ea 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -344,6 +344,15 @@ static void iommu_free(struct iommu_tabl
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
+static inline struct iommu_table *find_iommu_table(struct device *dev)
+{
+	struct iommu_table *tbl;
+
+	tbl = to_pci_dev(dev)->bus->self->sysdata;
+
+	return tbl;
+}
+
 static void __calgary_unmap_sg(struct iommu_table *tbl,
 	struct scatterlist *sglist, int nelems, int direction)
 {
@@ -365,7 +374,7 @@ void calgary_unmap_sg(struct device *dev
 		      int nelems, int direction)
 {
 	unsigned long flags;
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 
 	if (!translate_phb(to_pci_dev(dev)))
 		return;
@@ -394,7 +403,7 @@ static int calgary_nontranslate_map_sg(s
 int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned long flags;
 	unsigned long vaddr;
 	unsigned int npages;
@@ -448,7 +457,7 @@ dma_addr_t calgary_map_single(struct dev
 	dma_addr_t dma_handle = bad_dma_address;
 	unsigned long uaddr;
 	unsigned int npages;
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
@@ -464,7 +473,7 @@ dma_addr_t calgary_map_single(struct dev
 void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
 	if (!translate_phb(to_pci_dev(dev)))
@@ -480,9 +489,7 @@ void* calgary_alloc_coherent(struct devi
 	void *ret = NULL;
 	dma_addr_t mapping;
 	unsigned int npages, order;
-	struct iommu_table *tbl;
-
-	tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = find_iommu_table(dev);
 
 	size = PAGE_ALIGN(size); /* size rounded up to full pages */
 	npages = size >> PAGE_SHIFT;
-- 
1.4.4

