Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYGWROa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYGWROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYGWROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:14:22 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:38013 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYGWROU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:14:20 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <488766F4.20603@gmail.com>
Date: Wed, 23 Jul 2008 18:14:28 +0100
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
Subject: [Patch 3/4] ST LIS3L02DQ accelerometer
References: <488763AD.4050400@gmail.com>
In-Reply-To: <488763AD.4050400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

Add support for ST LIS3L02DQ accelerometer as found on the xbow imote2 sensor
board. Provides direct access via sysfs interfaces and a software ring buffer
using the chips datardy interrupt as a trigger. Motion detection and data ready
events are available on a chrdev as are ring buffer 50% and 100% full events.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
Patch depends on iio_core patch
drivers/industrialio/Kconfig                   |    1
drivers/industrialio/Makefile                  |    1
drivers/industrialio/accelerometer/Kconfig     |   19
drivers/industrialio/accelerometer/Makefile    |    5
drivers/industrialio/accelerometer/lis3l02dq.c | 1371 +++++++++++++++++++++++++
drivers/industrialio/accelerometer/lis3l02dq.h |  168 +++
6 files changed, 1565 insertions(+)

--- a/drivers/industrialio/Makefile	2008-07-23 16:49:28.000000000 +0100
+++ b/drivers/industrialio/Makefile	2008-07-23 16:54:42.000000000 +0100
@@ -7,3 +7,4 @@ obj-$(CONFIG_INDUSTRIALIO)	+= industrial
 obj-$(CONFIG_INDUSTRIALIO_PTIMER_BOARDINFO) += industrialio_ptimer_board_info.o
 
 obj-y += adc/
+obj-y += accelerometer/
--- a/drivers/industrialio/Kconfig	2008-07-23 16:52:14.000000000 +0100
+++ b/drivers/industrialio/Kconfig	2008-07-23 15:44:45.000000000 +0100
@@ -16,6 +16,7 @@ config INDUSTRIALIO_PTIMER_BOARDINFO
        boolean
        default y
 
+source drivers/industrialio/accelerometer/Kconfig
 source drivers/industrialio/adc/Kconfig
 
 endif
