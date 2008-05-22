Return-Path: <linux-kernel-owner+w=401wt.eu-S1764542AbYEVWZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764542AbYEVWZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbYEVWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:24:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34714 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757061AbYEVWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:24:55 -0400
Date: Thu, 22 May 2008 23:12:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] rtc: Push the BKL down into the driver ioctl method
Message-ID: <20080522231223.65b32d3d@core>
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

For now just wrap the main logic, but this driver is a prime candidate
for someone wanting to eliminate the lock entirely

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 5f80a9d..3ea201a 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -77,9 +77,10 @@
 #include <linux/wait.h>
 #include <linux/bcd.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
 #include <asm/current.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #ifdef CONFIG_X86
@@ -143,8 +144,7 @@ static DEFINE_TIMER(rtc_irq_timer, rtc_dropped_irq, 0, 0);
 static ssize_t rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos);
 
-static int rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
@@ -717,10 +717,13 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 			    &wtime, sizeof wtime) ? -EFAULT : 0;
 }
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return rtc_do_ioctl(cmd, arg, 0);
+	long ret;
+	lock_kernel();
+	ret = rtc_do_ioctl(cmd, arg, 0);
+	unlock_kernel();
+	return ret;
 }
 
 /*
@@ -910,7 +913,7 @@ static const struct file_operations rtc_fops = {
 #ifdef RTC_IRQ
 	.poll		= rtc_poll,
 #endif
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
 	.fasync		= rtc_fasync,
