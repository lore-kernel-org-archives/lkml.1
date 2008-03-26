Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYCZHxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYCZHxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYCZHxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:53:36 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:48140 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYCZHxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:53:36 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] fsldma: Split the MPC83xx event from MPC85xx and refine irq codes.
Date: Wed, 26 Mar 2008 15:42:35 +0800
Message-Id: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 26 Mar 2008 07:47:39.0457 (UTC) FILETIME=[AA50DB10:01C88F15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split MPC83xx EOCDI event from MPC85xx EOLNI event, which is
also need to update cookie and start the next transfer.
The DMA channel irq handler function code is refined.
The patch is tested on MPC8377MDS board.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 07de0cf..b5a9d79 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -696,6 +696,8 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 {
 	struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
 	u32 stat;
+	int update_cookie = 0;
+	int xfer_ld_q = 0;
 
 	stat = get_sr(fsl_chan);
 	dev_dbg(fsl_chan->dev, "event: channel %d, stat = 0x%x\n",
@@ -720,8 +722,8 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 			 * Now, update the completed cookie, and continue the
 			 * next uncompleted transfer.
 			 */
-			fsl_dma_update_completed_cookie(fsl_chan);
-			fsl_chan_xfer_ld_queue(fsl_chan);
+			update_cookie = 1;
+			xfer_ld_q = 1;
 		}
 		stat &= ~FSL_DMA_SR_PE;
 	}
@@ -734,19 +736,33 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
 			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
-		fsl_dma_update_completed_cookie(fsl_chan);
+		update_cookie = 1;
+	}
+
+	/* For MPC8349, EOCDI event need to update cookie
+	 * and start the next transfer if it exist.
+	 */
+	if (stat & FSL_DMA_SR_EOCDI) {
+		dev_dbg(fsl_chan->dev, "event: End-of-Chain link INT\n");
+		stat &= ~FSL_DMA_SR_EOCDI;
+		update_cookie = 1;
+		xfer_ld_q = 1;
 	}
 
 	/* If it current transfer is the end-of-transfer,
 	 * we should clear the Channel Start bit for
 	 * prepare next transfer.
 	 */
-	if (stat & (FSL_DMA_SR_EOLNI | FSL_DMA_SR_EOCDI)) {
+	if (stat & FSL_DMA_SR_EOLNI) {
 		dev_dbg(fsl_chan->dev, "event: End-of-link INT\n");
 		stat &= ~FSL_DMA_SR_EOLNI;
-		fsl_chan_xfer_ld_queue(fsl_chan);
+		xfer_ld_q = 1;
 	}
 
+	if (update_cookie)
+		fsl_dma_update_completed_cookie(fsl_chan);
+	if (xfer_ld_q)
+		fsl_chan_xfer_ld_queue(fsl_chan);
 	if (stat)
 		dev_dbg(fsl_chan->dev, "event: unhandled sr 0x%02x\n",
 					stat);
-- 
1.5.4

