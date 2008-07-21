Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYGUOPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYGUOPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYGUOPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:15:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbYGUOPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:15:31 -0400
Date: Mon, 21 Jul 2008 10:15:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20080721141506.3720.93023.sendpatchset@prarit.bos.redhat.com>
In-Reply-To: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com>
References: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: PCI: GART iommu alignment fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_alloc_consistent/dma_alloc_coherent is supposed to return size aligned
addresses.

>From Documentation/DMA-mapping.txt:

"pci_alloc_consistent returns two values: the virtual address which you
can use to access it from the CPU and dma_handle which you pass to the
card.

The cpu return address and the DMA bus master address are both
guaranteed to be aligned to the smallest PAGE_SIZE order which
is greater than or equal to the requested size.  This invariant
exists (for example) to guarantee that if you allocate a chunk
which is smaller than or equal to 64 kilobytes, the extent of the
buffer you receive will not cross a 64K boundary."

Fix the GART's alloc_iommu code to return a size aligned address.  Also fix
an incorrect alignment calculation in the iommu-helper code.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index faf3229..329718e 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -96,11 +96,12 @@ static unsigned long alloc_iommu(struct device *dev, int size)
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
-				  size, base_index, boundary_size, 0);
+				  size, base_index, boundary_size, size - 1);
 	if (offset == -1) {
 		need_flush = 1;
 		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
-					  size, base_index, boundary_size, 0);
+					  size, base_index, boundary_size,
+					  size - 1);
 	}
 	if (offset != -1) {
 		set_bit_string(iommu_gart_bitmap, offset, size);
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index a3b8d4c..b970f1b 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -16,7 +16,7 @@ again:
 	index = find_next_zero_bit(map, size, start);
 
 	/* Align allocation */
-	index = (index + align_mask) & ~align_mask;
+	index = (index + align_mask + 1) & ~align_mask;
 
 	end = index + nr;
 	if (end >= size)
