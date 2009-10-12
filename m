Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbZJLPP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbZJLPP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbZJLPPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:15:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33259 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932560AbZJLPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:15:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Convert WM835x IRQ handling to use a data table
Date: Mon, 12 Oct 2009 16:15:10 +0100
Message-Id: <1255360510-20690-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255360510-20690-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1255360510-20690-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than open coding individual IRQs in each function which
manipulates them store data for IRQs in a table which is then
referenced in the users.

This is a substantial code shrink and should be a performance win in
cases where only a single IRQ goes off at once since instead of
reading four of the second level IRQ registers for each interrupt
we read only the sub-registers which have had an interrupt flagged.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-irq.c        | 1017 ++++++++++++++-------------------------
 include/linux/mfd/wm8350/gpio.h |   18 +
 2 files changed, 387 insertions(+), 648 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index a432e2b..d9abfc9 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -29,6 +29,343 @@
 #include <linux/mfd/wm8350/supply.h>
 #include <linux/mfd/wm8350/wdt.h>
 
+#define WM8350_NUM_IRQ_REGS 7
+
+#define WM8350_INT_OFFSET_1                     0
+#define WM8350_INT_OFFSET_2                     1
+#define WM8350_POWER_UP_INT_OFFSET              2
+#define WM8350_UNDER_VOLTAGE_INT_OFFSET         3
+#define WM8350_OVER_CURRENT_INT_OFFSET          4
+#define WM8350_GPIO_INT_OFFSET                  5
+#define WM8350_COMPARATOR_INT_OFFSET            6
+
+struct wm8350_irq_data {
+	int primary;
+	int reg;
+	int mask;
+	int primary_only;
+};
+
+static struct wm8350_irq_data wm8350_irqs[] = {
+	[WM8350_IRQ_OC_LS] = {
+		.primary = WM8350_OC_INT,
+		.reg = WM8350_OVER_CURRENT_INT_OFFSET,
+		.mask = WM8350_OC_LS_EINT,
+		.primary_only = 1,
+	},
+	[WM8350_IRQ_UV_DC1] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_DC1_EINT,
+	},
+	[WM8350_IRQ_UV_DC2] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_DC2_EINT,
+	},
+	[WM8350_IRQ_UV_DC3] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_DC3_EINT,
+	},
+	[WM8350_IRQ_UV_DC4] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_DC4_EINT,
+	},
+	[WM8350_IRQ_UV_DC5] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_DC5_EINT,
+	},
+	[WM8350_IRQ_UV_DC6] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_DC6_EINT,
+	},
+	[WM8350_IRQ_UV_LDO1] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_LDO1_EINT,
+	},
+	[WM8350_IRQ_UV_LDO2] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_LDO2_EINT,
+	},
+	[WM8350_IRQ_UV_LDO3] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_LDO3_EINT,
+	},
+	[WM8350_IRQ_UV_LDO4] = {
+		.primary = WM8350_UV_INT,
+		.reg = WM8350_UNDER_VOLTAGE_INT_OFFSET,
+		.mask = WM8350_UV_LDO4_EINT,
+	},
+	[WM8350_IRQ_CHG_BAT_HOT] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_BAT_HOT_EINT,
+	},
+	[WM8350_IRQ_CHG_BAT_COLD] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_BAT_COLD_EINT,
+	},
+	[WM8350_IRQ_CHG_BAT_FAIL] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_BAT_FAIL_EINT,
+	},
+	[WM8350_IRQ_CHG_TO] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_TO_EINT,
+	},
+	[WM8350_IRQ_CHG_END] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_END_EINT,
+	},
+	[WM8350_IRQ_CHG_START] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_START_EINT,
+	},
+	[WM8350_IRQ_CHG_FAST_RDY] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_FAST_RDY_EINT,
+	},
+	[WM8350_IRQ_CHG_VBATT_LT_3P9] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_VBATT_LT_3P9_EINT,
+	},
+	[WM8350_IRQ_CHG_VBATT_LT_3P1] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_VBATT_LT_3P1_EINT,
+	},
+	[WM8350_IRQ_CHG_VBATT_LT_2P85] = {
+		.primary = WM8350_CHG_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_CHG_VBATT_LT_2P85_EINT,
+	},
+	[WM8350_IRQ_RTC_ALM] = {
+		.primary = WM8350_RTC_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_RTC_ALM_EINT,
+	},
+	[WM8350_IRQ_RTC_SEC] = {
+		.primary = WM8350_RTC_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_RTC_SEC_EINT,
+	},
+	[WM8350_IRQ_RTC_PER] = {
+		.primary = WM8350_RTC_INT,
+		.reg = WM8350_INT_OFFSET_1,
+		.mask = WM8350_RTC_PER_EINT,
+	},
+	[WM8350_IRQ_CS1] = {
+		.primary = WM8350_CS_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_CS1_EINT,
+	},
+	[WM8350_IRQ_CS2] = {
+		.primary = WM8350_CS_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_CS2_EINT,
+	},
+	[WM8350_IRQ_SYS_HYST_COMP_FAIL] = {
+		.primary = WM8350_SYS_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_SYS_HYST_COMP_FAIL_EINT,
+	},
+	[WM8350_IRQ_SYS_CHIP_GT115] = {
+		.primary = WM8350_SYS_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_SYS_CHIP_GT115_EINT,
+	},
+	[WM8350_IRQ_SYS_CHIP_GT140] = {
+		.primary = WM8350_SYS_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_SYS_CHIP_GT140_EINT,
+	},
+	[WM8350_IRQ_SYS_WDOG_TO] = {
+		.primary = WM8350_SYS_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_SYS_WDOG_TO_EINT,
+	},
+	[WM8350_IRQ_AUXADC_DATARDY] = {
+		.primary = WM8350_AUXADC_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_AUXADC_DATARDY_EINT,
+	},
+	[WM8350_IRQ_AUXADC_DCOMP4] = {
+		.primary = WM8350_AUXADC_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_AUXADC_DCOMP4_EINT,
+	},
+	[WM8350_IRQ_AUXADC_DCOMP3] = {
+		.primary = WM8350_AUXADC_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_AUXADC_DCOMP3_EINT,
+	},
+	[WM8350_IRQ_AUXADC_DCOMP2] = {
+		.primary = WM8350_AUXADC_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_AUXADC_DCOMP2_EINT,
+	},
+	[WM8350_IRQ_AUXADC_DCOMP1] = {
+		.primary = WM8350_AUXADC_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_AUXADC_DCOMP1_EINT,
+	},
+	[WM8350_IRQ_USB_LIMIT] = {
+		.primary = WM8350_USB_INT,
+		.reg = WM8350_INT_OFFSET_2,
+		.mask = WM8350_USB_LIMIT_EINT,
+		.primary_only = 1,
+	},
+	[WM8350_IRQ_WKUP_OFF_STATE] = {
+		.primary = WM8350_WKUP_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_WKUP_OFF_STATE_EINT,
+	},
+	[WM8350_IRQ_WKUP_HIB_STATE] = {
+		.primary = WM8350_WKUP_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_WKUP_HIB_STATE_EINT,
+	},
+	[WM8350_IRQ_WKUP_CONV_FAULT] = {
+		.primary = WM8350_WKUP_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_WKUP_CONV_FAULT_EINT,
+	},
+	[WM8350_IRQ_WKUP_WDOG_RST] = {
+		.primary = WM8350_WKUP_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_WKUP_WDOG_RST_EINT,
+	},
+	[WM8350_IRQ_WKUP_GP_PWR_ON] = {
+		.primary = WM8350_WKUP_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_WKUP_GP_PWR_ON_EINT,
+	},
+	[WM8350_IRQ_WKUP_ONKEY] = {
+		.primary = WM8350_WKUP_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_WKUP_ONKEY_EINT,
+	},
+	[WM8350_IRQ_WKUP_GP_WAKEUP] = {
+		.primary = WM8350_WKUP_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_WKUP_GP_WAKEUP_EINT,
+	},
+	[WM8350_IRQ_CODEC_JCK_DET_L] = {
+		.primary = WM8350_CODEC_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_CODEC_JCK_DET_L_EINT,
+	},
+	[WM8350_IRQ_CODEC_JCK_DET_R] = {
+		.primary = WM8350_CODEC_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_CODEC_JCK_DET_R_EINT,
+	},
+	[WM8350_IRQ_CODEC_MICSCD] = {
+		.primary = WM8350_CODEC_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_CODEC_MICSCD_EINT,
+	},
+	[WM8350_IRQ_CODEC_MICD] = {
+		.primary = WM8350_CODEC_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_CODEC_MICD_EINT,
+	},
+	[WM8350_IRQ_EXT_USB_FB] = {
+		.primary = WM8350_EXT_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_EXT_USB_FB_EINT,
+	},
+	[WM8350_IRQ_EXT_WALL_FB] = {
+		.primary = WM8350_EXT_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_EXT_WALL_FB_EINT,
+	},
+	[WM8350_IRQ_EXT_BAT_FB] = {
+		.primary = WM8350_EXT_INT,
+		.reg = WM8350_COMPARATOR_INT_OFFSET,
+		.mask = WM8350_EXT_BAT_FB_EINT,
+	},
+	[WM8350_IRQ_GPIO(0)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP0_EINT,
+	},
+	[WM8350_IRQ_GPIO(1)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP1_EINT,
+	},
+	[WM8350_IRQ_GPIO(2)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP2_EINT,
+	},
+	[WM8350_IRQ_GPIO(3)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP3_EINT,
+	},
+	[WM8350_IRQ_GPIO(4)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP4_EINT,
+	},
+	[WM8350_IRQ_GPIO(5)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP5_EINT,
+	},
+	[WM8350_IRQ_GPIO(6)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP6_EINT,
+	},
+	[WM8350_IRQ_GPIO(7)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP7_EINT,
+	},
+	[WM8350_IRQ_GPIO(8)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP8_EINT,
+	},
+	[WM8350_IRQ_GPIO(9)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP9_EINT,
+	},
+	[WM8350_IRQ_GPIO(10)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP10_EINT,
+	},
+	[WM8350_IRQ_GPIO(11)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP11_EINT,
+	},
+	[WM8350_IRQ_GPIO(12)] = {
+		.primary = WM8350_GP_INT,
+		.reg = WM8350_GPIO_INT_OFFSET,
+		.mask = WM8350_GP12_EINT,
+	},
+};
+
 static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
 {
 	mutex_lock(&wm8350->irq_mutex);
@@ -51,197 +388,43 @@ static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
  * asserted while we run - in the normal course of events this is a
  * rare occurrence so we save I2C/SPI reads.
  */
-static irqreturn_t wm8350_irq(int irq, void *data)
+static irqreturn_t wm8350_irq(int irq, void *irq_data)
 {
-	struct wm8350 *wm8350 = data;
-	u16 level_one, status1, status2, comp;
+	struct wm8350 *wm8350 = irq_data;
+	u16 level_one;
+	u16 sub_reg[WM8350_NUM_IRQ_REGS];
+	int read_done[WM8350_NUM_IRQ_REGS];
+	struct wm8350_irq_data *data;
+	int i;
 
 	/* TODO: Use block reads to improve performance? */
 	level_one = wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS)
 		& ~wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK);
