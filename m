Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZEVMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZEVMRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbZEVMQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:16:08 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6143 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZEVMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:16:07 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KK1OQ9-03-948-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] amd-iommu: remove support for msi-x
Date: Fri, 22 May 2009 14:15:35 +0200
Message-ID: <1242994540-28799-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0189 (UTC) FILETIME=[06B181D0:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: drop support for msi-x in amd iommu code

Current hardware uses msi instead of msi-x so this code it not necessary
and can not be tested. The best thing is to drop this code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   44 +-------------------------------------
 1 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index cc99f60..feee475 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -783,46 +783,6 @@ static int __init init_iommu_all(struct acpi_table_header *table)
  *
  ****************************************************************************/
 
-static int __init iommu_setup_msix(struct amd_iommu *iommu)
-{
-	struct amd_iommu *curr;
-	struct msix_entry entries[32]; /* only 32 supported by AMD IOMMU */
-	int nvec = 0, i;
-
-	for_each_iommu(curr) {
-		if (curr->dev == iommu->dev) {
-			entries[nvec].entry = curr->evt_msi_num;
-			entries[nvec].vector = 0;
-			curr->int_enabled = true;
-			nvec++;
-		}
-	}
-
-	if (pci_enable_msix(iommu->dev, entries, nvec)) {
-		pci_disable_msix(iommu->dev);
-		return 1;
-	}
-
-	for (i = 0; i < nvec; ++i) {
-		int r = request_irq(entries->vector, amd_iommu_int_handler,
-				    IRQF_SAMPLE_RANDOM,
-				    "AMD IOMMU",
-				    NULL);
-		if (r)
-			goto out_free;
-	}
-
-	return 0;
-
-out_free:
-	for (i -= 1; i >= 0; --i)
-		free_irq(entries->vector, NULL);
-
-	pci_disable_msix(iommu->dev);
-
-	return 1;
-}
-
 static int __init iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
@@ -851,9 +811,7 @@ static int __init iommu_init_msi(struct amd_iommu *iommu)
 	if (iommu->int_enabled)
 		return 0;
 
-	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSIX))
-		return iommu_setup_msix(iommu);
-	else if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
+	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
 		return iommu_setup_msi(iommu);
 
 	return 1;
-- 
1.6.3.1


