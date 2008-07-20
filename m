Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYGTPul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYGTPul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYGTPue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:50:34 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58782 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757367AbYGTPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:50:33 -0400
Subject: RTC: rtc-s3c: update IRQ handling
Message-Id: <20080720155031.013012457@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: a.zummo@towertech.it, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-s3c24xx-rtc-update-irq.patch
Date: Sun, 20 Jul 2008 16:50:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc-s3c.c driver has been using it's own ioctl() handling
to deal with alarm and periodic interrupts to handle what
should now be done with the rtc core code.

Change to using the .irq_set_freq and .irq_set_state driver
entries and remove the .ioctl handling.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/drivers/rtc/rtc-s3c.c
===================================================================
--- linux-2.6.26-quilt3.orig/drivers/rtc/rtc-s3c.c	2008-07-18 14:54:40.000000000 +0100
+++ linux-2.6.26-quilt3/drivers/rtc/rtc-s3c.c	2008-07-18 15:44:45.000000000 +0100
@@ -40,10 +40,8 @@ static struct resource *s3c_rtc_mem;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
-static int s3c_rtc_freq    = 1;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
-static unsigned int tick_count;
 
 /* IRQ Handlers */
 
@@ -59,7 +57,7 @@ static irqreturn_t s3c_rtc_tickirq(int i
 {
 	struct rtc_device *rdev = id;
 
-	rtc_update_irq(rdev, tick_count++, RTC_PF | RTC_IRQF);
+	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
 	return IRQ_HANDLED;
 }
 
@@ -78,35 +76,37 @@ static void s3c_rtc_setaie(int to)
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
 }
 
-static void s3c_rtc_setpie(int to)
+static int s3c_rtc_setpie(struct device *dev, int enabled)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: pie=%d\n", __func__, to);
+	pr_debug("%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&s3c_rtc_pie_lock);
 	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & ~S3C2410_TICNT_ENABLE;
 
-	if (to)
+	if (enabled)
 		tmp |= S3C2410_TICNT_ENABLE;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
+
+	return 0;
 }
 
-static void s3c_rtc_setfreq(int freq)
+static int s3c_rtc_setfreq(struct device *dev, int freq)
 {
 	unsigned int tmp;
 
 	spin_lock_irq(&s3c_rtc_pie_lock);
-	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & S3C2410_TICNT_ENABLE;
-
-	s3c_rtc_freq = freq;
 
+	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & S3C2410_TICNT_ENABLE;
 	tmp |= (128 / freq)-1;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
+
+	return 0;
 }
 
 /* Time read/write */
@@ -271,12 +271,7 @@ static int s3c_rtc_setalarm(struct devic
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
-	if (0) {
-		alrm_en = readb(base + S3C2410_RTCALM);
-		alrm_en &= ~S3C2410_RTCALM_ALMEN;
-		writeb(alrm_en, base + S3C2410_RTCALM);
-		disable_irq_wake(s3c_rtc_alarmno);
-	}
+	s3c_rtc_setaie(alrm->enabled);
 
 	if (alrm->enabled)
 		enable_irq_wake(s3c_rtc_alarmno);
@@ -286,59 +281,12 @@ static int s3c_rtc_setalarm(struct devic
 	return 0;
 }
 
-static int s3c_rtc_ioctl(struct device *dev,
-			 unsigned int cmd, unsigned long arg)
-{
-	unsigned int ret = -ENOIOCTLCMD;
-
-	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-		s3c_rtc_setaie((cmd == RTC_AIE_ON) ? 1 : 0);
-		ret = 0;
-		break;
-
-	case RTC_PIE_OFF:
-	case RTC_PIE_ON:
-		tick_count = 0;
-		s3c_rtc_setpie((cmd == RTC_PIE_ON) ? 1 : 0);
-		ret = 0;
-		break;
-
-	case RTC_IRQP_READ:
-		ret = put_user(s3c_rtc_freq, (unsigned long __user *)arg);
-		break;
-
-	case RTC_IRQP_SET:
-		if (!is_power_of_2(arg)) {
-			ret = -EINVAL;
-			goto exit;
-		}
-
-		pr_debug("s3c2410_rtc: setting frequency %ld\n", arg);
-
-		s3c_rtc_setfreq(arg);
-		ret = 0;
-		break;
-
-	case RTC_UIE_ON:
-	case RTC_UIE_OFF:
-		ret = -EINVAL;
-	}
-
- exit:
-	return ret;
-}
-
 static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	unsigned int ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
 
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
 		     (ticnt & S3C2410_TICNT_ENABLE) ? "yes" : "no" );
-
-	seq_printf(seq, "periodic_freq\t: %d\n", s3c_rtc_freq);
-
 	return 0;
 }
 
@@ -378,7 +326,7 @@ static void s3c_rtc_release(struct devic
 
 	/* do not clear AIE here, it may be needed for wake */
 
-	s3c_rtc_setpie(0);
+	s3c_rtc_setpie(dev, 0);
 	free_irq(s3c_rtc_alarmno, rtc_dev);
 	free_irq(s3c_rtc_tickno, rtc_dev);
 }
@@ -386,11 +334,12 @@ static void s3c_rtc_release(struct devic
 static const struct rtc_class_ops s3c_rtcops = {
 	.open		= s3c_rtc_open,
 	.release	= s3c_rtc_release,
-	.ioctl		= s3c_rtc_ioctl,
 	.read_time	= s3c_rtc_gettime,
 	.set_time	= s3c_rtc_settime,
 	.read_alarm	= s3c_rtc_getalarm,
 	.set_alarm	= s3c_rtc_setalarm,
+	.irq_set_freq	= s3c_rtc_setfreq,
+	.irq_set_state	= s3c_rtc_setpie,
 	.proc	        = s3c_rtc_proc,
 };
 
@@ -441,7 +390,7 @@ static int s3c_rtc_remove(struct platfor
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
-	s3c_rtc_setpie(0);
+	s3c_rtc_setpie(&dev->dev, 0);
 	s3c_rtc_setaie(0);
 
 	iounmap(s3c_rtc_base);
@@ -508,7 +457,7 @@ static int s3c_rtc_probe(struct platform
  	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
 		 readb(s3c_rtc_base + S3C2410_RTCCON));
 
-	s3c_rtc_setfreq(s3c_rtc_freq);
+	s3c_rtc_setfreq(&pdev->dev, 1);
 
 	/* register RTC and exit */
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
