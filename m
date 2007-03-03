Return-Path: <linux-kernel-owner+w=401wt.eu-S2992904AbXCCCjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992904AbXCCCjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 21:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992914AbXCCCjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 21:39:11 -0500
Received: from [63.64.152.142] ([63.64.152.142]:1458 "EHLO gitlost.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992904AbXCCCjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 21:39:10 -0500
X-Greylist: delayed 1781 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 21:39:10 EST
From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 4/9] ioatdma: Remove the use of writeq from the ioatdma driver
Date: Fri, 02 Mar 2007 18:24:24 -0800
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070303022423.31033.52798.stgit@gitlost.site>
In-Reply-To: <20070303022238.31033.84558.stgit@gitlost.site>
References: <20070303022238.31033.84558.stgit@gitlost.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one now anyway, and it's not in a performance path,
so make it behave the same on 32-bit and 64-bit CPUs.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 drivers/dma/ioatdma.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index ec11131..cbf93ca 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -608,13 +608,11 @@ static void ioat_start_null_desc(struct ioat_dma_chan *ioat_chan)
 	list_add_tail(&desc->node, &ioat_chan->used_desc);
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
-#if (BITS_PER_LONG == 64)
-	writeq(desc->phys, ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET);
-#else
-	writel((u32) desc->phys,
+	writel(((u64) desc->phys) & 0x00000000FFFFFFFF,
 	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_LOW);
-	writel(0, ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_HIGH);
-#endif
+	writel(((u64) desc->phys) >> 32,
+	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_HIGH);
+
 	writeb(IOAT_CHANCMD_START, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 }
 

