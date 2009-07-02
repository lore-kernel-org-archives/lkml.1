Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZGBRjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZGBRjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZGBRjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:39:01 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:49007 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZGBRjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:39:00 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A4CF07B.3090600@cam.ac.uk>
Date: Thu, 02 Jul 2009 17:38:03 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Chris Verges <chrisv@cyberswitching.com>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, vapier@gentoo.org,
       michael.hennerich@analog.com
Subject: Re: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

One interesting thing I just came across whilst searching lkml for
your post to reply to, was that Mike Frysinger submited a patch
adding some board support for an adx34x driver to bf548-ezkit.
I've not seen any sign of this anywhere else as yet (it hasn't
hit the input list which would be the obvious place) I've copied in
both people who signed off.  Michael or Mike able to give us more info?

Anyhow over to a review.

I'll (more or less) ignore anything related to use of hwmon etc and
concentrate on the bits that will be there whatever.

> 
> 
> --- PATCH BELOW ---
> 
> Signed-off-by: Chris Verges <chrisv@cyberswitching.com>
> Index: drivers/hwmon/Makefile
> ===================================================================
> --- linux-2.6.29.3-orig/drivers/hwmon/Makefile	(revision 33)
> +++ linux-2.6.29.3/drivers/hwmon/Makefile	(revision 49)
> @@ -29,6 +29,7 @@
>  obj-$(CONFIG_SENSORS_ADT7470)	+= adt7470.o
>  obj-$(CONFIG_SENSORS_ADT7473)	+= adt7473.o
>  obj-$(CONFIG_SENSORS_ADT7475)	+= adt7475.o
> +obj-$(CONFIG_SENSORS_ADXL345)	+= adxl345.o
>  
>  obj-$(CONFIG_SENSORS_APPLESMC)	+= applesmc.o
>  obj-$(CONFIG_SENSORS_AMS)	+= ams/
> Index: drivers/hwmon/Kconfig
> ===================================================================
> --- linux-2.6.29.3-orig/drivers/hwmon/Kconfig	(revision 33)
> +++ linux-2.6.29.3/drivers/hwmon/Kconfig	(revision 49)
> @@ -199,6 +199,16 @@
>  	  This driver can also be build as a module.  If so, the module
>  	  will be called adt7475.
>  
> +config SENSORS_ADXL345
> +	tristate "Analog Devices ADXL345"
> +	depends on I2C && EXPERIMENTAL
> +	help
> +	  If you say yes here, you get support for the Analog Devices
> +	  ADXL345 digital accelerometer chip.
> +
> +	  This driver can also be build as a module.  If so, the module
> +	  will be called adxl345.
> +

First question is whether it's worth adding support for the very
similar adxl346 at this stage, or leave it for a future occasion? As
far as I can immediately see the only difference is that the adxl346
has a couple more registers to do with orientation detection (complete
with deadzones etc) Annoyingly the two chips have the same id so
you can't tell them appart which is rather annoying!

>  config SENSORS_K8TEMP
>  	tristate "AMD Athlon64/FX or Opteron temperature sensor"
>  	depends on X86 && PCI && EXPERIMENTAL
> Index: drivers/hwmon/adxl345.c
> ===================================================================
> --- linux-2.6.29.3-orig/drivers/hwmon/adxl345.c	(revision 0)
> +++ linux-2.6.29.3/drivers/hwmon/adxl345.c	(revision 49)
> @@ -0,0 +1,521 @@
> +/*
> + * A hwmon driver for the Analog Devices ADXL345
> + *
> + * Copyright (c) 2009 Cyber Switching, Inc.
> + * Author: Robert Mehranfar <robertme@earthlink.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/jiffies.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/hwmon-vid.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/kernel.h>
> +
> +#define DRV_NAME	"adxl345"
> +#define DRV_VERSION	"0.1"
> +
> +#define SIMULATE 1
> +
> +/*
> + * The ADXL345 registers
> + */
> +#define ADXL345_REG_DEV_ID		0x00
> +#define ADXL345_REG_OFS(nr)		(0x1E + (nr))
> +#define ADXL345_REG_DATA(nr)		(0x32 + (nr))
> +#define ADXL345_REG_DATA_FORMAT		0x31
> +
> +/*
> + * See ADXL345 specification

This could do with some explanation, combine to make 15.6 milli g?

> +#define OFFSET_SCALE_FACTOR_WHOLE 15
> +#define OFFSET_SCALE_FACTOR_FRACTIONAL 6

8 bit register, 15.6mg giving (I think)
127*15.6 or 1981.2 and -128*15.6 = -1996.8 
> +#define MAX_OFFSET 1988
> +#define MIN_OFFSET -1998
> +
> +/*
> + * Based on 10-bit resolution +/-16 range set in the DATA FORMAT
> register
> + */
Where did these come from? If you are in 16g mode at 10 bit
2's complement, your range is -512 to 511 giving 31.25

