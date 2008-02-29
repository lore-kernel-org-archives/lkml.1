Return-Path: <linux-kernel-owner+w=401wt.eu-S933772AbYB2UgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbYB2UgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbYB2Ufx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:35:53 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbYB2Ufv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:35:51 -0500
Date: Fri, 29 Feb 2008 12:35:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, apw@shadowen.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Message-Id: <20080229123512.f85f417c.akpm@linux-foundation.org>
In-Reply-To: <47C7FB0F.1060902@gdsys.de>
References: <20080229020245.61f1f8f4.akpm@linux-foundation.org>
	<47C7FB0F.1060902@gdsys.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 13:31:11 +0100
Dirk Eibach <eibach@gdsys.de> wrote:

> So here is a new try.
> 

Please reissue the possibly-updated changelog and signed-off-by: with each
revision of a patch.

Please cc linux-usb on usb patches.

> diff -purN linux-2.6.24/drivers/usb/serial/cp2101.c linux-2.6.24-diff/drivers/usb/serial/cp2101.c
> --- linux-2.6.24/drivers/usb/serial/cp2101.c	2008-01-24 23:58:37.000000000 +0100
> +++ linux-2.6.24-diff/drivers/usb/serial/cp2101.c	2008-02-29 13:15:58.168233146 +0100
> @@ -18,6 +18,8 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/platform_device.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
>  #include <linux/tty.h>
> @@ -52,6 +54,8 @@ static void cp2101_shutdown(struct usb_s
>  
>  static int debug;
>  
> +static int enable_config = false;

Should be either

static int enable_config;

or, if you're being very formal,

static bool enable_config = false;

or, if you're being less formal and want to avoid bloating the kernel image,

static bool enable_config;

> +static ssize_t write_reload(struct device *dev, struct device_attribute *attr,
> +	const char *buf, size_t count)
> +{
> +	int result;
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	/* writing "0" does not trigger */
> +	if (!strict_strtoul(buf, NULL, 0))
> +		return count;
> +
> +	result = usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_RELOAD,
> +		0, NULL, 0, 300);
> +
> +	/* this request is expected to fail because cp210x reboots */
> +
> +	return count;
> +}

The comment will suffice - there's no need to add the do-nothing `result'.

> +static DEVICE_ATTR(reload, S_IWUGO, NULL, write_reload);
> +
> +static ssize_t write_vendor_id(struct device *dev, struct device_attribute *attr,
> +	const char *buf, size_t count)
> +{
> +	int result;
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	unsigned long vendor_id = strict_strtoul(buf, NULL, 0);
> +
> +	if (!vendor_id || vendor_id > 0xffff)
> +		return -EINVAL;
> +
> +	result = usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_VENDOR_ID,
> +		vendor_id, NULL, 0, 300);
> +
> +	if (result)
> +		return -EIO;
> +
> +	return count;
> +}

usb_control_msg() already returns an errno - we should just propagate that
back to the caller rather than overwriting, say, -ENOMEM with -EIO.

> +static DEVICE_ATTR(vendor_id, S_IWUGO, NULL, write_vendor_id);
> +
> +static ssize_t write_product_id(struct device *dev, struct device_attribute *attr,
> +	const char *buf, size_t count)
> +{
> +	int result;
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	unsigned long product_id = strict_strtoul(buf, NULL, 0);
> +
> +	if (!product_id || product_id > 0xffff)
> +		return -EINVAL;
> +
> +	result = usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_PRODUCT_ID,
> +		product_id, NULL, 0, 300);
> +
> +	if (result)
> +		return -EIO;
> +
> +	return count;
> +}

ditto

> +static DEVICE_ATTR(product_id, S_IWUGO, NULL, write_product_id);
> +
> +static ssize_t write_serialnumber(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	int result;
> +	unsigned int k;
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +	u8 serial_stringsize = 2 + 2*count;
> +	char serial[2 + 2*SERIALNUMBER_MAX_CHARS];

128 bytes of stack is a little more than we'd like (the kernel is really
squeezy on stack space sometimes).  kmalloc would be better...

> +	if (count > SERIALNUMBER_MAX_CHARS)
> +		return -EINVAL;
> +
> +	serial[0] = serial_stringsize;
> +	serial[1] = USB_DT_STRING;
> +
> +	/* convert to utf-16 */
> +	printk("#Max index: %d\n", serial_stringsize - 1);

checkpatch...

> +	for (k = 0; k < count; ++k) {
> +		printk("Address index %d and %d\n", 2+2*k, 2+2*k+1);
> +		serial[2+2*k] = buf[k];
> +		serial[2+2*k+1] = 0;
> +	}
> +
> +	result = usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_SERIALNUMBER,
> +		0, serial, serial_stringsize, 300);
> +
> +	if (result != serial_stringsize)
> +		return -EIO;
> +
> +	return count;
> +}
>
> ...
>
> +static ssize_t write_lock_forever(struct device *dev,
> +	struct device_attribute *attr,	const char *buf, size_t count)
> +{
> +	int result;
> +	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
> +
> +	unsigned long lock = strict_strtoul(buf, NULL, 0);
> +
> +	/* be really, really sure to know what you are doing here */
> +	if (lock != 0xabadbabe)
> +		return -EINVAL;

this is incomprehehsible without docs

> +	result = usb_control_msg(usbdev,
> +		usb_sndctrlpipe(usbdev, 0),
> +		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_LOCK,
> +		0x00f0, NULL, 0, 300);
> +
> +	if (result)
> +		return -EIO;
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(lock_forever, S_IWUGO, NULL, write_lock_forever);
> +
> +static struct attribute *cp2101_attributes[] = {
> +	&dev_attr_reload.attr,
> +	&dev_attr_vendor_id.attr,
> +	&dev_attr_product_id.attr,
> +	&dev_attr_productstring.attr,
> +	&dev_attr_serialnumber.attr,
> +	&dev_attr_self_powered.attr,
> +	&dev_attr_max_power.attr,
> +	&dev_attr_release_version.attr,
> +	&dev_attr_lock_forever.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group cp2101_group = {
> +	.attrs = cp2101_attributes,
> +};
> +
>  static int cp2101_startup (struct usb_serial *serial)
>  {
> +	int err;
> +
>  	/* CP2101 buffers behave strangely unless device is reset */
>  	usb_reset_device(serial->dev);
> -	return 0;
> +
> +	if (!enable_config)
> +		return 0;
> +
> +	err = sysfs_create_group(&serial->dev->dev.kobj, &cp2101_group);
> +	
> +	return err;
>  }
>  
>  static void cp2101_shutdown (struct usb_serial *serial)
> @@ -721,6 +1015,11 @@ static void cp2101_shutdown (struct usb_
>  	for (i=0; i < serial->num_ports; ++i) {
>  		cp2101_cleanup(serial->port[i]);
>  	}
> +
> +	if (!enable_config)
> +		return;
> +
> +	sysfs_remove_group(&serial->dev->dev.kobj, &cp2101_group);
>  }
>  
>  static int __init cp2101_init (void)
> @@ -758,3 +1057,6 @@ MODULE_LICENSE("GPL");
>  
>  module_param(debug, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Enable verbose debugging messages");
> +
> +module_param(enable_config, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(enable_config, "Enable sysfs access to configuration eeprom.");
> 

