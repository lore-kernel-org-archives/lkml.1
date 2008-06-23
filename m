Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYFWC4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYFWC4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYFWCzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:55:51 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30169 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752827AbYFWCzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:55:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ZQ/2XsKVrAmLzu/su/TbnKJGSziHkJl25xRDnrI64LFUptx4/4bi2OugV16kwTZbKAqm+O/WWZtN7+o7gqHhIWHrCYuhRicD2P3QEg67WeoGnQne2ZarrI4234le5d4+PLkThqQ+G6Danr6zOqutEdWO3pUE63gbvaSfTLlDxyY=  ;
X-YMail-OSG: PYkiW3oVM1mvffQ3BK.CzV4p.W11ag7nPfDpYCDLeoGbX2jdH2_rvbshAiGMECTl7LuLYKZPRoOPq0yiTeSPfnwO.WWOpZ7eqP8ArJlE1ff69Y2U_Cex4tScCtfLhO1ftxi2Sv11qWgZeMNIZK0xlwpq
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: remove BKL for ioctl()
Date: Sun, 22 Jun 2008 19:55:42 -0700
User-Agent: KMail/1.9.9
Cc: rtc-linux@googlegroups.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806221955.42597.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove implicit use of BKL in ioctl() from the RTC framework.

Instead, the rtc->ops_lock is used.  That's the same lock that already
protects the RTC operations when they're issued through the exported
rtc_*() calls in drivers/rtc/interface.c ... making this a bugfix, not
just a cleanup, since both ioctl calls and set_alarm() need to update
IRQ enable flags and that implies a common lock (which RTC drivers as
a rule do not provide on their own).

A new comment at the declaration of "struct rtc_class_ops" summarizes
current locking rules.  It's not clear to me that the exceptions listed
there should exist ... if not, those are pre-existing problems which can
be fixed in a patch that doesn't relate to BKL removal.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
presumably better than the quickie from Alan Cox
http://marc.info/?l=linux-kernel&m=121149082228913&w=2

 drivers/rtc/rtc-dev.c |   58 ++++++++++++++++++++++++++++++++------------------
 include/linux/rtc.h   |   17 ++++++++++++++
 2 files changed, 55 insertions(+), 20 deletions(-)

--- a/drivers/rtc/rtc-dev.c	2008-06-21 20:56:14.000000000 -0700
+++ b/drivers/rtc/rtc-dev.c	2008-06-21 21:46:14.000000000 -0700
@@ -203,7 +203,7 @@ static unsigned int rtc_dev_poll(struct 
 	return (data != 0) ? (POLLIN | POLLRDNORM) : 0;
 }
 