> +#define DATA_SCALE_FACTOR_WHOLE 15
> +#define DATA_SCALE_FACTOR_FRACTIONAL 6
> +#define NUMBER_OF_AXES 3
> +
> +#define X_AXIS 0
> +#define Y_AXIS 1
> +#define Z_AXIS 2
> +
> +/* Position in the sysfs attribute array */
> +#define X_AXIS_ATTR 0
> +#define Y_AXIS_ATTR 1
> +#define Z_AXIS_ATTR 2
> +#define DATA_ATTR 3
> +
> +/*
> + * Functions declaration
> + */
Unnecessary as it's defined before use anyway.
> +static void adxl345_init_client(struct i2c_client *client);
> +static struct adxl345_data *adxl345_update_device(struct device *dev);
Same with this one.
> +static void convert_to_fraction(s16 data, u8 whole_scale, u8
> fraction_scale,
> +					int *decimal, int *fraction);
> +
> +/*
> + * Client data (each client gets its own)
> + */
> +struct adxl345_data {
> +	struct i2c_client	client;
> +	struct device		*hwmon_dev;
> +	struct mutex		update_lock;	/* lock on the structure
> */
> +	char			valid;		/* 0 until below are
> valid */
Doesn't generally make sense to cache accelerometer values but then this
is a legacy of you using hwmon.
> +	unsigned long		last_updated;	/* in jiffies */
> +
> +	/*
> +	 * ADXL345 Data
> +	 * In two's complement, data coming in from or going out to
> user-space
> +	 * must be converted.
> +	 */
> +	u8			offset[NUMBER_OF_AXES];
> +	u16			data[NUMBER_OF_AXES];
> +};
> +
Personally I'm a little dubious about having this sort of conversion
function in kernel.  I'm rather more of the view that its a job for
userspace.  At very least, pick some units that avoid the need to deal
with the decimal element.

 To consider what this is doing - the data going in is...
First things first give the device is giving you 2's comp sign
extended data, why not just make the data field a s16?
> +		temp_data = ~(data->data[i] - 1);

So I'm going to take two possible values of data[i], -10 and +10 (decimal)

With -10  your conversion gives me 10 (so looses the sign);
With 10 this line converts to (in binary 1111111111110110) or 65526?
Oh actually it's signed so you've neatly converted it to -10, not sure
how this helps.

