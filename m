Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbYLPUVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYLPUVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYLPUSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:51 -0500
Received: from gw.goop.org ([64.81.55.164]:45904 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbYLPUSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:48 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 14] swiotlb: factor out copy to/from device
X-Mercurial-Node: ced5a26305adccb581e13ab9df32f3b446c39693
Message-Id: <ced5a26305adccb581e1.1229458652@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 lib/swiotlb.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -312,6 +312,15 @@
 	return addr >= io_tlb_start && addr < io_tlb_end;
 }
 
+static void
+__sync_single(char *buffer, char *dma_addr, size_t size, int dir)
+{
+	if (dir == DMA_TO_DEVICE)
+		memcpy(dma_addr, buffer, size);
+	else
+		memcpy(buffer, dma_addr, size);
+}
+
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
@@ -413,7 +422,7 @@
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		memcpy(dma_addr, buffer, size);
+		__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
 
 	return dma_addr;
 }
@@ -437,7 +446,7 @@
 		 * bounce... copy the data back into the original buffer * and
 		 * delete the bounce buffer.
 		 */
-		memcpy(buffer, dma_addr, size);
+		__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -477,13 +486,13 @@
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(buffer, dma_addr, size);
+			__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(dma_addr, buffer, size);
+			__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;


