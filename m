Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYLDRaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYLDRaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYLDR3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:15 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:11548 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbYLDR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:10 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4K7-03-CRH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/11] VT-d: adapt domain iova_to_phys function for IOMMU API
Date: Thu, 4 Dec 2008 18:28:54 +0100
Message-ID: <1228411736-22644-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0834 (UTC) FILETIME=[C95CFE20:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |    7 ++++---
 include/linux/intel-iommu.h |    2 --
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 34ea06f..c5f1405 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2809,15 +2809,16 @@ int intel_iommu_found(void)
 }
 EXPORT_SYMBOL_GPL(intel_iommu_found);
 
-u64 intel_iommu_iova_to_phys(struct dmar_domain *domain, u64 iova)
+static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
+					    unsigned long iova)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
 	struct dma_pte *pte;
 	u64 phys = 0;
 
-	pte = addr_to_dma_pte(domain, iova);
+	pte = addr_to_dma_pte(dmar_domain, iova);
 	if (pte)
 		phys = dma_pte_addr(*pte);
 
 	return phys;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_iova_to_phys);
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 01ba896..57c44c2 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -335,8 +335,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-u64 intel_iommu_iova_to_phys(struct dmar_domain *domain, u64 iova);
-
 #ifdef CONFIG_DMAR
 int intel_iommu_found(void);
 #else /* CONFIG_DMAR */
-- 
1.5.6.4


