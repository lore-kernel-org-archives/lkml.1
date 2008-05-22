Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYEVUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYEVUzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbYEVUzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:55:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54311 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754134AbYEVUzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:55:13 -0400
Date: Thu, 22 May 2008 21:42:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmtimer: Push BKL down into the ioctl handler
Message-ID: <20080522214244.457da3d7@core>
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

Switches to unlocked_ioctl read to remove ioctl BKL method. Fix the
unknown ioctl return. Probably a nice easy one to kill off BKL usage
entirely later

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 192961f..918711a 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/math64.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/sn/addrs.h>
@@ -57,8 +58,8 @@ extern unsigned long sn_rtc_cycles_per_second;
 
 #define rtc_time()              (*RTC_COUNTER_ADDR)
 
-static int mmtimer_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg);
+static long mmtimer_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg);
 static int mmtimer_mmap(struct file *file, struct vm_area_struct *vma);
 
 /*
@@ -67,9 +68,9 @@ static int mmtimer_mmap(struct file *file, struct vm_area_struct *vma);
 static unsigned long mmtimer_femtoperiod = 0;
 
 static const struct file_operations mmtimer_fops = {
-	.owner =	THIS_MODULE,
-	.mmap =		mmtimer_mmap,
-	.ioctl =	mmtimer_ioctl,
+	.owner = THIS_MODULE,
+	.mmap =	mmtimer_mmap,
+	.unlocked_ioctl = mmtimer_ioctl,
 };
 
 /*
@@ -339,7 +340,6 @@ restart:
 
 /**
  * mmtimer_ioctl - ioctl interface for /dev/mmtimer
- * @inode: inode of the device
  * @file: file structure for the device
  * @cmd: command to execute
  * @arg: optional argument to command
@@ -365,11 +365,13 @@ restart:
  * %MMTIMER_GETCOUNTER - Gets the current value in the counter and places it
  * in the address specified by @arg.
  */
-static int mmtimer_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long mmtimer_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int ret = 0;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case MMTIMER_GETOFFSET:	/* offset of the counter */
 		/*
@@ -384,15 +386,14 @@ static int mmtimer_ioctl(struct inode *inode, struct file *file,
 	case MMTIMER_GETRES: /* resolution of the clock in 10^-15 s */
 		if(copy_to_user((unsigned long __user *)arg,
 				&mmtimer_femtoperiod, sizeof(unsigned long)))
-			return -EFAULT;
+			ret = -EFAULT;
 		break;
 
 	case MMTIMER_GETFREQ: /* frequency in Hz */
 		if(copy_to_user((unsigned long __user *)arg,
 				&sn_rtc_cycles_per_second,
 				sizeof(unsigned long)))
-			return -EFAULT;
-		ret = 0;
+			ret = -EFAULT;
 		break;
 
 	case MMTIMER_GETBITS: /* number of bits in the clock */
@@ -406,13 +407,13 @@ static int mmtimer_ioctl(struct inode *inode, struct file *file,
 	case MMTIMER_GETCOUNTER:
 		if(copy_to_user((unsigned long __user *)arg,
 				RTC_COUNTER_ADDR, sizeof(unsigned long)))
-			return -EFAULT;
+			ret = -EFAULT;
 		break;
 	default:
-		ret = -ENOSYS;
+		ret = -ENOTTY;
 		break;
 	}
-
+	unlock_kernel();
 	return ret;
 }
 
