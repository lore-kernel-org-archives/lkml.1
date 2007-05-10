Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXEJLss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXEJLss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761615AbXEJLsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:48:36 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:4206 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761542AbXEJLse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:48:34 -0400
Date: Thu, 10 May 2007 13:48:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Message-ID: <20070510134850.64075278@hyperion.delvare>
In-Reply-To: <11785707423303-git-send-email-grant.likely@secretlab.ca>
References: <11785707423303-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mon,  7 May 2007 14:45:42 -0600, Grant Likely wrote:
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/i2c/chips/Kconfig  |   10 ++
>  drivers/i2c/chips/Makefile |    1 +
>  drivers/i2c/chips/ds1682.c |  363 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 374 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/chips/ds1682.c
> 

Please fix the following warnings:

drivers/i2c/chips/ds1682.c: In function ‘ds1682_store’:
drivers/i2c/chips/ds1682.c:129: warning: format ‘%i’ expects type ‘int’, but argument 5 has type ‘size_t’
drivers/i2c/chips/ds1682.c: In function ‘ds1682_user_data_store’:
drivers/i2c/chips/ds1682.c:220: warning: format ‘%i’ expects type ‘int’, but argument 4 has type ‘size_t’


> diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
> index 87ee3ce..21d73e6 100644
> --- a/drivers/i2c/chips/Kconfig
> +++ b/drivers/i2c/chips/Kconfig
> @@ -25,6 +25,16 @@ config SENSORS_DS1374
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called ds1374.
>  
> +config SENSORS_DS1682
> +	tristate "Maxim/Dallas DS1682 Total Elapsed Time Recorder with Alarm"
> +	depends on I2C && EXPERIMENTAL

Dependency on I2C is no longer needed in this directory, this is done
at menu level.

> +	help
> +	  If you say yes here you get support for Dallas Semiconductor
> +	  DS1682 Total Elapsed Time Recorder
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called ds1682.
> +

I know this isn't exactly a RTC chip, but this is still related with
timekeeping, so wouldn't it be better placed under drivers/rtc?
Alessandro, what do you think?

>  config SENSORS_EEPROM
>  	tristate "EEPROM reader"
>  	depends on I2C && EXPERIMENTAL
> diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
> index 779868e..5f76bda 100644
> --- a/drivers/i2c/chips/Makefile
> +++ b/drivers/i2c/chips/Makefile
> @@ -4,6 +4,7 @@
>  
>  obj-$(CONFIG_SENSORS_DS1337)	+= ds1337.o
>  obj-$(CONFIG_SENSORS_DS1374)	+= ds1374.o
> +obj-$(CONFIG_SENSORS_DS1682)	+= ds1682.o
>  obj-$(CONFIG_SENSORS_EEPROM)	+= eeprom.o
>  obj-$(CONFIG_SENSORS_MAX6875)	+= max6875.o
>  obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
> diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
> new file mode 100644
> index 0000000..181175a
> --- /dev/null
> +++ b/drivers/i2c/chips/ds1682.c
> @@ -0,0 +1,363 @@
> +/*
> + * Dallas Semiconductor DS1682 Elapsed Time Recorder device driver
> + *
> + * Written by: Grant Likely <grant.likely@secretlab.ca>
> + *
> + * Copyright (C) 2007 Secret Lab Technologies Ltd.
> + * Copyright (C) 2005 James Chapman <jchapman@katalix.com>
> + * Copyright (C) 2000 Russell King
> + *
> + * Derived from ds1337 real time clock device driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/*
> + * The DS1682 elapsed timer recorder is a simple device that implements
> + * one elapsed time counters, one event counter, an alarm signal and 10

"time counter", no s.

> + * bytes of general purpose EEPROM.
> + *
> + * This driver provides access to the DS1682 counters and user data via
> + * the sysfs.  The following attributes are added to the device node:
> + *     elapsed_time (u32): Total elapsed event time in 1/4s resolution

That's a bad idea. Please use a standard unit, so that drivers for
devices with a similar feature but a different implementation can be
used the same way. Milliseconds would be fine, I guess.

> + *     alarm_time (u32): When elapsed time exceeds the value in alarm_time,
> + *                       then the alarm pin is asserted.
> + *     event_count (u16): number of times the event pin has gone low.
> + *     user_data (u8[10]): general purpose EEPROM

The file is called "eeprom" in other drivers (eeprom, max6875), it
would be nice to use the same here for consistency.

> + *
> + * Counter registers and user data are both read/write unless the device
> + * has been write protected.  This driver does not support turning on write
> + * protection.  Once write protection is turned on, it is impossible to
> + * turn off so I have left the feature out of this driver to avoid
> + * accidental enabling, but it is trivial to add write protect support.
> + *
> + */
> +
> +#define DEBUG

