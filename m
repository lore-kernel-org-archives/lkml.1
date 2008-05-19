Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbYESNXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbYESNXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbYESNST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45838 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760158AbYESNSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:08 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 16/57] iop: watchdog switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:14 +0100
Message-ID: <20080519130614.31722.84805.stgit@core>
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

 drivers/watchdog/iop_wdt.c |   46 +++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 22 deletions(-)


diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index bbbd91a..e54c888 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -37,6 +37,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned long wdt_status;
 static unsigned long boot_status;
+static spinlock_t wdt_lock;
 
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
@@ -68,8 +69,10 @@ static void wdt_enable(void)
 	/* Arm and enable the Timer to starting counting down from 0xFFFF.FFFF
 	 * Takes approx. 10.7s to timeout
 	 */
+	spin_lock(&wdt_lock);
 	write_wdtcr(IOP_WDTCR_EN_ARM);
 	write_wdtcr(IOP_WDTCR_EN);
+	spin_unlock(&wdt_lock);
 }
 
 /* returns 0 if the timer was successfully disabled */
@@ -77,9 +80,11 @@ static int wdt_disable(void)
 {
 	/* Stop Counting */
 	if (wdt_supports_disable()) {
+		spin_lock(&wdt_lock);
 		write_wdtcr(IOP_WDTCR_DIS_ARM);
 		write_wdtcr(IOP_WDTCR_DIS);
 		clear_bit(WDT_ENABLED, &wdt_status);
+		spin_unlock(&wdt_lock);
 		printk(KERN_INFO "WATCHDOG: Disabled\n");
 		return 0;
 	} else
@@ -92,16 +97,12 @@ static int iop_wdt_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
 	wdt_enable();
-
 	set_bit(WDT_ENABLED, &wdt_status);
-
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-iop_wdt_write(struct file *file, const char *data, size_t len,
+static ssize_t iop_wdt_write(struct file *file, const char *data, size_t len,
 		  loff_t *ppos)
 {
 	if (len) {
@@ -121,41 +122,39 @@ iop_wdt_write(struct file *file, const char *data, size_t len,
 		}
 		wdt_enable();
 	}
-
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.identity = "iop watchdog",
 };
 
-static int
-iop_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long iop_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	int options;
 	int ret = -ENOTTY;
+	int __user *argp = (int __user *)arg;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user
-		    ((struct watchdog_info *)arg, &ident, sizeof ident))
+		if (copy_to_user(argp, &ident, sizeof ident))
 			ret = -EFAULT;
 		else
 			ret = 0;
 		break;
 
 	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int *)arg);
+		ret = put_user(0, argp);
 		break;
 
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(boot_status, (int *)arg);
+		ret = put_user(boot_status, argp);
 		break;
 
 	case WDIOC_GETTIMEOUT:
-		ret = put_user(iop_watchdog_timeout(), (int *)arg);
+		ret = put_user(iop_watchdog_timeout(), argp);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -177,14 +176,12 @@ iop_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			} else
 				ret = 0;
 		}
-
 		if (options & WDIOS_ENABLECARD) {
 			wdt_enable();
 			ret = 0;
 		}
 		break;
 	}
-
 	return ret;
 }
 
@@ -214,7 +211,7 @@ static const struct file_operations iop_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = iop_wdt_write,
-	.ioctl = iop_wdt_ioctl,
+	.unlocked_ioctl = iop_wdt_ioctl,
 	.open = iop_wdt_open,
 	.release = iop_wdt_release,
 };
@@ -229,10 +226,8 @@ static int __init iop_wdt_init(void)
 {
 	int ret;
 
-	ret = misc_register(&iop_wdt_miscdev);
-	if (ret == 0)
-		printk("iop watchdog timer: timeout %lu sec\n",
-		       iop_watchdog_timeout());
+	spin_lock_init(&wdt_lock);
+
 
 	/* check if the reset was caused by the watchdog timer */
 	boot_status = (read_rcsr() & IOP_RCSR_WDT) ? WDIOF_CARDRESET : 0;
@@ -242,6 +237,13 @@ static int __init iop_wdt_init(void)
 	 */
 	write_wdtsr(IOP13XX_WDTCR_IB_RESET);
 
+	/* Register after we have the device set up so we cannot race
+	   with an open */
+	ret = misc_register(&iop_wdt_miscdev);
+	if (ret == 0)
+		printk("iop watchdog timer: timeout %lu sec\n",
+		       iop_watchdog_timeout());
+
 	return ret;
 }
 

