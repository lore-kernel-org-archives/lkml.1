Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYIQQ4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYIQQ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYIQQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:19 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53008 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbYIQQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:16 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K7CMW5-04-URI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/23] AMD IOMMU: check for invalid device pointers
Date: Wed, 17 Sep 2008 18:52:35 +0200
Message-ID: <1221670377-19295-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:57.0907 (UTC) FILETIME=[D6526030:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently AMD IOMMU code triggers a BUG_ON if NULL is passed as the
device. This is inconsistent with other IOMMU implementations. This
patch fixes it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   43 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 01c68c3..695e0fc 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -646,6 +646,18 @@ static void set_device_domain(struct amd_iommu *iommu,
  *****************************************************************************/
 
 /*
+ * This function checks if the driver got a valid device from the caller to
+ * avoid dereferencing invalid pointers.
+ */
+static bool check_device(struct device *dev)
+{
+	if (!dev || !dev->dma_mask)
+		return false;
+
+	return true;
+}
+
+/*
  * In the dma_ops path we only have the struct device. This function
  * finds the corresponding IOMMU, the protection domain and the
  * requestor id for a given device.
@@ -661,18 +673,19 @@ static int get_device_resources(struct device *dev,
 	struct pci_dev *pcidev;
 	u16 _bdf;
 
-	BUG_ON(!dev || dev->bus != &pci_bus_type || !dev->dma_mask);
+	*iommu = NULL;
+	*domain = NULL;
+	*bdf = 0xffff;
+
+	if (dev->bus != &pci_bus_type)
+		return 0;
 
 	pcidev = to_pci_dev(dev);
 	_bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
 
 	/* device not translated by any IOMMU in the system? */
-	if (_bdf > amd_iommu_last_bdf) {
-		*iommu = NULL;
-		*domain = NULL;
-		*bdf = 0xffff;
+	if (_bdf > amd_iommu_last_bdf)
 		return 0;
-	}
 
 	*bdf = amd_iommu_alias_table[_bdf];
 
@@ -826,6 +839,9 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	u16 devid;
 	dma_addr_t addr;
 
+	if (!check_device(dev))
+		return bad_dma_address;
+
 	get_device_resources(dev, &iommu, &domain, &devid);
 
 	if (iommu == NULL || domain == NULL)
@@ -860,7 +876,8 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 	struct protection_domain *domain;
 	u16 devid;
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!check_device(dev) ||
+	    !get_device_resources(dev, &iommu, &domain, &devid))
 		/* device not handled by any AMD IOMMU */
 		return;
 
@@ -910,6 +927,9 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 	phys_addr_t paddr;
 	int mapped_elems = 0;
 
+	if (!check_device(dev))
+		return 0;
+
 	get_device_resources(dev, &iommu, &domain, &devid);
 
 	if (!iommu || !domain)
@@ -967,7 +987,8 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	u16 devid;
 	int i;
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!check_device(dev) ||
+	    !get_device_resources(dev, &iommu, &domain, &devid))
 		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
@@ -999,6 +1020,9 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	u16 devid;
 	phys_addr_t paddr;
 
+	if (!check_device(dev))
+		return NULL;
+
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return 0;
@@ -1047,6 +1071,9 @@ static void free_coherent(struct device *dev, size_t size,
 	struct protection_domain *domain;
 	u16 devid;
 
+	if (!check_device(dev))
+		return;
+
 	get_device_resources(dev, &iommu, &domain, &devid);
 
 	if (!iommu || !domain)
-- 
1.5.6.4