No. DEBUG in i2c chip drivers is set based on CONFIG_I2C_DEBUG_CHIP.

> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/string.h>
> +#include <linux/bcd.h>

You don't appear to use this one?

> +#include <linux/list.h>
> +#include <linux/sysfs.h>
> +#include <linux/ctype.h>
> +
> +/* Device registers */
> +#define DS1682_ADDR			0x6B

Given that you use this only once a few lines below, I'm not sure
there's much value in a define.

> +
> +#define DS1682_REG_CONFIG		0x00
> +#define DS1682_REG_ALARM		0x01
> +#define DS1682_REG_ELAPSED		0x05
> +#define DS1682_REG_EVT_CNTR		0x09
> +#define DS1682_REG_USER_DATA		0x0b
> +#define DS1682_REG_RESET		0x1d
> +#define DS1682_REG_WRITE_DISABLE	0x1e
> +#define DS1682_REG_WRITE_MEM_DISABLE	0x1f
> +
> +/*
> + * Probing class
> + */

This is an address, not a class.

> +static unsigned short normal_i2c[] = { DS1682_ADDR, I2C_CLIENT_END };
> +
> +I2C_CLIENT_INSMOD;
> +
> +/*
> + * Low level chip access functions
> + */
> +static int ds1682_read(struct i2c_client *client, int reg, void *buf, int len)
> +{
> +	u8 *bytes = buf;
> +	int val;
> +
> +	while (len--) {
> +		val = i2c_smbus_read_byte_data(client, reg++);
> +		if (val < 0)
> +			return -EIO;
> +		*bytes++ = val;
> +	}
> +	return 0;
> +}

Did you check if the device supports I2C block reads? This would be
much faster, and might also solve consistency issues. Are you certain
that the above brings you back bytes which all belong to the same
"time measurement"? Does the device latch the register values on the
first read?

I find it strange that you use an I2C block write when writing values
to the chip, but individual byte reads in the other direction.

