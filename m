Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYJFMmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYJFMmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYJFMi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:38:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40073 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753164AbYJFMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:38:15 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/13] mfd: Core support for the WM8350 AudioPlus PMIC
Date: Mon,  6 Oct 2008 13:38:03 +0100
Message-Id: <1223296688-9960-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223296688-9960-7-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main>
 <1223296688-9960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-6-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-7-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8350 is an integrated audio and power management subsystem
intended for use as the primary PMIC in mobile multimedia applications.
The WM8350 can be controlled via either I2C or SPI - the control
interface is provided by a separate module in order to allow greatest
flexibility in configuring the kernel.

This driver was originally written by Liam Girdwood and has since been
updated to current kernel APIs and split up for submission by me.  All
the heavy lifting here was done by Liam.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig             |   47 ++
 drivers/mfd/Makefile            |    2 +
 drivers/mfd/wm8350-core.c       |  456 ++++++++++++++
 drivers/mfd/wm8350-regmap.c     | 1323 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/core.h |  585 +++++++++++++++++
 5 files changed, 2413 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wm8350-core.c
 create mode 100644 drivers/mfd/wm8350-regmap.c
 create mode 100644 include/linux/mfd/wm8350/core.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0541dfb..c32d676 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -86,6 +86,53 @@ config MFD_WM8400
 	  the device, additional drivers must be enabled in order to use
 	  the functionality of the device.
 
+config MFD_WM8350
+	tristate
+
+config MFD_WM8350_CONFIG_MODE_0
+	bool "Support WM8350 in configuration mode 0"
+	depends on MFD_WM8350
+	default y
+	help
+	  The WM8350 offers four configuration modes with different
+	  initial register states.  This option enables support for the
+	  WM8350 in mode 0.
+
+	  If unsure say Y
+
+config MFD_WM8350_CONFIG_MODE_1
+	bool "Support WM8350 in configuration mode 1"
+	depends on MFD_WM8350
+	default y
+	help
+	  The WM8350 offers four configuration modes with different
+	  initial register states.  This option enables support for the
+	  WM8350 in mode 1.
+	  
+	  If unsure say Y
+
+config MFD_WM8350_CONFIG_MODE_2
+	bool "Support WM8350 in configuration mode 2"
+	depends on MFD_WM8350
+	default y
+	help
+	  The WM8350 offers four configuration modes with different
+	  initial register states.  This option enables support for the
+	  WM8350 in mode 2.
+	  
+	  If unsure say Y
+
+config MFD_WM8350_CONFIG_MODE_3
+	bool "Support WM8350 in configuration mode 3"
+	depends on MFD_WM8350
+	default y
+	help
+	  The WM8350 offers four configuration modes with different
+	  initial register states.  This option enables support for the
+	  WM8350 in mode 3.
+	  
+	  If unsure say Y
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 172439d..b0adca0 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -13,6 +13,8 @@ obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o
 obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o
 
 obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
