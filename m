Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYHOJMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYHOJMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYHOJL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:11:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:52441 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYHOJLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:11:25 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="58087367"
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/4] Blackfin RTC Driver: move irq request/free out of open/release and into probe/remove so that the non-dev interfaces (like sysfs) work as expected
Date: Fri, 15 Aug 2008 17:01:17 +0800
Message-Id: <1218790880-12477-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
References: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |   51 ++++++++++++++++++-----------------------------
 1 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index a1af4c2..51741dc 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -218,26 +218,6 @@ static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 		return IRQ_NONE;
 }
 
-static int bfin_rtc_open(struct device *dev)
-{
-	int ret;
-
-	dev_dbg_stamp(dev);
-
-	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, to_platform_device(dev)->name, dev);
-	if (!ret)
-		bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
-
-	return ret;
-}
-
-static void bfin_rtc_release(struct device *dev)
-{
-	dev_dbg_stamp(dev);
-	bfin_rtc_reset(dev, 0);
-	free_irq(IRQ_RTC, dev);
-}
-
 static void bfin_rtc_int_set(u16 rtc_int)
 {
 	bfin_write_RTC_ISTAT(rtc_int);
@@ -370,8 +350,6 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 }
 
 static struct rtc_class_ops bfin_rtc_ops = {
-	.open          = bfin_rtc_open,
-	.release       = bfin_rtc_release,
 	.ioctl         = bfin_rtc_ioctl,
 	.read_time     = bfin_rtc_read_time,
 	.set_time      = bfin_rtc_set_time,
@@ -383,29 +361,37 @@ static struct rtc_class_ops bfin_rtc_ops = {
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 {
 	struct bfin_rtc *rtc;
+	struct device *dev = &pdev->dev;
 	int ret = 0;
 
-	dev_dbg_stamp(&pdev->dev);
+	dev_dbg_stamp(dev);
 
+	/* Allocate memory for our RTC struct */
 	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
 		return -ENOMEM;
+	platform_set_drvdata(pdev, rtc);
 
-	rtc->rtc_dev = rtc_device_register(pdev->name, &pdev->dev, &bfin_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc->rtc_dev);
+	/* Grab the IRQ and init the hardware */
+	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
+	if (unlikely(ret))
 		goto err;
-	}
-
-	/* see comment at top of file about stopwatch/PIE */
+	bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 
-	platform_set_drvdata(pdev, rtc);
+	/* Register our RTC with the RTC framework */
+	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops, THIS_MODULE);
+	if (unlikely(IS_ERR(rtc))) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto err_irq;
+	}
 
-	device_init_wakeup(&pdev->dev, 1);
+	device_init_wakeup(dev, 1);
 
 	return 0;
 
+ err_irq:
+	free_irq(IRQ_RTC, dev);
  err:
 	kfree(rtc);
 	return ret;
@@ -414,7 +400,10 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 static int __devexit bfin_rtc_remove(struct platform_device *pdev)
 {
 	struct bfin_rtc *rtc = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
 
+	bfin_rtc_reset(dev, 0);
+	free_irq(IRQ_RTC, dev);
 	rtc_device_unregister(rtc->rtc_dev);
 	platform_set_drvdata(pdev, NULL);
 	kfree(rtc);
-- 
1.5.6
