Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYGWRRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYGWRRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYGWRRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:17:24 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:50857 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYGWRRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:17:22 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <488767A7.70903@gmail.com>
Date: Wed, 23 Jul 2008 18:17:27 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>
CC: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>, hmh@hmh.eng.br,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [Patch 4/4] VTI SCA3000 Series accelerometer driver
References: <488763AD.4050400@gmail.com>
In-Reply-To: <488763AD.4050400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jonathan Cameron <jic23@cam.ac.uk>

Add support for the sca3000 series of accelerometers from VTI using the
industrialio subsystem. Includes event interfaces (via chrdevs) for general
events for events relating to the hardware ring buffer. Chrdev access to the
hardware ring buffer and direct access to and control of the device via sysfs
interfaces within the industrialio class.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

drivers/industrialio/accelerometer/Kconfig   |    7
drivers/industrialio/accelerometer/Makefile  |    1
drivers/industrialio/accelerometer/sca3000.c | 1547 +++++++++++++++++++++++++++
include/linux/industrialio/sca3000.h         |   22
4 files changed, 1577 insertions(+)

--- a/drivers/industrialio/accelerometer/Kconfig	2008-07-23 17:03:01.000000000 +0100
+++ b/drivers/industrialio/accelerometer/Kconfig	2008-07-23 16:57:39.000000000 +0100
@@ -17,3 +17,10 @@ config LIS3L02DQ_SPI
 	  Say yes here to build support for the ST LIS3L02DQ accelerometer via
 	  an SPI bus.
 
