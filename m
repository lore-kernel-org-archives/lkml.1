Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbYESNTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbYESNTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbYESNRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759464AbYESNRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:08 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/57] at91: watchdog to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:19 +0100
Message-ID: <20080519130519.31722.15841.stgit@core>
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

Review and switch to unlocked_ioctl
---

 drivers/watchdog/at91rm9200_wdt.c |  108 +++++++++++++++++++------------------
 1 files changed, 54 insertions(+), 54 deletions(-)


diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index 9ff9a95..bb79f64 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/arch/at91_st.h>
 
 
@@ -31,11 +31,14 @@ static int wdt_time = WDT_DEFAULT_TIME;
 static int nowayout = WATCHDOG_NOWAYOUT;
 
 module_param(wdt_time, int, 0);
-MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="__MODULE_STRING(WDT_DEFAULT_TIME) ")");
+MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
+				__MODULE_STRING(WDT_DEFAULT_TIME) ")");
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 #endif
 
 
@@ -46,7 +49,7 @@ static unsigned long at91wdt_busy;
 /*
  * Disable the watchdog.
  */
-static void inline at91_wdt_stop(void)
+static inline void at91_wdt_stop(void)
 {
 	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN);
 }
@@ -54,16 +57,17 @@ static void inline at91_wdt_stop(void)
 /*
  * Enable and reset the watchdog.
  */
-static void inline at91_wdt_start(void)
+static inline void at91_wdt_start(void)
 {
-	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN | (((65536 * wdt_time) >> 8) & AT91_ST_WDV));
+	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN |
+				(((65536 * wdt_time) >> 8) & AT91_ST_WDV));
 	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static void inline at91_wdt_reload(void)
+static inline void at91_wdt_reload(void)
 {
 	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
 }
@@ -89,8 +93,9 @@ static int at91_wdt_open(struct inode *inode, struct file *file)
  */
 static int at91_wdt_close(struct inode *inode, struct file *file)
 {
+	/* Disable the watchdog when file is closed */
 	if (!nowayout)
-		at91_wdt_stop();	/* Disable the watchdog when file is closed */
+		at91_wdt_stop();
 
 	clear_bit(0, &at91wdt_busy);
 	return 0;
@@ -110,7 +115,8 @@ static int at91_wdt_settimeout(int new_time)
 	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
 		return -EINVAL;
 
-	/* Set new watchdog time. It will be used when at91_wdt_start() is called. */
+	/* Set new watchdog time. It will be used when
+	   at91_wdt_start() is called. */
 	wdt_time = new_time;
 	return 0;
 }
@@ -123,60 +129,52 @@ static struct watchdog_info at91_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static int at91_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long at91_wdt_ioct(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_value;
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			at91_wdt_reload();	/* pat the watchdog */
-			return 0;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &at91_wdt_info, sizeof(at91_wdt_info)) ? -EFAULT : 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (at91_wdt_settimeout(new_value))
-				return -EINVAL;
-
-			/* Enable new time value */
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		at91_wdt_reload();	/* pat the watchdog */
+		return 0;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &at91_wdt_info,
+				sizeof(at91_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (at91_wdt_settimeout(new_value))
+			return -EINVAL;
+		/* Enable new time value */
+		at91_wdt_start();
+		/* Return current value */
+		return put_user(wdt_time, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_time, p);
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (new_value & WDIOS_DISABLECARD)
+			at91_wdt_stop();
+		if (new_value & WDIOS_ENABLECARD)
 			at91_wdt_start();
-
-			/* Return current value */
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_SETOPTIONS:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (new_value & WDIOS_DISABLECARD)
-				at91_wdt_stop();
-			if (new_value & WDIOS_ENABLECARD)
-				at91_wdt_start();
-			return 0;
-
-		default:
-			return -ENOTTY;
+		return 0;
+	default:
+		return -ENOTTY;
 	}
 }
 
 /*
  * Pat the watchdog whenever device is written to.
  */
-static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t at91_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	at91_wdt_reload();		/* pat the watchdog */
 	return len;
@@ -187,7 +185,7 @@ static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len, l
 static const struct file_operations at91wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= at91_wdt_ioctl,
+	.unlocked_ioctl	= at91_wdt_ioctl,
 	.open		= at91_wdt_open,
 	.release	= at91_wdt_close,
 	.write		= at91_wdt_write,
@@ -211,7 +209,8 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	printk("AT91 Watchdog Timer enabled (%d seconds%s)\n", wdt_time, nowayout ? ", nowayout" : "");
+	printk(KERN_INFO "AT91 Watchdog Timer enabled (%d seconds%s)\n",
+				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -265,7 +264,8 @@ static struct platform_driver at91wdt_driver = {
 
 static int __init at91_wdt_init(void)
 {
-	/* Check that the heartbeat value is within range; if not reset to the default */
+	/* Check that the heartbeat value is within range;
+	   if not reset to the default */
 	if (at91_wdt_settimeout(wdt_time)) {
 		at91_wdt_settimeout(WDT_DEFAULT_TIME);
 		pr_info("at91_wdt: wdt_time value must be 1 <= wdt_time <= 256, using %d\n", wdt_time);

