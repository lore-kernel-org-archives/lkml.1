Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZJVDls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZJVDls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZJVDlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:41:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17616 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZJVDlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:41:47 -0400
Subject: [PATCH] intel-iommu: Fix alloc_coherent for pass-through devices
From: Alex Williamson <alex.williamson@hp.com>
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Oct 2009 21:41:50 -0600
Message-ID: <1256182910.2842.36.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 19943b0e (intel-iommu: Unify hardware and software passthrough
support) hardware pass-through mode devices make use of intel_dma_ops
rather than swiotlb_dma_ops.  The problem is that intel_alloc_coherent
ignores the device coherent_dma_mask when allocating the page since it
expects to remap the page and provide the device with an iova within the
coherent mask.  This breaks when we use pass-through.

The patch below crudely works around the problem, but I hope we can come
up with something better without reintroducing the dependency on
swiotlb.  The device hitting this problem is an HP smart array
controller on a Proliant G6 system.  It uses a default 32bit coherent
DMA mask, and stalls, presumably waiting on control data to change in
the wrong address space, when it gets a coherent buffer above 4G.  This
device also doesn't exactly play nice when using VT-d in anything other
than pass-through mode, so switching it into mapped mode is not really
an option.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b1e97e6..7a739ac 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2767,7 +2767,11 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
 
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
-	flags &= ~(GFP_DMA | GFP_DMA32);
+
+	if (iommu_no_mapping(hwdev))
+		flags |= (GFP_DMA | GFP_DMA32);
+	else
+		flags &= ~(GFP_DMA | GFP_DMA32);
 
 	vaddr = (void *)__get_free_pages(flags, order);
 	if (!vaddr)


