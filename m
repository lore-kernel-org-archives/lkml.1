Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYLAOXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYLAOXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYLAOXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:23:43 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:39493 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYLAOXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:23:40 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F366.7010205@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:23:34 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [1/13] RFC: IIO core functionality
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

The Industrial I/O core functionality.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--

This patch contains the core functionality of the industrial I/O (IIO)
subsystem. This handling of sysfs registration of devices and
allocation of such things as character devices + the handling of
any access to the major device number associated with IIO.

Principle changes since the last version are concerned with making
this considerably more modular so as to make the subsystem more
adaptable and hopefuly easier to review.

If this component is used with a driver then the available
functionality is limited to sysfs access to readings and control
along with chrdev based event interfaces to transmit hardware
events (typically interrupts) to userspace programs.

Whilst this may seem overly complex, it as pretty much as simple
as I can manage whilst keeping it fairly adaptable.  All
suggestions for simplifications particularly welcome.

 drivers/Kconfig                           |    2
 drivers/Makefile                          |    1
 drivers/industrialio/Kconfig              |   12
 drivers/industrialio/Makefile             |    6
 drivers/industrialio/industrialio-core.c  |  907 ++++++++++++++++++++++++++++++
 include/linux/industrialio/chrdev.h       |   91 +++
 include/linux/industrialio/iio.h          |  440 ++++++++++++++
 include/linux/industrialio/ring_generic.h |   24
 include/linux/industrialio/sysfs.h        |  284 +++++++++
 include/linux/industrialio/trigger.h      |   68 ++
 10 files changed, 1835 insertions(+)

