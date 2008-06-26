Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYFZTgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYFZTgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761364AbYFZT3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:11 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4096 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761290AbYFZT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:02 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334RU-04-UOP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 27/34] AMD IOMMU: add mapping functions for coherent mappings
Date: Thu, 26 Jun 2008 21:28:03 +0200
Message-ID: <1214508490-29683-28-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0127 (UTC) FILETIME=[C5BE4EF0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dma_ops functions for coherent mappings.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   74 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f4747fe..aab9125 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -798,3 +798,77 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
+static void *alloc_coherent(struct device *dev, size_t size,
+			    dma_addr_t *dma_addr, gfp_t flag)
+{
+	unsigned long flags;
+	void *virt_addr;
+	struct amd_iommu *iommu;
+	struct protection_domain *domain;
+	u16 devid;
+	phys_addr_t paddr;
+
+	virt_addr = (void *)__get_free_pages(flag, get_order(size));
+	if (!virt_addr)
+		return 0;
+
+	memset(virt_addr, 0, size);
+	paddr = virt_to_phys(virt_addr);
+
+	get_device_resources(dev, &iommu, &domain, &devid);
+
+	if (!iommu || !domain) {
+		*dma_addr = (dma_addr_t)paddr;
+		return virt_addr;
+	}
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
+				 size, DMA_BIDIRECTIONAL);
+
+	if (*dma_addr == bad_dma_address) {
+		free_pages((unsigned long)virt_addr, get_order(size));
+		virt_addr = NULL;
+		goto out;
+	}
+
+	if (iommu_has_npcache(iommu))
+		iommu_flush_pages(iommu, domain->id, *dma_addr, size);
+
+	if (iommu->need_sync)
+		iommu_completion_wait(iommu);
+
+out:
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return virt_addr;
+}
+
+static void free_coherent(struct device *dev, size_t size,
+			  void *virt_addr, dma_addr_t dma_addr)
+{
+	unsigned long flags;
+	struct amd_iommu *iommu;
+	struct protection_domain *domain;
+	u16 devid;
+
+	get_device_resources(dev, &iommu, &domain, &devid);
+
+	if (!iommu || !domain)
+		goto free_mem;
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
+	iommu_flush_pages(iommu, domain->id, dma_addr, size);
+
+	if (iommu->need_sync)
+		iommu_completion_wait(iommu);
+
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+free_mem:
+	free_pages((unsigned long)virt_addr, get_order(size));
+}
+
-- 
1.5.3.7


