Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYK0Pny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYK0Pny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYK0Plc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:32 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54052 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYK0PlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:18 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KB00W5-04-B7Q-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/9] VT-d: add domain map and iova_to_phys functions for IOMMU API
Date: Thu, 27 Nov 2008 16:40:52 +0100
Message-ID: <1227800454-9555-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0906 (UTC) FILETIME=[88F105A0:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a90c832..8fa0269 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2492,3 +2492,25 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 
 	intel_iommu_detach_dev(dmar_domain, pdev->bus->number, pdev->devfn);
 }
+
+static int intel_iommu_map(struct iommu_domain *domain, dma_addr_t iova,
+			   phys_addr_t paddr, size_t size, int prot)
+{
+	struct dmar_domain *dmar_domain = domain->priv;
+
+	return intel_iommu_page_mapping(dmar_domain, iova, paddr, size, prot);
+}
+
+static phys_addr_t intel_iova_to_phys(struct iommu_domain *domain,
+				      dma_addr_t iova)
+{
+	struct dmar_domain *dmar_domain = domain->priv;
+	u64 pfn;
+	u64 offset = iova & ~PAGE_MASK;
+
+	pfn = intel_iommu_iova_to_pfn(dmar_domain, iova);
+	if (!pfn)
+		return pfn;
+
+	return (pfn << PAGE_SHIFT) & offset;
+}
-- 
1.5.6.4