-	status1 = wm8350_reg_read(wm8350, WM8350_INT_STATUS_1)
-		& ~wm8350_reg_read(wm8350, WM8350_INT_STATUS_1_MASK);
-	status2 = wm8350_reg_read(wm8350, WM8350_INT_STATUS_2)
-		& ~wm8350_reg_read(wm8350, WM8350_INT_STATUS_2_MASK);
-	comp = wm8350_reg_read(wm8350, WM8350_COMPARATOR_INT_STATUS)
-		& ~wm8350_reg_read(wm8350, WM8350_COMPARATOR_INT_STATUS_MASK);
-
-	/* over current */
-	if (level_one & WM8350_OC_INT) {
-		u16 oc;
-
-		oc = wm8350_reg_read(wm8350, WM8350_OVER_CURRENT_INT_STATUS);
-		oc &= ~wm8350_reg_read(wm8350,
-				       WM8350_OVER_CURRENT_INT_STATUS_MASK);
-
-		if (oc & WM8350_OC_LS_EINT)	/* limit switch */
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_OC_LS);
-	}
-
-	/* under voltage */
-	if (level_one & WM8350_UV_INT) {
-		u16 uv;
-
-		uv = wm8350_reg_read(wm8350, WM8350_UNDER_VOLTAGE_INT_STATUS);
-		uv &= ~wm8350_reg_read(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK);
-
-		if (uv & WM8350_UV_DC1_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC1);
-		if (uv & WM8350_UV_DC2_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC2);
-		if (uv & WM8350_UV_DC3_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC3);
-		if (uv & WM8350_UV_DC4_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC4);
-		if (uv & WM8350_UV_DC5_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC5);
-		if (uv & WM8350_UV_DC6_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC6);
-		if (uv & WM8350_UV_LDO1_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO1);
-		if (uv & WM8350_UV_LDO2_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO2);
-		if (uv & WM8350_UV_LDO3_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO3);
-		if (uv & WM8350_UV_LDO4_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO4);
-	}
 
