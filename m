Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYLBNDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYLBNDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYLBNBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:01:53 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50136 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYLBNBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:45 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KB92UC-04-VCS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/12] VT-d: adapt domain iova_to_phys function for IOMMU API
Date: Tue, 2 Dec 2008 14:01:22 +0100
Message-ID: <1228222883-17207-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:24.0003 (UTC) FILETIME=[144DDF30:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |   15 ++++++++-------
 include/linux/intel-iommu.h |    2 --
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index ac22973..2e8b102 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2913,18 +2913,19 @@ int intel_iommu_found(void)
 }
 EXPORT_SYMBOL_GPL(intel_iommu_found);
 
-u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova)
+static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
+					    unsigned long iova)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
 	struct dma_pte *pte;
-	u64 pfn;
+	phys_addr_t paddr;
 
-	pfn = 0;
-	pte = addr_to_dma_pte(domain, iova);
+	paddr = 0;
+	pte = addr_to_dma_pte(dmar_domain, iova);
 
 	if (pte)
-		pfn = dma_pte_addr(*pte);
+		paddr = dma_pte_addr(*pte);
 
-	return pfn >> VTD_PAGE_SHIFT;
+	return paddr;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_iova_to_pfn);
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index ac79a1c..469508f 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -337,8 +337,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova);
-
 #ifdef CONFIG_DMAR
 int intel_iommu_found(void);
 #else /* CONFIG_DMAR */
-- 
1.5.6.4


