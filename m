Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736Ab0A1LjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0A1LjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852Ab0A1LjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:39:17 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:16943
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932208Ab0A1Lij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:39 -0500
X-SpamScore: 5
X-BigFish: VPS5(z2d9bozab9bh936eMzz1202hzzz32i87h6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGC1-01-FXX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/11] iommu-api: Remove iommu_{un}map_range functions
Date: Thu, 28 Jan 2010 12:38:02 +0100
Message-ID: <1264678682-30655-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:21.0008 (UTC) FILETIME=[6487AD00:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are not longer used and can be removed
savely. There functionality is now provided by the
iommu_{un}map functions which are also capable of multiple
page sizes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   48 -------------------------------------------
 drivers/base/iommu.c        |   26 +---------------------
 include/linux/iommu.h       |   20 -----------------
 3 files changed, 2 insertions(+), 92 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0e068c9..d8da998 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2506,52 +2506,6 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	return ret;
 }
 
-static int amd_iommu_map_range(struct iommu_domain *dom,
-			       unsigned long iova, phys_addr_t paddr,
-			       size_t size, int iommu_prot)
-{
-	struct protection_domain *domain = dom->priv;
-	unsigned long i,  npages = iommu_num_pages(paddr, size, PAGE_SIZE);
-	int prot = 0;
-	int ret;
-
-	if (iommu_prot & IOMMU_READ)
-		prot |= IOMMU_PROT_IR;
-	if (iommu_prot & IOMMU_WRITE)
-		prot |= IOMMU_PROT_IW;
-
-	iova  &= PAGE_MASK;
-	paddr &= PAGE_MASK;
-
-	for (i = 0; i < npages; ++i) {
-		ret = iommu_map_page(domain, iova, paddr, prot, PAGE_SIZE);
-		if (ret)
-			return ret;
-
-		iova  += PAGE_SIZE;
-		paddr += PAGE_SIZE;
-	}
-
-	return 0;
-}
-
-static void amd_iommu_unmap_range(struct iommu_domain *dom,
-				  unsigned long iova, size_t size)
-{
-
-	struct protection_domain *domain = dom->priv;
-	unsigned long i,  npages = iommu_num_pages(iova, size, PAGE_SIZE);
-
-	iova  &= PAGE_MASK;
-
-	for (i = 0; i < npages; ++i) {
-		iommu_unmap_page(domain, iova, PAGE_SIZE);
-		iova  += PAGE_SIZE;
-	}
-
-	iommu_flush_tlb_pde(domain);
-}
-
 static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 			 phys_addr_t paddr, int gfp_order, int iommu_prot)
 {
@@ -2616,8 +2570,6 @@ static struct iommu_ops amd_iommu_ops = {
 	.detach_dev = amd_iommu_detach_device,
 	.map = amd_iommu_map,
 	.unmap = amd_iommu_unmap,
-	.map_range = amd_iommu_map_range,
-	.unmap_range = amd_iommu_unmap_range,
 	.iova_to_phys = amd_iommu_iova_to_phys,
 	.domain_has_cap = amd_iommu_domain_has_cap,
 };
diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 55d37e4..6e6b6a1 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -80,20 +80,6 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
-int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
-		    phys_addr_t paddr, size_t size, int prot)
-{
-	return iommu_ops->map_range(domain, iova, paddr, size, prot);
-}
-EXPORT_SYMBOL_GPL(iommu_map_range);
-
-void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
-		      size_t size)
-{
-	iommu_ops->unmap_range(domain, iova, size);
-}
-EXPORT_SYMBOL_GPL(iommu_unmap_range);
-
 phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 			       unsigned long iova)
 {
@@ -119,10 +105,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 
 	BUG_ON((iova | paddr) & invalid_mask);
 
-	if (iommu_ops->map)
-		return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
-
-	return iommu_ops->map_range(domain, iova, paddr, size, prot);
+	return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
@@ -136,11 +119,6 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 
 	BUG_ON(iova & invalid_mask);
 
-	if (iommu_ops->unmap)
-		return iommu_ops->unmap(domain, iova, gfp_order);
-
-	iommu_ops->unmap_range(domain, iova, size);
-
-	return gfp_order;
+	return iommu_ops->unmap(domain, iova, gfp_order);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5a7a3d8..be22ad8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -40,10 +40,6 @@ struct iommu_ops {
 		   phys_addr_t paddr, int gfp_order, int prot);
 	int (*unmap)(struct iommu_domain *domain, unsigned long iova,
 		     int gfp_order);
-	int (*map_range)(struct iommu_domain *domain, unsigned long iova,
-			 phys_addr_t paddr, size_t size, int prot);
-	void (*unmap_range)(struct iommu_domain *domain, unsigned long iova,
-			    size_t size);
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    unsigned long iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
@@ -60,10 +56,6 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
-extern int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
-			   phys_addr_t paddr, size_t size, int prot);
-extern void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
-			      size_t size);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, int gfp_order, int prot);
 extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
@@ -104,18 +96,6 @@ static inline void iommu_detach_device(struct iommu_domain *domain,
 {
 }
 
-static inline int iommu_map_range(struct iommu_domain *domain,
-				  unsigned long iova, phys_addr_t paddr,
-				  size_t size, int prot)
-{
-	return -ENODEV;
-}
-
-static inline void iommu_unmap_range(struct iommu_domain *domain,
-				     unsigned long iova, size_t size)
-{
-}
-
 static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
 			    phys_addr_t paddr, int gfp_order, int prot)
 {
-- 
1.6.6


