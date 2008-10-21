Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYJUABx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYJUABx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYJUABo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:01:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:46233 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYJUABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=scr7/Vc97YiujfqgrP71INPgx3tytwgyBtomfEuzOx4INZoGF+X1AW2TLwpfbocD+i
         095O8jZ6F+UlCpN7rxGAeDIDyYNg/1LYWFN2v85aCku+gILtbNIRG1yer6lwbG1XmVjc
         FXiJ89puFfTyrzPWc4BMfqnzcLA395JrJZqig=
Message-ID: <48FD7043.6010703@gmail.com>
Date: Tue, 21 Oct 2008 02:01:39 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: ben@simtec.co.uk, sameo@openedhand.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: fix irq assignment
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->irq is unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 220e437..56cc9f9 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1374,31 +1374,31 @@ static int sm501_init_dev(struct sm501_devdata *sm)
 static int sm501_plat_probe(struct platform_device *dev)
 {
 	struct sm501_devdata *sm;
-	int err;
+	int ret;
 
 	sm = kzalloc(sizeof(struct sm501_devdata), GFP_KERNEL);
 	if (sm == NULL) {
 		dev_err(&dev->dev, "no memory for device data\n");
-		err = -ENOMEM;
+		ret = -ENOMEM;
 		goto err1;
 	}
 
 	sm->dev = &dev->dev;
 	sm->pdev_id = dev->id;
-	sm->irq = platform_get_irq(dev, 0);
-	sm->io_res = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	sm->mem_res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	sm->platdata = dev->dev.platform_data;
 
-	if (sm->irq < 0) {
+	ret = platform_get_irq(dev, 0);
+	if (ret < 0) {
 		dev_err(&dev->dev, "failed to get irq resource\n");
-		err = sm->irq;
 		goto err_res;
 	}
+	sm->irq = ret;
 
+	sm->io_res = platform_get_resource(dev, IORESOURCE_MEM, 1);
+	sm->mem_res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (sm->io_res == NULL || sm->mem_res == NULL) {
 		dev_err(&dev->dev, "failed to get IO resource\n");
-		err = -ENOENT;
+		ret = -ENOENT;
 		goto err_res;
 	}
 
@@ -1407,7 +1407,7 @@ static int sm501_plat_probe(struct platform_device *dev)
 
 	if (sm->regs_claim == NULL) {
 		dev_err(&dev->dev, "cannot claim registers\n");
-		err= -EBUSY;
+		ret= -EBUSY;
 		goto err_res;
 	}
 
@@ -1418,7 +1418,7 @@ static int sm501_plat_probe(struct platform_device *dev)
 
 	if (sm->regs == NULL) {
 		dev_err(&dev->dev, "cannot remap registers\n");
-		err = -EIO;
+		ret = -EIO;
 		goto err_claim;
 	}
 
@@ -1430,7 +1430,7 @@ static int sm501_plat_probe(struct platform_device *dev)
  err_res:
 	kfree(sm);
  err1:
-	return err;
+	return ret;
 
 }
 
