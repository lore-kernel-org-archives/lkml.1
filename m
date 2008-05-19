Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbYESNYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbYESNYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbYESNSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45863 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760141AbYESNSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:34 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 21/57] ixp2000_wdt: clean up and unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:42 +0100
Message-ID: <20080519130642.31722.53823.stgit@core>
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

 drivers/watchdog/ixp2000_wdt.c |   50 ++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 27 deletions(-)


diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index dc7548d..943ceff 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -25,42 +25,45 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
+static spinlock_t wdt_lock;
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
 
 static unsigned long wdt_tick_rate;
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_RESET0, *(IXP2000_RESET0) | WDT_RESET_ENABLE);
 	ixp2000_reg_write(IXP2000_TWDE, WDT_ENABLE);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
 	ixp2000_reg_write(IXP2000_T4_CTL, TIMER_DIVIDER_256 | TIMER_ENABLE);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CTL, 0);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_keepalive(void)
+static void wdt_keepalive(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
+	spin_unlock(&wdt_lock);
 }
 
-static int
-ixp2000_wdt_open(struct inode *inode, struct file *file)
+static int ixp2000_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
@@ -72,8 +75,8 @@ ixp2000_wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-ixp2000_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -103,9 +106,8 @@ static struct watchdog_info ident = {
 	.identity	= "IXP2000 Watchdog",
 };
 
-static int
-ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-			unsigned long arg)
+static long ixp2000_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -151,16 +153,13 @@ ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	return ret;
 }
 
-static int
-ixp2000_wdt_release(struct inode *inode, struct file *file)
+static int ixp2000_wdt_release(struct inode *inode, struct file *file)
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
 
@@ -168,18 +167,16 @@ ixp2000_wdt_release(struct inode *inode, struct file *file)
 }
 
 
-static const struct file_operations ixp2000_wdt_fops =
-{
+static const struct file_operations ixp2000_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ixp2000_wdt_write,
-	.ioctl		= ixp2000_wdt_ioctl,
+	.unlocked_ioctl	= ixp2000_wdt_ioctl,
 	.open		= ixp2000_wdt_open,
 	.release	= ixp2000_wdt_release,
 };
 
-static struct miscdevice ixp2000_wdt_miscdev =
-{
+static struct miscdevice ixp2000_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &ixp2000_wdt_fops,
@@ -191,9 +188,8 @@ static int __init ixp2000_wdt_init(void)
 		printk(KERN_INFO "Unable to use IXP2000 watchdog due to IXP2800 erratum #25.\n");
 		return -EIO;
 	}
-
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-
+	spin_lock_init(&wdt_lock);
 	return misc_register(&ixp2000_wdt_miscdev);
 }
 