-static int rtc_dev_ioctl(struct inode *inode, struct file *file,
+static long rtc_dev_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
@@ -213,6 +213,10 @@ static int rtc_dev_ioctl(struct inode *i
 	struct rtc_wkalrm alarm;
 	void __user *uarg = (void __user *) arg;
 
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return -EBUSY;
+
 	/* check that the calling task has appropriate permissions
 	 * for certain ioctls. doing this check here is useful
 	 * to avoid duplicate code in each driver.
@@ -221,26 +225,31 @@ static int rtc_dev_ioctl(struct inode *i
 	case RTC_EPOCH_SET:
 	case RTC_SET_TIME:
 		if (!capable(CAP_SYS_TIME))
-			return -EACCES;
+			err = -EACCES;
 		break;
 
 	case RTC_IRQP_SET:
 		if (arg > rtc->max_user_freq && !capable(CAP_SYS_RESOURCE))
-			return -EACCES;
+			err = -EACCES;
 		break;
 
 	case RTC_PIE_ON:
 		if (rtc->irq_freq > rtc->max_user_freq &&
 				!capable(CAP_SYS_RESOURCE))
-			return -EACCES;
+			err = -EACCES;
 		break;
 	}
 
+	if (err)
+		goto done;
+
 	/* try the driver's ioctl interface */
 	if (ops->ioctl) {
 		err = ops->ioctl(rtc->dev.parent, cmd, arg);
-		if (err != -ENOIOCTLCMD)
+		if (err != -ENOIOCTLCMD) {
+			mutex_unlock(&rtc->ops_lock);
 			return err;
+		}
 	}
 
 	/* if the driver does not provide the ioctl interface
@@ -259,15 +268,19 @@ static int rtc_dev_ioctl(struct inode *i
 
 	switch (cmd) {
 	case RTC_ALM_READ:
+		mutex_unlock(&rtc->ops_lock);
+
 		err = rtc_read_alarm(rtc, &alarm);
 		if (err < 0)
 			return err;
 
 		if (copy_to_user(uarg, &alarm.time, sizeof(tm)))
-			return -EFAULT;
-		break;
+			err = -EFAULT;
+		return err;
 
 	case RTC_ALM_SET:
+		mutex_unlock(&rtc->ops_lock);
+
 		if (copy_from_user(&alarm.time, uarg, sizeof(tm)))
 			return -EFAULT;
 
@@ -315,24 +328,26 @@ static int rtc_dev_ioctl(struct inode *i
 			}
 		}
 
-		err = rtc_set_alarm(rtc, &alarm);
-		break;
+		return rtc_set_alarm(rtc, &alarm);
 
 	case RTC_RD_TIME:
+		mutex_unlock(&rtc->ops_lock);
+
 		err = rtc_read_time(rtc, &tm);
 		if (err < 0)
 			return err;
 
 		if (copy_to_user(uarg, &tm, sizeof(tm)))
-			return -EFAULT;
-		break;
+			err = -EFAULT;
+		return err;
 
 	case RTC_SET_TIME:
+		mutex_unlock(&rtc->ops_lock);
+
 		if (copy_from_user(&tm, uarg, sizeof(tm)))
 			return -EFAULT;
 
-		err = rtc_set_time(rtc, &tm);
-		break;
+		return rtc_set_time(rtc, &tm);
 
 	case RTC_PIE_ON:
 		err = rtc_irq_set_state(rtc, NULL, 1);
@@ -370,34 +385,37 @@ static int rtc_dev_ioctl(struct inode *i
 		break;
 #endif
 	case RTC_WKALM_SET:
+		mutex_unlock(&rtc->ops_lock);
 		if (copy_from_user(&alarm, uarg, sizeof(alarm)))
 			return -EFAULT;
 
-		err = rtc_set_alarm(rtc, &alarm);
-		break;
+		return rtc_set_alarm(rtc, &alarm);
 
 	case RTC_WKALM_RD:
+		mutex_unlock(&rtc->ops_lock);
 		err = rtc_read_alarm(rtc, &alarm);
 		if (err < 0)
 			return err;
 
 		if (copy_to_user(uarg, &alarm, sizeof(alarm)))
-			return -EFAULT;
-		break;
+			err = -EFAULT;
+		return err;
 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	case RTC_UIE_OFF:
 		clear_uie(rtc);
-		return 0;
+		break;
 
 	case RTC_UIE_ON:
-		return set_uie(rtc);
+		err = set_uie(rtc);
 #endif
 	default:
 		err = -ENOTTY;
 		break;
 	}
 
+done:
+	mutex_unlock(&rtc->ops_lock);
 	return err;
 }
 
@@ -426,7 +444,7 @@ static const struct file_operations rtc_
 	.llseek		= no_llseek,
 	.read		= rtc_dev_read,
 	.poll		= rtc_dev_poll,
-	.ioctl		= rtc_dev_ioctl,
+	.unlocked_ioctl	= rtc_dev_ioctl,
 	.open		= rtc_dev_open,
 	.release	= rtc_dev_release,
 	.fasync		= rtc_dev_fasync,
--- a/include/linux/rtc.h	2008-06-21 21:15:30.000000000 -0700
+++ b/include/linux/rtc.h	2008-06-21 21:42:59.000000000 -0700
@@ -115,6 +115,23 @@ extern void rtc_time_to_tm(unsigned long
 
 extern struct class *rtc_class;
 
+/*
+ * For these RTC methods the device parameter is the physical device
+ * on whatever bus holds the hardware (I2C, Platform, SPI, etc), which
+ * was passed to rtc_device_register().  Its driver_data normally holds
+ * device state, including the rtc_device pointer for the RTC.
+ *
+ * Most of these methods are called with rtc_device.ops_lock held,
+ * through the rtc_*(struct rtc_device *, ...) calls.
+ *
+ * The (current) exceptions are mostly filesystem hooks:
+ *   - the proc() hook for procfs
+ *   - non-ioctl() chardev hooks:  open(), release(), read_callback()
+ *   - periodic irq calls:  irq_set_state(), irq_set_freq()
+ *
+ * REVISIT those periodic irq calls *do* have ops_lock when they're
+ * issued through ioctl() ...
+ */
 struct rtc_class_ops {
 	int (*open)(struct device *);
 	void (*release)(struct device *);
