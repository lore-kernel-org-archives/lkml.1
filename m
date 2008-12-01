Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYLAOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYLAOhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYLAOh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:37:29 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:39125 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYLAOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:37:26 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F6A4.3070801@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:37:24 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [11/13] RFC: VTI SCA3000 3d accelerometer driver.
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
From: Jonathan Cameron <jic23@cam.ac.uk>

IIO: VTI SCA3000 3d accelerometer driver.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--
This patch provides support for the VTI SCA3000 seriese of
accelerometers. These are relatively unusual chips having
internal ring buffers. They provide interrupt signals on
ring buffer events (50% full etc) and so fit well within
the IIO ring buffer architecture.

This patch also introduces the ring_hw.h header which provides
the infrastructure code for hardware ring buffers.

At the current time this driver doesn't support triggers
or software ring buffers.  As it does not supply a data
ready signal it doesn't really make sense to use it as
a trigger, but more complex use of the ring buffer might
include the ability to trigger a copy of current contents
for example on some other event.


 drivers/industrialio/accelerometer/Kconfig        |    8 +
 drivers/industrialio/accelerometer/Makefile       |    6 +-
 drivers/industrialio/accelerometer/sca3000.h      |  266 ++++
 drivers/industrialio/accelerometer/sca3000_core.c | 1522 +++++++++++++++++++++
 drivers/industrialio/accelerometer/sca3000_ring.c |  196 +++
 include/linux/industrialio/ring_hw.h              |    9 +
 include/linux/industrialio/sca3000.h              |   36 +
 7 files changed, 2042 insertions(+), 1 deletions(-)

diff --git a/drivers/industrialio/accelerometer/Kconfig b/drivers/industrialio/accelerometer/Kconfig
index 7e011a6..02bfb53 100644
--- a/drivers/industrialio/accelerometer/Kconfig
+++ b/drivers/industrialio/accelerometer/Kconfig
@@ -19,3 +19,11 @@ config LIS3L02DQ_SPI
 	  Say yes here to build support for the ST LIS3L02DQ accelerometer via
 	  an SPI bus.
 
+config SCA3000
+       depends on INDUSTRIALIO
+       depends on SPI
+       tristate "VTI SCA3000 series accelerometers"
+       help
+         Say yes here to build support for the VTI SCA3000 series of SPI 
+	 accelerometers. These devices use a hardware ring buffer. Direct
+	 access is available unless motion detector mode is enabled.
\ No newline at end of file
diff --git a/drivers/industrialio/accelerometer/Makefile b/drivers/industrialio/accelerometer/Makefile
index 3079723..eabc23e 100644
--- a/drivers/industrialio/accelerometer/Makefile
+++ b/drivers/industrialio/accelerometer/Makefile
@@ -5,4 +5,8 @@
 lis3l02dq-y := lis3l02dq_core.o
 #RFC separate config param per device?
 lis3l02dq-$(CONFIG_IIO_RING_BUFFER) += lis3l02dq_ring.o
