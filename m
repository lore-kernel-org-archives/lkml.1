Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXIUVDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXIUVDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764670AbXIUU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:57:09 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:4637 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762932AbXIUU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:57:07 -0400
Date: Fri, 21 Sep 2007 22:57:04 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: bernarde@br.ibm.com, Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 1/2] x86-64: Calgary - fix calgary=disable=<busnum> for CalIOC2
Message-ID: <20070921205704.GB7640@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The old check we used based on dev->bus->number is wrong for devices
on CalIOC2. Instead look whether we have an IOMMU table for that bus -
if not, translation is disabled.

Thanks to Murillo Fernandes Bernardes <bernarde@br.ibm.com> for
spotting, suggesting a fix and testing.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Acked-by: Murillo Fernandes Bernardes <bernarde@br.ibm.com>
---
Andi, This is Calgary 2.6.24 material - please apply.

 pci-calgary.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff -r ca20f7bdb869 -r c9308d0538d9 arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c	Sun Aug 12 11:38:08 2007 +0300
+++ b/arch/x86_64/kernel/pci-calgary.c	Sun Aug 12 11:43:49 2007 +0300
@@ -220,6 +220,12 @@ static inline unsigned int num_dma_pages
 	return npages;
 }
 
+static inline int translation_enabled(struct iommu_table *tbl)
+{
+	/* only PHBs with translation enabled have an IOMMU table */
+	return (tbl != NULL);
+}
+
 static inline int translate_phb(struct pci_dev* dev)
 {
 	int disabled = bus_info[dev->bus->number].translation_disabled;
@@ -384,7 +390,7 @@ static void calgary_unmap_sg(struct devi
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translation_enabled(tbl))
 		return;
 
 	while (nelems--) {
@@ -424,7 +430,7 @@ static int calgary_map_sg(struct device 
 	unsigned long entry;
 	int i;
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translation_enabled(tbl))
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
 	for (i = 0; i < nelems; i++ ) {
@@ -471,7 +477,7 @@ static dma_addr_t calgary_map_single(str
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
 
-	if (translate_phb(to_pci_dev(dev)))
+	if (translation_enabled(tbl))
 		dma_handle = iommu_alloc(tbl, vaddr, npages, direction);
 	else
 		dma_handle = virt_to_bus(vaddr);
@@ -485,7 +491,7 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translation_enabled(tbl))
 		return;
 
 	npages = num_dma_pages(dma_handle, size);
@@ -510,7 +516,7 @@ static void* calgary_alloc_coherent(stru
 		goto error;
 	memset(ret, 0, size);
 
-	if (translate_phb(to_pci_dev(dev))) {
+	if (translation_enabled(tbl)) {
 		/* set up tces to cover the allocated range */
 		mapping = iommu_alloc(tbl, ret, npages, DMA_BIDIRECTIONAL);
 		if (mapping == bad_dma_address)
