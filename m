Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYJWOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYJWOPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYJWOPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:15:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:41268 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbYJWOPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:15:00 -0400
Date: Thu, 23 Oct 2008 23:14:29 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, joerg.roedel@amd.com
Subject: [PATCH] x86: restore the old swiotlb alloc_coherent behavior
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081023231230V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restores the old swiotlb alloc_coherent behavior (before the
alloc_coherent rewrite):

http://lkml.org/lkml/2008/8/12/200

The old alloc_coherent avoids GFP_DMA allocation first and if the
allocated address is not fit for the device's coherent_dma_mask, then
dma_alloc_coherent does GFP_DMA allocation. If it fails,
alloc_coherent calls swiotlb_alloc_coherent (in short, we rarely used
swiotlb_alloc_coherent).

After the alloc_coherent rewrite, dma_alloc_coherent
(include/asm-x86/dma-mapping.h) directly calls swiotlb_alloc_coherent.
It means that we possibly can't handle a device having dma_masks >
24bit < 32bits since swiotlb_alloc_coherent doesn't have the above
GFP_DMA retry mechanism.

This patch fixes x86's swiotlb alloc_coherent to use the GFP_DMA retry
mechanism, which dma_generic_alloc_coherent() provides now
(pci-nommu.c and GART IOMMU driver also use
dma_generic_alloc_coherent).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb_64.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index c4ce033..3c539d1 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,9 +18,21 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
+static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flags)
+{
+	void *vaddr;
+
+	vaddr = dma_generic_alloc_coherent(hwdev, size, dma_handle, flags);
+	if (vaddr)
+		return vaddr;
+
+	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
+}
+
 struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
-	.alloc_coherent = swiotlb_alloc_coherent,
+	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
 	.map_single = swiotlb_map_single_phys,
 	.unmap_single = swiotlb_unmap_single,
-- 
1.5.5.GIT