-	/* charger, RTC */
-	if (status1) {
-		if (status1 & WM8350_CHG_BAT_HOT_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CHG_BAT_HOT);
-		if (status1 & WM8350_CHG_BAT_COLD_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CHG_BAT_COLD);
-		if (status1 & WM8350_CHG_BAT_FAIL_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CHG_BAT_FAIL);
-		if (status1 & WM8350_CHG_TO_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CHG_TO);
-		if (status1 & WM8350_CHG_END_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CHG_END);
-		if (status1 & WM8350_CHG_START_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CHG_START);
-		if (status1 & WM8350_CHG_FAST_RDY_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CHG_FAST_RDY);
-		if (status1 & WM8350_CHG_VBATT_LT_3P9_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CHG_VBATT_LT_3P9);
-		if (status1 & WM8350_CHG_VBATT_LT_3P1_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CHG_VBATT_LT_3P1);
-		if (status1 & WM8350_CHG_VBATT_LT_2P85_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CHG_VBATT_LT_2P85);
-		if (status1 & WM8350_RTC_ALM_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_RTC_ALM);
-		if (status1 & WM8350_RTC_SEC_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_RTC_SEC);
-		if (status1 & WM8350_RTC_PER_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_RTC_PER);
-	}
-
-	/* current sink, system, aux adc */
-	if (status2) {
-		if (status2 & WM8350_CS1_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CS1);
-		if (status2 & WM8350_CS2_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CS2);
-
-		if (status2 & WM8350_SYS_HYST_COMP_FAIL_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_SYS_HYST_COMP_FAIL);
-		if (status2 & WM8350_SYS_CHIP_GT115_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_SYS_CHIP_GT115);
-		if (status2 & WM8350_SYS_CHIP_GT140_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_SYS_CHIP_GT140);
-		if (status2 & WM8350_SYS_WDOG_TO_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_SYS_WDOG_TO);
-
-		if (status2 & WM8350_AUXADC_DATARDY_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_AUXADC_DATARDY);
-		if (status2 & WM8350_AUXADC_DCOMP4_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_AUXADC_DCOMP4);
-		if (status2 & WM8350_AUXADC_DCOMP3_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_AUXADC_DCOMP3);
-		if (status2 & WM8350_AUXADC_DCOMP2_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_AUXADC_DCOMP2);
-		if (status2 & WM8350_AUXADC_DCOMP1_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_AUXADC_DCOMP1);
-
-		if (status2 & WM8350_USB_LIMIT_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_USB_LIMIT);
-	}
+	if (!level_one)
+		return IRQ_NONE;
 
