Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYIQQ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYIQQ6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYIQQx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:26 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53468 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbYIQQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:24 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K7CMW9-03-U90-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/23] AMD IOMMU: add dma_supported callback
Date: Wed, 17 Sep 2008 18:52:47 +0200
Message-ID: <1221670377-19295-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0126 (UTC) FILETIME=[D673CAE0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function determines if the AMD IOMMU implementation is responsible
for a given device. So the DMA layer can get this information from the
driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 71e20ad..0410be1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1205,6 +1205,30 @@ free_mem:
 }
 
 /*
+ * This function is called by the DMA layer to find out if we can handle a
+ * particular device. It is part of the dma_ops.
+ */
+static int amd_iommu_dma_supported(struct device *dev, u64 mask)
+{
+	u16 bdf;
+	struct pci_dev *pcidev;
+
+	/* No device or no PCI device */
+	if (!dev || dev->bus != &pci_bus_type)
+		return 0;
+
+	pcidev = to_pci_dev(dev);
+
+	bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
+
+	/* Out of our scope? */
+	if (bdf > amd_iommu_last_bdf)
+		return 0;
+
+	return 1;
+}
+
+/*
  * The function for pre-allocating protection domains.
  *
  * If the driver core informs the DMA layer if a driver grabs a device
@@ -1247,6 +1271,7 @@ static struct dma_mapping_ops amd_iommu_dma_ops = {
 	.unmap_single = unmap_single,
 	.map_sg = map_sg,
 	.unmap_sg = unmap_sg,
+	.dma_supported = amd_iommu_dma_supported,
 };
 
 /*
-- 
1.5.6.4


