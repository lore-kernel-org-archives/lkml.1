Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbYESNYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbYESNYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbYESNSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45858 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759571AbYESNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 20/57] booke watchdog: clean up and unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:36 +0100
Message-ID: <20080519130636.31722.55578.stgit@core>
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

 drivers/watchdog/booke_wdt.c |   57 ++++++++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 27 deletions(-)


diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index d362f5b..5d52d35 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -19,9 +19,9 @@
 #include <linux/miscdevice.h>
 #include <linux/notifier.h>
 #include <linux/watchdog.h>
+#include <linux/uaccess.h>
 
 #include <asm/reg_booke.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* If the kernel parameter wdt=1, the watchdog will be enabled at boot.
@@ -33,12 +33,12 @@
  */
 
 #ifdef	CONFIG_FSL_BOOKE
-#define WDT_PERIOD_DEFAULT 63	/* Ex. wdt_period=28 bus=333Mhz , reset=~40sec */
+#define WDT_PERIOD_DEFAULT 63	/* Ex. wdt_period=28 bus=333Mhz,reset=~40sec */
 #else
 #define WDT_PERIOD_DEFAULT 3	/* Refer to the PPC40x and PPC4xx manuals */
 #endif				/* for timing information */
 
-u32 booke_wdt_enabled = 0;
+u32 booke_wdt_enabled;
 u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 #ifdef	CONFIG_FSL_BOOKE
@@ -50,7 +50,7 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 /*
  * booke_wdt_ping:
  */
-static __inline__ void booke_wdt_ping(void)
+static inline void booke_wdt_ping(void)
 {
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
 }
@@ -58,7 +58,7 @@ static __inline__ void booke_wdt_ping(void)
 /*
  * booke_wdt_enable:
  */
-static __inline__ void booke_wdt_enable(void)
+static inline void booke_wdt_enable(void)
 {
 	u32 val;
 
@@ -73,7 +73,7 @@ static __inline__ void booke_wdt_enable(void)
 /*
  * booke_wdt_write:
  */
-static ssize_t booke_wdt_write (struct file *file, const char __user *buf,
+static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	booke_wdt_ping();
@@ -81,24 +81,23 @@ static ssize_t booke_wdt_write (struct file *file, const char __user *buf,
 }
 
 static struct watchdog_info ident = {
-  .options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-  .firmware_version = 0,
-  .identity = "PowerPC Book-E Watchdog",
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.firmware_version = 0,
+	.identity = "PowerPC Book-E Watchdog",
 };
 
 /*
  * booke_wdt_ioctl:
  */
-static int booke_wdt_ioctl (struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg)
+static long booke_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	u32 tmp = 0;
 	u32 __user *p = (u32 __user *)arg;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user ((struct watchdog_info __user *) arg, &ident,
-				sizeof(struct watchdog_info)))
+		if (copy_to_user(arg, &ident, sizeof(struct watchdog_info)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
 		return put_user(ident.options, p);
@@ -113,7 +112,8 @@ static int booke_wdt_ioctl (struct inode *inode, struct file *file,
 	case WDIOC_SETTIMEOUT:
 		if (get_user(booke_wdt_period, p))
 			return -EFAULT;
-		mtspr(SPRN_TCR, (mfspr(SPRN_TCR)&~WDTP(0))|WDTP(booke_wdt_period));
+		mtspr(SPRN_TCR, (mfspr(SPRN_TCR) & ~WDTP(0)) |
+						WDTP(booke_wdt_period));
 		return 0;
 	case WDIOC_GETTIMEOUT:
 		return put_user(booke_wdt_period, p);
@@ -135,12 +135,13 @@ static int booke_wdt_ioctl (struct inode *inode, struct file *file,
 /*
  * booke_wdt_open:
  */
-static int booke_wdt_open (struct inode *inode, struct file *file)
+static int booke_wdt_open(struct inode *inode, struct file *file)
 {
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
 		booke_wdt_enable();
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
+		printk(KERN_INFO
+		     "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
 				booke_wdt_period);
 	}
 
@@ -148,17 +149,17 @@ static int booke_wdt_open (struct inode *inode, struct file *file)
 }
 
 static const struct file_operations booke_wdt_fops = {
-  .owner = THIS_MODULE,
-  .llseek = no_llseek,
-  .write = booke_wdt_write,
-  .ioctl = booke_wdt_ioctl,
-  .open = booke_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = booke_wdt_write,
+	.unlocked_ioctl = booke_wdt_ioctl,
+	.open = booke_wdt_open,
 };
 
 static struct miscdevice booke_wdt_miscdev = {
-  .minor = WATCHDOG_MINOR,
-  .name = "watchdog",
-  .fops = &booke_wdt_fops,
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &booke_wdt_fops,
 };
 
 static void __exit booke_wdt_exit(void)
@@ -173,18 +174,20 @@ static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	printk (KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
+	printk(KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		printk (KERN_CRIT "Cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_CRIT
+			"Cannot register miscdev on minor=%d (err=%d)\n",
 				WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
 	if (booke_wdt_enabled == 1) {
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
+		printk(KERN_INFO
+		    "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
 				booke_wdt_period);
 		booke_wdt_enable();
 	}

