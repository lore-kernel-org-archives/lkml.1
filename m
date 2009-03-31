Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbZCaW4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbZCaW4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763796AbZCaWwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:25 -0400
Received: from gw.goop.org ([64.81.55.164]:53481 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761498AbZCaWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:20 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 6/9] swiotlb: use swiotlb_alloc_boot to allocate emergency pool
Date: Tue, 31 Mar 2009 15:52:12 -0700
Message-Id: <1238539935-4295-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix

Also fix xen_swiotlb_fixup() to deal with sub-slab-sized allocations.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/pci/xen-iommu.c |   12 +++++++++---
 lib/swiotlb.c           |    3 ++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 95d0753..2c90642 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -48,16 +48,22 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
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
 {
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 0de836d..e8df499 100644
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

