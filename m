Return-Path: <linux-kernel-owner+w=401wt.eu-S1762371AbYESNbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762371AbYESNbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760935AbYESNUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:20:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754957AbYESNU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 39/57] sbc8360: clean up
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:22 +0100
Message-ID: <20080519130822.31722.59376.stgit@core>
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

Needs a proper ioctl method adding and stuff
---

 drivers/watchdog/sbc8360.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)


diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 2ee2677..c66fa66 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -48,13 +48,12 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static unsigned long sbc8360_is_open;
-static DEFINE_SPINLOCK(sbc8360_lock);
 static char expect_close;
 
 #define PFX "sbc8360: "
@@ -204,7 +203,8 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Index into timeout table (0-63) (default=27 (60s))");
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
-		 "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+		 "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
@@ -232,8 +232,8 @@ static void sbc8360_ping(void)
 }
 
 /* Userspace pings kernel driver, or requests clean close */
-static ssize_t sbc8360_write(struct file *file, const char __user * buf,
-			     size_t count, loff_t * ppos)
+static ssize_t sbc8360_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -257,16 +257,12 @@ static ssize_t sbc8360_write(struct file *file, const char __user * buf,
 
 static int sbc8360_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
-	if (test_and_set_bit(0, &sbc8360_is_open)) {
-		spin_unlock(&sbc8360_lock);
+	if (test_and_set_bit(0, &sbc8360_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	/* Activate and ping once to start the countdown */
-	spin_unlock(&sbc8360_lock);
 	sbc8360_activate();
 	sbc8360_ping();
 	return nonseekable_open(inode, file);
@@ -274,16 +270,14 @@ static int sbc8360_open(struct inode *inode, struct file *file)
 
 static int sbc8360_close(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
 	if (expect_close == 42)
 		outb(0, SBC8360_ENABLE);
 	else
 		printk(KERN_CRIT PFX
-		       "SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
+			"SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
 	expect_close = 0;
-	spin_unlock(&sbc8360_lock);
 	return 0;
 }
 
@@ -382,13 +376,13 @@ static int __init sbc8360_init(void)
 
 	return 0;
 
-      out_nomisc:
+out_nomisc:
 	unregister_reboot_notifier(&sbc8360_notifier);
-      out_noreboot:
+out_noreboot:
 	release_region(SBC8360_BASETIME, 1);
-      out_nobasetimereg:
+out_nobasetimereg:
 	release_region(SBC8360_ENABLE, 1);
-      out:
+out:
 	return res;
 }
 

