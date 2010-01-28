Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731Ab0A1Lkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab0A1Lkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793Ab0A1Lif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:38:35 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:28625 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab0A1Lic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:32 -0500
X-SpamScore: 3
X-BigFish: VPS3(z2d9bozab9bh936eMzz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBW-02-6ZZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/11] VT-d: Change {un}map_range functions to implement {un}map interface
Date: Thu, 28 Jan 2010 12:37:55 +0100
Message-ID: <1264678682-30655-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0742 (UTC) FILETIME=[645F1660:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the iommu-api functions for mapping and
unmapping page ranges to use the new page-size based
interface. This allows to remove the range based functions
later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a714e3d..f1d3b85 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3626,14 +3626,15 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 	domain_remove_one_dev_info(dmar_domain, pdev);
 }
 
-static int intel_iommu_map_range(struct iommu_domain *domain,
-				 unsigned long iova, phys_addr_t hpa,
-				 size_t size, int iommu_prot)
+static int intel_iommu_map(struct iommu_domain *domain,
+			   unsigned long iova, phys_addr_t hpa,
+			   int gfp_order, int iommu_prot)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
 	int addr_width;
 	int prot = 0;
+	size_t size;
 	int ret;
 
 	if (iommu_prot & IOMMU_READ)
@@ -3643,6 +3644,7 @@ static int intel_iommu_map_range(struct iommu_domain *domain,
 	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
 		prot |= DMA_PTE_SNP;
 
+	size     = 0x1000UL << gfp_order;
 	max_addr = iova + size;
 	if (dmar_domain->max_addr < max_addr) {
 		int min_agaw;
@@ -3669,19 +3671,19 @@ static int intel_iommu_map_range(struct iommu_domain *domain,
 	return ret;
 }
 
-static void intel_iommu_unmap_range(struct iommu_domain *domain,
-				    unsigned long iova, size_t size)
+static int intel_iommu_unmap(struct iommu_domain *domain,
+			     unsigned long iova, int gfp_order)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
-
-	if (!size)
-		return;
+	size_t size = 0x1000UL << gfp_order;
 
 	dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
 			    (iova + size - 1) >> VTD_PAGE_SHIFT);
 
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
+
+	return gfp_order;
 }
 
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
@@ -3714,8 +3716,8 @@ static struct iommu_ops intel_iommu_ops = {
 	.domain_destroy = intel_iommu_domain_destroy,
 	.attach_dev	= intel_iommu_attach_device,
 	.detach_dev	= intel_iommu_detach_device,
-	.map_range	= intel_iommu_map_range,
-	.unmap_range	= intel_iommu_unmap_range,
+	.map		= intel_iommu_map,
+	.unmap		= intel_iommu_unmap,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 	.domain_has_cap = intel_iommu_domain_has_cap,
 };
-- 
1.6.6


