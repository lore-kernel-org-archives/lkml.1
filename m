Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYFBRjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYFBRjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYFBRil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:38:41 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14433 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753626AbYFBRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:38:40 -0400
Date: Mon, 2 Jun 2008 21:38:38 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jochen Friedrich <jochen@scram.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] [WATCHDOG] mpc83xx_wdt: convert to the OF platform
	driver
Message-ID: <20080602173838.GB30705@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080602173726.GA24556@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply converts mpc83xx_wdt to the OF platform driver so we
can directly work with the device tree without passing various stuff
through platform data.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/watchdog/mpc83xx_wdt.c |   62 +++++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/watchdog/mpc83xx_wdt.c b/drivers/watchdog/mpc83xx_wdt.c
index 6905712..127d85e 100644
--- a/drivers/watchdog/mpc83xx_wdt.c
+++ b/drivers/watchdog/mpc83xx_wdt.c
@@ -19,11 +19,12 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
-#include <linux/platform_device.h>
+#include <linux/of_platform.h>
 #include <linux/module.h>
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <sysdev/fsl_soc.h>
 
 struct mpc83xx_wdt {
 	__be32 res0;
@@ -149,53 +150,42 @@ static struct miscdevice mpc83xx_wdt_miscdev = {
 	.fops	= &mpc83xx_wdt_fops,
 };
 
-static int __devinit mpc83xx_wdt_probe(struct platform_device *dev)
+static int __devinit mpc83xx_wdt_probe(struct of_device *ofdev,
+				       const struct of_device_id *match)
 {
-	struct resource *r;
 	int ret;
-	unsigned int *freq = dev->dev.platform_data;
+	u32 freq = fsl_get_sys_freq();
 
-	/* get a pointer to the register memory */
-	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!freq || freq == -1)
+		return -EINVAL;
 
-	if (!r) {
-		ret = -ENODEV;
-		goto err_out;
-	}
-
-	wd_base = ioremap(r->start, sizeof(struct mpc83xx_wdt));
-
-	if (wd_base == NULL) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
+	wd_base = of_iomap(ofdev->node, 0);
+	if (!wd_base)
+		return -ENOMEM;
 
 	ret = misc_register(&mpc83xx_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR "cannot register miscdev on minor=%d "
-				"(err=%d)\n",
-				WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
 		goto err_unmap;
 	}
 
 	/* Calculate the timeout in seconds */
 	if (prescale)
-		timeout_sec = (timeout * 0x10000) / (*freq);
+		timeout_sec = (timeout * 0x10000) / freq;
 	else
-		timeout_sec = timeout / (*freq);
+		timeout_sec = timeout / freq;
 
-	printk(KERN_INFO "WDT driver for MPC83xx initialized. "
-		"mode:%s timeout=%d (%d seconds)\n",
-		reset ? "reset":"interrupt", timeout, timeout_sec);
+	pr_info("WDT driver for MPC83xx initialized. mode:%s timeout=%d "
+		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
+		timeout_sec);
 	return 0;
-
 err_unmap:
 	iounmap(wd_base);
-err_out:
 	return ret;
 }
 
-static int __devexit mpc83xx_wdt_remove(struct platform_device *dev)
+static int __devexit mpc83xx_wdt_remove(struct of_device *ofdev)
 {
 	misc_deregister(&mpc83xx_wdt_miscdev);
 	iounmap(wd_base);
@@ -203,7 +193,16 @@ static int __devexit mpc83xx_wdt_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct platform_driver mpc83xx_wdt_driver = {
+static const struct of_device_id mpc83xx_wdt_match[] = {
+	{
+		.compatible = "mpc83xx_wdt",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mpc83xx_wdt_match);
+
+static struct of_platform_driver mpc83xx_wdt_driver = {
+	.match_table	= mpc83xx_wdt_match,
 	.probe		= mpc83xx_wdt_probe,
 	.remove		= __devexit_p(mpc83xx_wdt_remove),
 	.driver		= {
@@ -214,12 +213,12 @@ static struct platform_driver mpc83xx_wdt_driver = {
 
 static int __init mpc83xx_wdt_init(void)
 {
-	return platform_driver_register(&mpc83xx_wdt_driver);
+	return of_register_platform_driver(&mpc83xx_wdt_driver);
 }
 
 static void __exit mpc83xx_wdt_exit(void)
 {
-	platform_driver_unregister(&mpc83xx_wdt_driver);
+	of_unregister_platform_driver(&mpc83xx_wdt_driver);
 }
 
 module_init(mpc83xx_wdt_init);
@@ -229,4 +228,3 @@ MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
 MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx uProcessor");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform:mpc83xx_wdt");
-- 
1.5.5.1

