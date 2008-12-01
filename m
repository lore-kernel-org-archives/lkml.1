Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYLAOZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYLAOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYLAOZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:25:19 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:51289 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYLAOZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:25:16 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F3C9.1090704@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:25:13 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [2/13] RFC: IIO ring buffer support (core)
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

The Industrial I/O core - ring buffer support

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

--
This patch adds ring buffer support to the industrial I/O subsystem
core. This functionality may be disabled when not desired.

The support is designed to be generic enough to allow multiple
software implementations. At the moment only one is available so
the functionality for run time or board conf based selection has
not yet been implemented.

The framework also allows for hardware ring buffers existing on the
actual chip. An example of this usage is the VTI sca3000 driver found
later in this patch set.

 drivers/industrialio/Kconfig              |    7
 drivers/industrialio/Makefile             |    1
 drivers/industrialio/industrialio-ring.c  |  491 ++++++++++++++++++++++++++++++
 include/linux/industrialio/ring_generic.h |  123 +++++++
 4 files changed, 622 insertions(+)


diff --git a/drivers/industrialio/Kconfig b/drivers/industrialio/Kconfig
index 433f777..d132ab6 100644
--- a/drivers/industrialio/Kconfig
+++ b/drivers/industrialio/Kconfig
@@ -10,3 +10,10 @@ menuconfig INDUSTRIALIO
 	  number of different physical interfaces (i2c, spi etc). See
 	  Documentation/industrialio for more information.
 
+config IIO_RING_BUFFER
+       bool "Enable ring buffer support within iio"
+	  depends on INDUSTRIALIO
+	  help
+	    Provide support for various ring buffer based data
+	    acquisition methods.
+
diff --git a/drivers/industrialio/Makefile b/drivers/industrialio/Makefile
index 1acd8fa..1f47af3 100644
--- a/drivers/industrialio/Makefile
+++ b/drivers/industrialio/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_INDUSTRIALIO)	+= industrialio.o
 industrialio-y := industrialio-core.o
