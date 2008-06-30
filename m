Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbYF3STY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbYF3STY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYF3STP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:19:15 -0400
Received: from www.tglx.de ([62.245.132.106]:40958 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbYF3STO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:19:14 -0400
Date: Mon, 30 Jun 2008 20:18:56 +0200
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Li Yang <leoli@freescale.com>
Cc: Zhang Wei <zw@zh-kernel.org>, linuxppc-embedded@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] DMA Engine: fix error path(s) in fsl-dma driver
Message-ID: <20080630181856.GA6980@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_fsl_dma_probe:
 - kfree(NULL) doesn't hurt but dereferencing the pointer in iounmap does
 - also, the irq can be freed

of_fsl_dma_chan_probe:
- iounmap(NULL) resolved in vunmap() what which in turn is able to handle NULL
  pointer but dereferencing still doesn't work
- don't clean up not yet allocated ressources, like list_del before list_add

fsl_dma_self_test:
- call fsl_dma_free_chan_resources() if the first dma trans didn't complete

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 drivers/dma/fsldma.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 054eabf..d36098c 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -842,7 +842,7 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	if (fsl_dma_is_complete(chan, cookie, NULL, NULL) != DMA_SUCCESS) {
 		dev_err(fsl_chan->dev, "selftest: Time out!\n");
 		err = -ENODEV;
-		goto out;
+		goto free_resources;
 	}
 
 	/* Test free and re-alloc channel resources */
@@ -927,8 +927,7 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 	if (!new_fsl_chan) {
 		dev_err(&dev->dev, "No free memory for allocating "
 				"dma channels!\n");
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	/* get dma channel register base */
@@ -936,7 +935,7 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 	if (err) {
 		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
 				dev->node->full_name);
-		goto err;
+		goto err_free_mem;
 	}
 
 	new_fsl_chan->feature = *(u32 *)match->data;
@@ -953,12 +952,17 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 	new_fsl_chan->reg_base = ioremap(new_fsl_chan->reg.start,
 			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
 
+	if (!new_fsl_chan->reg_base) {
+		err = -ENOMEM;
+		goto err_free_mem;
+	}
+
 	new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
 	if (new_fsl_chan->id > FSL_DMA_MAX_CHANS_PER_DEVICE) {
 		dev_err(&dev->dev, "There is no %d channel!\n",
 				new_fsl_chan->id);
 		err = -EINVAL;
-		goto err;
+		goto err_unnmap;
 	}
 	fdev->chan[new_fsl_chan->id] = new_fsl_chan;
 	tasklet_init(&new_fsl_chan->tasklet, dma_do_tasklet,
@@ -997,23 +1001,28 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 		if (err) {
 			dev_err(&dev->dev, "DMA channel %s request_irq error "
 				"with return %d\n", dev->node->full_name, err);
-			goto err;
+			goto err_remove_list;
 		}
 	}
 
 	err = fsl_dma_self_test(new_fsl_chan);
 	if (err)
-		goto err;
+		goto err_test;
 
 	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
 				match->compatible, new_fsl_chan->irq);
-
 	return 0;
-err:
+
+err_test:
 	dma_halt(new_fsl_chan);
-	iounmap(new_fsl_chan->reg_base);
-	free_irq(new_fsl_chan->irq, new_fsl_chan);
+	if (new_fsl_chan->irq != NO_IRQ)
+		free_irq(new_fsl_chan->irq, new_fsl_chan);
+err_remove_list:
 	list_del(&new_fsl_chan->common.device_node);
+	fdev->common.chancnt--;
+err_unnmap:
+	iounmap(new_fsl_chan->reg_base);
+err_free_mem:
 	kfree(new_fsl_chan);
 	return err;
 }
@@ -1054,8 +1063,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
 	if (!fdev) {
 		dev_err(&dev->dev, "No enough memory for 'priv'\n");
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 	fdev->dev = &dev->dev;
 	INIT_LIST_HEAD(&fdev->common.channels);
@@ -1091,7 +1099,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 		if (err) {
 			dev_err(&dev->dev, "DMA device request_irq error "
 				"with return %d\n", err);
-			goto err;
+			goto err_remove_irq;
 		}
 	}
 
@@ -1101,6 +1109,8 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	dma_async_device_register(&fdev->common);
 	return 0;
 
+err_remove_irq:
+	free_irq(irq, &fsl_dma_do_interrupt);
 err:
 	iounmap(fdev->reg_base);
 	kfree(fdev);
-- 
1.5.5.2

