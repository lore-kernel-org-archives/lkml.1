Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYFZTcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYFZTcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760663AbYFZT2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:43 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30375 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479AbYFZT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:40 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K334QY-03-2Y9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 24/34] AMD IOMMU: add generic dma_ops mapping functions
Date: Thu, 26 Jun 2008 21:28:00 +0200
Message-ID: <1214508490-29683-25-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0033 (UTC) FILETIME=[C5AFF710:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the generic functions to map and unmap pages to a protection
domain for dma_ops usage.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  105 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 47e80b5..e00a3e7 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -536,3 +536,108 @@ static int get_device_resources(struct device *dev,
 	return 1;
 }
 
+static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
+				     struct dma_ops_domain *dom,
+				     unsigned long address,
+				     phys_addr_t paddr,
+				     int direction)
+{
+	u64 *pte, __pte;
+
+	WARN_ON(address > dom->aperture_size);
+
+	paddr &= PAGE_MASK;
+
+	pte  = dom->pte_pages[IOMMU_PTE_L1_INDEX(address)];
+	pte += IOMMU_PTE_L0_INDEX(address);
+
+	__pte = paddr | IOMMU_PTE_P | IOMMU_PTE_FC;
+
+	if (direction == DMA_TO_DEVICE)
+		__pte |= IOMMU_PTE_IR;
+	else if (direction == DMA_FROM_DEVICE)
+		__pte |= IOMMU_PTE_IW;
+	else if (direction == DMA_BIDIRECTIONAL)
+		__pte |= IOMMU_PTE_IR | IOMMU_PTE_IW;
+
+	WARN_ON(*pte);
+
+	*pte = __pte;
+
+	return (dma_addr_t)address;
+}
+
+static void dma_ops_domain_unmap(struct amd_iommu *iommu,
+				 struct dma_ops_domain *dom,
+				 unsigned long address)
+{
+	u64 *pte;
+
+	if (address >= dom->aperture_size)
+		return;
+
+	WARN_ON(address & 0xfffULL || address > dom->aperture_size);
+
+	pte  = dom->pte_pages[IOMMU_PTE_L1_INDEX(address)];
+	pte += IOMMU_PTE_L0_INDEX(address);
+
+	WARN_ON(!*pte);
+
+	*pte = 0ULL;
+}
+
+static dma_addr_t __map_single(struct device *dev,
+			       struct amd_iommu *iommu,
+			       struct dma_ops_domain *dma_dom,
+			       phys_addr_t paddr,
+			       size_t size,
+			       int dir)
+{
+	dma_addr_t offset = paddr & ~PAGE_MASK;
+	dma_addr_t address, start;
+	unsigned int pages;
+	int i;
+
+	pages = to_pages(paddr, size);
+	paddr &= PAGE_MASK;
+
+	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
+	if (unlikely(address == bad_dma_address))
+		goto out;
+
+	start = address;
+	for (i = 0; i < pages; ++i) {
+		dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
+		paddr += PAGE_SIZE;
+		start += PAGE_SIZE;
+	}
+	address += offset;
+
+out:
+	return address;
+}
+
+static void __unmap_single(struct amd_iommu *iommu,
+			   struct dma_ops_domain *dma_dom,
+			   dma_addr_t dma_addr,
+			   size_t size,
+			   int dir)
+{
+	dma_addr_t i, start;
+	unsigned int pages;
+
+	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
+		return;
+
+	pages = to_pages(dma_addr, size);
+	dma_addr &= PAGE_MASK;
+	start = dma_addr;
+
+	for (i = 0; i < pages; ++i) {
+		dma_ops_domain_unmap(iommu, dma_dom, start);
+		start += PAGE_SIZE;
+	}
+
+	dma_ops_free_addresses(dma_dom, dma_addr, pages);
+}
+
-- 
1.5.3.7


