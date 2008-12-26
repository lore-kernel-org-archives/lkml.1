Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYLZPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYLZPbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 10:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYLZPbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 10:31:13 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:58629 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYLZPbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 10:31:12 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: hskinnemoen@atmel.com, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com, ralf@linux-mips.org
Subject: [PATCH] dmatest: flush and invalidate destination buffer before DMA
Date: Sat, 27 Dec 2008 00:31:08 +0900
Message-Id: <1230305468-18021-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On non-coherent architectures, such as MIPS, the dmatest reports
mismatches on just before and after the DMA area.  This is because
test patterns in the dstbuf discarded from cache without writing to
main memory.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/dma/dmatest.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index ed9636b..6b747dc 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -202,6 +202,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	int			ret;
+	dma_addr_t		dma_dest;
 
 	thread_name = current->comm;
 
@@ -226,6 +227,12 @@ static int dmatest_func(void *data)
 
 		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
 		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
+		/* flush and invalidate caches for whole dstbuf */
+		dma_dest = dma_map_single(chan->device->dev,
+				thread->dstbuf,
+				test_buf_size, DMA_BIDIRECTIONAL);
+		dma_unmap_single(chan->device->dev, dma_dest,
+				test_buf_size, DMA_BIDIRECTIONAL);
 
 		cookie = dma_async_memcpy_buf_to_buf(chan,
 				thread->dstbuf + dst_off,
-- 
1.5.6.3

