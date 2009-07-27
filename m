Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZG0Nt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZG0Nt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZG0Nt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:49:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59115 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754602AbZG0Nq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/22] mfd: Initial core support for WM831x series devices
Date: Mon, 27 Jul 2009 14:45:52 +0100
Message-Id: <1248702372-29534-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of devices are register compatible processor power
management subsystems, providing regulator and power path management
facilities along with other services like watchdog, RTC and touch
panel controllers.

This patch adds very basic support, providing basic single register
I2C access, handling of the security key and registration of the
devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c        | 1357 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/core.h  |  247 +++++++
 include/linux/mfd/wm831x/pdata.h |  107 +++
 3 files changed, 1711 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wm831x-core.c
 create mode 100644 include/linux/mfd/wm831x/core.h
 create mode 100644 include/linux/mfd/wm831x/pdata.h

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
new file mode 100644
index 0000000..cc1040c
--- /dev/null
+++ b/drivers/mfd/wm831x-core.c
@@ -0,0 +1,1357 @@
+/*
+ * wm831x-core.c  --  Device access for Wolfson WM831x PMICs
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
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/pdata.h>
+
+enum wm831x_parent {
+	WM8310 = 0,
+	WM8311 = 1,
+	WM8312 = 2,
+};
+
+static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
+{
+	if (!wm831x->locked)
+		return 0;
+
+	switch (reg) {
+	case WM831X_WATCHDOG:
+	case WM831X_DC4_CONTROL:
+	case WM831X_ON_PIN_CONTROL:
+	case WM831X_BACKUP_CHARGER_CONTROL:
+	case WM831X_CHARGER_CONTROL_1:
+	case WM831X_CHARGER_CONTROL_2:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
+/**
+ * wm831x_reg_unlock: Unlock user keyed registers
+ *
+ * The WM831x has a user key preventing writes to particularly
+ * critical registers.  This function locks those registers,
+ * allowing writes to them.
+ */
+void wm831x_reg_lock(struct wm831x *wm831x)
+{
+	int ret;
+
+	ret = wm831x_reg_write(wm831x, WM831X_SECURITY_KEY, 0);
+	if (ret == 0) {
+		dev_vdbg(wm831x->dev, "Registers locked\n");
+
+		mutex_lock(&wm831x->io_lock);
+		WARN_ON(wm831x->locked);
+		wm831x->locked = 1;
+		mutex_unlock(&wm831x->io_lock);
+	} else {
+		dev_err(wm831x->dev, "Failed to lock registers: %d\n", ret);
+	}
+
+}
+EXPORT_SYMBOL_GPL(wm831x_reg_lock);
+
+/**
+ * wm831x_reg_unlock: Unlock user keyed registers
+ *
+ * The WM831x has a user key preventing writes to particularly
+ * critical registers.  This function locks those registers,
+ * preventing spurious writes.
+ */
+int wm831x_reg_unlock(struct wm831x *wm831x)
+{
+	int ret;
+
+	/* 0x9716 is the value required to unlock the registers */
+	ret = wm831x_reg_write(wm831x, WM831X_SECURITY_KEY, 0x9716);
+	if (ret == 0) {
+		dev_vdbg(wm831x->dev, "Registers unlocked\n");
+
+		mutex_lock(&wm831x->io_lock);
+		WARN_ON(!wm831x->locked);
+		wm831x->locked = 0;
+		mutex_unlock(&wm831x->io_lock);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_reg_unlock);
+
+static int wm831x_read(struct wm831x *wm831x, unsigned short reg,
+		       int bytes, void *dest)
+{
+	int ret, i;
+	u16 *buf = dest;
+
+	BUG_ON(bytes % 2);
+	BUG_ON(bytes <= 0);
+
+	ret = wm831x->read_dev(wm831x, reg, bytes, dest);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < bytes / 2; i++) {
+		buf[i] = be16_to_cpu(buf[i]);
+
+		dev_vdbg(wm831x->dev, "Read %04x from R%d(0x%x)\n",
+			 buf[i], reg + i, reg + i);
+	}
+
+	return 0;
+}
+
+/**
+ * wm831x_reg_read: Read a single WM831x register.
+ *
+ * @wm831x: Device to read from.
+ * @reg: Register to read.
+ */
+int wm831x_reg_read(struct wm831x *wm831x, unsigned short reg)
+{
+	unsigned short val;
+	int ret;
+
+	mutex_lock(&wm831x->io_lock);
+
+	ret = wm831x_read(wm831x, reg, 2, &val);
+
+	mutex_unlock(&wm831x->io_lock);
+
+	if (ret < 0)
+		return ret;
+	else
+		return val;
+}
+EXPORT_SYMBOL_GPL(wm831x_reg_read);
+
+/**
+ * wm831x_bulk_read: Read multiple WM831x registers
+ *
+ * @wm831x: Device to read from
+ * @reg: First register
+ * @count: Number of registers
+ * @buf: Buffer to fill.
+ */
+int wm831x_bulk_read(struct wm831x *wm831x, unsigned short reg,
+		     int count, u16 *buf)
+{
+	int ret;
+
+	mutex_lock(&wm831x->io_lock);
+
+	ret = wm831x_read(wm831x, reg, count * 2, buf);
+
+	mutex_unlock(&wm831x->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_bulk_read);
+
+static int wm831x_write(struct wm831x *wm831x, unsigned short reg,
+			int bytes, void *src)
+{
+	u16 *buf = src;
+	int i;
+
+	BUG_ON(bytes % 2);
+	BUG_ON(bytes <= 0);
+
+	for (i = 0; i < bytes / 2; i++) {
+		if (wm831x_reg_locked(wm831x, reg))
+			return -EPERM;
+
+		dev_vdbg(wm831x->dev, "Write %04x to R%d(0x%x)\n",
+			 buf[i], reg + i, reg + i);
+
+		buf[i] = cpu_to_be16(buf[i]);
+	}
+
+	return wm831x->write_dev(wm831x, reg, bytes, src);
+}
+
+/**
+ * wm831x_reg_write: Write a single WM831x register.
+ *
+ * @wm831x: Device to write to.
+ * @reg: Register to write to.
+ * @val: Value to write.
+ */
+int wm831x_reg_write(struct wm831x *wm831x, unsigned short reg,
+		     unsigned short val)
+{
+	int ret;
+
+	mutex_lock(&wm831x->io_lock);
+
+	ret = wm831x_write(wm831x, reg, 2, &val);
+
+	mutex_unlock(&wm831x->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_reg_write);
+
+/**
+ * wm831x_set_bits: Set the value of a bitfield in a WM831x register
+ *
+ * @wm831x: Device to write to.
+ * @reg: Register to write to.
+ * @mask: Mask of bits to set.
+ * @val: Value to set (unshifted)
+ */
+int wm831x_set_bits(struct wm831x *wm831x, unsigned short reg,
+		    unsigned short mask, unsigned short val)
+{
+	int ret;
+	u16 r;
+
+	mutex_lock(&wm831x->io_lock);
+
+	ret = wm831x_read(wm831x, reg, 2, &r);
+	if (ret < 0)
+		goto out;
+
+	r &= ~mask;
+	r |= val;
+
+	ret = wm831x_write(wm831x, reg, 2, &r);
+
+out:
+	mutex_unlock(&wm831x->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_set_bits);
+
+static struct resource wm831x_dcdc1_resources[] = {
+	{
+		.start = WM831X_DC1_CONTROL_1,
+		.end   = WM831X_DC1_DVS_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_DC1,
+		.end   = WM831X_IRQ_UV_DC1,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name  = "HC",
+		.start = WM831X_IRQ_HC_DC1,
+		.end   = WM831X_IRQ_HC_DC1,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+
+static struct resource wm831x_dcdc2_resources[] = {
+	{
+		.start = WM831X_DC2_CONTROL_1,
+		.end   = WM831X_DC2_DVS_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_DC2,
+		.end   = WM831X_IRQ_UV_DC2,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name  = "HC",
+		.start = WM831X_IRQ_HC_DC2,
+		.end   = WM831X_IRQ_HC_DC2,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_dcdc3_resources[] = {
+	{
+		.start = WM831X_DC3_CONTROL_1,
+		.end   = WM831X_DC3_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_DC3,
+		.end   = WM831X_IRQ_UV_DC3,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_dcdc4_resources[] = {
+	{
+		.start = WM831X_DC4_CONTROL,
+		.end   = WM831X_DC4_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_DC4,
+		.end   = WM831X_IRQ_UV_DC4,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_gpio_resources[] = {
+	{
+		.start = WM831X_IRQ_GPIO_1,
+		.end   = WM831X_IRQ_GPIO_16,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_isink1_resources[] = {
+	{
+		.start = WM831X_CURRENT_SINK_1,
+		.end   = WM831X_CURRENT_SINK_1,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.start = WM831X_IRQ_CS1,
+		.end   = WM831X_IRQ_CS1,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_isink2_resources[] = {
+	{
+		.start = WM831X_CURRENT_SINK_2,
+		.end   = WM831X_CURRENT_SINK_2,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.start = WM831X_IRQ_CS2,
+		.end   = WM831X_IRQ_CS2,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo1_resources[] = {
+	{
+		.start = WM831X_LDO1_CONTROL,
+		.end   = WM831X_LDO1_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO1,
+		.end   = WM831X_IRQ_UV_LDO1,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo2_resources[] = {
+	{
+		.start = WM831X_LDO2_CONTROL,
+		.end   = WM831X_LDO2_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO2,
+		.end   = WM831X_IRQ_UV_LDO2,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo3_resources[] = {
+	{
+		.start = WM831X_LDO3_CONTROL,
+		.end   = WM831X_LDO3_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO3,
+		.end   = WM831X_IRQ_UV_LDO3,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo4_resources[] = {
+	{
+		.start = WM831X_LDO4_CONTROL,
+		.end   = WM831X_LDO4_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO4,
+		.end   = WM831X_IRQ_UV_LDO4,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo5_resources[] = {
+	{
+		.start = WM831X_LDO5_CONTROL,
+		.end   = WM831X_LDO5_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO5,
+		.end   = WM831X_IRQ_UV_LDO5,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo6_resources[] = {
+	{
+		.start = WM831X_LDO6_CONTROL,
+		.end   = WM831X_LDO6_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO6,
+		.end   = WM831X_IRQ_UV_LDO6,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo7_resources[] = {
+	{
+		.start = WM831X_LDO7_CONTROL,
+		.end   = WM831X_LDO7_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO7,
+		.end   = WM831X_IRQ_UV_LDO7,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo8_resources[] = {
+	{
+		.start = WM831X_LDO8_CONTROL,
+		.end   = WM831X_LDO8_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO8,
+		.end   = WM831X_IRQ_UV_LDO8,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo9_resources[] = {
+	{
+		.start = WM831X_LDO9_CONTROL,
+		.end   = WM831X_LDO9_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO9,
+		.end   = WM831X_IRQ_UV_LDO9,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo10_resources[] = {
+	{
+		.start = WM831X_LDO10_CONTROL,
+		.end   = WM831X_LDO10_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_LDO10,
+		.end   = WM831X_IRQ_UV_LDO10,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_ldo11_resources[] = {
+	{
+		.start = WM831X_LDO11_ON_CONTROL,
+		.end   = WM831X_LDO11_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+};
+
+static struct resource wm831x_on_resources[] = {
+	{
+		.start = WM831X_IRQ_ON,
+		.end   = WM831X_IRQ_ON,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+
+static struct resource wm831x_power_resources[] = {
+	{
+		.name = "SYSLO",
+		.start = WM831X_IRQ_PPM_SYSLO,
+		.end   = WM831X_IRQ_PPM_SYSLO,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "PWR SRC",
+		.start = WM831X_IRQ_PPM_PWR_SRC,
+		.end   = WM831X_IRQ_PPM_PWR_SRC,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB CURR",
+		.start = WM831X_IRQ_PPM_USB_CURR,
+		.end   = WM831X_IRQ_PPM_USB_CURR,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BATT HOT",
+		.start = WM831X_IRQ_CHG_BATT_HOT,
+		.end   = WM831X_IRQ_CHG_BATT_HOT,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BATT COLD",
+		.start = WM831X_IRQ_CHG_BATT_COLD,
+		.end   = WM831X_IRQ_CHG_BATT_COLD,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BATT FAIL",
+		.start = WM831X_IRQ_CHG_BATT_FAIL,
+		.end   = WM831X_IRQ_CHG_BATT_FAIL,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "OV",
+		.start = WM831X_IRQ_CHG_OV,
+		.end   = WM831X_IRQ_CHG_OV,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "END",
+		.start = WM831X_IRQ_CHG_END,
+		.end   = WM831X_IRQ_CHG_END,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "TO",
+		.start = WM831X_IRQ_CHG_TO,
+		.end   = WM831X_IRQ_CHG_TO,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MODE",
+		.start = WM831X_IRQ_CHG_MODE,
+		.end   = WM831X_IRQ_CHG_MODE,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "START",
+		.start = WM831X_IRQ_CHG_START,
+		.end   = WM831X_IRQ_CHG_START,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_rtc_resources[] = {
+	{
+		.name = "PER",
+		.start = WM831X_IRQ_RTC_PER,
+		.end   = WM831X_IRQ_RTC_PER,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "ALM",
+		.start = WM831X_IRQ_RTC_ALM,
+		.end   = WM831X_IRQ_RTC_ALM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_status1_resources[] = {
+	{
+		.start = WM831X_STATUS_LED_1,
+		.end   = WM831X_STATUS_LED_1,
+		.flags = IORESOURCE_IO,
+	},
+};
+
+static struct resource wm831x_status2_resources[] = {
+	{
+		.start = WM831X_STATUS_LED_2,
+		.end   = WM831X_STATUS_LED_2,
+		.flags = IORESOURCE_IO,
+	},
+};
+
+static struct resource wm831x_touch_resources[] = {
+	{
+		.name = "TCHPD",
+		.start = WM831X_IRQ_TCHPD,
+		.end   = WM831X_IRQ_TCHPD,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "TCHDATA",
+		.start = WM831X_IRQ_TCHDATA,
+		.end   = WM831X_IRQ_TCHDATA,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm831x_wdt_resources[] = {
+	{
+		.start = WM831X_IRQ_WDOG_TO,
+		.end   = WM831X_IRQ_WDOG_TO,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell wm8310_devs[] = {
+	{
+		.name = "wm831x-buckv",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc1_resources),
+		.resources = wm831x_dcdc1_resources,
+	},
+	{
+		.name = "wm831x-buckv",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc2_resources),
+		.resources = wm831x_dcdc2_resources,
+	},
+	{
+		.name = "wm831x-buckp",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc3_resources),
+		.resources = wm831x_dcdc3_resources,
+	},
+	{
+		.name = "wm831x-boostp",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc4_resources),
+		.resources = wm831x_dcdc4_resources,
+	},
+	{
+		.name = "wm831x-epe",
+		.id = 1,
+	},
+	{
+		.name = "wm831x-epe",
+		.id = 2,
+	},
+	{
+		.name = "wm831x-gpio",
+		.num_resources = ARRAY_SIZE(wm831x_gpio_resources),
+		.resources = wm831x_gpio_resources,
+	},
+	{
+		.name = "wm831x-hwmon",
+	},
+	{
+		.name = "wm831x-isink",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_isink1_resources),
+		.resources = wm831x_isink1_resources,
+	},
+	{
+		.name = "wm831x-isink",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_isink2_resources),
+		.resources = wm831x_isink2_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_ldo1_resources),
+		.resources = wm831x_ldo1_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_ldo2_resources),
+		.resources = wm831x_ldo2_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_ldo3_resources),
+		.resources = wm831x_ldo3_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm831x_ldo4_resources),
+		.resources = wm831x_ldo4_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 5,
+		.num_resources = ARRAY_SIZE(wm831x_ldo5_resources),
+		.resources = wm831x_ldo5_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 6,
+		.num_resources = ARRAY_SIZE(wm831x_ldo6_resources),
+		.resources = wm831x_ldo6_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 7,
+		.num_resources = ARRAY_SIZE(wm831x_ldo7_resources),
+		.resources = wm831x_ldo7_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 8,
+		.num_resources = ARRAY_SIZE(wm831x_ldo8_resources),
+		.resources = wm831x_ldo8_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 9,
+		.num_resources = ARRAY_SIZE(wm831x_ldo9_resources),
+		.resources = wm831x_ldo9_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 10,
+		.num_resources = ARRAY_SIZE(wm831x_ldo10_resources),
+		.resources = wm831x_ldo10_resources,
+	},
+	{
+		.name = "wm831x-alive-ldo",
+		.id = 11,
+		.num_resources = ARRAY_SIZE(wm831x_ldo11_resources),
+		.resources = wm831x_ldo11_resources,
+	},
+	{
+		.name = "wm831x-on",
+		.num_resources = ARRAY_SIZE(wm831x_on_resources),
+		.resources = wm831x_on_resources,
+	},
+	{
+		.name = "wm831x-power",
+		.num_resources = ARRAY_SIZE(wm831x_power_resources),
+		.resources = wm831x_power_resources,
+	},
+	{
+		.name = "wm831x-rtc",
+		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
+		.resources = wm831x_rtc_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
+		.resources = wm831x_status1_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_status2_resources),
+		.resources = wm831x_status2_resources,
+	},
+	{
+		.name = "wm831x-watchdog",
+		.num_resources = ARRAY_SIZE(wm831x_wdt_resources),
+		.resources = wm831x_wdt_resources,
+	},
+};
+
+static struct mfd_cell wm8311_devs[] = {
+	{
+		.name = "wm831x-buckv",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc1_resources),
+		.resources = wm831x_dcdc1_resources,
+	},
+	{
+		.name = "wm831x-buckv",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc2_resources),
+		.resources = wm831x_dcdc2_resources,
+	},
+	{
+		.name = "wm831x-buckp",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc3_resources),
+		.resources = wm831x_dcdc3_resources,
+	},
+	{
+		.name = "wm831x-boostp",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc4_resources),
+		.resources = wm831x_dcdc4_resources,
+	},
+	{
+		.name = "wm831x-epe",
+		.id = 1,
+	},
+	{
+		.name = "wm831x-epe",
+		.id = 2,
+	},
+	{
+		.name = "wm831x-gpio",
+		.num_resources = ARRAY_SIZE(wm831x_gpio_resources),
+		.resources = wm831x_gpio_resources,
+	},
+	{
+		.name = "wm831x-hwmon",
+	},
+	{
+		.name = "wm831x-isink",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_isink1_resources),
+		.resources = wm831x_isink1_resources,
+	},
+	{
+		.name = "wm831x-isink",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_isink2_resources),
+		.resources = wm831x_isink2_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_ldo1_resources),
+		.resources = wm831x_ldo1_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_ldo2_resources),
+		.resources = wm831x_ldo2_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_ldo3_resources),
+		.resources = wm831x_ldo3_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm831x_ldo4_resources),
+		.resources = wm831x_ldo4_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 5,
+		.num_resources = ARRAY_SIZE(wm831x_ldo5_resources),
+		.resources = wm831x_ldo5_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 7,
+		.num_resources = ARRAY_SIZE(wm831x_ldo7_resources),
+		.resources = wm831x_ldo7_resources,
+	},
+	{
+		.name = "wm831x-alive-ldo",
+		.id = 11,
+		.num_resources = ARRAY_SIZE(wm831x_ldo11_resources),
+		.resources = wm831x_ldo11_resources,
+	},
+	{
+		.name = "wm831x-on",
+		.num_resources = ARRAY_SIZE(wm831x_on_resources),
+		.resources = wm831x_on_resources,
+	},
+	{
+		.name = "wm831x-power",
+		.num_resources = ARRAY_SIZE(wm831x_power_resources),
+		.resources = wm831x_power_resources,
+	},
+	{
+		.name = "wm831x-rtc",
+		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
+		.resources = wm831x_rtc_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
+		.resources = wm831x_status1_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_status2_resources),
+		.resources = wm831x_status2_resources,
+	},
+	{
+		.name = "wm831x-touch",
+		.num_resources = ARRAY_SIZE(wm831x_touch_resources),
+		.resources = wm831x_touch_resources,
+	},
+	{
+		.name = "wm831x-watchdog",
+		.num_resources = ARRAY_SIZE(wm831x_wdt_resources),
+		.resources = wm831x_wdt_resources,
+	},
+};
+
+static struct mfd_cell wm8312_devs[] = {
+	{
+		.name = "wm831x-buckv",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc1_resources),
+		.resources = wm831x_dcdc1_resources,
+	},
+	{
+		.name = "wm831x-buckv",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc2_resources),
+		.resources = wm831x_dcdc2_resources,
+	},
+	{
+		.name = "wm831x-buckp",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc3_resources),
+		.resources = wm831x_dcdc3_resources,
+	},
+	{
+		.name = "wm831x-boostp",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc4_resources),
+		.resources = wm831x_dcdc4_resources,
+	},
+	{
+		.name = "wm831x-epe",
+		.id = 1,
+	},
+	{
+		.name = "wm831x-epe",
+		.id = 2,
+	},
+	{
+		.name = "wm831x-gpio",
+		.num_resources = ARRAY_SIZE(wm831x_gpio_resources),
+		.resources = wm831x_gpio_resources,
+	},
+	{
+		.name = "wm831x-hwmon",
+	},
+	{
+		.name = "wm831x-isink",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_isink1_resources),
+		.resources = wm831x_isink1_resources,
+	},
+	{
+		.name = "wm831x-isink",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_isink2_resources),
+		.resources = wm831x_isink2_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_ldo1_resources),
+		.resources = wm831x_ldo1_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_ldo2_resources),
+		.resources = wm831x_ldo2_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_ldo3_resources),
+		.resources = wm831x_ldo3_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm831x_ldo4_resources),
+		.resources = wm831x_ldo4_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 5,
+		.num_resources = ARRAY_SIZE(wm831x_ldo5_resources),
+		.resources = wm831x_ldo5_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 6,
+		.num_resources = ARRAY_SIZE(wm831x_ldo6_resources),
+		.resources = wm831x_ldo6_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 7,
+		.num_resources = ARRAY_SIZE(wm831x_ldo7_resources),
+		.resources = wm831x_ldo7_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 8,
+		.num_resources = ARRAY_SIZE(wm831x_ldo8_resources),
+		.resources = wm831x_ldo8_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 9,
+		.num_resources = ARRAY_SIZE(wm831x_ldo9_resources),
+		.resources = wm831x_ldo9_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 10,
+		.num_resources = ARRAY_SIZE(wm831x_ldo10_resources),
+		.resources = wm831x_ldo10_resources,
+	},
+	{
+		.name = "wm831x-alive-ldo",
+		.id = 11,
+		.num_resources = ARRAY_SIZE(wm831x_ldo11_resources),
+		.resources = wm831x_ldo11_resources,
+	},
+	{
+		.name = "wm831x-on",
+		.num_resources = ARRAY_SIZE(wm831x_on_resources),
+		.resources = wm831x_on_resources,
+	},
+	{
+		.name = "wm831x-power",
+		.num_resources = ARRAY_SIZE(wm831x_power_resources),
+		.resources = wm831x_power_resources,
+	},
+	{
+		.name = "wm831x-rtc",
+		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
+		.resources = wm831x_rtc_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
+		.resources = wm831x_status1_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_status2_resources),
+		.resources = wm831x_status2_resources,
+	},
+	{
+		.name = "wm831x-touch",
+		.num_resources = ARRAY_SIZE(wm831x_touch_resources),
+		.resources = wm831x_touch_resources,
+	},
+	{
+		.name = "wm831x-watchdog",
+		.num_resources = ARRAY_SIZE(wm831x_wdt_resources),
+		.resources = wm831x_wdt_resources,
+	},
+};
+
+/*
+ * Instantiate the generic non-control parts of the device.
+ */
+static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
+{
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int rev;
+	enum wm831x_parent parent;
+	int ret;
+
+	mutex_init(&wm831x->io_lock);
+	mutex_init(&wm831x->key_lock);
+	dev_set_drvdata(wm831x->dev, wm831x);
+
+	ret = wm831x_reg_read(wm831x, WM831X_PARENT_ID);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read parent ID: %d\n", ret);
+		goto err;
+	}
+	if (ret != 0x6204) {
+		dev_err(wm831x->dev, "Device is not a WM831x: ID %x\n", ret);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = wm831x_reg_read(wm831x, WM831X_REVISION);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read revision: %d\n", ret);
+		goto err;
+	}
+	rev = (ret & WM831X_PARENT_REV_MASK) >> WM831X_PARENT_REV_SHIFT;
+
+	ret = wm831x_reg_read(wm831x, WM831X_RESET_ID);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read device ID: %d\n", ret);
+		goto err;
+	}
+
+	switch (ret) {
+	case 0x8310:
+		parent = WM8310;
+		switch (rev) {
+		case 0:
+			dev_info(wm831x->dev, "WM8310 revision %c\n",
+				 'A' + rev);
+			break;
+		}
+		break;
+
+	case 0x8311:
+		parent = WM8311;
+		switch (rev) {
+		case 0:
+			dev_info(wm831x->dev, "WM8311 revision %c\n",
+				 'A' + rev);
+			break;
+		}
+		break;
+
+	case 0x8312:
+		parent = WM8312;
+		switch (rev) {
+		case 0:
+			dev_info(wm831x->dev, "WM8312 revision %c\n",
+				 'A' + rev);
+			break;
+		}
+		break;
+
+	case 0:
+		/* Some engineering samples do not have the ID set,
+		 * rely on the device being registered correctly.
+		 * This will need revisiting for future devices with
+		 * multiple dies.
+		 */
+		parent = id;
+		switch (rev) {
+		case 0:
+			dev_info(wm831x->dev, "WM831%d ES revision %c\n",
+				 parent, 'A' + rev);
+			break;
+		}
+		break;
+
+	default:
+		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* This will need revisiting in future but is OK for all
+	 * current parts.
+	 */
+	if (parent != id)
+		dev_warn(wm831x->dev, "Device was registered as a WM831%lu\n",
+			 id);
+
+	/* Bootstrap the user key */
+	ret = wm831x_reg_read(wm831x, WM831X_SECURITY_KEY);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read security key: %d\n", ret);
+		goto err;
+	}
+	if (ret != 0) {
+		dev_warn(wm831x->dev, "Security key had non-zero value %x\n",
+			 ret);
+		wm831x_reg_write(wm831x, WM831X_SECURITY_KEY, 0);
+	}
+	wm831x->locked = 1;
+
+	if (pdata && pdata->pre_init) {
+		ret = pdata->pre_init(wm831x);
+		if (ret != 0) {
+			dev_err(wm831x->dev, "pre_init() failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	/* The core device is up, instantiate the subdevices. */
+	switch (parent) {
+	case WM8310:
+		ret = mfd_add_devices(wm831x->dev, -1,
+				      wm8310_devs, ARRAY_SIZE(wm8310_devs),
+				      NULL, 0);
+		break;
+
+	case WM8311:
+		ret = mfd_add_devices(wm831x->dev, -1,
+				      wm8311_devs, ARRAY_SIZE(wm8311_devs),
+				      NULL, 0);
+		break;
+
+	case WM8312:
+		ret = mfd_add_devices(wm831x->dev, -1,
+				      wm8312_devs, ARRAY_SIZE(wm8312_devs),
+				      NULL, 0);
+		break;
+
+	default:
+		/* If this happens the bus probe function is buggy */
+		BUG();
+	}
+
+	if (ret != 0) {
+		dev_err(wm831x->dev, "Failed to add children\n");
+		goto err;
+	}
+
+	if (pdata && pdata->post_init) {
+		ret = pdata->post_init(wm831x);
+		if (ret != 0) {
+			dev_err(wm831x->dev, "post_init() failed: %d\n", ret);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	mfd_remove_devices(wm831x->dev);
+	kfree(wm831x);
+	return ret;
+}
+
+static void wm831x_device_exit(struct wm831x *wm831x)
+{
+	mfd_remove_devices(wm831x->dev);
+	kfree(wm831x);
+}
+
+static int wm831x_i2c_read_device(struct wm831x *wm831x, unsigned short reg,
+				  int bytes, void *dest)
+{
+	struct i2c_client *i2c = wm831x->control_data;
+	int ret;
+	u16 r = cpu_to_be16(reg);
+
+	ret = i2c_master_send(i2c, (unsigned char *)&r, 2);
+	if (ret < 0)
+		return ret;
+	if (ret != 2)
+		return -EIO;
+
+	ret = i2c_master_recv(i2c, dest, bytes);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes)
+		return -EIO;
+	return 0;
+}
+
+/* Currently we allocate the write buffer on the stack; this is OK for
+ * small writes - if we need to do large writes this will need to be
+ * revised.
+ */
+static int wm831x_i2c_write_device(struct wm831x *wm831x, unsigned short reg,
+				   int bytes, void *src)
+{
+	struct i2c_client *i2c = wm831x->control_data;
+	unsigned char msg[bytes + 2];
+	int ret;
+
+	reg = cpu_to_be16(reg);
+	memcpy(&msg[0], &reg, 2);
+	memcpy(&msg[2], src, bytes);
+
+	ret = i2c_master_send(i2c, msg, bytes + 2);
+	if (ret < 0)
+		return ret;
+	if (ret < bytes + 2)
+		return -EIO;
+
+	return 0;
+}
+
+static int wm831x_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct wm831x *wm831x;
+
+	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
+	if (wm831x == NULL) {
+		kfree(i2c);
+		return -ENOMEM;
+	}
+
+	i2c_set_clientdata(i2c, wm831x);
+	wm831x->dev = &i2c->dev;
+	wm831x->control_data = i2c;
+	wm831x->read_dev = wm831x_i2c_read_device;
+	wm831x->write_dev = wm831x_i2c_write_device;
+
+	return wm831x_device_init(wm831x, id->driver_data, i2c->irq);
+}
+
+static int wm831x_i2c_remove(struct i2c_client *i2c)
+{
+	struct wm831x *wm831x = i2c_get_clientdata(i2c);
+
+	wm831x_device_exit(wm831x);
+
+	return 0;
+}
+
+static const struct i2c_device_id wm831x_i2c_id[] = {
+	{ "wm8310", WM8310 },
+	{ "wm8311", WM8311 },
+	{ "wm8312", WM8312 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
+
+
+static struct i2c_driver wm831x_i2c_driver = {
+	.driver = {
+		   .name = "wm831x",
+		   .owner = THIS_MODULE,
+	},
+	.probe = wm831x_i2c_probe,
+	.remove = wm831x_i2c_remove,
+	.id_table = wm831x_i2c_id,
+};
+
+static int __init wm831x_i2c_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&wm831x_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register wm831x I2C driver: %d\n", ret);
+
+	return ret;
+}
+subsys_initcall(wm831x_i2c_init);
+
+static void __exit wm831x_i2c_exit(void)
+{
+	i2c_del_driver(&wm831x_i2c_driver);
+}
+module_exit(wm831x_i2c_exit);
+
+MODULE_DESCRIPTION("I2C support for the WM831X AudioPlus PMIC");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mark Brown");
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
new file mode 100644
index 0000000..d90e693
--- /dev/null
+++ b/include/linux/mfd/wm831x/core.h
@@ -0,0 +1,247 @@
+/*
+ * include/linux/mfd/wm831x/core.h -- Core interface for WM831x
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
+#ifndef __MFD_WM831X_CORE_H__
+#define __MFD_WM831X_CORE_H__
+
+/*
+ * Register values.
+ */
+#define WM831X_RESET_ID                         0x00
+#define WM831X_REVISION                         0x01
+#define WM831X_PARENT_ID                        0x4000
+#define WM831X_SYSVDD_CONTROL                   0x4001
+#define WM831X_THERMAL_MONITORING               0x4002
+#define WM831X_POWER_STATE                      0x4003
+#define WM831X_WATCHDOG                         0x4004
+#define WM831X_ON_PIN_CONTROL                   0x4005
+#define WM831X_RESET_CONTROL                    0x4006
+#define WM831X_CONTROL_INTERFACE                0x4007
+#define WM831X_SECURITY_KEY                     0x4008
+#define WM831X_SOFTWARE_SCRATCH                 0x4009
+#define WM831X_OTP_CONTROL                      0x400A
+#define WM831X_GPIO_LEVEL                       0x400C
+#define WM831X_SYSTEM_STATUS                    0x400D
+#define WM831X_ON_SOURCE                        0x400E
+#define WM831X_OFF_SOURCE                       0x400F
+#define WM831X_SYSTEM_INTERRUPTS                0x4010
+#define WM831X_INTERRUPT_STATUS_1               0x4011
+#define WM831X_INTERRUPT_STATUS_2               0x4012
+#define WM831X_INTERRUPT_STATUS_3               0x4013
+#define WM831X_INTERRUPT_STATUS_4               0x4014
+#define WM831X_INTERRUPT_STATUS_5               0x4015
+#define WM831X_IRQ_CONFIG                       0x4017
+#define WM831X_SYSTEM_INTERRUPTS_MASK           0x4018
+#define WM831X_INTERRUPT_STATUS_1_MASK          0x4019
+#define WM831X_INTERRUPT_STATUS_2_MASK          0x401A
+#define WM831X_INTERRUPT_STATUS_3_MASK          0x401B
+#define WM831X_INTERRUPT_STATUS_4_MASK          0x401C
+#define WM831X_INTERRUPT_STATUS_5_MASK          0x401D
+#define WM831X_RTC_WRITE_COUNTER                0x4020
+#define WM831X_RTC_TIME_1                       0x4021
+#define WM831X_RTC_TIME_2                       0x4022
+#define WM831X_RTC_ALARM_1                      0x4023
+#define WM831X_RTC_ALARM_2                      0x4024
+#define WM831X_RTC_CONTROL                      0x4025
+#define WM831X_RTC_TRIM                         0x4026
+#define WM831X_TOUCH_CONTROL_1                  0x4028
+#define WM831X_TOUCH_CONTROL_2                  0x4029
+#define WM831X_TOUCH_DATA_X                     0x402A
+#define WM831X_TOUCH_DATA_Y                     0x402B
+#define WM831X_TOUCH_DATA_Z                     0x402C
+#define WM831X_AUXADC_DATA                      0x402D
+#define WM831X_AUXADC_CONTROL                   0x402E
+#define WM831X_AUXADC_SOURCE                    0x402F
+#define WM831X_COMPARATOR_CONTROL               0x4030
+#define WM831X_COMPARATOR_1                     0x4031
+#define WM831X_COMPARATOR_2                     0x4032
+#define WM831X_COMPARATOR_3                     0x4033
+#define WM831X_COMPARATOR_4                     0x4034
+#define WM831X_GPIO1_CONTROL                    0x4038
+#define WM831X_GPIO2_CONTROL                    0x4039
+#define WM831X_GPIO3_CONTROL                    0x403A
+#define WM831X_GPIO4_CONTROL                    0x403B
+#define WM831X_GPIO5_CONTROL                    0x403C
+#define WM831X_GPIO6_CONTROL                    0x403D
+#define WM831X_GPIO7_CONTROL                    0x403E
+#define WM831X_GPIO8_CONTROL                    0x403F
+#define WM831X_GPIO9_CONTROL                    0x4040
+#define WM831X_GPIO10_CONTROL                   0x4041
+#define WM831X_GPIO11_CONTROL                   0x4042
+#define WM831X_GPIO12_CONTROL                   0x4043
+#define WM831X_GPIO13_CONTROL                   0x4044
+#define WM831X_GPIO14_CONTROL                   0x4045
+#define WM831X_GPIO15_CONTROL                   0x4046
+#define WM831X_GPIO16_CONTROL                   0x4047
+#define WM831X_CHARGER_CONTROL_1                0x4048
+#define WM831X_CHARGER_CONTROL_2                0x4049
+#define WM831X_CHARGER_STATUS                   0x404A
+#define WM831X_BACKUP_CHARGER_CONTROL           0x404B
+#define WM831X_STATUS_LED_1                     0x404C
+#define WM831X_STATUS_LED_2                     0x404D
+#define WM831X_CURRENT_SINK_1                   0x404E
+#define WM831X_CURRENT_SINK_2                   0x404F
+#define WM831X_DCDC_ENABLE                      0x4050
+#define WM831X_LDO_ENABLE                       0x4051
+#define WM831X_DCDC_STATUS                      0x4052
+#define WM831X_LDO_STATUS                       0x4053
+#define WM831X_DCDC_UV_STATUS                   0x4054
+#define WM831X_LDO_UV_STATUS                    0x4055
+#define WM831X_DC1_CONTROL_1                    0x4056
+#define WM831X_DC1_CONTROL_2                    0x4057
+#define WM831X_DC1_ON_CONFIG                    0x4058
+#define WM831X_DC1_SLEEP_CONTROL                0x4059
+#define WM831X_DC1_DVS_CONTROL                  0x405A
+#define WM831X_DC2_CONTROL_1                    0x405B
+#define WM831X_DC2_CONTROL_2                    0x405C
+#define WM831X_DC2_ON_CONFIG                    0x405D
+#define WM831X_DC2_SLEEP_CONTROL                0x405E
+#define WM831X_DC2_DVS_CONTROL                  0x405F
+#define WM831X_DC3_CONTROL_1                    0x4060
+#define WM831X_DC3_CONTROL_2                    0x4061
+#define WM831X_DC3_ON_CONFIG                    0x4062
+#define WM831X_DC3_SLEEP_CONTROL                0x4063
+#define WM831X_DC4_CONTROL                      0x4064
+#define WM831X_DC4_SLEEP_CONTROL                0x4065
+#define WM831X_EPE1_CONTROL                     0x4066
+#define WM831X_EPE2_CONTROL                     0x4067
+#define WM831X_LDO1_CONTROL                     0x4068
+#define WM831X_LDO1_ON_CONTROL                  0x4069
+#define WM831X_LDO1_SLEEP_CONTROL               0x406A
+#define WM831X_LDO2_CONTROL                     0x406B
+#define WM831X_LDO2_ON_CONTROL                  0x406C
+#define WM831X_LDO2_SLEEP_CONTROL               0x406D
+#define WM831X_LDO3_CONTROL                     0x406E
+#define WM831X_LDO3_ON_CONTROL                  0x406F
+#define WM831X_LDO3_SLEEP_CONTROL               0x4070
+#define WM831X_LDO4_CONTROL                     0x4071
+#define WM831X_LDO4_ON_CONTROL                  0x4072
+#define WM831X_LDO4_SLEEP_CONTROL               0x4073
+#define WM831X_LDO5_CONTROL                     0x4074
+#define WM831X_LDO5_ON_CONTROL                  0x4075
+#define WM831X_LDO5_SLEEP_CONTROL               0x4076
+#define WM831X_LDO6_CONTROL                     0x4077
+#define WM831X_LDO6_ON_CONTROL                  0x4078
+#define WM831X_LDO6_SLEEP_CONTROL               0x4079
+#define WM831X_LDO7_CONTROL                     0x407A
+#define WM831X_LDO7_ON_CONTROL                  0x407B
+#define WM831X_LDO7_SLEEP_CONTROL               0x407C
+#define WM831X_LDO8_CONTROL                     0x407D
+#define WM831X_LDO8_ON_CONTROL                  0x407E
+#define WM831X_LDO8_SLEEP_CONTROL               0x407F
+#define WM831X_LDO9_CONTROL                     0x4080
+#define WM831X_LDO9_ON_CONTROL                  0x4081
+#define WM831X_LDO9_SLEEP_CONTROL               0x4082
+#define WM831X_LDO10_CONTROL                    0x4083
+#define WM831X_LDO10_ON_CONTROL                 0x4084
+#define WM831X_LDO10_SLEEP_CONTROL              0x4085
+#define WM831X_LDO11_ON_CONTROL                 0x4087
+#define WM831X_LDO11_SLEEP_CONTROL              0x4088
+#define WM831X_POWER_GOOD_SOURCE_1              0x408E
+#define WM831X_POWER_GOOD_SOURCE_2              0x408F
+#define WM831X_CLOCK_CONTROL_1                  0x4090
+#define WM831X_CLOCK_CONTROL_2                  0x4091
+#define WM831X_FLL_CONTROL_1                    0x4092
+#define WM831X_FLL_CONTROL_2                    0x4093
+#define WM831X_FLL_CONTROL_3                    0x4094
+#define WM831X_FLL_CONTROL_4                    0x4095
+#define WM831X_FLL_CONTROL_5                    0x4096
+#define WM831X_UNIQUE_ID_1                      0x7800
+#define WM831X_UNIQUE_ID_2                      0x7801
+#define WM831X_UNIQUE_ID_3                      0x7802
+#define WM831X_UNIQUE_ID_4                      0x7803
+#define WM831X_UNIQUE_ID_5                      0x7804
+#define WM831X_UNIQUE_ID_6                      0x7805
+#define WM831X_UNIQUE_ID_7                      0x7806
+#define WM831X_UNIQUE_ID_8                      0x7807
+#define WM831X_FACTORY_OTP_ID                   0x7808
+#define WM831X_FACTORY_OTP_1                    0x7809
+#define WM831X_FACTORY_OTP_2                    0x780A
+#define WM831X_FACTORY_OTP_3                    0x780B
+#define WM831X_FACTORY_OTP_4                    0x780C
+#define WM831X_FACTORY_OTP_5                    0x780D
+#define WM831X_CUSTOMER_OTP_ID                  0x7810
+#define WM831X_DC1_OTP_CONTROL                  0x7811
+#define WM831X_DC2_OTP_CONTROL                  0x7812
+#define WM831X_DC3_OTP_CONTROL                  0x7813
+#define WM831X_LDO1_2_OTP_CONTROL               0x7814
+#define WM831X_LDO3_4_OTP_CONTROL               0x7815
+#define WM831X_LDO5_6_OTP_CONTROL               0x7816
+#define WM831X_LDO7_8_OTP_CONTROL               0x7817
+#define WM831X_LDO9_10_OTP_CONTROL              0x7818
+#define WM831X_LDO11_EPE_CONTROL                0x7819
+#define WM831X_GPIO1_OTP_CONTROL                0x781A
+#define WM831X_GPIO2_OTP_CONTROL                0x781B
+#define WM831X_GPIO3_OTP_CONTROL                0x781C
+#define WM831X_GPIO4_OTP_CONTROL                0x781D
+#define WM831X_GPIO5_OTP_CONTROL                0x781E
+#define WM831X_GPIO6_OTP_CONTROL                0x781F
+#define WM831X_DBE_CHECK_DATA                   0x7827
+
+/*
+ * R0 (0x00) - Reset ID
+ */
+#define WM831X_CHIP_ID_MASK                     0xFFFF  /* CHIP_ID - [15:0] */
+#define WM831X_CHIP_ID_SHIFT                         0  /* CHIP_ID - [15:0] */
+#define WM831X_CHIP_ID_WIDTH                        16  /* CHIP_ID - [15:0] */
+
+/*
+ * R1 (0x01) - Revision
+ */
+#define WM831X_PARENT_REV_MASK                  0xFF00  /* PARENT_REV - [15:8] */
+#define WM831X_PARENT_REV_SHIFT                      8  /* PARENT_REV - [15:8] */
+#define WM831X_PARENT_REV_WIDTH                      8  /* PARENT_REV - [15:8] */
+#define WM831X_CHILD_REV_MASK                   0x00FF  /* CHILD_REV - [7:0] */
+#define WM831X_CHILD_REV_SHIFT                       0  /* CHILD_REV - [7:0] */
+#define WM831X_CHILD_REV_WIDTH                       8  /* CHILD_REV - [7:0] */
+
+/*
+ * R16384 (0x4000) - Parent ID
+ */
+#define WM831X_PARENT_ID_MASK                   0xFFFF  /* PARENT_ID - [15:0] */
+#define WM831X_PARENT_ID_SHIFT                       0  /* PARENT_ID - [15:0] */
+#define WM831X_PARENT_ID_WIDTH                      16  /* PARENT_ID - [15:0] */
+
+struct wm831x {
+	struct mutex io_lock;
+
+	struct device *dev;
+	int (*read_dev)(struct wm831x *wm831x, unsigned short reg,
+			int bytes, void *dest);
+	int (*write_dev)(struct wm831x *wm831x, unsigned short reg,
+			 int bytes, void *src);
+
+	void *control_data;
+
+	/* The WM831x has a security key blocking access to certain
+	 * registers.  The mutex is taken by the accessors for locking
+	 * and unlocking the security key, locked is used to fail
+	 * writes if the lock is held.
+	 */
+	struct mutex key_lock;
+	unsigned int locked:1;
+};
+
+/* Device I/O API */
+int wm831x_reg_read(struct wm831x *wm831x, unsigned short reg);
+int wm831x_reg_write(struct wm831x *wm831x, unsigned short reg,
+		 unsigned short val);
+void wm831x_reg_lock(struct wm831x *wm831x);
+int wm831x_reg_unlock(struct wm831x *wm831x);
+int wm831x_set_bits(struct wm831x *wm831x, unsigned short reg,
+		    unsigned short mask, unsigned short val);
+int wm831x_bulk_read(struct wm831x *wm831x, unsigned short reg,
+		     int count, u16 *buf);
+
+#endif
diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
new file mode 100644
index 0000000..571e601
--- /dev/null
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -0,0 +1,107 @@
+/*
+ * include/linux/mfd/wm831x/pdata.h -- Platform data for WM831x
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
+#ifndef __MFD_WM831X_PDATA_H__
+#define __MFD_WM831X_PDATA_H__
+
+struct wm831x;
+struct regulator_init_data;
+
+struct wm831x_backup_pdata {
+	int charger_enable;
+	int no_constant_voltage;  /** Disable constant voltage charging */
+	int vlim;   /** Voltage limit in milivolts */
+	int ilim;   /** Current limit in microamps */
+};
+
+struct wm831x_battery_pdata {
+	int enable;         /** Enable charging */
+	int fast_enable;    /** Enable fast charging */
+	int off_mask;       /** Mask OFF while charging */
+	int trickle_ilim;   /** Trickle charge current limit, in mA */
+	int vsel;           /** Target voltage, in mV */
+	int eoc_iterm;      /** End of trickle charge current, in mA */
+	int fast_ilim;      /** Fast charge current limit, in mA */
+	int timeout;        /** Charge cycle timeout, in minutes */
+};
+
+/* Sources for status LED configuration.  Values are register values
+ * plus 1 to allow for a zero default for preserve.
+ */
+enum wm831x_status_src {
+	WM831X_STATUS_PRESERVE = 0,  /* Keep the current hardware setting */
+	WM831X_STATUS_OTP = 1,
+	WM831X_STATUS_POWER = 2,
+	WM831X_STATUS_CHARGER = 3,
+	WM831X_STATUS_MANUAL = 4,
+};
+
+struct wm831x_status_pdata {
+	enum wm831x_status_src default_src;
+	const char *name;
+	const char *default_trigger;
+};
+
+struct wm831x_touch_pdata {
+	int fivewire;          /** 1 for five wire mode, 0 for 4 wire */
+	int isel;              /** Current for pen down (uA) */
+	int rpu;               /** Pen down sensitivity resistor divider */
+	int pressure;          /** Report pressure (boolean) */
+	int data_irq;          /** Touch data ready IRQ */
+};
+
+enum wm831x_watchdog_action {
+	WM831X_WDOG_NONE = 0,
+	WM831X_WDOG_INTERRUPT = 1,
+	WM831X_WDOG_RESET = 2,
+	WM831X_WDOG_WAKE = 3,
+};
+
+struct wm831x_watchdog_pdata {
+	enum wm831x_watchdog_action primary, secondary;
+	int update_gpio;
+	unsigned int software:1;
+};
+
+#define WM831X_MAX_STATUS 2
+#define WM831X_MAX_DCDC   4
+#define WM831X_MAX_EPE    2
+#define WM831X_MAX_LDO    11
+#define WM831X_MAX_ISINK  2
+
+struct wm831x_pdata {
+	/** Called before subdevices are set up */
+	int (*pre_init)(struct wm831x *wm831x);
+	/** Called after subdevices are set up */
+	int (*post_init)(struct wm831x *wm831x);
+
+	int gpio_base;
+	struct wm831x_backup_pdata *backup;
+	struct wm831x_battery_pdata *battery;
+	struct wm831x_touch_pdata *touch;
+	struct wm831x_watchdog_pdata *watchdog;
+
+	/** LED1 = 0 and so on */
+	struct wm831x_status_pdata *status[WM831X_MAX_STATUS];
+	/** DCDC1 = 0 and so on */
+	struct regulator_init_data *dcdc[WM831X_MAX_DCDC];
+	/** EPE1 = 0 and so on */
+	struct regulator_init_data *epe[WM831X_MAX_EPE];
+	/** LDO1 = 0 and so on */
+	struct regulator_init_data *ldo[WM831X_MAX_LDO];
+	/** ISINK1 = 0 and so on*/
+	struct regulator_init_data *isink[WM831X_MAX_ISINK];
+};
+
+#endif
-- 
1.6.3.3

