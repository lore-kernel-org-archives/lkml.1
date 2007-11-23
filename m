Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXKWKKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXKWKKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXKWKIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:08:45 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:14858 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXKWKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:08:41 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="44107061:sNHT35108801"
From: Bryan Wu <bryan.wu@analog.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 7/7] Blackfin RTC driver: convert sync wait to use the irq write complete notice
Date: Fri, 23 Nov 2007 18:08:32 +0800
Message-Id: <1195812512-25979-8-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

 - thus clearing out the need for spin locks
 - add a small optimization for reading of the rtc field

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/rtc/rtc-bfin.c |  249 ++++++++++++++++++++++++++----------------------
 1 files changed, 136 insertions(+), 113 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 69810a2..d90ba86 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -1,6 +1,6 @@
 /*
  * Blackfin On-Chip Real Time Clock Driver
- *  Supports BF53[123]/BF53[467]/BF54[2489]
+ *  Supports BF52[257]/BF53[123]/BF53[467]/BF54[24789]
  *
  * Copyright 2004-2007 Analog Devices Inc.
  *
@@ -32,16 +32,16 @@
  * writes to clear status registers complete immediately.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/bcd.h>
-#include <linux/rtc.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/rtc.h>
 #include <linux/seq_file.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/delay.h>
 
 #include <asm/blackfin.h>
 
@@ -50,7 +50,7 @@
 struct bfin_rtc {
 	struct rtc_device *rtc_dev;
 	struct rtc_time rtc_alarm;
-	spinlock_t lock;
+	u16 rtc_wrote_regs;
 };
 
 /* Bit values for the ISTAT / ICTL registers */
@@ -96,7 +96,10 @@ static inline void rtc_bfin_to_tm(u32 rtc_bfin, struct rtc_time *tm)
 	rtc_time_to_tm(rtc_bfin_to_time(rtc_bfin), tm);
 }
 
-/* Wait for the previous write to a RTC register to complete.
+/**
+ *	bfin_rtc_sync_pending - make sure pending writes have complete
+ *
+ * Wait for the previous write to a RTC register to complete.
  * Unfortunately, we can't sleep here as that introduces a race condition when
  * turning on interrupt events.  Consider this:
  *  - process sets alarm
@@ -117,64 +120,102 @@ static inline void rtc_bfin_to_tm(u32 rtc_bfin, struct rtc_time *tm)
  *    inc rate for all RTC registers from 1HZ to 32.768kHZ ...
  *  - use the write complete IRQ
  */
-static void rtc_bfin_sync_pending(void)
+/*
+static void bfin_rtc_sync_pending_polled(void)
 {
-	while (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_COMPLETE)) {
+	while (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_COMPLETE))
 		if (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING))
 			break;
-	}
 	bfin_write_RTC_ISTAT(RTC_ISTAT_WRITE_COMPLETE);
 }
+*/
+static DECLARE_COMPLETION(bfin_write_complete);
+static void bfin_rtc_sync_pending(struct device *dev)
+{
+	dev_dbg_stamp(dev);
+	while (bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING)
+		wait_for_completion_timeout(&bfin_write_complete, HZ * 5);
+	dev_dbg_stamp(dev);
+}
 
-static void rtc_bfin_reset(struct device *dev)
+/**
+ *	bfin_rtc_reset - set RTC to sane/known state
+ *
+ * Initialize the RTC.  Enable pre-scaler to scale RTC clock
+ * to 1Hz and clear interrupt/status registers.
+ */
+static void bfin_rtc_reset(struct device *dev)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	/* Initialize the RTC. Enable pre-scaler to scale RTC clock
-	 * to 1Hz and clear interrupt/status registers. */
-	spin_lock_irq(&rtc->lock);
-	rtc_bfin_sync_pending();
+	dev_dbg_stamp(dev);
+	bfin_rtc_sync_pending(dev);
 	bfin_write_RTC_PREN(0x1);
-	bfin_write_RTC_ICTL(0);
+	bfin_write_RTC_ICTL(RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 	bfin_write_RTC_ALARM(0);
 	bfin_write_RTC_ISTAT(0xFFFF);
-	spin_unlock_irq(&rtc->lock);
+	rtc->rtc_wrote_regs = 0;
 }
 
