Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZKJIdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZKJIdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZKJIdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:33:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60816 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZKJIdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:33:18 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH RESENT] [RTC] Add Freescale MC13783 RTC driver
Date: Tue, 10 Nov 2009 09:32:47 +0100
Message-Id: <1257841967-6084-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4AF2E9E7.9050807@epfl.ch>
References: <4AF2E9E7.9050807@epfl.ch>
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

This driver provides support for the RTC part integrated into the
Freescale MC13783 PMIC and bases on patch created earlier by Sascha
Hauer.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-könig@pengutronix.de>
Acked-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/Kconfig       |    6 +
 drivers/rtc/Makefile      |    1 +
 drivers/rtc/rtc-mc13783.c |  262 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 269 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-mc13783.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 3c20dae..7fa8db3 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -827,4 +827,10 @@ config RTC_DRV_PCAP
 	  If you say Y here you will get support for the RTC found on
 	  the PCAP2 ASIC used on some Motorola phones.
 
+config RTC_DRV_MC13783
+	depends on MFD_MC13783
+	tristate "Freescale MC13783 RTC"
+	help
+	  This enables support for the Freescale MC13783 PMIC RTC
+
 endif # RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index aa3fbd5..f4d01ba 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
+obj-$(CONFIG_RTC_DRV_MC13783)	+= rtc-mc13783.o
 obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCAP)	+= rtc-pcap.o
diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
new file mode 100644
index 0000000..850f983
--- /dev/null
+++ b/drivers/rtc/rtc-mc13783.c
@@ -0,0 +1,262 @@
+/*
+ * Real Time Clock driver for Freescale MC13783 PMIC
+ *
+ * (C) 2009 Sascha Hauer, Pengutronix
+ * (C) 2009 Uwe Kleine-Koenig, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mfd/mc13783.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
+
+#define DRIVER_NAME "mc13783-rtc"
+
+#define MC13783_RTCTOD	20
+#define MC13783_RTCTODA	21
+#define MC13783_RTCDAY	22
+#define MC13783_RTCDAYA	23
+
+struct mc13783_rtc {
+	struct rtc_device *rtc;
+	struct mc13783 *mc13783;
+	int valid;
+};
+
+static int mc13783_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	unsigned int seconds, days1, days2;
+	unsigned long s1970;
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	if (!priv->valid) {
+		ret = -ENODATA;
+		goto out;
+	}
+
+	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days1);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCTOD, &seconds);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days2);
+out:
+	mc13783_unlock(priv->mc13783);
+
+	if (ret)
+		return ret;
+
+	if (days2 == days1 + 1) {
+		if (seconds >= 86400 / 2)
+			days2 = days1;
+		else
+			days1 = days2;
+	}
+
+	if (days1 != days2)
+		return -EIO;
+
+	s1970 = days1 * 86400 + seconds;
+
+	rtc_time_to_tm(s1970, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	unsigned int seconds, days;
+	int ret;
+
+	seconds = secs % 86400;
+	days = secs / 86400;
+
+	mc13783_lock(priv->mc13783);
+
+	/*
+	 * first write seconds=0 to prevent a day switch between writing days
+	 * and seconds below
+	 */
+	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, 0);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCDAY, days);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, seconds);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_ackirq(priv->mc13783, MC13783_IRQ_RTCRST);
+	if (unlikely(ret))
+		goto out;
+
+	ret = mc13783_unmask(priv->mc13783, MC13783_IRQ_RTCRST);
+out:
+	priv->valid = !ret;
+
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
+{
+	struct mc13783_rtc *priv = dev;
+	struct mc13783 *mc13783 = priv->mc13783;
+
+	dev_dbg(&priv->rtc->dev, "1HZ\n");
+
+	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
+
+	mc13783_ackirq(mc13783, irq);
+
+	return IRQ_HANDLED;
+}
+
+static int mc13783_rtc_update_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	int ret = -ENODATA;
+
+	mc13783_lock(priv->mc13783);
+	if (!priv->valid)
+		goto out;
+
+	ret = (enabled ? mc13783_unmask : mc13783_mask)(priv->mc13783,
+			MC13783_IRQ_1HZ);
+out:
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static const struct rtc_class_ops mc13783_rtc_ops = {
+	.read_time = mc13783_rtc_read_time,
+	.set_mmss = mc13783_rtc_set_mmss,
+	.update_irq_enable = mc13783_rtc_update_irq_enable,
+};
+
+static irqreturn_t mc13783_rtc_reset_handler(int irq, void *dev)
+{
+	struct mc13783_rtc *priv = dev;
+	struct mc13783 *mc13783 = priv->mc13783;
+
+	dev_dbg(&priv->rtc->dev, "RTCRST\n");
+	priv->valid = 0;
+
+	mc13783_mask(mc13783, irq);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct mc13783_rtc *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, priv);
+
+	priv->valid = 1;
+
+	mc13783_lock(priv->mc13783);
+
+	ret = mc13783_irq_request(priv->mc13783, MC13783_IRQ_RTCRST,
+			mc13783_rtc_reset_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_reset_irq_request;
+
+	ret = mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
+			mc13783_rtc_update_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_update_irq_request;
+
+	mc13783_unlock(priv->mc13783);
+
+	priv->rtc = rtc_device_register(pdev->name,
+			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(priv->rtc)) {
+		ret = PTR_ERR(priv->rtc);
+
+		mc13783_lock(priv->mc13783);
+
+		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
+err_update_irq_request:
+
+		mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
+err_reset_irq_request:
+
+		mc13783_unlock(priv->mc13783);
+
+		platform_set_drvdata(pdev, NULL);
+		kfree(priv);
+	}
+
+	return ret;
+}
+
+static int __devexit mc13783_rtc_remove(struct platform_device *pdev)
+{
+	struct mc13783_rtc *priv = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(priv->rtc);
+
+	mc13783_lock(priv->mc13783);
+
+	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
+	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
+
+	mc13783_unlock(priv->mc13783);
+
+	platform_set_drvdata(pdev, NULL);
+
+	kfree(priv);
+
+	return 0;
+}
+
+static struct platform_driver mc13783_rtc_driver = {
+	.remove = __devexit_p(mc13783_rtc_remove),
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init mc13783_rtc_init(void)
+{
+	return platform_driver_probe(&mc13783_rtc_driver, &mc13783_rtc_probe);
+}
+module_init(mc13783_rtc_init);
+
+static void __exit mc13783_rtc_exit(void)
+{
+	platform_driver_unregister(&mc13783_rtc_driver);
+}
+module_exit(mc13783_rtc_exit);
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("RTC driver for Freescale MC13783 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.6.5.2

