Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0BAORG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:17:06 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:14662 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab0BAORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:17:04 -0500
X-SpamScore: -13
X-BigFish: VPS-13(z2d9bozab9bh1432R98dN936eMzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KX62BY-02-9XK-02
X-M-MSG: 
Date: Mon, 1 Feb 2010 15:16:46 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11 v2] VT-d: Change {un}map_range functions to implement
 {un}map interface
Message-ID: <20100201141646.GC16236@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
 <1264678682-30655-5-git-send-email-joerg.roedel@amd.com>
 <1264712382.9059.1109.camel@macbook.infradead.org>
 <20100129090526.GT17809@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100129090526.GT17809@8bytes.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Feb 2010 14:16:47.0171 (UTC) FILETIME=[304C0930:01CAA349]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:05:26AM +0100, Joerg Roedel wrote:
> > Um, that's not a page-size based interface. Page size isn't always 4KiB;
> > this code runs on IA64 too.
> > 
> > We have enough fun with CPU vs. DMA page size on IA64 already :)
> 
> Ah right. So this should be
> 
> 	size     = PAGE_SIZE << gfp_order;
> 
> Right? The interface is meant to map the same amount of memory which
> alloc_pages(gfp_order) would return. Same for the return value of the
> unmap function.

Ok, here is an updated patch (also updated in the iommu/largepage
branch). Does it look ok to you David?

>From a3ef8393d8027c795709e11b2f57c6013d2474a6 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 20 Jan 2010 17:17:37 +0100
Subject: [PATCH 04/11] VT-d: Change {un}map_range functions to implement {un}map interface

This patch changes the iommu-api functions for mapping and
unmapping page ranges to use the new page-size based
interface. This allows to remove the range based functions
later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a714e3d..371dc56 100644
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
 
+	size     = PAGE_SIZE << gfp_order;
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
+	size_t size = PAGE_SIZE << gfp_order;
 
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