+config SCA3000
+	depends on SPI
+	tristate "VTI SCA3000 series accelerometers"
+	help
+	 Say yes here to build support for the VTI SCA3000 series of SPI 
+	 accelerometers. These devices use a hardware ring buffer. Direct
+	 access is available unless motion detector mode is enabled.
--- a/drivers/industrialio/accelerometer/Makefile	2008-07-23 17:03:01.000000000 +0100
+++ b/drivers/industrialio/accelerometer/Makefile	2008-07-14 17:26:34.000000000 +0100
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_LIS3L02DQ_SPI)	+= lis3l02dq.o
+obj-$(CONFIG_SCA3000)		+= sca3000.o
--- a/drivers/industrialio/accelerometer/sca3000.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/sca3000.c	2008-07-23 17:09:42.000000000 +0100
@@ -0,0 +1,1547 @@
+/*
+ * sca3000.c -- support VTI sca3000 series accelerometers
+ *              via SPI
+ *
+ * Copyright (c) 2007 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * See industrialio/accels/sca3000.h for comments.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/sysfs.h>
+#include <linux/rtc.h>
+#include <linux/industrialio.h>
+#include <linux/industrialio_sysfs.h>
+
+/* Platform data definitions */
+#include <linux/industrialio/sca3000.h>
+/* Local to driver defintions - to be shared with i2c driver */
+#include "sca3000.h"
+
+#define sca3000_state_from_dev(dev)					\
+	(((struct iio_dev *)(spi_get_drvdata(to_spi_device(dev))))->dev_data)
+
+/* Note where option modes are not defined, the chip simply does not
+ * support any.
+ */
+static const struct sca3000_chip_info sca3000_spi_chip_info_tbl[] = {
+	{
+		.name = "sca3000-d01",
+		.temp_output = true,
+		.measurement_mode_freq = 250,
+		.option_mode_1 = SCA3000_OP_MODE_BYPASS,
+		/* Not given on data sheet assuming same as for measurement
+		 * mode.
+		 */
+		.option_mode_1_freq = 250,
+	}, {
+		/* No data sheet available - may be the same as the 3100-d03?*/
+		.name = "sca3000-d03",
+		.temp_output = true,
+	}, {
+		.name = "sca3000-e02",
+		.measurement_mode_freq = 125,
+		.option_mode_1 = SCA3000_OP_MODE_NARROW,
+		.option_mode_1_freq = 63,
+	}, {
+		.name = "sca3000-e04",
+		.measurement_mode_freq = 100,
+		.option_mode_1 = SCA3000_OP_MODE_NARROW,
+		.option_mode_1_freq = 50,
+		.option_mode_2 = SCA3000_OP_MODE_WIDE,
+		.option_mode_2_freq = 400,
+	}, {
+		.name = "sca3000-e05",
+		.measurement_mode_freq = 200,
+		.option_mode_1 = SCA3000_OP_MODE_NARROW,
+		.option_mode_1_freq = 50,
+		.option_mode_2 = SCA3000_OP_MODE_WIDE,
+		.option_mode_2_freq = 400,
+	}, {
+		/* No data sheet available.
+		 * Frequencies are unknown.
+		 */
+		.name = "sca3000-l01",
+		.temp_output = true,
+		.option_mode_1 = SCA3000_OP_MODE_BYPASS,
+	},
+};
+
+/* Remove dynamic alloc of tx?*/
+static int sca3000_write_reg(struct device *dev,
+			     uint8_t address,
+			     uint8_t val)
+{
+	int ret;
+	struct spi_device *spi_dev = to_spi_device(dev);
+	struct spi_transfer xfer = {
+		.bits_per_word = 8,
+		.len = 2,
+		.cs_change = 1,
+	};
+	struct spi_message msg;
+	char *tx;
+
+	tx = kmalloc(2, GFP_KERNEL);
+	if (tx == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	xfer.tx_buf = tx;
+	tx[0] = SCA3000_WRITE_REG(address);
+	tx[1] = val;
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(spi_dev, &msg);
+	if (ret)
+		dev_err(dev, "problem writing register");
+	kfree(tx);
+
+error_ret:
+	return ret;
+}
+
+/* Note that the responsibility for deallocating rx_p is left
+ * to the caller.
+ */
+static int sca3000_read_data(struct device *dev,
+			     uint8_t reg_address_high,
+			     char **rx_p,
+			     int len)
+{
+	int ret;
+	struct spi_message msg;
+	struct spi_device *spi_dev = to_spi_device(dev);
+	struct spi_transfer xfer = {
+		.bits_per_word = 8,
+		.len = len + 1,
+		.cs_change = 0,
+	};
+	char *tx;
+
+	*rx_p = kmalloc(len + 1, GFP_KERNEL);
+	if (*rx_p == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	tx = kzalloc(len + 1, GFP_KERNEL);
+	if (tx == NULL) {
+		ret = -ENOMEM;
+		goto error_free_rx;
+	}
+	xfer.tx_buf = tx;
+	xfer.rx_buf = *rx_p;
+
+	tx[0] = SCA3000_READ_REG(reg_address_high);
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(spi_dev, &msg);
+	kfree(tx);
+	if (ret) {
+		dev_err(dev, "problem reading register");
+		goto error_free_rx;
+	}
+
+	return 0;
+error_free_rx:
+	kfree(*rx_p);
+error_ret:
+	return ret;
+
+}
+
+static int sca3000_reg_lock_on(struct device *dev)
+{
+
+	char *rx;
+	int ret = 0;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_STATUS, &rx, 1);
+	if (ret < 0)
+		goto error_ret;
+	ret = (rx[1] & SCA3000_LOCKED) ? 0 : 1;
+	kfree(rx);
+
+error_ret:
+	return ret;
+}
+
+/* Unlock the control registers. Note the device does not appear to support
+ * doing this in a single transfer. Should only ever be used as part of a ctrl
+ * reg read. Note that on the pxa27x the cs_change settings have no effect.
+ */
+
+static int __sca3000_unlock_reg_lock(struct device *dev)
+{
+	int ret;
+	struct spi_device *spi_dev = to_spi_device(dev);
+	struct spi_message msg;
+	struct spi_transfer xfer[3] = {
+		{
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		}, {
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		}, {
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		},
+	};
+	char *tx;
+
+	tx = kmalloc(6, GFP_KERNEL);
+	if (tx == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	tx[0] = tx[2] = tx[4] = SCA3000_WRITE_REG(SCA3000_REG_ADDR_UNLOCK);
+	tx[1] = 0x00;
+	tx[3] = 0x50;
+	tx[5] = 0xA0;
+	xfer[0].tx_buf = tx;
+	xfer[1].tx_buf = tx+2;
+	xfer[2].tx_buf = tx+4;
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer[0], &msg);
+	spi_message_add_tail(&xfer[1], &msg);
+	spi_message_add_tail(&xfer[2], &msg);
+	ret = spi_sync(spi_dev, &msg);
+	kfree(tx);
+
+error_ret:
+	return ret;
+}
+
+/* Certain control registers are protected against overwriting by the lock
+ * register and use a shared write address. This function allows writing of
+ * these registers.
+ */
+static int sca3000_write_ctrl_reg(struct device *dev, uint8_t sel, uint8_t val)
+{
+
+	int ret;
+
+
+	/* Check whether the lock is on and unlock if needed. */
+	ret = sca3000_reg_lock_on(dev);
+	if (ret < 0)
+		goto error_ret;
+	if (ret) {
+		ret = __sca3000_unlock_reg_lock(dev);
+		if (ret)
+			goto error_ret;
+	}
+
+	/* Set the control select register */
+	ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_CTRL_SEL, sel);
+	if (ret)
+		goto error_ret;
+
+	/* Write the actual value into the register */
+	ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_CTRL_DATA, val);
+
+error_ret:
+	return ret;
+}
+
+/* Crucial that lock is called before calling this */
+static int sca3000_read_ctrl_reg(struct device *dev,
+				 uint8_t ctrl_reg,
+				 char **rx_p)
+{
+	int ret;
+
+	ret = sca3000_reg_lock_on(dev);
+	if (ret < 0)
+		goto error_ret;
+	if (ret) {
+		ret = __sca3000_unlock_reg_lock(dev);
+		if (ret)
+			goto error_ret;
+	}
+
+	/* Set the control select register */
+	ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_CTRL_SEL, ctrl_reg);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_CTRL_DATA, rx_p, 1);
+
+error_ret:
+	return ret;
+}
+
+/* This status check function is only needed for debugging */
+static int sca3000_check_status(struct device *dev)
+{
+	char *rx;
+	int ret;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_STATUS, &rx, 1);
+	if (ret < 0)
+		goto error_ret;
+	if (rx[1] & SCA3000_EEPROM_CS_ERROR)
+		dev_err(dev, "eeprom error \n");
+	if (rx[1] & SCA3000_SPI_FRAME_ERROR)
+		dev_err(dev, "Previous SPI Frame was corrupt\n");
+	kfree(rx);
+
+error_ret:
+	return ret;
+}
+
+/* All of these are designed to give equivalent values */
+/* FIXME: Is there a cleaner way of doing this? */
+inline int sca3000_13bit_convert(uint8_t msb, uint8_t lsb)
+{
+	int16_t val;
+
+	val = ((lsb >> 3) & 0x1F) | (msb << 5);
+	/* sign fill */
+	val |= (val & (1 << 12)) ? 0xE000 : 0;
+
+	return val;
+}
+
+
+/* These are described as signed 12 bit on the data sheet, which appears
+ * to be a conventional 2's complement 13 bit.
+ */
+static ssize_t sca3000_read_13bit_signed(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	int len = 0, ret;
+	int val;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	char *rx;
+
+	ret = sca3000_read_data(dev, this_attr->address, &rx, 2);
+	if (ret < 0)
+		goto error_ret;
+	/* Process the data */
+	val = sca3000_13bit_convert(rx[1], rx[2]);
+	len += sprintf(buf + len, "%d\n", val);
+	kfree(rx);
+
+	return len;
+error_ret:
+	return ret;
+}
+
+static ssize_t sca3000_show_rev(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	int len = 0, ret;
+	char *rx;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_REVID, &rx, 1);
+	if (ret < 0)
+		goto error_ret;
+	len += sprintf(buf + len,
+		       "major=%d, minor=%d\n",
+		       rx[1] & SCA3000_REVID_MAJOR_MASK,
+		       rx[1] & SCA3000_REVID_MINOR_MASK);
+	kfree(rx);
+
+	return len;
+
+error_ret:
+	return ret;
+}
+
+static ssize_t
+sca3000_show_available_measurement_modes(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int len = 0;
+
+	len += sprintf(buf + len, "0 - normal mode");
+	switch (st->info->option_mode_1) {
+	case SCA3000_OP_MODE_NARROW:
+		len += sprintf(buf + len, ", 1 - narrow mode");
+		break;
+	case SCA3000_OP_MODE_BYPASS:
+		len += sprintf(buf + len, ", 1 - bypass mode");
+		break;
+	};
+	switch (st->info->option_mode_2) {
+	case SCA3000_OP_MODE_WIDE:
+		len += sprintf(buf + len, ", 2 - wide mode");
+		break;
+	}
+	/* always supported */
+	len += sprintf(buf + len, " 3 - motion detection \n");
+
+	return len;
+}
+
+static ssize_t
+sca3000_show_measurement_mode(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int len = 0, ret;
+	char *rx;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	/* mask bottom 2 bits - only ones that are relevant */
+	rx[1] &= 0x03;
+	switch (rx[1]) {
+	case SCA3000_MEAS_MODE_NORMAL:
+		len += sprintf(buf + len, "0 - normal mode\n");
+		break;
+	case SCA3000_MEAS_MODE_MOT_DET:
+		len += sprintf(buf + len, "3 - motion detection\n");
+		break;
+	case SCA3000_MEAS_MODE_OP_1:
+		switch (st->info->option_mode_1) {
+		case SCA3000_OP_MODE_NARROW:
+			len += sprintf(buf + len, "1 - narrow mode\n");
+			break;
+		case SCA3000_OP_MODE_BYPASS:
+			len += sprintf(buf + len, "1 - bypass mode\n");
+			break;
+		};
+		break;
+	case SCA3000_MEAS_MODE_OP_2:
+		switch (st->info->option_mode_2) {
+		case SCA3000_OP_MODE_WIDE:
+			len += sprintf(buf + len, "2 - wide mode\n");
+			break;
+		}
+		break;
+	};
+
+	return len;
+
+error_ret:
+	return ret;
+}
+
+static ssize_t
+sca3000_store_measurement_mode(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf,
+			       size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	char *rx;
+	int mask = 0x03;
+	long val;
+
+	mutex_lock(&st->lock);
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	rx[1] &= ~mask;
+	rx[1] |= (val & mask);
+	ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE, rx[1]);
+	if (ret)
+		goto error_free_rx;
+	mutex_unlock(&st->lock);
+
+	return len;
+
+error_free_rx:
+	kfree(rx);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret;
+}
+
+
+/* A couple of decidedly non standard attributes - if I see them enough they
+ * will make it into the sysfs header if not, made available like this. */
+static IIO_DEVICE_ATTR(available_measurement_modes, S_IRUGO,
+		       sca3000_show_available_measurement_modes,
+		       NULL, 0);
+
+static IIO_DEVICE_ATTR(measurement_mode, S_IRUGO | S_IWUSR,
+		       sca3000_show_measurement_mode,
+		       sca3000_store_measurement_mode,
+		       0);
+
+/* More standard parameters */
+static IIO_DEV_ATTR_REV(sca3000_show_rev);
+
+static IIO_DEV_ATTR_ACCEL_X(sca3000_read_13bit_signed,
+			    SCA3000_REG_ADDR_X_MSB);
+static IIO_DEV_ATTR_ACCEL_Y(sca3000_read_13bit_signed,
+			    SCA3000_REG_ADDR_Y_MSB);
+static IIO_DEV_ATTR_ACCEL_Z(sca3000_read_13bit_signed,
+			    SCA3000_REG_ADDR_Z_MSB);
+
+/* This is only relevant to the ring buffer - and is dependent on measurement
+ * mode. Note that data sheet gives rather wide tollerances for these so int
+ * devision will give good enough answer and not all chips have them specified
+ *  at all.
+ */
+static ssize_t sca3000_read_av_freq(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int len = 0, ret;
+	char *rx;
+	/* What mode are we in? */
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	rx[1] &= 0x03;
+	switch (rx[1]) {
+	case SCA3000_MEAS_MODE_NORMAL:
+		len += sprintf(buf + len, "%d %d %d\n",
+			       st->info->measurement_mode_freq,
+			       st->info->measurement_mode_freq/2,
+			       st->info->measurement_mode_freq/4);
+		break;
+	case SCA3000_MEAS_MODE_OP_1:
+		len += sprintf(buf + len, "%d %d %d\n",
+			       st->info->option_mode_1_freq,
+			       st->info->option_mode_1_freq/2,
+			       st->info->option_mode_1_freq/4);
+		break;
+	case SCA3000_MEAS_MODE_OP_2:
+		len += sprintf(buf + len, "%d %d %d\n",
+			       st->info->option_mode_2_freq,
+			       st->info->option_mode_2_freq/2,
+			       st->info->option_mode_2_freq/4);
+		break;
+	};
+	kfree(rx);
+	return len;
+error_ret:
+	return ret;
+}
+static IIO_DEV_ATTR_AVAIL_SAMP_FREQ(sca3000_read_av_freq);
+
+static ssize_t sca3000_read_frequency(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret, len = 0, base_freq = 0;
+	char *rx;
+
+	/* What mode are we in? */
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	switch (0x03 & rx[1]) {
+	case SCA3000_MEAS_MODE_NORMAL:
+		base_freq = st->info->measurement_mode_freq;
+		break;
+	case SCA3000_MEAS_MODE_OP_1:
+		base_freq = st->info->option_mode_1_freq;
+		break;
+	case SCA3000_MEAS_MODE_OP_2:
+		base_freq = st->info->option_mode_2_freq;
+		break;
+	};
+	kfree(rx);
+	mutex_lock(&st->lock);
+	ret = sca3000_read_ctrl_reg(dev, SCA3000_REG_CTRL_SEL_OUT_CTRL, &rx);
+	mutex_unlock(&st->lock);
+	if (ret)
+		goto error_ret;
+	if (base_freq > 0)
+		switch (rx[1]&0x03) {
+		case 0x00:
+		case 0x03:
+			len = sprintf(buf, "%d\n", base_freq);
+			break;
+		case 0x01:
+			len = sprintf(buf, "%d\n", base_freq/2);
+			break;
+		case 0x02:
+			len = sprintf(buf, "%d\n", base_freq/4);
+			break;
+	};
+			kfree(rx);
+	return len;
+error_ret:
+	return ret;
+}
+
+static ssize_t sca3000_set_frequency(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf,
+				     size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret, base_freq = 0;
+	char *rx;
+	long val;
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+	/* What mode are we in? */
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	switch (0x03 & rx[1]) {
+	case SCA3000_MEAS_MODE_NORMAL:
+		base_freq = st->info->measurement_mode_freq;
+		break;
+	case SCA3000_MEAS_MODE_OP_1:
+		base_freq = st->info->option_mode_1_freq;
+		break;
+	case SCA3000_MEAS_MODE_OP_2:
+		base_freq = st->info->option_mode_2_freq;
+		break;
+	};
+	kfree(rx);
+	mutex_lock(&st->lock);
+
+	ret = sca3000_read_ctrl_reg(dev, SCA3000_REG_CTRL_SEL_OUT_CTRL, &rx);
+	if (ret)
+		goto error_free_lock;
+	/* clear the bits */
+	rx[1] &= ~0x03;
+	if (val == base_freq/2) {
+		rx[1] |= SCA3000_OUT_CTRL_BUF_DIV_2;
+	} else if (val == base_freq/4) {
+		rx[1] |= SCA3000_OUT_CTRL_BUF_DIV_4;
+	} else if (val != base_freq) {
+		ret = -EINVAL;
+		goto error_free_lock;
+	}
+	ret = sca3000_write_ctrl_reg(dev, SCA3000_REG_CTRL_SEL_OUT_CTRL, rx[1]);
+	if (ret)
+		goto error_free_lock;
+	mutex_unlock(&st->lock);
+	return len;
+
+error_free_lock:
+	mutex_unlock(&st->lock);
+error_ret:
+	return ret;
+}
+static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
+			      sca3000_read_frequency,
+			      sca3000_set_frequency);
+/* The alignment of data in here is downright odd. See data sheet */
+/* Converting this into a meaningful value is left to inline functions in
+ * userspace part of header */
+static ssize_t sca3000_read_temp(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	int len = 0, ret;
+	int val;
+	char *rx;
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_TEMP_MSB, &rx, 2);
+	if (ret < 0)
+		goto error_ret;
+	val = ((rx[1]&0x3F) << 3) | ((rx[2] & 0xE0) >> 5);
+	len += sprintf(buf + len, "%d\n", val);
+	kfree(rx);
+
+	return len;
+
+error_ret:
+	return ret;
+}
+static IIO_DEV_ATTR_TEMP(sca3000_read_temp);
+
+static ssize_t sca3000_show_ring_bps_available(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	return sprintf(buf, "8, 11\n");;
+}
+static IIO_DEV_ATTR_RING_BPS_AVAILABLE(sca3000_show_ring_bps_available);
+
+static ssize_t sca3000_show_ring_bps(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	int ret, len;
+	char *rx;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	if (rx[1] & SCA3000_RING_BUF_8BIT)
+		len = sprintf(buf, "8\n");
+	else
+		len = sprintf(buf, "11\n");
+	return len;
+
+error_ret:
+	return ret;
+}
+
+static ssize_t sca3000_store_ring_bps(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	char *rx;
+	long val;
+
+	mutex_lock(&st->lock);
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	switch (val) {
+	case 8:
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					rx[1] | SCA3000_RING_BUF_8BIT);
+		st->bps = 8;
+		break;
+	case 11:
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					rx[1] & ~SCA3000_RING_BUF_8BIT);
+		st->bps = 11;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	if (ret)
+		goto error_ret;
+	mutex_unlock(&st->lock);
+	return len;
+error_ret:
+	mutex_unlock(&st->lock);
+	return ret;
+}
+
+static IIO_DEV_ATTR_RING_BPS(S_IRUGO | S_IWUSR,
+			     sca3000_show_ring_bps,
+			     sca3000_store_ring_bps);
+
+static ssize_t sca3000_show_thresh(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int len = 0, ret;
+	char *rx;
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_ctrl_reg(dev,
+				    this_attr->address,
+				    &rx);
+	mutex_unlock(&st->lock);
+	if (ret)
+		goto error_ret;
+	len += sprintf(buf+len, "%d\n", rx[1]);
+	kfree(rx);
+
+	return len;
+error_ret:
+	return ret;
+}
+
+static ssize_t sca3000_write_thresh(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf,
+				    size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int ret;
+	long val;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+	mutex_lock(&st->lock);
+	ret = sca3000_write_ctrl_reg(dev, this_attr->address, val);
+	mutex_unlock(&st->lock);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t sca3000_show_ring_enable(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	int len = 0, ret, val;
+	char *rx;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	val = (rx[1] & SCA3000_RING_BUF_ENABLE) ? 1 : 0;
+	len += sprintf(buf + len, "%d\n", val);
+	kfree(rx);
+
+	return len;
+error_ret:
+	return ret;
+}
+
+static ssize_t sca3000_store_ring_enable(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf,
+					 size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	long val;
+	int ret;
+	char *rx;
+
+	mutex_lock(&st->lock);
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+
+	if (val)
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1] | SCA3000_RING_BUF_ENABLE));
+	else
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1] & ~SCA3000_RING_BUF_ENABLE));
+	kfree(rx);
+	if (ret)
+		goto error_ret;
+	mutex_unlock(&st->lock);
+
+	return len;
+
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret;
+}
+
+static IIO_DEV_ATTR_ACCEL_THRESH_X(S_IRUGO | S_IWUSR,
+				   sca3000_show_thresh,
+				   sca3000_write_thresh,
+				   SCA3000_REG_CTRL_SEL_MD_X_TH);
+static IIO_DEV_ATTR_ACCEL_THRESH_Y(S_IRUGO | S_IWUSR,
+				   sca3000_show_thresh,
+				   sca3000_write_thresh,
+				   SCA3000_REG_CTRL_SEL_MD_Y_TH);
+static IIO_DEV_ATTR_ACCEL_THRESH_Z(S_IRUGO | S_IWUSR,
+				   sca3000_show_thresh,
+				   sca3000_write_thresh,
+				   SCA3000_REG_CTRL_SEL_MD_Z_TH);
+
+/* FIXME: Move into the ring registration stuff ? */
+static IIO_DEV_ATTR_HW_RING_ENABLE(sca3000_show_ring_enable,
+				   sca3000_store_ring_enable);
+/*fixme, cleaner and readable way of handling these two subtly different tables?
+*/
+static struct attribute *sca3000_attributes[] = {
+	&iio_dev_attr_revision.dev_attr.attr,
+	&iio_dev_attr_x.dev_attr.attr,
+	&iio_dev_attr_y.dev_attr.attr,
+	&iio_dev_attr_z.dev_attr.attr,
+	&iio_dev_attr_thresh_x.dev_attr.attr,
+	&iio_dev_attr_thresh_y.dev_attr.attr,
+	&iio_dev_attr_thresh_z.dev_attr.attr,
+	&iio_dev_attr_hw_ring_enable.dev_attr.attr,
+	&iio_dev_attr_available_measurement_modes.dev_attr.attr,
+	&iio_dev_attr_measurement_mode.dev_attr.attr,
+	&iio_dev_attr_ring_bps.dev_attr.attr,
+	&iio_dev_attr_ring_bps_available.dev_attr.attr,
+	&iio_dev_attr_available_sampling_frequency.dev_attr.attr,
+	&iio_dev_attr_sampling_frequency.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute *sca3000_attributes_with_temp[] = {
+	&iio_dev_attr_revision.dev_attr.attr,
+	&iio_dev_attr_x.dev_attr.attr,
+	&iio_dev_attr_y.dev_attr.attr,
+	&iio_dev_attr_z.dev_attr.attr,
+	&iio_dev_attr_thresh_x.dev_attr.attr,
+	&iio_dev_attr_thresh_y.dev_attr.attr,
+	&iio_dev_attr_thresh_z.dev_attr.attr,
+	&iio_dev_attr_hw_ring_enable.dev_attr.attr,
+	&iio_dev_attr_available_measurement_modes.dev_attr.attr,
+	&iio_dev_attr_measurement_mode.dev_attr.attr,
+	&iio_dev_attr_ring_bps.dev_attr.attr,
+	&iio_dev_attr_ring_bps_available.dev_attr.attr,
+	&iio_dev_attr_available_sampling_frequency.dev_attr.attr,
+	&iio_dev_attr_sampling_frequency.dev_attr.attr,
+	/* Only present if temp sensor is */
+	&iio_dev_attr_temp.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group sca3000_attribute_group = {
+	.attrs = sca3000_attributes,
+};
+
+static const struct attribute_group sca3000_attribute_group_with_temp = {
+	.attrs = sca3000_attributes_with_temp,
+};
+
+/* depending on event, push to the ring buffer event chrdev or the event one */
+static void sca3000_interrupt_handler_bh(struct work_struct *work_s)
+{
+	struct sca3000_state *st
+		= container_of(work_s, struct sca3000_state,
+			       interrupt_handler_ws);
+	struct spi_device *spi_dev  = to_spi_device(st->indio_dev->dev);
+	char *rx;
+
+
+	enable_irq(spi_dev->irq);
+	sca3000_read_data(&spi_dev->dev, SCA3000_REG_ADDR_INT_STATUS, &rx, 1);
+
+	/* may need to escalate an event depending on what has previously
+	 * occured. Note no events are actually sent if no-one is listening.*/
+	if (rx[1] & SCA3000_INT_STATUS_THREE_QUARTERS)
+		iio_put_or_escallate_ring_event(&st->hw_ring->buf,
+						IIO_EVENT_CODE_RING_75_FULL, 0);
+	else if (rx[1] & SCA3000_INT_STATUS_HALF)
+		iio_put_ring_event(&st->hw_ring->buf,
+				   IIO_EVENT_CODE_RING_50_FULL, 0);
+	return;
+}
+
+/* Device deploys a unified interrupt status register */
+static int sca3000_handler_th(struct iio_dev *dev_info,
+			      int index,
+			      s64 timestamp,
+			      int no_test)
+{
+	struct sca3000_state *st = dev_info->dev_data;
+	st->last_timestamp = timestamp;
+	/* have to read the interrupt status to acknowledge the interrupt so
+	   no check is irrelvant */
+	schedule_work(&st->interrupt_handler_ws);
+	return 0;
+}
+
+/* First query if motion detection is enabled, then if this axis is on */
+static ssize_t sca3000_query_mo_det(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	int ret, len = 0;
+	char *rx;
+	uint8_t protect_mask = 0x03;
+	/* read current value of mode register */
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+
+	if ((rx[1]&protect_mask) != SCA3000_MEAS_MODE_MOT_DET)
+		len += sprintf(buf + len, "0\n");
+	else {
+		kfree(rx);
+		ret = sca3000_read_ctrl_reg(dev,
+					    SCA3000_REG_CTRL_SEL_MD_CTRL,
+					    &rx);
+		if (ret)
+			goto error_ret;
+		/* only supporting logical or's for now */
+		if (rx[1]&this_attr->mask)
+			len += sprintf(buf + len, "1\n");
+		else
+			len += sprintf(buf + len, "0\n");
+	}
+	mutex_unlock(&st->lock);
+	kfree(rx);
+
+	return len;
+
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret;
+}
+
+
+static ssize_t sca3000_query_free_fall_mode(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	int val, ret, len = 0;
+	char *rx;
+	/* read current value of mode register */
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	val = rx[1]&SCA3000_FREE_FALL_DETECT ? 1 : 0;
+	len += sprintf(buf + len, "%d\n", val);
+	kfree(rx);
+
+	return len;
+error_ret:
+	return ret;
+}
+
+static ssize_t sca3000_query_ring_int(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	int val, ret, len = 0;
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	char *rx;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_INT_MASK, &rx, 1);
+	if (ret)
+		goto error_ret;
+
+	val = (rx[1] & this_attr->mask) ? 1 : 0;
+	len += sprintf(buf + len, "%d\n", val);
+	kfree(rx);
+	return len;
+
+error_ret:
+	return ret;
+
+}
+
+static ssize_t sca3000_set_ring_int(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+
+	long val;
+	int ret;
+	char *rx;
+
+	mutex_lock(&st->lock);
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_INT_MASK, &rx, 1);
+	if (ret)
+		goto error_ret;
+
+	if (val)
+		ret = sca3000_write_reg(dev,
+					SCA3000_REG_ADDR_INT_MASK,
+					rx[1] | this_attr->mask);
+	else
+		ret = sca3000_write_reg(dev,
+					SCA3000_REG_ADDR_INT_MASK,
+					rx[1] & ~this_attr->mask);
+
+	kfree(rx);
+	if (ret)
+		goto error_ret;
+	mutex_unlock(&st->lock);
+
+	return len;
+
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret;
+}
+
+/* assumes that a 'mode' has been specified in the attribute */
+static ssize_t sca3000_set_free_fall_mode(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf,
+					  size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	long val;
+	int ret;
+	char *rx;
+	uint8_t protect_mask = SCA3000_FREE_FALL_DETECT;
+
+	mutex_lock(&st->lock);
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+
+	/* read current value of mode register */
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+
+	/*if off and should be on*/
+	if (val && !(rx[1]&protect_mask))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1] | SCA3000_FREE_FALL_DETECT));
+	/* if on and should be off */
+	else if (!val && (rx[1]&protect_mask))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1]&(~protect_mask)));
+
+	kfree(rx);
+	if (ret)
+		goto error_ret;
+	mutex_unlock(&st->lock);
+
+	return len;
+
+error_ret:
+
+	mutex_unlock(&st->lock);
+
+	return ret;
+}
+
+/* FIXME - can I simplify this? */
+/* assumes that a 'mode' has been specified in the attribute */
+static ssize_t sca3000_set_mo_det(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	long val;
+	int ret;
+	char *rx;
+	uint8_t protect_mask = 0x03;
+	mutex_lock(&st->lock);
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+	/* First read the motion detector config to find out if
+	 * this axis is on*/
+	ret = sca3000_read_ctrl_reg(dev,
+				    SCA3000_REG_CTRL_SEL_MD_CTRL,
+				    &rx);
+	if (ret)
+		goto error_ret;
+	/* Off and should be on */
+	if (val && !(rx[1]&this_attr->mask)) {
+		ret = sca3000_write_ctrl_reg(dev,
+					     SCA3000_REG_CTRL_SEL_MD_CTRL,
+					     rx[1] | this_attr->mask);
+		kfree(rx);
+		if (ret)
+			goto error_ret;
+		st->mo_det_use_count++;
+	} else if (!val && (rx[1]&this_attr->mask)) {
+		ret = sca3000_write_ctrl_reg(dev,
+					     SCA3000_REG_CTRL_SEL_MD_CTRL,
+					     rx[1] & ~(this_attr->mask));
+		kfree(rx);
+		if (ret)
+			goto error_ret;
+		st->mo_det_use_count--;
+	} else { /* relies on clean state for device on boot */
+		kfree(rx);
+		return len;
+	}
+	/* read current value of mode register */
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	/*if off and should be on*/
+	if ((st->mo_det_use_count)
+	    && ((rx[1]&protect_mask) != SCA3000_MEAS_MODE_MOT_DET))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1]&(~protect_mask))
+					| SCA3000_MEAS_MODE_MOT_DET);
+
+	/* if on and should be off */
+	/*CARE HERE as need to know what mode to switch
+	   to - at the moment assuming back to normal */
+	else if (!(st->mo_det_use_count)
+		&& ((rx[1]&protect_mask) == SCA3000_MEAS_MODE_MOT_DET))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1]&(~protect_mask)));
+
+	kfree(rx);
+	if (ret)
+		goto error_ret;
+
+	mutex_unlock(&st->lock);
+	return len;
+
+error_ret:
+	mutex_unlock(&st->lock);
+	return ret;
+}
+
+
+
+IIO_EVENT_SH(all, &sca3000_handler_th);
+
+/* Free fall detector related event attribute */
+IIO_EVENT_ATTR_FREE_FALL_DETECT_SH(iio_event_all,
+				   sca3000_query_free_fall_mode,
+				   sca3000_set_free_fall_mode,
+				   0)
+
+/* Motion detector related event attributes */
+IIO_EVENT_ATTR_ACCEL_X_HIGH_SH(iio_event_all,
+			       sca3000_query_mo_det,
+			       sca3000_set_mo_det,
+			       SCA3000_MD_CTRL_OR_X);
+
+IIO_EVENT_ATTR_ACCEL_Y_HIGH_SH(iio_event_all,
+			       sca3000_query_mo_det,
+			       sca3000_set_mo_det,
+			       SCA3000_MD_CTRL_OR_Y);
+
+IIO_EVENT_ATTR_ACCEL_Z_HIGH_SH(iio_event_all,
+			       sca3000_query_mo_det,
+			       sca3000_set_mo_det,
+			       SCA3000_MD_CTRL_OR_Z);
+
+/* Hardware ring buffer related event attributes */
+IIO_EVENT_ATTR_RING_50_FULL_SH(iio_event_all,
+			       sca3000_query_ring_int,
+			       sca3000_set_ring_int,
+			       SCA3000_INT_MASK_RING_HALF);
+
+IIO_EVENT_ATTR_RING_75_FULL_SH(iio_event_all,
+			       sca3000_query_ring_int,
+			       sca3000_set_ring_int,
+			       SCA3000_INT_MASK_RING_THREE_QUARTER);
+
+static struct attribute *sca3000_event_attributes[] = {
+	&iio_event_attr_free_fall.dev_attr.attr,
+	&iio_event_attr_x_high.dev_attr.attr,
+	&iio_event_attr_y_high.dev_attr.attr,
+	&iio_event_attr_z_high.dev_attr.attr,
+	&iio_event_attr_ring_50_full.dev_attr.attr,
+	&iio_event_attr_ring_75_full.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group sca3000_event_attribute_group = {
+	.attrs = sca3000_event_attributes,
+};
+
+/* File ops for direct access to the ring buffer */
+int sca3000_ring_open(struct inode *inode, struct file *filp)
+{
+	try_module_get(THIS_MODULE);
+
+	return 0;
+}
+
+int sca3000_ring_release(struct inode *inode, struct file *filp)
+{
+	struct iio_hw_ring_buffer *ring = filp->private_data;
+
+	module_put(THIS_MODULE);
+	clear_bit(IIO_BUSY_BIT_POS, &ring->buf.access_handler.flags);
+
+	return 0;
+}
+
+/* FIXME - ioctl to not bother checking whether there is enough in the ring?
+ * Afterall, if we are responding to an interrupt we have a minimum content
+ * guaranteed*/
+/* FIXME: allow for ring buffering of single / pairs of directions */
+ssize_t sca3000_ring_rip(struct file *filp,
+			 char *buf,
+			 size_t count,
+			 loff_t *f_ps)
+{
+
+	/* let us actually rip half the ring!*/
+	struct iio_hw_ring_buffer *hw_ring = filp->private_data;
+	struct sca3000_state *st = hw_ring->private;
+
+	char *rx;
+	int ret;
+	int num_available;
+	int num_read;
+	int bytes_per_sample = 1;
+
+	if (st->bps == 11)
+		bytes_per_sample = 2;
+	/* Check how much data is available!*/
+	ret = sca3000_read_data(st->indio_dev->dev,
+				SCA3000_REG_ADDR_BUF_COUNT,
+				&rx, 1);
+	if (ret)
+		goto error_ret;
+	else
+		num_available = rx[1];
+	/* NB. The num_available is the total number of samples available
+	 * i.e. Number of time points * number of channels.
+	 */
+	kfree(rx);
+	if (count > num_available*bytes_per_sample)
+		num_read = num_available*bytes_per_sample;
+	else
+		num_read = count - (count % (bytes_per_sample));
+	/* FIXME: Can I do this directly into buf? - not easily because
+	 * of the initial byte. Will think on this.*/
+	ret = sca3000_read_data(st->indio_dev->dev,
+				SCA3000_REG_ADDR_RING_OUT,
+				&rx, num_read);
+	if (ret)
+		goto error_ret;
+
+	memcpy(buf, &rx[1], num_read);
+	kfree(rx);
+	return num_read;
+error_ret:
+	return ret;
+}
+
+static const struct file_operations sca3000_hw_ring_fileops = {
+	.read = sca3000_ring_rip,
+	.release = sca3000_ring_release,
+	.open = sca3000_ring_open,
+	.owner = THIS_MODULE,
+};
+
+/* Device uses flash memory to store may of these things and
+ * hence can come up in somewhat unpredictable state. For now reset
+ * everything.
+ */
+
+static int sca3000_clean_setup(struct device *dev)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	char *rx;
+	/* Ensure all interrupts have been acknowledged */
+	ret = sca3000_read_data(dev,
+				SCA3000_REG_ADDR_INT_STATUS, &rx, 1);
+	if (ret)
+		goto error_ret;
+	kfree(rx);
+	mutex_lock(&st->lock);
+	/* Turn off all motion detection channels */
+	ret = sca3000_read_ctrl_reg(dev,
+				    SCA3000_REG_CTRL_SEL_MD_CTRL,
+				    &rx);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_write_ctrl_reg(dev,
+				     SCA3000_REG_CTRL_SEL_MD_CTRL,
+				     rx[1] & SCA3000_MD_CTRL_PROT_MASK);
+	kfree(rx);
+	if (ret)
+		goto error_ret;
+
+	/* Disable ring buffer */
+	sca3000_read_ctrl_reg(dev,
+			      SCA3000_REG_CTRL_SEL_OUT_CTRL,
+			      &rx);
+	/* Frequency of ring buffer sampling deliberately restricted to make
+	 * debugging easier - add control of this later */
+	ret = sca3000_write_ctrl_reg(dev,
+				     SCA3000_REG_CTRL_SEL_OUT_CTRL,
+				     (rx[1] & SCA3000_OUT_CTRL_PROT_MASK)
+				     | SCA3000_OUT_CTRL_BUF_X_EN
+				     | SCA3000_OUT_CTRL_BUF_Y_EN
+				     | SCA3000_OUT_CTRL_BUF_Z_EN
+				     | SCA3000_OUT_CTRL_BUF_DIV_4);
+	kfree(rx);
+
+	if (ret)
+		goto error_ret;
+	/* Enable interrupts, relevant to mode and set up as active low */
+	ret = sca3000_read_data(dev,
+			  SCA3000_REG_ADDR_INT_MASK,
+			  &rx, 1);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_write_reg(dev,
+				SCA3000_REG_ADDR_INT_MASK,
+				(rx[1] & SCA3000_INT_MASK_PROT_MASK)
+				| SCA3000_INT_MASK_ACTIVE_LOW);
+	kfree(rx);
+	if (ret)
+		goto error_ret;
+	/* Select normal measurement mode, free fall off, ring off */
+	/* Ring in 12 bit mode - it is fine to overwrite reserved bits 3,5
+	 * as that occurs in one of the example on the datasheet */
+	ret = sca3000_read_data(dev,
+			  SCA3000_REG_ADDR_MODE,
+			  &rx, 1);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_write_reg(dev,
+				SCA3000_REG_ADDR_MODE,
+				(rx[1] & SCA3000_MODE_PROT_MASK));
+	kfree(rx);
+	st->bps = 11;
+
+error_ret:
+	mutex_unlock(&st->lock);
+	return ret;
+}
+
+static int __devinit sca3000_probe(struct spi_device *spi)
+{
+	int ret;
+	const struct sca3000_platform_data *pdata = spi->dev.platform_data;
+	struct sca3000_state *st;
+
+	st = kzalloc(sizeof(struct sca3000_state), GFP_KERNEL);
+	if (st == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	mutex_init(&st->lock);
+	st->info = &sca3000_spi_chip_info_tbl[pdata->variant];
+
+	st->indio_dev = kzalloc(sizeof(struct iio_dev), GFP_KERNEL);
+	if (st->indio_dev == NULL) {
+		ret = -ENOMEM;
+		goto error_clear_st;
+	}
+
+	st->indio_dev->dev = &spi->dev;
+	st->indio_dev->num_interrupt_lines = 1;
+	st->indio_dev->event_attrs = &sca3000_event_attribute_group;
+	if (st->info->temp_output)
+		st->indio_dev->attrs = &sca3000_attribute_group_with_temp;
+	else
+		st->indio_dev->attrs = &sca3000_attribute_group;
+	st->indio_dev->dev_data = (void *)(st);
+	st->indio_dev->modes = INDIO_DIRECT_MODE | INDIO_RING_HARDWARE_BUFFER;
+
+	ret = iio_device_register(st->indio_dev);
+	if (ret < 0)
+		goto error_free_dev;
+
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
+		INIT_WORK(&st->interrupt_handler_ws,
+			  sca3000_interrupt_handler_bh);
+		ret = iio_register_interrupt_line(spi->irq,
+						  st->indio_dev,
+						  0,
+						  IRQF_TRIGGER_FALLING,
+						  "sca3000");
+		if (ret)
+			goto error_unregister_dev;
+		/* FIXME: --
+		 * THIS IS PROBABLY A COMMON SITUATION - CLEAN UP REGISTRATION*/
+		/* As all interrupts need ack there is only one handler */
+		ret = iio_add_event_to_list(&st->indio_dev
+					    ->interrupts[0]->ev_list,
+					    iio_event_attr_z_high.listel);
+		if (ret < 0)
+			goto error_unregister_interrupt_line;
+	}
+
+	ret = iio_request_hw_ring_buffer(6,
+					 64,
+					 &st->hw_ring,
+					 0,
+					 THIS_MODULE,
+					 &spi->dev,
+					 &sca3000_hw_ring_fileops,
+					 st);
+	if (ret)
+		goto error_unregister_interrupt_line;
+	ret = sca3000_clean_setup(&spi->dev);
+	if (ret)
+		goto error_free_hw_ring_buffer;
+	return 0;
+error_free_hw_ring_buffer:
+	iio_free_hw_ring_buffer(st->hw_ring, &spi->dev);
+error_unregister_interrupt_line:
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
+		iio_unregister_interrupt_line(st->indio_dev, 0);
+error_unregister_dev:
+	iio_device_unregister(st->indio_dev);
+error_free_dev:
+	kfree(st->indio_dev);
+error_clear_st:
+	kfree(st);
+error_ret:
+	return ret;
+}
+static int sca3000_stop_all_interrupts(struct device *dev)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	char *rx;
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_INT_MASK, &rx, 1);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_INT_MASK,
+				(rx[1] & ~(SCA3000_INT_MASK_RING_THREE_QUARTER
+					   | SCA3000_INT_MASK_RING_HALF
+					   | SCA3000_INT_MASK_ALL_INTS)));
+error_ret:
+	kfree(rx);
+	return ret;
+
+}
+static int sca3000_remove(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+	struct sca3000_state *st = indio_dev->dev_data;
+	int ret;
+	iio_free_hw_ring_buffer(st->hw_ring, &spi->dev);
+	/* Must ensure no interrupts can be generated after this!*/
+	ret = sca3000_stop_all_interrupts(&spi->dev);
+	if (ret)
+		return ret;
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
+		iio_unregister_interrupt_line(st->indio_dev, 0);
+	iio_device_unregister(st->indio_dev);
+
+	kfree(st->indio_dev);
+	kfree(st);
+
+	return 0;
+}
+static struct spi_driver sca3000_driver = {
+	.driver = {
+		.name = "sca3000",
+		.owner = THIS_MODULE,
+	},
+	.probe = sca3000_probe,
+	.remove = __devexit_p(sca3000_remove),
+};
+
+static __init int sca3000_init(void)
+{
+	return spi_register_driver(&sca3000_driver);
+}
+
+static __exit void sca3000_exit(void)
+{
+	spi_unregister_driver(&sca3000_driver);
+}
+
+module_init(sca3000_init);
+module_exit(sca3000_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("VTI SCA3000 Series Accelerometers SPI driver");
+MODULE_LICENSE("GPL v2");
--- a/include/linux/industrialio/sca3000.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/industrialio/sca3000.h	2008-07-23 17:12:00.000000000 +0100
@@ -0,0 +1,22 @@
+/* fixme, start these at zero and rebase chip_info array in driver */
+#define SCA3000_VARIANT_D01 0
+#define SCA3000_VARIANT_D03 1
+#define SCA3000_VARIANT_e02 2
+#define SCA3000_VARIANT_e04 3
+#define SCA3000_VARIANT_e05 4
+#define SCA3000_VARIANT_l01 5
+
+struct sca3000_platform_data {
+	int variant;
+};
+
+/* Conversion function for use with the ring buffer when in 11bit mode */
+inline int sca3000_11bit_convert(uint8_t msb, uint8_t lsb)
+{
+	int16_t val;
+
+	val = ((lsb >> 3) & 0x1C) | (msb << 5);
+	val |= (val & (1 << 12)) ? 0xE000 : 0;
+
+	return val;
+};
