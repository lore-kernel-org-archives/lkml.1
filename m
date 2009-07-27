Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZG0Nqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZG0Nqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZG0Nqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59108 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754564AbZG0Nq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 04/22] mfd: Add WM831x AUXADC support
Date: Mon, 27 Jul 2009 14:45:54 +0100
Message-Id: <1248702372-29534-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x contains an auxiliary ADC with a number of switchable
inputs which is used to monitor some of the voltages and
temperatures in the system and has some external inputs which can be
used for machine specific purposes. Provide an API allowing drivers
to read values from the ADC.

An internal reference voltage is provided to allow callibration of
the ADC. This is used to calibrate the device at startup.

The hardware also supports continuous readings and digital comparators.
These are not yet supported by the driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c         |  101 +++++++++++++++++
 include/linux/mfd/wm831x/auxadc.h |  216 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/core.h   |    2 +
 3 files changed, 319 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mfd/wm831x/auxadc.h

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index eb63d22..42bef1d 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -15,11 +15,14 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
+#include <linux/bcd.h>
+#include <linux/delay.h>
 #include <linux/mfd/core.h>
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/pdata.h>
 #include <linux/mfd/wm831x/irq.h>
+#include <linux/mfd/wm831x/auxadc.h>
 
 enum wm831x_parent {
 	WM8310 = 0,
@@ -244,6 +247,103 @@ out:
 }
 EXPORT_SYMBOL_GPL(wm831x_set_bits);
 