-obj-$(CONFIG_LIS3L02DQ_SPI)	:= lis3l02dq.o
\ No newline at end of file
+obj-$(CONFIG_LIS3L02DQ_SPI)	:= lis3l02dq.o
+
+sca3000-y := sca3000_core.o
+sca3000-$(CONFIG_IIO_RING_BUFFER) += sca3000_ring.o
+obj-$(CONFIG_SCA3000)		+= sca3000.o
diff --git a/drivers/industrialio/accelerometer/sca3000.h b/drivers/industrialio/accelerometer/sca3000.h
new file mode 100644
index 0000000..b05e4aa
--- /dev/null
+++ b/drivers/industrialio/accelerometer/sca3000.h
@@ -0,0 +1,266 @@
+/*
+ * sca3000.c -- support VTI sca3000 series accelerometers
+ *              via SPI
+ *
+ * Copyright (c) 2007 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * Partly based upon tle62x0.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Initial mode is direct measurement.
+ *
+ * Untested things
+ *
+ * Temperature reading (the e05 I'm testing with doesn't have a sensor)
+ *
+ * Free fall detection mode - supported but untested as I'm not droping my
+ * dubious wire rig far enough to test it.
+ *
+ * Unsupported as yet
+ *
+ * Time stamping of data from ring. Various ideas on how to do this but none
+ * are remotely simple. Suggestions welcome.
+ *
+ * Individual enabling disabling of channels going into ring buffer
+ *
+ * Overflow handling (this is signaled for all but 8 bit ring buffer mode.)
+ *
+ * Motion detector using AND combinations of signals.
+ *
+ * Note: Be very careful about not touching an register bytes marked
+ * as reserved on the data sheet. They really mean it as changing convents of
+ * some will cause the device to lock up.
+ *
+ * Known issues - on rare occasions the interrupts lock up. Not sure why as yet.
+ * Can probably alleviate this by reading the interrupt register on start, but
+ * that is really just brushing the problem under the carpet.
+ */
+#define SCA3000_WRITE_REG(a) ((a) << 2) | 0x02
+#define SCA3000_READ_REG(a) ((a) << 2)
+
+#define SCA3000_REG_ADDR_REVID			0x00
+#define SCA3000_REVID_MAJOR_MASK		0xf0
+#define SCA3000_REVID_MINOR_MASK		0x0f
+
+#define SCA3000_REG_ADDR_STATUS			0x02
+#define SCA3000_LOCKED				0x20
+#define SCA3000_EEPROM_CS_ERROR			0x02
+#define SCA3000_SPI_FRAME_ERROR			0x01
+
+/* All reads done using register decrement so no need to directly access LSBs */
+#define SCA3000_REG_ADDR_X_MSB			0x05
+#define SCA3000_REG_ADDR_Y_MSB			0x07
+#define SCA3000_REG_ADDR_Z_MSB			0x09
+
+#define SCA3000_REG_ADDR_RING_OUT		0x0f
+
+/* Temp read untested - the e05 doesn't have the sensor */
+#define SCA3000_REG_ADDR_TEMP_MSB		0x13
+
+#define SCA3000_REG_ADDR_MODE			0x14
+#define SCA3000_MODE_PROT_MASK			0x28
+
+#define SCA3000_RING_BUF_ENABLE			0x80
+#define SCA3000_RING_BUF_8BIT			0x40
+/* Free fall detection triggers an interrupt if the acceleration
+ * is below a threshold for equivalent of 25cm drop
+ */
+#define SCA3000_FREE_FALL_DETECT		0x10
+#define SCA3000_MEAS_MODE_NORMAL		0x00
+#define SCA3000_MEAS_MODE_OP_1			0x01
+#define SCA3000_MEAS_MODE_OP_2			0x02
+
+/* In motion detection mode the accelerations are band pass filtered
+ * (aprox 1 - 25Hz) and then a programmable theshold used to trigger
+ * and interrupt.
+ */
+#define SCA3000_MEAS_MODE_MOT_DET		0x03
+
+#define SCA3000_REG_ADDR_BUF_COUNT		0x15
+
+#define SCA3000_REG_ADDR_INT_STATUS		0x16
+
+#define SCA3000_INT_STATUS_THREE_QUARTERS	0x80
+#define SCA3000_INT_STATUS_HALF			0x40
+
+#define SCA3000_INT_STATUS_FREE_FALL		0x08
+#define SCA3000_INT_STATUS_Y_TRIGGER		0x04
+#define SCA3000_INT_STATUS_X_TRIGGER		0x02
+#define SCA3000_INT_STATUS_Z_TRIGGER		0x01
+
+/* Used to allow accesss to multiplexed registers */
+#define SCA3000_REG_ADDR_CTRL_SEL		0x18
+/* Only available for SCA3000-D03 and SCA3000-D01 */
+#define SCA3000_REG_CTRL_SEL_I2C_DISABLE	0x01
+#define SCA3000_REG_CTRL_SEL_MD_CTRL		0x02
+#define SCA3000_REG_CTRL_SEL_MD_Y_TH		0x03
+#define SCA3000_REG_CTRL_SEL_MD_X_TH		0x04
+#define SCA3000_REG_CTRL_SEL_MD_Z_TH		0x05
+/* BE VERY CAREFUL WITH THIS, IF 3 BITS ARE NOT SET the device
+   will not function */
+#define SCA3000_REG_CTRL_SEL_OUT_CTRL		0x0B
+#define SCA3000_OUT_CTRL_PROT_MASK		0xE0
+#define SCA3000_OUT_CTRL_BUF_X_EN		0x10
+#define SCA3000_OUT_CTRL_BUF_Y_EN		0x08
+#define SCA3000_OUT_CTRL_BUF_Z_EN		0x04
+#define SCA3000_OUT_CTRL_BUF_DIV_4		0x02
+#define SCA3000_OUT_CTRL_BUF_DIV_2		0x01
+
+/* Control which motion detector interrupts are on.
+ * For now only OR combinations are supported.x
+ */
+#define SCA3000_MD_CTRL_PROT_MASK		0xC0
+#define SCA3000_MD_CTRL_OR_Y			0x01
+#define SCA3000_MD_CTRL_OR_X			0x02
+#define SCA3000_MD_CTRL_OR_Z			0x04
+/* Currently unsupported */
+#define SCA3000_MD_CTRL_AND_Y			0x08
+#define SCA3000_MD_CTRL_AND_X			0x10
+#define SAC3000_MD_CTRL_AND_Z			0x20
+
+/* Some control registers of complex access methods requiring this register to
+ * be used to remove a lock.
+ */
+#define SCA3000_REG_ADDR_UNLOCK			0x1e
+
+#define SCA3000_REG_ADDR_INT_MASK		0x21
+#define SCA3000_INT_MASK_PROT_MASK		0x1C
+
+#define SCA3000_INT_MASK_RING_THREE_QUARTER	0x80
+#define SCA3000_INT_MASK_RING_HALF		0x40
+
+#define SCA3000_INT_MASK_ALL_INTS		0x02
+#define SCA3000_INT_MASK_ACTIVE_HIGH		0x01
+#define SCA3000_INT_MASK_ACTIVE_LOW		0x00
+
+/* Values of mulipexed registers (write to ctrl_data after select) */
+#define SCA3000_REG_ADDR_CTRL_DATA		0x22
+
+/* Measurment modes available on some sca3000 series chips. Code assumes others
+ * may become available in the future.
+ *
+ * Bypass - Bypass the low-pass filter in the signal channel so as to increase
+ *          signal bandwidth.
+ *
+ * Narrow - Narrow low-pass filtering of the signal channel and half output
+ *          data rate by decimation.
+ *
+ * Wide - Widen low-pass filtering of signal channel to increase bandwidth
+ */
+#define SCA3000_OP_MODE_BYPASS			0x01
+#define SCA3000_OP_MODE_NARROW			0x02
+#define SCA3000_OP_MODE_WIDE			0x04
+#define SCA3000_MAX_TX 6
+#define SCA3000_MAX_RX 2
+
+/**
+ * struct sca3000_state - device instance state information
+ * @us: 	 		the associated spi device
+ * @info: 	  		chip variant information
+ * @indio_dev: 	 		device information used by the IIO core
+ * @interrupt_handler_ws: 	event interrupt handler for all events
+ * @last_timestamp: 		the timestamp of the last event
+ * @mo_det_use_count: 		reference counter for the motion detection unit
+ * @lock: 		 	lock used to protect elements of sca3000_state
+ * 	 			and the underlying device state.
+ * @bps: 		 	number of bits per sample
+ * @tx: 		 	dma-able transmit buffer
+ * @rx: 		 	dma-able receive buffer
+ **/
+struct sca3000_state {
+	struct spi_device		*us;
+	const struct sca3000_chip_info	*info;
+	struct iio_dev			*indio_dev;
+	struct work_struct		interrupt_handler_ws;
+	s64				last_timestamp;
+	int				mo_det_use_count;
+	struct mutex			lock;
+	int				bps;
+	u8				*tx;
+	/* not used during a ring buffer read */
+	u8				*rx;
+};
+
+#define sca3000_state_from_dev(dev)					\
+	(((struct iio_dev *)(spi_get_drvdata(to_spi_device(dev))))->dev_data)
+
+/**
+ * struct sca3000_chip_info - model dependant parameters
+ * @name: 			model identification
+ * @temp_output:		some devices have temperature sensors.
+ * @measurement_mode_freq:	normal mode sampling frequency
+ * @option_mode_1:		first optional mode. Not all models have one
+ * @option_mode_1_freq:		option mode 1 sampling frequency
+ * @option_mode_2:		second optional mode. Not all chips have one
+ * @option_mode_2_freq:		option mode 2 sampling frequency
+ *
+ * This structure is used to hold information about the functionality of a given
+ * sca3000 variant.
+ **/
+struct sca3000_chip_info {
+	const char		*name;
+	bool			temp_output;
+	int			measurement_mode_freq;
+	int			option_mode_1;
+	int			option_mode_1_freq;
+	int			option_mode_2;
+	int			option_mode_2_freq;
+};
+
+/**
+ * sca3000_read_data() read a series of values from the device
+ * @dev:		device
+ * @reg_address_high:	start address (decremented read)
+ * @rx:			pointer where recieved data is placed. Callee
+ *			responsible for freeing this.
+ * @len:		number of bytes to read
+ *
+ * The main lock must be held.
+ **/
+int sca3000_read_data(struct device *dev,
+		      u8 reg_address_high,
+		      u8 **rx_p,
+		      int len);
+
+/**
+ * sca3000_write_reg() write a single register
+ * @address:	address of register on chip
+ * @val:	value to be written to register
+ *
+ * The main lock must be held.
+ **/
+int sca3000_write_reg(struct device *dev, u8 address, u8 val);
+
+#ifdef CONFIG_IIO_RING_BUFFER
+/**
+ * sca3000_register_ring_funcs() setup the ring state change functions
+ **/
+void sca3000_register_ring_funcs(struct iio_dev *indio_dev);
+/**
+ * sca3000_register_ring_access_and_init() init and set ring buffer access up
+ *
+ * Principally registers the ring access and control functions with the IIO
+ * core.
+ **/
+int sca3000_register_ring_access_and_init(struct iio_dev *indio_dev);
+
+/**
+ * sca3000_ring_int_process() handles ring related event pushing and escalation
+ * @val:	the event code
+ **/
+void sca3000_ring_int_process(u8 val, void *ring);
+
+#else
+static inline void sca3000_register_ring_funcs(struct iio_dev *indio_dev) {};
+
+static inline
+int sca3000_register_ring_access_and_init(struct iio_dev *indio_dev)
+{
+	return 0;
+};
+
+static inline void sca3000_ring_int_process(u8 val, void *ring) {};
+#endif
diff --git a/drivers/industrialio/accelerometer/sca3000_core.c b/drivers/industrialio/accelerometer/sca3000_core.c
new file mode 100644
index 0000000..d6dbb89
--- /dev/null
+++ b/drivers/industrialio/accelerometer/sca3000_core.c
@@ -0,0 +1,1522 @@
+/*
+ * sca3000_core.c -- support VTI sca3000 series accelerometers via SPI
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
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
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/sysfs.h>
+#include <linux/industrialio/accel.h>
+
+#include <linux/industrialio/sca3000.h>
+#include "sca3000.h"
+
+enum sca3000_variant {
+	d01,
+	d03,
+	e02,
+	e04,
+	e05,
+	l01,
+};
+/* Note where option modes are not defined, the chip simply does not
+ * support any.
+ * Other chips in the sca3000 series use i2c and are not included here.
+ *
+ * Some of these devices are only listed in the family data sheet and
+ * do not actually appear to be available.
+ */
+static const struct sca3000_chip_info sca3000_spi_chip_info_tbl[] = {
+	{
+		.name = "sca3000-d01",
+		.temp_output = true,
+		.measurement_mode_freq = 250,
+		.option_mode_1 = SCA3000_OP_MODE_BYPASS,
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
+
+int sca3000_write_reg(struct device *dev, u8 address, u8 val)
+{
+	struct spi_device *spi_dev = to_spi_device(dev);
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct spi_transfer xfer = {
+		.bits_per_word = 8,
+		.len = 2,
+		.cs_change = 1,
+		.tx_buf = st->tx,
+	};
+	struct spi_message msg;
+
+	st->tx[0] = SCA3000_WRITE_REG(address);
+	st->tx[1] = val;
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	return spi_sync(spi_dev, &msg);
+}
+
+
+
+int sca3000_read_data(struct device *dev,
+		      uint8_t reg_address_high,
+		      u8 **rx_p,
+		      int len)
+{
+  	int ret;
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct spi_message msg;
+	struct spi_device *spi_dev = to_spi_device(dev);
+	struct spi_transfer xfer = {
+		.bits_per_word = 8,
+		.len = len + 1,
+		.cs_change = 1,
+		.tx_buf = st->tx,
+	};
+	*rx_p = kmalloc(len + 1, GFP_KERNEL);
+	if (*rx_p == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	xfer.rx_buf = *rx_p;
+	st->tx[0] = SCA3000_READ_REG(reg_address_high);
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	ret = spi_sync(spi_dev, &msg);
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
+/**
+ * sca3000_reg_lock_on() test if the ctrl register lock is on
+ *
+ * Lock must be held.
+ **/
+static int sca3000_reg_lock_on(struct device *dev)
+{
+	u8 *rx;
+	int ret;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_STATUS, &rx, 1);
+
+	if (ret < 0)
+		return ret;
+	ret = (rx[1] & SCA3000_LOCKED) ? 0 : 1;
+	kfree(rx);
+
+	return ret;
+}
+
+/**
+ * __sca3000_unlock_reg_lock() unlock the control registers
+ *
+ * Note the device does not appear to support doing this in a single transfer.
+ * This should only ever be used as part of ctrl reg read.
+ * Lock must be held before calling this
+ **/
+static int __sca3000_unlock_reg_lock(struct device *dev)
+{
+	struct spi_device *spi_dev = to_spi_device(dev);
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct spi_message msg;
+	struct spi_transfer xfer[3] = {
+		{
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+			.tx_buf = st->tx,
+		}, {
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+			.tx_buf = st->tx + 2,
+		}, {
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+			.tx_buf = st->tx + 4,
+		},
+	};
+	st->tx[0] = SCA3000_WRITE_REG(SCA3000_REG_ADDR_UNLOCK);
+	st->tx[1] = 0x00;
+	st->tx[2] = SCA3000_WRITE_REG(SCA3000_REG_ADDR_UNLOCK);
+	st->tx[3] = 0x50;
+	st->tx[4] = SCA3000_WRITE_REG(SCA3000_REG_ADDR_UNLOCK);
+	st->tx[5] = 0xA0;
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer[0], &msg);
+	spi_message_add_tail(&xfer[1], &msg);
+	spi_message_add_tail(&xfer[2], &msg);
+
+	return spi_sync(spi_dev, &msg);
+}
+
+/**
+ * sca3000_write_ctrl_reg() write to a lock protect ctrl register
+ * @sel: selects which registers we wish to write to
+ * @val: the value to be written
+ *
+ * Certain control registers are protected against overwriting by the lock
+ * register and use a shared write address. This function allows writing of
+ * these registers.
+ **/
+static int sca3000_write_ctrl_reg(struct device *dev, uint8_t sel, uint8_t val)
+{
+
+	int ret;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct sca3000_state *st = indio_dev->dev_data;
+	/* Check whether the lock is on and unlock if needed. */
+	mutex_lock(&st->lock);
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
+	mutex_unlock(&st->lock);
+	return ret;
+}
+
+/* Crucial that lock is called before calling this */
+/**
+ * sca3000_read_ctrl_reg() read from lock protected control register.
+ *
+ * Lock must be held.
+ **/
+static int sca3000_read_ctrl_reg(struct device *dev,
+				 u8 ctrl_reg,
+				 u8 **rx_p)
+{
+	int ret;
+
+
+	ret = sca3000_reg_lock_on(dev);
+	if (ret < 0)
+		goto error_ret;
+	if (ret) {
+		ret = __sca3000_unlock_reg_lock(dev);
+		if (ret)
+			goto error_ret;
+	}
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
+/**
+ * sca3000_check_status() check the status register
+ *
+ * Only used for debugging purposes
+ **/
+static int sca3000_check_status(struct device *dev)
+{
+	u8 *rx;
+	int ret;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct sca3000_state *st = indio_dev->dev_data;
+
+	mutex_lock(&st->lock);
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
+	mutex_unlock(&st->lock);
+	return ret;
+}
+
+/**
+ * sca3000_read_13bit_signed() sysfs interface to read 13 bit signed registers
+ *
+ * These are described as signed 12 bit on the data sheet, which appears
+ * to be a conventional 2's complement 13 bit.
+ **/
+static ssize_t sca3000_read_13bit_signed(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	int len = 0, ret;
+	int val;
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	u8 *rx;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct sca3000_state *st = indio_dev->dev_data;
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, this_attr->address, &rx, 2);
+	if (ret < 0)
+		goto error_ret;
+	val = sca3000_13bit_convert(rx[1], rx[2]);
+	len += sprintf(buf + len, "%d\n", val);
+	kfree(rx);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+
+/**
+ * sca3000_show_reg() sysfs interface to read the chip revision number
+ **/
+static ssize_t sca3000_show_rev(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	int len = 0, ret;
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	u8 *rx;
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_REVID, &rx, 1);
+	if (ret < 0)
+		goto error_ret;
+	len += sprintf(buf + len,
+		       "major=%d, minor=%d\n",
+		       rx[1] & SCA3000_REVID_MAJOR_MASK,
+		       rx[1] & SCA3000_REVID_MINOR_MASK);
+	kfree(rx);
+
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+
+/**
+ * sca3000_show_available_measurement_modes() display available modes
+ *
+ * This is all read from chip specific data in the driver. Not all
+ * of the sca3000 series support modes other than normal.
+ **/
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
+/**
+ * sca3000_show_measurmenet_mode() sysfs read of current mode
+ **/
+static ssize_t
+sca3000_show_measurement_mode(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int len = 0, ret;
+	u8 *rx;
+
+	mutex_lock(&st->lock);
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
+error_ret:
+	mutex_unlock(&st->lock);
+	return ret ? ret : len;
+}
+
+/**
+ * sca3000_store_measurement_mode() set the current mode
+ **/
+static ssize_t
+sca3000_store_measurement_mode(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf,
+			       size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	u8 *rx;
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
+/* Not even vaguely standard attributes so defined here rather than
+ * in the relevant IIO core headers
+ */
+static IIO_DEVICE_ATTR(available_measurement_modes, S_IRUGO,
+		       sca3000_show_available_measurement_modes,
+		       NULL, 0);
+
+static IIO_DEVICE_ATTR(measurement_mode, S_IRUGO | S_IWUSR,
+		       sca3000_show_measurement_mode,
+		       sca3000_store_measurement_mode,
+		       0);
+
+/* More standard attributes */
+static IIO_DEV_ATTR_REV(sca3000_show_rev);
+
+static IIO_DEV_ATTR_ACCEL_X(sca3000_read_13bit_signed,
+			    SCA3000_REG_ADDR_X_MSB);
+static IIO_DEV_ATTR_ACCEL_Y(sca3000_read_13bit_signed,
+			    SCA3000_REG_ADDR_Y_MSB);
+static IIO_DEV_ATTR_ACCEL_Z(sca3000_read_13bit_signed,
+			    SCA3000_REG_ADDR_Z_MSB);
+
+
+/**
+ * sca3000_read_av_freq() sysfs function to get available frequencies
+ *
+ * The later modes are only relevant to the ring buffer - and depend on current
+ * mode. Note that data sheet gives rather wide tolerances for these so integer
+ * division will give good enough answer and not all chips have them specified
+ * at all.
+ **/
+static ssize_t sca3000_read_av_freq(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int len = 0, ret;
+	u8 *rx;
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	mutex_unlock(&st->lock);
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
+/**
+ * __sca3000_get_base_frequency() obtain mode specific base frequency
+ *
+ * lock must be held
+ **/
+static inline int __sca3000_get_base_freq(struct device *dev,
+					  const struct sca3000_chip_info *info,
+					  int *base_freq)
+{
+	int ret;
+	u8 *rx;
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	switch (0x03 & rx[1]) {
+	case SCA3000_MEAS_MODE_NORMAL:
+		*base_freq = info->measurement_mode_freq;
+		break;
+	case SCA3000_MEAS_MODE_OP_1:
+		*base_freq = info->option_mode_1_freq;
+		break;
+	case SCA3000_MEAS_MODE_OP_2:
+		*base_freq = info->option_mode_2_freq;
+		break;
+	};
+	kfree(rx);
+error_ret:
+	return ret;
+}
+/**
+ * sca3000_read_frequency() sysfs interface to get the current frequency
+ **/
+static ssize_t sca3000_read_frequency(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret, len = 0, base_freq = 0;
+	u8 *rx;
+	mutex_lock(&st->lock);
+	ret = __sca3000_get_base_freq(dev, st->info, &base_freq);
+	if (ret)
+		goto error_ret_mut;
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
+error_ret_mut:
+	mutex_unlock(&st->lock);
+error_ret:
+	return ret;
+}
+/**
+ * sca3000_set_frequency() sysfs interface to set the current frequency
+ **/
+static ssize_t sca3000_set_frequency(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf,
+			      size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret, base_freq = 0;
+	u8 *rx;
+	long val;
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&st->lock);
+	/* What mode are we in? */
+	ret = __sca3000_get_base_freq(dev, st->info, &base_freq);
+	if (ret)
+		goto error_free_lock;
+
+	ret = sca3000_read_ctrl_reg(dev, SCA3000_REG_CTRL_SEL_OUT_CTRL, &rx);
+	if (ret)
+		goto error_free_lock;
+	/* clear the bits */
+	rx[1] &= ~0x03;
+
+	if (val == base_freq/2) {
+		rx[1] |= SCA3000_OUT_CTRL_BUF_DIV_2;
+	} else if (val == base_freq/4) {
+		rx[1] |= SCA3000_OUT_CTRL_BUF_DIV_4;
+	} else if (val != base_freq) {
+		ret = -EINVAL;
+		goto error_free_lock;
+	}
+	ret = sca3000_write_ctrl_reg(dev, SCA3000_REG_CTRL_SEL_OUT_CTRL, rx[1]);
+error_free_lock:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+
+/* Should only really be registered if ring buffer support is compiled in.
+ * Does no harm however and doing in right would add a fair bit of complexity
+ */
+static IIO_DEV_ATTR_AVAIL_SAMP_FREQ(sca3000_read_av_freq);
+
+static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
+			      sca3000_read_frequency,
+			      sca3000_set_frequency);
+
+
+/**
+ * sca3000_read_temp() sysfs interface to get the temperature when available
+ *
+* The alignment of data in here is downright odd. See data sheet.
+* Converting this into a meaningful value is left to inline functions in
+* userspace part of header.
+**/
+static ssize_t sca3000_read_temp(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	int len = 0, ret;
+	int val;
+	u8 *rx;
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
+/* FIXME - move to ring funcs */
+static IIO_CONST_ATTR(ring_bps_available, "8, 11\n");
+
+/**
+ * sca3000_show_ring_bps() sysfs function to query bits per sample from ring
+ **/
+static ssize_t sca3000_show_ring_bps(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	int len= 0, ret;
+	u8 *rx;
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	len = sprintf(buf, "%d\n", (rx[1] & SCA3000_RING_BUF_8BIT) ? 8: 11);
+	kfree(rx);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+/**
+ * sca3000_store_ring_bps() sysfs functio to store bits per sample form ring
+ **/
+static ssize_t sca3000_store_ring_bps(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	u8 *rx;
+	long val;
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&st->lock);
+
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (!ret)
+		switch (val) {
+		case 8:
+			ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+						rx[1] | SCA3000_RING_BUF_8BIT);
+			st->bps = 8;
+			break;
+		case 11:
+			ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+						rx[1] & ~SCA3000_RING_BUF_8BIT);
+			st->bps = 11;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+
+static IIO_DEV_ATTR_RING_BPS(S_IRUGO | S_IWUSR,
+			     sca3000_show_ring_bps,
+			     sca3000_store_ring_bps);
+/**
+ * sca3000_show_thresh() sysfs query of a theshold
+ **/
+static ssize_t sca3000_show_thresh(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int len = 0, ret;
+	u8 *rx;
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_ctrl_reg(dev,
+				    this_attr->address,
+				    &rx);
+	mutex_unlock(&st->lock);
+	if (ret)
+		return ret;
+	len += sprintf(buf + len, "%d\n", rx[1]);
+	kfree(rx);
+
+	return len;
+}
+
+/**
+ * sca3000_write_thresh() sysfs control of threshold
+ **/
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
+
+	return ret ? ret : len;
+}
+
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
+/*
+ * fixme, cleaner and readable way of handling these two subtly different tables?
+ * RFC
+ */
+static struct attribute *sca3000_attributes[] = {
+	&iio_dev_attr_revision.dev_attr.attr,
+	&iio_dev_attr_accel_x.dev_attr.attr,
+	&iio_dev_attr_accel_y.dev_attr.attr,
+	&iio_dev_attr_accel_z.dev_attr.attr,
+	&iio_dev_attr_thresh_accel_x.dev_attr.attr,
+	&iio_dev_attr_thresh_accel_y.dev_attr.attr,
+	&iio_dev_attr_thresh_accel_z.dev_attr.attr,
+	&iio_dev_attr_available_measurement_modes.dev_attr.attr,
+	&iio_dev_attr_measurement_mode.dev_attr.attr,
+	&iio_dev_attr_ring_bps.dev_attr.attr,
+	&iio_const_attr_ring_bps_available.dev_attr.attr,
+	&iio_dev_attr_available_sampling_frequency.dev_attr.attr,
+	&iio_dev_attr_sampling_frequency.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute *sca3000_attributes_with_temp[] = {
+	&iio_dev_attr_revision.dev_attr.attr,
+	&iio_dev_attr_accel_x.dev_attr.attr,
+	&iio_dev_attr_accel_y.dev_attr.attr,
+	&iio_dev_attr_accel_z.dev_attr.attr,
+	&iio_dev_attr_thresh_accel_x.dev_attr.attr,
+	&iio_dev_attr_thresh_accel_y.dev_attr.attr,
+	&iio_dev_attr_thresh_accel_z.dev_attr.attr,
+	&iio_dev_attr_available_measurement_modes.dev_attr.attr,
+	&iio_dev_attr_measurement_mode.dev_attr.attr,
+	&iio_dev_attr_ring_bps.dev_attr.attr,
+	&iio_const_attr_ring_bps_available.dev_attr.attr,
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
+/* RING RELATED interrupt handler */
+/* depending on event, push to the ring buffer event chrdev or the event one */
+
+/**
+ * sca3000_interrupt_handler_bh() - handling ring and non ring events
+ *
+ * This function is complicated by the fact that the devices can signify ring
+ * and non ring events via the same interrupt line and they can only
+ * be distinguished via a read of the relevant status register.
+ **/
+static void sca3000_interrupt_handler_bh(struct work_struct *work_s)
+{
+	struct sca3000_state *st
+		= container_of(work_s, struct sca3000_state,
+			       interrupt_handler_ws);
+	struct spi_device *spi_dev  = to_spi_device(st->indio_dev->dev);
+	u8 *rx;
+	int ret;
+
+	/* Could lead if badly timed to an extra read of status reg,
+	 * but ensures no interrupt is missed.
+	 */
+	enable_irq(spi_dev->irq);
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(&spi_dev->dev, SCA3000_REG_ADDR_INT_STATUS,
+				&rx, 1);
+	mutex_unlock(&st->lock);
+	if (ret)
+		goto done;
+
+	sca3000_ring_int_process(rx[1], st->indio_dev->ring);
+
+	if (rx[1] & SCA3000_INT_STATUS_FREE_FALL)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_FREE_FALL,
+			       st->last_timestamp);
+
+	if (rx[1] & SCA3000_INT_STATUS_Y_TRIGGER)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_Y_HIGH,
+			       st->last_timestamp);
+
+	if (rx[1] & SCA3000_INT_STATUS_X_TRIGGER)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_X_HIGH,
+			       st->last_timestamp);
+
+	if (rx[1] & SCA3000_INT_STATUS_Z_TRIGGER)
+		iio_push_event(st->indio_dev, 0,
+			       IIO_EVENT_CODE_ACCEL_Z_HIGH,
+			       st->last_timestamp);
+
+done:
+	kfree(rx);
+	return;
+}
+
+/**
+ * sca3000_handler_th() handles all interrupt events from device
+ *
+ * These devices deploy unified interrupt status registers meaning
+ * all interrupts must be handled together
+ **/
+static int sca3000_handler_th(struct iio_dev *dev_info,
+			      int index,
+			      s64 timestamp,
+			      int no_test)
+{
+	struct sca3000_state *st = dev_info->dev_data;
+	st->last_timestamp = timestamp;
+	schedule_work(&st->interrupt_handler_ws);
+	return 0;
+}
+
+/**
+ * sca3000_query_mo_det() is motion detection enabled for this axis
+ *
+ * First queries if motion detection is enabled and then if this axis is
+ * on.
+ **/
+static ssize_t sca3000_query_mo_det(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	int ret, len = 0;
+	u8 *rx;
+	u8 protect_mask = 0x03;
+
+	/* read current value of mode register */
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
+		len += sprintf(buf + len, "%d\n",
+			       (rx[1] & this_attr->mask) ? 1 : 0);
+	}
+	kfree(rx);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+/**
+ * sca3000_query_free_fall_mode() is free fall mode enabled
+ **/
+static ssize_t sca3000_query_free_fall_mode(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	int ret, len;
+	u8 *rx;
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	mutex_unlock(&st->lock);
+	if (ret)
+		return ret;
+	len = sprintf(buf, "%d\n",
+		      !!(rx[1] & SCA3000_FREE_FALL_DETECT));
+	kfree(rx);
+
+	return len;
+}
+/**
+ * sca3000_query_ring_int() is the hardware ring status interrupt enabled
+ **/
+static ssize_t sca3000_query_ring_int(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	int ret, len;
+	u8 *rx;
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_INT_MASK, &rx, 1);
+	mutex_unlock(&st->lock);
+	if (ret)
+		return ret;
+	len = sprintf(buf, "%d\n", (rx[1] & this_attr->mask) ? 1 : 0);
+	kfree(rx);
+
+	return len;
+}
+/**
+ * sca3000_set_ring_int() set state of ring status interrupt
+ **/
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
+	u8 *rx;
+
+	mutex_lock(&st->lock);
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_INT_MASK, &rx, 1);
+	if (ret)
+		goto error_ret;
+	if (val)
+		ret = sca3000_write_reg(dev,
+					SCA3000_REG_ADDR_INT_MASK,
+					rx[1] | this_attr->mask);
+	else
+		ret = sca3000_write_reg(dev,
+					SCA3000_REG_ADDR_INT_MASK,
+					rx[1] & ~this_attr->mask);
+	kfree(rx);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+
+/**
+ * sca3000_set_free_fall_mode() simple on off control for free fall int
+ *
+ * In these chips the free fall detector should send an interrupt if
+ * the device falls more than 25cm.  This has not been tested due
+ * to fragile wiring.
+ **/
+
+static ssize_t sca3000_set_free_fall_mode(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf,
+					  size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	long val;
+	int ret;
+	u8 *rx;
+	u8 protect_mask = SCA3000_FREE_FALL_DETECT;
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
+	if (val && !(rx[1] & protect_mask))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1] | SCA3000_FREE_FALL_DETECT));
+	/* if on and should be off */
+	else if (!val && (rx[1]&protect_mask))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1] & ~protect_mask));
+
+	kfree(rx);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+
+}
+
+/**
+ * sca3000_set_mo_det() simple on off control for motion detector
+ *
+ * This is a per axis control, but enabling any will result in the
+ * motion detector unit being enabled.
+ * N.B. enabling motion detector stops normal data acquisition.
+ * There is a complexity in knowing which mode to return to when
+ * this mode is disabled.  Currently normal mode is assumed.
+ **/
+static ssize_t sca3000_set_mo_det(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t len)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	long val;
+	int ret;
+	u8 *rx;
+	u8 protect_mask = 0x03;
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&st->lock);
+	/* First read the motion detector config to find out if
+	 * this axis is on*/
+	ret = sca3000_read_ctrl_reg(dev,
+				    SCA3000_REG_CTRL_SEL_MD_CTRL,
+				    &rx);
+	if (ret)
+		goto exit_point;
+	/* Off and should be on */
+	if (val && !(rx[1] & this_attr->mask)) {
+		ret = sca3000_write_ctrl_reg(dev,
+					     SCA3000_REG_CTRL_SEL_MD_CTRL,
+					     rx[1] | this_attr->mask);
+		if (ret)
+			goto exit_point_free_rx;
+		st->mo_det_use_count++;
+	} else if (!val && (rx[1]&this_attr->mask)) {
+		ret = sca3000_write_ctrl_reg(dev,
+					     SCA3000_REG_CTRL_SEL_MD_CTRL,
+					     rx[1] & ~(this_attr->mask));
+		if (ret)
+			goto exit_point_free_rx;
+		st->mo_det_use_count--;
+	} else /* relies on clean state for device on boot */
+		goto exit_point_free_rx;
+	kfree(rx);
+	/* read current value of mode register */
+	ret = sca3000_read_data(dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto exit_point;
+	/*if off and should be on*/
+	if ((st->mo_det_use_count)
+	    && ((rx[1]&protect_mask) != SCA3000_MEAS_MODE_MOT_DET))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1] & ~protect_mask)
+					| SCA3000_MEAS_MODE_MOT_DET);
+	/* if on and should be off */
+	else if (!(st->mo_det_use_count)
+		 && ((rx[1]&protect_mask) == SCA3000_MEAS_MODE_MOT_DET))
+		ret = sca3000_write_reg(dev, SCA3000_REG_ADDR_MODE,
+					(rx[1] & ~protect_mask));
+exit_point_free_rx:
+	kfree(rx);
+exit_point:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : len;
+}
+
+/* Shared event handler for all events as single event status register */
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
+	&iio_event_attr_accel_x_high.dev_attr.attr,
+	&iio_event_attr_accel_y_high.dev_attr.attr,
+	&iio_event_attr_accel_z_high.dev_attr.attr,
+	&iio_event_attr_ring_50_full.dev_attr.attr,
+	&iio_event_attr_ring_75_full.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group sca3000_event_attribute_group = {
+	.attrs = sca3000_event_attributes,
+};
+
+/**
+ * sca3000_clean_setup() get the device into a predictable state
+ *
+ * Devices use flash memory to store many of the register values
+ * and hence can come up in somewhat unpredictable states.
+ * Hence reset everything on driver load.
+  **/
+static int sca3000_clean_setup(struct device *dev)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	u8 *rx;
+
+	mutex_lock(&st->lock);
+	/* Ensure all interrupts have been acknowledged */
+	ret = sca3000_read_data(dev,
+				SCA3000_REG_ADDR_INT_STATUS, &rx, 1);
+	if (ret)
+		goto error_ret;
+	kfree(rx);
+
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
+static int __devinit __sca3000_probe(struct spi_device *spi,
+				     enum sca3000_variant variant)
+{
+	int ret;
+	struct sca3000_state *st;
+
+	st = kzalloc(sizeof(struct sca3000_state), GFP_KERNEL);
+	if (st == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	st->us = spi;
+	mutex_init(&st->lock);
+	st->info = &sca3000_spi_chip_info_tbl[variant];
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
+	st->indio_dev->modes = INDIO_DIRECT_MODE;
+
+	sca3000_register_ring_access_and_init(st->indio_dev);
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
+		/* RFC
+		 * Probably a common situation.  All interrupts need an ack
+		 * and there is only one handler so the complicated list system
+		 * is overkill.  At very least a simpler registration method
+		 * might be worthwhile.
+		 */
+		ret = iio_add_event_to_list(iio_event_attr_accel_z_high.listel,
+					    &st->indio_dev
+					    ->interrupts[0]->ev_list);
+		if (ret < 0)
+			goto error_unregister_interrupt_line;
+	}
+	sca3000_register_ring_funcs(st->indio_dev);
+
+	ret = sca3000_clean_setup(&spi->dev);
+	if (ret)
+		goto error_unregister_interrupt_line;
+	return 0;
+
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
+
+static int sca3000_stop_all_interrupts(struct device *dev)
+{
+	struct sca3000_state *st = sca3000_state_from_dev(dev);
+	int ret;
+	u8 *rx;
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
+
+static int sca3000_remove(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+	struct sca3000_state *st = indio_dev->dev_data;
+	int ret;
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
+
+/* These macros save on an awful lot of repeated code */
+#define SCA3000_VARIANT_PROBE(_name)				\
+	static int __devinit					\
+	sca3000_##_name##_probe(struct spi_device *spi)		\
+	{							\
+		return __sca3000_probe(spi, _name);		\
+	}
+#define SCA3000_VARIANT_DRIVER(_name)				\
+	SCA3000_VARIANT_PROBE(_name);				\
+	static struct spi_driver sca3000_##_name##_driver = {	\
+		.driver = {					\
+			.name = "sca3000_##_name##",		\
+			.owner = THIS_MODULE,			\
+		},						\
+		.probe = sca3000_##_name##_probe,		\
+		.remove = __devexit_p(sca3000_remove),		\
+	};
+
+SCA3000_VARIANT_DRIVER(d01);
+SCA3000_VARIANT_DRIVER(d03);
+SCA3000_VARIANT_DRIVER(e02);
+SCA3000_VARIANT_DRIVER(e04);
+SCA3000_VARIANT_DRIVER(e05);
+SCA3000_VARIANT_DRIVER(l01);
+
+static __init int sca3000_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&sca3000_d01_driver);
+	if (ret)
+		goto error_ret;
+	ret = spi_register_driver(&sca3000_d03_driver);
+	if (ret)
+		goto error_unreg_d01;
+	ret = spi_register_driver(&sca3000_e02_driver);
+	if (ret)
+		goto error_unreg_d03;
+	ret = spi_register_driver(&sca3000_e04_driver);
+	if (ret)
+		goto error_unreg_e02;
+	ret = spi_register_driver(&sca3000_e05_driver);
+	if (ret)
+		goto error_unreg_e04;
+	ret = spi_register_driver(&sca3000_l01_driver);
+	if (ret)
+		goto error_unreg_e05;
+
+	return 0;
+
+error_unreg_e05:
+	spi_unregister_driver(&sca3000_e05_driver);
+error_unreg_e04:
+	spi_unregister_driver(&sca3000_e04_driver);
+error_unreg_e02:
+	spi_unregister_driver(&sca3000_e02_driver);
+error_unreg_d03:
+	spi_unregister_driver(&sca3000_d03_driver);
+error_unreg_d01:
+	spi_unregister_driver(&sca3000_d01_driver);
+error_ret:
+
+	return ret;
+}
+
+static __exit void sca3000_exit(void)
+{
+	spi_unregister_driver(&sca3000_l01_driver);
+	spi_unregister_driver(&sca3000_e05_driver);
+	spi_unregister_driver(&sca3000_e04_driver);
+	spi_unregister_driver(&sca3000_e02_driver);
+	spi_unregister_driver(&sca3000_d03_driver);
+	spi_unregister_driver(&sca3000_d01_driver);
+}
+
+module_init(sca3000_init);
+module_exit(sca3000_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("VTI SCA3000 Series Accelerometers SPI driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/industrialio/accelerometer/sca3000_ring.c b/drivers/industrialio/accelerometer/sca3000_ring.c
new file mode 100644
index 0000000..cedeaba
--- /dev/null
+++ b/drivers/industrialio/accelerometer/sca3000_ring.c
@@ -0,0 +1,196 @@
+
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/sysfs.h>
+#include <linux/rtc.h>
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/sysfs.h>
+#include <linux/industrialio/accel.h>
+/* Shared kernel / userspace conversion functions */
+#include <linux/industrialio/sca3000.h>
+#include <linux/industrialio/ring_hw.h>
+/* Local stuff such as register locations */
+#include "sca3000.h"
+
+/* RFC / future work
+ *
+ * The internal ring buffer doesn't actually change what it holds depending
+ * on which signals are enabled etc, merely whether you can read them.
+ * As such the scan mode selection is somewhat different than for a software
+ * ring buffer and changing it actually covers any data already in the buffer.
+ * Currently scan elements aren't configured so it doesn't matter.
+ */
+
+/**
+ * sca3000_rip_hw_rb() main ring access function, attempts to pull data from ring
+ * @r:			the ring
+ * @count:		number of samples to try and pull
+ * @data:		output the actual samples pulled from the hw ring
+ * @dead_offset:	cheating a bit here: Set to 1 so as to allow for the
+ *			leading byte used in bus comms.
+ *
+ * Currently does not provide timestamps.  As the hardware doesn't add them they
+ * can only be inferred aproximately from ring buffer events such as 50% full and
+ * knowledge of when buffer was last emptied.  This is left to userspace.
+ **/
+static int sca3000_rip_hw_rb(void *r, size_t count, u8 **data, int *dead_offset)
+{
+	struct iio_hw_ring_buffer *hw_ring = r;
+	struct iio_dev *indio_dev = hw_ring->private;
+	struct sca3000_state *st = indio_dev->dev_data;
+	u8 *rx;
+	int ret, num_available, num_read = 0;
+	int bytes_per_sample = 1;
+
+	if (st->bps == 11)
+		bytes_per_sample = 2;
+
+	mutex_lock(&st->lock);
+	/* Check how much data is available:
+	 * RFC: Implement an ioctl to not bother checking whether there
+	 * is enough data in the ring?  Afterall, if we are responding
+	 * to an interrupt we have a minimum content guaranteed so it
+	 * seems slight silly to waste time checking it is there.
+	 */
+	ret = sca3000_read_data(st->indio_dev->dev,
+				SCA3000_REG_ADDR_BUF_COUNT,
+				&rx, 1);
+	if (ret)
+		goto error_ret;
+	else
+		num_available = rx[1];
+	/* num_available is the total number of samples available
+	 * i.e. number of time points * number of channels.
+	 */
+	kfree(rx);
+	if (count > num_available * bytes_per_sample)
+		num_read = num_available*bytes_per_sample;
+	else
+		num_read = count - (count % (bytes_per_sample));
+
+	*dead_offset = 1;
+	ret = sca3000_read_data(st->indio_dev->dev,
+				SCA3000_REG_ADDR_RING_OUT,
+				data, num_read);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret ? ret : num_read;
+}
+
+/**
+ * sca3000_create_ring_buffer() creates the appropriate ring buffer
+ **/
+static int sca3000_create_ring_buffer(void **r)
+{
+	*r = kzalloc(sizeof(struct iio_hw_ring_buffer),
+		     GFP_KERNEL);
+	if (*r == 0)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * sca3000_init_ring_buffer() minimal amount of init for hw ring buffer
+ **/
+static int sca3000_init_ring_buffer(void *r, void *iio_dev)
+{
+	struct iio_hw_ring_buffer *ring = r;
+
+	ring->private = iio_dev;
+
+	return 0;
+}
+
+static void sca3000_free_ring_buffer(void *r)
+{
+	kfree(r);
+}
+
+/**
+ * sca3000_register_ring_access_and_init() notify iio core of ring funcs
+ *
+ * The hardware ring buffer only needs far fewer ring buffer functions than
+ * a software one as a lot of things are handled automatically.
+ * This function also tells the iio core that our device supports a
+ * hardware ring buffer mode.
+ **/
+int sca3000_register_ring_access_and_init(struct iio_dev *indio_dev)
+{
+	struct iio_ring_access_funcs *ra = &indio_dev->ring_access;
+	indio_dev->modes |= INDIO_RING_HARDWARE_BUFFER;
+	ra->_create = &sca3000_create_ring_buffer;
+	ra->_free = &sca3000_free_ring_buffer;
+	ra->_init = &sca3000_init_ring_buffer;
+
+	ra->rip_lots = &sca3000_rip_hw_rb;
+	return 0;
+}
+
+static inline
+int __sca3000_hw_ring_state_set(struct iio_dev *indio_dev, bool state)
+{
+	struct sca3000_state *st = indio_dev->dev_data;
+	int ret;
+	u8 *rx;
+
+	mutex_lock(&st->lock);
+	ret = sca3000_read_data(indio_dev->dev, SCA3000_REG_ADDR_MODE, &rx, 1);
+	if (ret)
+		goto error_ret;
+	if (state)
+		ret = sca3000_write_reg(indio_dev->dev,
+					SCA3000_REG_ADDR_MODE,
+					(rx[1] | SCA3000_RING_BUF_ENABLE));
+	else
+		ret = sca3000_write_reg(indio_dev->dev,
+					SCA3000_REG_ADDR_MODE,
+					(rx[1] & ~SCA3000_RING_BUF_ENABLE));
+	kfree(rx);
+error_ret:
+	mutex_unlock(&st->lock);
+
+	return ret;
+}
+/**
+ * sca3000_hw_ring_preenable() hw ring buffer preenable function
+ *
+ * Very simple enable function as the chip will allows normal reads
+ * during ring buffer operation so as long as it is indeed running
+ * before we notify the core, the precise ordering does not matter.
+ **/
+static int sca3000_hw_ring_preenable(struct iio_dev *indio_dev)
+{
+	return __sca3000_hw_ring_state_set(indio_dev, 1);
+}
+
+static int sca3000_hw_ring_postdisable(struct iio_dev *indio_dev)
+{
+	return __sca3000_hw_ring_state_set(indio_dev, 0);
+}
+
+void sca3000_register_ring_funcs(struct iio_dev *indio_dev)
+{
+	indio_dev->ring_preenable = &sca3000_hw_ring_preenable;
+	indio_dev->ring_postdisable = &sca3000_hw_ring_postdisable;
+}
+
+/**
+ * sca3000_ring_int_process() ring specific interrupt handling.
+ *
+ * This is only split from the main interrupt handler so as to
+ * reduce the amount of code if the ring buffer is not enabled.
+ **/
+void sca3000_ring_int_process(u8 val, void *ring)
+{
+	if (val & SCA3000_INT_STATUS_THREE_QUARTERS)
+		iio_push_or_escallate_ring_event(ring,
+						 IIO_EVENT_CODE_RING_75_FULL, 0);
+	else if (val & SCA3000_INT_STATUS_HALF)
+		iio_push_ring_event(ring,
+				    IIO_EVENT_CODE_RING_50_FULL, 0);
+}
diff --git a/include/linux/industrialio/ring_hw.h b/include/linux/industrialio/ring_hw.h
new file mode 100644
index 0000000..93b0cae
--- /dev/null
+++ b/include/linux/industrialio/ring_hw.h
@@ -0,0 +1,9 @@
+/**
+ * struct iio_hw_ring_buffer- hardware ring buffer
+ * @buf:	generic ring buffer elements
+ * @private:	device specific data
+ */
+struct iio_hw_ring_buffer {
+	struct iio_ring_buffer buf;
+	void *private;
+};
diff --git a/include/linux/industrialio/sca3000.h b/include/linux/industrialio/sca3000.h
new file mode 100644
index 0000000..a07c70d
--- /dev/null
+++ b/include/linux/industrialio/sca3000.h
@@ -0,0 +1,36 @@
+/*
+ * sca3000.h -- conversion functions related to VTI sca3000 series accelerometers
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Copyright (c) 2007 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ */
+
+#ifndef _SCA3000_H_USER_
+#define _SCA3000_H_USER_
+
+/* Conversion function for use with the ring buffer when in 11bit mode */
+static inline int sca3000_11bit_convert(uint8_t msb, uint8_t lsb)
+{
+	int16_t val;
+
+	val = ((lsb >> 3) & 0x1C) | (msb << 5);
+	val |= (val & (1 << 12)) ? 0xE000 : 0;
+
+	return val;
+};
+
+static inline int sca3000_13bit_convert(uint8_t msb, uint8_t lsb)
+{
+	s16 val;
+
+	val = ((lsb >> 3) & 0x1F) | (msb << 5);
+	/* sign fill */
+	val |= (val & (1 << 12)) ? 0xE000 : 0;
+
+	return val;
+}
+#endif /* _SCA3000_H_USER_ */
