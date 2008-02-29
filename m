Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYB2KD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYB2KD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYB2KDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:03:11 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbYB2KDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:03:02 -0500
Date: Fri, 29 Feb 2008 02:02:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-Id: <20080229020245.61f1f8f4.akpm@linux-foundation.org>
In-Reply-To: <47C7CA1A.3080001@gdsys.de>
References: <47C7CA1A.3080001@gdsys.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 10:02:18 +0100 Dirk Eibach <eibach@gdsys.de> wrote:

> From: Dirk Eibach <eibach@gdsys.de>
> 
> The usb configuration data for the Silabs CP2101 usb to uart bridge 
> controller can be customized:
> - Vendor ID
> - Product ID
> - Power Descriptor
> - Release Number
> - Serial Number
> - Product Description String
> 
> Silabs provides a windows-only tool to do that.
> Since we use linux-only machines in our production-environment, we have no 
> proper way to customize the chips for our purpose.
> So I added sysfs configuration support to the linux driver.
> 

Thanks.


>From where do our users get the information which they are to write into
these sysfs files?


Please pass your diff through scripts/checkpatch.pl and address the (valid)
errors which it reports.

> +static ssize_t write_vid(struct device *dev, struct device_attribute *attr,
> +	const char *buf, size_t count)
> +{
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	unsigned long vid = simple_strtoul(buf, NULL, 0);

If a user writes "12bucklemyshoe" into one of your sysfs files the kernel
will treat this as 12, which is poor form.

We have a new strict_strtoul() (and related functions) which will perform
proper checking for a valid number.  Please use that interface.

Andy, this is going to happen so much that a "should you have used
strict_strtoul?" warning in checkpatch would reduce my email output.


> +	if (!vid || vid > 0xffff)
> +		return -EINVAL;
> +
> +	usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_VID,
> +		vid, NULL, 0, 300);

usb_control_msg() can return an error, but this driver doesn't check for
that in several places.

> +	return count;
> +}
> +
> +static DEVICE_ATTR(vid, S_IWUGO, NULL, write_vid);
> +
> +static ssize_t write_pid(struct device *dev, struct device_attribute *attr,
> +	const char *buf, size_t count)
> +{
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	unsigned long pid = simple_strtoul(buf, NULL, 0);
> +
> +	if (!pid || pid > 0xffff)
> +		return -EINVAL;
> +
> +	usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_PID,
> +		pid, NULL, 0, 300);
> +
> +	return count;
> +}

<gets worried>

Oh.  Here, "pid" means product ID, not process ID.  A little comment over
these functions would be nice ;)

