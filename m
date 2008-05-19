Return-Path: <linux-kernel-owner+w=401wt.eu-S1763379AbYESN06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763379AbYESN06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760475AbYESNTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45895 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759918AbYESNTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/57] mpcore watchdog: unlocked_ioctl and BKl work
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:15 +0100
Message-ID: <20080519130715.31722.47165.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/watchdog/mpcore_wdt.c |   53 +++++++++++++++++++++++++----------------
 1 files changed, 32 insertions(+), 21 deletions(-)


diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 009573b..5e58f8b 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -29,9 +29,9 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware/arm_twd.h>
-#include <asm/uaccess.h>
 
 struct mpcore_wdt {
 	unsigned long	timer_alive;
@@ -43,17 +43,20 @@ struct mpcore_wdt {
 };
 
 static struct platform_device *mpcore_wdt_dev;
-
 extern unsigned int mpcore_timer_rate;
 
 #define TIMER_MARGIN	60
 static int mpcore_margin = TIMER_MARGIN;
 module_param(mpcore_margin, int, 0);
-MODULE_PARM_DESC(mpcore_margin, "MPcore timer margin in seconds. (0<mpcore_margin<65536, default=" __MODULE_STRING(TIMER_MARGIN) ")");
+MODULE_PARM_DESC(mpcore_margin,
+	"MPcore timer margin in seconds. (0 < mpcore_margin < 65536, default="
+				__MODULE_STRING(TIMER_MARGIN) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define ONLY_TESTING	0
 static int mpcore_noboot = ONLY_TESTING;
@@ -70,14 +73,12 @@ static irqreturn_t mpcore_wdt_fire(int irq, void *arg)
 
 	/* Check it really was our interrupt */
 	if (readl(wdt->base + TWD_WDOG_INTSTAT)) {
-		dev_printk(KERN_CRIT, wdt->dev, "Triggered - Reboot ignored.\n");
-
+		dev_printk(KERN_CRIT, wdt->dev,
+					"Triggered - Reboot ignored.\n");
 		/* Clear the interrupt on the watchdog */
 		writel(1, wdt->base + TWD_WDOG_INTSTAT);
-
 		return IRQ_HANDLED;
 	}
-
 	return IRQ_NONE;
 }
 
@@ -96,22 +97,26 @@ static void mpcore_wdt_keepalive(struct mpcore_wdt *wdt)
 	count = (mpcore_timer_rate / 256) * mpcore_margin;
 
 	/* Reload the counter */
+	spin_lock(&wdt_lock);
 	writel(count + wdt->perturb, wdt->base + TWD_WDOG_LOAD);
-
 	wdt->perturb = wdt->perturb ? 0 : 1;
+	spin_unlock(&wdt_lock);
 }
 
 static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
 {
+	spin_lock(&wdt_lock);
 	writel(0x12345678, wdt->base + TWD_WDOG_DISABLE);
 	writel(0x87654321, wdt->base + TWD_WDOG_DISABLE);
 	writel(0x0, wdt->base + TWD_WDOG_CONTROL);
+	spin_unlock(&wdt_lock);
 }
 
 static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 {
 	dev_printk(KERN_INFO, wdt->dev, "enabling watchdog.\n");
 
+	spin_lock(&wdt_lock);
 	/* This loads the count register but does NOT start the count yet */
 	mpcore_wdt_keepalive(wdt);
 
@@ -122,6 +127,7 @@ static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 		/* Enable watchdog - prescale=256, watchdog mode=1, enable=1 */
 		writel(0x0000FF09, wdt->base + TWD_WDOG_CONTROL);
 	}
+	spin_unlock(&wdt_lock);
 }
 
 static int mpcore_wdt_set_heartbeat(int t)
@@ -164,10 +170,11 @@ static int mpcore_wdt_release(struct inode *inode, struct file *file)
 	 *	Shut off the timer.
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
-	if (wdt->expect_close == 42) {
+	if (wdt->expect_close == 42)
 		mpcore_wdt_stop(wdt);
-	} else {
-		dev_printk(KERN_CRIT, wdt->dev, "unexpected close, not stopping watchdog!\n");
+	else {
+		dev_printk(KERN_CRIT, wdt->dev,
+				"unexpected close, not stopping watchdog!\n");
 		mpcore_wdt_keepalive(wdt);
 	}
 	clear_bit(0, &wdt->timer_alive);
@@ -175,7 +182,8 @@ static int mpcore_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t mpcore_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t mpcore_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	struct mpcore_wdt *wdt = file->private_data;
 
@@ -210,8 +218,8 @@ static struct watchdog_info ident = {
 	.identity		= "MPcore Watchdog",
 };
 
-static int mpcore_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct mpcore_wdt *wdt = file->private_data;
 	int ret;
@@ -301,7 +309,7 @@ static const struct file_operations mpcore_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mpcore_wdt_write,
-	.ioctl		= mpcore_wdt_ioctl,
+	.unlocked_ioctl	= mpcore_wdt_ioctl,
 	.open		= mpcore_wdt_open,
 	.release	= mpcore_wdt_release,
 };
@@ -349,14 +357,17 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 	mpcore_wdt_miscdev.parent = &dev->dev;
 	ret = misc_register(&mpcore_wdt_miscdev);
 	if (ret) {
-		dev_printk(KERN_ERR, _dev, "cannot register miscdev on minor=%d (err=%d)\n",
-			   WATCHDOG_MINOR, ret);
+		dev_printk(KERN_ERR, _dev,
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto err_misc;
 	}
 
-	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED, "mpcore_wdt", wdt);
+	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED,
+							"mpcore_wdt", wdt);
 	if (ret) {
-		dev_printk(KERN_ERR, _dev, "cannot register IRQ%d for watchdog\n", wdt->irq);
+		dev_printk(KERN_ERR, _dev,
+			"cannot register IRQ%d for watchdog\n", wdt->irq);
 		goto err_irq;
 	}
 
@@ -415,7 +426,7 @@ static int __init mpcore_wdt_init(void)
 	 */
 	if (mpcore_wdt_set_heartbeat(mpcore_margin)) {
 		mpcore_wdt_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO "mpcore_margin value must be 0<mpcore_margin<65536, using %d\n",
+		printk(KERN_INFO "mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 

