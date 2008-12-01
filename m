Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbYLAOel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbYLAOel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYLAOec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:34:32 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:42505 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYLAOeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:34:31 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F5F3.6040503@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:34:27 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [0/13] RFC:  Maxim MAX1363 driver (ring buffer support)
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jonathan Cameron <jic23@cam.ac.uk>

IIO: Maxim MAX1363 driver (ring buffer support)

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--
 This patch adds triggered software ring buffer support to
 the core driver.  It should act as an example of how many
 of the elements of the IIO subsystem function.

 There is currently an issue with unaligned timestamps on
 arm to be resolved when non multiple of 4 scan modes used.

 drivers/industrialio/adc/Kconfig        |    6 +
 drivers/industrialio/adc/Makefile       |    2 +
 drivers/industrialio/adc/max1363.h      |    9 ++
 drivers/industrialio/adc/max1363_ring.c |  219 +++++++++++++++++++++++++++++++
 4 files changed, 236 insertions(+), 0 deletions(-)

diff --git a/drivers/industrialio/adc/Kconfig b/drivers/industrialio/adc/Kconfig
index 203a5f9..be77ab5 100644
--- a/drivers/industrialio/adc/Kconfig
+++ b/drivers/industrialio/adc/Kconfig
@@ -11,3 +11,9 @@ config MAX1363
 	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
 	  max1136, max1137, max1138, max1139, max1236, max1237, max11238,
 	  max1239) Provides direct access via sysfs.
+
+config MAX1363_RING
+       boolean "Ring buffer support"
+       depends on MAX1363 && IIO_SW_RING && IIO_TRIGGERS
+       help
+         Enable software ring buffer support in the max1363 driver.
diff --git a/drivers/industrialio/adc/Makefile b/drivers/industrialio/adc/Makefile
index 2a37fee..a6bff5f 100644
--- a/drivers/industrialio/adc/Makefile
+++ b/drivers/industrialio/adc/Makefile
@@ -3,5 +3,7 @@
 #
 
 max1363-y := max1363_core.o
+#got to be a better way of doing this 
+max1363-$(CONFIG_MAX1363_RING) += max1363_ring.o
 
 obj-$(CONFIG_MAX1363) += max1363.o
diff --git a/drivers/industrialio/adc/max1363.h b/drivers/industrialio/adc/max1363.h
index 71e9577..b0e8928 100644
--- a/drivers/industrialio/adc/max1363.h
+++ b/drivers/industrialio/adc/max1363.h
@@ -228,6 +228,15 @@ struct max1363_data {
 };
 
 #ifdef CONFIG_MAX1363_RING