> +
> +/*
> + * Generic counter attributes
> + */
> +static int ds1682_attr_to_reg(struct device_attribute *attr, int *regsize);
> +
> +static ssize_t ds1682_show(struct device *dev,
> +			   struct device_attribute *attr, char *buf)
> +{
> +	u32 val = 0;

Shouldn't this be declared __le32 instead? Same for the other places
where you explicitly handle little-endian values.

> +	int reg;
> +	int regsize;
> +
> +	dev_dbg(dev, "ds1682_show() called for %s\n", attr->attr.name);
> +
> +	/* Get the register address */
> +	reg = ds1682_attr_to_reg(attr, &regsize);
> +	if (reg < 0)
> +		return -EIO;
> +
> +	/* Read the register */
> +	if (ds1682_read(to_i2c_client(dev), reg, &val, regsize))
> +		return -EIO;
> +
> +	/* Format the output string and return # of bytes */
> +	return sprintf(buf, "0x%.2x\n", le32_to_cpu(val));
> +}
> +
> +static ssize_t ds1682_store(struct device *dev,
> +			    struct device_attribute *attr, const char *buf,
> +			    size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int reg;
> +	int regsize;
> +	char *endp;
> +	u32 val;
> +	int rc;
> +
> +	/* Sanitize the input */
> +	reg = ds1682_attr_to_reg(attr, &regsize);
> +
> +	if ((reg < 0) || (count >= 16) || (buf[count] != '\0')) {

How could buf[count] not be '\0'? As far as I know this is guaranteed
by the underlying sysfs code. I also don't see the point of checking
the value of count.

> +		dev_dbg(dev, "insane input; reg=0x%i count=%i%s\n",
> +			reg, count, buf[count] == '\0' ? " unterminated" : "");
> +		return -EIO;
> +	}
> +
> +	/* Decode input */
> +	val = simple_strtoul(buf, &endp, 0);
> +	if (buf == endp) {
> +		dev_dbg(dev, "input string not a number\n");
> +		return -EIO;
> +	}
> +
> +	/* write out the value */
> +	val = cpu_to_le32(val);
> +	rc = i2c_smbus_write_i2c_block_data(client, reg, regsize, (void *)&val);

You should cast to u8*, that's what i2c_smbus_write_i2c_block_data
takes.

> +	if (rc < 0) {
> +		dev_err(dev, "register write failed; reg=0x%x, size=%i\n",
> +			reg, regsize);
> +		return -EIO;
> +	}
> +
> +	return count;
> +}
> +
> +/*
> + * Simple register attributes
> + */
> +DEVICE_ATTR(config, S_IRUGO, ds1682_show, NULL);
> +DEVICE_ATTR(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
> +DEVICE_ATTR(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
> +DEVICE_ATTR(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
> +
> +/* Get register size and address from device_attribute structure.  This
> + * function must come after the DEVICE_ATTR() lines as it depends on the
> + * device_attribute lines being declared */
> +static int ds1682_attr_to_reg(struct device_attribute *attr, int *regsize)
> +{
> +	if (attr == &dev_attr_elapsed_time) {
> +		*regsize = 4;
> +		return DS1682_REG_ELAPSED;
> +	}
> +
> +	if (attr == &dev_attr_alarm_time) {
> +		*regsize = 4;
> +		return DS1682_REG_ALARM;
> +	}
> +
> +	if (attr == &dev_attr_event_count) {
> +		*regsize = 2;
> +		return DS1682_REG_EVT_CNTR;
> +	}
> +
> +	if (attr == &dev_attr_config) {
> +		*regsize = 1;
> +		return DS1682_REG_CONFIG;
> +	}
> +
> +	pr_debug("Cannot find registers for device_attribute %p\n", attr);
> +	return -ENODEV;
> +}

You can do much better than that, using additional attribute
properties. This is done in many hardware monitoring drivers. Look at
<linux/hwmon-sysfs.h>, then see the w83792d driver for an example of
use. Using a similar technique you could easily attach the register and
size information directly to each attribute, so you don't need this
expensive look-up.

> +
> +/*
> + * User data attribute
> + */
> +static ssize_t ds1682_user_data_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	char *end = buf;
> +	u8 val[10];
> +	int i;
> +
> +	if (ds1682_read(to_i2c_client(dev), DS1682_REG_USER_DATA, &val, 10))
> +		return -EIO;
> +
> +	for (i = 0; i < 10; i++)
> +		end += sprintf(end, "%.2x ", val[i]);

I'd suggest a define instead of the hard-coded "10".

> +
> +	*(end - 1) = '\n';	/* Eliminate trailing space */
> +	return end - buf;
> +}

The other drivers export the EEPROM data as a binary file, please do
the same for consistency. See the max6875 driver for an example. This
will also save you the parsing code below.

> +
> +static ssize_t ds1682_user_data_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	u8 data[10];
> +	char *endp;
> +	int bytecount = 0;
> +
> +	/* Check input for sanity */
> +	if ((count >= 80) || (buf[count] != '\0')) {
> +		dev_dbg(dev, "insane input; count=%i%s\n",
> +			count, buf[count] == '\0' ? " unterminated" : "");
> +		return -EIO;
> +	}
> +
> +	/* Parse the data */
> +	while (bytecount < 10) {
> +		while (isspace(*buf))
> +			buf++;
> +
> +		data[bytecount] = simple_strtoul(buf, &endp, 16);
> +		if (endp == buf)	/* make sure it's a real data value */
> +			break;
> +
> +		buf = endp;
> +		bytecount++;
> +	}
> +	while (isspace(*endp))
> +		endp++;
> +
> +	/* Abort on invalid data */
> +	if ((bytecount == 0) || (*endp != '\0')) {
> +		dev_dbg(dev, "invalid input *buf=\"%s\" *endp=\"%s\"\n",
> +			buf, endp);
> +		return -EIO;
> +	}
> +
> +	/* Write out to the device */
> +	if (i2c_smbus_write_i2c_block_data(to_i2c_client(dev),
> +					   DS1682_REG_USER_DATA, bytecount,
> +					   data) < 0)
> +		return -EIO;
> +	return count;
> +}
> +
> +DEVICE_ATTR(user_data, S_IRUGO | S_IWUSR, ds1682_user_data_show,
> +	    ds1682_user_data_store);
> +
> +/*
> + * Called when a device is found at the ds1682 address
> + */
> +static struct i2c_driver ds1682_driver;
> +static int ds1682_detect(struct i2c_adapter *adapter, int address, int kind)
> +{
> +	struct i2c_client *new_client;

Please rename this to just "client". This "new_client" name is a
disease :(

> +	int err = 0;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> +				     I2C_FUNC_I2C))

This check doesn't match the functions you are using in the driver. You
are using i2c_smbus_read_byte_data() and
i2c_smbus_write_i2c_block_data(), so you should check for
I2C_FUNC_SMBUS_READ_BYTE_DATA | I2C_FUNC_SMBUS_WRITE_I2C_BLOCK.

> +		goto exit;
> +
> +	if (!(new_client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL))) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	new_client->addr = address;
> +	new_client->adapter = adapter;
> +	new_client->driver = &ds1682_driver;
> +	new_client->flags = 0;

