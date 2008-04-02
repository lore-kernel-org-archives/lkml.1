Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYDUNda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYDUNda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932498AbYDUNX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:23:57 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:42688 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbYDUNXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=CAIHS6g7Tfa3J5nrdWOqJCBpMoU7oUkzBrFOkzoxb3wnqzTFA3esYzhu2yM56Up9x9Jzj/TzlRB0ATMFW8cACfhUVuqQhvIQay/Cpdn0c3tkbWM2iZ0KjPWO4VXPJfPYhvmoFcX9S68FScQ9LK/dmH1q8lPDOeElOajtz2hAcb0=
Message-Id: <4db8a5f21e5149e09949516eef98b78b68880075.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Wed, 2 Apr 2008 00:51:46 -0400
Subject: [PATCH 08/37] Input: WM97xx - add support for streaming mode on Mainstone
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Mark Brown <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Signed-off-by: Graeme Gregory <gg@opensource.wolfsonmicro.com>
Signed-off-by: Mike Arthur <mike.arthur@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/touchscreen/Kconfig            |   12 +
 drivers/input/touchscreen/Makefile           |    1 +
 drivers/input/touchscreen/mainstone-wm97xx.c |  302 ++++++++++++++++++++++++++
 3 files changed, 315 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/mainstone-wm97xx.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index f6e8dad..565ec71 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -226,6 +226,18 @@ config TOUCHSCREEN_WM9713
 
 	  If unsure, say N.
 