diff --git a/drivers/industrialio/industrialio-core.c b/drivers/industrialio/industrialio-core.c
new file mode 100644
index 0000000..88ad39d
--- /dev/null
+++ b/drivers/industrialio/industrialio-core.c
@@ -0,0 +1,907 @@
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
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/trigger.h>
+
+#define IIO_ID_PREFIX "iio:device"
+#define IIO_ID_FORMAT IIO_ID_PREFIX "%d"
+
+/* Temporary - I'll request one when we are near submission*/
+#define IIO_MAJOR 244
+
+/* Integer id  - used to assign each registered device a unique id*/
+static DEFINE_IDR(iio_idr);
+static DEFINE_SPINLOCK(iio_idr_lock);
+
+struct class iio_class = {
+	.name = "industrialio",
+};
+
+/**
+ * struct __iio_state - internal iio subsystem state information.
+ * @fhs:	file operations for the various chrdevs. These are
+ *		all intially set to null in init.
+ **/
+struct __iio_state {
+	struct iio_handler *fhs[256];
+};
+
+static struct __iio_state iio_state;
+static DEFINE_SPINLOCK(iio_state_lock);
+
+ssize_t iio_scan_el_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_scan_el *this_el = to_iio_scan_el(attr);
+
+	return sprintf(buf, "%d\n",
+		       !!(indio_dev->scan_mask & this_el->mask));
+}
+EXPORT_SYMBOL(iio_scan_el_show);
+
+ssize_t iio_scan_el_store(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf,
+			  size_t len)
+{
+	int ret = 0;
+	bool state;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_scan_el *this_el = to_iio_scan_el(attr);
+
+	state = !(buf[0] == '0');
+	mutex_lock(&indio_dev->mlock);
+	if (indio_dev->currentmode == INDIO_RING_TRIGGERED) {
+		ret = -EBUSY;
+		goto error_ret;
+	}
+
+	if (!state && (indio_dev->scan_mask & this_el->mask)) {
+		indio_dev->scan_mask &= ~this_el->mask;
+		indio_dev->scan_count--;
+	} else if (state && !(indio_dev->scan_mask & this_el->mask)) {
+		indio_dev->scan_mask |= this_el->mask;
+		indio_dev->scan_count++;
+	}
+	if (this_el->set_state)
+		ret = this_el->set_state(this_el, indio_dev, state);
+error_ret:
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret ? ret : len;
+
+}
+EXPORT_SYMBOL(iio_scan_el_store);
+
+ssize_t iio_scan_el_ts_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", indio_dev->scan_timestamp);
+}
+EXPORT_SYMBOL(iio_scan_el_ts_show);
+
+ssize_t iio_scan_el_ts_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf,
+			     size_t len)
+{
+	int ret = 0;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	bool state;
+	state = !(buf[0] == '0');
+	mutex_lock(&indio_dev->mlock);
+	if (indio_dev->currentmode == INDIO_RING_TRIGGERED) {
+		ret = -EBUSY;
+		goto error_ret;
+	}
+	indio_dev->scan_timestamp = state;
+error_ret:
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret ? ret : len;
+}
+EXPORT_SYMBOL(iio_scan_el_ts_store);
+
+/* TODO Check if these need locking */
+void __iio_change_event(struct iio_detected_event_list *ev,
+			int ev_code,
+			s64 timestamp)
+{
+	ev->ev.id = ev_code;
+	ev->ev.timestamp = timestamp;
+}
+EXPORT_SYMBOL(__iio_change_event);
+
+/* Used both in the interrupt line put events and the ring buffer ones */
+
+/* Note that in it's current form someone has to be listening before events
+ * are queued. Hence a client MUST open the chrdev before the ring buffer is
+ * switched on.
+ */
+ int __iio_push_event(struct iio_event_interface *ev_int,
+		     int ev_code,
+		     s64 timestamp,
+		     struct iio_shared_ev_pointer*
+		     shared_pointer_p)
+{
+	struct iio_detected_event_list *ev;
+	int ret = 0;
+
+	/* Does anyone care? */
+	if (test_bit(IIO_BUSY_BIT_POS, &ev_int->handler.flags)) {
+		if (ev_int->current_events == ev_int->max_events)
+			return 0;
+		ev = kmalloc(sizeof(struct iio_detected_event_list),
+			     GFP_KERNEL);
+		if (ev == NULL) {
+			ret = -ENOMEM;
+			goto error_ret;
+		}
+		ev->ev.id = ev_code;
+		ev->ev.timestamp = timestamp;
+		if (shared_pointer_p != NULL) {
+			ev->shared_pointer = shared_pointer_p;
+			shared_pointer_p->ev_p = ev;
+		} else
+			ev->shared_pointer = NULL;
+
+		mutex_lock(&ev_int->event_list_lock);
+		list_add_tail(&ev->list, &ev_int->det_events.list);
+		mutex_unlock(&ev_int->event_list_lock);
+
+		ev_int->current_events++;
+		wake_up_interruptible(&ev_int->wait);
+	}
+
+error_ret:
+	return ret;
+}
+EXPORT_SYMBOL(__iio_push_event);
+
+int iio_push_event(struct iio_dev *dev_info,
+		   int ev_line,
+		   int ev_code,
+		   s64 timestamp)
+{
+	return __iio_push_event(&dev_info->event_interfaces[ev_line],
+			       ev_code, timestamp, NULL);
+}
+EXPORT_SYMBOL(iio_push_event);
+
+/* Generic interrupt line interrupt handler */
+irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
+{
+	struct iio_interrupt *int_info = _int_info;
+	struct iio_dev *dev_info = int_info->dev_info;
+	struct iio_event_handler_list *p, *q;
+	s64 time_ns;
+	unsigned long flags;
+	spin_lock_irqsave(&int_info->ev_list_lock, flags);
+	if (list_empty(&int_info->ev_list)) {
+		spin_unlock_irqrestore(&int_info->ev_list_lock, flags);
+		return IRQ_NONE;
+	}
+
+
+	time_ns = iio_get_time_ns();
+	/* detect single element list*/
+	if (list_is_singular(&int_info->ev_list)) {
+		disable_irq_nosync(irq);
+		p = list_first_entry(&int_info->ev_list,
+				     struct iio_event_handler_list,
+				     list);
+		/* single event handler - maybe shared */
+		p->handler(dev_info, 1, time_ns, !(p->refcount > 1));
+	} else /* safe against list deletion? */
+		list_for_each_entry_safe(p, q, &int_info->ev_list, list) {
+			disable_irq_nosync(irq);
+			p->handler(dev_info, 1, time_ns, 0);
+		}
+	spin_unlock_irqrestore(&int_info->ev_list_lock, flags);
+	return IRQ_HANDLED;
+}
+
+/* Confirming the validity of supplied irq is left to drivers.*/
+int iio_register_interrupt_line(unsigned int irq,
+				struct iio_dev *dev_info,
+				int line_number,
+				unsigned long type,
+				const char *name)
+{
+	int ret;
+
+	dev_info->interrupts[line_number] =
+		kmalloc(sizeof(struct iio_interrupt), GFP_KERNEL);
+	if (dev_info->interrupts[line_number] == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	printk(KERN_INFO  "initializing interrupt line %d\n", line_number);
+	spin_lock_init(&dev_info->interrupts[line_number]->ev_list_lock);
+	INIT_LIST_HEAD(&dev_info->interrupts[line_number]->ev_list);
+	dev_info->interrupts[line_number]->line_number = line_number;
+	dev_info->interrupts[line_number]->irq = irq;
+	dev_info->interrupts[line_number]->dev_info = dev_info;
+
+	/* Possibly only request on demand?
+	 * Can see this may complicate the handling of interrupts.
+	 * However, with this approach we might end up handling lots of
+	 * events no-one cares about.*/
+	ret = request_irq(irq,
+			  &iio_interrupt_handler,
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
+EXPORT_SYMBOL(iio_register_interrupt_line);
+
+/* This turns up an awful lot */
+ssize_t iio_read_const_attr(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "%s\n", to_iio_const_attr(attr)->string);
+}
+EXPORT_SYMBOL(iio_read_const_attr);
+
+/* Before this runs the interrupt generator must have been disabled */
+void iio_unregister_interrupt_line(struct iio_dev *dev_info,
+					    int line_number)
+{
+	/* make sure the interrupt handlers are all done */
+	flush_scheduled_work();
+	free_irq(dev_info->interrupts[line_number]->irq,
+		 dev_info->interrupts[line_number]);
+	kfree(dev_info->interrupts[line_number]);
+}
+EXPORT_SYMBOL(iio_unregister_interrupt_line);
+
+/* Reference counted add and remove */
+int iio_add_event_to_list(struct iio_event_handler_list *el,
+			  struct list_head *head)
+{
+	struct iio_interrupt *inter
+		= container_of(head, struct iio_interrupt, ev_list);
+	unsigned long flags;
+	/* take mutex to protect this element */
+	mutex_lock(&el->exist_lock);
+	if (el->refcount == 0) {
+		spin_lock_irqsave(&inter->ev_list_lock, flags);
+		/*take spinlock*/
+		list_add(&el->list, head);
+		spin_unlock_irqrestore(&inter->ev_list_lock, flags);
+	}
+	el->refcount++;
+	mutex_unlock(&el->exist_lock);
+	return 0;
+}
+EXPORT_SYMBOL(iio_add_event_to_list);
+
+int iio_remove_event_from_list(struct iio_event_handler_list *el,
+			       struct list_head *head)
+{
+	struct iio_interrupt *inter
+		= container_of(head, struct iio_interrupt, ev_list);
+	unsigned long flags;
+	mutex_lock(&el->exist_lock);
+	el->refcount--;
+	if (el->refcount == 0) {
+		spin_lock_irqsave(&inter->ev_list_lock, flags);
+		/* take spinlock */
+		list_del_init(&el->list);
+		spin_unlock_irqrestore(&inter->ev_list_lock, flags);
+	}
+	mutex_unlock(&el->exist_lock);
+	return 0;
+}
+EXPORT_SYMBOL(iio_remove_event_from_list);
+
+int iio_allocate_chrdev(struct iio_handler *handler)
+{
+	int id;
+
+	spin_lock(&iio_state_lock);
+	for (id = 0; id <= 256; id++)
+		if (iio_state.fhs[id] == NULL)
+			break;
+	if (id == 256) {
+		spin_unlock(&iio_state_lock);
+		return -ENOMEM;
+	}
+	iio_state.fhs[id] = handler;
+	spin_unlock(&iio_state_lock);
+	handler->id = id;
+
+	return 0;
+}
+
+void iio_deallocate_chrdev(struct iio_handler *handler)
+{
+	spin_lock(&iio_state_lock);
+	iio_state.fhs[handler->id] = NULL;
+	spin_unlock(&iio_state_lock);
+}
+
+/* Upon open, switch in the correct file ops.
+ * Lifted directly from input subsystem (more or less)
+ */
+static int iio_open_file(struct inode *inode, struct file *file)
+{
+	struct iio_handler *handler;
+	const struct file_operations *old_fops, *new_fops = NULL;
+	int err;
+
+	/* This lock needed as  we are dynamically allocating chrdevs */
+	spin_lock(&iio_state_lock);
+	handler = iio_state.fhs[iminor(inode)];
+	spin_unlock(&iio_state_lock);
+
+	if (!handler) {
+		fops_put(file->f_op);
+		return -ENODEV;
+	}
+	new_fops = fops_get(handler->fops);
+	if (new_fops == NULL) {
+		fops_put(file->f_op);
+		return -ENODEV;
+	}
+
+	/* cribbed from lp.c */
+	if (test_and_set_bit(IIO_BUSY_BIT_POS, &handler->flags)) {
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
+static const struct file_operations iio_fops = {
+	.owner = THIS_MODULE,
+	.open = iio_open_file,
+};
+
+/* File ops for event character device files */
+ssize_t iio_event_chrdev_read(struct file *filep,
+			      char *buf,
+			      size_t count,
+			      loff_t *f_ps)
+{
+	struct iio_event_interface *ev_int = filep->private_data;
+	struct iio_detected_event_list *el;
+	int ret;
+
+	mutex_lock(&ev_int->event_list_lock);
+	if (list_empty(&ev_int->det_events.list)) {
+		if (filep->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			goto error_mutex_unlock;
+		}
+		mutex_unlock(&ev_int->event_list_lock);
+		/* Blocking on device; waiting for something to be there */
+		ret = wait_event_interruptible(ev_int->wait,
+					       !list_empty(&ev_int
+							   ->det_events.list));
+		if (ret)
+			goto error_ret;
+		/* Single access device so noone else can get the data */
+		mutex_lock(&ev_int->event_list_lock);
+	}
+
+	el = list_first_entry(&ev_int->det_events.list,
+			      struct iio_detected_event_list,
+			      list);
+
+	if (copy_to_user(buf, &(el->ev),
+			 sizeof(struct iio_event_data))) {
+		ret = -EFAULT;
+		goto error_mutex_unlock;
+	}
+
+	list_del(&el->list);
+	ev_int->current_events--;
+	mutex_unlock(&ev_int->event_list_lock);
+
+	spin_lock(&el->shared_pointer->lock);
+	if (el->shared_pointer)
+		(el->shared_pointer->ev_p) = NULL;
+	spin_unlock(&el->shared_pointer->lock);
+
+	kfree(el);
+
+	return sizeof(struct iio_event_data);
+
+error_mutex_unlock:
+	mutex_unlock(&ev_int->event_list_lock);
+error_ret:
+
+	return ret;
+}
+
+int iio_event_chrdev_release(struct inode *inode, struct file *filep)
+{
+	struct iio_event_interface *ev_int = filep->private_data;
+
+	module_put(ev_int->owner);
+	clear_bit(IIO_BUSY_BIT_POS, &ev_int->handler.flags);
+
+	return 0;
+}
+
+int iio_event_chrdev_open(struct inode *inode, struct file *filep)
+{
+	struct iio_event_interface *ev_int = filep->private_data;
+
+	try_module_get(ev_int->owner);
+
+	return 0;
+}
+
+static const struct file_operations iio_event_chrdev_fileops = {
+	.read =  iio_event_chrdev_read,
+	.release = iio_event_chrdev_release,
+	.open = iio_event_chrdev_open,
+	.owner = THIS_MODULE,
+};
+
+ssize_t iio_show_attr_minor(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct iio_chrdev_minor_attr *_attr
+		= to_iio_chrdev_minor_attr(attr);
+	return sprintf(buf, "%d\n", _attr->minor);
+}
+
+void __init_iio_chrdev_minor_attr(struct iio_chrdev_minor_attr *minor_attr,
+				const char *name,
+				struct module *owner,
+				int id)
+{
+	minor_attr->dev_attr.attr.name = name;
+	minor_attr->dev_attr.attr.owner = owner;
+	minor_attr->dev_attr.attr.mode = S_IRUGO;
+	minor_attr->minor = id;
+	minor_attr->dev_attr.show = &iio_show_attr_minor;
+}
+
+int iio_setup_ev_int(struct iio_event_interface *ev_int,
+		     const char *name,
+		     struct module *owner,
+		     struct device *dev)
+{
+	int ret;
+
+	mutex_init(&ev_int->event_list_lock);
+	/* discussion point - make this variable? */
+	ev_int->max_events = 10;
+	ev_int->current_events = 0;
+	INIT_LIST_HEAD(&ev_int->det_events.list);
+	init_waitqueue_head(&ev_int->wait);
+	ev_int->handler.fops = &iio_event_chrdev_fileops;
+	ev_int->handler.private = ev_int;
+	ev_int->handler.flags = 0;
+	ret = iio_allocate_chrdev(&ev_int->handler);
+	if (ret)
+		goto error_ret;
+	__init_iio_chrdev_minor_attr(&ev_int->attr,
+				     (const char *)(name),
+				     owner,
+				     ev_int->handler.id);
+
+	ret = sysfs_create_file(&dev->kobj, &ev_int->attr.dev_attr.attr);
+	if (ret)
+		goto error_deallocate_chrdev;
+
+	return 0;
+error_deallocate_chrdev:
+	iio_deallocate_chrdev(&ev_int->handler);
+error_ret:
+	return ret;
+}
+
+void iio_free_ev_int(struct iio_event_interface *ev_int, struct device *dev)
+{
+	sysfs_remove_file(&dev->kobj, &ev_int->attr.dev_attr.attr);
+	iio_deallocate_chrdev(&ev_int->handler);
+}
+
+static int __init iio_init(void)
+{
+	int ret;
+
+	memset(iio_state.fhs,
+	       sizeof(struct iio_handler *)*256,
+	       0);
+
+	/* Create sysfs class */
+	ret  = class_register(&iio_class);
+	if (ret < 0) {
+		printk(KERN_ERR
+		       "industrialio.c: could not create sysfs class\n");
+		goto error_nothing;
+	}
+
+	ret = register_chrdev(IIO_MAJOR, "industrialio", &iio_fops);
+	if (ret) {
+		printk(KERN_ERR
+		       "industrialio: unable to register a char major %d",
+		       IIO_MAJOR);
+		goto error_unregister_class;
+	}
+	return 0;
+
+error_unregister_class:
+	class_unregister(&iio_class);
+error_nothing:
+	return ret;
+}
+
+static void __exit iio_exit(void)
+{
+	unregister_chrdev(IIO_MAJOR, "industrialio");
+	class_unregister(&iio_class);
+}
+
+static int iio_device_register_sysfs(struct iio_dev *dev_info)
+{
+	int ret = 0;
+
+	dev_info->sysfs_dev = device_create(&iio_class,
+					    dev_info->dev,
+					    0,
+					    dev_info,
+					    IIO_ID_FORMAT,
+					    dev_info->id);
+	if (IS_ERR(dev_info->sysfs_dev)) {
+		/* what would correct error here be?*/
+		ret = -EINVAL;
+		dev_err(dev_info->dev, "Failed in device create \n");
+		goto error_ret;
+	}
+
+	/* register attributes */
+	ret = sysfs_create_group(&dev_info->sysfs_dev->kobj, dev_info->attrs);
+	if (ret) {
+		dev_err(dev_info->dev, "Failed to register sysfs hooks\n");
+		goto error_free_sysfs_device;
+	}
+
+	if (dev_info->scan_el_attrs) {
+		ret = sysfs_create_group(&dev_info->sysfs_dev->kobj,
+					 dev_info->scan_el_attrs);
+		if (ret)
+			dev_err(dev_info->dev,
+				"Failed to add sysfs scan els\n");
+	}
+	return ret;
+
+error_free_sysfs_device:
+	device_unregister(dev_info->sysfs_dev);
+error_ret:
+	return ret;
+}
+
+static void iio_device_unregister_sysfs(struct iio_dev *dev_info)
+{
+	if (dev_info->scan_el_attrs)
+		sysfs_remove_group(&dev_info->sysfs_dev->kobj,
+				   dev_info->scan_el_attrs);
+
+	sysfs_remove_group(&dev_info->sysfs_dev->kobj, dev_info->attrs);
+	device_unregister(dev_info->sysfs_dev);
+}
+
+static int iio_device_register_id(struct iio_dev *dev_info)
+{
+	int ret;
+
+idr_again:
+	if (unlikely(idr_pre_get(&iio_idr, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	spin_lock(&iio_idr_lock);
+	ret = idr_get_new(&iio_idr, NULL, &dev_info->id);
+	spin_unlock(&iio_idr_lock);
+	if (unlikely(ret == -EAGAIN))
+		goto idr_again;
+	else if (unlikely(ret))
+		return ret;
+	dev_info->id = dev_info->id & MAX_ID_MASK;
+
+	return 0;
+}
+
+static void iio_device_unregister_id(struct iio_dev *dev_info)
+{
+	spin_lock(&iio_idr_lock);
+	idr_remove(&iio_idr, dev_info->id);
+	spin_unlock(&iio_idr_lock);
+}
+
+static inline int __iio_add_event_config_attrs(struct iio_dev *dev_info, int i)
+{
+	int ret;
+	/*p for adding, q for removing */
+	struct attribute **attrp, **attrq;
+
+	if (dev_info->event_conf_attrs && dev_info->event_conf_attrs[i].attrs) {
+		attrp = dev_info->event_conf_attrs[i].attrs;
+		while (*attrp) {
+			ret =  sysfs_add_file_to_group(&dev_info->sysfs_dev
+						       ->kobj,
+						       *attrp,
+						       dev_info
+						       ->event_attrs[i].name);
+			if (ret)
+				goto error_ret;
+			attrp++;
+		}
+	}
+	return 0;
+
+error_ret:
+	attrq = dev_info->event_conf_attrs[i].attrs;
+	while (attrq != attrp) {
+			sysfs_remove_file_from_group(&dev_info->sysfs_dev->kobj,
+					     *attrq,
+					     dev_info->event_attrs[i].name);
+		attrq++;
+	}
+
+	return ret;
+}
+
+static inline int __iio_remove_event_config_attrs(struct iio_dev *dev_info,
+						  int i)
+{
+	struct attribute **attrq;
+
+	if (dev_info->event_conf_attrs
+		&& dev_info->event_conf_attrs[i].attrs) {
+		attrq = dev_info->event_conf_attrs[i].attrs;
+		while (*attrq) {
+			sysfs_remove_file_from_group(&dev_info->sysfs_dev->kobj,
+						     *attrq,
+						     dev_info
+						     ->event_attrs[i].name);
+			attrq++;
+		}
+	}
+
+	return 0;
+}
+
+static int iio_device_register_eventset(struct iio_dev *dev_info)
+{
+	int ret = 0, i, j;
+
+	if (dev_info->num_interrupt_lines == 0)
+		return 0;
+
+	dev_info->event_interfaces = (struct iio_event_interface *)
+		(kzalloc(sizeof(struct iio_event_interface)
+			 *dev_info->num_interrupt_lines,
+			 GFP_KERNEL));
+	if (dev_info->event_interfaces == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	/* assign id's to the event_interface elements */
+	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
+		dev_info->event_interfaces[i].id = i;
+		dev_info->event_interfaces[i].owner = dev_info->driver_module;
+	}
+	dev_info->interrupts
+		= kzalloc(sizeof(struct iio_interrupt *)
+			  *dev_info->num_interrupt_lines,
+			  GFP_KERNEL);
+	if (dev_info->interrupts == NULL) {
+		dev_err(dev_info->dev,
+			"Failed to register sysfs hooks for events attributes");
+		ret = -ENOMEM;
+		goto error_free_event_interfaces;
+	}
+
+	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
+
+		snprintf(dev_info->event_interfaces[i]._name, 20,
+			"event_line%d_minor", i);
+		ret = iio_setup_ev_int(&dev_info->event_interfaces[i],
+				       (const char *)(dev_info
+						      ->event_interfaces[i]
+						      ._name),
+				       dev_info->driver_module,
+				       dev_info->sysfs_dev);
+		if (ret) {
+			dev_err(dev_info->dev,
+				"Could not get chrdev interface\n");
+			goto error_free_setup_ev_ints;
+		}
+	}
+	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
+		snprintf(dev_info->event_interfaces[i]._attrname, 20,
+			"event_line%d_sources", i);
+		dev_info->event_attrs[i].name
+			= (const char *)
+			(dev_info->event_interfaces[i]._attrname);
+		ret = sysfs_create_group(&dev_info->sysfs_dev->kobj,
+					 &dev_info->event_attrs[i]);
+		if (ret) {
+			dev_err(dev_info->dev,
+				"Failed to register sysfs for event attrs");
+			goto error_remove_sysfs_interfaces;
+		}
+	}
+	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
+		ret = __iio_add_event_config_attrs(dev_info, i);
+		if (ret)
+			goto error_unregister_config_attrs;
+	}
+
+
+
+	return 0;
+
+error_unregister_config_attrs:
+	for (j = 0; j < i; j++)
+		__iio_remove_event_config_attrs(dev_info, i);
+	i = dev_info->num_interrupt_lines - 1;
+error_remove_sysfs_interfaces:
+	for (j = 0; j < i; j++)
+		sysfs_remove_group(&dev_info->sysfs_dev->kobj,
+				   &dev_info->event_attrs[j]);
+
+	i = dev_info->num_interrupt_lines - 1;
+error_free_setup_ev_ints:
+	for (j = 0; j < i; j++)
+		iio_free_ev_int(&dev_info->event_interfaces[j],
+				dev_info->sysfs_dev);
+	kfree(dev_info->interrupts);
+error_free_event_interfaces:
+	kfree(dev_info->event_interfaces);
+error_ret:
+
+	return ret;
+}
+
+static void iio_device_unregister_eventset(struct iio_dev *dev_info)
+{
+	int i;
+	if (dev_info->num_interrupt_lines == 0)
+		return;
+	for (i = 0; i < dev_info->num_interrupt_lines; i++)
+		sysfs_remove_group(&dev_info->sysfs_dev->kobj,
+				   &dev_info->event_attrs[i]);
+
+	for (i = 0; i < dev_info->num_interrupt_lines; i++)
+		iio_free_ev_int(&dev_info->event_interfaces[i],
+					 dev_info->dev);
+	kfree(dev_info->event_interfaces);
+}
+
+
+int iio_device_register(struct iio_dev *dev_info)
+{
+	int ret;
+	mutex_init(&dev_info->mlock);
+	dev_set_drvdata(dev_info->dev, (void *)(dev_info));
+
+/*Get a unique id */
+	ret = iio_device_register_id(dev_info);
+	if (ret) {
+		dev_err(dev_info->dev, "Failed to get id\n");
+		goto error_nothing;
+	}
+
+/* Create sysfs device */
+	ret = iio_device_register_sysfs(dev_info);
+	if (ret) {
+		dev_err(dev_info->dev,
+			"Failed to register sysfs interfaces\n");
+		goto error_free_idr;
+	}
+
+/* Interrupt triggered events setup */
+	ret = iio_device_register_eventset(dev_info);
+	if (ret) {
+		dev_err(dev_info->dev,
+			"Failed to register event set \n");
+		goto error_free_sysfs;
+	}
+
+
+/* Ring buffer init if relevant */
+	if (dev_info->modes & (INDIO_RING_TRIGGERED
+			       | INDIO_RING_HARDWARE_BUFFER)) {
+		ret = iio_device_register_ring(dev_info, 0);
+		if (ret) {
+			dev_err(dev_info->dev,
+				"Failed to register ring");
+			goto error_free_eventset;
+		}
+	}
+
+/* Register ability to use triggers */
+	iio_device_register_trigger_consumer(dev_info);
+
+	return 0;
+
+error_free_eventset:
+	iio_device_unregister_eventset(dev_info);
+error_free_sysfs:
+	iio_device_unregister_sysfs(dev_info);
+error_free_idr:
+	iio_device_unregister_id(dev_info);
+error_nothing:
+
+	return ret;
+}
+EXPORT_SYMBOL(iio_device_register);
+
+void iio_device_unregister(struct iio_dev *dev_info)
+{
+	iio_device_unregister_trigger_consumer(dev_info);
+	if (dev_info->modes & (INDIO_RING_TRIGGERED
+			       | INDIO_RING_HARDWARE_BUFFER))
+		iio_device_unregister_ring(dev_info);
+	iio_device_unregister_eventset(dev_info);
+	iio_device_unregister_sysfs(dev_info);
+	iio_device_unregister_id(dev_info);
+}
+EXPORT_SYMBOL(iio_device_unregister);
+
+
+
+subsys_initcall(iio_init);
+module_exit(iio_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("Industrial I/O core");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/industrialio/iio.h b/include/linux/industrialio/iio.h
new file mode 100644
index 0000000..f51f653
--- /dev/null
+++ b/include/linux/industrialio/iio.h
@@ -0,0 +1,440 @@
+/* The industrial I/O core
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _INDUSTRIAL_IO_H_
+#define _INDUSTRIAL_IO_H_
+
+#include <linux/device.h>
+#include <linux/industrialio/sysfs.h>
+#include <linux/industrialio/ring_generic.h>
+#include <linux/industrialio/chrdev.h>
+
+/* IIO TODO LIST */
+/* Static device specific elements (conversion factors etc)
+ * should be exported via sysfs
+ *
+ * Provide alternative to high resolution timers if not available.
+ */
+
+/* Event interface flags */
+#define IIO_BUSY_BIT_POS 1
+
+struct iio_dev;
+
+/* Requires high resolution timers */
+static inline s64 iio_get_time_ns(void)
+{
+	struct timespec ts;
+	ktime_get_ts(&ts);
+	return timespec_to_ns(&ts);
+}
+
+/**
+ * struct iio_event_handler_list - element in list handlers for events
+ * @list:		list header
+ * @handler:		event handler function - called on event if this
+ *			event_handler is enabled.
+ * @refcount:		as the handler may be shared between multiple device
+ *			side events, reference counting ensures clean removal
+ * @exist_lock:		prevents race conditions related to refcount useage.
+ *
+ * Each device has one list of these per interrupt line
+ **/
+struct iio_event_handler_list {
+	struct list_head list;
+	int (*handler)(struct iio_dev *dev_io, int index, s64 timestamp,
+		       int no_test);
+	/* This element may be shared */ /* NEEDS LOCK unfortunately */
+	int refcount;
+	struct mutex exist_lock;
+};
+
+/**
+ * iio_add_event_to_list() - Wraps adding to event lists
+ * @el:		the list element of the event to be handled.
+ * @head:	the list associated with the event handler being used.
+ *
+ * Does reference counting to allow shared handlers.
+ **/
+int iio_add_event_to_list(struct iio_event_handler_list *el,
+			   struct list_head *head);
+/**
+ * iio_remove_event_from_list() - Wraps removing from event list
+ * @el:		element to be removed
+ * @head:	associate list head for the interrupt handler.
+ *
+ * Does reference counting to allow shared handlers.  The awkward bit
+ * is access to the spinlock used to prevent the interrupt handler from
+ * running into problems with this list having changed.
+ **/
+int iio_remove_event_from_list(struct iio_event_handler_list *el,
+			       struct list_head *head);
+
+
+/* Device operating modes */
+#define INDIO_DIRECT_MODE		0x01
+#define INDIO_RING_TRIGGERED		0x02
+#define INDIO_RING_HARDWARE_BUFFER	0x08
+
+#define INDIO_ALL_RING_MODES (INDIO_RING_TRIGGERED | INDIO_RING_HARDWARE_BUFFER)
+
+/* Vast majority of this is set by the industrialio subsystem on a
+ * call to iio_device_register. */
+
+/**
+ * struct iio_dev - industrial I/O device
+ * @id:			[INTERN] used to identify device internally
+ * @dev_data:		[DRIVER] device specific data
+ * @modes:		[DRIVER] operating modes supported by device
+ * @currentmode:	[DRIVER] current operating mode
+ * @sysfs_dev:		[INTERN] device created by sysfs needed for management
+ * @dev:		[DRIVER] the actual device structure
+ * @attrs:		[DRIVER] device attributes
+ * @driver_module:	[DRIVER] module structure used to ensure correct
+ *			ownership of chrdevs etc
+ * @scan_el_attrs:	[DRIVER] control of scan elements if that scan mode
+ *			control method is used
+ * @num_interrupt_lines:[DRIVER] number of physical interrupt lines from device
+ * @interrupts:		[INTERN] interrupt line specific event lists etc
+ * @event_attrs:	[DRIVER] event control attributes
+ * @event_conf_attrs:	[DRIVER] event configuration attributes
+ * @event_interfaces:	[INTERN] event chrdevs associated with interrupt lines
+ * @ring_bytes_per_datum:[DRIVER] number of bytes per datum in ring buffer
+ * @ring_length:	[DRIVER] number of datums in ring buffer
+ * @ring_attrs:		[INTERN] ring related attributes
+ * @ring_prenable:	[DRIVER] function to run prior to marking ring enabled
+ * @ring_postenable:	[DRIVER] function to run after marking ring enabled
+ * @ring_predisable:	[DRIVER] function to run prior to marking ring disabled
+ * @ring_postdisable:	[DRIVER] function to run after marking ring disabled
+ * @mlock:		[INTERN] lock used to prevent simultaneous device state
+ *			changes
+ * @scan_count:	        [INTERN] the number of elements in the current scan mode
+ * @scan_mask:		[INTERN] bitmask used in masking scan mode elements
+ * @trig:		[INTERN] current device trigger (ring buffer modes)
+ * @pollfunc:		[DRIVER] function run on trigger being recieved
+ **/
+
+struct iio_dev {
+	int				id;
+	void				*dev_data;
+	int				modes;
+	int				currentmode;
+	struct device			*sysfs_dev;
+	struct device			*dev;
+	const struct attribute_group	*attrs;
+	struct module			*driver_module;
+
+	struct attribute_group		*scan_el_attrs;
+	int				num_interrupt_lines;
+	struct iio_interrupt		**interrupts;
+	struct attribute_group		*event_attrs;
+	struct attribute_group		*event_conf_attrs;
+
+	struct iio_event_interface	*event_interfaces;
+	struct iio_ring_access_funcs	ring_access;
+
+	void				*ring;
+	struct attribute_group		*ring_attrs_group;
+	struct iio_ring_attr		*ring_attrs;
+
+	int				(*ring_preenable)(struct iio_dev *);
+	int				(*ring_postenable)(struct iio_dev *);
+	int				(*ring_predisable)(struct iio_dev *);
+	int				(*ring_postdisable)(struct iio_dev *);
+
+	struct mutex			mlock;
+
+	int				scan_count;
+	u16				scan_mask;
+	bool				scan_timestamp;
+	struct iio_trigger		*trig;
+	struct iio_poll_func		*pollfunc;
+};
+
+/**
+ * iio_device_register() - register a device with the IIO subsystem
+ * @dev_info:		Device structure filled by the device driver
+ **/
+int iio_device_register(struct iio_dev *dev_info);
+
+/**
+ * iio_device_unregister() - unregister a device from the IIO subsystem
+ * @dev_info:		Device structure representing the device.
+ **/
+void iio_device_unregister(struct iio_dev *dev_info);
+
+/**
+ * struct iio_interrupt - wrapper used to allow easy handling of multiple
+ *			physical interrupt lines
+ * @dev_info:		the iio device for which the is an interrupt line
+ * @linue_number:	associated line number
+ * @irq:		associate interrupt number
+ * @ev_list:		event handler list for associated events
+ **/
+struct iio_interrupt {
+	struct iio_dev			*dev_info;
+	int				line_number;
+	int				irq;
+	struct list_head		ev_list;
+	spinlock_t			ev_list_lock;
+};
+
+/**
+ * iio_register_interrupt_line() - Tell IIO about interrupt lines
+ *
+ * @irq:		Typically provided via platform data
+ * @dev_info:		IIO device info structure for device
+ * @line_number:	Which interrupt line of the device is this?
+ * @type:		Interrupt type (e.g. edge triggered etc)
+ * @name:		Identifying name.
+ **/
+int iio_register_interrupt_line(unsigned int			irq,
+				struct iio_dev			*dev_info,
+				int				line_number,
+				unsigned long			type,
+				const char			*name);
+
+void iio_unregister_interrupt_line(struct iio_dev *dev_info,
+				   int line_number);
+
+
+
+/**
+ * iio_push_event() - try to add event to the list for userspace reading
+ * @dev_info:		IIO device structure
+ * @ev_line:		Which event line (hardware interrupt)
+ * @ev_code:		What event
+ * @timestamp:		When the event occured
+ **/
+int iio_push_event(struct iio_dev *dev_info,
+		  int ev_line,
+		  int ev_code,
+		  s64 timestamp);
+
+/**
+ * struct iio_work_cont - container for case where singleton handler case matters
+ * @ws:			[DEVICE]work_struct when not only possible event
+ * @ws_nocheck:		[DEVICE]work_struct when only possible event
+ * @address:		[DEVICE]associated register address
+ * @mask:		[DEVICE]associated mask for identifying event source
+ * @st:			[DEVICE]device specific state information
+ **/
+struct iio_work_cont {
+	struct work_struct ws;
+	struct work_struct ws_nocheck;
+	int address;
+	int mask;
+	void *st;
+};
+
+#define to_iio_work_cont_check(_ws)			\
+	container_of(_ws, struct iio_work_cont, ws)
+
+#define to_iio_work_cont_no_check(_ws)				\
+	container_of(_ws, struct iio_work_cont, ws_nocheck)
+
+static inline void
+iio_init_work_cont(struct iio_work_cont *cont,
+		   void (*_checkfunc)(struct work_struct *),
+		   void (*_nocheckfunc)(struct work_struct *),
+		   int _add, int _mask, void *_st)
+{
+	INIT_WORK(&(cont)->ws, _checkfunc);
+	INIT_WORK(&(cont)->ws_nocheck, _nocheckfunc);
+	cont->address = _add;
+	cont->mask = _mask;
+	cont->st = _st;
+}
+/**
+ * __iio_push_event() tries to add an event to the list associated with a chrdev
+ * @ev_int:		the event interface to which we are pushing the event
+ * @ev_code:		the outgoing event code
+ * @timestamp:		timestamp of the event
+ * @shared_pointer_p:	the shared event pointer
+ **/
+int __iio_push_event(struct iio_event_interface *ev_int,
+		    int ev_code,
+		    s64 timestamp,
+		    struct iio_shared_ev_pointer*
+		    shared_pointer_p);
+/**
+ * __iio_change_event() change an event code in case of event escallation
+ * @ev:			the evnet to be changed
+ * @ev_code:		new event code
+ * @timestamp:		new timestamp
+ **/
+void __iio_change_event(struct iio_detected_event_list *ev,
+			int ev_code,
+			s64 timestamp);
+
+/**
+ * iio_setup_ev_int() Configure an event interface (chrdev)
+ *
+ * @ev_int:		Interface we are configuring
+ * @owner:		Module that is responsible for registering this ev_int
+ * @dev		Device whose ev_int this is
+ **/
+int iio_setup_ev_int(struct iio_event_interface *ev_int,
+		     const char *name,
+		     struct module *owner,
+		     struct device *dev);
+
+void iio_free_ev_int(struct iio_event_interface *ev_int,  struct device *dev);
+
+/**
+ * iio_allocate_chrdev() - Allocate a chrdev
+ *
+ * @hander:		Struct that contains relevant file handling for chrdev
+ **/
+int iio_allocate_chrdev(struct iio_handler *handler);
+void iio_deallocate_chrdev(struct iio_handler *handler);
+
+/**
+ * iio_show_attr_minor() sysfs read function to get the chrdev minor number
+ **/
+ssize_t iio_show_attr_minor(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf);
+
+/* Used to distinguish between bipolar and unipolar scan elemenents.
+ * Whilst this may seem obvious, we may well want to change the representation
+ * in the future!*/
+#define IIO_SIGNED(a) -(a)
+#define IIO_UNSIGNED(a) (a)
+struct iio_dev;
+
+/**
+ * struct iio_scan_el - an individual element of a scan
+ *
+ * @dev_attr:		control attribute (if directly controllable)
+ * @mask:		bitmask corresonding to this scan element
+ * @bit_count:		number of bits in scan element
+ * @label:		useful data for the scan el (often reg address)
+ * @set_state:		for some devices datardy signals are generated
+ *			for any enabled lines.  This allows unwanted lines
+ *			to be disabled and hence not get in the way.
+ **/
+struct iio_scan_el {
+	struct device_attribute		dev_attr;
+	unsigned int			mask;
+	int				bit_count;
+	unsigned int			label;
+
+	int (*set_state)(struct iio_scan_el *scanel,
+			 struct iio_dev *dev_info,
+			 bool state);
+};
+
+#define to_iio_scan_el(_dev_attr)				\
+	container_of(_dev_attr, struct iio_scan_el, dev_attr);
+
+/**
+ * iio_scan_el_store() - sysfs scan element selection interface.
+ *
+ * A generic function used to enable various scan elements.  In some
+ * devices explicit read commands for each channel mean this is merely
+ * a software switch.  In others this must actively disable the channel.
+ * Complexities occur when this interacts with data ready type triggers
+ * which may not reset unless every channel that is enabled is explicitly
+ * read.
+ **/
+ssize_t iio_scan_el_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len);
+/**
+ * iio_scal_el_show() -	sysfs interface to query whether a scan element is
+ *			is enabled or not.
+ **/
+ssize_t iio_scan_el_show(struct device *dev, struct device_attribute *attr,
+			 char *buf);
+/**
+ * IIO_SCAN_EL: - declare and initialize a scan element without control func
+ * @_name:	identifying name. Resulting struct is iio_scan_el_##_name,
+ *		sysfs element, scan_en_##_name.
+ * @_number:	unique id number for the scan element.
+ * @_bits:	number of bits in the scan element result (used in mixed bit
+ *		length devices).
+ * @_label:	indentification variable used by drivers.  Often a reg address.
+ **/
+#define IIO_SCAN_EL(_name, _number, _bits, _label)			\
+	struct iio_scan_el iio_scan_el_##_name = {			\
+		.dev_attr = __ATTR(scan_en_##_name,			\
+				   S_IRUGO | S_IWUSR,			\
+				   iio_scan_el_show,			\
+				   iio_scan_el_store),			\
+		.mask = (1 << _number),					\
+		.bit_count = _bits,					\
+		.label = _label,					\
+	}
+
+ssize_t iio_scan_el_ts_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len);
+
+ssize_t iio_scan_el_ts_show(struct device *dev, struct device_attribute *attr,
+			    char *buf);
+/**
+ * IIO_SCAN_EL_C: - declare and initialize a scan element with a control func
+ *
+ * @_controlfunc: function used to notify hardware of whether state changes
+ **/
+#define IIO_SCAN_EL_C(_name, _number, _bits, _label, _controlfunc)	\
+	struct iio_scan_el iio_scan_el_##_name = {			\
+		.dev_attr = __ATTR(scan_en_##_name,			\
+				   S_IRUGO | S_IWUSR,			\
+				   iio_scan_el_show,			\
+				   iio_scan_el_store),			\
+		.mask = (1 << _number),					\
+		.bit_count = _bits,					\
+		.label = _label,					\
+		.set_state = _controlfunc,				\
+	}
+/**
+ * IIO_SCAN_EL_TIMESTAMP: - declare a special scan element for timestamps
+ *
+ * Odd one out. Handled slightly differently from other scan elements.
+ **/
+#define IIO_SCAN_EL_TIMESTAMP					\
+	struct iio_scan_el iio_scan_el_timestamp = {		\
+		.dev_attr = __ATTR(scan_en_timestamp,		\
+				   S_IRUGO | S_IWUSR,		\
+				   iio_scan_el_ts_show,		\
+				   iio_scan_el_ts_store),	\
+	}
+
+extern struct class iio_class;
+
+/* Ring buffer related */
+#ifdef CONFIG_IIO_RING_BUFFER
+/**
+ * iio_ring_enabled() helper function to test if any form of ring enabled
+ **/
+static inline bool iio_ring_enabled(struct iio_dev *dev_info)
+{
+	return dev_info->currentmode
+		& (INDIO_RING_TRIGGERED
+		   | INDIO_RING_HARDWARE_BUFFER);
+};
+/**
+ * iio_device_register_ring() connect up all ring related elements
+ **/
+int iio_device_register_ring(struct iio_dev *dev_info, int id);
+void iio_device_unregister_ring(struct iio_dev *dev_info);
+
+#else
+static inline bool iio_ring_enabled(struct iio_dev *dev_info)
+{
+	return false;
+};
+static inline int iio_device_register_ring(struct iio_dev *devinfo, int id)
+{
+	return 0;
+};
+static inline void iio_device_unregister_ring(struct iio_dev *dev_info) {};
+
+#endif /* CONFIG_IIO_RING_BUFFER */
+#endif /* _INDUSTRIAL_IO_H_ */
diff --git a/include/linux/industrialio/sysfs.h b/include/linux/industrialio/sysfs.h
new file mode 100644
index 0000000..eba6439
--- /dev/null
+++ b/include/linux/industrialio/sysfs.h
@@ -0,0 +1,284 @@
+/* The industrial I/O core
+ *
+ *Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * General attributes
+ */
+
+#ifndef _INDUSTRIAL_IO_SYSFS_H_
+#define _INDUSTRIAL_IO_SYSFS_H_
+
+#include <linux/industrialio/iio.h>
+
+/**
+ * struct iio_event_attribute - event control attribute
+ * @dev_attr:	underlying device attribute
+ * @mask:	mask for the event when detecting
+ * @listel:	list header to allow addition to list of event handlers
+*/
+struct iio_event_attr {
+	struct device_attribute dev_attr;
+	int mask;
+	struct iio_event_handler_list *listel;
+};
+
+#define to_iio_event_attr(_dev_attr) \
+	container_of(_dev_attr, struct iio_event_attr, dev_attr)
+
+/**
+ * struct iio_chrdev_minor_attr - simple attribute to allow reading of chrdev
+ *				minor number
+ * @dev_attr:	underlying device attribute
+ * @minor:	the minor number
+ */
+struct iio_chrdev_minor_attr {
+	struct device_attribute dev_attr;
+	int minor;
+};
+
+void
+__init_iio_chrdev_minor_attr(struct iio_chrdev_minor_attr *minor_attr,
+			   const char *name,
+			   struct module *owner,
+			   int id);
+
+
+#define to_iio_chrdev_minor_attr(_dev_attr) \
+	container_of(_dev_attr, struct iio_chrdev_minor_attr, dev_attr);
+
+/**
+ * struct iio_dev_attr - iio specific device attribute
+ * @dev_attr:	underlying device attribute
+ * @address:	associated register address
+ */
+struct iio_dev_attr {
+	struct device_attribute dev_attr;
+	int address;
+	int val2;
+};
+
+#define to_iio_dev_attr(_dev_attr)				\
+	container_of(_dev_attr, struct iio_dev_attr, dev_attr)
+
+ssize_t iio_read_const_attr(struct device *dev,
+			    struct device_attribute *attr,
+			    char *len);
+
+/**
+ * struct iio_const_attr - constant device specific attribute
+ *                         often used for things like available modes
+ */
+struct iio_const_attr {
+	const char *string;
+	struct device_attribute dev_attr;
+};
+
+#define to_iio_const_attr(_dev_attr) \
+	container_of(_dev_attr, struct iio_const_attr, dev_attr)
+
+/* Some attributes will be hard coded (device dependant) and not require an
+   address, in these cases pass a negative */
+#define IIO_ATTR(_name, _mode, _show, _store, _addr)		\
+	{ .dev_attr = __ATTR(_name, _mode, _show, _store),	\
+	  .address = _addr }
+
+#define IIO_ATTR_2(_name, _mode, _show, _store, _addr, _val2)	\
+	{ .dev_attr = __ATTR(_name, _mode, _show, _store),	\
+			.address = _addr,			\
+			.val2 = _val2 }
+
+#define IIO_DEVICE_ATTR(_name, _mode, _show, _store, _addr)	\
+	struct iio_dev_attr iio_dev_attr_##_name		\
+	= IIO_ATTR(_name, _mode, _show, _store, _addr)
+
+
+#define IIO_DEVICE_ATTR_2(_name, _mode, _show, _store, _addr, _val2)	\
+	struct iio_dev_attr iio_dev_attr_##_name			\
+	= IIO_ATTR_2(_name, _mode, _show, _store, _addr, _val2)
+
+#define IIO_CONST_ATTR(_name, _string)					\
+	struct iio_const_attr iio_const_attr_##_name			\
+	= { .string = _string,						\
+	    .dev_attr = __ATTR(_name, S_IRUGO, iio_read_const_attr, NULL)}
+
+/* Generic attributes of onetype or another */
+
+/**
+ * IIO_DEV_ATTR_REG: revision number for the device
+ *
+ * Very much device dependent.
+ **/
+#define IIO_DEV_ATTR_REV(_show)			\
+	IIO_DEVICE_ATTR(revision, S_IRUGO, _show, NULL, 0)
+
+/**
+ * IIO_DEV_ATTR_SAMP_FREQ: sets any internal clock frequency
+ **/
+#define IIO_DEV_ATTR_SAMP_FREQ(_mode, _show, _store)			\
+	IIO_DEVICE_ATTR(sampling_frequency, _mode, _show, _store, 0)
+
+/**
+ * IIO_DEV_ATTR_AVAIL_SAMP_FREQ: list available sampling frequencies.
+ *
+ * May be mode dependant on some devices
+ **/
+#define IIO_DEV_ATTR_AVAIL_SAMP_FREQ(_show)				\
+	IIO_DEVICE_ATTR(available_sampling_frequency, S_IRUGO, _show, NULL, 0)
+
+/**
+ * IIO_DEV_ATTR_CONST_AVAIL_SAMP_FREQ: list available sampling frequencies.
+ *
+ * Constant version
+ **/
+#define IIO_CONST_ATTR_AVAIL_SAMP_FREQ(_string)	\
+	IIO_CONST_ATTR(available_sampling_frequency, _string)
+/**
+ * IIO_DEV_ATTR_SCAN_MODE: select a scan mode
+ *
+ * This is used when only certain combinations of inputs may be read in one
+ * scan.
+ **/
+#define IIO_DEV_ATTR_SCAN_MODE(_mode, _show, _store)		\
+	IIO_DEVICE_ATTR(scan_mode, _mode, _show, _store, 0)
+/**
+ * IIO_DEV_ATTR_AVAIL_SCAN_MODES: list available scan modes
+ **/
+#define IIO_DEV_ATTR_AVAIL_SCAN_MODES(_show)				\
+	IIO_DEVICE_ATTR(available_scan_modes, S_IRUGO, _show, NULL, 0)
+
+/**
+ * IIO_DEV_ATTR_SCAN: result of scan of multiple channels
+ **/
+#define IIO_DEV_ATTR_SCAN(_show)		\
+	IIO_DEVICE_ATTR(scan, S_IRUGO, _show, NULL, 0);
+
+/**
+ * IIO_DEV_ATTR_INPUT: direct read of a single input channel
+ **/
+#define IIO_DEV_ATTR_INPUT(_number, _show)				\
+	IIO_DEVICE_ATTR(in##_number, S_IRUGO, _show, NULL, _number)
+
+
+/**
+ * IIO_DEV_ATTR_SW_RING_ENABLE: enable software ring buffer
+ *
+ * Success may be dependant on attachment of trigger previously
+ **/
+#define IIO_DEV_ATTR_SW_RING_ENABLE(_show, _store)			\
+	IIO_DEVICE_ATTR(sw_ring_enable, S_IRUGO | S_IWUSR, _show, _store, 0)
+
+/**
+ * IIO_DEV_ATTR_HW_RING_ENABLE: enable hardware ring buffer
+ *
+ * This is a different attribute from the software one as one can invision
+ * schemes where a combination of the two may be used.
+ **/
+#define IIO_DEV_ATTR_HW_RING_ENABLE(_show, _store)			\
+	IIO_DEVICE_ATTR(hw_ring_enable, S_IRUGO | S_IWUSR, _show, _store, 0)
+
+/**
+ * IIO_DEV_ATTR_RING_BPS: set number of bits per sample
+ **/
+#define IIO_DEV_ATTR_RING_BPS(_mode, _show, _store)		\
+	IIO_DEVICE_ATTR(ring_bps, _mode, _show, _store, 0)
+
+/**
+ * IIO_DEV_ATTR_RING_BPS_AVAILABLE: no of bits per sample supported
+ **/
+#define IIO_DEV_ATTR_RING_BPS_AVAILABLE(_show)				\
+	IIO_DEVICE_ATTR(ring_bps_available, S_IRUGO, _show, NULL, 0)
+
+/**
+ * IIO_DEV_ATTR_TEMP: many sensors have auxiliary temperature sensors
+ **/
+#define IIO_DEV_ATTR_TEMP(_show)			\
+	IIO_DEVICE_ATTR(temp, S_IRUGO, _show, NULL, 0)
+/**
+ * IIO_EVENT_SH: generic shared event handler
+ *
+ * This is used in cases where more than one event may result from a single
+ * handler.  Often the case that some alarm register must be read and multiple
+ * alarms may have been triggered.
+ **/
+#define IIO_EVENT_SH(_name, _handler)					\
+	static struct iio_event_handler_list				\
+	iio_event_##_name = {						\
+		.handler = _handler,					\
+		.refcount = 0,						\
+		.exist_lock = __MUTEX_INITIALIZER(iio_event_##_name	\
+						  .exist_lock),	\
+	};
+/**
+ * IIO_EVENT_ATTR_SH: generic shared event attribute
+ *
+ * An attribute with an associated IIO_EVENT_SH
+ **/
+#define IIO_EVENT_ATTR_SH(_name, _ev_list, _show, _store, _mask)	\
+	static struct iio_event_attr					\
+	iio_event_attr_##_name						\
+	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR,		\
+			       _show, _store),				\
+	    .mask = _mask,						\
+	    .listel = &_ev_list };
+
+/**
+ * IIO_EVENT_ATTR: non shared event attribute
+ **/
+#define IIO_EVENT_ATTR(_name, _show, _store, _mask, _handler)		\
+	static struct iio_event_handler_list				\
+	iio_event_##_name = {						\
+		.handler = _handler,					\
+	};								\
+	static struct							\
+	iio_event_attr							\
+	iio_event_attr_##_name						\
+	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR,		\
+			       _show, _store),				\
+	    .mask = _mask,						\
+	    .listel = &iio_event_##_name };				\
+
+/**
+ * IIO_EVENT_ATTR_DATA_RDY: event driven by data ready signal
+ *
+ * Not typically implemented in devices where full triggering support
+ * has been implemented
+ **/
+#define IIO_EVENT_ATTR_DATA_RDY(_show, _store, _mask, _handler) \
+	IIO_EVENT_ATTR(data_rdy, _show, _store, _mask, _handler)
+
+#define IIO_EVENT_CODE_DATA_RDY		100
+#define IIO_EVENT_CODE_RING_BASE	200
+#define IIO_EVENT_CODE_ACCEL_BASE	300
+#define IIO_EVENT_CODE_GYRO_BASE	400
+#define IIO_EVENT_CODE_ADC_BASE		500
+#define IIO_EVENT_CODE_MISC_BASE	600
+
+#define IIO_EVENT_CODE_DEVICE_SPECIFIC	1000
+
+/**
+ * IIO_EVENT_ATTR_RING_50_FULL: ring buffer event to indicate 50% full
+ **/
+#define IIO_EVENT_ATTR_RING_50_FULL(_show, _store, _mask, _handler)	\
+	IIO_EVENT_ATTR(ring_50_full, _show, _store, _mask, _handler)
+
+/**
+ * IIO_EVENT_ATTR_RING_50_FULL_SH: shared ring event to indicate 50% full
+ **/
+#define IIO_EVENT_ATTR_RING_50_FULL_SH(_evlist, _show, _store, _mask)	\
+	IIO_EVENT_ATTR_SH(ring_50_full, _evlist, _show, _store, _mask)
+
+/**
+ * IIO_EVENT_ATTR_RING_75_FULL_SH: shared ring event to indicate 75% full
+ **/
+#define IIO_EVENT_ATTR_RING_75_FULL_SH(_evlist, _show, _store, _mask)	\
+	IIO_EVENT_ATTR_SH(ring_75_full, _evlist, _show, _store, _mask)
+
+#define IIO_EVENT_CODE_RING_50_FULL	IIO_EVENT_CODE_RING_BASE
+#define IIO_EVENT_CODE_RING_75_FULL	(IIO_EVENT_CODE_RING_BASE + 1)
+#define IIO_EVENT_CODE_RING_100_FULL	(IIO_EVENT_CODE_RING_BASE + 2)
+
+#endif /* _INDUSTRIAL_IO_SYSFS_H_ */
diff --git a/include/linux/industrialio/chrdev.h b/include/linux/industrialio/chrdev.h
new file mode 100644
index 0000000..00fda2e
--- /dev/null
+++ b/include/linux/industrialio/chrdev.h
@@ -0,0 +1,91 @@
+/* The industrial I/O core - character device related
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+/* FIXME - inprecise name for this file */
+
+#ifndef _IIO_CHRDEV_H_
+#define _IIO_CHRDEV_H_
+/**
+ * struct iio_handler - Structure used to specify file operations
+ *			for a particular chrdev
+ * @fops:	file operations including read function
+ * @id:		the location in the handler table - used for deallocation.
+ * @flags:	file operations related flags including busy flag.
+ */
+struct iio_handler {
+	const struct file_operations *fops;
+	int id;
+	unsigned long flags;
+	void *private;
+};
+
+/**
+ * struct iio_event_data - The actual event being pushed to userspace
+ * @id:		event identifier
+ * @timestamp:	best estimate of time of event occurance (often from
+ *		the interrupt handler)
+ */
+struct iio_event_data {
+	int id;
+	s64 timestamp;
+};
+
+/**
+ * struct iio_detected_event_list - list element for events that have occured
+ * @list:		linked list header
+ * @ev:			the event itself
+ * @shared_pointer:	used when the event is shared - i.e. can be escallated
+ *			on demand (eg ring buffer 50%->100% full)
+ */
+struct iio_detected_event_list {
+	struct list_head list;
+	struct iio_event_data ev;
+	struct iio_shared_ev_pointer *shared_pointer;
+};
+/**
+ * struct iio_shared_ev_pointer - allows shared events to identify if currently
+ *				in the detected event list
+ * @ev_p:	pointer to detected event list element (null if not in list)
+ * @lock:	protect this element to prevent simultaneous edit and remove
+ */
+struct iio_shared_ev_pointer {
+	struct iio_detected_event_list	*ev_p;
+	spinlock_t lock;
+};
+
+/**
+ * struct iio_event_interface - chrdev interface for an event line
+ * @handler:		fileoperations and related control for the chrdev
+ * @wait:		wait queue to allow blocking reads of events
+ * @event_list_lock:	mutex to protect the list of detected events
+ * @det_events:		list of detected events
+ * @max_events:		maximum number of events before new ones are dropped
+ * @current_events:	number of events in detected list
+ * @id:			indentifier to allow the event interface to know which
+ *			physical line it corresponds to
+ * @owner:		ensure the driver module owns the file, not iio
+ * @private:		driver specific data
+ * @_name:		used internally to store the sysfs name for minor id
+ *			attribute
+ */
+struct iio_event_interface {
+	struct iio_handler			handler;
+	wait_queue_head_t			wait;
+	struct mutex				event_list_lock;
+	struct iio_detected_event_list		det_events;
+	int					max_events;
+	int					current_events;
+	int					id;
+	struct iio_chrdev_minor_attr		attr;
+	struct module				*owner;
+	void					*private;
+	char					_name[20];
+	char					_attrname[20];
+};
+#endif
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 2f557f5..ae35394 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -106,5 +106,7 @@ source "drivers/uio/Kconfig"
 
 source "drivers/xen/Kconfig"
 
