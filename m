Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYLAOdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYLAOdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYLAOdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:33:40 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:35872 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYLAOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:33:38 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F5BE.3080900@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:33:34 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [7/13] RFC: Maxim MAX1363 driver
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
From: Jonathan Cameron <jic23@cam.ac.uk>

IIO: Maxim MAX1363 driver
Also supports max1361, max1362, max1364, max1136, max1136,
max1137, max1138, max1139, max1236, max1237, max11238, max1239

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--
This patch provides the core functionality (sysfs control 
and direct device scanning, chrdev event interface).

It illustrates one common form of scan mode configuration
found in numerous similar devices.  A restricted set of
combinations of elements are possible via a set of predefined
scan modes.  How to handle this in a consistent way alongside
devices such as the lis3l02dq accelerometer (any combinations
of channels possible) is very much a question for discussion.

 drivers/industrialio/Kconfig            |    4 +-
 drivers/industrialio/Makefile           |    3 +-
 drivers/industrialio/adc/Kconfig        |   13 +
 drivers/industrialio/adc/Makefile       |    7 +
 drivers/industrialio/adc/max1363.h      |  250 +++++++++++++
 drivers/industrialio/adc/max1363_core.c |  599 +++++++++++++++++++++++++++++++
 6 files changed, 874 insertions(+), 2 deletions(-)

diff --git a/drivers/industrialio/Kconfig b/drivers/industrialio/Kconfig
index c20ca2f..f682fbf 100644
--- a/drivers/industrialio/Kconfig
+++ b/drivers/industrialio/Kconfig
@@ -36,4 +36,6 @@ config IIO_SW_RING
 	example software ring buffer implementation.  The design aim
 	of this particular realization was to minize write locking
 	with the intention that some devices would be able to write
-	in interrupt context.
\ No newline at end of file
+	in interrupt context.
+
+source drivers/industrialio/adc/Kconfig
\ No newline at end of file
diff --git a/drivers/industrialio/Makefile b/drivers/industrialio/Makefile
index 518849a..dd6d5ca 100644
--- a/drivers/industrialio/Makefile
+++ b/drivers/industrialio/Makefile
@@ -9,4 +9,5 @@ industrialio-$(CONFIG_IIO_TRIGGERS) += industrialio-trigger.o
 
 obj-$(CONFIG_IIO_SW_RING) += ring_sw.o
 