+/**
+ *	bfin_rtc_interrupt - handle interrupt from RTC
+ *
+ * Since we handle all RTC events here, we have to make sure the requested
+ * interrupt is enabled (in RTC_ICTL) as the event status register (RTC_ISTAT)
+ * always gets updated regardless of the interrupt being enabled.  So when one
+ * even we care about (e.g. stopwatch) goes off, we don't want to turn around
+ * and say that other events have happened as well (e.g. second).  We do not
+ * have to worry about pending writes to the RTC_ICTL register as interrupts
+ * only fire if they are enabled in the RTC_ICTL register.
+ */
 static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 {
 	struct device *dev = dev_id;
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	unsigned long events = 0;
-	u16 rtc_istat;
+	bool write_complete = false;
+	u16 rtc_istat, rtc_ictl;
 
 	dev_dbg_stamp(dev);
 
-	spin_lock_irq(&rtc->lock);
-
 	rtc_istat = bfin_read_RTC_ISTAT();
+	rtc_ictl = bfin_read_RTC_ICTL();
 
-	if (rtc_istat & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY)) {
-		bfin_write_RTC_ISTAT(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY);
-		events |= RTC_AF | RTC_IRQF;
+	if (rtc_istat & RTC_ISTAT_WRITE_COMPLETE) {
+		bfin_write_RTC_ISTAT(RTC_ISTAT_WRITE_COMPLETE);
+		write_complete = true;
+		complete(&bfin_write_complete);
 	}
 
-	if (rtc_istat & RTC_ISTAT_STOPWATCH) {
-		bfin_write_RTC_ISTAT(RTC_ISTAT_STOPWATCH);
-		events |= RTC_PF | RTC_IRQF;
-		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
+	if (rtc_ictl & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY)) {
+		if (rtc_istat & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY)) {
+			bfin_write_RTC_ISTAT(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY);
+			events |= RTC_AF | RTC_IRQF;
+		}
 	}
 
-	if (rtc_istat & RTC_ISTAT_SEC) {
-		bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
-		events |= RTC_UF | RTC_IRQF;
+	if (rtc_ictl & RTC_ISTAT_STOPWATCH) {
+		if (rtc_istat & RTC_ISTAT_STOPWATCH) {
+			bfin_write_RTC_ISTAT(RTC_ISTAT_STOPWATCH);
+			events |= RTC_PF | RTC_IRQF;
+			bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
+		}
 	}
 
-	rtc_update_irq(rtc->rtc_dev, 1, events);
+	if (rtc_ictl & RTC_ISTAT_SEC) {
+		if (rtc_istat & RTC_ISTAT_SEC) {
+			bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
+			events |= RTC_UF | RTC_IRQF;
+		}
+	}
 
-	spin_unlock_irq(&rtc->lock);
+	if (events)
+		rtc_update_irq(rtc->rtc_dev, 1, events);
 
-	return IRQ_HANDLED;
+	if (write_complete || events)
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
 }
 
 static int bfin_rtc_open(struct device *dev)
@@ -183,13 +224,9 @@ static int bfin_rtc_open(struct device *dev)
 
 	dev_dbg_stamp(dev);
 
-	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_DISABLED, "rtc-bfin", dev);
-	if (unlikely(ret)) {
-		dev_err(dev, "request RTC IRQ failed with %d\n", ret);
-		return ret;
-	}
-
-	rtc_bfin_reset(dev);
+	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, to_platform_device(dev)->name, dev);
+	if (!ret)
+		bfin_rtc_reset(dev);
 
 	return ret;
 }
@@ -197,93 +234,70 @@ static int bfin_rtc_open(struct device *dev)
 static void bfin_rtc_release(struct device *dev)
 {
 	dev_dbg_stamp(dev);
-	rtc_bfin_reset(dev);
+	bfin_rtc_reset(dev);
 	free_irq(IRQ_RTC, dev);
 }
 
+static void bfin_rtc_int_set(struct bfin_rtc *rtc, u16 rtc_int)
+{
+	bfin_write_RTC_ISTAT(rtc_int);
+	bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() | rtc_int);
+}
+static void bfin_rtc_int_clear(struct bfin_rtc *rtc, u16 rtc_int)
+{
+	bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & rtc_int);
+}
+static void bfin_rtc_int_set_alarm(struct bfin_rtc *rtc)
+{
+	/* Blackfin has different bits for whether the alarm is
+	 * more than 24 hours away.
+	 */
+	bfin_rtc_int_set(rtc, (rtc->rtc_alarm.tm_yday == -1 ? RTC_ISTAT_ALARM : RTC_ISTAT_ALARM_DAY));
+}
 static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
+	int ret = 0;
 
 	dev_dbg_stamp(dev);
 
+	bfin_rtc_sync_pending(dev);
+
 	switch (cmd) {
 	case RTC_PIE_ON:
 		dev_dbg_stamp(dev);
-		spin_lock_irq(&rtc->lock);
-		rtc_bfin_sync_pending();
-		bfin_write_RTC_ISTAT(RTC_ISTAT_STOPWATCH);
+		bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
 		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
-		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() | RTC_ISTAT_STOPWATCH);
-		spin_unlock_irq(&rtc->lock);
-		return 0;
+		break;
 	case RTC_PIE_OFF:
 		dev_dbg_stamp(dev);
-		spin_lock_irq(&rtc->lock);
-		rtc_bfin_sync_pending();
-		bfin_write_RTC_SWCNT(0);
-		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & ~RTC_ISTAT_STOPWATCH);
-		spin_unlock_irq(&rtc->lock);
-		return 0;
+		bfin_rtc_int_clear(rtc, ~RTC_ISTAT_STOPWATCH);
+		break;
 
 	case RTC_UIE_ON:
 		dev_dbg_stamp(dev);
