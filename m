Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYGWSb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYGWSb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYGWSbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:31:18 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:1418 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753161AbYGWSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:31:17 -0400
Date: Wed, 23 Jul 2008 22:31:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>, hmh@hmh.eng.br,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [Patch 1/4] Industrialio Core
Message-ID: <20080723183113.GA22142@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <488763AD.4050400@gmail.com> <488765A5.3040703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <488765A5.3040703@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Sorry, I didn't comment on the first version. So my comments for
this version is below. Note, I only briefly looked in the code,
thus the comments are really superficial.

So... this subsystem is _huge_. And so it needs documentation. Yes,
the code is well commented, much thanks for this. But the
documentation is needed, for example, to answer these simple
questions:

- What userspace interface the subsystem provides (i.e. for use with
  userspace tools).
- What kernel interface the subsystem provides (i.e. for use with
  in-kernel drivers, for example touchscreens).
- What is iio_ring (as I see it, is one of basic concepts of this
  subsystem), I'd like to see description of its basic usage.
- What is struct iio_event_data, what is event's "id"? How it is used
  across subsystem?

There is a lot of questions more. Of course, half the questions I'll
answer myself through reading the code... But you really need to
describe basic ideas of 2431-LOC-subsystem.

Something like Documentation/gpio.txt would work.

On the subsystem itself. I would recommend you to split the 
industrialio_{core,rtc,ring,ptimer_board_info} into separate modules
(if possible) and into separate patches (for better reviewing).

Few more comments below.

[...]
> +
> +#define INIT_IIO_RING_BUFFER(ring_buf, _bytes_per_datum, _length) {	\
> +		(ring_buf)->size = _bytes_per_datum;			\
> +		(ring_buf)->length = _length;				\
> +		(ring_buf)->loopcount = 0;				\
> +		(ring_buf)->shared_ev_pointer.ev_p = 0;			\
> +		(ring_buf)->shared_ev_pointer.lock =			\
> +			__SPIN_LOCK_UNLOCKED((ring_buf)			\
> +					     ->shared_ev_pointer->loc);	\
> +	}

Is it possible to convert this into function?

> +#define INIT_IIO_SW_RING_BUFFER(ring, _bytes_per_datum, _length) {	\
> +		INIT_IIO_RING_BUFFER(&(ring)->buf,			\
> +				     _bytes_per_datum,			\
> +				     _length);				\
> +		(ring)->read_p = 0;					\
> +		(ring)->write_p = 0;					\
> +		(ring)->last_written_p = 0;				\
> +		(ring)->data = kmalloc(_length*(ring)->buf.size,	\
> +				       GFP_KERNEL);			\
> +		(ring)->use_count = 0;					\
> +		(ring)->use_lock = __SPIN_LOCK_UNLOCKED((ring)->use_lock); \
> +	}
> +
> +#define FREE_IIO_SW_RING_BUFFER(ring) kfree((ring)->data)

Ditto.

[...]
> +/* Vast majority of this is set by the industrialio subsystem on a
> + * call to iio_device_register. */
> +/* TODO Macros to simplify setting the relevant stuff in the driver. */
> +struct iio_dev {
> +/* generic handling data used by ind io */
> +	int id;
> +/* device specific data */
> +	void *dev_data;
> +
> +/* Modes the drivers supports */
> +	int modes; /* Driver Set */
> +	int currentmode;
> +/* Direct sysfs related functionality */
> +	struct device *sysfs_dev;
> +	struct device *dev; /* Driver Set */
> +	/* General attributes */
> +	const struct attribute_group *attrs;
> +
> +/* Interrupt handling related */
> +	struct module *driver_module;
> +	int num_interrupt_lines; /* Driver Set */
> +
> +	struct iio_interrupt **interrupts;
> +
> +
> +	/* Event control attributes */
> +	struct attribute_group *event_attrs;
> +	/* The character device related elements */
> +	struct iio_event_interface *event_interfaces;
> +
> +/* Software Ring Buffer
> +   - for now assuming only makes sense to have a single ring */

These comments are really hard to parse. Try to turn off syntax
highlighting (if you use), and see the result. It is really
unreadable.

So, I'd suggest to use kernel doc syntax to describe the fields.

For example, I very like how include/linux/mtd/nand.h is commented.
It is in kernel doc, plus explains what fields are
internal/driver-specific/e.t.c.

> +	int ring_dimension;
> +	int ring_bytes_per_datum;
> +	int ring_length;
> +	struct iio_sw_ring_buffer *ring;
> +	struct attribute_group *ring_attrs_group;
> +	struct iio_ring_attr *ring_attrs;
> +	/* enabling / disabling related functions.
> +	 * post / pre refer to relative to the change of current_mode. */
> +	int (*ring_preenable)(struct iio_dev *);
> +	int (*ring_postenable)(struct iio_dev *);
> +	int (*ring_predisable)(struct iio_dev *);
> +	int (*ring_postdisable)(struct iio_dev *);
> +	void (*ring_poll_func)(void *private_data);
> +	struct iio_periodic  *ptimer;
> +
> +	/* Device state lock.
> +	 * Used to prevent simultaneous changes to device state.
> +	 * In here rather than modules as some ring buffer changes must occur
> +	 * with this locked.*/
> +	struct mutex			mlock;
> +
> +	/* Name used to allow releasing of the relevant ptimer on exit.
> +	 * Ideally the ptimers will only be held when the driver is actually
> +	 * using them, but for now they have one the whole time they are loaded.
> +	 */
> +	const char *ptimer_name;
> +};