-	/* wake, codec, ext */
-	if (comp) {
-		if (comp & WM8350_WKUP_OFF_STATE_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_WKUP_OFF_STATE);
-		if (comp & WM8350_WKUP_HIB_STATE_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_WKUP_HIB_STATE);
-		if (comp & WM8350_WKUP_CONV_FAULT_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_WKUP_CONV_FAULT);
-		if (comp & WM8350_WKUP_WDOG_RST_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_WKUP_WDOG_RST);
-		if (comp & WM8350_WKUP_GP_PWR_ON_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_WKUP_GP_PWR_ON);
-		if (comp & WM8350_WKUP_ONKEY_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_WKUP_ONKEY);
-		if (comp & WM8350_WKUP_GP_WAKEUP_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_WKUP_GP_WAKEUP);
-
-		if (comp & WM8350_CODEC_JCK_DET_L_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CODEC_JCK_DET_L);
-		if (comp & WM8350_CODEC_JCK_DET_R_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CODEC_JCK_DET_R);
-		if (comp & WM8350_CODEC_MICSCD_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_CODEC_MICSCD);
-		if (comp & WM8350_CODEC_MICD_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CODEC_MICD);
-
-		if (comp & WM8350_EXT_USB_FB_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_EXT_USB_FB);
-		if (comp & WM8350_EXT_WALL_FB_EINT)
-			wm8350_irq_call_handler(wm8350,
-						WM8350_IRQ_EXT_WALL_FB);
-		if (comp & WM8350_EXT_BAT_FB_EINT)
-			wm8350_irq_call_handler(wm8350, WM8350_IRQ_EXT_BAT_FB);
-	}
+	memset(&read_done, 0, sizeof(read_done));
 
