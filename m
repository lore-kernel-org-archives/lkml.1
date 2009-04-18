Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbZDRS5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbZDRS5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbZDRSwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:52:55 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:45710 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030AbZDRSwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:52:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, rtc-linux@googlegroups.com
Subject: [PATCH/RFC 14/16] rtc: Add an RTC driver for the Oki MSM6242
Date: Sat, 18 Apr 2009 20:52:22 +0200
Message-Id: <1240080744-14995-15-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240080744-14995-14-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-3-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-4-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-5-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-6-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-7-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-8-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-9-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-10-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-11-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-12-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-13-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-14-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/Kconfig       |    9 ++
 drivers/rtc/Makefile      |    1 +
 drivers/rtc/rtc-msm6242.c |  285 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 295 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-msm6242.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index ffe34a1..a0f6297 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -526,6 +526,15 @@ config RTC_DRV_PCF50633
 	  If you say yes here you get support for the RTC subsystem of the
 	  NXP PCF50633 used in embedded systems.
 
+config RTC_DRV_MSM6242
+	tristate "Oki MSM6242"
+	help
+	  If you say yes here you get support for the Oki MSM6242
+	  timekeeping chip. It is used in some Amiga models (e.g. A2000).
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-msm6242.
+
 comment "on-CPU RTC drivers"
 
 config RTC_DRV_OMAP
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 6c0639a..c70418b 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -76,4 +76,5 @@ obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
 obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
+obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
 obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
