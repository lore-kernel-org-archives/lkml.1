Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYLVS3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYLVS3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYLVS2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:53 -0500
Received: from gw.goop.org ([64.81.55.164]:44702 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860AbYLVS2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 8 of 9] swiotlb: cleanups to swiotlb_bounce()
X-Mercurial-Node: 0e514a12d8a05941d55b400c52da7439e12c6fb6
Message-Id: <0e514a12d8a05941d55b.1229970370@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:10 -0800
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

Make swiotlb_bounce test each page for highness rather than relying on
CONFIG_HIGHMEM, and a couple of other cleanups.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 lib/swiotlb.c |   61 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -25,6 +25,7 @@
 #include <linux/swiotlb.h>
 #include <linux/string.h>
 #include <linux/swiotlb.h>
+#include <linux/pfn.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>
@@ -330,40 +331,42 @@
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
  */
-void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
-		  enum dma_data_direction dir)
+static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+			   enum dma_data_direction dir)
 {
-#ifdef CONFIG_HIGHMEM
-	/* The buffer may not have a mapping.  Map it in and copy */
-	unsigned int offset = ((unsigned long)phys &
-			       ((1 << PAGE_SHIFT) - 1));
-	char *buffer;
-	unsigned int sz = 0;
-	unsigned long flags;
+	unsigned long pfn = PFN_DOWN(phys);
 
-	while (size) {
-		sz = ((PAGE_SIZE - offset) > size) ? size :
-			PAGE_SIZE - offset;
-		local_irq_save(flags);
-		buffer = kmap_atomic(pfn_to_page(phys >> PAGE_SHIFT),
-				     KM_BOUNCE_READ);
+	if (PageHighMem(pfn_to_page(pfn))) {
+		/* The buffer does not have a mapping.  Map it in and copy */
+		unsigned int offset = phys & ~PAGE_MASK;
+		char *buffer;
+		unsigned int sz = 0;
+		unsigned long flags;
+
+		while (size) {
+			sz = min(PAGE_SIZE - offset, size);
+
+			local_irq_save(flags);
+			buffer = kmap_atomic(pfn_to_page(pfn),
+					     KM_BOUNCE_READ);
+			if (dir == DMA_TO_DEVICE)
+				memcpy(dma_addr, buffer + offset, sz);
+			else
+				memcpy(buffer + offset, dma_addr, sz);
+			kunmap_atomic(buffer, KM_BOUNCE_READ);
+			local_irq_restore(flags);
+
+			size -= sz;
+			pfn++;
+			dma_addr += sz;
+			offset = 0;
+		}
+	} else {
 		if (dir == DMA_TO_DEVICE)
-			memcpy(dma_addr, buffer + offset, sz);
+			memcpy(dma_addr, phys_to_virt(phys), size);
 		else
-			memcpy(buffer + offset, dma_addr, sz);
-		kunmap_atomic(buffer, KM_BOUNCE_READ);
-		local_irq_restore(flags);
-		size -= sz;
-		phys += sz;
-		dma_addr += sz;
-		offset = 0;
+			memcpy(phys_to_virt(phys), dma_addr, size);
 	}
-#else
-	if (dir == DMA_TO_DEVICE)
-		memcpy(dma_addr, phys_to_virt(phys), size);
-	else
-		memcpy(phys_to_virt(phys), dma_addr, size);
-#endif
 }
 
 /*


