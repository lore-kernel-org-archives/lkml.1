Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYLIOXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYLIOXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYLIOQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:54 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:53087 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYLIOQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:32 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4Z8-03-KKS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/21] AMD IOMMU: add checks for dma_ops domain to dma_ops functions
Date: Tue, 9 Dec 2008 15:16:07 +0100
Message-ID: <1228832178-13429-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-10-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-8-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-9-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-10-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0036 (UTC) FILETIME=[B471B9C0:01C95A08]
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
index 6d26544..2173283 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -787,6 +787,15 @@ free_dma_dom:
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
@@ -1091,6 +1100,8 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 		/* device not handled by any AMD IOMMU */
 		return (dma_addr_t)paddr;
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir, false,
 			    dma_mask);
@@ -1121,6 +1132,8 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
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
@@ -1228,6 +1243,8 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	    !get_device_resources(dev, &iommu, &domain, &devid))
 		return;
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
@@ -1273,6 +1290,8 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		return virt_addr;
 	}
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	if (!dma_mask)
 		dma_mask = *dev->dma_mask;
 
@@ -1314,6 +1333,8 @@ static void free_coherent(struct device *dev, size_t size,
 	if (!iommu || !domain)
 		goto free_mem;
 
+	BUG_ON(!dma_ops_domain(domain));
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
-- 
1.5.6.4


