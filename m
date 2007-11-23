Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbXKWKLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbXKWKLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXKWKIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:08:47 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:3663 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbXKWKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:08:41 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="56898553:sNHT29089991"
From: Bryan Wu <bryan.wu@analog.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 4/7] Blackfin RTC driver: use dev_dbg() rather than pr_stamp()
Date: Fri, 23 Nov 2007 18:08:29 +0800
Message-Id: <1195812512-25979-5-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/rtc/rtc-bfin.c |   48 ++++++++++++++++++++++--------------------------
 1 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 343f284..b14a9c4 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -45,8 +45,7 @@
 
 #include <asm/blackfin.h>
 
-#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
-#define stampit() stamp("here i am")
+#define dev_dbg_stamp(dev) dev_dbg(dev, "%s:%i: here i am\n", __func__, __LINE__)
 
 struct bfin_rtc {
 	struct rtc_device *rtc_dev;
@@ -120,7 +119,6 @@ static inline void rtc_bfin_to_tm(u32 rtc_bfin, struct rtc_time *tm)
  */
 static void rtc_bfin_sync_pending(void)
 {
-	stampit();
 	while (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_COMPLETE)) {
 		if (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING))
 			break;
@@ -128,8 +126,9 @@ static void rtc_bfin_sync_pending(void)
 	bfin_write_RTC_ISTAT(RTC_ISTAT_WRITE_COMPLETE);
 }
 
-static void rtc_bfin_reset(struct bfin_rtc *rtc)
+static void rtc_bfin_reset(struct device *dev)
 {
+	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	/* Initialize the RTC. Enable pre-scaler to scale RTC clock
 	 * to 1Hz and clear interrupt/status registers. */
 	spin_lock_irq(&rtc->lock);
@@ -149,7 +148,7 @@ static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 	unsigned long events = 0;
 	u16 rtc_istat;
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	spin_lock_irq(&rtc->lock);
 
@@ -180,10 +179,9 @@ static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 
 static int bfin_rtc_open(struct device *dev)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	int ret;
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_DISABLED, "rtc-bfin", dev);
 	if (unlikely(ret)) {
@@ -191,16 +189,15 @@ static int bfin_rtc_open(struct device *dev)
 		return ret;
 	}
 
-	rtc_bfin_reset(rtc);
+	rtc_bfin_reset(dev);
 
 	return ret;
 }
 
 static void bfin_rtc_release(struct device *dev)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	stampit();
-	rtc_bfin_reset(rtc);
+	dev_dbg_stamp(dev);
+	rtc_bfin_reset(dev);
 	free_irq(IRQ_RTC, dev);
 }
 
@@ -208,11 +205,11 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	switch (cmd) {
 	case RTC_PIE_ON:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ISTAT(RTC_ISTAT_STOPWATCH);
@@ -221,7 +218,7 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 		spin_unlock_irq(&rtc->lock);
 		return 0;
 	case RTC_PIE_OFF:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_SWCNT(0);
@@ -230,7 +227,7 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 		return 0;
 
 	case RTC_UIE_ON:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
@@ -238,7 +235,7 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 		spin_unlock_irq(&rtc->lock);
 		return 0;
 	case RTC_UIE_OFF:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & ~RTC_ISTAT_SEC);
@@ -250,7 +247,7 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 		u16 which_alarm;
 		int ret = 0;
 
-		stampit();
+		dev_dbg_stamp(dev);
 
 		spin_lock_irq(&rtc->lock);
 
@@ -278,7 +275,7 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 		return ret;
 	}
 	case RTC_AIE_OFF:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & ~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
@@ -293,7 +290,7 @@ static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	spin_lock_irq(&rtc->lock);
 	rtc_bfin_sync_pending();
@@ -309,7 +306,7 @@ static int bfin_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	int ret;
 	unsigned long now;
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	spin_lock_irq(&rtc->lock);
 
@@ -327,7 +324,7 @@ static int bfin_rtc_set_time(struct device *dev, struct rtc_time *tm)
 static int bfin_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	stampit();
+	dev_dbg_stamp(dev);
 	memcpy(&alrm->time, &rtc->rtc_alarm, sizeof(struct rtc_time));
 	alrm->pending = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 	return 0;
@@ -336,7 +333,7 @@ static int bfin_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int bfin_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	stampit();
+	dev_dbg_stamp(dev);
 	memcpy(&rtc->rtc_alarm, &alrm->time, sizeof(struct rtc_time));
 	return 0;
 }
@@ -345,7 +342,7 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 #define yesno(x) ((x) ? "yes" : "no")
 	u16 ictl = bfin_read_RTC_ICTL();
-	stampit();
+	dev_dbg_stamp(dev);
 	seq_printf(seq,
 		"alarm_IRQ\t: %s\n"
 		"wkalarm_IRQ\t: %s\n"
@@ -369,7 +366,7 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
  */
 static int bfin_irq_set_freq(struct device *dev, int freq)
 {
-	stampit();
+	dev_dbg_stamp(dev);
 	return -ENOTTY;
 }
 
@@ -390,7 +387,7 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 	struct bfin_rtc *rtc;
 	int ret = 0;
 
-	stampit();
+	dev_dbg_stamp(&pdev->dev);
 
 	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
@@ -436,7 +433,6 @@ static struct platform_driver bfin_rtc_driver = {
 
 static int __init bfin_rtc_init(void)
 {
-	stampit();
 	return platform_driver_register(&bfin_rtc_driver);
 }
 
-- 
1.5.3.4