+industrialio-$(CONFIG_IIO_RING_BUFFER) += industrialio-ring.o
diff --git a/drivers/industrialio/industrialio-ring.c b/drivers/industrialio/industrialio-ring.c
new file mode 100644
index 0000000..04a8cb1
--- /dev/null
+++ b/drivers/industrialio/industrialio-ring.c
@@ -0,0 +1,491 @@
+/* The industrial I/O core
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Handling of ring allocation / resizing.
+ *
+ *
+ * Things to look at here.
+ * - Better memory allocation techniques?
+ * - Alternative access techniques?
+ */
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/module.h>
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/ring_generic.h>
+
+/* Allow for 3 digit id */
+#define IIO_RING_AC_MINOR_N_LEN 22
+#define IIO_RING_AC_MINOR_N "ring_buf%d_acc_minor"
+#define IIO_RING_EV_MINOR_N_LEN 21
+#define IIO_RING_EV_MINOR_N "ring_buf%d_ev_minor"
+
+int iio_push_ring_event(struct iio_ring_buffer *ring_buf,
+		       int event_code,
+		       s64 timestamp)
+{
+	return __iio_push_event(&ring_buf->ev_int,
+			       event_code,
+			       timestamp,
+			       &ring_buf->shared_ev_pointer);
+}
+EXPORT_SYMBOL(iio_push_ring_event);
+
+int iio_push_or_escallate_ring_event(struct iio_ring_buffer *ring_buf,
+				    int event_code,
+				    s64 timestamp)
+{
+	if (ring_buf->shared_ev_pointer.ev_p)
+		__iio_change_event(ring_buf->shared_ev_pointer.ev_p,
+				   event_code,
+				   timestamp);
+	else
+		return iio_push_ring_event(ring_buf,
+					  event_code,
+					  timestamp);
+	return 0;
+}
+EXPORT_SYMBOL(iio_push_or_escallate_ring_event);
+
+/**
+ * iio_ring_open() chrdev file open for ring buffer access
+ *
+ * This function relies on all ring buffer implementations having an
+ * iio_ring_buffer as their first element.
+ **/
+int iio_ring_open(struct inode *inode, struct file *filp)
+{
+	void *r = filp->private_data;
+	struct iio_ring_buffer *rb = r;
+
+	if (rb->ring_access->mark_in_use)
+		rb->ring_access->mark_in_use(r);
+	try_module_get(rb->access_minor_attr.dev_attr.attr.owner);
+
+	return 0;
+}
+
+/**
+ * iio_ring_release() chrdev file close ring buffer access
+ *
+ * This function relies on all ring buffer implementations having an
+ * iio_ring_buffer as their first element.
+ **/
+int iio_ring_release(struct inode *inode, struct file *filp)
+{
+	void *r = filp->private_data;
+	struct iio_ring_buffer *rb = r;
+
+	module_put(rb->access_minor_attr.dev_attr.attr.owner);
+	clear_bit(IIO_BUSY_BIT_POS, &rb->access_handler.flags);
+	if (rb->ring_access->unmark_in_use)
+		rb->ring_access->unmark_in_use(r);
+
+	return 0;
+}
+
+/**
+ * iio_ring_rip_outer() chrdev read for ring buffer access
+ *
+ * This function relies on all ring buffer implementations having an
+ * iio_ring _bufer as their first element.
+ **/
+ssize_t iio_ring_rip_outer(struct file *filp,
+			   char *buf,
+			   size_t count,
+			   loff_t *f_ps)
+{
+	void *r = filp->private_data;
+	struct iio_ring_buffer *rb = r;
+	int ret, dead_offset, copied;
+	u8 *data;
+	/* rip lots must exist. */
+	if (!rb->ring_access->rip_lots)
+		return -EINVAL;
+	copied = rb->ring_access->rip_lots(r, count, &data, &dead_offset);
+	if (copied < 0) {
+		ret = copied;
+		goto error_ret;
+	}
+	if (copy_to_user(buf, data + dead_offset, copied))  {
+		ret =  -EFAULT;
+		goto error_free_data_cpy;
+	}
+	/* In clever ring buffer designs this may not need to be freed.
+	 * When such a design exists I'll add this to ring access funcs. */
+	kfree(data);
+
+	return copied;
+
+error_free_data_cpy:
+	kfree(data);
+error_ret:
+	return ret;
+}
+
+static const struct file_operations iio_ring_fileops = {
+	.read = iio_ring_rip_outer,
+	.release = iio_ring_release,
+	.open = iio_ring_open,
+	.owner = THIS_MODULE,
+};
+
+/**
+ * __iio_request_ring_buffer_event_chrdev() allocate ring event chrdev
+ * @buf:	ring buffer whose event chrdev we are allocating
+ * @owner:	the module who owns the ring buffer (for ref counting)
+ * @dev:	device with which the chrdev is associated
+ **/
+static inline int
+__iio_request_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
+				       int id,
+				       struct module *owner,
+				       struct device *dev)
+{
+	int ret;
+
+	buf->event_minor_name = kmalloc(IIO_RING_EV_MINOR_N_LEN, GFP_KERNEL);
+	if (buf->event_minor_name == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	sprintf(buf->event_minor_name, IIO_RING_EV_MINOR_N, id);
+	ret = iio_setup_ev_int(&(buf->ev_int),
+			       (const char *)(buf->event_minor_name),
+			       owner,
+			       dev);
+	if (ret)
+		goto error_free_event_minor_name;
+
+	return 0;
+
+error_free_event_minor_name:
+	kfree(buf->event_minor_name);
+error_ret:
+	return ret;
+}
+
+static inline void
+__iio_free_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
+				    struct device *dev)
+{
+	iio_free_ev_int(&(buf->ev_int), dev);
+	kfree(buf->event_minor_name);
+}
+
+static inline int
+__iio_request_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
+					int id,
+					struct module *owner,
+					struct device *dev,
+					const struct file_operations *fops)
+{
+	int ret;
+/* Create and register the access character device */
+	buf->access_minor_name = kmalloc(IIO_RING_AC_MINOR_N_LEN,
+					 GFP_KERNEL);
+	if (buf->access_minor_name == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	sprintf(buf->access_minor_name, IIO_RING_AC_MINOR_N, id);
+
+	ret = iio_allocate_chrdev(&buf->access_handler);
+	if (ret)
+		goto error_free_access_minor_name;
+	buf->access_handler.fops = fops;
+	buf->access_handler.flags = 0;
+
+	__init_iio_chrdev_minor_attr(&buf->access_minor_attr,
+				   (const char *)(buf->access_minor_name),
+				   owner,
+				   buf->access_handler.id);
+
+	ret = sysfs_create_file(&dev->kobj,
+				&(buf->access_minor_attr.dev_attr.attr));
+	if (ret)
+		goto error_deallocate_chrdev;
+	return 0;
+
+error_deallocate_chrdev:
+	iio_deallocate_chrdev(&buf->access_handler);
+error_free_access_minor_name:
+	kfree(buf->access_minor_name);
+error_ret:
+	return ret;
+}
+
+static inline void
+__iio_free_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
+				     struct device *dev)
+{
+	sysfs_remove_file(&dev->kobj,
+			  &buf->access_minor_attr.dev_attr.attr);
+	iio_deallocate_chrdev(&buf->access_handler);
+	kfree(buf->access_minor_name);
+}
+
+static int iio_request_ring_buffer(struct iio_dev *dev_info,
+				   int id,
+				   struct module *owner,
+				   struct device *dev)
+{
+	int ret;
+	struct iio_ring_buffer *rb;
+	ret = dev_info->ring_access._create(&dev_info->ring);
+	if (ret)
+		goto error_ret;
+	rb = dev_info->ring;
+	/* Not ideal */
+	rb->ring_access = &dev_info->ring_access;
+	/* Initially mark for update of ring parameters */
+	if (dev_info->ring_access.mark_param_change)
+		dev_info->ring_access.mark_param_change(dev_info->ring);
+
+	ret = __iio_request_ring_buffer_event_chrdev(rb,
+						     id,
+						     owner,
+						     dev_info->sysfs_dev);
+	if (ret)
+		goto error_free_ring;
+
+	ret = __iio_request_ring_buffer_access_chrdev(rb,
+						      id,
+						      owner,
+						      dev_info->sysfs_dev,
+						      &iio_ring_fileops);
+	if (ret)
+		goto error_free_ring_buffer_event_chrdev;
+
+	rb->ev_int.private = rb;
+	rb->access_handler.private = rb;
+
+	return 0;
+error_free_ring_buffer_event_chrdev:
+	__iio_free_ring_buffer_event_chrdev(rb, dev_info->sysfs_dev);
+error_free_ring:
+	if (dev_info->ring_access._free)
+		dev_info->ring_access._free(dev_info->ring);
+error_ret:
+	return ret;
+}
+
+static void iio_unrequest_ring_buffer(struct iio_dev *dev_info)
+{
+
+	__iio_free_ring_buffer_event_chrdev(dev_info->ring, dev_info->dev);
+	if (dev_info->ring_access._free)
+		dev_info->ring_access._free(dev_info->ring);
+}
+
+static ssize_t iio_read_ring_length(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	int len = 0;
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+
+	if (dev_info->ring_access.get_length)
+		len = sprintf(buf, "%d\n",
+			      dev_info->ring_access.get_length(dev_info->ring));
+
+	return len;
+}
+
+static ssize_t iio_write_ring_length(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf,
+					      size_t len)
+{
+	int ret;
+	ulong val;
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct iio_ring_access_funcs *ra = &dev_info->ring_access;
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (dev_info->ring_access.get_length)
+		if (val == ra->get_length(dev_info->ring))
+			return len;
+
+	if (ra->set_length) {
+		ra->set_length(dev_info->ring, val);
+		if (ra->mark_param_change)
+			ra->mark_param_change(dev_info->ring);
+	}
+
+	return len;
+}
+
+static ssize_t iio_read_ring_bps(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	int len = 0;
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct iio_ring_access_funcs *ra = &dev_info->ring_access;
+
+	if (ra->get_bpd)
+		len = sprintf(buf, "%d\n",
+			      ra->get_bpd(dev_info->ring));
+
+	return len;
+}
+
+
+static DEVICE_ATTR(length, S_IRUGO | S_IWUSR,
+	    iio_read_ring_length,
+	    iio_write_ring_length);
+/* The software ring buffers aren't currently capable of changing the
+ * storage accuracy so this is read only. Note bps can change due to
+ * scan mode changes.
+ */
+static DEVICE_ATTR(bps, S_IRUGO, iio_read_ring_bps, NULL);
+
+static ssize_t iio_store_ring_enable(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf,
+				     size_t len)
+{
+	int ret;
+	bool requested_state, current_state;
+	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct iio_ring_access_funcs *ra = &dev_info->ring_access;
+
+	mutex_lock(&dev_info->mlock);
+	requested_state = (buf[0] == '0') ? 0 : 1;
+	current_state = !!(dev_info->currentmode & INDIO_ALL_RING_MODES);
+	if (current_state == requested_state)
+		goto done;
+	if (requested_state) {
+		if (dev_info->ring_preenable) {
+			ret = dev_info->ring_preenable(dev_info);
+			if (ret)
+				goto error_ret;
+		}
+		if (ra->request_update) {
+			ret = ra->request_update(dev_info->ring);
+			if (ret)
+				goto error_ret;
+		}
+		if (ra->mark_in_use)
+			ra->mark_in_use(dev_info->ring);
+		/* Definitely possible for devices to support both of these.*/
+		if (dev_info->modes & INDIO_RING_TRIGGERED)
+			dev_info->currentmode = INDIO_RING_TRIGGERED;
+		else if (dev_info->modes & INDIO_RING_HARDWARE_BUFFER)
+			dev_info->currentmode = INDIO_RING_HARDWARE_BUFFER;
+		else { /* should never be reached */
+			ret = -EINVAL;
+			goto error_ret;
+		}
+
+		if (dev_info->ring_postenable) {
+			ret = dev_info->ring_postenable(dev_info);
+			if (ret)
+				goto error_ret;
+		}
+	} else {
+		if (dev_info->ring_predisable) {
+			ret = dev_info->ring_predisable(dev_info);
+			if (ret)
+				goto error_ret;
+		}
+		if (ra->unmark_in_use)
+			ra->unmark_in_use(dev_info->ring);
+		dev_info->currentmode = INDIO_DIRECT_MODE;
+		if (dev_info->ring_postdisable) {
+			ret = dev_info->ring_postdisable(dev_info);
+			if (ret)
+				goto error_ret;
+		}
+	}
+done:
+	mutex_unlock(&dev_info->mlock);
+	return len;
+
+error_ret:
+	mutex_unlock(&dev_info->mlock);
+	return ret;
+}
+
+static ssize_t iio_show_ring_enable(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", !!(indio_dev->currentmode
+				       & INDIO_ALL_RING_MODES));
+}
+
+DEVICE_ATTR(ring_enable, S_IRUGO | S_IWUSR,
+	    iio_show_ring_enable,
+	    iio_store_ring_enable);
+
+/* Standard set of ring buffer attributes */
+static struct attribute *iio_ring_attributes[] = {
+	&dev_attr_length.attr,
+	&dev_attr_bps.attr,
+	&dev_attr_ring_enable.attr,
+	NULL,
+};
+
+static const struct attribute_group iio_ring_attribute_group = {
+	.name = "ring_buffer",
+	.attrs = iio_ring_attributes,
+};
+
+int iio_device_register_ring(struct iio_dev *dev_info, int id)
+{
+	int ret = 0;
+	struct iio_ring_access_funcs *ra = &dev_info->ring_access;
+
+	ret = iio_request_ring_buffer(dev_info, id, dev_info->driver_module,
+				      dev_info->dev);
+	if (ret)
+		goto error_ret;
+	if (ra->_init) {
+		ret = ra->_init(dev_info->ring, dev_info);
+		if (ret)
+			goto error_unrequest_ring;
+	}
+	ret = sysfs_create_group(&dev_info->sysfs_dev->kobj,
+				 &iio_ring_attribute_group);
+	if (ret)
+		goto error_exit_ring;
+
+	return 0;
+
+error_exit_ring:
+	if (ra->_exit)
+		ra->_exit(dev_info->ring);
+error_unrequest_ring:
+	iio_unrequest_ring_buffer(dev_info);
+error_ret:
+	return ret;
+}
+
+void iio_device_unregister_ring(struct iio_dev *dev_info)
+{
+	struct iio_ring_access_funcs *ra = &dev_info->ring_access;
+	struct iio_ring_buffer *rb = dev_info->ring;;
+	if (dev_info->ring) {
+		sysfs_remove_group(&dev_info->sysfs_dev->kobj,
+				   &iio_ring_attribute_group);
+		__iio_free_ring_buffer_access_chrdev(rb, dev_info->sysfs_dev);
+		__iio_free_ring_buffer_event_chrdev(rb, dev_info->sysfs_dev);
+		if (ra->_exit)
+			ra->_exit(dev_info->ring);
+		iio_unrequest_ring_buffer(dev_info);
+	}
+}
diff --git a/include/linux/industrialio/ring_generic.h b/include/linux/industrialio/ring_generic.h
index 6daff14..cbbce58 100644
--- a/include/linux/industrialio/ring_generic.h
+++ b/include/linux/industrialio/ring_generic.h
@@ -15,6 +15,129 @@
 struct iio_ring_buffer;
 
 #ifdef CONFIG_IIO_RING_BUFFER
