Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0BKOdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:33:39 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:20700
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751832Ab0BKOdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:37 -0500
X-SpamScore: 6
X-BigFish: VPS6(za62pzab9bh936eMzz1202hzzz32i6bh87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRP-01-0UM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/7] x86/amd-iommu: Move functions to get rid of forward declarations
Date: Thu, 11 Feb 2010 15:33:14 +0100
Message-ID: <1265898797-32183-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0572 (UTC) FILETIME=[29231640:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some functions in amd_iommu.c to get rid of
the iommu_update_domain_dte forward declaration.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   90 +++++++++++++++++++++----------------------
 1 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 02ab775..bda00f0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -58,7 +58,6 @@ struct iommu_cmd {
 };
 
 static void reset_iommu_command_buffer(struct amd_iommu *iommu);
-static void iommu_update_domain_dte(struct protection_domain *domain);
 
 /****************************************************************************
  *
@@ -90,6 +89,38 @@ static void update_flush_info_tlb(struct protection_domain *domain,
 		domain->flush.end   = max(end  , domain->flush.end);
 	}
 }
+static void set_dte_entry(u16 devid, struct protection_domain *domain)
+{
+	u64 pte_root = virt_to_phys(domain->pt_root);
+
+	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
+		    << DEV_ENTRY_MODE_SHIFT;
+	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
+
+	amd_iommu_dev_table[devid].data[2] = domain->id;
+	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
+	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
+}
+
+static void clear_dte_entry(u16 devid)
+{
+	/* remove entry from the device table seen by the hardware */
+	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
+	amd_iommu_dev_table[devid].data[1] = 0;
+	amd_iommu_dev_table[devid].data[2] = 0;
+
+	amd_iommu_apply_erratum_63(devid);
+}
+
+static void update_device_table(struct protection_domain *domain)
+{
+	struct iommu_dev_data *dev_data;
+
+	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		u16 devid = get_device_id(dev_data->dev);
+		set_dte_entry(devid, domain);
+	}
+}
 
 /*
  * In this function the list of preallocated protection domains is traversed to
@@ -718,6 +749,18 @@ static void reset_iommu_command_buffer(struct amd_iommu *iommu)
 	iommu->reset_in_progress = false;
 }
 
+static void iommu_update_domain_dte(struct protection_domain *domain)
+{
+	if (!domain->flush.dte)
+		return;
+
+	update_device_table(domain);
+	iommu_flush_domain_devices(domain);
+	iommu_flush_tlb_pde(domain);
+
+	domain->flush.dte = false;
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -1366,29 +1409,6 @@ static bool dma_ops_domain(struct protection_domain *domain)
 	return domain->flags & PD_DMA_OPS_MASK;
 }
 
-static void set_dte_entry(u16 devid, struct protection_domain *domain)
-{
-	u64 pte_root = virt_to_phys(domain->pt_root);
-
-	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
-		    << DEV_ENTRY_MODE_SHIFT;
-	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
-
-	amd_iommu_dev_table[devid].data[2] = domain->id;
-	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
-	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
-}
-
-static void clear_dte_entry(u16 devid)
-{
-	/* remove entry from the device table seen by the hardware */
-	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
-	amd_iommu_dev_table[devid].data[1] = 0;
-	amd_iommu_dev_table[devid].data[2] = 0;
-
-	amd_iommu_apply_erratum_63(devid);
-}
-
 static void do_attach(struct device *dev, struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
@@ -1698,28 +1718,6 @@ static struct protection_domain *get_domain(struct device *dev)
 	return &dma_dom->domain;
 }
 
-static void update_device_table(struct protection_domain *domain)
-{
-	struct iommu_dev_data *dev_data;
-
-	list_for_each_entry(dev_data, &domain->dev_list, list) {
-		u16 devid = get_device_id(dev_data->dev);
-		set_dte_entry(devid, domain);
-	}
-}
-
-static void iommu_update_domain_dte(struct protection_domain *domain)
-{
-	if (!domain->flush.dte)
-		return;
-
-	update_device_table(domain);
-	iommu_flush_domain_devices(domain);
-	iommu_flush_tlb_pde(domain);
-
-	domain->flush.dte = false;
-}
-
 /*
  * This function fetches the PTE for a given address in the aperture
  */
-- 
1.6.6


