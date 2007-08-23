Return-Path: <linux-kernel-owner+w=401wt.eu-S934349AbXHWAMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbXHWAMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXHWAMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:12:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:26860 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbXHWAMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,296,1183359600"; 
   d="scan'208";a="266676567"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH] IOAT: ioatdma needs to to play nice in a multi-dma-client
	world
To: netdev@vger.kernel.org, davem@davemloft.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com, jgarzik@pobox.com
Date: Wed, 22 Aug 2007 17:12:18 -0700
Message-ID: <20070823001218.11648.49528.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the DMA engine has a multi-client interface, fix the ioatdma
driver to play along.  At the same time, remove a couple of unnecessary
reads and writes.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioatdma.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 2d1f178..41b18c5 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -191,17 +191,12 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 	int i;
 	LIST_HEAD(tmp_list);
 
-	/*
-	 * In-use bit automatically set by reading chanctrl
-	 * If 0, we got it, if 1, someone else did
-	 */
-	chanctrl = readw(ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
-	if (chanctrl & IOAT_CHANCTRL_CHANNEL_IN_USE)
-		return -EBUSY;
+	/* have we already been set up? */
+	if (!list_empty(&ioat_chan->free_desc))
+		return INITIAL_IOAT_DESC_COUNT;
 
         /* Setup register to interrupt and write completion status on error */
-	chanctrl = IOAT_CHANCTRL_CHANNEL_IN_USE |
-		IOAT_CHANCTRL_ERR_INT_EN |
+	chanctrl = IOAT_CHANCTRL_ERR_INT_EN |
 		IOAT_CHANCTRL_ANY_ERR_ABORT_EN |
 		IOAT_CHANCTRL_ERR_COMPLETION_EN;
         writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
@@ -282,11 +277,6 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 			in_use_descs - 1);
 
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
-
-	/* Tell hw the chan is free */
-	chanctrl = readw(ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
-	chanctrl &= ~IOAT_CHANCTRL_CHANNEL_IN_USE;
-	writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
 static struct dma_async_tx_descriptor *