[...]
> --- a/include/linux/industrialio_sysfs.h	1970-01-01 01:00:00.000000000 +0100
> +++ b/include/linux/industrialio_sysfs.h	2008-07-23 16:04:18.000000000 +0100
> @@ -0,0 +1,274 @@
> +/* The industrial I/O core
> + *
> + *Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * General attributes
> + */
> +
> +#ifndef _INDUSTRIAL_IO_SYSFS_H_
> +#define _INDUSTRIAL_IO_SYSFS_H_
> +
> +#include <linux/industrialio.h>
> +
> +
> +struct iio_event_attr {
> +	struct device_attribute dev_attr;
> +	int mask;
> +	struct iio_event_handler_list *listel;
> +};
> +
> +
> +#define to_iio_event_attr(_dev_attr) \
> +	container_of(_dev_attr, struct iio_event_attr, dev_attr)
> +
> +
> +struct iio_chrdev_minor_attr {
> +	struct device_attribute dev_attr;
> +	int minor;
> +};
> +
> +void
> +__init_iio_chrdev_minor_attr(struct iio_chrdev_minor_attr *minor_attr,
> +			   const char *name,
> +			   struct module *owner,
> +			   int id);
> +
> +
> +#define to_iio_chrdev_minor_attr(_dev_attr) \
> +	container_of(_dev_attr, struct iio_chrdev_minor_attr, dev_attr);
> +
> +struct iio_dev_attr {
> +	struct device_attribute dev_attr;
> +	int address;
> +};
> +
> +
> +#define to_iio_dev_attr(_dev_attr) \
> +	container_of(_dev_attr, struct iio_dev_attr, dev_attr)
> +
> +/* Some attributes will be hard coded (device dependant) and not require an
> +   address, in these cases pass a negative */
> +#define IIO_ATTR(_name, _mode, _show, _store, _addr)	\
> +	{ .dev_attr = __ATTR(_name, _mode, _show, _store),	\
> +	  .address = _addr }
> +
> +#define IIO_DEVICE_ATTR(_name, _mode, _show, _store, _addr)	\
> +	struct iio_dev_attr iio_dev_attr_##_name		\
> +	= IIO_ATTR(_name, _mode, _show, _store, _addr)
> +
> +/* This may get broken down into separate files later */
> +
> +/* Generic attributes of onetype or another */
> +
> +/* Revision number for the device. As the form of this varies greatly from
> + * device to device, no particular form is specified. In most cases this will
> + * only be for information to the user, not to effect functionality etc.
> + */
> +#define IIO_DEV_ATTR_REV(_show)			\
> +	IIO_DEVICE_ATTR(revision, S_IRUGO, _show, NULL, 0)
> +
> +/* For devices with internal clocks - and possibly poling later */
> +
> +#define IIO_DEV_ATTR_SAMP_FREQ(_mode, _show, _store)			\
> +	IIO_DEVICE_ATTR(sampling_frequency, _mode, _show, _store, 0)
> +
> +#define IIO_DEV_ATTR_AVAIL_SAMP_FREQ(_show)				\
> +	IIO_DEVICE_ATTR(available_sampling_frequency, S_IRUGO, _show, NULL, 0)
> +
> +/* ADC types of attibute */
> +
> +#define IIO_DEV_ATTR_AVAIL_SCAN_MODES(_show)				\
> +	IIO_DEVICE_ATTR(available_scan_modes, S_IRUGO, _show, NULL, 0)
> +
> +#define IIO_DEV_ATTR_SCAN_MODE(_mode, _show, _store)		\
> +	IIO_DEVICE_ATTR(scan_mode, _mode, _show, _store, 0)
> +
> +#define IIO_DEV_ATTR_INPUT(_number, _show)				\
> +	IIO_DEVICE_ATTR(in##_number, S_IRUGO, _show, NULL, _number)
> +
> +#define IIO_DEV_ATTR_SCAN(_show)		\
> +	IIO_DEVICE_ATTR(scan, S_IRUGO, _show, NULL, 0);
> +/* Accelerometer types of attribute */
> +
> +#define IIO_DEV_ATTR_ACCEL_X_OFFSET(_mode, _show, _store, _addr) \
> +	IIO_DEVICE_ATTR(x_offset, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_Y_OFFSET(_mode, _show, _store, _addr) \
> +	IIO_DEVICE_ATTR(y_offset, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_Z_OFFSET(_mode, _show, _store, _addr) \
> +	IIO_DEVICE_ATTR(z_offset, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_X_GAIN(_mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(x_gain, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_Y_GAIN(_mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(y_gain, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_Z_GAIN(_mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(z_gain, _mode, _show, _store, _addr)
> +

Why such a generic subsystem should be aware of X/Y/Z? ADC can measure
strength of wind, for example. But in fact it measures voltage and/or
current. Yes, it is convenient to tell user what exactly chip is
supposed to measure, but it is chip (and thus driver) specific,
subsystem should only provides means to expose that information, but
it should not be aware of what exactly we're measuring. At least that is
how I imagine the ADC subsystem.


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
