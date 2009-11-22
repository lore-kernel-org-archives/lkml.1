Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZKVSPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZKVSPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 13:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZKVSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 13:14:59 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38222 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZKVSO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 13:14:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JnwHVekWWCucfE8wAalWm6mMwChi28u1QFYTzdcGbFpB5MAmAz1ghe2rRIal5hFzCY
         0RP+sOEQ9Ex0lAYYbSjrUCYknaLQZg0Z8hbj4tFnRcWeB7rygIgwcuKtJQj7GOIQflGy
         rh50aPB7147yFIpkYe4NypDZd2SnLXsoh9rb4=
Message-ID: <4B097FA0.8040308@gmail.com>
Date: Mon, 23 Nov 2009 02:14:56 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-rtc <rtc-linux@googlegroups.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: NUC900: add rtc controller driver support for NUC900
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sirs,

This is a RTC driver patch support for NUC910 and NUC920 processors of Winbind/Nuvoton NUC900 ARM series.


Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/rtc/Kconfig      |    6 +
 drivers/rtc/Makefile     |    1 +
 drivers/rtc/rtc-nuc900.c |  347 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 354 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-nuc900.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 3c20dae..266ce62 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -573,6 +573,12 @@ config RTC_DRV_AB3100
 	  Select this to enable the ST-Ericsson AB3100 Mixed Signal IC RTC
 	  support. This chip contains a battery- and capacitor-backed RTC.
 
+config RTC_DRV_NUC900
+	tristate "NUC910/NUC920 RTC driver"
+	depends on RTC_CLASS && ARCH_W90X900
+	help
+	  If you say yes here you get support for the RTC subsystem of the
+	  NUC910/NUC920 used in embedded systems.
 
 comment "on-CPU RTC drivers"
 
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index aa3fbd5..6338887 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -85,3 +85,4 @@ obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
 obj-$(CONFIG_RTC_DRV_WM831X)	+= rtc-wm831x.o
 obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
