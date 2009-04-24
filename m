Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZDXQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZDXQ74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZDXQ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:59:42 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:65404 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbZDXQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:59:41 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled (v2)
Date: Sat, 25 Apr 2009 01:59:40 +0900
Message-Id: <1240592380-7498-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc_update_irq() might be called with irqs enabled, if a interrupt
handler was registered without IRQF_DISABLED.
Use spin_lock_irqsave/spin_unlock_irqrestore instead of
spin_lock/spin_unlock.

Also update kerneldoc and drivers which do extra work to follow the
current interface spec, as suggestted by David Brownell.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/interface.c  |   12 +++++++-----
 drivers/rtc/rtc-dev.c    |    6 ++----
 drivers/rtc/rtc-ds1305.c |    3 ---
 drivers/rtc/rtc-ds1307.c |    5 -----
 drivers/rtc/rtc-ds1374.c |    5 -----
 drivers/rtc/rtc-test.c   |    2 --
 6 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 4348c4b..4cdb31a 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -371,19 +371,21 @@ EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
  * @rtc: the rtc device
  * @num: how many irqs are being reported (usually one)
  * @events: mask of RTC_IRQF with one or more of RTC_PF, RTC_AF, RTC_UF
- * Context: in_interrupt(), irqs blocked
+ * Context: any
  */
 void rtc_update_irq(struct rtc_device *rtc,
 		unsigned long num, unsigned long events)
 {
-	spin_lock(&rtc->irq_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->irq_lock, flags);
 	rtc->irq_data = (rtc->irq_data + (num << 8)) | events;
-	spin_unlock(&rtc->irq_lock);
+	spin_unlock_irqrestore(&rtc->irq_lock, flags);
 
-	spin_lock(&rtc->irq_task_lock);
+	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task)
 		rtc->irq_task->func(rtc->irq_task->private_data);
-	spin_unlock(&rtc->irq_task_lock);
+	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	wake_up_interruptible(&rtc->irq_queue);
 	kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 45152f4..8a11de9 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -60,8 +60,7 @@ static void rtc_uie_task(struct work_struct *work)
 
 	err = rtc_read_time(rtc, &tm);
 
-	local_irq_disable();
-	spin_lock(&rtc->irq_lock);
+	spin_lock_irq(&rtc->irq_lock);
 	if (rtc->stop_uie_polling || err) {
 		rtc->uie_task_active = 0;
 	} else if (rtc->oldsecs != tm.tm_sec) {
@@ -74,10 +73,9 @@ static void rtc_uie_task(struct work_struct *work)
 	} else if (schedule_work(&rtc->uie_task) == 0) {
 		rtc->uie_task_active = 0;
 	}
-	spin_unlock(&rtc->irq_lock);
+	spin_unlock_irq(&rtc->irq_lock);
 	if (num)
 		rtc_update_irq(rtc, num, RTC_UF | RTC_IRQF);
-	local_irq_enable();
 }
 static void rtc_uie_timer(unsigned long data)
 {
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index fc372df..8f410e5 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -499,10 +499,7 @@ static void ds1305_work(struct work_struct *work)
 	if (!test_bit(FLAG_EXITING, &ds1305->flags))
 		enable_irq(spi->irq);
 
-	/* rtc_update_irq() requires an IRQ-disabled context */
-	local_irq_disable();
 	rtc_update_irq(ds1305->rtc, 1, RTC_AF | RTC_IRQF);
-	local_irq_enable();
 }
 
 /*
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 2c4a653..7b80195 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -258,12 +258,7 @@ static void ds1307_work(struct work_struct *work)
 		control &= ~DS1337_BIT_A1IE;
 		i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL, control);
 
-		/* rtc_update_irq() assumes that it is called
-		 * from IRQ-disabled context.
-		 */
-		local_irq_disable();
 		rtc_update_irq(ds1307->rtc, 1, RTC_AF | RTC_IRQF);
-		local_irq_enable();
 	}
 
 out:
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 4d32e32..32b2773 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -296,12 +296,7 @@ static void ds1374_work(struct work_struct *work)
 		control &= ~(DS1374_REG_CR_WACE | DS1374_REG_CR_AIE);
 		i2c_smbus_write_byte_data(client, DS1374_REG_CR, control);
 
-		/* rtc_update_irq() assumes that it is called
-		 * from IRQ-disabled context.
-		 */
-		local_irq_disable();
 		rtc_update_irq(ds1374->rtc, 1, RTC_AF | RTC_IRQF);
-		local_irq_enable();
 	}
 
 out:
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index e478280..51725f7 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -93,7 +93,6 @@ static ssize_t test_irq_store(struct device *dev,
 	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
 	retval = count;
-	local_irq_disable();
 	if (strncmp(buf, "tick", 4) == 0)
 		rtc_update_irq(rtc, 1, RTC_PF | RTC_IRQF);
 	else if (strncmp(buf, "alarm", 5) == 0)
@@ -102,7 +101,6 @@ static ssize_t test_irq_store(struct device *dev,
 		rtc_update_irq(rtc, 1, RTC_UF | RTC_IRQF);
 	else
 		retval = -EINVAL;
-	local_irq_enable();
 
 	return retval;
 }
-- 
1.5.6.3

