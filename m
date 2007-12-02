Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXLBWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXLBWAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXLBWAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:00:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:58331 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbXLBWAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:00:06 -0500
Date: Sun, 2 Dec 2007 23:00:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       Nickk Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] RTC: assure proper memory ordering with respect to
 RTC_DEV_BUSY flag (was Re: RTC: convert mutex to bitfield)
In-Reply-To: <Pine.LNX.4.64.0711300944020.12807@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0712022258120.13260@jikos.suse.cz>
References: <200711301355.03139.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0711300944020.12807@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ nobody seems to have picked this up, resending. This is a fix for 
  commit 8853c202b4 in Linus' tree ]

From: Jiri Kosina <jkosina@suse.cz>

RTC: assure proper memory ordering with respect to RTC_DEV_BUSY flag

We must make sure that the RTC_DEV_BUSY flag has proper lock semantics, 
i.e. that the RTC_DEV_BUSY stores clearing the flag don't get reordered 
before the preceeding stores and loads and vice versa.

Spotted by Nick Piggin.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index a4f56e9..f1e00ff 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -293,7 +293,7 @@ int rtc_irq_register(struct rtc_device *rtc, struct rtc_task *task)
 		return -EINVAL;
 
 	/* Cannot register while the char dev is in use */
-	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
+	if (test_and_set_bit_lock(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	spin_lock_irq(&rtc->irq_task_lock);
@@ -303,7 +303,7 @@ int rtc_irq_register(struct rtc_device *rtc, struct rtc_task *task)
 	}
 	spin_unlock_irq(&rtc->irq_task_lock);
 
-	clear_bit(RTC_DEV_BUSY, &rtc->flags);
+	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 
 	return retval;
 }
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index ae1bf17..025c60a 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -26,7 +26,7 @@ static int rtc_dev_open(struct inode *inode, struct file *file)
 					struct rtc_device, char_dev);
 	const struct rtc_class_ops *ops = rtc->ops;
 
-	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
+	if (test_and_set_bit_lock(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	file->private_data = rtc;
@@ -41,7 +41,7 @@ static int rtc_dev_open(struct inode *inode, struct file *file)
 	}
 
 	/* something has gone wrong */
-	clear_bit(RTC_DEV_BUSY, &rtc->flags);
+	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 	return err;
 }
 
@@ -402,7 +402,7 @@ static int rtc_dev_release(struct inode *inode, struct file *file)
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
-	clear_bit(RTC_DEV_BUSY, &rtc->flags);
+	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 	return 0;
 }
 

