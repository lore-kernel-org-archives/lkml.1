Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbYEUGTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbYEUGTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYEUGT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:19:27 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:32772 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYEUGT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:19:26 -0400
From: Li Yang <leoli@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Li Yang <leoli@freescale.com>,
       Zhang Wei <zw@zh-kernel.org>
Subject: [PATCH] fsldma: fix incorrect exit path for initialization
Date: Wed, 21 May 2008 14:30:59 +0800
Message-Id: <1211351459-32355-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.5.5.1.248.g4b17
X-OriginalArrivalTime: 21 May 2008 06:19:21.0319 (UTC) FILETIME=[9B832770:01C8BB0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Zhang Wei <zw@zh-kernel.org>
---
 drivers/dma/fsldma.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 054eabf..724f6fd 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -809,8 +809,7 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	if (!src) {
 		dev_err(fsl_chan->dev,
 				"selftest: Cannot alloc memory for test!\n");
-		err = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	dest = src + test_size;
@@ -842,7 +841,7 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	if (fsl_dma_is_complete(chan, cookie, NULL, NULL) != DMA_SUCCESS) {
 		dev_err(fsl_chan->dev, "selftest: Time out!\n");
 		err = -ENODEV;
-		goto out;
+		goto free_resources;
 	}
 
 	/* Test free and re-alloc channel resources */
@@ -927,8 +926,7 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 	if (!new_fsl_chan) {
 		dev_err(&dev->dev, "No free memory for allocating "
 				"dma channels!\n");
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	/* get dma channel register base */
@@ -936,7 +934,7 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 	if (err) {
 		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
 				dev->node->full_name);
-		goto err;
+		goto err_no_reg;
 	}
 
 	new_fsl_chan->feature = *(u32 *)match->data;
@@ -958,7 +956,7 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 		dev_err(&dev->dev, "There is no %d channel!\n",
 				new_fsl_chan->id);
 		err = -EINVAL;
-		goto err;
+		goto err_no_chan;
 	}
 	fdev->chan[new_fsl_chan->id] = new_fsl_chan;
 	tasklet_init(&new_fsl_chan->tasklet, dma_do_tasklet,
@@ -997,23 +995,26 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 		if (err) {
 			dev_err(&dev->dev, "DMA channel %s request_irq error "
 				"with return %d\n", dev->node->full_name, err);
-			goto err;
+			goto err_no_irq;
 		}
 	}
 
 	err = fsl_dma_self_test(new_fsl_chan);
 	if (err)
-		goto err;
+		goto err_self_test;
 
 	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
 				match->compatible, new_fsl_chan->irq);
 
 	return 0;
-err:
-	dma_halt(new_fsl_chan);
-	iounmap(new_fsl_chan->reg_base);
+
+err_self_test:
 	free_irq(new_fsl_chan->irq, new_fsl_chan);
+err_no_irq:
 	list_del(&new_fsl_chan->common.device_node);
+err_no_chan:
+	iounmap(new_fsl_chan->reg_base);
+err_no_reg:
 	kfree(new_fsl_chan);
 	return err;
 }
@@ -1054,8 +1055,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
 	if (!fdev) {
 		dev_err(&dev->dev, "No enough memory for 'priv'\n");
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 	fdev->dev = &dev->dev;
 	INIT_LIST_HEAD(&fdev->common.channels);
@@ -1065,7 +1065,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	if (err) {
 		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
 				dev->node->full_name);
-		goto err;
+		goto err_no_reg;
 	}
 
 	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
@@ -1103,6 +1103,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 
 err:
 	iounmap(fdev->reg_base);
+err_no_reg:
 	kfree(fdev);
 	return err;
 }
-- 
1.5.5.1.248.g4b17