+
+ssize_t max1363_scan_from_ring(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf);
+int max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev);
+void max1363_ring_cleanup(struct iio_dev *indio_dev);
+
+
+
 #else /* CONFIG_MAX1363_RING */
 
 static inline ssize_t max1363_scan_from_ring(struct device *dev,
diff --git a/drivers/industrialio/adc/max1363_ring.c b/drivers/industrialio/adc/max1363_ring.c
new file mode 100644
index 0000000..b2b9e18
--- /dev/null
+++ b/drivers/industrialio/adc/max1363_ring.c
@@ -0,0 +1,219 @@
+/*
+ * Copyright (C) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * max1363_ring.c
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
+
+
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/ring_sw.h>
+#include <linux/industrialio/trigger.h>
+#include <linux/industrialio/sysfs.h>
+
+#include "max1363.h"
+
+ssize_t max1363_scan_from_ring(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_data *info = dev_info->dev_data;
+	int i, ret, len = 0;
+	char *ring_data;
+
+	ring_data = kmalloc(info->current_mode->numvals*2, GFP_KERNEL);
+	if (ring_data == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	ret = dev_info->ring_access.read_last(dev_info->ring, ring_data);
+	if (ret)
+		goto error_free_ring_data;
+	len += sprintf(buf+len, "ring ");
+	for (i = 0; i < info->current_mode->numvals; i++)
+		len += sprintf(buf + len, "%d ",
+			       ((int)(ring_data[i*2 + 0] & 0x0F) << 8)
+			       + ((int)(ring_data[i*2 + 1])));
+	len += sprintf(buf + len, "\n");
+	kfree(ring_data);
+
+	return len;
+
+error_free_ring_data:
+	kfree(ring_data);
+error_ret:
+	return ret;
+}
+
+/**
+ * max1363_ring_preenable() setup the parameters of the ring before enabling
+ *
+ * The complex nature of the setting of the nuber of bytes per datum is due
+ * to this driver currently ensuring that the timestamp is stored at an 8
+ * byte boundary.
+ **/
+static int max1363_ring_preenable(struct iio_dev *indio_dev)
+{
+	struct max1363_data *data = indio_dev->dev_data;
+	size_t d_size;
+
+	if (indio_dev->ring_access.set_bpd) {
+		d_size = data->current_mode->numvals*2 + sizeof(s64);
+		if (d_size % 8)
+			d_size += 8 - (d_size % 8);
+		indio_dev->ring_access.set_bpd(indio_dev->ring, d_size);
+	}
+
+	return 0;
+}
+
+/**
+ * max1363_ring_postenable() typical ring post enable
+ *
+ * Only not moved into the core for the hardware ring buffer cases
+ * that are more sophisticated.
+ **/
+static int max1363_ring_postenable(struct iio_dev *indio_dev)
+{
+	if (indio_dev->trig == NULL)
+		return 0;
+	return iio_trigger_attach_poll_func(indio_dev->trig,
+					    indio_dev->pollfunc);
+}
+
+/**
+ * max1363_ring_predisable() runs just prior to ring buffer being disabled
+ *
+ * Typical predisable function which ensures that no trigger events can
+ * occur before we disable the ring buffer (and hence would have no idea
+ * what to do with them)
+ **/
+static int max1363_ring_predisable(struct iio_dev *indio_dev)
+{
+	if (indio_dev->trig)
+		return iio_trigger_dettach_poll_func(indio_dev->trig,
+						     indio_dev->pollfunc);
+	else
+		return 0;
+}
+
+/**
+ * max1363_poll_func_th() th of trigger launched polling to ring buffer
+ *
+ * As sampling only occurs on i2c comms occuring, leave timestamping until
+ * then.  Some triggers will generate their own time stamp.  Currently
+ * there is no way of notifying them when no one cares.
+ **/
+void max1363_poll_func_th(struct iio_dev *indio_dev)
+{
+	struct max1363_data *data = indio_dev->dev_data;
+
+	schedule_work(&data->poll_work);
+
+	return;
+}
+/**
+ * max1363_poll_bh_to_ring() bh of trigger launched polling to ring buffer
+ * @work_s:	the work struct through which this was scheduled
+ *
+ * Currently there is no option in this driver to disable the saving of
+ * timestamps within the ring.
+ * I think the one copy of this at a time was to avoid problems if the
+ * trigger was set far too high and the reads then locked up the computer.
+ **/
+static void max1363_poll_bh_to_ring(struct work_struct *work_s)
+{
+	struct max1363_data *data = container_of(work_s, struct max1363_data,
+						 poll_work);
+	struct iio_dev *indio_dev = data->indio_dev;
+	struct iio_sw_ring_buffer *ring = indio_dev->ring;
+	s64 time_ns;
+	__u8 *rxbuf;
+	int b_sent;
+	size_t d_size;
+
+	/* Ensure the timestamp is 8 byte aligned */
+	d_size = data->current_mode->numvals*2 + sizeof(s64);
+	if (d_size % sizeof(s64))
+		d_size += sizeof(s64) - (d_size % sizeof(s64));
+
+	/* Ensure only one copy of this function running at a time */
+	if (atomic_inc_return(&data->protect_ring) > 1)
+		return;
+
+	/* Monitor mode prevents reading. Whilst not currently implemented
+	 * might as well have this test in here in the meantime as it does
+	 * no harm.
+	 */
+	if (data->current_mode->numvals == 0)
+		return;
+
+	rxbuf = kmalloc(d_size,	GFP_KERNEL);
+	if (rxbuf == NULL)
+		return;
+
+	b_sent = i2c_master_recv(data->client,
+				 rxbuf,
+				 data->current_mode->numvals*2);
+	if (b_sent < 0)
+		goto done;
+
+	time_ns = iio_get_time_ns();
+
+	memcpy(rxbuf + d_size - sizeof(s64), &time_ns, sizeof(time_ns));
+	indio_dev->ring_access.store_to(ring, rxbuf, time_ns);
+done:
+	kfree(rxbuf);
+	atomic_dec(&data->protect_ring);
+}
+
+int max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev)
+{
+	struct max1363_data *data = indio_dev->dev_data;
+	int ret = 0;
+
+	/* Effectively select the ring buffer implementation */
+	iio_ring_sw_register_funcs(&data->indio_dev->ring_access);
+
+	indio_dev->pollfunc = kzalloc(sizeof(*indio_dev->pollfunc), GFP_KERNEL);
+	if (indio_dev->pollfunc == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	/* Configure the polling function called on trigger interrupts */
+	indio_dev->pollfunc->poll_func_main = &max1363_poll_func_th;
+	indio_dev->pollfunc->private_data = indio_dev;
+
+	/* Ring buffer functions - here trigger setup related */
+	indio_dev->ring_postenable = &max1363_ring_postenable;
+	indio_dev->ring_preenable = &max1363_ring_preenable;
+	indio_dev->ring_predisable = &max1363_ring_predisable;
+
+	INIT_WORK(&data->poll_work, &max1363_poll_bh_to_ring);
+
+	/* Flag that polled ring buffering is possible */
+	indio_dev->modes |= INDIO_RING_TRIGGERED;
+
+error_ret:
+	return ret;
+}
+
+void max1363_ring_cleanup(struct iio_dev *indio_dev)
+{
+	kfree(indio_dev->pollfunc);
+}
+
