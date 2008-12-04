Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbYLDRkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbYLDRkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbYLDRco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:44 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:28715 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968AbYLDRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:17 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4P9-03-CX8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/19] AMD IOMMU: add checks for dma_ops domain to dma_ops functions
Date: Thu, 4 Dec 2008 18:31:47 +0100
Message-ID: <1228411916-22668-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0214 (UTC) FILETIME=[34E0CBE0:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: detect when a driver uses a device assigned otherwise

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 07ef5e9..be626ad 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -786,6 +786,15 @@ free_dma_dom:
 }
 
 /*
+ * little helper function to check whether a given protection domain is a
+ * dma_ops domain
+ */
+static bool dma_ops_domain(struct protection_domain *domain)
+{
+	return domain->flags & PD_DMA_OPS_MASK;
+}
+
+/*
  * Find out the protection domain structure for a given PCI device. This
  * will give us the pointer to the page table root for example.
  */
@@ -1089,6 +1098,8 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 		/* device not handled by any AMD IOMMU */
 		return (dma_addr_t)paddr;
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir, false,
 			    dma_mask);
@@ -1120,6 +1131,8 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 		/* device not handled by any AMD IOMMU */
 		return;
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
@@ -1175,6 +1188,8 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 	if (!iommu || !domain)
 		return map_sg_no_iommu(dev, sglist, nelems, dir);
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
@@ -1229,6 +1244,8 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	    !get_device_resources(dev, &iommu, &domain, &devid))
 		return;
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
@@ -1275,6 +1292,8 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		return virt_addr;
 	}
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	if (!dma_mask)
 		dma_mask = *dev->dma_mask;
 
@@ -1317,6 +1336,8 @@ static void free_coherent(struct device *dev, size_t size,
 	if (!iommu || !domain)
 		goto free_mem;
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
-- 
1.5.6.4


