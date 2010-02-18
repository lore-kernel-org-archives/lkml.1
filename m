Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab0BRRMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:12:15 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:58036 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab0BRRMJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 12:12:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/10] swiotlb: Make printk's use same prefix and include dev_err when possible.
Date: Thu, 18 Feb 2010 11:27:00 -0500
Message-Id: <1266510426-6815-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B7D6EA2.0223:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various printk's had the prefix 'DMA' in them, but not all of them.
This makes all of the printk's have the 'DMA' in them and for error
cases use the 'dev_err' macro.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7b66fc3..0eb64d7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -162,9 +162,9 @@ void swiotlb_print_info(void)
 	pstart = virt_to_phys(io_tlb_start);
 	pend = virt_to_phys(io_tlb_end);
 
-	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
+	printk(KERN_INFO "DMA: Placing %luMB software IO TLB between %p - %p\n",
 	       bytes >> 20, io_tlb_start, io_tlb_end);
-	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
+	printk(KERN_INFO "DMA: software IO TLB at phys %#llx - %#llx\n",
 	       (unsigned long long)pstart,
 	       (unsigned long long)pend);
 }
@@ -190,7 +190,7 @@ swiotlb_init_early(size_t default_size, int verbose)
 	 */
 	io_tlb_start = alloc_bootmem_low_pages(bytes);
 	if (!io_tlb_start)
-		panic("Cannot allocate SWIOTLB buffer");
+		panic("DMA: Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
 
 	/*
@@ -209,7 +209,7 @@ swiotlb_init_early(size_t default_size, int verbose)
 	 */
 	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
 	if (!io_tlb_overflow_buffer)
-		panic("Cannot allocate SWIOTLB overflow buffer!\n");
+		panic("DMA: Cannot allocate SWIOTLB overflow buffer!\n");
 	if (verbose)
 		swiotlb_print_info();
 }
@@ -255,8 +255,8 @@ swiotlb_init_late(size_t default_size)
 		goto cleanup1;
 
 	if (order != get_order(bytes)) {
-		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
-		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
+		printk(KERN_WARNING "DMA: Warning: only able to allocate %ld MB"
+		       " for software IO TLB\n", (PAGE_SIZE << order) >> 20);
 		io_tlb_nslabs = SLABS_PER_PAGE << order;
 		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	}
@@ -602,7 +602,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 
 	/* Confirm address can be DMA'd by device */
 	if (dev_addr + size - 1 > dma_mask) {
-		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
+		dev_err(hwdev, "DMA: hwdev DMA mask = 0x%016Lx, " \
+		       "dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
 
@@ -640,8 +641,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	 * When the mapping is small enough return a static buffer to limit
 	 * the damage, or panic when the transfer is too big.
 	 */
-	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
-	       "device %s\n", size, dev ? dev_name(dev) : "?");
+	dev_err(dev, "DMA: Out of SW-IOMMU space for %zu bytes.", size);
 
 	if (size <= io_tlb_overflow || !do_panic)
 		return;
@@ -694,7 +694,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * Ensure that the address returned is DMA'ble
 	 */
 	if (!dma_capable(dev, dev_addr, size))
-		panic("map_single: bounce buffer is not DMA'ble");
+		panic("DMA: swiotlb_map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
 }
-- 
1.6.2.5

