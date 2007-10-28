Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbXJ1LMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbXJ1LMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 07:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXJ1LMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 07:12:42 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37939 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbXJ1LMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 07:12:41 -0400
Date: Sun, 28 Oct 2007 12:12:19 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gabriel C <nix.or.die@googlemail.com>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
Subject: Re: BUG: lock held when returning to user space
In-Reply-To: <20071027084646.434ccb4f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710281211170.18815@twin.jikos.cz>
References: <472348F6.6050100@googlemail.com> <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
 <1193498921.5648.68.camel@lappy> <20071027084646.434ccb4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(CC list stripped)

On Sat, 27 Oct 2007, Andrew Morton wrote:

> It's a fairly daft thing to do.  I think it'd be saner to teach rtc about
> test_and_set_bit() personally..


From: Jiri Kosina <jkosina@suse.cz>

RTC: convert mutex to bitfield

RTC code is using mutex to assure exclusive access to /dev/rtc.
This is however wrong usage, as it leaves the mutex locked when
returning into userspace, which is unacceptable.

Convert rtc->char_lock into bit operation.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index de0da54..a4f56e9 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -293,7 +293,7 @@ int rtc_irq_register(struct rtc_device *rtc, struct rtc_task *task)
 		return -EINVAL;
 
 	/* Cannot register while the char dev is in use */
-	if (!(mutex_trylock(&rtc->char_lock)))
+	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	spin_lock_irq(&rtc->irq_task_lock);
@@ -303,7 +303,7 @@ int rtc_irq_register(struct rtc_device *rtc, struct rtc_task *task)
 	}
 	spin_unlock_irq(&rtc->irq_task_lock);
 
-	mutex_unlock(&rtc->char_lock);
+	clear_bit(RTC_DEV_BUSY, &rtc->flags);
 
 	return retval;
 }
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 814583b..ae1bf17 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -26,10 +26,7 @@ static int rtc_dev_open(struct inode *inode, struct file *file)
 					struct rtc_device, char_dev);
 	const struct rtc_class_ops *ops = rtc->ops;
 
-	/* We keep the lock as long as the device is in use
-	 * and return immediately if busy
-	 */
-	if (!(mutex_trylock(&rtc->char_lock)))
+	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	file->private_data = rtc;
@@ -43,8 +40,8 @@ static int rtc_dev_open(struct inode *inode, struct file *file)
 		return 0;
 	}
 
-	/* something has gone wrong, release the lock */
-	mutex_unlock(&rtc->char_lock);
+	/* something has gone wrong */
+	clear_bit(RTC_DEV_BUSY, &rtc->flags);
 	return err;
 }
 
@@ -405,7 +402,7 @@ static int rtc_dev_release(struct inode *inode, struct file *file)
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
-	mutex_unlock(&rtc->char_lock);
+	clear_bit(RTC_DEV_BUSY, &rtc->flags);
 	return 0;
 }
 
@@ -440,7 +437,6 @@ void rtc_dev_prepare(struct rtc_device *rtc)
 
 	rtc->dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
 
-	mutex_init(&rtc->char_lock);
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	INIT_WORK(&rtc->uie_task, rtc_uie_task);
 	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6d5e4a4..f2d0d15 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -133,6 +133,9 @@ struct rtc_class_ops {
 #define RTC_DEVICE_NAME_SIZE 20
 struct rtc_task;
 
+/* flags */
+#define RTC_DEV_BUSY 0
+
 struct rtc_device
 {
 	struct device dev;
@@ -145,7 +148,7 @@ struct rtc_device
 	struct mutex ops_lock;
 
 	struct cdev char_dev;
-	struct mutex char_lock;
+	unsigned long flags;
 
 	unsigned long irq_data;
 	spinlock_t irq_lock;
