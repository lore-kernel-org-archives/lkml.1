Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZK0PKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZK0PKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZK0PK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:10:29 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:46675 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbZK0PK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 10:10:28 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KTRWSV-02-504-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/34] x86/amd-iommu: Use check_device in get_device_resources
Date: Fri, 27 Nov 2009 14:55:25 +0100
Message-ID: <1259330145-14865-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0139 (UTC) FILETIME=[52977FB0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every call-place of get_device_resources calls check_device
before it. So call it from get_device_resources directly and
simplify the code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   86 ++++++++++++++-----------------------------
 1 files changed, 28 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ac27b1d..c5102eb 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1432,35 +1432,24 @@ static struct dma_ops_domain *find_protection_domain(u16 devid)
  * If the device is not yet associated with a domain this is also done
  * in this function.
  */
-static int get_device_resources(struct device *dev,
-				struct amd_iommu **iommu,
-				struct protection_domain **domain,
-				u16 *bdf)
+static bool get_device_resources(struct device *dev,
+				 struct amd_iommu **iommu,
+				 struct protection_domain **domain,
+				 u16 *bdf)
 {
 	struct dma_ops_domain *dma_dom;
 	struct pci_dev *pcidev;
 	u16 _bdf;
 
-	*iommu = NULL;
-	*domain = NULL;
-	*bdf = 0xffff;
-
-	if (dev->bus != &pci_bus_type)
-		return 0;
-
-	pcidev = to_pci_dev(dev);
-	_bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
-
-	/* device not translated by any IOMMU in the system? */
-	if (_bdf > amd_iommu_last_bdf)
-		return 0;
-
-	*bdf = amd_iommu_alias_table[_bdf];
+	if (!check_device(dev))
+		return false;
 
-	*iommu = amd_iommu_rlookup_table[*bdf];
-	if (*iommu == NULL)
-		return 0;
+	pcidev  = to_pci_dev(dev);
+	_bdf    = calc_devid(pcidev->bus->number, pcidev->devfn);
+	*bdf    = amd_iommu_alias_table[_bdf];
+	*iommu  = amd_iommu_rlookup_table[*bdf];
 	*domain = domain_for_device(*bdf);
+
 	if (*domain == NULL) {
 		dma_dom = find_protection_domain(*bdf);
 		if (!dma_dom)
@@ -1474,7 +1463,7 @@ static int get_device_resources(struct device *dev,
 	if (domain_for_device(_bdf) == NULL)
 		attach_device(*iommu, *domain, _bdf);
 
-	return 1;
+	return true;
 }
 
 static void update_device_table(struct protection_domain *domain)
@@ -1797,17 +1786,12 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 
 	INC_STATS_COUNTER(cnt_map_single);
 
-	if (!check_device(dev))
-		return DMA_ERROR_CODE;
-
-	dma_mask = *dev->dma_mask;
-
-	get_device_resources(dev, &iommu, &domain, &devid);
-
-	if (iommu == NULL || domain == NULL)
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
 		/* device not handled by any AMD IOMMU */
 		return (dma_addr_t)paddr;
 
+	dma_mask = *dev->dma_mask;
+
 	if (!dma_ops_domain(domain))
 		return DMA_ERROR_CODE;
 
@@ -1838,8 +1822,7 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	INC_STATS_COUNTER(cnt_unmap_single);
 
-	if (!check_device(dev) ||
-	    !get_device_resources(dev, &iommu, &domain, &devid))
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
 		/* device not handled by any AMD IOMMU */
 		return;
 
@@ -1893,16 +1876,11 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 
 	INC_STATS_COUNTER(cnt_map_sg);
 
-	if (!check_device(dev))
-		return 0;
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
+		return map_sg_no_iommu(dev, sglist, nelems, dir);
 
 	dma_mask = *dev->dma_mask;
 
-	get_device_resources(dev, &iommu, &domain, &devid);
-
-	if (!iommu || !domain)
-		return map_sg_no_iommu(dev, sglist, nelems, dir);
-
 	if (!dma_ops_domain(domain))
 		return 0;
 
@@ -1958,8 +1936,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 
 	INC_STATS_COUNTER(cnt_unmap_sg);
 
-	if (!check_device(dev) ||
-	    !get_device_resources(dev, &iommu, &domain, &devid))
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
 		return;
 
 	if (!dma_ops_domain(domain))
@@ -1994,24 +1971,22 @@ static void *alloc_coherent(struct device *dev, size_t size,
 
 	INC_STATS_COUNTER(cnt_alloc_coherent);
 
-	if (!check_device(dev))
-		return NULL;
+	if (!get_device_resources(dev, &iommu, &domain, &devid)) {
+		virt_addr = (void *)__get_free_pages(flag, get_order(size));
+		*dma_addr = __pa(virt_addr);
+		return virt_addr;
+	}
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
-		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	dma_mask  = dev->coherent_dma_mask;
+	flag     &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	flag     |= __GFP_ZERO;
 
-	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return NULL;
 
 	paddr = virt_to_phys(virt_addr);
 
-	if (!iommu || !domain) {
-		*dma_addr = (dma_addr_t)paddr;
-		return virt_addr;
-	}
-
 	if (!dma_ops_domain(domain))
 		goto out_free;
 
@@ -2054,12 +2029,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	INC_STATS_COUNTER(cnt_free_coherent);
 
-	if (!check_device(dev))
-		return;
-
-	get_device_resources(dev, &iommu, &domain, &devid);
-
-	if (!iommu || !domain)
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
 		goto free_mem;
 
 	if (!dma_ops_domain(domain))
-- 
1.6.5.3


