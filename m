Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbYFZS0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbYFZS0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761409AbYFZS0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:26:24 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:51067 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760055AbYFZS0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:26:21 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4863DF5F.9040409@gmail.com>
Date: Thu, 26 Jun 2008 19:26:39 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: Accelerometer etc subsystem (Update on progress)
References: <4832A211.4040206@gmail.com> <20080520132817.03fb74ea@hyperion.delvare> <4863D97A.9090102@gmail.com>
In-Reply-To: <4863D97A.9090102@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030402030807090203070705"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030402030807090203070705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sorry, forgot to include the headers in the original patch.  Obviously these
are very rough and ready at the moment and if nothing else their overall
layout isn't particularly logical.
> Dear All,
>
> This email is mainly to give people an idea of current progress towards
> a new
> subsystem as discussed in the thread starting with
> http://lkml.org/lkml/2008/5/20/135
>
> Sorry for the mass list bombardment, but clearly some elements of this
> discussion
> will end up in various different territories.
>
> Some elements of a prototype subsystem are in place. It draws very heavily
> on parts of the input and hwmon subsystems diverging only where necessary.
>
> The only test driver currently integrated is for an ST LIS3L02DQ
> accelerometer
> which has more than a few quirks to make it tricky to handle (and some what
> sketchy documentation.) More chips will follow over next week or so but
> hopefully the driver for this chip gives enough of an idea of how I envision
> the system working to encourage discussion / advice.
>
> Note that I haven't dealt with anywhere near all the possible locking issues
> etc and am well aware that this needs to be done. Other cleanups that will
> need to be done include working out the layout in sysfs to make it more
> intuitive. Also sorry for the somewhat rough and ready nature of the
> attached
> patch (against 2.6.26-rc4)
>
> Ring buffer design is a large part of the attached patch. I'm not sure if
> I am going about this the right way. Basically, we need ring buffers with
> almost no write latency but can waste plenty of time reading from them
> (in general case - we do however want reading the last available value to be
> fast). What is there works, but probably has at least a few nasty corner
> cases that I haven't prevented.
>
> Interfaces (these are per device) - at somepoint a procfs interface similar
>        to that used in the input subsystem would make device querying
>        simpler.
>
> Sysfs -    Parameter Control - gain / offsets etc
>     State control, turn interrupts on and off etc.
>     Interrupt control parameters (threshold etc)
>     Ring buffer parameters as relevant (currently fixed)
>     Individual input reading (acceleration values here)
>     Minor numbers for various chrdevs associated with this device.
>
> chrdev-    3 types of chrdev at the moment
>     Ring buffer events
>     Ring buffer access (currently ripping data off the buffer only)
>     Interrupt events - for lis3l02dq these are only threshold breaks
>
> Functionality yet to be implemented.
>     Polled based capture (use a peroidic timer if available)
>
>     Hardware ring buffering for devices that support it (two level ring
> buffer -
>     hard and soft may be appropriate)
>
>     A chrdev for polling of whole device (with timestamps etc).
>
>     Composite interrupt handling (some devices allow logical combinations
>     of different interrupt signals to be used as the trigger condition).
>
>     Documenation ;)
>
>     Cleaner solution to data alignment in the ring buffer (currently I'm
> cheating
>     and manually doing it)
>
>     Lots lots more....
>
> Anyhow, all comments welcome.  Can anyone think of a better name?
> (I'm not keen on industrialio. It's too long if nothing else!
>  It will do as a working title for now)
>
> Thanks,
>
> --
>
> Jonathan Cameron
>   


--------------030402030807090203070705
Content-Type: text/x-patch;
 name="indio_headers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="indio_headers.patch"

