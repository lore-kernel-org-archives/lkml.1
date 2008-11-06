Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbYKFRlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbYKFRlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYKFRlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:41:15 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:20363 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751162AbYKFRlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:41:14 -0500
Date: Thu, 6 Nov 2008 20:41:11 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: bunch of drivers: fix 'no irq' case handing
Message-ID: <20081106174111.GA21882@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bunch of irq checking misuses.  Most drivers were getting
irq via platform_get_irq(), which returns -ENXIO or r->start.  Platforms
may specify r->start = 0 to emphasize 'no irq' case, and drivers should
handle this correctly.

rtc-cmos.c is special.  It is using PNP and platform bindings.  Hopefully
nobody is using PNP IRQ 0 for RTC.  So the changes should be safe.

rtc-sh.c is using platform_get_irq, but was storing a result into an
unsigned type, then was checking for < 0.  This is fixed now.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/rtc/rtc-at32ap700x.c |    4 ++--
 drivers/rtc/rtc-cmos.c       |    2 +-
 drivers/rtc/rtc-ds1511.c     |   19 +++++++++----------
 drivers/rtc/rtc-ds1553.c     |   15 +++++++--------
 drivers/rtc/rtc-m48t59.c     |    2 +-
 drivers/rtc/rtc-sh.c         |   10 ++++++----
 drivers/rtc/rtc-stk17ta8.c   |   15 +++++++--------
 drivers/rtc/rtc-twl4030.c    |    5 +++--
 drivers/rtc/rtc-vr41xx.c     |    8 ++++----
 9 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 90b9a65..e1ec33e 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -205,7 +205,7 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 {
 	struct resource	*regs;
 	struct rtc_at32ap700x *rtc;
-	int irq = -1;
+	int irq;
 	int ret;
 
 	rtc = kzalloc(sizeof(struct rtc_at32ap700x), GFP_KERNEL);
@@ -222,7 +222,7 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
+	if (irq <= 0) {
 		dev_dbg(&pdev->dev, "could not get irq\n");
 		ret = -ENXIO;
 		goto out;
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5549231..521706d 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -58,7 +58,7 @@ struct cmos_rtc {
 };
 
 /* both platform and pnp busses use negative numbers for invalid irqs */
-#define is_valid_irq(n)		((n) >= 0)
+#define is_valid_irq(n)		((n) > 0)
 
 static const char driver_name[] = "rtc_cmos";
 
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 25caada..23a07fe 100644
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
@@ -385,7 +385,7 @@ ds1511_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0) {
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	}
 	switch (cmd) {
@@ -503,7 +503,6 @@ ds1511_rtc_probe(struct platform_device *pdev)
 	if (!pdata) {
 		return -ENOMEM;
 	}
-	pdata->irq = -1;
 	pdata->size = res->end - res->start + 1;
 	if (!request_mem_region(res->start, pdata->size, pdev->name)) {
 		ret = -EBUSY;
@@ -545,13 +544,13 @@ ds1511_rtc_probe(struct platform_device *pdev)
 	 * if the platform has an interrupt in mind for this device,
 	 * then by all means, set it
 	 */
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		rtc_read(RTC_CMD1);
 		if (request_irq(pdata->irq, ds1511_interrupt,
 			IRQF_DISABLED | IRQF_SHARED, pdev->name, pdev) < 0) {
 
 			dev_warn(&pdev->dev, "interrupt not available.\n");
-			pdata->irq = -1;
+			pdata->irq = 0;
 		}
 	}
 
@@ -572,7 +571,7 @@ ds1511_rtc_probe(struct platform_device *pdev)
 	if (pdata->rtc) {
 		rtc_device_unregister(pdata->rtc);
 	}
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		free_irq(pdata->irq, pdev);
 	}
 	if (ds1511_base) {
@@ -595,7 +594,7 @@ ds1511_rtc_remove(struct platform_device *pdev)
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
 	pdata->rtc = NULL;
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		/*
 		 * disable the alarm interrupt
 		 */
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index b9475cd..38d472b 100644
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
@@ -213,7 +213,7 @@ static int ds1553_rtc_ioctl(struct device *dev, unsigned int cmd,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -301,7 +301,6 @@ static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
 	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->irq = -1;
 	if (!request_mem_region(res->start, RTC_REG_SIZE, pdev->name)) {
 		ret = -EBUSY;
 		goto out;
@@ -327,13 +326,13 @@ static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_BLF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
-			pdata->irq = -1;
+			pdata->irq = 0;
 		}
 	}
 
@@ -353,7 +352,7 @@ static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -369,7 +368,7 @@ static int __devexit ds1553_rtc_remove(struct platform_device *pdev)
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 		free_irq(pdata->irq, pdev);
 	}
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 43afb7a..33921a6 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -450,7 +450,7 @@ static int __devinit m48t59_rtc_probe(struct platform_device *pdev)
 	 * the mode without IRQ.
 	 */
 	m48t59->irq = platform_get_irq(pdev, 0);
-	if (m48t59->irq < 0)
+	if (m48t59->irq <= 0)
 		m48t59->irq = NO_IRQ;
 
 	if (m48t59->irq != NO_IRQ) {
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index aaf9d6a..5ed66ac 100644
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
@@ -578,7 +580,7 @@ static int __devinit sh_rtc_probe(struct platform_device *pdev)
 
 	/* get periodic/carry/alarm irqs */
 	ret = platform_get_irq(pdev, 0);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for period\n");
 		goto err_badres;
@@ -586,7 +588,7 @@ static int __devinit sh_rtc_probe(struct platform_device *pdev)
 	rtc->periodic_irq = ret;
 
 	ret = platform_get_irq(pdev, 1);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for carry\n");
 		goto err_badres;
@@ -594,7 +596,7 @@ static int __devinit sh_rtc_probe(struct platform_device *pdev)
 	rtc->carry_irq = ret;
 
 	ret = platform_get_irq(pdev, 2);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for alarm\n");
 		goto err_badres;
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index f4cd46e..dc0b622 100644
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
@@ -221,7 +221,7 @@ static int stk17ta8_rtc_ioctl(struct device *dev, unsigned int cmd,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -303,7 +303,6 @@ static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
 	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->irq = -1;
 	if (!request_mem_region(res->start, RTC_REG_SIZE, pdev->name)) {
 		ret = -EBUSY;
 		goto out;
@@ -329,13 +328,13 @@ static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_PF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, stk17ta8_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
-			pdata->irq = -1;
+			pdata->irq = 0;
 		}
 	}
 
@@ -355,7 +354,7 @@ static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -371,7 +370,7 @@ static int __devexit stk17ta8_rtc_remove(struct platform_device *pdev)
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 		free_irq(pdata->irq, pdev);
 	}
diff --git a/drivers/rtc/rtc-twl4030.c b/drivers/rtc/rtc-twl4030.c
index abe87a4..3952d91 100644
--- a/drivers/rtc/rtc-twl4030.c
+++ b/drivers/rtc/rtc-twl4030.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -415,8 +416,8 @@ static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
 	int irq = platform_get_irq(pdev, 0);
 	u8 rd_reg;
 
-	if (irq < 0)
-		return irq;
+	if (irq <= 0)
+		return -EINVAL;
 
 	rtc = rtc_device_register(pdev->name,
 				  &pdev->dev, &twl4030_rtc_ops, THIS_MODULE);
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 834dcc6..57b7aac 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -84,8 +84,8 @@ static DEFINE_SPINLOCK(rtc_lock);
 static char rtc_name[] = "RTC";
 static unsigned long periodic_count;
 static unsigned int alarm_enabled;
-static int aie_irq = -1;
-static int pie_irq = -1;
+static int aie_irq;
+static int pie_irq;
 
 static inline unsigned long read_elapsed_second(void)
 {
@@ -360,7 +360,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 	spin_unlock_irq(&rtc_lock);
 
 	aie_irq = platform_get_irq(pdev, 0);
-	if (aie_irq < 0 || aie_irq >= nr_irqs) {
+	if (aie_irq <= 0) {
 		retval = -EBUSY;
 		goto err_device_unregister;
 	}
@@ -371,7 +371,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq < 0 || pie_irq >= nr_irqs)
+	if (pie_irq <= 0)
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
-- 
1.5.6.3