+
+/**
+ * iio_push_ring_event() - ring buffer specific push to event chrdev
+ * @ring_buf:		ring buffer that is the event source
+ * @event_code:		event indentification code
+ * @timestamp:		time of event
+ **/
+int iio_push_ring_event(struct iio_ring_buffer *ring_buf,
+			int event_code,
+			s64 timestamp);
+/**
+ * iio_push_or_escallate_ring_event() -	escallate or add as appropriate
+ *
+ * Typical usecase is to escallate a 50% ring full to 75% full if noone has yet
+ * read the first event. Clearly the 50% full is no longer of interest in
+ * typical use case.
+ **/
+int iio_push_or_escallate_ring_event(struct iio_ring_buffer *ring_buf,
+				     int event_code,
+				     s64 timestamp);
+
+/**
+ * struct iio_ring_access_funcs - access functions for ring buffers.
+ * @create:		perform allocation
+ * @init:		get ring buffer ready for use
+ * @_exit:		reverse steps in init
+ * @_free:		deallocate ring buffer
+ * @mark_in_use:	reference counting, typically to prevent module removal
+ * @unmark_in_use:	reduce reference count when no longer using ring buffer
+ * @store_to:		actually store stuff to the ring buffer
+ * @read_last:		get the last element stored
+ * @rip_lots:		try to get a specified number of elements (must exist)
+ * @mark_param_change:	notify ring that some relevant parameter has changed
+ *			Often this means the underlying storage may need to
+ *			change.
+ * @request_update:	if a parameter change has been marked, update underlying
+ *			storage.
+ * @get_bpd:		get current bytes per datum
+ * @set_bpd:		set number of bytes per datum
+ * @get_length:		get number of datums in ring
+ * @set_length:		set number of datums in ring
+ * @is_enabled:		query if ring is currently being used
+ * @enable:		enable the ring
+ *
+ * The purpose of this structure is to make the ring buffer element
+ * modular as event for a given driver, different usecases may require
+ * different ring designs (space efficiency vs speed for example.
+ *
+ * It is worth noting that a given ring implementation may only support a small
+ * proportion of these functions.  The core code 'should' cope fine with any of
+ * them not existing.
+ **/
+struct iio_ring_access_funcs {
+	int (*_create)(void **ring);
+	int (*_init)(void *ring, void *indio_dev);
+	void (*_exit)(void *ring);
+	void (*_free)(void *ring);
+
+	void (*mark_in_use)(void *ring);
+	void (*unmark_in_use)(void *ring);
+
+	int (*store_to)(void *ring, u8 *data, s64 timestamp);
+	int (*read_last)(void *ring, u8 *data);
+	int (*rip_lots)(void *ring, size_t count, u8 **data, int *dead_offset);
+
+	int (*mark_param_change)(void *ring);
+	int (*request_update)(void *ring);
+
+	int (*get_bpd)(void *ring);
+	int (*set_bpd)(void *ring, size_t bpd);
+	int (*get_length)(void *ring);
+	int (*set_length)(void *ring, int length);
+
+	int (*is_enabled)(void *ring);
+	int (*enable)(void *ring);
+};
+
+/**
+ * struct iio_ring_buffer - general ring buffer structure
+ * @length:		[DEVICE]number of datums in ring
+ * @bpd:		[DEVICE]size of individual datum including timestamp
+ * @loopcount:		[INTERN]number of times the ring has looped
+ * @access_minor_name:	[INTERN]store of name of the access chrdev minor number
+ *			sysfs attribute
+ * @access_handler:	[INTERN]chrdev access handling
+ * @event_minor_name:	[INTERN]store of name of the event chrdev minor number
+ *			sysfs attribute
+ * @ev_int:		[INTERN]chrdev interface for the event chrdev
+ * @shared_ev_pointer:	[INTERN]the shared event pointer to allow escalation of
+ *			events
+ * @ring_access:	[DRIVER]ring access functions associated with the
+ *			implementation.
+ *
+ * This structure must be the first element in any ring buffer implementation
+ * structure as they must be castable to this.
+ **/
+struct iio_ring_buffer {
+	int				length;
+	int				bpd;
+	int				loopcount;
+	char				*access_minor_name;
+	struct iio_chrdev_minor_attr	access_minor_attr;
+	struct iio_handler		access_handler;
+	char				*event_minor_name;
+	struct iio_event_interface	ev_int;
+	struct iio_shared_ev_pointer	shared_ev_pointer;
+	struct iio_ring_access_funcs    *ring_access;
+};
+
+/**
+ * __iio_init_ring_buffer() - initialize common elements of ring buffers.
+ **/
+static inline void __iio_init_ring_buffer(struct iio_ring_buffer *ring,
+				 int bytes_per_datum, int length)
+{
+	ring->bpd = bytes_per_datum;
+	ring->length = length;
+	ring->loopcount = 0;
+	ring->shared_ev_pointer.ev_p = 0;
+	ring->shared_ev_pointer.lock =
+		__SPIN_LOCK_UNLOCKED(ring->shared_ev_pointer->loc);
+}
+
 #else
 
 struct iio_ring_buffer {};
