Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYHLQSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYHLQSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYHLQRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:17:47 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:58023 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754213AbYHLQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:17:46 -0400
Date: Tue, 12 Aug 2008 20:17:45 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/2] rtc: bunch of drivers: fix 'no irq' case handing
Message-ID: <20080812161745.GB32164@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bunch of irq checking misuses. Most drivers were
getting irq via platform_get_irq(), which returns -ENXIO or r->start.
Platforms may specify r->start = 0 to emphasize 'no irq' case, and
drivers should handle this correctly.

rtc-cmos.c is special. It is using PNP and platform bindings.
Hopefully nobody is using PNP IRQ 0 for RTC. So the changes should
be safe.

Also, rtc-sh.c was using platform_get_irq, and stored a result into
an unsigned type, then was checking for < 0. This is fixed now.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

Unlike the first patch, this one is untested. Please review carefully.

 drivers/rtc/rtc-at32ap700x.c |    2 +-
 drivers/rtc/rtc-cmos.c       |    4 ++--
 drivers/rtc/rtc-ds1511.c     |   18 +++++++++---------
 drivers/rtc/rtc-ds1553.c     |   14 +++++++-------
 drivers/rtc/rtc-m48t59.c     |    2 +-
 drivers/rtc/rtc-sh.c         |   10 ++++++----
 drivers/rtc/rtc-stk17ta8.c   |   14 +++++++-------
 drivers/rtc/rtc-vr41xx.c     |    4 ++--
 8 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 90b9a65..e327f6f 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -222,7 +222,7 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
+	if (irq <= 0) {
 		dev_dbg(&pdev->dev, "could not get irq\n");
 		ret = -ENXIO;
 		goto out;
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 6ea349a..2dea444 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -57,8 +57,8 @@ struct cmos_rtc {
 	u8			century;
 };
 
-/* both platform and pnp busses use negative numbers for invalid irqs */
-#define is_valid_irq(n)		((n) >= 0)
+/* both platform and pnp busses use positive numbers for valid irqs */
+#define is_valid_irq(n)		((n) > 0)
 
 static const char driver_name[] = "rtc_cmos";
 
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 0f0d27d..434b045 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -326,9 +326,9 @@ ds1511_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0)
 		return -EINVAL;
-	}
+
 	pdata->alrm_mday = alrm->time.tm_mday;
 	pdata->alrm_hour = alrm->time.tm_hour;
 	pdata->alrm_min = alrm->time.tm_min;
@@ -346,9 +346,9 @@ ds1511_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0)
 		return -EINVAL;
-	}
+
 	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
 	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
 	alrm->time.tm_min = pdata->alrm_min < 0 ? 0 : pdata->alrm_min;
@@ -385,7 +385,7 @@ ds1511_rtc_release(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		pdata->irqen = 0;
 		ds1511_rtc_update_alarm(pdata);
 	}
