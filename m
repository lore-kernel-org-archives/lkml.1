Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZGBNvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZGBNvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZGBNs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:48:56 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:53245 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbZGBNsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:48:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: chrisv@cyberswitching.com, daniel@caiaq.de, iws@ovro.caltech.edu,
       dmitry.torokhov@gmail.com, hmh@hmh.eng.br, david-b@pacbell.net,
       khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 04/14] IIO: lis3l02dq accelerometer core support
Date: Thu,  2 Jul 2009 13:47:34 +0000
Message-Id: <1246542464-6974-5-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1246542464-6974-4-git-send-email-jic23@cam.ac.uk>
References: <1246542464-6974-1-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-2-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-3-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-4-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

A later patch in the series will add data ready triggering
and ring buffer support.

This core patch provides an event interface and sysfs
based reading of values.
---
 drivers/iio/Kconfig                |    1 +
 drivers/iio/Makefile               |    1 +
 drivers/iio/accel/Kconfig          |   13 +
 drivers/iio/accel/Makefile         |    5 +
 drivers/iio/accel/lis3l02dq.h      |  212 ++++++++
 drivers/iio/accel/lis3l02dq_core.c |  925 ++++++++++++++++++++++++++++++++++++
 include/linux/iio/accel.h          |  167 +++++++
 7 files changed, 1324 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iio/accel/Kconfig
 create mode 100644 drivers/iio/accel/Makefile
 create mode 100644 drivers/iio/accel/lis3l02dq.h
 create mode 100644 drivers/iio/accel/lis3l02dq_core.c
 create mode 100644 include/linux/iio/accel.h

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index d37859d..f3545c8 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -10,5 +10,6 @@ menuconfig IIO
 	  number of different physical interfaces (i2c, spi etc). See
 	  Documentation/industrialio for more information.
 
+source drivers/iio/accel/Kconfig
 source drivers/iio/adc/Kconfig
 source drivers/iio/light/Kconfig
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 4e78f98..14c661b 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -5,5 +5,6 @@
 obj-$(CONFIG_IIO) += industrialio.o
 industrialio-y := industrialio-core.o
 
+obj-y += accel/
 obj-y += adc/
 obj-y += light/