+config TOUCHSCREEN_WM97XX_MAINSTONE
+	tristate "WM97xx Mainstone accelerated touch"
+	depends on TOUCHSCREEN_WM97XX && ARCH_PXA
+	help
+	  Say Y here for support for streaming mode with WM97xx touchscreens
+	  on Mainstone systems.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mainstone-wm97xx.
+
 config TOUCHSCREEN_USB_COMPOSITE
 	tristate "USB Touchscreen Driver"
 	depends on USB_ARCH_HAS_HCD
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index f1bc829..3c096d7 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX)	+= wm97xx-ts.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)	+= wm9705.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)	+= wm9713.o
+obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
new file mode 100644
index 0000000..a79f029
--- /dev/null
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -0,0 +1,302 @@
+/*
+ * mainstone-wm97xx.c  --  Mainstone Continuous Touch screen driver for
+ *                         Wolfson WM97xx AC97 Codecs.
+ *
+ * Copyright 2004, 2007 Wolfson Microelectronics PLC.
+ * Author: Liam Girdwood
+ *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Parts Copyright : Ian Molton <spyro@f2s.com>
+ *                   Andrew Zabolotny <zap@homelink.ru>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ * Notes:
+ *     This is a wm97xx extended touch driver to capture touch
+ *     data in a continuous manner on the Intel XScale archictecture
+ *
+ *  Features:
+ *       - codecs supported:- WM9705, WM9712, WM9713
+ *       - processors supported:- Intel XScale PXA25x, PXA26x, PXA27x
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/wm97xx.h>
+#include <linux/io.h>
+#include <asm/arch/pxa-regs.h>
+
+#define VERSION		"0.13"
+
+struct continuous {
+	u16 id;    /* codec id */
+	u8 code;   /* continuous code */
+	u8 reads;  /* number of coord reads per read cycle */
+	u32 speed; /* number of coords per second */
+};
+
+#define WM_READS(sp) ((sp / HZ) + 1)
+
+static const struct continuous cinfo[] = {
+	{WM9705_ID2, 0, WM_READS(94), 94},
+	{WM9705_ID2, 1, WM_READS(188), 188},
+	{WM9705_ID2, 2, WM_READS(375), 375},
+	{WM9705_ID2, 3, WM_READS(750), 750},
+	{WM9712_ID2, 0, WM_READS(94), 94},
+	{WM9712_ID2, 1, WM_READS(188), 188},
+	{WM9712_ID2, 2, WM_READS(375), 375},
+	{WM9712_ID2, 3, WM_READS(750), 750},
+	{WM9713_ID2, 0, WM_READS(94), 94},
+	{WM9713_ID2, 1, WM_READS(120), 120},
+	{WM9713_ID2, 2, WM_READS(154), 154},
+	{WM9713_ID2, 3, WM_READS(188), 188},
+};
+
+/* continuous speed index */
+static int sp_idx;
+static u16 last, tries;
+
+/*
+ * Pen sampling frequency (Hz) in continuous mode.
+ */
+static int cont_rate = 200;
+module_param(cont_rate, int, 0);
+MODULE_PARM_DESC(cont_rate, "Sampling rate in continuous mode (Hz)");
+
+/*
+ * Pen down detection.
+ *
+ * This driver can either poll or use an interrupt to indicate a pen down
+ * event. If the irq request fails then it will fall back to polling mode.
+ */
+static int pen_int;
+module_param(pen_int, int, 0);
+MODULE_PARM_DESC(pen_int, "Pen down detection (1 = interrupt, 0 = polling)");
+
+/*
+ * Pressure readback.
+ *
+ * Set to 1 to read back pen down pressure
+ */
+static int pressure;
+module_param(pressure, int, 0);
+MODULE_PARM_DESC(pressure, "Pressure readback (1 = pressure, 0 = no pressure)");
+
+/*
+ * AC97 touch data slot.
+ *
+ * Touch screen readback data ac97 slot
+ */
+static int ac97_touch_slot = 5;
+module_param(ac97_touch_slot, int, 0);
+MODULE_PARM_DESC(ac97_touch_slot, "Touch screen data slot AC97 number");
+
+
+/* flush AC97 slot 5 FIFO on pxa machines */
+#ifdef CONFIG_PXA27x
+static void wm97xx_acc_pen_up(struct wm97xx *wm)
+{
+	schedule_timeout_uninterruptible(1);
+
+	while (MISR & (1 << 2))
+		MODR;
+}
+#else
+static void wm97xx_acc_pen_up(struct wm97xx *wm)
+{
+	int count = 16;
+	schedule_timeout_uninterruptible(1);
+
+	while (count < 16) {
+		MODR;
+		count--;
+	}
+}
+#endif
+
+static int wm97xx_acc_pen_down(struct wm97xx *wm)
+{
+	u16 x, y, p = 0x100 | WM97XX_ADCSEL_PRES;
+	int reads = 0;
+
+	/* When the AC97 queue has been drained we need to allow time
+	 * to buffer up samples otherwise we end up spinning polling
+	 * for samples.  The controller can't have a suitably low
+	 * threashold set to use the notifications it gives.
+	 */
+	schedule_timeout_uninterruptible(1);
+
+	if (tries > 5) {
+		tries = 0;
+		return RC_PENUP;
+	}
+
+	x = MODR;
+	if (x == last) {
+		tries++;
+		return RC_AGAIN;
+	}
+	last = x;
+	do {
+		if (reads)
+			x = MODR;
+		y = MODR;
+		if (pressure)
+			p = MODR;
+
+		/* are samples valid */
+		if ((x & WM97XX_ADCSRC_MASK) != WM97XX_ADCSEL_X ||
+		    (y & WM97XX_ADCSRC_MASK) != WM97XX_ADCSEL_Y ||
+		    (p & WM97XX_ADCSRC_MASK) != WM97XX_ADCSEL_PRES)
+			goto up;
+
+		/* coordinate is good */
+		tries = 0;
+		input_report_abs(wm->input_dev, ABS_X, x & 0xfff);
+		input_report_abs(wm->input_dev, ABS_Y, y & 0xfff);
+		input_report_abs(wm->input_dev, ABS_PRESSURE, p & 0xfff);
+		input_sync(wm->input_dev);
+		reads++;
+	} while (reads < cinfo[sp_idx].reads);
+up:
+	return RC_PENDOWN | RC_AGAIN;
+}
+
+static int wm97xx_acc_startup(struct wm97xx *wm)
+{
+	int idx = 0;
+
+	/* check we have a codec */
+	if (wm->ac97 == NULL)
+		return -ENODEV;
+
+	/* Go you big red fire engine */
+	for (idx = 0; idx < ARRAY_SIZE(cinfo); idx++) {
+		if (wm->id != cinfo[idx].id)
+			continue;
+		sp_idx = idx;
+		if (cont_rate <= cinfo[idx].speed)
+			break;
+	}
+	wm->acc_rate = cinfo[sp_idx].code;
+	wm->acc_slot = ac97_touch_slot;
+	dev_info(wm->dev,
+		 "mainstone accelerated touchscreen driver, %d samples/sec\n",
+		 cinfo[sp_idx].speed);
+
+	/* codec specific irq config */
+	if (pen_int) {
+		switch (wm->id) {
+		case WM9705_ID2:
+			wm->pen_irq = IRQ_GPIO(4);
+			set_irq_type(IRQ_GPIO(4), IRQT_BOTHEDGE);
+			break;
+		case WM9712_ID2:
+		case WM9713_ID2:
+			/* enable pen down interrupt */
+			/* use PEN_DOWN GPIO 13 to assert IRQ on GPIO line 2 */
+			wm->pen_irq = MAINSTONE_AC97_IRQ;
+			wm97xx_config_gpio(wm, WM97XX_GPIO_13, WM97XX_GPIO_IN,
+					   WM97XX_GPIO_POL_HIGH,
+					   WM97XX_GPIO_STICKY,
+					   WM97XX_GPIO_WAKE);
+			wm97xx_config_gpio(wm, WM97XX_GPIO_2, WM97XX_GPIO_OUT,
+					   WM97XX_GPIO_POL_HIGH,
+					   WM97XX_GPIO_NOTSTICKY,
+					   WM97XX_GPIO_NOWAKE);
+			break;
+		default:
+			dev_err(wm->dev,
+				"pen down irq not supported on this device\n");
+			pen_int = 0;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void wm97xx_acc_shutdown(struct wm97xx *wm)
+{
+	/* codec specific deconfig */
+	if (pen_int) {
+		switch (wm->id & 0xffff) {
+		case WM9705_ID2:
+			wm->pen_irq = 0;
+			break;
+		case WM9712_ID2:
+		case WM9713_ID2:
+			/* disable interrupt */
+			wm->pen_irq = 0;
+			break;
+		}
+	}
+}
+
+static void wm97xx_irq_enable(struct wm97xx *wm, int enable)
+{
+	if (enable)
+		enable_irq(wm->pen_irq);
+	else
+		disable_irq(wm->pen_irq);
+}
+
+static struct wm97xx_mach_ops mainstone_mach_ops = {
+	.acc_enabled = 1,
+	.acc_pen_up = wm97xx_acc_pen_up,
+	.acc_pen_down = wm97xx_acc_pen_down,
+	.acc_startup = wm97xx_acc_startup,
+	.acc_shutdown = wm97xx_acc_shutdown,
+	.irq_enable = wm97xx_irq_enable,
+	.irq_gpio = WM97XX_GPIO_2,
+};
+
+static int mainstone_wm97xx_probe(struct platform_device *pdev)
+{
+	struct wm97xx *wm = platform_get_drvdata(pdev);
+
+	return wm97xx_register_mach_ops(wm, &mainstone_mach_ops);
+}
+
+static int mainstone_wm97xx_remove(struct platform_device *pdev)
+{
+	struct wm97xx *wm = platform_get_drvdata(pdev);
+
+	wm97xx_unregister_mach_ops(wm);
+	return 0;
+}
+
+static struct platform_driver mainstone_wm97xx_driver = {
+	.probe = mainstone_wm97xx_probe,
+	.remove = mainstone_wm97xx_remove,
+	.driver = {
+		.name = "wm97xx-touch",
+	},
+};
+
+static int __init mainstone_wm97xx_init(void)
+{
+	return platform_driver_register(&mainstone_wm97xx_driver);
+}
+
+static void __exit mainstone_wm97xx_exit(void)
+{
+	platform_driver_unregister(&mainstone_wm97xx_driver);
+}
+
+module_init(mainstone_wm97xx_init);
+module_exit(mainstone_wm97xx_exit);
+
+/* Module information */
+MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
+MODULE_DESCRIPTION("wm97xx continuous touch driver for mainstone");
+MODULE_LICENSE("GPL");
-- 
1.5.5.rc2.6.gf58d


