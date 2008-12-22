Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbYLVS35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbYLVS35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYLVS2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:54 -0500
Received: from gw.goop.org ([64.81.55.164]:44694 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbYLVS2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 9] swiotlb: Add support for systems with highmem
X-Mercurial-Node: 51a2fa6a566144bc14c008bdaddb48989b654135
Message-Id: <51a2fa6a566144bc14c0.1229970369@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

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
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -14,6 +14,7 @@
  * 04/07/.. ak		Better overflow handling. Assorted fixes.
  * 05/09/10 linville	Add support for syncing ranges, support syncing for
  *			DMA_BIDIRECTIONAL mappings, miscellaneous cleanup.
+ * 08/12/11 beckyb	Add highmem support
  */
 
 #include <linux/cache.h>
@@ -26,6 +27,7 @@
 #include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
+#include <linux/highmem.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -326,6 +328,45 @@
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
@@ -426,7 +467,7 @@
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		memcpy(dma_addr, phys_to_virt(phys), size);
+		swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
 
 	return dma_addr;
 }
@@ -446,11 +487,7 @@
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
@@ -490,13 +527,13 @@
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


