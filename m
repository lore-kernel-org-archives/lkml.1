Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZGBNvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZGBNvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZGBNub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:50:31 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:42937 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZGBNu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:50:29 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: chrisv@cyberswitching.com, daniel@caiaq.de, iws@ovro.caltech.edu,
       dmitry.torokhov@gmail.com, hmh@hmh.eng.br, david-b@pacbell.net,
       khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 11/14] IIO: max1363 add software ring buffer support using ring_sw
Date: Thu,  2 Jul 2009 13:47:41 +0000
Message-Id: <1246542464-6974-12-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1246542464-6974-11-git-send-email-jic23@cam.ac.uk>
References: <1246542464-6974-1-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-2-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-3-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-4-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-5-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-6-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-7-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-8-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-9-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-10-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-11-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Changes since V2:
* Moved to new registration methodology.
---
 drivers/iio/adc/Makefile       |    1 +
 drivers/iio/adc/max1363.h      |   14 +++-
 drivers/iio/adc/max1363_ring.c |  235 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+), 1 deletions(-)
 create mode 100644 drivers/iio/adc/max1363_ring.c

diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 2a37fee..0c2b6f3 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -3,5 +3,6 @@
 #
 
 max1363-y := max1363_core.o
+max1363-$(CONFIG_IIO_RING_BUFFER) += max1363_ring.o
 
 obj-$(CONFIG_MAX1363) += max1363.o
diff --git a/drivers/iio/adc/max1363.h b/drivers/iio/adc/max1363.h
index a9d5c21..8aca81f 100644
--- a/drivers/iio/adc/max1363.h
+++ b/drivers/iio/adc/max1363.h
@@ -228,6 +228,18 @@ struct max1363_state {
 	struct iio_trigger		*trig;
 	struct regulator		*reg;
 };
+#ifdef CONFIG_IIO_RING_BUFFER
+
+ssize_t max1363_scan_from_ring(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf);
+int max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev);
+void max1363_ring_cleanup(struct iio_dev *indio_dev);
+
+int max1363_initialize_ring(struct iio_ring_buffer *ring);
+void max1363_uninitialize_ring(struct iio_ring_buffer *ring);
+
+#else /* CONFIG_IIO_RING_BUFFER */
 
 static inline void max1363_uninitialize_ring(struct iio_ring_buffer *ring)
 {
@@ -253,5 +265,5 @@ max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev)
 };
 
 static inline void max1363_ring_cleanup(struct iio_dev *indio_dev) {};
-
+#endif /* CONFIG_IIO_RING_BUFFER */
 #endif /* _MAX1363_H_ */
diff --git a/drivers/iio/adc/max1363_ring.c b/drivers/iio/adc/max1363_ring.c
new file mode 100644
index 0000000..6c66b43
--- /dev/null
+++ b/drivers/iio/adc/max1363_ring.c
@@ -0,0 +1,235 @@
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
+#include <linux/iio/iio.h>
+#include <linux/iio/ring_generic.h>
+#include <linux/iio/ring_sw.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/sysfs.h>
+
+#include "max1363.h"
+
+ssize_t max1363_scan_from_ring(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct max1363_state *info = dev_info->dev_data;
+	int i, ret, len = 0;
+	char *ring_data;
+
+	ring_data = kmalloc(info->current_mode->numvals*2, GFP_KERNEL);
+	if (ring_data == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	ret = dev_info->ring->access.read_last(dev_info->ring, ring_data);
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
+	struct max1363_state *st = indio_dev->dev_data;
+	size_t d_size;
+
+	if (indio_dev->ring->access.set_bpd) {
+		d_size = st->current_mode->numvals*2 + sizeof(s64);
+		if (d_size % 8)
+			d_size += 8 - (d_size % 8);
+		indio_dev->ring->access.set_bpd(indio_dev->ring, d_size);
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
+	struct max1363_state *st = indio_dev->dev_data;
+
+	schedule_work(&st->poll_work);
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
+	struct max1363_state *st = container_of(work_s, struct max1363_state,
+						  poll_work);
+	struct iio_dev *indio_dev = st->indio_dev;
+	struct iio_sw_ring_buffer *ring = iio_to_sw_ring(indio_dev->ring);
+	s64 time_ns;
+	__u8 *rxbuf;
+	int b_sent;
+	size_t d_size;
+
+	/* Ensure the timestamp is 8 byte aligned */
+	d_size = st->current_mode->numvals*2 + sizeof(s64);
+	if (d_size % sizeof(s64))
+		d_size += sizeof(s64) - (d_size % sizeof(s64));
+
+	/* Ensure only one copy of this function running at a time */
+	if (atomic_inc_return(&st->protect_ring) > 1)
+		return;
+
+	/* Monitor mode prevents reading. Whilst not currently implemented
+	 * might as well have this test in here in the meantime as it does
+	 * no harm.
+	 */
+	if (st->current_mode->numvals == 0)
+		return;
+
+	rxbuf = kmalloc(d_size,	GFP_KERNEL);
+	if (rxbuf == NULL)
+		return;
+
+	b_sent = i2c_master_recv(st->client,
+				 rxbuf,
+				 st->current_mode->numvals*2);
+	if (b_sent < 0)
+		goto done;
+
+	time_ns = iio_get_time_ns();
+
+	memcpy(rxbuf + d_size - sizeof(s64), &time_ns, sizeof(time_ns));
+
+	indio_dev->ring->access.store_to(&ring->buf, rxbuf, time_ns);
+done:
+	kfree(rxbuf);
+	atomic_dec(&st->protect_ring);
+}
+
+
+int max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev)
+{
+	struct max1363_state *st = indio_dev->dev_data;
+	int ret = 0;
+
+	indio_dev->ring = iio_sw_rb_allocate(indio_dev);
+	if (!indio_dev->ring) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	/* Effectively select the ring buffer implementation */
+	iio_ring_sw_register_funcs(&st->indio_dev->ring->access);
+	indio_dev->pollfunc = kzalloc(sizeof(*indio_dev->pollfunc), GFP_KERNEL);
+	if (indio_dev->pollfunc == NULL) {
+		ret = -ENOMEM;
+		goto error_deallocate_sw_rb;
+	}
+	/* Configure the polling function called on trigger interrupts */
+	indio_dev->pollfunc->poll_func_main = &max1363_poll_func_th;
+	indio_dev->pollfunc->private_data = indio_dev;
+
+	/* Ring buffer functions - here trigger setup related */
+	indio_dev->ring->postenable = &max1363_ring_postenable;
+	indio_dev->ring->preenable = &max1363_ring_preenable;
+	indio_dev->ring->predisable = &max1363_ring_predisable;
+	INIT_WORK(&st->poll_work, &max1363_poll_bh_to_ring);
+
+	/* Flag that polled ring buffering is possible */
+	indio_dev->modes |= INDIO_RING_TRIGGERED;
+	return 0;
+error_deallocate_sw_rb:
+	iio_sw_rb_free(indio_dev->ring);
+error_ret:
+	return ret;
+}
+
+void max1363_ring_cleanup(struct iio_dev *indio_dev)
+{
+	kfree(indio_dev->pollfunc);
+	iio_sw_rb_free(indio_dev->ring);
+}
+
+void max1363_uninitialize_ring(struct iio_ring_buffer *ring)
+{
+	iio_ring_buffer_unregister(ring);
+};
+
+int max1363_initialize_ring(struct iio_ring_buffer *ring)
+{
+	return iio_ring_buffer_register(ring);
+};
-- 
1.6.2

