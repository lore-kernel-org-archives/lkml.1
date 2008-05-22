Return-Path: <linux-kernel-owner+w=401wt.eu-S1759663AbYEVUvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663AbYEVUvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbYEVUvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:51:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50150 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754938AbYEVUvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:51:04 -0400
Date: Thu, 22 May 2008 21:38:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] efirtc: Push down the BKL
Message-ID: <20080522213832.29a969ba@core>
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

Push it down as far as the EFI method calls. Someone who knows EFI can do
the other bits. Also fix another wrong unknown ioctl return.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 49233f5..b092063 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -36,8 +36,9 @@
 #include <linux/rtc.h>
 #include <linux/proc_fs.h>
 #include <linux/efi.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define EFI_RTC_VERSION		"0.4"
@@ -50,8 +51,8 @@
 
 static DEFINE_SPINLOCK(efi_rtc_lock);
 
-static int efi_rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg);
 
 #define is_leap(year) \
           ((year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0))
@@ -145,9 +146,8 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	}
 }
 
-static int
-efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 
 	efi_status_t	status;
@@ -174,13 +174,13 @@ efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			return -EINVAL;
 
 		case RTC_RD_TIME:
-
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_time(&eft, &cap);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-
+			unlock_kernel();
 			if (status != EFI_SUCCESS) {
 				/* should never happen */
 				printk(KERN_ERR "efitime: can't read time\n");
@@ -202,11 +202,13 @@ efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 			convert_to_efi_time(&wtime, &eft);
 
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.set_time(&eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
+			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
@@ -222,6 +224,7 @@ efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 			convert_to_efi_time(&wtime, &eft);
 
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 			/*
 			 * XXX Fixme:
@@ -232,16 +235,19 @@ efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			status = efi.set_wakeup_time((efi_bool_t)enabled, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
+			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
 		case RTC_WKALM_RD:
 
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_wakeup_time((efi_bool_t *)&enabled, (efi_bool_t *)&pending, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
+			unlock_kernel();
 
 			if (status != EFI_SUCCESS) return -EINVAL;
 
@@ -255,7 +261,7 @@ efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			return copy_to_user(&ewp->time, &wtime,
 					    sizeof(struct rtc_time)) ? -EFAULT : 0;
 	}
-	return -EINVAL;
+	return -ENOTTY;
 }
 
 /*
@@ -264,8 +270,7 @@ efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
  *	up things on a close.
  */
 
-static int
-efi_rtc_open(struct inode *inode, struct file *file)
+static int efi_rtc_open(struct inode *inode, struct file *file)
 {
 	/*
 	 * nothing special to do here
@@ -275,8 +280,7 @@ efi_rtc_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int
-efi_rtc_close(struct inode *inode, struct file *file)
+static int efi_rtc_close(struct inode *inode, struct file *file)
 {
 	return 0;
 }
@@ -287,13 +291,12 @@ efi_rtc_close(struct inode *inode, struct file *file)
 
 static const struct file_operations efi_rtc_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= efi_rtc_ioctl,
+	.unlocked_ioctl	= efi_rtc_ioctl,
 	.open		= efi_rtc_open,
 	.release	= efi_rtc_close,
 };
 
-static struct miscdevice efi_rtc_dev=
-{
+static struct miscdevice efi_rtc_dev= {
 	EFI_RTC_MINOR,
 	"efirtc",
 	&efi_rtc_fops