Testing this with full range value 2^9 = 512
> +/*
> + * Converts internal data to a decimal-fraction value.
> + * Notes: Must already be converted out of twos complement
> + *
> + * @param data  Data to be converted
> + * @param whole_scale Scale factor for whole number part. (Set to 1 for
> no scaling).
> + * @param fraction_scale Scale factor for fractional number part. (Set
> to 1 for no scaling).
> + * @param decimal Pointer to location to store decimal part.
> + * @param fraction Pointer to location to store fractional part.
> + */
> +static void convert_to_fraction(s16 data, u8 whole_scale, u8
> fraction_scale,
> +					int *decimal, int *fraction)
> +{
> +	int temp_decimal, temp_fraction, temp;
> +	int sign = 1;
> +
> +	/* Scale the decimal and fractional parts */
	  Corresponds to mulitpying by 1500 so 768000
> +	temp_decimal = data * whole_scale * 10;
Corresponds to multiplying by 6 so 312
> +	temp_fraction = data * fraction_scale;
> +
> +	/* get rid of the sign for negative fractions */
> +	if (temp_fraction < 0) {
> +		sign = -1;
> +		temp_fraction *= sign;
> +	}
> +
> +	/* If necessary, carry */
> +	if (temp_fraction >= 10) {
	true as 312 > 10
> +		/* Add to the decimal part */
> +		temp_decimal += sign * temp_fraction;
temp decimal is now 77112
> +
> +		/* Amount to be subtracted from the fractional part */
> +		temp = temp_fraction / 10;
	temp = 31 (rounded)
> +
> +		temp_fraction -= temp * 10;
281
> +	}
> +
> +	temp_decimal /= 10;
7711
> +
> +	/*
> +	 * If at least 10 still remains in the fractional part, one
> +	 * last carry
> +	 */
> +	if (temp_fraction >= 10) {
	true as it's 281
> +		temp_decimal += sign;
ok, 7712
> +		temp_fraction -= 10;
tempfraction = 271
> +	}
> +
> +	/* Pass the values up */
> +	*decimal = temp_decimal;
> +	*fraction = temp_fraction;
> +}
So at the end of this by 2^9 (which should be something related to 16 g)
will print 7712.271 which is probably not what you meant.
> +
> +/*
> + * Called in response to cat ofs(x,y,z) in sysfs
> + *
> + * @param dev Pointer to device
> + * @param attr Pointer to the device attributes
> + * @param buf Pointer to string shown in user space
> + * @return Number of chars copied to buffer
> +*/
Definitely doesn't make sense to query offsets with every
'update' they don't change after all.  Make it separate
read on demand.