> +static DEVICE_ATTR(pid, S_IWUGO, NULL, write_pid);
> +
> +static ssize_t write_serialnumber(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	int result;
> +	unsigned int k;
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +	u8 serial_stringsize = 2 + 2*count;
> +	char serial[serial_stringsize];
> +
> +	if (count > 63)
> +		return -EINVAL;

uh-oh.  serial[] is dynamically allocated on the stack _before_ we've
checked `count'.  Methinks we've just give people a way to allocate 8GB of
kernel stack, which won't work terribly well.

I suggest a switch to kmalloc().

> +	serial[0] = serial_stringsize;
> +	serial[1] = USB_DT_STRING;
> +
> +	/* convert to utf-16 */
> +	for (k = 0; k < count; ++k) {
> +		serial[2+2*k] = buf[k];
> +		serial[2+2*k+1] = 0;
> +	}

Are you sure this doesn't run off the end of serial[]?

> +	result = usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_SERIALNUMBER,
> +		0, serial, sizeof(serial), 300);
> +
> +	if (result != serial_stringsize)
> +		return -EIO;
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(serialnumber, S_IWUGO, NULL, write_serialnumber);
> +
> +
> +static ssize_t write_productstring(struct device *dev,
> +	struct device_attribute *attr,	const char *buf, size_t count)
> +{
> +	int result;
> +	unsigned int k;
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +	u8 product_stringsize = 2 + 2*count;
> +	char product[product_stringsize];
> +
> +	if (count > 126)
> +		return -EINVAL;
> +
> +	product[0] = product_stringsize;
> +	product[1] = USB_DT_STRING;
> +
> +	/* convert to utf-16 */
> +	for (k = 0; k < count; ++k) {
> +		product[2+2*k] = buf[k];
> +		product[2+2*k+1] = 0;
> +	}
> +
> +	result = usb_control_msg(usbdev,
> +			usb_sndctrlpipe(usbdev, 0),
> +			CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE,
> +			EEPROM_PRODUCTSTRING, 0,
> +			product, sizeof(product), 300);
> +
> +	if (result != product_stringsize)
> +		return -EIO;
> +
> +	return count;
> +}

dittoes.

> +static DEVICE_ATTR(productstring, S_IWUGO, NULL, write_productstring);
> +
> +static ssize_t write_self_powered(struct device *dev,
> +	struct device_attribute *attr,	const char *buf, size_t count)
> +{
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	unsigned long self_powered = simple_strtoul(buf, NULL, 0);
> +
> +	usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_POWER_ATTRIB,
> +		self_powered ? 0x00c0 : 0x0080, NULL, 0, 300);
> +
> +	return count;
> +}
>
> ...
>
> +static ssize_t write_lock_forever(struct device *dev,
> +	struct device_attribute *attr,	const char *buf, size_t count)
> +{
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	unsigned long lock = simple_strtoul(buf, NULL, 0);
> +
> +	/* be really, really sure to know what you are doing here */
> +	if (lock != 0xabadbabe)
> +		return -EINVAL;
> +
> +	usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_LOCK,
> +		0x00f0, NULL, 0, 300);
> +
> +	return count;
> +}

hm, interesting.  A bit of interface documetation would be nice.

> +static DEVICE_ATTR(lock_forever, S_IWUGO, NULL, write_lock_forever);
> +
>  static int cp2101_startup (struct usb_serial *serial)
>  {
> +	int err;
> +
>  	/* CP2101 buffers behave strangely unless device is reset */
>  	usb_reset_device(serial->dev);
> +
> +	if (!enable_config)
> +		return 0;
> +
> +	err = device_create_file(&serial->dev->dev, &dev_attr_reload);
> +	if (err) goto out;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_vid);
> +	if (err) goto out_reload;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_pid);
> +	if (err) goto out_vid;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_productstring);
> +	if (err) goto out_pid;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_serialnumber);
> +	if (err) goto out_productstring;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_self_powered);
> +	if (err) goto out_serialnumber;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_max_power);
> +	if (err) goto out_self_powered;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_release_version);
> +	if (err) goto out_max_power;
> +	err = device_create_file(&serial->dev->dev, &dev_attr_lock_forever);
> +	if (err) goto out_release_version;
> +
>  	return 0;
> +
> +out_release_version:
> +	device_remove_file(&serial->dev->dev, &dev_attr_release_version);
> +out_max_power:
> +	device_remove_file(&serial->dev->dev, &dev_attr_max_power);
> +out_self_powered:
> +	device_remove_file(&serial->dev->dev, &dev_attr_self_powered);
> +out_serialnumber:
> +	device_remove_file(&serial->dev->dev, &dev_attr_serialnumber);
> +out_productstring:
> +	device_remove_file(&serial->dev->dev, &dev_attr_productstring);
> +out_pid:
> +	device_remove_file(&serial->dev->dev, &dev_attr_pid);
> +out_vid:
> +	device_remove_file(&serial->dev->dev, &dev_attr_vid);
> +out_reload:
> +	device_remove_file(&serial->dev->dev, &dev_attr_reload);
> +out:
> +	return err;
>  }

I think the attribute-group interface will permit you to do this more
elegantly.

>  static void cp2101_shutdown (struct usb_serial *serial)
> @@ -721,6 +988,19 @@ static void cp2101_shutdown (struct usb_
>  	for (i=0; i < serial->num_ports; ++i) {
>  		cp2101_cleanup(serial->port[i]);
>  	}
> +
> +	if (!enable_config)
> +		return;
> +
> +	device_remove_file(&serial->dev->dev, &dev_attr_reload);
> +	device_remove_file(&serial->dev->dev, &dev_attr_vid);
> +	device_remove_file(&serial->dev->dev, &dev_attr_pid);
> +	device_remove_file(&serial->dev->dev, &dev_attr_productstring);
> +	device_remove_file(&serial->dev->dev, &dev_attr_serialnumber);
> +	device_remove_file(&serial->dev->dev, &dev_attr_self_powered);
> +	device_remove_file(&serial->dev->dev, &dev_attr_max_power);
> +	device_remove_file(&serial->dev->dev, &dev_attr_release_version);
> +	device_remove_file(&serial->dev->dev, &dev_attr_lock_forever);
>  }
>
> ...
>
> +/*
> + * Silicon Laboratories CP2101/CP2102 USB to RS232 serial adaptor driver
> + *
> + * Copyright (C) 2005 Craig Shelley (craig@microtron.org.uk)
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License version
> + *	2 as published by the Free Software Foundation.
> + *
> + * Support to set flow control line levels using TIOCMGET and TIOCMSET
> + * thanks to Karl Hiramoto karl@hiramoto.org. RTSCTS hardware flow
> + * control thanks to Munir Nassar nassarmu@real-time.com
> + *
> + * Outstanding Issues:
> + *  Buffers are not flushed when the port is opened.
> + *  Multiple calls to write() may fail with "Resource temporarily unavailable"
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/usb.h>
> +#include <asm/uaccess.h>

Please include linux/foo.h in preference to asm/foo.h when linux/foo.h
exists.

checkpatch used to detect this but it got broken.

> +#include <linux/usb/serial.h>
> +
> +/*
> + * Version Information
> + */
> +#define DRIVER_VERSION "v0.07"
> +#define DRIVER_DESC "Silicon Labs CP2101/CP2102 RS232 serial adaptor driver"
> +
> +/*
> + * Function Prototypes
> + */
> +static int cp2101_open(struct usb_serial_port*, struct file*);
> +static void cp2101_cleanup(struct usb_serial_port*);
> +static void cp2101_close(struct usb_serial_port*, struct file*);
> +static void cp2101_get_termios(struct usb_serial_port*);
> +static void cp2101_set_termios(struct usb_serial_port*, struct ktermios*);
> +static int cp2101_tiocmget (struct usb_serial_port *, struct file *);
> +static int cp2101_tiocmset (struct usb_serial_port *, struct file *,
> +		unsigned int, unsigned int);
> +static void cp2101_break_ctl(struct usb_serial_port*, int);
> +static int cp2101_startup (struct usb_serial *);
> +static void cp2101_shutdown(struct usb_serial*);
> +
> +
> +static int debug;
> +
> +static struct usb_device_id id_table [] = {

This should have been laid out as "id_table[]".  checkpatch misses this.

> +	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
> +	{ USB_DEVICE(0x0FCF, 0x1003) }, /* Dynastream ANT development board */
> +	{ USB_DEVICE(0x0FCF, 0x1004) }, /* Dynastream ANT2USB */
> +	{ USB_DEVICE(0x10A6, 0xAA26) }, /* Knock-off DCU-11 cable */
> +	{ USB_DEVICE(0x10AB, 0x10C5) }, /* Siemens MC60 Cable */
> +	{ USB_DEVICE(0x10B5, 0xAC70) }, /* Nokia CA-42 USB */
> +	{ USB_DEVICE(0x10C4, 0x803B) }, /* Pololu USB-serial converter */
> +	{ USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
> +	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
> +	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
> +	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
> +	{ USB_DEVICE(0x10C4, 0x80DD) }, /* Tracient RFID */
> +	{ USB_DEVICE(0x10C4, 0x80F6) }, /* Suunto sports instrument */
> +	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
> +	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
> +	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
> +	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
> +	{ USB_DEVICE(0x10C4, 0x81C8) }, /* Lipowsky Industrie Elektronik GmbH, Baby-JTAG */
> +	{ USB_DEVICE(0x10C4, 0x81E2) }, /* Lipowsky Industrie Elektronik GmbH, Baby-LIN */
> +	{ USB_DEVICE(0x10C4, 0x81E7) }, /* Aerocomm Radio */
> +	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
> +	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
> +	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
> +	{ USB_DEVICE(0x10C5, 0xEA61) }, /* Silicon Labs MobiData GPRS USB Modem */
> +	{ USB_DEVICE(0x13AD, 0x9999) }, /* Baltech card reader */
> +	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
> +	{ } /* Terminating Entry */
> +};
> +
>
> ...
>
> +/*
> + * cp2101_get_config
> + * Reads from the CP2101 configuration registers
> + * 'size' is specified in bytes.
> + * 'data' is a pointer to a pre-allocated array of integers large
> + * enough to hold 'size' bytes (with 4 bytes to each integer)
> + */
> +static int cp2101_get_config(struct usb_serial_port* port, u8 request,
> +		unsigned int *data, int size)
> +{
> +	struct usb_serial *serial = port->serial;
> +	__le32 *buf;
> +	int result, i, length;
> +
> +	/* Number of integers required to contain the array */
> +	length = (((size - 1) | 3) + 1)/4;

That looks tricky.  Could we just do ROUND_UP(size, 4)?

> +	buf = kcalloc(length, sizeof(__le32), GFP_KERNEL);
> +	if (!buf) {
> +		dev_err(&port->dev, "%s - out of memory.\n", __FUNCTION__);
> +		return -ENOMEM;
> +	}
> +
> +	/* For get requests, the request number must be incremented */
> +	request++;
> +
> +	/* Issue the request, attempting to read 'size' bytes */
> +	result = usb_control_msg (serial->dev,usb_rcvctrlpipe (serial->dev, 0),
> +				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
> +				0, buf, size, 300);

Please don't pu a space before the function call operator "(".

checkpatch misses this too - I suspect it got confused and bailed out.


> +	/* Convert data into an array of integers */
> +	for (i=0; i<length; i++)

spaces around the "=" and the "<" here.

> +		data[i] = le32_to_cpu(buf[i]);
> +
> +	kfree(buf);
> +
> +	if (result != size) {
> +		dev_err(&port->dev, "%s - Unable to send config request, "
> +				"request=0x%x size=%d result=%d\n",
> +				__FUNCTION__, request, size, result);
> +		return -EPROTO;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * cp2101_set_config
> + * Writes to the CP2101 configuration registers
> + * Values less than 16 bits wide are sent directly
> + * 'size' is specified in bytes.
> + */
> +static int cp2101_set_config(struct usb_serial_port* port, u8 request,
> +		unsigned int *data, int size)
> +{
> +	struct usb_serial *serial = port->serial;
> +	__le32 *buf;
> +	int result, i, length;
> +
> +	/* Number of integers required to contain the array */
> +	length = (((size - 1) | 3) + 1)/4;

ROUND_UP?

> +	buf = kmalloc(length * sizeof(__le32), GFP_KERNEL);
> +	if (!buf) {
> +		dev_err(&port->dev, "%s - out of memory.\n",
> +				__FUNCTION__);
> +		return -ENOMEM;
> +	}
> +
> +	/* Array of integers into bytes */
> +	for (i = 0; i < length; i++)

yes, like that.

> +		buf[i] = cpu_to_le32(data[i]);
> +
> +	if (size > 2) {
> +		result = usb_control_msg (serial->dev,
> +				usb_sndctrlpipe(serial->dev, 0),
> +				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
> +				0, buf, size, 300);
> +	} else {
> +		result = usb_control_msg (serial->dev,
> +				usb_sndctrlpipe(serial->dev, 0),
> +				request, REQTYPE_HOST_TO_DEVICE, data[0],
> +				0, NULL, 0, 300);
> +	}
> +
> +	kfree(buf);
> +
> +	if ((size > 2 && result != size) || result < 0) {
> +		dev_err(&port->dev, "%s - Unable to send request, "
> +				"request=0x%x size=%d result=%d\n",
> +				__FUNCTION__, request, size, result);
> +		return -EPROTO;
> +	}
> +
> +	/* Single data value */
> +	result = usb_control_msg (serial->dev,
> +			usb_sndctrlpipe(serial->dev, 0),
> +			request, REQTYPE_HOST_TO_DEVICE, data[0],
> +			0, NULL, 0, 300);
> +	return 0;
> +}
>
> ...
>
> +static int cp2101_open (struct usb_serial_port *port, struct file *filp)

yes, checkpatch has failed us here.

> +{
> +	struct usb_serial *serial = port->serial;
> +	int result;
> +
> +	dbg("%s - port %d", __FUNCTION__, port->number);
> +
> +	if (cp2101_set_config_single(port, CP2101_UART, UART_ENABLE)) {
> +		dev_err(&port->dev, "%s - Unable to enable UART\n",
> +				__FUNCTION__);
> +		return -EPROTO;
> +	}
> +
> +	/* Start reading from the device */
> +	usb_fill_bulk_urb (port->read_urb, serial->dev,
> +			usb_rcvbulkpipe(serial->dev,
> +			port->bulk_in_endpointAddress),
> +			port->read_urb->transfer_buffer,
> +			port->read_urb->transfer_buffer_length,
> +			serial->type->read_bulk_callback,
> +			port);
> +	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
> +	if (result) {
> +		dev_err(&port->dev, "%s - failed resubmitting read urb, "
> +				"error %d\n", __FUNCTION__, result);
> +		return result;
> +	}
> +
> +	/* Configure the termios structure */
> +	cp2101_get_termios(port);
> +
> +	/* Set the DTR and RTS pins low */
> +	cp2101_tiocmset(port, NULL, TIOCM_DTR | TIOCM_RTS, 0);
> +
> +	return 0;
> +}
> +
> +/*
> + * cp2101_get_termios
> + * Reads the baud rate, data bits, parity, stop bits and flow control mode
> + * from the device, corrects any unsupported values, and configures the
> + * termios structure to reflect the state of the device
> + */
> +static void cp2101_get_termios (struct usb_serial_port *port)

Please cc Alan Cox <alan@lxorguk.ukuu.org.uk> on the next version - he
might review the termios stuff for us.

> +{
> +	unsigned int cflag, modem_ctl[4];
> +	int baud;
> +	int bits;
> +
> +	dbg("%s - port %d", __FUNCTION__, port->number);
> +
> +	if (!port->tty || !port->tty->termios) {

can this happen?

> +		dbg("%s - no tty structures", __FUNCTION__);
> +		return;
> +	}
> +
> +	cp2101_get_config(port, CP2101_BAUDRATE, &baud, 2);
> +	/* Convert to baudrate */
> +	if (baud)
> +		baud = BAUD_RATE_GEN_FREQ / baud;
> +
> +	dbg("%s - baud rate = %d", __FUNCTION__, baud);
> +
> +	tty_encode_baud_rate(port->tty, baud, baud);
> +	cflag = port->tty->termios->c_cflag;
> +
> +	cp2101_get_config(port, CP2101_BITS, &bits, 2);
> +	cflag &= ~CSIZE;
> +	switch(bits & BITS_DATA_MASK) {
> +		case BITS_DATA_5:
> +			dbg("%s - data bits = 5", __FUNCTION__);
> +			cflag |= CS5;
> +			break;
> +		case BITS_DATA_6:
> +			dbg("%s - data bits = 6", __FUNCTION__);
> +			cflag |= CS6;
> +			break;
> +		case BITS_DATA_7:
> +			dbg("%s - data bits = 7", __FUNCTION__);
> +			cflag |= CS7;
> +			break;
> +		case BITS_DATA_8:
> +			dbg("%s - data bits = 8", __FUNCTION__);
> +			cflag |= CS8;
> +			break;
> +		case BITS_DATA_9:
> +			dbg("%s - data bits = 9 (not supported, "
> +					"using 8 data bits)", __FUNCTION__);
> +			cflag |= CS8;
> +			bits &= ~BITS_DATA_MASK;
> +			bits |= BITS_DATA_8;
> +			cp2101_set_config(port, CP2101_BITS, &bits, 2);
> +			break;
> +		default:
> +			dbg("%s - Unknown number of data bits, "
> +					"using 8", __FUNCTION__);
> +			cflag |= CS8;
> +			bits &= ~BITS_DATA_MASK;
> +			bits |= BITS_DATA_8;
> +			cp2101_set_config(port, CP2101_BITS, &bits, 2);
> +			break;
> +	}

We normally indent the switch body one tabsyop less than this.

I'll stop emulating checkpatch now - let's work out why it failed, get that
fixed and then please run it.


