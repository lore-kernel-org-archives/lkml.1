Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYCTGoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYCTGoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 02:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYCTGn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 02:43:57 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:53156 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYCTGnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 02:43:55 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] fsldma: Remove CONFIG_FSL_DMA_SELFTEST, keep fsl_dma_self_test() running always.
Date: Thu, 20 Mar 2008 14:40:00 +0800
Message-Id: <1205995200-8248-1-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 20 Mar 2008 06:43:49.0827 (UTC) FILETIME=[C1333130:01C88A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always enabling the fsl_dma_self_test() to ensure the DMA controller
should works well after the driver probed.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/Kconfig  |    8 --------
 drivers/dma/fsldma.c |   13 +++----------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 27340a7..6239c3d 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -46,14 +46,6 @@ config FSL_DMA
 	  MPC8560/40, MPC8555, MPC8548 and MPC8641 processors.
 	  The MPC8349, MPC8360 is also supported.
 
-config FSL_DMA_SELFTEST
-	bool "Enable the self test for each DMA channel"
-	depends on FSL_DMA
-	default y
-	---help---
-	  Enable the self test for each DMA channel. A self test will be
-	  performed after the channel probed to ensure the DMA works well.
-
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 7269230..07de0cf 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -776,15 +776,13 @@ static void dma_do_tasklet(unsigned long data)
 	fsl_chan_ld_cleanup(fsl_chan);
 }
 
-#ifdef FSL_DMA_CALLBACKTEST
-static void fsl_dma_callback_test(struct fsl_dma_chan *fsl_chan)
+static void fsl_dma_callback_test(void *param)
 {
+	struct fsl_dma_chan *fsl_chan = param;
 	if (fsl_chan)
-		dev_info(fsl_chan->dev, "selftest: callback is ok!\n");
+		dev_dbg(fsl_chan->dev, "selftest: callback is ok!\n");
 }
-#endif
 
-#ifdef CONFIG_FSL_DMA_SELFTEST
 static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 {
 	struct dma_chan *chan;
@@ -875,13 +873,11 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	cookie = fsl_dma_tx_submit(tx3);
 	cookie = fsl_dma_tx_submit(tx2);
 
-#ifdef FSL_DMA_CALLBACKTEST
 	if (dma_has_cap(DMA_INTERRUPT, ((struct fsl_dma_device *)
 	    dev_get_drvdata(fsl_chan->dev->parent))->common.cap_mask)) {
 		tx3->callback = fsl_dma_callback_test;
 		tx3->callback_param = fsl_chan;
 	}
-#endif
 	fsl_dma_memcpy_issue_pending(chan);
 	msleep(2);
 
@@ -906,7 +902,6 @@ out:
 	kfree(src);
 	return err;
 }
-#endif
 
 static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 			const struct of_device_id *match)
@@ -997,11 +992,9 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 		}
 	}
 
-#ifdef CONFIG_FSL_DMA_SELFTEST
 	err = fsl_dma_self_test(new_fsl_chan);
 	if (err)
 		goto err;
-#endif
 
 	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
 				match->compatible, new_fsl_chan->irq);
-- 
1.5.4

