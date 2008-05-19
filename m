Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbYESNgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbYESNgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761513AbYESNVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:21:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46025 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760417AbYESNVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:21:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 55/57] wdt285: switch to unlocked_ioctl and tidy up oddments
	of coding style
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:51 +0100
Message-ID: <20080519130951.31722.97834.stgit@core>
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

 drivers/watchdog/wdt285.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)


diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index e4cf661..fea398a 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -26,9 +26,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
+#include <linux/irq.h>
 
-#include <asm/irq.h>
-#include <asm/uaccess.h>
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/hardware/dec21285.h>
@@ -115,8 +115,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-watchdog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t watchdog_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
@@ -127,19 +127,18 @@ watchdog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_SETTIMEOUT,
 	.identity	= "Footbridge Watchdog",
 };
 
-static int
-watchdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	unsigned int new_margin;
 	int ret = -ENOTTY;
 
-	switch(cmd) {
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = 0;
 		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
@@ -148,7 +147,7 @@ watchdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0,(int *)arg);
+		ret = put_user(0, (int *)arg);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -182,7 +181,7 @@ static const struct file_operations watchdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= watchdog_write,
-	.ioctl		= watchdog_ioctl,
+	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
 	.release	= watchdog_release,
 };
@@ -204,11 +203,13 @@ static int __init footbridge_watchdog_init(void)
 	if (retval < 0)
 		return retval;
 
-	printk("Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
-	       soft_margin);
+	printk(KERN_INFO
+		"Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
+								soft_margin);
 
 	if (machine_is_cats())
-		printk("Warning: Watchdog reset may not work on this machine.\n");
+		printk(KERN_WARN
+		  "Warning: Watchdog reset may not work on this machine.\n");
 	return 0;
 }
 
@@ -223,7 +224,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(soft_margin, int, 0);
-MODULE_PARM_DESC(soft_margin,"Watchdog timeout in seconds");
+MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
 
 module_init(footbridge_watchdog_init);
 module_exit(footbridge_watchdog_exit);

