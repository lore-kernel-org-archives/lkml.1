Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbZJLPPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbZJLPPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbZJLPPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:15:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33262 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932156AbZJLPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:15:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Split wm8350 IRQ code into a separate file
Date: Mon, 12 Oct 2009 16:15:09 +0100
Message-Id: <1255360510-20690-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for refactoring - it's over 700 lines of well-isolated
code and having it in a file by itself makes things more managable.

While we're at it make sure that we clean up the IRQ if we fail after
acquiring it on init.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/wm8350-core.c       |  769 +-------------------------------------
 drivers/mfd/wm8350-irq.c        |  804 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/core.h |    4 +-
 4 files changed, 815 insertions(+), 763 deletions(-)
 create mode 100644 drivers/mfd/wm8350-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 9baebbe..62405ba 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
 wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
 obj-$(CONFIG_MFD_WM831X)	+= wm831x.o
 wm8350-objs			:= wm8350-core.o wm8350-regmap.o wm8350-gpio.o
+wm8350-objs			+= wm8350-irq.o
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 
diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index ba27c9d..242795f 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -337,733 +337,6 @@ int wm8350_reg_unlock(struct wm8350 *wm8350)
 }
 EXPORT_SYMBOL_GPL(wm8350_reg_unlock);
 
-static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
-{
-	mutex_lock(&wm8350->irq_mutex);
-
-	if (wm8350->irq[irq].handler)
-		wm8350->irq[irq].handler(wm8350, irq, wm8350->irq[irq].data);
-	else {
-		dev_err(wm8350->dev, "irq %d nobody cared. now masked.\n",
-			irq);
-		wm8350_mask_irq(wm8350, irq);
-	}
-
-	mutex_unlock(&wm8350->irq_mutex);
-}
-
-/*
- * This is a threaded IRQ handler so can access I2C/SPI.  Since all
- * interrupts are clear on read the IRQ line will be reasserted and
- * the physical IRQ will be handled again if another interrupt is
- * asserted while we run - in the normal course of events this is a
- * rare occurrence so we save I2C/SPI reads.
- */
-static irqreturn_t wm8350_irq(int irq, void *data)
-{
-	struct wm8350 *wm8350 = data;
-	u16 level_one, status1, status2, comp;
-
-	/* TODO: Use block reads to improve performance? */
-	level_one = wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS)
-		& ~wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK);
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
-
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
-
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
-
-	if (level_one & WM8350_GP_INT) {
-		int i;
-		u16 gpio;
-
-		gpio = wm8350_reg_read(wm8350, WM8350_GPIO_INT_STATUS);
-		gpio &= ~wm8350_reg_read(wm8350,
-					 WM8350_GPIO_INT_STATUS_MASK);
-
-		for (i = 0; i < 12; i++) {
-			if (gpio & (1 << i))
-				wm8350_irq_call_handler(wm8350,
-							WM8350_IRQ_GPIO(i));
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
-int wm8350_register_irq(struct wm8350 *wm8350, int irq,
-			void (*handler) (struct wm8350 *, int, void *),
-			void *data)
-{
-	if (irq < 0 || irq > WM8350_NUM_IRQ || !handler)
-		return -EINVAL;
-
-	if (wm8350->irq[irq].handler)
-		return -EBUSY;
-
-	mutex_lock(&wm8350->irq_mutex);
-	wm8350->irq[irq].handler = handler;
-	wm8350->irq[irq].data = data;
-	mutex_unlock(&wm8350->irq_mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(wm8350_register_irq);
-
-int wm8350_free_irq(struct wm8350 *wm8350, int irq)
-{
-	if (irq < 0 || irq > WM8350_NUM_IRQ)
-		return -EINVAL;
-
-	mutex_lock(&wm8350->irq_mutex);
-	wm8350->irq[irq].handler = NULL;
-	mutex_unlock(&wm8350->irq_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(wm8350_free_irq);
-
-int wm8350_mask_irq(struct wm8350 *wm8350, int irq)
-{
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
-}
-EXPORT_SYMBOL_GPL(wm8350_mask_irq);
-
-int wm8350_unmask_irq(struct wm8350 *wm8350, int irq)
-{
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
-}
-EXPORT_SYMBOL_GPL(wm8350_unmask_irq);
-
 int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
 {
 	u16 reg, result = 0;
@@ -1409,49 +682,18 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		return ret;
 	}
 
-	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_INT_STATUS_1_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_INT_STATUS_2_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_UNDER_VOLTAGE_INT_STATUS_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_GPIO_INT_STATUS_MASK, 0xFFFF);
-	wm8350_reg_write(wm8350, WM8350_COMPARATOR_INT_STATUS_MASK, 0xFFFF);
-
 	mutex_init(&wm8350->auxadc_mutex);
-	mutex_init(&wm8350->irq_mutex);
-	if (irq) {
-		int flags = IRQF_ONESHOT;
-
-		if (pdata && pdata->irq_high) {
-			flags |= IRQF_TRIGGER_HIGH;
-
-			wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
-					WM8350_IRQ_POL);
-		} else {
-			flags |= IRQF_TRIGGER_LOW;
-
-			wm8350_clear_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
-					  WM8350_IRQ_POL);
-		}
 
-		ret = request_threaded_irq(irq, NULL, wm8350_irq, flags,
-					   "wm8350", wm8350);
-		if (ret != 0) {
-			dev_err(wm8350->dev, "Failed to request IRQ: %d\n",
-				ret);
-			goto err;
-		}
-	} else {
-		dev_err(wm8350->dev, "No IRQ configured\n");
+	ret = wm8350_irq_init(wm8350, irq, pdata);
+	if (ret < 0)
 		goto err;
-	}
-	wm8350->chip_irq = irq;
 
 	if (pdata && pdata->init) {
 		ret = pdata->init(wm8350);
 		if (ret != 0) {
 			dev_err(wm8350->dev, "Platform init() failed: %d\n",
 				ret);
-			goto err;
+			goto err_irq;
 		}
 	}
 
@@ -1470,6 +712,8 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 
 	return 0;
 
+err_irq:
+	wm8350_irq_exit(wm8350);
 err:
 	kfree(wm8350->reg_cache);
 	return ret;
@@ -1493,7 +737,8 @@ void wm8350_device_exit(struct wm8350 *wm8350)
 	platform_device_unregister(wm8350->gpio.pdev);
 	platform_device_unregister(wm8350->codec.pdev);
 
-	free_irq(wm8350->chip_irq, wm8350);
+	wm8350_irq_exit(wm8350);
+
 	kfree(wm8350->reg_cache);
 }
 EXPORT_SYMBOL_GPL(wm8350_device_exit);
diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
new file mode 100644
index 0000000..a432e2b
--- /dev/null
+++ b/drivers/mfd/wm8350-irq.c
@@ -0,0 +1,804 @@
+/*
+ * wm8350-irq.c  --  IRQ support for Wolfson WM8350
+ *
+ * Copyright 2007, 2008, 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood, Mark Brown
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
+#include <linux/mfd/wm8350/core.h>
+#include <linux/mfd/wm8350/audio.h>
+#include <linux/mfd/wm8350/comparator.h>
+#include <linux/mfd/wm8350/gpio.h>
+#include <linux/mfd/wm8350/pmic.h>
+#include <linux/mfd/wm8350/rtc.h>
+#include <linux/mfd/wm8350/supply.h>
+#include <linux/mfd/wm8350/wdt.h>
+
+static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
+{
+	mutex_lock(&wm8350->irq_mutex);
+
+	if (wm8350->irq[irq].handler)
+		wm8350->irq[irq].handler(wm8350, irq, wm8350->irq[irq].data);
+	else {
+		dev_err(wm8350->dev, "irq %d nobody cared. now masked.\n",
+			irq);
+		wm8350_mask_irq(wm8350, irq);
+	}
+
+	mutex_unlock(&wm8350->irq_mutex);
+}
+
+/*
+ * This is a threaded IRQ handler so can access I2C/SPI.  Since all
+ * interrupts are clear on read the IRQ line will be reasserted and
+ * the physical IRQ will be handled again if another interrupt is
+ * asserted while we run - in the normal course of events this is a
+ * rare occurrence so we save I2C/SPI reads.
+ */
+static irqreturn_t wm8350_irq(int irq, void *data)
+{
+	struct wm8350 *wm8350 = data;
+	u16 level_one, status1, status2, comp;
+
+	/* TODO: Use block reads to improve performance? */
+	level_one = wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS)
+		& ~wm8350_reg_read(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK);
+	status1 = wm8350_reg_read(wm8350, WM8350_INT_STATUS_1)
+		& ~wm8350_reg_read(wm8350, WM8350_INT_STATUS_1_MASK);
+	status2 = wm8350_reg_read(wm8350, WM8350_INT_STATUS_2)
+		& ~wm8350_reg_read(wm8350, WM8350_INT_STATUS_2_MASK);
+	comp = wm8350_reg_read(wm8350, WM8350_COMPARATOR_INT_STATUS)
+		& ~wm8350_reg_read(wm8350, WM8350_COMPARATOR_INT_STATUS_MASK);
+
+	/* over current */
+	if (level_one & WM8350_OC_INT) {
+		u16 oc;
+
+		oc = wm8350_reg_read(wm8350, WM8350_OVER_CURRENT_INT_STATUS);
+		oc &= ~wm8350_reg_read(wm8350,
+				       WM8350_OVER_CURRENT_INT_STATUS_MASK);
+
+		if (oc & WM8350_OC_LS_EINT)	/* limit switch */
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_OC_LS);
+	}
+
+	/* under voltage */
+	if (level_one & WM8350_UV_INT) {
+		u16 uv;
+
+		uv = wm8350_reg_read(wm8350, WM8350_UNDER_VOLTAGE_INT_STATUS);
+		uv &= ~wm8350_reg_read(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK);
+
+		if (uv & WM8350_UV_DC1_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC1);
+		if (uv & WM8350_UV_DC2_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC2);
+		if (uv & WM8350_UV_DC3_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC3);
+		if (uv & WM8350_UV_DC4_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC4);
+		if (uv & WM8350_UV_DC5_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC5);
+		if (uv & WM8350_UV_DC6_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_DC6);
+		if (uv & WM8350_UV_LDO1_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO1);
+		if (uv & WM8350_UV_LDO2_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO2);
+		if (uv & WM8350_UV_LDO3_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO3);
+		if (uv & WM8350_UV_LDO4_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_UV_LDO4);
+	}
+
+	/* charger, RTC */
+	if (status1) {
+		if (status1 & WM8350_CHG_BAT_HOT_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CHG_BAT_HOT);
+		if (status1 & WM8350_CHG_BAT_COLD_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CHG_BAT_COLD);
+		if (status1 & WM8350_CHG_BAT_FAIL_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CHG_BAT_FAIL);
+		if (status1 & WM8350_CHG_TO_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CHG_TO);
+		if (status1 & WM8350_CHG_END_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CHG_END);
+		if (status1 & WM8350_CHG_START_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CHG_START);
+		if (status1 & WM8350_CHG_FAST_RDY_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CHG_FAST_RDY);
+		if (status1 & WM8350_CHG_VBATT_LT_3P9_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CHG_VBATT_LT_3P9);
+		if (status1 & WM8350_CHG_VBATT_LT_3P1_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CHG_VBATT_LT_3P1);
+		if (status1 & WM8350_CHG_VBATT_LT_2P85_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CHG_VBATT_LT_2P85);
+		if (status1 & WM8350_RTC_ALM_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_RTC_ALM);
+		if (status1 & WM8350_RTC_SEC_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_RTC_SEC);
+		if (status1 & WM8350_RTC_PER_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_RTC_PER);
+	}
+
+	/* current sink, system, aux adc */
+	if (status2) {
+		if (status2 & WM8350_CS1_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CS1);
+		if (status2 & WM8350_CS2_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CS2);
+
+		if (status2 & WM8350_SYS_HYST_COMP_FAIL_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_SYS_HYST_COMP_FAIL);
+		if (status2 & WM8350_SYS_CHIP_GT115_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_SYS_CHIP_GT115);
+		if (status2 & WM8350_SYS_CHIP_GT140_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_SYS_CHIP_GT140);
+		if (status2 & WM8350_SYS_WDOG_TO_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_SYS_WDOG_TO);
+
+		if (status2 & WM8350_AUXADC_DATARDY_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_AUXADC_DATARDY);
+		if (status2 & WM8350_AUXADC_DCOMP4_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_AUXADC_DCOMP4);
+		if (status2 & WM8350_AUXADC_DCOMP3_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_AUXADC_DCOMP3);
+		if (status2 & WM8350_AUXADC_DCOMP2_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_AUXADC_DCOMP2);
+		if (status2 & WM8350_AUXADC_DCOMP1_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_AUXADC_DCOMP1);
+
+		if (status2 & WM8350_USB_LIMIT_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_USB_LIMIT);
+	}
+
+	/* wake, codec, ext */
+	if (comp) {
+		if (comp & WM8350_WKUP_OFF_STATE_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_WKUP_OFF_STATE);
+		if (comp & WM8350_WKUP_HIB_STATE_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_WKUP_HIB_STATE);
+		if (comp & WM8350_WKUP_CONV_FAULT_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_WKUP_CONV_FAULT);
+		if (comp & WM8350_WKUP_WDOG_RST_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_WKUP_WDOG_RST);
+		if (comp & WM8350_WKUP_GP_PWR_ON_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_WKUP_GP_PWR_ON);
+		if (comp & WM8350_WKUP_ONKEY_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_WKUP_ONKEY);
+		if (comp & WM8350_WKUP_GP_WAKEUP_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_WKUP_GP_WAKEUP);
+
+		if (comp & WM8350_CODEC_JCK_DET_L_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CODEC_JCK_DET_L);
+		if (comp & WM8350_CODEC_JCK_DET_R_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CODEC_JCK_DET_R);
+		if (comp & WM8350_CODEC_MICSCD_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_CODEC_MICSCD);
+		if (comp & WM8350_CODEC_MICD_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_CODEC_MICD);
+
+		if (comp & WM8350_EXT_USB_FB_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_EXT_USB_FB);
+		if (comp & WM8350_EXT_WALL_FB_EINT)
+			wm8350_irq_call_handler(wm8350,
+						WM8350_IRQ_EXT_WALL_FB);
+		if (comp & WM8350_EXT_BAT_FB_EINT)
+			wm8350_irq_call_handler(wm8350, WM8350_IRQ_EXT_BAT_FB);
+	}
+
+	if (level_one & WM8350_GP_INT) {
+		int i;
+		u16 gpio;
+
+		gpio = wm8350_reg_read(wm8350, WM8350_GPIO_INT_STATUS);
+		gpio &= ~wm8350_reg_read(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK);
+
+		for (i = 0; i < 12; i++) {
+			if (gpio & (1 << i))
+				wm8350_irq_call_handler(wm8350,
+							WM8350_IRQ_GPIO(i));
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+int wm8350_register_irq(struct wm8350 *wm8350, int irq,
+			void (*handler) (struct wm8350 *, int, void *),
+			void *data)
+{
+	if (irq < 0 || irq > WM8350_NUM_IRQ || !handler)
+		return -EINVAL;
+
+	if (wm8350->irq[irq].handler)
+		return -EBUSY;
+
+	mutex_lock(&wm8350->irq_mutex);
+	wm8350->irq[irq].handler = handler;
+	wm8350->irq[irq].data = data;
+	mutex_unlock(&wm8350->irq_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wm8350_register_irq);
+
+int wm8350_free_irq(struct wm8350 *wm8350, int irq)
+{
+	if (irq < 0 || irq > WM8350_NUM_IRQ)
+		return -EINVAL;
+
+	mutex_lock(&wm8350->irq_mutex);
+	wm8350->irq[irq].handler = NULL;
+	mutex_unlock(&wm8350->irq_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wm8350_free_irq);
+
+int wm8350_mask_irq(struct wm8350 *wm8350, int irq)
+{
+	switch (irq) {
+	case WM8350_IRQ_CHG_BAT_HOT:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_BAT_HOT_EINT);
+	case WM8350_IRQ_CHG_BAT_COLD:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_BAT_COLD_EINT);
+	case WM8350_IRQ_CHG_BAT_FAIL:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_BAT_FAIL_EINT);
+	case WM8350_IRQ_CHG_TO:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_TO_EINT);
+	case WM8350_IRQ_CHG_END:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_END_EINT);
+	case WM8350_IRQ_CHG_START:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_START_EINT);
+	case WM8350_IRQ_CHG_FAST_RDY:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_FAST_RDY_EINT);
+	case WM8350_IRQ_RTC_PER:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_RTC_PER_EINT);
+	case WM8350_IRQ_RTC_SEC:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_RTC_SEC_EINT);
+	case WM8350_IRQ_RTC_ALM:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_RTC_ALM_EINT);
+	case WM8350_IRQ_CHG_VBATT_LT_3P9:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_VBATT_LT_3P9_EINT);
+	case WM8350_IRQ_CHG_VBATT_LT_3P1:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_VBATT_LT_3P1_EINT);
+	case WM8350_IRQ_CHG_VBATT_LT_2P85:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+				       WM8350_IM_CHG_VBATT_LT_2P85_EINT);
+	case WM8350_IRQ_CS1:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_CS1_EINT);
+	case WM8350_IRQ_CS2:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_CS2_EINT);
+	case WM8350_IRQ_USB_LIMIT:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_USB_LIMIT_EINT);
+	case WM8350_IRQ_AUXADC_DATARDY:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_AUXADC_DATARDY_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP4:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_AUXADC_DCOMP4_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP3:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_AUXADC_DCOMP3_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP2:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_AUXADC_DCOMP2_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP1:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_AUXADC_DCOMP1_EINT);
+	case WM8350_IRQ_SYS_HYST_COMP_FAIL:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_SYS_HYST_COMP_FAIL_EINT);
+	case WM8350_IRQ_SYS_CHIP_GT115:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_SYS_CHIP_GT115_EINT);
+	case WM8350_IRQ_SYS_CHIP_GT140:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_SYS_CHIP_GT140_EINT);
+	case WM8350_IRQ_SYS_WDOG_TO:
+		return wm8350_set_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+				       WM8350_IM_SYS_WDOG_TO_EINT);
+	case WM8350_IRQ_UV_LDO4:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_LDO4_EINT);
+	case WM8350_IRQ_UV_LDO3:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_LDO3_EINT);
+	case WM8350_IRQ_UV_LDO2:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_LDO2_EINT);
+	case WM8350_IRQ_UV_LDO1:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_LDO1_EINT);
+	case WM8350_IRQ_UV_DC6:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_DC6_EINT);
+	case WM8350_IRQ_UV_DC5:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_DC5_EINT);
+	case WM8350_IRQ_UV_DC4:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_DC4_EINT);
+	case WM8350_IRQ_UV_DC3:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_DC3_EINT);
+	case WM8350_IRQ_UV_DC2:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_DC2_EINT);
+	case WM8350_IRQ_UV_DC1:
+		return wm8350_set_bits(wm8350,
+				       WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+				       WM8350_IM_UV_DC1_EINT);
+	case WM8350_IRQ_OC_LS:
+		return wm8350_set_bits(wm8350,
+				       WM8350_OVER_CURRENT_INT_STATUS_MASK,
+				       WM8350_IM_OC_LS_EINT);
+	case WM8350_IRQ_EXT_USB_FB:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_EXT_USB_FB_EINT);
+	case WM8350_IRQ_EXT_WALL_FB:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_EXT_WALL_FB_EINT);
+	case WM8350_IRQ_EXT_BAT_FB:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_EXT_BAT_FB_EINT);
+	case WM8350_IRQ_CODEC_JCK_DET_L:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_CODEC_JCK_DET_L_EINT);
+	case WM8350_IRQ_CODEC_JCK_DET_R:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_CODEC_JCK_DET_R_EINT);
+	case WM8350_IRQ_CODEC_MICSCD:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_CODEC_MICSCD_EINT);
+	case WM8350_IRQ_CODEC_MICD:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_CODEC_MICD_EINT);
+	case WM8350_IRQ_WKUP_OFF_STATE:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_WKUP_OFF_STATE_EINT);
+	case WM8350_IRQ_WKUP_HIB_STATE:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_WKUP_HIB_STATE_EINT);
+	case WM8350_IRQ_WKUP_CONV_FAULT:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_WKUP_CONV_FAULT_EINT);
+	case WM8350_IRQ_WKUP_WDOG_RST:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_WKUP_OFF_STATE_EINT);
+	case WM8350_IRQ_WKUP_GP_PWR_ON:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_WKUP_GP_PWR_ON_EINT);
+	case WM8350_IRQ_WKUP_ONKEY:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_WKUP_ONKEY_EINT);
+	case WM8350_IRQ_WKUP_GP_WAKEUP:
+		return wm8350_set_bits(wm8350,
+				       WM8350_COMPARATOR_INT_STATUS_MASK,
+				       WM8350_IM_WKUP_GP_WAKEUP_EINT);
+	case WM8350_IRQ_GPIO(0):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP0_EINT);
+	case WM8350_IRQ_GPIO(1):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP1_EINT);
+	case WM8350_IRQ_GPIO(2):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP2_EINT);
+	case WM8350_IRQ_GPIO(3):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP3_EINT);
+	case WM8350_IRQ_GPIO(4):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP4_EINT);
+	case WM8350_IRQ_GPIO(5):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP5_EINT);
+	case WM8350_IRQ_GPIO(6):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP6_EINT);
+	case WM8350_IRQ_GPIO(7):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP7_EINT);
+	case WM8350_IRQ_GPIO(8):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP8_EINT);
+	case WM8350_IRQ_GPIO(9):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP9_EINT);
+	case WM8350_IRQ_GPIO(10):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP10_EINT);
+	case WM8350_IRQ_GPIO(11):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP11_EINT);
+	case WM8350_IRQ_GPIO(12):
+		return wm8350_set_bits(wm8350,
+				       WM8350_GPIO_INT_STATUS_MASK,
+				       WM8350_IM_GP12_EINT);
+	default:
+		dev_warn(wm8350->dev, "Attempting to mask unknown IRQ %d\n",
+			 irq);
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wm8350_mask_irq);
+
+int wm8350_unmask_irq(struct wm8350 *wm8350, int irq)
+{
+	switch (irq) {
+	case WM8350_IRQ_CHG_BAT_HOT:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_BAT_HOT_EINT);
+	case WM8350_IRQ_CHG_BAT_COLD:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_BAT_COLD_EINT);
+	case WM8350_IRQ_CHG_BAT_FAIL:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_BAT_FAIL_EINT);
+	case WM8350_IRQ_CHG_TO:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_TO_EINT);
+	case WM8350_IRQ_CHG_END:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_END_EINT);
+	case WM8350_IRQ_CHG_START:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_START_EINT);
+	case WM8350_IRQ_CHG_FAST_RDY:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_FAST_RDY_EINT);
+	case WM8350_IRQ_RTC_PER:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_RTC_PER_EINT);
+	case WM8350_IRQ_RTC_SEC:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_RTC_SEC_EINT);
+	case WM8350_IRQ_RTC_ALM:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_RTC_ALM_EINT);
+	case WM8350_IRQ_CHG_VBATT_LT_3P9:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_VBATT_LT_3P9_EINT);
+	case WM8350_IRQ_CHG_VBATT_LT_3P1:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_VBATT_LT_3P1_EINT);
+	case WM8350_IRQ_CHG_VBATT_LT_2P85:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_1_MASK,
+					 WM8350_IM_CHG_VBATT_LT_2P85_EINT);
+	case WM8350_IRQ_CS1:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_CS1_EINT);
+	case WM8350_IRQ_CS2:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_CS2_EINT);
+	case WM8350_IRQ_USB_LIMIT:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_USB_LIMIT_EINT);
+	case WM8350_IRQ_AUXADC_DATARDY:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_AUXADC_DATARDY_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP4:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_AUXADC_DCOMP4_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP3:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_AUXADC_DCOMP3_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP2:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_AUXADC_DCOMP2_EINT);
+	case WM8350_IRQ_AUXADC_DCOMP1:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_AUXADC_DCOMP1_EINT);
+	case WM8350_IRQ_SYS_HYST_COMP_FAIL:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_SYS_HYST_COMP_FAIL_EINT);
+	case WM8350_IRQ_SYS_CHIP_GT115:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_SYS_CHIP_GT115_EINT);
+	case WM8350_IRQ_SYS_CHIP_GT140:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_SYS_CHIP_GT140_EINT);
+	case WM8350_IRQ_SYS_WDOG_TO:
+		return wm8350_clear_bits(wm8350, WM8350_INT_STATUS_2_MASK,
+					 WM8350_IM_SYS_WDOG_TO_EINT);
+	case WM8350_IRQ_UV_LDO4:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_LDO4_EINT);
+	case WM8350_IRQ_UV_LDO3:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_LDO3_EINT);
+	case WM8350_IRQ_UV_LDO2:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_LDO2_EINT);
+	case WM8350_IRQ_UV_LDO1:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_LDO1_EINT);
+	case WM8350_IRQ_UV_DC6:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_DC6_EINT);
+	case WM8350_IRQ_UV_DC5:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_DC5_EINT);
+	case WM8350_IRQ_UV_DC4:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_DC4_EINT);
+	case WM8350_IRQ_UV_DC3:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_DC3_EINT);
+	case WM8350_IRQ_UV_DC2:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_DC2_EINT);
+	case WM8350_IRQ_UV_DC1:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_UNDER_VOLTAGE_INT_STATUS_MASK,
+					 WM8350_IM_UV_DC1_EINT);
+	case WM8350_IRQ_OC_LS:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_OVER_CURRENT_INT_STATUS_MASK,
+					 WM8350_IM_OC_LS_EINT);
+	case WM8350_IRQ_EXT_USB_FB:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_EXT_USB_FB_EINT);
+	case WM8350_IRQ_EXT_WALL_FB:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_EXT_WALL_FB_EINT);
+	case WM8350_IRQ_EXT_BAT_FB:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_EXT_BAT_FB_EINT);
+	case WM8350_IRQ_CODEC_JCK_DET_L:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_CODEC_JCK_DET_L_EINT);
+	case WM8350_IRQ_CODEC_JCK_DET_R:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_CODEC_JCK_DET_R_EINT);
+	case WM8350_IRQ_CODEC_MICSCD:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_CODEC_MICSCD_EINT);
+	case WM8350_IRQ_CODEC_MICD:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_CODEC_MICD_EINT);
+	case WM8350_IRQ_WKUP_OFF_STATE:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_WKUP_OFF_STATE_EINT);
+	case WM8350_IRQ_WKUP_HIB_STATE:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_WKUP_HIB_STATE_EINT);
+	case WM8350_IRQ_WKUP_CONV_FAULT:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_WKUP_CONV_FAULT_EINT);
+	case WM8350_IRQ_WKUP_WDOG_RST:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_WKUP_OFF_STATE_EINT);
+	case WM8350_IRQ_WKUP_GP_PWR_ON:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_WKUP_GP_PWR_ON_EINT);
+	case WM8350_IRQ_WKUP_ONKEY:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_WKUP_ONKEY_EINT);
+	case WM8350_IRQ_WKUP_GP_WAKEUP:
+		return wm8350_clear_bits(wm8350,
+					 WM8350_COMPARATOR_INT_STATUS_MASK,
+					 WM8350_IM_WKUP_GP_WAKEUP_EINT);
+	case WM8350_IRQ_GPIO(0):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP0_EINT);
+	case WM8350_IRQ_GPIO(1):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP1_EINT);
+	case WM8350_IRQ_GPIO(2):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP2_EINT);
+	case WM8350_IRQ_GPIO(3):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP3_EINT);
+	case WM8350_IRQ_GPIO(4):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP4_EINT);
+	case WM8350_IRQ_GPIO(5):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP5_EINT);
+	case WM8350_IRQ_GPIO(6):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP6_EINT);
+	case WM8350_IRQ_GPIO(7):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP7_EINT);
+	case WM8350_IRQ_GPIO(8):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP8_EINT);
+	case WM8350_IRQ_GPIO(9):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP9_EINT);
+	case WM8350_IRQ_GPIO(10):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP10_EINT);
+	case WM8350_IRQ_GPIO(11):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP11_EINT);
+	case WM8350_IRQ_GPIO(12):
+		return wm8350_clear_bits(wm8350,
+					 WM8350_GPIO_INT_STATUS_MASK,
+					 WM8350_IM_GP12_EINT);
+	default:
+		dev_warn(wm8350->dev, "Attempting to unmask unknown IRQ %d\n",
+			 irq);
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wm8350_unmask_irq);
+
+int wm8350_irq_init(struct wm8350 *wm8350, int irq,
+		    struct wm8350_platform_data *pdata)
+{
+	int ret;
+	int flags = IRQF_ONESHOT;
+
+	if (!irq) {
+		dev_err(wm8350->dev, "No IRQ configured\n");
+		return -EINVAL;
+	}
+
+	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_INT_STATUS_1_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_INT_STATUS_2_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_UNDER_VOLTAGE_INT_STATUS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_GPIO_INT_STATUS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_COMPARATOR_INT_STATUS_MASK, 0xFFFF);
+
+	mutex_init(&wm8350->irq_mutex);
+	wm8350->chip_irq = irq;
+
+	if (pdata && pdata->irq_high) {
+		flags |= IRQF_TRIGGER_HIGH;
+
+		wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
+				WM8350_IRQ_POL);
+	} else {
+		flags |= IRQF_TRIGGER_LOW;
+
+		wm8350_clear_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
+				  WM8350_IRQ_POL);
+	}
+
+	ret = request_threaded_irq(irq, NULL, wm8350_irq, flags,
+				   "wm8350", wm8350);
+	if (ret != 0)
+		dev_err(wm8350->dev, "Failed to request IRQ: %d\n", ret);
+
+	return ret;
+}
+
+int wm8350_irq_exit(struct wm8350 *wm8350)
+{
+	free_irq(wm8350->chip_irq, wm8350);
+	return 0;
+}
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 1d595de..32197fd 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -681,6 +681,8 @@ int wm8350_register_irq(struct wm8350 *wm8350, int irq,
 int wm8350_free_irq(struct wm8350 *wm8350, int irq);
 int wm8350_mask_irq(struct wm8350 *wm8350, int irq);
 int wm8350_unmask_irq(struct wm8350 *wm8350, int irq);
-
+int wm8350_irq_init(struct wm8350 *wm8350, int irq,
+		    struct wm8350_platform_data *pdata);
+int wm8350_irq_exit(struct wm8350 *wm8350);
 
 #endif
-- 
1.6.4.3