Not needed, the kzalloc above did it for you.

> +
> +	/* Note: Ignoring 'kind' value as the ds1682 uses a fixed address */

The "kind" value has nothing to do with the address. It tells you if
the user asked (through a module parameter) for the device
detection/identification to be skipped. Which brings me to the point
that your driver does no device identification at all. Fortunately,
address 0x6b isn't very popular, but I would still like to see some
detection code. Is there a way to identify the DS1682? I know that such
devices usually (unfortunately) don't have an identification register,
but maybe there are unused configuration bits which can be checked? Or
you can check the number of registers?

Alternatively, what system are you targeting with this driver? We just
merged David Brownell's new I2C infrastructure which lets I2C devices
be declared as platform data. This is particularly suitable for
embedded architectures.

> +
> +	/* We can fill in the remaining client fields */
> +	strlcpy(new_client->name, "ds1682", I2C_NAME_SIZE);
> +
> +	/* Tell the I2C layer a new client has arrived */
> +	if ((err = i2c_attach_client(new_client)))
> +		goto exit_free;
> +
> +	if (device_create_file(&new_client->dev, &dev_attr_config))
> +		goto exit_attr_config;
> +	if (device_create_file(&new_client->dev, &dev_attr_elapsed_time))
> +		goto exit_attr_elapsed;
> +	if (device_create_file(&new_client->dev, &dev_attr_alarm_time))
> +		goto exit_attr_alarm;
> +	if (device_create_file(&new_client->dev, &dev_attr_event_count))
> +		goto exit_attr_event;
> +	if (device_create_file(&new_client->dev, &dev_attr_user_data))
> +		goto exit_attr_userdata;

Please use a file group and sysfs_create_group(), it'll make the code
much cleaner.

> +
> +	return 0;
> +
> +      exit_attr_userdata:

Please use a single space for label indentation.

> +	device_remove_file(&new_client->dev, &dev_attr_event_count);
> +      exit_attr_event:
> +	device_remove_file(&new_client->dev, &dev_attr_alarm_time);
> +      exit_attr_alarm:
> +	device_remove_file(&new_client->dev, &dev_attr_elapsed_time);
> +      exit_attr_elapsed:
> +	device_remove_file(&new_client->dev, &dev_attr_config);
> +      exit_attr_config:
> +	i2c_detach_client(new_client);
> +      exit_free:
> +	kfree(new_client);
> +      exit:
> +	return err;
> +}
> +
> +static int ds1682_attach_adapter(struct i2c_adapter *adapter)
> +{
> +	return i2c_probe(adapter, &addr_data, ds1682_detect);
> +}
> +
> +static int ds1682_detach_client(struct i2c_client *client)
> +{
> +	int err;
> +	device_remove_file(&client->dev, &dev_attr_user_data);
> +	device_remove_file(&client->dev, &dev_attr_event_count);
> +	device_remove_file(&client->dev, &dev_attr_alarm_time);
> +	device_remove_file(&client->dev, &dev_attr_elapsed_time);
> +	device_remove_file(&client->dev, &dev_attr_config);
> +
> +	if ((err = i2c_detach_client(client)))
> +		return err;
> +
> +	kfree(client);
> +	return 0;
> +}
> +
> +static struct i2c_driver ds1682_driver = {
> +	.driver = {
> +		   .name = "ds1682",
> +		   },

Indentation.

> +	.attach_adapter = ds1682_attach_adapter,
> +	.detach_client = ds1682_detach_client,
> +};
> +
> +static int __init ds1682_init(void)
> +{
> +	return i2c_add_driver(&ds1682_driver);
> +}
> +
> +static void __exit ds1682_exit(void)
> +{
> +	i2c_del_driver(&ds1682_driver);
> +}
> +
> +MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
> +MODULE_DESCRIPTION("DS1682 Elapsed Time Indicator driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(ds1682_init);
> +module_exit(ds1682_exit);

The code is quite nice otherwise, good work!

-- 
Jean Delvare
