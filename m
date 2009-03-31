Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbZCaAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbZCaAvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZCaAvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:51:42 -0400
Received: from gw.goop.org ([64.81.55.164]:57028 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZCaAvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:51:41 -0400
Message-ID: <49D16916.5000103@goop.org>
Date: Mon, 30 Mar 2009 17:51:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH] swiotlb: use swiotlb_alloc_boot to allocate emergency pool
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix

Also fix xen_swiotlb_fixup() to deal with sub-slab-sized allocations.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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
 
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 9ce1599..5775691 100644
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


