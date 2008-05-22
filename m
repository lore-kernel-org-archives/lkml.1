Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbYEVVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbYEVVBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbYEVVBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:01:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37376 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757458AbYEVVBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:01:09 -0400
Date: Thu, 22 May 2008 21:48:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Subject: [PATCH] toshiba: Push BKL down into driver ioctl code
Message-ID: <20080522214840.1f096189@core>
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

Another I suspect the actual maintainer can easily then eliminate the BKL
from entirely.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 663cd15..640e3f3 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -68,6 +68,7 @@
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 
 #include <linux/toshiba.h>
 
@@ -88,13 +89,12 @@ static int tosh_date;
 static int tosh_sci;
 static int tosh_fan;
 
-static int tosh_ioctl(struct inode *, struct file *, unsigned int,
-	unsigned long);
+static long tosh_ioctl(struct file *, unsigned int, unsigned long);
 
 
 static const struct file_operations tosh_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= tosh_ioctl,
+	.unlocked_ioctl	= tosh_ioctl,
 };
 
 static struct miscdevice tosh_device = {
@@ -252,8 +252,7 @@ int tosh_smm(SMMRegisters *regs)
 EXPORT_SYMBOL(tosh_smm);
 
 
-static int tosh_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
-	unsigned long arg)
+static long tosh_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	SMMRegisters regs;
 	SMMRegisters __user *argp = (SMMRegisters __user *)arg;
@@ -275,16 +274,19 @@ static int tosh_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
 				return -EINVAL;
 
 			/* do we need to emulate the fan ? */
+			lock_kernel();
 			if (tosh_fan==1) {
 				if (((ax==0xf300) || (ax==0xf400)) && (bx==0x0004)) {
 					err = tosh_emulate_fan(&regs);
+					unlock_kernel();
 					break;
 				}
 			}
 			err = tosh_smm(&regs);
+			unlock_kernel();
 			break;
 		default:
-			return -EINVAL;
+			return -ENOTTY;
 	}
 
         if (copy_to_user(argp, &regs, sizeof(SMMRegisters)))
