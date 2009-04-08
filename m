Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbZDHP10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbZDHP10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933490AbZDHP0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:26:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:52413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231AbZDHP0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:26:22 -0400
Date: Wed, 8 Apr 2009 15:25:17 GMT
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       galak@kernel.crashing.org, tglx@linutronix.de,
       beckyb@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       galak@kernel.crashing.org, tglx@linutronix.de,
       beckyb@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <1239199761-22886-6-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-6-git-send-email-galak@kernel.crashing.org>
Subject: [tip:core/iommu] swiotlb: rename unmap_single to do_unmap_single
Message-ID: <tip-7fcebbd2d984eac3fdd6da2f4453e7c43d32de89@git.kernel.org>
Git-Commit-ID: 7fcebbd2d984eac3fdd6da2f4453e7c43d32de89
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:25:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fcebbd2d984eac3fdd6da2f4453e7c43d32de89
Gitweb:     http://git.kernel.org/tip/7fcebbd2d984eac3fdd6da2f4453e7c43d32de89
Author:     Becky Bruce <beckyb@kernel.crashing.org>
AuthorDate: Wed, 8 Apr 2009 09:09:19 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 16:18:37 +0200

swiotlb: rename unmap_single to do_unmap_single

Previously, swiotlb_unmap_page and swiotlb_unmap_sg were
duplicating very similar code.  Refactor that code into a
new unmap_single and unmap_single use do_unmap_single.

Note that the swiotlb_unmap_sg code was previously doing
a complicated comparison to determine if an addresses needed
to be unmapped where a simple is_swiotlb_buffer() call
would have sufficed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: jeremy@goop.org
Cc: ian.campbell@citrix.com
LKML-Reference: <1239199761-22886-6-git-send-email-galak@kernel.crashing.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/swiotlb.c |   42 +++++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d81afab..2bde54a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -482,7 +482,7 @@ found:
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -591,7 +591,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		       (unsigned long long)dev_addr);
 
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
+		do_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
 		return NULL;
 	}
 	*dma_handle = dev_addr;
@@ -608,7 +608,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		free_pages((unsigned long) vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
+		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
@@ -688,17 +688,29 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
  * After this call, reads by the cpu to the buffer are guaranteed to see
  * whatever the device wrote there.
  */
-void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
-			size_t size, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+			 size_t size, int dir)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
-		unmap_single(hwdev, dma_addr, size, dir);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+
+	if (is_swiotlb_buffer(dma_addr)) {
+		do_unmap_single(hwdev, dma_addr, size, dir);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(dma_addr, size);
+}
+
+void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			size_t size, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
+{
+	unmap_single(hwdev, dev_addr, size, dir);
 }
 EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
 
@@ -850,13 +862,9 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	BUG_ON(dir == DMA_NONE);
 
-	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
-				     sg->dma_length, dir);
-		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
-	}
+	for_each_sg(sgl, sg, nelems, i)
+		unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
+
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
