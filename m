Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbYESNUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbYESNUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbYESNRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45810 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756767AbYESNRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:24 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/57] ep93xx_wdt: unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:35 +0100
Message-ID: <20080519130535.31722.90948.stgit@core>
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

 drivers/watchdog/ep93xx_wdt.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)


diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 0e4787a..cdcdd11 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -28,9 +28,9 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 #define WDT_VERSION	"0.3"
 #define PFX		"ep93xx_wdt: "
@@ -136,9 +136,8 @@ static struct watchdog_info ident = {
 	.identity = "EP93xx Watchdog",
 };
 
-static int
-ep93xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		 unsigned long arg)
+static long ep93xx_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 
@@ -174,8 +173,8 @@ static int ep93xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_shutdown();
 	else
-		printk(KERN_CRIT PFX "Device closed unexpectedly - "
-			"timer will not stop\n");
+		printk(KERN_CRIT PFX
+			"Device closed unexpectedly - timer will not stop\n");
 
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -186,7 +185,7 @@ static int ep93xx_wdt_release(struct inode *inode, struct file *file)
 static const struct file_operations ep93xx_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ep93xx_wdt_write,
-	.ioctl		= ep93xx_wdt_ioctl,
+	.unlocked_ioctl	= ep93xx_wdt_ioctl,
 	.open		= ep93xx_wdt_open,
 	.release	= ep93xx_wdt_release,
 };
@@ -243,7 +242,9 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>,"
 		"Alessandro Zummo <a.zummo@towertech.it>");

