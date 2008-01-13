Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYAMUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYAMUcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYAMUcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:32:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:54055 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYAMUco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:32:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=t57czlwvYT7ZVsCvR+r39AOZTQGgfbyvAa5uBF3I+V1AFB9f8THC0ZCe6QU8lAVlbM65GTa8b1kBU105ZiGDqs96unuaK2RwPj4mteZ5yIqgN/kCUK3SStu6coYfcb0QxHUI0mzVGR5Z1jtgo9UajPQwK4TXUV0IcfkOzwPofc8=
Date: Sun, 13 Jan 2008 23:32:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Message-ID: <20080113203223.GA6723@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ioctl call to unlocked_ioctl form with
explicit big-kernel-lock. Also it makes a bit of cleanup
converting miscdevice structure initialization to C99 form.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Any comments are welcome.
This is untested code - i've no such chip on my laptop.

Andi, i think we could use mutex to eliminate BKL, but not sure.


 drivers/char/ip27-rtc.c |   86 ++++++++++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/drivers/char/ip27-rtc.c b/drivers/char/ip27-rtc.c
index 932264a..1d83e16 100644
--- a/drivers/char/ip27-rtc.c
+++ b/drivers/char/ip27-rtc.c
@@ -46,8 +46,8 @@
 #include <asm/sn/sn0/hub.h>
 #include <asm/sn/sn_private.h>
 
-static int rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long rtc_ioctl(struct file *file, unsigned int cmd,
+		      unsigned long arg);
 
 static int rtc_read_proc(char *page, char **start, off_t off,
                          int count, int *eof, void *data);
@@ -62,7 +62,7 @@ static void get_rtc_time(struct rtc_time *rtc_tm);
 #define RTC_TIMER_ON		0x02	/* missed irq timer active	*/
 
 static unsigned char rtc_status;	/* bitmapped status byte.	*/
-static unsigned long rtc_freq;	/* Current periodic IRQ rate	*/
+static unsigned long rtc_freq;		/* Current periodic IRQ rate	*/
 static struct m48t35_rtc *rtc;
 
 /*
@@ -75,30 +75,34 @@ static unsigned long epoch = 1970;	/* year corresponding to 0x00	*/
 static const unsigned char days_in_mo[] =
 {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-
 	struct rtc_time wtime;
+	int err;
+
+	lock_kernel();
 
 	switch (cmd) {
 	case RTC_RD_TIME:	/* Read the time/date from RTC	*/
-	{
 		get_rtc_time(&wtime);
+		err = copy_to_user((void *)arg, &wtime, sizeof wtime) ? -EFAULT : 0;
 		break;
-	}
 	case RTC_SET_TIME:	/* Set the RTC */
 	{
 		struct rtc_time rtc_tm;
 		unsigned char mon, day, hrs, min, sec, leap_yr;
 		unsigned int yrs;
 
-		if (!capable(CAP_SYS_TIME))
-			return -EACCES;
+		if (!capable(CAP_SYS_TIME)) {
+			err = -EACCES;
+			goto unlock;
+		}
 
 		if (copy_from_user(&rtc_tm, (struct rtc_time*)arg,
-				   sizeof(struct rtc_time)))
-			return -EFAULT;
+				   sizeof(struct rtc_time))) {
+			err = -EFAULT;
+			goto unlock;
+		}
 
 		yrs = rtc_tm.tm_year + 1900;
 		mon = rtc_tm.tm_mon + 1;   /* tm_mon starts at zero */
@@ -107,25 +111,27 @@ static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		min = rtc_tm.tm_min;
 		sec = rtc_tm.tm_sec;
 
+		err = -EINVAL;
+
 		if (yrs < 1970)
-			return -EINVAL;
+			goto unlock;
 
 		leap_yr = ((!(yrs % 4) && (yrs % 100)) || !(yrs % 400));
 
 		if ((mon > 12) || (day == 0))
-			return -EINVAL;
+			goto unlock;
 
 		if (day > (days_in_mo[mon] + ((mon == 2) && leap_yr)))
-			return -EINVAL;
+			goto unlock;
 
 		if ((hrs >= 24) || (min >= 60) || (sec >= 60))
-			return -EINVAL;
+			goto unlock;
 
 		if ((yrs -= epoch) > 255)    /* They are unsigned */
-			return -EINVAL;
+			goto unlock;
 
 		if (yrs > 169)
-			return -EINVAL;
+			goto unlock;
 
 		if (yrs >= 100)
 			yrs -= 100;
@@ -148,12 +154,18 @@ static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		rtc->control &= ~M48T35_RTC_SET;
 		spin_unlock_irq(&rtc_lock);
 
-		return 0;
+		err = 0;
+		break;
 	}
 	default:
-		return -EINVAL;
+		err = -EINVAL;
+		break;
 	}
-	return copy_to_user((void *)arg, &wtime, sizeof wtime) ? -EFAULT : 0;
+
+ unlock:
+	unlock_kernel();
+
+	return err;
 }
 
 /*
@@ -170,8 +182,8 @@ static int rtc_open(struct inode *inode, struct file *file)
 		spin_unlock_irq(&rtc_lock);
 		return -EBUSY;
 	}
-
 	rtc_status |= RTC_IS_OPEN;
+
 	spin_unlock_irq(&rtc_lock);
 
 	return 0;
@@ -197,16 +209,15 @@ static int rtc_release(struct inode *inode, struct file *file)
 
 static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
 };
 
-static struct miscdevice rtc_dev=
-{
-	RTC_MINOR,
-	"rtc",
-	&rtc_fops
+static struct miscdevice rtc_dev = {
+	.minor		= RTC_MINOR,
+	.name		= "rtc",
+	.fops		= &rtc_fops,
 };
 
 static int __init rtc_init(void)
@@ -229,16 +240,15 @@ static int __init rtc_init(void)
 
 	return 0;
 }
+module_init(rtc_init);
 
-static void __exit rtc_exit (void)
+static void __exit rtc_exit(void)
 {
 	/* interrupts and timer disabled at this point by rtc_release */
 
 	remove_proc_entry ("rtc", NULL);
 	misc_deregister(&rtc_dev);
 }
-
-module_init(rtc_init);
 module_exit(rtc_exit);
 
 /*
@@ -274,14 +284,20 @@ static int rtc_get_status(char *buf)
 }
 
 static int rtc_read_proc(char *page, char **start, off_t off,
-                                 int count, int *eof, void *data)
+			 int count, int *eof, void *data)
 {
         int len = rtc_get_status(page);
-        if (len <= off+count) *eof = 1;
+
+        if (len <= off + count)
+		*eof = 1;
+
         *start = page + off;
         len -= off;
-        if (len>count) len = count;
-        if (len<0) len = 0;
+        if (len > count)
+		len = count;
+        if (len < 0)
+		len = 0;
+
         return len;
 }
 