\ No newline at end of file
diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
new file mode 100644
index 0000000..a3abffc
--- /dev/null
+++ b/drivers/iio/accel/Kconfig
@@ -0,0 +1,13 @@
+#
+# Accelerometer drivers
+#
+comment "Accelerometers"
+	depends on IIO
+
+config LIS3L02DQ
+	tristate "ST Microelectronics LIS3L02DQ Accelerometer Driver"
+	depends on IIO && SPI
+	help
+	  Say yes here to build SPI support for the ST microelectronics
+	  accelerometer. The driver supplies direct access via sysfs files
+	  and an event interface via a character device.
diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
new file mode 100644
index 0000000..5a7ef9d
--- /dev/null
+++ b/drivers/iio/accel/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for industrial I/O accelerometer drivers
+#
+lis3l02dq-y		:= lis3l02dq_core.o
+obj-$(CONFIG_LIS3L02DQ)	+= lis3l02dq.o
diff --git a/drivers/iio/accel/lis3l02dq.h b/drivers/iio/accel/lis3l02dq.h
new file mode 100644
index 0000000..18cb49c
--- /dev/null
+++ b/drivers/iio/accel/lis3l02dq.h
@@ -0,0 +1,212 @@
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
+#define LIS3L02DQ_REG_OFFSET_X_ADDR		0x16
+#define LIS3L02DQ_REG_OFFSET_Y_ADDR		0x17
+#define LIS3L02DQ_REG_OFFSET_Z_ADDR		0x18
+
+#define LIS3L02DQ_REG_GAIN_X_ADDR		0x19
+#define LIS3L02DQ_REG_GAIN_Y_ADDR		0x1A
+#define LIS3L02DQ_REG_GAIN_Z_ADDR		0x1B
+
+/* Control Register (1 of 2) */
+#define LIS3L02DQ_REG_CTRL_1_ADDR		0x20
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
+#define LIS3L02DQ_REG_CTRL_2_ADDR		0x21
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
+#define LIS3L02DQ_REG_WAKE_UP_CFG_ADDR			0x23
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
+#define LIS3L02DQ_REG_WAKE_UP_SRC_ADDR			0x24
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
+#define LIS3L02DQ_REG_WAKE_UP_ACK_ADDR			0x25
+
+/* Status register */
+#define LIS3L02DQ_REG_STATUS_ADDR			0x27
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
+#define LIS3L02DQ_REG_OUT_X_L_ADDR			0x28
+#define LIS3L02DQ_REG_OUT_X_H_ADDR			0x29
+#define LIS3L02DQ_REG_OUT_Y_L_ADDR			0x2A
+#define LIS3L02DQ_REG_OUT_Y_H_ADDR			0x2B
+#define LIS3L02DQ_REG_OUT_Z_L_ADDR			0x2C
+#define LIS3L02DQ_REG_OUT_Z_H_ADDR			0x2D
+
+/* Threshold values for all axes and both above and below thresholds
+ * - i.e. there is only one value */
+#define LIS3L02DQ_REG_THS_L_ADDR			0x2E
+#define LIS3L02DQ_REG_THS_H_ADDR			0x2F
+
+#define LIS3L02DQ_DEFAULT_CTRL1 (LIS3L02DQ_REG_CTRL_1_PD_ON	      \
+				 | LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE \
+				 | LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE \
+				 | LIS3L02DQ_REG_CTRL_1_AXES_X_ENABLE \
+				 | LIS3L02DQ_REG_CTRL_1_DF_128)
+
+#define LIS3L02DQ_DEFAULT_CTRL2	0
+
+#define LIS3L02DQ_MAX_TX 12
+#define LIS3L02DQ_MAX_RX 12
+/**
+ * struct lis3l02dq_state - device instance specific data
+ * @us:			actual spi_device
+ * @work_trigger_to_ring: bh for triggered event handling
+ * @work_cont_thresh: CLEAN
+ * @inter:		used to check if new interrupt has been triggered
+ * @last_timestamp:	passing timestamp from th to bh of interrupt handler
+ * @indio_dev:		industrial I/O device structure
+ * @trig:		data ready trigger registered with iio
+ * @tx:			transmit buffer
+ * @rx:			recieve buffer
+ * @buf_lock:		mutex to protect tx and rx
+ **/
+struct lis3l02dq_state {
+	struct spi_device		*us;
+	struct work_struct		work_trigger_to_ring;
+	struct iio_work_cont		work_cont_thresh;
+	bool				inter;
+	s64				last_timestamp;
+	struct iio_dev			*indio_dev;
+	struct iio_trigger		*trig;
+	u8				*tx;
+	u8				*rx;
+	struct mutex			buf_lock;
+};
+
+int lis3l02dq_spi_read_reg_8(struct device *dev,
+			     u8 reg_address,
+			     u8 *val);
+
+int lis3l02dq_spi_write_reg_8(struct device *dev,
+			      u8 reg_address,
+			      u8 *val);
+#define LIS3L02DQ_SCAN_ACC_X 0
+#define LIS3L02DQ_SCAN_ACC_Y 1
+#define LIS3L02DQ_SCAN_ACC_Z 2
+
+static inline void lis3l02dq_remove_trigger(struct iio_dev *indio_dev) {};
+static inline int lis3l02dq_probe_trigger(struct iio_dev *indio_dev)
+{
+	return 0;
+};
+
+static inline ssize_t
+lis3l02dq_read_accel_from_ring(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	return 0;
+};
+
+static int lis3l02dq_configure_ring(struct iio_dev *indio_dev)
+{
+	return 0;
+};
+static inline void lis3l02dq_unconfigure_ring(struct iio_dev *indio_dev)
+{};
+static inline int lis3l02dq_initialize_ring(struct iio_ring_buffer *ring)
+{
+	return 0;
+};
+static inline void lis3l02dq_uninitialize_ring(struct iio_ring_buffer *ring) {};
+
+#endif /* SPI_LIS3L02DQ_H_ */
diff --git a/drivers/iio/accel/lis3l02dq_core.c b/drivers/iio/accel/lis3l02dq_core.c
new file mode 100644
index 0000000..503d6ed
--- /dev/null
+++ b/drivers/iio/accel/lis3l02dq_core.c
@@ -0,0 +1,925 @@
+/*
+ * lis3l02dq.c	support STMicroelectronics LISD02DQ
+ *		3d 2g Linear Accelerometers via SPI
+ *
+ * Copyright (c) 2007 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Settings:
+ * 16 bit left justified mode used.
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
+
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include <linux/iio/accel.h>
+
+#include "lis3l02dq.h"
+
+/* At the moment the spi framework doesn't allow global setting of cs_change.
+ * It's in the likely to be added comment at the top of spi.h.
+ * This means that use cannot be made of spi_write etc.
+ */
+
+/**
+ * lis3l02dq_spi_read_reg_8() - read single byte from a single register
+ * @dev: device asosciated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the register to be read
+ * @val: pass back the resulting value
+ **/
+int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
+{
+	int ret;
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = iio_dev_get_devdata(indio_dev);
+	struct spi_transfer xfer = {
+		.tx_buf = st->tx,
+		.rx_buf = st->rx,
+		.bits_per_word = 8,
+		.len = 2,
+		.cs_change = 1,
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = LIS3L02DQ_READ_REG(reg_address);
+	st->tx[1] = 0;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(st->us, &msg);
+	*val = st->rx[1];
+	mutex_unlock(&st->buf_lock);
+
+	return ret;
+}
+
+/**
+ * lis3l02dq_spi_write_reg_8() - write single byte to a register
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the register to be writen
+ * @val: the value to write
+ **/
+int lis3l02dq_spi_write_reg_8(struct device *dev,
+			      u8 reg_address,
+			      u8 *val)
+{
+	int ret;
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = iio_dev_get_devdata(indio_dev);
+	struct spi_transfer xfer = {
+		.tx_buf = st->tx,
+		.bits_per_word = 8,
+		.len = 2,
+		.cs_change = 1,
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = LIS3L02DQ_WRITE_REG(reg_address);
+	st->tx[1] = *val;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret =  spi_sync(st->us, &msg);
+	mutex_unlock(&st->buf_lock);
+
+	return ret;
+}
+
+/**
+ * lisl302dq_spi_write_reg_s16() - write 2 bytes to a pair of registers
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the lower of the two registers. Second register
+ *               is assumed to have address one greater.
+ * @val: value to be written
+ **/
+static int lis3l02dq_spi_write_reg_s16(struct device *dev,
+				       u8 lower_reg_address,
+				       s16 value)
+{
+	int ret;
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = iio_dev_get_devdata(indio_dev);
+	struct spi_transfer xfers[] = { {
+			.tx_buf = st->tx,
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		}, {
+			.tx_buf = st->tx + 2,
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		},
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = LIS3L02DQ_WRITE_REG(lower_reg_address);
+	st->tx[1] = value & 0xFF;
+	st->tx[2] = LIS3L02DQ_WRITE_REG(lower_reg_address + 1);
+	st->tx[3] = (value >> 8) & 0xFF;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	spi_message_add_tail(&xfers[1], &msg);
+	ret = spi_sync(st->us, &msg);
+	mutex_unlock(&st->buf_lock);
+
+	return ret;
+}
+
+/**
+ * lisl302dq_spi_read_reg_s16() - write 2 bytes to a pair of registers
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the lower of the two registers. Second register
+ *               is assumed to have address one greater.
+ * @val: somewhere to pass back the value read
+ **/
+static int lis3l02dq_spi_read_reg_s16(struct device *dev,
+				      u8 lower_reg_address,
+				      s16 *val)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct lis3l02dq_state *st = iio_dev_get_devdata(indio_dev);
+	int ret;
+	struct spi_transfer xfers[] = { {
+			.tx_buf = st->tx,
+			.rx_buf = st->rx,
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		}, {
+			.tx_buf = st->tx + 2,
+			.rx_buf = st->rx + 2,
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+
+		},
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = LIS3L02DQ_READ_REG(lower_reg_address);
+	st->tx[1] = 0;
+	st->tx[2] = LIS3L02DQ_READ_REG(lower_reg_address+1);
+	st->tx[3] = 0;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	spi_message_add_tail(&xfers[1], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "problem when reading 16 bit register");
+		goto error_ret;
+	}
+	*val = (s16)(st->rx[1]) | ((s16)(st->rx[3]) << 8);
+
+error_ret:
+	mutex_unlock(&st->buf_lock);
+	return ret;
+}
+
+/**
+ * lis3l02dq_read_signed() - attribute function used for 8 bit signed values
+ * @dev: the child device associated with the iio_dev or iio_trigger
+ * @attr: the attribute being processed
+ * @buf: buffer into which put the output string
+ **/
+static ssize_t lis3l02dq_read_signed(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	int ret;
+	s8 val;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_8(dev, this_attr->address, (u8 *)&val);
+
+	return ret ? ret : sprintf(buf, "%d\n", val);
+}
+
+static ssize_t lis3l02dq_read_unsigned(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	int ret;
+	u8 val;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_8(dev, this_attr->address, &val);
+
+	return ret ? ret : sprintf(buf, "%d\n", val);
+}
+
+static ssize_t lis3l02dq_write_signed(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	long valin;
+	s8 val;
+	int ret;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = strict_strtol(buf, 10, &valin);
+	if (ret)
+		goto error_ret;
+	val = valin;
+	ret = lis3l02dq_spi_write_reg_8(dev, this_attr->address, (u8 *)&val);
+
+error_ret:
+	return ret ? ret : len;
+}
+
+static ssize_t lis3l02dq_write_unsigned(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf,
+					size_t len)
+{
+	int ret;
+	ulong valin;
+	u8 val;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = strict_strtoul(buf, 10, &valin);
+	if (ret)
+		goto err_ret;
+	val = valin;
+	ret = lis3l02dq_spi_write_reg_8(dev, this_attr->address, &val);
+
+err_ret:
+	return ret ? ret : len;
+}
+
+static ssize_t lis3l02dq_read_16bit_signed(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	int ret;
+	s16 val = 0;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_s16(dev, this_attr->address, &val);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t lis3l02dq_read_accel(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	ssize_t ret;
+
+	/* Take the iio_dev status lock */
+	mutex_lock(&indio_dev->mlock);
+	if (indio_dev->currentmode == INDIO_RING_TRIGGERED)
+		ret = lis3l02dq_read_accel_from_ring(dev, attr, buf);
+	else
+		ret =  lis3l02dq_read_16bit_signed(dev, attr, buf);
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
+static ssize_t lis3l02dq_write_16bit_signed(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf,
+					    size_t len)
+{
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int ret;
+	long val;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+	ret = lis3l02dq_spi_write_reg_s16(dev, this_attr->address, val);
+
+error_ret:
+	return ret ? ret : len;
+}
+
+static ssize_t lis3l02dq_read_frequency(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	int ret, len = 0;
+	s8 t;
+	ret = lis3l02dq_spi_read_reg_8(dev,
+				       LIS3L02DQ_REG_CTRL_1_ADDR,
+				       (u8 *)&t);
+	if (ret)
+		return ret;
+	t &= LIS3L02DQ_DEC_MASK;
+	switch (t) {
+	case LIS3L02DQ_REG_CTRL_1_DF_128:
+		len = sprintf(buf, "280\n");
+		break;
+	case LIS3L02DQ_REG_CTRL_1_DF_64:
+		len = sprintf(buf, "560\n");
+		break;
+	case LIS3L02DQ_REG_CTRL_1_DF_32:
+		len = sprintf(buf, "1120\n");
+		break;
+	case LIS3L02DQ_REG_CTRL_1_DF_8:
+		len = sprintf(buf, "4480\n");
+		break;
+	}
+	return len;
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
+	u8 t;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&indio_dev->mlock);
+	ret = lis3l02dq_spi_read_reg_8(dev,
+				       LIS3L02DQ_REG_CTRL_1_ADDR,
+				       &t);
+	if (ret)
+		goto error_ret_mutex;
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
+		goto error_ret_mutex;
+	};
+
+	ret = lis3l02dq_spi_write_reg_8(dev,
+					LIS3L02DQ_REG_CTRL_1_ADDR,
+					&t);
+
+error_ret_mutex:
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret ? ret : len;
+}
+
+static int lis3l02dq_initial_setup(struct lis3l02dq_state *st)
+{
+	int ret;
+	u8 val, valtest;
+
+	st->us->mode = SPI_MODE_3;
+
+	spi_setup(st->us);
+
+	val = LIS3L02DQ_DEFAULT_CTRL1;
+	/* Write suitable defaults to ctrl1 */
+	ret = lis3l02dq_spi_write_reg_8(&st->indio_dev->dev,
+					LIS3L02DQ_REG_CTRL_1_ADDR,
+					&val);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with setup control register 1");
+		goto err_ret;
+	}
+	/* Repeat as sometimes doesn't work first time?*/
+	ret = lis3l02dq_spi_write_reg_8(&st->indio_dev->dev,
+					LIS3L02DQ_REG_CTRL_1_ADDR,
+					&val);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with setup control register 1");
+		goto err_ret;
+	}
+
+	/* Read back to check this has worked acts as loose test of correct
+	 * chip */
+	ret = lis3l02dq_spi_read_reg_8(&st->indio_dev->dev,
+				       LIS3L02DQ_REG_CTRL_1_ADDR,
+				       &valtest);
+	if (ret || (valtest != val)) {
+		dev_err(&st->indio_dev->dev, "device not playing ball");
+		ret = -EINVAL;
+		goto err_ret;
+	}
+
+	val = LIS3L02DQ_DEFAULT_CTRL2;
+	ret = lis3l02dq_spi_write_reg_8(&st->indio_dev->dev,
+					LIS3L02DQ_REG_CTRL_2_ADDR,
+					&val);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with setup control register 2");
+		goto err_ret;
+	}
+
+	val = LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC;
+	ret = lis3l02dq_spi_write_reg_8(&st->indio_dev->dev,
+					LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
+					&val);
+	if (ret)
+		dev_err(&st->us->dev, "problem with interrupt cfg register");
+err_ret:
+
+	return ret;
+}
+
+static IIO_DEV_ATTR_ACCEL_X_OFFSET(S_IWUSR | S_IRUGO,
+				   lis3l02dq_read_signed,
+				   lis3l02dq_write_signed,
+				   LIS3L02DQ_REG_OFFSET_X_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_Y_OFFSET(S_IWUSR | S_IRUGO,
+				   lis3l02dq_read_signed,
+				   lis3l02dq_write_signed,
+				   LIS3L02DQ_REG_OFFSET_Y_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_Z_OFFSET(S_IWUSR | S_IRUGO,
+				   lis3l02dq_read_signed,
+				   lis3l02dq_write_signed,
+				   LIS3L02DQ_REG_OFFSET_Z_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_X_GAIN(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_unsigned,
+				 lis3l02dq_write_unsigned,
+				 LIS3L02DQ_REG_GAIN_X_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_Y_GAIN(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_unsigned,
+				 lis3l02dq_write_unsigned,
+				 LIS3L02DQ_REG_GAIN_Y_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_Z_GAIN(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_unsigned,
+				 lis3l02dq_write_unsigned,
+				 LIS3L02DQ_REG_GAIN_Z_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_THRESH(S_IWUSR | S_IRUGO,
+				 lis3l02dq_read_16bit_signed,
+				 lis3l02dq_write_16bit_signed,
+				 LIS3L02DQ_REG_THS_L_ADDR);
+
+/* RFC The reading method for these will change depending on whether
+ * ring buffer capture is in use. Is it worth making these take two
+ * functions and let the core handle which to call, or leave as in this
+ * driver where it is the drivers problem to manage this?
+ */
+
+static IIO_DEV_ATTR_ACCEL_X(lis3l02dq_read_accel,
+			    LIS3L02DQ_REG_OUT_X_L_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_Y(lis3l02dq_read_accel,
+			    LIS3L02DQ_REG_OUT_Y_L_ADDR);
+
+static IIO_DEV_ATTR_ACCEL_Z(lis3l02dq_read_accel,
+			    LIS3L02DQ_REG_OUT_Z_L_ADDR);
+
+static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
+			      lis3l02dq_read_frequency,
+			      lis3l02dq_write_frequency);
+
+static IIO_CONST_ATTR_AVAIL_SAMP_FREQ("280 560 1120 4480");
+
+static ssize_t lis3l02dq_read_interrupt_config(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	int ret;
+	s8 val;
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+
+	ret = lis3l02dq_spi_read_reg_8(dev,
+				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
+				       (u8 *)&val);
+
+	return ret ? ret : sprintf(buf, "%d\n",
+				   (val & this_attr->mask) ? 1 : 0);;
+}
+
+static ssize_t lis3l02dq_write_interrupt_config(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf,
+						size_t len)
+{
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	int ret, currentlyset, changed = 0;
+	u8 valold, controlold;
+	bool val;
+
+	val = !(buf[0] == '0');
+
+	mutex_lock(&indio_dev->mlock);
+	/* read current value */
+	ret = lis3l02dq_spi_read_reg_8(dev,
+				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
+				       &valold);
+	if (ret)
+		goto error_mutex_unlock;
+
+	/* read current control */
+	ret = lis3l02dq_spi_read_reg_8(dev,
+				       LIS3L02DQ_REG_CTRL_2_ADDR,
+				       &controlold);
+	if (ret)
+		goto error_mutex_unlock;
+	currentlyset = !!(valold & this_attr->mask);
+	if (val == false && currentlyset) {
+		valold &= ~this_attr->mask;
+		changed = 1;
+		iio_remove_event_from_list(this_attr->listel,
+						 &indio_dev->interrupts[0]
+						 ->ev_list);
+	} else if (val == true && !currentlyset) {
+		changed = 1;
+		valold |= this_attr->mask;
+		iio_add_event_to_list(this_attr->listel,
+					    &indio_dev->interrupts[0]->ev_list);
+	}
+
+	if (changed) {
+		ret = lis3l02dq_spi_write_reg_8(dev,
+						LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
+						&valold);
+		if (ret)
+			goto error_mutex_unlock;
+		/* This always enables the interrupt, even if we've remove the
+		 * last thing using it. For this device we can use the reference
+		 * count on the handler to tell us if anyone wants the interrupt
+		 */
+		controlold = this_attr->listel->refcount ?
+			(controlold | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT) :
+			(controlold & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
+		ret = lis3l02dq_spi_write_reg_8(dev,
+						LIS3L02DQ_REG_CTRL_2_ADDR,
+						&controlold);
+		if (ret)
+			goto error_mutex_unlock;
+	}
+error_mutex_unlock:
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret ? ret : len;
+}
+
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
+	u8 t;
+
+	lis3l02dq_spi_read_reg_8(&st->indio_dev->dev,
+				 LIS3L02DQ_REG_WAKE_UP_SRC_ADDR,
+				 &t);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_Z_HIGH,
+			       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_Z_LOW,
+			       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_Y_HIGH,
+			       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_LOW)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_Y_LOW,
+			       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_HIGH)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_X_HIGH,
+			       st->last_timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_LOW)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_X_LOW,
+			       st->last_timestamp);
+	/* reenable the irq */
+	enable_irq(st->us->irq);
+	/* Ack and allow for new interrupts */
+	lis3l02dq_spi_read_reg_8(&st->indio_dev->dev,
+				 LIS3L02DQ_REG_WAKE_UP_ACK_ADDR,
+				 &t);
+
+	return;
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
+	&iio_event_attr_accel_x_high.dev_attr.attr,
+	&iio_event_attr_accel_y_high.dev_attr.attr,
+	&iio_event_attr_accel_z_high.dev_attr.attr,
+	&iio_event_attr_accel_x_low.dev_attr.attr,
+	&iio_event_attr_accel_y_low.dev_attr.attr,
+	&iio_event_attr_accel_z_low.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group lis3l02dq_event_attribute_group = {
+	.attrs = lis3l02dq_event_attributes,
+};
+
+static IIO_CONST_ATTR(name, "lis3l02dq");
+
+static struct attribute *lis3l02dq_attributes[] = {
+	&iio_dev_attr_accel_x_offset.dev_attr.attr,
+	&iio_dev_attr_accel_y_offset.dev_attr.attr,
+	&iio_dev_attr_accel_z_offset.dev_attr.attr,
+	&iio_dev_attr_accel_x_gain.dev_attr.attr,
+	&iio_dev_attr_accel_y_gain.dev_attr.attr,
+	&iio_dev_attr_accel_z_gain.dev_attr.attr,
+	&iio_dev_attr_thresh.dev_attr.attr,
+	&iio_dev_attr_accel_x.dev_attr.attr,
+	&iio_dev_attr_accel_y.dev_attr.attr,
+	&iio_dev_attr_accel_z.dev_attr.attr,
+	&iio_dev_attr_sampling_frequency.dev_attr.attr,
+	&iio_const_attr_available_sampling_frequency.dev_attr.attr,
+	&iio_const_attr_name.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group lis3l02dq_attribute_group = {
+	.attrs = lis3l02dq_attributes,
+};
+
+static int __devinit lis3l02dq_probe(struct spi_device *spi)
+{
+	int ret;
+	struct lis3l02dq_state *st = kzalloc(sizeof *st, GFP_KERNEL);
+	if (!st) {
+		ret =  -ENOMEM;
+		goto error_ret;
+	}
+	/* this is only used tor removal purposes */
+	spi_set_drvdata(spi, st);
+
+	/* Allocate the comms buffers */
+	st->rx = kzalloc(sizeof(*st->rx)*LIS3L02DQ_MAX_RX, GFP_KERNEL);
+	if (st->rx == NULL) {
+		ret = -ENOMEM;
+		goto error_free_st;
+	}
+	st->tx = kzalloc(sizeof(*st->tx)*LIS3L02DQ_MAX_TX, GFP_KERNEL);
+	if (st->tx == NULL) {
+		ret = -ENOMEM;
+		goto error_free_rx;
+	}
+	st->us = spi;
+	mutex_init(&st->buf_lock);
+	/* setup the industrialio driver allocated elements */
+	st->indio_dev = iio_allocate_device();
+	if (st->indio_dev == NULL) {
+		ret = -ENOMEM;
+		goto error_free_tx;
+	}
+
+	st->indio_dev->dev.parent = &spi->dev;
+	st->indio_dev->num_interrupt_lines = 1;
+	st->indio_dev->event_attrs = &lis3l02dq_event_attribute_group;
+	st->indio_dev->attrs = &lis3l02dq_attribute_group;
+	st->indio_dev->dev_data = (void *)(st);
+	st->indio_dev->driver_module = THIS_MODULE;
+	st->indio_dev->modes = INDIO_DIRECT_MODE;
+
+	ret = lis3l02dq_configure_ring(st->indio_dev);
+	if (ret)
+		goto error_free_dev;
+
+	ret = iio_device_register(st->indio_dev);
+	if (ret)
+		goto error_unreg_ring_funcs;
+
+	ret = lis3l02dq_initialize_ring(st->indio_dev->ring);
+	if (ret) {
+		printk(KERN_ERR "failed to initialize the ring\n");
+		goto error_unregister_dev;
+	}
+
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
+		/* This is a little unusual, in that the device seems
+		   to need a full read of the interrupt source reg before
+		   the interrupt will reset.
+		   Hence the two handlers are the same */
+		iio_init_work_cont(&st->work_cont_thresh,
+				   lis3l02dq_thresh_handler_bh_no_check,
+				   lis3l02dq_thresh_handler_bh_no_check,
+				   LIS3L02DQ_REG_WAKE_UP_SRC_ADDR,
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
+
+	}
+
+	ret = lis3l02dq_probe_trigger(st->indio_dev);
+	if (ret)
+		goto error_unregister_line;
+
+	/* Get the device into a sane initial state */
+	ret = lis3l02dq_initial_setup(st);
+	if (ret)
+		goto error_remove_trigger;
+	return 0;
+
+error_remove_trigger:
+	lis3l02dq_remove_trigger(st->indio_dev);
+error_unregister_line:
+	if (st->indio_dev->modes & INDIO_RING_TRIGGERED)
+		iio_unregister_interrupt_line(st->indio_dev, 0);
+error_unregister_dev:
+	iio_device_unregister(st->indio_dev);
+error_unreg_ring_funcs:
+	lis3l02dq_unconfigure_ring(st->indio_dev);
+error_free_dev:
+	iio_free_device(st->indio_dev);
+error_free_tx:
+	kfree(st->tx);
+error_free_rx:
+	kfree(st->rx);
+error_free_st:
+	kfree(st);
+error_ret:
+	return ret;
+}
+
+/* Power down the device */
+static int lis3l02dq_stop_device(struct iio_dev *indio_dev)
+{
+	int ret;
+	struct lis3l02dq_state *st = indio_dev->dev_data;
+	u8 val = 0;
+
+	mutex_lock(&indio_dev->mlock);
+	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+					LIS3L02DQ_REG_CTRL_1_ADDR,
+					&val);
+	if (ret) {
+		dev_err(&st->us->dev, "problem with turning device off: ctrl1");
+		goto err_ret;
+	}
+
+	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+					LIS3L02DQ_REG_CTRL_2_ADDR,
+					&val);
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
+	struct lis3l02dq_state *st = spi_get_drvdata(spi);
+	struct iio_dev *indio_dev = st->indio_dev;
+
+	ret = lis3l02dq_stop_device(indio_dev);
+	if (ret)
+		goto err_ret;
+
+	flush_scheduled_work();
+
+	lis3l02dq_remove_trigger(indio_dev);
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
+		iio_unregister_interrupt_line(indio_dev, 0);
+
+	lis3l02dq_uninitialize_ring(indio_dev->ring);
+
+	iio_device_unregister(indio_dev);
+
+	lis3l02dq_unconfigure_ring(indio_dev);
+
+	iio_free_device(indio_dev);
+	kfree(st->tx);
+	kfree(st->rx);
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
+module_init(lis3l02dq_init);
+
+static __exit void lis3l02dq_exit(void)
+{
+	spi_unregister_driver(&lis3l02dq_driver);
+}
+module_exit(lis3l02dq_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("ST LIS3L02DQ Accelerometer SPI driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/iio/accel.h b/include/linux/iio/accel.h
new file mode 100644
index 0000000..c66df20
--- /dev/null
+++ b/include/linux/iio/accel.h
@@ -0,0 +1,167 @@
+
+#include <linux/iio/sysfs.h>
+
+/* Accelerometer types of attribute */
+
+#define IIO_DEV_ATTR_ACCEL_X_OFFSET(_mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(accel_x_offset, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_Y_OFFSET(_mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(accel_y_offset, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_Z_OFFSET(_mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(accel_z_offset, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_X_GAIN(_mode, _show, _store, _addr)		\
+	IIO_DEVICE_ATTR(accel_x_gain, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_Y_GAIN(_mode, _show, _store, _addr)		\
+	IIO_DEVICE_ATTR(accel_y_gain, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_Z_GAIN(_mode, _show, _store, _addr)		\
+	IIO_DEVICE_ATTR(accel_z_gain, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_X(_show, _addr)			\
+	IIO_DEVICE_ATTR(accel_x, S_IRUGO, _show, NULL, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_Y(_show, _addr)			\
+	IIO_DEVICE_ATTR(accel_y, S_IRUGO, _show, NULL, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_Z(_show, _addr)			\
+	IIO_DEVICE_ATTR(accel_z, S_IRUGO, _show, NULL, _addr)
+
+/* Thresholds are somewhat chip dependent - may need quite a few defs here */
+/* For unified thesholds (shared across all directions */
+
+/**
+ * IIO_DEV_ATTR_ACCEL_THRESH: unified threshold
+ * @_mode: read/write
+ * @_show: read detector threshold value
+ * @_store: write detector theshold value
+ * @_addr: driver specific data, typically a register address
+ *
+ * This one is for cases where as single threshold covers all directions
+ **/
+#define IIO_DEV_ATTR_ACCEL_THRESH(_mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(thresh, _mode, _show, _store, _addr)
+
+/**
+ * IIO_DEV_ATTR_ACCEL_THRESH_X: independant direction threshold, x axis
+ * @_mode: readable / writable
+ * @_show: read x axis detector theshold value
+ * @_store: write x axis detector threshold value
+ * @_addr: device driver dependant, typically a register address
+ **/
+#define IIO_DEV_ATTR_ACCEL_THRESH_X(_mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(thresh_accel_x, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_THRESH_Y(_mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(thresh_accel_y, _mode, _show, _store, _addr)
+
+#define IIO_DEV_ATTR_ACCEL_THRESH_Z(_mode, _show, _store, _addr)	\
+	IIO_DEVICE_ATTR(thresh_accel_z, _mode, _show, _store, _addr)
+
+
+/**
+ * IIO_EVENT_ATTR_ACCEL_X_HIGH: threshold event, x acceleration
+ * @_show: read x acceleration high threshold
+ * @_store: write x acceleration high threshold
+ * @_mask: device dependant, typically a bit mask
+ * @_handler: the iio_handler associated with this attribute
+ **/
+#define IIO_EVENT_ATTR_ACCEL_X_HIGH(_show, _store, _mask, _handler)	\
+	IIO_EVENT_ATTR(accel_x_high, _show, _store, _mask, _handler)
+
+/**
+ * IIO_EVENT_ATTR_ACCEL_X_HIGH_SH: threshold event, x accel high, shared handler
+ * @_evlist: event list used to share the handler
+ * @_show: attribute read
+ * @_store: attribute write
+ * @_mask: driver specific data, typically a bit mask
+ **/
+#define IIO_EVENT_ATTR_ACCEL_X_HIGH_SH(_evlist, _show, _store, _mask)	\
+	IIO_EVENT_ATTR_SH(accel_x_high, _evlist, _show, _store, _mask)
+
+/**
+ * IIO_EVENT_CODE_ACCEL_X_HIGH - event code for x axis high accel threshold
+ **/
+#define IIO_EVENT_CODE_ACCEL_X_HIGH IIO_EVENT_CODE_ACCEL_BASE
+
+#define IIO_EVENT_ATTR_ACCEL_Y_HIGH(_show, _store, _mask, _handler)	\
+	IIO_EVENT_ATTR(accel_y_high, _show, _store, _mask, _handler)
+
+#define IIO_EVENT_ATTR_ACCEL_Y_HIGH_SH(_evlist, _show, _store, _mask)	\
+	IIO_EVENT_ATTR_SH(accel_y_high, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Y_HIGH (IIO_EVENT_CODE_ACCEL_BASE + 1)
+
+#define IIO_EVENT_ATTR_ACCEL_Z_HIGH(_show, _store, _mask, _handler)	\
+	IIO_EVENT_ATTR(accel_z_high, _show, _store, _mask, _handler)
+
+#define IIO_EVENT_ATTR_ACCEL_Z_HIGH_SH(_evlist, _show, _store, _mask)	\
+	IIO_EVENT_ATTR_SH(accel_z_high, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Z_HIGH (IIO_EVENT_CODE_ACCEL_BASE + 2)
+
+#define IIO_EVENT_ATTR_ACCEL_X_LOW(_show, _store, _mask, _handler)	\
+	IIO_EVENT_ATTR(accel_x_low, _show, _store, _mask, _handler)
+
+#define IIO_EVENT_ATTR_ACCEL_X_LOW_SH(_evlist, _show, _store, _mask)	\
+	IIO_EVENT_ATTR_SH(accel_x_low, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_X_LOW (IIO_EVENT_CODE_ACCEL_BASE + 3)
+
+#define IIO_EVENT_ATTR_ACCEL_Y_LOW(_show, _store, _mask, _handler) \
+	IIO_EVENT_ATTR(accel_y_low, _show, _store, _mask, _handler)
+
+#define IIO_EVENT_ATTR_ACCEL_Y_LOW_SH(_evlist, _show, _store, _mask)\
+	IIO_EVENT_ATTR_SH(accel_y_low, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Y_LOW (IIO_EVENT_CODE_ACCEL_BASE + 4)
+
+#define IIO_EVENT_ATTR_ACCEL_Z_LOW(_show, _store, _mask, _handler)	\
+	IIO_EVENT_ATTR(accel_z_low, _show, _store, _mask, _handler)
+
+#define IIO_EVENT_ATTR_ACCEL_Z_LOW_SH(_evlist, _show, _store, _mask)	\
+	IIO_EVENT_ATTR_SH(accel_z_low, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Z_LOW (IIO_EVENT_CODE_ACCEL_BASE + 5)
+
+#define IIO_EVENT_ATTR_FREE_FALL_DETECT(_show, _store, _mask, _handler)	\
+	IIO_EVENT_ATTR(free_fall, _show, _store, _mask, _handler)
+
+#define IIO_EVENT_ATTR_FREE_FALL_DETECT_SH(_evlist, _show, _store, _mask) \
+	IIO_EVENT_ATTR_SH(free_fall, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_FREE_FALL (IIO_EVENT_CODE_ACCEL_BASE + 6)
+
+
+#define IIO_EVENT_ATTR_ACCEL_X_ROC_HIGH_SH(_evlist, _show, _store, _mask) \
+	IIO_EVENT_ATTR_SH(accel_x_roc_high, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_X_ROC_HIGH (IIO_EVENT_CODE_ACCEL_BASE + 10)
+
+#define IIO_EVENT_ATTR_ACCEL_X_ROC_LOW_SH(_evlist, _show, _store, _mask) \
+	IIO_EVENT_ATTR_SH(accel_x_roc_low, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_X_ROC_LOW (IIO_EVENT_CODE_ACCEL_BASE + 11)
+
+#define IIO_EVENT_ATTR_ACCEL_Y_ROC_HIGH_SH(_evlist, _show, _store, _mask) \
+	IIO_EVENT_ATTR_SH(accel_y_roc_high, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Y_ROC_HIGH (IIO_EVENT_CODE_ACCEL_BASE + 12)
+
+#define IIO_EVENT_ATTR_ACCEL_Y_ROC_LOW_SH(_evlist, _show, _store, _mask) \
+	IIO_EVENT_ATTR_SH(accel_y_roc_low, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Y_ROC_LOW (IIO_EVENT_CODE_ACCEL_BASE + 13)
+
+#define IIO_EVENT_ATTR_ACCEL_Z_ROC_HIGH_SH(_evlist, _show, _store, _mask) \
+	IIO_EVENT_ATTR_SH(accel_z_roc_high, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Z_ROC_HIGH (IIO_EVENT_CODE_ACCEL_BASE + 14)
+
+#define IIO_EVENT_ATTR_ACCEL_Z_ROC_LOW_SH(_evlist, _show, _store, _mask) \
+	IIO_EVENT_ATTR_SH(accel_z_roc_low, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_ACCEL_Z_ROC_LOW (IIO_EVENT_CODE_ACCEL_BASE + 15)
-- 
1.6.2

