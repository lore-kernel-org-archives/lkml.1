Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbYFZTfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbYFZTfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760217AbYFZT3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:07 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:26913 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761260AbYFZT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:02 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j)
X-WSS-ID: 0K334RU-04-UOL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 25/34] AMD IOMMU: add dma_ops mapping functions for single mappings
Date: Thu, 26 Jun 2008 21:28:01 +0200
Message-ID: <1214508490-29683-26-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0065 (UTC) FILETIME=[C5B4D910:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dma_ops specific mapping functions for single mappings.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   59 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e00a3e7..b4079f6 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -40,6 +40,11 @@ struct command {
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
 
+static int iommu_has_npcache(struct amd_iommu *iommu)
+{
+	return iommu->cap & IOMMU_CAP_NPCACHE;
+}
+
 static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
 {
 	u32 tail, head;
@@ -641,3 +646,57 @@ static void __unmap_single(struct amd_iommu *iommu,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 }
 
+static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
+			     size_t size, int dir)
+{
+	unsigned long flags;
+	struct amd_iommu *iommu;
+	struct protection_domain *domain;
+	u16 devid;
+	dma_addr_t addr;
+
+	get_device_resources(dev, &iommu, &domain, &devid);
+
+	if (iommu == NULL || domain == NULL)
+		return (dma_addr_t)paddr;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir);
+	if (addr == bad_dma_address)
+		goto out;
+
+	if (iommu_has_npcache(iommu))
+		iommu_flush_pages(iommu, domain->id, addr, size);
+
+	if (iommu->need_sync)
+		iommu_completion_wait(iommu);
+
+out:
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return addr;
+}
+
+static void unmap_single(struct device *dev, dma_addr_t dma_addr,
+			 size_t size, int dir)
+{
+	unsigned long flags;
+	struct amd_iommu *iommu;
+	struct protection_domain *domain;
+	u16 devid;
+
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
+		return;
+
+	spin_lock_irqsave(&domain->lock, flags);
+
+	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
+
+	iommu_flush_pages(iommu, domain->id, dma_addr, size);
+
+	if (iommu->need_sync)
+		iommu_completion_wait(iommu);
+
+	spin_unlock_irqrestore(&domain->lock, flags);
+}
+
-- 
1.5.3.7


