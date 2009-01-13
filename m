Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZAMPfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZAMPfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZAMPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:34:46 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:54490 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZAMPep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:34:45 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, dan.j.williams@intel.com,
       maciej.sosnowski@intel.com
Subject: [PATCH] dmatest: Use custom map/unmap for destination buffer
Date: Wed, 14 Jan 2009 00:34:40 +0900
Message-Id: <1231860880-6277-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmatest driver should use DMA_BIDIRECTIONAL on the destination buffer
to ensure that the poison values are written to RAM and not just written
to cache and discarded.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/dma/dmatest.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index ed9636b..02c171f 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -218,6 +218,10 @@ static int dmatest_func(void *data)
 	dma_chan_get(chan);
 
 	while (!kthread_should_stop()) {
+		struct dma_device *dev = chan->device;
+		struct dma_async_tx_descriptor *tx;
+		dma_addr_t dma_src, dma_dest;
+
 		total_tests++;
 
 		len = dmatest_random() % test_buf_size + 1;
@@ -227,10 +231,30 @@ static int dmatest_func(void *data)
 		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
 		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
 
-		cookie = dma_async_memcpy_buf_to_buf(chan,
-				thread->dstbuf + dst_off,
-				thread->srcbuf + src_off,
-				len);
+		dma_src = dma_map_single(dev->dev, thread->srcbuf + src_off,
+				len, DMA_TO_DEVICE);
+		/* map with DMA_BIDIRECTIONAL to force writeback/invalidate */
+		dma_dest = dma_map_single(dev->dev, thread->dstbuf,
+				test_buf_size, DMA_BIDIRECTIONAL);
+
+		tx = dev->device_prep_dma_memcpy(chan, dma_dest + dst_off,
+				dma_src, len,
+				DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP);
+		if (!tx) {
+			dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
+			dma_unmap_single(dev->dev, dma_dest,
+					test_buf_size, DMA_BIDIRECTIONAL);
+			pr_warning("%s: #%u: prep error with src_off=0x%x "
+					"dst_off=0x%x len=0x%x\n",
+					thread_name, total_tests - 1,
+					src_off, dst_off, len);
+			msleep(100);
+			failed_tests++;
+			continue;
+		}
+		tx->callback = NULL;
+		cookie = tx->tx_submit(tx);
+
 		if (dma_submit_error(cookie)) {
 			pr_warning("%s: #%u: submit error %d with src_off=0x%x "
 					"dst_off=0x%x len=0x%x\n",
@@ -254,6 +278,9 @@ static int dmatest_func(void *data)
 			failed_tests++;
 			continue;
 		}
+		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
+		dma_unmap_single(dev->dev, dma_dest,
+				test_buf_size, DMA_BIDIRECTIONAL);
 
 		error_count = 0;
 
-- 
1.5.6.3

