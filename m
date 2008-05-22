Return-Path: <linux-kernel-owner+w=401wt.eu-S1762552AbYEVVNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762552AbYEVVNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbYEVVNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:13:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35127 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755756AbYEVVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:13:10 -0400
Date: Thu, 22 May 2008 22:00:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
Subject: [PATCH] rtc: Push BKL for ioctl down into the rtc drivers
Message-ID: <20080522220031.03d635d8@core>
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

diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 90dfa0d..583ba6b 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -203,8 +203,8 @@ static unsigned int rtc_dev_poll(struct file *file, poll_table *wait)
 	return (data != 0) ? (POLLIN | POLLRDNORM) : 0;
 }
 
-static int rtc_dev_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long rtc_dev_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int err = 0;
 	struct rtc_device *rtc = file->private_data;
@@ -225,6 +225,8 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 		break;
 
 	case RTC_IRQP_SET:
+		/* FIXME: Do we need to lock rtc->max_user_freq
+		   - probably not */
 		if (arg > rtc->max_user_freq && !capable(CAP_SYS_RESOURCE))
 			return -EACCES;
 		break;
@@ -238,7 +240,9 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 
 	/* try the driver's ioctl interface */
 	if (ops->ioctl) {
+		lock_kernel();
 		err = ops->ioctl(rtc->dev.parent, cmd, arg);
+		unlock_kernel();
 		if (err != -ENOIOCTLCMD)
 			return err;
 	}
@@ -259,7 +263,9 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 
 	switch (cmd) {
 	case RTC_ALM_READ:
+		lock_kernel();
 		err = rtc_read_alarm(rtc, &alarm);
+		unlock_kernel();
 		if (err < 0)
 			return err;
 
@@ -301,7 +307,9 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 			alarm.time.tm_mday = tm.tm_mday;
 			alarm.time.tm_mon = tm.tm_mon;
 			alarm.time.tm_year = tm.tm_year;
+			lock_kernel();
 			err  = rtc_valid_tm(&alarm.time);
+			unlock_kernel();
 			if (err < 0)
 				return err;
 			rtc_tm_to_time(&alarm.time, &then);
@@ -319,7 +327,9 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 		break;
 
 	case RTC_RD_TIME:
+		lock_kernel();
 		err = rtc_read_time(rtc, &tm);
+		unlock_kernel();
 		if (err < 0)
 			return err;
 
@@ -331,19 +341,27 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 		if (copy_from_user(&tm, uarg, sizeof(tm)))
 			return -EFAULT;
 
+		lock_kernel();
 		err = rtc_set_time(rtc, &tm);
+		unlock_kernel();
 		break;
 
 	case RTC_PIE_ON:
+		lock_kernel();
 		err = rtc_irq_set_state(rtc, NULL, 1);
+		unlock_kernel();
 		break;
 
 	case RTC_PIE_OFF:
+		lock_kernel();
 		err = rtc_irq_set_state(rtc, NULL, 0);
+		unlock_kernel();
 		break;
 
 	case RTC_IRQP_SET:
+		lock_kernel();
 		err = rtc_irq_set_freq(rtc, NULL, arg);
+		unlock_kernel();
 		break;
 
 	case RTC_IRQP_READ:
@@ -360,7 +378,9 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 			err = -EINVAL;
 			break;
 		}
+		lock_kernel();
 		rtc_epoch = arg;
+		unlock_kernel();
 		err = 0;
 #endif
 		break;
@@ -373,11 +393,15 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 		if (copy_from_user(&alarm, uarg, sizeof(alarm)))
 			return -EFAULT;
 
+		lock_kernel();
 		err = rtc_set_alarm(rtc, &alarm);
+		unlock_kernel();
 		break;
 
 	case RTC_WKALM_RD:
+		lock_kernel();
 		err = rtc_read_alarm(rtc, &alarm);
+		unlock_kernel();
 		if (err < 0)
 			return err;
 
@@ -387,11 +411,15 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	case RTC_UIE_OFF:
+		lock_kernel();
 		clear_uie(rtc);
+		unlock_kernel();
 		return 0;
 
 	case RTC_UIE_ON:
+		lock_kernel();
 		return set_uie(rtc);
+		unlock_kernel();
 #endif
 	default:
 		err = -ENOTTY;
@@ -426,7 +454,7 @@ static const struct file_operations rtc_dev_fops = {
 	.llseek		= no_llseek,
 	.read		= rtc_dev_read,
 	.poll		= rtc_dev_poll,
-	.ioctl		= rtc_dev_ioctl,
+	.unlocked_ioctl	= rtc_dev_ioctl,
 	.open		= rtc_dev_open,
 	.release	= rtc_dev_release,
 	.fasync		= rtc_dev_fasync,
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 316bfaa..81d8914 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -590,8 +590,7 @@ static ssize_t wdt_read(struct file *file, char __user *buf,
  *	according to their available features. We only actually usefully support
  *	querying capabilities and current status.
  */
-static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_margin, rv;
 	static struct watchdog_info ident = {
@@ -618,16 +617,22 @@ static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		/* Arbitrary, can't find the card's limits */
 		if (new_margin < 1 || new_margin > 124)
 			return -EINVAL;
+		lock_kernel();
 		wdt_margin = new_margin;
 		wdt_ping();
+		unlock_kernel();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
-		return put_user(wdt_margin, (int __user *)arg);
+		lock_kernel();
+		rv = wdt_margin;
+		unlock_kernel();
+		return put_user(rv, (int __user *)arg);
 
 	case WDIOC_SETOPTIONS:
 		if (copy_from_user(&rv, (int __user *)arg, sizeof(int)))
 			return -EFAULT;
 
+		lock_kernel();
 		if (rv & WDIOS_DISABLECARD) {
 			printk(KERN_INFO
 			       "rtc-m41t80: disable watchdog\n");
@@ -639,7 +644,7 @@ static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			       "rtc-m41t80: enable watchdog\n");
 			wdt_ping();
 		}
-
+		unlock_kernel();
 		return -EINVAL;
 	}
 	return -ENOTTY;
@@ -701,7 +706,7 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 static const struct file_operations wdt_fops = {
 	.owner	= THIS_MODULE,
 	.read	= wdt_read,
-	.ioctl	= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.write	= wdt_write,
 	.open	= wdt_open,
 	.release = wdt_release,
