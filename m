Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYLIOSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYLIOSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYLIOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:29 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:52157 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYLIOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:23 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4YZ-04-AEE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/11] VT-d: adapt domain iova_to_phys function for IOMMU API
Date: Tue, 9 Dec 2008 15:16:08 +0100
Message-ID: <1228832170-13405-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832170-13405-9-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832170-13405-1-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-2-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-3-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-4-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-5-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-6-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-7-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-8-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-9-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:10.0973 (UTC) FILETIME=[AFA368D0:01C95A08]
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
index 8af6c96..7128105 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3106,15 +3106,16 @@ int intel_iommu_found(void)
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
 		phys = dma_pte_addr(pte);
 
 	return phys;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_iova_to_phys);
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 6bc26e0..26ccc02 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -330,8 +330,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-u64 intel_iommu_iova_to_phys(struct dmar_domain *domain, u64 iova);
-
 #ifdef CONFIG_DMAR
 int intel_iommu_found(void);
 #else /* CONFIG_DMAR */
-- 
1.5.6.4