+/**
+ * wm831x_auxadc_read: Read a value from the WM831x AUXADC
+ *
+ * @wm831x: Device to read from.
+ * @input: AUXADC input to read.
+ */
+int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
+{
+	int tries = 10;
+	int ret, src;
+
+	mutex_lock(&wm831x->auxadc_lock);
+
+	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
+			      WM831X_AUX_ENA, WM831X_AUX_ENA);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to enable AUXADC: %d\n", ret);
+		goto out;
+	}
+
+	/* We force a single source at present */
+	src = input;
+	ret = wm831x_reg_write(wm831x, WM831X_AUXADC_SOURCE,
+			       1 << src);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to set AUXADC source: %d\n", ret);
+		goto out;
+	}
+
+	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
+			      WM831X_AUX_CVT_ENA, WM831X_AUX_CVT_ENA);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to start AUXADC: %d\n", ret);
+		goto disable;
+	}
+
+	do {
+		msleep(1);
+
+		ret = wm831x_reg_read(wm831x, WM831X_AUXADC_CONTROL);
+		if (ret < 0)
+			ret = WM831X_AUX_CVT_ENA;
+	} while ((ret & WM831X_AUX_CVT_ENA) && --tries);
+
+	if (ret & WM831X_AUX_CVT_ENA) {
+		dev_err(wm831x->dev, "Timed out reading AUXADC\n");
+		ret = -EBUSY;
+		goto disable;
+	}
+
+	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read AUXADC data: %d\n", ret);
+	} else {
+		src = ((ret & WM831X_AUX_DATA_SRC_MASK)
+		       >> WM831X_AUX_DATA_SRC_SHIFT) - 1;
+
+		if (src == 14)
+			src = WM831X_AUX_CAL;
+
+		if (src != input) {
+			dev_err(wm831x->dev, "Data from source %d not %d\n",
+				src, input);
+			ret = -EINVAL;
+		} else {
+			ret &= WM831X_AUX_DATA_MASK;
+		}
+	}
+
+disable:
+	wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL, WM831X_AUX_ENA, 0);
+out:
+	mutex_unlock(&wm831x->auxadc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_auxadc_read);
+
+/**
+ * wm831x_auxadc_read_uv: Read a voltage from the WM831x AUXADC
+ *
+ * @wm831x: Device to read from.
+ * @input: AUXADC input to read.
+ */
+int wm831x_auxadc_read_uv(struct wm831x *wm831x, enum wm831x_auxadc input)
+{
+	int ret;
+
+	ret = wm831x_auxadc_read(wm831x, input);
+	if (ret < 0)
+		return ret;
+
+	ret *= 1465;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_auxadc_read_uv);
+
 static struct resource wm831x_dcdc1_resources[] = {
 	{
 		.start = WM831X_DC1_CONTROL_1,
@@ -1084,6 +1184,7 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 	mutex_init(&wm831x->io_lock);
 	mutex_init(&wm831x->key_lock);
+	mutex_init(&wm831x->auxadc_lock);
 	dev_set_drvdata(wm831x->dev, wm831x);
 
 	ret = wm831x_reg_read(wm831x, WM831X_PARENT_ID);
diff --git a/include/linux/mfd/wm831x/auxadc.h b/include/linux/mfd/wm831x/auxadc.h
new file mode 100644
index 0000000..b132067
--- /dev/null
+++ b/include/linux/mfd/wm831x/auxadc.h
@@ -0,0 +1,216 @@
+/*
+ * include/linux/mfd/wm831x/auxadc.h -- Auxiliary ADC interface for WM831x
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
+#ifndef __MFD_WM831X_AUXADC_H__
+#define __MFD_WM831X_AUXADC_H__
+
+/*
+ * R16429 (0x402D) - AuxADC Data
+ */
+#define WM831X_AUX_DATA_SRC_MASK                0xF000  /* AUX_DATA_SRC - [15:12] */
+#define WM831X_AUX_DATA_SRC_SHIFT                   12  /* AUX_DATA_SRC - [15:12] */
+#define WM831X_AUX_DATA_SRC_WIDTH                    4  /* AUX_DATA_SRC - [15:12] */
+#define WM831X_AUX_DATA_MASK                    0x0FFF  /* AUX_DATA - [11:0] */
+#define WM831X_AUX_DATA_SHIFT                        0  /* AUX_DATA - [11:0] */
+#define WM831X_AUX_DATA_WIDTH                       12  /* AUX_DATA - [11:0] */
+
+/*
+ * R16430 (0x402E) - AuxADC Control
+ */
+#define WM831X_AUX_ENA                          0x8000  /* AUX_ENA */
+#define WM831X_AUX_ENA_MASK                     0x8000  /* AUX_ENA */
+#define WM831X_AUX_ENA_SHIFT                        15  /* AUX_ENA */
+#define WM831X_AUX_ENA_WIDTH                         1  /* AUX_ENA */
+#define WM831X_AUX_CVT_ENA                      0x4000  /* AUX_CVT_ENA */
+#define WM831X_AUX_CVT_ENA_MASK                 0x4000  /* AUX_CVT_ENA */
+#define WM831X_AUX_CVT_ENA_SHIFT                    14  /* AUX_CVT_ENA */
+#define WM831X_AUX_CVT_ENA_WIDTH                     1  /* AUX_CVT_ENA */
+#define WM831X_AUX_SLPENA                       0x1000  /* AUX_SLPENA */
+#define WM831X_AUX_SLPENA_MASK                  0x1000  /* AUX_SLPENA */
+#define WM831X_AUX_SLPENA_SHIFT                     12  /* AUX_SLPENA */
+#define WM831X_AUX_SLPENA_WIDTH                      1  /* AUX_SLPENA */
+#define WM831X_AUX_FRC_ENA                      0x0800  /* AUX_FRC_ENA */
+#define WM831X_AUX_FRC_ENA_MASK                 0x0800  /* AUX_FRC_ENA */
+#define WM831X_AUX_FRC_ENA_SHIFT                    11  /* AUX_FRC_ENA */
+#define WM831X_AUX_FRC_ENA_WIDTH                     1  /* AUX_FRC_ENA */
+#define WM831X_AUX_RATE_MASK                    0x003F  /* AUX_RATE - [5:0] */
+#define WM831X_AUX_RATE_SHIFT                        0  /* AUX_RATE - [5:0] */
+#define WM831X_AUX_RATE_WIDTH                        6  /* AUX_RATE - [5:0] */
+
+/*
+ * R16431 (0x402F) - AuxADC Source
+ */
+#define WM831X_AUX_CAL_SEL                      0x8000  /* AUX_CAL_SEL */
+#define WM831X_AUX_CAL_SEL_MASK                 0x8000  /* AUX_CAL_SEL */
+#define WM831X_AUX_CAL_SEL_SHIFT                    15  /* AUX_CAL_SEL */
+#define WM831X_AUX_CAL_SEL_WIDTH                     1  /* AUX_CAL_SEL */
+#define WM831X_AUX_BKUP_BATT_SEL                0x0400  /* AUX_BKUP_BATT_SEL */
+#define WM831X_AUX_BKUP_BATT_SEL_MASK           0x0400  /* AUX_BKUP_BATT_SEL */
+#define WM831X_AUX_BKUP_BATT_SEL_SHIFT              10  /* AUX_BKUP_BATT_SEL */
+#define WM831X_AUX_BKUP_BATT_SEL_WIDTH               1  /* AUX_BKUP_BATT_SEL */
+#define WM831X_AUX_WALL_SEL                     0x0200  /* AUX_WALL_SEL */
+#define WM831X_AUX_WALL_SEL_MASK                0x0200  /* AUX_WALL_SEL */
+#define WM831X_AUX_WALL_SEL_SHIFT                    9  /* AUX_WALL_SEL */
+#define WM831X_AUX_WALL_SEL_WIDTH                    1  /* AUX_WALL_SEL */
+#define WM831X_AUX_BATT_SEL                     0x0100  /* AUX_BATT_SEL */
+#define WM831X_AUX_BATT_SEL_MASK                0x0100  /* AUX_BATT_SEL */
+#define WM831X_AUX_BATT_SEL_SHIFT                    8  /* AUX_BATT_SEL */
+#define WM831X_AUX_BATT_SEL_WIDTH                    1  /* AUX_BATT_SEL */
+#define WM831X_AUX_USB_SEL                      0x0080  /* AUX_USB_SEL */
+#define WM831X_AUX_USB_SEL_MASK                 0x0080  /* AUX_USB_SEL */
+#define WM831X_AUX_USB_SEL_SHIFT                     7  /* AUX_USB_SEL */
+#define WM831X_AUX_USB_SEL_WIDTH                     1  /* AUX_USB_SEL */
+#define WM831X_AUX_SYSVDD_SEL                   0x0040  /* AUX_SYSVDD_SEL */
+#define WM831X_AUX_SYSVDD_SEL_MASK              0x0040  /* AUX_SYSVDD_SEL */
+#define WM831X_AUX_SYSVDD_SEL_SHIFT                  6  /* AUX_SYSVDD_SEL */
+#define WM831X_AUX_SYSVDD_SEL_WIDTH                  1  /* AUX_SYSVDD_SEL */
+#define WM831X_AUX_BATT_TEMP_SEL                0x0020  /* AUX_BATT_TEMP_SEL */
+#define WM831X_AUX_BATT_TEMP_SEL_MASK           0x0020  /* AUX_BATT_TEMP_SEL */
+#define WM831X_AUX_BATT_TEMP_SEL_SHIFT               5  /* AUX_BATT_TEMP_SEL */
+#define WM831X_AUX_BATT_TEMP_SEL_WIDTH               1  /* AUX_BATT_TEMP_SEL */
+#define WM831X_AUX_CHIP_TEMP_SEL                0x0010  /* AUX_CHIP_TEMP_SEL */
+#define WM831X_AUX_CHIP_TEMP_SEL_MASK           0x0010  /* AUX_CHIP_TEMP_SEL */
+#define WM831X_AUX_CHIP_TEMP_SEL_SHIFT               4  /* AUX_CHIP_TEMP_SEL */
+#define WM831X_AUX_CHIP_TEMP_SEL_WIDTH               1  /* AUX_CHIP_TEMP_SEL */
+#define WM831X_AUX_AUX4_SEL                     0x0008  /* AUX_AUX4_SEL */
+#define WM831X_AUX_AUX4_SEL_MASK                0x0008  /* AUX_AUX4_SEL */
+#define WM831X_AUX_AUX4_SEL_SHIFT                    3  /* AUX_AUX4_SEL */
+#define WM831X_AUX_AUX4_SEL_WIDTH                    1  /* AUX_AUX4_SEL */
+#define WM831X_AUX_AUX3_SEL                     0x0004  /* AUX_AUX3_SEL */
+#define WM831X_AUX_AUX3_SEL_MASK                0x0004  /* AUX_AUX3_SEL */
+#define WM831X_AUX_AUX3_SEL_SHIFT                    2  /* AUX_AUX3_SEL */
+#define WM831X_AUX_AUX3_SEL_WIDTH                    1  /* AUX_AUX3_SEL */
+#define WM831X_AUX_AUX2_SEL                     0x0002  /* AUX_AUX2_SEL */
+#define WM831X_AUX_AUX2_SEL_MASK                0x0002  /* AUX_AUX2_SEL */
+#define WM831X_AUX_AUX2_SEL_SHIFT                    1  /* AUX_AUX2_SEL */
+#define WM831X_AUX_AUX2_SEL_WIDTH                    1  /* AUX_AUX2_SEL */
+#define WM831X_AUX_AUX1_SEL                     0x0001  /* AUX_AUX1_SEL */
+#define WM831X_AUX_AUX1_SEL_MASK                0x0001  /* AUX_AUX1_SEL */
+#define WM831X_AUX_AUX1_SEL_SHIFT                    0  /* AUX_AUX1_SEL */
+#define WM831X_AUX_AUX1_SEL_WIDTH                    1  /* AUX_AUX1_SEL */
+
+/*
+ * R16432 (0x4030) - Comparator Control
+ */
+#define WM831X_DCOMP4_STS                       0x0800  /* DCOMP4_STS */
+#define WM831X_DCOMP4_STS_MASK                  0x0800  /* DCOMP4_STS */
+#define WM831X_DCOMP4_STS_SHIFT                     11  /* DCOMP4_STS */
+#define WM831X_DCOMP4_STS_WIDTH                      1  /* DCOMP4_STS */
+#define WM831X_DCOMP3_STS                       0x0400  /* DCOMP3_STS */
+#define WM831X_DCOMP3_STS_MASK                  0x0400  /* DCOMP3_STS */
+#define WM831X_DCOMP3_STS_SHIFT                     10  /* DCOMP3_STS */
+#define WM831X_DCOMP3_STS_WIDTH                      1  /* DCOMP3_STS */
+#define WM831X_DCOMP2_STS                       0x0200  /* DCOMP2_STS */
+#define WM831X_DCOMP2_STS_MASK                  0x0200  /* DCOMP2_STS */
+#define WM831X_DCOMP2_STS_SHIFT                      9  /* DCOMP2_STS */
+#define WM831X_DCOMP2_STS_WIDTH                      1  /* DCOMP2_STS */
+#define WM831X_DCOMP1_STS                       0x0100  /* DCOMP1_STS */
+#define WM831X_DCOMP1_STS_MASK                  0x0100  /* DCOMP1_STS */
+#define WM831X_DCOMP1_STS_SHIFT                      8  /* DCOMP1_STS */
+#define WM831X_DCOMP1_STS_WIDTH                      1  /* DCOMP1_STS */
+#define WM831X_DCMP4_ENA                        0x0008  /* DCMP4_ENA */
+#define WM831X_DCMP4_ENA_MASK                   0x0008  /* DCMP4_ENA */
+#define WM831X_DCMP4_ENA_SHIFT                       3  /* DCMP4_ENA */
+#define WM831X_DCMP4_ENA_WIDTH                       1  /* DCMP4_ENA */
+#define WM831X_DCMP3_ENA                        0x0004  /* DCMP3_ENA */
+#define WM831X_DCMP3_ENA_MASK                   0x0004  /* DCMP3_ENA */
+#define WM831X_DCMP3_ENA_SHIFT                       2  /* DCMP3_ENA */
+#define WM831X_DCMP3_ENA_WIDTH                       1  /* DCMP3_ENA */
+#define WM831X_DCMP2_ENA                        0x0002  /* DCMP2_ENA */
+#define WM831X_DCMP2_ENA_MASK                   0x0002  /* DCMP2_ENA */
+#define WM831X_DCMP2_ENA_SHIFT                       1  /* DCMP2_ENA */
+#define WM831X_DCMP2_ENA_WIDTH                       1  /* DCMP2_ENA */
+#define WM831X_DCMP1_ENA                        0x0001  /* DCMP1_ENA */
+#define WM831X_DCMP1_ENA_MASK                   0x0001  /* DCMP1_ENA */
+#define WM831X_DCMP1_ENA_SHIFT                       0  /* DCMP1_ENA */
+#define WM831X_DCMP1_ENA_WIDTH                       1  /* DCMP1_ENA */
+
+/*
+ * R16433 (0x4031) - Comparator 1
+ */
+#define WM831X_DCMP1_SRC_MASK                   0xE000  /* DCMP1_SRC - [15:13] */
+#define WM831X_DCMP1_SRC_SHIFT                      13  /* DCMP1_SRC - [15:13] */
+#define WM831X_DCMP1_SRC_WIDTH                       3  /* DCMP1_SRC - [15:13] */
+#define WM831X_DCMP1_GT                         0x1000  /* DCMP1_GT */
+#define WM831X_DCMP1_GT_MASK                    0x1000  /* DCMP1_GT */
+#define WM831X_DCMP1_GT_SHIFT                       12  /* DCMP1_GT */
+#define WM831X_DCMP1_GT_WIDTH                        1  /* DCMP1_GT */
+#define WM831X_DCMP1_THR_MASK                   0x0FFF  /* DCMP1_THR - [11:0] */
+#define WM831X_DCMP1_THR_SHIFT                       0  /* DCMP1_THR - [11:0] */
+#define WM831X_DCMP1_THR_WIDTH                      12  /* DCMP1_THR - [11:0] */
+
+/*
+ * R16434 (0x4032) - Comparator 2
+ */
+#define WM831X_DCMP2_SRC_MASK                   0xE000  /* DCMP2_SRC - [15:13] */
+#define WM831X_DCMP2_SRC_SHIFT                      13  /* DCMP2_SRC - [15:13] */
+#define WM831X_DCMP2_SRC_WIDTH                       3  /* DCMP2_SRC - [15:13] */
+#define WM831X_DCMP2_GT                         0x1000  /* DCMP2_GT */
+#define WM831X_DCMP2_GT_MASK                    0x1000  /* DCMP2_GT */
+#define WM831X_DCMP2_GT_SHIFT                       12  /* DCMP2_GT */
+#define WM831X_DCMP2_GT_WIDTH                        1  /* DCMP2_GT */
+#define WM831X_DCMP2_THR_MASK                   0x0FFF  /* DCMP2_THR - [11:0] */
+#define WM831X_DCMP2_THR_SHIFT                       0  /* DCMP2_THR - [11:0] */
+#define WM831X_DCMP2_THR_WIDTH                      12  /* DCMP2_THR - [11:0] */
+
+/*
+ * R16435 (0x4033) - Comparator 3
+ */
+#define WM831X_DCMP3_SRC_MASK                   0xE000  /* DCMP3_SRC - [15:13] */
+#define WM831X_DCMP3_SRC_SHIFT                      13  /* DCMP3_SRC - [15:13] */
+#define WM831X_DCMP3_SRC_WIDTH                       3  /* DCMP3_SRC - [15:13] */
+#define WM831X_DCMP3_GT                         0x1000  /* DCMP3_GT */
+#define WM831X_DCMP3_GT_MASK                    0x1000  /* DCMP3_GT */
+#define WM831X_DCMP3_GT_SHIFT                       12  /* DCMP3_GT */
+#define WM831X_DCMP3_GT_WIDTH                        1  /* DCMP3_GT */
+#define WM831X_DCMP3_THR_MASK                   0x0FFF  /* DCMP3_THR - [11:0] */
+#define WM831X_DCMP3_THR_SHIFT                       0  /* DCMP3_THR - [11:0] */
+#define WM831X_DCMP3_THR_WIDTH                      12  /* DCMP3_THR - [11:0] */
+
+/*
+ * R16436 (0x4034) - Comparator 4
+ */
+#define WM831X_DCMP4_SRC_MASK                   0xE000  /* DCMP4_SRC - [15:13] */
+#define WM831X_DCMP4_SRC_SHIFT                      13  /* DCMP4_SRC - [15:13] */
+#define WM831X_DCMP4_SRC_WIDTH                       3  /* DCMP4_SRC - [15:13] */
+#define WM831X_DCMP4_GT                         0x1000  /* DCMP4_GT */
+#define WM831X_DCMP4_GT_MASK                    0x1000  /* DCMP4_GT */
+#define WM831X_DCMP4_GT_SHIFT                       12  /* DCMP4_GT */
+#define WM831X_DCMP4_GT_WIDTH                        1  /* DCMP4_GT */
+#define WM831X_DCMP4_THR_MASK                   0x0FFF  /* DCMP4_THR - [11:0] */
+#define WM831X_DCMP4_THR_SHIFT                       0  /* DCMP4_THR - [11:0] */
+#define WM831X_DCMP4_THR_WIDTH                      12  /* DCMP4_THR - [11:0] */
+
+#define WM831X_AUX_CAL_FACTOR  0xfff
+#define WM831X_AUX_CAL_NOMINAL 0x222
+
+enum wm831x_auxadc {
+	WM831X_AUX_CAL = 15,
+	WM831X_AUX_BKUP_BATT = 10,
+	WM831X_AUX_WALL = 9,
+	WM831X_AUX_BATT = 8,
+	WM831X_AUX_USB = 7,
+	WM831X_AUX_SYSVDD = 6,
+	WM831X_AUX_BATT_TEMP = 5,
+	WM831X_AUX_CHIP_TEMP = 4,
+	WM831X_AUX_AUX4 = 3,
+	WM831X_AUX_AUX3 = 2,
+	WM831X_AUX_AUX2 = 1,
+	WM831X_AUX_AUX1 = 0,
+};
+
+int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input);
+int wm831x_auxadc_read_uv(struct wm831x *wm831x, enum wm831x_auxadc input);
+
+#endif
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index b96c935..d7134df 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -234,6 +234,8 @@ struct wm831x {
 	unsigned int irq_base;
 	int irq_masks[5];
 
+	struct mutex auxadc_lock;
+
 	/* The WM831x has a security key blocking access to certain
 	 * registers.  The mutex is taken by the accessors for locking
 	 * and unlocking the security key, locked is used to fail
-- 
1.6.3.3

