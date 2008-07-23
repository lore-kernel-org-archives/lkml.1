Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYGWTms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYGWTms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYGWTmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:42:37 -0400
Received: from trinity.fluff.org ([89.145.97.151]:41886 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbYGWTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:42:33 -0400
Date: Wed, 23 Jul 2008 20:42:30 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, David Brownell <david-b@pacbell.net>,
       hmh@hmh.eng.br, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 1/4] Industrialio Core
Message-ID: <20080723194230.GE26938@trinity.fluff.org>
References: <488763AD.4050400@gmail.com> <488765A5.3040703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488765A5.3040703@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 06:08:53PM +0100, Jonathan Cameron wrote:
> 
> From: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Industrialio subsystem core patch. This subsystem is intended to support the use
> of (initially) sensors within linux for the purposes of data capture and its use
> within control applications. The intention is to provide consistent interfaces
> (where it makes sense) with device control occuring through sysfs interfaces and
> provision of events to userspace via chrdevs. Currently software ring buffers
> are available if the sensor provides a data ready signal or a periodic rtc is
> available (and registered with the subsystem in board init code).
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
> The periodic timer code is a temporary stop gap until a more generic subsystem
> becomes available.
> 
> The intention of publishing these patches is to generate feedback both at the
> high level of suggestions / comments on the general approach taken by the
> subsystem as a whole and at the low level of implementation details.
> 
> Areas that in my view need attention are the software ring buffer (particularly
> careful analysis of corner cases and efficiency of it as a storage method).
> Although none of the current drivers is capable of filling it in interrupt
> context, I can envision some hardware may need to and this will clearly require
> some changes.  The overall layout of the interfaces (and indeed the code) needs
> some work, particularly with a view to cutting down the dependancies if a
> given driver doesn't need all of the systems functionality.
> 
> Additional test drivers will obviously assist in working out many of these
> issues and I hope to add several more over the comming weeks.
> 
> My sincerest thanks goes to anyone who takes the time to read through or test
> this patch set.
> 
> drivers/Kconfig                                       |    3
> drivers/Makefile                                      |    1
> drivers/industrialio/Kconfig                          |   19
> drivers/industrialio/Makefile                         |    7
> drivers/industrialio/industrialio-core.c              |  787 ++++++++++++++++++
> drivers/industrialio/industrialio-ring.c              |  770 +++++++++++++++++
> drivers/industrialio/industrialio-rtc.c               |  134 +++
> drivers/industrialio/industrialio_ptimer_board_info.c |   44 +
> include/linux/industrialio.h                          |  374 ++++++++
> include/linux/industrialio_ptimer.h                   |   18
> include/linux/industrialio_sysfs.h                    |  274 ++++++
> 11 files changed, 2431 insertions(+)
> 
> ------ a/drivers/Kconfig	2008-07-13 22:51:29.000000000 +0100
> +++ b/drivers/Kconfig	2008-07-14 17:26:34.000000000 +0100
> @@ -101,4 +101,7 @@ source "drivers/auxdisplay/Kconfig"
>  source "drivers/uio/Kconfig"
>  
>  source "drivers/xen/Kconfig"
> +
> +source "drivers/industrialio/Kconfig" 
>  endmenu
> +
> --- a/drivers/Makefile	2008-07-13 22:51:29.000000000 +0100
> +++ b/drivers/Makefile	2008-07-14 17:26:34.000000000 +0100
> @@ -62,6 +62,7 @@ obj-$(CONFIG_INPUT)		+= input/
>  obj-$(CONFIG_I2O)		+= message/
>  obj-$(CONFIG_RTC_LIB)		+= rtc/
>  obj-y				+= i2c/
> +obj-y				+= industrialio/
>  obj-$(CONFIG_W1)		+= w1/
>  obj-$(CONFIG_POWER_SUPPLY)	+= power/
>  obj-$(CONFIG_HWMON)		+= hwmon/
> --- a/drivers/industrialio/Kconfig	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/industrialio/Kconfig	2008-07-23 15:44:45.000000000 +0100
> @@ -0,0 +1,19 @@
> +#
> +# Industrial I/O subsytem configuration
> +#
> +
> +menuconfig INDUSTRIALIO
> +	tristate "Industrial I/O support"
> +	---help---
> +	  The industrial IO subsystem provides a unified framework for drivers
> +	  for many different types of embedded sensors using a number of
> +	  different phyiscal interfaces (i2c, spi etc). See
> +	  Documentation/industrialio for more information.
> +
> +if INDUSTRIALIO
> +
> +config INDUSTRIALIO_PTIMER_BOARDINFO
> +       boolean
> +       default y
> +
> +endif
> --- a/drivers/industrialio/Makefile	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/industrialio/Makefile	2008-07-23 12:05:27.000000000 +0100
> @@ -0,0 +1,7 @@
> +#
> +# Makefile for the industrial I/O core.
> +#
> +industrialio-objs := industrialio-core.o industrialio-ring.o industrialio-rtc.o
> +
> +obj-$(CONFIG_INDUSTRIALIO)	+= industrialio.o
> +obj-$(CONFIG_INDUSTRIALIO_PTIMER_BOARDINFO) += industrialio_ptimer_board_info.o
> --- a/include/linux/industrialio.h	1970-01-01 01:00:00.000000000 +0100
> +++ b/include/linux/industrialio.h	2008-07-23 15:20:19.000000000 +0100
> @@ -0,0 +1,374 @@
> +/* The industrial I/O core
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#ifndef _INDUSTRIAL_IO_H_
> +#define _INDUSTRIAL_IO_H_
> +
> +#include <linux/device.h>
> +#include <linux/industrialio_sysfs.h>
> +
> +/* TODO LIST */
> +/* Static device specific elements (conversion factors etc)
> +   should be exported via sysfs
> +   Break up this header - some drivers only want a fraction of this.
> +*/
> +
> +
> +/* Event interface flags */
> +#define IIO_BUSY_BIT_POS 1
> +
> +
> +struct iio_handler {
> +	const struct file_operations *fops;
> +	int id;
> +	unsigned long flags;
> +	void *private;
> +};
> +
> +/* The actual event being pushed ot userspace */
> +struct iio_event_data {
> +	int id;
> +	s64 timestamp;
> +};

So is this an header for an event? Where is the data in this, this
is confusing... Also, should we have a framework to produce an
key/pair data, so that an single event can export multiple values
from one event...

ie:

struct event_header {
	unsigned int 	id;
	unsigned int	nr_data;	/* number of event_data after */
	s64		timestamp;

struct event {
	struct event_header	header;
	struct event_data	data[0];
};

> +
> +struct iio_detected_event_list {
> +	struct list_head list;
> +	struct iio_event_data ev;
> +	/* Part of shared event handling - (typicaly ring buffers) */
> +	struct iio_shared_ev_pointer *shared_pointer;
> +};

the naming of these structures is rather long.

> +/* Requires high resolution timers */
> +/*  TODO - provide alternative if not available? */
> +static inline s64 iio_get_time_ns(void)
> +{
> +	struct timespec ts;
> +	ktime_get_ts(&ts);
> +	return timespec_to_ns(&ts);
> +}

do we really need something that accurate? we should at-least have
the option to remove the timestamp or choose something of lower
accuracy?

> +struct iio_dev;
> +
> +/* Each device has one of these per interrupt */
> +struct iio_event_handler_list {
> +	struct list_head list;
> +	int (*handler)(struct iio_dev *dev_io, int index, s64 timestamp,
> +		       int no_test);
> +	/* This element may be shared */
> +	int refcount;
> +};
> +
> +/* Wraps adding to lists and does reference counting to allowed shared
> + * handlers.
> + */
> +int iio_add_event_to_list(struct iio_event_handler_list *list,
> +			  struct iio_event_handler_list *el);
> +
> +int iio_remove_event_from_list(struct iio_event_handler_list *el);
> +
> +struct iio_sw_ring_buffer;
> +struct iio_hw_ring_buffer;
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
> +
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

these should be inlined functions.

> +#define FREE_IIO_SW_RING_BUFFER(ring) kfree((ring)->data)
> +
> +
> +
> +int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
> +		      unsigned char *data,
> +		      s64 timestamp);
> +
> +/* Edge cases :
> +   1) data at last_p is no longer valid - requires complete wrap around.
> +   To detect, loop count has changed - if only by 1 then problem only
> +   if current_lastp is equal to or greater than copy made at start.
> +   If we have wrapped an entire int in this time (loopcount) then
> +   something very very weird has occured!
> +*/
> +int iio_read_last_from_sw_ring(struct iio_sw_ring_buffer *ring,
> +			       unsigned char *data);
> +
> +/* Up to the drivers to mark the ring whenever it must not change size
> + * and unmark when it may without problems */
> +void iio_mark_sw_ring_buffer_in_use(struct iio_sw_ring_buffer *ring);
> +
> +void iio_unmark_sw_ring_buffer_in_use(struct iio_sw_ring_buffer *ring);
> +
> +int iio_request_sw_ring_buffer(int bytes_per_datum,
> +			       int length,
> +			       struct iio_sw_ring_buffer **ring,
> +			       int id,
> +			       struct module *owner,
> +			       struct device *dev);
> +

how about tying this to a driver, where you already know the owner
and the dev?

