Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbYG0Gjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbYG0Gjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbYG0GjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:39:05 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503AbYG0GjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=G0aXvq7I0iJy1fQdFqII+c951ozhBVN/nCx1hvhdQeQypyhg6XPb4ibsQoTr8kFmVz
         hAQQ+FM4pUb+JJut3yZvsSfxGEzW3GfAV70hfElHsLW/4V5a0RG8TiLTKSwkl1B0Lwrj
         bcU/sQg9unfUrwk9Mryn2O78acEndaIhWSSBM=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <bryan.wu@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/8] [Blackfin] RTC driver: dont bother passing the rtc struct down to bfin_rtc_int_{set,clear} since it isnt needed (shaves off ~100bytes)
Date: Sun, 27 Jul 2008 14:38:23 +0800
Message-Id: <1217140707-21263-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
References: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 23b991d..56656dd 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -238,12 +238,12 @@ static void bfin_rtc_release(struct device *dev)
 	free_irq(IRQ_RTC, dev);
 }
 
-static void bfin_rtc_int_set(struct bfin_rtc *rtc, u16 rtc_int)
+static void bfin_rtc_int_set(u16 rtc_int)
 {
 	bfin_write_RTC_ISTAT(rtc_int);
 	bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() | rtc_int);
 }
-static void bfin_rtc_int_clear(struct bfin_rtc *rtc, u16 rtc_int)
+static void bfin_rtc_int_clear(u16 rtc_int)
 {
 	bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & rtc_int);
 }
@@ -252,7 +252,7 @@ static void bfin_rtc_int_set_alarm(struct bfin_rtc *rtc)
 	/* Blackfin has different bits for whether the alarm is
 	 * more than 24 hours away.
 	 */
-	bfin_rtc_int_set(rtc, (rtc->rtc_alarm.tm_yday == -1 ? RTC_ISTAT_ALARM : RTC_ISTAT_ALARM_DAY));
+	bfin_rtc_int_set(rtc->rtc_alarm.tm_yday == -1 ? RTC_ISTAT_ALARM : RTC_ISTAT_ALARM_DAY);
 }
 static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
@@ -266,21 +266,21 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 	switch (cmd) {
 	case RTC_PIE_ON:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
+		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
 		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
 		break;
 	case RTC_PIE_OFF:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(rtc, ~RTC_ISTAT_STOPWATCH);
+		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
 		break;
 
 	case RTC_UIE_ON:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_set(rtc, RTC_ISTAT_SEC);
+		bfin_rtc_int_set(RTC_ISTAT_SEC);
 		break;
 	case RTC_UIE_OFF:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(rtc, ~RTC_ISTAT_SEC);
+		bfin_rtc_int_clear(~RTC_ISTAT_SEC);
 		break;
 
 	case RTC_AIE_ON:
@@ -289,7 +289,7 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 		break;
 	case RTC_AIE_OFF:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(rtc, ~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 		break;
 
 	default:
@@ -435,12 +435,10 @@ static int __devexit bfin_rtc_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
-
 	if (device_may_wakeup(&pdev->dev))
 		enable_irq_wake(IRQ_RTC);
 	else
-		bfin_rtc_int_clear(rtc, -1);
+		bfin_rtc_int_clear(-1);
 
 	return 0;
 }
-- 
1.5.6

