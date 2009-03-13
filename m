Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbZCMRKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbZCMRKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbZCMRCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:02:32 -0400
Received: from gw.goop.org ([64.81.55.164]:57426 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759672AbZCMRCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:02:31 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/27] swiotlb: use swiotlb_alloc_boot to allocate emergency pool
Date: Fri, 13 Mar 2009 10:00:01 -0700
Message-Id: <1236963612-14287-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix xen_swiotlb_fixup() to deal with sub-slab-sized allocations.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |   12 +++++++++---
 lib/swiotlb.c           |    3 ++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 608b8e2..7b6fd3e 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -47,16 +47,22 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 		buf, size);
 
 	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
-	for (i = 0; i < nslabs; i += IO_TLB_SEGSIZE) {
+
+	i = 0;
+	do {
+		int slabs = min(nslabs - i, (unsigned long)IO_TLB_SEGSIZE);
+
 		do {
 			rc = xen_create_contiguous_region(
 				(unsigned long)buf + (i << IO_TLB_SHIFT),
-				get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT),
+				get_order(slabs << IO_TLB_SHIFT),
 				dma_bits);
 		} while (rc && dma_bits++ < max_dma_bits);
 		if (rc)
 			panic(KERN_ERR "xen_create_contiguous_region failed\n");
-	}
+
+		i += slabs;
+	} while(i < nslabs);
 }
 
 int xen_wants_swiotlb(void)
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 32e2bd3..8e6f6c8 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -202,7 +202,8 @@ swiotlb_init_with_default_size(size_t default_size)
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
+	io_tlb_overflow_buffer = swiotlb_alloc_boot(io_tlb_overflow,
+						    io_tlb_overflow >> IO_TLB_SHIFT);
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 
-- 
1.6.0.6

