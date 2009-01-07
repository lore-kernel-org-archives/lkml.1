Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZAGNOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZAGNOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZAGNOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:14:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50024 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752317AbZAGNOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:14:31 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] rtc: Convert wm8350 use new alarm and update operations
Date: Wed,  7 Jan 2009 13:14:29 +0000
Message-Id: <1231334069-12072-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the only two ioctls so the ioctl() function is also removed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/rtc/rtc-wm8350.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 5c5e3aa..616630d 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -236,6 +236,17 @@ static int wm8350_rtc_start_alarm(struct wm8350 *wm8350)
 	return 0;
 }
 
+static int wm8350_rtc_alarm_irq_enable(struct device *dev,
+				       unsigned int enabled)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(dev);
+
+	if (enabled)
+		return wm8350_rtc_start_alarm(wm8350);
+	else
+		return wm8350_rtc_stop_alarm(wm8350);
+}
+
 static int wm8350_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct wm8350 *wm8350 = dev_get_drvdata(dev);
@@ -291,30 +302,15 @@ static int wm8350_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return ret;
 }
 
-/*
- * Handle commands from user-space
- */
-static int wm8350_rtc_ioctl(struct device *dev, unsigned int cmd,
-			    unsigned long arg)
+static int wm8350_rtc_update_irq_enable(struct device *dev,
+					unsigned int enabled)
 {
 	struct wm8350 *wm8350 = dev_get_drvdata(dev);
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		return wm8350_rtc_stop_alarm(wm8350);
-	case RTC_AIE_ON:
-		return wm8350_rtc_start_alarm(wm8350);
-
-	case RTC_UIE_OFF:
-		wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-		break;
-	case RTC_UIE_ON:
+	if (enabled)
 		wm8350_unmask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-		break;
-
-	default:
-		return -ENOIOCTLCMD;
-	}
+	else
+		wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 
 	return 0;
 }
@@ -345,11 +341,12 @@ static void wm8350_rtc_update_handler(struct wm8350 *wm8350, int irq,
 }
 
 static const struct rtc_class_ops wm8350_rtc_ops = {
-	.ioctl = wm8350_rtc_ioctl,
 	.read_time = wm8350_rtc_readtime,
 	.set_time = wm8350_rtc_settime,
 	.read_alarm = wm8350_rtc_readalarm,
 	.set_alarm = wm8350_rtc_setalarm,
+	.alarm_irq_enable = wm8350_rtc_alarm_irq_enable,
+	.update_irq_enable = wm8350_rtc_update_irq_enable,
 };
 
 #ifdef CONFIG_PM
-- 
1.5.6.5

