Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYFZSBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYFZSBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYFZSBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:01:23 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:60660 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYFZSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:01:14 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4863D97A.9090102@gmail.com>
Date: Thu, 26 Jun 2008 19:01:30 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, Dmitry Torokhov <dtor@mail.ru>,
       Ben Dooks <ben@fluff.org>, mgross@linux.intel.com, hmh@hmh.eng.br,
       "Hans J. Koch" <hjk@linutronix.de>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: Accelerometer etc subsystem (Update on progress)
References: <4832A211.4040206@gmail.com> <20080520132817.03fb74ea@hyperion.delvare>
In-Reply-To: <20080520132817.03fb74ea@hyperion.delvare>
Content-Type: multipart/mixed;
 boundary="------------040802060900060503060200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040802060900060503060200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dear All,

This email is mainly to give people an idea of current progress towards
a new
subsystem as discussed in the thread starting with
http://lkml.org/lkml/2008/5/20/135

Sorry for the mass list bombardment, but clearly some elements of this
discussion
will end up in various different territories.

Some elements of a prototype subsystem are in place. It draws very heavily
on parts of the input and hwmon subsystems diverging only where necessary.

The only test driver currently integrated is for an ST LIS3L02DQ
accelerometer
which has more than a few quirks to make it tricky to handle (and some what
sketchy documentation.) More chips will follow over next week or so but
hopefully the driver for this chip gives enough of an idea of how I envision
the system working to encourage discussion / advice.

Note that I haven't dealt with anywhere near all the possible locking issues
etc and am well aware that this needs to be done. Other cleanups that will
need to be done include working out the layout in sysfs to make it more
intuitive. Also sorry for the somewhat rough and ready nature of the
attached
patch (against 2.6.26-rc4)

Ring buffer design is a large part of the attached patch. I'm not sure if
I am going about this the right way. Basically, we need ring buffers with
almost no write latency but can waste plenty of time reading from them
(in general case - we do however want reading the last available value to be
fast). What is there works, but probably has at least a few nasty corner
cases that I haven't prevented.

Interfaces (these are per device) - at somepoint a procfs interface similar
       to that used in the input subsystem would make device querying
       simpler.

Sysfs -    Parameter Control - gain / offsets etc
    State control, turn interrupts on and off etc.
    Interrupt control parameters (threshold etc)
    Ring buffer parameters as relevant (currently fixed)
    Individual input reading (acceleration values here)
    Minor numbers for various chrdevs associated with this device.

chrdev-    3 types of chrdev at the moment
    Ring buffer events
    Ring buffer access (currently ripping data off the buffer only)
    Interrupt events - for lis3l02dq these are only threshold breaks

Functionality yet to be implemented.
    Polled based capture (use a peroidic timer if available)

    Hardware ring buffering for devices that support it (two level ring
buffer -
    hard and soft may be appropriate)

    A chrdev for polling of whole device (with timestamps etc).

    Composite interrupt handling (some devices allow logical combinations
    of different interrupt signals to be used as the trigger condition).

    Documenation ;)

    Cleaner solution to data alignment in the ring buffer (currently I'm
cheating
    and manually doing it)

    Lots lots more....

Anyhow, all comments welcome.  Can anyone think of a better name?
(I'm not keen on industrialio. It's too long if nothing else!
 It will do as a working title for now)

Thanks,

--

Jonathan Cameron


--------------040802060900060503060200
Content-Type: text/x-patch;
 name="indio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="indio.patch"

diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/Kconfig b/drivers/industrialio/Kconfig
--- a/drivers/industrialio/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/Kconfig	2008-06-04 18:59:18.000000000 +0100
@@ -0,0 +1,27 @@
+#
+# Industrial I/O subsytem configuration
+#
+
+menuconfig INDUSTRIALIO
+	tristate "Industrial I/O support"
+	---help---
+	  The industrial IO subsystem provides a unified framework for drivers
+	  for many different types of embedded sensors using a number of
+	  different phyiscal interfaces (i2c, spi etc).
+
+	  This documentation will need some work!
+
+if INDUSTRIALIO
+
+source drivers/industrialio/accelerometer/Kconfig
+#source drivers/industrialio/adc/Kconfig
+#source drivers/industrialio/misc/Kconfig
+
+config INDUSTRIALIO_DEBUG_CORE
+	bool "Industrial I/O Core debugging messages"
+	help
+	  Say yes here if you want the Industrial I/O core to producte a bunch
+	  of debug messages to the system log. Select this if you are having a
+	  problem with industrial io support and want to see mor eof what is
+	  going on.
+endif
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/Makefile b/drivers/industrialio/Makefile
--- a/drivers/industrialio/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/Makefile	2008-06-07 13:41:31.000000000 +0100
@@ -0,0 +1,11 @@
+#
+# Makefile for the industrial I/O core.
+#
+
+obj-$(CONFIG_INDUSTRIALIO)	+= industrial.o
+
+obj-y				+= accelerometer/ 
+
+ifeq ($(CONFIG_INDUSTRIALIO_DEBUG_CORE),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
\ No newline at end of file
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/accelerometer/Kconfig b/drivers/industrialio/accelerometer/Kconfig
--- a/drivers/industrialio/accelerometer/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/Kconfig	2008-06-04 18:59:47.000000000 +0100
@@ -0,0 +1,24 @@
+#
+# Accelerometer drivers
+#
+
+config LIS3L02DQ
+	tristate "ST Microelectronics LIS3L02DQ Accelerometer Driver"
+	help
+	  Say yes here to build generic support for the ST microelectronics
+	  accelerometer. You will also need to one or more of the bus specific
+	  elements below.
+
+config LIS3L02DQ_SPI
+	depends on LIS3L02DQ && SPI
+	tristate "SPI support"
+	help
+	  Say yes here to build support for the ST LIS3L02DQ accelerometer via
+	  an SPI bus.
+
+config LIS3L02DQ_I2C
+	depends on LIS3L02DQ && I2C
+	tristate "I2C support"
+	help
+	  Say yes here to build support for the ST LIS3L02DQ accelerometer via
+	  an I2C bus.
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/accelerometer/Makefile b/drivers/industrialio/accelerometer/Makefile
--- a/drivers/industrialio/accelerometer/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/Makefile	2008-06-05 11:35:28.000000000 +0100
@@ -0,0 +1,5 @@
+#
+# Makefile for industrial I/O accelerometer drivers
+#
+
+obj-$(CONFIG_LIS3L02DQ_SPI)	+= lis3l02dq.o
\ No newline at end of file
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/accelerometer/lis3l02dq.c b/drivers/industrialio/accelerometer/lis3l02dq.c
--- a/drivers/industrialio/accelerometer/lis3l02dq.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/lis3l02dq.c	2008-06-26 18:05:57.000000000 +0100
@@ -0,0 +1,1305 @@
+/*
+ * lis3l02dq.c	support STMicroelectronics LISD02DQ
+ *		3d 2g Linear Accelerometers via SPI
+ *
+ * Copyright (c) 2007 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * Loosely based upon tle62x0.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * FIXME: MORE DOCS
+ *
+ * Settings:
+ * Latch on interrupt generation enabled as it simplifies when to reenable
+ * the interrupt.
+ * 16 bit left justified mode used (makes little or no difference, but that
+ * is what I picked.
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/workqueue.h>
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+
+#include <linux/sysfs.h>
+#include <linux/list.h>
+#include <linux/industrialio.h>
+#include <linux/industrialio_sysfs.h>
+
+#include "lis3l02dq.h"
+
+/* Read all inputs in one spi message */
+static const char read_all_tx_array[] =
+{
+	0, LIS3L02DQ_READ_REG(LIS3L02DQ_REG_OUT_X_L_ADDRESS),
+	0, LIS3L02DQ_READ_REG(LIS3L02DQ_REG_OUT_X_H_ADDRESS),
+	0, LIS3L02DQ_READ_REG(LIS3L02DQ_REG_OUT_Y_L_ADDRESS),
+	0, LIS3L02DQ_READ_REG(LIS3L02DQ_REG_OUT_Y_H_ADDRESS),
+	0, LIS3L02DQ_READ_REG(LIS3L02DQ_REG_OUT_Z_L_ADDRESS),
+	0, LIS3L02DQ_READ_REG(LIS3L02DQ_REG_OUT_Z_H_ADDRESS),
+};
+
+static int lis3l02dq_read_all(struct lis3l02dq_state *st,
+			      unsigned char *rx_array)
+{
+	/* Sadly the device appears to require deselection between
+	 * reading the different registers - hence the somewhat
+	 * convoluted nature of this transfer */
+	struct spi_transfer xfers[] = {
+		/* x low byte */
+		{
+			.tx_buf = read_all_tx_array,
+			.rx_buf = rx_array,
+			.bits_per_word = 16,
+			.len = 2,
+			.cs_change = 1,
+		},
+		/* x high byte */
+		{
+			.tx_buf = read_all_tx_array+2,
+			.rx_buf = rx_array + 2,
+			.bits_per_word = 16,
+			.len = 2,
+			.cs_change = 1,
+		},
+		/* y low byte */
+		{
+			.tx_buf = read_all_tx_array+4,
+			.rx_buf = rx_array + 4,
+			.bits_per_word = 16,
+			.len = 2,
+			.cs_change = 1,
+		},
+		/* y high byte */
+		{
+			.tx_buf = read_all_tx_array+6,
+			.rx_buf = rx_array + 6,
+			.bits_per_word = 16,
+			.len = 2,
+			.cs_change = 1,
+		},
+		/* z low byte */
+		{
+			.tx_buf = read_all_tx_array+8,
+			.rx_buf = rx_array + 8,
+			.bits_per_word = 16,
+			.len = 2,
+			.cs_change = 1,
+		},
+		/* z high byte */
+		{
+			.tx_buf = read_all_tx_array+10,
+			.rx_buf = rx_array + 10,
+			.bits_per_word = 16,
+			.len = 2,
+			.cs_change = 0,
+		},
+	};
+	struct spi_message msg;
+	int ret;
+	/* After these are trasmitted, the rx_buff should have
+	 * values in alternate bytes */
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	spi_message_add_tail(&xfers[2], &msg);
+	spi_message_add_tail(&xfers[4], &msg);
+	spi_message_add_tail(&xfers[1], &msg);
+	spi_message_add_tail(&xfers[3], &msg);
+	spi_message_add_tail(&xfers[5], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with get all accels");
+		goto err_ret;
+	}
+
+err_ret:
+	return ret;
+}
+
+static int lis3l02dq_spi_read_reg_int8_t(struct device *dev,
+					  uint8_t reg_address,
+					  int8_t *val)
+{
+	int ret;
+	struct spi_message msg;
+	struct industrialio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	struct spi_transfer xfer = {
+		.tx_buf = NULL,
+		.rx_buf = NULL,
+		.bits_per_word = 16,
+		.len = 2,
+	};
+
+	xfer.tx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+	xfer.rx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+	((unsigned char *)(xfer.tx_buf))[1] = LIS3L02DQ_READ_REG(reg_address);
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(st->us, &msg);
+	kfree(xfer.tx_buf);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with get x offset");
+		goto err_ret;
+	}
+	*val = ((unsigned char *)(xfer.rx_buf))[0];
+	kfree(xfer.rx_buf);
+	return ret;
+err_ret:
+	kfree(xfer.rx_buf);
+	return 0;
+}
+
+/*Returns into to allow full 0/255 range with error codes in negative range */
+static int lis3l02dq_spi_read_reg_uint8_t(struct device *dev,
+					       uint8_t reg_address)
+{
+	uint8_t val;
+	int8_t ret;
+	struct spi_message msg;
+	struct industrialio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	/* FIXME clearer to leave these in, or use tx_buf in xfer directly? */
+	unsigned char *local_tx_buf;
+	unsigned char *local_rx_buf;
+	struct spi_transfer xfer = {
+		.tx_buf = NULL,
+		.rx_buf = NULL,
+		.bits_per_word = 16,
+		.len = 2,
+	};
+
+	local_tx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+	local_rx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+
+	local_tx_buf[1] = LIS3L02DQ_READ_REG(reg_address);
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(st->us, &msg);
+	kfree(local_tx_buf);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with get x offset");
+		goto err_ret;
+	}
+	val = local_rx_buf[0];
+	kfree(local_rx_buf);
+	return val;
+err_ret:
+	kfree(local_rx_buf);
+	return ret;
+}
+
+static int lis3l02dq_spi_write_reg_int8_t(struct device *dev,
+					   uint8_t reg_address,
+					   int value)
+{
+	struct spi_message msg;
+	struct industrialio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	unsigned char *local_tx_buf;
+	struct spi_transfer xfer = {
+		.tx_buf = NULL,
+		.rx_buf = NULL,
+		.bits_per_word = 16,
+		.len = 2,
+	};
+	int ret;
+
+	local_tx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+	xfer.tx_buf = local_tx_buf;
+	local_tx_buf[1] = LIS3L02DQ_WRITE_REG(reg_address);
+	local_tx_buf[0] = value;
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(st->us, &msg);
+	kfree(local_tx_buf);
+
+	if (ret) {
+		dev_err(&st->us->dev, "problem with writing 8 bit register");
+		return ret;
+	}
+	return 0;
+}
+
+/* Relies on the MSB being one higher adress than the LSB */
+static int lis3l02dq_spi_write_reg_int16_t(struct device *dev,
+						uint8_t lower_reg_address,
+						int value)
+{
+	struct spi_message msg;
+	struct industrialio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	unsigned char *local_tx_buf;
+	int ret;
+	struct spi_transfer xfers [] = { {
+			.tx_buf = NULL,
+			.rx_buf = NULL,
+			.bits_per_word = 16,
+			.len = 2,
+		}, {
+			.tx_buf = NULL,
+			.rx_buf = NULL,
+			.bits_per_word = 16,
+			.len = 2,
+		},
+	};
+
+	local_tx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+	xfers[0].tx_buf = local_tx_buf;
+	xfers[1].tx_buf = local_tx_buf + 2;
+	local_tx_buf[1] = LIS3L02DQ_WRITE_REG(lower_reg_address);
+	local_tx_buf[0] = (value & 0xFF);
+	local_tx_buf[3] = LIS3L02DQ_WRITE_REG(lower_reg_address+1);
+	local_tx_buf[2] = (value & 0xFF00) >> 8;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	spi_message_add_tail(&xfers[1], &msg);
+	ret = spi_sync(st->us, &msg);
+	kfree(local_tx_buf);
+	if (ret) {
+		dev_err(&st->us->dev, "problem when writing 16 bit register");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lis3l02dq_spi_read_reg_int16_t(struct device *dev,
+					       uint8_t lower_reg_address,
+					       int16_t *val)
+{
+	struct spi_message msg;
+	struct industrialio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	unsigned char *local_tx_buf;
+	unsigned char *local_rx_buf;
+	int ret;
+	uint16_t temp;
+	struct spi_transfer xfers [] = { {
+			.tx_buf = NULL,
+			.rx_buf = NULL,
+			.bits_per_word = 16,
+			.len = 2,
+		}, {
+			.tx_buf = NULL,
+			.rx_buf = NULL,
+			.bits_per_word = 16,
+			.len = 2,
+		},
+	};
+	local_tx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+	local_rx_buf = (unsigned char *)(kmalloc(4, GFP_KERNEL));
+	xfers[0].tx_buf = local_tx_buf;
+	xfers[0].rx_buf = local_rx_buf;
+	xfers[1].tx_buf = local_tx_buf + 2;
+	xfers[1].rx_buf = local_rx_buf + 2;
+	local_tx_buf[0] = 0;
+	local_tx_buf[1] = LIS3L02DQ_READ_REG(lower_reg_address);
+	local_tx_buf[2] = 0;
+	local_tx_buf[3] = LIS3L02DQ_READ_REG(lower_reg_address+1);
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	spi_message_add_tail(&xfers[1], &msg);
+	ret = spi_sync(st->us, &msg);
+	kfree(local_tx_buf);
+	kfree(local_rx_buf);
+	if (ret) {
+		dev_err(&st->us->dev, "problem when reading 16 bit register");
+		return ret;
+	}
+	temp = (((uint16_t)((local_rx_buf[2]))) << 8)
+		| (uint16_t)(local_rx_buf[0]);
+	*val = *((int16_t *)(&temp));
+
+	return 0;
+}
+
+
+
+static ssize_t lis3l02dq_read_signed(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	int len, ret;
+	int8_t val;
+	struct industrialio_dev_attr *this_attr
+		= to_industrialio_dev_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    this_attr->address,
+					    &val);
+	if (ret < 0)
+		goto err_ret;
+	len = sprintf(buf, "%d\n", val);
+
+	return len;
+
+err_ret:
+	return ret;
+}
+
+static ssize_t lis3l02dq_read_unsigned(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	int val, len;
+	struct industrialio_dev_attr *this_attr
+		= to_industrialio_dev_attr(attr);
+
+	val = lis3l02dq_spi_read_reg_uint8_t(dev,
+					     this_attr->address);
+	if (val < 0) {
+		dev_err(dev, "problem reading an unsigned 8 bit value");
+		goto err_ret;
+	}
+
+	len = sprintf(buf, "%d\n", val);
+	return len;
+err_ret:
+	return val;
+}
+
+static ssize_t lis3l02dq_write_signed(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	long val;
+	int ret;
+	struct industrialio_dev_attr *this_attr
+		= to_industrialio_dev_attr(attr);
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto err_ret;
+
+	ret = lis3l02dq_spi_write_reg_int8_t(dev,
+					     this_attr->address,
+					     val);
+	if (ret)
+		goto err_ret;
+
+	return len;
+
+err_ret:
+	return ret;
+}
+
+static ssize_t lis3l02dq_write_unsigned(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf,
+					size_t len)
+{
+	int ret;
+	ulong val;
+	struct industrialio_dev_attr *this_attr
+		= to_industrialio_dev_attr(attr);
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		goto err_ret;
+
+	ret = lis3l02dq_spi_write_reg_int8_t(dev,
+					      this_attr->address,
+					      val);
+	if (ret)
+		goto err_ret;
+
+	return len;
+err_ret:
+	return ret;
+}
+
+
+static ssize_t lis3l02dq_read_16bit_signed(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	int len, ret;
+	int16_t val;
+	struct industrialio_dev_attr *this_attr
+		= to_industrialio_dev_attr(attr);
+	ret = lis3l02dq_spi_read_reg_int16_t(dev,
+						  this_attr->address,
+						  &val);
+	if (ret < 0) {
+		dev_err(dev, "problem reading a signed 16 bit value from chip");
+		return ret;
+	}
+	len = sprintf(buf, "%d\n", val);
+	return len;
+}
+
+/* As the ring buffer contents are device dependent this functionality
+ * must remain part of the driver and not the ring buffer subsystem */
+static ssize_t
+lis3l02dq_read_accel_from_ring(struct industrialio_ring_buffer *ring,
+			       int element, char *buf)
+{
+	int val, ret, len;
+	uint16_t temp;
+	char *data, *datalock;
+
+	data = kmalloc(8, GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	ret = industrialio_read_last_from_ring(ring, data);
+	datalock = data + 2*element;
+	kfree(data);
+	temp = (((uint16_t)((datalock[1]))) << 8)
+		| (uint16_t)(datalock[0]);
+	val = *((int16_t *)(&temp));
+	len = sprintf(buf, "ring %d\n", val);
+
+	return len;
+error_ret:
+	return ret;
+}
+
+static ssize_t lis3l02dq_read_accel(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct industrialio_dev_attr *this_attr
+		= to_industrialio_dev_attr(attr);
+	struct industrialio_dev *dev_info = dev_get_drvdata(dev);
+	int element;
+	/* FIXME clunky*/
+	if (dev_info->currentmode == INDIO_RING_DATA_RDY) {
+		switch (this_attr->address) {
+		case LIS3L02DQ_REG_OUT_X_L_ADDRESS:
+			element = 0;
+			break;
+		case LIS3L02DQ_REG_OUT_Y_L_ADDRESS:
+			element = 1;
+			break;
+		case LIS3L02DQ_REG_OUT_Z_L_ADDRESS:
+			element = 2;
+			break;
+		default:
+			return -EINVAL;
+		}
+		return lis3l02dq_read_accel_from_ring(dev_info->ring,
+						      element, buf);
+	} else
+		return lis3l02dq_read_16bit_signed(dev, attr, buf);
+}
+
+/* For this device this is only relevant to the threshold for interrupt
+ * generation */
+static ssize_t lis3l02dq_write_16bit_signed(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf,
+					    size_t len)
+{
+	int ret;
+	long val;
+	struct industrialio_dev_attr *this_attr
+		= to_industrialio_dev_attr(attr);
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+	ret = lis3l02dq_spi_write_reg_int16_t(dev,
+						   this_attr->address,
+						   val);
+	if (ret)
+		return ret;
+	return len;
+}
+
+static ssize_t lis3l02dq_read_av_freq(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return sprintf(buf, "280 560 1120 4480\n");
+}
+
+static ssize_t lis3l02dq_read_frequency(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	int ret, len;
+	int8_t t;
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					    &t);
+	if (ret)
+		goto error_ret;
+	t &= LIS3L02DQ_DEC_MASK;
+	if (t == LIS3L02DQ_REG_CTRL_1_DF_128)
+		len = sprintf(buf, "280");
+	else if (t == LIS3L02DQ_REG_CTRL_1_DF_64)
+		len = sprintf(buf, "560");
+	else if (t == LIS3L02DQ_REG_CTRL_1_DF_32)
+		len = sprintf(buf, "1120");
+	else
+		len = sprintf(buf, "4480");
+	len += sprintf(buf+len, "\n");
+
+	return len;
+
+error_ret:
+	return ret;
+}
+
+static ssize_t lis3l02dq_write_frequency(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf,
+					 size_t len)
+{
+	long val;
+	int ret;
+	int8_t t;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					    &t);
+	if (ret)
+		goto error_ret;
+	/* Wipe the bits clean */
+	t |= ~LIS3L02DQ_DEC_MASK;
+	switch (val) {
+	case 280:
+		t |= LIS3L02DQ_REG_CTRL_1_DF_128;
+		break;
+	case 560:
+		t |= LIS3L02DQ_REG_CTRL_1_DF_64;
+		break;
+	case 1120:
+		t |= LIS3L02DQ_REG_CTRL_1_DF_32;
+		break;
+	case 4480:
+		t |= LIS3L02DQ_REG_CTRL_1_DF_8;
+		break;
+	default:
+		ret = -EINVAL;
+		goto error_ret;
+	};
+
+	ret = lis3l02dq_spi_write_reg_int8_t(dev,
+					     LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					     t);
+	if (ret)
+		goto error_ret;
+
+	return len;
+
+error_ret:
+	return ret;
+
+}
+
+static int lis3l02dq_initial_setup(struct lis3l02dq_state *st)
+{
+	int ret;
+
+	st->us->mode = SPI_MODE_3;
+	spi_setup(st->us);
+
+	/* Write suitable defaults to ctrl1 */
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					      LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					      LIS3L02DQ_DEFAULT_CTRL1);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with setup control register 1");
+		goto err_ret;
+	}
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					      LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					      LIS3L02DQ_DEFAULT_CTRL2);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with setup control register 2");
+		goto err_ret;
+	}
+
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					     LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+					     LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with interrupt cfg register");
+		goto err_ret;
+	}
+err_ret:
+	return ret;
+}
+
+
+
+/* These are all a case of reading / writing directly to the chip */
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_X_OFFSET(S_IWUSR | S_IRUGO,
+					    lis3l02dq_read_signed,
+					    lis3l02dq_write_signed,
+					    LIS3L02DQ_REG_OFFSET_X_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_Y_OFFSET(S_IWUSR | S_IRUGO,
+					    lis3l02dq_read_signed,
+					    lis3l02dq_write_signed,
+					    LIS3L02DQ_REG_OFFSET_Y_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_Z_OFFSET(S_IWUSR | S_IRUGO,
+					    lis3l02dq_read_signed,
+					    lis3l02dq_write_signed,
+					    LIS3L02DQ_REG_OFFSET_Z_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_X_GAIN(S_IWUSR | S_IRUGO,
+					  lis3l02dq_read_unsigned,
+					  lis3l02dq_write_unsigned,
+					  LIS3L02DQ_REG_GAIN_X_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_Y_GAIN(S_IWUSR | S_IRUGO,
+					  lis3l02dq_read_unsigned,
+					  lis3l02dq_write_unsigned,
+					  LIS3L02DQ_REG_GAIN_Y_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_Z_GAIN(S_IWUSR | S_IRUGO,
+					  lis3l02dq_read_unsigned,
+					  lis3l02dq_write_unsigned,
+					  LIS3L02DQ_REG_GAIN_Z_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_THRESH(S_IWUSR | S_IRUGO,
+					  lis3l02dq_read_16bit_signed,
+					  lis3l02dq_write_16bit_signed,
+					  LIS3L02DQ_REG_THS_L_ADDRESS);
+
+/* Obviously the reading method for these will change depending on whether
+   ring buffer capture is in use. Allow specification here of alternate
+   function? Or take the approach used above of making this a driver issue
+   rather than part of industrialio */
+static INDUSTRIALIO_DEV_ATTR_ACCEL_X(lis3l02dq_read_accel,
+				     LIS3L02DQ_REG_OUT_X_L_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_Y(lis3l02dq_read_accel,
+				     LIS3L02DQ_REG_OUT_Y_L_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_ACCEL_Z(lis3l02dq_read_accel,
+				     LIS3L02DQ_REG_OUT_Z_L_ADDRESS);
+
+static INDUSTRIALIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
+				       lis3l02dq_read_frequency,
+				       lis3l02dq_write_frequency);
+
+static INDUSTRIALIO_DEV_ATTR_AVAIL_SAMP_FREQ(lis3l02dq_read_av_freq);
+
+static ssize_t
+lis3l02dq_read_interrupt_config(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	int len, ret, set;
+	int8_t val;
+	struct industrialio_event_attr *this_attr
+		= to_industrialio_event_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					     LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+					     &val);
+	if (ret < 0)
+		return ret;
+	set = (val & this_attr->mask) ? 1 : 0;
+	len = sprintf(buf, "%d\n", set);
+
+	return len;
+}
+
+static ssize_t
+lis3l02dq_write_interrupt_config(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t len)
+{
+	int ret, currentlyset, changed = 0;
+	int8_t valold;
+	int8_t controlold;
+
+	struct industrialio_event_attr *this_attr
+		= to_industrialio_event_attr(attr);
+	long val;
+	struct industrialio_dev *indio_dev = dev_get_drvdata(dev);
+
+	ret = strict_strtol(buf, 10, &val);
+
+	if (ret < 0)
+		return ret;
+	/* read current value */
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+					    &valold);
+	if (ret < 0)
+		return ret;
+
+	/* read current control */
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					    &controlold);
+	if (ret < 0)
+		return ret;
+	currentlyset = valold & this_attr->mask ? 1 : 0;
+	if (val == 0 && currentlyset) {
+		valold &= ~this_attr->mask;
+		changed = 1;
+		ret = industrialio_remove_event_from_list(this_attr->listel);
+		if (ret < 0)
+			return ret;
+	} else if (val == 1 && !currentlyset) {
+		changed = 1;
+		valold |= this_attr->mask;
+		/* move to a line spec rather than this? */
+		ret = industrialio_add_event_to_list(&indio_dev
+						     ->interrupts[0]->ev_list,
+						     this_attr->listel);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (changed) {
+		ret = lis3l02dq_spi_write_reg_int8_t(dev,
+						     LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+						     valold);
+		if (ret < 0)
+			return ret;
+		/* This always enables the interrupt, even if we've remove the
+		 * last thing using it. For this device we can use the reference
+		 * count on the handler to tell us if anyone
+		 * wants the interrupt */
+		controlold = this_attr->listel->refcount ?
+			(controlold | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT):
+			(controlold & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
+		ret = lis3l02dq_spi_write_reg_int8_t(dev,
+							  LIS3L02DQ_REG_CTRL_2_ADDRESS,
+							  controlold);
+		if (ret < 0)
+			return ret;
+	}
+
+	return len;
+}
+
+static ssize_t lis3l02dq_read_data_ready_config(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	int ret, set, len;
+	int8_t val;
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					    &val);
+	if (ret < 0)
+		return ret;
+	set = (val & LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION) ? 1 : 0;
+	len = sprintf(buf, "%d\n", set);
+
+	return len;
+}
+
+/* This function must enable data ready generation - whether this is going into
+   a ring buffer or directly generating events is dependant on the value input.
+   0 - no data ready
+   1 - into ring buffer
+   2 - generate events
+*/
+static ssize_t lis3l02dq_write_data_ready_config(struct device *dev,
+						 struct device_attribute *attr,
+						 const char *buf,
+						 size_t len)
+{
+	int ret, currentlyset, changed = 0;
+	int8_t valold;
+
+	struct industrialio_event_attr *this_attr
+		= to_industrialio_event_attr(attr);
+	long val;
+	struct industrialio_dev *indio_dev = dev_get_drvdata(dev);
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	if (val > 2 || val < 0)
+		return -EINVAL;
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					    &valold);
+	if (ret < 0)
+		return ret;
+
+	currentlyset
+		= valold
+		& LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION
+		? 1 : 0;
+	if (val == 0 && currentlyset) {
+		valold &= ~LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
+		changed = 1;
+		ret = industrialio_remove_event_from_list(this_attr->listel);
+		indio_dev->currentmode = INDIO_DIRECT_MODE;
+	} else if (val != 0 && !currentlyset) {
+		valold |= LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
+		changed = 2;
+		ret = industrialio_add_event_to_list(&indio_dev
+						     ->interrupts[0]->ev_list,
+						     this_attr->listel);
+	}
+	if (val == 1)
+		indio_dev->currentmode = INDIO_RING_DATA_RDY;
+	else if (val == 2) {
+		indio_dev->currentmode = INDIO_DIRECT_MODE;
+		valold |= LIS3L02DQ_REG_CTRL_2_BLOCK_UPDATE;
+	}
+	if (changed) {
+		ret = lis3l02dq_spi_write_reg_int8_t(dev,
+						     LIS3L02DQ_REG_CTRL_2_ADDRESS,
+						     valold);
+		if (ret < 0)
+			return ret;
+		/* Clear the other sources of interrupts - whilst not strictly
+		   necessary, this does avoid the need for maintaining state
+		   in software */
+		if (changed == 2) {
+			ret = lis3l02dq_spi_write_reg_int8_t(dev,
+							     LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+							     LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC);
+
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return len;
+}
+
+static void lis3l02dq_data_rdy_bh_to_ring(struct work_struct *work_s)
+{
+	struct lis3l02dq_state *st
+		= container_of(work_s, struct lis3l02dq_state,
+			       work_data_rdy_ring);
+	/* indicate we have begun to process the interrupt*/
+	unsigned char *rx_array, *ring_data;
+	int i;
+
+	/*FIXME both need tests for -enomem */
+	rx_array = (unsigned char *)(kmalloc(12, GFP_KERNEL));
+	ring_data = (unsigned char *)(kmalloc(6, GFP_KERNEL));
+
+	st->inter = 0;
+
+	if (lis3l02dq_read_all(st, rx_array) >= 0) {
+		for (i = 0; i < 6; i++)
+			ring_data[i] = rx_array[i*2];
+		industrialio_store_to_ring(&st->indio_dev->ring[0],
+					   ring_data,
+					   st->last_timestamp);
+	}
+	/* so the data should now be in the rx array */
+try_again:
+	while (gpio_get_value(irq_to_gpio(st->us->irq)))
+		if (lis3l02dq_read_all(st, rx_array) >= 0) {
+			for (i = 0; i < 3; i++)
+				ring_data[i] = rx_array[i*2];
+			/* Passing a negated time stamp to indicate that
+			 * we don't actually know when this occured! */
+			industrialio_store_to_ring(&st->indio_dev->ring[0],
+						   ring_data,
+						   -st->last_timestamp);
+		}
+	/* push data into ring buffer before trying renable */
+	enable_irq(st->us->irq);
+	if (gpio_get_value(irq_to_gpio(st->us->irq)))
+		if (st->inter == 0) {
+			disable_irq_nosync(st->us->irq);
+			goto try_again;
+		}
+	kfree(rx_array);
+	kfree(ring_data);
+	return;
+}
+
+/* This one is odd, I need to perform a full read in order to reset the
+ * interrupt - hence only real thing to make sense it to send the data
+ * as payload of an event? */
+
+static void lis3l02dq_data_rdy_bh_to_event(struct work_struct *work_s)
+{
+	struct lis3l02dq_state *st
+		= container_of(work_s, struct lis3l02dq_state,
+			       work_data_rdy_event);
+
+	/* send an event up to user space */
+	industrialio_put_event(st->indio_dev, 0,
+			       INDUSTRIALIO_EVENT_CODE_DATA_RDY,
+			       st->last_timestamp);
+	enable_irq(st->us->irq);
+	return;
+}
+
+static int lis3l02dq_data_rdy_th(struct industrialio_dev *dev_info,
+				 int index,
+				 s64 timestamp,
+				 int no_test)
+{
+	struct lis3l02dq_state *st = dev_info->dev_data;
+
+	/* Stash the timestamp for the bottom half of the handler*/
+	st->last_timestamp = timestamp;
+
+	if (dev_info->currentmode == INDIO_RING_DATA_RDY) {
+		schedule_work(&st->work_data_rdy_ring);
+		st->inter = 1;
+	} else
+		schedule_work(&st->work_data_rdy_event);
+
+	return IRQ_HANDLED;
+}
+
+static inline int lis3l02dq_thresh_th_impl(struct industrialio_dev *dev_info,
+					  int index,
+					  int timestamp,
+					  int no_test,
+					  struct lis3l02dq_work_cont *wc)
+{
+	/* Find out if this condition is true */
+	if (no_test == 0) {
+		schedule_work(&wc->ws);
+		/* can't do anything else yet */
+		return 0;
+	}
+	schedule_work(&wc->ws_nocheck);
+	/* So I'm set - send event to userspace */
+
+}
+static int lis3l02dq_thresh_handler_th(struct industrialio_dev *dev_info,
+				       int index,
+				       s64 timestamp,
+				       int no_test)
+{
+	struct lis3l02dq_state *st = dev_info->dev_data;
+	/* Stash the timestamp somewhere convenient for the bh */
+	st->last_timestamp = timestamp;
+	/* This is somewhat missleading as for this chip these are actually
+	   the same function */
+	if (no_test == 0)
+		schedule_work(&st->work_cont_thresh.ws);
+	else
+		schedule_work(&st->work_cont_thresh.ws_nocheck);
+	return 0;
+}
+
+
+/* Unforunately it appears the interrupt won't clear unless you read from the
+   src register */
+/* Could move the event list adding stuff into the interrupt, and just do the
+   stuff necessary to reenable the interrupt in here? */
+static void lis3l02dq_thresh_handler_bh_no_check(struct work_struct *work_s)
+{
+	struct lis3l02dq_work_cont *wc
+		= container_of(work_s, struct lis3l02dq_work_cont,
+			       ws_nocheck);
+	struct lis3l02dq_state *st = wc->st;
+
+	int8_t t;
+
+	lis3l02dq_spi_read_reg_int8_t(st->indio_dev->dev,
+					   LIS3L02DQ_REG_WAKE_UP_SRC_ADDRESS,
+					   &t);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH)
+		industrialio_put_event(st->indio_dev, 0,
+				       INDUSTRIALIO_EVENT_CODE_ACCEL_Z_HIGH,
+				       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW)
+		industrialio_put_event(st->indio_dev, 0,
+				       INDUSTRIALIO_EVENT_CODE_ACCEL_Z_LOW,
+				       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH)
+		industrialio_put_event(st->indio_dev, 0,
+				       INDUSTRIALIO_EVENT_CODE_ACCEL_Y_HIGH,
+				       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_LOW)
+		industrialio_put_event(st->indio_dev, 0,
+				       INDUSTRIALIO_EVENT_CODE_ACCEL_Y_LOW,
+				       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_HIGH)
+		industrialio_put_event(st->indio_dev, 0,
+				       INDUSTRIALIO_EVENT_CODE_ACCEL_X_HIGH,
+				       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_LOW)
+		industrialio_put_event(st->indio_dev, 0,
+				       INDUSTRIALIO_EVENT_CODE_ACCEL_X_LOW,
+				       st->last_timestamp);
+
+	/* For this chip, if this handler is running no other interrupts can
+	   occur so this will actually enable the irq  - in others it will
+	   effectively reference count */
+	enable_irq(st->us->irq);
+	/* Ack (and allow for new interrupts? (not clear on data sheet ) )*/
+	lis3l02dq_spi_read_reg_int8_t(st->indio_dev->dev,
+				      LIS3L02DQ_REG_WAKE_UP_ACK_ADDRESS,
+				      &t);
+
+	return;
+}
+
+/* A shared handler for a number of threshold types */
+INDUSTRIALIO_EVENT_SH(threshold, &lis3l02dq_thresh_handler_th);
+
+INDUSTRIALIO_EVENT_ATTR_ACCEL_X_HIGH_SH(industrialio_event_threshold,
+					lis3l02dq_read_interrupt_config,
+					lis3l02dq_write_interrupt_config,
+					LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_HIGH);
+
+INDUSTRIALIO_EVENT_ATTR_ACCEL_Y_HIGH_SH(industrialio_event_threshold,
+					lis3l02dq_read_interrupt_config,
+					lis3l02dq_write_interrupt_config,
+					LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_HIGH);
+
+INDUSTRIALIO_EVENT_ATTR_ACCEL_Z_HIGH_SH(industrialio_event_threshold,
+					lis3l02dq_read_interrupt_config,
+					lis3l02dq_write_interrupt_config,
+					LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_HIGH);
+
+INDUSTRIALIO_EVENT_ATTR_ACCEL_X_LOW_SH(industrialio_event_threshold,
+				       lis3l02dq_read_interrupt_config,
+				       lis3l02dq_write_interrupt_config,
+				       LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_LOW);
+
+INDUSTRIALIO_EVENT_ATTR_ACCEL_Y_LOW_SH(industrialio_event_threshold,
+				       lis3l02dq_read_interrupt_config,
+				       lis3l02dq_write_interrupt_config,
+				       LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_LOW);
+
+INDUSTRIALIO_EVENT_ATTR_ACCEL_Z_LOW_SH(industrialio_event_threshold,
+				       lis3l02dq_read_interrupt_config,
+				       lis3l02dq_write_interrupt_config,
+				       LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_LOW);
+
+INDUSTRIALIO_EVENT_ATTR_DATA_RDY(lis3l02dq_read_data_ready_config,
+				lis3l02dq_write_data_ready_config,
+				 0,
+				&lis3l02dq_data_rdy_th);
+
+
+
+static struct attribute *lis3l02dq_event_attributes[] = {
+	&industrialio_event_attr_x_high.dev_attr.attr,
+	&industrialio_event_attr_y_high.dev_attr.attr,
+	&industrialio_event_attr_z_high.dev_attr.attr,
+	&industrialio_event_attr_x_low.dev_attr.attr,
+	&industrialio_event_attr_y_low.dev_attr.attr,
+	&industrialio_event_attr_z_low.dev_attr.attr,
+	&industrialio_event_attr_data_rdy.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group lis3l02dq_event_attribute_group = {
+	.name = "event_sources",
+	.attrs = lis3l02dq_event_attributes,
+};
+
+/*standardize these attributes as much as possible*/
+
+static struct attribute *lis3l02dq_attributes[] = {
+	&industrialio_dev_attr_x_offset.dev_attr.attr,
+	&industrialio_dev_attr_y_offset.dev_attr.attr,
+	&industrialio_dev_attr_z_offset.dev_attr.attr,
+	&industrialio_dev_attr_x_gain.dev_attr.attr,
+	&industrialio_dev_attr_y_gain.dev_attr.attr,
+	&industrialio_dev_attr_z_gain.dev_attr.attr,
+	&industrialio_dev_attr_thresh.dev_attr.attr,
+	&industrialio_dev_attr_x.dev_attr.attr,
+	&industrialio_dev_attr_y.dev_attr.attr,
+	&industrialio_dev_attr_z.dev_attr.attr,
+	&industrialio_dev_attr_sampling_frequency.dev_attr.attr,
+	&industrialio_dev_attr_available_sampling_frequency.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group lis3l02dq_attribute_group = {
+	.attrs = lis3l02dq_attributes,
+};
+
+static int __devinit lis3l02dq_probe(struct spi_device *spi)
+{
+	struct lis3l02dq_state *st;
+	int ret;
+	st = kzalloc(sizeof(struct lis3l02dq_state), GFP_KERNEL);
+	if (st == NULL) {
+		dev_err(&spi->dev, "Memory allocation error \n");
+		return -ENOMEM;
+	}
+	st->us = spi;
+
+	/* setup the industrialio driver allocated elements */
+	st->indio_dev
+		= (struct industrialio_dev *)
+		(kzalloc(sizeof(struct industrialio_dev), GFP_KERNEL));
+	if (st->indio_dev == NULL) {
+		ret = -ENOMEM;
+		goto error_free_st;
+	}
+
+	/* WRAP THIS LOT INTO A COUPLE OF DEFINES! */
+	st->indio_dev->dev = &spi->dev;
+	st->indio_dev->num_interrupt_lines = 1;
+	st->indio_dev->event_attrs = &lis3l02dq_event_attribute_group;
+	st->indio_dev->attrs = &lis3l02dq_attribute_group;
+	st->indio_dev->dev_data = (void *)(st);
+	/* setup parameters of the ring buffer */
+/* CARE WITH WORD ALIGNMENT*/
+	st->indio_dev->ring_dimension = 4;
+	st->indio_dev->ring_bytes_per_reading = 2;
+	st->indio_dev->ring_length = 500;
+	st->indio_dev->driver_module = THIS_MODULE;
+	st->indio_dev->modes = INDIO_DIRECT_MODE | INDIO_RING_DATA_RDY;
+
+
+	ret = industrialio_device_register(st->indio_dev);
+	if (ret < 0)
+		goto error_free_dev;
+	/* FIXME: Due to intialization order the ring is created even if the irq
+	   is no good. Valid when polling is implemented */
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
+		INIT_WORK(&st->work_data_rdy_ring,
+			  lis3l02dq_data_rdy_bh_to_ring);
+		INIT_WORK(&st->work_data_rdy_event,
+			  lis3l02dq_data_rdy_bh_to_event);
+
+		/* This is a little unusual, in that the device seems
+		   to need a full read of the interrupt source reg before
+		   the interrupt will reset.
+		   Hence the two handlers are the same */
+
+		INIT_WORK_CONT(&(st->work_cont_thresh),
+			       lis3l02dq_thresh_handler_bh_no_check,
+			       lis3l02dq_thresh_handler_bh_no_check,
+			       LIS3L02DQ_REG_WAKE_UP_SRC_ADDRESS,
+			       0,
+			       st);
+		st->inter = 0;
+		ret = industrialio_register_interrupt_line(spi->irq,
+							   st->indio_dev,
+							   0,
+							   IRQF_TRIGGER_RISING,
+							   "lis3l02dq");
+		if (ret)
+			goto error_unregister_dev;
+	} else
+		st->indio_dev->modes &= ~INDIO_RING_DATA_RDY;
+
+	/* Get the device into a sane initial state */
+	ret = lis3l02dq_initial_setup(st);
+	if (ret)
+		goto error_unregister_line;
+
+	return 0;
+
+error_unregister_line:
+	if (st->indio_dev->modes & INDIO_RING_DATA_RDY)
+		industrialio_unregister_interrupt_line(st->indio_dev, 0);
+error_unregister_dev:
+	industrialio_device_unregister(st->indio_dev);
+error_free_dev:
+	kfree(st->indio_dev);
+error_free_st:
+	kfree(st);
+	return ret;
+}
+
+/* Power down the device */
+static int lis3l02dq_stop_device(struct lis3l02dq_state *st)
+{
+	int ret;
+
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					      LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					      0);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with turning device off: ctrl1");
+		goto err_ret;
+	}
+
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					      LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					      0);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with turning device off: ctrl2");
+		goto err_ret;
+	}
+	return 0;
+err_ret:
+	return ret;
+}
+
+/* fixme, confirm ordering in this function */
+static int lis3l02dq_remove(struct spi_device *spi)
+{
+	int ret;
+	struct industrialio_dev *indio_dev = spi_get_drvdata(spi);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+
+	/* stop the device
+	 * Move into industrialio - can then automating linking
+	 * to power type controls in sysfs? FUTURE WORK!
+	 */
+	/* Amongst other things this must ensure no more interrupts are generate
+	 * by the device */
+	ret = lis3l02dq_stop_device(st);
+	if (ret)
+		goto err_ret;
+	/* Fixme slightly misleading test condition - even if valid */
+	if (st->indio_dev->modes & INDIO_RING_DATA_RDY)
+		industrialio_unregister_interrupt_line(st->indio_dev, 0);
+	industrialio_device_unregister(st->indio_dev);
+	kfree(st->indio_dev);
+	kfree(st);
+	return 0;
+
+err_ret:
+	return ret;
+}
+
+static struct spi_driver lis3l02dq_driver = {
+	.driver = {
+		.name = "lis3l02dq",
+		.owner = THIS_MODULE,
+	},
+	.probe = lis3l02dq_probe,
+	.remove = __devexit_p(lis3l02dq_remove),
+};
+
+static __init int lis3l02dq_init(void)
+{
+	return spi_register_driver(&lis3l02dq_driver);
+}
+
+static __exit void lis3l02dq_exit(void)
+{
+	spi_unregister_driver(&lis3l02dq_driver);
+}
+
+module_init(lis3l02dq_init);
+module_exit(lis3l02dq_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("ST LIS3L02DQ Accelerometer SPI driver");
+MODULE_LICENSE("GPL v2");
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/accelerometer/lis3l02dq.c_oldfuncs b/drivers/industrialio/accelerometer/lis3l02dq.c_oldfuncs
--- a/drivers/industrialio/accelerometer/lis3l02dq.c_oldfuncs	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/lis3l02dq.c_oldfuncs	2008-06-12 18:11:01.000000000 +0100
@@ -0,0 +1,265 @@
+/* A fairly inellegant way of ripping the contents of the
+ * ring buffer and ensuring only a valid set of readings are output */
+
+static ssize_t lis3l02dq_rip_buffer(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	int len = 0, elements, i, dead_offset = 0;
+	uint8_t data_dump[LIS3L02DQ_BUFFER_LENGTH*6];
+	uint8_t *initial_read_p, *initial_write_p,
+		*current_read_p, *end_read_p;
+	struct lis3l02dq_state *st = dev_get_drvdata(dev);
+	uint16_t temp;
+
+	/* Get a consistent pair of read and write pointers */
+	initial_read_p = st->read_pointer;
+
+	/* Occurs if nothing has yet been placed in the ring buffer */
+	if (unlikely(initial_read_p == 0))
+		goto err;
+
+	initial_write_p = st->write_pointer;
+	while (initial_read_p != st->read_pointer
+	       || initial_write_p != st->write_pointer) {
+		initial_read_p = st->read_pointer;
+		initial_write_p = st->write_pointer;
+	}
+	if (initial_write_p > initial_read_p) {
+		elements = (initial_write_p - initial_read_p);
+		memcpy(data_dump, initial_read_p, elements);
+	} else {
+		elements = st->ring_buffer
+			+ LIS3L02DQ_BUFFER_LENGTH*6
+			- initial_read_p;
+
+		memcpy(data_dump, initial_read_p, elements);
+		memcpy(data_dump+elements,
+		       st->ring_buffer,
+		       initial_write_p - st->ring_buffer);
+		elements += initial_write_p - st->ring_buffer;
+	}
+
+	end_read_p = st->read_pointer;
+
+	if (initial_read_p <= end_read_p)
+		dead_offset = end_read_p - initial_read_p;
+	else
+		dead_offset = st->ring_buffer
+			+ LIS3L02DQ_BUFFER_LENGTH*6 - initial_read_p
+			+ end_read_p - st->ring_buffer;
+
+	/* Possible issue here is the readpointer may have changed.
+	 * It could in theory have passed the initial write pointer.*/
+	st->read_pointer = initial_write_p;
+
+	for (current_read_p = data_dump + dead_offset;
+	    current_read_p < data_dump + elements;
+	    current_read_p += 6) {
+		for (i = 0; i < 3; i++) {
+			temp = (((uint16_t)((current_read_p[2*i+1]))) << 8)
+				| (uint16_t)(current_read_p[2*i]);
+			len += sprintf(len+buf, "%d ", *((int16_t *)(&temp)));
+		}
+	}
+	len += sprintf(len+buf, "\n");
+
+	return len;
+
+err:
+	return 0;
+}
+
+static int lis3l02dq_set_mode(struct device *dev, int val)
+{
+	int ret;
+	uint8_t tmp;
+	const uint8_t addr_ctrl2 = LIS3L02DQ_REG_CTRL_2_ADDRESS;
+	struct lis3l02dq_state *st = dev_get_drvdata(dev);
+
+	if (st->mode == val
+	    || st->mode == LIS3L02DQ_DIRECT_ONLY_MODE)
+		return 0;
+
+	switch (val) {
+	case 0:
+		/* disable interrupt generation */
+		ret = lis3l02dq_write_register_int8_t(&st->us->dev,
+						      addr_ctrl2,
+						      LIS3L02DQ_DEFAULT_CTRL2);
+		if (ret)	{
+			dev_err(&st->us->dev,
+				"problem with setup control register 2");
+			goto err_ret;
+		}
+
+		flush_scheduled_work();
+		free_irq(st->us->irq, st);
+		break;
+
+	case 1:
+		/* quick read to ensure that the interrupt line is low */
+		lis3l02dq_read_all(st);
+		ret = request_irq(st->us->irq,
+				  interrupthandler,
+				  IRQF_TRIGGER_RISING,
+				  "lis3l02dq",
+				  st);
+		if (ret < 0) {
+			dev_err(&st->us->dev, "Could not obtain irq ");
+			goto err_ret;
+		}
+		/* enable interrupt generation */
+	tmp =  LIS3L02DQ_DEFAULT_CTRL2	       
+			|  LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
+		ret = lis3l02dq_write_register_int8_t(&st->us->dev,
+						      addr_ctrl2,
+						      tmp);
+		if (ret) {
+			dev_err(&st->us->dev,
+				"problem with setup control register 2");
+			goto err_ret;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_ret;
+		break;
+	};
+	st->mode = val;
+
+	return 0;
+err_ret:
+	return ret;
+}
+
+static ssize_t lis3l02dq_read_mode(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	int len = 0;
+	struct lis3l02dq_state *st = dev_get_drvdata(dev);
+
+	len += sprintf(buf + len, "%d\n", st->mode);
+
+	return len;
+}
+
+static ssize_t lis3l02dq_write_mode(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf,
+				    size_t len)
+{
+	int ret;
+	long val;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret < 0)
+		goto err_ret;
+	ret = lis3l02dq_set_mode(dev, val);
+	if (ret < 0)
+		goto err_ret;
+	return len;
+err_ret:
+	return ret;
+}
+
+static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, lis3l02dq_read_mode,
+		   lis3l02dq_write_mode);
+
+
+
+static DEVICE_ATTR(rip_buffer, S_IRUGO, lis3l02dq_rip_buffer, NULL);
+
+
+
+static void lis3l02dq_store_to_ring(struct lis3l02dq_state *st)
+{
+	int i;
+	bool initread = true;
+
+	/* First use of ring */
+	if (unlikely(st->write_pointer == 0)) {
+		st->write_pointer = st->ring_buffer;
+		initread = false;
+	}
+	/*probably unnecessary */
+	barrier();
+	/*save data */
+	for (i = 0; i < 3; i++) {
+		st->write_pointer[i*2] = st->rx_buff[i*4];
+		st->write_pointer[i*2+1] = st->rx_buff[i*4+2];
+	}
+	barrier();
+	st->last_written_pointer = st->write_pointer;
+	barrier();
+	st->write_pointer += 6;
+	if (unlikely(st->write_pointer
+		     == st->ring_buffer + 6*LIS3L02DQ_BUFFER_LENGTH))
+		st->write_pointer = st->ring_buffer;
+
+	if (unlikely(st->read_pointer == 0))
+		st->read_pointer = st->ring_buffer;
+	else if (st->write_pointer == st->read_pointer)	{
+		if (unlikely((st->read_pointer+6
+			      == st->ring_buffer + 6*LIS3L02DQ_BUFFER_LENGTH)))
+			st->read_pointer = st->ring_buffer;
+		else
+			st->read_pointer += 6;
+	}
+	return;
+}
+
+static void lis3l02dq_data_ready_work(struct work_struct *work_s)
+{
+	struct lis3l02dq_state *st
+		= container_of(work_s, struct lis3l02dq_state, work);
+
+	st->inter = 0;
+	if (lis3l02dq_read_all(st) >= 0)
+		lis3l02dq_store_to_ring(st);
+
+try_again:
+	while (gpio_get_value(irq_to_gpio(st->us->irq)))
+		if (lis3l02dq_read_all(st) >= 0)
+			lis3l02dq_store_to_ring(st);
+	/* If we are lucky gpio should not be set now
+	 * Try reenabling interrupt. */
+	enable_irq(st->us->irq);
+	/* verify that either the gpio has not risen or that
+	 * the interrupt handler caught it */
+	if (gpio_get_value(irq_to_gpio(st->us->irq)))
+		if (st->inter == 0) {
+			disable_irq_nosync(st->us->irq);
+			goto try_again;
+		}
+	return;
+}
+
+
+/* can I make any of this generic - yes! */
+static irqreturn_t interrupthandler(int irq, void *_state)
+{
+
+	struct lis3l02dq_state *st = _state;
+	struct industrialio_event_list* p;
+
+	disable_irq_nosync(irq);
+	/* Could it have been us? */
+	if(list_empty(&st->interrupt_pin_event_list.list))
+		return IRQ_NONE;
+
+	/* Grab and store a time stamp - might take us a while to fill in the details */
+	/* Assume for now it could only have been us */
+	/* If only one possible source exists don't need to identify */
+	if(st->interrupt_pin_event_list.list.next->next == &st->interrupt_pin_event_list.list);
+	list_for_each_entry(p, &st->interrupt_pin_event_list.list, list)
+	{
+		/* fixme, need the index from somewhere safe! hang on, I'm in an interrupt, anywhere is fine */
+		/* Hang on, what's the point of the index?  If the time is fine, all is good */
+		p->handler(_state, 1, 1);
+	}
+	/*Otherwise we need to queue a query to find out what it was and then handle later */
+
+	return IRQ_HANDLED;
+}
\ No newline at end of file
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/accelerometer/lis3l02dq.h b/drivers/industrialio/accelerometer/lis3l02dq.h
--- a/drivers/industrialio/accelerometer/lis3l02dq.h	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/lis3l02dq.h	2008-06-26 18:07:34.000000000 +0100
@@ -0,0 +1,183 @@
+/*
+ * LISL02DQ.h -- support STMicroelectronics LISD02DQ
+ *               3d 2g Linear Accelerometers via SPI
+ *
+ * Copyright (c) 2007 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * Loosely based upon tle62x0.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver has two modes, one is interrupt based, the other on demand
+ */
+#ifndef SPI_LIS3L02DQ_H_
+#define SPI_LIS3L02DQ_H_
+#define LIS3L02DQ_READ_REG(a) ((a) | 0x80)
+#define LIS3L02DQ_WRITE_REG(a) a
+
+/* Calibration parameters */
+#define LIS3L02DQ_REG_OFFSET_X_ADDRESS		0x16
+#define LIS3L02DQ_REG_OFFSET_Y_ADDRESS		0x17
+#define LIS3L02DQ_REG_OFFSET_Z_ADDRESS		0x18
+
+#define LIS3L02DQ_REG_GAIN_X_ADDRESS		0x19
+#define LIS3L02DQ_REG_GAIN_Y_ADDRESS		0x1A
+#define LIS3L02DQ_REG_GAIN_Z_ADDRESS		0x1B
+
+/* Control Register (1 of 2) */
+#define LIS3L02DQ_REG_CTRL_1_ADDRESS		0x20
+/* Power ctrl - either bit set corresponds to on*/
+#define LIS3L02DQ_REG_CTRL_1_PD_ON	0xC0
+
+/* Decimation Factor  */
+#define LIS3L02DQ_DEC_MASK			0x30
+#define LIS3L02DQ_REG_CTRL_1_DF_128		0x00
+#define LIS3L02DQ_REG_CTRL_1_DF_64		0x10
+#define LIS3L02DQ_REG_CTRL_1_DF_32		0x20
+#define LIS3L02DQ_REG_CTRL_1_DF_8		(0x10 | 0x20)
+
+/* Self Test Enable */
+#define LIS3L02DQ_REG_CTRL_1_SELF_TEST_ON	0x08
+
+/* Axes enable ctrls */
+#define LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE	0x04
+#define LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE	0x02
+#define LIS3L02DQ_REG_CTRL_1_AXES_X_ENABLE	0x01
+
+/* Control Register (2 of 2) */
+#define LIS3L02DQ_REG_CTRL_2_ADDRESS		0x21
+
+/* Block Data Update only after MSB and LSB read */
+#define LIS3L02DQ_REG_CTRL_2_BLOCK_UPDATE	0x40
+
+/* Set to big endian output */
+#define LIS3L02DQ_REG_CTRL_2_BIG_ENDIAN		0x20
+
+/* Reboot memory content */
+#define LIS3L02DQ_REG_CTRL_2_REBOOT_MEMORY	0x10
+
+/* Interupt Enable - applies data ready to the RDY pad */
+#define LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT	0x08
+
+/* Enable Data Ready Generation - relationship with previous unclear in docs */
+#define LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION 0x04
+
+/* SPI 3 wire mode */
+#define LIS3L02DQ_REG_CTRL_2_THREE_WIRE_SPI_MODE	0x02
+
+/* Data alignment, default is 12 bit right justified
+ * - option for 16 bit left justified */
+#define LIS3L02DQ_REG_CTRL_2_DATA_ALIGNMENT_16_BIT_LEFT_JUSTIFIED	0x01
+
+/* Interupt related stuff */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS		0x23
+
+/* Switch from or combination fo conditions to and */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_BOOLEAN_AND		0x80
+
+/* Latch interupt request,
+ * if on ack must be given by reading the ack register */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC		0x40
+
+/* Z Interupt on High (above threshold)*/
+#define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_HIGH	0x20
+/* Z Interupt on Low */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_LOW	0x10
+/* Y Interupt on High */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_HIGH	0x08
+/* Y Interupt on Low */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_LOW	0x04
+/* X Interupt on High */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_HIGH	0x02
+/* X Interupt on Low */
+#define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_LOW 0x01
+
+/* Register that gives description of what caused interupt
+ * - latched if set in CFG_ADDRES */
+#define LIS3L02DQ_REG_WAKE_UP_SRC_ADDRESS		0x24
+/* top bit ignored */
+/* Interupt Active */
+#define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_ACTIVATED	0x40
+/* Interupts that have been triggered */
+#define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH	0x20
+#define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW	0x10
+#define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH	0x08
+#define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_LOW	0x04
+#define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_HIGH	0x02
+#define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_LOW	0x01
+
+#define LIS3L02DQ_REG_WAKE_UP_ACK_ADDRESS		0x25
+
+/* Status register */
+#define LIS3L02DQ_REG_STATUS_ADDRESS			0x27
+/* XYZ axis data overrun - first is all overrun? */
+#define LIS3L02DQ_REG_STATUS_XYZ_OVERRUN		0x80
+#define LIS3L02DQ_REG_STATUS_Z_OVERRUN			0x40
+#define LIS3L02DQ_REG_STATUS_Y_OVERRUN			0x20
+#define LIS3L02DQ_REG_STATUS_X_OVERRUN			0x10
+/* XYZ new data available - first is all 3 available? */
+#define LIS3L02DQ_REG_STATUS_XYZ_NEW_DATA 0x08
+#define LIS3L02DQ_REG_STATUS_Z_NEW_DATA			0x04
+#define LIS3L02DQ_REG_STATUS_Y_NEW_DATA			0x02
+#define LIS3L02DQ_REG_STATUS_X_NEW_DATA			0x01
+
+/* The accelerometer readings - low and high bytes.
+Form of high byte dependant on justification set in ctrl reg */
+#define LIS3L02DQ_REG_OUT_X_L_ADDRESS			0x28
+#define LIS3L02DQ_REG_OUT_X_H_ADDRESS			0x29
+#define LIS3L02DQ_REG_OUT_Y_L_ADDRESS			0x2A
+#define LIS3L02DQ_REG_OUT_Y_H_ADDRESS			0x2B
+#define LIS3L02DQ_REG_OUT_Z_L_ADDRESS			0x2C
+#define LIS3L02DQ_REG_OUT_Z_H_ADDRESS			0x2D
+
+/* Threshold values for all axes and both above and below thresholds
+ * - i.e. there is only one value */
+#define LIS3L02DQ_REG_THS_L_ADDRESS			0x2E
+#define LIS3L02DQ_REG_THS_H_ADDRESS			0x2F
+
+#define LIS3L02DQ_DEFAULT_CTRL1 (LIS3L02DQ_REG_CTRL_1_PD_ON	      \
+				 | LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE \
+				 | LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE \
+				 | LIS3L02DQ_REG_CTRL_1_AXES_X_ENABLE \
+				 | LIS3L02DQ_REG_CTRL_1_DF_128)
+
+#define LIS3L02DQ_DEFAULT_CTRL2	0
+
+#define LIS3L02DQ_DIRECT_ONLY_MODE	-1
+#define LIS3L02DQ_DIRECT_MODE		0
+#define LIS3L02DQ_INTERRUPT_MODE	1
+
+#define LIS3L02DQ_BUFFER_LENGTH		100
+
+struct lis3l02dq_work_cont {
+	struct work_struct ws;
+	struct work_struct ws_nocheck;
+	int address;
+	int mask;
+	struct lis3l02dq_state *st;
+};
+
+#define INIT_WORK_CONT(cont, _checkfunc, _nocheckfunc, _add, _mask, _st)\
+	do {								\
+	INIT_WORK(&(cont)->ws, _checkfunc);				\
+	INIT_WORK(&(cont)->ws_nocheck, _nocheckfunc);			\
+	(cont)->address = _add;						\
+	(cont)->mask = _mask;						\
+	(cont)->st = _st;						\
+	} while (0)
+
+struct lis3l02dq_state {
+	struct spi_device		*us;
+	struct work_struct		work_data_rdy_ring;
+	struct work_struct		work_data_rdy_event;
+	struct lis3l02dq_work_cont	work_cont_thresh;
+
+	/* Interrupt caught event - used as part of the datardy to ring bh
+	   in ensuring interrupt line does not become locked high */
+	bool				inter;
+	s64				last_timestamp;
+	struct industrialio_dev		*indio_dev;
+};
+#endif /* SPI_LIS3L02DQ_H_ */
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/adc/Makefile b/drivers/industrialio/adc/Makefile
--- a/drivers/industrialio/adc/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/adc/Makefile	2008-06-05 11:31:16.000000000 +0100
@@ -0,0 +1,3 @@
+
+# Makefile for industrial I/O ADC drivers
+#
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/industrial.c b/drivers/industrialio/industrial.c
--- a/drivers/industrialio/industrial.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/industrial.c	2008-06-26 18:26:12.000000000 +0100
@@ -0,0 +1,1172 @@
+/* The industrial I/O core
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Based on elements of hwmon and input subsystems.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/idr.h>
+#include <linux/kdev_t.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/poll.h>
+
+#include <linux/industrialio.h>
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("Industrial I/O core");
+MODULE_LICENSE("GPL");
+
+#define INDUSTRIALIO_ID_PREFIX "industrialio"
+#define INDUSTRIALIO_ID_FORMAT INDUSTRIALIO_ID_PREFIX "%d"
+#define INDUSTRIALIO_MAJOR 244
+
+/* Integer id  - used to assign each registered device a unique id*/
+static DEFINE_IDR(industrialio_idr);
+
+/* Single spinlock used to protect all the IDRs */
+static DEFINE_SPINLOCK(industrialio_idr_lock);
+
+struct class industrialio_class = {
+	.name = "industrialio",
+};
+EXPORT_SYMBOL_GPL(industrialio_class);
+
+static DEFINE_SPINLOCK(industrialio_state_lock);
+
+/* Struct used to maintain internal state about industrialio.
+ * This will be used to handle the character device accesses
+ * and redirect them to the relevant driver.
+ * Will reduce this to the included table if nothing else comes
+ * up that should go in here!
+ */
+struct __industrialio_state {
+	/* All initially set to NULL in init */
+	struct industrialio_handler *fhs[256];
+};
+
+
+static struct __industrialio_state industrialio_state;
+
+/* Used to escalate shared event.
+ * currently this only used with ring buffer events */
+static inline void
+__industrialio_change_event(struct industrialio_detected_event_list *ev,
+			    int ev_code,
+			    s64 timestamp)
+{
+	ev->ev.id = ev_code;
+	ev->ev.timestamp = timestamp;
+}
+
+/* Used both in the interrupt line put events and the ring buffer ones */
+static inline int
+__industrialio_put_event(struct industrialio_event_interface *ev_int,
+			 int ev_code,
+			 s64 timestamp,
+			 struct industrialio_shared_ev_pointer*
+			 shared_pointer_p)
+{
+	struct industrialio_detected_event_list *ev;
+	int ret;
+	/* Does anyone care? */
+	if (test_bit(INDUSTRIALIO_BUSY_BIT_POS, &ev_int->handler.flags)) {
+		if (ev_int->current_events
+		   == ev_int->max_events)
+			return 0;
+		ev = (struct industrialio_detected_event_list *)
+			(kmalloc(sizeof(struct
+					industrialio_detected_event_list),
+				 GFP_KERNEL));
+		if (ev == NULL) {
+			ret = -ENOMEM;
+			goto error_ret;
+		}
+
+		INIT_LIST_HEAD(&ev->list);
+		ev->ev.id = ev_code;
+		ev->ev.timestamp = timestamp;
+		if (shared_pointer_p != NULL) {
+			ev->shared_pointer = shared_pointer_p;
+			shared_pointer_p->ev_p = ev;
+		} else
+			ev->shared_pointer = NULL;
+		list_add_tail(&ev->list, &ev_int->det_events.list);
+		ev_int->current_events++;
+		wake_up_interruptible(&ev_int->wait);
+	}
+
+	return 0;
+error_ret:
+	return ret;
+
+}
+
+int industrialio_put_event(struct industrialio_dev *dev_info,
+			    int ev_line,
+			    int ev_code,
+			    s64 timestamp)
+{
+	return __industrialio_put_event(&dev_info->event_interfaces[ev_line],
+					ev_code,
+					timestamp, NULL);
+}
+EXPORT_SYMBOL(industrialio_put_event);
+
+/* Confirming validity of supplied irq is left to drivers */
+int industrialio_register_interrupt_line(unsigned int irq,
+					 struct industrialio_dev *dev_info,
+					 int line_number,
+					 unsigned long type,
+					 const char *name)
+{
+	int ret;
+
+	dev_info->interrupts[line_number] = (struct industrialio_interrupt *)
+		kmalloc(sizeof(struct industrialio_interrupt), GFP_KERNEL);
+	if (dev_info->interrupts[line_number] == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	INIT_LIST_HEAD(&dev_info->interrupts[line_number]->ev_list.list);
+	dev_info->interrupts[line_number]->line_number = line_number;
+	dev_info->interrupts[line_number]->irq = irq;
+	dev_info->interrupts[line_number]->dev_info = dev_info;
+
+	/* Possibly only request on demand?
+	 * Can see this may complicate the handling of interrupts.
+	 * However, with this approache we end up handling lots of
+	 * events noone cares about.*/
+	ret = request_irq(irq,
+			  &industrialio_interrupt_handler,
+			  type,
+			  name,
+			  dev_info->interrupts[line_number]);
+	if (ret < 0)
+		goto error_ret;
+
+	return 0;
+
+error_ret:
+	return ret;
+}
+EXPORT_SYMBOL(industrialio_register_interrupt_line);
+
+/* Before this runs the interrupt generator must have been disabled */
+void industrialio_unregister_interrupt_line(struct industrialio_dev *dev_info,
+					    int line_number)
+{
+	/* make sure the interrupt handlers are all done */
+	flush_scheduled_work();
+	free_irq(dev_info->interrupts[line_number]->irq,
+		 dev_info->interrupts[line_number]);
+	kfree(dev_info->interrupts[line_number]);
+}
+EXPORT_SYMBOL(industrialio_unregister_interrupt_line);
+
+/* Generic interrupt line interrupt handler */
+irqreturn_t industrialio_interrupt_handler(int irq, void *_int_info)
+{
+	struct industrialio_interrupt *int_info = _int_info;
+	struct industrialio_dev *dev_info = int_info->dev_info;
+	struct industrialio_event_handler_list *p;
+	s64 time_ns;
+
+	if (list_empty(&int_info->ev_list.list))
+		return IRQ_NONE;
+
+	time_ns = industrialio_get_time_ns();
+	/* detect single element list*/
+	if (int_info->ev_list.list.next->next == &int_info->ev_list.list) {
+		disable_irq_nosync(irq);
+		p = list_first_entry(&int_info->ev_list.list,
+				     struct industrialio_event_handler_list,
+				     list);
+		p->handler(dev_info, 1, time_ns, 1);
+	} else
+		list_for_each_entry(p, &int_info->ev_list.list, list)
+		{
+			disable_irq_nosync(irq);
+			p->handler(dev_info, 1, time_ns, 0);
+		}
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL(industrialio_interrupt_handler);
+
+int industrialio_add_event_to_list(struct industrialio_event_handler_list *list,
+				   struct industrialio_event_handler_list *el)
+{
+	if (el->refcount == 0)
+		list_add(&list->list, &el->list);
+	el->refcount++;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(industrialio_add_event_to_list);
+
+int industrialio_remove_event_from_list(struct industrialio_event_handler_list
+					*el)
+{
+	el->refcount--;
+	if (el->refcount == 0)
+		list_del_init(&el->list);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(industrialio_remove_event_from_list);
+
+
+static int industrialio_allocate_chrdev(struct industrialio_handler *handler)
+{
+	int id;
+	spin_lock(industrialio_state_lock);
+	/* Find an unused device - fixme, more efficient options?*/
+	for (id = 0; id <= 256; id++)
+		if (industrialio_state.fhs[id] == NULL)
+			break;
+	if (id == 256) { /*FIXME incorrect error code ?*/
+		spin_unlock(industrialio_state_lock);
+		return -ENOMEM;
+	}
+	industrialio_state.fhs[id] = handler;
+	spin_unlock(industrialio_state_lock);
+	handler->id = id;
+
+	return 0;
+}
+
+
+static void industrialio_deallocate_chrdev(struct industrialio_handler *handler)
+{
+	spin_lock(industrialio_state_lock);
+	industrialio_state.fhs[handler->id] = NULL;
+	spin_unlock(industrialio_state_lock);
+}
+
+/* Upon open, switch in the correct file ops
+ * lifted directly from input subsystem */
+static int industrialio_open_file(struct inode *inode, struct file *file)
+{
+	struct industrialio_handler *handler;
+	const struct file_operations *old_fops, *new_fops = NULL;
+	int err;
+
+
+	/* This lock needed as unlike input we are dynamically allocating
+	 * chrdevs */
+	spin_lock(industrialio_state_lock);
+	handler = industrialio_state.fhs[iminor(inode)];
+	spin_unlock(industrialio_state_lock);
+	if (!handler || !(new_fops == fops_get(handler->fops)))
+		return -ENODEV;
+	/* cribbed from lp.c - not entirely certain if the fops_put is
+	 * necessary */
+
+	if (test_and_set_bit(INDUSTRIALIO_BUSY_BIT_POS, &handler->flags)) {
+		fops_put(file->f_op);
+		return -EBUSY;
+	}
+
+	if (!new_fops->open) {
+		fops_put(new_fops);
+		return -ENODEV;
+	}
+	old_fops = file->f_op;
+	file->f_op = new_fops;
+	/* use the private data pointer in file to give access to device
+	 * specific stuff */
+	file->private_data = handler->private;
+	err = new_fops->open(inode, file);
+
+	if (err) {
+		fops_put(file->f_op);
+		file->f_op = fops_get(old_fops);
+	}
+	fops_put(old_fops);
+
+	return err;
+}
+
+
+/* The main file ops structure. All open calls on the major number will
+ * be handled by this with fops for the actual minor number assigned by
+ * switching function above */
+
+static const struct file_operations industrialio_fops = {
+	.owner = THIS_MODULE,
+	.open = industrialio_open_file,
+};
+static int count;
+/* Ring buffer related functionality */
+int industrialio_store_to_ring(struct industrialio_ring_buffer *ring,
+			       unsigned char *data,
+			       s64 timestamp)
+{
+	bool init_read = true;
+	int ret;
+	int code;
+
+	/* initial store */
+	if (unlikely(ring->write_p == 0)) {
+		ring->write_p = ring->data;
+		/* doesn't actually matter if this is out of the set
+		 * FIXME deal with odd ring length */
+		ring->half_p = ring->data - ring->length*ring->skip / 2;
+		init_read = false;
+	}
+	memcpy(ring->write_p, data, ring->size);
+	memcpy(ring->write_p + ring->size, &timestamp, sizeof(s64));
+		barrier();
+	ring->last_written_p = ring->write_p;
+	barrier();
+	ring->write_p += ring->skip;
+	/* End of ring, back to the beginning */
+	if (ring->write_p == ring->data + ring->length*ring->skip) {
+		ring->write_p = ring->data;
+		ring->loopcount++;
+	}
+	if (ring->read_p == 0)
+		ring->read_p = ring->data;
+	/* Buffer full - move the read pointer and create / escalate
+	 * ring event */
+	else if (ring->write_p == ring->read_p) {
+		ring->read_p += ring->skip;
+		if (ring->read_p == ring->data + ring->length*ring->skip)
+			ring->read_p = ring->data;
+		/* Needs protection against unexpected delete? How? */
+		spin_lock(ring->shared_ev_pointer.lock);
+		if (ring->shared_ev_pointer.ev_p) {
+			/* Event escalation - probably quicker to let this
+			   keep running than check if it is necessary */
+			code = INDUSTRIALIO_EVENT_CODE_RING_100_FULL;
+			__industrialio_change_event(ring
+						    ->shared_ev_pointer.ev_p,
+						    code,
+						    timestamp);
+		} else {
+			code = INDUSTRIALIO_EVENT_CODE_RING_100_FULL;
+			ret = __industrialio_put_event(&ring->ev_int,
+						       code,
+						       timestamp,
+						       &ring
+						       ->shared_ev_pointer);
+			if (ret) {
+				spin_unlock(ring->shared_ev_pointer.lock);
+				goto error_ret;
+			}
+		}
+		spin_unlock(ring->shared_ev_pointer.lock);
+
+	}
+
+
+	/* investigate if our event barrier has been passed */
+	/* There are definite 'issues' with this and chances of
+	 * simultaneous read */
+	/* Also need to use loop count to ensure this only happens once */
+	ring->half_p += ring->skip;
+	if (ring->half_p == ring->data + ring->length*ring->skip)
+		ring->half_p = ring->data;
+	if (ring->half_p == ring->read_p) {
+		spin_lock(ring->shared_ev_pointer.lock);
+		code = INDUSTRIALIO_EVENT_CODE_RING_50_FULL;
+		ret = __industrialio_put_event(&ring->ev_int,
+					       code,
+					       timestamp,
+					       &ring->shared_ev_pointer);
+		spin_unlock(ring->shared_ev_pointer.lock);
+		if (ret)
+			goto error_ret;
+	}
+	return 0;
+error_ret:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(industrialio_store_to_ring);
+
+int industrialio_read_last_from_ring(struct industrialio_ring_buffer *ring,
+					    unsigned char *data)
+{
+	int loopcount_copy;
+	unsigned char *last_written_p_copy;
+again:
+	loopcount_copy = ring->loopcount;
+	barrier();
+	last_written_p_copy = ring->last_written_p;
+	barrier(); /*unnessecary? */
+
+	memcpy(data, last_written_p_copy, ring->size);
+
+	if (unlikely(loopcount_copy != ring->loopcount)) {
+		if (unlikely(ring->last_written_p >= last_written_p_copy))
+			goto again;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(industrialio_read_last_from_ring);
+
+ssize_t industrialio_interrupt_read(struct file *filep,
+				    char *buf,
+				    size_t count,
+				    loff_t *f_ps)
+{
+	struct industrialio_event_interface *ev_int = filep->private_data;
+	struct industrialio_detected_event_list *el;
+	int ret;
+	/* event interface has a list of events
+	 * - if empty and blocking, block */
+	/* need lock to protect this list ?*/
+
+	if (list_empty(&ev_int->det_events.list)) {
+		if (filep->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		/* So we are blocking on this device waiting for something
+		 * to be there */
+		/* FIXME: Take into account risk that something may have
+		 * disappeared in meantime!*/
+		ret = wait_event_interruptible(ev_int->wait,
+					       !list_empty(&ev_int
+							   ->det_events.list));
+		if (ret)
+			return ret;
+	}
+
+	el = list_first_entry(&ev_int->det_events.list,
+			      struct industrialio_detected_event_list,
+			      list);
+
+	if (copy_to_user(buf, &(el->ev),
+			 sizeof(struct industrialio_event_data)))
+		return -EFAULT;
+
+	list_del(&el->list);
+	ev_int->current_events--;
+	/* Need to zero pointer to shared element*/
+	spin_lock(el->shared_pointer->lock);
+	if (el->shared_pointer)
+		(el->shared_pointer->ev_p) = NULL;
+	spin_unlock(el->shared_pointer->lock);
+	kfree(el);
+
+	return sizeof(struct industrialio_event_data);
+}
+
+int industrialio_interrupt_release(struct inode *inode, struct file *filep)
+{
+	struct industrialio_event_interface *ev_int = filep->private_data;
+
+	module_put(ev_int->owner);
+	clear_bit(INDUSTRIALIO_BUSY_BIT_POS, &ev_int->handler.flags);
+
+	return 0;
+}
+
+int industrialio_interrupt_open(struct inode *inode, struct file *filep)
+{
+	struct industrialio_event_interface *ev_int = filep->private_data;
+	try_module_get(ev_int->owner);
+
+	return 0;
+}
+static const struct file_operations industrialio_interrupt_fileops = {
+	.read =  industrialio_interrupt_read,
+	.release = industrialio_interrupt_release,
+	.open = industrialio_interrupt_open,
+	.owner = THIS_MODULE,
+};
+
+
+static ssize_t industrialio_show_attr_minor(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	int len;
+
+	struct industrialio_chrdev_minor_attr *_attr
+		= to_industrialio_chrdev_minor_attr(attr);
+	len = sprintf(buf, "%d\n", _attr->minor);
+
+	return len;
+}
+static inline int
+industrialio_setup_ev_int(struct industrialio_event_interface *ev_int,
+			  const char *name,
+			  struct module *owner,
+			  struct device *dev)
+{
+	int ret;
+	/* FIXME MAKE THIS VARIABLE! */
+	ev_int->max_events = 10;
+	ev_int->current_events = 0;
+	INIT_LIST_HEAD(&ev_int->det_events.list);
+	init_waitqueue_head(&ev_int->wait);
+	ev_int->handler.fops = &industrialio_interrupt_fileops;
+	ev_int->handler.private = ev_int;
+	ev_int->handler.flags = 0;
+	ret = industrialio_allocate_chrdev(&ev_int->handler);
+	if (ret)
+		goto error_ret;
+	ev_int->attr.dev_attr.attr.name = (const char *)(name);
+	ev_int->attr.dev_attr.attr.owner = owner;
+	ev_int->owner = owner;
+	ev_int->attr.minor = ev_int->handler.id;
+	ev_int->attr.dev_attr.attr.mode = S_IRUGO;
+	ev_int->attr.dev_attr.show = &industrialio_show_attr_minor;
+	ret = sysfs_create_file(&dev->kobj, &ev_int->attr.dev_attr.attr);
+	if (ret)
+		goto error_deallocate_chrdev;
+
+	return 0;
+error_deallocate_chrdev:
+	industrialio_deallocate_chrdev(&ev_int->handler);
+error_ret:
+	return ret;
+}
+
+static inline void
+industrialio_free_ev_int(struct industrialio_event_interface *ev_int,
+						     struct device *dev)
+{
+	sysfs_remove_file(&dev->kobj, &ev_int->attr.dev_attr.attr);
+	industrialio_deallocate_chrdev(&ev_int->handler);
+}
+
+
+
+
+/*
+ * Create a character device for reading from local ring buffer. One of
+ * these per device.
+ * Create this as part of a request for a ring buffer? Yes. If it's not
+ * there then the device does not have an associate ring buffer!
+ * How to make reading through to a hardware ring buffer transparent?
+ */
+
+
+int industrialio_ring_open(struct inode *inode, struct file *filp)
+{
+	/* So now we need to know where this should go !*/
+	struct industrialio_ring_buffer *ring = filp->private_data;
+	/*Fixme MESSY - should the ring have an owner?*/
+	try_module_get(ring->access_minor_attr.dev_attr.attr.owner);
+
+	return 0;
+}
+
+int industrialio_ring_release(struct inode *inode, struct file *filp)
+{
+	struct industrialio_ring_buffer *ring = filp->private_data;
+
+	module_put(ring->access_minor_attr.dev_attr.attr.owner);
+	clear_bit(INDUSTRIALIO_BUSY_BIT_POS, &ring->access_handler.flags);
+
+	return 0;
+}
+
+/* no point in ripping more than nearest number of whole records below count */
+/* Depending on movement of pointers in the meantime this may return a lot
+ * less than count*/
+/* Also, we aren't going to wait for enough data to be available */
+/* NEEDS CODE REVIEW */
+ssize_t industrialio_ring_rip(struct file *filp,
+			      char *buf,
+			      size_t count,
+			      loff_t *f_ps)
+{
+	unsigned char *initial_read_p, *initial_write_p,
+		*current_read_p, *end_read_p;
+
+	struct industrialio_ring_buffer *ring = filp->private_data;
+	unsigned char *data_cpy;
+	int dead_offset;
+	int bytes_to_rip = 0;
+	int max_copied;
+
+	bytes_to_rip = (count - count % ring->skip);
+	/*fixme, needed? */
+	if (bytes_to_rip > ring->skip*ring->length)
+		bytes_to_rip = ring->skip*ring->length;
+	data_cpy = (unsigned char *)(kmalloc(bytes_to_rip, GFP_KERNEL));
+	/* Handle -ENOMEM*/
+	/* build local copy */
+	initial_read_p = ring->read_p;
+	if (unlikely(initial_read_p == 0))
+		goto err;
+	initial_write_p = ring->write_p;
+
+	/* Need a consistent pair */
+	while (initial_read_p != ring->read_p
+	      || initial_write_p != ring->write_p) {
+		initial_read_p = ring->read_p;
+		initial_write_p = ring->write_p;
+	}
+	if (initial_write_p == initial_read_p)
+		goto err;
+	/* write is at later location than read */
+
+	if (initial_write_p > initial_read_p + bytes_to_rip) {
+		/* write_p is greater than necessary, all is easy */
+		max_copied = bytes_to_rip;
+		memcpy(data_cpy, initial_read_p, max_copied);
+		end_read_p = initial_read_p + max_copied;
+	} else if (initial_write_p > initial_read_p) {
+		/*not enough data to cpy */
+		max_copied = initial_write_p - initial_read_p;
+		memcpy(data_cpy, initial_read_p, max_copied);
+		end_read_p = initial_write_p;
+	} else {
+		max_copied = ring->data
+			+ ring->length*ring->skip - initial_read_p;
+		memcpy(data_cpy, initial_read_p, max_copied);
+		if (initial_write_p > ring->data + bytes_to_rip - max_copied) {
+			/* enough data to finish */
+			memcpy(data_cpy, ring->data, bytes_to_rip - max_copied);
+			max_copied = bytes_to_rip;
+			end_read_p = ring->data + (bytes_to_rip - max_copied);
+		} else {  /* not enough data */
+			memcpy(data_cpy, ring->data,
+			       initial_write_p - ring->data);
+			max_copied += initial_write_p - ring->data;
+			end_read_p = initial_write_p;
+		}
+	}
+	/* Now to verify which section was cleanly copied - i.e. how far
+	 * read pointer has been pushed */
+	current_read_p = ring->read_p;
+
+	if (initial_read_p <= current_read_p)
+		dead_offset = current_read_p - initial_read_p;
+	else
+		dead_offset = ring->length*ring->skip - (initial_read_p
+							 - current_read_p);
+	/* setup the next read position */
+	ring->read_p = end_read_p;
+	/* possible issue if the initial write has been lapped or indeed
+	 * the point we were reading to has been passed */
+	/* No valid data read */
+	if (max_copied - dead_offset < 0)
+		return 0;
+
+	if (copy_to_user(buf, data_cpy + dead_offset,
+			 max_copied - dead_offset))
+		return -EFAULT;
+	kfree(data_cpy);
+	return max_copied - dead_offset;
+err:
+	kfree(data_cpy);
+	return 0;
+}
+
+static const struct file_operations industrialio_ring_fileops = {
+	.read = industrialio_ring_rip,
+	.release = industrialio_ring_release,
+	.open = industrialio_ring_open,
+	/* true? */
+	.owner = THIS_MODULE,
+};
+
+void industrialio_free_ring_buffer(struct industrialio_ring_buffer *ring,
+				   struct device *dev)
+{
+	sysfs_remove_file(&dev->kobj, &ring->access_minor_attr.dev_attr.attr);
+	industrialio_deallocate_chrdev(&ring->access_handler);
+	kfree(ring->access_minor_name);
+	industrialio_free_ev_int(&ring->ev_int, dev);
+	kfree(ring->event_minor_name);
+	FREE_INDUSTRIALIO_RING_BUFFER(ring);
+	kfree(ring);
+}
+EXPORT_SYMBOL_GPL(industrialio_free_ring_buffer);
+
+int industrialio_request_ring_buffer(int dimension,
+				     int bytes_per_reading,
+				     int length,
+				     struct industrialio_ring_buffer **ring,
+				     int id,
+				     struct module *owner,
+				     struct device *dev)
+{
+	int ret;
+/* Actually do the ring buffer initialization */
+	*ring = (struct industrialio_ring_buffer *)
+		(kmalloc(sizeof(struct industrialio_ring_buffer),
+			 GFP_KERNEL));
+
+	if (*ring == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	INIT_INDUSTRIALIO_RING_BUFFER(*ring,
+				      dimension,
+				      bytes_per_reading,
+				      length);
+	if ((*ring)->data == NULL) {
+		ret = -ENOMEM;
+		goto error_free_ring;
+	}
+
+/* Create and register the event character device */
+	(*ring)->event_minor_name = kmalloc(20, GFP_KERNEL);
+	if ((*ring)->event_minor_name == NULL) {
+		ret = -ENOMEM;
+		goto error_free_ring_data;
+	}
+	sprintf((*ring)->event_minor_name, "ring_buffer%d_ev_minor", id);
+
+	ret = industrialio_setup_ev_int(&(*ring)->ev_int,
+					(const char *)
+					((*ring)->event_minor_name),
+					owner,
+					dev);
+	if (ret)
+		goto error_free_event_minor_name;
+	(*ring)->ev_int.private = (*ring);
+/* Create and register the access character device */
+	(*ring)->access_minor_name = kmalloc(20, GFP_KERNEL);
+	if ((*ring)->access_minor_name == NULL) {
+		ret = -ENOMEM;
+		goto error_free_event_interface;
+	}
+	sprintf((*ring)->access_minor_name, "ring_buffer%d_access_minor", id);
+
+	ret = industrialio_allocate_chrdev(&(*ring)->access_handler);
+	if (ret)
+		goto error_free_access_minor_name;
+	(*ring)->access_handler.fops = &industrialio_ring_fileops;
+	(*ring)->access_handler.private = (*ring);
+	(*ring)->access_minor_attr.dev_attr.attr.name
+		= (const char *)((*ring)->access_minor_name);
+	(*ring)->access_minor_attr.dev_attr.attr.owner = owner;
+	(*ring)->access_minor_attr.dev_attr.attr.mode = S_IRUGO;
+	(*ring)->access_minor_attr.minor = (*ring)->access_handler.id;
+	(*ring)->access_minor_attr.dev_attr.show
+		= &industrialio_show_attr_minor;
+	ret = sysfs_create_file(&dev->kobj,
+				&(*ring)->access_minor_attr.dev_attr.attr);
+	if (ret)
+		goto error_deallocate_chrdev;
+
+	return 0;
+error_deallocate_chrdev:
+	industrialio_deallocate_chrdev(&(*ring)->access_handler);
+error_free_access_minor_name:
+	kfree((*ring)->access_minor_name);
+error_free_event_interface:
+	industrialio_free_ev_int(&(*ring)->ev_int,
+					  dev);
+error_free_event_minor_name:
+	kfree((*ring)->event_minor_name);
+error_free_ring_data:
+	FREE_INDUSTRIALIO_RING_BUFFER(*ring);
+error_free_ring:
+	kfree(*ring);
+error_ret:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(industrialio_request_ring_buffer);
+
+
+static int __init industrialio_init(void)
+{
+	int ret;
+
+	memset(industrialio_state.fhs,
+	       sizeof(struct industrialio_handler *)*256,
+	       0);
+
+	/* Create sysfs class */
+	ret  = class_register(&industrialio_class);
+	if (ret < 0) {
+		printk(KERN_ERR
+		       "industrialio.c: could not create sysfs class\n");
+		goto error_nothing;
+	}
+
+	/* Register the industrialio major number character device */
+	/* Various things can then result in minor numbers being allocated
+	 * by the subsystem
+	 * 1) Event device - possibly more than one?
+	 * 2) Ring buffer read device
+	 */
+
+	ret = register_chrdev(INDUSTRIALIO_MAJOR, "bob", &industrialio_fops);
+	if (ret) {
+		printk(KERN_ERR
+		       "industrialio: unable to register a char major %d",
+		       INDUSTRIALIO_MAJOR);
+		goto error_unregister_class;
+	}
+
+
+	return 0;
+error_unregister_class:
+	class_unregister(&industrialio_class);
+error_nothing:
+	return ret;
+}
+
+static void __exit industrialio_exit(void)
+{
+	unregister_chrdev(INDUSTRIALIO_MAJOR, "bob");
+	class_unregister(&industrialio_class);
+}
+/* A series of functions that are effectively parts of
+ * device register.  This structure is simpler to debug than
+ * a unified function.
+ * Each has corresponding unregister function*/
+
+
+int industrialio_device_register_sysfs(struct industrialio_dev *dev_info)
+{
+	int ret;
+
+	dev_info->sysfs_dev = device_create(&industrialio_class,
+					    dev_info->dev,
+					    MKDEV(0, 0),
+					    INDUSTRIALIO_ID_FORMAT,
+					    dev_info->id);
+
+	if (IS_ERR(dev_info->sysfs_dev)) {
+		/* what would correct error here be?*/
+		ret = -EINVAL;
+		goto error_ret;
+	}
+	/* register attributes */
+	ret = sysfs_create_group(&dev_info->dev->kobj, dev_info->attrs);
+	if (ret) {
+		dev_err(dev_info->dev, "Failed to register sysfs hooks\n");
+		goto error_free_sysfs_device;
+	}
+
+	return 0;
+error_free_sysfs_device:
+	device_unregister(dev_info->dev);
+
+error_ret:
+	return ret;
+}
+
+void industrialio_device_unregister_sysfs(struct industrialio_dev *dev_info)
+{
+	sysfs_remove_group(&dev_info->dev->kobj, dev_info->attrs);
+	device_unregister(dev_info->sysfs_dev);
+}
+
+int industrialio_device_register_id(struct industrialio_dev *dev_info)
+{
+	int ret;
+idr_again:
+	if (unlikely(idr_pre_get(&industrialio_idr, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	spin_lock(&industrialio_idr_lock);
+	ret = idr_get_new(&industrialio_idr, NULL, &dev_info->id);
+	spin_unlock(&industrialio_idr_lock);
+	if (unlikely(ret == -EAGAIN))
+		goto idr_again;
+	else if (unlikely(ret))
+		return ret;
+
+	dev_info->id = dev_info->id & MAX_ID_MASK;
+	return 0;
+}
+void industrialio_device_unregister_id(struct industrialio_dev *dev_info)
+{
+	/* Can I use the save id? */
+	int id;
+	if (likely(sscanf(dev_info->sysfs_dev->bus_id,
+			  INDUSTRIALIO_ID_FORMAT, &id) == 1)) {
+		spin_lock(&industrialio_idr_lock);
+		idr_remove(&industrialio_idr, id);
+		spin_unlock(&industrialio_idr_lock);
+	} else
+		dev_dbg(dev_info->dev->parent,
+			"indio_device_unregister() failed: bad class ID!\n");
+}
+
+int industrialio_device_register_eventset(struct industrialio_dev *dev_info)
+{
+	int ret, i;
+	char *name;
+	struct device_attribute *devattr;
+	struct industrialio_event_attr *indio_devattr;
+	/* Establish whether interrupts are actually possible */
+	/*fixme - still in driver for now */
+
+	dev_info->event_interfaces = (struct industrialio_event_interface *)
+		(kzalloc(sizeof(struct industrialio_event_interface)
+			 *dev_info->num_interrupt_lines,
+			 GFP_KERNEL));
+	if (dev_info->event_interfaces == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	/* assign id's to the event_interface elements */
+	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
+		dev_info->event_interfaces[i].id = i;
+		/* FIXME: done in event_setup as well? */
+		dev_info->event_interfaces[i].owner = dev_info->driver_module;
+	}
+	dev_info->interrupts
+		= (struct industrialio_interrupt **)
+		kmalloc(sizeof(struct industrialio_interrupt *)
+			*dev_info->num_interrupt_lines,
+			GFP_KERNEL);
+	if (dev_info->interrupts == NULL) {
+		dev_err(dev_info->dev,
+			"Failed to register sysfs hooks for events attributes");
+		ret = -ENOMEM;
+		goto error_free_event_interfaces;
+	}
+
+	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
+		name = kmalloc(20, GFP_KERNEL);
+		if (name == NULL) {
+			ret = -ENOMEM;
+			goto error_ret;
+		}
+		sprintf(name, "event_line%d_minor", i);
+		ret = industrialio_setup_ev_int(&dev_info->event_interfaces[i],
+						(const char *)(name),
+						dev_info->driver_module,
+						dev_info->dev);
+		if (ret) {
+			dev_err(dev_info->dev,
+				"Could not get chrdev interface\n");
+		}
+	}
+	ret = sysfs_create_group(&dev_info->dev->kobj, dev_info->event_attrs);
+	if (ret) {
+		dev_err(dev_info->dev,
+			"Failed to register sysfs hooks for events attributes");
+		goto error_free_interrupts;
+	}
+	/* May double initialize lists in case of shared handlers,
+	   but other than slight overhead that isn't a problem */
+	i = 0;
+	while (1) {
+		if (dev_info->event_attrs->attrs[i] == NULL)
+			break;
+		devattr = container_of(dev_info->event_attrs->attrs[i],
+				       struct device_attribute, attr);
+		indio_devattr = to_industrialio_event_attr(devattr);
+		INIT_LIST_HEAD(&indio_devattr->listel->list);
+		i++;
+	}
+	return 0;
+
+error_free_interrupts:
+	kfree(dev_info->interrupts);
+error_free_event_interfaces:
+	kfree(dev_info->event_interfaces);
+error_ret:
+	return ret;
+}
+
+void industrialio_device_unregister_eventset(struct industrialio_dev *dev_info)
+{
+	int i;
+	for (i = 0; i < dev_info->num_interrupt_lines; i++)
+		industrialio_free_ev_int(&dev_info->event_interfaces[i],
+					 dev_info->dev);
+	sysfs_remove_group(&dev_info->dev->kobj, dev_info->event_attrs);
+	kfree(dev_info->event_interfaces);
+}
+
+/*Simple paramater read and set for ring buffer */
+static ssize_t industrialio_read_ring_dim(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	int len;
+	struct industrialio_dev *dev_info = dev_get_drvdata(dev);
+
+	len = sprintf(buf, "%d\n", dev_info->ring_dimension);
+
+	return len;
+}
+
+static ssize_t industrialio_write_ring_dim(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf,
+					   size_t len)
+{
+	/* FIXME: move to dynamically adjustable as and when ring is dynamically
+	   allocated */
+	return len;
+}
+
+static ssize_t industrialio_read_ring_length(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	int len;
+	struct industrialio_dev *dev_info = dev_get_drvdata(dev);
+
+	len = sprintf(buf, "%d\n", dev_info->ring_length);
+
+	return len;
+
+	return 0;
+}
+
+static ssize_t industrialio_write_ring_length(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf,
+					      size_t len)
+{
+	/* FIXME: move to user adjustable as and when ring is dynamically
+	   activated */
+	return len;
+}
+
+static ssize_t industrialio_read_ring_bps(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	int len;
+	struct industrialio_dev *dev_info = dev_get_drvdata(dev);
+
+	len = sprintf(buf, "%d\n", dev_info->ring_bytes_per_reading);
+
+	return len;
+}
+
+static ssize_t industrialio_write_ring_bps(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf,
+					   size_t len)
+{
+	/*Not sure it will ever make sense to make this user adjustable!*/
+	return len;
+}
+
+DEVICE_ATTR(dimension, S_IRUGO | S_IWUSR,
+	    industrialio_read_ring_dim,
+	    industrialio_write_ring_dim);
+DEVICE_ATTR(length, S_IRUGO | S_IWUSR,
+	    industrialio_read_ring_length,
+	    industrialio_write_ring_length);
+DEVICE_ATTR(bps, S_IRUGO | S_IWUSR,
+	    industrialio_read_ring_bps,
+	    industrialio_write_ring_bps);
+
+
+static struct attribute *industrialio_ring_attributes[] = {
+	&dev_attr_dimension.attr,
+	&dev_attr_length.attr,
+	&dev_attr_bps.attr,
+
+	NULL,
+};
+
+static const struct attribute_group industrialio_ring_attribute_group = {
+	.name = "ring_buffer_attributes",
+	.attrs = industrialio_ring_attributes,
+};
+
+
+
+int industrialio_device_register_ring(struct industrialio_dev *dev_info, int id)
+{
+	int ret;
+
+	/* FIXME: actual ring alloc should be on demand, not here
+	* For now I'm simply ignoring any ring buffer parameter changes!*/
+	ret = industrialio_request_ring_buffer(dev_info->ring_dimension,
+					       dev_info->ring_bytes_per_reading,
+					       dev_info->ring_length,
+					       &dev_info->ring,
+					       id,
+					       dev_info->driver_module,
+					       dev_info->dev);
+	if (ret < 0)
+		goto error_ret;
+	ret = sysfs_create_group(&dev_info->dev->kobj,
+				 &industrialio_ring_attribute_group);
+	if (ret < 0)
+		goto error_free_ring;
+
+	return 0;
+
+error_free_ring:
+	industrialio_free_ring_buffer(dev_info->ring, dev_info->dev);
+error_ret:
+	return ret;
+}
+
+void industrialio_device_unregister_ring(struct industrialio_dev *dev_info)
+{
+	sysfs_remove_group(&dev_info->dev->kobj,
+			   &industrialio_ring_attribute_group);
+	/* deallocate ring buffer related stuff */
+	if (dev_info->modes & (INDIO_RING_POLLED | INDIO_RING_DATA_RDY))
+		industrialio_free_ring_buffer(dev_info->ring, dev_info->dev);
+
+}
+
+int industrialio_device_register(struct industrialio_dev *dev_info)
+{
+	int ret;
+	dev_set_drvdata(dev_info->dev, (void *)(dev_info));
+
+/*Get a unique id */
+	ret = industrialio_device_register_id(dev_info);
+	if (ret)
+		goto error_nothing;
+
+/* Create sysfs device */
+	ret = industrialio_device_register_sysfs(dev_info);
+	if (ret)
+		goto error_free_idr;
+
+/* Interrupt triggered events setup */
+	ret = industrialio_device_register_eventset(dev_info);
+	if (ret)
+		goto error_free_sysfs;
+
+/* Ring buffer init if relevant */
+	/* FIXME: multiple ring buffers? */
+	if (dev_info->modes & (INDIO_RING_POLLED | INDIO_RING_DATA_RDY)) {
+		ret = industrialio_device_register_ring(dev_info, 0);
+		if (ret)
+			goto error_free_eventset;
+	}
+	return 0;
+/* Clean up the shrapnel of any failures */
+
+error_free_eventset:
+	industrialio_device_unregister_eventset(dev_info);
+
+error_free_sysfs:
+	industrialio_device_unregister_sysfs(dev_info);
+
+error_free_idr:
+	industrialio_device_unregister_id(dev_info);
+
+error_nothing:
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(industrialio_device_register);
+
+void industrialio_device_unregister(struct industrialio_dev *dev_info)
+{
+	if (dev_info->modes & (INDIO_RING_POLLED | INDIO_RING_DATA_RDY))
+		industrialio_device_unregister_ring(dev_info);
+	industrialio_device_unregister_eventset(dev_info);
+	industrialio_device_unregister_sysfs(dev_info);
+	industrialio_device_unregister_id(dev_info);
+
+}
+EXPORT_SYMBOL_GPL(industrialio_device_unregister);
+
+subsys_initcall(industrialio_init);
+module_exit(industrialio_exit);
diff -uprN -X a/Documentation/dontdiff a/drivers/industrialio/misc/Makefile b/drivers/industrialio/misc/Makefile
--- a/drivers/industrialio/misc/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/misc/Makefile	2008-06-05 11:31:46.000000000 +0100
@@ -0,0 +1,3 @@
+#
+# Makefile for industrial I/O misc drivers
+#
\ No newline at end of file

--------------040802060900060503060200--