--- a/drivers/industrialio/accelerometer/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/Kconfig	2008-07-23 16:57:39.000000000 +0100
@@ -0,0 +1,19 @@
+#
+# Accelerometer drivers
+#
+
+config LIS3L02DQ
+	tristate "ST Microelectronics LIS3L02DQ Accelerometer Driver"
+	help
+	  Say yes here to build generic support for the ST microelectronics
+	  accelerometer. You will also need to one or more of the bus specific
+	  elements below. The driver supplies direct access via sysfs files
+	  and a software ring buffer using a supplied datardy interrupt.
+
+config LIS3L02DQ_SPI
+	depends on LIS3L02DQ && SPI
+	tristate "SPI support"
+	help
+	  Say yes here to build support for the ST LIS3L02DQ accelerometer via
+	  an SPI bus.
+
--- a/drivers/industrialio/accelerometer/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/Makefile	2008-07-14 17:26:34.000000000 +0100
@@ -0,0 +1,5 @@
+#
+# Makefile for industrial I/O accelerometer drivers
+#
+
+obj-$(CONFIG_LIS3L02DQ_SPI)	+= lis3l02dq.o
--- a/drivers/industrialio/accelerometer/lis3l02dq.h	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/lis3l02dq.h	2008-07-21 17:29:56.000000000 +0100
@@ -0,0 +1,168 @@
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
+ */
+
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
+
+
+struct lis3l02dq_state {
+	struct spi_device		*us;
+	struct work_struct		work_data_rdy_ring;
+	struct work_struct		work_data_rdy_event;
+	struct iio_work_cont		work_cont_thresh;
+
+	/* Interrupt caught event - used as part of the datardy to ring bh
+	   in ensuring interrupt line does not become locked high */
+	bool				inter;
+	s64				last_timestamp;
+	struct iio_dev			*indio_dev;
+
+};
+#endif /* SPI_LIS3L02DQ_H_ */
--- a/drivers/industrialio/accelerometer/lis3l02dq.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/industrialio/accelerometer/lis3l02dq.c	2008-07-23 17:02:12.000000000 +0100
@@ -0,0 +1,1371 @@
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
+ * 16 bit left justified mode used.
+ *
+ * Not implemented as yet - 'channel' selection for scan. This will probably
+ * look quite similar to the mode selection code in max1363 but will affect only
+ * which channels are read and pushed to the ring.
+ * Complexities arise in preventing reads from ring for elements that are not
+ * there. Could move to an entirely 'scan' based interface, but at the cost
+ * of allowing direct reading (problem or not?).
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+
+#include <linux/sysfs.h>
+#include <linux/list.h>
+#include <linux/rtc.h>
+#include <linux/industrialio.h>
+#include <linux/industrialio_sysfs.h>
+
+#include "lis3l02dq.h"
+
+/* Somewhat wasteful under arm type alignments - endianess issues
+ as well?*/
+union lis3l02dq_channel {
+	char data[2];
+	int16_t val;
+};
+
+struct lis3l02dq_datum {
+	union lis3l02dq_channel el[3];
+	s64 time;
+};
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
+	 * convoluted nature of this transfer
+	 */
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
+	 * values in alternate bytes
+	 */
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
+					 uint8_t reg_address,
+					 int8_t *val)
+{
+	int ret;
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	struct spi_transfer xfer = {
+		.tx_buf = NULL,
+		.rx_buf = NULL,
+		.bits_per_word = 16,
+		.len = 2,
+	};
+
+	xfer.tx_buf = kmalloc(4, GFP_KERNEL);
+	if (xfer.tx_buf == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	xfer.rx_buf = kmalloc(4, GFP_KERNEL);
+	if (xfer.rx_buf == NULL) {
+		ret = -ENOMEM;
+		goto error_free_tx;
+	}
+	((unsigned char *)(xfer.tx_buf))[1] = LIS3L02DQ_READ_REG(reg_address);
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with get x offset");
+		goto error_free_rx;
+	}
+	*val = ((unsigned char *)(xfer.rx_buf))[0];
+	kfree(xfer.rx_buf);
+	kfree(xfer.tx_buf);
+	return ret;
+error_free_rx:
+	kfree(xfer.rx_buf);
+error_free_tx:
+	kfree(xfer.tx_buf);
+error_ret:
+	return ret;
+}
+
+/*Returns into to allow full 0/255 range with error codes in negative range */
+static int lis3l02dq_spi_read_reg_uint8_t(struct device *dev,
+					  uint8_t reg_address)
+{
+	uint8_t val;
+	int8_t ret;
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	unsigned char *local_tx_buf;
+	unsigned char *local_rx_buf;
+	struct spi_transfer xfer = {
+		.tx_buf = NULL,
+		.rx_buf = NULL,
+		.bits_per_word = 16,
+		.len = 2,
+	};
+
+	local_rx_buf = kmalloc(4, GFP_KERNEL);
+	local_tx_buf = kmalloc(4, GFP_KERNEL);
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
+
+	return val;
+err_ret:
+	kfree(local_rx_buf);
+
+	return ret;
+}
+
+static int lis3l02dq_spi_write_reg_int8_t(struct device *dev,
+					  uint8_t reg_address,
+					  int value)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
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
+	local_tx_buf = kmalloc(4, GFP_KERNEL);
+	if (local_tx_buf == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
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
+		goto error_ret;
+
+	}
+
+	return 0;
+error_ret:
+	return ret;
+}
+
+/* Relies on the MSB being one higher adress than the LSB */
+static int lis3l02dq_spi_write_reg_int16_t(struct device *dev,
+					   uint8_t lower_reg_address,
+					   int value)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	unsigned char *local_tx_buf;
+	int ret;
+	union lis3l02dq_channel tval;
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
+	tval.val = value;
+	local_tx_buf = kmalloc(4, GFP_KERNEL);
+	if (local_tx_buf == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	xfers[0].tx_buf = local_tx_buf;
+	xfers[1].tx_buf = local_tx_buf + 2;
+	local_tx_buf[1] = LIS3L02DQ_WRITE_REG(lower_reg_address);
+	local_tx_buf[0] = tval.data[0];
+	local_tx_buf[3] = LIS3L02DQ_WRITE_REG(lower_reg_address+1);
+	local_tx_buf[2] = tval.data[1];
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
+error_ret:
+	return ret;
+}
+
+static int lis3l02dq_spi_read_reg_int16_t(struct device *dev,
+					  uint8_t lower_reg_address,
+					  int16_t *val)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	unsigned char *local_tx_buf;
+	unsigned char *local_rx_buf;
+	int ret;
+	/* slight abuse, but same form */
+	union lis3l02dq_channel tval;
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
+	local_tx_buf = kmalloc(4, GFP_KERNEL);
+	if (local_tx_buf == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	local_rx_buf = kmalloc(4, GFP_KERNEL);
+	if (local_rx_buf == NULL) {
+		ret = -ENOMEM;
+		goto error_free_tx_buf;
+	}
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
+	if (ret) {
+		dev_err(&st->us->dev, "problem when reading 16 bit register");
+		goto error_free_rx_buf;
+	}
+	/* FIXME - endianness problem? */
+	tval.data[0] = local_rx_buf[0];
+	tval.data[1] = local_rx_buf[2];
+	kfree(local_rx_buf);
+	kfree(local_tx_buf);
+	*val = tval.val;
+	return 0;
+error_free_rx_buf:
+	kfree(local_rx_buf);
+error_free_tx_buf:
+	kfree(local_tx_buf);
+error_ret:
+	return ret;
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
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev, this_attr->address, &val);
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
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	val = lis3l02dq_spi_read_reg_uint8_t(dev, this_attr->address);
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
+/* Used for offsets etc so no need for lock. */
+static ssize_t lis3l02dq_write_signed(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	long val;
+	int ret;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto err_ret;
+	ret = lis3l02dq_spi_write_reg_int8_t(dev, this_attr->address, val);
+	if (ret)
+		goto err_ret;
+
+	return len;
+
+err_ret:
+	return ret;
+}
+/* Used for gains etc so no need for lock. */
+static ssize_t lis3l02dq_write_unsigned(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf,
+					size_t len)
+{
+	int ret;
+	ulong val;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		goto err_ret;
+
+	ret = lis3l02dq_spi_write_reg_int8_t(dev, this_attr->address, val);
+	if (ret)
+		goto err_ret;
+
+	return len;
+
+err_ret:
+	return ret;
+}
+
+static ssize_t lis3l02dq_read_16bit_signed(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	int len, ret;
+	int16_t val;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_int16_t(dev, this_attr->address, &val);
+	if (ret < 0) {
+		dev_err(dev, "problem reading a signed 16 bit value from chip");
+		return ret;
+	}
+	len = sprintf(buf, "%d\n", val);
+
+	return len;
+}
+
+/* As the ring buffer contents are device dependent this functionality
+ * must remain part of the driver and not the ring buffer subsystem */
+static ssize_t
+lis3l02dq_read_accel_from_ring(struct iio_sw_ring_buffer *ring,
+			       int element, char *buf)
+{
+	int ret, len;
+	struct lis3l02dq_datum data;
+
+	ret = iio_read_last_from_sw_ring(ring, (char *)(&data));
+	if (ret)
+		return ret;
+	len = sprintf(buf, "ring %d\n", data.el[element].val);
+
+	return len;
+}
+/* Prevents mode switching when running */
+static ssize_t lis3l02dq_read_accel(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	ssize_t returnval;
+	int element;
+
+	mutex_lock(&indio_dev->mlock);
+	if (indio_dev->currentmode == INDIO_RING_DATA_RDY) {
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
+			returnval =  -EINVAL;
+			goto error_ret;
+		}
+		returnval = lis3l02dq_read_accel_from_ring(indio_dev->ring,
+							   element, buf);
+	} else
+		returnval =  lis3l02dq_read_16bit_signed(dev, attr, buf);
+error_ret:
+	mutex_unlock(&indio_dev->mlock);
+	return returnval;
+}
+
+/* For this device this is only relevant to the threshold for interrupt
+ * generation */
+static ssize_t lis3l02dq_write_16bit_signed(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf,
+					    size_t len)
+{
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	int ret;
+	long val;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+	mutex_lock(&indio_dev->mlock);
+	ret = lis3l02dq_spi_write_reg_int16_t(dev, this_attr->address, val);
+	mutex_unlock(&indio_dev->mlock);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t lis3l02dq_read_av_freq(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
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
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	long val;
+	int ret;
+	int8_t t;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&indio_dev->mlock);
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					    &t);
+	if (ret)
+		goto error_ret;
+	/* Wipe the bits clean */
+	t &= ~LIS3L02DQ_DEC_MASK;
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
+
+	if (ret)
+		goto error_ret;
+	mutex_unlock(&indio_dev->mlock);
+	return len;
+
+error_ret:
+	mutex_unlock(&indio_dev->mlock);
+	return ret;
+
+}
+
+static int lis3l02dq_initial_setup(struct lis3l02dq_state *st)
+{
+	int ret, val;
+
+	st->us->mode = SPI_MODE_3;
+	spi_setup(st->us);
+	/* Write suitable defaults to ctrl1 */
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					     LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					     LIS3L02DQ_DEFAULT_CTRL1);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with setup control register 1");
+		goto err_ret;
+	}
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					     LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					     LIS3L02DQ_DEFAULT_CTRL2);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with setup control register 2");
+		goto err_ret;
+	}
+	val = LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC;
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					     LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+					     val);
+	if (ret)
+		dev_err(&st->us->dev, "problem with interrupt cfg register");
+
+err_ret:
+
+	return ret;
+}
+
+
+
+/* These are all a case of reading / writing directly to the chip */
+
+static IIO_DEV_ATTR_ACCEL_X_OFFSET(S_IWUSR | S_IRUGO,
+				   lis3l02dq_read_signed,
+				   lis3l02dq_write_signed,
+				   LIS3L02DQ_REG_OFFSET_X_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_Y_OFFSET(S_IWUSR | S_IRUGO,
+				   lis3l02dq_read_signed,
+				   lis3l02dq_write_signed,
+				   LIS3L02DQ_REG_OFFSET_Y_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_Z_OFFSET(S_IWUSR | S_IRUGO,
+				   lis3l02dq_read_signed,
+				   lis3l02dq_write_signed,
+				   LIS3L02DQ_REG_OFFSET_Z_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_X_GAIN(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_unsigned,
+				 lis3l02dq_write_unsigned,
+				 LIS3L02DQ_REG_GAIN_X_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_Y_GAIN(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_unsigned,
+				 lis3l02dq_write_unsigned,
+				 LIS3L02DQ_REG_GAIN_Y_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_Z_GAIN(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_unsigned,
+				 lis3l02dq_write_unsigned,
+				 LIS3L02DQ_REG_GAIN_Z_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_THRESH(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_16bit_signed,
+				 lis3l02dq_write_16bit_signed,
+				 LIS3L02DQ_REG_THS_L_ADDRESS);
+
+/* Obviously the reading method for these will change depending on whether
+   ring buffer capture is in use. Allow specification here of alternate
+   function? Or take the approach used above of making this a driver issue
+   rather than part of industrialio */
+static IIO_DEV_ATTR_ACCEL_X(lis3l02dq_read_accel,
+			    LIS3L02DQ_REG_OUT_X_L_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_Y(lis3l02dq_read_accel,
+			    LIS3L02DQ_REG_OUT_Y_L_ADDRESS);
+
+static IIO_DEV_ATTR_ACCEL_Z(lis3l02dq_read_accel,
+			    LIS3L02DQ_REG_OUT_Z_L_ADDRESS);
+
+static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
+			      lis3l02dq_read_frequency,
+			      lis3l02dq_write_frequency);
+
+static IIO_DEV_ATTR_AVAIL_SAMP_FREQ(lis3l02dq_read_av_freq);
+
+static ssize_t
+lis3l02dq_read_interrupt_config(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	int len, ret, set;
+	int8_t val;
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+					    &val);
+	if (ret < 0)
+		return ret;
+	set = (val & this_attr->mask) ? 1 : 0;
+	len = sprintf(buf, "%d\n", set);
+
+	return len;
+}
+
+static ssize_t lis3l02dq_write_interrupt_config(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf,
+						size_t len)
+{
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+		int ret, currentlyset, addr, changed = 0;
+	int8_t valold, controlold;
+	bool val;
+
+	val = (buf[0] == '0') ? 0 : 1;
+
+	mutex_lock(&indio_dev->mlock);
+	/* read current value */
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS,
+					    &valold);
+	if (ret)
+		goto error_mutex_unlock;
+
+	/* read current control */
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					    &controlold);
+	if (ret)
+		goto error_mutex_unlock;
+	currentlyset = valold & this_attr->mask ? 1 : 0;
+	if (val == false && currentlyset) {
+		valold &= ~this_attr->mask;
+		changed = 1;
+		ret = iio_remove_event_from_list(this_attr->listel);
+		if (ret)
+			goto error_mutex_unlock;
+	} else if (val == true && !currentlyset) {
+		changed = 1;
+		valold |= this_attr->mask;
+		/* move to a line spec rather than this? */
+		ret = iio_add_event_to_list(&indio_dev->interrupts[0]->ev_list,
+					    this_attr->listel);
+		if (ret)
+			goto error_mutex_unlock;
+	}
+
+	if (changed) {
+		addr = LIS3L02DQ_REG_WAKE_UP_CFG_ADDRESS;
+		ret = lis3l02dq_spi_write_reg_int8_t(dev, addr, valold);
+		if (ret)
+			goto error_mutex_unlock;
+		/* This always enables the interrupt, even if we've remove the
+		 * last thing using it. For this device we can use the reference
+		 * count on the handler to tell us if anyone
+		 * wants the interrupt */
+		controlold = this_attr->listel->refcount ?
+			(controlold | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT):
+			(controlold & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
+		addr = LIS3L02DQ_REG_CTRL_2_ADDRESS;
+		ret = lis3l02dq_spi_write_reg_int8_t(dev, addr, controlold);
+		if (ret)
+			goto error_mutex_unlock;
+	}
+	mutex_unlock(&indio_dev->mlock);
+
+	return len;
+
+error_mutex_unlock:
+	mutex_unlock(&indio_dev->mlock);
+	return ret;
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
+/* Caller responsible for locking as necessary. */
+static int __lis3l02dq_write_data_ready_config(struct device *dev,
+					       struct iio_event_handler_list
+					       *list,
+					       long state)
+{
+	int ret;
+	int8_t valold, addr;
+	bool currentlyset, changed = 0;
+
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+
+	ret = lis3l02dq_spi_read_reg_int8_t(dev,
+					    LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					    &valold);
+	if (ret)
+		goto error_ret;
+
+	currentlyset
+		= valold & LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION
+		? 1 : 0;
+	/* if set, disable requested and ring buffer not in use (FIXME) */
+	if (state == 0 && currentlyset) {
+		valold &= ~LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
+		ret = iio_remove_event_from_list(list);
+		if (ret)
+			goto error_ret;
+		changed = true;
+	} else if (state != 0 && !currentlyset) {
+		/* if not set, enable requested */
+		valold |= LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
+		ret = iio_add_event_to_list(&indio_dev->interrupts[0]->ev_list,
+					    list);
+		if (ret)
+			goto error_ret;
+		changed = true;
+	}
+	if (changed) {
+		addr = LIS3L02DQ_REG_CTRL_2_ADDRESS;
+		ret = lis3l02dq_spi_write_reg_int8_t(dev, addr, valold);
+		if (ret)
+			goto error_ret;
+	}
+
+	return 0;
+error_ret:
+	return ret;
+}
+
+/* Does nothing if the ring is in use */
+static ssize_t lis3l02dq_write_data_ready_config(struct device *dev,
+						 struct device_attribute *attr,
+						 const char *buf,
+						 size_t len)
+{
+	int ret;
+	long val;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+
+	mutex_lock(&indio_dev->mlock);
+	if (indio_dev->currentmode ==  INDIO_RING_DATA_RDY)
+		return len;
+
+	/* fixme not the simplest method out!*/
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+
+	ret = __lis3l02dq_write_data_ready_config(dev, this_attr->listel, val);
+
+	if (ret)
+		goto error_ret;
+	mutex_unlock(&indio_dev->mlock);
+
+	return len;
+error_ret:
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
+/* Whilst this makes a lot of calls to iio_sw_ring functions - it is to device
+ * specific to be rolled into the core.
+ */
+static void lis3l02dq_data_rdy_bh_to_ring(struct work_struct *work_s)
+{
+	struct lis3l02dq_state *st
+		= container_of(work_s, struct lis3l02dq_state,
+			       work_data_rdy_ring);
+	unsigned char *rx_array;
+	int i, j;
+	struct lis3l02dq_datum ring_data;
+
+	rx_array = kmalloc(12, GFP_KERNEL);
+	if (rx_array == NULL) {
+		dev_err(&st->us->dev, "memory alloc failed in ring bh");
+		return;
+	}
+	st->inter = 0;
+
+	if (lis3l02dq_read_all(st, rx_array) >= 0) {
+		for (i = 0; i < 3; i++)
+			for (j = 0; j < 2; j++)
+				ring_data.el[i].data[j] = rx_array[i*4+j*2];
+		ring_data.time = st->last_timestamp;
+		iio_store_to_sw_ring(&st->indio_dev->ring[0],
+				     (char *)(&ring_data),
+				     st->last_timestamp);
+	}
+	/* so the data should now be in the rx array */
+try_again:
+	while (gpio_get_value(irq_to_gpio(st->us->irq)))
+		if (lis3l02dq_read_all(st, rx_array) >= 0) {
+			for (i = 0; i < 3; i++)
+				for (j = 0; j < 2; j++)
+					ring_data.el[i].data[j]
+						= rx_array[i*4+j*2];
+			ring_data.time = 0;
+			/* Passing a negated time stamp to indicate that
+			 * we don't actually know when this occured! */
+			iio_store_to_sw_ring(&st->indio_dev->ring[0],
+					     (char *)(&ring_data),
+					     0);
+		}
+	/* push data into ring buffer before trying renable */
+	enable_irq(st->us->irq);
+	if (gpio_get_value(irq_to_gpio(st->us->irq)))
+		if (st->inter == 0) {
+			disable_irq_nosync(st->us->irq);
+			goto try_again;
+		}
+	kfree(rx_array);
+
+	return;
+}
+
+static void lis3l02dq_data_rdy_bh_to_event(struct work_struct *work_s)
+{
+	struct lis3l02dq_state *st
+		= container_of(work_s, struct lis3l02dq_state,
+			       work_data_rdy_event);
+
+	/* send an event up to user space */
+	iio_put_event(st->indio_dev, 0, IIO_EVENT_CODE_DATA_RDY,
+		      st->last_timestamp);
+	enable_irq(st->us->irq);
+
+	return;
+}
+
+static int lis3l02dq_data_rdy_event_th(struct iio_dev *dev_info,
+				 int index,
+				 s64 timestamp,
+				 int no_test)
+{
+	struct lis3l02dq_state *st = dev_info->dev_data;
+
+	st->last_timestamp = timestamp;
+	schedule_work(&st->work_data_rdy_event);
+
+	return IRQ_HANDLED;
+}
+
+static int lis3l02dq_data_rdy_ring_th(struct iio_dev *dev_info,
+				 int index,
+				 s64 timestamp,
+				 int no_test)
+{
+	struct lis3l02dq_state *st = dev_info->dev_data;
+
+	st->last_timestamp = timestamp;
+	schedule_work(&st->work_data_rdy_ring);
+	st->inter = 1;
+
+	return IRQ_HANDLED;
+}
+
+static int lis3l02dq_thresh_handler_th(struct iio_dev *dev_info,
+				       int index,
+				       s64 timestamp,
+				       int no_test)
+{
+	struct lis3l02dq_state *st = dev_info->dev_data;
+
+	/* Stash the timestamp somewhere convenient for the bh */
+	st->last_timestamp = timestamp;
+	schedule_work(&st->work_cont_thresh.ws);
+
+	return 0;
+}
+
+
+/* Unforunately it appears the interrupt won't clear unless you read from the
+ * src register.
+ */
+static void lis3l02dq_thresh_handler_bh_no_check(struct work_struct *work_s)
+{
+	struct iio_work_cont *wc
+		= container_of(work_s, struct iio_work_cont, ws_nocheck);
+	struct lis3l02dq_state *st = wc->st;
+
+	int8_t t;
+
+	lis3l02dq_spi_read_reg_int8_t(st->indio_dev->dev,
+				      LIS3L02DQ_REG_WAKE_UP_SRC_ADDRESS,
+				      &t);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH)
+		iio_put_event(st->indio_dev, 0,
+			      IIO_EVENT_CODE_ACCEL_Z_HIGH,
+			      st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW)
+		iio_put_event(st->indio_dev, 0,
+			      IIO_EVENT_CODE_ACCEL_Z_LOW,
+			      st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH)
+		iio_put_event(st->indio_dev, 0,
+			      IIO_EVENT_CODE_ACCEL_Y_HIGH,
+			      st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_LOW)
+		iio_put_event(st->indio_dev, 0,
+			      IIO_EVENT_CODE_ACCEL_Y_LOW,
+			      st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_HIGH)
+		iio_put_event(st->indio_dev, 0,
+			      IIO_EVENT_CODE_ACCEL_X_HIGH,
+			      st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_LOW)
+		iio_put_event(st->indio_dev, 0,
+			      IIO_EVENT_CODE_ACCEL_X_LOW,
+			      st->last_timestamp);
+
+	enable_irq(st->us->irq);
+	/* Ack (and allow for new interrupts? (not clear on data sheet ) )*/
+	lis3l02dq_spi_read_reg_int8_t(st->indio_dev->dev,
+				      LIS3L02DQ_REG_WAKE_UP_ACK_ADDRESS,
+				      &t);
+
+	return;
+}
+
+/* This only enables direct output of data ready as an event - not the ring*/
+IIO_EVENT_ATTR_DATA_RDY(lis3l02dq_read_data_ready_config,
+			lis3l02dq_write_data_ready_config,
+			0,
+			&lis3l02dq_data_rdy_event_th);
+
+/* This is an event as it is a response to a physical interrupt */
+IIO_EVENT_SH(sw_ring_enable, &lis3l02dq_data_rdy_ring_th);
+
+static int lis3l02dq_data_rdy_ring_preenable(struct iio_dev *indio_dev)
+{
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	__lis3l02dq_write_data_ready_config(&st->us->dev,
+					    &iio_event_data_rdy,
+					    0);
+	return 0;
+}
+
+static int lis3l02dq_data_rdy_ring_postenable(struct iio_dev *indio_dev)
+{
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	__lis3l02dq_write_data_ready_config(&st->us->dev,
+					    &iio_event_sw_ring_enable,
+					    1);
+	return 0;
+}
+
+static int lis3l02dq_data_rdy_ring_predisable(struct iio_dev *indio_dev)
+{
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	__lis3l02dq_write_data_ready_config(&st->us->dev,
+					    &iio_event_sw_ring_enable,
+					    0);
+	return 0;
+}
+
+/* A shared handler for a number of threshold types */
+IIO_EVENT_SH(threshold, &lis3l02dq_thresh_handler_th);
+
+IIO_EVENT_ATTR_ACCEL_X_HIGH_SH(iio_event_threshold,
+			       lis3l02dq_read_interrupt_config,
+			       lis3l02dq_write_interrupt_config,
+			       LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_HIGH);
+
+IIO_EVENT_ATTR_ACCEL_Y_HIGH_SH(iio_event_threshold,
+			       lis3l02dq_read_interrupt_config,
+			       lis3l02dq_write_interrupt_config,
+			       LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_HIGH);
+
+IIO_EVENT_ATTR_ACCEL_Z_HIGH_SH(iio_event_threshold,
+			       lis3l02dq_read_interrupt_config,
+			       lis3l02dq_write_interrupt_config,
+			       LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_HIGH);
+
+IIO_EVENT_ATTR_ACCEL_X_LOW_SH(iio_event_threshold,
+			      lis3l02dq_read_interrupt_config,
+			      lis3l02dq_write_interrupt_config,
+			      LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_LOW);
+
+IIO_EVENT_ATTR_ACCEL_Y_LOW_SH(iio_event_threshold,
+			      lis3l02dq_read_interrupt_config,
+			      lis3l02dq_write_interrupt_config,
+			      LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_LOW);
+
+IIO_EVENT_ATTR_ACCEL_Z_LOW_SH(iio_event_threshold,
+			      lis3l02dq_read_interrupt_config,
+			      lis3l02dq_write_interrupt_config,
+			      LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_LOW);
+
+static struct attribute *lis3l02dq_event_attributes[] = {
+	&iio_event_attr_x_high.dev_attr.attr,
+	&iio_event_attr_y_high.dev_attr.attr,
+	&iio_event_attr_z_high.dev_attr.attr,
+	&iio_event_attr_x_low.dev_attr.attr,
+	&iio_event_attr_y_low.dev_attr.attr,
+	&iio_event_attr_z_low.dev_attr.attr,
+	&iio_event_attr_data_rdy.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group lis3l02dq_event_attribute_group = {
+	.attrs = lis3l02dq_event_attributes,
+};
+
+static struct attribute *lis3l02dq_attributes[] = {
+	&iio_dev_attr_x_offset.dev_attr.attr,
+	&iio_dev_attr_y_offset.dev_attr.attr,
+	&iio_dev_attr_z_offset.dev_attr.attr,
+	&iio_dev_attr_x_gain.dev_attr.attr,
+	&iio_dev_attr_y_gain.dev_attr.attr,
+	&iio_dev_attr_z_gain.dev_attr.attr,
+	&iio_dev_attr_thresh.dev_attr.attr,
+	&iio_dev_attr_x.dev_attr.attr,
+	&iio_dev_attr_y.dev_attr.attr,
+	&iio_dev_attr_z.dev_attr.attr,
+	&iio_dev_attr_sampling_frequency.dev_attr.attr,
+	&iio_dev_attr_available_sampling_frequency.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group lis3l02dq_attribute_group = {
+	.attrs = lis3l02dq_attributes,
+};
+
+
+static int __devinit lis3l02dq_probe(struct spi_device *spi)
+{
+	struct lis3l02dq_state *st;
+	int ret;
+	/* must init this somewhere */
+	INIT_LIST_HEAD(&iio_event_sw_ring_enable.list);
+	st = kzalloc(sizeof(struct lis3l02dq_state), GFP_KERNEL);
+	if (st == NULL) {
+		ret =  -ENOMEM;
+		goto error_ret;
+	}
+
+
+	st->us = spi;
+	/* setup the industrialio driver allocated elements */
+	st->indio_dev = kzalloc(sizeof(struct iio_dev), GFP_KERNEL);
+	if (st->indio_dev == NULL) {
+		ret = -ENOMEM;
+		goto error_free_st;
+	}
+
+	st->indio_dev->dev = &spi->dev;
+	st->indio_dev->num_interrupt_lines = 1;
+	st->indio_dev->event_attrs = &lis3l02dq_event_attribute_group;
+	st->indio_dev->attrs = &lis3l02dq_attribute_group;
+	st->indio_dev->dev_data = (void *)(st);
+	/* setup parameters of the ring buffer */
+	st->indio_dev->ring_bytes_per_datum = sizeof(struct lis3l02dq_datum);
+	st->indio_dev->ring_length = 500;
+	st->indio_dev->driver_module = THIS_MODULE;
+	st->indio_dev->modes = INDIO_DIRECT_MODE | INDIO_RING_DATA_RDY;
+	st->indio_dev->ring_preenable = &lis3l02dq_data_rdy_ring_preenable;
+	st->indio_dev->ring_postenable = &lis3l02dq_data_rdy_ring_postenable;
+	st->indio_dev->ring_predisable = &lis3l02dq_data_rdy_ring_predisable;
+
+	ret = iio_device_register(st->indio_dev);
+	if (ret < 0)
+		goto error_free_dev;
+
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
+		INIT_IIO_WORK_CONT(&(st->work_cont_thresh),
+				   lis3l02dq_thresh_handler_bh_no_check,
+				   lis3l02dq_thresh_handler_bh_no_check,
+				   LIS3L02DQ_REG_WAKE_UP_SRC_ADDRESS,
+				   0,
+				   st);
+		st->inter = 0;
+		ret = iio_register_interrupt_line(spi->irq,
+						  st->indio_dev,
+						  0,
+						  IRQF_TRIGGER_RISING,
+						  "lis3l02dq");
+		if (ret)
+			goto error_unregister_dev;
+	} else
+		st->indio_dev->modes &= ~INDIO_RING_DATA_RDY;
+
+	/* Get the device into a sane initial state */
+	ret = lis3l02dq_initial_setup(st);
+	if (ret)
+		goto error_unregister_line;
+	return 0;
+
+error_unregister_line:
+	if (st->indio_dev->modes & INDIO_RING_DATA_RDY)
+		iio_unregister_interrupt_line(st->indio_dev, 0);
+error_unregister_dev:
+	iio_device_unregister(st->indio_dev);
+error_free_dev:
+	kfree(st->indio_dev);
+error_free_st:
+	kfree(st);
+ error_ret:
+	return ret;
+}
+
+/* Power down the device */
+static int lis3l02dq_stop_device(struct iio_dev *indio_dev)
+{
+	int ret;
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	mutex_lock(&indio_dev->mlock);
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					     LIS3L02DQ_REG_CTRL_1_ADDRESS,
+					     0);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with turning device off: ctrl1");
+		goto err_ret;
+	}
+
+	ret = lis3l02dq_spi_write_reg_int8_t(&st->us->dev,
+					     LIS3L02DQ_REG_CTRL_2_ADDRESS,
+					     0);
+	if (ret)
+		dev_err(&st->us->dev, "problem with turning device off: ctrl2");
+err_ret:
+	mutex_unlock(&indio_dev->mlock);
+	return ret;
+}
+
+/* fixme, confirm ordering in this function */
+static int lis3l02dq_remove(struct spi_device *spi)
+{
+	int ret;
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+
+	/* stop the device*/
+	/* Amongst other things this must ensure no more interrupts are
+	 * generated by the device.
+	 */
+	ret = lis3l02dq_stop_device(indio_dev);
+	/* Make sure all bottom halfs of interrupts are done */
+	flush_scheduled_work();
+	if (ret)
+		goto err_ret;
+	/* Fixme slightly misleading test condition - even if valid */
+	if (indio_dev->modes & INDIO_RING_DATA_RDY)
+		iio_unregister_interrupt_line(indio_dev, 0);
+	iio_device_unregister(indio_dev);
+	kfree(indio_dev);
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