> +int iio_request_update_sw_ring_buffer(struct iio_dev *dev_info, int id);
> +
> +void iio_free_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
> +			     struct device *dev);
> +
> +int iio_request_hw_ring_buffer(int bytes_per_datum,
> +			       int length,
> +			       struct iio_hw_ring_buffer **ring,
> +			       int id,
> +			       struct module *owner,
> +			       struct device *dev,
> +			       const struct file_operations *fops,
> +			       void *private);
> +
> +void iio_free_hw_ring_buffer(struct iio_hw_ring_buffer *ring,
> +			     struct device *dev);
> +
> +/* Device operating modes */
> +#define INDIO_DIRECT_MODE		0x01
> +#define INDIO_RING_POLLED		0x02
> +#define INDIO_RING_DATA_RDY		0x04
> +#define INDIO_RING_HARDWARE_BUFFER	0x08
> +
> +struct iio_event_interface {
> +	struct iio_handler			handler;
> +	wait_queue_head_t			wait;
> +	struct mutex				event_list_lock;
> +	struct iio_detected_event_list		det_events;
> +	int					max_events;
> +	int					current_events;
> +	/* Integer id, used to differentiate this one form any others */
> +	int					id;
> +	struct iio_chrdev_minor_attr		attr;
> +	struct module				*owner;
> +	void					*private;
> +	/* used to store name for associated sysfs file */
> +	char					_name[20];
> +};
> +
> +struct iio_shared_ev_pointer {
> +	struct iio_detected_event_list	*ev_p;
> +	spinlock_t lock;
> +};
> +
> +/* A general ring buffer structure
> + *  Intended to be completely lock free as we always want fills from
> + * the interrupt handler to not have to wait.  This obviously increases
> + * the possible time required to read from the buffer.  */
> +struct iio_ring_buffer {
> +	/* Number of datums */
> +	int			length;
> +	/* length of single datum - including timestamp if there */
> +	int			size;
> +	int			loopcount;
> +	/* accessing the ring buffer */
> +	char			*access_minor_name;
> +	struct iio_chrdev_minor_attr	access_minor_attr;
> +	struct iio_handler		access_handler;
> +	/* events triggered by the ring buffer */
> +	char			*event_minor_name;
> +	struct iio_event_interface ev_int;
> +	/* a fully shared output event ? wtf?*/
> +	struct iio_shared_ev_pointer shared_ev_pointer;
> +};
> +
> +int iio_put_ring_event(struct iio_ring_buffer *ring_buf,
> +		       int event_code,
> +		       s64 timestamp);
> +
> +int iio_put_or_escallate_ring_event(struct iio_ring_buffer *ring_buf,
> +				    int event_code,
> +				    s64 timestamp);
> +
> +struct iio_sw_ring_buffer {
> +	struct iio_ring_buffer buf;
> +	unsigned char		*data;
> +	unsigned char		*read_p;
> +	unsigned char		*write_p;
> +	unsigned char		*last_written_p;
> +	/* used to act as a point at which to signal an event */
> +	unsigned char		*half_p;
> +	int			use_count;
> +	int			update_needed;
> +	spinlock_t		use_lock;
> +};
> +
> +struct iio_hw_ring_buffer {
> +	struct iio_ring_buffer buf;
> +	void *private;
> +};
> +
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
> +
> +int iio_device_register(struct iio_dev *dev_info);
> +void iio_device_unregister(struct iio_dev *dev_info);
> +
> +/* Wrapper class used to allow easy specification of different line numbers */
> +struct iio_interrupt {
> +	struct iio_dev *dev_info;
> +	int line_number;
> +	int irq;
> +	struct iio_event_handler_list ev_list;
> +};
> +
> +irqreturn_t iio_interrupt_handler(int irq, void *_int_info);
> +
> +int iio_register_interrupt_line(unsigned int			irq,
> +				struct iio_dev	*dev_info,
> +				int				line_number,
> +				unsigned long			type,
> +				const char			*name);
> +
> +void iio_unregister_interrupt_line(struct iio_dev *dev_info,
> +				   int line_number);
> +
> +
> +/* Used to try inserting an event into the list for userspace reading via
> + * chrdev */
> +int iio_put_event(struct iio_dev *dev_info,
> +		  int ev_line,
> +		  int ev_code,
> +		  s64 timestamp);
> +
> +struct iio_work_cont {
> +	struct work_struct ws;
> +	struct work_struct ws_nocheck;
> +	int address;
> +	int mask;
> +	void *st;
> +};
> +#define INIT_IIO_WORK_CONT(cont, _checkfunc, _nocheckfunc, _add, _mask, _st)\
> +	do {								\
> +	INIT_WORK(&(cont)->ws, _checkfunc);				\
> +	INIT_WORK(&(cont)->ws_nocheck, _nocheckfunc);			\
> +	(cont)->address = _add;						\
> +	(cont)->mask = _mask;						\
> +	(cont)->st = _st;						\
> +	} while (0)

more nasty macros.

