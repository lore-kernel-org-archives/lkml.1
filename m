Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0CKUKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:10:55 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:45926 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab0CKUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:10:51 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux@arm.linux.org.uk, mroberto@cpti.cetuc.puc-rio.br
Cc: mad_soft@inbox.ru, rpjday@crashcourse.ca, jaswinderrajput@gmail.com,
       kristoffer.ericson@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: mach-sa1100: Better use of the RTC framework for sa11xx.
Date: Thu, 11 Mar 2010 17:10:25 -0300
Message-Id: <1268338225-32253-4-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1268338225-32253-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1268338225-32253-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the RTC framework to treat some common ioctl.
In particular, it fixes the behaviour of rtc_irq_set_freq(),
which did not work as expected because the timer was not beeing
retriggered.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/rtc-sa1100.c |   90 +++++++++++++++++++++++++++++++++------------
 1 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index b0985f7..738503c 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -42,7 +42,7 @@
 #define RTC_DEF_DIVIDER		(32768 - 1)
 #define RTC_DEF_TRIM		0
 
-static unsigned long rtc_freq = 1024;
+static const unsigned long RTC_FREQ = 1024;
 static unsigned long timer_freq;
 static struct rtc_time rtc_alarm;
 static DEFINE_SPINLOCK(sa1100_rtc_lock);
@@ -156,8 +156,50 @@ static irqreturn_t sa1100_rtc_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int sa1100_irq_set_freq(struct device *dev, int freq)
+{
+	if (freq < 1 || freq > timer_freq) {
+		return -EINVAL;
+	} else {
+		struct rtc_device *rtc = (struct rtc_device *)dev;
+
+		rtc->irq_freq = freq;
+
+		return 0;
+	}
+}
+
 static int rtc_timer1_count;
 
+static int sa1100_irq_set_state(struct device *dev, int enabled)
+{
+	spin_lock_irq(&sa1100_rtc_lock);
+	if (enabled) {
+		struct rtc_device *rtc = (struct rtc_device *)dev;
+
+		OSMR1 = timer_freq / rtc->irq_freq + OSCR;
+		OIER |= OIER_E1;
+		rtc_timer1_count = 1;
+	} else {
+		OIER &= ~OIER_E1;
+	}
+	spin_unlock_irq(&sa1100_rtc_lock);
+
+	return 0;
+}
+
+static inline int sa1100_timer1_retrigger(struct rtc_device *rtc)
+{
+	spin_lock_irq(&sa1100_rtc_lock);
+
+	OSMR1 = timer_freq / rtc->irq_freq + OSCR;
+	OIER |= OIER_E1;
+
+	spin_unlock_irq(&sa1100_rtc_lock);
+
+	return 0;
+}
+
 static irqreturn_t timer1_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = to_platform_device(dev_id);
@@ -175,7 +217,11 @@ static irqreturn_t timer1_interrupt(int irq, void *dev_id)
 	rtc_update_irq(rtc, rtc_timer1_count, RTC_PF | RTC_IRQF);
 
 	if (rtc_timer1_count == 1)
-		rtc_timer1_count = (rtc_freq * ((1 << 30) / (timer_freq >> 2)));
+		rtc_timer1_count =
+			(rtc->irq_freq * ((1 << 30) / (timer_freq >> 2)));
+
+	/* retrigger. */
+	sa1100_timer1_retrigger(rtc);
 
 	return IRQ_HANDLED;
 }
@@ -183,8 +229,10 @@ static irqreturn_t timer1_interrupt(int irq, void *dev_id)
 static int sa1100_rtc_read_callback(struct device *dev, int data)
 {
 	if (data & RTC_PF) {
+		struct rtc_device *rtc = (struct rtc_device *)dev;
+
 		/* interpolate missed periods and set match for the next */
-		unsigned long period = timer_freq / rtc_freq;
+		unsigned long period = timer_freq / rtc->irq_freq;
 		unsigned long oscr = OSCR;
 		unsigned long osmr1 = OSMR1;
 		unsigned long missed = (oscr - osmr1)/period;
@@ -207,6 +255,7 @@ static int sa1100_rtc_read_callback(struct device *dev, int data)
 static int sa1100_rtc_open(struct device *dev)
 {
 	int ret;
+	struct rtc_device *rtc = (struct rtc_device *)dev;
 
 	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, IRQF_DISABLED,
 		"rtc 1Hz", dev);
@@ -226,6 +275,9 @@ static int sa1100_rtc_open(struct device *dev)
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_OST1);
 		goto fail_pi;
 	}
+	rtc->max_user_freq = RTC_FREQ;
+	sa1100_irq_set_freq(dev, RTC_FREQ);
+
 	return 0;
 
  fail_pi:
@@ -274,25 +326,6 @@ static int sa1100_rtc_ioctl(struct device *dev, unsigned int cmd,
 		RTSR |= RTSR_HZE;
 		spin_unlock_irq(&sa1100_rtc_lock);
 		return 0;
-	case RTC_PIE_OFF:
-		spin_lock_irq(&sa1100_rtc_lock);
-		OIER &= ~OIER_E1;
-		spin_unlock_irq(&sa1100_rtc_lock);
-		return 0;
-	case RTC_PIE_ON:
-		spin_lock_irq(&sa1100_rtc_lock);
-		OSMR1 = timer_freq / rtc_freq + OSCR;
-		OIER |= OIER_E1;
-		rtc_timer1_count = 1;
-		spin_unlock_irq(&sa1100_rtc_lock);
-		return 0;
-	case RTC_IRQP_READ:
-		return put_user(rtc_freq, (unsigned long *)arg);
-	case RTC_IRQP_SET:
-		if (arg < 1 || arg > timer_freq)
-			return -EINVAL;
-		rtc_freq = arg;
-		return 0;
 	}
 	return -ENOIOCTLCMD;
 }
@@ -344,12 +377,14 @@ static int sa1100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int sa1100_rtc_proc(struct device *dev, struct seq_file *seq)
 {
+	struct rtc_device *rtc = (struct rtc_device *)dev;
+
 	seq_printf(seq, "trim/divider\t: 0x%08x\n", (u32) RTTR);
 	seq_printf(seq, "update_IRQ\t: %s\n",
 			(RTSR & RTSR_HZE) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
 			(OIER & OIER_E1) ? "yes" : "no");
-	seq_printf(seq, "periodic_freq\t: %ld\n", rtc_freq);
+	seq_printf(seq, "periodic_freq\t: %d\n", rtc->irq_freq);
 	seq_printf(seq, "RTSR\t\t: 0x%08x\n", (u32)RTSR);
 
 	return 0;
@@ -365,6 +400,8 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 	.read_alarm = sa1100_rtc_read_alarm,
 	.set_alarm = sa1100_rtc_set_alarm,
 	.proc = sa1100_rtc_proc,
+	.irq_set_freq = sa1100_irq_set_freq,
+	.irq_set_state = sa1100_irq_set_state,
 };
 
 static int sa1100_rtc_probe(struct platform_device *pdev)
@@ -391,13 +428,18 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 1);
 
 	rtc = rtc_device_register(pdev->name, &pdev->dev, &sa1100_rtc_ops,
-				THIS_MODULE);
+		THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
 	platform_set_drvdata(pdev, rtc);
 
+	/* Set the irq_freq */
+	/*TODO: Find out who is messing with this value after we initialize
+	 * it here.*/
+	rtc->irq_freq = RTC_FREQ;
+
 	/* Fix for a nasty initialization problem the in SA11xx RTSR register.
 	 * See also the comments in sa1100_rtc_interrupt().
 	 *
-- 
1.7.0.1

