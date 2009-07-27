Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZG0Nqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZG0Nqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZG0Nqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59142 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754643AbZG0Nq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 03/22] mfd: Add WM831x interrupt support
Date: Mon, 27 Jul 2009 14:45:53 +0100
Message-Id: <1248702372-29534-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x includes an interrupt controller managing interrupts for
the various functions on the chip. This patch adds support for the
core interrupt block on the device.

Ideally this would be supported by genirq, particularly for the
GPIOs, but currently genirq is unable to cope with controllers on
interrupt driven buses so we cut'n'paste the generic interface.
Once genirq is able to cope chips like this it should be a case
of filing the prefixes off the code and redoing wm831x-irq.c to
move over.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c       |   12 +-
 drivers/mfd/wm831x-irq.c        |  559 ++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/core.h |   21 +
 include/linux/mfd/wm831x/irq.h  |  764 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 1354 insertions(+), 2 deletions(-)
 create mode 100644 drivers/mfd/wm831x-irq.c
 create mode 100644 include/linux/mfd/wm831x/irq.h

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index cc1040c..eb63d22 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -19,6 +19,7 @@
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/pdata.h>
+#include <linux/mfd/wm831x/irq.h>
 
 enum wm831x_parent {
 	WM8310 = 0,
@@ -1189,6 +1190,10 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		}
 	}
 