+obj-$(CONFIG_RTC_DRV_NUC900)	+= rtc-nuc900.o
diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
new file mode 100644
index 0000000..5059fdc
--- /dev/null
+++ b/drivers/rtc/rtc-nuc900.c
@@ -0,0 +1,347 @@
+/*
+ * Copyright (c) 2008-2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/rtc.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/ioctl.h>
+#include <linux/io.h>
+#include <linux/bcd.h>
+
+/* RTC Control Registers */
+#define REG_RTC_INIR		0x00
+#define REG_RTC_AER		0x04
+#define REG_RTC_FCR		0x08
+#define REG_RTC_TLR		0x0C
+#define REG_RTC_CLR		0x10
+#define REG_RTC_TSSR		0x14
+#define REG_RTC_DWR		0x18
+#define REG_RTC_TAR		0x1C
+#define REG_RTC_CAR		0x20
+#define REG_RTC_LIR		0x24
+#define REG_RTC_RIER		0x28
+#define REG_RTC_RIIR		0x2C
+#define REG_RTC_TTR		0x30
+
+#define RTCSET			0x01
+#define AERRWENB		0x10000
+#define INIRRESET		0xa5eb1357
+#define AERPOWERON		0xA965
+#define AERPOWEROFF		0x0000
+#define LEAPYEAR		0x0001
+#define TICKENB			0x80
+#define TICKINTENB		0x0002
+#define ALARMINTENB		0x0001
+
+struct nuc900_rtc {
+	int			irq_num;
+	void __iomem		*rtc_reg;
+	struct rtc_device	*rtcdev;
+	spinlock_t		lock;
+};
+
+static const unsigned char days_in_mo[] = {
+0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
+};
+
+static irqreturn_t nuc900_rtc_interrupt(int irq, void *_rtc)
+{
+	struct nuc900_rtc *rtc = _rtc;
+	unsigned long events = 0, rtc_irq;
+
+	rtc_irq = __raw_readl(rtc->rtc_reg + REG_RTC_RIIR);
+
+	if (rtc_irq & ALARMINTENB) {
+		rtc_irq &= ~ALARMINTENB;
+		__raw_writel(rtc_irq, rtc->rtc_reg + REG_RTC_RIIR);
+		events |= RTC_AF | RTC_IRQF;
+	}
+
+	if (rtc_irq & TICKINTENB) {
+		rtc_irq &= ~TICKINTENB;
+		__raw_writel(rtc_irq, rtc->rtc_reg + REG_RTC_RIIR);
+		events |= RTC_UF | RTC_IRQF;
+	}
+
+	rtc_update_irq(rtc->rtcdev, 1, events);
+
+	return IRQ_HANDLED;
+}
+
+static void check_rtc_power(struct nuc900_rtc *nuc900_rtc)
+{
+	unsigned int i;
+	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);
+
+	mdelay(10);
+
+	__raw_writel(AERPOWERON, nuc900_rtc->rtc_reg + REG_RTC_AER);
+
+	for (i = 0; i < 1000000; i++) {
+		if (__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB)
+			break;
+	}
+}
+
+static void nuc900_rtc_decodetime(unsigned int timereg,
+				unsigned int calreg, struct rtc_time *tm)
+{
+	tm->tm_mday	= bcd2bin(calreg >> 0);
+	tm->tm_mon	= bcd2bin(calreg >> 8);
+	tm->tm_year	= bcd2bin(calreg >> 16) + 2000;
+
+	tm->tm_sec	= bcd2bin(timereg >> 0);
+	tm->tm_min	= bcd2bin(timereg >> 8);
+	tm->tm_hour	= bcd2bin(timereg >> 16);
+}
+
+static void nuc900_rtc_encodetime(struct rtc_time *settm,
+						struct rtc_time *gettm)
+{
+	gettm->tm_mday = bin2bcd((settm->tm_mday) << 0);
+	gettm->tm_mon  = bin2bcd((settm->tm_mon) << 8);
+	gettm->tm_year = bin2bcd((settm->tm_year) << 16) - 2000;
+
+	gettm->tm_sec  = bin2bcd((settm->tm_sec) << 0);
+	gettm->tm_min  = bin2bcd((settm->tm_min) << 8);
+	gettm->tm_hour = bin2bcd((settm->tm_hour) << 16);
+}
+
+static int nuc900_rtc_ioctl(struct device *dev, unsigned int cmd,
+		unsigned long arg)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	int ret = 0;
+	unsigned int val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	val = __raw_readl(rtc->rtc_reg + REG_RTC_RIER);
+
+	switch (cmd) {
+	case RTC_AIE_OFF:		/* alarm off */
+		val &= (~ALARMINTENB);
+		break;
+	case RTC_AIE_ON:		/* alarm on */
+		val |= ALARMINTENB;
+		break;
+	case RTC_UIE_OFF:		/* update off */
+		val &= (~TICKINTENB);
+		break;
+	case RTC_UIE_ON:		/* update on */
+		val |= TICKINTENB;
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_RIER);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	return ret;
+}
+
+static int nuc900_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	unsigned int timeval, clrval;
+
+	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TLR);
+	clrval	= __raw_readl(rtc->rtc_reg + REG_RTC_CLR);
+
+	nuc900_rtc_decodetime(timeval, clrval, tm);
+
+	return 0;
+}
+
+static int nuc900_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	struct rtc_time gettm;
+	unsigned char leap_yr;
+	unsigned long val;
+
+	nuc900_rtc_encodetime(tm, &gettm);
+
+	check_rtc_power(rtc);
+
+	leap_yr = __raw_readl(rtc->rtc_reg + REG_RTC_LIR) & LEAPYEAR;
+
+	if ((gettm.tm_mon > 12) || (gettm.tm_mday == 0))
+		return -EINVAL;
+	if (gettm.tm_mday > (days_in_mo[gettm.tm_mon] +
+					((gettm.tm_mon == 2) && leap_yr)))
+		return -EINVAL;
+	if ((gettm.tm_hour >= 24) || (gettm.tm_min >= 60) ||
+						(gettm.tm_sec >= 60))
+		return -EINVAL;
+
+	val = gettm.tm_mday | gettm.tm_mon | gettm.tm_year;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_CLR);
+
+	val = gettm.tm_sec | gettm.tm_min | gettm.tm_hour;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_TLR);
+
+	return 0;
+}
+
+static int nuc900_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	unsigned int timeval, carval;
+
+	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TAR);
+	carval	= __raw_readl(rtc->rtc_reg + REG_RTC_CAR);
+
+	nuc900_rtc_decodetime(timeval, carval, &alrm->time);
+
+	return 0;
+}
+
+static int nuc900_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	struct rtc_time tm;
+	unsigned long val;
+
+	nuc900_rtc_encodetime(&alrm->time, &tm);
+
+	check_rtc_power(rtc);
+
+	val = tm.tm_mday | tm.tm_mon | tm.tm_year;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_CAR);
+
+	val = tm.tm_sec | tm.tm_min | tm.tm_hour;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_TAR);
+
+	if (alrm->enabled) {
+		__raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)|
+			(ALARMINTENB), rtc->rtc_reg + REG_RTC_RIER);
+	}
+
+	return 0;
+}
+
+static struct rtc_class_ops nuc900_rtc_ops = {
+	.ioctl = nuc900_rtc_ioctl,
+	.read_time = nuc900_rtc_read_time,
+	.set_time = nuc900_rtc_set_time,
+	.read_alarm = nuc900_rtc_read_alarm,
+	.set_alarm = nuc900_rtc_set_alarm,
+};
+
+static int __devinit nuc900_rtc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct nuc900_rtc *nuc900_rtc;
+	int err;
+
+	nuc900_rtc = kzalloc(sizeof(struct nuc900_rtc), GFP_KERNEL);
+	if (!nuc900_rtc) {
+		err = -ENOMEM;
+		goto fail1;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -ENXIO;
+		goto fail1;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res),
+				pdev->name)) {
+		err = -EBUSY;
+		goto fail1;
+	}
+
+	nuc900_rtc->rtc_reg = ioremap(res->start, resource_size(res));
+	if (!nuc900_rtc->rtc_reg) {
+		err = -ENOMEM;
+		goto fail2;
+	}
+
+	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
+	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
+			IRQF_DISABLED, "nuc900rtc", nuc900_rtc)) {
+		err = -EBUSY;
+		goto fail3;
+	}
+
+	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
+						&nuc900_rtc_ops, THIS_MODULE);
+	if (IS_ERR(nuc900_rtc->rtcdev)) {
+		err = PTR_ERR(nuc900_rtc->rtcdev);
+		goto fail4;
+	}
+	platform_set_drvdata(pdev, nuc900_rtc->rtcdev);
+	spin_lock_init(&nuc900_rtc->lock);
+
+	return 0;
+
+fail4:	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+fail3:	iounmap(nuc900_rtc->rtc_reg);
+fail2:	release_mem_region(res->start, resource_size(res));
+fail1:	kfree(nuc900_rtc);
+	return err;
+}
+
+static int __devexit nuc900_rtc_remove(struct platform_device *pdev)
+{
+	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+	iounmap(nuc900_rtc->rtc_reg);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	rtc_device_unregister(nuc900_rtc->rtcdev);
+	kfree(nuc900_rtc);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver nuc900_rtc_driver = {
+	.probe		= nuc900_rtc_probe,
+	.remove		= __devexit_p(nuc900_rtc_remove),
+	.driver		= {
+		.name	= "nuc900-rtc",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init nuc900_rtc_init(void)
+{
+	return platform_driver_register(&nuc900_rtc_driver);
+}
+
+static void __exit nuc900_rtc_exit(void)
+{
+	platform_driver_unregister(&nuc900_rtc_driver);
+}
+
+module_init(nuc900_rtc_init);
+module_exit(nuc900_rtc_exit);
+
+MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
+MODULE_DESCRIPTION("nuc910/nuc920 RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:nuc900-rtc");
-- 
1.5.6.3