-	if (level_one & WM8350_GP_INT) {
-		int i;
-		u16 gpio;
+	for (i = 0; i < ARRAY_SIZE(wm8350_irqs); i++) {
+		data = &wm8350_irqs[i];
 
-		gpio = wm8350_reg_read(wm8350, WM8350_GPIO_INT_STATUS);
-		gpio &= ~wm8350_reg_read(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK);
+		if (!(level_one & data->primary))
+			continue;
 
-		for (i = 0; i < 12; i++) {
-			if (gpio & (1 << i))
-				wm8350_irq_call_handler(wm8350,
-							WM8350_IRQ_GPIO(i));
+		if (!read_done[data->reg]) {
+			sub_reg[data->reg] =
+				wm8350_reg_read(wm8350, WM8350_INT_STATUS_1 +
+						data->reg);
+			sub_reg[data->reg] &=
+				~wm8350_reg_read(wm8350,
+						 WM8350_INT_STATUS_1_MASK +
+						 data->reg);
+			read_done[data->reg] = 1;
 		}
+
+		if (sub_reg[data->reg] & data->mask)
+			wm8350_irq_call_handler(wm8350, i);
 	}
 
 	return IRQ_HANDLED;
@@ -280,479 +463,17 @@ EXPORT_SYMBOL_GPL(wm8350_free_irq);
 
 int wm8350_mask_irq(struct wm8350 *wm8350, int irq)
 {
-	switch (irq) {
-	case WM8350_IRQ_CHG_BAT_HOT:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_BAT_HOT_EINT);
-	case WM8350_IRQ_CHG_BAT_COLD:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_BAT_COLD_EINT);
-	case WM8350_IRQ_CHG_BAT_FAIL:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_BAT_FAIL_EINT);
-	case WM8350_IRQ_CHG_TO:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_TO_EINT);
-	case WM8350_IRQ_CHG_END:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_END_EINT);
-	case WM8350_IRQ_CHG_START:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_START_EINT);
-	case WM8350_IRQ_CHG_FAST_RDY:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_FAST_RDY_EINT);
-	case WM8350_IRQ_RTC_PER:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_RTC_PER_EINT);
-	case WM8350_IRQ_RTC_SEC:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_RTC_SEC_EINT);
-	case WM8350_IRQ_RTC_ALM:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_RTC_ALM_EINT);
-	case WM8350_IRQ_CHG_VBATT_LT_3P9:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_VBATT_LT_3P9_EINT);
-	case WM8350_IRQ_CHG_VBATT_LT_3P1:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_VBATT_LT_3P1_EINT);
-	case WM8350_IRQ_CHG_VBATT_LT_2P85:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-				       WM8350_IM_CHG_VBATT_LT_2P85_EINT);
-	case WM8350_IRQ_CS1:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_CS1_EINT);
-	case WM8350_IRQ_CS2:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_CS2_EINT);
-	case WM8350_IRQ_USB_LIMIT:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_USB_LIMIT_EINT);
-	case WM8350_IRQ_AUXADC_DATARDY:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_AUXADC_DATARDY_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP4:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_AUXADC_DCOMP4_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP3:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_AUXADC_DCOMP3_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP2:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_AUXADC_DCOMP2_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP1:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_AUXADC_DCOMP1_EINT);
-	case WM8350_IRQ_SYS_HYST_COMP_FAIL:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_SYS_HYST_COMP_FAIL_EINT);
-	case WM8350_IRQ_SYS_CHIP_GT115:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_SYS_CHIP_GT115_EINT);
-	case WM8350_IRQ_SYS_CHIP_GT140:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_SYS_CHIP_GT140_EINT);
-	case WM8350_IRQ_SYS_WDOG_TO:
-		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-				       WM8350_IM_SYS_WDOG_TO_EINT);
-	case WM8350_IRQ_UV_LDO4:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_LDO4_EINT);
-	case WM8350_IRQ_UV_LDO3:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_LDO3_EINT);
-	case WM8350_IRQ_UV_LDO2:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_LDO2_EINT);
-	case WM8350_IRQ_UV_LDO1:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_LDO1_EINT);
-	case WM8350_IRQ_UV_DC6:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_DC6_EINT);
-	case WM8350_IRQ_UV_DC5:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_DC5_EINT);
-	case WM8350_IRQ_UV_DC4:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_DC4_EINT);
-	case WM8350_IRQ_UV_DC3:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_DC3_EINT);
-	case WM8350_IRQ_UV_DC2:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_DC2_EINT);
-	case WM8350_IRQ_UV_DC1:
-		return wm8350_set_bits(wm8350,
-				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-				       WM8350_IM_UV_DC1_EINT);
-	case WM8350_IRQ_OC_LS:
-		return wm8350_set_bits(wm8350,
-				       WM8350_OVER_CURRENT_INT_STATUS_MASK,
-				       WM8350_IM_OC_LS_EINT);
-	case WM8350_IRQ_EXT_USB_FB:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_EXT_USB_FB_EINT);
-	case WM8350_IRQ_EXT_WALL_FB:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_EXT_WALL_FB_EINT);
-	case WM8350_IRQ_EXT_BAT_FB:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_EXT_BAT_FB_EINT);
-	case WM8350_IRQ_CODEC_JCK_DET_L:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_CODEC_JCK_DET_L_EINT);
-	case WM8350_IRQ_CODEC_JCK_DET_R:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_CODEC_JCK_DET_R_EINT);
-	case WM8350_IRQ_CODEC_MICSCD:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_CODEC_MICSCD_EINT);
-	case WM8350_IRQ_CODEC_MICD:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_CODEC_MICD_EINT);
-	case WM8350_IRQ_WKUP_OFF_STATE:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_WKUP_OFF_STATE_EINT);
-	case WM8350_IRQ_WKUP_HIB_STATE:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_WKUP_HIB_STATE_EINT);
-	case WM8350_IRQ_WKUP_CONV_FAULT:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_WKUP_CONV_FAULT_EINT);
-	case WM8350_IRQ_WKUP_WDOG_RST:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_WKUP_OFF_STATE_EINT);
-	case WM8350_IRQ_WKUP_GP_PWR_ON:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_WKUP_GP_PWR_ON_EINT);
-	case WM8350_IRQ_WKUP_ONKEY:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_WKUP_ONKEY_EINT);
-	case WM8350_IRQ_WKUP_GP_WAKEUP:
-		return wm8350_set_bits(wm8350,
-				       WM8350_COMPARATOR_INT_STATUS_MASK,
-				       WM8350_IM_WKUP_GP_WAKEUP_EINT);
-	case WM8350_IRQ_GPIO(0):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP0_EINT);
-	case WM8350_IRQ_GPIO(1):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP1_EINT);
-	case WM8350_IRQ_GPIO(2):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP2_EINT);
-	case WM8350_IRQ_GPIO(3):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP3_EINT);
-	case WM8350_IRQ_GPIO(4):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP4_EINT);
-	case WM8350_IRQ_GPIO(5):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP5_EINT);
-	case WM8350_IRQ_GPIO(6):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP6_EINT);
-	case WM8350_IRQ_GPIO(7):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP7_EINT);
-	case WM8350_IRQ_GPIO(8):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP8_EINT);
-	case WM8350_IRQ_GPIO(9):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP9_EINT);
-	case WM8350_IRQ_GPIO(10):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP10_EINT);
-	case WM8350_IRQ_GPIO(11):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP11_EINT);
-	case WM8350_IRQ_GPIO(12):
-		return wm8350_set_bits(wm8350,
-				       WM8350_GPIO_INT_STATUS_MASK,
-				       WM8350_IM_GP12_EINT);
-	default:
-		dev_warn(wm8350->dev, "Attempting to mask unknown IRQ %d\n",
-			 irq);
-		return -EINVAL;
-	}
-	return 0;
+	return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK +
+			       wm8350_irqs[irq].reg,
+			       wm8350_irqs[irq].mask);
 }
 EXPORT_SYMBOL_GPL(wm8350_mask_irq);
 
 int wm8350_unmask_irq(struct wm8350 *wm8350, int irq)
 {
-	switch (irq) {
-	case WM8350_IRQ_CHG_BAT_HOT:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_BAT_HOT_EINT);
-	case WM8350_IRQ_CHG_BAT_COLD:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_BAT_COLD_EINT);
-	case WM8350_IRQ_CHG_BAT_FAIL:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_BAT_FAIL_EINT);
-	case WM8350_IRQ_CHG_TO:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_TO_EINT);
-	case WM8350_IRQ_CHG_END:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_END_EINT);
-	case WM8350_IRQ_CHG_START:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_START_EINT);
-	case WM8350_IRQ_CHG_FAST_RDY:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_FAST_RDY_EINT);
-	case WM8350_IRQ_RTC_PER:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_RTC_PER_EINT);
-	case WM8350_IRQ_RTC_SEC:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_RTC_SEC_EINT);
-	case WM8350_IRQ_RTC_ALM:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_RTC_ALM_EINT);
-	case WM8350_IRQ_CHG_VBATT_LT_3P9:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_VBATT_LT_3P9_EINT);
-	case WM8350_IRQ_CHG_VBATT_LT_3P1:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_VBATT_LT_3P1_EINT);
-	case WM8350_IRQ_CHG_VBATT_LT_2P85:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
-					 WM8350_IM_CHG_VBATT_LT_2P85_EINT);
-	case WM8350_IRQ_CS1:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_CS1_EINT);
-	case WM8350_IRQ_CS2:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_CS2_EINT);
-	case WM8350_IRQ_USB_LIMIT:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_USB_LIMIT_EINT);
-	case WM8350_IRQ_AUXADC_DATARDY:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_AUXADC_DATARDY_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP4:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_AUXADC_DCOMP4_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP3:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_AUXADC_DCOMP3_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP2:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_AUXADC_DCOMP2_EINT);
-	case WM8350_IRQ_AUXADC_DCOMP1:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_AUXADC_DCOMP1_EINT);
-	case WM8350_IRQ_SYS_HYST_COMP_FAIL:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_SYS_HYST_COMP_FAIL_EINT);
-	case WM8350_IRQ_SYS_CHIP_GT115:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_SYS_CHIP_GT115_EINT);
-	case WM8350_IRQ_SYS_CHIP_GT140:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_SYS_CHIP_GT140_EINT);
-	case WM8350_IRQ_SYS_WDOG_TO:
-		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
-					 WM8350_IM_SYS_WDOG_TO_EINT);
-	case WM8350_IRQ_UV_LDO4:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_LDO4_EINT);
-	case WM8350_IRQ_UV_LDO3:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_LDO3_EINT);
-	case WM8350_IRQ_UV_LDO2:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_LDO2_EINT);
-	case WM8350_IRQ_UV_LDO1:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_LDO1_EINT);
-	case WM8350_IRQ_UV_DC6:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_DC6_EINT);
-	case WM8350_IRQ_UV_DC5:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_DC5_EINT);
-	case WM8350_IRQ_UV_DC4:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_DC4_EINT);
-	case WM8350_IRQ_UV_DC3:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_DC3_EINT);
-	case WM8350_IRQ_UV_DC2:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_DC2_EINT);
-	case WM8350_IRQ_UV_DC1:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
-					 WM8350_IM_UV_DC1_EINT);
-	case WM8350_IRQ_OC_LS:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_OVER_CURRENT_INT_STATUS_MASK,
-					 WM8350_IM_OC_LS_EINT);
-	case WM8350_IRQ_EXT_USB_FB:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_EXT_USB_FB_EINT);
-	case WM8350_IRQ_EXT_WALL_FB:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_EXT_WALL_FB_EINT);
-	case WM8350_IRQ_EXT_BAT_FB:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_EXT_BAT_FB_EINT);
-	case WM8350_IRQ_CODEC_JCK_DET_L:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_CODEC_JCK_DET_L_EINT);
-	case WM8350_IRQ_CODEC_JCK_DET_R:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_CODEC_JCK_DET_R_EINT);
-	case WM8350_IRQ_CODEC_MICSCD:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_CODEC_MICSCD_EINT);
-	case WM8350_IRQ_CODEC_MICD:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_CODEC_MICD_EINT);
-	case WM8350_IRQ_WKUP_OFF_STATE:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_WKUP_OFF_STATE_EINT);
-	case WM8350_IRQ_WKUP_HIB_STATE:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_WKUP_HIB_STATE_EINT);
-	case WM8350_IRQ_WKUP_CONV_FAULT:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_WKUP_CONV_FAULT_EINT);
-	case WM8350_IRQ_WKUP_WDOG_RST:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_WKUP_OFF_STATE_EINT);
-	case WM8350_IRQ_WKUP_GP_PWR_ON:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_WKUP_GP_PWR_ON_EINT);
-	case WM8350_IRQ_WKUP_ONKEY:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_WKUP_ONKEY_EINT);
-	case WM8350_IRQ_WKUP_GP_WAKEUP:
-		return wm8350_clear_bits(wm8350,
-					 WM8350_COMPARATOR_INT_STATUS_MASK,
-					 WM8350_IM_WKUP_GP_WAKEUP_EINT);
-	case WM8350_IRQ_GPIO(0):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP0_EINT);
-	case WM8350_IRQ_GPIO(1):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP1_EINT);
-	case WM8350_IRQ_GPIO(2):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP2_EINT);
-	case WM8350_IRQ_GPIO(3):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP3_EINT);
-	case WM8350_IRQ_GPIO(4):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP4_EINT);
-	case WM8350_IRQ_GPIO(5):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP5_EINT);
-	case WM8350_IRQ_GPIO(6):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP6_EINT);
-	case WM8350_IRQ_GPIO(7):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP7_EINT);
-	case WM8350_IRQ_GPIO(8):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP8_EINT);
-	case WM8350_IRQ_GPIO(9):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP9_EINT);
-	case WM8350_IRQ_GPIO(10):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP10_EINT);
-	case WM8350_IRQ_GPIO(11):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP11_EINT);
-	case WM8350_IRQ_GPIO(12):
-		return wm8350_clear_bits(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK,
-					 WM8350_IM_GP12_EINT);
-	default:
-		dev_warn(wm8350->dev, "Attempting to unmask unknown IRQ %d\n",
-			 irq);
-		return -EINVAL;
-	}
-	return 0;
+	return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK +
+				 wm8350_irqs[irq].reg,
+				 wm8350_irqs[irq].mask);
 }
 EXPORT_SYMBOL_GPL(wm8350_unmask_irq);
 
