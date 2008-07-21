Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbYGUOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbYGUOPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYGUOP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:15:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYGUOPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:15:25 -0400
Date: Mon, 21 Jul 2008 10:15:22 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: iommu fix potential overflow in alloc_iommu()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This didn't appear on LKML or any of the mirrors ... trying again)

It is possible that alloc_iommu()'s boundary_size overflows as
dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
boundary_size triggers a BUG_ON() in the iommu code.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index faf3229..baecb47 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -91,7 +91,7 @@ static unsigned long alloc_iommu(struct device *dev, int size)
 
 	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
 			   PAGE_SIZE) >> PAGE_SHIFT;
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
 			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
