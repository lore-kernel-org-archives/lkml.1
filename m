Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYLSFNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYLSFNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYLSFLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:34 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42911 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 07/11] swiotlb: Add support for systems with highmem
Date: Thu, 18 Dec 2008 23:11:18 -0600
Message-Id: <1229663480-10757-8-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On highmem systems, the original dma buffer might not
have a virtual mapping - we need to kmap it in to perform
the bounce.  Extract the code that does the actual
copy into a function that does the kmap if highmem
is enabled, and defaults to the normal swiotlb memcpy
if not.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   53 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e9d5bf6..ab5d3d7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -14,6 +14,7 @@
  * 04/07/.. ak		Better overflow handling. Assorted fixes.
  * 05/09/10 linville	Add support for syncing ranges, support syncing for
  *			DMA_BIDIRECTIONAL mappings, miscellaneous cleanup.
+ * 08/12/11 beckyb	Add highmem support
  */
 
 #include <linux/cache.h>
@@ -24,6 +25,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
+#include <linux/highmem.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -306,6 +308,45 @@ static int is_swiotlb_buffer(char *addr)
 }
 
 /*
+ * Bounce: copy the swiotlb buffer back to the original dma location
+ */
+void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+		  enum dma_data_direction dir)
+{
+#ifdef CONFIG_HIGHMEM
+	/* The buffer may not have a mapping.  Map it in and copy */
+	unsigned int offset = ((unsigned long)phys &
+			       ((1 << PAGE_SHIFT) - 1));
+	char *buffer;
+	unsigned int sz = 0;
+	unsigned long flags;
+
+	while (size) {
+		sz = ((PAGE_SIZE - offset) > size) ? size :
+			PAGE_SIZE - offset;
+		local_irq_save(flags);
+		buffer = kmap_atomic(pfn_to_page(phys >> PAGE_SHIFT),
+				     KM_BOUNCE_READ);
+		if (dir == DMA_TO_DEVICE)
+			memcpy(dma_addr, buffer + offset, sz);
+		else
+			memcpy(buffer + offset, dma_addr, sz);
+		kunmap_atomic(buffer, KM_BOUNCE_READ);
+		local_irq_restore(flags);
+		size -= sz;
+		phys += sz;
+		dma_addr += sz;
+		offset = 0;
+	}
+#else
+	if (dir == DMA_TO_DEVICE)
+		memcpy(dma_addr, phys_to_virt(phys), size);
+	else
+		memcpy(phys_to_virt(phys), dma_addr, size);
+#endif
+}
+
+/*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
@@ -402,7 +443,7 @@ found:
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		memcpy(dma_addr, phys_to_virt(phys), size);
+		swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
 
 	return dma_addr;
 }
@@ -422,11 +463,7 @@ unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 	 * First, sync the memory before unmapping the entry
 	 */
 	if (phys && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
-		/*
-		 * bounce... copy the data back into the original buffer * and
-		 * delete the bounce buffer.
-		 */
-		memcpy(phys_to_virt(phys), dma_addr, size);
+		swiotlb_bounce(phys, dma_addr, size, DMA_FROM_DEVICE);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -466,13 +503,13 @@ sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(phys_to_virt(phys), dma_addr, size);
+			swiotlb_bounce(phys, dma_addr, size, DMA_FROM_DEVICE);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(dma_addr, phys_to_virt(phys), size);
+			swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;
-- 
1.5.6.5