@@ -397,7 +397,7 @@ ds1511_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0) {
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	}
 	switch (cmd) {
@@ -559,7 +559,7 @@ ds1511_rtc_probe(struct platform_device *pdev)
 	 * if the platform has an interrupt in mind for this device,
 	 * then by all means, set it
 	 */
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		rtc_read(RTC_CMD1);
 		if (request_irq(pdata->irq, ds1511_interrupt,
 			IRQF_DISABLED | IRQF_SHARED, pdev->name, pdev) < 0) {
@@ -586,7 +586,7 @@ ds1511_rtc_probe(struct platform_device *pdev)
 	if (pdata->rtc) {
 		rtc_device_unregister(pdata->rtc);
 	}
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		free_irq(pdata->irq, pdev);
 	}
 	if (ds1511_base) {
@@ -609,7 +609,7 @@ ds1511_rtc_remove(struct platform_device *pdev)
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
 	pdata->rtc = NULL;
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		/*
 		 * disable the alarm interrupt
 		 */
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index a19f114..426048f 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -162,7 +162,7 @@ static int ds1553_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	pdata->alrm_mday = alrm->time.tm_mday;
 	pdata->alrm_hour = alrm->time.tm_hour;
@@ -179,7 +179,7 @@ static int ds1553_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
 	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
@@ -212,7 +212,7 @@ static void ds1553_rtc_release(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		pdata->irqen = 0;
 		ds1553_rtc_update_alarm(pdata);
 	}
@@ -224,7 +224,7 @@ static int ds1553_rtc_ioctl(struct device *dev, unsigned int cmd,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -339,7 +339,7 @@ static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_BLF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
@@ -365,7 +365,7 @@ static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -381,7 +381,7 @@ static int __devexit ds1553_rtc_remove(struct platform_device *pdev)
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 		free_irq(pdata->irq, pdev);
 	}
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 013e6c1..827a60b 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -412,7 +412,7 @@ static int __devinit m48t59_rtc_probe(struct platform_device *pdev)
 	 * the mode without IRQ.
 	 */
 	m48t59->irq = platform_get_irq(pdev, 0);
-	if (m48t59->irq < 0)
+	if (m48t59->irq <= 0)
 		m48t59->irq = NO_IRQ;
 
 	if (m48t59->irq != NO_IRQ) {
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 1f88e9e..2ac40cf 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -89,7 +89,9 @@ struct sh_rtc {
 	void __iomem *regbase;
 	unsigned long regsize;
 	struct resource *res;
-	unsigned int alarm_irq, periodic_irq, carry_irq;
+	int alarm_irq;
+	int periodic_irq;
+	int carry_irq;
 	struct rtc_device *rtc_dev;
 	spinlock_t lock;
 	unsigned long capabilities;	/* See asm-sh/rtc.h for cap bits */
@@ -585,19 +587,19 @@ static int __devinit sh_rtc_probe(struct platform_device *pdev)
 
 	/* get periodic/carry/alarm irqs */
 	rtc->periodic_irq = platform_get_irq(pdev, 0);
-	if (unlikely(rtc->periodic_irq < 0)) {
+	if (unlikely(rtc->periodic_irq <= 0)) {
 		dev_err(&pdev->dev, "No IRQ for period\n");
 		goto err_badres;
 	}
 
 	rtc->carry_irq = platform_get_irq(pdev, 1);
-	if (unlikely(rtc->carry_irq < 0)) {
+	if (unlikely(rtc->carry_irq <= 0)) {
 		dev_err(&pdev->dev, "No IRQ for carry\n");
 		goto err_badres;
 	}
 
 	rtc->alarm_irq = platform_get_irq(pdev, 2);
-	if (unlikely(rtc->alarm_irq < 0)) {
+	if (unlikely(rtc->alarm_irq <= 0)) {
 		dev_err(&pdev->dev, "No IRQ for alarm\n");
 		goto err_badres;
 	}
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 31d3c8c..ad1ae47 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -170,7 +170,7 @@ static int stk17ta8_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	pdata->alrm_mday = alrm->time.tm_mday;
 	pdata->alrm_hour = alrm->time.tm_hour;
@@ -187,7 +187,7 @@ static int stk17ta8_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
 	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
@@ -220,7 +220,7 @@ static void stk17ta8_rtc_release(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		pdata->irqen = 0;
 		stk17ta8_rtc_update_alarm(pdata);
 	}
@@ -232,7 +232,7 @@ static int stk17ta8_rtc_ioctl(struct device *dev, unsigned int cmd,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -342,7 +342,7 @@ static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_PF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, stk17ta8_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
@@ -368,7 +368,7 @@ static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -384,7 +384,7 @@ static int __devexit stk17ta8_rtc_remove(struct platform_device *pdev)
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 		free_irq(pdata->irq, pdev);
 	}
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 884b635..e441c9e 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -360,7 +360,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 	spin_unlock_irq(&rtc_lock);
 
 	aie_irq = platform_get_irq(pdev, 0);
-	if (aie_irq < 0 || aie_irq >= NR_IRQS) {
+	if (aie_irq <= 0 || aie_irq >= NR_IRQS) {
 		retval = -EBUSY;
 		goto err_device_unregister;
 	}
@@ -371,7 +371,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq < 0 || pie_irq >= NR_IRQS)
+	if (pie_irq <= 0 || pie_irq >= NR_IRQS)
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
-- 
1.5.6.3
