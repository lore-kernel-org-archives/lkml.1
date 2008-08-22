Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYHVHc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYHVHc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYHVHcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:32:18 -0400
Received: from sh.osrg.net ([192.16.179.4]:37988 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYHVHcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:32:18 -0400
Date: Fri, 22 Aug 2008 16:29:10 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       jbarnes@virtuousgeek.org, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080822070450.GX14110@elte.hu>
References: <20080822064414.GT14110@elte.hu>
	<20080822155754C.fujita.tomonori@lab.ntt.co.jp>
	<20080822070450.GX14110@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080822162957F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 09:04:50 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > Can you drop the following patch in tip/x86/gart?
> > 
> > commit 0bc65ffd52a78a65f582b42503f727b3f3773cc4
> > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date:   Mon Aug 18 00:36:18 2008 +0900
> > 
> >     x86 gart: allocate size-aligned address for alloc_coherent, v2
> > 
> > Joerg's patchset and this patch slightly conflict with the above
> > patch. I'll send a new patch against tip/x86/iommu shortly.
> 
> such conflicts are no problem usually, check out the resolution in 
> tip/master - so there's no need to resend. Also, i just merged 
> tip/x86/gart into tip/x86/iommu, to make the integration even more 
> apparent.

Ok, here's a patch against tip/x86/iommu:

commit 0d8136ea509132c66155ca8a1e7cf60699f95c37
Merge: 766af9f... 7b22ff5...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Aug 22 09:03:43 2008 +0200

    Merge branch 'x86/gart' into x86/iommu

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] gart: allocate size-aligned address for alloc_coherent

alloc_coherent dma_ops callback was added to GART, however, it doesn't
return a size aligned address wrt dma_alloc_coherent, as
DMA-mapping.txt defines. This patch fixes it.

This patch also removes unused gart_map_simple
(dma_mapping_ops->map_simple has gone).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 338c4f2..4d08649 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -261,20 +261,6 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 	return iommu_bus_base + iommu_page*PAGE_SIZE + (phys_mem & ~PAGE_MASK);
 }
 
-static dma_addr_t
-gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
-{
-	dma_addr_t map;
-	unsigned long align_mask;
-
-	align_mask = (1UL << get_order(size)) - 1;
-	map = dma_map_area(dev, paddr, size, dir, align_mask);
-
-	flush_gart();
-
-	return map;
-}
-
 /* Map a single area into the IOMMU */
 static dma_addr_t
 gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
@@ -512,12 +498,21 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 		    gfp_t flag)
 {
 	void *vaddr;
+	unsigned long align_mask;
 
 	vaddr = (void *)__get_free_pages(flag | __GFP_ZERO, get_order(size));
 	if (!vaddr)
 		return NULL;
 
-	*dma_addr = gart_map_single(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL);
+	align_mask = (1UL << get_order(size)) - 1;
+
+	if (!dev)
+		dev = &x86_dma_fallback_dev;
+
+	*dma_addr = dma_map_area(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL,
+				 align_mask);
+	flush_gart();
+
 	if (*dma_addr != bad_dma_address)
 		return vaddr;
 
-- 
1.5.5.GIT

