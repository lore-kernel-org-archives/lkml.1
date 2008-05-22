Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYEVUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYEVUsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbYEVUsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:48:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44003 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755060AbYEVUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:48:00 -0400
Date: Thu, 22 May 2008 21:35:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: [PATCH] ds1620: Push BKL down
Message-ID: <20080522213529.1423c01f@core>
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

Push down the BKL and correct the ioctl return for unknown ioctls.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index 334ad5b..6db699d 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -8,10 +8,11 @@
 #include <linux/proc_fs.h>
 #include <linux/capability.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/uaccess.h>
 #include <asm/therm.h>
 
 #ifdef CONFIG_PROC_FS
@@ -225,8 +226,8 @@ ds1620_read(struct file *file, char __user *buf, size_t count, loff_t *ptr)
 	return 1;
 }
 
-static int
-ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long ds1620_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct therm therm;
 	union {
@@ -254,13 +255,16 @@ ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned
 
 		therm.lo <<= 1;
 		therm.hi <<= 1;
-
+		lock_kernel();
 		ds1620_write_state(&therm);
+		unlock_kernel();
 		break;
 
 	case CMD_GET_THERMOSTATE:
 	case CMD_GET_THERMOSTATE2:
+		lock_kernel();
 		ds1620_read_state(&therm);
+		unlock_kernel();
 
 		therm.lo >>= 1;
 		therm.hi >>= 1;
@@ -276,20 +280,25 @@ ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned
 
 	case CMD_GET_TEMPERATURE:
 	case CMD_GET_TEMPERATURE2:
+		lock_kernel();
 		i = cvt_9_to_int(ds1620_in(THERM_READ_TEMP, 9));
 
 		if (cmd == CMD_GET_TEMPERATURE)
 			i >>= 1;
-
+		unlock_kernel();
 		return put_user(i, uarg.i) ? -EFAULT : 0;
 
 	case CMD_GET_STATUS:
+		lock_kernel();
 		i = ds1620_in(THERM_READ_CONFIG, 8) & 0xe3;
+		unlock_kernel();
 
 		return put_user(i, uarg.i) ? -EFAULT : 0;
 
 	case CMD_GET_FAN:
+		lock_kernel();
 		i = netwinder_get_fan();
+		unnlock_kernel();
 
 		return put_user(i, uarg.i) ? -EFAULT : 0;
 
@@ -299,14 +308,14 @@ ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned
 
 		if (get_user(i, uarg.i))
 			return -EFAULT;
-
+		lock_kernel();
 		netwinder_set_fan(i);
+		unlock_kernel();
 		break;
 		
 	default:
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 	}
-
 	return 0;
 }
 
@@ -338,7 +347,7 @@ static const struct file_operations ds1620_fops = {
 	.owner		= THIS_MODULE,
 	.open		= nonseekable_open,
 	.read		= ds1620_read,
-	.ioctl		= ds1620_ioctl,
+	.unlocked_ioctl	= ds1620_ioctl,
 };
 
 static struct miscdevice ds1620_miscdev = {
