Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZG0Nrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZG0Nrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZG0Nrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:47:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59146 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754722AbZG0Nqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 06/22] mfd: Add basic WM831x OTP support
Date: Mon, 27 Jul 2009 14:45:56 +0100
Message-Id: <1248702372-29534-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of devices use OTP (One Time Programmable, a type
of PROM) to store system configuration. At run time this data is
visible via registers.

Currently the only explicitly supported feature is that the unique
ID provided by every WM831x device is exported to user space via
sysfs. Other configuration data may be read by system-specific
code in the pre_init() and post_init() platform data operations.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c      |    4 +
 drivers/mfd/wm831x-otp.c       |   83 ++++++++++++++++++++
 include/linux/mfd/wm831x/otp.h |  162 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wm831x-otp.c
 create mode 100644 include/linux/mfd/wm831x/otp.h

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index bc40ea3..33eaea2 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -23,6 +23,7 @@
 #include <linux/mfd/wm831x/pdata.h>
 #include <linux/mfd/wm831x/irq.h>
 #include <linux/mfd/wm831x/auxadc.h>
+#include <linux/mfd/wm831x/otp.h>
 
 enum wm831x_parent {
 	WM8310 = 0,
@@ -1340,6 +1341,8 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 				ret);
 	}
 
+	wm831x_otp_init(wm831x);
+
 	if (pdata && pdata->post_init) {
 		ret = pdata->post_init(wm831x);
 		if (ret != 0) {
@@ -1360,6 +1363,7 @@ err:
 
 static void wm831x_device_exit(struct wm831x *wm831x)
 {
+	wm831x_otp_exit(wm831x);
 	mfd_remove_devices(wm831x->dev);
 	wm831x_irq_exit(wm831x);
 	kfree(wm831x);
diff --git a/drivers/mfd/wm831x-otp.c b/drivers/mfd/wm831x-otp.c
new file mode 100644
index 0000000..f742745
--- /dev/null
+++ b/drivers/mfd/wm831x-otp.c
@@ -0,0 +1,83 @@
+/*
+ * wm831x-otp.c  --  OTP for Wolfson WM831x PMICs
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
+#include <linux/bcd.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/otp.h>
+
+/* In bytes */
+#define WM831X_UNIQUE_ID_LEN 16
+
+/* Read the unique ID from the chip into id */
+static int wm831x_unique_id_read(struct wm831x *wm831x, char *id)
+{
+	int i, val;
+
+	for (i = 0; i < WM831X_UNIQUE_ID_LEN / 2; i++) {
+		val = wm831x_reg_read(wm831x, WM831X_UNIQUE_ID_1 + i);
+		if (val < 0)
+			return val;
+
+		id[i * 2]       = (val >> 8) & 0xff;
+		id[(i * 2) + 1] = val & 0xff;
+	}
+
+	return 0;
+}
+
+static ssize_t wm831x_unique_id_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct wm831x *wm831x = dev_get_drvdata(dev);
+	int i, rval;
+	char id[WM831X_UNIQUE_ID_LEN];
+	ssize_t ret = 0;
+
+	rval = wm831x_unique_id_read(wm831x, id);
+	if (rval < 0)
+		return 0;
+
+	for (i = 0; i < WM831X_UNIQUE_ID_LEN; i++)
+		ret += sprintf(&buf[ret], "%02x", buf[i]);
+
+	ret += sprintf(&buf[ret], "\n");
+
+	return ret;
+}
+
+static DEVICE_ATTR(unique_id, 0444, wm831x_unique_id_show, NULL);
+
+int wm831x_otp_init(struct wm831x *wm831x)
+{
+	int ret;
+
+	ret = device_create_file(wm831x->dev, &dev_attr_unique_id);
+	if (ret != 0)
+		dev_err(wm831x->dev, "Unique ID attribute not created: %d\n",
+			ret);
+
+	return ret;
+}
+
+void wm831x_otp_exit(struct wm831x *wm831x)
+{
+	device_remove_file(wm831x->dev, &dev_attr_unique_id);
+}
+
diff --git a/include/linux/mfd/wm831x/otp.h b/include/linux/mfd/wm831x/otp.h
new file mode 100644
index 0000000..ce1f81a
--- /dev/null
+++ b/include/linux/mfd/wm831x/otp.h
@@ -0,0 +1,162 @@
+/*
+ * include/linux/mfd/wm831x/otp.h -- OTP interface for WM831x
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
+#ifndef __MFD_WM831X_OTP_H__
+#define __MFD_WM831X_OTP_H__
+
+int wm831x_otp_init(struct wm831x *wm831x);
+void wm831x_otp_exit(struct wm831x *wm831x);
+
+/*
+ * R30720 (0x7800) - Unique ID 1
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30721 (0x7801) - Unique ID 2
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30722 (0x7802) - Unique ID 3
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30723 (0x7803) - Unique ID 4
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30724 (0x7804) - Unique ID 5
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30725 (0x7805) - Unique ID 6
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30726 (0x7806) - Unique ID 7
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30727 (0x7807) - Unique ID 8
+ */
+#define WM831X_UNIQUE_ID_MASK                   0xFFFF  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_SHIFT                       0  /* UNIQUE_ID - [15:0] */
+#define WM831X_UNIQUE_ID_WIDTH                      16  /* UNIQUE_ID - [15:0] */
+
+/*
+ * R30728 (0x7808) - Factory OTP ID
+ */
+#define WM831X_OTP_FACT_ID_MASK                 0xFFFE  /* OTP_FACT_ID - [15:1] */
+#define WM831X_OTP_FACT_ID_SHIFT                     1  /* OTP_FACT_ID - [15:1] */
+#define WM831X_OTP_FACT_ID_WIDTH                    15  /* OTP_FACT_ID - [15:1] */
+#define WM831X_OTP_FACT_FINAL                   0x0001  /* OTP_FACT_FINAL */
+#define WM831X_OTP_FACT_FINAL_MASK              0x0001  /* OTP_FACT_FINAL */
+#define WM831X_OTP_FACT_FINAL_SHIFT                  0  /* OTP_FACT_FINAL */
+#define WM831X_OTP_FACT_FINAL_WIDTH                  1  /* OTP_FACT_FINAL */
+
+/*
+ * R30729 (0x7809) - Factory OTP 1
+ */
+#define WM831X_DC3_TRIM_MASK                    0xF000  /* DC3_TRIM - [15:12] */
+#define WM831X_DC3_TRIM_SHIFT                       12  /* DC3_TRIM - [15:12] */
+#define WM831X_DC3_TRIM_WIDTH                        4  /* DC3_TRIM - [15:12] */
+#define WM831X_DC2_TRIM_MASK                    0x0FC0  /* DC2_TRIM - [11:6] */
+#define WM831X_DC2_TRIM_SHIFT                        6  /* DC2_TRIM - [11:6] */
+#define WM831X_DC2_TRIM_WIDTH                        6  /* DC2_TRIM - [11:6] */
+#define WM831X_DC1_TRIM_MASK                    0x003F  /* DC1_TRIM - [5:0] */
+#define WM831X_DC1_TRIM_SHIFT                        0  /* DC1_TRIM - [5:0] */
+#define WM831X_DC1_TRIM_WIDTH                        6  /* DC1_TRIM - [5:0] */
+
+/*
+ * R30730 (0x780A) - Factory OTP 2
+ */
+#define WM831X_CHIP_ID_MASK                     0xFFFF  /* CHIP_ID - [15:0] */
+#define WM831X_CHIP_ID_SHIFT                         0  /* CHIP_ID - [15:0] */
+#define WM831X_CHIP_ID_WIDTH                        16  /* CHIP_ID - [15:0] */
+
+/*
+ * R30731 (0x780B) - Factory OTP 3
+ */
+#define WM831X_OSC_TRIM_MASK                    0x0780  /* OSC_TRIM - [10:7] */
+#define WM831X_OSC_TRIM_SHIFT                        7  /* OSC_TRIM - [10:7] */
+#define WM831X_OSC_TRIM_WIDTH                        4  /* OSC_TRIM - [10:7] */
+#define WM831X_BG_TRIM_MASK                     0x0078  /* BG_TRIM - [6:3] */
+#define WM831X_BG_TRIM_SHIFT                         3  /* BG_TRIM - [6:3] */
+#define WM831X_BG_TRIM_WIDTH                         4  /* BG_TRIM - [6:3] */
+#define WM831X_LPBG_TRIM_MASK                   0x0007  /* LPBG_TRIM - [2:0] */
+#define WM831X_LPBG_TRIM_SHIFT                       0  /* LPBG_TRIM - [2:0] */
+#define WM831X_LPBG_TRIM_WIDTH                       3  /* LPBG_TRIM - [2:0] */
+
+/*
+ * R30732 (0x780C) - Factory OTP 4
+ */
+#define WM831X_CHILD_I2C_ADDR_MASK              0x00FE  /* CHILD_I2C_ADDR - [7:1] */
+#define WM831X_CHILD_I2C_ADDR_SHIFT                  1  /* CHILD_I2C_ADDR - [7:1] */
+#define WM831X_CHILD_I2C_ADDR_WIDTH                  7  /* CHILD_I2C_ADDR - [7:1] */
+#define WM831X_CH_AW                            0x0001  /* CH_AW */
+#define WM831X_CH_AW_MASK                       0x0001  /* CH_AW */
+#define WM831X_CH_AW_SHIFT                           0  /* CH_AW */
+#define WM831X_CH_AW_WIDTH                           1  /* CH_AW */
+
+/*
+ * R30733 (0x780D) - Factory OTP 5
+ */
+#define WM831X_CHARGE_TRIM_MASK                 0x003F  /* CHARGE_TRIM - [5:0] */
+#define WM831X_CHARGE_TRIM_SHIFT                     0  /* CHARGE_TRIM - [5:0] */
+#define WM831X_CHARGE_TRIM_WIDTH                     6  /* CHARGE_TRIM - [5:0] */
+
+/*
+ * R30736 (0x7810) - Customer OTP ID
+ */
+#define WM831X_OTP_AUTO_PROG                    0x8000  /* OTP_AUTO_PROG */
+#define WM831X_OTP_AUTO_PROG_MASK               0x8000  /* OTP_AUTO_PROG */
+#define WM831X_OTP_AUTO_PROG_SHIFT                  15  /* OTP_AUTO_PROG */
+#define WM831X_OTP_AUTO_PROG_WIDTH                   1  /* OTP_AUTO_PROG */
+#define WM831X_OTP_CUST_ID_MASK                 0x7FFE  /* OTP_CUST_ID - [14:1] */
+#define WM831X_OTP_CUST_ID_SHIFT                     1  /* OTP_CUST_ID - [14:1] */
+#define WM831X_OTP_CUST_ID_WIDTH                    14  /* OTP_CUST_ID - [14:1] */
+#define WM831X_OTP_CUST_FINAL                   0x0001  /* OTP_CUST_FINAL */
+#define WM831X_OTP_CUST_FINAL_MASK              0x0001  /* OTP_CUST_FINAL */
+#define WM831X_OTP_CUST_FINAL_SHIFT                  0  /* OTP_CUST_FINAL */
+#define WM831X_OTP_CUST_FINAL_WIDTH                  1  /* OTP_CUST_FINAL */
+
+/*
+ * R30759 (0x7827) - DBE CHECK DATA
+ */
+#define WM831X_DBE_VALID_DATA_MASK              0xFFFF  /* DBE_VALID_DATA - [15:0] */
+#define WM831X_DBE_VALID_DATA_SHIFT                  0  /* DBE_VALID_DATA - [15:0] */
+#define WM831X_DBE_VALID_DATA_WIDTH                 16  /* DBE_VALID_DATA - [15:0] */
+
+
+#endif
-- 
1.6.3.3

