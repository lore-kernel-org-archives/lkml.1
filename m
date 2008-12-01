Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYLAO1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYLAO1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYLAO1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:27:22 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:50376 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYLAO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:27:21 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F445.2070403@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:27:17 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [3/13] RFC: IIO Software ring buffer implementation
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

IIO: Software ring buffer implementation.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

--

Intended to act as an example of how a software ring buffer might
function rather than as a definitive solution. The particular
focus of this was an application that required relatively hight
sampling rates (couple of Ksamples) with low computational load
and few dropped samples.

To my mind this is the most flakey element of this patch set.
All suggestions on alternative approaches / simplifications
would be most welcome. My intention is to also provide a far
simple locked ring buffer (hence all accesses in bh of interrupt
handlers) to act as a very simple example for people coding up
there own but this is not yet in place.

 drivers/industrialio/Kconfig         |    9
 drivers/industrialio/Makefile        |    4
 drivers/industrialio/ring_sw.c       |  370 +++++++++++++++++++++++++++++++++++
 include/linux/industrialio/ring_sw.h |  183 +++++++++++++++++
 4 files changed, 565 insertions(+), 1 deletion(-)

diff --git a/drivers/industrialio/Kconfig b/drivers/industrialio/Kconfig
index d132ab6..73c5616 100644
--- a/drivers/industrialio/Kconfig
+++ b/drivers/industrialio/Kconfig
@@ -17,3 +17,12 @@ config IIO_RING_BUFFER
 	    Provide support for various ring buffer based data
 	    acquisition methods.
 
+config IIO_SW_RING
+       tristate "Industrial I/O lock free software ring"
+       depends on IIO_RING_BUFFER && INDUSTRIALIO
+
+       ---help---
+	example software ring buffer implementation.  The design aim
+	of this particular realization was to minize write locking
+	with the intention that some devices would be able to write
+	in interrupt context.
\ No newline at end of file
diff --git a/drivers/industrialio/Makefile b/drivers/industrialio/Makefile
index 1f47af3..0fda138 100644
--- a/drivers/industrialio/Makefile
+++ b/drivers/industrialio/Makefile
@@ -3,5 +3,7 @@
 #
 
 obj-$(CONFIG_INDUSTRIALIO)	+= industrialio.o
-industrialio-y := industrialio-core.o
+industrialio-y := industrialio-core.o 
 industrialio-$(CONFIG_IIO_RING_BUFFER) += industrialio-ring.o
