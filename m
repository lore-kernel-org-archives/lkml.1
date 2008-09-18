Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYIRQLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYIRQLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYIRQK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:10:56 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:59444 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYIRQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:10:55 -0400
From: Timur Tabi <timur@freescale.com>
To: dan.j.williams@intel.com, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] dmatest: properly handle duplicate DMA channels
Date: Thu, 18 Sep 2008 11:10:17 -0500
Message-Id: <1221754217-26974-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the the dmatest driver so that it handles duplicate DMA channels
properly.

When a DMA client is notified of an available DMA channel, it must check if it
has already allocated resources for that channel.  If so, it should return
DMA_DUP.  This can happen, for example, if a DMA driver calls
dma_async_device_register() more than once.

Signed-off-by: Timur Tabi <timur@freescale.com>
---

Replaced list_for_each_entry_safe() with list_for_each_entry()

 drivers/dma/dmatest.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a08d197..422500c 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -325,6 +325,11 @@ static enum dma_state_client dmatest_add_channel(struct dma_chan *chan)
 	struct dmatest_thread	*thread;
 	unsigned int		i;
 
+	/* Have we already been told about this channel? */
+	list_for_each_entry(dtc, &dmatest_channels, node)
+		if (dtc->chan == chan)
+			return DMA_DUP;
+
 	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_ATOMIC);
 	if (!dtc) {
 		pr_warning("dmatest: No memory for %s\n", chan->dev.bus_id);
-- 
1.5.5

