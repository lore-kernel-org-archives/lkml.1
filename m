Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZDWSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZDWSLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbZDWSLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:11:00 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:33447 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZDWSK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:10:58 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com,
       Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2] Maxim 1586 regulator driver
Date: Thu, 23 Apr 2009 20:10:43 +0200
Message-Id: <1240510243-28969-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Maxim 1586 regulator is a voltage regulator with 2
voltage outputs, specially suitable for Marvell PXA
chips. One output is in the range of required VCC_CORE by
the PXA27x chips, the other in the VCC_USIM required as well
by PXA27x chips.

The chip is controlled through the I2C bus.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/regulator/Kconfig         |    8 ++
 drivers/regulator/Makefile        |    1 +
 drivers/regulator/max1586.c       |  249 +++++++++++++++++++++++++++++++++++++
 include/linux/regulator/max1586.h |   52 ++++++++
 4 files changed, 310 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/max1586.c
 create mode 100644 include/linux/regulator/max1586.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index e58c0ce..72f0ae1 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -56,6 +56,14 @@ config REGULATOR_BQ24022
 	  charging select between 100 mA and 500 mA charging current
 	  limit.
 
+config REGULATOR_MAX1586
+	tristate "Maxim 1586/1587 voltage regulator"
+	default n
+	help
+	  This driver controls a Maxim 1586 or 1587 voltage output
+	  regulator via I2C bus. The provided regulator is suitable
+	  for PXA27x chips to control VCC_CORE and VCC_USIM voltages.
+
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TPS695x0 PMIC"
 	depends on TWL4030_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index bac133a..1d7de87 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
+obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
new file mode 100644
index 0000000..bbbb55f
--- /dev/null
+++ b/drivers/regulator/max1586.c
@@ -0,0 +1,249 @@
+/*
+ * max1586.c  --  Voltage and current regulation for the Maxim 1586
+ *
+ * Copyright (C) 2008 Robert Jarzmik
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
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
+#include <linux/regulator/max1586.h>
+
+#define MAX1586_V3_MAX_VSEL 31
+#define MAX1586_V6_MAX_VSEL 3
+
+#define MAX1586_V3_MIN_UV   700000
+#define MAX1586_V3_MAX_UV  1475000
+#define MAX1586_V3_STEP_UV   25000
+
+#define MAX1586_V6_MIN_UV        0
+#define MAX1586_V6_MAX_UV  3000000
+
+#define I2C_V3_SELECT (0 << 5)
+#define I2C_V6_SELECT (1 << 5)
+
+/*
+ * V3 voltage
+ * On I2C bus, sending a "x" byte to the max1586 means :
+ *   set V3 to 0.700V + (x & 0x1f) * 0.025V
+ */
+static int max1586_v3_calc_voltage(unsigned selector)
+{
+	return MAX1586_V3_MIN_UV + (MAX1586_V3_STEP_UV * selector);
+}
+
+static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+	struct i2c_client *client = rdev_get_drvdata(rdev);
+	unsigned selector;
+	u8 v3_prog;
+
+	if (min_uV < MAX1586_V3_MIN_UV || min_uV > MAX1586_V3_MAX_UV)
+		return -EINVAL;
+	if (max_uV < MAX1586_V3_MIN_UV || max_uV > MAX1586_V3_MAX_UV)
+		return -EINVAL;
+
+	selector = (min_uV - MAX1586_V3_MIN_UV) / MAX1586_V3_STEP_UV;
+	if (max1586_v3_calc_voltage(selector) > max_uV)
+		return -EINVAL;
+
+	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
+		max1586_v3_calc_voltage(selector) / 1000);
+
+	v3_prog = I2C_V3_SELECT | (u8) selector;
+	return i2c_smbus_write_byte(client, v3_prog);
+}
+
+static int max1586_v3_list(struct regulator_dev *rdev, unsigned selector)
+{
+	if (selector > MAX1586_V3_MAX_VSEL)
+		return -EINVAL;
+	return max1586_v3_calc_voltage(selector);
+}
+
+/*
+ * V6 voltage
+ * On I2C bus, sending a "x" byte to the max1586 means :
+ *   set V6 to either 0V, 1.8V, 2.5V, 3V depending on (x & 0x3)
+ * As regulator framework doesn't accept voltages to be 0V, we use 1uV.
+ */
+static int max1586_v6_calc_voltage(unsigned selector)
+{
+	static int voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
+
+	return voltages_uv[selector];
+}
+
+static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+	struct i2c_client *client = rdev_get_drvdata(rdev);
+	unsigned selector;
+	u8 v6_prog;
+
+	if (min_uV < MAX1586_V6_MIN_UV || min_uV > MAX1586_V6_MAX_UV)
+		return -EINVAL;
+	if (max_uV < MAX1586_V6_MIN_UV || max_uV > MAX1586_V6_MAX_UV)
+		return -EINVAL;
+
+	if (min_uV >= 3000000)
+		selector = 3;
+	if (min_uV < 3000000)
+		selector = 2;
+	if (min_uV < 2500000)
+		selector = 1;
+	if (min_uV < 1800000)
+		selector = 0;
+
+	if (max1586_v6_calc_voltage(selector) > max_uV)
+		return -EINVAL;
+
+	dev_dbg(&client->dev, "changing voltage v6 to %dmv\n",
+		max1586_v6_calc_voltage(selector) / 1000);
+
+	v6_prog = I2C_V6_SELECT | (u8) selector;
+	return i2c_smbus_write_byte(client, v6_prog);
+}
+
+static int max1586_v6_list(struct regulator_dev *rdev, unsigned selector)
+{
+	if (selector > MAX1586_V6_MAX_VSEL)
+		return -EINVAL;
+	return max1586_v6_calc_voltage(selector);
+}
+
+/*
+ * The Maxim 1586 controls V3 and V6 voltages, but offers no way of reading back
+ * the set up value.
+ */
+static struct regulator_ops max1586_v3_ops = {
+	.set_voltage = max1586_v3_set,
+	.list_voltage = max1586_v3_list,
+};
+
+static struct regulator_ops max1586_v6_ops = {
+	.set_voltage = max1586_v6_set,
+	.list_voltage = max1586_v6_list,
+};
+
+static struct regulator_desc max1586_reg[] = {
+	{
+		.name = "Output_V3",
+		.id = MAX1586_V3,
+		.ops = &max1586_v3_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = MAX1586_V3_MAX_VSEL + 1,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "Output_V6",
+		.id = MAX1586_V6,
+		.ops = &max1586_v6_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = MAX1586_V6_MAX_VSEL + 1,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int max1586_pmic_probe(struct i2c_client *client,
+			      const struct i2c_device_id *i2c_id)
+{
+	struct regulator_dev **rdev;
+	struct max1586_platform_data *pdata = client->dev.platform_data;
+	int i, id, ret = 0;
+
+	rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
+		       GFP_KERNEL);
+	if (!rdev)
+		return -ENOMEM;
+
+	ret = -EINVAL;
+	for (i = 0; i < pdata->num_subdevs && i <= MAX1586_V6; i++) {
+		id = pdata->subdevs[i].id;
+		if (!pdata->subdevs[i].platform_data)
+			continue;
+		if (id < MAX1586_V3 || id > MAX1586_V6) {
+			dev_err(&client->dev, "invalid regulator id %d\n", id);
+			goto err;
+		}
+		rdev[i] = regulator_register(&max1586_reg[id], &client->dev,
+					     pdata->subdevs[i].platform_data,
+					     client);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(&client->dev, "failed to register %s\n",
+				max1586_reg[id].name);
+			goto err;
+		}
+	}
+
+	i2c_set_clientdata(client, rdev);
+	dev_info(&client->dev, "Maxim 1586 regulator driver loaded\n");
+	return 0;
+
+err:
+	while (--i >= 0)
+		regulator_unregister(rdev[i]);
+	kfree(rdev);
+	return ret;
+}
+
+static int max1586_pmic_remove(struct i2c_client *client)
+{
+	struct regulator_dev **rdev = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i <= MAX1586_V6; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+	kfree(rdev);
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static const struct i2c_device_id max1586_id[] = {
+	{ "max1586", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max1586_id);
+
+static struct i2c_driver max1586_pmic_driver = {
+	.probe = max1586_pmic_probe,
+	.remove = max1586_pmic_remove,
+	.driver		= {
+		.name	= "max1586",
+	},
+	.id_table	= max1586_id,
+};
+
+static int __init max1586_pmic_init(void)
+{
+	return i2c_add_driver(&max1586_pmic_driver);
+}
+subsys_initcall(max1586_pmic_init);
+
+static void __exit max1586_pmic_exit(void)
+{
+	i2c_del_driver(&max1586_pmic_driver);
+}
+module_exit(max1586_pmic_exit);
+
+/* Module information */
+MODULE_DESCRIPTION("MAXIM 1586 voltage regulator driver");
+MODULE_AUTHOR("Robert Jarzmik");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/max1586.h b/include/linux/regulator/max1586.h
new file mode 100644
index 0000000..2056973
--- /dev/null
+++ b/include/linux/regulator/max1586.h
@@ -0,0 +1,52 @@
+/*
+ * max1586.h  --  Voltage regulation for the Maxim 1586
+ *
+ * Copyright (C) 2008 Robert Jarzmik
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
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
+#ifndef REGULATOR_MAX1586
+#define REGULATOR_MAX1586
+
+#include <linux/regulator/machine.h>
+
+#define MAX1586_V3 0
+#define MAX1586_V6 1
+
+/**
+ * max1586_subdev_data - regulator data
+ * @id: regulator Id (either MAX1586_V3 or MAX1586_V6)
+ * @name: regulator cute name (example for V3: "vcc_core")
+ * @platform_data: regulator init data (contraints, supplies, ...)
+ */
+struct max1586_subdev_data {
+	int				id;
+	char				*name;
+	struct regulator_init_data	*platform_data;
+};
+
+/**
+ * max1586_platform_data - platform data for max1586
+ * @num_subdevs: number of regultors used (may be 1 or 2)
+ * @subdevs: regulator used
+ *           At most, there will be a regulator for V3 and one for V6 voltages.
+ */
+struct max1586_platform_data {
+	int num_subdevs;
+	struct max1586_subdev_data *subdevs;
+};
+
+#endif
-- 
1.6.2.1