-		spin_lock_irq(&rtc->lock);
-		rtc_bfin_sync_pending();
-		bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
-		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() | RTC_ISTAT_SEC);
-		spin_unlock_irq(&rtc->lock);
-		return 0;
+		bfin_rtc_int_set(rtc, RTC_ISTAT_SEC);
+		break;
 	case RTC_UIE_OFF:
 		dev_dbg_stamp(dev);
-		spin_lock_irq(&rtc->lock);
-		rtc_bfin_sync_pending();
-		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & ~RTC_ISTAT_SEC);
-		spin_unlock_irq(&rtc->lock);
-		return 0;
-
-	case RTC_AIE_ON: {
-		unsigned long rtc_alarm;
-		u16 which_alarm;
-		int ret = 0;
+		bfin_rtc_int_clear(rtc, ~RTC_ISTAT_SEC);
+		break;
 
+	case RTC_AIE_ON:
 		dev_dbg_stamp(dev);
-
-		spin_lock_irq(&rtc->lock);
-
-		rtc_bfin_sync_pending();
-		if (rtc->rtc_alarm.tm_yday == -1) {
-			struct rtc_time now;
-			rtc_bfin_to_tm(bfin_read_RTC_STAT(), &now);
-			now.tm_sec = rtc->rtc_alarm.tm_sec;
-			now.tm_min = rtc->rtc_alarm.tm_min;
-			now.tm_hour = rtc->rtc_alarm.tm_hour;
-			ret = rtc_tm_to_time(&now, &rtc_alarm);
-			which_alarm = RTC_ISTAT_ALARM;
-		} else {
-			ret = rtc_tm_to_time(&rtc->rtc_alarm, &rtc_alarm);
-			which_alarm = RTC_ISTAT_ALARM_DAY;
-		}
-		if (ret == 0) {
-			bfin_write_RTC_ISTAT(which_alarm);
-			bfin_write_RTC_ALARM(rtc_time_to_bfin(rtc_alarm));
-			bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() | which_alarm);
-		}
-
-		spin_unlock_irq(&rtc->lock);
-
-		return ret;
-	}
+		bfin_rtc_int_set_alarm(rtc);
+		break;
 	case RTC_AIE_OFF:
 		dev_dbg_stamp(dev);
-		spin_lock_irq(&rtc->lock);
-		rtc_bfin_sync_pending();
-		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & ~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
-		spin_unlock_irq(&rtc->lock);
-		return 0;
+		bfin_rtc_int_clear(rtc, ~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+		break;
+
+	default:
+		dev_dbg_stamp(dev);
+		ret = -ENOIOCTLCMD;
 	}
 
-	return -ENOIOCTLCMD;
+	return ret;
 }
 
 static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
@@ -292,10 +306,10 @@ static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	dev_dbg_stamp(dev);
 
-	spin_lock_irq(&rtc->lock);
-	rtc_bfin_sync_pending();
+	if (rtc->rtc_wrote_regs & 0x1)
+		bfin_rtc_sync_pending(dev);
+
 	rtc_bfin_to_tm(bfin_read_RTC_STAT(), tm);
-	spin_unlock_irq(&rtc->lock);
 
 	return 0;
 }
@@ -308,16 +322,14 @@ static int bfin_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	dev_dbg_stamp(dev);
 
-	spin_lock_irq(&rtc->lock);
-
 	ret = rtc_tm_to_time(tm, &now);
 	if (ret == 0) {
-		rtc_bfin_sync_pending();
+		if (rtc->rtc_wrote_regs & 0x1)
+			bfin_rtc_sync_pending(dev);
 		bfin_write_RTC_STAT(rtc_time_to_bfin(now));
+		rtc->rtc_wrote_regs = 0x1;
 	}
 
-	spin_unlock_irq(&rtc->lock);
-
 	return ret;
 }
 
@@ -326,6 +338,7 @@ static int bfin_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
 	alrm->time = rtc->rtc_alarm;
+	bfin_rtc_sync_pending(dev);
 	alrm->enabled = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 	return 0;
 }
@@ -333,8 +346,20 @@ static int bfin_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int bfin_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long rtc_alarm;
+
 	dev_dbg_stamp(dev);
+
+	if (rtc_tm_to_time(&alrm->time, &rtc_alarm))
+		return -EINVAL;
+
 	rtc->rtc_alarm = alrm->time;
+
+	bfin_rtc_sync_pending(dev);
+	bfin_write_RTC_ALARM(rtc_time_to_bfin(rtc_alarm));
+	if (alrm->enabled)
+		bfin_rtc_int_set_alarm(rtc);
+
 	return 0;
 }
 
@@ -393,8 +418,6 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 	if (unlikely(!rtc))
 		return -ENOMEM;
 
-	spin_lock_init(&rtc->lock);
-
 	rtc->rtc_dev = rtc_device_register(pdev->name, &pdev->dev, &bfin_rtc_ops, THIS_MODULE);
 	if (unlikely(IS_ERR(rtc))) {
 		ret = PTR_ERR(rtc->rtc_dev);
-- 
1.5.3.4
