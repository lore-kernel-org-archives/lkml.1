Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbYESNZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbYESNZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760268AbYESNSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45869 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760179AbYESNSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 22/57] ixp4xx_wdt: unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:48 +0100
Message-ID: <20080519130647.31722.66950.stgit@core>
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

 drivers/watchdog/ixp4xx_wdt.c |   41 +++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 24 deletions(-)


diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 5864bb8..24e624c 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -30,40 +30,40 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
 static unsigned long boot_status;
+static spin_lock_t wdt_lock;
 
 #define WDT_TICK_RATE (IXP4XX_PERIPHERAL_BUS_CLOCK * 1000000UL)
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
+	spin_lock(&wdt_lock);
 	*IXP4XX_OSWK = IXP4XX_WDT_KEY;
 	*IXP4XX_OSWE = 0;
 	*IXP4XX_OSWT = WDT_TICK_RATE * heartbeat;
 	*IXP4XX_OSWE = IXP4XX_WDT_COUNT_ENABLE | IXP4XX_WDT_RESET_ENABLE;
 	*IXP4XX_OSWK = 0;
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
+	spin_lock(&wdt_lock);
 	*IXP4XX_OSWK = IXP4XX_WDT_KEY;
 	*IXP4XX_OSWE = 0;
 	*IXP4XX_OSWK = 0;
+	spin_unlock(&wdt_lock);
 }
 
-static int
-ixp4xx_wdt_open(struct inode *inode, struct file *file)
+static int ixp4xx_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
 	wdt_enable();
-
 	return nonseekable_open(inode, file);
 }
 
@@ -87,7 +87,6 @@ ixp4xx_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 		}
 		wdt_enable();
 	}
-
 	return len;
 }
 
@@ -98,9 +97,8 @@ static struct watchdog_info ident = {
 };
 
 
-static int
-ixp4xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-			unsigned long arg)
+static long ixp4xx_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -145,16 +143,13 @@ ixp4xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	return ret;
 }
 
-static int
-ixp4xx_wdt_release(struct inode *inode, struct file *file)
+static int ixp4xx_wdt_release(struct inode *inode, struct file *file)
 {
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
-	} else {
+	else
 		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
-	}
-
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -167,7 +162,7 @@ static const struct file_operations ixp4xx_wdt_fops =
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ixp4xx_wdt_write,
-	.ioctl		= ixp4xx_wdt_ioctl,
+	.unlocked_ioctl	= ixp4xx_wdt_ioctl,
 	.open		= ixp4xx_wdt_open,
 	.release	= ixp4xx_wdt_release,
 };
@@ -191,14 +186,12 @@ static int __init ixp4xx_wdt_init(void)
 
 		return -ENODEV;
 	}
-
+	spin_lock_init(&wdt_lock);
+	boot_status = (*IXP4XX_OSST & IXP4XX_OSST_TIMER_WARM_RESET) ?
+			WDIOF_CARDRESET : 0;
 	ret = misc_register(&ixp4xx_wdt_miscdev);
 	if (ret == 0)
 		printk("IXP4xx Watchdog Timer: heartbeat %d sec\n", heartbeat);
-
-	boot_status = (*IXP4XX_OSST & IXP4XX_OSST_TIMER_WARM_RESET) ?
-			WDIOF_CARDRESET : 0;
-
 	return ret;
 }
 

