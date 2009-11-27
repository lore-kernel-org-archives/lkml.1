Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZK0N5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZK0N5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZK0N4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:10 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:41369 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZK0Nz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:59 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD3-01-6RO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/34] x86/amd-iommu: Use check_device for amd_iommu_dma_supported
Date: Fri, 27 Nov 2009 14:55:24 +0100
Message-ID: <1259330145-14865-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0154 (UTC) FILETIME=[5299C9A0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check_device logic needs to include the dma_supported
checks to be really sure. Merge the dma_supported logic into
check_device and use it to implement dma_supported.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5ebd24e..ac27b1d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1375,9 +1375,27 @@ static struct notifier_block device_nb = {
  */
 static bool check_device(struct device *dev)
 {
+	u16 bdf;
+	struct pci_dev *pcidev;
+
 	if (!dev || !dev->dma_mask)
 		return false;
 
+	/* No device or no PCI device */
+	if (!dev || dev->bus != &pci_bus_type)
+		return false;
+
+	pcidev = to_pci_dev(dev);
+
+	bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
+
+	/* Out of our scope? */
+	if (bdf > amd_iommu_last_bdf)
+		return false;
+
+	if (amd_iommu_rlookup_table[bdf] == NULL)
+		return false;
+
 	return true;
 }
 
@@ -2065,22 +2083,7 @@ free_mem:
  */
 static int amd_iommu_dma_supported(struct device *dev, u64 mask)
 {
-	u16 bdf;
-	struct pci_dev *pcidev;
-
-	/* No device or no PCI device */
-	if (!dev || dev->bus != &pci_bus_type)
-		return 0;
-
-	pcidev = to_pci_dev(dev);
-
-	bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
-
-	/* Out of our scope? */
-	if (bdf > amd_iommu_last_bdf)
-		return 0;
-
-	return 1;
+	return check_device(dev);
 }
 
 /*
-- 
1.6.5.3


