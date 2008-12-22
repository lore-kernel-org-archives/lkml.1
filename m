Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYLVS3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYLVS3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYLVS2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:52 -0500
Received: from gw.goop.org ([64.81.55.164]:44699 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751713AbYLVS2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 9] revert "swiotlb: factor out copy to/from device."
X-Mercurial-Node: e9674b11c9fd4039946d0ebba7690b5d9893851d
Message-Id: <e9674b11c9fd4039946d.1229970364@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:04 -0800
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

git commit 1b548f667c1487d92e794a9f7a67788f49b952d8

---
 lib/swiotlb.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -335,15 +335,6 @@
 	return addr >= io_tlb_start && addr < io_tlb_end;
 }
 
-static void
-__sync_single(char *buffer, char *dma_addr, size_t size, int dir)
-{
-	if (dir == DMA_TO_DEVICE)
-		memcpy(dma_addr, buffer, size);
-	else
-		memcpy(buffer, dma_addr, size);
-}
-
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
@@ -445,7 +436,7 @@
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
+		memcpy(dma_addr, buffer, size);
 
 	return dma_addr;
 }
@@ -469,7 +460,7 @@
 		 * bounce... copy the data back into the original buffer * and
 		 * delete the bounce buffer.
 		 */
-		__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
+		memcpy(buffer, dma_addr, size);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -509,13 +500,13 @@
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
+			memcpy(buffer, dma_addr, size);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
+			memcpy(dma_addr, buffer, size);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;


