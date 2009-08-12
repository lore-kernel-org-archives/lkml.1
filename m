Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZHLPKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZHLPKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHLPKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:10:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55453 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbZHLPKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:10:13 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 4/5] [RTC] Add Freescale MC13783 RTC driver
Date: Wed, 12 Aug 2009 17:05:30 +0200
Message-Id: <1250089531-10399-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides support for the RTC part integrated into
the Freescale MC13783 PMIC.

changes since v1:

- use set_mmss instead of set_time
- fix __devinit / __devexit usage
- use platform_driver_probe instead of platform_driver_register
- add MODULE_ALIAS

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/Kconfig       |    6 ++
 drivers/rtc/Makefile      |    1 +
 drivers/rtc/rtc-mc13783.c |  135 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-mc13783.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 81adbdb..e4a242f 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -759,4 +759,10 @@ config RTC_DRV_PS3
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ps3.
 
+config RTC_DRV_MC13783
+	depends on MFD_MC13783
+	tristate "Freescale MC13783 RTC"
+	help
+	  This enables support for the Freescale MC13783 PMIC RTC
+
 endif # RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 3c0f2b2..0c2cea6 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_RTC_DRV_SUN4V)	+= rtc-sun4v.o
 obj-$(CONFIG_RTC_DRV_STARFIRE)	+= rtc-starfire.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
+obj-$(CONFIG_RTC_DRV_MC13783)	+= rtc-mc13783.o
 obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
new file mode 100644
index 0000000..dfa4702
--- /dev/null
+++ b/drivers/rtc/rtc-mc13783.c
@@ -0,0 +1,135 @@
+/*
+ * Real Time Clock driver for Freescale MC13783 PMIC
+ *
+ * (C) 2009 Sascha Hauer, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/mfd/mc13783-private.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
+
+struct mc13783_rtc {
+	struct rtc_device *rtc;
+	struct mc13783 *mc13783;
+};
+
+static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	unsigned int seconds, days;
+
+	seconds = secs % 86400;
+	days = secs / 86400;
+
+	mc13783_reg_write(priv->mc13783, MC13783_REG_RTC_TIME, seconds);
+	mc13783_reg_write(priv->mc13783, MC13783_REG_RTC_DAY, days);
+
+	return 0;
+}
+
+static int mc13783_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct mc13783_rtc *priv = dev_get_drvdata(dev);
+	unsigned int seconds, days1, days2;
+	unsigned long s1970;
+
+	rtc_tm_to_time(tm, &s1970);
+
+	do {
+		mc13783_reg_read(priv->mc13783, MC13783_REG_RTC_TIME, &seconds);
+		mc13783_reg_read(priv->mc13783, MC13783_REG_RTC_DAY, &days1);
+		mc13783_reg_read(priv->mc13783, MC13783_REG_RTC_DAY, &days2);
+	} while (days1 != days2);
+
+	s1970 = days1 * 86400 + seconds;
+
+	rtc_time_to_tm(s1970, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static const struct rtc_class_ops mc13783_rtc_ops = {
+	.read_time	= mc13783_rtc_read_time,
+	.set_mmss	= mc13783_rtc_set_mmss,
+};
+
+static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
+{
+	int err;
+	struct mc13783_rtc *priv;
+
+	priv = kzalloc(sizeof *priv, GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, priv);
+
+	priv->rtc = rtc_device_register(pdev->name,
+			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(priv->rtc)) {
+		err = PTR_ERR(priv->rtc);
+		goto exit_kfree;
+	}
+
+	return 0;
+
+exit_kfree:
+	kfree(priv);
+	return err;
+}
+
+static int __devexit mc13783_rtc_remove(struct platform_device *pdev)
+{
+	struct mc13783_rtc *priv = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(priv->rtc);
+	platform_set_drvdata(pdev, NULL);
+
+	kfree(priv);
+
+	return 0;
+}
+
+static struct platform_driver mc13783_rtc_driver = {
+	.remove		= __devexit_p(mc13783_rtc_remove),
+	.driver = {
+		.name	= "mc13783-rtc",
+		.owner	= THIS_MODULE,
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
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("RTC driver for Freescale MC13783 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mc13783-rtc");
-- 
1.6.3.3

