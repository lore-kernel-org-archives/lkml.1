Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZJZX3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZJZX3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZJZX3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:29:10 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:29416 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZJZX3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:29:08 -0400
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH 2/5] intel-iommu: Use dma_generic_alloc_coherent() for
	passthrough mappings
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 26 Oct 2009 17:25:03 -0600
Message-ID: <20091026232503.9646.88301.stgit@nehalem.aw>
In-Reply-To: <20091026232401.9646.90540.stgit@nehalem.aw>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_alloc_coherent() needs to follow DMA mapping convention and
make use of the coherent_dma_mask of the device.  Without this,
devices may get buffers they can't use.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

 drivers/pci/intel-iommu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b1e97e6..40be49a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2765,6 +2765,10 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
 	void *vaddr;
 	int order;
 
+	if (iommu_no_mapping(hwdev))
+		return dma_generic_alloc_coherent(hwdev, size, dma_handle,
+						  flags);
+
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
 	flags &= ~(GFP_DMA | GFP_DMA32);
@@ -2788,6 +2792,10 @@ static void intel_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 {
 	int order;
 
+	if (iommu_no_mapping(hwdev))
+		return dma_generic_free_coherent(hwdev, size, vaddr,
+						 dma_handle);
+
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
 

