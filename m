Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZIVNTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZIVNTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZIVNTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:19:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33857 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZIVNTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:19:01 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC] regulator: add driver for MAX8660/8661
Date: Tue, 22 Sep 2009 15:18:19 +0200
Message-Id: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** Not intended to be merged yet ***

Here is my current, already working version for a MAX8660 regulator driver. See
the documentation for some notes. I'm still undecided if merging the functions
for the different regulator types into more generic functions should be done
before finishing the other todos; it looks a bit crowded this way. Some details
are still a bit hackish, I'm hoping for some general comments about the way
things are done here. Thanks in advance! :)

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>

---
 Documentation/power/regulator/max8660.txt |   32 ++
 drivers/regulator/Kconfig                 |    7 +
 drivers/regulator/Makefile                |    1 +
 drivers/regulator/max8660.c               |  471 +++++++++++++++++++++++++++++
 include/linux/regulator/max8660.h         |   57 ++++
 5 files changed, 568 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/regulator/max8660.txt
 create mode 100644 drivers/regulator/max8660.c
 create mode 100644 include/linux/regulator/max8660.h

diff --git a/Documentation/power/regulator/max8660.txt b/Documentation/power/regulator/max8660.txt
new file mode 100644
index 0000000..143a0c0
--- /dev/null
+++ b/Documentation/power/regulator/max8660.txt
@@ -0,0 +1,32 @@
+MAX8660/8661 Regulator Driver for Linux 2.6
+===========================================
+
+Datasheet
+---------
+
+http://datasheets.maxim-ic.com/en/ds/MAX8660-MAX8661.pdf
+
+Comments
+--------
+
+This chip is a bit nasty because it is a write-only device. Thus, the driver
+uses shadow registers to keep track of its values. The main problem appears to
+be the initialization: When Linux boots up, we cannot know if the chip is in
+the default state or not, so we would have to pass such information in
+platform_data. As this adds a bit of complexity to the driver, this is left
+out for now until it is really needed.
+
+The Target Voltage 2 Registers for V3, V4 and V5 are not used by this driver.
+
+Note that disabling V3 or V4 has no effect if pin EN34 is driven high (pin and
+register are ORed, see datasheet).
+
+TO DO:
+------
+
+- Accept inital values other than the default ones
+- Make use of the forced PWM modes?
+- ARD?
+- If all todo-items are implemented, check if one set of functions for V3-V7 is
+  sufficent. For maximum flexibility during development, they are seperated for
+  now.
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..e2d8eb2 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -75,6 +75,13 @@ config REGULATOR_MAX1586
 	  regulator via I2C bus. The provided regulator is suitable
 	  for PXA27x chips to control VCC_CORE and VCC_USIM voltages.
 
+config REGULATOR_MAX8660
+	tristate "Maxim 8660/8661 voltage regulator"
+	depends on I2C
+	help
+	  This driver controls a Maxim 8660/8661 voltage output
+	  regulator via I2C bus.
+
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TPS695x0 PMIC"
 	depends on TWL4030_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4d762c4..da57e3e 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
+obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
new file mode 100644
index 0000000..d8c0b4d
--- /dev/null
+++ b/drivers/regulator/max8660.c
@@ -0,0 +1,471 @@
+/*
+ * max8660.c  --  Voltage regulation for the Maxim 8660/8661
+ *
+ * based on max1586.c and wm8400-regulator.c
+ *
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix e.K.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/max8660.h>
+
+
+#define MAX8660_DCDC_MIN_UV	 725000
+#define MAX8660_DCDC_MAX_UV	1800000
+#define MAX8660_DCDC_STEP	  25000
+#define MAX8660_DCDC_MAX_SEL	0x2b
+
+#define MAX8660_LDO5_MIN_UV	1700000
+#define MAX8660_LDO5_MAX_UV	2000000
+#define MAX8660_LDO5_STEP	  25000
+#define MAX8660_LDO5_MAX_SEL	0x0c
+
+#define MAX8660_LDO67_MIN_UV	1800000
+#define MAX8660_LDO67_MAX_UV	3300000
+#define MAX8660_LDO67_STEP	 100000
+#define MAX8660_LDO67_MAX_SEL	0x0f
+
+enum {
+	MAX8660_OVER1,
+	MAX8660_OVER2,
+	MAX8660_VCC1,
+	MAX8660_ADTV1,
+	MAX8660_ADTV2,
+	MAX8660_SDTV1,
+	MAX8660_SDTV2,
+	MAX8660_MDTV1,
+	MAX8660_MDTV2,
+	MAX8660_L12VCR,
+	MAX8660_FPWM,
+	MAX8660_N_REGS,	/* not a real register */
+};
+
+struct max8660 {
+	struct i2c_client *client;
+	u8 shadow_regs[MAX8660_N_REGS];		/* as chip is write only */
+	struct regulator_dev *rdev[0];
+};
+
+static int max8660_write(struct max8660 *max8660, u8 reg, u8 mask, u8 val)
+{
+	static const u8 max8660_addresses[MAX8660_N_REGS] =
+	  { 0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };
+
+	int ret;
+	u8 reg_val = (max8660->shadow_regs[reg] & mask) | val;
+	dev_dbg(&max8660->client->dev, "Writing reg %02x with %02x\n",
+			max8660_addresses[reg], reg_val);
+	ret = i2c_smbus_write_byte_data(max8660->client,
+			max8660_addresses[reg], reg_val);
+	if (ret == 0)
+		max8660->shadow_regs[reg] = reg_val;
+
+	return ret;
+}
+
+
+/*
+ * DCDC functions
+ */
+
+static int max8660_dcdc_is_enabled(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 val = max8660->shadow_regs[MAX8660_OVER1];
+	u8 mask = (rdev_get_id(rdev) == MAX8660_V3) ? 1 : 4;
+	return !!(val & mask);
+}
+
+static int max8660_dcdc_enable(struct regulator_dev *rdev)
+{
+	int ret;
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 val = (rdev_get_id(rdev) == MAX8660_V3) ? 1 : 4;
+	ret = max8660_write(max8660, MAX8660_OVER1, 0xff, val);
+	val = (rdev_get_id(rdev) == MAX8660_V3) ? 0x03 : 0x30;
+	return (ret != 0) ? :
+		max8660_write(max8660, MAX8660_VCC1, ~val, val & 0x11);
+}
+
+static int max8660_dcdc_disable(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 mask = (rdev_get_id(rdev) == MAX8660_V3) ? ~1 : ~4;
+	return max8660_write(max8660, MAX8660_OVER1, mask, 0);
+}
+
+static int max8660_dcdc_list(struct regulator_dev *rdev, unsigned selector)
+{
+	if (selector > MAX8660_DCDC_MAX_SEL)
+		return -EINVAL;
+	return MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP;
+}
+
+static int max8660_dcdc_get(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 reg = (rdev_get_id(rdev) == MAX8660_V3) ? MAX8660_ADTV1 : MAX8660_SDTV1;
+	u8 selector = max8660->shadow_regs[reg];
+	return MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP;
+}
+
+static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 reg, selector;
+
+	if (min_uV < MAX8660_DCDC_MIN_UV || min_uV > MAX8660_DCDC_MAX_UV)
+		return -EINVAL;
+	if (max_uV < MAX8660_DCDC_MIN_UV || max_uV > MAX8660_DCDC_MAX_UV)
+		return -EINVAL;
+
+	reg = (rdev_get_id(rdev) == MAX8660_V3) ? MAX8660_ADTV1 : MAX8660_SDTV1;
+	selector = (min_uV - (MAX8660_DCDC_MIN_UV - MAX8660_DCDC_STEP + 1))
+			/ MAX8660_DCDC_STEP;
+
+	if (MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP > max_uV)
+		return -EINVAL;
+
+	return max8660_write(max8660, reg, 0, selector);
+}
+
+static struct regulator_ops max8660_dcdc_ops = {
+	.is_enabled = max8660_dcdc_is_enabled,
+	.enable = max8660_dcdc_enable,
+	.disable = max8660_dcdc_disable,
+	.list_voltage = max8660_dcdc_list,
+	.set_voltage = max8660_dcdc_set,
+	.get_voltage = max8660_dcdc_get,
+};
+
+
+/*
+ * LDO5 functions
+ */
+
+static int max8660_ldo5_list(struct regulator_dev *rdev, unsigned selector)
+{
+	if (selector > MAX8660_LDO5_MAX_SEL)
+		return -EINVAL;
+	return MAX8660_LDO5_MIN_UV + selector * MAX8660_LDO5_STEP;
+}
+
+static int max8660_ldo5_get(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 selector = max8660->shadow_regs[MAX8660_MDTV1];
+
+	return MAX8660_LDO5_MIN_UV + selector * MAX8660_LDO5_STEP;
+}
+
+static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 selector;
+	int ret;
+
+	if (min_uV < MAX8660_LDO5_MIN_UV || min_uV > MAX8660_LDO5_MAX_UV)
+		return -EINVAL;
+	if (max_uV < MAX8660_LDO5_MIN_UV || max_uV > MAX8660_LDO5_MAX_UV)
+		return -EINVAL;
+
+	selector = (min_uV - (MAX8660_LDO5_MIN_UV - MAX8660_LDO5_STEP + 1))
+			/ MAX8660_LDO5_STEP;
+	if (MAX8660_LDO5_MIN_UV + selector * MAX8660_LDO5_STEP > max_uV)
+		return -EINVAL;
+
+	ret = max8660_write(max8660, MAX8660_MDTV1, 0, selector);
+	if (ret)
+		return ret;
+	return max8660_write(max8660, MAX8660_VCC1, 0x3f, 0x40);
+}
+
+static struct regulator_ops max8660_ldo5_ops = {
+	.list_voltage = max8660_ldo5_list,
+	.set_voltage = max8660_ldo5_set,
+	.get_voltage = max8660_ldo5_get,
+};
+
+
+/*
+ * LDO67 functions
+ */
+
+static int max8660_ldo67_is_enabled(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 val = max8660->shadow_regs[MAX8660_OVER2];
+	u8 mask = (rdev_get_id(rdev) == MAX8660_V6) ? 2 : 4;
+	return !!(val & mask);
+}
+
+static int max8660_ldo67_enable(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 bit = (rdev_get_id(rdev) == MAX8660_V6) ? 2 : 4;
+	return max8660_write(max8660, MAX8660_OVER2, 0xff, bit);
+}
+
+static int max8660_ldo67_disable(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 mask = (rdev_get_id(rdev) == MAX8660_V6) ? ~2 : ~4;
+	return max8660_write(max8660, MAX8660_OVER2, mask, 0);
+}
+
+static int max8660_ldo67_list(struct regulator_dev *rdev, unsigned selector)
+{
+	if (selector > MAX8660_LDO67_MAX_SEL)
+		return -EINVAL;
+	return MAX8660_LDO67_MIN_UV + selector * MAX8660_LDO67_STEP;
+}
+
+static int max8660_ldo67_get(struct regulator_dev *rdev)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 shift = (rdev_get_id(rdev) == MAX8660_V6) ? 0 : 4;
+	u8 selector = (max8660->shadow_regs[MAX8660_L12VCR] >> shift) & 0xf;
+
+	return MAX8660_LDO67_MIN_UV + selector * MAX8660_LDO67_STEP;
+}
+
+static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+	u8 selector;
+
+	if (min_uV < MAX8660_LDO67_MIN_UV || min_uV > MAX8660_LDO67_MAX_UV)
+		return -EINVAL;
+	if (max_uV < MAX8660_LDO67_MIN_UV || max_uV > MAX8660_LDO67_MAX_UV)
+		return -EINVAL;
+
+	selector = (min_uV - (MAX8660_LDO67_MIN_UV - MAX8660_LDO67_STEP + 1))
+			/ MAX8660_LDO67_STEP;
+
+	if (MAX8660_LDO67_MIN_UV + selector * MAX8660_LDO67_STEP > max_uV)
+		return -EINVAL;
+
+	if (rdev_get_id(rdev) == MAX8660_V6)
+		return max8660_write(max8660, MAX8660_L12VCR, 0xf0, selector);
+	else
+		return max8660_write(max8660, MAX8660_L12VCR, 0x0f, selector << 4);
+}
+
+static struct regulator_ops max8660_ldo67_ops = {
+	.is_enabled = max8660_ldo67_is_enabled,
+	.enable = max8660_ldo67_enable,
+	.disable = max8660_ldo67_disable,
+	.list_voltage = max8660_ldo67_list,
+	.get_voltage = max8660_ldo67_get,
+	.set_voltage = max8660_ldo67_set,
+};
+
+static struct regulator_desc max8660_reg[] = {
+	{
+		.name = "V3(DCDC)",
+		.id = MAX8660_V3,
+		.ops = &max8660_dcdc_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = MAX8660_DCDC_MAX_SEL + 1,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "V4(DCDC)",
+		.id = MAX8660_V4,
+		.ops = &max8660_dcdc_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = MAX8660_DCDC_MAX_SEL + 1,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "V5(LDO)",
+		.id = MAX8660_V5,
+		.ops = &max8660_ldo5_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = MAX8660_LDO5_MAX_SEL + 1,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "V6(LDO)",
+		.id = MAX8660_V6,
+		.ops = &max8660_ldo67_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = MAX8660_LDO67_MAX_SEL + 1,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "V7(LDO)",
+		.id = MAX8660_V7,
+		.ops = &max8660_ldo67_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = MAX8660_LDO67_MAX_SEL + 1,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int max8660_probe(struct i2c_client *client,
+			      const struct i2c_device_id *i2c_id)
+{
+	struct regulator_dev **rdev;
+	struct max8660_platform_data *pdata = client->dev.platform_data;
+	struct max8660 *max8660;
+	int boot_on, i, id, ret = -EINVAL;
+
+	if (pdata->num_subdevs > MAX8660_V_END) {
+		dev_err(&client->dev, "Too much regulators found!\n");
+		goto out;
+	}
+
+	max8660 = kzalloc(sizeof(struct max8660) +
+			sizeof(struct regulator_dev *) * MAX8660_V_END,
+			GFP_KERNEL);
+	if (!max8660) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	max8660->client = client;
+	rdev = max8660->rdev;
+
+	/* First loop sets up shadow registers to prevent glitches */
+	max8660->shadow_regs[MAX8660_ADTV1] =
+		max8660->shadow_regs[MAX8660_ADTV2] =
+		max8660->shadow_regs[MAX8660_SDTV1] =
+		max8660->shadow_regs[MAX8660_SDTV2] = 0x1b;
+	max8660->shadow_regs[MAX8660_MDTV1] =
+		max8660->shadow_regs[MAX8660_MDTV2] = 0x04;
+
+	for (i = 0; i < pdata->num_subdevs; i++) {
+
+		if (!pdata->subdevs[i].platform_data)
+			goto err_free;
+
+		boot_on = pdata->subdevs[i].platform_data->constraints.boot_on;
+
+		switch (pdata->subdevs[i].id) {
+		case MAX8660_V3:
+			if (boot_on)
+				max8660->shadow_regs[MAX8660_OVER1] |= 1;
+			break;
+
+		case MAX8660_V4:
+			if (boot_on)
+				max8660->shadow_regs[MAX8660_OVER1] |= 4;
+			break;
+
+		case MAX8660_V5:
+			break;
+
+		case MAX8660_V6:
+			if (boot_on)
+				max8660->shadow_regs[MAX8660_OVER2] |= 2;
+			break;
+
+		case MAX8660_V7:
+			if (!strcmp(i2c_id->name, "max8661")) {
+				dev_err(&client->dev, "Regulator not on this chip!\n");
+				goto err_free;
+			}
+
+			if (boot_on)
+				max8660->shadow_regs[MAX8660_OVER2] |= 4;
+			break;
+
+		default:
+			dev_err(&client->dev, "invalid regulator %s\n",
+				 pdata->subdevs[i].name);
+			goto err_free;
+		}
+	}
+
+	/* Second loop finally registers devices */
+	for (i = 0; i < pdata->num_subdevs; i++) {
+
+		id = pdata->subdevs[i].id;
+
+		rdev[i] = regulator_register(&max8660_reg[id], &client->dev,
+					     pdata->subdevs[i].platform_data,
+					     max8660);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(&client->dev, "failed to register %s\n",
+				max8660_reg[id].name);
+			goto err_unregister;
+		}
+	}
+
+	i2c_set_clientdata(client, rdev);
+	dev_info(&client->dev, "Maxim 8660/8661 regulator driver loaded\n");
+	return 0;
+
+err_unregister:
+	while (--i >= 0)
+		regulator_unregister(rdev[i]);
+err_free:
+	kfree(max8660);
+out:
+	return ret;
+}
+
+static int max8660_remove(struct i2c_client *client)
+{
+	struct regulator_dev **rdev = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < MAX8660_V_END; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+	kfree(rdev);
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static const struct i2c_device_id max8660_id[] = {
+	{ "max8660", 0 },
+	{ "max8661", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max8660_id);
+
+static struct i2c_driver max8660_driver = {
+	.probe = max8660_probe,
+	.remove = max8660_remove,
+	.driver		= {
+		.name	= "max8660",
+	},
+	.id_table	= max8660_id,
+};
+
+static int __init max8660_init(void)
+{
+	return i2c_add_driver(&max8660_driver);
+}
+subsys_initcall(max8660_init);
+
+static void __exit max8660_exit(void)
+{
+	i2c_del_driver(&max8660_driver);
+}
+module_exit(max8660_exit);
+
+/* Module information */
+MODULE_DESCRIPTION("MAXIM 8660/8661 voltage regulator driver");
+MODULE_AUTHOR("Wolfram Sang");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/max8660.h b/include/linux/regulator/max8660.h
new file mode 100644
index 0000000..b6542b1
--- /dev/null
+++ b/include/linux/regulator/max8660.h
@@ -0,0 +1,55 @@
+/*
+ * max8660.h  --  Voltage regulation for the Maxim 8660/8661
+ *
+ * Copyright (C) 2009 Wolfram Sang, Pengutronix e.K.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __LINUX_REGULATOR_MAX8660_H
+#define __LINUX_REGULATOR_MAX8660_H
+
+#include <linux/regulator/machine.h>
+
+enum {
+	MAX8660_V3,
+	MAX8660_V4,
+	MAX8660_V5,
+	MAX8660_V6,
+	MAX8660_V7,
+	MAX8660_V_END,
+};
+
+/**
+ * max8660_subdev_data - regulator subdev data
+ * @id: regulator id
+ * @name: regulator name
+ * @platform_data: regulator init data
+ */
+struct max8660_subdev_data {
+	int				id;
+	char				*name;
+	struct regulator_init_data	*platform_data;
+};
+
+/**
+ * max8660_platform_data - platform data for max8660
+ * @num_subdevs: number of regulators used
+ * @subdevs: regulators used
+ */
+struct max8660_platform_data {
+	int num_subdevs;
+	struct max8660_subdev_data *subdevs;
+};
+#endif
-- 
1.6.3.3

