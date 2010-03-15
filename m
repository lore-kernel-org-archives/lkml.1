Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936224Ab0COMw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:52:26 -0400
Received: from bamako.nerim.net ([62.4.17.28]:62195 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936155Ab0COMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:52:23 -0400
Date: Mon, 15 Mar 2010 13:52:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Steven King <sfking00@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: driver for TI tmp102 temperature sensor
Message-ID: <20100315135217.550a6aba@hyperion.delvare>
In-Reply-To: <201003132000.35840.sfking00@yahoo.com>
References: <201003132000.35840.sfking00@yahoo.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Sat, 13 Mar 2010 20:00:35 -0800, Steven King wrote:
> Driver for the TI TMP102.
> 
> Signed-off-by: Steven King <sfking@fdwdc.com>
> ---
> 
> The TI TMP102 is similar to the lm75.  It differs from the lm75 by having a 16
> bit conf register and the temp registers have a minimum resolution of 12bits;
> the extended conf register can select 13 bit resolution (which this driver
> does) and also change the update rate (which this driver currently doesn't
> use).
> 
> V2: removed broken and unneeded detection routine,
>     made temperature conversion use base 1000 instead of base 100.
>     (per Jean Delvare's feed back)
>     incorporated fixes for the loop and made dev_pm_ops const.
>     (per Andrew Morton's patch)
> 
>  Documentation/hwmon/tmp102 |   27 ++++
>  drivers/hwmon/Kconfig      |   10 ++
>  drivers/hwmon/Makefile     |    1 +
>  drivers/hwmon/tmp102.c     |  296 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 334 insertions(+), 0 deletions(-)

Here's my review. Feel free to pick whatever you like in it and ignore
the rest. Then submit a final version for upstream integration.

> 
> diff --git a/Documentation/hwmon/tmp102 b/Documentation/hwmon/tmp102
> new file mode 100644
> index 0000000..239dded
> --- /dev/null
> +++ b/Documentation/hwmon/tmp102
> @@ -0,0 +1,27 @@
> +Kernel driver tmp102
> +====================
> +
> +Supported chips:
> +  * Texas Instruments TMP102
> +    Prefix: 'tmp102'
> +    Addresses scanned: I2C 0x48 0x49 0x4a 0x4b

This is no longer true, since you removed the detect() function.

> +    Datasheet: http://focus.ti.com/docs/prod/folders/print/tmp102.html
> +
> +Author:
> +	Steven King <sfking@fdwdc.com>
> +
> +Description
> +-----------
> +
> +The Texas Instruments TMP102 implements one temperature sensor.  Limits can be
> +set through the Overtemperature Shutdown register and Hysteresis register.  The
> +sensor is accurate to 0.5 degrees over the range of -25 to +85 C, and to 1.0

s/degrees/degree/

> +degrees from -40 to +125 C. Resolution of the sensor is 0.0625 degree.  The

Ditto.

> +operating temperature has a minimum of -55 C and a maximum of +150 C.
> +
> +The TMP102 has a programmable update rate that can select between 8, 4, 1, and
> +0.5 Hz. (Currently the driver only supports the default of 4 Hz).
> +
> +The driver provides the common sysfs-interface for temperatures (see
> +/Documentation/hwmon/sysfs-interface under Temperatures).

No leading / for this path.

> +

Trailing blank line.

> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 68cf877..cf9d7d3 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -812,6 +812,16 @@ config SENSORS_THMC50
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called thmc50.
>  
> +config SENSORS_TMP102
> +	tristate "Texas Instruments TMP102 and compatibles"

Do you actually know of any compatible chip? If not, the "and
compatible" should be removed.

> +	depends on I2C && EXPERIMENTAL
> +	help
> +	  If you say yes here you get support for Texas Instruments TMP102
> +	  sensor chips.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called tmp102.
> +
>  config SENSORS_TMP401
>  	tristate "Texas Instruments TMP401 and compatibles"
>  	depends on I2C && EXPERIMENTAL
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 4bc215c..0e5cf73 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -88,6 +88,7 @@ obj-$(CONFIG_SENSORS_SMSC47M1)	+= smsc47m1.o
>  obj-$(CONFIG_SENSORS_SMSC47M192)+= smsc47m192.o
>  obj-$(CONFIG_SENSORS_AMC6821)	+= amc6821.o
>  obj-$(CONFIG_SENSORS_THMC50)	+= thmc50.o
> +obj-$(CONFIG_SENSORS_TMP102)	+= tmp102.o
>  obj-$(CONFIG_SENSORS_TMP401)	+= tmp401.o
>  obj-$(CONFIG_SENSORS_TMP421)	+= tmp421.o
>  obj-$(CONFIG_SENSORS_VIA_CPUTEMP)+= via-cputemp.o
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> new file mode 100644
> index 0000000..e4816f6
> --- /dev/null
> +++ b/drivers/hwmon/tmp102.c
> @@ -0,0 +1,296 @@
> +/* Texas Instruments TMP102 SMBUS temperature sensor driver

"SMBus" please.

> + *
> + * Copyright 2010 Steven King <sfking@fdwdc.com>

Normally there is a (C) between Copyright and the year.

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
> + * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA
> + */
> +
> +
> +

One less blank line would be welcome.

> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>

I can't see where you need <linux/delay.h>. Including <linux/device.h>,
OTOH, is needed.

> +
> +#define	DRIVER_NAME "tmp102"
> +
> +#define	TMP102_TEMP_REG			0x00
> +#define	TMP102_CONF_REG			0x01
> +/* note: these bit definitions are byte swapped */
> +#define		TMP102_CONF_SD		0x0100
> +#define		TMP102_CONF_TM		0x0200
> +#define		TMP102_CONF_POL		0x0400
> +#define		TMP102_CONF_F0		0x0800
> +#define		TMP102_CONF_F1		0x1000
> +#define		TMP102_CONF_R0		0x2000
> +#define		TMP102_CONF_R1		0x4000
> +#define		TMP102_CONF_OS		0x8000
> +#define		TMP102_CONF_EM		0x0010
> +#define		TMP102_CONF_AL		0x0020
> +#define		TMP102_CONF_CR0		0x0040
> +#define		TMP102_CONF_CR1		0x0080
> +#define	TMP102_TLOW_REG			0x02
> +#define	TMP102_THIGH_REG		0x03

My personal preference would go to TMP102_REG_* over TMP102_*_REG, but
up to you...

> +
> +struct tmp102 {
> +	struct device *hwmon_dev;
> +	struct mutex lock;
> +	unsigned long last_update;
> +	int temp[3];
> +};
> +
> +/* the TMP102 registers are big endian so we have to swab16 the values */

This has nothing to do with the endianess of the registers. This has to
do with the fact that the SMBus specification states that words are
send LSB first while all chips actually send MSB first because it makes
more sense that way.

> +static int tmp102_read_reg(struct i2c_client *client, u8 reg)
> +{
> +	int result = i2c_smbus_read_word_data(client, reg);
> +	return result < 0 ? result : swab16(result);
> +}
> +
> +static int tmp102_write_reg(struct i2c_client *client, u8 reg, u16 val)
> +{
> +	return i2c_smbus_write_word_data(client, reg, swab16(val));
> +}
> +
> +/* convert left adjusted 13bit TMP102 register value to miliCelsius */

s/mili/milli/

> +static int tmp102_reg_to_mC(s16 val)
> +{
> +	return (val * 1000) / 128;

In 13-bit mode, the LSb is 1, not 0, you must filter it out, otherwise
the temperature reported is (very slightly) off.

> +}
> +
> +/* convert miliCelsius to left adjusted 13bit TMP102 register value */

Ditto.

> +static u16 tmp102_mC_to_reg(int val)
> +{
> +	return (val * 128) / 1000;
> +}

It might make sense to inline (some of) the 4 functions above.

> +
> +static const u8 tmp102_reg[] = {
> +	TMP102_TEMP_REG,
> +	TMP102_TLOW_REG,
> +	TMP102_THIGH_REG,
> +};
> +
> +static struct tmp102 *tmp102_update_device(struct i2c_client *client)
> +{
> +	struct tmp102 *tmp102 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&tmp102->lock);
> +	if (time_after(jiffies, tmp102->last_update + HZ / 4)) {

Did you check if continuously reading the sysfs files would let the
values be updated? Some chips stop monitoring when accessed over SMBus,
so we tend to define the cache lifetime somewhat larger than the
sampling rate, to make sure sampling has the time to complete between
accesses. You could use HZ / 3 to be on the safe side.

> +		int i;
> +		for (i = 0; i < ARRAY_SIZE(tmp102->temp); ++i) {
> +			int status = tmp102_read_reg(client, tmp102_reg[i]);
> +			if (status > -1)
> +				tmp102->temp[i] = tmp102_reg_to_mC(status);

hwmon drivers traditionally store raw register values in the cache, and
only convert on sysfs attribute access. The rationale is that someone
only reading one value (temp1_input in your case) doesn't have to spend
CPU time converting all values. This also allows for smaller caches.

> +		}
> +		tmp102->last_update = jiffies;
> +	}
> +	mutex_unlock(&tmp102->lock);
> +	return tmp102;
> +}
> +
> +static ssize_t tmp102_show_temp(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct tmp102 *tmp102 = tmp102_update_device(to_i2c_client(dev));
> +
> +	return sprintf(buf, "%d\n", tmp102->temp[sda->index]);
> +}
> +
> +static ssize_t tmp102_set_temp(struct device *dev,
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct tmp102 *tmp102 = i2c_get_clientdata(client);
> +	long val;
> +	int status = 0;
> +
> +	if ((strict_strtol(buf, 10, &val) < 0) || (abs(val) > 150000))

Limiting to -150 to +150 degrees C is a little arbitrary, I can't see
the rationale. Also note that other hwmon drivers tend to clamp values
that are out the device's capabilities, rather than rejecting them.

> +		return -EINVAL;
> +	mutex_lock(&tmp102->lock);
> +	if (tmp102->temp[sda->index] != val) {

Don't try to be smart. If you are asked to write a value, write it. It
happens infrequently enough that optimizing it makes little sense. And
the cached value you are comparing with may be very old...

> +		tmp102->temp[sda->index] = val;
> +		status = tmp102_write_reg(client, tmp102_reg[sda->index],
> +					  tmp102_mC_to_reg(val));
> +	}
> +	mutex_unlock(&tmp102->lock);
> +	return status ? : count;
> +}
> +
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, tmp102_show_temp, NULL , 0);
> +
> +static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO, tmp102_show_temp,
> +			  tmp102_set_temp, 1);
> +
> +static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, tmp102_show_temp,
> +			  tmp102_set_temp, 2);
> +
> +static struct attribute *tmp102_attributes[] = {
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group tmp102_attr_group = {
> +	.attrs = tmp102_attributes,
> +};
> +
> +#define TMP102_CONFIG  (TMP102_CONF_TM | TMP102_CONF_EM | TMP102_CONF_CR1)

Unconditionally setting the extended mode can have a nasty side effect,
because the limit registers' format depends on the mode. So when
changing the mode, you need to reprogram the limits, but the driver
doesn't do that. I think that your driver should either keep the mode
unchanged (needs some work to support both 12- and 13-bit resolution)
or adjust the limits automatically when changing modes.

> +#define TMP102_CONFIG_RD_ONLY (TMP102_CONF_R0 | TMP102_CONF_R1 | TMP102_CONF_AL)
> +
> +static int __devinit tmp102_probe(struct i2c_client *client,
> +				  const struct i2c_device_id *id)
> +{
> +	struct tmp102 *tmp102;
> +	int status;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |

You shouldn't check for SMBus byte data support, as your driver doesn't
make use of them.

> +				     I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_dbg(&client->dev, "adapter doesnt support SMBUS\n");

The error message is horribly inaccurate and misleading. What is
missing is SMBus read/write word support.

> +		return -ENODEV;
> +	}
> +
> +	tmp102 = kzalloc(sizeof(*tmp102), GFP_KERNEL);
> +	if (!tmp102) {
> +		dev_dbg(&client->dev, "kzalloc failed\n");
> +		return -ENOMEM;
> +	}
> +	i2c_set_clientdata(client, tmp102);
> +
> +	tmp102_write_reg(client, TMP102_CONF_REG, TMP102_CONFIG);
> +	status = tmp102_read_reg(client, TMP102_CONF_REG);
> +	if (status < 0) {

You check that the read succeeded, but you didn't bother checking that
the preceding write had succeeded?

> +		dev_dbg(&client->dev, "error reading config register\n");
> +		goto fail0;
> +	}
> +	status &= ~TMP102_CONFIG_RD_ONLY;
> +	if (status != TMP102_CONFIG) {
> +		dev_dbg(&client->dev, "could not verify config settings\n");

Again, this error message is misleading...

> +		status = -EIO;

... and so is this error code. -ENODEV would be more appropriate IMHO.

> +		goto fail0;
> +	}
> +	tmp102->last_update = jiffies - HZ;
> +	mutex_init(&tmp102->lock);
> +
> +	status = sysfs_create_group(&client->dev.kobj, &tmp102_attr_group);
> +	if (status) {
> +		dev_dbg(&client->dev, "could not create sysfs files\n");
> +		goto fail0;
> +	}
> +	tmp102->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(tmp102->hwmon_dev)) {
> +		dev_dbg(&client->dev, "unable to register hwmon device\n");
> +		status = PTR_ERR(tmp102->hwmon_dev);
> +		goto fail1;
> +	}
> +
> +	dev_info(&client->dev, "initialized\n");
> +
> +	return 0;
> +fail1:
> +	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
> +fail0:
> +	i2c_set_clientdata(client, NULL);
> +	kfree(tmp102);
> +
> +	return 0;

