Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZKDXDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZKDXDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZKDXDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:03:15 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:41820 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZKDXDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:03:15 -0500
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent on
	passthrough
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, alex.williamson@hp.com
Date: Wed, 04 Nov 2009 15:59:34 -0700
Message-ID: <20091104225359.2720.91502.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_alloc_coherent() needs to follow DMA mapping convention and
make use of the coherent_dma_mask of the device for identity mappings.
Without this, devices may get buffers they can't use.  This patch
provides best effort allocations and fails the request if the mask
requirements are not met rather than returning an unusable buffer.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

This patch fixes a regression introduced since 2.6.31 that prevents
devices with a restricted coherent_dma_mask from working in passthrough
mode.

 drivers/pci/intel-iommu.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b1e97e6..8283df9 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2582,7 +2582,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (iommu_no_mapping(hwdev))
-		return paddr;
+		return paddr + size > dma_mask ? 0 : paddr;
 
 	domain = get_valid_domain_for_dev(pdev);
 	if (!domain)
@@ -2767,7 +2767,15 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
 
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
-	flags &= ~(GFP_DMA | GFP_DMA32);
+
+	if (!iommu_no_mapping(hwdev))
+		flags &= ~(GFP_DMA | GFP_DMA32);
+	else if (hwdev->coherent_dma_mask != DMA_BIT_MASK(64)) {
+		if (hwdev->coherent_dma_mask < DMA_BIT_MASK(32))
+			flags |= GFP_DMA;
+		else
+			flags |= GFP_DMA32;
+	}
 
 	vaddr = (void *)__get_free_pages(flags, order);
 	if (!vaddr)

