Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZKJAq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZKJAq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZKJAqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:46:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:40026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZKJAqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:46:54 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on passthrough
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20091104225359.2720.91502.stgit@nehalem.aw>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 00:46:54 +0000
Message-ID: <1257814014.25961.912.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 15:59 -0700, Alex Williamson wrote:
> 
> @@ -2582,7 +2582,7 @@ static dma_addr_t __intel_map_single(struct
> device *hwdev, phys_addr_t paddr,
>         BUG_ON(dir == DMA_NONE);
>  
>         if (iommu_no_mapping(hwdev))
> -               return paddr;
> +               return paddr + size > dma_mask ? 0 : paddr; 

Especially on 32-bit without PAE, that 'paddr + size' can wrap.

How's this... (Alex, you can tell me if you still want it to be From:
you after I changed the comments).


From:  Alex Williamson <alex.williamson@hp.com>
Date: Wed, 4 Nov 2009 15:59:34 -0700
Subject: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent on passthrough

The model for IOMMU passthrough is that decent devices that can cope
with DMA to all of memory get passthrough; crappy devices with a limited
dma_mask don't -- they get to use the IOMMU anyway.

This is done on the basis that IOMMU passthrough is usually wanted for
performance reasons, and it's only the decent PCI devices that you
really care about performance for, while the crappy 32-bit ones like
your USB controller can just use the IOMMU and you won't really care.

Unfortunately, the check for this was only looking at dev->dma_mask, not
at dev->coherent_dma_mask. And some devices have a 32-bit
coherent_dma_mask even though they have a full 64-bit dma_mask.

Even more unfortunately, fixing that simple oversight would upset
certain broken HP devices. Not only do they have a 32-bit
coherent_dma_mask, but they also have a tendency to do stray DMA to
unmapped addresses. And then they die when they take the DMA fault they
so richly deserve.

So if we do the 'correct' fix, it'll mean that affects users have to
disable IOMMU support completely on "a large percentage of servers from
a major vendor."

Personally, I have little sympathy -- given that this is the _same_
'major vendor' who is shipping machines which claim to have IOMMU
support but have obviously never _once_ booted a VT-d capable OS to do
any form of QA. But strictly speaking, it _would_ be a regression even
though it only ever worked by fluke and the hardware is arguably broken.

For 2.6.33, we'll come up with a quirk which gives swiotlb support
for this particular device, and other devices with an inadequate
coherent_dma_mask will just get normal IOMMU mapping.

The simplest fix for 2.6.32, though, is just to jump through some hoops
to try to allocate coherent DMA memory for such devices in a place that
they can reach. We'd use dma_generic_alloc_coherent() for this if it
existed on IA64.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/intel-iommu.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b1e97e6..fe9ca58 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2582,7 +2582,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (iommu_no_mapping(hwdev))
-		return paddr;
+		return paddr > dma_mask - size ? 0 : paddr;
 
 	domain = get_valid_domain_for_dev(pdev);
 	if (!domain)
@@ -2767,7 +2767,15 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
 
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
-	flags &= ~(GFP_DMA | GFP_DMA32);
+
+	if (!iommu_no_mapping(hwdev))
+		flags &= ~(GFP_DMA | GFP_DMA32);
+	else if (hwdev->coherent_dma_mask < dma_get_required_mask()) {
+		if (hwdev->coherent_dma_mask < DMA_BIT_MASK(32))
+			flags |= GFP_DMA;
+		else
+			flags |= GFP_DMA32;
+	}
 
 	vaddr = (void *)__get_free_pages(flags, order);
 	if (!vaddr)
-- 
1.6.5.2



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