+	ret = wm831x_irq_init(wm831x, irq);
+	if (ret != 0)
+		goto err;
+
 	/* The core device is up, instantiate the subdevices. */
 	switch (parent) {
 	case WM8310:
@@ -1216,19 +1221,21 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 	if (ret != 0) {
 		dev_err(wm831x->dev, "Failed to add children\n");
-		goto err;
+		goto err_irq;
 	}
 
 	if (pdata && pdata->post_init) {
 		ret = pdata->post_init(wm831x);
 		if (ret != 0) {
 			dev_err(wm831x->dev, "post_init() failed: %d\n", ret);
-			goto err;
+			goto err_irq;
 		}
 	}
 
 	return 0;
 
+err_irq:
+	wm831x_irq_exit(wm831x);
 err:
 	mfd_remove_devices(wm831x->dev);
 	kfree(wm831x);
@@ -1238,6 +1245,7 @@ err:
 static void wm831x_device_exit(struct wm831x *wm831x)
 {
 	mfd_remove_devices(wm831x->dev);
+	wm831x_irq_exit(wm831x);
 	kfree(wm831x);
 }
 
diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
new file mode 100644
index 0000000..d3015df
--- /dev/null
+++ b/drivers/mfd/wm831x-irq.c
@@ -0,0 +1,559 @@
+/*
+ * wm831x-irq.c  --  Interrupt controller support for Wolfson WM831x PMICs
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
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
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/pdata.h>
+#include <linux/mfd/wm831x/irq.h>
+
+#include <linux/delay.h>
+
+/*
+ * Since generic IRQs don't currently support interrupt controllers on
+ * interrupt driven buses we don't use genirq but instead provide an
+ * interface that looks very much like the standard ones.  This leads
+ * to some bodges, including storing interrupt handler information in
+ * the static irq_data table we use to look up the data for individual
+ * interrupts, but hopefully won't last too long.
+ */
+
+struct wm831x_irq_data {
+	int primary;
+	int reg;
+	int mask;
+	irq_handler_t handler;
+	void *handler_data;
+};
+
+static struct wm831x_irq_data wm831x_irqs[] = {
+	[WM831X_IRQ_TEMP_THW] = {
+		.primary = WM831X_TEMP_INT,
+		.reg = 1,
+		.mask = WM831X_TEMP_THW_EINT,
+	},
+	[WM831X_IRQ_GPIO_1] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP1_EINT,
+	},
+	[WM831X_IRQ_GPIO_2] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP2_EINT,
+	},
+	[WM831X_IRQ_GPIO_3] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP3_EINT,
+	},
+	[WM831X_IRQ_GPIO_4] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP4_EINT,
+	},
+	[WM831X_IRQ_GPIO_5] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP5_EINT,
+	},
+	[WM831X_IRQ_GPIO_6] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP6_EINT,
+	},
+	[WM831X_IRQ_GPIO_7] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP7_EINT,
+	},
+	[WM831X_IRQ_GPIO_8] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP8_EINT,
+	},
+	[WM831X_IRQ_GPIO_9] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP9_EINT,
+	},
+	[WM831X_IRQ_GPIO_10] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP10_EINT,
+	},
+	[WM831X_IRQ_GPIO_11] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP11_EINT,
+	},
+	[WM831X_IRQ_GPIO_12] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP12_EINT,
+	},
+	[WM831X_IRQ_GPIO_13] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP13_EINT,
+	},
+	[WM831X_IRQ_GPIO_14] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP14_EINT,
+	},
+	[WM831X_IRQ_GPIO_15] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP15_EINT,
+	},
+	[WM831X_IRQ_GPIO_16] = {
+		.primary = WM831X_GP_INT,
+		.reg = 5,
+		.mask = WM831X_GP16_EINT,
+	},
+	[WM831X_IRQ_ON] = {
+		.primary = WM831X_ON_PIN_INT,
+		.reg = 1,
+		.mask = WM831X_ON_PIN_EINT,
+	},
+	[WM831X_IRQ_PPM_SYSLO] = {
+		.primary = WM831X_PPM_INT,
+		.reg = 1,
+		.mask = WM831X_PPM_SYSLO_EINT,
+	},
+	[WM831X_IRQ_PPM_PWR_SRC] = {
+		.primary = WM831X_PPM_INT,
+		.reg = 1,
+		.mask = WM831X_PPM_PWR_SRC_EINT,
+	},
+	[WM831X_IRQ_PPM_USB_CURR] = {
+		.primary = WM831X_PPM_INT,
+		.reg = 1,
+		.mask = WM831X_PPM_USB_CURR_EINT,
+	},
+	[WM831X_IRQ_WDOG_TO] = {
+		.primary = WM831X_WDOG_INT,
+		.reg = 1,
+		.mask = WM831X_WDOG_TO_EINT,
+	},
+	[WM831X_IRQ_RTC_PER] = {
+		.primary = WM831X_RTC_INT,
+		.reg = 1,
+		.mask = WM831X_RTC_PER_EINT,
+	},
+	[WM831X_IRQ_RTC_ALM] = {
+		.primary = WM831X_RTC_INT,
+		.reg = 1,
+		.mask = WM831X_RTC_ALM_EINT,
+	},
+	[WM831X_IRQ_CHG_BATT_HOT] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_BATT_HOT_EINT,
+	},
+	[WM831X_IRQ_CHG_BATT_COLD] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_BATT_COLD_EINT,
+	},
+	[WM831X_IRQ_CHG_BATT_FAIL] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_BATT_FAIL_EINT,
+	},
+	[WM831X_IRQ_CHG_OV] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_OV_EINT,
+	},
+	[WM831X_IRQ_CHG_END] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_END_EINT,
+	},
+	[WM831X_IRQ_CHG_TO] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_TO_EINT,
+	},
+	[WM831X_IRQ_CHG_MODE] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_MODE_EINT,
+	},
+	[WM831X_IRQ_CHG_START] = {
+		.primary = WM831X_CHG_INT,
+		.reg = 2,
+		.mask = WM831X_CHG_START_EINT,
+	},
+	[WM831X_IRQ_TCHDATA] = {
+		.primary = WM831X_TCHDATA_INT,
+		.reg = 1,
+		.mask = WM831X_TCHDATA_EINT,
+	},
+	[WM831X_IRQ_TCHPD] = {
+		.primary = WM831X_TCHPD_INT,
+		.reg = 1,
+		.mask = WM831X_TCHPD_EINT,
+	},
+	[WM831X_IRQ_AUXADC_DATA] = {
+		.primary = WM831X_AUXADC_INT,
+		.reg = 1,
+		.mask = WM831X_AUXADC_DATA_EINT,
+	},
+	[WM831X_IRQ_AUXADC_DCOMP1] = {
+		.primary = WM831X_AUXADC_INT,
+		.reg = 1,
+		.mask = WM831X_AUXADC_DCOMP1_EINT,
+	},
+	[WM831X_IRQ_AUXADC_DCOMP2] = {
+		.primary = WM831X_AUXADC_INT,
+		.reg = 1,
+		.mask = WM831X_AUXADC_DCOMP2_EINT,
+	},
+	[WM831X_IRQ_AUXADC_DCOMP3] = {
+		.primary = WM831X_AUXADC_INT,
+		.reg = 1,
+		.mask = WM831X_AUXADC_DCOMP3_EINT,
+	},
+	[WM831X_IRQ_AUXADC_DCOMP4] = {
+		.primary = WM831X_AUXADC_INT,
+		.reg = 1,
+		.mask = WM831X_AUXADC_DCOMP4_EINT,
+	},
+	[WM831X_IRQ_CS1] = {
+		.primary = WM831X_CS_INT,
+		.reg = 2,
+		.mask = WM831X_CS1_EINT,
+	},
+	[WM831X_IRQ_CS2] = {
+		.primary = WM831X_CS_INT,
+		.reg = 2,
+		.mask = WM831X_CS2_EINT,
+	},
+	[WM831X_IRQ_HC_DC1] = {
+		.primary = WM831X_HC_INT,
+		.reg = 4,
+		.mask = WM831X_HC_DC1_EINT,
+	},
+	[WM831X_IRQ_HC_DC2] = {
+		.primary = WM831X_HC_INT,
+		.reg = 4,
+		.mask = WM831X_HC_DC2_EINT,
+	},
+	[WM831X_IRQ_UV_LDO1] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO1_EINT,
+	},
+	[WM831X_IRQ_UV_LDO2] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO2_EINT,
+	},
+	[WM831X_IRQ_UV_LDO3] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO3_EINT,
+	},
+	[WM831X_IRQ_UV_LDO4] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO4_EINT,
+	},
+	[WM831X_IRQ_UV_LDO5] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO5_EINT,
+	},
+	[WM831X_IRQ_UV_LDO6] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO6_EINT,
+	},
+	[WM831X_IRQ_UV_LDO7] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO7_EINT,
+	},
+	[WM831X_IRQ_UV_LDO8] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO8_EINT,
+	},
+	[WM831X_IRQ_UV_LDO9] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO9_EINT,
+	},
+	[WM831X_IRQ_UV_LDO10] = {
+		.primary = WM831X_UV_INT,
+		.reg = 3,
+		.mask = WM831X_UV_LDO10_EINT,
+	},
+	[WM831X_IRQ_UV_DC1] = {
+		.primary = WM831X_UV_INT,
+		.reg = 4,
+		.mask = WM831X_UV_DC1_EINT,
+	},
+	[WM831X_IRQ_UV_DC2] = {
+		.primary = WM831X_UV_INT,
+		.reg = 4,
+		.mask = WM831X_UV_DC2_EINT,
+	},
+	[WM831X_IRQ_UV_DC3] = {
+		.primary = WM831X_UV_INT,
+		.reg = 4,
+		.mask = WM831X_UV_DC3_EINT,
+	},
+	[WM831X_IRQ_UV_DC4] = {
+		.primary = WM831X_UV_INT,
+		.reg = 4,
+		.mask = WM831X_UV_DC4_EINT,
+	},
+};
+
+static inline int irq_data_to_status_reg(struct wm831x_irq_data *irq_data)
+{
+	return WM831X_INTERRUPT_STATUS_1 - 1 + irq_data->reg;
+}
+
+static inline int irq_data_to_mask_reg(struct wm831x_irq_data *irq_data)
+{
+	return WM831X_INTERRUPT_STATUS_1_MASK - 1 + irq_data->reg;
+}
+
+static void __wm831x_enable_irq(struct wm831x *wm831x, int irq)
+{
+	struct wm831x_irq_data *irq_data = &wm831x_irqs[irq];
+
+	wm831x->irq_masks[irq_data->reg - 1] &= ~irq_data->mask;
+	wm831x_reg_write(wm831x, irq_data_to_mask_reg(irq_data),
+			 wm831x->irq_masks[irq_data->reg - 1]);
+}
+
+void wm831x_enable_irq(struct wm831x *wm831x, int irq)
+{
+	mutex_lock(&wm831x->irq_lock);
+	__wm831x_enable_irq(wm831x, irq);
+	mutex_unlock(&wm831x->irq_lock);
+}
+EXPORT_SYMBOL_GPL(wm831x_enable_irq);
+
+static void __wm831x_disable_irq(struct wm831x *wm831x, int irq)
+{
+	struct wm831x_irq_data *irq_data = &wm831x_irqs[irq];
+
+	wm831x->irq_masks[irq_data->reg - 1] |= irq_data->mask;
+	wm831x_reg_write(wm831x, irq_data_to_mask_reg(irq_data),
+			 wm831x->irq_masks[irq_data->reg - 1]);
+}
+
+void wm831x_disable_irq(struct wm831x *wm831x, int irq)
+{
+	mutex_lock(&wm831x->irq_lock);
+	__wm831x_disable_irq(wm831x, irq);
+	mutex_unlock(&wm831x->irq_lock);
+}
+EXPORT_SYMBOL_GPL(wm831x_disable_irq);
+
+int wm831x_request_irq(struct wm831x *wm831x,
+		       unsigned int irq, irq_handler_t handler,
+		       unsigned long flags, const char *name,
+		       void *dev)
+{
+	int ret = 0;
+
+	if (irq < 0 || irq >= WM831X_NUM_IRQS)
+		return -EINVAL;
+
+	mutex_lock(&wm831x->irq_lock);
+
+	if (wm831x_irqs[irq].handler) {
+		dev_err(wm831x->dev, "Already have handler for IRQ %d\n", irq);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	wm831x_irqs[irq].handler = handler;
+	wm831x_irqs[irq].handler_data = dev;
+
+	__wm831x_enable_irq(wm831x, irq);
+
+out:
+	mutex_unlock(&wm831x->irq_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_request_irq);
+
+void wm831x_free_irq(struct wm831x *wm831x, unsigned int irq, void *data)
+{
+	if (irq < 0 || irq >= WM831X_NUM_IRQS)
+		return;
+
+	mutex_lock(&wm831x->irq_lock);
+
+	wm831x_irqs[irq].handler = NULL;
+	wm831x_irqs[irq].handler_data = NULL;
+
+	__wm831x_disable_irq(wm831x, irq);
+
+	mutex_unlock(&wm831x->irq_lock);
+}
+EXPORT_SYMBOL_GPL(wm831x_free_irq);
+
+
+static void wm831x_handle_irq(struct wm831x *wm831x, int irq, int status)
+{
+	struct wm831x_irq_data *irq_data = &wm831x_irqs[irq];
+
+	if (irq_data->handler) {
+		irq_data->handler(irq, irq_data->handler_data);
+		wm831x_reg_write(wm831x, irq_data_to_status_reg(irq_data),
+				 irq_data->mask);
+	} else {
+		dev_err(wm831x->dev, "Unhandled IRQ %d, masking\n", irq);
+		__wm831x_disable_irq(wm831x, irq);
+	}
+}
+
+/* Main interrupt handling occurs in a workqueue since we need
+ * interrupts enabled to interact with the chip. */
+static void wm831x_irq_worker(struct work_struct *work)
+{
+	struct wm831x *wm831x = container_of(work, struct wm831x, irq_work);
+	unsigned int i;
+	int primary;
+	int status_regs[5];
+	int read[5] = { 0 };
+	int *status;
+
+	primary = wm831x_reg_read(wm831x, WM831X_SYSTEM_INTERRUPTS);
+	if (primary < 0) {
+		dev_err(wm831x->dev, "Failed to read system interrupt: %d\n",
+			primary);
+		goto out;
+	}
+
+	mutex_lock(&wm831x->irq_lock);
+
+	for (i = 0; i < ARRAY_SIZE(wm831x_irqs); i++) {
+		int offset = wm831x_irqs[i].reg - 1;
+
+		if (!(primary & wm831x_irqs[i].primary))
+			continue;
+
+		status = &status_regs[offset];
+
+		/* Hopefully there should only be one register to read
+		 * each time otherwise we ought to do a block read. */
+		if (!read[offset]) {
+			*status = wm831x_reg_read(wm831x,
+				     irq_data_to_status_reg(&wm831x_irqs[i]));
+			if (*status < 0) {
+				dev_err(wm831x->dev,
+					"Failed to read IRQ status: %d\n",
+					*status);
+				goto out_lock;
+			}
+
+			/* Mask out the disabled IRQs */
+			*status &= ~wm831x->irq_masks[offset];
+			read[offset] = 1;
+		}
+
+		if (*status & wm831x_irqs[i].mask)
+			wm831x_handle_irq(wm831x, i, *status);
+	}
+
+out_lock:
+	mutex_unlock(&wm831x->irq_lock);
+out:
+	enable_irq(wm831x->irq);
+}
+
+
+static irqreturn_t wm831x_cpu_irq(int irq, void *data)
+{
+	struct wm831x *wm831x = data;
+
+	/* Shut the interrupt to the CPU up and schedule the actual
+	 * handler; we can't check that the IRQ is asserted. */
+	disable_irq_nosync(irq);
+
+	queue_work(wm831x->irq_wq, &wm831x->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+int wm831x_irq_init(struct wm831x *wm831x, int irq)
+{
+	int i, ret;
+
+	if (!irq) {
+		dev_warn(wm831x->dev,
+			 "No interrupt specified - functionality limited\n");
+		return 0;
+	}
+
+
+	wm831x->irq_wq = create_singlethread_workqueue("wm831x-irq");
+	if (!wm831x->irq_wq) {
+		dev_err(wm831x->dev, "Failed to allocate IRQ worker\n");
+		return -ESRCH;
+	}
+
+	wm831x->irq = irq;
+	mutex_init(&wm831x->irq_lock);
+	INIT_WORK(&wm831x->irq_work, wm831x_irq_worker);
+
+	/* Mask the individual interrupt sources */
+	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks); i++) {
+		wm831x->irq_masks[i] = 0xffff;
+		wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1_MASK + i,
+				 0xffff);
+	}
+
+	/* Enable top level interrupts, we mask at secondary level */
+	wm831x_reg_write(wm831x, WM831X_SYSTEM_INTERRUPTS_MASK, 0);
+
+	/* We're good to go.  We set IRQF_SHARED since there's a
+	 * chance the driver will interoperate with another driver but
+	 * the need to disable the IRQ while handing via I2C/SPI means
+	 * that this may break and performance will be impacted.  If
+	 * this does happen it's a hardware design issue and the only
+	 * other alternative would be polling.
+	 */
+	ret = request_irq(irq, wm831x_cpu_irq, IRQF_TRIGGER_LOW | IRQF_SHARED,
+			  "wm831x", wm831x);
+	if (ret != 0) {
+		dev_err(wm831x->dev, "Failed to request IRQ %d: %d\n",
+			irq, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void wm831x_irq_exit(struct wm831x *wm831x)
+{
+	if (wm831x->irq)
+		free_irq(wm831x->irq, wm831x);
+}
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index d90e693..b96c935 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -15,6 +15,9 @@
 #ifndef __MFD_WM831X_CORE_H__
 #define __MFD_WM831X_CORE_H__
 
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
 /*
  * Register values.
  */
@@ -224,6 +227,13 @@ struct wm831x {
 
 	void *control_data;
 
+	int irq;  /* Our chip IRQ */
+	struct mutex irq_lock;
+	struct workqueue_struct *irq_wq;
+	struct work_struct irq_work;
+	unsigned int irq_base;
+	int irq_masks[5];
+
 	/* The WM831x has a security key blocking access to certain
 	 * registers.  The mutex is taken by the accessors for locking
 	 * and unlocking the security key, locked is used to fail
@@ -244,4 +254,15 @@ int wm831x_set_bits(struct wm831x *wm831x, unsigned short reg,
 int wm831x_bulk_read(struct wm831x *wm831x, unsigned short reg,
 		     int count, u16 *buf);
 
+int wm831x_irq_init(struct wm831x *wm831x, int irq);
+void wm831x_irq_exit(struct wm831x *wm831x);
+
+int __must_check wm831x_request_irq(struct wm831x *wm831x,
+				    unsigned int irq, irq_handler_t handler,
+				    unsigned long flags, const char *name,
+				    void *dev);
+void wm831x_free_irq(struct wm831x *wm831x, unsigned int, void *);
+void wm831x_disable_irq(struct wm831x *wm831x, int irq);
+void wm831x_enable_irq(struct wm831x *wm831x, int irq);
+
 #endif
diff --git a/include/linux/mfd/wm831x/irq.h b/include/linux/mfd/wm831x/irq.h
new file mode 100644
index 0000000..3a8c976
--- /dev/null
+++ b/include/linux/mfd/wm831x/irq.h
@@ -0,0 +1,764 @@
+/*
+ * include/linux/mfd/wm831x/irq.h -- Interrupt controller for WM831x
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM831X_IRQ_H__
+#define __MFD_WM831X_IRQ_H__
+
+/* Interrupt number assignments within Linux */
+#define WM831X_IRQ_TEMP_THW 0
+#define WM831X_IRQ_GPIO_1   1
+#define WM831X_IRQ_GPIO_2   2
+#define WM831X_IRQ_GPIO_3   3
+#define WM831X_IRQ_GPIO_4   4
+#define WM831X_IRQ_GPIO_5   5
+#define WM831X_IRQ_GPIO_6   6
+#define WM831X_IRQ_GPIO_7   7
+#define WM831X_IRQ_GPIO_8   8
+#define WM831X_IRQ_GPIO_9   9
+#define WM831X_IRQ_GPIO_10  10
+#define WM831X_IRQ_GPIO_11  11
+#define WM831X_IRQ_GPIO_12  12
+#define WM831X_IRQ_GPIO_13  13
+#define WM831X_IRQ_GPIO_14  14
+#define WM831X_IRQ_GPIO_15  15
+#define WM831X_IRQ_GPIO_16  16
+#define WM831X_IRQ_ON           17
+#define WM831X_IRQ_PPM_SYSLO    18
+#define WM831X_IRQ_PPM_PWR_SRC  19
+#define WM831X_IRQ_PPM_USB_CURR 20
+#define WM831X_IRQ_WDOG_TO      21
+#define WM831X_IRQ_RTC_PER      22
+#define WM831X_IRQ_RTC_ALM      23
+#define WM831X_IRQ_CHG_BATT_HOT  24
+#define WM831X_IRQ_CHG_BATT_COLD 25
+#define WM831X_IRQ_CHG_BATT_FAIL 26
+#define WM831X_IRQ_CHG_OV        27
+#define WM831X_IRQ_CHG_END       29
+#define WM831X_IRQ_CHG_TO        30
+#define WM831X_IRQ_CHG_MODE      31
+#define WM831X_IRQ_CHG_START     32
+#define WM831X_IRQ_TCHDATA       33
+#define WM831X_IRQ_TCHPD         34
+#define WM831X_IRQ_AUXADC_DATA   35
+#define WM831X_IRQ_AUXADC_DCOMP1 36
+#define WM831X_IRQ_AUXADC_DCOMP2 37
+#define WM831X_IRQ_AUXADC_DCOMP3 38
+#define WM831X_IRQ_AUXADC_DCOMP4 39
+#define WM831X_IRQ_CS1           40
+#define WM831X_IRQ_CS2           41
+#define WM831X_IRQ_HC_DC1        42
+#define WM831X_IRQ_HC_DC2        43
+#define WM831X_IRQ_UV_LDO1       44
+#define WM831X_IRQ_UV_LDO2       45
+#define WM831X_IRQ_UV_LDO3       46
+#define WM831X_IRQ_UV_LDO4       47
+#define WM831X_IRQ_UV_LDO5       48
+#define WM831X_IRQ_UV_LDO6       49
+#define WM831X_IRQ_UV_LDO7       50
+#define WM831X_IRQ_UV_LDO8       51
+#define WM831X_IRQ_UV_LDO9       52
+#define WM831X_IRQ_UV_LDO10      53
+#define WM831X_IRQ_UV_DC1        54
+#define WM831X_IRQ_UV_DC2        55
+#define WM831X_IRQ_UV_DC3        56
+#define WM831X_IRQ_UV_DC4        57
+
+#define WM831X_NUM_IRQS     58
+
+/*
+ * R16400 (0x4010) - System Interrupts
+ */
+#define WM831X_PS_INT                           0x8000  /* PS_INT */
+#define WM831X_PS_INT_MASK                      0x8000  /* PS_INT */
+#define WM831X_PS_INT_SHIFT                         15  /* PS_INT */
+#define WM831X_PS_INT_WIDTH                          1  /* PS_INT */
+#define WM831X_TEMP_INT                         0x4000  /* TEMP_INT */
+#define WM831X_TEMP_INT_MASK                    0x4000  /* TEMP_INT */
+#define WM831X_TEMP_INT_SHIFT                       14  /* TEMP_INT */
+#define WM831X_TEMP_INT_WIDTH                        1  /* TEMP_INT */
+#define WM831X_GP_INT                           0x2000  /* GP_INT */
+#define WM831X_GP_INT_MASK                      0x2000  /* GP_INT */
+#define WM831X_GP_INT_SHIFT                         13  /* GP_INT */
+#define WM831X_GP_INT_WIDTH                          1  /* GP_INT */
+#define WM831X_ON_PIN_INT                       0x1000  /* ON_PIN_INT */
+#define WM831X_ON_PIN_INT_MASK                  0x1000  /* ON_PIN_INT */
+#define WM831X_ON_PIN_INT_SHIFT                     12  /* ON_PIN_INT */
+#define WM831X_ON_PIN_INT_WIDTH                      1  /* ON_PIN_INT */
+#define WM831X_WDOG_INT                         0x0800  /* WDOG_INT */
+#define WM831X_WDOG_INT_MASK                    0x0800  /* WDOG_INT */
+#define WM831X_WDOG_INT_SHIFT                       11  /* WDOG_INT */
+#define WM831X_WDOG_INT_WIDTH                        1  /* WDOG_INT */
+#define WM831X_TCHDATA_INT                      0x0400  /* TCHDATA_INT */
+#define WM831X_TCHDATA_INT_MASK                 0x0400  /* TCHDATA_INT */
+#define WM831X_TCHDATA_INT_SHIFT                    10  /* TCHDATA_INT */
+#define WM831X_TCHDATA_INT_WIDTH                     1  /* TCHDATA_INT */
+#define WM831X_TCHPD_INT                        0x0200  /* TCHPD_INT */
+#define WM831X_TCHPD_INT_MASK                   0x0200  /* TCHPD_INT */
+#define WM831X_TCHPD_INT_SHIFT                       9  /* TCHPD_INT */
+#define WM831X_TCHPD_INT_WIDTH                       1  /* TCHPD_INT */
+#define WM831X_AUXADC_INT                       0x0100  /* AUXADC_INT */
+#define WM831X_AUXADC_INT_MASK                  0x0100  /* AUXADC_INT */
+#define WM831X_AUXADC_INT_SHIFT                      8  /* AUXADC_INT */
+#define WM831X_AUXADC_INT_WIDTH                      1  /* AUXADC_INT */
+#define WM831X_PPM_INT                          0x0080  /* PPM_INT */
+#define WM831X_PPM_INT_MASK                     0x0080  /* PPM_INT */
+#define WM831X_PPM_INT_SHIFT                         7  /* PPM_INT */
+#define WM831X_PPM_INT_WIDTH                         1  /* PPM_INT */
+#define WM831X_CS_INT                           0x0040  /* CS_INT */
+#define WM831X_CS_INT_MASK                      0x0040  /* CS_INT */
+#define WM831X_CS_INT_SHIFT                          6  /* CS_INT */
+#define WM831X_CS_INT_WIDTH                          1  /* CS_INT */
+#define WM831X_RTC_INT                          0x0020  /* RTC_INT */
+#define WM831X_RTC_INT_MASK                     0x0020  /* RTC_INT */
+#define WM831X_RTC_INT_SHIFT                         5  /* RTC_INT */
+#define WM831X_RTC_INT_WIDTH                         1  /* RTC_INT */
+#define WM831X_OTP_INT                          0x0010  /* OTP_INT */
+#define WM831X_OTP_INT_MASK                     0x0010  /* OTP_INT */
+#define WM831X_OTP_INT_SHIFT                         4  /* OTP_INT */
+#define WM831X_OTP_INT_WIDTH                         1  /* OTP_INT */
+#define WM831X_CHILD_INT                        0x0008  /* CHILD_INT */
+#define WM831X_CHILD_INT_MASK                   0x0008  /* CHILD_INT */
+#define WM831X_CHILD_INT_SHIFT                       3  /* CHILD_INT */
+#define WM831X_CHILD_INT_WIDTH                       1  /* CHILD_INT */
+#define WM831X_CHG_INT                          0x0004  /* CHG_INT */
+#define WM831X_CHG_INT_MASK                     0x0004  /* CHG_INT */
+#define WM831X_CHG_INT_SHIFT                         2  /* CHG_INT */
+#define WM831X_CHG_INT_WIDTH                         1  /* CHG_INT */
+#define WM831X_HC_INT                           0x0002  /* HC_INT */
+#define WM831X_HC_INT_MASK                      0x0002  /* HC_INT */
+#define WM831X_HC_INT_SHIFT                          1  /* HC_INT */
+#define WM831X_HC_INT_WIDTH                          1  /* HC_INT */
+#define WM831X_UV_INT                           0x0001  /* UV_INT */
+#define WM831X_UV_INT_MASK                      0x0001  /* UV_INT */
+#define WM831X_UV_INT_SHIFT                          0  /* UV_INT */
+#define WM831X_UV_INT_WIDTH                          1  /* UV_INT */
+
+/*
+ * R16401 (0x4011) - Interrupt Status 1
+ */
+#define WM831X_PPM_SYSLO_EINT                   0x8000  /* PPM_SYSLO_EINT */
+#define WM831X_PPM_SYSLO_EINT_MASK              0x8000  /* PPM_SYSLO_EINT */
+#define WM831X_PPM_SYSLO_EINT_SHIFT                 15  /* PPM_SYSLO_EINT */
+#define WM831X_PPM_SYSLO_EINT_WIDTH                  1  /* PPM_SYSLO_EINT */
+#define WM831X_PPM_PWR_SRC_EINT                 0x4000  /* PPM_PWR_SRC_EINT */
+#define WM831X_PPM_PWR_SRC_EINT_MASK            0x4000  /* PPM_PWR_SRC_EINT */
+#define WM831X_PPM_PWR_SRC_EINT_SHIFT               14  /* PPM_PWR_SRC_EINT */
+#define WM831X_PPM_PWR_SRC_EINT_WIDTH                1  /* PPM_PWR_SRC_EINT */
+#define WM831X_PPM_USB_CURR_EINT                0x2000  /* PPM_USB_CURR_EINT */
+#define WM831X_PPM_USB_CURR_EINT_MASK           0x2000  /* PPM_USB_CURR_EINT */
+#define WM831X_PPM_USB_CURR_EINT_SHIFT              13  /* PPM_USB_CURR_EINT */
+#define WM831X_PPM_USB_CURR_EINT_WIDTH               1  /* PPM_USB_CURR_EINT */
+#define WM831X_ON_PIN_EINT                      0x1000  /* ON_PIN_EINT */
+#define WM831X_ON_PIN_EINT_MASK                 0x1000  /* ON_PIN_EINT */
+#define WM831X_ON_PIN_EINT_SHIFT                    12  /* ON_PIN_EINT */
+#define WM831X_ON_PIN_EINT_WIDTH                     1  /* ON_PIN_EINT */
+#define WM831X_WDOG_TO_EINT                     0x0800  /* WDOG_TO_EINT */
+#define WM831X_WDOG_TO_EINT_MASK                0x0800  /* WDOG_TO_EINT */
+#define WM831X_WDOG_TO_EINT_SHIFT                   11  /* WDOG_TO_EINT */
+#define WM831X_WDOG_TO_EINT_WIDTH                    1  /* WDOG_TO_EINT */
+#define WM831X_TCHDATA_EINT                     0x0400  /* TCHDATA_EINT */
+#define WM831X_TCHDATA_EINT_MASK                0x0400  /* TCHDATA_EINT */
+#define WM831X_TCHDATA_EINT_SHIFT                   10  /* TCHDATA_EINT */
+#define WM831X_TCHDATA_EINT_WIDTH                    1  /* TCHDATA_EINT */
+#define WM831X_TCHPD_EINT                       0x0200  /* TCHPD_EINT */
+#define WM831X_TCHPD_EINT_MASK                  0x0200  /* TCHPD_EINT */
+#define WM831X_TCHPD_EINT_SHIFT                      9  /* TCHPD_EINT */
+#define WM831X_TCHPD_EINT_WIDTH                      1  /* TCHPD_EINT */
+#define WM831X_AUXADC_DATA_EINT                 0x0100  /* AUXADC_DATA_EINT */
+#define WM831X_AUXADC_DATA_EINT_MASK            0x0100  /* AUXADC_DATA_EINT */
+#define WM831X_AUXADC_DATA_EINT_SHIFT                8  /* AUXADC_DATA_EINT */
+#define WM831X_AUXADC_DATA_EINT_WIDTH                1  /* AUXADC_DATA_EINT */
+#define WM831X_AUXADC_DCOMP4_EINT               0x0080  /* AUXADC_DCOMP4_EINT */
+#define WM831X_AUXADC_DCOMP4_EINT_MASK          0x0080  /* AUXADC_DCOMP4_EINT */
+#define WM831X_AUXADC_DCOMP4_EINT_SHIFT              7  /* AUXADC_DCOMP4_EINT */
+#define WM831X_AUXADC_DCOMP4_EINT_WIDTH              1  /* AUXADC_DCOMP4_EINT */
+#define WM831X_AUXADC_DCOMP3_EINT               0x0040  /* AUXADC_DCOMP3_EINT */
+#define WM831X_AUXADC_DCOMP3_EINT_MASK          0x0040  /* AUXADC_DCOMP3_EINT */
+#define WM831X_AUXADC_DCOMP3_EINT_SHIFT              6  /* AUXADC_DCOMP3_EINT */
+#define WM831X_AUXADC_DCOMP3_EINT_WIDTH              1  /* AUXADC_DCOMP3_EINT */
+#define WM831X_AUXADC_DCOMP2_EINT               0x0020  /* AUXADC_DCOMP2_EINT */
+#define WM831X_AUXADC_DCOMP2_EINT_MASK          0x0020  /* AUXADC_DCOMP2_EINT */
+#define WM831X_AUXADC_DCOMP2_EINT_SHIFT              5  /* AUXADC_DCOMP2_EINT */
+#define WM831X_AUXADC_DCOMP2_EINT_WIDTH              1  /* AUXADC_DCOMP2_EINT */
+#define WM831X_AUXADC_DCOMP1_EINT               0x0010  /* AUXADC_DCOMP1_EINT */
+#define WM831X_AUXADC_DCOMP1_EINT_MASK          0x0010  /* AUXADC_DCOMP1_EINT */
+#define WM831X_AUXADC_DCOMP1_EINT_SHIFT              4  /* AUXADC_DCOMP1_EINT */
+#define WM831X_AUXADC_DCOMP1_EINT_WIDTH              1  /* AUXADC_DCOMP1_EINT */
+#define WM831X_RTC_PER_EINT                     0x0008  /* RTC_PER_EINT */
+#define WM831X_RTC_PER_EINT_MASK                0x0008  /* RTC_PER_EINT */
+#define WM831X_RTC_PER_EINT_SHIFT                    3  /* RTC_PER_EINT */
+#define WM831X_RTC_PER_EINT_WIDTH                    1  /* RTC_PER_EINT */
+#define WM831X_RTC_ALM_EINT                     0x0004  /* RTC_ALM_EINT */
+#define WM831X_RTC_ALM_EINT_MASK                0x0004  /* RTC_ALM_EINT */
+#define WM831X_RTC_ALM_EINT_SHIFT                    2  /* RTC_ALM_EINT */
+#define WM831X_RTC_ALM_EINT_WIDTH                    1  /* RTC_ALM_EINT */
+#define WM831X_TEMP_THW_EINT                    0x0002  /* TEMP_THW_EINT */
+#define WM831X_TEMP_THW_EINT_MASK               0x0002  /* TEMP_THW_EINT */
+#define WM831X_TEMP_THW_EINT_SHIFT                   1  /* TEMP_THW_EINT */
+#define WM831X_TEMP_THW_EINT_WIDTH                   1  /* TEMP_THW_EINT */
+
+/*
+ * R16402 (0x4012) - Interrupt Status 2
+ */
+#define WM831X_CHG_BATT_HOT_EINT                0x8000  /* CHG_BATT_HOT_EINT */
+#define WM831X_CHG_BATT_HOT_EINT_MASK           0x8000  /* CHG_BATT_HOT_EINT */
+#define WM831X_CHG_BATT_HOT_EINT_SHIFT              15  /* CHG_BATT_HOT_EINT */
+#define WM831X_CHG_BATT_HOT_EINT_WIDTH               1  /* CHG_BATT_HOT_EINT */
+#define WM831X_CHG_BATT_COLD_EINT               0x4000  /* CHG_BATT_COLD_EINT */
+#define WM831X_CHG_BATT_COLD_EINT_MASK          0x4000  /* CHG_BATT_COLD_EINT */
+#define WM831X_CHG_BATT_COLD_EINT_SHIFT             14  /* CHG_BATT_COLD_EINT */
+#define WM831X_CHG_BATT_COLD_EINT_WIDTH              1  /* CHG_BATT_COLD_EINT */
+#define WM831X_CHG_BATT_FAIL_EINT               0x2000  /* CHG_BATT_FAIL_EINT */
+#define WM831X_CHG_BATT_FAIL_EINT_MASK          0x2000  /* CHG_BATT_FAIL_EINT */
+#define WM831X_CHG_BATT_FAIL_EINT_SHIFT             13  /* CHG_BATT_FAIL_EINT */
+#define WM831X_CHG_BATT_FAIL_EINT_WIDTH              1  /* CHG_BATT_FAIL_EINT */
+#define WM831X_CHG_OV_EINT                      0x1000  /* CHG_OV_EINT */
+#define WM831X_CHG_OV_EINT_MASK                 0x1000  /* CHG_OV_EINT */
+#define WM831X_CHG_OV_EINT_SHIFT                    12  /* CHG_OV_EINT */
+#define WM831X_CHG_OV_EINT_WIDTH                     1  /* CHG_OV_EINT */
+#define WM831X_CHG_END_EINT                     0x0800  /* CHG_END_EINT */
+#define WM831X_CHG_END_EINT_MASK                0x0800  /* CHG_END_EINT */
+#define WM831X_CHG_END_EINT_SHIFT                   11  /* CHG_END_EINT */
+#define WM831X_CHG_END_EINT_WIDTH                    1  /* CHG_END_EINT */
+#define WM831X_CHG_TO_EINT                      0x0400  /* CHG_TO_EINT */
+#define WM831X_CHG_TO_EINT_MASK                 0x0400  /* CHG_TO_EINT */
+#define WM831X_CHG_TO_EINT_SHIFT                    10  /* CHG_TO_EINT */
+#define WM831X_CHG_TO_EINT_WIDTH                     1  /* CHG_TO_EINT */
+#define WM831X_CHG_MODE_EINT                    0x0200  /* CHG_MODE_EINT */
+#define WM831X_CHG_MODE_EINT_MASK               0x0200  /* CHG_MODE_EINT */
+#define WM831X_CHG_MODE_EINT_SHIFT                   9  /* CHG_MODE_EINT */
+#define WM831X_CHG_MODE_EINT_WIDTH                   1  /* CHG_MODE_EINT */
+#define WM831X_CHG_START_EINT                   0x0100  /* CHG_START_EINT */
+#define WM831X_CHG_START_EINT_MASK              0x0100  /* CHG_START_EINT */
+#define WM831X_CHG_START_EINT_SHIFT                  8  /* CHG_START_EINT */
+#define WM831X_CHG_START_EINT_WIDTH                  1  /* CHG_START_EINT */
+#define WM831X_CS2_EINT                         0x0080  /* CS2_EINT */
+#define WM831X_CS2_EINT_MASK                    0x0080  /* CS2_EINT */
+#define WM831X_CS2_EINT_SHIFT                        7  /* CS2_EINT */
+#define WM831X_CS2_EINT_WIDTH                        1  /* CS2_EINT */
+#define WM831X_CS1_EINT                         0x0040  /* CS1_EINT */
+#define WM831X_CS1_EINT_MASK                    0x0040  /* CS1_EINT */
+#define WM831X_CS1_EINT_SHIFT                        6  /* CS1_EINT */
+#define WM831X_CS1_EINT_WIDTH                        1  /* CS1_EINT */
+#define WM831X_OTP_CMD_END_EINT                 0x0020  /* OTP_CMD_END_EINT */
+#define WM831X_OTP_CMD_END_EINT_MASK            0x0020  /* OTP_CMD_END_EINT */
+#define WM831X_OTP_CMD_END_EINT_SHIFT                5  /* OTP_CMD_END_EINT */
+#define WM831X_OTP_CMD_END_EINT_WIDTH                1  /* OTP_CMD_END_EINT */
+#define WM831X_OTP_ERR_EINT                     0x0010  /* OTP_ERR_EINT */
+#define WM831X_OTP_ERR_EINT_MASK                0x0010  /* OTP_ERR_EINT */
+#define WM831X_OTP_ERR_EINT_SHIFT                    4  /* OTP_ERR_EINT */
+#define WM831X_OTP_ERR_EINT_WIDTH                    1  /* OTP_ERR_EINT */
+#define WM831X_PS_POR_EINT                      0x0004  /* PS_POR_EINT */
+#define WM831X_PS_POR_EINT_MASK                 0x0004  /* PS_POR_EINT */
+#define WM831X_PS_POR_EINT_SHIFT                     2  /* PS_POR_EINT */
+#define WM831X_PS_POR_EINT_WIDTH                     1  /* PS_POR_EINT */
+#define WM831X_PS_SLEEP_OFF_EINT                0x0002  /* PS_SLEEP_OFF_EINT */
+#define WM831X_PS_SLEEP_OFF_EINT_MASK           0x0002  /* PS_SLEEP_OFF_EINT */
+#define WM831X_PS_SLEEP_OFF_EINT_SHIFT               1  /* PS_SLEEP_OFF_EINT */
+#define WM831X_PS_SLEEP_OFF_EINT_WIDTH               1  /* PS_SLEEP_OFF_EINT */
+#define WM831X_PS_ON_WAKE_EINT                  0x0001  /* PS_ON_WAKE_EINT */
+#define WM831X_PS_ON_WAKE_EINT_MASK             0x0001  /* PS_ON_WAKE_EINT */
+#define WM831X_PS_ON_WAKE_EINT_SHIFT                 0  /* PS_ON_WAKE_EINT */
+#define WM831X_PS_ON_WAKE_EINT_WIDTH                 1  /* PS_ON_WAKE_EINT */
+
+/*
+ * R16403 (0x4013) - Interrupt Status 3
+ */
+#define WM831X_UV_LDO10_EINT                    0x0200  /* UV_LDO10_EINT */
+#define WM831X_UV_LDO10_EINT_MASK               0x0200  /* UV_LDO10_EINT */
+#define WM831X_UV_LDO10_EINT_SHIFT                   9  /* UV_LDO10_EINT */
+#define WM831X_UV_LDO10_EINT_WIDTH                   1  /* UV_LDO10_EINT */
+#define WM831X_UV_LDO9_EINT                     0x0100  /* UV_LDO9_EINT */
+#define WM831X_UV_LDO9_EINT_MASK                0x0100  /* UV_LDO9_EINT */
+#define WM831X_UV_LDO9_EINT_SHIFT                    8  /* UV_LDO9_EINT */
+#define WM831X_UV_LDO9_EINT_WIDTH                    1  /* UV_LDO9_EINT */
+#define WM831X_UV_LDO8_EINT                     0x0080  /* UV_LDO8_EINT */
+#define WM831X_UV_LDO8_EINT_MASK                0x0080  /* UV_LDO8_EINT */
+#define WM831X_UV_LDO8_EINT_SHIFT                    7  /* UV_LDO8_EINT */
+#define WM831X_UV_LDO8_EINT_WIDTH                    1  /* UV_LDO8_EINT */
+#define WM831X_UV_LDO7_EINT                     0x0040  /* UV_LDO7_EINT */
+#define WM831X_UV_LDO7_EINT_MASK                0x0040  /* UV_LDO7_EINT */
+#define WM831X_UV_LDO7_EINT_SHIFT                    6  /* UV_LDO7_EINT */
+#define WM831X_UV_LDO7_EINT_WIDTH                    1  /* UV_LDO7_EINT */
+#define WM831X_UV_LDO6_EINT                     0x0020  /* UV_LDO6_EINT */
+#define WM831X_UV_LDO6_EINT_MASK                0x0020  /* UV_LDO6_EINT */
+#define WM831X_UV_LDO6_EINT_SHIFT                    5  /* UV_LDO6_EINT */
+#define WM831X_UV_LDO6_EINT_WIDTH                    1  /* UV_LDO6_EINT */
+#define WM831X_UV_LDO5_EINT                     0x0010  /* UV_LDO5_EINT */
+#define WM831X_UV_LDO5_EINT_MASK                0x0010  /* UV_LDO5_EINT */
+#define WM831X_UV_LDO5_EINT_SHIFT                    4  /* UV_LDO5_EINT */
+#define WM831X_UV_LDO5_EINT_WIDTH                    1  /* UV_LDO5_EINT */
+#define WM831X_UV_LDO4_EINT                     0x0008  /* UV_LDO4_EINT */
+#define WM831X_UV_LDO4_EINT_MASK                0x0008  /* UV_LDO4_EINT */
+#define WM831X_UV_LDO4_EINT_SHIFT                    3  /* UV_LDO4_EINT */
+#define WM831X_UV_LDO4_EINT_WIDTH                    1  /* UV_LDO4_EINT */
+#define WM831X_UV_LDO3_EINT                     0x0004  /* UV_LDO3_EINT */
+#define WM831X_UV_LDO3_EINT_MASK                0x0004  /* UV_LDO3_EINT */
+#define WM831X_UV_LDO3_EINT_SHIFT                    2  /* UV_LDO3_EINT */
+#define WM831X_UV_LDO3_EINT_WIDTH                    1  /* UV_LDO3_EINT */
+#define WM831X_UV_LDO2_EINT                     0x0002  /* UV_LDO2_EINT */
+#define WM831X_UV_LDO2_EINT_MASK                0x0002  /* UV_LDO2_EINT */
+#define WM831X_UV_LDO2_EINT_SHIFT                    1  /* UV_LDO2_EINT */
+#define WM831X_UV_LDO2_EINT_WIDTH                    1  /* UV_LDO2_EINT */
+#define WM831X_UV_LDO1_EINT                     0x0001  /* UV_LDO1_EINT */
+#define WM831X_UV_LDO1_EINT_MASK                0x0001  /* UV_LDO1_EINT */
+#define WM831X_UV_LDO1_EINT_SHIFT                    0  /* UV_LDO1_EINT */
+#define WM831X_UV_LDO1_EINT_WIDTH                    1  /* UV_LDO1_EINT */
+
+/*
+ * R16404 (0x4014) - Interrupt Status 4
+ */
+#define WM831X_HC_DC2_EINT                      0x0200  /* HC_DC2_EINT */
+#define WM831X_HC_DC2_EINT_MASK                 0x0200  /* HC_DC2_EINT */
+#define WM831X_HC_DC2_EINT_SHIFT                     9  /* HC_DC2_EINT */
+#define WM831X_HC_DC2_EINT_WIDTH                     1  /* HC_DC2_EINT */
+#define WM831X_HC_DC1_EINT                      0x0100  /* HC_DC1_EINT */
+#define WM831X_HC_DC1_EINT_MASK                 0x0100  /* HC_DC1_EINT */
+#define WM831X_HC_DC1_EINT_SHIFT                     8  /* HC_DC1_EINT */
+#define WM831X_HC_DC1_EINT_WIDTH                     1  /* HC_DC1_EINT */
+#define WM831X_UV_DC4_EINT                      0x0008  /* UV_DC4_EINT */
+#define WM831X_UV_DC4_EINT_MASK                 0x0008  /* UV_DC4_EINT */
+#define WM831X_UV_DC4_EINT_SHIFT                     3  /* UV_DC4_EINT */
+#define WM831X_UV_DC4_EINT_WIDTH                     1  /* UV_DC4_EINT */
+#define WM831X_UV_DC3_EINT                      0x0004  /* UV_DC3_EINT */
+#define WM831X_UV_DC3_EINT_MASK                 0x0004  /* UV_DC3_EINT */
+#define WM831X_UV_DC3_EINT_SHIFT                     2  /* UV_DC3_EINT */
+#define WM831X_UV_DC3_EINT_WIDTH                     1  /* UV_DC3_EINT */
+#define WM831X_UV_DC2_EINT                      0x0002  /* UV_DC2_EINT */
+#define WM831X_UV_DC2_EINT_MASK                 0x0002  /* UV_DC2_EINT */
+#define WM831X_UV_DC2_EINT_SHIFT                     1  /* UV_DC2_EINT */
+#define WM831X_UV_DC2_EINT_WIDTH                     1  /* UV_DC2_EINT */
+#define WM831X_UV_DC1_EINT                      0x0001  /* UV_DC1_EINT */
+#define WM831X_UV_DC1_EINT_MASK                 0x0001  /* UV_DC1_EINT */
+#define WM831X_UV_DC1_EINT_SHIFT                     0  /* UV_DC1_EINT */
+#define WM831X_UV_DC1_EINT_WIDTH                     1  /* UV_DC1_EINT */
+
+/*
+ * R16405 (0x4015) - Interrupt Status 5
+ */
+#define WM831X_GP16_EINT                        0x8000  /* GP16_EINT */
+#define WM831X_GP16_EINT_MASK                   0x8000  /* GP16_EINT */
+#define WM831X_GP16_EINT_SHIFT                      15  /* GP16_EINT */
+#define WM831X_GP16_EINT_WIDTH                       1  /* GP16_EINT */
+#define WM831X_GP15_EINT                        0x4000  /* GP15_EINT */
+#define WM831X_GP15_EINT_MASK                   0x4000  /* GP15_EINT */
+#define WM831X_GP15_EINT_SHIFT                      14  /* GP15_EINT */
+#define WM831X_GP15_EINT_WIDTH                       1  /* GP15_EINT */
+#define WM831X_GP14_EINT                        0x2000  /* GP14_EINT */
+#define WM831X_GP14_EINT_MASK                   0x2000  /* GP14_EINT */
+#define WM831X_GP14_EINT_SHIFT                      13  /* GP14_EINT */
+#define WM831X_GP14_EINT_WIDTH                       1  /* GP14_EINT */
+#define WM831X_GP13_EINT                        0x1000  /* GP13_EINT */
+#define WM831X_GP13_EINT_MASK                   0x1000  /* GP13_EINT */
+#define WM831X_GP13_EINT_SHIFT                      12  /* GP13_EINT */
+#define WM831X_GP13_EINT_WIDTH                       1  /* GP13_EINT */
+#define WM831X_GP12_EINT                        0x0800  /* GP12_EINT */
+#define WM831X_GP12_EINT_MASK                   0x0800  /* GP12_EINT */
+#define WM831X_GP12_EINT_SHIFT                      11  /* GP12_EINT */
+#define WM831X_GP12_EINT_WIDTH                       1  /* GP12_EINT */
+#define WM831X_GP11_EINT                        0x0400  /* GP11_EINT */
+#define WM831X_GP11_EINT_MASK                   0x0400  /* GP11_EINT */
+#define WM831X_GP11_EINT_SHIFT                      10  /* GP11_EINT */
+#define WM831X_GP11_EINT_WIDTH                       1  /* GP11_EINT */
+#define WM831X_GP10_EINT                        0x0200  /* GP10_EINT */
+#define WM831X_GP10_EINT_MASK                   0x0200  /* GP10_EINT */
+#define WM831X_GP10_EINT_SHIFT                       9  /* GP10_EINT */
+#define WM831X_GP10_EINT_WIDTH                       1  /* GP10_EINT */
+#define WM831X_GP9_EINT                         0x0100  /* GP9_EINT */
+#define WM831X_GP9_EINT_MASK                    0x0100  /* GP9_EINT */
+#define WM831X_GP9_EINT_SHIFT                        8  /* GP9_EINT */
+#define WM831X_GP9_EINT_WIDTH                        1  /* GP9_EINT */
+#define WM831X_GP8_EINT                         0x0080  /* GP8_EINT */
+#define WM831X_GP8_EINT_MASK                    0x0080  /* GP8_EINT */
+#define WM831X_GP8_EINT_SHIFT                        7  /* GP8_EINT */
+#define WM831X_GP8_EINT_WIDTH                        1  /* GP8_EINT */
+#define WM831X_GP7_EINT                         0x0040  /* GP7_EINT */
+#define WM831X_GP7_EINT_MASK                    0x0040  /* GP7_EINT */
+#define WM831X_GP7_EINT_SHIFT                        6  /* GP7_EINT */
+#define WM831X_GP7_EINT_WIDTH                        1  /* GP7_EINT */
+#define WM831X_GP6_EINT                         0x0020  /* GP6_EINT */
+#define WM831X_GP6_EINT_MASK                    0x0020  /* GP6_EINT */
+#define WM831X_GP6_EINT_SHIFT                        5  /* GP6_EINT */
+#define WM831X_GP6_EINT_WIDTH                        1  /* GP6_EINT */
+#define WM831X_GP5_EINT                         0x0010  /* GP5_EINT */
+#define WM831X_GP5_EINT_MASK                    0x0010  /* GP5_EINT */
+#define WM831X_GP5_EINT_SHIFT                        4  /* GP5_EINT */
+#define WM831X_GP5_EINT_WIDTH                        1  /* GP5_EINT */
+#define WM831X_GP4_EINT                         0x0008  /* GP4_EINT */
+#define WM831X_GP4_EINT_MASK                    0x0008  /* GP4_EINT */
+#define WM831X_GP4_EINT_SHIFT                        3  /* GP4_EINT */
+#define WM831X_GP4_EINT_WIDTH                        1  /* GP4_EINT */
+#define WM831X_GP3_EINT                         0x0004  /* GP3_EINT */
+#define WM831X_GP3_EINT_MASK                    0x0004  /* GP3_EINT */
+#define WM831X_GP3_EINT_SHIFT                        2  /* GP3_EINT */
+#define WM831X_GP3_EINT_WIDTH                        1  /* GP3_EINT */
+#define WM831X_GP2_EINT                         0x0002  /* GP2_EINT */
+#define WM831X_GP2_EINT_MASK                    0x0002  /* GP2_EINT */
+#define WM831X_GP2_EINT_SHIFT                        1  /* GP2_EINT */
+#define WM831X_GP2_EINT_WIDTH                        1  /* GP2_EINT */
+#define WM831X_GP1_EINT                         0x0001  /* GP1_EINT */
+#define WM831X_GP1_EINT_MASK                    0x0001  /* GP1_EINT */
+#define WM831X_GP1_EINT_SHIFT                        0  /* GP1_EINT */
+#define WM831X_GP1_EINT_WIDTH                        1  /* GP1_EINT */
+
+/*
+ * R16407 (0x4017) - IRQ Config
+ */
+#define WM831X_IRQ_OD                           0x0002  /* IRQ_OD */
+#define WM831X_IRQ_OD_MASK                      0x0002  /* IRQ_OD */
+#define WM831X_IRQ_OD_SHIFT                          1  /* IRQ_OD */
+#define WM831X_IRQ_OD_WIDTH                          1  /* IRQ_OD */
+#define WM831X_IM_IRQ                           0x0001  /* IM_IRQ */
+#define WM831X_IM_IRQ_MASK                      0x0001  /* IM_IRQ */
+#define WM831X_IM_IRQ_SHIFT                          0  /* IM_IRQ */
+#define WM831X_IM_IRQ_WIDTH                          1  /* IM_IRQ */
+
+/*
+ * R16408 (0x4018) - System Interrupts Mask
+ */
+#define WM831X_IM_PS_INT                        0x8000  /* IM_PS_INT */
+#define WM831X_IM_PS_INT_MASK                   0x8000  /* IM_PS_INT */
+#define WM831X_IM_PS_INT_SHIFT                      15  /* IM_PS_INT */
+#define WM831X_IM_PS_INT_WIDTH                       1  /* IM_PS_INT */
+#define WM831X_IM_TEMP_INT                      0x4000  /* IM_TEMP_INT */
+#define WM831X_IM_TEMP_INT_MASK                 0x4000  /* IM_TEMP_INT */
+#define WM831X_IM_TEMP_INT_SHIFT                    14  /* IM_TEMP_INT */
+#define WM831X_IM_TEMP_INT_WIDTH                     1  /* IM_TEMP_INT */
+#define WM831X_IM_GP_INT                        0x2000  /* IM_GP_INT */
+#define WM831X_IM_GP_INT_MASK                   0x2000  /* IM_GP_INT */
+#define WM831X_IM_GP_INT_SHIFT                      13  /* IM_GP_INT */
+#define WM831X_IM_GP_INT_WIDTH                       1  /* IM_GP_INT */
+#define WM831X_IM_ON_PIN_INT                    0x1000  /* IM_ON_PIN_INT */
+#define WM831X_IM_ON_PIN_INT_MASK               0x1000  /* IM_ON_PIN_INT */
+#define WM831X_IM_ON_PIN_INT_SHIFT                  12  /* IM_ON_PIN_INT */
+#define WM831X_IM_ON_PIN_INT_WIDTH                   1  /* IM_ON_PIN_INT */
+#define WM831X_IM_WDOG_INT                      0x0800  /* IM_WDOG_INT */
+#define WM831X_IM_WDOG_INT_MASK                 0x0800  /* IM_WDOG_INT */
+#define WM831X_IM_WDOG_INT_SHIFT                    11  /* IM_WDOG_INT */
+#define WM831X_IM_WDOG_INT_WIDTH                     1  /* IM_WDOG_INT */
+#define WM831X_IM_TCHDATA_INT                   0x0400  /* IM_TCHDATA_INT */
+#define WM831X_IM_TCHDATA_INT_MASK              0x0400  /* IM_TCHDATA_INT */
+#define WM831X_IM_TCHDATA_INT_SHIFT                 10  /* IM_TCHDATA_INT */
+#define WM831X_IM_TCHDATA_INT_WIDTH                  1  /* IM_TCHDATA_INT */
+#define WM831X_IM_TCHPD_INT                     0x0200  /* IM_TCHPD_INT */
+#define WM831X_IM_TCHPD_INT_MASK                0x0200  /* IM_TCHPD_INT */
+#define WM831X_IM_TCHPD_INT_SHIFT                    9  /* IM_TCHPD_INT */
+#define WM831X_IM_TCHPD_INT_WIDTH                    1  /* IM_TCHPD_INT */
+#define WM831X_IM_AUXADC_INT                    0x0100  /* IM_AUXADC_INT */
+#define WM831X_IM_AUXADC_INT_MASK               0x0100  /* IM_AUXADC_INT */
+#define WM831X_IM_AUXADC_INT_SHIFT                   8  /* IM_AUXADC_INT */
+#define WM831X_IM_AUXADC_INT_WIDTH                   1  /* IM_AUXADC_INT */
+#define WM831X_IM_PPM_INT                       0x0080  /* IM_PPM_INT */
+#define WM831X_IM_PPM_INT_MASK                  0x0080  /* IM_PPM_INT */
+#define WM831X_IM_PPM_INT_SHIFT                      7  /* IM_PPM_INT */
+#define WM831X_IM_PPM_INT_WIDTH                      1  /* IM_PPM_INT */
+#define WM831X_IM_CS_INT                        0x0040  /* IM_CS_INT */
+#define WM831X_IM_CS_INT_MASK                   0x0040  /* IM_CS_INT */
+#define WM831X_IM_CS_INT_SHIFT                       6  /* IM_CS_INT */
+#define WM831X_IM_CS_INT_WIDTH                       1  /* IM_CS_INT */
+#define WM831X_IM_RTC_INT                       0x0020  /* IM_RTC_INT */
+#define WM831X_IM_RTC_INT_MASK                  0x0020  /* IM_RTC_INT */
+#define WM831X_IM_RTC_INT_SHIFT                      5  /* IM_RTC_INT */
+#define WM831X_IM_RTC_INT_WIDTH                      1  /* IM_RTC_INT */
+#define WM831X_IM_OTP_INT                       0x0010  /* IM_OTP_INT */
+#define WM831X_IM_OTP_INT_MASK                  0x0010  /* IM_OTP_INT */
+#define WM831X_IM_OTP_INT_SHIFT                      4  /* IM_OTP_INT */
+#define WM831X_IM_OTP_INT_WIDTH                      1  /* IM_OTP_INT */
+#define WM831X_IM_CHILD_INT                     0x0008  /* IM_CHILD_INT */
+#define WM831X_IM_CHILD_INT_MASK                0x0008  /* IM_CHILD_INT */
+#define WM831X_IM_CHILD_INT_SHIFT                    3  /* IM_CHILD_INT */
+#define WM831X_IM_CHILD_INT_WIDTH                    1  /* IM_CHILD_INT */
+#define WM831X_IM_CHG_INT                       0x0004  /* IM_CHG_INT */
+#define WM831X_IM_CHG_INT_MASK                  0x0004  /* IM_CHG_INT */
+#define WM831X_IM_CHG_INT_SHIFT                      2  /* IM_CHG_INT */
+#define WM831X_IM_CHG_INT_WIDTH                      1  /* IM_CHG_INT */
+#define WM831X_IM_HC_INT                        0x0002  /* IM_HC_INT */
+#define WM831X_IM_HC_INT_MASK                   0x0002  /* IM_HC_INT */
+#define WM831X_IM_HC_INT_SHIFT                       1  /* IM_HC_INT */
+#define WM831X_IM_HC_INT_WIDTH                       1  /* IM_HC_INT */
+#define WM831X_IM_UV_INT                        0x0001  /* IM_UV_INT */
+#define WM831X_IM_UV_INT_MASK                   0x0001  /* IM_UV_INT */
+#define WM831X_IM_UV_INT_SHIFT                       0  /* IM_UV_INT */
+#define WM831X_IM_UV_INT_WIDTH                       1  /* IM_UV_INT */
+
+/*
+ * R16409 (0x4019) - Interrupt Status 1 Mask
+ */
+#define WM831X_IM_PPM_SYSLO_EINT                0x8000  /* IM_PPM_SYSLO_EINT */
+#define WM831X_IM_PPM_SYSLO_EINT_MASK           0x8000  /* IM_PPM_SYSLO_EINT */
+#define WM831X_IM_PPM_SYSLO_EINT_SHIFT              15  /* IM_PPM_SYSLO_EINT */
+#define WM831X_IM_PPM_SYSLO_EINT_WIDTH               1  /* IM_PPM_SYSLO_EINT */
+#define WM831X_IM_PPM_PWR_SRC_EINT              0x4000  /* IM_PPM_PWR_SRC_EINT */
+#define WM831X_IM_PPM_PWR_SRC_EINT_MASK         0x4000  /* IM_PPM_PWR_SRC_EINT */
+#define WM831X_IM_PPM_PWR_SRC_EINT_SHIFT            14  /* IM_PPM_PWR_SRC_EINT */
+#define WM831X_IM_PPM_PWR_SRC_EINT_WIDTH             1  /* IM_PPM_PWR_SRC_EINT */
+#define WM831X_IM_PPM_USB_CURR_EINT             0x2000  /* IM_PPM_USB_CURR_EINT */
+#define WM831X_IM_PPM_USB_CURR_EINT_MASK        0x2000  /* IM_PPM_USB_CURR_EINT */
+#define WM831X_IM_PPM_USB_CURR_EINT_SHIFT           13  /* IM_PPM_USB_CURR_EINT */
+#define WM831X_IM_PPM_USB_CURR_EINT_WIDTH            1  /* IM_PPM_USB_CURR_EINT */
+#define WM831X_IM_ON_PIN_EINT                   0x1000  /* IM_ON_PIN_EINT */
+#define WM831X_IM_ON_PIN_EINT_MASK              0x1000  /* IM_ON_PIN_EINT */
+#define WM831X_IM_ON_PIN_EINT_SHIFT                 12  /* IM_ON_PIN_EINT */
+#define WM831X_IM_ON_PIN_EINT_WIDTH                  1  /* IM_ON_PIN_EINT */
+#define WM831X_IM_WDOG_TO_EINT                  0x0800  /* IM_WDOG_TO_EINT */
+#define WM831X_IM_WDOG_TO_EINT_MASK             0x0800  /* IM_WDOG_TO_EINT */
+#define WM831X_IM_WDOG_TO_EINT_SHIFT                11  /* IM_WDOG_TO_EINT */
+#define WM831X_IM_WDOG_TO_EINT_WIDTH                 1  /* IM_WDOG_TO_EINT */
+#define WM831X_IM_TCHDATA_EINT                  0x0400  /* IM_TCHDATA_EINT */
+#define WM831X_IM_TCHDATA_EINT_MASK             0x0400  /* IM_TCHDATA_EINT */
+#define WM831X_IM_TCHDATA_EINT_SHIFT                10  /* IM_TCHDATA_EINT */
+#define WM831X_IM_TCHDATA_EINT_WIDTH                 1  /* IM_TCHDATA_EINT */
+#define WM831X_IM_TCHPD_EINT                    0x0200  /* IM_TCHPD_EINT */
+#define WM831X_IM_TCHPD_EINT_MASK               0x0200  /* IM_TCHPD_EINT */
+#define WM831X_IM_TCHPD_EINT_SHIFT                   9  /* IM_TCHPD_EINT */
+#define WM831X_IM_TCHPD_EINT_WIDTH                   1  /* IM_TCHPD_EINT */
+#define WM831X_IM_AUXADC_DATA_EINT              0x0100  /* IM_AUXADC_DATA_EINT */
+#define WM831X_IM_AUXADC_DATA_EINT_MASK         0x0100  /* IM_AUXADC_DATA_EINT */
+#define WM831X_IM_AUXADC_DATA_EINT_SHIFT             8  /* IM_AUXADC_DATA_EINT */
+#define WM831X_IM_AUXADC_DATA_EINT_WIDTH             1  /* IM_AUXADC_DATA_EINT */
+#define WM831X_IM_AUXADC_DCOMP4_EINT            0x0080  /* IM_AUXADC_DCOMP4_EINT */
+#define WM831X_IM_AUXADC_DCOMP4_EINT_MASK       0x0080  /* IM_AUXADC_DCOMP4_EINT */
+#define WM831X_IM_AUXADC_DCOMP4_EINT_SHIFT           7  /* IM_AUXADC_DCOMP4_EINT */
+#define WM831X_IM_AUXADC_DCOMP4_EINT_WIDTH           1  /* IM_AUXADC_DCOMP4_EINT */
+#define WM831X_IM_AUXADC_DCOMP3_EINT            0x0040  /* IM_AUXADC_DCOMP3_EINT */
+#define WM831X_IM_AUXADC_DCOMP3_EINT_MASK       0x0040  /* IM_AUXADC_DCOMP3_EINT */
+#define WM831X_IM_AUXADC_DCOMP3_EINT_SHIFT           6  /* IM_AUXADC_DCOMP3_EINT */
+#define WM831X_IM_AUXADC_DCOMP3_EINT_WIDTH           1  /* IM_AUXADC_DCOMP3_EINT */
+#define WM831X_IM_AUXADC_DCOMP2_EINT            0x0020  /* IM_AUXADC_DCOMP2_EINT */
+#define WM831X_IM_AUXADC_DCOMP2_EINT_MASK       0x0020  /* IM_AUXADC_DCOMP2_EINT */
+#define WM831X_IM_AUXADC_DCOMP2_EINT_SHIFT           5  /* IM_AUXADC_DCOMP2_EINT */
+#define WM831X_IM_AUXADC_DCOMP2_EINT_WIDTH           1  /* IM_AUXADC_DCOMP2_EINT */
+#define WM831X_IM_AUXADC_DCOMP1_EINT            0x0010  /* IM_AUXADC_DCOMP1_EINT */
+#define WM831X_IM_AUXADC_DCOMP1_EINT_MASK       0x0010  /* IM_AUXADC_DCOMP1_EINT */
+#define WM831X_IM_AUXADC_DCOMP1_EINT_SHIFT           4  /* IM_AUXADC_DCOMP1_EINT */
+#define WM831X_IM_AUXADC_DCOMP1_EINT_WIDTH           1  /* IM_AUXADC_DCOMP1_EINT */
+#define WM831X_IM_RTC_PER_EINT                  0x0008  /* IM_RTC_PER_EINT */
+#define WM831X_IM_RTC_PER_EINT_MASK             0x0008  /* IM_RTC_PER_EINT */
+#define WM831X_IM_RTC_PER_EINT_SHIFT                 3  /* IM_RTC_PER_EINT */
+#define WM831X_IM_RTC_PER_EINT_WIDTH                 1  /* IM_RTC_PER_EINT */
+#define WM831X_IM_RTC_ALM_EINT                  0x0004  /* IM_RTC_ALM_EINT */
+#define WM831X_IM_RTC_ALM_EINT_MASK             0x0004  /* IM_RTC_ALM_EINT */
+#define WM831X_IM_RTC_ALM_EINT_SHIFT                 2  /* IM_RTC_ALM_EINT */
+#define WM831X_IM_RTC_ALM_EINT_WIDTH                 1  /* IM_RTC_ALM_EINT */
+#define WM831X_IM_TEMP_THW_EINT                 0x0002  /* IM_TEMP_THW_EINT */
+#define WM831X_IM_TEMP_THW_EINT_MASK            0x0002  /* IM_TEMP_THW_EINT */
+#define WM831X_IM_TEMP_THW_EINT_SHIFT                1  /* IM_TEMP_THW_EINT */
+#define WM831X_IM_TEMP_THW_EINT_WIDTH                1  /* IM_TEMP_THW_EINT */
+
+/*
+ * R16410 (0x401A) - Interrupt Status 2 Mask
+ */
+#define WM831X_IM_CHG_BATT_HOT_EINT             0x8000  /* IM_CHG_BATT_HOT_EINT */
+#define WM831X_IM_CHG_BATT_HOT_EINT_MASK        0x8000  /* IM_CHG_BATT_HOT_EINT */
+#define WM831X_IM_CHG_BATT_HOT_EINT_SHIFT           15  /* IM_CHG_BATT_HOT_EINT */
+#define WM831X_IM_CHG_BATT_HOT_EINT_WIDTH            1  /* IM_CHG_BATT_HOT_EINT */
+#define WM831X_IM_CHG_BATT_COLD_EINT            0x4000  /* IM_CHG_BATT_COLD_EINT */
+#define WM831X_IM_CHG_BATT_COLD_EINT_MASK       0x4000  /* IM_CHG_BATT_COLD_EINT */
+#define WM831X_IM_CHG_BATT_COLD_EINT_SHIFT          14  /* IM_CHG_BATT_COLD_EINT */
+#define WM831X_IM_CHG_BATT_COLD_EINT_WIDTH           1  /* IM_CHG_BATT_COLD_EINT */
+#define WM831X_IM_CHG_BATT_FAIL_EINT            0x2000  /* IM_CHG_BATT_FAIL_EINT */
+#define WM831X_IM_CHG_BATT_FAIL_EINT_MASK       0x2000  /* IM_CHG_BATT_FAIL_EINT */
+#define WM831X_IM_CHG_BATT_FAIL_EINT_SHIFT          13  /* IM_CHG_BATT_FAIL_EINT */
+#define WM831X_IM_CHG_BATT_FAIL_EINT_WIDTH           1  /* IM_CHG_BATT_FAIL_EINT */
+#define WM831X_IM_CHG_OV_EINT                   0x1000  /* IM_CHG_OV_EINT */
+#define WM831X_IM_CHG_OV_EINT_MASK              0x1000  /* IM_CHG_OV_EINT */
+#define WM831X_IM_CHG_OV_EINT_SHIFT                 12  /* IM_CHG_OV_EINT */
+#define WM831X_IM_CHG_OV_EINT_WIDTH                  1  /* IM_CHG_OV_EINT */
+#define WM831X_IM_CHG_END_EINT                  0x0800  /* IM_CHG_END_EINT */
+#define WM831X_IM_CHG_END_EINT_MASK             0x0800  /* IM_CHG_END_EINT */
+#define WM831X_IM_CHG_END_EINT_SHIFT                11  /* IM_CHG_END_EINT */
+#define WM831X_IM_CHG_END_EINT_WIDTH                 1  /* IM_CHG_END_EINT */
+#define WM831X_IM_CHG_TO_EINT                   0x0400  /* IM_CHG_TO_EINT */
+#define WM831X_IM_CHG_TO_EINT_MASK              0x0400  /* IM_CHG_TO_EINT */
+#define WM831X_IM_CHG_TO_EINT_SHIFT                 10  /* IM_CHG_TO_EINT */
+#define WM831X_IM_CHG_TO_EINT_WIDTH                  1  /* IM_CHG_TO_EINT */
+#define WM831X_IM_CHG_MODE_EINT                 0x0200  /* IM_CHG_MODE_EINT */
+#define WM831X_IM_CHG_MODE_EINT_MASK            0x0200  /* IM_CHG_MODE_EINT */
+#define WM831X_IM_CHG_MODE_EINT_SHIFT                9  /* IM_CHG_MODE_EINT */
+#define WM831X_IM_CHG_MODE_EINT_WIDTH                1  /* IM_CHG_MODE_EINT */
+#define WM831X_IM_CHG_START_EINT                0x0100  /* IM_CHG_START_EINT */
+#define WM831X_IM_CHG_START_EINT_MASK           0x0100  /* IM_CHG_START_EINT */
+#define WM831X_IM_CHG_START_EINT_SHIFT               8  /* IM_CHG_START_EINT */
+#define WM831X_IM_CHG_START_EINT_WIDTH               1  /* IM_CHG_START_EINT */
+#define WM831X_IM_CS2_EINT                      0x0080  /* IM_CS2_EINT */
+#define WM831X_IM_CS2_EINT_MASK                 0x0080  /* IM_CS2_EINT */
+#define WM831X_IM_CS2_EINT_SHIFT                     7  /* IM_CS2_EINT */
+#define WM831X_IM_CS2_EINT_WIDTH                     1  /* IM_CS2_EINT */
+#define WM831X_IM_CS1_EINT                      0x0040  /* IM_CS1_EINT */
+#define WM831X_IM_CS1_EINT_MASK                 0x0040  /* IM_CS1_EINT */
+#define WM831X_IM_CS1_EINT_SHIFT                     6  /* IM_CS1_EINT */
+#define WM831X_IM_CS1_EINT_WIDTH                     1  /* IM_CS1_EINT */
+#define WM831X_IM_OTP_CMD_END_EINT              0x0020  /* IM_OTP_CMD_END_EINT */
+#define WM831X_IM_OTP_CMD_END_EINT_MASK         0x0020  /* IM_OTP_CMD_END_EINT */
+#define WM831X_IM_OTP_CMD_END_EINT_SHIFT             5  /* IM_OTP_CMD_END_EINT */
+#define WM831X_IM_OTP_CMD_END_EINT_WIDTH             1  /* IM_OTP_CMD_END_EINT */
+#define WM831X_IM_OTP_ERR_EINT                  0x0010  /* IM_OTP_ERR_EINT */
+#define WM831X_IM_OTP_ERR_EINT_MASK             0x0010  /* IM_OTP_ERR_EINT */
+#define WM831X_IM_OTP_ERR_EINT_SHIFT                 4  /* IM_OTP_ERR_EINT */
+#define WM831X_IM_OTP_ERR_EINT_WIDTH                 1  /* IM_OTP_ERR_EINT */
+#define WM831X_IM_PS_POR_EINT                   0x0004  /* IM_PS_POR_EINT */
+#define WM831X_IM_PS_POR_EINT_MASK              0x0004  /* IM_PS_POR_EINT */
+#define WM831X_IM_PS_POR_EINT_SHIFT                  2  /* IM_PS_POR_EINT */
+#define WM831X_IM_PS_POR_EINT_WIDTH                  1  /* IM_PS_POR_EINT */
+#define WM831X_IM_PS_SLEEP_OFF_EINT             0x0002  /* IM_PS_SLEEP_OFF_EINT */
+#define WM831X_IM_PS_SLEEP_OFF_EINT_MASK        0x0002  /* IM_PS_SLEEP_OFF_EINT */
+#define WM831X_IM_PS_SLEEP_OFF_EINT_SHIFT            1  /* IM_PS_SLEEP_OFF_EINT */
+#define WM831X_IM_PS_SLEEP_OFF_EINT_WIDTH            1  /* IM_PS_SLEEP_OFF_EINT */
+#define WM831X_IM_PS_ON_WAKE_EINT               0x0001  /* IM_PS_ON_WAKE_EINT */
+#define WM831X_IM_PS_ON_WAKE_EINT_MASK          0x0001  /* IM_PS_ON_WAKE_EINT */
+#define WM831X_IM_PS_ON_WAKE_EINT_SHIFT              0  /* IM_PS_ON_WAKE_EINT */
+#define WM831X_IM_PS_ON_WAKE_EINT_WIDTH              1  /* IM_PS_ON_WAKE_EINT */
+
+/*
+ * R16411 (0x401B) - Interrupt Status 3 Mask
+ */
+#define WM831X_IM_UV_LDO10_EINT                 0x0200  /* IM_UV_LDO10_EINT */
+#define WM831X_IM_UV_LDO10_EINT_MASK            0x0200  /* IM_UV_LDO10_EINT */
+#define WM831X_IM_UV_LDO10_EINT_SHIFT                9  /* IM_UV_LDO10_EINT */
+#define WM831X_IM_UV_LDO10_EINT_WIDTH                1  /* IM_UV_LDO10_EINT */
+#define WM831X_IM_UV_LDO9_EINT                  0x0100  /* IM_UV_LDO9_EINT */
+#define WM831X_IM_UV_LDO9_EINT_MASK             0x0100  /* IM_UV_LDO9_EINT */
+#define WM831X_IM_UV_LDO9_EINT_SHIFT                 8  /* IM_UV_LDO9_EINT */
+#define WM831X_IM_UV_LDO9_EINT_WIDTH                 1  /* IM_UV_LDO9_EINT */
+#define WM831X_IM_UV_LDO8_EINT                  0x0080  /* IM_UV_LDO8_EINT */
+#define WM831X_IM_UV_LDO8_EINT_MASK             0x0080  /* IM_UV_LDO8_EINT */
+#define WM831X_IM_UV_LDO8_EINT_SHIFT                 7  /* IM_UV_LDO8_EINT */
+#define WM831X_IM_UV_LDO8_EINT_WIDTH                 1  /* IM_UV_LDO8_EINT */
+#define WM831X_IM_UV_LDO7_EINT                  0x0040  /* IM_UV_LDO7_EINT */
+#define WM831X_IM_UV_LDO7_EINT_MASK             0x0040  /* IM_UV_LDO7_EINT */
+#define WM831X_IM_UV_LDO7_EINT_SHIFT                 6  /* IM_UV_LDO7_EINT */
+#define WM831X_IM_UV_LDO7_EINT_WIDTH                 1  /* IM_UV_LDO7_EINT */
+#define WM831X_IM_UV_LDO6_EINT                  0x0020  /* IM_UV_LDO6_EINT */
+#define WM831X_IM_UV_LDO6_EINT_MASK             0x0020  /* IM_UV_LDO6_EINT */
+#define WM831X_IM_UV_LDO6_EINT_SHIFT                 5  /* IM_UV_LDO6_EINT */
+#define WM831X_IM_UV_LDO6_EINT_WIDTH                 1  /* IM_UV_LDO6_EINT */
+#define WM831X_IM_UV_LDO5_EINT                  0x0010  /* IM_UV_LDO5_EINT */
+#define WM831X_IM_UV_LDO5_EINT_MASK             0x0010  /* IM_UV_LDO5_EINT */
+#define WM831X_IM_UV_LDO5_EINT_SHIFT                 4  /* IM_UV_LDO5_EINT */
+#define WM831X_IM_UV_LDO5_EINT_WIDTH                 1  /* IM_UV_LDO5_EINT */
+#define WM831X_IM_UV_LDO4_EINT                  0x0008  /* IM_UV_LDO4_EINT */
+#define WM831X_IM_UV_LDO4_EINT_MASK             0x0008  /* IM_UV_LDO4_EINT */
+#define WM831X_IM_UV_LDO4_EINT_SHIFT                 3  /* IM_UV_LDO4_EINT */
+#define WM831X_IM_UV_LDO4_EINT_WIDTH                 1  /* IM_UV_LDO4_EINT */
+#define WM831X_IM_UV_LDO3_EINT                  0x0004  /* IM_UV_LDO3_EINT */
+#define WM831X_IM_UV_LDO3_EINT_MASK             0x0004  /* IM_UV_LDO3_EINT */
+#define WM831X_IM_UV_LDO3_EINT_SHIFT                 2  /* IM_UV_LDO3_EINT */
+#define WM831X_IM_UV_LDO3_EINT_WIDTH                 1  /* IM_UV_LDO3_EINT */
+#define WM831X_IM_UV_LDO2_EINT                  0x0002  /* IM_UV_LDO2_EINT */
+#define WM831X_IM_UV_LDO2_EINT_MASK             0x0002  /* IM_UV_LDO2_EINT */
+#define WM831X_IM_UV_LDO2_EINT_SHIFT                 1  /* IM_UV_LDO2_EINT */
+#define WM831X_IM_UV_LDO2_EINT_WIDTH                 1  /* IM_UV_LDO2_EINT */
+#define WM831X_IM_UV_LDO1_EINT                  0x0001  /* IM_UV_LDO1_EINT */
+#define WM831X_IM_UV_LDO1_EINT_MASK             0x0001  /* IM_UV_LDO1_EINT */
+#define WM831X_IM_UV_LDO1_EINT_SHIFT                 0  /* IM_UV_LDO1_EINT */
+#define WM831X_IM_UV_LDO1_EINT_WIDTH                 1  /* IM_UV_LDO1_EINT */
+
+/*
+ * R16412 (0x401C) - Interrupt Status 4 Mask
+ */
+#define WM831X_IM_HC_DC2_EINT                   0x0200  /* IM_HC_DC2_EINT */
+#define WM831X_IM_HC_DC2_EINT_MASK              0x0200  /* IM_HC_DC2_EINT */
+#define WM831X_IM_HC_DC2_EINT_SHIFT                  9  /* IM_HC_DC2_EINT */
+#define WM831X_IM_HC_DC2_EINT_WIDTH                  1  /* IM_HC_DC2_EINT */
+#define WM831X_IM_HC_DC1_EINT                   0x0100  /* IM_HC_DC1_EINT */
+#define WM831X_IM_HC_DC1_EINT_MASK              0x0100  /* IM_HC_DC1_EINT */
+#define WM831X_IM_HC_DC1_EINT_SHIFT                  8  /* IM_HC_DC1_EINT */
+#define WM831X_IM_HC_DC1_EINT_WIDTH                  1  /* IM_HC_DC1_EINT */
+#define WM831X_IM_UV_DC4_EINT                   0x0008  /* IM_UV_DC4_EINT */
+#define WM831X_IM_UV_DC4_EINT_MASK              0x0008  /* IM_UV_DC4_EINT */
+#define WM831X_IM_UV_DC4_EINT_SHIFT                  3  /* IM_UV_DC4_EINT */
+#define WM831X_IM_UV_DC4_EINT_WIDTH                  1  /* IM_UV_DC4_EINT */
+#define WM831X_IM_UV_DC3_EINT                   0x0004  /* IM_UV_DC3_EINT */
+#define WM831X_IM_UV_DC3_EINT_MASK              0x0004  /* IM_UV_DC3_EINT */
+#define WM831X_IM_UV_DC3_EINT_SHIFT                  2  /* IM_UV_DC3_EINT */
+#define WM831X_IM_UV_DC3_EINT_WIDTH                  1  /* IM_UV_DC3_EINT */
+#define WM831X_IM_UV_DC2_EINT                   0x0002  /* IM_UV_DC2_EINT */
+#define WM831X_IM_UV_DC2_EINT_MASK              0x0002  /* IM_UV_DC2_EINT */
+#define WM831X_IM_UV_DC2_EINT_SHIFT                  1  /* IM_UV_DC2_EINT */
+#define WM831X_IM_UV_DC2_EINT_WIDTH                  1  /* IM_UV_DC2_EINT */
+#define WM831X_IM_UV_DC1_EINT                   0x0001  /* IM_UV_DC1_EINT */
+#define WM831X_IM_UV_DC1_EINT_MASK              0x0001  /* IM_UV_DC1_EINT */
+#define WM831X_IM_UV_DC1_EINT_SHIFT                  0  /* IM_UV_DC1_EINT */
+#define WM831X_IM_UV_DC1_EINT_WIDTH                  1  /* IM_UV_DC1_EINT */
+
+/*
+ * R16413 (0x401D) - Interrupt Status 5 Mask
+ */
+#define WM831X_IM_GP16_EINT                     0x8000  /* IM_GP16_EINT */
+#define WM831X_IM_GP16_EINT_MASK                0x8000  /* IM_GP16_EINT */
+#define WM831X_IM_GP16_EINT_SHIFT                   15  /* IM_GP16_EINT */
+#define WM831X_IM_GP16_EINT_WIDTH                    1  /* IM_GP16_EINT */
+#define WM831X_IM_GP15_EINT                     0x4000  /* IM_GP15_EINT */
+#define WM831X_IM_GP15_EINT_MASK                0x4000  /* IM_GP15_EINT */
+#define WM831X_IM_GP15_EINT_SHIFT                   14  /* IM_GP15_EINT */
+#define WM831X_IM_GP15_EINT_WIDTH                    1  /* IM_GP15_EINT */
+#define WM831X_IM_GP14_EINT                     0x2000  /* IM_GP14_EINT */
+#define WM831X_IM_GP14_EINT_MASK                0x2000  /* IM_GP14_EINT */
+#define WM831X_IM_GP14_EINT_SHIFT                   13  /* IM_GP14_EINT */
+#define WM831X_IM_GP14_EINT_WIDTH                    1  /* IM_GP14_EINT */
+#define WM831X_IM_GP13_EINT                     0x1000  /* IM_GP13_EINT */
+#define WM831X_IM_GP13_EINT_MASK                0x1000  /* IM_GP13_EINT */
+#define WM831X_IM_GP13_EINT_SHIFT                   12  /* IM_GP13_EINT */
+#define WM831X_IM_GP13_EINT_WIDTH                    1  /* IM_GP13_EINT */
+#define WM831X_IM_GP12_EINT                     0x0800  /* IM_GP12_EINT */
+#define WM831X_IM_GP12_EINT_MASK                0x0800  /* IM_GP12_EINT */
+#define WM831X_IM_GP12_EINT_SHIFT                   11  /* IM_GP12_EINT */
+#define WM831X_IM_GP12_EINT_WIDTH                    1  /* IM_GP12_EINT */
+#define WM831X_IM_GP11_EINT                     0x0400  /* IM_GP11_EINT */
+#define WM831X_IM_GP11_EINT_MASK                0x0400  /* IM_GP11_EINT */
+#define WM831X_IM_GP11_EINT_SHIFT                   10  /* IM_GP11_EINT */
+#define WM831X_IM_GP11_EINT_WIDTH                    1  /* IM_GP11_EINT */
+#define WM831X_IM_GP10_EINT                     0x0200  /* IM_GP10_EINT */
+#define WM831X_IM_GP10_EINT_MASK                0x0200  /* IM_GP10_EINT */
+#define WM831X_IM_GP10_EINT_SHIFT                    9  /* IM_GP10_EINT */
+#define WM831X_IM_GP10_EINT_WIDTH                    1  /* IM_GP10_EINT */
+#define WM831X_IM_GP9_EINT                      0x0100  /* IM_GP9_EINT */
+#define WM831X_IM_GP9_EINT_MASK                 0x0100  /* IM_GP9_EINT */
+#define WM831X_IM_GP9_EINT_SHIFT                     8  /* IM_GP9_EINT */
+#define WM831X_IM_GP9_EINT_WIDTH                     1  /* IM_GP9_EINT */
+#define WM831X_IM_GP8_EINT                      0x0080  /* IM_GP8_EINT */
+#define WM831X_IM_GP8_EINT_MASK                 0x0080  /* IM_GP8_EINT */
+#define WM831X_IM_GP8_EINT_SHIFT                     7  /* IM_GP8_EINT */
+#define WM831X_IM_GP8_EINT_WIDTH                     1  /* IM_GP8_EINT */
+#define WM831X_IM_GP7_EINT                      0x0040  /* IM_GP7_EINT */
+#define WM831X_IM_GP7_EINT_MASK                 0x0040  /* IM_GP7_EINT */
+#define WM831X_IM_GP7_EINT_SHIFT                     6  /* IM_GP7_EINT */
+#define WM831X_IM_GP7_EINT_WIDTH                     1  /* IM_GP7_EINT */
+#define WM831X_IM_GP6_EINT                      0x0020  /* IM_GP6_EINT */
+#define WM831X_IM_GP6_EINT_MASK                 0x0020  /* IM_GP6_EINT */
+#define WM831X_IM_GP6_EINT_SHIFT                     5  /* IM_GP6_EINT */
+#define WM831X_IM_GP6_EINT_WIDTH                     1  /* IM_GP6_EINT */
+#define WM831X_IM_GP5_EINT                      0x0010  /* IM_GP5_EINT */
+#define WM831X_IM_GP5_EINT_MASK                 0x0010  /* IM_GP5_EINT */
+#define WM831X_IM_GP5_EINT_SHIFT                     4  /* IM_GP5_EINT */
+#define WM831X_IM_GP5_EINT_WIDTH                     1  /* IM_GP5_EINT */
+#define WM831X_IM_GP4_EINT                      0x0008  /* IM_GP4_EINT */
+#define WM831X_IM_GP4_EINT_MASK                 0x0008  /* IM_GP4_EINT */
+#define WM831X_IM_GP4_EINT_SHIFT                     3  /* IM_GP4_EINT */
+#define WM831X_IM_GP4_EINT_WIDTH                     1  /* IM_GP4_EINT */
+#define WM831X_IM_GP3_EINT                      0x0004  /* IM_GP3_EINT */
+#define WM831X_IM_GP3_EINT_MASK                 0x0004  /* IM_GP3_EINT */
+#define WM831X_IM_GP3_EINT_SHIFT                     2  /* IM_GP3_EINT */
+#define WM831X_IM_GP3_EINT_WIDTH                     1  /* IM_GP3_EINT */
+#define WM831X_IM_GP2_EINT                      0x0002  /* IM_GP2_EINT */
+#define WM831X_IM_GP2_EINT_MASK                 0x0002  /* IM_GP2_EINT */
+#define WM831X_IM_GP2_EINT_SHIFT                     1  /* IM_GP2_EINT */
+#define WM831X_IM_GP2_EINT_WIDTH                     1  /* IM_GP2_EINT */
+#define WM831X_IM_GP1_EINT                      0x0001  /* IM_GP1_EINT */
+#define WM831X_IM_GP1_EINT_MASK                 0x0001  /* IM_GP1_EINT */
+#define WM831X_IM_GP1_EINT_SHIFT                     0  /* IM_GP1_EINT */
+#define WM831X_IM_GP1_EINT_WIDTH                     1  /* IM_GP1_EINT */
+
+
+#endif
-- 
1.6.3.3

