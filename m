Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0CBJsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:48:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40739 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab0CBJsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:48:06 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2 6/6] rtc/mc13783: implement alarm
Date: Tue,  2 Mar 2010 10:47:58 +0100
Message-Id: <1267523278-17820-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100301124534.5262de64@linux.lan.towertech.it>
References: <20100301124534.5262de64@linux.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

changes since first submission:

  - implement race free time setting

Best regards
Uwe

 drivers/rtc/rtc-mc13783.c |  185 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 172 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
index 6a36201..d60c81b 100644
--- a/drivers/rtc/rtc-mc13783.c
+++ b/drivers/rtc/rtc-mc13783.c
@@ -28,6 +28,34 @@ struct mc13783_rtc {
 	int valid;
 };
 
+static int mc13783_rtc_irq_enable_unlocked(struct device *dev,
+		unsigned int enabled, int irq)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	int (*func)(struct mc13783 *mc13783, int irq);
+
+	if (!priv->valid)
+		return -ENODATA;
+
+	func = enabled ? mc13783_irq_unmask : mc13783_irq_mask;
+	return func(priv->mc13783, irq);
+}
+
+static int mc13783_rtc_irq_enable(struct device *dev,
+		unsigned int enabled, int irq)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	ret = mc13783_rtc_irq_enable_unlocked(dev, enabled, irq);
+
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
 static int mc13783_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct mc13783_rtc *priv = dev_get_drvdata(dev);
@@ -78,6 +106,7 @@ static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
 	struct mc13783_rtc *priv = dev_get_drvdata(dev);
 	unsigned int seconds, days;
+	unsigned int alarmseconds;
 	int ret;
 
 	seconds = secs % 86400;
@@ -86,7 +115,22 @@ static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs)
 	mc13783_lock(priv->mc13783);
 
 	/*
-	 * first write seconds=0 to prevent a day switch between writing days
+	 * temporarily invalidate alarm to prevent triggering it when the day is
+	 * already updated while the time isn't yet.
+	 */
+	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCTODA, &alarmseconds);
+	if (unlikely(ret))
+		goto out;
+
+	if (alarmseconds < 86400) {
+		ret = mc13783_reg_write(priv->mc13783,
+				MC13783_RTCTODA, 0x1ffff);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	/*
+	 * write seconds=0 to prevent a day switch between writing days
 	 * and seconds below
 	 */
 	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, 0);
@@ -101,6 +145,14 @@ static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs)
 	if (unlikely(ret))
 		goto out;
 
+	/* restore alarm */
+	if (alarmseconds < 86400) {
+		ret = mc13783_reg_write(priv->mc13783,
+				MC13783_RTCTODA, alarmseconds);
+		if (unlikely(ret))
+			goto out;
+	}
+
 	ret = mc13783_irq_ack(priv->mc13783, MC13783_IRQ_RTCRST);
 	if (unlikely(ret))
 		goto out;
@@ -114,6 +166,107 @@ out:
 	return ret;
 }
 
+static int mc13783_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	unsigned seconds, days;
+	unsigned long s1970;
+	int enabled, pending;
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCTODA, &seconds);
+	if (unlikely(ret))
+		goto out;
+	if (seconds >= 86400) {
+		ret = -ENODATA;
+		goto out;
+	}
+
+	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_irq_status(priv->mc13783, MC13783_IRQ_TODA,
+			&enabled, &pending);
+
+out:
+	mc13783_unlock(priv->mc13783);
+
+	if (ret)
+		return ret;
+
+	alarm->enabled = enabled;
+	alarm->pending = pending;
+
+	s1970 = days * 86400 + seconds;
+
+	rtc_time_to_tm(s1970, &alarm->time);
+	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
+
+	return 0;
+}
+
+static int mc13783_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	unsigned long s1970;
+	unsigned seconds, days;
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	/* disable alarm to prevent false triggering */
+	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTODA, 0x1ffff);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TODA);
+	if (unlikely(ret))
+		goto out;
+
+	ret = rtc_tm_to_time(&alarm->time, &s1970);
+	if (unlikely(ret))
+		goto out;
+
+	dev_dbg(dev, "%s: o%2.s %lu\n", __func__, alarm->enabled ? "n" : "ff",
+			s1970);
+
+	ret = mc13783_rtc_irq_enable_unlocked(dev, alarm->enabled,
+			MC13783_IRQ_TODA);
+	if (unlikely(ret))
+		goto out;
+
+	seconds = s1970 % 86400;
+	days = s1970 / 86400;
+
+	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCDAYA, days);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTODA, seconds);
+
+out:
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static irqreturn_t mc13783_rtc_alarm_handler(int irq, void *dev)
+{
+	struct mc13783_rtc *priv = dev;
+	struct mc13783 *mc13783 = priv->mc13783;
+
+	dev_dbg(&priv->rtc->dev, "Alarm\n");
+
+	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_AF);
+
+	mc13783_irq_ack(mc13783, irq);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
 {
 	struct mc13783_rtc *priv = dev;
@@ -131,24 +284,21 @@ static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
 static int mc13783_rtc_update_irq_enable(struct device *dev,
 		unsigned int enabled)
 {
-	struct mc13783_rtc *priv = dev_get_drvdata(dev);
-	int ret = -ENODATA;
-
-	mc13783_lock(priv->mc13783);
-	if (!priv->valid)
-		goto out;
-
-	ret = (enabled ? mc13783_irq_unmask : mc13783_irq_mask)(priv->mc13783,
-			MC13783_IRQ_1HZ);
-out:
-	mc13783_unlock(priv->mc13783);
+	return mc13783_rtc_irq_enable(dev, enabled, MC13783_IRQ_1HZ);
+}
 
-	return ret;
+static int mc13783_rtc_alarm_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	return mc13783_rtc_irq_enable(dev, enabled, MC13783_IRQ_TODA);
 }
 
 static const struct rtc_class_ops mc13783_rtc_ops = {
 	.read_time = mc13783_rtc_read_time,
 	.set_mmss = mc13783_rtc_set_mmss,
+	.read_alarm = mc13783_rtc_read_alarm,
+	.set_alarm = mc13783_rtc_set_alarm,
+	.alarm_irq_enable = mc13783_rtc_alarm_irq_enable,
 	.update_irq_enable = mc13783_rtc_update_irq_enable,
 };
 
@@ -197,11 +347,19 @@ static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_update_irq_request;
 
+	ret = mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_TODA,
+			mc13783_rtc_alarm_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_alarm_irq_request;
+
 	priv->rtc = rtc_device_register(pdev->name,
 			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
+		mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
+err_alarm_irq_request:
+
 		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 err_update_irq_request:
 
@@ -227,6 +385,7 @@ static int __devexit mc13783_rtc_remove(struct platform_device *pdev)
 
 	rtc_device_unregister(priv->rtc);
 
+	mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
 
-- 
1.7.0