+wm8350-objs			:= wm8350-core.o wm8350-regmap.o
+obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
new file mode 100644
index 0000000..c7552c0
--- /dev/null
+++ b/drivers/mfd/wm8350-core.c
@@ -0,0 +1,456 @@
+/*
+ * wm8350-core.c  --  Device access for Wolfson WM8350
+ *
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC.
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
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+
+#include <linux/mfd/wm8350/core.h>
+#include <linux/mfd/wm8350/audio.h>
+#include <linux/mfd/wm8350/gpio.h>
+#include <linux/mfd/wm8350/pmic.h>
+#include <linux/mfd/wm8350/supply.h>
+
+#define WM8350_UNLOCK_KEY		0x0013
+#define WM8350_LOCK_KEY			0x0000
+
+#define WM8350_CLOCK_CONTROL_1		0x28
+#define WM8350_AIF_TEST			0x74
+
+/* debug */
+#define WM8350_BUS_DEBUG 0
+#if WM8350_BUS_DEBUG
+#define dump(regs, src) do { \
+	int i_; \
+	u16 *src_ = src; \
+	printk(KERN_DEBUG); \
+	for (i_ = 0; i_ < regs; i_++) \
+		printk(" 0x%4.4x", *src_++); \
+	printk("\n"); \
+} while (0);
+#else
+#define dump(bytes, src)
+#endif
+
+#define WM8350_LOCK_DEBUG 0
+#if WM8350_LOCK_DEBUG
+#define ldbg(format, arg...) printk(format, ## arg)
+#else
+#define ldbg(format, arg...)
+#endif
+
+/*
+ * WM8350 Device IO
+ */
+static DEFINE_MUTEX(io_mutex);
+static DEFINE_MUTEX(reg_lock_mutex);
+static DEFINE_MUTEX(auxadc_mutex);
+
+/* Perform a physical read from the device.
+ */
+static int wm8350_phys_read(struct wm8350 *wm8350, u8 reg, int num_regs,
+			    u16 *dest)
+{
+	int i, ret;
+	int bytes = num_regs * 2;
+
+	dev_dbg(wm8350->dev, "volatile read\n");
+	ret = wm8350->read_dev(wm8350, reg, bytes, (char *)dest);
+
+	for (i = reg; i < reg + num_regs; i++) {
+		/* Cache is CPU endian */
+		dest[i - reg] = be16_to_cpu(dest[i - reg]);
+
+		/* Satisfy non-volatile bits from cache */
+		dest[i - reg] &= wm8350_reg_io_map[i].vol;
+		dest[i - reg] |= wm8350->reg_cache[i];
+
+		/* Mask out non-readable bits */
+		dest[i - reg] &= wm8350_reg_io_map[i].readable;
+	}
+
+	dump(num_regs, dest);
+
+	return ret;
+}
+
+static int wm8350_read(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *dest)
+{
+	int i;
+	int end = reg + num_regs;
+	int ret = 0;
+	int bytes = num_regs * 2;
+
+	if (wm8350->read_dev == NULL)
+		return -ENODEV;
+
+	if ((reg + num_regs - 1) > WM8350_MAX_REGISTER) {
+		dev_err(wm8350->dev, "invalid reg %x\n",
+			reg + num_regs - 1);
+		return -EINVAL;
+	}
+
+	dev_dbg(wm8350->dev,
+		"%s R%d(0x%2.2x) %d regs\n", __func__, reg, reg, num_regs);
+
+#if WM8350_BUS_DEBUG
+	/* we can _safely_ read any register, but warn if read not supported */
+	for (i = reg; i < end; i++) {
+		if (!wm8350_reg_io_map[i].readable)
+			dev_warn(wm8350->dev,
+				"reg R%d is not readable\n", i);
+	}
+#endif
+
+	/* if any volatile registers are required, then read back all */
+	for (i = reg; i < end; i++)
+		if (wm8350_reg_io_map[i].vol)
+			return wm8350_phys_read(wm8350, reg, num_regs, dest);
+
+	/* no volatiles, then cache is good */
+	dev_dbg(wm8350->dev, "cache read\n");
+	memcpy(dest, &wm8350->reg_cache[reg], bytes);
+	dump(num_regs, dest);
+	return ret;
+}
+
+static inline int is_reg_locked(struct wm8350 *wm8350, u8 reg)
+{
+	if (reg == WM8350_SECURITY ||
+	    wm8350->reg_cache[WM8350_SECURITY] == WM8350_UNLOCK_KEY)
+		return 0;
+
+	if ((reg == WM8350_GPIO_CONFIGURATION_I_O) ||
+	    (reg >= WM8350_GPIO_FUNCTION_SELECT_1 &&
+	     reg <= WM8350_GPIO_FUNCTION_SELECT_4) ||
+	    (reg >= WM8350_BATTERY_CHARGER_CONTROL_1 &&
+	     reg <= WM8350_BATTERY_CHARGER_CONTROL_3))
+		return 1;
+	return 0;
+}
+
+static int wm8350_write(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *src)
+{
+	int i;
+	int end = reg + num_regs;
+	int bytes = num_regs * 2;
+
+	if (wm8350->write_dev == NULL)
+		return -ENODEV;
+
+	if ((reg + num_regs - 1) > WM8350_MAX_REGISTER) {
+		dev_err(wm8350->dev, "invalid reg %x\n",
+			reg + num_regs - 1);
+		return -EINVAL;
+	}
+
+	/* it's generally not a good idea to write to RO or locked registers */
+	for (i = reg; i < end; i++) {
+		if (!wm8350_reg_io_map[i].writable) {
+			dev_err(wm8350->dev,
+				"attempted write to read only reg R%d\n", i);
+			return -EINVAL;
+		}
+
+		if (is_reg_locked(wm8350, i)) {
+			dev_err(wm8350->dev,
+			       "attempted write to locked reg R%d\n", i);
+			return -EINVAL;
+		}
+
+		src[i - reg] &= wm8350_reg_io_map[i].writable;
+
+		wm8350->reg_cache[i] =
+			(wm8350->reg_cache[i] & ~wm8350_reg_io_map[i].writable)
+			| src[i - reg];
+
+		src[i - reg] = cpu_to_be16(src[i - reg]);
+	}
+
+	/* Actually write it out */
+	return wm8350->write_dev(wm8350, reg, bytes, (char *)src);
+}
+
+/*
+ * Safe read, modify, write methods
+ */
+int wm8350_clear_bits(struct wm8350 *wm8350, u16 reg, u16 mask)
+{
+	u16 data;
+	int err;
+
+	mutex_lock(&io_mutex);
+	err = wm8350_read(wm8350, reg, 1, &data);
+	if (err) {
+		dev_err(wm8350->dev, "read from reg R%d failed\n", reg);
+		goto out;
+	}
+
+	data &= ~mask;
+	err = wm8350_write(wm8350, reg, 1, &data);
+	if (err)
+		dev_err(wm8350->dev, "write to reg R%d failed\n", reg);
+out:
+	mutex_unlock(&io_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(wm8350_clear_bits);
+
+int wm8350_set_bits(struct wm8350 *wm8350, u16 reg, u16 mask)
+{
+	u16 data;
+	int err;
+
+	mutex_lock(&io_mutex);
+	err = wm8350_read(wm8350, reg, 1, &data);
+	if (err) {
+		dev_err(wm8350->dev, "read from reg R%d failed\n", reg);
+		goto out;
+	}
+
+	data |= mask;
+	err = wm8350_write(wm8350, reg, 1, &data);
+	if (err)
+		dev_err(wm8350->dev, "write to reg R%d failed\n", reg);
+out:
+	mutex_unlock(&io_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(wm8350_set_bits);
+
+u16 wm8350_reg_read(struct wm8350 *wm8350, int reg)
+{
+	u16 data;
+	int err;
+
+	mutex_lock(&io_mutex);
+	err = wm8350_read(wm8350, reg, 1, &data);
+	if (err)
+		dev_err(wm8350->dev, "read from reg R%d failed\n", reg);
+
+	mutex_unlock(&io_mutex);
+	return data;
+}
+EXPORT_SYMBOL_GPL(wm8350_reg_read);
+
+int wm8350_reg_write(struct wm8350 *wm8350, int reg, u16 val)
+{
+	int ret;
+	u16 data = val;
+
+	mutex_lock(&io_mutex);
+	ret = wm8350_write(wm8350, reg, 1, &data);
+	if (ret)
+		dev_err(wm8350->dev, "write to reg R%d failed\n", reg);
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8350_reg_write);
+
+int wm8350_block_read(struct wm8350 *wm8350, int start_reg, int regs,
+		      u16 *dest)
+{
+	int err = 0;
+
+	mutex_lock(&io_mutex);
+	err = wm8350_read(wm8350, start_reg, regs, dest);
+	if (err)
+		dev_err(wm8350->dev, "block read starting from R%d failed\n",
+			start_reg);
+	mutex_unlock(&io_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(wm8350_block_read);
+
+int wm8350_block_write(struct wm8350 *wm8350, int start_reg, int regs,
+		       u16 *src)
+{
+	int ret = 0;
+
+	mutex_lock(&io_mutex);
+	ret = wm8350_write(wm8350, start_reg, regs, src);
+	if (ret)
+		dev_err(wm8350->dev, "block write starting at R%d failed\n",
+			start_reg);
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8350_block_write);
+
+int wm8350_reg_lock(struct wm8350 *wm8350)
+{
+	u16 key = WM8350_LOCK_KEY;
+	int ret;
+
+	ldbg(__func__);
+	mutex_lock(&io_mutex);
+	ret = wm8350_write(wm8350, WM8350_SECURITY, 1, &key);
+	if (ret)
+		dev_err(wm8350->dev, "lock failed\n");
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8350_reg_lock);
+
+int wm8350_reg_unlock(struct wm8350 *wm8350)
+{
+	u16 key = WM8350_UNLOCK_KEY;
+	int ret;
+
+	ldbg(__func__);
+	mutex_lock(&io_mutex);
+	ret = wm8350_write(wm8350, WM8350_SECURITY, 1, &key);
+	if (ret)
+		dev_err(wm8350->dev, "unlock failed\n");
+	mutex_unlock(&io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8350_reg_unlock);
+
+/*
+ * Cache is always host endian.
+ */
+static int wm8350_create_cache(struct wm8350 *wm8350, int mode)
+{
+	int i, ret = 0;
+	u16 value;
+	const u16 *reg_map;
+
+	switch (mode) {
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_0
+	case 0:
+		reg_map = wm8350_mode0_defaults;
+		break;
+#endif
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_1
+	case 1:
+		reg_map = wm8350_mode1_defaults;
+		break;
+#endif
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_2
+	case 2:
+		reg_map = wm8350_mode2_defaults;
+		break;
+#endif
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_3
+	case 3:
+		reg_map = wm8350_mode3_defaults;
+		break;
+#endif
+	default:
+		dev_err(wm8350->dev, "Configuration mode %d not supported\n",
+			mode);
+		return -EINVAL;
+	}
+
+	wm8350->reg_cache =
+	    kzalloc(sizeof(u16) * (WM8350_MAX_REGISTER + 1), GFP_KERNEL);
+	if (wm8350->reg_cache == NULL)
+		return -ENOMEM;
+
+	/* Read the initial cache state back from the device - this is
+	 * a PMIC so the device many not be in a virgin state and we
+	 * can't rely on the silicon values.
+	 */
+	for (i = 0; i < WM8350_MAX_REGISTER; i++) {
+		/* audio register range */
+		if (wm8350_reg_io_map[i].readable &&
+		    (i < WM8350_CLOCK_CONTROL_1 || i > WM8350_AIF_TEST)) {
+			ret = wm8350->read_dev(wm8350, i, 2, (char *)&value);
+			if (ret < 0) {
+				dev_err(wm8350->dev,
+				       "failed to read initial cache value\n");
+				goto out;
+			}
+			value = be16_to_cpu(value);
+			value &= wm8350_reg_io_map[i].readable;
+			wm8350->reg_cache[i] = value;
+		} else
+			wm8350->reg_cache[i] = reg_map[i];
+	}
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8350_create_cache);
+
+int wm8350_device_init(struct wm8350 *wm8350)
+{
+	int ret = -EINVAL;
+	u16 id1, id2, mask, mode;
+
+	/* get WM8350 revision and config mode */
+	wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
+	wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
+
+	id1 = be16_to_cpu(id1);
+	id2 = be16_to_cpu(id2);
+
+	if (id1 == 0x0)
+		dev_info(wm8350->dev, "Found Rev C device\n");
+	else if (id1 == 0x6143) {
+		switch ((id2 & WM8350_CHIP_REV_MASK) >> 12) {
+		case WM8350_REV_E:
+			dev_info(wm8350->dev, "Found Rev E device\n");
+			wm8350->rev = WM8350_REV_E;
+			break;
+		case WM8350_REV_F:
+			dev_info(wm8350->dev, "Found Rev F device\n");
+			wm8350->rev = WM8350_REV_F;
+			break;
+		case WM8350_REV_G:
+			dev_info(wm8350->dev, "Found Rev G device\n");
+			wm8350->rev = WM8350_REV_G;
+			break;
+		default:
+			/* For safety we refuse to run on unknown hardware */
+			dev_info(wm8350->dev, "Found unknown rev\n");
+			ret = -ENODEV;
+			goto err;
+		}
+	} else {
+		dev_info(wm8350->dev, "Device with ID %x is not a WM8350\n",
+			 id1);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	mode = id2 & WM8350_CONF_STS_MASK >> 10;
+	mask = id2 & WM8350_CUST_ID_MASK;
+	dev_info(wm8350->dev, "Config mode %d, ROM mask %d\n", mode, mask);
+
+	ret = wm8350_create_cache(wm8350, mode);
+	if (ret < 0) {
+		printk(KERN_ERR "wm8350: failed to create register cache\n");
+		return ret;
+	}
+
+	return 0;
+
+err:
+	kfree(wm8350->reg_cache);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8350_device_init);
+
+void wm8350_device_exit(struct wm8350 *wm8350)
+{
+	kfree(wm8350->reg_cache);
+}
+EXPORT_SYMBOL_GPL(wm8350_device_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
new file mode 100644
index 0000000..b062cc1
--- /dev/null
+++ b/drivers/mfd/wm8350-regmap.c
@@ -0,0 +1,1323 @@
+/*
+ * wm8350-regmap.c  --  Wolfson Microelectronics WM8350 register map
+ *
+ * This file splits out the tables describing the defaults and access
+ * status of the WM8350 registers since they are rather large.
+ *
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/mfd/wm8350/core.h>
+
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_0
+const u16 wm8350_mode0_defaults[] = {
+	0x17FF,     /* R0   - Reset/ID */
+	0x1000,     /* R1   - ID */
+	0x0000,     /* R2 */
+	0x1002,     /* R3   - System Control 1 */
+	0x0004,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27  - Power Up Interrupt Status */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35  - Power Up Interrupt Status Mask */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3B00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - LOUT1 Volume */
+	0x00E4,     /* R105 - ROUT1 Volume */
+	0x00E4,     /* R106 - LOUT2 Volume */
+	0x02E4,     /* R107 - ROUT2 Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 - AIF Test */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0000,     /* R129 - GPIO Pin pull up Control */
+	0x03FC,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x0FFC,     /* R134 - GPIO Configuration (i/o) */
+	0x0FFC,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x0013,     /* R140 - GPIO Function Select 1 */
+	0x0000,     /* R141 - GPIO Function Select 2 */
+	0x0000,     /* R142 - GPIO Function Select 3 */
+	0x0003,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 - Current Sink Driver B */
+	0x0000,     /* R175 - CSB Flash control */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x002D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x000E,     /* R180 - DCDC1 Control */
+	0x0000,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x0000,     /* R186 - DCDC3 Control */
+	0x0000,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x0000,     /* R189 - DCDC4 Control */
+	0x0000,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 - DCDC5 Control */
+	0x0000,     /* R193 - DCDC5 Timeouts */
+	0x0000,     /* R194 */
+	0x0000,     /* R195 - DCDC6 Control */
+	0x0000,     /* R196 - DCDC6 Timeouts */
+	0x0006,     /* R197 - DCDC6 Low Power */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x001C,     /* R200 - LDO1 Control */
+	0x0000,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x001B,     /* R203 - LDO2 Control */
+	0x0000,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x001B,     /* R206 - LDO3 Control */
+	0x0000,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x001B,     /* R209 - LDO4 Control */
+	0x0000,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 */
+	0x4000,     /* R220 - RAM BIST 1 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 */
+	0x0000,     /* R227 */
+	0x0000,     /* R228 */
+	0x0000,     /* R229 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 */
+	0x0000,     /* R234 */
+	0x0000,     /* R235 */
+	0x0000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0000,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0000,     /* R243 */
+	0x0000,     /* R244 */
+	0x0000,     /* R245 */
+	0x0000,     /* R246 */
+	0x0000,     /* R247 */
+	0x0000,     /* R248 */
+	0x0000,     /* R249 */
+	0x0000,     /* R250 */
+	0x0000,     /* R251 */
+	0x0000,     /* R252 */
+	0x0000,     /* R253 */
+	0x0000,     /* R254 */
+	0x0000,     /* R255 */
+};
+#endif
+
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_1
+const u16 wm8350_mode1_defaults[] = {
+	0x17FF,     /* R0   - Reset/ID */
+	0x1000,     /* R1   - ID */
+	0x0000,     /* R2 */
+	0x1002,     /* R3   - System Control 1 */
+	0x0014,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27  - Power Up Interrupt Status */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35  - Power Up Interrupt Status Mask */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3B00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - LOUT1 Volume */
+	0x00E4,     /* R105 - ROUT1 Volume */
+	0x00E4,     /* R106 - LOUT2 Volume */
+	0x02E4,     /* R107 - ROUT2 Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 - AIF Test */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0000,     /* R129 - GPIO Pin pull up Control */
+	0x03FC,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x00FB,     /* R134 - GPIO Configuration (i/o) */
+	0x04FE,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x0312,     /* R140 - GPIO Function Select 1 */
+	0x1003,     /* R141 - GPIO Function Select 2 */
+	0x1331,     /* R142 - GPIO Function Select 3 */
+	0x0003,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 - Current Sink Driver B */
+	0x0000,     /* R175 - CSB Flash control */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x002D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x0062,     /* R180 - DCDC1 Control */
+	0x0400,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x0026,     /* R186 - DCDC3 Control */
+	0x0400,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x0062,     /* R189 - DCDC4 Control */
+	0x0400,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 - DCDC5 Control */
+	0x0000,     /* R193 - DCDC5 Timeouts */
+	0x0000,     /* R194 */
+	0x0026,     /* R195 - DCDC6 Control */
+	0x0800,     /* R196 - DCDC6 Timeouts */
+	0x0006,     /* R197 - DCDC6 Low Power */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x0006,     /* R200 - LDO1 Control */
+	0x0400,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x0006,     /* R203 - LDO2 Control */
+	0x0400,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x001B,     /* R206 - LDO3 Control */
+	0x0000,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x001B,     /* R209 - LDO4 Control */
+	0x0000,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 */
+	0x4000,     /* R220 - RAM BIST 1 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 */
+	0x0000,     /* R227 */
+	0x0000,     /* R228 */
+	0x0000,     /* R229 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 */
+	0x0000,     /* R234 */
+	0x0000,     /* R235 */
+	0x0000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0000,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0000,     /* R243 */
+	0x0000,     /* R244 */
+	0x0000,     /* R245 */
+	0x0000,     /* R246 */
+	0x0000,     /* R247 */
+	0x0000,     /* R248 */
+	0x0000,     /* R249 */
+	0x0000,     /* R250 */
+	0x0000,     /* R251 */
+	0x0000,     /* R252 */
+	0x0000,     /* R253 */
+	0x0000,     /* R254 */
+	0x0000,     /* R255 */
+};
+#endif
+
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_2
+const u16 wm8350_mode2_defaults[] = {
+	0x17FF,     /* R0   - Reset/ID */
+	0x1000,     /* R1   - ID */
+	0x0000,     /* R2 */
+	0x1002,     /* R3   - System Control 1 */
+	0x0014,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27  - Power Up Interrupt Status */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35  - Power Up Interrupt Status Mask */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3B00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - LOUT1 Volume */
+	0x00E4,     /* R105 - ROUT1 Volume */
+	0x00E4,     /* R106 - LOUT2 Volume */
+	0x02E4,     /* R107 - ROUT2 Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 - AIF Test */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0000,     /* R129 - GPIO Pin pull up Control */
+	0x03FC,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x08FB,     /* R134 - GPIO Configuration (i/o) */
+	0x0CFE,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x0312,     /* R140 - GPIO Function Select 1 */
+	0x0003,     /* R141 - GPIO Function Select 2 */
+	0x2331,     /* R142 - GPIO Function Select 3 */
+	0x0003,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 - Current Sink Driver B */
+	0x0000,     /* R175 - CSB Flash control */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x002D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x000E,     /* R180 - DCDC1 Control */
+	0x0400,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x002E,     /* R186 - DCDC3 Control */
+	0x0800,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x000E,     /* R189 - DCDC4 Control */
+	0x0800,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 - DCDC5 Control */
+	0x0000,     /* R193 - DCDC5 Timeouts */
+	0x0000,     /* R194 */
+	0x0026,     /* R195 - DCDC6 Control */
+	0x0C00,     /* R196 - DCDC6 Timeouts */
+	0x0006,     /* R197 - DCDC6 Low Power */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x001A,     /* R200 - LDO1 Control */
+	0x0800,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x0010,     /* R203 - LDO2 Control */
+	0x0800,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x000A,     /* R206 - LDO3 Control */
+	0x0C00,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x001A,     /* R209 - LDO4 Control */
+	0x0800,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 */
+	0x4000,     /* R220 - RAM BIST 1 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 */
+	0x0000,     /* R227 */
+	0x0000,     /* R228 */
+	0x0000,     /* R229 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 */
+	0x0000,     /* R234 */
+	0x0000,     /* R235 */
+	0x0000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0000,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0000,     /* R243 */
+	0x0000,     /* R244 */
+	0x0000,     /* R245 */
+	0x0000,     /* R246 */
+	0x0000,     /* R247 */
+	0x0000,     /* R248 */
+	0x0000,     /* R249 */
+	0x0000,     /* R250 */
+	0x0000,     /* R251 */
+	0x0000,     /* R252 */
+	0x0000,     /* R253 */
+	0x0000,     /* R254 */
+	0x0000,     /* R255 */
+};
+#endif
+
+#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_3
+const u16 wm8350_mode3_defaults[] = {
+	0x17FF,     /* R0   - Reset/ID */
+	0x1000,     /* R1   - ID */
+	0x0000,     /* R2 */
+	0x1000,     /* R3   - System Control 1 */
+	0x0004,     /* R4   - System Control 2 */
+	0x0000,     /* R5   - System Hibernate */
+	0x8A00,     /* R6   - Interface Control */
+	0x0000,     /* R7 */
+	0x8000,     /* R8   - Power mgmt (1) */
+	0x0000,     /* R9   - Power mgmt (2) */
+	0x0000,     /* R10  - Power mgmt (3) */
+	0x2000,     /* R11  - Power mgmt (4) */
+	0x0E00,     /* R12  - Power mgmt (5) */
+	0x0000,     /* R13  - Power mgmt (6) */
+	0x0000,     /* R14  - Power mgmt (7) */
+	0x0000,     /* R15 */
+	0x0000,     /* R16  - RTC Seconds/Minutes */
+	0x0100,     /* R17  - RTC Hours/Day */
+	0x0101,     /* R18  - RTC Date/Month */
+	0x1400,     /* R19  - RTC Year */
+	0x0000,     /* R20  - Alarm Seconds/Minutes */
+	0x0000,     /* R21  - Alarm Hours/Day */
+	0x0000,     /* R22  - Alarm Date/Month */
+	0x0320,     /* R23  - RTC Time Control */
+	0x0000,     /* R24  - System Interrupts */
+	0x0000,     /* R25  - Interrupt Status 1 */
+	0x0000,     /* R26  - Interrupt Status 2 */
+	0x0000,     /* R27  - Power Up Interrupt Status */
+	0x0000,     /* R28  - Under Voltage Interrupt status */
+	0x0000,     /* R29  - Over Current Interrupt status */
+	0x0000,     /* R30  - GPIO Interrupt Status */
+	0x0000,     /* R31  - Comparator Interrupt Status */
+	0x3FFF,     /* R32  - System Interrupts Mask */
+	0x0000,     /* R33  - Interrupt Status 1 Mask */
+	0x0000,     /* R34  - Interrupt Status 2 Mask */
+	0x0000,     /* R35  - Power Up Interrupt Status Mask */
+	0x0000,     /* R36  - Under Voltage Interrupt status Mask */
+	0x0000,     /* R37  - Over Current Interrupt status Mask */
+	0x0000,     /* R38  - GPIO Interrupt Status Mask */
+	0x0000,     /* R39  - Comparator Interrupt Status Mask */
+	0x0040,     /* R40  - Clock Control 1 */
+	0x0000,     /* R41  - Clock Control 2 */
+	0x3B00,     /* R42  - FLL Control 1 */
+	0x7086,     /* R43  - FLL Control 2 */
+	0xC226,     /* R44  - FLL Control 3 */
+	0x0000,     /* R45  - FLL Control 4 */
+	0x0000,     /* R46 */
+	0x0000,     /* R47 */
+	0x0000,     /* R48  - DAC Control */
+	0x0000,     /* R49 */
+	0x00C0,     /* R50  - DAC Digital Volume L */
+	0x00C0,     /* R51  - DAC Digital Volume R */
+	0x0000,     /* R52 */
+	0x0040,     /* R53  - DAC LR Rate */
+	0x0000,     /* R54  - DAC Clock Control */
+	0x0000,     /* R55 */
+	0x0000,     /* R56 */
+	0x0000,     /* R57 */
+	0x4000,     /* R58  - DAC Mute */
+	0x0000,     /* R59  - DAC Mute Volume */
+	0x0000,     /* R60  - DAC Side */
+	0x0000,     /* R61 */
+	0x0000,     /* R62 */
+	0x0000,     /* R63 */
+	0x8000,     /* R64  - ADC Control */
+	0x0000,     /* R65 */
+	0x00C0,     /* R66  - ADC Digital Volume L */
+	0x00C0,     /* R67  - ADC Digital Volume R */
+	0x0000,     /* R68  - ADC Divider */
+	0x0000,     /* R69 */
+	0x0040,     /* R70  - ADC LR Rate */
+	0x0000,     /* R71 */
+	0x0303,     /* R72  - Input Control */
+	0x0000,     /* R73  - IN3 Input Control */
+	0x0000,     /* R74  - Mic Bias Control */
+	0x0000,     /* R75 */
+	0x0000,     /* R76  - Output Control */
+	0x0000,     /* R77  - Jack Detect */
+	0x0000,     /* R78  - Anti Pop Control */
+	0x0000,     /* R79 */
+	0x0040,     /* R80  - Left Input Volume */
+	0x0040,     /* R81  - Right Input Volume */
+	0x0000,     /* R82 */
+	0x0000,     /* R83 */
+	0x0000,     /* R84 */
+	0x0000,     /* R85 */
+	0x0000,     /* R86 */
+	0x0000,     /* R87 */
+	0x0800,     /* R88  - Left Mixer Control */
+	0x1000,     /* R89  - Right Mixer Control */
+	0x0000,     /* R90 */
+	0x0000,     /* R91 */
+	0x0000,     /* R92  - OUT3 Mixer Control */
+	0x0000,     /* R93  - OUT4 Mixer Control */
+	0x0000,     /* R94 */
+	0x0000,     /* R95 */
+	0x0000,     /* R96  - Output Left Mixer Volume */
+	0x0000,     /* R97  - Output Right Mixer Volume */
+	0x0000,     /* R98  - Input Mixer Volume L */
+	0x0000,     /* R99  - Input Mixer Volume R */
+	0x0000,     /* R100 - Input Mixer Volume */
+	0x0000,     /* R101 */
+	0x0000,     /* R102 */
+	0x0000,     /* R103 */
+	0x00E4,     /* R104 - LOUT1 Volume */
+	0x00E4,     /* R105 - ROUT1 Volume */
+	0x00E4,     /* R106 - LOUT2 Volume */
+	0x02E4,     /* R107 - ROUT2 Volume */
+	0x0000,     /* R108 */
+	0x0000,     /* R109 */
+	0x0000,     /* R110 */
+	0x0000,     /* R111 - BEEP Volume */
+	0x0A00,     /* R112 - AI Formating */
+	0x0000,     /* R113 - ADC DAC COMP */
+	0x0020,     /* R114 - AI ADC Control */
+	0x0020,     /* R115 - AI DAC Control */
+	0x0000,     /* R116 - AIF Test */
+	0x0000,     /* R117 */
+	0x0000,     /* R118 */
+	0x0000,     /* R119 */
+	0x0000,     /* R120 */
+	0x0000,     /* R121 */
+	0x0000,     /* R122 */
+	0x0000,     /* R123 */
+	0x0000,     /* R124 */
+	0x0000,     /* R125 */
+	0x0000,     /* R126 */
+	0x0000,     /* R127 */
+	0x1FFF,     /* R128 - GPIO Debounce */
+	0x0000,     /* R129 - GPIO Pin pull up Control */
+	0x03FC,     /* R130 - GPIO Pull down Control */
+	0x0000,     /* R131 - GPIO Interrupt Mode */
+	0x0000,     /* R132 */
+	0x0000,     /* R133 - GPIO Control */
+	0x0A7B,     /* R134 - GPIO Configuration (i/o) */
+	0x06FE,     /* R135 - GPIO Pin Polarity / Type */
+	0x0000,     /* R136 */
+	0x0000,     /* R137 */
+	0x0000,     /* R138 */
+	0x0000,     /* R139 */
+	0x1312,     /* R140 - GPIO Function Select 1 */
+	0x1030,     /* R141 - GPIO Function Select 2 */
+	0x2231,     /* R142 - GPIO Function Select 3 */
+	0x0003,     /* R143 - GPIO Function Select 4 */
+	0x0000,     /* R144 - Digitiser Control (1) */
+	0x0002,     /* R145 - Digitiser Control (2) */
+	0x0000,     /* R146 */
+	0x0000,     /* R147 */
+	0x0000,     /* R148 */
+	0x0000,     /* R149 */
+	0x0000,     /* R150 */
+	0x0000,     /* R151 */
+	0x7000,     /* R152 - AUX1 Readback */
+	0x7000,     /* R153 - AUX2 Readback */
+	0x7000,     /* R154 - AUX3 Readback */
+	0x7000,     /* R155 - AUX4 Readback */
+	0x0000,     /* R156 - USB Voltage Readback */
+	0x0000,     /* R157 - LINE Voltage Readback */
+	0x0000,     /* R158 - BATT Voltage Readback */
+	0x0000,     /* R159 - Chip Temp Readback */
+	0x0000,     /* R160 */
+	0x0000,     /* R161 */
+	0x0000,     /* R162 */
+	0x0000,     /* R163 - Generic Comparator Control */
+	0x0000,     /* R164 - Generic comparator 1 */
+	0x0000,     /* R165 - Generic comparator 2 */
+	0x0000,     /* R166 - Generic comparator 3 */
+	0x0000,     /* R167 - Generic comparator 4 */
+	0xA00F,     /* R168 - Battery Charger Control 1 */
+	0x0B06,     /* R169 - Battery Charger Control 2 */
+	0x0000,     /* R170 - Battery Charger Control 3 */
+	0x0000,     /* R171 */
+	0x0000,     /* R172 - Current Sink Driver A */
+	0x0000,     /* R173 - CSA Flash control */
+	0x0000,     /* R174 - Current Sink Driver B */
+	0x0000,     /* R175 - CSB Flash control */
+	0x0000,     /* R176 - DCDC/LDO requested */
+	0x002D,     /* R177 - DCDC Active options */
+	0x0000,     /* R178 - DCDC Sleep options */
+	0x0025,     /* R179 - Power-check comparator */
+	0x000E,     /* R180 - DCDC1 Control */
+	0x0400,     /* R181 - DCDC1 Timeouts */
+	0x1006,     /* R182 - DCDC1 Low Power */
+	0x0018,     /* R183 - DCDC2 Control */
+	0x0000,     /* R184 - DCDC2 Timeouts */
+	0x0000,     /* R185 */
+	0x000E,     /* R186 - DCDC3 Control */
+	0x0400,     /* R187 - DCDC3 Timeouts */
+	0x0006,     /* R188 - DCDC3 Low Power */
+	0x0026,     /* R189 - DCDC4 Control */
+	0x0400,     /* R190 - DCDC4 Timeouts */
+	0x0006,     /* R191 - DCDC4 Low Power */
+	0x0008,     /* R192 - DCDC5 Control */
+	0x0000,     /* R193 - DCDC5 Timeouts */
+	0x0000,     /* R194 */
+	0x0026,     /* R195 - DCDC6 Control */
+	0x0400,     /* R196 - DCDC6 Timeouts */
+	0x0006,     /* R197 - DCDC6 Low Power */
+	0x0000,     /* R198 */
+	0x0003,     /* R199 - Limit Switch Control */
+	0x001C,     /* R200 - LDO1 Control */
+	0x0000,     /* R201 - LDO1 Timeouts */
+	0x001C,     /* R202 - LDO1 Low Power */
+	0x001C,     /* R203 - LDO2 Control */
+	0x0400,     /* R204 - LDO2 Timeouts */
+	0x001C,     /* R205 - LDO2 Low Power */
+	0x001C,     /* R206 - LDO3 Control */
+	0x0400,     /* R207 - LDO3 Timeouts */
+	0x001C,     /* R208 - LDO3 Low Power */
+	0x001F,     /* R209 - LDO4 Control */
+	0x0400,     /* R210 - LDO4 Timeouts */
+	0x001C,     /* R211 - LDO4 Low Power */
+	0x0000,     /* R212 */
+	0x0000,     /* R213 */
+	0x0000,     /* R214 */
+	0x0000,     /* R215 - VCC_FAULT Masks */
+	0x001F,     /* R216 - Main Bandgap Control */
+	0x0000,     /* R217 - OSC Control */
+	0x9000,     /* R218 - RTC Tick Control */
+	0x0000,     /* R219 */
+	0x4000,     /* R220 - RAM BIST 1 */
+	0x0000,     /* R221 */
+	0x0000,     /* R222 */
+	0x0000,     /* R223 */
+	0x0000,     /* R224 */
+	0x0000,     /* R225 - DCDC/LDO status */
+	0x0000,     /* R226 */
+	0x0000,     /* R227 */
+	0x0000,     /* R228 */
+	0x0000,     /* R229 */
+	0xE000,     /* R230 - GPIO Pin Status */
+	0x0000,     /* R231 */
+	0x0000,     /* R232 */
+	0x0000,     /* R233 */
+	0x0000,     /* R234 */
+	0x0000,     /* R235 */
+	0x0000,     /* R236 */
+	0x0000,     /* R237 */
+	0x0000,     /* R238 */
+	0x0000,     /* R239 */
+	0x0000,     /* R240 */
+	0x0000,     /* R241 */
+	0x0000,     /* R242 */
+	0x0000,     /* R243 */
+	0x0000,     /* R244 */
+	0x0000,     /* R245 */
+	0x0000,     /* R246 */
+	0x0000,     /* R247 */
+	0x0000,     /* R248 */
+	0x0000,     /* R249 */
+	0x0000,     /* R250 */
+	0x0000,     /* R251 */
+	0x0000,     /* R252 */
+	0x0000,     /* R253 */
+	0x0000,     /* R254 */
+	0x0000,     /* R255 */
+};
+#endif
+
+/*
+ * Access masks.
+ */
+
+const struct wm8350_reg_access wm8350_reg_io_map[] = {
+	/*  read    write volatile */
+	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R0   - Reset/ID */
+	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
+	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
+	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
+	{ 0xFCF7, 0xFCF7, 0xF800 }, /* R4   - System Control 2 */
+	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
+	{ 0xFB0E, 0xFB0E, 0x0000 }, /* R6   - Interface Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R7 */
+	{ 0xE537, 0xE537, 0xFFFF }, /* R8   - Power mgmt (1) */
+	{ 0x0FF3, 0x0FF3, 0xFFFF }, /* R9   - Power mgmt (2) */
+	{ 0x008F, 0x008F, 0xFFFF }, /* R10  - Power mgmt (3) */
+	{ 0x6D3C, 0x6D3C, 0xFFFF }, /* R11  - Power mgmt (4) */
+	{ 0x1F8F, 0x1F8F, 0xFFFF }, /* R12  - Power mgmt (5) */
+	{ 0x8F3F, 0x8F3F, 0xFFFF }, /* R13  - Power mgmt (6) */
+	{ 0x0003, 0x0003, 0xFFFF }, /* R14  - Power mgmt (7) */
+	{ 0x0000, 0x0000, 0x0000 }, /* R15 */
+	{ 0x7F7F, 0x7F7F, 0xFFFF }, /* R16  - RTC Seconds/Minutes */
+	{ 0x073F, 0x073F, 0xFFFF }, /* R17  - RTC Hours/Day */
+	{ 0x1F3F, 0x1F3F, 0xFFFF }, /* R18  - RTC Date/Month */
+	{ 0x3FFF, 0x00FF, 0xFFFF }, /* R19  - RTC Year */
+	{ 0x7F7F, 0x7F7F, 0x0000 }, /* R20  - Alarm Seconds/Minutes */
+	{ 0x0F3F, 0x0F3F, 0x0000 }, /* R21  - Alarm Hours/Day */
+	{ 0x1F3F, 0x1F3F, 0x0000 }, /* R22  - Alarm Date/Month */
+	{ 0xEF7F, 0xEA7F, 0xFFFF }, /* R23  - RTC Time Control */
+	{ 0x3BFF, 0x0000, 0xFFFF }, /* R24  - System Interrupts */
+	{ 0xFEE7, 0x0000, 0xFFFF }, /* R25  - Interrupt Status 1 */
+	{ 0x35FF, 0x0000, 0xFFFF }, /* R26  - Interrupt Status 2 */
+	{ 0x0F3F, 0x0000, 0xFFFF }, /* R27  - Power Up Interrupt Status */
+	{ 0x0F3F, 0x0000, 0xFFFF }, /* R28  - Under Voltage Interrupt status */
+	{ 0x8000, 0x0000, 0xFFFF }, /* R29  - Over Current Interrupt status */
+	{ 0x1FFF, 0x0000, 0xFFFF }, /* R30  - GPIO Interrupt Status */
+	{ 0xEF7F, 0x0000, 0xFFFF }, /* R31  - Comparator Interrupt Status */
+	{ 0x3FFF, 0x3FFF, 0x0000 }, /* R32  - System Interrupts Mask */
+	{ 0xFEE7, 0xFEE7, 0x0000 }, /* R33  - Interrupt Status 1 Mask */
+	{ 0xF5FF, 0xF5FF, 0x0000 }, /* R34  - Interrupt Status 2 Mask */
+	{ 0x0F3F, 0x0F3F, 0x0000 }, /* R35  - Power Up Interrupt Status Mask */
+	{ 0x0F3F, 0x0F3F, 0x0000 }, /* R36  - Under Voltage Int status Mask */
+	{ 0x8000, 0x8000, 0x0000 }, /* R37  - Over Current Int status Mask */
+	{ 0x1FFF, 0x1FFF, 0x0000 }, /* R38  - GPIO Interrupt Status Mask */
+	{ 0xEF7F, 0xEF7F, 0x0000 }, /* R39  - Comparator IntStatus Mask */
+	{ 0xC9F7, 0xC9F7, 0xFFFF }, /* R40  - Clock Control 1 */
+	{ 0x8001, 0x8001, 0x0000 }, /* R41  - Clock Control 2 */
+	{ 0xFFF7, 0xFFF7, 0xFFFF }, /* R42  - FLL Control 1 */
+	{ 0xFBFF, 0xFBFF, 0x0000 }, /* R43  - FLL Control 2 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R44  - FLL Control 3 */
+	{ 0x0033, 0x0033, 0x0000 }, /* R45  - FLL Control 4 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R46 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R47 */
+	{ 0x3033, 0x3033, 0x0000 }, /* R48  - DAC Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R49 */
+	{ 0x81FF, 0x81FF, 0xFFFF }, /* R50  - DAC Digital Volume L */
+	{ 0x81FF, 0x81FF, 0xFFFF }, /* R51  - DAC Digital Volume R */
+	{ 0x0000, 0x0000, 0x0000 }, /* R52 */
+	{ 0x0FFF, 0x0FFF, 0xFFFF }, /* R53  - DAC LR Rate */
+	{ 0x0017, 0x0017, 0x0000 }, /* R54  - DAC Clock Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R55 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R56 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R57 */
+	{ 0x4000, 0x4000, 0x0000 }, /* R58  - DAC Mute */
+	{ 0x7000, 0x7000, 0x0000 }, /* R59  - DAC Mute Volume */
+	{ 0x3C00, 0x3C00, 0x0000 }, /* R60  - DAC Side */
+	{ 0x0000, 0x0000, 0x0000 }, /* R61 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R62 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R63 */
+	{ 0x8303, 0x8303, 0xFFFF }, /* R64  - ADC Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R65 */
+	{ 0x81FF, 0x81FF, 0xFFFF }, /* R66  - ADC Digital Volume L */
+	{ 0x81FF, 0x81FF, 0xFFFF }, /* R67  - ADC Digital Volume R */
+	{ 0x0FFF, 0x0FFF, 0x0000 }, /* R68  - ADC Divider */
+	{ 0x0000, 0x0000, 0x0000 }, /* R69 */
+	{ 0x0FFF, 0x0FFF, 0xFFFF }, /* R70  - ADC LR Rate */
+	{ 0x0000, 0x0000, 0x0000 }, /* R71 */
+	{ 0x0707, 0x0707, 0xFFFF }, /* R72  - Input Control */
+	{ 0xC0C0, 0xC0C0, 0xFFFF }, /* R73  - IN3 Input Control */
+	{ 0xC09F, 0xC09F, 0xFFFF }, /* R74  - Mic Bias Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R75 */
+	{ 0x0F15, 0x0F15, 0xFFFF }, /* R76  - Output Control */
+	{ 0xC000, 0xC000, 0xFFFF }, /* R77  - Jack Detect */
+	{ 0x03FF, 0x03FF, 0x0000 }, /* R78  - Anti Pop Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R79 */
+	{ 0xE1FC, 0xE1FC, 0x8000 }, /* R80  - Left Input Volume */
+	{ 0xE1FC, 0xE1FC, 0x8000 }, /* R81  - Right Input Volume */
+	{ 0x0000, 0x0000, 0x0000 }, /* R82 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R83 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R84 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R85 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R86 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R87 */
+	{ 0x9807, 0x9807, 0xFFFF }, /* R88  - Left Mixer Control */
+	{ 0x980B, 0x980B, 0xFFFF }, /* R89  - Right Mixer Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R90 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R91 */
+	{ 0x8909, 0x8909, 0xFFFF }, /* R92  - OUT3 Mixer Control */
+	{ 0x9E07, 0x9E07, 0xFFFF }, /* R93  - OUT4 Mixer Control */
+	{ 0x0000, 0x0000, 0x0000 }, /* R94 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R95 */
+	{ 0x0EEE, 0x0EEE, 0x0000 }, /* R96  - Output Left Mixer Volume */
+	{ 0xE0EE, 0xE0EE, 0x0000 }, /* R97  - Output Right Mixer Volume */
+	{ 0x0E0F, 0x0E0F, 0x0000 }, /* R98  - Input Mixer Volume L */
+	{ 0xE0E1, 0xE0E1, 0x0000 }, /* R99  - Input Mixer Volume R */
+	{ 0x800E, 0x800E, 0x0000 }, /* R100 - Input Mixer Volume */
+	{ 0x0000, 0x0000, 0x0000 }, /* R101 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R102 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R103 */
+	{ 0xE1FC, 0xE1FC, 0xFFFF }, /* R104 - LOUT1 Volume */
+	{ 0xE1FC, 0xE1FC, 0xFFFF }, /* R105 - ROUT1 Volume */
+	{ 0xE1FC, 0xE1FC, 0xFFFF }, /* R106 - LOUT2 Volume */
+	{ 0xE7FC, 0xE7FC, 0xFFFF }, /* R107 - ROUT2 Volume */
+	{ 0x0000, 0x0000, 0x0000 }, /* R108 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R109 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R110 */
+	{ 0x80E0, 0x80E0, 0xFFFF }, /* R111 - BEEP Volume */
+	{ 0xBF00, 0xBF00, 0x0000 }, /* R112 - AI Formating */
+	{ 0x00F1, 0x00F1, 0x0000 }, /* R113 - ADC DAC COMP */
+	{ 0x00F8, 0x00F8, 0x0000 }, /* R114 - AI ADC Control */
+	{ 0x40FB, 0x40FB, 0x0000 }, /* R115 - AI DAC Control */
+	{ 0x7C30, 0x7C30, 0x0000 }, /* R116 - AIF Test */
+	{ 0x0000, 0x0000, 0x0000 }, /* R117 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R118 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R119 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R120 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R121 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R122 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R123 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R124 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R125 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R126 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R127 */
+	{ 0x1FFF, 0x1FFF, 0x0000 }, /* R128 - GPIO Debounce */
+	{ 0x1FFF, 0x1FFF, 0x0000 }, /* R129 - GPIO Pin pull up Control */
+	{ 0x1FFF, 0x1FFF, 0x0000 }, /* R130 - GPIO Pull down Control */
+	{ 0x1FFF, 0x1FFF, 0x0000 }, /* R131 - GPIO Interrupt Mode */
+	{ 0x0000, 0x0000, 0x0000 }, /* R132 */
+	{ 0x00C0, 0x00C0, 0x0000 }, /* R133 - GPIO Control */
+	{ 0x1FFF, 0x1FFF, 0x0000 }, /* R134 - GPIO Configuration (i/o) */
+	{ 0x1FFF, 0x1FFF, 0x0000 }, /* R135 - GPIO Pin Polarity / Type */
+	{ 0x0000, 0x0000, 0x0000 }, /* R136 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R137 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R138 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R139 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R140 - GPIO Function Select 1 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R141 - GPIO Function Select 2 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R142 - GPIO Function Select 3 */
+	{ 0x000F, 0x000F, 0x0000 }, /* R143 - GPIO Function Select 4 */
+	{ 0xF0FF, 0xF0FF, 0xA000 }, /* R144 - Digitiser Control (1) */
+	{ 0x3707, 0x3707, 0x0000 }, /* R145 - Digitiser Control (2) */
+	{ 0x0000, 0x0000, 0x0000 }, /* R146 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R147 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R148 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R149 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R150 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R151 */
+	{ 0x7FFF, 0x7000, 0xFFFF }, /* R152 - AUX1 Readback */
+	{ 0x7FFF, 0x7000, 0xFFFF }, /* R153 - AUX2 Readback */
+	{ 0x7FFF, 0x7000, 0xFFFF }, /* R154 - AUX3 Readback */
+	{ 0x7FFF, 0x7000, 0xFFFF }, /* R155 - AUX4 Readback */
+	{ 0x0FFF, 0x0000, 0xFFFF }, /* R156 - USB Voltage Readback */
+	{ 0x0FFF, 0x0000, 0xFFFF }, /* R157 - LINE Voltage Readback */
+	{ 0x0FFF, 0x0000, 0xFFFF }, /* R158 - BATT Voltage Readback */
+	{ 0x0FFF, 0x0000, 0xFFFF }, /* R159 - Chip Temp Readback */
+	{ 0x0000, 0x0000, 0x0000 }, /* R160 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R161 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R162 */
+	{ 0x000F, 0x000F, 0x0000 }, /* R163 - Generic Comparator Control */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R164 - Generic comparator 1 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R165 - Generic comparator 2 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R166 - Generic comparator 3 */
+	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R167 - Generic comparator 4 */
+	{ 0xBFFF, 0xBFFF, 0x8000 }, /* R168 - Battery Charger Control 1 */
+	{ 0xFFFF, 0x4FFF, 0xB000 }, /* R169 - Battery Charger Control 2 */
+	{ 0x007F, 0x007F, 0x0000 }, /* R170 - Battery Charger Control 3 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R171 */
+	{ 0x903F, 0x903F, 0xFFFF }, /* R172 - Current Sink Driver A */
+	{ 0xE333, 0xE333, 0xFFFF }, /* R173 - CSA Flash control */
+	{ 0x903F, 0x903F, 0xFFFF }, /* R174 - Current Sink Driver B */
+	{ 0xE333, 0xE333, 0xFFFF }, /* R175 - CSB Flash control */
+	{ 0x8F3F, 0x8F3F, 0xFFFF }, /* R176 - DCDC/LDO requested */
+	{ 0x332D, 0x332D, 0x0000 }, /* R177 - DCDC Active options */
+	{ 0x002D, 0x002D, 0x0000 }, /* R178 - DCDC Sleep options */
+	{ 0x5177, 0x5177, 0x8000 }, /* R179 - Power-check comparator */
+	{ 0x047F, 0x047F, 0x0000 }, /* R180 - DCDC1 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R181 - DCDC1 Timeouts */
+	{ 0x737F, 0x737F, 0x0000 }, /* R182 - DCDC1 Low Power */
+	{ 0x535B, 0x535B, 0x0000 }, /* R183 - DCDC2 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R184 - DCDC2 Timeouts */
+	{ 0x0000, 0x0000, 0x0000 }, /* R185 */
+	{ 0x047F, 0x047F, 0x0000 }, /* R186 - DCDC3 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R187 - DCDC3 Timeouts */
+	{ 0x737F, 0x737F, 0x0000 }, /* R188 - DCDC3 Low Power */
+	{ 0x047F, 0x047F, 0x0000 }, /* R189 - DCDC4 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R190 - DCDC4 Timeouts */
+	{ 0x737F, 0x737F, 0x0000 }, /* R191 - DCDC4 Low Power */
+	{ 0x535B, 0x535B, 0x0000 }, /* R192 - DCDC5 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R193 - DCDC5 Timeouts */
+	{ 0x0000, 0x0000, 0x0000 }, /* R194 */
+	{ 0x047F, 0x047F, 0x0000 }, /* R195 - DCDC6 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R196 - DCDC6 Timeouts */
+	{ 0x737F, 0x737F, 0x0000 }, /* R197 - DCDC6 Low Power */
+	{ 0x0000, 0x0000, 0x0000 }, /* R198 */
+	{ 0xFFD3, 0xFFD3, 0x0000 }, /* R199 - Limit Switch Control */
+	{ 0x441F, 0x441F, 0x0000 }, /* R200 - LDO1 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R201 - LDO1 Timeouts */
+	{ 0x331F, 0x331F, 0x0000 }, /* R202 - LDO1 Low Power */
+	{ 0x441F, 0x441F, 0x0000 }, /* R203 - LDO2 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R204 - LDO2 Timeouts */
+	{ 0x331F, 0x331F, 0x0000 }, /* R205 - LDO2 Low Power */
+	{ 0x441F, 0x441F, 0x0000 }, /* R206 - LDO3 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R207 - LDO3 Timeouts */
+	{ 0x331F, 0x331F, 0x0000 }, /* R208 - LDO3 Low Power */
+	{ 0x441F, 0x441F, 0x0000 }, /* R209 - LDO4 Control */
+	{ 0xFFC0, 0xFFC0, 0x0000 }, /* R210 - LDO4 Timeouts */
+	{ 0x331F, 0x331F, 0x0000 }, /* R211 - LDO4 Low Power */
+	{ 0x0000, 0x0000, 0x0000 }, /* R212 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R213 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R214 */
+	{ 0x8F3F, 0x8F3F, 0x0000 }, /* R215 - VCC_FAULT Masks */
+	{ 0xFF3F, 0xE03F, 0x0000 }, /* R216 - Main Bandgap Control */
+	{ 0xEF2F, 0xE02F, 0x0000 }, /* R217 - OSC Control */
+	{ 0xF3FF, 0xB3FF, 0xc000 }, /* R218 - RTC Tick Control */
+	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R219 */
+	{ 0x09FF, 0x01FF, 0x0000 }, /* R220 - RAM BIST 1 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R221 */
+	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R222 */
+	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R223 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R224 */
+	{ 0x8F3F, 0x0000, 0xFFFF }, /* R225 - DCDC/LDO status */
+	{ 0x0000, 0x0000, 0x0000 }, /* R226 */
+	{ 0x0000, 0x0000, 0xFFFF }, /* R227 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R228 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R229 */
+	{ 0xFFFF, 0x1FFF, 0xFFFF }, /* R230 - GPIO Pin Status */
+	{ 0xFFFF, 0x1FFF, 0xFFFF }, /* R231 */
+	{ 0xFFFF, 0x1FFF, 0xFFFF }, /* R232 */
+	{ 0xFFFF, 0x1FFF, 0xFFFF }, /* R233 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R234 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R235 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R236 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R237 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R238 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R239 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R240 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R241 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R242 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R243 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R244 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R245 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R246 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R247 */
+	{ 0xFFFF, 0x0010, 0xFFFF }, /* R248 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R249 */
+	{ 0xFFFF, 0x0010, 0xFFFF }, /* R250 */
+	{ 0xFFFF, 0x0010, 0xFFFF }, /* R251 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R252 */
+	{ 0xFFFF, 0x0010, 0xFFFF }, /* R253 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R254 */
+	{ 0x0000, 0x0000, 0x0000 }, /* R255 */
+};
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
new file mode 100644
index 0000000..94778c1
--- /dev/null
+++ b/include/linux/mfd/wm8350/core.h
@@ -0,0 +1,585 @@
+/*
+ * core.h  --  Core Driver for Wolfson WM8350 PMIC
+ *
+ * Copyright 2007 Wolfson Microelectronics PLC
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_WM8350_CORE_H_
+#define __LINUX_MFD_WM8350_CORE_H_
+
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+
+/*
+ * Register values.
+ */
+#define WM8350_RESET_ID                         0x00
+#define WM8350_ID                               0x01
+#define WM8350_SYSTEM_CONTROL_1                 0x03
+#define WM8350_SYSTEM_CONTROL_2                 0x04
+#define WM8350_SYSTEM_HIBERNATE                 0x05
+#define WM8350_INTERFACE_CONTROL                0x06
+#define WM8350_POWER_MGMT_1                     0x08
+#define WM8350_POWER_MGMT_2                     0x09
+#define WM8350_POWER_MGMT_3                     0x0A
+#define WM8350_POWER_MGMT_4                     0x0B
+#define WM8350_POWER_MGMT_5                     0x0C
+#define WM8350_POWER_MGMT_6                     0x0D
+#define WM8350_POWER_MGMT_7                     0x0E
+
+#define WM8350_SYSTEM_INTERRUPTS                0x18
+#define WM8350_INT_STATUS_1                     0x19
+#define WM8350_INT_STATUS_2                     0x1A
+#define WM8350_POWER_UP_INT_STATUS              0x1B
+#define WM8350_UNDER_VOLTAGE_INT_STATUS         0x1C
+#define WM8350_OVER_CURRENT_INT_STATUS          0x1D
+#define WM8350_GPIO_INT_STATUS                  0x1E
+#define WM8350_COMPARATOR_INT_STATUS            0x1F
+#define WM8350_SYSTEM_INTERRUPTS_MASK           0x20
+#define WM8350_INT_STATUS_1_MASK                0x21
+#define WM8350_INT_STATUS_2_MASK                0x22
+#define WM8350_POWER_UP_INT_STATUS_MASK         0x23
+#define WM8350_UNDER_VOLTAGE_INT_STATUS_MASK    0x24
+#define WM8350_OVER_CURRENT_INT_STATUS_MASK     0x25
+#define WM8350_GPIO_INT_STATUS_MASK             0x26
+#define WM8350_COMPARATOR_INT_STATUS_MASK       0x27
+
+#define WM8350_MAX_REGISTER                     0xFF
+
+/*
+ * Field Definitions.
+ */
+
+/*
+ * R0 (0x00) - Reset/ID
+ */
+#define WM8350_SW_RESET_CHIP_ID_MASK            0xFFFF
+
+/*
+ * R1 (0x01) - ID
+ */
+#define WM8350_CHIP_REV_MASK                    0x7000
+#define WM8350_CONF_STS_MASK                    0x0C00
+#define WM8350_CUST_ID_MASK                     0x00FF
+
+/*
+ * R3 (0x03) - System Control 1
+ */
+#define WM8350_CHIP_ON                          0x8000
+#define WM8350_POWERCYCLE                       0x2000
+#define WM8350_VCC_FAULT_OV                     0x1000
+#define WM8350_REG_RSTB_TIME_MASK               0x0C00
+#define WM8350_BG_SLEEP                         0x0200
+#define WM8350_MEM_VALID                        0x0020
+#define WM8350_CHIP_SET_UP                      0x0010
+#define WM8350_ON_DEB_T                         0x0008
+#define WM8350_ON_POL                           0x0002
+#define WM8350_IRQ_POL                          0x0001
+
+/*
+ * R4 (0x04) - System Control 2
+ */
+#define WM8350_USB_SUSPEND_8MA                  0x8000
+#define WM8350_USB_SUSPEND                      0x4000
+#define WM8350_USB_MSTR                         0x2000
+#define WM8350_USB_MSTR_SRC                     0x1000
+#define WM8350_USB_500MA                        0x0800
+#define WM8350_USB_NOLIM                        0x0400
+
+/*
+ * R5 (0x05) - System Hibernate
+ */
+#define WM8350_HIBERNATE                        0x8000
+#define WM8350_WDOG_HIB_MODE                    0x0080
+#define WM8350_REG_HIB_STARTUP_SEQ              0x0040
+#define WM8350_REG_RESET_HIB_MODE               0x0020
+#define WM8350_RST_HIB_MODE                     0x0010
+#define WM8350_IRQ_HIB_MODE                     0x0008
+#define WM8350_MEMRST_HIB_MODE                  0x0004
+#define WM8350_PCCOMP_HIB_MODE                  0x0002
+#define WM8350_TEMPMON_HIB_MODE                 0x0001
+
+/*
+ * R6 (0x06) - Interface Control
+ */
+#define WM8350_USE_DEV_PINS                     0x8000
+#define WM8350_USE_DEV_PINS_MASK                0x8000
+#define WM8350_USE_DEV_PINS_SHIFT                   15
+#define WM8350_DEV_ADDR_MASK                    0x6000
+#define WM8350_DEV_ADDR_SHIFT                       13
+#define WM8350_CONFIG_DONE                      0x1000
+#define WM8350_CONFIG_DONE_MASK                 0x1000
+#define WM8350_CONFIG_DONE_SHIFT                    12
+#define WM8350_RECONFIG_AT_ON                   0x0800
+#define WM8350_RECONFIG_AT_ON_MASK              0x0800
+#define WM8350_RECONFIG_AT_ON_SHIFT                 11
+#define WM8350_AUTOINC                          0x0200
+#define WM8350_AUTOINC_MASK                     0x0200
+#define WM8350_AUTOINC_SHIFT                         9
+#define WM8350_ARA                              0x0100
+#define WM8350_ARA_MASK                         0x0100
+#define WM8350_ARA_SHIFT                             8
+#define WM8350_SPI_CFG                          0x0008
+#define WM8350_SPI_CFG_MASK                     0x0008
+#define WM8350_SPI_CFG_SHIFT                         3
+#define WM8350_SPI_4WIRE                        0x0004
+#define WM8350_SPI_4WIRE_MASK                   0x0004
+#define WM8350_SPI_4WIRE_SHIFT                       2
+#define WM8350_SPI_3WIRE                        0x0002
+#define WM8350_SPI_3WIRE_MASK                   0x0002
+#define WM8350_SPI_3WIRE_SHIFT                       1
+
+/* Bit values for R06 (0x06) */
+#define WM8350_USE_DEV_PINS_PRIMARY                  0
+#define WM8350_USE_DEV_PINS_DEV                      1
+
+#define WM8350_DEV_ADDR_34                           0
+#define WM8350_DEV_ADDR_36                           1
+#define WM8350_DEV_ADDR_3C                           2
+#define WM8350_DEV_ADDR_3E                           3
+
+#define WM8350_CONFIG_DONE_OFF                       0
+#define WM8350_CONFIG_DONE_DONE                      1
+
+#define WM8350_RECONFIG_AT_ON_OFF                    0
+#define WM8350_RECONFIG_AT_ON_ON                     1
+
+#define WM8350_AUTOINC_OFF                           0
+#define WM8350_AUTOINC_ON                            1
+
+#define WM8350_ARA_OFF                               0
+#define WM8350_ARA_ON                                1
+
+#define WM8350_SPI_CFG_CMOS                          0
+#define WM8350_SPI_CFG_OD                            1
+
+#define WM8350_SPI_4WIRE_3WIRE                       0
+#define WM8350_SPI_4WIRE_4WIRE                       1
+
+#define WM8350_SPI_3WIRE_I2C                         0
+#define WM8350_SPI_3WIRE_SPI                         1
+
+/*
+ * R8 (0x08) - Power mgmt (1)
+ */
+#define WM8350_CODEC_ISEL_MASK                  0xC000
+#define WM8350_VBUFEN                           0x2000
+#define WM8350_OUTPUT_DRAIN_EN                  0x0400
+#define WM8350_MIC_DET_ENA                      0x0100
+#define WM8350_BIASEN                           0x0020
+#define WM8350_MICBEN                           0x0010
+#define WM8350_VMIDEN                           0x0004
+#define WM8350_VMID_MASK                        0x0003
+#define WM8350_VMID_SHIFT                            0
+
+/*
+ * R9 (0x09) - Power mgmt (2)
+ */
+#define WM8350_IN3R_ENA                         0x0800
+#define WM8350_IN3L_ENA                         0x0400
+#define WM8350_INR_ENA                          0x0200
+#define WM8350_INL_ENA                          0x0100
+#define WM8350_MIXINR_ENA                       0x0080
+#define WM8350_MIXINL_ENA                       0x0040
+#define WM8350_OUT4_ENA                         0x0020
+#define WM8350_OUT3_ENA                         0x0010
+#define WM8350_MIXOUTR_ENA                      0x0002
+#define WM8350_MIXOUTL_ENA                      0x0001
+
+/*
+ * R10 (0x0A) - Power mgmt (3)
+ */
+#define WM8350_IN3R_TO_OUT2R                    0x0080
+#define WM8350_OUT2R_ENA                        0x0008
+#define WM8350_OUT2L_ENA                        0x0004
+#define WM8350_OUT1R_ENA                        0x0002
+#define WM8350_OUT1L_ENA                        0x0001
+
+/*
+ * R11 (0x0B) - Power mgmt (4)
+ */
+#define WM8350_SYSCLK_ENA                       0x4000
+#define WM8350_ADC_HPF_ENA                      0x2000
+#define WM8350_FLL_ENA                          0x0800
+#define WM8350_FLL_OSC_ENA                      0x0400
+#define WM8350_TOCLK_ENA                        0x0100
+#define WM8350_DACR_ENA                         0x0020
+#define WM8350_DACL_ENA                         0x0010
+#define WM8350_ADCR_ENA                         0x0008
+#define WM8350_ADCL_ENA                         0x0004
+
+/*
+ * R12 (0x0C) - Power mgmt (5)
+ */
+#define WM8350_CODEC_ENA                        0x1000
+#define WM8350_RTC_TICK_ENA                     0x0800
+#define WM8350_OSC32K_ENA                       0x0400
+#define WM8350_CHG_ENA                          0x0200
+#define WM8350_ACC_DET_ENA                      0x0100
+#define WM8350_AUXADC_ENA                       0x0080
+#define WM8350_DCMP4_ENA                        0x0008
+#define WM8350_DCMP3_ENA                        0x0004
+#define WM8350_DCMP2_ENA                        0x0002
+#define WM8350_DCMP1_ENA                        0x0001
+
+/*
+ * R13 (0x0D) - Power mgmt (6)
+ */
+#define WM8350_LS_ENA                           0x8000
+#define WM8350_LDO4_ENA                         0x0800
+#define WM8350_LDO3_ENA                         0x0400
+#define WM8350_LDO2_ENA                         0x0200
+#define WM8350_LDO1_ENA                         0x0100
+#define WM8350_DC6_ENA                          0x0020
+#define WM8350_DC5_ENA                          0x0010
+#define WM8350_DC4_ENA                          0x0008
+#define WM8350_DC3_ENA                          0x0004
+#define WM8350_DC2_ENA                          0x0002
+#define WM8350_DC1_ENA                          0x0001
+
+/*
+ * R14 (0x0E) - Power mgmt (7)
+ */
+#define WM8350_CS2_ENA                          0x0002
+#define WM8350_CS1_ENA                          0x0001
+
+/*
+ * R24 (0x18) - System Interrupts
+ */
+#define WM8350_OC_INT                           0x2000
+#define WM8350_UV_INT                           0x1000
+#define WM8350_PUTO_INT                         0x0800
+#define WM8350_CS_INT                           0x0200
+#define WM8350_EXT_INT                          0x0100
+#define WM8350_CODEC_INT                        0x0080
+#define WM8350_GP_INT                           0x0040
+#define WM8350_AUXADC_INT                       0x0020
+#define WM8350_RTC_INT                          0x0010
+#define WM8350_SYS_INT                          0x0008
+#define WM8350_CHG_INT                          0x0004
+#define WM8350_USB_INT                          0x0002
+#define WM8350_WKUP_INT                         0x0001
+
+/*
+ * R25 (0x19) - Interrupt Status 1
+ */
+#define WM8350_CHG_BAT_HOT_EINT                 0x8000
+#define WM8350_CHG_BAT_COLD_EINT                0x4000
+#define WM8350_CHG_BAT_FAIL_EINT                0x2000
+#define WM8350_CHG_TO_EINT                      0x1000
+#define WM8350_CHG_END_EINT                     0x0800
+#define WM8350_CHG_START_EINT                   0x0400
+#define WM8350_CHG_FAST_RDY_EINT                0x0200
+#define WM8350_RTC_PER_EINT                     0x0080
+#define WM8350_RTC_SEC_EINT                     0x0040
+#define WM8350_RTC_ALM_EINT                     0x0020
+#define WM8350_CHG_VBATT_LT_3P9_EINT            0x0004
+#define WM8350_CHG_VBATT_LT_3P1_EINT            0x0002
+#define WM8350_CHG_VBATT_LT_2P85_EINT           0x0001
+
+/*
+ * R26 (0x1A) - Interrupt Status 2
+ */
+#define WM8350_CS1_EINT                         0x2000
+#define WM8350_CS2_EINT                         0x1000
+#define WM8350_USB_LIMIT_EINT                   0x0400
+#define WM8350_AUXADC_DATARDY_EINT              0x0100
+#define WM8350_AUXADC_DCOMP4_EINT               0x0080
+#define WM8350_AUXADC_DCOMP3_EINT               0x0040
+#define WM8350_AUXADC_DCOMP2_EINT               0x0020
+#define WM8350_AUXADC_DCOMP1_EINT               0x0010
+#define WM8350_SYS_HYST_COMP_FAIL_EINT          0x0008
+#define WM8350_SYS_CHIP_GT115_EINT              0x0004
+#define WM8350_SYS_CHIP_GT140_EINT              0x0002
+#define WM8350_SYS_WDOG_TO_EINT                 0x0001
+
+/*
+ * R27 (0x1B) - Power Up Interrupt Status
+ */
+#define WM8350_PUTO_LDO4_EINT                   0x0800
+#define WM8350_PUTO_LDO3_EINT                   0x0400
+#define WM8350_PUTO_LDO2_EINT                   0x0200
+#define WM8350_PUTO_LDO1_EINT                   0x0100
+#define WM8350_PUTO_DC6_EINT                    0x0020
+#define WM8350_PUTO_DC5_EINT                    0x0010
+#define WM8350_PUTO_DC4_EINT                    0x0008
+#define WM8350_PUTO_DC3_EINT                    0x0004
+#define WM8350_PUTO_DC2_EINT                    0x0002
+#define WM8350_PUTO_DC1_EINT                    0x0001
+
+/*
+ * R28 (0x1C) - Under Voltage Interrupt status
+ */
+#define WM8350_UV_LDO4_EINT                     0x0800
+#define WM8350_UV_LDO3_EINT                     0x0400
+#define WM8350_UV_LDO2_EINT                     0x0200
+#define WM8350_UV_LDO1_EINT                     0x0100
+#define WM8350_UV_DC6_EINT                      0x0020
+#define WM8350_UV_DC5_EINT                      0x0010
+#define WM8350_UV_DC4_EINT                      0x0008
+#define WM8350_UV_DC3_EINT                      0x0004
+#define WM8350_UV_DC2_EINT                      0x0002
+#define WM8350_UV_DC1_EINT                      0x0001
+
+/*
+ * R29 (0x1D) - Over Current Interrupt status
+ */
+#define WM8350_OC_LS_EINT                       0x8000
+
+/*
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
+/*
+ * R31 (0x1F) - Comparator Interrupt Status
+ */
+#define WM8350_EXT_USB_FB_EINT                  0x8000
+#define WM8350_EXT_WALL_FB_EINT                 0x4000
+#define WM8350_EXT_BAT_FB_EINT                  0x2000
+#define WM8350_CODEC_JCK_DET_L_EINT             0x0800
+#define WM8350_CODEC_JCK_DET_R_EINT             0x0400
+#define WM8350_CODEC_MICSCD_EINT                0x0200
+#define WM8350_CODEC_MICD_EINT                  0x0100
+#define WM8350_WKUP_OFF_STATE_EINT              0x0040
+#define WM8350_WKUP_HIB_STATE_EINT              0x0020
+#define WM8350_WKUP_CONV_FAULT_EINT             0x0010
+#define WM8350_WKUP_WDOG_RST_EINT               0x0008
+#define WM8350_WKUP_GP_PWR_ON_EINT              0x0004
+#define WM8350_WKUP_ONKEY_EINT                  0x0002
+#define WM8350_WKUP_GP_WAKEUP_EINT              0x0001
+
+/*
+ * R32 (0x20) - System Interrupts Mask
+ */
+#define WM8350_IM_OC_INT                        0x2000
+#define WM8350_IM_UV_INT                        0x1000
+#define WM8350_IM_PUTO_INT                      0x0800
+#define WM8350_IM_SPARE_INT                     0x0400
+#define WM8350_IM_CS_INT                        0x0200
+#define WM8350_IM_EXT_INT                       0x0100
+#define WM8350_IM_CODEC_INT                     0x0080
+#define WM8350_IM_GP_INT                        0x0040
+#define WM8350_IM_AUXADC_INT                    0x0020
+#define WM8350_IM_RTC_INT                       0x0010
+#define WM8350_IM_SYS_INT                       0x0008
+#define WM8350_IM_CHG_INT                       0x0004
+#define WM8350_IM_USB_INT                       0x0002
+#define WM8350_IM_WKUP_INT                      0x0001
+
+/*
+ * R33 (0x21) - Interrupt Status 1 Mask
+ */
+#define WM8350_IM_CHG_BAT_HOT_EINT              0x8000
+#define WM8350_IM_CHG_BAT_COLD_EINT             0x4000
+#define WM8350_IM_CHG_BAT_FAIL_EINT             0x2000
+#define WM8350_IM_CHG_TO_EINT                   0x1000
+#define WM8350_IM_CHG_END_EINT                  0x0800
+#define WM8350_IM_CHG_START_EINT                0x0400
+#define WM8350_IM_CHG_FAST_RDY_EINT             0x0200
+#define WM8350_IM_RTC_PER_EINT                  0x0080
+#define WM8350_IM_RTC_SEC_EINT                  0x0040
+#define WM8350_IM_RTC_ALM_EINT                  0x0020
+#define WM8350_IM_CHG_VBATT_LT_3P9_EINT         0x0004
+#define WM8350_IM_CHG_VBATT_LT_3P1_EINT         0x0002
+#define WM8350_IM_CHG_VBATT_LT_2P85_EINT        0x0001
+
+/*
+ * R34 (0x22) - Interrupt Status 2 Mask
+ */
+#define WM8350_IM_SPARE2_EINT                   0x8000
+#define WM8350_IM_SPARE1_EINT                   0x4000
+#define WM8350_IM_CS1_EINT                      0x2000
+#define WM8350_IM_CS2_EINT                      0x1000
+#define WM8350_IM_USB_LIMIT_EINT                0x0400
+#define WM8350_IM_AUXADC_DATARDY_EINT           0x0100
+#define WM8350_IM_AUXADC_DCOMP4_EINT            0x0080
+#define WM8350_IM_AUXADC_DCOMP3_EINT            0x0040
+#define WM8350_IM_AUXADC_DCOMP2_EINT            0x0020
+#define WM8350_IM_AUXADC_DCOMP1_EINT            0x0010
+#define WM8350_IM_SYS_HYST_COMP_FAIL_EINT       0x0008
+#define WM8350_IM_SYS_CHIP_GT115_EINT           0x0004
+#define WM8350_IM_SYS_CHIP_GT140_EINT           0x0002
+#define WM8350_IM_SYS_WDOG_TO_EINT              0x0001
+
+/*
+ * R35 (0x23) - Power Up Interrupt Status Mask
+ */
+#define WM8350_IM_PUTO_LDO4_EINT                0x0800
+#define WM8350_IM_PUTO_LDO3_EINT                0x0400
+#define WM8350_IM_PUTO_LDO2_EINT                0x0200
+#define WM8350_IM_PUTO_LDO1_EINT                0x0100
+#define WM8350_IM_PUTO_DC6_EINT                 0x0020
+#define WM8350_IM_PUTO_DC5_EINT                 0x0010
+#define WM8350_IM_PUTO_DC4_EINT                 0x0008
+#define WM8350_IM_PUTO_DC3_EINT                 0x0004
+#define WM8350_IM_PUTO_DC2_EINT                 0x0002
+#define WM8350_IM_PUTO_DC1_EINT                 0x0001
+
+/*
+ * R36 (0x24) - Under Voltage Interrupt status Mask
+ */
+#define WM8350_IM_UV_LDO4_EINT                  0x0800
+#define WM8350_IM_UV_LDO3_EINT                  0x0400
+#define WM8350_IM_UV_LDO2_EINT                  0x0200
+#define WM8350_IM_UV_LDO1_EINT                  0x0100
+#define WM8350_IM_UV_DC6_EINT                   0x0020
+#define WM8350_IM_UV_DC5_EINT                   0x0010
+#define WM8350_IM_UV_DC4_EINT                   0x0008
+#define WM8350_IM_UV_DC3_EINT                   0x0004
+#define WM8350_IM_UV_DC2_EINT                   0x0002
+#define WM8350_IM_UV_DC1_EINT                   0x0001
+
+/*
+ * R37 (0x25) - Over Current Interrupt status Mask
+ */
+#define WM8350_IM_OC_LS_EINT                    0x8000
+
+/*
+ * R38 (0x26) - GPIO Interrupt Status Mask
+ */
+#define WM8350_IM_GP12_EINT                     0x1000
+#define WM8350_IM_GP11_EINT                     0x0800
+#define WM8350_IM_GP10_EINT                     0x0400
+#define WM8350_IM_GP9_EINT                      0x0200
+#define WM8350_IM_GP8_EINT                      0x0100
+#define WM8350_IM_GP7_EINT                      0x0080
+#define WM8350_IM_GP6_EINT                      0x0040
+#define WM8350_IM_GP5_EINT                      0x0020
+#define WM8350_IM_GP4_EINT                      0x0010
+#define WM8350_IM_GP3_EINT                      0x0008
+#define WM8350_IM_GP2_EINT                      0x0004
+#define WM8350_IM_GP1_EINT                      0x0002
+#define WM8350_IM_GP0_EINT                      0x0001
+
+/*
+ * R39 (0x27) - Comparator Interrupt Status Mask
+ */
+#define WM8350_IM_EXT_USB_FB_EINT               0x8000
+#define WM8350_IM_EXT_WALL_FB_EINT              0x4000
+#define WM8350_IM_EXT_BAT_FB_EINT               0x2000
+#define WM8350_IM_CODEC_JCK_DET_L_EINT          0x0800
+#define WM8350_IM_CODEC_JCK_DET_R_EINT          0x0400
+#define WM8350_IM_CODEC_MICSCD_EINT             0x0200
+#define WM8350_IM_CODEC_MICD_EINT               0x0100
+#define WM8350_IM_WKUP_OFF_STATE_EINT           0x0040
+#define WM8350_IM_WKUP_HIB_STATE_EINT           0x0020
+#define WM8350_IM_WKUP_CONV_FAULT_EINT          0x0010
+#define WM8350_IM_WKUP_WDOG_RST_EINT            0x0008
+#define WM8350_IM_WKUP_GP_PWR_ON_EINT           0x0004
+#define WM8350_IM_WKUP_ONKEY_EINT               0x0002
+#define WM8350_IM_WKUP_GP_WAKEUP_EINT           0x0001
+
+/*
+ * R220 (0xDC) - RAM BIST 1
+ */
+#define WM8350_READ_STATUS                      0x0800
+#define WM8350_TSTRAM_CLK                       0x0100
+#define WM8350_TSTRAM_CLK_ENA                   0x0080
+#define WM8350_STARTSEQ                         0x0040
+#define WM8350_READ_SRC                         0x0020
+#define WM8350_COUNT_DIR                        0x0010
+#define WM8350_TSTRAM_MODE_MASK                 0x000E
+#define WM8350_TSTRAM_ENA                       0x0001
+
+/*
+ * R225 (0xE1) - DCDC/LDO status
+ */
+#define WM8350_LS_STS                           0x8000
+#define WM8350_LDO4_STS                         0x0800
+#define WM8350_LDO3_STS                         0x0400
+#define WM8350_LDO2_STS                         0x0200
+#define WM8350_LDO1_STS                         0x0100
+#define WM8350_DC6_STS                          0x0020
+#define WM8350_DC5_STS                          0x0010
+#define WM8350_DC4_STS                          0x0008
+#define WM8350_DC3_STS                          0x0004
+#define WM8350_DC2_STS                          0x0002
+#define WM8350_DC1_STS                          0x0001
+
+/* WM8350 wake up conditions */
+#define WM8350_IRQ_WKUP_OFF_STATE		43
+#define WM8350_IRQ_WKUP_HIB_STATE		44
+#define WM8350_IRQ_WKUP_CONV_FAULT		45
+#define WM8350_IRQ_WKUP_WDOG_RST		46
+#define WM8350_IRQ_WKUP_GP_PWR_ON		47
+#define WM8350_IRQ_WKUP_ONKEY			48
+#define WM8350_IRQ_WKUP_GP_WAKEUP		49
+
+/* wm8350 chip revisions */
+#define WM8350_REV_E				0x4
+#define WM8350_REV_F				0x5
+#define WM8350_REV_G				0x6
+
+struct wm8350_reg_access {
+	u16 readable;		/* Mask of readable bits */
+	u16 writable;		/* Mask of writable bits */
+	u16 vol;		/* Mask of volatile bits */
+};
+extern const struct wm8350_reg_access wm8350_reg_io_map[];
+extern const u16 wm8350_mode0_defaults[];
+extern const u16 wm8350_mode1_defaults[];
+extern const u16 wm8350_mode2_defaults[];
+extern const u16 wm8350_mode3_defaults[];
+
+struct wm8350;
+
+struct wm8350_irq {
+	void (*handler) (struct wm8350 *, int, void *);
+	void *data;
+};
+
+struct wm8350 {
+	int rev;		/* chip revision */
+
+	struct device *dev;
+
+	/* device IO */
+	union {
+		struct i2c_client *i2c_client;
+		struct spi_device *spi_device;
+	};
+	int (*read_dev)(struct wm8350 *wm8350, char reg, int size, void *dest);
+	int (*write_dev)(struct wm8350 *wm8350, char reg, int size,
+			 void *src);
+	u16 *reg_cache;
+};
+
+/*
+ * WM8350 device initialisation and exit.
+ */
+int wm8350_device_init(struct wm8350 *wm8350);
+void wm8350_device_exit(struct wm8350 *wm8350);
+
+/*
+ * WM8350 device IO
+ */
+int wm8350_clear_bits(struct wm8350 *wm8350, u16 reg, u16 mask);
+int wm8350_set_bits(struct wm8350 *wm8350, u16 reg, u16 mask);
+u16 wm8350_reg_read(struct wm8350 *wm8350, int reg);
+int wm8350_reg_write(struct wm8350 *wm8350, int reg, u16 val);
+int wm8350_reg_lock(struct wm8350 *wm8350);
+int wm8350_reg_unlock(struct wm8350 *wm8350);
+int wm8350_block_read(struct wm8350 *wm8350, int reg, int size, u16 *dest);
+int wm8350_block_write(struct wm8350 *wm8350, int reg, int size, u16 *src);
+
+#endif
-- 
1.5.6.5

