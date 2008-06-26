Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbYFZTc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbYFZTc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760479AbYFZT2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:44 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:25122 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760615AbYFZT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:41 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j)
X-WSS-ID: 0K334R0-04-UNH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 26/34] AMD IOMMU: add mapping functions for scatter gather lists
Date: Thu, 26 Jun 2008 21:28:02 +0200
Message-ID: <1214508490-29683-27-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0096 (UTC) FILETIME=[C5B99400:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dma_ops functions for mapping and unmapping scatter gather
lists.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   98 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b4079f6..f4747fe 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -700,3 +700,101 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
+static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
+			   int nelems, int dir)
+{
+	struct scatterlist *s;
+	int i;
+
+	for_each_sg(sglist, s, nelems, i) {
+		s->dma_address = (dma_addr_t)sg_phys(s);
+		s->dma_length  = s->length;
+	}
+
+	return nelems;
+}
+
+static int map_sg(struct device *dev, struct scatterlist *sglist,
+		  int nelems, int dir)
+{
+	unsigned long flags;
+	struct amd_iommu *iommu;
+	struct protection_domain *domain;
+	u16 devid;
+	int i;
+	struct scatterlist *s;
+	phys_addr_t paddr;
+	int mapped_elems = 0;
+
+	get_device_resources(dev, &iommu, &domain, &devid);
+
+	if (!iommu || !domain)
+		return map_sg_no_iommu(dev, sglist, nelems, dir);
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	for_each_sg(sglist, s, nelems, i) {
+		paddr = sg_phys(s);
+
+		s->dma_address = __map_single(dev, iommu, domain->priv,
+					      paddr, s->length, dir);
+
+		if (s->dma_address) {
+			s->dma_length = s->length;
+			mapped_elems++;
+		} else
+			goto unmap;
+		if (iommu_has_npcache(iommu))
+			iommu_flush_pages(iommu, domain->id, s->dma_address,
+					  s->dma_length);
+	}
+
+	if (iommu->need_sync)
+		iommu_completion_wait(iommu);
+
+out:
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return mapped_elems;
+unmap:
+	for_each_sg(sglist, s, mapped_elems, i) {
+		if (s->dma_address)
+			__unmap_single(iommu, domain->priv, s->dma_address,
+				       s->dma_length, dir);
+		s->dma_address = s->dma_length = 0;
+	}
+
+	mapped_elems = 0;
+
+	goto out;
+}
+
+static void unmap_sg(struct device *dev, struct scatterlist *sglist,
+		     int nelems, int dir)
+{
+	unsigned long flags;
+	struct amd_iommu *iommu;
+	struct protection_domain *domain;
+	struct scatterlist *s;
+	u16 devid;
+	int i;
+
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
+		return;
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	for_each_sg(sglist, s, nelems, i) {
+		__unmap_single(iommu, domain->priv, s->dma_address,
+			       s->dma_length, dir);
+		iommu_flush_pages(iommu, domain->id, s->dma_address,
+				  s->dma_length);
+		s->dma_address = s->dma_length = 0;
+	}
+
+	if (iommu->need_sync)
+		iommu_completion_wait(iommu);
+
+	spin_unlock_irqrestore(&domain->lock, flags);
+}
+
-- 
1.5.3.7