> +static ssize_t show_offset(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	int index = to_sensor_dev_attr(attr)->index;
> +	struct adxl345_data *data = adxl345_update_device(dev);
> +	int decimal, fraction;
> +	s8 temp_data;
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	/* Convert from 2's complement */
Here we go again.  What do you have against 2's complement?
It's the standard way of storing signed values.

> +	temp_data = ~(data->offset[index] - 1);
> +
> +	dev_dbg(dev, "temp_data=%d\n", temp_data);
> +
> +	convert_to_fraction(temp_data,
> +			OFFSET_SCALE_FACTOR_WHOLE,
> +			OFFSET_SCALE_FACTOR_FRACTIONAL,
> +			&decimal,
> +			&fraction);
> +
> +	return snprintf(buf, PAGE_SIZE,
> +			"%4d.%1d\n", decimal, fraction);
> +}
> +
> +/*
> + * Called in response to echoing data to ofs(x,y,z) in sysfs
> + * Note: Input range is -1998 to 1998 milli-g's
(more or less)
> + *
> + * @param dev Pointer to device
> + * @param attr Pointer to the device attributes
> + * @param buf Pointer to string passed in from user space
> + * @param count Number of chars passed in from user space..
> + * @return Number of chars passed in from user space.
> + */
> +static ssize_t set_offset(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf,
> +				size_t count)
> +{
> +	int index = to_sensor_dev_attr(attr)->index;
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct adxl345_data *data = i2c_get_clientdata(client);
> +	long val;
> +	long temp_val;
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	if (!strict_strtol(buf, 10, &val)) {
> +		dev_dbg(dev, "error in converting string '%s' to
> long\n",
> +				buf);
> +		return 0;
> +	}
> +
> +	/* If outside offset range, clip to max or min value */
> +	if (val < MIN_OFFSET)
> +		val = MIN_OFFSET;
> +	else if (val > MAX_OFFSET)
> +		val = MAX_OFFSET;
> +
> +	temp_val = (val * 100) %
> +			((OFFSET_SCALE_FACTOR_WHOLE * 100) +
> +			(OFFSET_SCALE_FACTOR_FRACTIONAL * 10));
so take max 19800 % 1560 = 1080
> +	if (temp_val < 0)
> +		temp_val *= -1;
> +
> +	/* Get rid of scale for internal storage */
This just equals the temp val above (without sign remova)?
> +	val = (val * 100) /
> +			((OFFSET_SCALE_FACTOR_WHOLE * 100) +
> +			(OFFSET_SCALE_FACTOR_FRACTIONAL * 10));
> +
> +	if (temp_val > (OFFSET_SCALE_FACTOR_WHOLE * 100) / 2 && val > 0)
> +		++val;
> +	else if (temp_val > (OFFSET_SCALE_FACTOR_WHOLE * 100) / 2 && val
> < 0)
> +		--val;
> +
> +	val = ~val + 1;  /* convert to two's complement */
That's merely flipping the sign in 2's complement.

> +
> +	mutex_lock(&data->update_lock);
> +
> +	data->offset[index] = val;
> +
> +	dev_dbg(dev, "offset[%d]=%d\n", index, data->offset[index]);

I'd prefer to see these functions encapsulated in a 'adxl345_write'
function to make adding spi support at a later date simpler.
However, fine to leave as is for now as it makes driver simpler.

> +	/* Write the avlue to the chip via I2C */
> +	i2c_smbus_write_byte_data(client,
> +			ADXL345_REG_OFS(index),
> +			data->offset[index]);
> +
> +	mutex_unlock(&data->update_lock);
> +
> +	return count;
> +}
> +
> +/*
> + * Called in response to cat data in sysfs
> + *
> + * @param dev Pointer to device
> + * @param attr Pointer to the device attributes
> + * @param buf Pointer to string shown in user space
> + * @return Number of chars copied to buffer
> +*/
> +static ssize_t show_data(struct device *dev, struct device_attribute
> *attr,
> +				char *buf)
> +{
> +	int i;
> +	s16 temp_data;
> +	int decimal[NUMBER_OF_AXES], fraction[NUMBER_OF_AXES];
> +
> +	struct adxl345_data *data = adxl345_update_device(dev);
> +
> +	/* Convert x,y,z values */
> +	for (i = 0; i < NUMBER_OF_AXES; i++) {
Don't follow this at all.
> +		/* Convert from 2's complement */
> +		temp_data = ~(data->data[i] - 1);
> +
> +		convert_to_fraction(temp_data,
> +				DATA_SCALE_FACTOR_WHOLE,
> +				DATA_SCALE_FACTOR_FRACTIONAL,
> +				&decimal[i],
> +				&fraction[i]);
> +	}
> +
> +	return snprintf(buf, PAGE_SIZE,
> +			"x:%5d.%1d y:%5d.%1d z:%5d.%1d\n",
> +			decimal[X_AXIS], fraction[X_AXIS],
> +			decimal[Y_AXIS], fraction[Y_AXIS],
> +			decimal[Z_AXIS], fraction[Z_AXIS]);
> +}
I'd go for names that hint a little more at what these are,
perhaps accel_x_offset etc...
> +/*  Attributes of the sysfs entries */
> +static SENSOR_DEVICE_ATTR(ofsx, S_IWUSR | S_IRUGO,
> +				show_offset, set_offset, X_AXIS_ATTR);
> +static SENSOR_DEVICE_ATTR(ofsy, S_IWUSR | S_IRUGO,
> +				show_offset, set_offset, Y_AXIS_ATTR);
> +static SENSOR_DEVICE_ATTR(ofsz, S_IWUSR | S_IRUGO,
> +				show_offset, set_offset, Z_AXIS_ATTR);
> +static SENSOR_DEVICE_ATTR(data, S_IRUGO,
> +				show_data, NULL, DATA_ATTR);
> +
> +static struct attribute *adxl345_attributes[] = {
> +	&sensor_dev_attr_ofsx.dev_attr.attr,
> +	&sensor_dev_attr_ofsy.dev_attr.attr,
> +	&sensor_dev_attr_ofsz.dev_attr.attr,
> +	&sensor_dev_attr_data.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group adxl345_group = {
> +	.attrs = adxl345_attributes,
> +};
> +
> +/*
> + * Initialize the chip
> + *
> + * @param client Pointer to the client structure
> + */
> +static void adxl345_init_client(struct i2c_client *client)
> +{
> +	dev_dbg(&client->dev, "%s\n", __func__);
> +
> +	/*
> +	 * Set up the device, No self test, Dont care about SPI or
> +	 * interrupt, 10 bit resoltion, +/- 16g range
> +	 */
My reading of the data sheet says that to power up the device you
will also need to set the measure bit of 0x2D (power ctl).
If not it'll be in low power mode and you aren't going to be able
to read any values.

> +	i2c_smbus_write_byte_data(client, ADXL345_REG_DATA_FORMAT,
> 0x03);
> +}
> +
> +/*
> + * Does more than just detection. If detection succeeds, it also
> + * registers the new chip.
> + *
> + * @param adapter Pointer to the adapter
> + * @param address I2C address
> + * @return Zero, upon success
> + */
> +static int adxl345_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	struct adxl345_data *data;
> +	int err = 0;
> +	u8 dev_id;
> +
> +	dev_dbg(&client->dev, "%s\n", __func__);
> +
> +	if (!i2c_check_functionality(client->adapter,
> I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;

I'd favour using sizeof(*data) but only symantic sugar ;)
> +	data = kzalloc(sizeof(struct adxl345_data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, data);
Obviously this is useful for testing purposes, but do remember
to remove this from later submissions.

> +	#ifdef SIMULATE
> +	dev_id = 0xE5; /* Spoof the Analog Devices device ID */
> +	dev_dbg(&client->dev, "Simulating ADXL345 device\n");
> +	#else
> +	dev_id = i2c_smbus_read_byte_data(client, ADXL345_REG_DEV_ID);
> +	#endif
I think read byte data can also return an error (negative) so
check this first and return that rather than -EINVAL if it
does.  Also this is a failure to find a device, so I would
expect the right error code to be -ENODEV. Others may correct
me on that as I'm forever using the wrong ones.

> +	/* If the chip is not from Analog Devices, report an error */
> +	if (dev_id != 0xE5) {
> +		dev_err(&client->dev, "Unsupported chip
> (dev_id=0x%02X)\n",
> +				dev_id);
> +		err = -EINVAL;
> +		goto err_free_mem;
> +	}
> +
> +	dev_info(&client->dev, "chip found, driver version "
> +			DRV_VERSION "\n");
> +
> +	/* We can fill in the remaining client fields */
> +	mutex_init(&data->update_lock);
> +
> +	/* Initialize the ADXL345 chip */
> +	adxl345_init_client(client);
> +
> +	/* Register sysfs hooks */
> +	err = sysfs_create_group(&client->dev.kobj, &adxl345_group);
> +	if (err)
> +		goto err_free_mem;
> +
> +	data->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(data->hwmon_dev)) {
> +		err = PTR_ERR(data->hwmon_dev);
> +		goto err_remove;
> +	}
> +
> +	return 0;
> +
> +err_remove:
> +	sysfs_remove_group(&client->dev.kobj, &adxl345_group);
> +err_free_mem:
> +	kfree(data);
> +
> +	return err;
> +}
> +
> +/*
> + * Unregister device, remove the sysfs entries, and detach the client
> + * from I2C bus.
> + *
> + * @param client Pointer to the client structure
> + * @return Zero, upon success.
> + */
> +static int adxl345_remove(struct i2c_client *client)
> +{
> +	struct adxl345_data *data = i2c_get_clientdata(client);
> +
> +	hwmon_device_unregister(data->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &adxl345_group);
> +
> +	i2c_unregister_device(client);
> +
> +	kfree(data);
> +
> +	return 0;
> +}
> +
> +/*
> + * Gets the data from the chip.
> + *
> + * @param client Pointer to the device
> + * @return Pointer to structure containing the data
> + */
> +static struct adxl345_data *adxl345_update_device(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct adxl345_data *data = i2c_get_clientdata(client);
> +	int i;
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	mutex_lock(&data->update_lock);

This is a bit setup specific. Given it's going to be gone in a non
hwmon driver anyway I won't suggest how else to do it.
> +	/*
> +	 * This delay is 500ms, based on a default value of 100 for HZ
> +	 * in ARM kernels
> +	 */
> +	if (time_after(jiffies, data->last_updated + HZ * 50) ||
> +		!data->valid) {
> +		for (i = 0; i < NUMBER_OF_AXES; i++) {
Offset is (I think) only controlled by the user, so definitely shouldn't be
read each time.
> +			data->offset[i] = i2c_smbus_read_byte_data(client,
> +						ADXL345_REG_OFS(i))
Is there any reason not to do a multibyte read?
I guess it requires your i2c adapter to support
i2c_smbus_write_i2c_block_data()


> +			dev_dbg(dev, "offset[%d]=%d\n", i,
> data->offset[i]);
> +		}
> +
> +		/*
> +		 * Concatenate the data from each register pair
> +		 * Indexing logic is needed as per ADXL345 spec, LSB is
> first
> +		 * INDEX(reg)  LSB  MSB
> +		 *     0        0    1
> +		 *     1        2    3
> +		 *     2        4    5
> +		 */
> +		for (i = 0; i < NUMBER_OF_AXES; i++) {
> +			/* Get the MSB, shift by 8, and then get the LSB
> */
> +			data->data[i] = i2c_smbus_read_byte_data(client,
> +						ADXL345_REG_DATA(i*2+1))
> << 8;
> +			data->data[i] |=
> i2c_smbus_read_byte_data(client,
> +						ADXL345_REG_DATA(i*2));

Here you could use a word read, or the multi register read described
above.  If fact the word read at the very least is needed to ensure
you get a consistent set of high and low bytes for a given
axis. (otherwise very odd things may occur around 0.

There is a reference on page 8 of the data sheet that says:

After the register addressing and the first byte of data, each
subsequent set of clock pulses (eight clock pulses) causes the ADXL345
to point to the next register for a read or write. This shifting
continues until the clock pulses cease and Figure 5Figure 7CS is
deasserted. This is in the spi section, but my guess is that
it will also do this for i2c? It certainly shows a diagram implying
word reading is fine over i2c.

> +
> +			dev_dbg(dev, "data[%d]=%d\n", i, data->data[i]);
> +		}
> +
> +		data->last_updated = jiffies;
> +		data->valid = 1;
> +	}
> +
> +	mutex_unlock(&data->update_lock);
> +
> +	return data;
> +}
> +
> +/*
> + * Driver data (common to all clients)
> + */
> +
> +static const struct i2c_device_id adxl345_id[] = {
> +	{ "adxl345", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, adxl345_id);
> +
> +static struct i2c_driver adxl345_driver = {
> +	.driver = {
> +		.name	= DRV_NAME,
> +	},
> +	.probe		= adxl345_probe,
> +	.remove		= adxl345_remove,
> +	.id_table	= adxl345_id,
> +};
> +
> +/*
> + * Initialize the module
> + *
> + * @return Zero, upon success
> + */
> +static int __init adxl345_init(void)
> +{
> +	return i2c_add_driver(&adxl345_driver);
> +}
> +
> +/*
> + * Remove the module
> + */
> +static void __exit adxl345_exit(void)
> +{
> +	i2c_del_driver(&adxl345_driver);
> +}
> +
> +MODULE_AUTHOR("Robert Mehranfar <robertme@earthlink.net>");
> +MODULE_DESCRIPTION("Analog Devices ADXL345 driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_VERSION);
> +
> +module_init(adxl345_init);
> +module_exit(adxl345_exit);

Reasonable start at a driver, though I definitely didn't follow some
of the conversion code you have in there.  I'm very much be of
the view that shouldn't be in the kernel at all. (This is
a personal preference and others think differently!)

My intention with IIO (though I haven't actually done it yet) is
to work out the minimum set of parameters that need to be passed
out via sysfs to allow conversion of whatever is directly
read to sensible units.  In this case you'd merely export
the conversion factor under some suitably informative name.
Floating point support in userspace then makes life nice and
easy!

Anyhow always good to see more accelerometer drivers!

Thanks

Jonathan
