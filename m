Return-Path: <linux-kernel-owner+w=401wt.eu-S1764664AbYESNcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764664AbYESNcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760968AbYESNUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:20:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45963 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760070AbYESNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 38/57] stg7240_wdt: unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:16 +0100
Message-ID: <20080519130816.31722.63406.stgit@core>
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

 drivers/watchdog/sbc7240_wdt.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)


diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 4c8cefb..abccbe2 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -27,10 +27,10 @@
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
-#include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
 
@@ -159,7 +159,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_KEEPALIVEPING|
 		   WDIOF_SETTIMEOUT|
 		   WDIOF_MAGICCLOSE,
@@ -168,14 +168,12 @@ static struct watchdog_info ident = {
 };
 
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		return copy_to_user
-			((void __user *)arg, &ident, sizeof(ident))
-			 ? -EFAULT : 0;
+		return copy_to_user((void __user *)arg, &ident, sizeof(ident))
+						 ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, (int __user *)arg);
@@ -225,7 +223,7 @@ static const struct file_operations wdt_fops = {
 	.write = fop_write,
 	.open = fop_open,
 	.release = fop_close,
-	.ioctl = fop_ioctl,
+	.unlocked_ioctl = fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {

