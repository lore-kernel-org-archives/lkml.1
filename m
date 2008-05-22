Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbYEVWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbYEVWLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbYEVWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:11:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43012 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757557AbYEVWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:11:37 -0400
Date: Thu, 22 May 2008 22:59:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] generic rtc and nvram: Push the BKL down
Message-ID: <20080522225900.469bf807@core>
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

Switch the ioctl handlers to unlocked_ioctl and push lock_kernel into the
driver instead.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index 2398e86..8886e51 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -20,7 +20,8 @@
 #include <linux/fcntl.h>
 #include <linux/init.h>
 #include <linux/smp_lock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
+#include <linux/smp_lock.h>
 #include <asm/nvram.h>
 #ifdef CONFIG_PPC_PMAC
 #include <asm/machdep.h>
@@ -85,25 +86,33 @@ static ssize_t write_nvram(struct file *file, const char __user *buf,
 	return p - buf;
 }
 
-static int nvram_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long nvram_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
+	int ret = 0;
 	switch(cmd) {
 #ifdef CONFIG_PPC_PMAC
 	case OBSOLETE_PMAC_NVRAM_GET_OFFSET:
+		/* FIXME: should be rate limited */
 		printk(KERN_WARNING "nvram: Using obsolete PMAC_NVRAM_GET_OFFSET ioctl\n");
 	case IOC_NVRAM_GET_OFFSET: {
 		int part, offset;
 
-		if (!machine_is(powermac))
-			return -EINVAL;
-		if (copy_from_user(&part, (void __user*)arg, sizeof(part)) != 0)
-			return -EFAULT;
-		if (part < pmac_nvram_OF || part > pmac_nvram_NR)
-			return -EINVAL;
+		if (!machine_is(powermac)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (copy_from_user(&part, (void __user*)arg, sizeof(part)) != 0) {
+			ret = -EFAULT;
+			break;
+		}
+		if (part < pmac_nvram_OF || part > pmac_nvram_NR) {
+			ret = -EINVAL;
+			break;
+		}
 		offset = pmac_get_partition(part);
 		if (copy_to_user((void __user*)arg, &offset, sizeof(offset)) != 0)
-			return -EFAULT;
+			ret = -EFAULT;
 		break;
 	}
 #endif /* CONFIG_PPC_PMAC */
@@ -111,10 +120,10 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 		nvram_sync();
 		break;
 	default:
-		return -EINVAL;
+		ret = -ENOTTY;
 	}
-
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 const struct file_operations nvram_fops = {
@@ -122,7 +131,7 @@ const struct file_operations nvram_fops = {
 	.llseek		= nvram_llseek,
 	.read		= read_nvram,
 	.write		= write_nvram,
-	.ioctl		= nvram_ioctl,
+	.unlocked_ioctl	= nvram_ioctl,
 };
 
 static struct miscdevice nvram_dev = {
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 69f0a29..503c9c5 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -52,8 +52,9 @@
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
 #include <linux/workqueue.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/rtc.h>
 
@@ -260,74 +261,89 @@ static inline int gen_set_rtc_irq_bit(unsigned char bit)
 #endif
 }
 
-static int gen_rtc_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long gen_rtc_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	struct rtc_time wtime;
 	struct rtc_pll_info pll;
 	void __user *argp = (void __user *)arg;
+	int ret = 0;
+
+	lock_kernel();
 
 	switch (cmd) {
 
 	case RTC_PLL_GET:
-	    if (get_rtc_pll(&pll))
-	 	    return -EINVAL;
-	    else
-		    return copy_to_user(argp, &pll, sizeof pll) ? -EFAULT : 0;
-
+		if (get_rtc_pll(&pll))
+			ret = -EINVAL;
+		else
+			ret = copy_to_user(argp, &pll, sizeof pll)
+							? -EFAULT : 0;
+		break;
 	case RTC_PLL_SET:
 		if (!capable(CAP_SYS_TIME))
-			return -EACCES;
-		if (copy_from_user(&pll, argp, sizeof(pll)))
-			return -EFAULT;
-	    return set_rtc_pll(&pll);
+			ret = -EACCES;
+		else if (copy_from_user(&pll, argp, sizeof(pll)))
+			ret = -EFAULT;
+		else
+			ret = set_rtc_pll(&pll);
+		break;
 
 	case RTC_UIE_OFF:	/* disable ints from RTC updates.	*/
 		gen_clear_rtc_irq_bit(RTC_UIE);
-		return 0;
+		break;
 
 	case RTC_UIE_ON:	/* enable ints for RTC updates.	*/
-	        return gen_set_rtc_irq_bit(RTC_UIE);
+	        ret = gen_set_rtc_irq_bit(RTC_UIE);
+		break;
 
 	case RTC_RD_TIME:	/* Read the time/date from RTC	*/
 		/* this doesn't get week-day, who cares */
 		memset(&wtime, 0, sizeof(wtime));
 		get_rtc_time(&wtime);
 
-		return copy_to_user(argp, &wtime, sizeof(wtime)) ? -EFAULT : 0;
-
+		ret = copy_to_user(argp, &wtime, sizeof(wtime))
+							? -EFAULT : 0;
+		break;
 	case RTC_SET_TIME:	/* Set the RTC */
-	    {
+	{
 		int year;
 		unsigned char leap_yr;
 
-		if (!capable(CAP_SYS_TIME))
-			return -EACCES;
-
-		if (copy_from_user(&wtime, argp, sizeof(wtime)))
-			return -EFAULT;
+		if (!capable(CAP_SYS_TIME)) {
+			ret = -EACCES;
+			break;
+		}
+		if (copy_from_user(&wtime, argp, sizeof(wtime))) {
+			ret = -EFAULT;
+			break;
+		}
 
 		year = wtime.tm_year + 1900;
 		leap_yr = ((!(year % 4) && (year % 100)) ||
 			   !(year % 400));
 
+		ret = -EINVAL;
 		if ((wtime.tm_mon < 0 || wtime.tm_mon > 11) || (wtime.tm_mday < 1))
-			return -EINVAL;
+			break;
 
 		if (wtime.tm_mday < 0 || wtime.tm_mday >
 		    (days_in_mo[wtime.tm_mon] + ((wtime.tm_mon == 1) && leap_yr)))
-			return -EINVAL;
+			break;
 
 		if (wtime.tm_hour < 0 || wtime.tm_hour >= 24 ||
 		    wtime.tm_min < 0 || wtime.tm_min >= 60 ||
 		    wtime.tm_sec < 0 || wtime.tm_sec >= 60)
-			return -EINVAL;
+			break;
 
-		return set_rtc_time(&wtime);
-	    }
+		ret = set_rtc_time(&wtime);
+		break;
 	}
-
-	return -EINVAL;
+	default:
+		ret = -ENOTTY;
+	}
+	unlock_kernel();
+	return ret;
 }
 
 /*
@@ -476,7 +492,7 @@ static const struct file_operations gen_rtc_fops = {
 	.read		= gen_rtc_read,
 	.poll		= gen_rtc_poll,
 #endif
-	.ioctl		= gen_rtc_ioctl,
+	.unlocked_ioctl	= gen_rtc_ioctl,
 	.open		= gen_rtc_open,
 	.release	= gen_rtc_release,
 };
