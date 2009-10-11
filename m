Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZJKRHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZJKRHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbZJKRHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:07:05 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:52837 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408AbZJKRHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:07:03 -0400
Date: Mon, 12 Oct 2009 02:05:47 +0900 (JST)
Message-Id: <20091012.020547.236990947.anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 3/3] rtc-tx4939: Fix races around device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use its own spinlock instead of rtc->irq_lock
* Check pdata->rtc before calling rtc_update_irq
* Disable interrupt after rtc_device_unregister

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-tx4939.c |   51 +++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 4a6ed11..9ee81d8 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -17,6 +17,7 @@
 struct tx4939rtc_plat_data {
 	struct rtc_device *rtc;
 	struct tx4939_rtc_reg __iomem *rtcreg;
+	spinlock_t lock;
 };
 
 static struct tx4939rtc_plat_data *get_tx4939rtc_plat_data(struct device *dev)
@@ -52,14 +53,14 @@ static int tx4939_rtc_set_mmss(struct device *dev, unsigned long secs)
 	buf[3] = secs >> 8;
 	buf[4] = secs >> 16;
 	buf[5] = secs >> 24;
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irq(&pdata->lock);
 	__raw_writel(0, &rtcreg->adr);
 	for (i = 0; i < 6; i++)
 		__raw_writel(buf[i], &rtcreg->dat);
 	ret = tx4939_rtc_cmd(rtcreg,
 			     TX4939_RTCCTL_COMMAND_SETTIME |
 			     (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALME));
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irq(&pdata->lock);
 	return ret;
 }
 
@@ -71,18 +72,18 @@ static int tx4939_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	unsigned long sec;
 	unsigned char buf[6];
 
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irq(&pdata->lock);
 	ret = tx4939_rtc_cmd(rtcreg,
 			     TX4939_RTCCTL_COMMAND_GETTIME |
 			     (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALME));
 	if (ret) {
-		spin_unlock_irq(&pdata->rtc->irq_lock);
+		spin_unlock_irq(&pdata->lock);
 		return ret;
 	}
 	__raw_writel(2, &rtcreg->adr);
 	for (i = 2; i < 6; i++)
 		buf[i] = __raw_readl(&rtcreg->dat);
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irq(&pdata->lock);
 	sec = (buf[5] << 24) | (buf[4] << 16) | (buf[3] << 8) | buf[2];
 	rtc_time_to_tm(sec, tm);
 	return rtc_valid_tm(tm);
@@ -110,13 +111,13 @@ static int tx4939_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	buf[3] = sec >> 8;
 	buf[4] = sec >> 16;
 	buf[5] = sec >> 24;
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irq(&pdata->lock);
 	__raw_writel(0, &rtcreg->adr);
 	for (i = 0; i < 6; i++)
 		__raw_writel(buf[i], &rtcreg->dat);
 	ret = tx4939_rtc_cmd(rtcreg, TX4939_RTCCTL_COMMAND_SETALARM |
 			     (alrm->enabled ? TX4939_RTCCTL_ALME : 0));
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irq(&pdata->lock);
 	return ret;
 }
 
@@ -129,12 +130,12 @@ static int tx4939_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned char buf[6];
 	u32 ctl;
 
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irq(&pdata->lock);
 	ret = tx4939_rtc_cmd(rtcreg,
 			     TX4939_RTCCTL_COMMAND_GETALARM |
 			     (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALME));
 	if (ret) {
-		spin_unlock_irq(&pdata->rtc->irq_lock);
+		spin_unlock_irq(&pdata->lock);
 		return ret;
 	}
 	__raw_writel(2, &rtcreg->adr);
@@ -143,7 +144,7 @@ static int tx4939_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	ctl = __raw_readl(&rtcreg->ctl);
 	alrm->enabled = (ctl & TX4939_RTCCTL_ALME) ? 1 : 0;
 	alrm->pending = (ctl & TX4939_RTCCTL_ALMD) ? 1 : 0;
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irq(&pdata->lock);
 	sec = (buf[5] << 24) | (buf[4] << 16) | (buf[3] << 8) | buf[2];
 	rtc_time_to_tm(sec, &alrm->time);
 	return rtc_valid_tm(&alrm->time);
@@ -153,11 +154,11 @@ static int tx4939_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
 
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irq(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg,
 		       TX4939_RTCCTL_COMMAND_NOP |
 		       (enabled ? TX4939_RTCCTL_ALME : 0));
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irq(&pdata->lock);
 	return 0;
 }
 
@@ -167,13 +168,14 @@ static irqreturn_t tx4939_rtc_interrupt(int irq, void *dev_id)
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	unsigned long events = RTC_IRQF;
 
-	spin_lock(&pdata->rtc->irq_lock);
+	spin_lock(&pdata->lock);
 	if (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALMD) {
 		events |= RTC_AF;
 		tx4939_rtc_cmd(rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	}
-	spin_unlock(&pdata->rtc->irq_lock);
-	rtc_update_irq(pdata->rtc, 1, events);
+	spin_unlock(&pdata->lock);
+	if (likely(pdata->rtc))
+		rtc_update_irq(pdata->rtc, 1, events);
 	return IRQ_HANDLED;
 }
 
@@ -194,13 +196,13 @@ static ssize_t tx4939_rtc_nvram_read(struct kobject *kobj,
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	ssize_t count;
 
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irq(&pdata->lock);
 	for (count = 0; size > 0 && pos < TX4939_RTC_REG_RAMSIZE;
 	     count++, size--) {
 		__raw_writel(pos++, &rtcreg->adr);
 		*buf++ = __raw_readl(&rtcreg->dat);
 	}
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irq(&pdata->lock);
 	return count;
 }
 
@@ -213,13 +215,13 @@ static ssize_t tx4939_rtc_nvram_write(struct kobject *kobj,
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	ssize_t count;
 
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irq(&pdata->lock);
 	for (count = 0; size > 0 && pos < TX4939_RTC_REG_RAMSIZE;
 	     count++, size--) {
 		__raw_writel(pos++, &rtcreg->adr);
 		__raw_writel(*buf++, &rtcreg->dat);
 	}
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irq(&pdata->lock);
 	return count;
 }
 
@@ -259,6 +261,7 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 	if (!pdata->rtcreg)
 		return -EBUSY;
 
+	spin_lock_init(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
 			     IRQF_DISABLED, pdev->name, &pdev->dev) < 0)
@@ -277,14 +280,12 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 static int __exit tx4939_rtc_remove(struct platform_device *pdev)
 {
 	struct tx4939rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	struct rtc_device *rtc = pdata->rtc;
 
-	spin_lock_irq(&rtc->irq_lock);
-	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
-	spin_unlock_irq(&rtc->irq_lock);
 	sysfs_remove_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
-	rtc_device_unregister(rtc);
-	platform_set_drvdata(pdev, NULL);
+	rtc_device_unregister(pdata->rtc);
+	spin_lock_irq(&pdata->lock);
+	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
+	spin_unlock_irq(&pdata->lock);
 	return 0;
 }
 
-- 
1.5.6.5


