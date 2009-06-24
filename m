Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZFXJfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZFXJfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZFXJfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:35:32 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:47156 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZFXJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l0z2pX8ij9IYRtu6s7pbrARSUO42BG8oU4RSScT5T2wgPQvFz8n4ViSo5Gi7bOajBc
         ou01t6ByDznvRcctQ+BiLkVVVUatO09Uj1JXxIx3SV19B3uUHIp8dUAzm9pGjHRv5Grw
         dhEJPAoiQ2r0leR4XFns64PoCjCox7TwDFqDs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, ben-linux@fluff.org, hskinnemoen@atmel.com,
       anemo@mba.ocn.ne.jp, linux-usb@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>, rjw@sisk.pl,
       stern@rowland.harvard.edu, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
       akpm@linux-foundation.org, felipe.balbi@nokia.com
Date: Wed, 24 Jun 2009 18:23:50 +0900
Message-Id: <20090624092350.14276.82072.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
Subject: [PATCH 05/07] i2c: rework i2c-s3c2410 suspend_late()/resume() V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This is V2 of the i2c-s3c2410 dev_pm_ops patch.

The callbacks are converted for CONFIG_SUSPEND like this:
  suspend_late() -> suspend_noirq()
  resume() -> resume()

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V1:
 - resolved conflicts to fit upstream changes

 drivers/i2c/busses/i2c-s3c2410.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- 0001/drivers/i2c/busses/i2c-s3c2410.c
+++ work/drivers/i2c/busses/i2c-s3c2410.c	2009-06-22 17:18:22.000000000 +0900
@@ -951,17 +951,20 @@ static int s3c24xx_i2c_remove(struct pla
 }
 
 #ifdef CONFIG_PM
-static int s3c24xx_i2c_suspend_late(struct platform_device *dev,
-				    pm_message_t msg)
+static int s3c24xx_i2c_suspend_noirq(struct device *dev)
 {
-	struct s3c24xx_i2c *i2c = platform_get_drvdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
+
 	i2c->suspended = 1;
+
 	return 0;
 }
 
-static int s3c24xx_i2c_resume(struct platform_device *dev)
+static int s3c24xx_i2c_resume(struct device *dev)
 {
-	struct s3c24xx_i2c *i2c = platform_get_drvdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
 	i2c->suspended = 0;
 	s3c24xx_i2c_init(i2c);
@@ -969,9 +972,14 @@ static int s3c24xx_i2c_resume(struct pla
 	return 0;
 }
 
+static struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
+	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
+	.resume = s3c24xx_i2c_resume,
+};
+
+#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
 #else
-#define s3c24xx_i2c_suspend_late NULL
-#define s3c24xx_i2c_resume NULL
+#define S3C24XX_DEV_PM_OPS NULL
 #endif
 
 /* device driver for platform bus bits */
@@ -990,12 +998,11 @@ MODULE_DEVICE_TABLE(platform, s3c24xx_dr
 static struct platform_driver s3c24xx_i2c_driver = {
 	.probe		= s3c24xx_i2c_probe,
 	.remove		= s3c24xx_i2c_remove,
-	.suspend_late	= s3c24xx_i2c_suspend_late,
-	.resume		= s3c24xx_i2c_resume,
 	.id_table	= s3c24xx_driver_ids,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "s3c-i2c",
+		.pm	= S3C24XX_DEV_PM_OPS,
 	},
 };
 