new file mode 100644
index 0000000..c3af4f8
--- /dev/null
+++ b/drivers/rtc/rtc-msm6242.c
@@ -0,0 +1,285 @@
+/*
+ *  Oki MSM6242 RTC Driver
+ *
+ *  Copyright 2009 Geert Uytterhoeven
+ *
+ *  Based on the A2000 TOD code in arch/m68k/amiga/config.c
+ *  Copyright (C) 1993 Hamish Macdonald
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+
+
+enum {
+	MSM6242_SECOND1		= 0x0,	/* 1-second digit register */
+	MSM6242_SECOND10	= 0x1,	/* 10-second digit register */
+	MSM6242_MINUTE1		= 0x2,	/* 1-minute digit register */
+	MSM6242_MINUTE10	= 0x3,	/* 10-minute digit register */
+	MSM6242_HOUR1		= 0x4,	/* 1-hour digit register */
+	MSM6242_HOUR10		= 0x5,	/* PM/AM, 10-hour digit register */
+	MSM6242_DAY1		= 0x6,	/* 1-day digit register */
+	MSM6242_DAY10		= 0x7,	/* 10-day digit register */
+	MSM6242_MONTH1		= 0x8,	/* 1-month digit register */
+	MSM6242_MONTH10		= 0x9,	/* 10-month digit register */
+	MSM6242_YEAR1		= 0xa,	/* 1-year digit register */
+	MSM6242_YEAR10		= 0xb,	/* 10-year digit register */
+	MSM6242_WEEK		= 0xc,	/* Week register */
+	MSM6242_CD		= 0xd,	/* Control Register D */
+	MSM6242_CE		= 0xe,	/* Control Register E */
+	MSM6242_CF		= 0xf,	/* Control Register F */
+};
+
+#define MSM6242_HOUR10_AM	(0 << 2)
+#define MSM6242_HOUR10_PM	(1 << 2)
+#define MSM6242_HOUR10_HR_MASK	(3 << 0)
+
+#define MSM6242_WEEK_SUNDAY	0
+#define MSM6242_WEEK_MONDAY	1
+#define MSM6242_WEEK_TUESDAY	2
+#define MSM6242_WEEK_WEDNESDAY	3
+#define MSM6242_WEEK_THURSDAY	4
+#define MSM6242_WEEK_FRIDAY	5
+#define MSM6242_WEEK_SATURDAY	6
+
+#define MSM6242_CD_30_S_ADJ	(1 << 3)	/* 30-second adjustment */
+#define MSM6242_CD_IRQ_FLAG	(1 << 2)
+#define MSM6242_CD_BUSY		(1 << 1)
+#define MSM6242_CD_HOLD		(1 << 0)
+
+#define MSM6242_CE_T_MASK	(3 << 2)
+#define MSM6242_CE_T_64HZ	(0 << 2)	/* period 1/64 second */
+#define MSM6242_CE_T_1HZ	(1 << 2)	/* period 1 second */
+#define MSM6242_CE_T_1MINUTE	(2 << 2)	/* period 1 minute */
+#define MSM6242_CE_T_1HOUR	(3 << 2)	/* period 1 hour */
+
+#define MSM6242_CE_ITRPT_STND	(1 << 1)
+#define MSM6242_CE_MASK		(1 << 0)	/* STD.P output control */
+
+#define MSM6242_CF_TEST		(1 << 3)
+#define MSM6242_CF_12H		(0 << 2)
+#define MSM6242_CF_24H		(1 << 2)
+#define MSM6242_CF_STOP		(1 << 1)
+#define MSM6242_CF_REST		(1 << 0)	/* reset */
+
+
+struct msm6242_priv {
+	u32 __iomem *regs;
+	struct rtc_device *rtc;
+};
+
+static inline unsigned int msm6242_read(struct msm6242_priv *priv,
+				       unsigned int reg)
+{
+	return __raw_readl(&priv->regs[reg]) & 0xf;
+}
+
+static inline void msm6242_write(struct msm6242_priv *priv, unsigned int val,
+				unsigned int reg)
+{
+	return __raw_writel(val, &priv->regs[reg]);
+}
+
+static inline void msm6242_set(struct msm6242_priv *priv, unsigned int val,
+			       unsigned int reg)
+{
+	msm6242_write(priv, msm6242_read(priv, reg) | val, reg);
+}
+
+static inline void msm6242_clear(struct msm6242_priv *priv, unsigned int val,
+				 unsigned int reg)
+{
+	msm6242_write(priv, msm6242_read(priv, reg) & ~val, reg);
+}
+
+static void msm6242_lock(struct msm6242_priv *priv)
+{
+	int cnt = 5;
+
+	msm6242_set(priv, MSM6242_CD_HOLD, MSM6242_CD);
+
+	while ((msm6242_read(priv, MSM6242_CD) & MSM6242_CD_BUSY) && cnt--) {
+		msm6242_clear(priv, MSM6242_CD_HOLD, MSM6242_CD);
+		udelay(70);
+		msm6242_set(priv, MSM6242_CD_HOLD, MSM6242_CD);
+	}
+
+	if (!cnt)
+		pr_warning("msm6242: timed out waiting for RTC (0x%x)\n",
+			   msm6242_read(priv, MSM6242_CD));
+}
+
+static void msm6242_unlock(struct msm6242_priv *priv)
+{
+	msm6242_clear(priv, MSM6242_CD_HOLD, MSM6242_CD);
+}
+
+static int msm6242_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct msm6242_priv *priv = dev_get_drvdata(dev);
+
+	msm6242_lock(priv);
+
+	tm->tm_sec  = msm6242_read(priv, MSM6242_SECOND10) * 10 +
+		      msm6242_read(priv, MSM6242_SECOND1);
+	tm->tm_min  = msm6242_read(priv, MSM6242_MINUTE10) * 10 +
+		      msm6242_read(priv, MSM6242_MINUTE1);
+	tm->tm_hour = (msm6242_read(priv, MSM6242_HOUR10 & 3)) * 10 +
+		      msm6242_read(priv, MSM6242_HOUR1);
+	tm->tm_mday = msm6242_read(priv, MSM6242_DAY10) * 10 +
+		      msm6242_read(priv, MSM6242_DAY1);
+	tm->tm_wday = msm6242_read(priv, MSM6242_WEEK);
+	tm->tm_mon  = msm6242_read(priv, MSM6242_MONTH10) * 10 +
+		      msm6242_read(priv, MSM6242_MONTH1) - 1;
+	tm->tm_year = msm6242_read(priv, MSM6242_YEAR10) * 10 +
+		      msm6242_read(priv, MSM6242_YEAR1);
+	if (tm->tm_year <= 69)
+		tm->tm_year += 100;
+
+	if (!(msm6242_read(priv, MSM6242_CF) & MSM6242_CF_24H)) {
+		unsigned int pm = msm6242_read(priv, MSM6242_HOUR10) &
+				  MSM6242_HOUR10_PM;
+		if (!pm && tm->tm_hour == 12)
+			tm->tm_hour = 0;
+		else if (pm && tm->tm_hour != 12)
+			tm->tm_hour += 12;
+	}
+
+	msm6242_unlock(priv);
+
+	return rtc_valid_tm(tm);
+}
+
+static int msm6242_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct msm6242_priv *priv = dev_get_drvdata(dev);
+
+	msm6242_lock(priv);
+
+	msm6242_write(priv, tm->tm_sec / 10, MSM6242_SECOND10);
+	msm6242_write(priv, tm->tm_sec % 10, MSM6242_SECOND1);
+	msm6242_write(priv, tm->tm_min / 10, MSM6242_MINUTE10);
+	msm6242_write(priv, tm->tm_min % 10, MSM6242_MINUTE1);
+	if (msm6242_read(priv, MSM6242_CF) & MSM6242_CF_24H)
+		msm6242_write(priv, tm->tm_hour / 10, MSM6242_HOUR10);
+	else if (tm->tm_hour >= 12)
+		msm6242_write(priv, MSM6242_HOUR10_PM + (tm->tm_hour - 12) / 10,
+			      MSM6242_HOUR10);
+	else
+		msm6242_write(priv, tm->tm_hour / 10, MSM6242_HOUR10);
+	msm6242_write(priv, tm->tm_hour % 10, MSM6242_HOUR1);
+	msm6242_write(priv, tm->tm_mday / 10, MSM6242_DAY10);
+	msm6242_write(priv, tm->tm_mday % 10, MSM6242_DAY1);
+	if (tm->tm_wday != -1)
+		msm6242_write(priv, tm->tm_wday, MSM6242_WEEK);
+	msm6242_write(priv, (tm->tm_mon + 1) / 10, MSM6242_MONTH10);
+	msm6242_write(priv, (tm->tm_mon + 1) % 10, MSM6242_MONTH1);
+	if (tm->tm_year >= 100)
+		tm->tm_year -= 100;
+	msm6242_write(priv, tm->tm_year / 10, MSM6242_YEAR10);
+	msm6242_write(priv, tm->tm_year % 10, MSM6242_YEAR1);
+
+	msm6242_unlock(priv);
+	return 0;
+}
+
+static int msm6242_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct msm6242_priv *priv = dev_get_drvdata(dev);
+	unsigned int real_seconds = secs % 60, real_minutes = (secs / 60) % 60;
+
+	msm6242_lock(priv);
+
+	msm6242_write(priv, real_seconds / 10, MSM6242_SECOND10);
+	msm6242_write(priv, real_seconds % 10, MSM6242_SECOND1);
+	msm6242_write(priv, real_minutes / 10, MSM6242_MINUTE10);
+	msm6242_write(priv, real_minutes % 10, MSM6242_MINUTE1);
+
+	msm6242_unlock(priv);
+	return 0;
+}
+
+static const struct rtc_class_ops msm6242_rtc_ops = {
+	.read_time	= msm6242_read_time,
+	.set_time	= msm6242_set_time,
+	.set_mmss	= msm6242_set_mmss,
+};
+
+static int __init msm6242_rtc_probe(struct platform_device *dev)
+{
+	struct resource *res;
+	struct msm6242_priv *priv;
+	struct rtc_device *rtc;
+	int error;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->regs = ioremap(res->start, resource_size(res));
+	if (!priv->regs) {
+		error = -ENOMEM;
+		goto out_free_priv;
+	}
+
+	rtc = rtc_device_register("rtc-msm6242", &dev->dev, &msm6242_rtc_ops,
+				  THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		error = PTR_ERR(rtc);
+		goto out_unmap;
+	}
+
+	priv->rtc = rtc;
+	platform_set_drvdata(dev, priv);
+	return 0;
+
+out_unmap:
+	iounmap(priv->regs);
+out_free_priv:
+	kfree(priv);
+	return error;
+}
+
+static int __exit msm6242_rtc_remove(struct platform_device *dev)
+{
+	struct msm6242_priv *priv = platform_get_drvdata(dev);
+
+	rtc_device_unregister(priv->rtc);
+	iounmap(priv->regs);
+	kfree(priv);
+	return 0;
+}
+
+static struct platform_driver msm6242_rtc_driver = {
+	.driver	= {
+		.name	= "rtc-msm6242",
+		.owner	= THIS_MODULE,
+	},
+	.remove	= __exit_p(msm6242_rtc_remove),
+};
+
+static int __init msm6242_rtc_init(void)
+{
+	return platform_driver_probe(&msm6242_rtc_driver, msm6242_rtc_probe);
+}
+
+static void __exit msm6242_rtc_fini(void)
+{
+	platform_driver_unregister(&msm6242_rtc_driver);
+}
+
+module_init(msm6242_rtc_init);
+module_exit(msm6242_rtc_fini);
+
+MODULE_AUTHOR("Geert Uytterhoeven");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Oki MSM6242 RTC driver");
+MODULE_ALIAS("platform:rtc-msm6242");
-- 
1.6.2.3