--- a/include/linux/industrialio.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/industrialio.h	2008-06-26 12:10:31.000000000 +0100
@@ -0,0 +1,275 @@
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
+#include <linux/industrialio_sysfs.h>
+
+/* TODO LIST */
+/* Initial test drivers to implement
+   SCA3000 VTI Accelerometers (hardware ring buffers)
+   MAX1363 ADC (polled only for ring buffer )
+
+   Static device specific elements (conversion factors etc) should be exported via sysfs
+
+   Finish writing ring buffer character interface
+   Write general event character interfaces
+   Another type of chardev to allow direct reading (typically in response to data ready events)
+
+
+   Opinions sought on:
+   Shared interrupt lines.  Worth dealing with? (very time consuming to check
+   whether some devices caused an interrupt or not - in some states anyway)
+   Limiting length of event lists.  Could get silly numbers of them otherwise.
+*/
+
+
+/* Event interface flags */
+#define INDUSTRIALIO_BUSY_BIT_POS 1
+
+
+/* Could maintain a list of these for rapid clean up purposes,
+   but it doesn't exactly take long to scan the array */
+struct industrialio_handler {
+	const struct file_operations *fops;
+	int id;
+	unsigned long flags;
+	void *private;
+};
+
+
+/* The actual event being pushed ot userspace */
+struct industrialio_event_data {
+	int id;
+	s64 timestamp;
+};
+
+/* FIXME -WORK ON NAMING*/
+struct industrialio_detected_event_list {
+	struct list_head list;
+	struct industrialio_event_data ev;
+	/* Part of shared event handling - (typicaly ring buffers) */
+	struct industrialio_shared_ev_pointer *shared_pointer;
+};
+
+
+/* Requires high resolution timers */
+static inline s64 industrialio_get_time_ns(void)
+{
+	struct timespec ts;
+	ktime_get_ts(&ts);
+	return timespec_to_ns(&ts);
+}
+
+struct industrialio_dev;
+/* Each device has one of these per interrupt */
+struct industrialio_event_handler_list {
+	struct list_head list;
+	int (*handler)(struct industrialio_dev *dev_io, int index, s64 timestamp, int no_test);
+	/* This element may be shared */
+	int refcount;
+};
+/* wraps adding to lists and does reference counting to allowed shared handlers */
+/* FIXME CONFUSING NAMING */
+int industrialio_add_event_to_list(struct industrialio_event_handler_list *list,
+				   struct industrialio_event_handler_list *el);
+
+int industrialio_remove_event_from_list(struct industrialio_event_handler_list *el);
+
+
+
+/* This means that interrupts can be turned off when no events are being generated,
+   and also provides the interrupt handler the means to identify the incoming event */
+//int industrialio_register_event_list_to_interrupt(int interrupt, industrialio_event_list *list);
+
+/* Want this to be as transparrent as possible from the point of view of the driver! */
+
+/* JIC23: This is my first serious attempt at a lock free ring buffer for this sort of
+   situation so all suggestions on this code particularly welcome! */
+
+
+
+
+struct industrialio_ring_buffer;
+#define INIT_INDUSTRIALIO_RING_BUFFER(ring, _dim, _bytes, _length) {	\
+		(ring)->size = _dim*_bytes;				\
+		(ring)->skip = (ring)->size + sizeof(s64);		\
+		(ring)->length = _length;				\
+		(ring)->dimension = _dim;				\
+		(ring)->bytes = _bytes;					\
+		(ring)->read_p = 0;					\
+		(ring)->write_p = 0;					\
+		(ring)->last_written_p = 0;				\
+		(ring)->loopcount = 0;					\
+		(ring)->data						\
+			= (unsigned char*)				\
+			(kmalloc(_length*(ring)->skip,			\
+				 GFP_KERNEL));				\
+		(ring)->shared_ev_pointer.ev_p =0;			\
+		(ring)->shared_ev_pointer.lock =			\
+			__SPIN_LOCK_UNLOCKED((ring)->shared_ev_pointer->loc); \
+}
+
+#define FREE_INDUSTRIALIO_RING_BUFFER(ring)	\
+	kfree((ring)->data)
+
+int industrialio_store_to_ring(struct industrialio_ring_buffer *ring,
+			       unsigned char* data,
+			       s64 timestamp);
+
+/* Edge cases :
+   1) data at last_p is no longer valid - requires complete wrap around.
+      To detect, loop count has changed - if only by 1 then problem only
+      if current_lastp is equal to or greater than copy made at start.
+      If we have wrapped an entire int in this time (loopcount) then
+      something very very weird has occured!
+*/
+int industrialio_read_last_from_ring(struct industrialio_ring_buffer *ring,
+					    unsigned char* data);
+/* Dump the ring */
+
+int
+industrialio_request_ring_buffer(int dimension,
+				 int bytes_per_reading,
+				 int length,
+				 struct industrialio_ring_buffer **ring,
+				 int id,
+				 struct module *owner,
+				 struct device *dev );
+
+
+void industrialio_free_ring_buffer(struct industrialio_ring_buffer* ring, struct device *dev);
+/* Device operating modes */
+#define INDIO_DIRECT_MODE		0x01
+#define INDIO_RING_POLLED		0x02
+#define INDIO_RING_DATA_RDY		0x04
+#define INDIO_RING_HARDWARE_BUFFER	0x08
+
+
+
+struct industrialio_event_interface {
+	struct industrialio_handler		handler;
+	wait_queue_head_t			wait;
+	struct industrialio_detected_event_list	det_events;
+	int					max_events;
+	int					current_events;
+	/* Integer id, used to differentiate this one form any others */
+	int					id;
+	struct industrialio_chrdev_minor_attr	attr;
+	struct module				*owner;
+	void					*private;
+};
+
+
+struct industrialio_shared_ev_pointer {
+	struct industrialio_detected_event_list	*ev_p;
+	spinlock_t lock;
+};
+/* A general ring buffer structure
+   Intended to be completely lock free as we always want fills from the interrupt
+   handler to not have to wait.  This obviously increases the possible time required
+   to read from the buffer.  */
+struct industrialio_ring_buffer
+{
+	unsigned char*		data;
+	int			length;
+	int			dimension;
+	int			bytes;
+	int			size;
+	int			skip;
+	unsigned char		*read_p;
+	unsigned char		*write_p;
+	unsigned char		*last_written_p;
+	/* used to act as a point at which to signal an event */
+	unsigned char		*half_p;
+	int			loopcount;
+	/* accessing the ring buffer */
+	char*			access_minor_name;
+	struct industrialio_chrdev_minor_attr	access_minor_attr;
+	struct industrialio_handler		access_handler;
+	/* events triggered by the ring buffer */
+	char*			event_minor_name;
+	struct industrialio_event_interface ev_int;
+	/* a fully shared output event */
+	struct industrialio_shared_ev_pointer shared_ev_pointer;
+};
+/* Seperate registration functions were leading to very messy driver init */
+/* Vast majority of this is set by the industrialio subsystem.
+ * FIXME: Add a macro to set only the relevant stuff within a chip driver
+ */
+struct industrialio_dev {
+/* generic handling data used by ind io */
+	int id;
+/* device specific data */
+	void *dev_data;
+
+/* Modes the drivers supports */
+	int modes; /* Driver Set */
+	int currentmode;
+/* Direct sysfs related functionality */
+	struct device *sysfs_dev;
+	struct device *dev; /* Driver Set */
+	/* General attributes */
+	const struct attribute_group *attrs;
+
+/* Interrupt handling related */
+	/* FIXME: GETTING MESSY! */
+	struct module *driver_module;
+	int 				num_interrupt_lines; /* Driver Set */
+
+	struct industrialio_interrupt **interrupts;
+
+
+	/* Event control attributes */
+	const struct attribute_group *event_attrs;
+	/* The character device related elements */
+	struct industrialio_event_interface *event_interfaces;
+
+/* Software Ring Buffer - for now assuming only makes sense to have a single ring */
+	int ring_dimension;
+	int ring_bytes_per_reading;
+	int ring_length;
+	struct industrialio_ring_buffer *ring;
+	struct attribute_group *ring_attrs_group;
+	struct industrialio_ring_attr *ring_attrs;
+};
+
+int industrialio_device_register(struct industrialio_dev *dev_info);
+
+void industrialio_device_unregister(struct industrialio_dev *dev_info);
+
+/* Wrapper class used to allow easy specification of different line numbers */
+struct industrialio_interrupt {
+	struct industrialio_dev *dev_info;
+	int line_number;
+	int irq;
+	struct industrialio_event_handler_list ev_list;
+};
+
+irqreturn_t industrialio_interrupt_handler(int irq, void *_int_info);
+
+int industrialio_register_interrupt_line(unsigned int			irq,
+					 struct industrialio_dev	*dev_info,
+					 int				line_number,
+					 unsigned long			type,
+					 const char			*name);
+
+void industrialio_unregister_interrupt_line(struct industrialio_dev *dev_info,
+					    int line_number);
+
+
+/* Used to try inserting an event into the list for userspace reading via
+ * chrdev */
+int industrialio_put_event(struct industrialio_dev *dev_info,
+			   int ev_line,
+			   int ev_code,
+			   s64 timestamp);
+#endif /* _INDUSTRIAL_IO_H_ */
--- a/include/linux/industrialio_sysfs.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/industrialio_sysfs.h	2008-06-26 16:44:50.000000000 +0100
@@ -0,0 +1,207 @@
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
+#include <linux/industrialio.h>
+
+
+struct industrialio_event_attr {
+	struct device_attribute dev_attr;
+	int mask;
+	struct industrialio_event_handler_list *listel;
+};
+
+
+#define to_industrialio_event_attr(_dev_attr) \
+	container_of(_dev_attr, struct industrialio_event_attr, dev_attr)
+
+
+struct industrialio_chrdev_minor_attr {
+	struct device_attribute dev_attr;
+	int minor;
+};
+
+#define to_industrialio_chrdev_minor_attr(_dev_attr) \
+	container_of(_dev_attr, struct industrialio_chrdev_minor_attr, dev_attr);
+
+struct industrialio_dev_attr {
+	struct device_attribute dev_attr;
+	int address;
+};
+
+
+#define to_industrialio_dev_attr(_dev_attr) \
+	container_of(_dev_attr, struct industrialio_dev_attr, dev_attr)
+
+/* Some attributes will be hard coded (device dependant) and not require an
+   address, in these cases pass a negative */
+#define INDUSTRIALIO_ATTR(_name, _mode, _show, _store, _addr)	\
+	{ .dev_attr = __ATTR(_name, _mode, _show, _store), \
+	  .address = _addr }
+
+#define INDUSTRIALIO_DEVICE_ATTR(_name, _mode, _show, _store, _addr)	\
+	struct industrialio_dev_attr industrialio_dev_attr_##_name	\
+	= INDUSTRIALIO_ATTR(_name, _mode, _show, _store, _addr)
+
+/* This may get broken down into separate files later */
+
+/* For devices with internal clocks - and possibly poling later */
+
+#define INDUSTRIALIO_DEV_ATTR_SAMP_FREQ(_mode, _show, _store) \
+	INDUSTRIALIO_DEVICE_ATTR(sampling_frequency, _mode,   \
+				 _show, _store, 0)
+
+#define INDUSTRIALIO_DEV_ATTR_AVAIL_SAMP_FREQ(_show)\
+	INDUSTRIALIO_DEVICE_ATTR(available_sampling_frequency,	\
+				 S_IRUGO, _show, NULL, 0)
+
+/* Accelerometer types of attribute */
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_X_OFFSET(_mode, _show, _store, _addr) \
+	INDUSTRIALIO_DEVICE_ATTR(x_offset, _mode, _show, _store, _addr)
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_Y_OFFSET(_mode, _show, _store, _addr) \
+	INDUSTRIALIO_DEVICE_ATTR(y_offset, _mode, _show, _store, _addr)
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_Z_OFFSET(_mode, _show, _store, _addr) \
+	INDUSTRIALIO_DEVICE_ATTR(z_offset, _mode, _show, _store, _addr)
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_X_GAIN(_mode, _show, _store, _addr)	\
+	INDUSTRIALIO_DEVICE_ATTR(x_gain, _mode, _show, _store, _addr)
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_Y_GAIN(_mode, _show, _store, _addr)	\
+	INDUSTRIALIO_DEVICE_ATTR(y_gain, _mode, _show, _store, _addr)
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_Z_GAIN(_mode, _show, _store, _addr)	\
+	INDUSTRIALIO_DEVICE_ATTR(z_gain, _mode, _show, _store, _addr)
+
+
+/* The actual device readings are always going to be read only */
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_X(_show, _addr)			\
+	INDUSTRIALIO_DEVICE_ATTR(x, S_IRUGO, _show, NULL, _addr)
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_Y(_show, _addr)			\
+	INDUSTRIALIO_DEVICE_ATTR(y, S_IRUGO, _show, NULL, _addr)
+
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_Z(_show, _addr)			\
+	INDUSTRIALIO_DEVICE_ATTR(z, S_IRUGO, _show, NULL, _addr)
+
+/* Thresholds are somewhat chip dependent - may need quite a few defs here */
+#define INDUSTRIALIO_DEV_ATTR_ACCEL_THRESH(_mode, _show, _store, _addr) \
+	INDUSTRIALIO_DEVICE_ATTR(thresh, _mode, _show, _store, _addr)
+
+
+
+/* Events that the device may generate */
+/* How to do this. Is it valid to have sysfs elements which can be neither
+   read nor written? */
+/*  GOING TO NEED a usage count */
+#define INDUSTRIALIO_EVENT_SH(_name, _handler)			\
+	static struct industrialio_event_handler_list			\
+	industrialio_event_##_name = {				\
+		.handler=_handler,				\
+		.refcount = 0,					\
+	};
+#define INDUSTRIALIO_EVENT_ATTR_SH(_name, _ev_list, _show, _store, _mask) \
+	static struct industrialio_event_attr				\
+	industrialio_event_attr_##_name					\
+	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR, _show, _store),\
+	    .mask = _mask,\
+	    .listel = &_ev_list };
+
+/*FIXME use the above to define this */
+#define INDUSTRIALIO_EVENT_ATTR(_name, _show, _store, _mask, _handler)	\
+	static struct industrialio_event_handler_list				\
+	industrialio_event_##_name = {				\
+		.handler=_handler,					\
+	};								\
+	static struct							\
+	industrialio_event_attr						\
+	industrialio_event_attr_##_name					\
+	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR, _show, _store), \
+	    .mask = _mask,						\
+	    .listel = &industrialio_event_##_name };		\
+/*FIXME, add line number to the above?*/
+
+/* In most of these cases, this actually corresponds to something with a
+   value attached */
+
+/* For some devices you can select whether all conditions or any condition
+   must be met for interrupt generation */
+#define INDUSTRIALIO_EVENT_ATTR_DATA_RDY(_show, _store, _mask, _handler) \
+	INDUSTRIALIO_EVENT_ATTR(data_rdy, _show, _store, _mask, _handler)
+
+#define INDUSTRIALIO_EVENT_CODE_DATA_RDY  100
+
+/* Threshold pass events */
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_X_HIGH(_show, _store, _mask, _handler) \
+	INDUSTRIALIO_EVENT_ATTR(x_high, _show, _store, _mask, _handler)
+
+#define INDUSTRIALIO_EVENT_CODE_ACCEL_X_HIGH 1
+
+/* Shared handler version */
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_X_HIGH_SH(_evlist, _show, _store, _mask)\
+	INDUSTRIALIO_EVENT_ATTR_SH(x_high, _evlist, _show, _store, _mask)
+
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Y_HIGH(_show, _store, _mask, _handler) \
+	INDUSTRIALIO_EVENT_ATTR(y_high, _show, _store, _mask, _handler)
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Y_HIGH_SH(_evlist, _show, _store, _mask)\
+	INDUSTRIALIO_EVENT_ATTR_SH(y_high, _evlist, _show, _store, _mask)
+
+#define INDUSTRIALIO_EVENT_CODE_ACCEL_Y_HIGH 2
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Z_HIGH(_show, _store, _mask, _handler) \
+	INDUSTRIALIO_EVENT_ATTR(z_high, _show, _store, _mask, _handler)
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Z_HIGH_SH(_evlist, _show, _store, _mask)\
+	INDUSTRIALIO_EVENT_ATTR_SH(z_high, _evlist, _show, _store, _mask)
+
+#define INDUSTRIALIO_EVENT_CODE_ACCEL_Z_HIGH 3
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_X_LOW(_show, _store, _mask, _handler) \
+	INDUSTRIALIO_EVENT_ATTR(x_low, _show, _store, _mask, _handler)
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_X_LOW_SH(_evlist, _show, _store, _mask)\
+	INDUSTRIALIO_EVENT_ATTR_SH(x_low, _evlist, _show, _store, _mask)
+
+#define INDUSTRIALIO_EVENT_CODE_ACCEL_X_LOW 4
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Y_LOW(_show, _store, _mask, _handler) \
+	INDUSTRIALIO_EVENT_ATTR(y_low, _show, _store, _mask, _handler)
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Y_LOW_SH(_evlist,_show, _store, _mask)\
+	INDUSTRIALIO_EVENT_ATTR_SH(y_low, _evlist, _show, _store, _mask)
+
+#define INDUSTRIALIO_EVENT_CODE_ACCEL_Y_LOW 5
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Z_LOW(_show, _store, _mask, _handler) \
+	INDUSTRIALIO_EVENT_ATTR(z_low, _show, _store, _mask, _handler)
+
+#define INDUSTRIALIO_EVENT_ATTR_ACCEL_Z_LOW_SH(_evlist, _show, _store, _mask)\
+	INDUSTRIALIO_EVENT_ATTR_SH(z_low, _evlist, _show, _store, _mask)
+
+#define INDUSTRIALIO_EVENT_CODE_ACCEL_Z_LOW 6
+
+
+#define INDUSTRIALIO_EVENT_CODE_RING_50_FULL 100
+#define INDUSTRIALIO_EVENT_CODE_RING_100_FULL 101
+/* HOW TO HANDLE COMPOSITE EVENTS? */
+
+
+
+
+/* function that takes a list of these and puts them in an events directory? */
+
+#endif /* _INDUSTRIAL_IO_SYSFS_H_ */
--- a/include/linux/spi/lis3l02dq.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/spi/lis3l02dq.h	2008-05-27 20:18:00.000000000 +0100
@@ -0,0 +1,6 @@
+
+
+struct LIS3L02DQ_platform_data {
+  unsigned data_ready_gpio;
+};
+

--------------030402030807090203070705--
