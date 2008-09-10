Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYIJQWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYIJQWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYIJQWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:22:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:49254 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYIJQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=KhoMnkh13a36x4GJbhJVbMZOaHoByG5R9e4H0QVjMeUxbj9PxUsEBEYtFnwch63Mlq
         1NNcbkwCZTx79lcyd82tLkuKjSEiDVKAGAM3ReYKgADDQGzg23P+xoGB256kNxn+jHx6
         cUXCU09vSZcgY8tGcVKt6v/dwmvlrGQrkxTow=
Message-ID: <48C7F1EA.6070008@gmail.com>
Date: Wed, 10 Sep 2008 18:12:26 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: mchehab@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L/DVB: pxa-camera: Unsigned dma_chans[] cannot be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned dma_chans[] cannot be negative

Note that also the third time dma_chans[0] < 0 was tested instead of dma_chans[2]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index ead87dd..950a2d4 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1078,7 +1078,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	struct pxa_camera_dev *pcdev;
 	struct resource *res;
 	void __iomem *base;
-	int irq;
+	int irq, retval;
 	int err = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1144,31 +1144,34 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->dev = &pdev->dev;
 
 	/* request dma */
-	pcdev->dma_chans[0] = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
+	retval = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
 					      pxa_camera_dma_irq_y, pcdev);
-	if (pcdev->dma_chans[0] < 0) {
+	if (retval < 0) {
 		dev_err(pcdev->dev, "Can't request DMA for Y\n");
 		err = -ENOMEM;
 		goto exit_iounmap;
 	}
+	pcdev->dma_chans[0] = retval;
 	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
 
-	pcdev->dma_chans[1] = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
+	retval = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
 					      pxa_camera_dma_irq_u, pcdev);
-	if (pcdev->dma_chans[1] < 0) {
+	if (retval < 0) {
 		dev_err(pcdev->dev, "Can't request DMA for U\n");
 		err = -ENOMEM;
 		goto exit_free_dma_y;
 	}
+	pcdev->dma_chans[1] = retval;
 	dev_dbg(pcdev->dev, "got DMA channel (U) %d\n", pcdev->dma_chans[1]);
 
-	pcdev->dma_chans[2] = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
+	retval = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
 					      pxa_camera_dma_irq_v, pcdev);
-	if (pcdev->dma_chans[0] < 0) {
+	if (retval < 0) {
 		dev_err(pcdev->dev, "Can't request DMA for V\n");
 		err = -ENOMEM;
 		goto exit_free_dma_u;
 	}
+	pcdev->dma_chans[2] = retval;
 	dev_dbg(pcdev->dev, "got DMA channel (V) %d\n", pcdev->dma_chans[2]);
 
 	DRCMR68 = pcdev->dma_chans[0] | DRCMR_MAPVLD;
