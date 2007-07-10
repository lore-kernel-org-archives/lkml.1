Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXGJMQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXGJMQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbXGJMQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:16:05 -0400
Received: from mta1.cl.cam.ac.uk ([128.232.0.15]:58218 "EHLO mta1.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbXGJMQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:16:04 -0400
X-Greylist: delayed 3726 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 08:16:03 EDT
To: linux-kernel@vger.kernel.org
cc: davidm@hpl.hp.com, keir.fraser@cl.cam.ac.uk
Subject: [PATCH] Fix swiotlb_sync_single_range()
Date: Tue, 10 Jul 2007 12:13:56 +0100
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Message-Id: <E1I8DfI-0007pU-00@mta1.cl.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the swiotlb maps a multi-slab region, swiotlb_sync_single_range()
can be invoked to sync a sub-region which does not include the first
slab. Unfortunately io_tlb_orig_addr[] is only initialised for the
first slab, and hence the call to sync_single() will read a garbage
orig_addr in this case.

This patch fixes the issue by initialising all mapped slabs in
io_tlb_orig_addr[]. It also correctly adjusts the buffer pointer in
sync_single() to handle the case that the given dma_addr is not
aligned on a slab boundary.

Signed-off-by: Keir Fraser <keir.fraser@cl.cam.ac.uk>

(Please Cc me in any response: I am not subscribed to lkml)

diff -urpN linux-2.6.22/lib/swiotlb.c linux-2.6.22-new/lib/swiotlb.c
--- linux-2.6.22/lib/swiotlb.c	2007-07-10 11:38:33.000000000 +0100
+++ linux-2.6.22-new/lib/swiotlb.c	2007-07-10 11:48:44.000000000 +0100
@@ -357,7 +357,8 @@ map_single(struct device *hwdev, char *b
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	io_tlb_orig_addr[index] = buffer;
+	for (i = 0; i < nslots; i++)
+		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
 		memcpy(dma_addr, buffer, size);
 
@@ -418,6 +419,8 @@ sync_single(struct device *hwdev, char *
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	char *buffer = io_tlb_orig_addr[index];
 
+	buffer += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
+
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
