Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbZK0N4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbZK0N4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZK0N4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:11 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16053
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753061AbZK0Nz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:58 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KTRTD4-02-34U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/34] x86/amd-iommu: Use get_device_id and check_device where appropriate
Date: Fri, 27 Nov 2009 14:55:33 +0100
Message-ID: <1259330145-14865-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0514 (UTC) FILETIME=[52D0B820:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic of these two functions is reimplemented (at least
in parts) in places in the code. This patch removes these
code duplications and uses the functions instead. As a side
effect it moves check_device() to the helper function code
section.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  110 +++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 61 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 405f8da..d10195b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -111,6 +111,33 @@ static struct dma_ops_domain *find_protection_domain(u16 devid)
 	return ret;
 }
 
+/*
+ * This function checks if the driver got a valid device from the caller to
+ * avoid dereferencing invalid pointers.
+ */
+static bool check_device(struct device *dev)
+{
+	u16 devid;
+
+	if (!dev || !dev->dma_mask)
+		return false;
+
+	/* No device or no PCI device */
+	if (!dev || dev->bus != &pci_bus_type)
+		return false;
+
+	devid = get_device_id(dev);
+
+	/* Out of our scope? */
+	if (devid > amd_iommu_last_bdf)
+		return false;
+
+	if (amd_iommu_rlookup_table[devid] == NULL)
+		return false;
+
+	return true;
+}
+
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -1386,22 +1413,17 @@ static int device_change_notifier(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct pci_dev *pdev = to_pci_dev(dev);
-	u16 devid = calc_devid(pdev->bus->number, pdev->devfn);
+	u16 devid;
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_domain;
 	struct amd_iommu *iommu;
 	unsigned long flags;
 
-	if (devid > amd_iommu_last_bdf)
-		goto out;
-
-	devid = amd_iommu_alias_table[devid];
-
-	iommu = amd_iommu_rlookup_table[devid];
-	if (iommu == NULL)
-		goto out;
+	if (!check_device(dev))
+		return 0;
 
+	devid  = get_device_id(dev);
+	iommu  = amd_iommu_rlookup_table[devid];
 	domain = domain_for_device(dev);
 
 	if (domain && !dma_ops_domain(domain))
@@ -1453,36 +1475,6 @@ static struct notifier_block device_nb = {
  *****************************************************************************/
 
 /*
- * This function checks if the driver got a valid device from the caller to
- * avoid dereferencing invalid pointers.
- */
-static bool check_device(struct device *dev)
-{
-	u16 bdf;
-	struct pci_dev *pcidev;
-
-	if (!dev || !dev->dma_mask)
-		return false;
-
-	/* No device or no PCI device */
-	if (!dev || dev->bus != &pci_bus_type)
-		return false;
-
-	pcidev = to_pci_dev(dev);
-
-	bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
-
-	/* Out of our scope? */
-	if (bdf > amd_iommu_last_bdf)
-		return false;
-
-	if (amd_iommu_rlookup_table[bdf] == NULL)
-		return false;
-
-	return true;
-}
-
-/*
  * In the dma_ops path we only have the struct device. This function
  * finds the corresponding IOMMU, the protection domain and the
  * requestor id for a given device.
@@ -2094,15 +2086,20 @@ static void prealloc_protection_domains(void)
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
 	struct amd_iommu *iommu;
-	u16 devid, __devid;
+	u16 devid;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		__devid = devid = calc_devid(dev->bus->number, dev->devfn);
-		if (devid > amd_iommu_last_bdf)
+
+		/* Do we handle this device? */
+		if (!check_device(&dev->dev))
 			continue;
-		devid = amd_iommu_alias_table[devid];
+
+		/* Is there already any domain for it? */
 		if (domain_for_device(&dev->dev))
 			continue;
+
+		devid = get_device_id(&dev->dev);
+
 		iommu = amd_iommu_rlookup_table[devid];
 		if (!iommu)
 			continue;
@@ -2294,17 +2291,14 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 				    struct device *dev)
 {
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
 	u16 devid;
 
-	if (dev->bus != &pci_bus_type)
+	if (!check_device(dev))
 		return;
 
-	pdev = to_pci_dev(dev);
-
-	devid = calc_devid(pdev->bus->number, pdev->devfn);
+	devid = get_device_id(dev);
 
-	if (devid > 0)
+	if (amd_iommu_pd_table[devid] != NULL)
 		detach_device(dev);
 
 	iommu = amd_iommu_rlookup_table[devid];
@@ -2321,20 +2315,13 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	struct protection_domain *domain = dom->priv;
 	struct protection_domain *old_domain;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
 	int ret;
 	u16 devid;
 
-	if (dev->bus != &pci_bus_type)
+	if (!check_device(dev))
 		return -EINVAL;
 
-	pdev = to_pci_dev(dev);
-
-	devid = calc_devid(pdev->bus->number, pdev->devfn);
-
-	if (devid >= amd_iommu_last_bdf ||
-			devid != amd_iommu_alias_table[devid])
-		return -EINVAL;
+	devid = get_device_id(dev);
 
 	iommu = amd_iommu_rlookup_table[devid];
 	if (!iommu)
@@ -2458,10 +2445,11 @@ int __init amd_iommu_init_passthrough(void)
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 
-		devid = calc_devid(dev->bus->number, dev->devfn);
-		if (devid > amd_iommu_last_bdf)
+		if (!check_device(&dev->dev))
 			continue;
 
+		devid = get_device_id(&dev->dev);
+
 		iommu = amd_iommu_rlookup_table[devid];
 		if (!iommu)
 			continue;
-- 
1.6.5.3


