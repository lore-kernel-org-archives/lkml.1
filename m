Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508Ab0AEOAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0AEOAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457Ab0AEN7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:59:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60542 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754437Ab0AEN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:59:40 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 3/4] rtc: Suppress duplicate enable/disable of WM8350 update interrupt
Date: Tue,  5 Jan 2010 13:59:08 +0000
Message-Id: <1262699949-3079-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262699949-3079-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20100105135756.GA2993@rakim.wolfsonmicro.main>
 <1262699949-3079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1262699949-3079-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the wm8350-custom code genirq nests enable and disable calls
so we can't just unconditionally mask or unmask the interrupt,
we need to remember the state we set and only mask or unmask when
there is a real change.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-wm8350.c       |    7 +++++++
 include/linux/mfd/wm8350/rtc.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index a427491..ef376d7 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -307,11 +307,18 @@ static int wm8350_rtc_update_irq_enable(struct device *dev,
 {
 	struct wm8350 *wm8350 = dev_get_drvdata(dev);
 
+	/* Suppress duplicate changes since genirq nests enable and
+	 * disable calls. */
+	if (enabled == wm8350->rtc.update_enabled)
+		return 0;
+
 	if (enabled)
 		wm8350_unmask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 	else
 		wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 
+	wm8350->rtc.update_enabled = enabled;
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/wm8350/rtc.h b/include/linux/mfd/wm8350/rtc.h
index 24add2b..ebd72ff 100644
--- a/include/linux/mfd/wm8350/rtc.h
+++ b/include/linux/mfd/wm8350/rtc.h
@@ -263,6 +263,7 @@ struct wm8350_rtc {
 	struct platform_device *pdev;
 	struct rtc_device *rtc;
 	int alarm_enabled;      /* used over suspend/resume */
+	int update_enabled;
 };
 
 #endif
-- 
1.6.5.7

