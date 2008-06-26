Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbYFZTfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbYFZTfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761325AbYFZT3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:05 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4053 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761283AbYFZT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:01 -0400
X-BigFish: VPS9(ze98mzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K334RT-04-UOD-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 23/34] AMD IOMMU: add functions to find IOMMU device resources
Date: Thu, 26 Jun 2008 21:27:59 +0200
Message-ID: <1214508490-29683-24-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0002 (UTC) FILETIME=[C5AB3C20:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functions necessary to find the IOMMU resources for a specific
device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   75 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c43d15d..47e80b5 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -461,3 +461,78 @@ free_dma_dom:
 	return NULL;
 }
 
+static struct protection_domain *domain_for_device(u16 devid)
+{
+	struct protection_domain *dom;
+	unsigned long flags;
+
+	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	dom = amd_iommu_pd_table[devid];
+	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	return dom;
+}
+
+static void set_device_domain(struct amd_iommu *iommu,
+			      struct protection_domain *domain,
+			      u16 devid)
+{
+	unsigned long flags;
+
+	u64 pte_root = virt_to_phys(domain->pt_root);
+
+	pte_root |= (domain->mode & 0x07) << 9;
+	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | 2;
+
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	amd_iommu_dev_table[devid].data[0] = pte_root;
+	amd_iommu_dev_table[devid].data[1] = pte_root >> 32;
+	amd_iommu_dev_table[devid].data[2] = domain->id;
+
+	amd_iommu_pd_table[devid] = domain;
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	iommu_queue_inv_dev_entry(iommu, devid);
+
+	iommu->need_sync = 1;
+}
+
+static int get_device_resources(struct device *dev,
+				struct amd_iommu **iommu,
+				struct protection_domain **domain,
+				u16 *bdf)
+{
+	struct dma_ops_domain *dma_dom;
+	struct pci_dev *pcidev;
+	u16 _bdf;
+
+	BUG_ON(!dev || dev->bus != &pci_bus_type || !dev->dma_mask);
+
+	pcidev = to_pci_dev(dev);
+	_bdf = (pcidev->bus->number << 8) | pcidev->devfn;
+
+	if (_bdf >= amd_iommu_last_bdf) {
+		*iommu = NULL;
+		*domain = NULL;
+		*bdf = 0xffff;
+		return 0;
+	}
+
+	*bdf = amd_iommu_alias_table[_bdf];
+
+	*iommu = amd_iommu_rlookup_table[*bdf];
+	if (*iommu == NULL)
+		return 0;
+	dma_dom = (*iommu)->default_dom;
+	*domain = domain_for_device(*bdf);
+	if (*domain == NULL) {
+		*domain = &dma_dom->domain;
+		set_device_domain(*iommu, *domain, *bdf);
+		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
+				"device ", (*domain)->id);
+		print_devid(_bdf, 1);
+	}
+
+	return 1;
+}
+
-- 
1.5.3.7


