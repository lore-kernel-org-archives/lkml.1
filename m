Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833Ab0AHQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0AHQX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467Ab0AHQX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:23:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53749 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab0AHQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:23:26 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Richard Zhao <linuxzsc@gmail.com>,
       Darius Augulis <augulis.darius@gmail.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-i2c@vger.kernel.org
Subject: [PATCH] i2c/imx: call ioremap only after request_mem_region
Date: Fri,  8 Jan 2010 17:23:17 +0100
Message-Id: <1262967797-2001-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

accordingly adapt order of release_mem_region and release_mem_region on
remove.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Richard Zhao <linuxzsc@gmail.com>
Cc: Darius Augulis <augulis.darius@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/busses/i2c-imx.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index e3654d6..8431500 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -496,22 +496,23 @@ static int __init i2c_imx_probe(struct platform_device *pdev)
 	}
 
 	res_size = resource_size(res);
+
+	if (!request_mem_region(res->start, res_size, DRIVER_NAME)) {
+		ret = -EBUSY;
+		goto fail0;
+	}
+
 	base = ioremap(res->start, res_size);
 	if (!base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -EIO;
-		goto fail0;
+		goto fail1;
 	}
 
 	i2c_imx = kzalloc(sizeof(struct imx_i2c_struct), GFP_KERNEL);
 	if (!i2c_imx) {
 		dev_err(&pdev->dev, "can't allocate interface\n");
 		ret = -ENOMEM;
-		goto fail1;
-	}
-
-	if (!request_mem_region(res->start, res_size, DRIVER_NAME)) {
-		ret = -EBUSY;
 		goto fail2;
 	}
 
@@ -582,11 +583,11 @@ fail5:
 fail4:
 	clk_put(i2c_imx->clk);
 fail3:
-	release_mem_region(i2c_imx->res->start, resource_size(res));
-fail2:
 	kfree(i2c_imx);
-fail1:
+fail2:
 	iounmap(base);
+fail1:
+	release_mem_region(res->start, resource_size(res));
 fail0:
 	if (pdata && pdata->exit)
 		pdata->exit(&pdev->dev);
@@ -618,8 +619,8 @@ static int __exit i2c_imx_remove(struct platform_device *pdev)
 
 	clk_put(i2c_imx->clk);
 
-	release_mem_region(i2c_imx->res->start, resource_size(i2c_imx->res));
 	iounmap(i2c_imx->base);
+	release_mem_region(i2c_imx->res->start, resource_size(i2c_imx->res));
 	kfree(i2c_imx);
 	return 0;
 }
-- 
1.6.5.2

