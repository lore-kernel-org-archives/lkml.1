Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYLNLfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYLNLfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYLNLf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:35:26 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34170 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbYLNLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:35:25 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH 4/7] rtc: PCF50633 rtc driver
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <a.zummo@towertech.it>
Date: Sun, 14 Dec 2008 16:33:05 +0530
Message-ID: <20081214110304.3307.53502.stgit@cff.thadambail>
In-Reply-To: <20081214110152.3307.50843.stgit@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <a.zummo@towertech.it>
---
 drivers/rtc/Kconfig        |    6 +
 drivers/rtc/Makefile       |    1 
 drivers/rtc/rtc-pcf50633.c |  302 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 309 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-pcf50633.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 123092d..68e68d2 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -497,6 +497,12 @@ config RTC_DRV_WM8350
 	  This driver can also be built as a module. If so, the module
 	  will be called "rtc-wm8350".
 
+config RTC_DRV_PCF50633
+	depends on MFD_PCF50633
+	tristate "NXP PCF50633 RTC"
+	help
+	  If you say yes here you get support for the NXP PCF50633 RTC.
+
 comment "on-CPU RTC drivers"
 
 config RTC_DRV_OMAP
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 6e79c91..a717fec 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -70,3 +70,4 @@ obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
 obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
 obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
+obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
new file mode 100644
index 0000000..f314810
--- /dev/null
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -0,0 +1,302 @@
+/* NXP PCF50633 RTC Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+#include <linux/bcd.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/rtc.h>
+
+enum pcf50633_time_indexes {
+	PCF50633_TI_SEC,
+	PCF50633_TI_MIN,
+	PCF50633_TI_HOUR,
+	PCF50633_TI_WKDAY,
+	PCF50633_TI_DAY,
+	PCF50633_TI_MONTH,
+	PCF50633_TI_YEAR,
+	PCF50633_TI_EXTENT /* always last */
+};
+
+
+struct pcf50633_time {
+	u_int8_t time[PCF50633_TI_EXTENT];
+};
+
+static void pcf2rtc_time(struct rtc_time *rtc, struct pcf50633_time *pcf)
+{
+	rtc->tm_sec = bcd2bin(pcf->time[PCF50633_TI_SEC]);
+	rtc->tm_min = bcd2bin(pcf->time[PCF50633_TI_MIN]);
+	rtc->tm_hour = bcd2bin(pcf->time[PCF50633_TI_HOUR]);
+	rtc->tm_wday = bcd2bin(pcf->time[PCF50633_TI_WKDAY]);
+	rtc->tm_mday = bcd2bin(pcf->time[PCF50633_TI_DAY]);
+	rtc->tm_mon = bcd2bin(pcf->time[PCF50633_TI_MONTH]);
+	rtc->tm_year = bcd2bin(pcf->time[PCF50633_TI_YEAR]) + 100;
+}
+
+static void rtc2pcf_time(struct pcf50633_time *pcf, struct rtc_time *rtc)
+{
+	pcf->time[PCF50633_TI_SEC] = bin2bcd(rtc->tm_sec);
+	pcf->time[PCF50633_TI_MIN] = bin2bcd(rtc->tm_min);
+	pcf->time[PCF50633_TI_HOUR] = bin2bcd(rtc->tm_hour);
+	pcf->time[PCF50633_TI_WKDAY] = bin2bcd(rtc->tm_wday);
+	pcf->time[PCF50633_TI_DAY] = bin2bcd(rtc->tm_mday);
+	pcf->time[PCF50633_TI_MONTH] = bin2bcd(rtc->tm_mon);
+	pcf->time[PCF50633_TI_YEAR] = bin2bcd(rtc->tm_year - 100);
+}
+
+static int
+pcf50633_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	struct pcf50633 *pcf;
+
+	pcf = dev_get_drvdata(dev);
+
+	switch (cmd) {
+	case RTC_AIE_OFF:
+		pcf->rtc.alarm_enabled = 0;
+		pcf50633_irq_mask(pcf, PCF50633_IRQ_ALARM);
+		return 0;
+	case RTC_AIE_ON:
+		pcf->rtc.alarm_enabled = 1;
+		pcf50633_irq_unmask(pcf, PCF50633_IRQ_ALARM);
+		return 0;
+	case RTC_PIE_OFF:
+		pcf->rtc.second_enabled = 0;
+		pcf50633_irq_mask(pcf, PCF50633_IRQ_SECOND);
+		return 0;
+	case RTC_PIE_ON:
+		pcf->rtc.second_enabled = 1;
+		pcf50633_irq_unmask(pcf, PCF50633_IRQ_SECOND);
+		return 0;
+	}
+
+	return -ENOIOCTLCMD;
+}
+
+static int pcf50633_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct pcf50633 *pcf;
+	struct pcf50633_time pcf_tm;
+	int ret;
+
+	pcf = dev_get_drvdata(dev);
+
+	ret = pcf50633_read_block(pcf, PCF50633_REG_RTCSC,
+					    PCF50633_TI_EXTENT,
+					    &pcf_tm.time[0]);
+	if (ret != PCF50633_TI_EXTENT)
+		dev_err(dev, "Failed to read time\n");
+
+	dev_dbg(dev, "PCF_TIME: %02x.%02x.%02x %02x:%02x:%02x\n",
+		pcf_tm.time[PCF50633_TI_DAY],
+		pcf_tm.time[PCF50633_TI_MONTH],
+		pcf_tm.time[PCF50633_TI_YEAR],
+		pcf_tm.time[PCF50633_TI_HOUR],
+		pcf_tm.time[PCF50633_TI_MIN],
+		pcf_tm.time[PCF50633_TI_SEC]);
+
+	pcf2rtc_time(tm, &pcf_tm);
+
+	dev_dbg(dev, "RTC_TIME: %u.%u.%u %u:%u:%u\n",
+		tm->tm_mday, tm->tm_mon, tm->tm_year,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	return 0;
+}
+
+static int pcf50633_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct pcf50633 *pcf;
+	struct pcf50633_time pcf_tm;
+	int second_masked, alarm_masked, ret = 0;
+
+	pcf = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "RTC_TIME: %u.%u.%u %u:%u:%u\n",
+		tm->tm_mday, tm->tm_mon, tm->tm_year,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	rtc2pcf_time(&pcf_tm, tm);
+
+	dev_dbg(dev, "PCF_TIME: %02x.%02x.%02x %02x:%02x:%02x\n",
+		pcf_tm.time[PCF50633_TI_DAY],
+		pcf_tm.time[PCF50633_TI_MONTH],
+		pcf_tm.time[PCF50633_TI_YEAR],
+		pcf_tm.time[PCF50633_TI_HOUR],
+		pcf_tm.time[PCF50633_TI_MIN],
+		pcf_tm.time[PCF50633_TI_SEC]);
+
+
+	second_masked = pcf50633_irq_mask_get(pcf, PCF50633_IRQ_SECOND);
+	alarm_masked = pcf50633_irq_mask_get(pcf, PCF50633_IRQ_ALARM);
+
+	if (!second_masked)
+		pcf50633_irq_mask(pcf, PCF50633_IRQ_SECOND);
+	if (!alarm_masked)
+		pcf50633_irq_mask(pcf, PCF50633_IRQ_ALARM);
+
+	ret = pcf50633_write_block(pcf, PCF50633_REG_RTCSC,
+					     PCF50633_TI_EXTENT,
+					     &pcf_tm.time[0]);
+	if (ret)
+		dev_err(dev, "Failed to set time %d\n", ret);
+
+	if (!second_masked)
+		pcf50633_irq_unmask(pcf, PCF50633_IRQ_SECOND);
+	if (!alarm_masked)
+		pcf50633_irq_unmask(pcf, PCF50633_IRQ_ALARM);
+
+	return ret;
+}
+
+static int pcf50633_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct pcf50633 *pcf;
+	struct pcf50633_time pcf_tm;
+	int ret = 0;
+
+	pcf = dev_get_drvdata(dev);
+
+	alrm->enabled = pcf->rtc.alarm_enabled;
+
+	ret = pcf50633_read_block(pcf, PCF50633_REG_RTCSCA,
+				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
+
+	if (ret != PCF50633_TI_EXTENT)
+		dev_err(dev, "Failed to read Alarm time %d\n", ret);
+
+	pcf2rtc_time(&alrm->time, &pcf_tm);
+
+	return ret;
+}
+
+static int pcf50633_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct pcf50633 *pcf;
+	struct pcf50633_time pcf_tm;
+	int alarm_masked, ret = 0;
+
+	pcf = dev_get_drvdata(dev);
+
+	rtc2pcf_time(&pcf_tm, &alrm->time);
+
+	/* do like mktime does and ignore tm_wday */
+	pcf_tm.time[PCF50633_TI_WKDAY] = 7;
+
+	alarm_masked = pcf50633_irq_mask_get(pcf, PCF50633_IRQ_ALARM);
+
+	/* disable alarm interrupt */
+	if (!alarm_masked)
+		pcf50633_irq_mask(pcf, PCF50633_IRQ_ALARM);
+
+	ret = pcf50633_write_block(pcf, PCF50633_REG_RTCSCA,
+					PCF50633_TI_EXTENT, &pcf_tm.time[0]);
+	if (ret)
+		dev_err(dev, "Failed to write alarm time  %d\n", ret);
+
+	if (!alarm_masked)
+		pcf50633_irq_unmask(pcf, PCF50633_IRQ_ALARM);
+
+	return ret;
+}
+static struct rtc_class_ops pcf50633_rtc_ops = {
+	.ioctl		= pcf50633_rtc_ioctl,
+	.read_time	= pcf50633_rtc_read_time,
+	.set_time	= pcf50633_rtc_set_time,
+	.read_alarm	= pcf50633_rtc_read_alarm,
+	.set_alarm	= pcf50633_rtc_set_alarm,
+};
+
+static void pcf50633_rtc_irq(struct pcf50633 *pcf, int irq, void *unused)
+{
+	switch (irq) {
+	case PCF50633_IRQ_ALARM:
+		rtc_update_irq(pcf->rtc.rtc_dev, 1, RTC_AF | RTC_IRQF);
+		break;
+	case PCF50633_IRQ_SECOND:
+		rtc_update_irq(pcf->rtc.rtc_dev, 1, RTC_PF | RTC_IRQF);
+		break;
+	}
+}
+
+static int pcf50633_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc;
+	struct pcf50633 *pcf;
+
+	rtc = rtc_device_register("pcf50633-rtc", &pdev->dev,
+					&pcf50633_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return -ENODEV;
+
+	pcf = platform_get_drvdata(pdev);
+
+	/* Set up IRQ handlers */
+	pcf->irq_handler[PCF50633_IRQ_ALARM].handler = pcf50633_rtc_irq;
+	pcf->irq_handler[PCF50633_IRQ_SECOND].handler = pcf50633_rtc_irq;
+
+	pcf->rtc.rtc_dev = rtc;
+
+	return 0;
+}
+
+static int pcf50633_rtc_remove(struct platform_device *pdev)
+{
+	struct pcf50633 *pcf;
+
+	pcf = platform_get_drvdata(pdev);
+	rtc_device_unregister(pcf->rtc.rtc_dev);
+
+	return 0;
+}
+
+
+static struct platform_driver pcf50633_rtc_driver = {
+	.driver = {
+		.name = "pcf50633-rtc",
+	},
+	.probe = pcf50633_rtc_probe,
+	.remove = __devexit_p(pcf50633_rtc_remove),
+};
+
+static int __init pcf50633_rtc_init(void)
+{
+	return platform_driver_register(&pcf50633_rtc_driver);
+}
+module_init(pcf50633_rtc_init);
+
+static void __exit pcf50633_rtc_exit(void)
+{
+	platform_driver_unregister(&pcf50633_rtc_driver);
+}
+module_exit(pcf50633_rtc_exit);
+
+
+MODULE_DESCRIPTION("PCF50633 RTC driver");
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_LICENSE("GPL");
+

