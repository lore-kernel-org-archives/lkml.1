Return-Path: <linux-kernel-owner+w=401wt.eu-S1763175AbYFZTl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763175AbYFZTl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbYFZT31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14423 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761396AbYFZT3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:18 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K334RU-04-UOM-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 28/34] AMD IOMMU: add pre-allocation of protection domains
Date: Thu, 26 Jun 2008 21:28:04 +0200
Message-ID: <1214508490-29683-29-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0158 (UTC) FILETIME=[C5C309E0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function to pre-allocate protection domains. So we don't have
to allocate it on the first request for a device (which can happen in atomic
mode).

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index aab9125..bed5f82 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -872,3 +872,37 @@ free_mem:
 	free_pages((unsigned long)virt_addr, get_order(size));
 }
 
+/*
+ * If the driver core informs the DMA layer if a driver grabs a device
+ * we don't need to preallocate the protection domains anymore.
+ * For now we have to.
+ */
+void prealloc_protection_domains(void)
+{
+	struct pci_dev *dev = NULL;
+	struct dma_ops_domain *dma_dom;
+	struct amd_iommu *iommu;
+	int order = amd_iommu_aperture_order;
+	u16 devid;
+
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		devid = (dev->bus->number << 8) | dev->devfn;
+		if (devid >= amd_iommu_last_bdf)
+			continue;
+		devid = amd_iommu_alias_table[devid];
+		if (domain_for_device(devid))
+			continue;
+		iommu = amd_iommu_rlookup_table[devid];
+		if (!iommu)
+			continue;
+		dma_dom = dma_ops_domain_alloc(iommu, order);
+		if (!dma_dom)
+			continue;
+		init_unity_mappings_for_device(dma_dom, devid);
+		set_device_domain(iommu, &dma_dom->domain, devid);
+		printk(KERN_INFO "AMD IOMMU: Allocated domain %d for device ",
+		       dma_dom->domain.id);
+		print_devid(devid, 1);
+	}
+}
+
-- 
1.5.3.7


