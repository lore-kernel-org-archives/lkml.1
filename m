Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXFNLJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXFNLJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXFNLJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 07:09:14 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63749 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXFNLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 07:09:12 -0400
Message-Id: <20070614110910.634505309@fluff.org.uk>
References: <20070614110853.539162819@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:08:55 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch 2/2] WATCHDOG: change s3c2410_wdt to using dev_() macros for output
Content-Disposition: inline; filename=simtec-drivers-watchdog-devmacros.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move to using dev_info(), dev_dbg() and dev_err() for
reporting information from the driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt2/drivers/char/watchdog/s3c2410_wdt.c
===================================================================
--- linux-2.6.21-quilt2.orig/drivers/char/watchdog/s3c2410_wdt.c	2007-05-11 11:55:46.000000000 +0100
+++ linux-2.6.21-quilt2/drivers/char/watchdog/s3c2410_wdt.c	2007-05-11 12:01:44.000000000 +0100
@@ -92,6 +92,7 @@ typedef enum close_state {
 
 static DECLARE_MUTEX(open_lock);
 
+static struct device    *wdt_dev;	/* platform device attached to */
 static struct resource	*wdt_mem;
 static struct resource	*wdt_irq;
 static struct clk	*wdt_clock;
@@ -180,7 +181,7 @@ static int s3c2410wdt_set_heartbeat(int 
 		}
 
 		if ((count / divisor) >= 0x10000) {
-			printk(KERN_ERR PFX "timeout %d too big\n", timeout);
+			dev_err(wdt_dev, "timeout %d too big\n", timeout);
 			return -EINVAL;
 		}
 	}
@@ -233,7 +234,7 @@ static int s3c2410wdt_release(struct ino
 	if (allow_close == CLOSE_STATE_ALLOW) {
 		s3c2410wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		dev_err(wdt_dev, "Unexpected close, not stopping watchdog\n");
 		s3c2410wdt_keepalive();
 	}
 
@@ -338,7 +339,7 @@ static struct miscdevice s3c2410wdt_misc
 
 static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 {
-	printk(KERN_INFO PFX "Watchdog timer expired!\n");
+	dev_info(wdt_dev, "watchdog timer expired (irq)\n");
 
 	s3c2410wdt_keepalive();
 	return IRQ_HANDLED;
@@ -348,6 +349,7 @@ static irqreturn_t s3c2410wdt_irq(int ir
 static int s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	struct device *dev;
 	unsigned int wtcon;
 	int started = 0;
 	int ret;
@@ -355,25 +357,28 @@ static int s3c2410wdt_probe(struct platf
 
 	DBG("%s: probe=%p\n", __FUNCTION__, pdev);
 
+	dev = &pdev->dev;
+	wdt_dev = &pdev->dev;
+
 	/* get the memory region for the watchdog timer */
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-		printk(KERN_INFO PFX "failed to get memory region resouce\n");
+		dev_err(dev, "no memory resource specified\n");
 		return -ENOENT;
 	}
 
 	size = (res->end-res->start)+1;
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
-		printk(KERN_INFO PFX "failed to get memory region\n");
+		dev_err(dev, "failed to get memory region\n");
 		ret = -ENOENT;
 		goto err_req;
 	}
 
 	wdt_base = ioremap(res->start, size);
 	if (wdt_base == 0) {
-		printk(KERN_INFO PFX "failed to ioremap() region\n");
+		dev_err(dev, "failed to ioremap() region\n");
 		ret = -EINVAL;
 		goto err_req;
 	}
@@ -382,20 +387,20 @@ static int s3c2410wdt_probe(struct platf
 
 	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (wdt_irq == NULL) {
-		printk(KERN_INFO PFX "failed to get irq resource\n");
+		dev_err(dev, "no irq resource specified\n");
 		ret = -ENOENT;
 		goto err_map;
 	}
 
 	ret = request_irq(wdt_irq->start, s3c2410wdt_irq, 0, pdev->name, pdev);
 	if (ret != 0) {
-		printk(KERN_INFO PFX "failed to install irq (%d)\n", ret);
+		dev_err(dev, "failed to install irq (%d)\n", ret);
 		goto err_map;
 	}
 
 	wdt_clock = clk_get(&pdev->dev, "watchdog");
 	if (IS_ERR(wdt_clock)) {
-		printk(KERN_INFO PFX "failed to find watchdog clock source\n");
+		dev_err(dev, "failed to find watchdog clock source\n");
 		ret = PTR_ERR(wdt_clock);
 		goto err_irq;
 	}
@@ -409,22 +414,22 @@ static int s3c2410wdt_probe(struct platf
 		started = s3c2410wdt_set_heartbeat(CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 
 		if (started == 0) {
-			printk(KERN_INFO PFX "tmr_margin value out of range, default %d used\n",
+			dev_info(dev,"tmr_margin value out of range, default %d used\n",
 			       CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 		} else {
-			printk(KERN_INFO PFX "default timer value is out of range, cannot start\n");
+			dev_info(dev, "default timer value is out of range, cannot start\n");
 		}
 	}
 
 	ret = misc_register(&s3c2410wdt_miscdev);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (%d)\n",
+		dev_err(dev, "cannot register miscdev on minor=%d (%d)\n",
 			WATCHDOG_MINOR, ret);
 		goto err_clk;
 	}
 
 	if (tmr_atboot && started == 0) {
-		printk(KERN_INFO PFX "Starting Watchdog Timer\n");
+		dev_info(dev, "starting watchdog timer\n");
 		s3c2410wdt_start();
 	} else if (!tmr_atboot) {
 		/* if we're not enabling the watchdog, then ensure it is
@@ -438,12 +443,11 @@ static int s3c2410wdt_probe(struct platf
 
 	wtcon = readl(wdt_base + S3C2410_WTCON);
 
-	dev_info(&pdev->dev,
-		 "watchdog %sactive, reset %sabled, irq %sabled\n", 
+	dev_info(dev, "watchdog %sactive, reset %sabled, irq %sabled\n", 
 		 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
 		 (wtcon & S3C2410_WTCON_RSTEN) ? "" : "dis",
 		 (wtcon & S3C2410_WTCON_INTEN) ? "" : "en");
-
+	
 	return 0;
 
  err_clk:

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
