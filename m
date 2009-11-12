Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbZKLHpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbZKLHpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZKLHpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:45:38 -0500
Received: from smtp.nokia.com ([192.100.122.233]:33734 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZKLHpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:45:32 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RFC PATCH 1/1] AMI305 magnetometer driver
Date: Thu, 12 Nov 2009 09:44:26 +0200
Message-Id: <1258011866-25972-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1258011866-25972-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1258011866-25972-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 12 Nov 2009 07:44:32.0306 (UTC) FILETIME=[F8F6E120:01CA636B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support for AMI305 / AK8974 magnetometer chips.
coordinates are provided as polled input device.
Selftest and noise filtering (polled input device fuzziness)
are provided via sysfs.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/misc/Kconfig       |   11 +
 drivers/misc/Makefile      |    1 +
 drivers/misc/ami305.c      |  644 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/ami305.h |   22 ++
 4 files changed, 678 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ami305.c
 create mode 100644 include/linux/i2c/ami305.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index df1f86b..d9d0efc 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -246,6 +246,17 @@ config EP93XX_PWM
 	  To compile this driver as a module, choose M here: the module will
 	  be called ep93xx_pwm.
 
+config AMI305
+	 tristate "AMI305";
+	 depends on I2C
+	 default n
+	 ---help---
+	   Say Y here if you want to build a driver for AMI305 magnetometer
+	   chip.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called ami305. If unsure, say N here.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f982d2e..bb5f969 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
+obj-$(CONFIG_AMI305)		+= ami305.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-y				+= eeprom/
 obj-y				+= cb710/
diff --git a/drivers/misc/ami305.c b/drivers/misc/ami305.c
new file mode 100644
index 0000000..ead0190
--- /dev/null
+++ b/drivers/misc/ami305.c
@@ -0,0 +1,644 @@
+/*
+ * ami305.c is driver for AMI305 (Aichi Steel) and
+ * AK8974 (Asahi Kasei EMD Corporation) magnetometer chip
+ *
+ * Copyright (C) 2009 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/i2c/ami305.h>
+#include <linux/input-polldev.h>
+
+#define DRV_NAME "ami305"
+
+/*
+ * 16-bit registers are little-endian. LSB is at the address defined below
+ * and MSB is at the next higher address.
+ */
+#define AMI305_SELFTEST		0x0C
+#define AMI305_INFO		0x0D
+#define AMI305_WHOAMI		0x0F
+#define AMI305_DATA_X		0x10
+#define AMI305_DATA_Y		0x12
+#define AMI305_DATA_Z		0x14
+#define AMI305_INT_SRC		0x16
+#define AMI305_STATUS		0x18
+#define AMI305_INT_CLEAR	0x1A
+#define AMI305_CTRL1		0x1B
+#define AMI305_CTRL2		0x1C
+#define AMI305_CTRL3		0x1D
+#define AMI305_INT_CTRL		0x1E
+#define AMI305_OFFSET_X		0x20
+#define AMI305_OFFSET_Y		0x22
+#define AMI305_OFFSET_Z		0x24
+#define AMI305_INT_THRES	0x26  /* absolute any axis value threshold */
+#define AMI305_PRESET		0x30
+#define AMI305_TEMP		0x31
+
+#define AMI305_SELFTEST_IDLE	0x55
+#define AMI305_SELFTEST_OK	0xAA
+
+#define AMI305_WHOAMI_VALUE_AMI305 0x47
+#define AMI305_WHOAMI_VALUE_AK8974 0x48
+
+#define AMI305_INT_X_HIGH	0x80  /* Axis over +threshold  */
+#define AMI305_INT_Y_HIGH	0x40
+#define AMI305_INT_Z_HIGH	0x20
+#define AMI305_INT_X_LOW	0x10  /* Axis below -threshold	*/
+#define AMI305_INT_Y_LOW	0x08
+#define AMI305_INT_Z_LOW	0x04
+#define AMI305_INT_RANGE	0x02  /* Range overflow (any axis)   */
+
+#define AMI305_STATUS_DRDY	0x40  /* Data ready	    */
+#define AMI305_STATUS_OVERRUN	0x20  /* Data overrun	    */
+#define AMI305_STATUS_INT	0x10  /* Interrupt occurred */
+
+#define AMI305_CTRL1_POWER	0x80  /* 0 = standby; 1 = active */
+#define AMI305_CTRL1_RATE	0x10  /* 0 = 10 Hz;   1 = 20 Hz	 */
+#define AMI305_CTRL1_FORCE_EN	0x02  /* 0 = normal;  1 = force	 */
+#define AMI305_CTRL1_MODE2	0x01  /* 0 */
+
+#define AMI305_CTRL2_INT_EN	0x10  /* 1 = enable interrupts	      */
+#define AMI305_CTRL2_DRDY_EN	0x08  /* 1 = enable data ready signal */
+#define AMI305_CTRL2_DRDY_POL	0x04  /* 1 = data ready active high   */
+
+#define AMI305_CTRL3_RESET	0x80  /* Software reset		  */
+#define AMI305_CTRL3_FORCE	0x40  /* Start forced measurement */
+#define AMI305_CTRL3_SELFTEST	0x10  /* Set selftest register	  */
+
+#define AMI305_INT_CTRL_XEN	0x80  /* Enable interrupt for this axis */
+#define AMI305_INT_CTRL_YEN	0x40
+#define AMI305_INT_CTRL_ZEN	0x20
+#define AMI305_INT_CTRL_XYZEN	0xE0
+#define AMI305_INT_CTRL_POL	0x08  /* 0 = active low; 1 = active high     */
+#define AMI305_INT_CTRL_PULSE	0x02  /* 0 = latched;	 1 = pulse (50 usec) */
+
+#define AMI305_MAX_RANGE	2048
+#define AMI305_THRESHOLD_MAX	(AMI305_MAX_RANGE - 1)
+
+#define AMI305_POLL_INTERVAL	100   /* ms */
+#define AMI305_ACTIVATE_DELAY	1     /* ms */
+#define AMI305_DEFAULT_FUZZ	3     /* input noise filtering */
+#define AMI305_MEAS_DELAY	6     /* one measurement in ms */
+#define AMI305_SELFTEST_DELAY	1     /* ms. Spec says 200us min */
+#define AMI305_RESET_DELAY	5     /* ms */
+
+#define AMI305_PWR_ON		1
+#define AMI305_PWR_OFF		0
+
+#define AMI305_MAX_TRY		2
+
+struct ami305_chip {
+	struct mutex		lock;	/* Serialize access to chip */
+	struct mutex		users_lock;
+	struct i2c_client	*client;
+	struct input_polled_dev *idev;	   /* input device */
+
+	int			max_range;
+	int			users;
+	int			fuzz;
+
+	s16			x, y, z; /* Latest measurements */
+	s8			axis_x;
+	s8			axis_y;
+	s8			axis_z;
+};
+
+static int ami305_write(struct ami305_chip *chip, u8 reg, u8 data)
+{
+	return i2c_smbus_write_byte_data(chip->client, reg, data);
+}
+
+static int ami305_read(struct ami305_chip *chip, u8 reg)
+{
+	return i2c_smbus_read_byte_data(chip->client, reg);
+}
+
+static int ami305_read_block(struct ami305_chip *chip, u8 reg,
+			     u8 *data, u8 length)
+{
+	s32 result;
+	result = i2c_smbus_read_i2c_block_data(chip->client,
+				reg, length, data);
+	return result;
+}
+
+static int ami305_power(struct ami305_chip *chip, int poweron)
+{
+	int r, v;
+
+	v = poweron ? AMI305_CTRL1_POWER : 0;
+	v = v | AMI305_CTRL1_FORCE_EN;
+	r = ami305_write(chip, AMI305_CTRL1, v);
+	if (r < 0)
+		return r;
+
+	if (poweron)
+		msleep(AMI305_ACTIVATE_DELAY);
+
+	return 0;
+}
+
+static int ami305_start_measurement(struct ami305_chip *chip)
+{
+	int ctrl3;
+	int ret = 0;
+
+	ctrl3 = ami305_read(chip, AMI305_CTRL3);
+	if (ctrl3 < 0)
+		return ctrl3;
+
+	ret = ami305_write(chip, AMI305_CTRL3, ctrl3 | AMI305_CTRL3_FORCE);
+
+	return ret;
+}
+
+static int ami305_reset(struct ami305_chip *chip)
+{
+	int r = 0;
+
+	/* Power on to get register access */
+	r = ami305_power(chip, AMI305_PWR_ON);
+	if (r < 0)
+		goto fail;
+
+	r = ami305_write(chip, AMI305_CTRL3, AMI305_CTRL3_RESET);
+	if (r < 0)
+		goto fail;
+
+	msleep(AMI305_RESET_DELAY);
+fail:
+	return r;
+}
+
+static int ami305_add_users(struct ami305_chip *chip)
+{
+	int r = 0;
+
+	mutex_lock(&chip->users_lock);
+
+	if (chip->users == 0) {
+		r = ami305_power(chip, AMI305_PWR_ON);
+		if (r < 0)
+			goto fail;
+	}
+	chip->users++;
+fail:
+	mutex_unlock(&chip->users_lock);
+	return r;
+}
+
+static int ami305_remove_users(struct ami305_chip *chip)
+{
+	int r = 0;
+
+	mutex_lock(&chip->users_lock);
+
+	if (chip->users != 0)
+		chip->users--;
+
+	if (chip->users == 0) {
+		r = ami305_power(chip, AMI305_PWR_OFF);
+		if (r < 0)
+			goto fail;
+	}
+fail:
+	mutex_unlock(&chip->users_lock);
+	return r;
+}
+
+static int ami305_configure(struct ami305_chip *chip)
+{
+	int err;
+
+	ami305_reset(chip);
+
+	ami305_add_users(chip);
+
+	err = ami305_write(chip, AMI305_CTRL2, AMI305_CTRL2_DRDY_EN);
+	if (err)
+		goto fail;
+
+	err = ami305_write(chip, AMI305_CTRL3, 0);
+	if (err)
+		goto fail;
+
+	err = ami305_write(chip, AMI305_INT_CTRL, AMI305_INT_CTRL_POL);
+	if (err)
+		goto fail;
+
+	err = ami305_write(chip, AMI305_PRESET, 0);
+	if (err)
+		goto fail;
+
+fail:
+	ami305_remove_users(chip);
+
+	return err;
+}
+
+static int ami305_get_axis(s8 axis, s16 hw_values[3])
+{
+	if (axis > 0)
+		return hw_values[axis - 1];
+	else
+		return -hw_values[-axis - 1];
+}
+
+static int ami305_read_values(struct ami305_chip *chip)
+{
+	s16 hw_values[3];
+	int i;
+
+	ami305_start_measurement(chip);
+
+	i = AMI305_MAX_TRY;
+	do {
+		msleep(AMI305_MEAS_DELAY);
+		if (ami305_read(chip, AMI305_STATUS) & AMI305_STATUS_DRDY)
+			break;
+		i--;
+	} while (i > 0);
+
+	if (i == 0)
+		return -ENODEV;
+
+	/* X, Y, Z are in conscutive addresses. 2 * 3 bytes */
+	ami305_read_block(chip, AMI305_DATA_X, (u8 *)hw_values, 6);
+
+	for (i = 0; i < 3; i++)
+		hw_values[i] = le16_to_cpu(hw_values[i]);
+
+	chip->x = ami305_get_axis(chip->axis_x, hw_values);
+	chip->y = ami305_get_axis(chip->axis_y, hw_values);
+	chip->z = ami305_get_axis(chip->axis_z, hw_values);
+
+	return 0;
+}
+
+static int ami305_selftest(struct ami305_chip *chip)
+{
+	int r;
+	int success = 0;
+
+	ami305_add_users(chip);
+
+	r = ami305_read(chip, AMI305_SELFTEST);
+	if (r != AMI305_SELFTEST_IDLE)
+		goto out;
+
+	r = ami305_read(chip, AMI305_CTRL3);
+	if (r < 0)
+		goto out;
+
+	r = ami305_write(chip, AMI305_CTRL3, r | AMI305_CTRL3_SELFTEST);
+	if (r < 0)
+		goto out;
+
+	msleep(AMI305_SELFTEST_DELAY);
+
+	r = ami305_read(chip, AMI305_SELFTEST);
+	if (r != AMI305_SELFTEST_OK)
+		goto out;
+
+	r = ami305_read(chip, AMI305_SELFTEST);
+	if (r == AMI305_SELFTEST_IDLE)
+		success = 1;
+
+ out:
+	ami305_remove_users(chip);
+
+	return success;
+}
+
+static void ami305_set_input_params(struct ami305_chip *chip, int fuzz)
+{
+	struct input_dev *input_dev = chip->idev->input;
+	int range;
+
+	range = chip->max_range;
+	input_set_abs_params(input_dev, ABS_X, -range, range, fuzz, 0);
+	input_set_abs_params(input_dev, ABS_Y, -range, range, fuzz, 0);
+	input_set_abs_params(input_dev, ABS_Z, -range, range, fuzz, 0);
+	chip->fuzz = fuzz;
+}
+/*
+ * SYSFS interface
+ */
+
+static ssize_t ami305_show_selftest(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct ami305_chip *chip = dev_get_drvdata(dev);
+	char *status;
+
+	mutex_lock(&chip->lock);
+	status = ami305_selftest(chip) ? "OK" : "FAIL";
+	mutex_unlock(&chip->lock);
+
+	return sprintf(buf, "%s\n", status);
+}
+
+static DEVICE_ATTR(selftest, S_IRUGO, ami305_show_selftest, NULL);
+
+static ssize_t ami305_show_active(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct ami305_chip *chip = dev_get_drvdata(dev);
+	int status;
+
+	/* Read from the chip to reflect real state of the HW */
+	status = ami305_read(chip, AMI305_CTRL1) & AMI305_CTRL1_POWER;
+	return sprintf(buf, "%s\n", status ? "ON" : "OFF");
+}
+
+static DEVICE_ATTR(active, S_IRUGO, ami305_show_active, NULL);
+
+static ssize_t ami305_get_fuzz(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ami305_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", chip->fuzz);
+}
+
+static ssize_t ami305_set_fuzz(struct device *dev,
+			       struct device_attribute *attr, const char *buf,
+			       size_t count)
+{
+	struct ami305_chip *chip = dev_get_drvdata(dev);
+	unsigned long fuzz;
+
+	if (strict_strtoul(buf, 0, &fuzz))
+		return -EINVAL;
+
+	if (fuzz > AMI305_MAX_RANGE)
+		return -EINVAL;
+
+	ami305_set_input_params(chip, fuzz);
+
+	return count;
+}
+
+static DEVICE_ATTR(fuzz, S_IRUGO | S_IWUSR, ami305_get_fuzz,
+					    ami305_set_fuzz);
+
+static struct attribute *sysfs_attrs[] = {
+	&dev_attr_selftest.attr,
+	&dev_attr_active.attr,
+	&dev_attr_fuzz.attr,
+	NULL
+};
+
+static struct attribute_group ami305_attribute_group = {
+	.attrs = sysfs_attrs
+};
+
+/*
+ * Polled input device interface
+ */
+
+static void ami305_poll(struct input_polled_dev *pidev)
+{
+	struct ami305_chip *chip = pidev->private;
+
+	mutex_lock(&chip->lock);
+
+	ami305_read_values(chip);
+	input_report_abs(pidev->input, ABS_X, chip->x);
+	input_report_abs(pidev->input, ABS_Y, chip->y);
+	input_report_abs(pidev->input, ABS_Z, chip->z);
+	input_sync(pidev->input);
+
+	mutex_unlock(&chip->lock);
+}
+
+static void ami305_open(struct input_polled_dev *pidev)
+{
+	struct ami305_chip *chip = pidev->private;
+	ami305_add_users(chip);
+	ami305_poll(pidev);
+}
+
+static void ami305_close(struct input_polled_dev *pidev)
+{
+	struct ami305_chip *chip = pidev->private;
+	ami305_remove_users(chip);
+}
+
+int ami305_inputdev_enable(struct ami305_chip *chip)
+{
+	struct input_dev *input_dev;
+	int err;
+
+	if (chip->idev)
+		return -EINVAL;
+
+	chip->idev = input_allocate_polled_device();
+	if (!chip->idev)
+		return -ENOMEM;
+
+	chip->idev->private	  = chip;
+	chip->idev->poll	  = ami305_poll;
+	chip->idev->close	  = ami305_close;
+	chip->idev->open	  = ami305_open;
+	chip->idev->poll_interval = AMI305_POLL_INTERVAL;
+
+	input_dev	      = chip->idev->input;
+	input_dev->name	      = "AMI305 / AK8974 Magnetometer";
+	input_dev->phys	      = DRV_NAME "/input0";
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->id.vendor  = 0;
+	input_dev->dev.parent = &chip->client->dev;
+
+	set_bit(EV_ABS, input_dev->evbit);
+	ami305_set_input_params(chip, AMI305_DEFAULT_FUZZ);
+
+	err = input_register_polled_device(chip->idev);
+	if (err) {
+		input_free_polled_device(chip->idev);
+		chip->idev = NULL;
+	}
+
+	return err;
+}
+
+static int __devinit ami305_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct ami305_chip *chip;
+	struct ami305_platform_data *pdata;
+	int err = 0;
+	int whoami;
+	int x, y, z;
+
+	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, chip);
+	chip->client  = client;
+
+	pdata = client->dev.platform_data;
+
+	x = AMI305_DEV_X;
+	y = AMI305_DEV_Y;
+	z = AMI305_DEV_Z;
+
+	if (pdata) {
+		/* Remap axes */
+		x = pdata->axis_x ? pdata->axis_x : x;
+		y = pdata->axis_y ? pdata->axis_y : y;
+		z = pdata->axis_z ? pdata->axis_z : z;
+	}
+
+	if ((abs(x) > 3) | (abs(y) > 3) | (abs(z) > 3)) {
+		dev_err(&client->dev, "Incorrect platform data\n");
+		err = -EINVAL;
+		goto fail1;
+	}
+
+	chip->axis_x = x;
+	chip->axis_y = y;
+	chip->axis_z = z;
+
+	chip->max_range = AMI305_MAX_RANGE;
+
+	mutex_init(&chip->lock);
+	mutex_init(&chip->users_lock);
+
+	whoami = ami305_read(chip, AMI305_WHOAMI);
+	if (whoami < 0) {
+		dev_err(&client->dev, "device not found\n");
+		err = -ENODEV;
+		goto fail1;
+	}
+
+	if (whoami == AMI305_WHOAMI_VALUE_AMI305) {
+		dev_dbg(&client->dev, "device is AMI305, ok\n");
+	} else if (whoami == AMI305_WHOAMI_VALUE_AK8974) {
+		dev_dbg(&client->dev, "device is AK8974, ok\n");
+	} else {
+		dev_err(&client->dev, "device is neither AMI305 nor AK8974\n");
+		err = -ENODEV;
+		goto fail1;
+	}
+
+	err = ami305_configure(chip);
+	if (err)
+		goto fail1;
+
+	err = ami305_inputdev_enable(chip);
+	if (err) {
+		dev_err(&client->dev, "Cannot setup input device\n");
+		goto fail1;
+	}
+
+	err = sysfs_create_group(&chip->client->dev.kobj,
+				&ami305_attribute_group);
+	if (err)
+		dev_err(&client->dev, "Sysfs registration failed\n");
+
+	return err;
+fail1:
+	kfree(chip);
+	return err;
+}
+
+static int __devexit ami305_remove(struct i2c_client *client)
+{
+	struct ami305_chip *chip = i2c_get_clientdata(client);
+
+	sysfs_remove_group(&chip->client->dev.kobj,
+			&ami305_attribute_group);
+	input_unregister_polled_device(chip->idev);
+	input_free_polled_device(chip->idev);
+	kfree(chip);
+	return 0;
+}
+
+#if CONFIG_PM
+static int ami305_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct ami305_chip *chip = i2c_get_clientdata(client);
+	ami305_power(chip, AMI305_PWR_OFF);
+	return 0;
+}
+
+static int ami305_resume(struct i2c_client *client)
+{
+	struct ami305_chip *chip = i2c_get_clientdata(client);
+	ami305_power(chip, AMI305_PWR_ON);
+	return 0;
+}
+
+static void ami305_shutdown(struct i2c_client *client)
+{
+	struct ami305_chip *chip = i2c_get_clientdata(client);
+	ami305_power(chip, AMI305_PWR_OFF);
+}
+
+#else
+#define ami305_suspend NULL
+#define ami305_shutdown NULL
+#define ami305_resume NULL
+#endif
+
+static const struct i2c_device_id ami305_id[] = {
+	{DRV_NAME, 0 },
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, ami305_id);
+
+static struct i2c_driver ami305_driver = {
+	.driver	 = {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.suspend = ami305_suspend,
+	.shutdown = ami305_shutdown,
+	.resume = ami305_resume,
+	.probe	= ami305_probe,
+	.remove = __devexit_p(ami305_remove),
+	.id_table = ami305_id,
+};
+
+static int __init ami305_init(void)
+{
+	return i2c_add_driver(&ami305_driver);
+}
+
+static void __exit ami305_exit(void)
+{
+	i2c_del_driver(&ami305_driver);
+}
+
+MODULE_DESCRIPTION("AMI305 3-axis magnetometer driver");
+MODULE_AUTHOR("Samu Onkalo, Nokia Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("i2c:" DRV_NAME);
+
+module_init(ami305_init);
+module_exit(ami305_exit);
diff --git a/include/linux/i2c/ami305.h b/include/linux/i2c/ami305.h
new file mode 100644
index 0000000..6ca1931
--- /dev/null
+++ b/include/linux/i2c/ami305.h
@@ -0,0 +1,22 @@
+/*
+ * Configuration for AMI305 (and AK8974) magnetometer driver.
+ */
+
+#ifndef __LINUX_I2C_AMI305_H
+#define __LINUX_I2C_AMI305_H
+
+#define AMI305_NO_MAP		  0
+#define AMI305_DEV_X		  1
+#define AMI305_DEV_Y		  2
+#define AMI305_DEV_Z		  3
+#define AMI305_INV_DEV_X	 -1
+#define AMI305_INV_DEV_Y	 -2
+#define AMI305_INV_DEV_Z	 -3
+
+struct ami305_platform_data {
+	s8 axis_x;
+	s8 axis_y;
+	s8 axis_z;
+};
+
+#endif /* __LINUX_I2C_AMI305_H */
-- 
1.5.6.3