+
+obj-$(CONFIG_IIO_SW_RING) += ring_sw.o
diff --git a/drivers/industrialio/ring_sw.c b/drivers/industrialio/ring_sw.c
new file mode 100644
index 0000000..347ace1
--- /dev/null
+++ b/drivers/industrialio/ring_sw.c
@@ -0,0 +1,370 @@
+/* The industrial I/O simple minimally locked ring buffer.
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/industrialio/ring_sw.h>
+
+static inline int __iio_init_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
+					    int bytes_per_datum, int length)
+{
+	__iio_init_ring_buffer(&ring->buf, bytes_per_datum, length);
+	ring->use_lock = __SPIN_LOCK_UNLOCKED((ring)->use_lock);
+	ring->data = kmalloc(length*ring->buf.bpd, GFP_KERNEL);
+
+	return ring->data ? 0 : -ENOMEM;
+}
+
+static inline void __iio_free_sw_ring_buffer(struct iio_sw_ring_buffer *ring)
+{
+	kfree(ring->data);
+}
+
+void iio_mark_sw_rb_in_use(void *r)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	spin_lock(&ring->use_lock);
+	ring->use_count++;
+	spin_unlock(&ring->use_lock);
+}
+EXPORT_SYMBOL(iio_mark_sw_rb_in_use);
+
+void iio_unmark_sw_rb_in_use(void *r)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	spin_lock(&ring->use_lock);
+	ring->use_count--;
+	spin_unlock(&ring->use_lock);
+}
+EXPORT_SYMBOL(iio_unmark_sw_rb_in_use);
+
+
+/* Ring buffer related functionality */
+/* Store to ring is typically called in the bh of a data ready interrupt handler
+ * in the device driver */
+/* Lock always held if their is a chance this may be called */
+int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
+			 unsigned char *data,
+			 s64 timestamp)
+{
+	bool init_read = true;
+	int ret;
+	int code;
+
+	/* initial store */
+	if (unlikely(ring->write_p == 0)) {
+		ring->write_p = ring->data;
+		/* doesn't actually matter if this is out of the set */
+		ring->half_p = ring->data - ring->buf.length*ring->buf.bpd/2;
+		init_read = false;
+	}
+	memcpy(ring->write_p, data, ring->buf.bpd);
+	barrier();
+	ring->last_written_p = ring->write_p;
+	barrier();
+	ring->write_p += ring->buf.bpd;
+	/* End of ring, back to the beginning */
+	if (ring->write_p == ring->data + ring->buf.length*ring->buf.bpd) {
+		ring->write_p = ring->data;
+		ring->buf.loopcount++;
+	}
+	if (ring->read_p == 0)
+		ring->read_p = ring->data;
+	/* Buffer full - move the read pointer and create / escalate
+	 * ring event */
+	else if (ring->write_p == ring->read_p) {
+		ring->read_p += ring->buf.bpd;
+		if (ring->read_p
+		    == ring->data + ring->buf.length*ring->buf.bpd)
+			ring->read_p = ring->data;
+
+		spin_lock(&ring->buf.shared_ev_pointer.lock);
+		if (ring->buf.shared_ev_pointer.ev_p) {
+			/* Event escalation - probably quicker to let this
+			   keep running than check if it is necessary */
+			code = IIO_EVENT_CODE_RING_100_FULL;
+			__iio_change_event(ring
+					   ->buf.shared_ev_pointer.ev_p,
+					   code,
+					   timestamp);
+		} else {
+			code = IIO_EVENT_CODE_RING_100_FULL;
+			ret = __iio_push_event(&ring->buf.ev_int,
+					       code,
+					       timestamp,
+					       &ring
+					       ->buf.shared_ev_pointer);
+			if (ret) {
+				spin_unlock(&ring->buf.shared_ev_pointer.lock);
+				goto error_ret;
+			}
+		}
+		spin_unlock(&ring->buf.shared_ev_pointer.lock);
+	}
+	/* investigate if our event barrier has been passed */
+	/* There are definite 'issues' with this and chances of
+	 * simultaneous read */
+	/* Also need to use loop count to ensure this only happens once */
+	ring->half_p += ring->buf.bpd;
+	if (ring->half_p == ring->data + ring->buf.length*ring->buf.bpd)
+		ring->half_p = ring->data;
+	if (ring->half_p == ring->read_p) {
+		spin_lock(&ring->buf.shared_ev_pointer.lock);
+		code = IIO_EVENT_CODE_RING_50_FULL;
+		ret = __iio_push_event(&ring->buf.ev_int,
+				       code,
+				       timestamp,
+				       &ring->buf.shared_ev_pointer);
+		spin_unlock(&ring->buf.shared_ev_pointer.lock);
+
+		if (ret)
+			goto error_ret;
+	}
+	return 0;
+error_ret:
+	return ret;
+}
+
+int iio_rip_sw_rb(void *r,  size_t count, u8 **data, int *dead_offset)
+{
+	struct iio_sw_ring_buffer *ring = r;
+
+	u8 *initial_read_p, *initial_write_p, *current_read_p, *end_read_p;
+
+	int ret, max_copied;
+	/* Round down to nearest datum boundary */
+	int bytes_to_rip = count - count % ring->buf.bpd;
+
+	/* Limit size to whole of ring buffer */
+	bytes_to_rip = min(ring->buf.bpd*ring->buf.length, bytes_to_rip);
+
+	*data = kmalloc(bytes_to_rip, GFP_KERNEL);
+	if (*data == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	/* build local copy */
+	initial_read_p = ring->read_p;
+	if (unlikely(initial_read_p == 0)) { /* No data here as yet */
+		ret = 0;
+		goto error_free_data_cpy;
+	}
+
+	initial_write_p = ring->write_p;
+
+	/* Need a consistent pair */
+	while ((initial_read_p != ring->read_p)
+	       || (initial_write_p != ring->write_p)) {
+		initial_read_p = ring->read_p;
+		initial_write_p = ring->write_p;
+	}
+	if (initial_write_p == initial_read_p) {
+		/* No new data available.*/
+		ret = 0;
+		goto error_free_data_cpy;
+	}
+
+	if (initial_write_p > initial_read_p + bytes_to_rip) {
+		/* write_p is greater than necessary, all is easy */
+		max_copied = bytes_to_rip;
+		memcpy(*data, initial_read_p, max_copied);
+		end_read_p = initial_read_p + max_copied;
+	} else if (initial_write_p > initial_read_p) {
+		/*not enough data to cpy */
+		max_copied = initial_write_p - initial_read_p;
+		memcpy(*data, initial_read_p, max_copied);
+		end_read_p = initial_write_p;
+	} else {
+		/* going through 'end' of ring buffer */
+		max_copied = ring->data
+			+ ring->buf.length*ring->buf.bpd - initial_read_p;
+		memcpy(*data, initial_read_p, max_copied);
+		if (initial_write_p > ring->data + bytes_to_rip - max_copied) {
+			/* enough data to finish */
+			memcpy(*data + max_copied, ring->data,
+			       bytes_to_rip - max_copied);
+			max_copied = bytes_to_rip;
+			end_read_p = ring->data + (bytes_to_rip - max_copied);
+		} else {  /* not enough data */
+			memcpy(*data + max_copied, ring->data,
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
+		*dead_offset = current_read_p - initial_read_p;
+	else
+		*dead_offset = ring->buf.length*ring->buf.bpd
+			- (initial_read_p - current_read_p);
+
+	/* possible issue if the initial write has been lapped or indeed
+	 * the point we were reading to has been passed */
+	/* No valid data read.
+	 * In this case the read pointer is already correct having been
+	 * pushed further than we would look. */
+	if (max_copied - *dead_offset < 0) {
+		ret = 0;
+		goto error_free_data_cpy;
+	}
+
+	/* setup the next read position */
+	ring->read_p = end_read_p;
+	return max_copied - *dead_offset;
+
+error_free_data_cpy:
+	kfree(data);
+error_ret:
+	return 0;
+}
+EXPORT_SYMBOL(iio_rip_sw_rb);
+//EXPORT_SYMBOL_GPL(iio_store_to_sw_ring);
+int iio_store_to_sw_rb(void *r, u8 *data, s64 timestamp)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	return iio_store_to_sw_ring(ring, data, timestamp);
+}
+EXPORT_SYMBOL(iio_store_to_sw_rb);
+
+int iio_read_last_from_sw_ring(struct iio_sw_ring_buffer *ring,
+			       unsigned char *data)
+{
+	int loopcount_copy;
+	unsigned char *last_written_p_copy;
+
+	iio_mark_sw_rb_in_use(ring);
+again:
+	loopcount_copy = ring->buf.loopcount;
+	barrier();
+	last_written_p_copy = ring->last_written_p;
+	barrier(); /*unnessecary? */
+	/* Check there is anything here */
+	if (last_written_p_copy == 0)
+		return -EAGAIN;
+	memcpy(data, last_written_p_copy, ring->buf.bpd);
+
+	if (unlikely(loopcount_copy != ring->buf.loopcount)) {
+		if (unlikely(ring->last_written_p >= last_written_p_copy))
+			goto again;
+	}
+	iio_unmark_sw_rb_in_use(ring);
+	return 0;
+}
+
+int iio_read_last_from_sw_rb(void *r,
+			     unsigned char *data)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	return iio_read_last_from_sw_ring(ring, data);
+}
+EXPORT_SYMBOL(iio_read_last_from_sw_rb);
+
+int iio_create_sw_rb(void **r)
+{
+	*r = kzalloc(sizeof(struct iio_sw_ring_buffer), GFP_KERNEL);
+	return *r ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL(iio_create_sw_rb);
+
+int iio_init_sw_rb(void *r, void *indio_dev)
+{
+	return 0;
+}
+EXPORT_SYMBOL(iio_init_sw_rb);
+
+void iio_exit_sw_rb(void *r)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	__iio_free_sw_ring_buffer(ring);
+
+}
+EXPORT_SYMBOL(iio_exit_sw_rb);
+
+
+void iio_free_sw_rb(void *r)
+{
+	kfree(r);
+}
+EXPORT_SYMBOL(iio_free_sw_rb);
+
+int iio_request_update_sw_rb(void *r)
+{
+	int ret;
+	struct iio_sw_ring_buffer *ring = r;
+
+	spin_lock(&ring->use_lock);
+	if (ring->use_count || !ring->update_needed) {
+		ret = -EAGAIN;
+		goto error_ret;
+	}
+	__iio_free_sw_ring_buffer(ring);
+	ret = __iio_init_sw_ring_buffer(ring, ring->buf.bpd, ring->buf.length);
+error_ret:
+	spin_unlock(&ring->use_lock);
+	return ret;
+}
+EXPORT_SYMBOL(iio_request_update_sw_rb);
+
+int iio_get_bpd_sw_rb(void *r)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	return ring->buf.bpd;
+}
+EXPORT_SYMBOL(iio_get_bpd_sw_rb);
+
+int iio_set_bpd_sw_rb(void *r, size_t bpd)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	if (ring->buf.bpd != bpd) {
+		ring->buf.bpd = bpd;
+		if(ring->buf.ring_access->mark_param_change)
+			ring->buf.ring_access->mark_param_change(r);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iio_set_bpd_sw_rb);
+
+int iio_get_length_sw_rb(void *r)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	return ring->buf.length;
+}
+EXPORT_SYMBOL(iio_get_length_sw_rb);
+
+int iio_set_length_sw_rb(void *r, int length)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	if(ring->buf.length != length) {
+		ring->buf.length = length;
+		if(ring->buf.ring_access->mark_param_change)
+			ring->buf.ring_access->mark_param_change(r);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iio_set_length_sw_rb);
+
+int iio_mark_update_needed_sw_rb(void *r)
+{
+	struct iio_sw_ring_buffer *ring = r;
+	ring->update_needed = true;
+	return 0;
+}
+EXPORT_SYMBOL(iio_mark_update_needed_sw_rb);
+
+/* no init or exit as this is basically a library module */
+
+MODULE_DESCRIPTION("Industrialio I/O software ring buffer");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/industrialio/ring_sw.h b/include/linux/industrialio/ring_sw.h
new file mode 100644
index 0000000..0b85b56
--- /dev/null
+++ b/include/linux/industrialio/ring_sw.h
@@ -0,0 +1,183 @@
+/* The industrial I/O simple minimally locked ring buffer.
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This code is deliberately kept separate from the main industrialio I/O core
+ * as it is intended that in the future a number of different software ring
+ * buffer implementations will exist with different characteristics to suit
+ * different applications.
+ *
+ * This particular one was designed for a data capture application where it was
+ * particularly important that no userspace reads would interrupt the capture
+ * process. To this end the ring is not locked during a read.
+ *
+ * Comments on this buffer design welcomed. It's far from efficient and some of
+ * my understanding of the effects of scheduling on this are somewhat limited.
+ * Frankly, to my mind, this is the current weak point in the industrial I/O
+ * patch set.
+ */
+
+#ifndef _IIO_RING_SW_H_
+#define _IIO_RING_SW_H_
+/* NEEDS COMMENTS */
+/* The intention is that this should be a separate module from the iio core.
+ * This is a bit like supporting algorithms dependent on what the device
+ * driver requests - some may support multiple options */
+
+
+#include <linux/autoconf.h>
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/ring_generic.h>
+
+#if defined CONFIG_IIO_SW_RING || defined CONFIG_IIO_SW_RING_MODULE
+
+/**
+ * iio_create_sw_rb() software ring buffer allocation
+ * @r:		pointer to ring buffer pointer
+ **/
+int iio_create_sw_rb(void **r);
+
+/**
+ * iio_init_sw_rb() initialize the software ring buffer
+ * @r:		pointer to a software ring buffer created by an
+ *		iio_create_sw_rb call.
+ **/
+int iio_init_sw_rb(void *r, void *indio_dev);
+/**
+ * iio_exit_sw_rb() reverse what was done in iio_init_sw_rb
+ **/
+void iio_exit_sw_rb(void *r);
+
+/**
+ * iio_free_sw_rb() free memory occupied by the core ring buffer struct
+ **/
+void iio_free_sw_rb(void *r);
+
+/**
+ * iio_mark_sw_rb_in_use() reference counting to prevent incorrect chances
+ **/
+void iio_mark_sw_rb_in_use(void *r);
+
+/**
+ *  iio_unmark_sw_rb_in_use() notify the ring buffer that we don't care anymore
+ **/
+void iio_unmark_sw_rb_in_use(void *r);
+
+/**
+ * iio_read_last_from_sw_rb() attempt to read the last stored datum from the rb
+ **/
+int iio_read_last_from_sw_rb(void *r, u8 *data);
+
+/**
+ * iio_store_to_sw_rb() store a new datum to the ring buffer
+ * @rb:	pointer to ring buffer instance
+ * @data:	the datum to be stored including timestamp if relevant.
+ * @timestamp:	timestamp which will be attached to buffer events if relevant.
+ **/
+int iio_store_to_sw_rb(void *rb, u8 *data, s64 timestamp);
+
+/**
+ * iio_rip_sw_rb() attempt to read data from the ring buffer
+ * @r:			ring buffer instance
+ * @count:		number of datum's to try and read
+ * @data:		where the data will be stored.
+ * @dead_offset:	how much of the stored data was possibly invalidated by
+ *			the end of the copy.
+ **/
+int iio_rip_sw_rb(void *r, size_t count, u8 **data, int *dead_offset);
+
+/**
+ * iio_request_update_sw_rb() update params if update needed
+ **/
+int iio_request_update_sw_rb(void *r);
+
+/**
+ * iio_mark_update_needed_sw_rb() tell the ring buffer it needs a param update
+ **/
+int iio_mark_update_needed_sw_rb(void *r);
+
+
+/**
+ * iio_get_bpd_sw_rb() get the datum size in bytes
+ **/
+int iio_get_bpd_sw_rb(void *r);
+
+/**
+ * iio_set_bpd_sw_rb() set the datum size in bytes
+ **/
+int iio_set_bpd_sw_rb(void *r, size_t bpd);
+
+/**
+ * iio_get_length_sw_rb() get how many datums the rb may contain
+ **/
+int iio_get_length_sw_rb(void *r);
+
+/**
+ * iio_set_length_sw_rb() set how many datums the rb may contain
+ **/
+int iio_set_length_sw_rb(void *r, int length);
+
+/**
+ * iio_ring_sw_register_funcs() helper function to set up rb access
+ **/
+static inline void iio_ring_sw_register_funcs(struct iio_ring_access_funcs *ra)
+{
+	ra->_create = &iio_create_sw_rb;
+	ra->_free = &iio_free_sw_rb;
+	ra->_init = &iio_init_sw_rb;
+	ra->_exit = &iio_exit_sw_rb;
+
+	ra->mark_in_use = &iio_mark_sw_rb_in_use;
+	ra->unmark_in_use = &iio_unmark_sw_rb_in_use;
+
+	ra->store_to = &iio_store_to_sw_rb;
+	ra->read_last = &iio_read_last_from_sw_rb;
+	ra->rip_lots = &iio_rip_sw_rb;
+
+	ra->mark_param_change = &iio_mark_update_needed_sw_rb;
+	ra->request_update = &iio_request_update_sw_rb;
+
+	ra->get_bpd = &iio_get_bpd_sw_rb;
+	ra->set_bpd = &iio_set_bpd_sw_rb;
+
+	ra->get_length = &iio_get_length_sw_rb;
+	ra->set_length = &iio_set_length_sw_rb;
+};
+
+/**
+ * struct iio_sw_ring_buffer - software ring buffer
+ * @buf:		generic ring buffer elements
+ * @data:		the ring buffer memory
+ * @read_p:		read pointer (oldest available)
+ * @write_p:		write pointer
+ * @last_written_p:	read pointer (newest available)
+ * @half_p:		half buffer length behind write_p (event generation)
+ * @use_count:		reference count to prevent resizing when in use
+ * @update_needed:	flag to indicated change in size requested
+ * @use_lock:		lock to prevent change in size when in use
+ *
+ * Note that the first element of all ring buffers must be a
+ * struct iio_ring_buffer.
+**/
+
+struct iio_sw_ring_buffer {
+	struct iio_ring_buffer buf;
+	unsigned char		*data;
+	unsigned char		*read_p;
+	unsigned char		*write_p;
+	unsigned char		*last_written_p;
+	/* used to act as a point at which to signal an event */
+	unsigned char		*half_p;
+	int			use_count;
+	int			update_needed;
+	spinlock_t		use_lock;
+};
+#else /* CONFIG_IIO_RING_BUFFER*/
+static inline void iio_ring_sw_register_funcs(struct iio_ring_access_funcs *ra)
+{};
+#endif /* !CONFIG_IIO_RING_BUFFER */
+#endif /* _IIO_RING_SW_H_ */