I think you mean "return status", otherwise there was no point in
tracking this value.

> +}
> +
> +static int __devexit tmp102_remove(struct i2c_client *client)
> +{
> +	struct tmp102 *tmp102 = i2c_get_clientdata(client);
> +
> +	/* shutdown the chip */
> +	tmp102_write_reg(client, TMP102_CONF_REG, TMP102_CONF_SD);

I am not a big fan of unconditional device shutdown on driver unload.
The device might have been running already before the driver was
loaded, in which case it seems unfair to stop it. You'd rather remember
and restore the initial device state.

> +
> +	hwmon_device_unregister(tmp102->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
> +	i2c_set_clientdata(client, NULL);
> +	kfree(tmp102);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int tmp102_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +
> +	tmp102_write_reg(client, TMP102_CONF_REG, TMP102_CONF_SD);
> +
> +	return 0;
> +}
> +
> +static int tmp102_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +
> +	tmp102_write_reg(client, TMP102_CONF_REG, TMP102_CONFIG);
> +
> +	return 0;
> +}

This is wrong, sorry. You should not assume anything with regards to
the other configuration bits. Just change the one bit you are concerned
about, using a read-modify-write cycle.

> +
> +static const struct dev_pm_ops tmp102_dev_pm_ops = {
> +	.suspend	= tmp102_suspend,
> +	.resume		= tmp102_resume,
> +};
> +
> +#define TMP102_DEV_PM_OPS (&tmp102_dev_pm_ops)
> +#else
> +#define	TMP102_DEV_PM_OPS NULL
> +#endif /* CONFIG_PM */
> +
> +static const unsigned short normal_i2c[] = {
> +	0x48, 0x49, 0x4a, 0x4b, I2C_CLIENT_END
> +};
> +
> +static const struct i2c_device_id tmp102_id[] = {
> +	{ DRIVER_NAME, 0 },

No, this list contains device names, not driver names, so you want to
use "tmp102".

> +	{ }
> +};

I suggest adding:

MODULE_DEVICE_TABLE(i2c, tmp102_id);

so that the drivers can be loaded automatically when needed.

> +
> +static struct i2c_driver tmp102_driver = {
> +	.driver.name	= DRIVER_NAME,
> +	.driver.pm	= TMP102_DEV_PM_OPS,
> +	.class		= I2C_CLASS_HWMON,
> +	.probe		= tmp102_probe,
> +	.remove		= __devexit_p(tmp102_remove),
> +	.id_table	= tmp102_id,
> +	.address_list	= normal_i2c,
> +};

Note that .class and .address_list are unused in the absence
of .detect(), so you might as well remove them.

> +
> +static int __init tmp102_init(void)
> +{
> +	return i2c_add_driver(&tmp102_driver);
> +}
> +module_init(tmp102_init);
> +
> +static void __init tmp102_exit(void)
> +{
> +	i2c_del_driver(&tmp102_driver);
> +}
> +module_exit(tmp102_exit);
> +
> +
> +MODULE_AUTHOR("Steven King <sfking@fdwdc.com>");
> +MODULE_DESCRIPTION("Texas Instruments TMP102 temperature sensor driver");
> +MODULE_LICENSE("GPL");


-- 
Jean Delvare
