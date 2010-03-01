Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab0CAKx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:53:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54456 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0CAKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:53:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 6/6] rtc/mc13783: implement alarm
Date: Mon,  1 Mar 2010 11:53:45 +0100
Message-Id: <1267440825-14694-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: rtc-linux@googlegroups.com
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

for now this just ignores the possible race to trigger an alarm when
setting the time.  Should I resolve that, if so, what is the prefered
way to do that?

Best regards
Uwe

 drivers/rtc/rtc-mc13783.c |  159 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 147 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
index 6a36201..ae01217 100644
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
@@ -114,6 +142,107 @@ out:
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
@@ -131,24 +260,21 @@ static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
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
 
@@ -197,11 +323,19 @@ static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
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
 
@@ -227,6 +361,7 @@ static int __devexit mc13783_rtc_remove(struct platform_device *pdev)
 
 	rtc_device_unregister(priv->rtc);
 
+	mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
 
-- 
1.7.0