diff --git a/include/linux/mfd/wm8350/gpio.h b/include/linux/mfd/wm8350/gpio.h
index ed91e8f..71af3d6 100644
--- a/include/linux/mfd/wm8350/gpio.h
+++ b/include/linux/mfd/wm8350/gpio.h
@@ -173,6 +173,24 @@
 #define WM8350_GPIO_DEBOUNCE_ON			1
 
 /*
+ * R30 (0x1E) - GPIO Interrupt Status
+ */
+#define WM8350_GP12_EINT                        0x1000
+#define WM8350_GP11_EINT                        0x0800
+#define WM8350_GP10_EINT                        0x0400
+#define WM8350_GP9_EINT                         0x0200
+#define WM8350_GP8_EINT                         0x0100
+#define WM8350_GP7_EINT                         0x0080
+#define WM8350_GP6_EINT                         0x0040
+#define WM8350_GP5_EINT                         0x0020
+#define WM8350_GP4_EINT                         0x0010
+#define WM8350_GP3_EINT                         0x0008
+#define WM8350_GP2_EINT                         0x0004
+#define WM8350_GP1_EINT                         0x0002
+#define WM8350_GP0_EINT                         0x0001
+
+
+/*
  * R128 (0x80) - GPIO Debounce
  */
 #define WM8350_GP12_DB                          0x1000
-- 
1.6.4.3

