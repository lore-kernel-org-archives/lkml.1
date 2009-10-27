Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZJ0Dfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZJ0Dfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZJ0Dfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:35:40 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:25657 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbZJ0Dfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:35:39 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 23:35:39 EDT
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH v2 2/5] intel-iommu: Obey coherent_dma_mask for alloc_coherent
	on passthrough
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 26 Oct 2009 21:24:17 -0600
Message-ID: <20091027031907.2733.83945.stgit@nehalem.aw>
In-Reply-To: <20091026232503.9646.88301.stgit@nehalem.aw>
References: <20091026232503.9646.88301.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_alloc_coherent() needs to follow DMA mapping convention and
make use of the coherent_dma_mask of the device for identity mappings.
Without this, devices may get buffers they can't use.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

 v2: Abandon attempt to create a common dma_generic_alloc_coherent,
     patch 1/5 is now defunct.  Patches 3-5 are unchanged.

 drivers/pci/intel-iommu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b1e97e6..272261e 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2582,7 +2582,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (iommu_no_mapping(hwdev))
-		return paddr;
+		return paddr + size > dma_mask ? 0 : paddr;
 
 	domain = get_valid_domain_for_dev(pdev);
 	if (!domain)
@@ -2767,7 +2767,11 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
 
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
-	flags &= ~(GFP_DMA | GFP_DMA32);
+
+	if (!iommu_no_mapping(hwdev))
+		flags &= ~(GFP_DMA | GFP_DMA32);
+	else if (hwdev->coherent_dma_mask != DMA_BIT_MASK(64))
+		flags |= GFP_DMA;
 
 	vaddr = (void *)__get_free_pages(flags, order);
 	if (!vaddr)

