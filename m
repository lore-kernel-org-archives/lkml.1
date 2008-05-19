Return-Path: <linux-kernel-owner+w=401wt.eu-S1763700AbYESN20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763700AbYESN20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760606AbYESNTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45907 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759859AbYESNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 30/57] omap_wdt: locking, unlocked_ioctl, tidy
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:32 +0100
Message-ID: <20080519130731.31722.15156.stgit@core>
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

 drivers/watchdog/omap_wdt.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)


diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 74bc39a..ccdf069 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -41,9 +41,9 @@
 #include <linux/clk.h>
 #include <linux/bitops.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/hardware.h>
+#include </io.h>
+#include <linux/uaccess.h>
+#include <linux/hardware.h>
 
 #include <asm/arch/prcm.h>
 
@@ -54,11 +54,12 @@ module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
 static int omap_wdt_users;
-static struct clk *armwdt_ck = NULL;
-static struct clk *mpu_wdt_ick = NULL;
-static struct clk *mpu_wdt_fck = NULL;
+static struct clk *armwdt_ck;
+static struct clk *mpu_wdt_ick;
+static struct clk *mpu_wdt_fck;
 
 static unsigned int wdt_trgr_pattern = 0x1234;
+static spinlock_t wdt_lock;
 
 static void omap_wdt_ping(void)
 {
@@ -174,22 +175,23 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-omap_wdt_write(struct file *file, const char __user *data,
+static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 		size_t len, loff_t *ppos)
 {
 	/* Refresh LOAD_TIME. */
-	if (len)
+	if (len) {
+		spin_lock(&wdt_lock);
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
+	}
 	return len;
 }
 
-static int
-omap_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int new_margin;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "OMAP Watchdog",
 		.options = WDIOF_SETTIMEOUT,
 		.firmware_version = 0,
@@ -211,18 +213,22 @@ omap_wdt_ioctl(struct inode *inode, struct file *file,
 			return put_user(omap_prcm_get_reset_sources(),
 					(int __user *)arg);
 	case WDIOC_KEEPALIVE:
+		spin_lock(&wdt_lock);
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
 		return 0;
 	case WDIOC_SETTIMEOUT:
 		if (get_user(new_margin, (int __user *)arg))
 			return -EFAULT;
 		omap_wdt_adjust_timeout(new_margin);
 
+		spin_lock(&wdt_lock);
 		omap_wdt_disable();
 		omap_wdt_set_timeout();
 		omap_wdt_enable();
 
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timer_margin, (int __user *)arg);
@@ -232,7 +238,7 @@ omap_wdt_ioctl(struct inode *inode, struct file *file,
 static const struct file_operations omap_wdt_fops = {
 	.owner = THIS_MODULE,
 	.write = omap_wdt_write,
-	.ioctl = omap_wdt_ioctl,
+	.unlocked_ioctl = omap_wdt_ioctl,
 	.open = omap_wdt_open,
 	.release = omap_wdt_release,
 };
@@ -373,6 +379,7 @@ static struct platform_driver omap_wdt_driver = {
 
 static int __init omap_wdt_init(void)
 {
+	spin_lock_init(&wdt_lock);
 	return platform_driver_register(&omap_wdt_driver);
 }
 

