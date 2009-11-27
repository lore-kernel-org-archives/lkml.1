Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZK0OA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZK0OA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZK0OA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:00:57 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:14501
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982AbZK0Nzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:55 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD3-02-34R-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/34] x86/amd-iommu: Simplify get_device_resources()
Date: Fri, 27 Nov 2009 14:55:31 +0100
Message-ID: <1259330145-14865-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0326 (UTC) FILETIME=[52B40860:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous changes the get_device_resources function
can be simplified even more. The only important information
for the callers is the protection domain.
This patch renames the function to get_domain() and let it
only return the protection domain for a device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   86 ++++++++++++++++++-------------------------
 1 files changed, 36 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 75470ff..e5bbe9a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1463,6 +1463,7 @@ static struct dma_ops_domain *find_protection_domain(u16 devid)
 {
 	struct dma_ops_domain *entry, *ret = NULL;
 	unsigned long flags;
+	u16 alias = amd_iommu_alias_table[devid];
 
 	if (list_empty(&iommu_pd_list))
 		return NULL;
@@ -1470,7 +1471,8 @@ static struct dma_ops_domain *find_protection_domain(u16 devid)
 	spin_lock_irqsave(&iommu_pd_list_lock, flags);
 
 	list_for_each_entry(entry, &iommu_pd_list, list) {
-		if (entry->target_dev == devid) {
+		if (entry->target_dev == devid ||
+		    entry->target_dev == alias) {
 			ret = entry;
 			break;
 		}
@@ -1488,33 +1490,31 @@ static struct dma_ops_domain *find_protection_domain(u16 devid)
  * If the device is not yet associated with a domain this is also done
  * in this function.
  */
-static bool get_device_resources(struct device *dev,
-				 struct protection_domain **domain,
-				 u16 *bdf)
+static struct protection_domain *get_domain(struct device *dev)
 {
+	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
-	struct amd_iommu *iommu;
+	u16 devid = get_device_id(dev);
 
 	if (!check_device(dev))
-		return false;
+		return ERR_PTR(-EINVAL);
 
-	*bdf    = get_device_id(dev);
-	*domain = domain_for_device(dev);
-	iommu   = amd_iommu_rlookup_table[*bdf];
+	domain = domain_for_device(dev);
+	if (domain != NULL && !dma_ops_domain(domain))
+		return ERR_PTR(-EBUSY);
 
-	if (*domain != NULL)
-		return true;
+	if (domain != NULL)
+		return domain;
 
 	/* Device not bount yet - bind it */
-	dma_dom = find_protection_domain(*bdf);
+	dma_dom = find_protection_domain(devid);
 	if (!dma_dom)
-		dma_dom = iommu->default_dom;
-	*domain = &dma_dom->domain;
-	attach_device(dev, *domain);
+		dma_dom = amd_iommu_rlookup_table[devid]->default_dom;
+	attach_device(dev, &dma_dom->domain);
 	DUMP_printk("Using protection domain %d for device %s\n",
-		    (*domain)->id, dev_name(dev));
+		    dma_dom->domain.id, dev_name(dev));
 
-	return true;
+	return &dma_dom->domain;
 }
 
 static void update_device_table(struct protection_domain *domain)
@@ -1825,23 +1825,22 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 {
 	unsigned long flags;
 	struct protection_domain *domain;
-	u16 devid;
 	dma_addr_t addr;
 	u64 dma_mask;
 	phys_addr_t paddr = page_to_phys(page) + offset;
 
 	INC_STATS_COUNTER(cnt_map_single);
 
-	if (!get_device_resources(dev, &domain, &devid))
-		/* device not handled by any AMD IOMMU */
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL)
 		return (dma_addr_t)paddr;
+	else if (IS_ERR(domain))
+		return DMA_ERROR_CODE;
 
 	dma_mask = *dev->dma_mask;
 
-	if (!dma_ops_domain(domain))
-		return DMA_ERROR_CODE;
-
 	spin_lock_irqsave(&domain->lock, flags);
+
 	addr = __map_single(dev, domain->priv, paddr, size, dir, false,
 			    dma_mask);
 	if (addr == DMA_ERROR_CODE)
@@ -1863,15 +1862,11 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 {
 	unsigned long flags;
 	struct protection_domain *domain;
-	u16 devid;
 
 	INC_STATS_COUNTER(cnt_unmap_single);
 
-	if (!get_device_resources(dev, &domain, &devid))
-		/* device not handled by any AMD IOMMU */
-		return;
-
-	if (!dma_ops_domain(domain))
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
 		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
@@ -1911,7 +1906,6 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 {
 	unsigned long flags;
 	struct protection_domain *domain;
-	u16 devid;
 	int i;
 	struct scatterlist *s;
 	phys_addr_t paddr;
@@ -1920,14 +1914,14 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 
 	INC_STATS_COUNTER(cnt_map_sg);
 
-	if (!get_device_resources(dev, &domain, &devid))
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL)
 		return map_sg_no_iommu(dev, sglist, nelems, dir);
+	else if (IS_ERR(domain))
+		return 0;
 
 	dma_mask = *dev->dma_mask;
 
-	if (!dma_ops_domain(domain))
-		return 0;
-
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
@@ -1974,15 +1968,12 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	unsigned long flags;
 	struct protection_domain *domain;
 	struct scatterlist *s;
-	u16 devid;
 	int i;
 
 	INC_STATS_COUNTER(cnt_unmap_sg);
 
-	if (!get_device_resources(dev, &domain, &devid))
-		return;
-
-	if (!dma_ops_domain(domain))
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
 		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
@@ -2007,17 +1998,18 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	unsigned long flags;
 	void *virt_addr;
 	struct protection_domain *domain;
-	u16 devid;
 	phys_addr_t paddr;
 	u64 dma_mask = dev->coherent_dma_mask;
 
 	INC_STATS_COUNTER(cnt_alloc_coherent);
 
-	if (!get_device_resources(dev, &domain, &devid)) {
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL) {
 		virt_addr = (void *)__get_free_pages(flag, get_order(size));
 		*dma_addr = __pa(virt_addr);
 		return virt_addr;
-	}
+	} else if (IS_ERR(domain))
+		return NULL;
 
 	dma_mask  = dev->coherent_dma_mask;
 	flag     &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
@@ -2029,9 +2021,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
 
 	paddr = virt_to_phys(virt_addr);
 
-	if (!dma_ops_domain(domain))
-		goto out_free;
-
 	if (!dma_mask)
 		dma_mask = *dev->dma_mask;
 
@@ -2066,14 +2055,11 @@ static void free_coherent(struct device *dev, size_t size,
 {
 	unsigned long flags;
 	struct protection_domain *domain;
-	u16 devid;
 
 	INC_STATS_COUNTER(cnt_free_coherent);
 
-	if (!get_device_resources(dev, &domain, &devid))
-		goto free_mem;
-
-	if (!dma_ops_domain(domain))
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
 		goto free_mem;
 
 	spin_lock_irqsave(&domain->lock, flags);
-- 
1.6.5.3


