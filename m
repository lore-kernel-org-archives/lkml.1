Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbYEVVnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbYEVVnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbYEVVn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:43:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59914 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760003AbYEVVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:43:24 -0400
Date: Thu, 22 May 2008 22:30:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ds1302: Push down the BKL into the driver ioctl code
Message-ID: <20080522223022.288faba6@core>
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

diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index fada6dd..c5e67a6 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -20,10 +20,11 @@
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/bcd.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
-#include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/rtc.h>
 #if defined(CONFIG_M32R)
 #include <asm/m32r.h>
@@ -153,9 +154,7 @@ static unsigned char days_in_mo[] =
 
 /* ioctl that supports RTC_RD_TIME and RTC_SET_TIME (read and set time/date). */
 
-static int
-rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
 
@@ -165,7 +164,9 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			struct rtc_time rtc_tm;
 
 			memset(&rtc_tm, 0, sizeof (struct rtc_time));
+			lock_kernel();
 			get_rtc_time(&rtc_tm);
+			unlock_kernel();
 			if (copy_to_user((struct rtc_time*)arg, &rtc_tm, sizeof(struct rtc_time)))
 				return -EFAULT;
 			return 0;
@@ -217,6 +218,7 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			BIN_TO_BCD(mon);
 			BIN_TO_BCD(yrs);
 
+			lock_kernel();
 			local_irq_save(flags);
 			CMOS_WRITE(yrs, RTC_YEAR);
 			CMOS_WRITE(mon, RTC_MONTH);
@@ -225,6 +227,7 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			CMOS_WRITE(min, RTC_MINUTES);
 			CMOS_WRITE(sec, RTC_SECONDS);
 			local_irq_restore(flags);
+			unlock_kernel();
 
 			/* Notice that at this point, the RTC is updated but
 			 * the kernel is still running with the old time.
@@ -244,8 +247,10 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			if(copy_from_user(&tcs_val, (int*)arg, sizeof(int)))
 				return -EFAULT;
 
+			lock_kernel();
 			tcs_val = RTC_TCR_PATTERN | (tcs_val & 0x0F);
 			ds1302_writereg(RTC_TRICKLECHARGER, tcs_val);
+			unlock_kernel();
 			return 0;
 		}
 		default:
@@ -282,7 +287,7 @@ get_rtc_status(char *buf)
 
 static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 };
 
 /* Probe for the chip by writing something to its RAM and try reading it back. */