-obj-y += triggers/
\ No newline at end of file
+obj-y += triggers/
+obj-y += adc/
\ No newline at end of file
diff --git a/drivers/industrialio/adc/Kconfig b/drivers/industrialio/adc/Kconfig
new file mode 100644
index 0000000..203a5f9
--- /dev/null
+++ b/drivers/industrialio/adc/Kconfig
@@ -0,0 +1,13 @@
+#
+# ADC drivers
+#
+comment "Analog to digital convertors"
+	depends on INDUSTRIALIO
+config MAX1363
+	tristate "MAXIM max1363 ADC driver"
+	depends on INDUSTRIALIO
+	help
+	  Say yes here to build support for many MAXIM i2c analog to digital
+	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
+	  max1136, max1137, max1138, max1139, max1236, max1237, max11238,
+	  max1239) Provides direct access via sysfs.
diff --git a/drivers/industrialio/adc/Makefile b/drivers/industrialio/adc/Makefile
new file mode 100644
index 0000000..2a37fee
--- /dev/null
+++ b/drivers/industrialio/adc/Makefile
@@ -0,0 +1,7 @@
+
+# Makefile for industrial I/O ADC drivers
+#
+
+max1363-y := max1363_core.o
+
+obj-$(CONFIG_MAX1363) += max1363.o
diff --git a/drivers/industrialio/adc/max1363.h b/drivers/industrialio/adc/max1363.h
new file mode 100644
index 0000000..71e9577
--- /dev/null
+++ b/drivers/industrialio/adc/max1363.h
@@ -0,0 +1,250 @@
+#ifndef _MAX1363_H_
+#define  _MAX1363_H_
+
+#define MAX1363_SETUP_BYTE(a) ((a) | 0x80)
+
+/* There is a fair bit more defined here than currently
+ * used, but the intention is to support everything these
+ * chips do in the long run */
+
+/* see data sheets */
+/* max1363 and max1236, max1237, max1238, max1239 */
+#define MAX1363_SETUP_AIN3_IS_AIN3_REF_IS_VDD	0x00
+#define MAX1363_SETUP_AIN3_IS_REF_EXT_TO_REF	0x20
+#define MAX1363_SETUP_AIN3_IS_AIN3_REF_IS_INT	0x40
+#define MAX1363_SETUP_AIN3_IS_REF_REF_IS_INT	0x60
+#define MAX1363_SETUP_POWER_UP_INT_REF		0x10
+#define MAX1363_SETUP_POWER_DOWN_INT_REF	0x00
+
+
+#define MAX1363_SETUP_EXT_CLOCK			0x08
+#define MAX1363_SETUP_INT_CLOCK			0x00
+#define MAX1363_SETUP_UNIPOLAR			0x00
+#define MAX1363_SETUP_BIPOLAR			0x04
+#define MAX1363_SETUP_RESET			0x00
+#define MAX1363_SETUP_NORESET			0x02
+/* max1363 only - though don't care on others.
+ * For now monitor modes are not implemented as the relevant
+ * line is not connected on my test board.
+ * The definitions are here as I intend to add this soon.
+ */
+#define MAX1363_SETUP_MONITOR_SETUP		0x01
+
+/* Specific to the max1363 */
+#define MAX1363_MON_RESET_CHAN(a) (1 << ((a) + 4))
+#define MAX1363_MON_CONV_RATE_133ksps		0
+#define MAX1363_MON_CONV_RATE_66_5ksps		0x02
+#define MAX1363_MON_CONV_RATE_33_3ksps		0x04
+#define MAX1363_MON_CONV_RATE_16_6ksps		0x06
+#define MAX1363_MON_CONV_RATE_8_3ksps		0x08
+#define MAX1363_MON_CONV_RATE_4_2ksps		0x0A
+#define MAX1363_MON_CONV_RATE_2_0ksps		0x0C
+#define MAX1363_MON_CONV_RATE_1_0ksps		0x0E
+#define MAX1363_MON_INT_ENABLE			0x01
+
+/* defined for readability reasons */
+/* All chips */
+#define MAX1363_CONFIG_BYTE(a) ((a))
+
+#define MAX1363_CONFIG_SE			0x01
+#define MAX1363_CONFIG_DE			0x00
+#define MAX1363_CONFIG_SCAN_TO_CS		0x00
+#define MAX1363_CONFIG_SCAN_SINGLE_8		0x20
+#define MAX1363_CONFIG_SCAN_MONITOR_MODE	0x40
+#define MAX1363_CONFIG_SCAN_SINGLE_1		0x60
+/* max123{6-9} only */
+#define MAX1236_SCAN_MID_TO_CHANNEL		0x40
+
+/* max1363 only - merely part of channel selects or don't care for others*/
+#define MAX1363_CONFIG_EN_MON_MODE_READ 0x18
+
+#define MAX1363_CHANNEL_SEL(a) ((a) << 1)
+
+/* max1363 strictly 0x06 - but doesn't matter */
+#define MAX1363_CHANNEL_SEL_MASK		0x1E
+#define MAX1363_SCAN_MASK			0x60
+#define MAX1363_SE_DE_MASK			0x01
+
+/**
+ * struct max1363_mode - scan mode information
+ * @name:	Name used to identify the scan mode.
+ * @conf:	The corresponding value of the configuration register
+ * @numvals:	The number of values returned by a single scan
+ */
+struct max1363_mode {
+	const char	*name;
+	int8_t		conf;
+	int		numvals;
+};
+
+#define MAX1363_MODE_SINGLE(_num) {					\
+		.name = #_num,						\
+			.conf = MAX1363_CHANNEL_SEL(_num)		\
+			| MAX1363_CONFIG_SCAN_SINGLE_1			\
+			| MAX1363_CONFIG_SE,				\
+			.numvals = 1,					\
+			}
+
+#define MAX1363_MODE_SINGLE_TIMES_8(_num) {				\
+		.name = #_num"x8",					\
+			.conf = MAX1363_CHANNEL_SEL(_num)		\
+			| MAX1363_CONFIG_SCAN_SINGLE_8			\
+			| MAX1363_CONFIG_SE,				\
+			.numvals = 8,					\
+			}
+
+#define MAX1363_MODE_SCAN_TO_CHANNEL(_num) {				\
+		.name = "0..."#_num,					\
+			.conf = MAX1363_CHANNEL_SEL(_num)		\
+			| MAX1363_CONFIG_SCAN_TO_CS			\
+			| MAX1363_CONFIG_SE,				\
+			.numvals = _num + 1,				\
+			}
+
+
+/* note not available for max1363 hence naming */
+#define MAX1236_MODE_SCAN_MID_TO_CHANNEL(_mid, _num) {			\
+		.name = #_mid"..."#_num,				\
+			.conf =MAX1363_CHANNEL_SEL(_num)		\
+			| MAX1236_SCAN_MID_TO_CHANNEL			\
+			| MAX1363_CONFIG_SE,				\
+			.numvals = _num - _mid + 1			\
+}
+
+#define MAX1363_MODE_DIFF_SINGLE(_nump, _numm) {			\
+		.name = #_nump"-"#_numm,				\
+			.conf = MAX1363_CHANNEL_SEL(_nump)		\
+			| MAX1363_CONFIG_SCAN_SINGLE_1			\
+			| MAX1363_CONFIG_DE,				\
+			.numvals = 1,					\
+			}
+
+#define MAX1363_MODE_DIFF_SINGLE_TIMES_8(_nump, _numm) {		\
+		.name = #_nump"-"#_numm,				\
+			.conf = MAX1363_CHANNEL_SEL(_nump)		\
+			| MAX1363_CONFIG_SCAN_SINGLE_8			\
+			| MAX1363_CONFIG_DE,				\
+			.numvals = 1,					\
+			}
+
+/* Can't think how to automate naming so specify for now */
+#define MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(_name, _num, _numvals) { \
+		.name = #_name,						\
+			.conf = MAX1363_CHANNEL_SEL(_num)		\
+			| MAX1363_CONFIG_SCAN_TO_CS			\
+			| MAX1363_CONFIG_DE,				\
+			.numvals = _numvals,				\
+			}
+
+/* note only available for max1363 hence naming */
+#define MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(_name, _num, _numvals) { \
+    .name = #_name,							\
+			.conf =MAX1363_CHANNEL_SEL(_num)		\
+			| MAX1236_SCAN_MID_TO_CHANNEL			\
+			| MAX1363_CONFIG_SE,				\
+			.numvals = _numvals,				\
+}
+
+/* Not currently handled */
+#define MAX1363_MODE_MONITOR {					\
+		.name = "monitor",				\
+			.conf = MAX1363_CHANNEL_SEL(3)		\
+			| MAX1363_CONFIG_SCAN_MONITOR_MODE	\
+			| MAX1363_CONFIG_SE,			\
+			.numvals = 10,				\
+		}
+
+/* This may seem an overly long winded way to do this, but at least it makes
+ * clear what all the various options actually do. Alternative suggestions
+ * that don't require user to have intimate knowledge of the chip welcomed.
+ */
+
+/* This must be maintained along side the max1363_mode_table in max1363_core */
+enum max1363_modes {
+	/* Single read of a single channel */
+	_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11,
+	/* Eight reads of a single channel */
+	se0, se1, se2, se3, se4, se5, se6, se7, se8, se9, se10, se11,
+	/* Scan to channel */
+	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6,
+	s0to7, s0to8, s0to9, s0to10, s0to11,
+	/* Differential single read */
+	d0m1, d2m3, d4m5, d6m7, d8m9, d10m11,
+	d1m0, d3m2, d5m4, d7m6, d9m8, d11m10,
+	/* Differential single read 8 times */
+	de0m1, de2m3, de4m5, de6m7, de8m9, de10m11,
+	de1m0, de3m2, de5m4, de7m6, de9m8, de11m10,
+	/* Differential scan to channel */
+	d0m1to2m3, d0m1to4m5, d0m1to6m7, d0m1to8m9, d0m1to10m11,
+	d1m0to3m2, d1m0to5m4, d1m0to7m6, d1m0to9m8, d1m0to11m10,
+	/* Scan mid to channel max123{6-9} only */
+	s2to3, s6to7, s6to8, s6to9, s6to10, s6to11,
+	/* Differential scan mid to channel */
+	s6m7to8m9, s6m7to10m11, s7m6to9m8, s7m6to11m10,
+};
+
+/**
+ * struct max1363_chip_info - chip specifc information
+ * @name:		indentification string for chip
+ * @num_inputs:		number of physical inputs on chip
+ * @int_vref_mv:	the internal reference voltage
+ * @monitor_mode:	whether the chip supports monitor interrupts
+ * @mode_list:		array of available scan modes
+ * @num_modes:		the number of scan modes available
+ * @default_mode:	the scan mode in which the chip starts up
+ */
+struct max1363_chip_info {
+	const char			*name;
+	u8				num_inputs;
+	u16				int_vref_mv;
+	bool				monitor_mode;
+	const enum max1363_modes	*mode_list;
+	int				num_modes;
+	enum max1363_modes		default_mode;
+};
+
+
+/**
+ * struct max1363_data - driver instance specific data
+ * @indio_dev:		the industrial I/O device
+ * @client:		i2c_client
+ * @setupbyte:		cache of current device setup byte
+ * @configbyte:		cache of current device config byte
+ * @chip_info:		chip model specific constants, available modes etc
+ * @current_mode:	the scan mode of this chip
+ * @poll_work:		bottom half of polling interrupt handler
+ * @protect_ring:	used to ensure only one polling bh running at a time
+ */
+struct max1363_data {
+	struct iio_dev			*indio_dev;
+	struct i2c_client		*client;
+	char				setupbyte;
+	char				configbyte;
+	const struct max1363_chip_info	*chip_info;
+	const struct max1363_mode	*current_mode;
+	struct work_struct		poll_work;
+	atomic_t			protect_ring;
+	struct iio_trigger		*trig;
+};
+
+#ifdef CONFIG_MAX1363_RING
+#else /* CONFIG_MAX1363_RING */
+
+static inline ssize_t max1363_scan_from_ring(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+  return 0;
+};
+
+static inline int
+max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev)
+{
+	return 0;
+};
+
+static inline void max1363_ring_cleanup(struct iio_dev *indio_dev) {};
+
+#endif /* CONFIG_MAX1363_RING */
+
+#endif /* _MAX1363_H_ */
diff --git a/drivers/industrialio/adc/max1363_core.c b/drivers/industrialio/adc/max1363_core.c
new file mode 100644
index 0000000..f83e948
--- /dev/null
+++ b/drivers/industrialio/adc/max1363_core.c
@@ -0,0 +1,599 @@
+ /*
+ * linux/drivers/industrialio/adc/max1363.c
+ * Copyright (C) 2008 Jonathan Cameron
+ *
+ * based on linux/drivers/i2c/chips/max123x
+ * Copyright (C) 2002-2004 Stefan Eletzhofer
+ *
+ * based on linux/drivers/acron/char/pcf8583.c
+ * Copyright (C) 2000 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * max1363.c
+ *
+ * Partial support for max1363 and similar chips.
+ *
+ * Not currently implemented.
+ *
+ * - Monitor interrrupt generation.
+ * - Control of internal reference.
+ * - Sysfs scan interface currently assumes unipolar mode.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/workqueue.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/sysfs.h>
+#include <linux/list.h>
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/sysfs.h>
+
+#include "max1363.h"
+
+/* Available scan modes.
+ * Awkwardly the associated enum is in the header so it is available to
+ * the ring buffer code.
+ */
+static const struct  max1363_mode max1363_mode_table[] = {
+	MAX1363_MODE_SINGLE(0),
+	MAX1363_MODE_SINGLE(1),
+	MAX1363_MODE_SINGLE(2),
+	MAX1363_MODE_SINGLE(3),
+	MAX1363_MODE_SINGLE(4),
+	MAX1363_MODE_SINGLE(5),
+	MAX1363_MODE_SINGLE(6),
+	MAX1363_MODE_SINGLE(7),
+	MAX1363_MODE_SINGLE(8),
+	MAX1363_MODE_SINGLE(9),
+	MAX1363_MODE_SINGLE(10),
+	MAX1363_MODE_SINGLE(11),
+
+	MAX1363_MODE_SINGLE_TIMES_8(0),
+	MAX1363_MODE_SINGLE_TIMES_8(1),
+	MAX1363_MODE_SINGLE_TIMES_8(2),
+	MAX1363_MODE_SINGLE_TIMES_8(3),
+	MAX1363_MODE_SINGLE_TIMES_8(4),
+	MAX1363_MODE_SINGLE_TIMES_8(5),
+	MAX1363_MODE_SINGLE_TIMES_8(6),
+	MAX1363_MODE_SINGLE_TIMES_8(7),
+	MAX1363_MODE_SINGLE_TIMES_8(8),
+	MAX1363_MODE_SINGLE_TIMES_8(9),
+	MAX1363_MODE_SINGLE_TIMES_8(10),
+	MAX1363_MODE_SINGLE_TIMES_8(11),
+
+	MAX1363_MODE_SCAN_TO_CHANNEL(1),
+	MAX1363_MODE_SCAN_TO_CHANNEL(2),
+	MAX1363_MODE_SCAN_TO_CHANNEL(3),
+	MAX1363_MODE_SCAN_TO_CHANNEL(4),
+	MAX1363_MODE_SCAN_TO_CHANNEL(5),
+	MAX1363_MODE_SCAN_TO_CHANNEL(6),
+	MAX1363_MODE_SCAN_TO_CHANNEL(7),
+	MAX1363_MODE_SCAN_TO_CHANNEL(8),
+	MAX1363_MODE_SCAN_TO_CHANNEL(9),
+	MAX1363_MODE_SCAN_TO_CHANNEL(10),
+	MAX1363_MODE_SCAN_TO_CHANNEL(11),
+
+	MAX1363_MODE_DIFF_SINGLE(0, 1),
+	MAX1363_MODE_DIFF_SINGLE(2, 3),
+	MAX1363_MODE_DIFF_SINGLE(4, 5),
+	MAX1363_MODE_DIFF_SINGLE(6, 7),
+	MAX1363_MODE_DIFF_SINGLE(8, 9),
+	MAX1363_MODE_DIFF_SINGLE(10, 11),
+	MAX1363_MODE_DIFF_SINGLE(1, 0),
+	MAX1363_MODE_DIFF_SINGLE(3, 2),
+	MAX1363_MODE_DIFF_SINGLE(5, 4),
+	MAX1363_MODE_DIFF_SINGLE(7, 6),
+	MAX1363_MODE_DIFF_SINGLE(9, 8),
+	MAX1363_MODE_DIFF_SINGLE(11, 10),
+
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(0, 1),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(2, 3),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(4, 5),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(6, 7),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(8, 9),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(10, 11),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(1, 0),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(3, 2),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(5, 4),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(7, 6),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(9, 8),
+	MAX1363_MODE_DIFF_SINGLE_TIMES_8(11, 10),
+
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...2-3, 2, 2),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...4-5, 4, 3),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...6-7, 6, 4),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...8-9, 8, 5),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(0-1...10-11, 10, 6),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...3-2, 3, 2),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...5-4, 5, 3),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...7-6, 7, 4),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...9-8, 9, 5),
+	MAX1363_MODE_DIFF_SCAN_TO_CHANNEL_NAMED(1-0...11-10, 11, 6),
+
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(2, 3),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 7),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 8),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 9),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 10),
+	MAX1236_MODE_SCAN_MID_TO_CHANNEL(6, 11),
+
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(6-7...8-9, 8, 2),
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(6-7...10-11, 10, 3),
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(7-6...9-8, 9, 2),
+	MAX1236_MODE_DIFF_SCAN_MID_TO_CHANNEL_NAMED(7-6...11-10, 11, 3),
+};
+
+/* Applies to max1363 */
+static const enum max1363_modes max1363_mode_list[] = {
+	_s0, _s1, _s2, _s3,
+	se0, se1, se2, se3,
+	s0to1, s0to2, s0to3,
+	d0m1, d2m3, d1m0, d3m2,
+	de0m1, de2m3, de1m0, de3m2,
+	d0m1to2m3, d1m0to3m2,
+};
+
+/* Appies to max1236, max1237 */
+static const enum max1363_modes max1236_mode_list[] = {
+	_s0, _s1, _s2, _s3,
+	se0, se1, se2, se3,
+	s0to1, s0to2, s0to3,
+	d0m1, d2m3, d1m0, d3m2,
+	de0m1, de2m3, de1m0, de3m2,
+	d0m1to2m3, d1m0to3m2,
+	s2to3,
+};
+
+/* Applies to max1238, max1239 */
+static const enum max1363_modes max1238_mode_list[] = {
+	_s0, _s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8, _s9, _s10, _s11,
+	se0, se1, se2, se3, se4, se5, se6, se7, se8, se9, se10, se11,
+	s0to1, s0to2, s0to3, s0to4, s0to5, s0to6,
+	s0to7, s0to8, s0to9, s0to10, s0to11,
+	d0m1, d2m3, d4m5, d6m7, d8m9, d10m11,
+	d1m0, d3m2, d5m4, d7m6, d9m8, d11m10,
+	de0m1, de2m3, de4m5, de6m7, de8m9, de10m11,
+	de1m0, de3m2, de5m4, de7m6, de9m8, de11m10,
+	d0m1to2m3, d0m1to4m5, d0m1to6m7, d0m1to8m9, d0m1to10m11,
+	d1m0to3m2, d1m0to5m4, d1m0to7m6, d1m0to9m8, d1m0to11m10,
+	s2to3, s6to7, s6to8, s6to9, s6to10, s6to11,
+	s6m7to8m9, s6m7to10m11, s7m6to9m8, s7m6to11m10,
+};
+
+
+enum { max1361,
+       max1362,
+       max1363,
+       max1364,
+       max1136,
+       max1137,
+       max1138,
+       max1139,
+       max1236,
+       max1237,
+       max1238,
+       max1239,
+};
+
+/* max1363 and max1368 tested - rest from data sheet */
+static const struct max1363_chip_info max1363_chip_info_tbl[] = {
+	{
+		.name = "max1361",
+		.num_inputs = 4,
+		.monitor_mode = 1,
+		.mode_list = max1363_mode_list,
+		.num_modes = ARRAY_SIZE(max1363_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1362",
+		.num_inputs = 4,
+		.monitor_mode = 1,
+		.mode_list = max1363_mode_list,
+		.num_modes = ARRAY_SIZE(max1363_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1363",
+		.num_inputs = 4,
+		.monitor_mode = 1,
+		.mode_list = max1363_mode_list,
+		.num_modes = ARRAY_SIZE(max1363_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1364",
+		.num_inputs = 4,
+		.monitor_mode = 1,
+		.mode_list = max1363_mode_list,
+		.num_modes = ARRAY_SIZE(max1363_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1136",
+		.num_inputs = 4,
+		.int_vref_mv = 4096,
+		.mode_list = max1236_mode_list,
+		.num_modes = ARRAY_SIZE(max1236_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1137",
+		.num_inputs = 4,
+		.int_vref_mv = 2048,
+		.mode_list = max1236_mode_list,
+		.num_modes = ARRAY_SIZE(max1236_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1138",
+		.num_inputs = 12,
+		.int_vref_mv = 4096,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+	}, {
+		.name = "max1139",
+		.num_inputs = 12,
+		.int_vref_mv = 2048,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+	}, {
+		.name = "max1236",
+		.num_inputs = 4,
+		.int_vref_mv = 4096,
+		.mode_list = max1236_mode_list,
+		.num_modes = ARRAY_SIZE(max1236_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1237",
+		.num_inputs = 4,
+		.int_vref_mv = 2048,
+		.mode_list = max1236_mode_list,
+		.num_modes = ARRAY_SIZE(max1236_mode_list),
+		.default_mode = s0to3,
+	}, {
+		.name = "max1238",
+		.num_inputs = 12,
+		.int_vref_mv = 4096,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+	}, {
+		.name = "max1239",
+		.num_inputs = 12,
+		.int_vref_mv = 2048,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+	},
+};
+
+static int max1363_write_basic_config(struct i2c_client *client,
+				      unsigned char d1,
+				      unsigned char d2)
+{
+	int ret;
+	u8 *tx_buf = kmalloc(2 , GFP_KERNEL);
+	if (!tx_buf)
+		return -ENOMEM;
+	tx_buf[0] = d1;
+	tx_buf[1] = d2;
+	ret = i2c_master_send(client, tx_buf, 2);
+	kfree(tx_buf);
+	return (ret > 0) ? 0 : ret;
+}
+
+static int max1363_set_scan_mode(struct device *dev, struct max1363_data *data)
+{
+	int ret;
+
+	data->configbyte &= ~(MAX1363_CHANNEL_SEL_MASK
+			      | MAX1363_SCAN_MASK
+			      | MAX1363_SE_DE_MASK);
+
+	data->configbyte |= data->current_mode->conf;
+
+	ret = max1363_write_basic_config(data->client,
+					 data->setupbyte,
+					 data->configbyte);
+
+	return ret;
+}
+
+static int max1363_initial_setup(struct max1363_data *data)
+{
+	int ret;
+
+	data->setupbyte	= MAX1363_SETUP_AIN3_IS_AIN3_REF_IS_VDD
+		| MAX1363_SETUP_POWER_UP_INT_REF
+		| MAX1363_SETUP_INT_CLOCK
+		| MAX1363_SETUP_UNIPOLAR
+		| MAX1363_SETUP_NORESET;
+
+	data->setupbyte = MAX1363_SETUP_BYTE(data->setupbyte);
+	data->current_mode = &max1363_mode_table[data->chip_info->default_mode];
+	data->configbyte = MAX1363_CONFIG_BYTE(data->configbyte);
+	/* Set scan mode writes the config anyway so don't explicitly do it */
+	ret = max1363_set_scan_mode(data->indio_dev->dev, data);
+
+	return ret;
+}
+
+static ssize_t max1363_show_av_scan_modes(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_data *data = dev_info->dev_data;
+	int i, len = 0;
+
+	for (i = 0; i < data->chip_info->num_modes; i++)
+		len += sprintf(buf + len, "%s ",
+			       max1363_mode_table[data->chip_info
+						  ->mode_list[i]].name);
+	len += sprintf(buf + len, "\n");
+
+	return len;
+}
+
+
+
+static ssize_t max1363_scan_direct(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_data *data = dev_info->dev_data;
+	int len = 0, ret, i;
+	struct i2c_client *client = to_i2c_client(dev);
+	char *rxbuf;
+
+	if (data->current_mode->numvals == 0)
+		return 0;
+	rxbuf = kmalloc(data->current_mode->numvals*2, GFP_KERNEL);
+	if (rxbuf == NULL)
+		return -ENOMEM;
+
+	/* Interpretation depends on whether these are signed or not!*/
+	/* Assume not for now */
+	ret = i2c_master_recv(client, rxbuf, data->current_mode->numvals*2);
+
+	if (ret < 0)
+		return ret;
+	for (i = 0; i < data->current_mode->numvals; i++)
+		len += sprintf(buf+len, "%d ",
+			       ((int)(rxbuf[i*2+0]&0x0F) << 8)
+			       + ((int)(rxbuf[i*2+1])));
+	kfree(rxbuf);
+	len += sprintf(buf + len, "\n");
+
+	return len;
+}
+
+static ssize_t max1363_scan(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&dev_info->mlock);
+	if (dev_info->currentmode == INDIO_RING_TRIGGERED)
+		ret = max1363_scan_from_ring(dev, attr, buf);
+	else
+		ret = max1363_scan_direct(dev, attr, buf);
+	mutex_unlock(&dev_info->mlock);
+
+	return ret;
+}
+
+/* Cannot query the device, so use local copy of state */
+static ssize_t max1363_show_scan_mode(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	int len = 0;
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_data *data = dev_info->dev_data;
+
+	len += sprintf(buf, "%s\n", data->current_mode->name);
+
+	return len;
+}
+
+static const struct max1363_mode
+*__max1363_find_mode_in_ci(const struct max1363_chip_info *info,
+				  const char *buf)
+{
+	int i;
+	for (i = 0; i <  info->num_modes; i++)
+		if (strcmp(max1363_mode_table[info->mode_list[i]].name, buf)
+		    == 0)
+			return &max1363_mode_table[info->mode_list[i]];
+	return NULL;
+}
+
+static ssize_t max1363_store_scan_mode(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf,
+				       size_t len)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_data *data = dev_info->dev_data;
+	int ret;
+
+	mutex_lock(&dev_info->mlock);
+	data->current_mode = NULL;
+	/* Avoid state changes if a ring buffer is enabled */
+	if (!iio_ring_enabled(dev_info)) {
+		data->current_mode
+			= __max1363_find_mode_in_ci(data->chip_info, buf);
+		if (!data->current_mode) {
+			ret = -EINVAL;
+			goto error_ret;
+		}
+		ret =  max1363_set_scan_mode(dev, data);
+		if (ret)
+			goto error_ret;
+} else {
+		ret = -EBUSY;
+		goto error_ret;
+	}
+	mutex_unlock(&dev_info->mlock);
+
+	return len;
+
+error_ret:
+	mutex_unlock(&dev_info->mlock);
+
+	return ret;
+}
+
+IIO_DEV_ATTR_AVAIL_SCAN_MODES(max1363_show_av_scan_modes);
+IIO_DEV_ATTR_SCAN_MODE(S_IRUGO | S_IWUSR,
+		       max1363_show_scan_mode,
+		       max1363_store_scan_mode);
+
+IIO_DEV_ATTR_SCAN(max1363_scan);
+
+
+
+static struct attribute *max1363_attributes[] = {
+	&iio_dev_attr_available_scan_modes.dev_attr.attr,
+	&iio_dev_attr_scan_mode.dev_attr.attr,
+	&iio_dev_attr_scan.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group max1363_attribute_group = {
+	.attrs = max1363_attributes,
+};
+
+static int __devinit max1363_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
+{
+	int ret, i;
+	struct max1363_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	atomic_set(&data->protect_ring, 0);
+
+	/* Find the default mode */
+	for (i = 0; i < ARRAY_SIZE(max1363_chip_info_tbl); i++)
+		if (!strcmp(max1363_chip_info_tbl[i].name, id->name)) {
+			data->chip_info = &max1363_chip_info_tbl[i];
+			break;
+		};
+	/* Unsupported default mode? */
+	if (!data->chip_info) {
+		dev_err(&client->dev, "%s is not supported\n", id->name);
+		ret = -ENODEV;
+		goto error_free_data;
+	}
+
+	data->client = client;
+
+	data->indio_dev = kzalloc(sizeof(*data->indio_dev), GFP_KERNEL);
+	if (data->indio_dev == NULL) {
+		ret = -ENOMEM;
+		goto error_free_data;
+	}
+
+	data->indio_dev->dev = &client->dev;
+	data->indio_dev->attrs = &max1363_attribute_group;
+	data->indio_dev->dev_data = (void *)(data);
+
+	data->indio_dev->modes = INDIO_DIRECT_MODE;
+
+	ret = max1363_register_ring_funcs_and_init(data->indio_dev);
+	if (ret)
+		goto error_free_device;
+
+	ret = iio_device_register(data->indio_dev);
+	if (ret)
+		goto error_cleanup_ring;
+
+	ret = max1363_initial_setup(data);
+	if (ret)
+		goto error_unregister_dev;
+
+	return 0;
+
+error_unregister_dev:
+	iio_device_unregister(data->indio_dev);
+error_cleanup_ring:
+	max1363_ring_cleanup(data->indio_dev);
+error_free_device:
+	kfree(data->indio_dev);
+error_free_data:
+	kfree(data);
+error_ret:
+	return ret;
+}
+
+static int max1363_remove(struct i2c_client *client)
+{
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+	struct max1363_data *data = indio_dev->dev_data;
+
+/* Currently device left in whatever state it is currently in */
+	iio_device_unregister(indio_dev);
+	max1363_ring_cleanup(indio_dev);
+	kfree(indio_dev);
+	kfree(data);
+
+	return 0;
+}
+
+static const struct i2c_device_id max1363_id[] = {
+	{ "max1361", max1361 },
+	{ "max1362", max1362 },
+	{ "max1363", max1363 },
+	{ "max1364", max1364 },
+	{ "max1136", max1136 },
+	{ "max1137", max1137 },
+	{ "max1138", max1138 },
+	{ "max1139", max1139 },
+	{ "max1236", max1236 },
+	{ "max1237", max1237 },
+	{ "max1238", max1238 },
+	{ "max1239", max1239 },
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, max1363_id);
+
+static struct i2c_driver max1363_driver = {
+	.driver = {
+		.name = "max1363",
+	},
+	.probe = max1363_probe,
+	.remove = max1363_remove,
+	.id_table = max1363_id,
+};
+
+static __init int max1363_init(void)
+{
+	return i2c_add_driver(&max1363_driver);
+}
+
+static __exit void max1363_exit(void)
+{
+	i2c_del_driver(&max1363_driver);
+}
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("Maxim 1363 ADC");
+MODULE_LICENSE("GPL v2");
+
+module_init(max1363_init);
+module_exit(max1363_exit);
