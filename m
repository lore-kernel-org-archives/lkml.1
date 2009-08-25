Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZHYKvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZHYKvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZHYKvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:51:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43735 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754803AbZHYKvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:51:09 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       rtc-linux@googlegroups.com
Subject: [PATCH] RTC: Update for final round of review comments
Date: Tue, 25 Aug 2009 11:51:08 +0100
Message-Id: <1251197468-3242-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like an early version of the WM831x RTC driver got merged into
the mfd tree without fixes for some final review comments:

 - Consistently get interrupts by name.
 - Implement set_mmss() rather than set_time().
 - Make the error checking a bit less excessive and noisy.
 - Clean up the private data structure.

There shouldn't be any operational effect.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-wm831x.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 99e7845..79795cd 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -92,8 +92,7 @@
 struct wm831x_rtc {
 	struct wm831x *wm831x;
 	struct rtc_device *rtc;
-	int alarm_enabled;
-	int per_irq;
+	unsigned int alarm_enabled:1;
 };
 
 /*
@@ -136,7 +135,7 @@ static int wm831x_rtc_readtime(struct device *dev, struct rtc_time *tm)
 			u32 time = (time1[0] << 16) | time1[1];
 
 			rtc_time_to_tm(time, tm);
-			return 0;
+			return rtc_valid_tm(tm);
 		}
 
 	} while (++count < WM831X_GET_TIME_RETRIES);
@@ -149,21 +148,15 @@ static int wm831x_rtc_readtime(struct device *dev, struct rtc_time *tm)
 /*
  * Set current time and date in RTC
  */
-static int wm831x_rtc_settime(struct device *dev, struct rtc_time *tm)
+static int wm831x_rtc_set_mmss(struct device *dev, unsigned long time)
 {
 	struct wm831x_rtc *wm831x_rtc = dev_get_drvdata(dev);
 	struct wm831x *wm831x = wm831x_rtc->wm831x;
 	struct rtc_time new_tm;
-	unsigned long time, new_time;
+	unsigned long new_time;
 	int ret;
 	int count = 0;
 
-	ret = rtc_tm_to_time(tm, &time);
-	if (ret < 0) {
-		dev_err(dev, "Failed to convert time: %d\n", ret);
-		return ret;
-	}
-
 	ret = wm831x_reg_write(wm831x, WM831X_RTC_TIME_1,
 			       (time >> 16) & 0xffff);
 	if (ret < 0) {
@@ -356,7 +349,7 @@ static irqreturn_t wm831x_per_irq(int irq, void *data)
 
 static const struct rtc_class_ops wm831x_rtc_ops = {
 	.read_time = wm831x_rtc_readtime,
-	.set_time = wm831x_rtc_settime,
+	.set_mmss = wm831x_rtc_set_mmss,
 	.read_alarm = wm831x_rtc_readalarm,
 	.set_alarm = wm831x_rtc_setalarm,
 	.alarm_irq_enable = wm831x_rtc_alarm_irq_enable,
@@ -437,7 +430,6 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, wm831x_rtc);
 	wm831x_rtc->wm831x = wm831x;
-	wm831x_rtc->per_irq = per_irq;
 
 	ret = wm831x_reg_read(wm831x, WM831X_RTC_CONTROL);
 	if (ret < 0) {
@@ -453,7 +445,6 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 					      &wm831x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(wm831x_rtc->rtc)) {
 		ret = PTR_ERR(wm831x_rtc->rtc);
-		dev_err(&pdev->dev, "Failed to register RTC: %d\n", ret);
 		goto err;
 	}
 
@@ -463,7 +454,6 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request periodic IRQ %d: %d\n",
 			per_irq, ret);
-		goto err_rtc;
 	}
 
 	ret = wm831x_request_irq(wm831x, alm_irq, wm831x_alm_irq,
@@ -472,15 +462,10 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
 			alm_irq, ret);
-		goto err_per;
 	}
 
 	return 0;
 
-err_per:
-	wm831x_free_irq(wm831x, per_irq, wm831x_rtc);
-err_rtc:
-	rtc_device_unregister(wm831x_rtc->rtc);
 err:
 	kfree(wm831x_rtc);
 	return ret;
@@ -489,8 +474,8 @@ err:
 static int __devexit wm831x_rtc_remove(struct platform_device *pdev)
 {
 	struct wm831x_rtc *wm831x_rtc = platform_get_drvdata(pdev);
-	int per_irq = platform_get_irq(pdev, 0);
-	int alm_irq = platform_get_irq(pdev, 1);
+	int per_irq = platform_get_irq_byname(pdev, "PER");
+	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 
 	wm831x_free_irq(wm831x_rtc->wm831x, alm_irq, wm831x_rtc);
 	wm831x_free_irq(wm831x_rtc->wm831x, per_irq, wm831x_rtc);
-- 
1.6.3.3

