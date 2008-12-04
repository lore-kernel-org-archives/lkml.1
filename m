Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYLDRgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYLDRgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbYLDRcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:21 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:37098 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbYLDRcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:10 -0500
X-BigFish: VPS10(zzzzzzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0KBD4PA-04-YDT-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/19] AMD IOMMU: add device detach function for IOMMU API
Date: Thu, 4 Dec 2008 18:31:51 +0100
Message-ID: <1228411916-22668-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0355 (UTC) FILETIME=[34F64FB0:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function to detach devices from protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   51 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fd42926..0ded6f4 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1529,3 +1529,54 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 
 	dom->priv = NULL;
 }
+
+static void __detach_device(struct protection_domain *domain, u16 devid)
+{
+	unsigned long flags;
+
+	/* lock domain and device table */
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	spin_lock(&domain->lock);
+
+	/* remove domain from the lookup table */
+	amd_iommu_pd_table[devid] = NULL;
+
+	/* remove entry from the device table seen by the hardware */
+	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
+	amd_iommu_dev_table[devid].data[1] = 0;
+	amd_iommu_dev_table[devid].data[2] = 0;
+
+	/* decrease reference counter */
+	domain->dev_cnt -= 1;
+
+	/* ready */
+	spin_unlock(&domain->lock);
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+}
+
+static void amd_iommu_detach_device(struct iommu_domain *dom,
+				    struct device *dev)
+{
+	struct protection_domain *domain = dom->priv;
+	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
+	u16 devid;
+
+	if (dev->bus != &pci_bus_type)
+		return;
+
+	pdev = to_pci_dev(dev);
+
+	devid = calc_devid(pdev->bus->number, pdev->devfn);
+
+	if (devid > 0)
+		__detach_device(domain, devid);
+
+	iommu = amd_iommu_rlookup_table[devid];
+	if (!iommu)
+		return;
+
+	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_completion_wait(iommu);
+}
+
-- 
1.5.6.4


