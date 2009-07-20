Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZGTNhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZGTNhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZGTNhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:37:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44108 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbZGTNhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:37:17 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Balaji T K <balajitk@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RFC][PATCH 2/4] OMAP4: PMIC: Add support for twl6030 RTC
Date: Mon, 20 Jul 2009 19:06:47 +0530
Message-Id: <1248097007-14699-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

This patch adds support for RTC in phoenix TWL6030.
Register offset addresses which have changed in TWL6030 are defined under
CONFIG_TWL6030_CORE and CONFIG_TWL4030_CORE.
rtc-twl.c will hence forth support all twl RTC (4030, 5030, 6030 ..)

Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/mfd/twl-core.c |    2 +-
 drivers/rtc/Kconfig    |    8 ++++----
 drivers/rtc/Makefile   |    2 +-
 drivers/rtc/rtc-twl.c  |   23 +++++++++++++++++++++++
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 7ee7a1e..cf4fec4 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -89,7 +89,7 @@
 #define twl_has_madc()	false
 #endif
 
-#if defined(CONFIG_RTC_DRV_TWL4030) || defined(CONFIG_RTC_DRV_TWL4030_MODULE)
+#if defined(CONFIG_RTC_DRV_TWL) || defined(CONFIG_RTC_DRV_TWL_MODULE)
 #define twl_has_rtc()	true
 #else
 #define twl_has_rtc()	false
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 81adbdb..89ccc93 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -257,15 +257,15 @@ config RTC_DRV_TWL92330
 	  platforms. The support is integrated with the rest of
 	  the Menelaus driver; it's not separate module.
 
-config RTC_DRV_TWL4030
-	tristate "TI TWL4030/TWL5030/TPS659x0"
-	depends on RTC_CLASS && TWL4030_CORE
+config RTC_DRV_TWL
+	tristate "TI TWL4030/TWL5030/TWL6030/TPS659x0"
+	depends on RTC_CLASS && (TWL4030_CORE || TWL6030_CORE)
 	help
 	  If you say yes here you get support for the RTC on the
 	  TWL4030 family chips, used mostly with OMAP3 platforms.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-twl4030.
+	  will be called twl-rtc.
 
 config RTC_DRV_S35390A
 	tristate "Seiko Instruments S-35390A"
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index e331b1c..c32e21d 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -70,7 +70,7 @@ obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
 obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
-obj-$(CONFIG_RTC_DRV_TWL4030)	+= rtc-twl.o
+obj-$(CONFIG_RTC_DRV_TWL)	+= rtc-twl.o
 obj-$(CONFIG_RTC_DRV_TX4939)	+= rtc-tx4939.o
 obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
 obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 630acb7..ff3842d 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -42,6 +42,7 @@
 #define REG_YEARS_REG                            0x05
 #define REG_WEEKS_REG                            0x06
 
+#ifdef CONFIG_TWL4030_CORE
 #define REG_ALARM_SECONDS_REG                    0x07
 #define REG_ALARM_MINUTES_REG                    0x08
 #define REG_ALARM_HOURS_REG                      0x09
@@ -55,6 +56,26 @@
 
 #define REG_RTC_COMP_LSB_REG                     0x10
 #define REG_RTC_COMP_MSB_REG                     0x11
+#endif
+
+#ifdef CONFIG_TWL6030_CORE
+#define REG_ALARM_SECONDS_REG		0x08
+#define REG_ALARM_MINUTES_REG		0x09
+#define REG_ALARM_HOURS_REG		0x0A
+#define REG_ALARM_DAYS_REG		0x0B
+#define REG_ALARM_MONTHS_REG		0x0C
+#define REG_ALARM_YEARS_REG		0x0D
+
+#define REG_RTC_CTRL_REG		0x10
+#define REG_RTC_STATUS_REG		0x11
+#define REG_RTC_INTERRUPTS_REG		0x12
+
+#define REG_RTC_COMP_LSB_REG		0x13
+#define REG_RTC_COMP_MSB_REG		0x14
+#define REG_RTC_RESET_STATUS_REG	0x16
+
+#define TWL_MODULE_RTC TWL6030_MODULE_RTC
+#endif
 
 /* RTC_CTRL_REG bitfields */
 #define BIT_RTC_CTRL_REG_STOP_RTC_M              0x01
@@ -352,6 +373,7 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	if (res)
 		goto out;
 
+#ifdef CONFIG_TWL4030_CORE
 	/* Clear on Read enabled. RTC_IT bit of TWL4030_INT_PWR_ISR1
 	 * needs 2 reads to clear the interrupt. One read is done in
 	 * do_twl_pwrirq(). Doing the second read, to clear
@@ -367,6 +389,7 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 			&rd_reg, TWL4030_INT_PWR_ISR1);
 	if (res)
 		goto out;
+#endif
 
 	/* Notify RTC core on event */
 	rtc_update_irq(rtc, 1, events);
-- 
1.5.4.7