+source "drivers/industrialio/Kconfig"
+
 source "drivers/staging/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index fceb71a..41a7d1c 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_INPUT)		+= input/
 obj-$(CONFIG_I2O)		+= message/
 obj-$(CONFIG_RTC_LIB)		+= rtc/
 obj-y				+= i2c/
+obj-y				+= industrialio/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
diff --git a/drivers/industrialio/Kconfig b/drivers/industrialio/Kconfig
new file mode 100644
index 0000000..7be386c
--- /dev/null
+++ b/drivers/industrialio/Kconfig
@@ -0,0 +1,12 @@
+#
+# Industrial I/O subsytem configuration
+#
+
+menuconfig INDUSTRIALIO
+	tristate "Industrial I/O support"
+	---help---
+	  The industrial I/O subsystem provides a unified framework for
+	  drivers for many different types of embedded sensors using a
+	  number of different physical interfaces (i2c, spi etc). See
+	  Documentation/industrialio for more information.
+
diff --git a/drivers/industrialio/Makefile b/drivers/industrialio/Makefile
new file mode 100644
index 0000000..579ac30
--- /dev/null
+++ b/drivers/industrialio/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the industrial I/O core.
+#
+
+obj-$(CONFIG_INDUSTRIALIO)	+= industrialio.o
+industrialio-y := industrialio-core.o
diff --git a/include/linux/industrialio/trigger.h b/include/linux/industrialio/trigger.h
new file mode 100644
index 0000000..bca0678
--- /dev/null
+++ b/include/linux/industrialio/trigger.h
@@ -0,0 +1,68 @@
+/* The industrial I/O core, trigger handling functions
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#ifndef _IIO_TRIGGER_H_
+#define _IIO_TRIGGER_H_
+#define IIO_TRIGGER_NAME_LENGTH 20
+#define IIO_TRIGGER_ID_PREFIX "iio:trigger"
+#define IIO_TRIGGER_ID_FORMAT IIO_TRIGGER_ID_PREFIX "%d"
+
+#ifdef CONFIG_IIO_TRIGGERS
+#else
+struct iio_trigger{};
+static inline int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
+{
+	return 0;
+};
+
+static inline int
+iio_device_unregister_trigger_consumer(struct iio_dev *dev_info)
+{
+	return 0;
+}
+
+
+static inline int iio_trigger_attach_poll_func(struct iio_trigger *trig,
+					       struct iio_poll_func *pf)
+{
+	return 0;
+}
+
+static inline int iio_trigger_dettach_poll_func(struct iio_trigger *trig,
+						struct iio_poll_func *pf)
+{
+	return 0;
+}
+#endif
+
+/**
+ * struct iio_poll_func - poll function pair
+ *
+ * @list:			associate this with a triggers pollfunc_list
+ * @private_data:		data specific to device (passed into poll func)
+ * @poll_func_immediate:	function in here is run first. They should be
+ *				extremely lightweight.  Typically used for latch
+ *				control on sensor supporting it.
+ * @poll_func_main:		function in here is run after all immediates.
+ *				Reading from sensor etc typically involves
+ *				scheduling
+ *				from here.
+ *
+ * The two stage approach used here only important when multiple sensors are
+ * being triggered by a single trigger. This really comes into it's own with
+ * simultaneous sampling devices where a simple latch command can be used to
+ * make the device store the values on all inputs.
+ **/
+struct iio_poll_func {
+	struct				list_head list;
+	void				*private_data;
+	void (*poll_func_immediate)(struct iio_dev *indio_dev);
+	void (*poll_func_main)(struct iio_dev  *private_data);
+
+};
+#endif /* _IIO_TRIGGER_H_ */
diff --git a/include/linux/industrialio/ring_generic.h b/include/linux/industrialio/ring_generic.h
new file mode 100644
index 0000000..c79e2dd
--- /dev/null
+++ b/include/linux/industrialio/ring_generic.h
@@ -0,0 +1,24 @@
+/* The industrial I/O core - generic ring buffer interfaces.
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _IIO_RING_GENERIC_H_
+#define _IIO_RING_GENERIC_H_
+
+#include <linux/industrialio/chrdev.h>
+
+struct iio_ring_buffer;
+
+#ifdef CONFIG_IIO_RING_BUFFER
+#else
+
+struct iio_ring_buffer {};
+struct iio_ring_access_funcs {};
+#endif /* CONFIG_IIO_RING_BUFFER */
+
+#endif /* _IIO_RING_GENERIC_H_ */
