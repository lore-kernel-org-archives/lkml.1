Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbYESN1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbYESN1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760550AbYESNTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45901 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760524AbYESNTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 29/57] mv64x60_wdt: clean up and locking checks
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:26 +0100
Message-ID: <20080519130726.31722.86704.stgit@core>
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

 drivers/watchdog/mv64x60_wdt.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)


diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index b59ca32..ac09fe4 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -8,7 +8,7 @@
  * and services the watchdog.
  *
  * Derived from mpc8xx_wdt.c, with the following copyright.
- * 
+ *
  * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
  * the terms of the GNU General Public License version 2. This program
  * is licensed "as is" without any warranty of any kind, whether express
@@ -24,8 +24,8 @@
 #include <linux/platform_device.h>
 
 #include <linux/mv643xx.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define MV64x60_WDT_WDC_OFFSET	0
 
@@ -61,7 +61,9 @@ static DEFINE_SPINLOCK(mv64x60_wdt_spinlock);
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static int mv64x60_wdt_toggle_wdc(int enabled_predicate, int field_shift)
 {
@@ -150,7 +152,7 @@ static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 }
 
 static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
-				 size_t len, loff_t * ppos)
+				 size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -160,7 +162,7 @@ static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data + i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -172,8 +174,8 @@ static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long mv64x60_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
 	int options;
@@ -240,7 +242,7 @@ static const struct file_operations mv64x60_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = mv64x60_wdt_write,
-	.ioctl = mv64x60_wdt_ioctl,
+	.unlocked_ioctl = mv64x60_wdt_ioctl,
 	.open = mv64x60_wdt_open,
 	.release = mv64x60_wdt_release,
 };

