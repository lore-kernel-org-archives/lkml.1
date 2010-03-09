Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0CIWMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:12:32 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:19180 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0CIWM3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 9 Mar 2010 17:12:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, alex.williamson@hp.com,
       dwmw2@infradead.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] swiotlb: Make printk's use same prefix and include dev_err when possible.
Date: Tue,  9 Mar 2010 16:54:21 -0500
Message-Id: <1268171662-12701-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268171662-12701-3-git-send-email-konrad.wilk@oracle.com>
References: <1268171662-12701-1-git-send-email-konrad.wilk@oracle.com>
 <1268171662-12701-2-git-send-email-konrad.wilk@oracle.com>
 <1268171662-12701-3-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B96C78E.01E1:SCFMA4539814,ss=1,fgs=0
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
index 737ceb7..655883b 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -134,9 +134,9 @@ void swiotlb_print_info(void)
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
@@ -162,7 +162,7 @@ swiotlb_init_early(size_t default_size, int verbose)
 	 */
 	io_tlb_start = alloc_bootmem_low_pages(bytes);
 	if (!io_tlb_start)
-		panic("Cannot allocate SWIOTLB buffer");
+		panic("DMA: Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
 
 	/*
@@ -181,7 +181,7 @@ swiotlb_init_early(size_t default_size, int verbose)
 	 */
 	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
 	if (!io_tlb_overflow_buffer)
-		panic("Cannot allocate SWIOTLB overflow buffer!\n");
+		panic("DMA: Cannot allocate SWIOTLB overflow buffer!\n");
 	if (verbose)
 		swiotlb_print_info();
 }
@@ -227,8 +227,8 @@ swiotlb_init_late(size_t default_size)
 		goto cleanup1;
 
 	if (order != get_order(bytes)) {
-		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
-		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
+		printk(KERN_WARNING "DMA: Warning: only able to allocate %ld MB"
+		       " for software IO TLB\n", (PAGE_SIZE << order) >> 20);
 		io_tlb_nslabs = SLABS_PER_PAGE << order;
 		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	}
@@ -574,7 +574,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 
 	/* Confirm address can be DMA'd by device */
 	if (dev_addr + size - 1 > dma_mask) {
-		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
+		dev_err(hwdev, "DMA: hwdev DMA mask = 0x%016Lx, " \
+		       "dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
 
@@ -612,8 +613,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	 * When the mapping is small enough return a static buffer to limit
 	 * the damage, or panic when the transfer is too big.
 	 */
-	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
-	       "device %s\n", size, dev ? dev_name(dev) : "?");
+	dev_err(dev, "DMA: Out of SW-IOMMU space for %zu bytes.", size);
 
 	if (size <= io_tlb_overflow || !do_panic)
 		return;
@@ -666,7 +666,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * Ensure that the address returned is DMA'ble
 	 */
 	if (!dma_capable(dev, dev_addr, size))
-		panic("map_single: bounce buffer is not DMA'ble");
+		panic("DMA: swiotlb_map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
 }
-- 
1.6.2.5