> +/* Ring buffer related */
> +int iio_device_register_sw_ring(struct iio_dev *dev_info, int id);
> +void iio_device_unregister_sw_ring(struct iio_dev *dev_info);
> +
> +int __iio_put_event(struct iio_event_interface *ev_int,
> +		int ev_code,
> +		s64 timestamp,
> +		struct iio_shared_ev_pointer*
> +		shared_pointer_p);
> +void __iio_change_event(struct iio_detected_event_list *ev,
> +			int ev_code,
> +			s64 timestamp);
> +
> +int iio_setup_ev_int(struct iio_event_interface *ev_int,
> +		     const char *name,
> +		     struct module *owner,
> +		     struct device *dev);
> +
> +void iio_free_ev_int(struct iio_event_interface *ev_int,  struct device *dev);
> +
> +int iio_allocate_chrdev(struct iio_handler *handler);
> +void iio_deallocate_chrdev(struct iio_handler *handler);
> +
> +ssize_t iio_show_attr_minor(struct device *dev,
> +			    struct device_attribute *attr,
> +			    char *buf);
> +
> +/* For now this is on the type of periodic timer used*/
> +struct iio_periodic {
> +	struct rtc_device *rtc;
> +	int frequency;
> +	struct rtc_task task;
> +};
> +
> +int iio_ptimer_request_periodic_timer(char *name, struct iio_dev *indio_dev);
> +void iio_ptimer_unrequest_periodic_timer(struct iio_dev *indio_dev);
> +int iio_ptimer_set_freq(struct iio_periodic *ptimer, unsigned frequency);
> +int iio_ptimer_irq_set_state(struct iio_dev *indio_dev, bool state);
> +
> +/* Board registration is handled by contents of
> + * industrialio_ptimer_board_info.c
> + */
> +extern struct mutex industrialio_ptimer_board_lock;
> +extern struct list_head industrialio_ptimer_board_info_list;
> +#endif /* _INDUSTRIAL_IO_H_ */
> --- a/include/linux/industrialio_ptimer.h	1970-01-01 01:00:00.000000000 +0100
> +++ b/include/linux/industrialio_ptimer.h	2008-07-23 15:41:29.000000000 +0100
> @@ -0,0 +1,18 @@
> +#ifndef _INDUSTRIALIO_PTIMER_H_
> +#define _INDUSTRIALIO_PTIMER_H_
> +
> +#define IIO_PTIMER_NAME_SIZE 10
> +
> +
> +struct ptimer_info {
> +	char name[IIO_PTIMER_NAME_SIZE];
> +};
> +struct ptimer_info_listel {
> +	struct list_head list;
> +	bool inuse;
> +	struct ptimer_info info;
> +};
> +
> +extern int
> +industrialio_register_ptimer(struct ptimer_info const *info, unsigned n);
> +#endif
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
> +
> +/* The actual device readings are always going to be read only */
> +#define IIO_DEV_ATTR_ACCEL_X(_show, _addr)			\
> +	IIO_DEVICE_ATTR(x, S_IRUGO, _show, NULL, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_Y(_show, _addr)			\
> +	IIO_DEVICE_ATTR(y, S_IRUGO, _show, NULL, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_Z(_show, _addr)			\
> +	IIO_DEVICE_ATTR(z, S_IRUGO, _show, NULL, _addr)
> +
> +#define IIO_DEV_ATTR_TEMP(_show)					\
> +	IIO_DEVICE_ATTR(temp, S_IRUGO, _show, NULL, 0)
> +/* Thresholds are somewhat chip dependent - may need quite a few defs here */
> +/* For unified thesholds (shared across all directions */
> +#define IIO_DEV_ATTR_ACCEL_THRESH(_mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(thresh, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_THRESH_X(_mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(thresh_x, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_THRESH_Y(_mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(thresh_y, _mode, _show, _store, _addr)
> +
> +#define IIO_DEV_ATTR_ACCEL_THRESH_Z(_mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(thresh_z, _mode, _show, _store, _addr)
> +
> +/* This is an event attr in some case and a dev in others - FIX*/
> +#define IIO_DEV_ATTR_SW_RING_ENABLE(_show, _store)			\
> +	IIO_DEVICE_ATTR(sw_ring_enable, S_IRUGO | S_IWUSR, _show, _store, 0)
> +
> +/* Hardware ring buffer related attributes */
> +#define IIO_DEV_ATTR_HW_RING_ENABLE(_show, _store)			\
> +	IIO_DEVICE_ATTR(hw_ring_enable, S_IRUGO | S_IWUSR, _show, _store, 0)
> +
> +#define IIO_DEV_ATTR_RING_BPS(_mode, _show, _store)		\
> +	IIO_DEVICE_ATTR(ring_bps, _mode, _show, _store, 0)
> +
> +/* Bits per sample */
> +#define IIO_DEV_ATTR_RING_BPS_AVAILABLE(_show)				\
> +	IIO_DEVICE_ATTR(ring_bps_available, S_IRUGO, _show, NULL, 0)
> +
> +/* Events that the device may generate */
> +
> +#define IIO_EVENT_SH(_name, _handler)					\
> +	static struct iio_event_handler_list				\
> +	iio_event_##_name = {						\
> +		.handler = _handler,					\
> +		.refcount = 0,						\
> +	};
> +#define IIO_EVENT_ATTR_SH(_name, _ev_list, _show, _store, _mask)	\
> +	static struct iio_event_attr				\
> +	iio_event_attr_##_name					\
> +	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR, _show, _store),\
> +	    .mask = _mask,\
> +	    .listel = &_ev_list };
> +
> +/*FIXME use the above to define this */
> +#define IIO_EVENT_ATTR(_name, _show, _store, _mask, _handler)	\
> +	static struct iio_event_handler_list				\
> +	iio_event_##_name = {				\
> +		.handler = _handler,					\
> +	};								\
> +	static struct							\
> +	iio_event_attr						\
> +	iio_event_attr_##_name					\
> +	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR, _show, _store), \
> +	    .mask = _mask,						\
> +	    .listel = &iio_event_##_name };		\
> +/*FIXME, add line number to the above?*/
> +
> +/* In most of these cases, this actually corresponds to something with a
> +   value attached */
> +
> +/* For some devices you can select whether all conditions or any condition
> +   must be met for interrupt generation */
> +#define IIO_EVENT_ATTR_DATA_RDY(_show, _store, _mask, _handler) \
> +	IIO_EVENT_ATTR(data_rdy, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_CODE_DATA_RDY  100
> +
> +/* Threshold pass events */
> +#define IIO_EVENT_ATTR_ACCEL_X_HIGH(_show, _store, _mask, _handler) \
> +	IIO_EVENT_ATTR(x_high, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_CODE_ACCEL_X_HIGH 1
> +
> +/* Shared handler version */
> +#define IIO_EVENT_ATTR_ACCEL_X_HIGH_SH(_evlist, _show, _store, _mask)\
> +	IIO_EVENT_ATTR_SH(x_high, _evlist, _show, _store, _mask)
> +
> +
> +#define IIO_EVENT_ATTR_ACCEL_Y_HIGH(_show, _store, _mask, _handler) \
> +	IIO_EVENT_ATTR(y_high, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_ATTR_ACCEL_Y_HIGH_SH(_evlist, _show, _store, _mask)\
> +	IIO_EVENT_ATTR_SH(y_high, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_CODE_ACCEL_Y_HIGH 2
> +
> +#define IIO_EVENT_ATTR_ACCEL_Z_HIGH(_show, _store, _mask, _handler) \
> +	IIO_EVENT_ATTR(z_high, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_ATTR_ACCEL_Z_HIGH_SH(_evlist, _show, _store, _mask)\
> +	IIO_EVENT_ATTR_SH(z_high, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_CODE_ACCEL_Z_HIGH 3
> +
> +#define IIO_EVENT_ATTR_ACCEL_X_LOW(_show, _store, _mask, _handler) \
> +	IIO_EVENT_ATTR(x_low, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_ATTR_ACCEL_X_LOW_SH(_evlist, _show, _store, _mask)\
> +	IIO_EVENT_ATTR_SH(x_low, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_CODE_ACCEL_X_LOW 4
> +
> +#define IIO_EVENT_ATTR_ACCEL_Y_LOW(_show, _store, _mask, _handler) \
> +	IIO_EVENT_ATTR(y_low, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_ATTR_ACCEL_Y_LOW_SH(_evlist, _show, _store, _mask)\
> +	IIO_EVENT_ATTR_SH(y_low, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_CODE_ACCEL_Y_LOW 5
> +
> +#define IIO_EVENT_ATTR_ACCEL_Z_LOW(_show, _store, _mask, _handler)	\
> +	IIO_EVENT_ATTR(z_low, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_ATTR_ACCEL_Z_LOW_SH(_evlist, _show, _store, _mask)	\
> +	IIO_EVENT_ATTR_SH(z_low, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_CODE_ACCEL_Z_LOW 6
> +
> +#define IIO_EVENT_ATTR_FREE_FALL_DETECT(_show, _store, _mask, _handler)	\
> +	IIO_EVENT_ATTR(free_fall, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_ATTR_FREE_FALL_DETECT_SH(_evlist, _show, _store, _mask) \
> +	IIO_EVENT_ATTR_SH(free_fall, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_CODE_FREE_FALL 7
> +
> +/* These may be software or hardware events depending on type of ring buffer */
> +
> +#define IIO_EVENT_ATTR_RING_50_FULL(_show, _store, _mask, _handler)	\
> +	IIO_EVENT_ATTR(ring_50_full, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_ATTR_RING_50_FULL_SH(_evlist, _show, _store, _mask)	\
> +	IIO_EVENT_ATTR_SH(ring_50_full, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_ATTR_RING_75_FULL_SH(_evlist, _show, _store, _mask)	\
> +	IIO_EVENT_ATTR_SH(ring_75_full, _evlist, _show, _store, _mask)
> +
> +#define IIO_EVENT_ATTR_SW_RING_ENABLE(_show, _store, _mask, _handler)	\
> +	IIO_EVENT_ATTR(sw_ring_enable, _show, _store, _mask, _handler)
> +
> +#define IIO_EVENT_CODE_RING_50_FULL 100
> +#define IIO_EVENT_CODE_RING_75_FULL 101
> +#define IIO_EVENT_CODE_RING_100_FULL 102
> +/* HOW TO HANDLE COMPOSITE EVENTS? */
> +
> +#endif /* _INDUSTRIAL_IO_SYSFS_H_ */
> --- a/drivers/industrialio/industrialio_ptimer_board_info.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/industrialio/industrialio_ptimer_board_info.c	2008-07-23 14:16:28.000000000 +0100
> @@ -0,0 +1,44 @@
> +/* The industrial I/O periodic timer registration code
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + */
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/industrialio_ptimer.h>
> +
> +LIST_HEAD(industrialio_ptimer_board_info_list);
> +EXPORT_SYMBOL_GPL(industrialio_ptimer_board_info_list);
> +
> +DEFINE_MUTEX(industrialio_ptimer_board_lock);
> +EXPORT_SYMBOL_GPL(industrialio_ptimer_board_lock);
> +
> +
> +int __init
> +industrialio_register_ptimer(struct ptimer_info const *info, unsigned n)
> +{
> +	int i;
> +	struct ptimer_info_listel *pi;
> +
> +	mutex_lock(&industrialio_ptimer_board_lock);
> +	for (i = 0; i < n; i++) {
> +		pi = kzalloc(sizeof(*pi), GFP_KERNEL);
> +		if (!pi) {
> +			mutex_unlock(&industrialio_ptimer_board_lock);
> +			return -ENOMEM;
> +		}
> +		strncpy(pi->info.name, info[i].name, IIO_PTIMER_NAME_SIZE);
> +		list_add_tail(&pi->list, &industrialio_ptimer_board_info_list);
> +	}
> +	mutex_unlock(&industrialio_ptimer_board_lock);
> +
> +	return 0;
> +}
> --- a/drivers/industrialio/industrialio-core.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/industrialio/industrialio-core.c	2008-07-23 15:07:21.000000000 +0100
> @@ -0,0 +1,787 @@
> +/* The industrial I/O core
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * Based on elements of hwmon and input subsystems.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/idr.h>
> +#include <linux/kdev_t.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +#include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/poll.h>
> +#include <linux/rtc.h>
> +
> +#include <linux/industrialio.h>
> +#include <linux/industrialio_ptimer.h>
> +
> +MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
> +MODULE_DESCRIPTION("Industrial I/O core");
> +MODULE_LICENSE("GPL");
> +
> +#define IIO_ID_PREFIX "industrialio"
> +#define IIO_ID_FORMAT IIO_ID_PREFIX "%d"
> +#define IIO_MAJOR 244
> +
> +/* Integer id  - used to assign each registered device a unique id*/
> +static DEFINE_IDR(iio_idr);
> +static DEFINE_SPINLOCK(iio_idr_lock);
> +
> +struct class iio_class = {
> +	.name = "industrialio",
> +};
> +
> +/* Struct used to maintain internal state about industrialio.
> + * This will be used to handle the character device accesses
> + * and redirect them to the relevant driver.
> + * Will reduce this to the included table if nothing else comes
> + * up that should go in here!
> + */
> +struct __iio_state {
> +	/* All initially set to NULL in init */
> +	struct iio_handler *fhs[256];
> +};
> +
> +static struct __iio_state iio_state;
> +static DEFINE_SPINLOCK(iio_state_lock);
> +
> +/* Used to escalate shared event.
> + * Currently this is only used with ring buffer events.
> + */
> +void __iio_change_event(struct iio_detected_event_list *ev,
> +			int ev_code,
> +			s64 timestamp)
> +{
> +	ev->ev.id = ev_code;
> +	ev->ev.timestamp = timestamp;
> +}
> +
> +/* Used both in the interrupt line put events and the ring buffer ones */
> + int
> +__iio_put_event(struct iio_event_interface *ev_int,
> +		int ev_code,
> +		s64 timestamp,
> +		struct iio_shared_ev_pointer*
> +		shared_pointer_p)
> +{
> +	struct iio_detected_event_list *ev;
> +	int ret;
> +
> +	/* Does anyone care? */
> +	if (test_bit(IIO_BUSY_BIT_POS, &ev_int->handler.flags)) {
> +		if (ev_int->current_events == ev_int->max_events)
> +			return 0;
> +		ev = kmalloc(sizeof(struct iio_detected_event_list),
> +			     GFP_KERNEL);
> +		if (ev == NULL) {
> +			ret = -ENOMEM;
> +			goto error_ret;
> +		}
> +		ev->ev.id = ev_code;
> +		ev->ev.timestamp = timestamp;
> +		if (shared_pointer_p != NULL) {
> +			ev->shared_pointer = shared_pointer_p;
> +			shared_pointer_p->ev_p = ev;
> +		} else
> +			ev->shared_pointer = NULL;
> +
> +		mutex_lock(&ev_int->event_list_lock);
> +		list_add_tail(&ev->list, &ev_int->det_events.list);
> +		mutex_unlock(&ev_int->event_list_lock);
> +
> +		ev_int->current_events++;
> +		wake_up_interruptible(&ev_int->wait);
> +	}
> +
> +	return 0;
> +error_ret:
> +	return ret;
> +
> +}
> +
> +int iio_put_event(struct iio_dev *dev_info,
> +		  int ev_line,
> +		  int ev_code,
> +		  s64 timestamp)
> +{
> +	return __iio_put_event(&dev_info->event_interfaces[ev_line],
> +			       ev_code, timestamp, NULL);
> +}
> +EXPORT_SYMBOL(iio_put_event);
> +
> +/* Confirming the validity of supplied irq is left to drivers.*/
> +int iio_register_interrupt_line(unsigned int irq,
> +					 struct iio_dev *dev_info,
> +					 int line_number,
> +					 unsigned long type,
> +					 const char *name)
> +{
> +	int ret;
> +
> +	dev_info->interrupts[line_number] =
> +		kmalloc(sizeof(struct iio_interrupt), GFP_KERNEL);
> +	if (dev_info->interrupts[line_number] == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +
> +	INIT_LIST_HEAD(&dev_info->interrupts[line_number]->ev_list.list);
> +	dev_info->interrupts[line_number]->line_number = line_number;
> +	dev_info->interrupts[line_number]->irq = irq;
> +	dev_info->interrupts[line_number]->dev_info = dev_info;
> +
> +	/* Possibly only request on demand?
> +	 * Can see this may complicate the handling of interrupts.
> +	 * However, with this approach we end up handling lots of
> +	 * events no-one cares about.*/
> +	ret = request_irq(irq,
> +			  &iio_interrupt_handler,
> +			  type,
> +			  name,
> +			  dev_info->interrupts[line_number]);
> +	if (ret < 0)
> +		goto error_ret;
> +
> +	return 0;
> +
> +error_ret:
> +	return ret;
> +}
> +EXPORT_SYMBOL(iio_register_interrupt_line);
> +
> +/* Before this runs the interrupt generator must have been disabled */
> +void iio_unregister_interrupt_line(struct iio_dev *dev_info,
> +					    int line_number)
> +{
> +	/* make sure the interrupt handlers are all done */
> +	flush_scheduled_work();
> +	free_irq(dev_info->interrupts[line_number]->irq,
> +		 dev_info->interrupts[line_number]);
> +	kfree(dev_info->interrupts[line_number]);
> +}
> +EXPORT_SYMBOL(iio_unregister_interrupt_line);
> +
> +/* Generic interrupt line interrupt handler */
> +irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
> +{
> +	struct iio_interrupt *int_info = _int_info;
> +	struct iio_dev *dev_info = int_info->dev_info;
> +	struct iio_event_handler_list *p;
> +	s64 time_ns;
> +
> +	if (list_empty(&int_info->ev_list.list))
> +		return IRQ_NONE;
> +
> +	time_ns = iio_get_time_ns();
> +	/* detect single element list*/
> +	if (int_info->ev_list.list.next->next == &int_info->ev_list.list) {
> +		disable_irq_nosync(irq);
> +		p = list_first_entry(&int_info->ev_list.list,
> +				     struct iio_event_handler_list,
> +				     list);
> +		p->handler(dev_info, 1, time_ns, 1);
> +	} else
> +		list_for_each_entry(p, &int_info->ev_list.list, list) {
> +		       disable_irq_nosync(irq);
> +		       p->handler(dev_info, 1, time_ns, 0);
> +		}
> +	return IRQ_HANDLED;
> +}
> +EXPORT_SYMBOL(iio_interrupt_handler);
> +
> +int iio_add_event_to_list(struct iio_event_handler_list *list,
> +				   struct iio_event_handler_list *el)
> +{
> +	if (el->refcount == 0)
> +		list_add(&list->list, &el->list);
> +	el->refcount++;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(iio_add_event_to_list);
> +
> +int iio_remove_event_from_list(struct iio_event_handler_list
> +					*el)
> +{
> +	el->refcount--;
> +	if (el->refcount == 0)
> +		list_del_init(&el->list);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(iio_remove_event_from_list);
> +
> +
> +int iio_allocate_chrdev(struct iio_handler *handler)
> +{
> +	int id;
> +
> +	spin_lock(iio_state_lock);
> +	for (id = 0; id <= 256; id++)
> +		if (iio_state.fhs[id] == NULL)
> +			break;
> +	if (id == 256) {
> +		spin_unlock(iio_state_lock);
> +		return -ENOMEM;
> +	}
> +	iio_state.fhs[id] = handler;
> +	spin_unlock(iio_state_lock);
> +	handler->id = id;
> +
> +	return 0;
> +}
> +
> +void iio_deallocate_chrdev(struct iio_handler *handler)
> +{
> +	spin_lock(iio_state_lock);
> +	iio_state.fhs[handler->id] = NULL;
> +	spin_unlock(iio_state_lock);
> +}
> +
> +/* Upon open, switch in the correct file ops
> + * lifted directly from input subsystem */
> +static int iio_open_file(struct inode *inode, struct file *file)
> +{
> +	struct iio_handler *handler;
> +	const struct file_operations *old_fops, *new_fops = NULL;
> +	int err;
> +
> +	/* This lock needed as unlike input we are dynamically allocating
> +	 * chrdevs */
> +	spin_lock(iio_state_lock);
> +	handler = iio_state.fhs[iminor(inode)];
> +	spin_unlock(iio_state_lock);
> +
> +	if (!handler) {
> +		fops_put(file->f_op);
> +		return -ENODEV;
> +	}
> +	new_fops = fops_get(handler->fops);
> +	if (new_fops == NULL) {
> +		fops_put(file->f_op);
> +		return -ENODEV;
> +	}
> +
> +	/* cribbed from lp.c */
> +	if (test_and_set_bit(IIO_BUSY_BIT_POS, &handler->flags)) {
> +		fops_put(file->f_op);
> +		return -EBUSY;
> +	}
> +
> +	if (!new_fops->open) {
> +		fops_put(new_fops);
> +		return -ENODEV;
> +	}
> +	old_fops = file->f_op;
> +	file->f_op = new_fops;
> +	/* use the private data pointer in file to give access to device
> +	 * specific stuff */
> +	file->private_data = handler->private;
> +	err = new_fops->open(inode, file);
> +
> +	if (err) {
> +		fops_put(file->f_op);
> +		file->f_op = fops_get(old_fops);
> +	}
> +	fops_put(old_fops);
> +
> +	return err;
> +}
> +
> +
> +/* The main file ops structure. All open calls on the major number will
> + * be handled by this with fops for the actual minor number assigned by
> + * switching function above */
> +static const struct file_operations iio_fops = {
> +	.owner = THIS_MODULE,
> +	.open = iio_open_file,
> +};
> +
> +ssize_t iio_interrupt_read(struct file *filep,
> +			   char *buf,
> +			   size_t count,
> +			   loff_t *f_ps)
> +{
> +	struct iio_event_interface *ev_int = filep->private_data;
> +	struct iio_detected_event_list *el;
> +	int ret;
> +
> +	mutex_lock(&ev_int->event_list_lock);
> +	if (list_empty(&ev_int->det_events.list)) {
> +		if (filep->f_flags & O_NONBLOCK) {
> +			ret = -EAGAIN;
> +			goto error_mutex_unlock;
> +		}
> +		mutex_unlock(&ev_int->event_list_lock);
> +		/* Blocking on device; waiting for something to be there */
> +		ret = wait_event_interruptible(ev_int->wait,
> +					       !list_empty(&ev_int
> +							   ->det_events.list));
> +		if (ret)
> +			goto error_ret;
> +		/* Single access device so noone else can get the data */
> +		mutex_lock(&ev_int->event_list_lock);
> +	}
> +
> +	el = list_first_entry(&ev_int->det_events.list,
> +			      struct iio_detected_event_list,
> +			      list);
> +
> +	if (copy_to_user(buf, &(el->ev),
> +			 sizeof(struct iio_event_data))) {
> +		ret = -EFAULT;
> +		goto error_mutex_unlock;
> +	}
> +
> +	list_del(&el->list);
> +	ev_int->current_events--;
> +	mutex_unlock(&ev_int->event_list_lock);
> +
> +	spin_lock(el->shared_pointer->lock);
> +	if (el->shared_pointer)
> +		(el->shared_pointer->ev_p) = NULL;
> +	spin_unlock(el->shared_pointer->lock);
> +
> +	kfree(el);
> +
> +	return sizeof(struct iio_event_data);
> +
> +error_mutex_unlock:
> +	mutex_unlock(&ev_int->event_list_lock);
> +error_ret:
> +
> +	return ret;
> +}
> +
> +int iio_interrupt_release(struct inode *inode, struct file *filep)
> +{
> +	struct iio_event_interface *ev_int = filep->private_data;
> +
> +	module_put(ev_int->owner);
> +	clear_bit(IIO_BUSY_BIT_POS, &ev_int->handler.flags);
> +
> +	return 0;
> +}
> +
> +int iio_interrupt_open(struct inode *inode, struct file *filep)
> +{
> +	struct iio_event_interface *ev_int = filep->private_data;
> +
> +	try_module_get(ev_int->owner);
> +
> +	return 0;
> +}
> +static const struct file_operations iio_interrupt_fileops = {
> +	.read =  iio_interrupt_read,
> +	.release = iio_interrupt_release,
> +	.open = iio_interrupt_open,
> +	.owner = THIS_MODULE,
> +};
> +
> +
> +ssize_t iio_show_attr_minor(struct device *dev,
> +			    struct device_attribute *attr,
> +			    char *buf)
> +{
> +	int len;
> +
> +	struct iio_chrdev_minor_attr *_attr
> +		= to_iio_chrdev_minor_attr(attr);
> +	len = sprintf(buf, "%d\n", _attr->minor);
> +
> +	return len;
> +}
> +
> +void __init_iio_chrdev_minor_attr(struct iio_chrdev_minor_attr *minor_attr,
> +				const char *name,
> +				struct module *owner,
> +				int id)
> +{
> +	minor_attr->dev_attr.attr.name = name;
> +	minor_attr->dev_attr.attr.owner = owner;
> +	minor_attr->dev_attr.attr.mode = S_IRUGO;
> +	minor_attr->minor = id;
> +	minor_attr->dev_attr.show = &iio_show_attr_minor;
> +}
> +
> +int iio_setup_ev_int(struct iio_event_interface *ev_int,
> +		     const char *name,
> +		     struct module *owner,
> +		     struct device *dev)
> +{
> +	int ret;
> +
> +	mutex_init(&ev_int->event_list_lock);
> +	/* discussion point - make this variable? */
> +	ev_int->max_events = 10;
> +	ev_int->current_events = 0;
> +	INIT_LIST_HEAD(&ev_int->det_events.list);
> +	init_waitqueue_head(&ev_int->wait);
> +	ev_int->handler.fops = &iio_interrupt_fileops;
> +	ev_int->handler.private = ev_int;
> +	ev_int->handler.flags = 0;
> +	ret = iio_allocate_chrdev(&ev_int->handler);
> +	if (ret)
> +		goto error_ret;
> +	__init_iio_chrdev_minor_attr(&ev_int->attr,
> +				     (const char *)(name),
> +				     owner,
> +				     ev_int->handler.id);
> +	ret = sysfs_create_file(&dev->kobj, &ev_int->attr.dev_attr.attr);
> +	if (ret)
> +		goto error_deallocate_chrdev;
> +
> +	return 0;
> +error_deallocate_chrdev:
> +	iio_deallocate_chrdev(&ev_int->handler);
> +error_ret:
> +	return ret;
> +}
> +
> +void iio_free_ev_int(struct iio_event_interface *ev_int, struct device *dev)
> +{
> +	sysfs_remove_file(&dev->kobj, &ev_int->attr.dev_attr.attr);
> +	iio_deallocate_chrdev(&ev_int->handler);
> +}
> +
> +static int __init iio_init(void)
> +{
> +	int ret;
> +
> +	memset(iio_state.fhs,
> +	       sizeof(struct iio_handler *)*256,
> +	       0);
> +
> +	/* Create sysfs class */
> +	ret  = class_register(&iio_class);
> +	if (ret < 0) {
> +		printk(KERN_ERR
> +		       "industrialio.c: could not create sysfs class\n");
> +		goto error_nothing;
> +	}
> +
> +	ret = register_chrdev(IIO_MAJOR, "industrialio", &iio_fops);
> +	if (ret) {
> +		printk(KERN_ERR
> +		       "industrialio: unable to register a char major %d",
> +		       IIO_MAJOR);
> +		goto error_unregister_class;
> +	}
> +
> +	return 0;
> +error_unregister_class:
> +	class_unregister(&iio_class);
> +error_nothing:
> +	return ret;
> +}
> +
> +static void __exit iio_exit(void)
> +{
> +	unregister_chrdev(IIO_MAJOR, "bob");
> +	class_unregister(&iio_class);
> +}
> +
> +int iio_device_register_sysfs(struct iio_dev *dev_info)
> +{
> +	int ret;
> +
> +	dev_info->sysfs_dev = device_create(&iio_class,
> +					    dev_info->dev,
> +					    MKDEV(0, 0),
> +					    IIO_ID_FORMAT,
> +					    dev_info->id);
> +
> +	if (IS_ERR(dev_info->sysfs_dev)) {
> +		/* what would correct error here be?*/
> +		ret = -EINVAL;
> +		goto error_ret;
> +	}
> +	/* register attributes */
> +	ret = sysfs_create_group(&dev_info->dev->kobj, dev_info->attrs);
> +	if (ret) {
> +		dev_err(dev_info->dev, "Failed to register sysfs hooks\n");
> +		goto error_free_sysfs_device;
> +	}
> +
> +	return 0;
> +
> +error_free_sysfs_device:
> +	device_unregister(dev_info->dev);
> +error_ret:
> +	return ret;
> +}
> +
> +void iio_device_unregister_sysfs(struct iio_dev *dev_info)
> +{
> +	sysfs_remove_group(&dev_info->dev->kobj, dev_info->attrs);
> +	device_unregister(dev_info->sysfs_dev);
> +}
> +
> +int iio_device_register_id(struct iio_dev *dev_info)
> +{
> +	int ret;
> +
> +idr_again:
> +	if (unlikely(idr_pre_get(&iio_idr, GFP_KERNEL) == 0))
> +		return -ENOMEM;
> +
> +	spin_lock(&iio_idr_lock);
> +	ret = idr_get_new(&iio_idr, NULL, &dev_info->id);
> +	spin_unlock(&iio_idr_lock);
> +	if (unlikely(ret == -EAGAIN))
> +		goto idr_again;
> +	else if (unlikely(ret))
> +		return ret;
> +	dev_info->id = dev_info->id & MAX_ID_MASK;
> +
> +	return 0;
> +}
> +void iio_device_unregister_id(struct iio_dev *dev_info)
> +{
> +	/* Can I use the save id? */
> +	int id;
> +
> +	if (likely(sscanf(dev_info->sysfs_dev->bus_id,
> +			  IIO_ID_FORMAT, &id) == 1)) {
> +		spin_lock(&iio_idr_lock);
> +		idr_remove(&iio_idr, id);
> +		spin_unlock(&iio_idr_lock);
> +	} else
> +		dev_dbg(dev_info->dev->parent,
> +			"indio_device_unregister() failed: bad class ID!\n");
> +}
> +
> +int iio_device_register_eventset(struct iio_dev *dev_info)
> +{
> +	int ret, i, j;
> +
> +	struct device_attribute *devattr;
> +	struct iio_event_attr *indio_devattr;
> +
> +	if (dev_info->num_interrupt_lines == 0)
> +		return 0;
> +	dev_info->event_interfaces = (struct iio_event_interface *)
> +		(kzalloc(sizeof(struct iio_event_interface)
> +			 *dev_info->num_interrupt_lines,
> +			 GFP_KERNEL));
> +	if (dev_info->event_interfaces == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	/* assign id's to the event_interface elements */
> +	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
> +		dev_info->event_interfaces[i].id = i;
> +		dev_info->event_interfaces[i].owner = dev_info->driver_module;
> +	}
> +	dev_info->interrupts
> +		= kzalloc(sizeof(struct iio_interrupt *)
> +			  *dev_info->num_interrupt_lines,
> +			  GFP_KERNEL);
> +	if (dev_info->interrupts == NULL) {
> +		dev_err(dev_info->dev,
> +			"Failed to register sysfs hooks for events attributes");
> +		ret = -ENOMEM;
> +		goto error_free_event_interfaces;
> +	}
> +
> +	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
> +
> +		snprintf(dev_info->event_interfaces[i]._name, 20,
> +			"event_line%d_minor", i);
> +		ret = iio_setup_ev_int(&dev_info->event_interfaces[i],
> +				       (const char *)(dev_info
> +						      ->event_interfaces[i]
> +						      ._name),
> +				       dev_info->driver_module,
> +				       dev_info->dev);
> +		if (ret) {
> +			dev_err(dev_info->dev,
> +				"Could not get chrdev interface\n");
> +			goto error_free_setup_ev_ints;
> +		}
> +	}
> +	dev_info->event_attrs->name = "event_sources";
> +	ret = sysfs_create_group(&dev_info->dev->kobj, dev_info->event_attrs);
> +	if (ret) {
> +		dev_err(dev_info->dev,
> +			"Failed to register sysfs hooks for events attributes");
> +		goto error_free_setup_ev_ints;
> +	}
> +	/* May double initialize lists in case of shared handlers,
> +	   but other than a slight overhead that isn't a problem */
> +	j = 0;
> +	while (1) {
> +		if (dev_info->event_attrs->attrs[j] == NULL)
> +			break;
> +		devattr = container_of(dev_info->event_attrs->attrs[j],
> +				       struct device_attribute, attr);
> +		indio_devattr = to_iio_event_attr(devattr);
> +		INIT_LIST_HEAD(&indio_devattr->listel->list);
> +		j++;
> +	}
> +	return 0;
> +
> +error_free_setup_ev_ints:
> +	for (j = 0; j < i; j++)
> +		iio_free_ev_int(&dev_info->event_interfaces[j],
> +				dev_info->dev);
> +	kfree(dev_info->interrupts);
> +error_free_event_interfaces:
> +	kfree(dev_info->event_interfaces);
> +error_ret:
> +	return ret;
> +}
> +
> +void iio_device_unregister_eventset(struct iio_dev *dev_info)
> +{
> +	int i;
> +	if (dev_info->num_interrupt_lines == 0)
> +		return;
> +	for (i = 0; i < dev_info->num_interrupt_lines; i++)
> +		iio_free_ev_int(&dev_info->event_interfaces[i],
> +					 dev_info->dev);
> +	if (dev_info->event_attrs)
> +		sysfs_remove_group(&dev_info->dev->kobj, dev_info->event_attrs);
> +	kfree(dev_info->event_interfaces);
> +}
> +
> +int iio_get_ptimer(const char **name)
> +{
> +	struct ptimer_info_listel *ptimer_i;
> +
> +	*name = NULL;
> +	mutex_lock(&industrialio_ptimer_board_lock);
> +
> +	list_for_each_entry(ptimer_i, &industrialio_ptimer_board_info_list,
> +			    list)
> +		if (ptimer_i->inuse == false) {
> +			ptimer_i->inuse = true;
> +			*name = ptimer_i->info.name;
> +			break;
> +		}
> +	mutex_unlock(&industrialio_ptimer_board_lock);
> +	if (*name == NULL)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +int iio_free_ptimer(const char *name)
> +{
> +	struct ptimer_info_listel *ptimer_i;
> +
> +	mutex_lock(&industrialio_ptimer_board_lock);
> +	list_for_each_entry(ptimer_i, &industrialio_ptimer_board_info_list,
> +			    list)
> +		if (ptimer_i->info.name == name) {
> +			ptimer_i->inuse = false;
> +			break;
> +		}
> +	mutex_unlock(&industrialio_ptimer_board_lock);
> +
> +	return 0;
> +}
> +
> +int iio_device_register_ptimer(struct iio_dev *dev_info)
> +{
> +	int ret = 0;
> +
> +	if (dev_info->modes & INDIO_RING_POLLED) {
> +		ret = iio_get_ptimer(&dev_info->ptimer_name);
> +		if (ret)
> +			goto error_ret;
> +		ret = iio_ptimer_request_periodic_timer((char *)
> +							(dev_info->ptimer_name),
> +							dev_info);
> +		if (ret)
> +			goto error_release_ptimer;
> +	}
> +
> +	return ret;
> +
> +error_release_ptimer:
> +	iio_free_ptimer(dev_info->ptimer_name);
> +error_ret:
> +	return ret;
> +
> +}
> +
> +void iio_device_unregister_ptimer(struct iio_dev *dev_info)
> +{
> +	if (dev_info->ptimer) {
> +		iio_ptimer_unrequest_periodic_timer(dev_info);
> +		iio_free_ptimer(dev_info->ptimer_name);
> +	}
> +}
> +
> +int iio_device_register(struct iio_dev *dev_info)
> +{
> +	int ret;
> +	mutex_init(&dev_info->mlock);
> +	dev_set_drvdata(dev_info->dev, (void *)(dev_info));
> +
> +/*Get a unique id */
> +	ret = iio_device_register_id(dev_info);
> +	if (ret)
> +		goto error_nothing;
> +
> +/* Create sysfs device */
> +	ret = iio_device_register_sysfs(dev_info);
> +	if (ret)
> +		goto error_free_idr;
> +
> +/* Interrupt triggered events setup */
> +	ret = iio_device_register_eventset(dev_info);
> +	if (ret)
> +		goto error_free_sysfs;
> +
> +/* Ring buffer init if relevant */
> +	if (dev_info->modes & (INDIO_RING_POLLED | INDIO_RING_DATA_RDY)) {
> +
> +		ret = iio_device_register_sw_ring(dev_info, 0);
> +		if (ret)
> +			goto error_free_eventset;
> +	}
> +/* Register ptimer if relevant */
> +	if (dev_info->modes & INDIO_RING_POLLED) {
> +		ret = iio_device_register_ptimer(dev_info);
> +		if (ret)
> +			goto error_unregister_sw_ring;
> +	}
> +
> +	return 0;
> +
> +error_unregister_sw_ring:
> +	iio_device_unregister_sw_ring(dev_info);
> +error_free_eventset:
> +	iio_device_unregister_eventset(dev_info);
> +error_free_sysfs:
> +	iio_device_unregister_sysfs(dev_info);
> +error_free_idr:
> +	iio_device_unregister_id(dev_info);
> +error_nothing:
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iio_device_register);
> +
> +void iio_device_unregister(struct iio_dev *dev_info)
> +{
> +	if (dev_info->modes & INDIO_RING_POLLED)
> +		iio_device_unregister_ptimer(dev_info);
> +	if (dev_info->modes & (INDIO_RING_POLLED | INDIO_RING_DATA_RDY))
> +		iio_device_unregister_sw_ring(dev_info);
> +	iio_device_unregister_eventset(dev_info);
> +	iio_device_unregister_sysfs(dev_info);
> +	iio_device_unregister_id(dev_info);
> +
> +}
> +EXPORT_SYMBOL_GPL(iio_device_unregister);
> +
> +subsys_initcall(iio_init);
> +module_exit(iio_exit);
> --- a/drivers/industrialio/industrialio-rtc.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/industrialio/industrialio-rtc.c	2008-07-23 15:08:43.000000000 +0100
> @@ -0,0 +1,134 @@
> +/* The industrial I/O core
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/rtc.h>
> +#include <linux/industrialio.h>
> +#include <linux/industrialio_ptimer.h>
> +/* This is a temporary stop gap until a more generic timer subsystem is in place
> + * within the kernel.
> + * See discussion (initial thoughts so far) on the rtc mailing list.
> + * Comments still welcomed though I may not do much about them!.
> + */
> +int iio_ptimer_irq_set_state(struct iio_dev *indio_dev, bool state)
> +{
> +	return rtc_irq_set_state(indio_dev->ptimer->rtc,
> +				 &indio_dev->ptimer->task,
> +				 state);
> +}
> +EXPORT_SYMBOL(iio_ptimer_irq_set_state);
> +
> +int iio_ptimer_set_freq(struct iio_periodic *ptimer,
> +			    unsigned frequency)
> +{
> +	int ret;
> +
> +	ret = rtc_irq_set_freq(ptimer->rtc, &ptimer->task, frequency);
> +	if (ret == 0)
> +		ptimer->frequency = frequency;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(iio_ptimer_set_freq);
> +
> +static ssize_t iio_ptimer_show_samp_freq(struct device *dev,
> +					 struct device_attribute *attr,
> +					 char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct iio_periodic *ptimer = dev_info->ptimer;
> +	return sprintf(buf, "%u\n", ptimer->frequency);
> +}
> +
> +static ssize_t iio_ptimer_store_samp_freq(struct device *dev,
> +					  struct device_attribute *attr,
> +					  const char *buf,
> +					  size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct iio_periodic *ptimer = dev_info->ptimer;
> +	int ret;
> +	unsigned long val;
> +
> +	ret = strict_strtoul(buf, 10, &val);
> +	if (ret)
> +		goto error_ret;
> +	ret = iio_ptimer_set_freq(ptimer, val);
> +	if (ret)
> +		goto error_ret;
> +	return len;
> +
> +error_ret:
> +	return ret;
> +}
> +
> +
> +IIO_DEV_ATTR_SAMP_FREQ(S_IRUGO | S_IWUSR,
> +		       iio_ptimer_show_samp_freq,
> +		       iio_ptimer_store_samp_freq);
> +
> +int iio_ptimer_request_periodic_timer(char *name,
> +				      struct iio_dev *indio_dev)
> +{
> +	int ret;
> +
> +	indio_dev->ptimer = kmalloc(sizeof(struct iio_periodic), GFP_KERNEL);
> +	indio_dev->ptimer->rtc = rtc_class_open(name);
> +	if (indio_dev->ptimer == NULL) {
> +		ret = -EINVAL;
> +		goto error_free_ptimer;
> +	}
> +	indio_dev->ptimer->task.func = indio_dev->ring_poll_func;
> +	indio_dev->ptimer->task.private_data = indio_dev;
> +	ret = rtc_irq_register(indio_dev->ptimer->rtc,
> +			       &indio_dev->ptimer->task);
> +	if (ret)
> +		goto error_close_class;
> +
> +	ret = sysfs_add_file_to_group(&indio_dev->dev->kobj,
> +				      &iio_dev_attr_sampling_frequency
> +				      .dev_attr.attr,
> +				      "ring_buffer");
> +	if (ret)
> +		goto error_unregister_irq;
> +
> +	return 0;
> +
> +error_unregister_irq:
> +	rtc_irq_unregister(indio_dev->ptimer->rtc, &indio_dev->ptimer->task);
> +
> +error_close_class:
> +	rtc_class_close(indio_dev->ptimer->rtc);
> +error_free_ptimer:
> +	kfree(indio_dev->ptimer);
> +	indio_dev->ptimer = NULL;
> +	return ret;
> +}
> +EXPORT_SYMBOL(iio_ptimer_request_periodic_timer);
> +
> +void iio_ptimer_unrequest_periodic_timer(struct iio_dev *indio_dev)
> +{
> +
> +	sysfs_remove_file_from_group(&indio_dev->dev->kobj,
> +				      &iio_dev_attr_sampling_frequency
> +				     .dev_attr.attr,
> +				     "ring_buffer");
> +
> +	if (indio_dev->ptimer->rtc) {
> +		rtc_irq_set_state(indio_dev->ptimer->rtc,
> +				  &indio_dev->ptimer->task, 0);
> +		rtc_irq_unregister(indio_dev->ptimer->rtc,
> +				   &indio_dev->ptimer->task);
> +				flush_scheduled_work();
> +		rtc_class_close(indio_dev->ptimer->rtc);
> +		flush_scheduled_work();
> +	}
> +	kfree(indio_dev->ptimer);
> +}
> +EXPORT_SYMBOL(iio_ptimer_unrequest_periodic_timer);
> --- a/drivers/industrialio/industrialio-ring.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/industrialio/industrialio-ring.c	2008-07-23 15:10:39.000000000 +0100
> @@ -0,0 +1,770 @@
> +/* The industrial I/O core
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * Handling of ring allocation / resizing.
> + *
> + *
> + * Things to look at here.
> + * - Better memory allocation techniques?
> + * - Alternative access techniques?
> + */
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/fs.h>
> +#include <linux/poll.h>
> +#include <linux/module.h>
> +#include <linux/rtc.h>
> +#include <linux/industrialio.h>
> +
> +/* Prevent resizing of the ring if it might break anything */
> +void iio_mark_sw_ring_buffer_in_use(struct iio_sw_ring_buffer *ring)
> +{
> +	spin_lock(ring->use_lock);
> +	ring->use_count++;
> +	spin_unlock(ring->use_lock);
> +}
> +EXPORT_SYMBOL_GPL(iio_mark_sw_ring_buffer_in_use);
> +
> +void iio_unmark_sw_ring_buffer_in_use(struct iio_sw_ring_buffer *ring)
> +{
> +	spin_lock(ring->use_lock);
> +	ring->use_count--;
> +	spin_unlock(ring->use_lock);
> +}
> +EXPORT_SYMBOL_GPL(iio_unmark_sw_ring_buffer_in_use);
> +
> +/* Mark that a resize is needed */
> +static void iio_mark_sw_ring_buffer_need_update(struct iio_sw_ring_buffer *ring)
> +{
> +	spin_lock(ring->use_lock);
> +	ring->update_needed = 1;
> +	spin_unlock(ring->use_lock);
> +}
> +
> +/* Event handling for the ring - allows escallation of events */
> +int iio_put_ring_event(struct iio_ring_buffer *ring_buf,
> +		       int event_code,
> +		       s64 timestamp)
> +{
> +	return __iio_put_event(&ring_buf->ev_int,
> +			       event_code,
> +			       timestamp,
> +			       &ring_buf->shared_ev_pointer);
> +}
> +EXPORT_SYMBOL(iio_put_ring_event);
> +
> +int iio_put_or_escallate_ring_event(struct iio_ring_buffer *ring_buf,
> +				    int event_code,
> +				    s64 timestamp)
> +{
> +	if (ring_buf->shared_ev_pointer.ev_p)
> +		__iio_change_event(ring_buf->shared_ev_pointer.ev_p,
> +				   event_code,
> +				   timestamp);
> +	else
> +		return iio_put_ring_event(ring_buf,
> +					  event_code,
> +					  timestamp);
> +	return 0;
> +}
> +EXPORT_SYMBOL(iio_put_or_escallate_ring_event);
> +
> +
> +/* Ring buffer related functionality */
> +/* Store to ring is typically called in the bh of a data ready interrupt handler
> + * in the device driver */
> +/* Lock always held if their is a chance this may be called */
> +int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
> +			 unsigned char *data,
> +			 s64 timestamp)
> +{
> +	bool init_read = true;
> +	int ret;
> +	int code;
> +
> +	/* initial store */
> +	if (unlikely(ring->write_p == 0)) {
> +		ring->write_p = ring->data;
> +		/* doesn't actually matter if this is out of the set */
> +		ring->half_p = ring->data - ring->buf.length*ring->buf.size/2;
> +		init_read = false;
> +	}
> +	memcpy(ring->write_p, data, ring->buf.size);
> +	barrier();
> +	ring->last_written_p = ring->write_p;
> +	barrier();
> +	ring->write_p += ring->buf.size;
> +	/* End of ring, back to the beginning */
> +	if (ring->write_p == ring->data + ring->buf.length*ring->buf.size) {
> +		ring->write_p = ring->data;
> +		ring->buf.loopcount++;
> +	}
> +	if (ring->read_p == 0)
> +		ring->read_p = ring->data;
> +	/* Buffer full - move the read pointer and create / escalate
> +	 * ring event */
> +	else if (ring->write_p == ring->read_p) {
> +		ring->read_p += ring->buf.size;
> +		if (ring->read_p
> +		    == ring->data + ring->buf.length*ring->buf.size)
> +			ring->read_p = ring->data;
> +
> +		spin_lock(ring->buf.shared_ev_pointer.lock);
> +		if (ring->buf.shared_ev_pointer.ev_p) {
> +			/* Event escalation - probably quicker to let this
> +			   keep running than check if it is necessary */
> +			code = IIO_EVENT_CODE_RING_100_FULL;
> +			__iio_change_event(ring
> +					   ->buf.shared_ev_pointer.ev_p,
> +					   code,
> +					   timestamp);
> +		} else {
> +			code = IIO_EVENT_CODE_RING_100_FULL;
> +			ret = __iio_put_event(&ring->buf.ev_int,
> +					      code,
> +					      timestamp,
> +					      &ring
> +					      ->buf.shared_ev_pointer);
> +			if (ret) {
> +				spin_unlock(ring->buf.shared_ev_pointer.lock);
> +				goto error_ret;
> +			}
> +		}
> +		spin_unlock(ring->buf.shared_ev_pointer.lock);
> +	}
> +	/* investigate if our event barrier has been passed */
> +	/* There are definite 'issues' with this and chances of
> +	 * simultaneous read */
> +	/* Also need to use loop count to ensure this only happens once */
> +	ring->half_p += ring->buf.size;
> +	if (ring->half_p == ring->data + ring->buf.length*ring->buf.size)
> +		ring->half_p = ring->data;
> +	if (ring->half_p == ring->read_p) {
> +		spin_lock(ring->buf.shared_ev_pointer.lock);
> +		code = IIO_EVENT_CODE_RING_50_FULL;
> +		ret = __iio_put_event(&ring->buf.ev_int,
> +				      code,
> +				      timestamp,
> +				      &ring->buf.shared_ev_pointer);
> +		spin_unlock(ring->buf.shared_ev_pointer.lock);
> +
> +		if (ret)
> +			goto error_ret;
> +	}
> +	return 0;
> +error_ret:
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iio_store_to_sw_ring);
> +
> +
> +/*doesn't currently read the timestamp */
> +/* For software ring buffers this function is needed to get the latest
> + * reading without preventing it from ending up in the ring buffer.
> +*/
> +int iio_read_last_from_sw_ring(struct iio_sw_ring_buffer *ring,
> +			       unsigned char *data)
> +{
> +	int loopcount_copy;
> +	unsigned char *last_written_p_copy;
> +	iio_mark_sw_ring_buffer_in_use(ring);
> +again:
> +	loopcount_copy = ring->buf.loopcount;
> +	barrier();
> +	last_written_p_copy = ring->last_written_p;
> +	barrier(); /*unnessecary? */
> +
> +	memcpy(data, last_written_p_copy, ring->buf.size);
> +
> +	if (unlikely(loopcount_copy != ring->buf.loopcount)) {
> +		if (unlikely(ring->last_written_p >= last_written_p_copy))
> +			goto again;
> +	}
> +	iio_unmark_sw_ring_buffer_in_use(ring);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(iio_read_last_from_sw_ring);
> +
> +/* Ring buffer access fileops */
> +int iio_ring_open(struct inode *inode, struct file *filp)
> +{
> +	struct iio_sw_ring_buffer *ring = filp->private_data;
> +
> +	iio_mark_sw_ring_buffer_in_use(ring);
> +	try_module_get(ring->buf.access_minor_attr.dev_attr.attr.owner);
> +
> +	return 0;
> +}
> +
> +int iio_ring_release(struct inode *inode, struct file *filp)
> +{
> +	struct iio_sw_ring_buffer *ring = filp->private_data;
> +
> +	module_put(ring->buf.access_minor_attr.dev_attr.attr.owner);
> +	clear_bit(IIO_BUSY_BIT_POS, &ring->buf.access_handler.flags);
> +	iio_unmark_sw_ring_buffer_in_use(ring);
> +
> +	return 0;
> +}
> +
> +/* no point in ripping more than nearest number of whole records below count */
> +/* Depending on movement of pointers in the meantime this may return a lot
> + * less than count*/
> +/* Also, we aren't going to wait for enough data to be available */
> +
> +/* Can only occur currently when the ring buffer is marked
> +   - from userspace call */
> +ssize_t iio_ring_rip(struct file *filp,
> +		     char *buf,
> +		     size_t count,
> +		     loff_t *f_ps)
> +{
> +	unsigned char *initial_read_p, *initial_write_p,
> +		*current_read_p, *end_read_p;
> +
> +	struct iio_sw_ring_buffer *ring = filp->private_data;
> +	unsigned char *data_cpy;
> +	int ret;
> +	int dead_offset;
> +	int bytes_to_rip = 0;
> +	int max_copied;
> +	/* Round down to nearest datum boundary */
> +	bytes_to_rip = (count - count % ring->buf.size);
> +	/* Limit size to whole of ring buffer */
> +	if (bytes_to_rip > ring->buf.size*ring->buf.length)
> +		bytes_to_rip = ring->buf.size*ring->buf.length;
> +	data_cpy = kmalloc(bytes_to_rip, GFP_KERNEL);
> +	if (data_cpy == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +
> +	/* build local copy */
> +	initial_read_p = ring->read_p;
> +	if (unlikely(initial_read_p == 0)) {
> +		/* No data here as yet */
> +		ret = 0;
> +		goto error_free_data_cpy;
> +	}
> +	initial_write_p = ring->write_p;
> +
> +	/* Need a consistent pair */
> +	while (initial_read_p != ring->read_p
> +	      || initial_write_p != ring->write_p) {
> +		initial_read_p = ring->read_p;
> +		initial_write_p = ring->write_p;
> +	}
> +	if (initial_write_p == initial_read_p) {
> +		/* No new data available.*/
> +		ret = 0;
> +		goto error_free_data_cpy;
> +	}
> +
> +	if (initial_write_p > initial_read_p + bytes_to_rip) {
> +		/* write_p is greater than necessary, all is easy */
> +		max_copied = bytes_to_rip;
> +		memcpy(data_cpy, initial_read_p, max_copied);
> +		end_read_p = initial_read_p + max_copied;
> +	} else if (initial_write_p > initial_read_p) {
> +		/*not enough data to cpy */
> +		max_copied = initial_write_p - initial_read_p;
> +		memcpy(data_cpy, initial_read_p, max_copied);
> +		end_read_p = initial_write_p;
> +	} else { /* going through 'end' of ring buffer */
> +		max_copied = ring->data
> +			+ ring->buf.length*ring->buf.size - initial_read_p;
> +		memcpy(data_cpy, initial_read_p, max_copied);
> +		if (initial_write_p > ring->data + bytes_to_rip - max_copied) {
> +			/* enough data to finish */
> +			memcpy(data_cpy + max_copied, ring->data,
> +			       bytes_to_rip - max_copied);
> +			max_copied = bytes_to_rip;
> +			end_read_p = ring->data + (bytes_to_rip - max_copied);
> +		} else {  /* not enough data */
> +			memcpy(data_cpy + max_copied, ring->data,
> +			       initial_write_p - ring->data);
> +			max_copied += initial_write_p - ring->data;
> +			end_read_p = initial_write_p;
> +		}
> +	}
> +	/* Now to verify which section was cleanly copied - i.e. how far
> +	 * read pointer has been pushed */
> +	current_read_p = ring->read_p;
> +
> +	if (initial_read_p <= current_read_p)
> +		dead_offset = current_read_p - initial_read_p;
> +	else
> +		dead_offset = ring->buf.length*ring->buf.size
> +			- (initial_read_p - current_read_p);
> +
> +	/* possible issue if the initial write has been lapped or indeed
> +	 * the point we were reading to has been passed */
> +	/* No valid data read.
> +	 * In this case the read pointer is already correct having been
> +	 * pushed further than we would look. */
> +	if (max_copied - dead_offset < 0) {
> +		ret = 0;
> +		goto error_free_data_cpy;
> +	}
> +
> +	/* setup the next read position */
> +	ring->read_p = end_read_p;
> +
> +	if (copy_to_user(buf, data_cpy + dead_offset,
> +			 max_copied - dead_offset))  {
> +		ret =  -EFAULT;
> +		goto error_free_data_cpy;
> +	}
> +	kfree(data_cpy);
> +
> +	return max_copied - dead_offset;
> +
> +error_free_data_cpy:
> +	kfree(data_cpy);
> +error_ret:
> +	return 0;
> +}
> +
> +static const struct file_operations iio_ring_fileops = {
> +	.read = iio_ring_rip,
> +	.release = iio_ring_release,
> +	.open = iio_ring_open,
> +	.owner = THIS_MODULE,
> +};
> +
> +inline int __iio_request_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
> +						  int id,
> +						  struct module *owner,
> +						  struct device *dev)
> +{
> +	int ret;
> +
> +/* Create and register the event character device */
> +	buf->event_minor_name = kmalloc(20, GFP_KERNEL);
> +	if (buf->event_minor_name == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	sprintf(buf->event_minor_name, "ring_buffer%d_ev_minor", id);
> +	ret = iio_setup_ev_int(&(buf->ev_int),
> +			       (const char *)(buf->event_minor_name),
> +			       owner,
> +			       dev);
> +	if (ret)
> +		goto error_free_event_minor_name;
> +
> +	return 0;
> +
> +error_free_event_minor_name:
> +	kfree(buf->event_minor_name);
> +error_ret:
> +	return ret;
> +}
> +
> +inline void __iio_free_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
> +						struct device *dev)
> +{
> +	iio_free_ev_int(&(buf->ev_int), dev);
> +	kfree(buf->event_minor_name);
> +}
> +
> +inline int
> +__iio_request_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
> +					int id,
> +					struct module *owner,
> +					struct device *dev,
> +					const struct file_operations *fops)
> +{
> +	int ret;
> +/* Create and register the access character device */
> +	buf->access_minor_name = kmalloc(20, GFP_KERNEL);
> +	if (buf->access_minor_name == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	sprintf(buf->access_minor_name, "ring_buffer%d_access_minor", id);
> +
> +	ret = iio_allocate_chrdev(&buf->access_handler);
> +	if (ret)
> +		goto error_free_access_minor_name;
> +	buf->access_handler.fops = fops;
> +	buf->access_handler.flags = 0;
> +
> +	__init_iio_chrdev_minor_attr(&buf->access_minor_attr,
> +				   (const char *)(buf->access_minor_name),
> +				   owner,
> +				   buf->access_handler.id);
> +
> +	ret = sysfs_create_file(&dev->kobj,
> +				&(buf->access_minor_attr.dev_attr.attr));
> +	if (ret)
> +		goto error_deallocate_chrdev;
> +	return 0;
> +
> +error_deallocate_chrdev:
> +	iio_deallocate_chrdev(&buf->access_handler);
> +error_free_access_minor_name:
> +	kfree(buf->access_minor_name);
> +error_ret:
> +	return ret;
> +}
> +
> +inline void __iio_free_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
> +						 struct device *dev)
> +{
> +	sysfs_remove_file(&dev->kobj,
> +			  &buf->access_minor_attr.dev_attr.attr);
> +	iio_deallocate_chrdev(&buf->access_handler);
> +	kfree(buf->access_minor_name);
> +}
> +
> +int iio_request_hw_ring_buffer(int bytes_per_datum,
> +			       int length,
> +			       struct iio_hw_ring_buffer **ring,
> +			       int id,
> +			       struct module *owner,
> +			       struct device *dev,
> +			       const struct file_operations *fops,
> +			       void *private)
> +{
> +	int ret;
> +
> +	*ring = kmalloc(sizeof(struct iio_hw_ring_buffer),
> +			GFP_KERNEL);
> +
> +	if (*ring == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	(*ring)->private = private;
> +	INIT_IIO_RING_BUFFER(&((*ring)->buf), bytes_per_datum, length);
> +	ret = __iio_request_ring_buffer_event_chrdev(&(*ring)->buf,
> +						     id,
> +						     owner,
> +						     dev);
> +
> +	if (ret)
> +		goto error_free_ring_data;
> +	ret = __iio_request_ring_buffer_access_chrdev(&(*ring)->buf,
> +						      id,
> +						      owner,
> +						      dev,
> +						      fops);
> +	if (ret)
> +		goto error_free_ring_buffer_event_chrdev;
> +	(*ring)->buf.ev_int.private = (*ring);
> +	(*ring)->buf.access_handler.private = (*ring);
> +
> +	return 0;
> +
> +error_free_ring_buffer_event_chrdev:
> +	__iio_free_ring_buffer_event_chrdev(&(*ring)->buf, dev);
> +error_free_ring_data:
> +	/* there isn't any!*/
> +error_ret:
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iio_request_hw_ring_buffer);
> +
> +void iio_free_hw_ring_buffer(struct iio_hw_ring_buffer *ring,
> +			     struct device *dev)
> +{
> +	__iio_free_ring_buffer_access_chrdev(&(ring->buf), dev);
> +	__iio_free_ring_buffer_event_chrdev(&(ring->buf), dev);
> +	kfree(ring);
> +}
> +EXPORT_SYMBOL_GPL(iio_free_hw_ring_buffer);
> +
> +
> +/* Resize the ring if requested - run whenever ring buffer mode entered */
> +int __iio_request_update_sw_ring_buffer(int bytes_per_datum,
> +					int length,
> +					struct iio_sw_ring_buffer *ring,
> +					int id,
> +					struct module *owner,
> +					struct device *dev)
> +{
> +/* Reference count the ring - if anyone is using it this will fail!*/
> +	int ret = 0;
> +/* Need to sanity check if this is necessary? */
> +	spin_lock(ring->use_lock);
> +
> +	if (ring->use_count || !ring->update_needed) {
> +		ret = -EAGAIN;
> +		goto error_ret;
> +	}
> +	kfree(ring->data);
> +	/* keeps clear of chr devs etc - so fine to use here - I THINK!*/
> +	INIT_IIO_SW_RING_BUFFER(ring, bytes_per_datum, length);
> +	if (ring->data == NULL)
> +		ret = -ENOMEM;
> +
> +error_ret:
> +	spin_unlock(ring->use_lock);
> +	return ret;
> +}
> +
> +int iio_request_update_sw_ring_buffer(struct iio_dev *dev_info, int id)
> +{
> +	return __iio_request_update_sw_ring_buffer(dev_info
> +						   ->ring_bytes_per_datum,
> +						   dev_info->ring_length,
> +						   dev_info->ring,
> +						   id,
> +						   dev_info->driver_module,
> +						   dev_info->dev);
> +}
> +EXPORT_SYMBOL_GPL(iio_request_update_sw_ring_buffer);
> +
> +/* Should only occur on init so no locking needed */
> +int iio_request_sw_ring_buffer(int bytes_per_datum,
> +			       int length,
> +			       struct iio_sw_ring_buffer **ring,
> +			       int id,
> +			       struct module *owner,
> +			       struct device *dev)
> +{
> +	int ret;
> +
> +	/* Actually do the ring buffer initialization */
> +	*ring = kzalloc(sizeof(struct iio_sw_ring_buffer),
> +			GFP_KERNEL);
> +	if (*ring == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	/* Moved to an allocation on demand model.*/
> +	iio_mark_sw_ring_buffer_need_update(*ring);
> +	ret = __iio_request_ring_buffer_event_chrdev(&(*ring)->buf,
> +						     id,
> +						     owner,
> +						     dev);
> +	if (ret)
> +		goto error_free_ring_data;
> +
> +	ret = __iio_request_ring_buffer_access_chrdev(&(*ring)->buf,
> +						      id,
> +						      owner,
> +						      dev,
> +						      &iio_ring_fileops);
> +	if (ret)
> +		goto error_free_ring_buffer_event_chrdev;
> +
> +	/* Setup the private pointer so the fileoperations will work */
> +	(*ring)->buf.ev_int.private = (*ring);
> +	(*ring)->buf.access_handler.private = (*ring);
> +
> +	return 0;
> +
> +error_free_ring_buffer_event_chrdev:
> +	__iio_free_ring_buffer_event_chrdev(&(*ring)->buf, dev);
> +error_free_ring_data:
> +	FREE_IIO_SW_RING_BUFFER(*ring);
> +	kfree(*ring);
> +error_ret:
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iio_request_sw_ring_buffer);
> +
> +void iio_free_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
> +			  struct device *dev)
> +{
> +	__iio_free_ring_buffer_access_chrdev(&(ring->buf), dev);
> +	__iio_free_ring_buffer_event_chrdev(&(ring->buf), dev);
> +	FREE_IIO_SW_RING_BUFFER(ring);
> +	kfree(ring);
> +}
> +EXPORT_SYMBOL_GPL(iio_free_sw_ring_buffer);
> +
> +static ssize_t iio_read_ring_length(struct device *dev,
> +					     struct device_attribute *attr,
> +					     char *buf)
> +{
> +	int len;
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +
> +	len = sprintf(buf, "%d\n", dev_info->ring_length);
> +
> +	return len;
> +}
> +
> +static ssize_t iio_write_ring_length(struct device *dev,
> +					      struct device_attribute *attr,
> +					      const char *buf,
> +					      size_t len)
> +{
> +	int ret;
> +	long val;
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	ret = strict_strtol(buf, 10, &val);
> +	if (ret)
> +		goto error_ret;
> +	/* Ring length stored here and in ring? */
> +	if (val != dev_info->ring_length) {
> +		dev_info->ring_length = val;
> +		iio_mark_sw_ring_buffer_need_update(dev_info->ring);
> +	}
> +
> +	return len;
> +error_ret:
> +	return ret;
> +}
> +
> +static ssize_t iio_read_ring_bps(struct device *dev,
> +					  struct device_attribute *attr,
> +					  char *buf)
> +{
> +	int len;
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +
> +	len = sprintf(buf, "%d\n", dev_info->ring_bytes_per_datum);
> +
> +	return len;
> +}
> +
> +
> +DEVICE_ATTR(length, S_IRUGO | S_IWUSR,
> +	    iio_read_ring_length,
> +	    iio_write_ring_length);
> +/* The software ring buffers aren't currently capable of changing the
> + * storage accuracy so this is read only.
> + */
> +DEVICE_ATTR(bps, S_IRUGO,
> +	    iio_read_ring_bps,
> +	    NULL);
> +
> +ssize_t iio_store_ring_enable(struct device *dev,
> +			      struct device_attribute *attr,
> +			      const char *buf,
> +			      size_t len)
> +{
> +	int ret;
> +	bool requested_state, current_state;
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +
> +	mutex_lock(&dev_info->mlock);
> +	requested_state = (buf[0] == '0') ? 0 : 1;
> +	current_state = (dev_info->currentmode
> +			 & (INDIO_RING_DATA_RDY | INDIO_RING_POLLED))
> +			 ? 1: 0;
> +	if (current_state == requested_state)
> +		goto done;
> +	if (requested_state) {
> +		if (dev_info->ring_preenable) {
> +			ret = dev_info->ring_preenable(dev_info);
> +			if (ret)
> +				goto error_ret;
> +		}
> +		ret = iio_request_update_sw_ring_buffer(dev_info, 0);
> +		if (ret)
> +			goto error_ret;
> +		iio_mark_sw_ring_buffer_in_use(dev_info->ring);
> +		if (dev_info->modes & INDIO_RING_DATA_RDY)
> +			dev_info->currentmode = INDIO_RING_DATA_RDY;
> +		else if (dev_info->modes & INDIO_RING_POLLED)
> +			dev_info->currentmode = INDIO_RING_POLLED;
> +		else { /* should never be reached */
> +			ret = -EINVAL;
> +			goto error_ret;
> +		}
> +
> +		if (dev_info->ring_postenable) {
> +			ret = dev_info->ring_postenable(dev_info);
> +			if (ret)
> +				goto error_ret;
> +		}
> +	} else {
> +		if (dev_info->ring_predisable) {
> +			ret = dev_info->ring_predisable(dev_info);
> +			if (ret)
> +				goto error_ret;
> +		}
> +		iio_unmark_sw_ring_buffer_in_use(dev_info->ring);
> +		dev_info->currentmode = INDIO_DIRECT_MODE;
> +		if (dev_info->ring_postdisable) {
> +			ret = dev_info->ring_postdisable(dev_info);
> +			if (ret)
> +				goto error_ret;
> +		}
> +	}
> +done:
> +	mutex_unlock(&dev_info->mlock);
> +	return len;
> +error_ret:
> +	mutex_unlock(&dev_info->mlock);
> +	return ret;
> +}
> +
> +static ssize_t iio_show_ring_enable(struct device *dev,
> +				    struct device_attribute *attr,
> +				    char *buf)
> +{
> +
> +	int len;
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +
> +	if (indio_dev->currentmode & (INDIO_RING_DATA_RDY | INDIO_RING_POLLED))
> +		len = sprintf(buf, "1\n");
> +	else
> +		len = sprintf(buf, "0\n");
> +
> +	return len;
> +}
> +
> +DEVICE_ATTR(sw_ring_enable, S_IRUGO | S_IWUSR,
> +	    iio_show_ring_enable,
> +	    iio_store_ring_enable);
> +
> +static struct attribute *iio_ring_attributes[] = {
> +	&dev_attr_length.attr,
> +	&dev_attr_bps.attr,
> +	&dev_attr_sw_ring_enable.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group iio_ring_attribute_group = {
> +	.name = "ring_buffer",
> +	.attrs = iio_ring_attributes,
> +};
> +
> +int iio_device_register_sw_ring(struct iio_dev *dev_info, int id)
> +{
> +	int ret;
> +
> +	ret = iio_request_sw_ring_buffer(dev_info->ring_bytes_per_datum,
> +					 dev_info->ring_length,
> +					 &dev_info->ring,
> +					 id,
> +					 dev_info->driver_module,
> +					 dev_info->dev);
> +	if (ret < 0)
> +		goto error_ret;
> +
> +	ret = sysfs_create_group(&dev_info->dev->kobj,
> +				 &iio_ring_attribute_group);
> +	if (ret)
> +		goto error_free_ring;
> +
> +	return 0;
> +
> +error_free_ring:
> +	iio_free_sw_ring_buffer(dev_info->ring, dev_info->dev);
> +error_ret:
> +	return ret;
> +}
> +
> +void iio_device_unregister_sw_ring(struct iio_dev *dev_info)
> +{
> +	sysfs_remove_group(&dev_info->dev->kobj,
> +			   &iio_ring_attribute_group);
> +	/* deallocate ring buffer related stuff */
> +	if (dev_info->modes & (INDIO_RING_POLLED | INDIO_RING_DATA_RDY))
> +		iio_free_sw_ring_buffer(dev_info->ring, dev_info->dev);
> +
> +}

Nice idea, I just don't get what is actually going on in
here. This needs more planning.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

