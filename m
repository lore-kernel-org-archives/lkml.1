Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZK0N64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZK0N64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZK0N6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:58:55 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:38562
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753280AbZK0N4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:01 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD5-01-6RR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/34] x86/amd-iommu: Remove iommu specific handling from dma_ops path
Date: Fri, 27 Nov 2009 14:55:29 +0100
Message-ID: <1259330145-14865-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0576 (UTC) FILETIME=[52DA2E00:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch finishes the removal of all iommu specific
handling code in the dma_ops path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c04dcb7..2cd5800 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1436,11 +1436,11 @@ static struct dma_ops_domain *find_protection_domain(u16 devid)
  * in this function.
  */
 static bool get_device_resources(struct device *dev,
-				 struct amd_iommu **iommu,
 				 struct protection_domain **domain,
 				 u16 *bdf)
 {
 	struct dma_ops_domain *dma_dom;
+	struct amd_iommu *iommu;
 	struct pci_dev *pcidev;
 	u16 _bdf;
 
@@ -1450,21 +1450,21 @@ static bool get_device_resources(struct device *dev,
 	pcidev  = to_pci_dev(dev);
 	_bdf    = calc_devid(pcidev->bus->number, pcidev->devfn);
 	*bdf    = amd_iommu_alias_table[_bdf];
-	*iommu  = amd_iommu_rlookup_table[*bdf];
+	iommu   = amd_iommu_rlookup_table[*bdf];
 	*domain = domain_for_device(*bdf);
 
 	if (*domain == NULL) {
 		dma_dom = find_protection_domain(*bdf);
 		if (!dma_dom)
-			dma_dom = (*iommu)->default_dom;
+			dma_dom = iommu->default_dom;
 		*domain = &dma_dom->domain;
-		attach_device(*iommu, *domain, *bdf);
+		attach_device(iommu, *domain, *bdf);
 		DUMP_printk("Using protection domain %d for device %s\n",
 			    (*domain)->id, dev_name(dev));
 	}
 
 	if (domain_for_device(_bdf) == NULL)
-		attach_device(*iommu, *domain, _bdf);
+		attach_device(iommu, *domain, _bdf);
 
 	return true;
 }
@@ -1776,7 +1776,6 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 			   struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
 	u16 devid;
 	dma_addr_t addr;
@@ -1785,7 +1784,7 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 
 	INC_STATS_COUNTER(cnt_map_single);
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!get_device_resources(dev, &domain, &devid))
 		/* device not handled by any AMD IOMMU */
 		return (dma_addr_t)paddr;
 
@@ -1815,13 +1814,12 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
 	u16 devid;
 
 	INC_STATS_COUNTER(cnt_unmap_single);
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!get_device_resources(dev, &domain, &devid))
 		/* device not handled by any AMD IOMMU */
 		return;
 
@@ -1864,7 +1862,6 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 		  struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
 	u16 devid;
 	int i;
@@ -1875,7 +1872,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 
 	INC_STATS_COUNTER(cnt_map_sg);
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!get_device_resources(dev, &domain, &devid))
 		return map_sg_no_iommu(dev, sglist, nelems, dir);
 
 	dma_mask = *dev->dma_mask;
@@ -1927,7 +1924,6 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		     struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
 	struct scatterlist *s;
 	u16 devid;
@@ -1935,7 +1931,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 
 	INC_STATS_COUNTER(cnt_unmap_sg);
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!get_device_resources(dev, &domain, &devid))
 		return;
 
 	if (!dma_ops_domain(domain))
@@ -1962,7 +1958,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
 {
 	unsigned long flags;
 	void *virt_addr;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
 	u16 devid;
 	phys_addr_t paddr;
@@ -1970,7 +1965,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 
 	INC_STATS_COUNTER(cnt_alloc_coherent);
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid)) {
+	if (!get_device_resources(dev, &domain, &devid)) {
 		virt_addr = (void *)__get_free_pages(flag, get_order(size));
 		*dma_addr = __pa(virt_addr);
 		return virt_addr;
@@ -2022,13 +2017,12 @@ static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
 	u16 devid;
 
 	INC_STATS_COUNTER(cnt_free_coherent);
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!get_device_resources(dev, &domain, &devid))
 		goto free_mem;
 
 	if (!dma_ops_domain(domain))
-- 
1.6.5.3


