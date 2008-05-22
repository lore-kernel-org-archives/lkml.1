Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbYEVVpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbYEVVpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYEVVo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:44:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59920 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757422AbYEVVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:44:56 -0400
Date: Thu, 22 May 2008 22:32:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dz@debian.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i8k: Push the BKL down into the driver ioctl method
Message-ID: <20080522223223.62af5cd3@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index b60d425..1c22cff 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -23,8 +23,9 @@
 #include <linux/seq_file.h>
 #include <linux/dmi.h>
 #include <linux/capability.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <linux/i8k.h>
 
@@ -82,8 +83,7 @@ module_param(fan_mult, int, 0);
 MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
 
 static int i8k_open_fs(struct inode *inode, struct file *file);
-static int i8k_ioctl(struct inode *, struct file *, unsigned int,
-		     unsigned long);
+static long i8k_ioctl(struct file *, unsigned int, unsigned long);
 
 static const struct file_operations i8k_fops = {
 	.owner		= THIS_MODULE,
@@ -91,7 +91,7 @@ static const struct file_operations i8k_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
-	.ioctl		= i8k_ioctl,
+	.unlocked_ioctl	= i8k_ioctl,
 };
 
 struct smm_regs {
@@ -307,8 +307,7 @@ static int i8k_get_dell_signature(int req_fn)
 	return regs.eax == 1145651527 && regs.edx == 1145392204 ? 0 : -1;
 }
 
-static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
-		     unsigned long arg)
+static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int val = 0;
 	int speed;
@@ -318,6 +317,8 @@ static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 	if (!argp)
 		return -EINVAL;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
 		val = i8k_get_bios_version();
@@ -342,34 +343,33 @@ static int i8k_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 
 	case I8K_GET_SPEED:
 		if (copy_from_user(&val, argp, sizeof(int)))
-			return -EFAULT;
-
-		val = i8k_get_fan_speed(val);
+			val = -EFAULT;
+		else
+			val = i8k_get_fan_speed(val);
 		break;
 
 	case I8K_GET_FAN:
 		if (copy_from_user(&val, argp, sizeof(int)))
-			return -EFAULT;
-
-		val = i8k_get_fan_status(val);
+			val = -EFAULT;
+		else
+			val = i8k_get_fan_status(val);
 		break;
 
 	case I8K_SET_FAN:
 		if (restricted && !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&val, argp, sizeof(int)))
-			return -EFAULT;
-
-		if (copy_from_user(&speed, argp + 1, sizeof(int)))
-			return -EFAULT;
-
-		val = i8k_set_fan(val, speed);
+			val = -EPERM;
+		else if (copy_from_user(&val, argp, sizeof(int)))
+			val = -EFAULT;
+		else if (copy_from_user(&speed, argp + 1, sizeof(int)))
+			val = -EFAULT;
+		else
+			val = i8k_set_fan(val, speed);
 		break;
 
 	default:
-		return -EINVAL;
+		val = -ENOTTY;
 	}
+	unlock_kernel();
 
 	if (val < 0)
 		return val;
