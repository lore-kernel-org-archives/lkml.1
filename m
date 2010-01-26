Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790Ab0AZJvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0AZJvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200Ab0AZJvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:51:50 -0500
Received: from bamako.nerim.net ([62.4.17.28]:53716 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0AZJvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:51:48 -0500
Date: Tue, 26 Jan 2010 10:51:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       giometti@linux.it
Subject: Re: [PATCH] tsl2550: Move form i2c/chips to als and update
 interfaces
Message-ID: <20100126105138.1006aaad@hyperion.delvare>
In-Reply-To: <4B23D029.9080004@cam.ac.uk>
References: <4B23D029.9080004@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Sorry for the late answer.

On Sat, 12 Dec 2009 17:17:29 +0000, Jonathan Cameron wrote:
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  V3. Against current mainline with the addition of the two als patches
>  as posted by Amit.
> 
>  Changes since V2.
> 
>  Couple of bug fixes.
> 
>  Change from using illuminance_range_max to exposure_time.  As Jean has
>  described, using the range is rather problematic as actual range is
>  dependent on the difference in infrared and visible + infrared light
>  levels. Thus setting it to a particular value far from guarantees that
>  the sensor will be able to read anywhere near the desired range.
>  exposure_time brings it's own problems.  For this particular chip there
>  are two separate ADC's and no way of separating the proportions of
>  time in which light is captured as opposed to when the ADC conversion is
>  occurring. Other suggestions for how to handle this would be most welcome.
>  At the moment, <800msecs is set to 160msecs, everything else to 800msecs
>  which is actually made up of 400msecs on each of the two channels.

Sounds reasonable.

>  Documentation has been updated appropriately.
> 
>  I've also removed the now unnecessary kconfig and makefile form i2c/chips.
>  Jean, yell if you would prefer to split that into a separate patch or do
>  it yourself.

I would prefer a separate patch, yes. Whether you do it or I do it,
doesn't really matter, as I don't expect any conflict.

> 
>  Documentation/ABI/testing/sysfs-class-als |    9 +
>  drivers/als/Kconfig                       |   14 +
>  drivers/als/Makefile                      |    2 +
>  drivers/als/tsl2550.c                     |  496 +++++++++++++++++++++++++++++
>  drivers/i2c/Kconfig                       |    1 -
>  drivers/i2c/Makefile                      |    2 +-
>  drivers/i2c/chips/Kconfig                 |   19 --
>  drivers/i2c/chips/Makefile                |   18 -
>  drivers/i2c/chips/tsl2550.c               |  473 ---------------------------
>  9 files changed, 522 insertions(+), 512 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-als b/Documentation/ABI/testing/sysfs-class-als
> index d3b33f3..732f449 100644
> --- a/Documentation/ABI/testing/sysfs-class-als
> +++ b/Documentation/ABI/testing/sysfs-class-als
> @@ -7,3 +7,12 @@ Description:	Current Ambient Light Illuminance reported by
>  		Unit: lux (lumens per square meter)
>  		RO
>  
> +What:		/sys/class/als/.../exposure_time[n]
> +Date:		Dec. 2009
> +KernelVersion:	2.6.32
> +Contact:	Jonathan Cameron <jic23@cam.ac.uk>
> +Description:	Sensor exposure time.  In some devices this
> +		corresponds to the combined time needed to
> +		to internally read several different sensors.
> +		Unit: microseconds
> +		RW
> diff --git a/drivers/als/Kconfig b/drivers/als/Kconfig
> index 200c52b..1564ffc 100644
> --- a/drivers/als/Kconfig
> +++ b/drivers/als/Kconfig
> @@ -8,3 +8,17 @@ menuconfig ALS
>  	  This framework provides a generic sysfs I/F for Ambient Light
>  	  Sensor devices.
>  	  If you want this support, you should say Y or M here.
> +
> +if ALS
> +
> +config ALS_TSL2550
> +	tristate "Taos TSL2550 ambient light sensor"
> +	depends on EXPERIMENTAL && I2C
> +	help
> +	  If you say yes here you get support for the Taos TSL2550
> +	  ambient light sensor.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called tsl2550.
> +
> +endif #ALS
> diff --git a/drivers/als/Makefile b/drivers/als/Makefile
> index a527197..7be5631 100644
> --- a/drivers/als/Makefile
> +++ b/drivers/als/Makefile
> @@ -3,3 +3,5 @@
>  #
>  
>  obj-$(CONFIG_ALS)		+= als_sys.o
> +
> +obj-$(CONFIG_ALS_TSL2550)	+= tsl2550.o
> \ No newline at end of file
> diff --git a/drivers/als/tsl2550.c b/drivers/als/tsl2550.c
> new file mode 100644
> index 0000000..64f7f96
> --- /dev/null
> +++ b/drivers/als/tsl2550.c
> @@ -0,0 +1,496 @@
> +/*
> + *  tsl2550.c - Linux kernel modules for ambient light sensor
> + *
> + *  Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>
> + *  Copyright (C) 2007 Eurotech S.p.A. <info@eurotech.it>
> + *  Copyright (C) 2009 Jonathan Cameron <jic23@cam.ac.uk>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/als_sys.h>
> +
> +#define TSL2550_DRV_NAME	"tsl2550"
> +#define DRIVER_VERSION		"2.0"
> +
> +/*
> + * Defines
> + */
> +
> +#define TSL2550_POWER_DOWN		0x00
> +#define TSL2550_POWER_UP		0x03
> +#define TSL2550_STANDARD_RANGE		0x18
> +#define TSL2550_EXTENDED_RANGE		0x1d
> +#define TSL2550_READ_ADC0		0x43
> +#define TSL2550_READ_ADC1		0x83
> +
> +/*
> + * Structs
> + */
> +
> +struct tsl2550_data {
> +	struct device *classdev;
> +	struct i2c_client *client;
> +	struct mutex update_lock;

The original driver had a blank like here, which I think made sense
(separating the administrative part from the actual device settings.

> +	unsigned int power_state:1;
> +	unsigned int operating_mode:1;
> +};
> +
> +/*
> + * Global data
> + */
> +
> +static const u8 TSL2550_MODE_RANGE[2] = {
> +	TSL2550_STANDARD_RANGE, TSL2550_EXTENDED_RANGE,
> +};
> +
> +/*
> + * Management functions
> + */
> +
> +static int tsl2550_set_operating_mode(struct i2c_client *client, int mode)
> +{
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +
> +	int ret = i2c_smbus_write_byte(client, TSL2550_MODE_RANGE[mode]);
> +
> +	data->operating_mode = mode;
> +
> +	return ret;
> +}
> +
> +static int tsl2550_set_power_state(struct i2c_client *client, int state)
> +{
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +	int ret;
> +
> +	if (state == 0)
> +		ret = i2c_smbus_write_byte(client, TSL2550_POWER_DOWN);
> +	else {
> +		ret = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
> +
> +		/* On power up we should reset operating mode also... */
> +		tsl2550_set_operating_mode(client, data->operating_mode);
> +	}
> +
> +	data->power_state = state;
> +
> +	return ret;
> +}
> +
> +static int tsl2550_get_adc_value(struct i2c_client *client, u8 cmd)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(client, cmd);
> +	if (ret < 0)
> +		return ret;
> +	if (!(ret & 0x80))
> +		return -EAGAIN;
> +	if (ret == 0x7f)
> +		return -ERANGE;
> +	return ret & 0x7f;	/* remove the "valid" bit */
> +}
> +
> +/*
> + * LUX calculation - note the range is dependent on combination
> + * of infrared level and visible light levels.
> + */
> +
> +#define	TSL2550_MAX_LUX		1568

I would get rid of this entirely. As I explained before, there is no
way the computations can lead to a value larger than this. If we start
diverging from the "official" algorithm then we might as well drop the
useless parts altogether.

> +
> +static const u8 ratio_lut[] = {
> +	100, 100, 100, 100, 100, 100, 100, 100,
> +	100, 100, 100, 100, 100, 100, 99, 99,
> +	99, 99, 99, 99, 99, 99, 99, 99,
> +	99, 99, 99, 98, 98, 98, 98, 98,
> +	98, 98, 97, 97, 97, 97, 97, 96,
> +	96, 96, 96, 95, 95, 95, 94, 94,
> +	93, 93, 93, 92, 92, 91, 91, 90,
> +	89, 89, 88, 87, 87, 86, 85, 84,
> +	83, 82, 81, 80, 79, 78, 77, 75,
> +	74, 73, 71, 69, 68, 66, 64, 62,
> +	60, 58, 56, 54, 52, 49, 47, 44,
> +	42, 41, 40, 40, 39, 39, 38, 38,
> +	37, 37, 37, 36, 36, 36, 35, 35,
> +	35, 35, 34, 34, 34, 34, 33, 33,
> +	33, 33, 32, 32, 32, 32, 32, 31,
> +	31, 31, 31, 31, 30, 30, 30, 30,
> +	30,
> +};
> +
> +static const u16 count_lut[] = {
> +	0, 1, 2, 3, 4, 5, 6, 7,
> +	8, 9, 10, 11, 12, 13, 14, 15,
> +	16, 18, 20, 22, 24, 26, 28, 30,
> +	32, 34, 36, 38, 40, 42, 44, 46,
> +	49, 53, 57, 61, 65, 69, 73, 77,
> +	81, 85, 89, 93, 97, 101, 105, 109,
> +	115, 123, 131, 139, 147, 155, 163, 171,
> +	179, 187, 195, 203, 211, 219, 227, 235,
> +	247, 263, 279, 295, 311, 327, 343, 359,
> +	375, 391, 407, 423, 439, 455, 471, 487,
> +	511, 543, 575, 607, 639, 671, 703, 735,
> +	767, 799, 831, 863, 895, 927, 959, 991,
> +	1039, 1103, 1167, 1231, 1295, 1359, 1423, 1487,
> +	1551, 1615, 1679, 1743, 1807, 1871, 1935, 1999,
> +	2095, 2223, 2351, 2479, 2607, 2735, 2863, 2991,
> +	3119, 3247, 3375, 3503, 3631, 3759, 3887, 4015,
> +};
> +
> +/*
> + * This function is described into Taos TSL2550 Designer's Notebook
> + * pages 2, 3.
> + */
> +static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
> +{
> +	unsigned int lux;
> +
> +	/* Look up count from channel values */
> +	u16 c0 = count_lut[ch0];
> +	u16 c1 = count_lut[ch1];
> +
> +	/*
> +	 * Calculate ratio.
> +	 * Note: the "128" is a scaling factor
> +	 */
> +	u8 r = 128;
> +
> +	/* Avoid division by 0 and count 1 cannot be greater than count 0 */
> +	if (c1 <= c0)
> +		if (c0) {
> +			r = c1 * 128 / c0;
> +
> +			/* Calculate LUX */
> +			lux = ((c0 - c1) * ratio_lut[r]) / 256;
> +		} else
> +			lux = 0;
> +	else
> +		return -EAGAIN;
> +
> +	/* LUX range check */
> +	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
> +}
> +
> +/*
> + * SysFS support
> + */
> +
> +static ssize_t tsl2550_show_power_state(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +
> +	return sprintf(buf, "%u\n", data->power_state);
> +}
> +
> +static ssize_t tsl2550_store_power_state(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +	unsigned long val;
> +	int ret = strict_strtoul(buf, 10, &val);
> +
> +	if (val < 0 || val > 1 || ret)
> +		return -EINVAL;
> +
> +	mutex_lock(&data->update_lock);
> +	ret = tsl2550_set_power_state(client, val);
> +	mutex_unlock(&data->update_lock);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(power_state, S_IWUSR | S_IRUGO,
> +		   tsl2550_show_power_state, tsl2550_store_power_state);
> +
> +static ssize_t tsl2550_show_exposure(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +	if (data->operating_mode)
> +		return sprintf(buf, "160000\n");
> +	else
> +		return sprintf(buf, "800000\n");
> +}
> +
> +static ssize_t tsl2550_store_exposure(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf,
> +				      size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +	unsigned long val;
> +
> +	int ret = strict_strtoul(buf, 10, &val);
> +
> +	if (ret)
> +		return -EINVAL;
> +	mutex_lock(&data->update_lock);
> +	if (val >= 800000)
> +		ret = tsl2550_set_operating_mode(client, 0);
> +	else
> +		ret = tsl2550_set_operating_mode(client, 1);
> +	mutex_unlock(&data->update_lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(exposure_time0, S_IWUSR | S_IRUGO,
> +		   tsl2550_show_exposure, tsl2550_store_exposure);
> +
> +static ssize_t __tsl2550_show_lux(struct i2c_client *client, char *buf)
> +{
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +	u8 ch0, ch1;
> +	int ret;
> +
> +	ret = tsl2550_get_adc_value(client, TSL2550_READ_ADC0);
> +	if (ret < 0)
> +		return ret;
> +	ch0 = ret;
> +
> +	ret = tsl2550_get_adc_value(client, TSL2550_READ_ADC1);
> +	if (ret < 0)
> +		return ret;
> +	ch1 = ret;
> +
> +	/* Do the job */
> +	ret = tsl2550_calculate_lux(ch0, ch1);
> +	if (ret < 0)
> +		return ret;
> +	if (data->operating_mode == 1)
> +		ret *= 5;
> +
> +	return sprintf(buf, "%d\n", ret);
> +}
> +
> +static ssize_t tsl2550_show_lux1_input(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +	int ret;
> +
> +	/* No LUX data if not operational */
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	mutex_lock(&data->update_lock);
> +	ret = __tsl2550_show_lux(client, buf);
> +	mutex_unlock(&data->update_lock);
> +
> +	return ret;
> +}
> +
> +static DEVICE_ATTR(illuminance0, S_IRUGO,
> +		   tsl2550_show_lux1_input, NULL);
> +
> +static struct attribute *tsl2550_attributes[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_exposure_time0.attr,
> +	&dev_attr_illuminance0.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group tsl2550_attr_group = {
> +	.attrs = tsl2550_attributes,
> +};
> +
> +/*
> + * Initialization function
> + */
> +
> +static int tsl2550_init_client(struct i2c_client *client)
> +{
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +	int err;
> +
> +	/*
> +	 * Probe the chip. To do so we try to power up the device and then to
> +	 * read back the 0x03 code
> +	 */
> +	err = i2c_smbus_read_byte_data(client, TSL2550_POWER_UP);
> +	if (err < 0)
> +		return err;
> +	if (err != TSL2550_POWER_UP)
> +		return -ENODEV;
> +	data->power_state = 1;
> +
> +	/* Set the default operating mode */
> +	err = i2c_smbus_write_byte(client,
> +				   TSL2550_MODE_RANGE[data->operating_mode]);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +
> +/*
> + * I2C init/probing/exit functions
> + */
> +
> +static struct i2c_driver tsl2550_driver;
> +static int __devinit tsl2550_probe(struct i2c_client *client,
> +				   const struct i2c_device_id *id)
> +{
> +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> +	struct tsl2550_data *data;
> +	int *opmode, err = 0;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WRITE_BYTE
> +					    | I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
> +		err = -EIO;
> +		goto exit;
> +	}
> +
> +	data = kzalloc(sizeof(struct tsl2550_data), GFP_KERNEL);
> +	if (!data) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +	data->client = client;
> +	i2c_set_clientdata(client, data);
> +
> +	/* Check platform data */
> +	opmode = client->dev.platform_data;
> +	if (opmode) {
> +		if (*opmode < 0 || *opmode > 1) {
> +			dev_err(&client->dev, "invalid operating_mode (%d)\n",
> +					*opmode);
> +			err = -EINVAL;
> +			goto exit_kfree;
> +		}
> +		data->operating_mode = *opmode;
> +	} else
> +		data->operating_mode = 0;	/* default mode is standard */
> +	dev_info(&client->dev, "%s operating mode\n",
> +			data->operating_mode ? "extended" : "standard");
> +
> +	mutex_init(&data->update_lock);
> +
> +	/* Initialize the TSL2550 chip */
> +	err = tsl2550_init_client(client);
> +	if (err)
> +		goto exit_kfree;
> +
> +	/* Register sysfs hooks */
> +	data->classdev = als_device_register(&client->dev);
> +	if (IS_ERR(data->classdev)) {
> +		err = PTR_ERR(data->classdev);
> +		goto exit_kfree;
> +	}
> +
> +	err = sysfs_create_group(&data->classdev->kobj, &tsl2550_attr_group);
> +	if (err)
> +		goto exit_unreg;
> +
> +	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
> +
> +	return 0;
> +
> +exit_unreg:
> +	als_device_unregister(data->classdev);
> +exit_kfree:
> +	kfree(data);
> +exit:
> +	return err;
> +}
> +
> +static int __devexit tsl2550_remove(struct i2c_client *client)
> +{
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +
> +	sysfs_remove_group(&data->classdev->kobj, &tsl2550_attr_group);
> +	als_device_unregister(data->classdev);
> +
> +	/* Power down the device */
> +	tsl2550_set_power_state(client, 0);
> +
> +	kfree(data);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int tsl2550_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	return tsl2550_set_power_state(client, 0);
> +}
> +
> +static int tsl2550_resume(struct i2c_client *client)
> +{
> +	return tsl2550_set_power_state(client, 1);
> +}
> +
> +#else
> +
> +#define tsl2550_suspend		NULL
> +#define tsl2550_resume		NULL
> +
> +#endif /* CONFIG_PM */
> +
> +static const struct i2c_device_id tsl2550_id[] = {
> +	{ "tsl2550", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, tsl2550_id);
> +
> +static struct i2c_driver tsl2550_driver = {
> +	.driver = {
> +		.name	= TSL2550_DRV_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +	.suspend = tsl2550_suspend,
> +	.resume	= tsl2550_resume,
> +	.probe	= tsl2550_probe,
> +	.remove	= __devexit_p(tsl2550_remove),
> +	.id_table = tsl2550_id,
> +};
> +
> +static int __init tsl2550_init(void)
> +{
> +	return i2c_add_driver(&tsl2550_driver);
> +}
> +
> +static void __exit tsl2550_exit(void)
> +{
> +	i2c_del_driver(&tsl2550_driver);
> +}
> +
> +MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
> +MODULE_DESCRIPTION("TSL2550 ambient light sensor driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRIVER_VERSION);
> +
> +module_init(tsl2550_init);
> +module_exit(tsl2550_exit);
> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> index 8d8a00e..5c33a71 100644
> --- a/drivers/i2c/Kconfig
> +++ b/drivers/i2c/Kconfig
> @@ -63,7 +63,6 @@ config I2C_HELPER_AUTO
>  
>  source drivers/i2c/algos/Kconfig
>  source drivers/i2c/busses/Kconfig
> -source drivers/i2c/chips/Kconfig
>  
>  config I2C_DEBUG_CORE
>  	bool "I2C Core debugging messages"
> diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
> index ba26e6c..ce5fd62 100644
> --- a/drivers/i2c/Makefile
> +++ b/drivers/i2c/Makefile
> @@ -5,7 +5,7 @@
>  obj-$(CONFIG_I2C_BOARDINFO)	+= i2c-boardinfo.o
>  obj-$(CONFIG_I2C)		+= i2c-core.o
>  obj-$(CONFIG_I2C_CHARDEV)	+= i2c-dev.o
> -obj-y				+= busses/ chips/ algos/
> +obj-y				+= busses/ algos/
>  
>  ifeq ($(CONFIG_I2C_DEBUG_CORE),y)
>  EXTRA_CFLAGS += -DDEBUG
> diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
> deleted file mode 100644
> index ae4539d..0000000
> --- a/drivers/i2c/chips/Kconfig
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -#
> -# Miscellaneous I2C chip drivers configuration
> -#
> -# *** DEPRECATED! Do not add new entries! See Makefile ***
> -#
> -
> -menu "Miscellaneous I2C Chip support"
> -
> -config SENSORS_TSL2550
> -	tristate "Taos TSL2550 ambient light sensor"
> -	depends on EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for the Taos TSL2550
> -	  ambient light sensor.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called tsl2550.
> -
> -endmenu
> diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
> deleted file mode 100644
> index fe0af0f..0000000
> --- a/drivers/i2c/chips/Makefile
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -#
> -# Makefile for miscellaneous I2C chip drivers.
> -#
> -# Do not add new drivers to this directory! It is DEPRECATED.
> -#
> -# Device drivers are better grouped according to the functionality they
> -# implement rather than to the bus they are connected to. In particular:
> -# * Hardware monitoring chip drivers go to drivers/hwmon
> -# * RTC chip drivers go to drivers/rtc
> -# * I/O expander drivers go to drivers/gpio
> -#
> -
> -obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
> -
> -ifeq ($(CONFIG_I2C_DEBUG_CHIP),y)
> -EXTRA_CFLAGS += -DDEBUG
> -endif
> -
> diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/i2c/chips/tsl2550.c
> deleted file mode 100644
> index a0702f3..0000000
> --- a/drivers/i2c/chips/tsl2550.c
> +++ /dev/null
> @@ -1,473 +0,0 @@
> -/*
> - *  tsl2550.c - Linux kernel modules for ambient light sensor
> - *
> - *  Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>
> - *  Copyright (C) 2007 Eurotech S.p.A. <info@eurotech.it>
> - *
> - *  This program is free software; you can redistribute it and/or modify
> - *  it under the terms of the GNU General Public License as published by
> - *  the Free Software Foundation; either version 2 of the License, or
> - *  (at your option) any later version.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
> - *
> - *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/init.h>
> -#include <linux/slab.h>
> -#include <linux/i2c.h>
> -#include <linux/mutex.h>
> -
> -#define TSL2550_DRV_NAME	"tsl2550"
> -#define DRIVER_VERSION		"1.2"
> -
> -/*
> - * Defines
> - */
> -
> -#define TSL2550_POWER_DOWN		0x00
> -#define TSL2550_POWER_UP		0x03
> -#define TSL2550_STANDARD_RANGE		0x18
> -#define TSL2550_EXTENDED_RANGE		0x1d
> -#define TSL2550_READ_ADC0		0x43
> -#define TSL2550_READ_ADC1		0x83
> -
> -/*
> - * Structs
> - */
> -
> -struct tsl2550_data {
> -	struct i2c_client *client;
> -	struct mutex update_lock;
> -
> -	unsigned int power_state : 1;
> -	unsigned int operating_mode : 1;
> -};
> -
> -/*
> - * Global data
> - */
> -
> -static const u8 TSL2550_MODE_RANGE[2] = {
> -	TSL2550_STANDARD_RANGE, TSL2550_EXTENDED_RANGE,
> -};
> -
> -/*
> - * Management functions
> - */
> -
> -static int tsl2550_set_operating_mode(struct i2c_client *client, int mode)
> -{
> -	struct tsl2550_data *data = i2c_get_clientdata(client);
> -
> -	int ret = i2c_smbus_write_byte(client, TSL2550_MODE_RANGE[mode]);
> -
> -	data->operating_mode = mode;
> -
> -	return ret;
> -}
> -
> -static int tsl2550_set_power_state(struct i2c_client *client, int state)
> -{
> -	struct tsl2550_data *data = i2c_get_clientdata(client);
> -	int ret;
> -
> -	if (state == 0)
> -		ret = i2c_smbus_write_byte(client, TSL2550_POWER_DOWN);
> -	else {
> -		ret = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
> -
> -		/* On power up we should reset operating mode also... */
> -		tsl2550_set_operating_mode(client, data->operating_mode);
> -	}
> -
> -	data->power_state = state;
> -
> -	return ret;
> -}
> -
> -static int tsl2550_get_adc_value(struct i2c_client *client, u8 cmd)
> -{
> -	int ret;
> -
> -	ret = i2c_smbus_read_byte_data(client, cmd);
> -	if (ret < 0)
> -		return ret;
> -	if (!(ret & 0x80))
> -		return -EAGAIN;
> -	return ret & 0x7f;	/* remove the "valid" bit */
> -}
> -
> -/*
> - * LUX calculation
> - */
> -
> -#define	TSL2550_MAX_LUX		1846
> -
> -static const u8 ratio_lut[] = {
> -	100, 100, 100, 100, 100, 100, 100, 100,
> -	100, 100, 100, 100, 100, 100, 99, 99,
> -	99, 99, 99, 99, 99, 99, 99, 99,
> -	99, 99, 99, 98, 98, 98, 98, 98,
> -	98, 98, 97, 97, 97, 97, 97, 96,
> -	96, 96, 96, 95, 95, 95, 94, 94,
> -	93, 93, 93, 92, 92, 91, 91, 90,
> -	89, 89, 88, 87, 87, 86, 85, 84,
> -	83, 82, 81, 80, 79, 78, 77, 75,
> -	74, 73, 71, 69, 68, 66, 64, 62,
> -	60, 58, 56, 54, 52, 49, 47, 44,
> -	42, 41, 40, 40, 39, 39, 38, 38,
> -	37, 37, 37, 36, 36, 36, 35, 35,
> -	35, 35, 34, 34, 34, 34, 33, 33,
> -	33, 33, 32, 32, 32, 32, 32, 31,
> -	31, 31, 31, 31, 30, 30, 30, 30,
> -	30,
> -};
> -
> -static const u16 count_lut[] = {
> -	0, 1, 2, 3, 4, 5, 6, 7,
> -	8, 9, 10, 11, 12, 13, 14, 15,
> -	16, 18, 20, 22, 24, 26, 28, 30,
> -	32, 34, 36, 38, 40, 42, 44, 46,
> -	49, 53, 57, 61, 65, 69, 73, 77,
> -	81, 85, 89, 93, 97, 101, 105, 109,
> -	115, 123, 131, 139, 147, 155, 163, 171,
> -	179, 187, 195, 203, 211, 219, 227, 235,
> -	247, 263, 279, 295, 311, 327, 343, 359,
> -	375, 391, 407, 423, 439, 455, 471, 487,
> -	511, 543, 575, 607, 639, 671, 703, 735,
> -	767, 799, 831, 863, 895, 927, 959, 991,
> -	1039, 1103, 1167, 1231, 1295, 1359, 1423, 1487,
> -	1551, 1615, 1679, 1743, 1807, 1871, 1935, 1999,
> -	2095, 2223, 2351, 2479, 2607, 2735, 2863, 2991,
> -	3119, 3247, 3375, 3503, 3631, 3759, 3887, 4015,
> -};
> -
> -/*
> - * This function is described into Taos TSL2550 Designer's Notebook
> - * pages 2, 3.
> - */
> -static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
> -{
> -	unsigned int lux;
> -
> -	/* Look up count from channel values */
> -	u16 c0 = count_lut[ch0];
> -	u16 c1 = count_lut[ch1];
> -
> -	/*
> -	 * Calculate ratio.
> -	 * Note: the "128" is a scaling factor
> -	 */
> -	u8 r = 128;
> -
> -	/* Avoid division by 0 and count 1 cannot be greater than count 0 */
> -	if (c1 <= c0)
> -		if (c0) {
> -			r = c1 * 128 / c0;
> -
> -			/* Calculate LUX */
> -			lux = ((c0 - c1) * ratio_lut[r]) / 256;
> -		} else
> -			lux = 0;
> -	else
> -		return -EAGAIN;
> -
> -	/* LUX range check */
> -	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
> -}
> -
> -/*
> - * SysFS support
> - */
> -
> -static ssize_t tsl2550_show_power_state(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
> -
> -	return sprintf(buf, "%u\n", data->power_state);
> -}
> -
> -static ssize_t tsl2550_store_power_state(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t count)
> -{
> -	struct i2c_client *client = to_i2c_client(dev);
> -	struct tsl2550_data *data = i2c_get_clientdata(client);
> -	unsigned long val = simple_strtoul(buf, NULL, 10);
> -	int ret;
> -
> -	if (val < 0 || val > 1)
> -		return -EINVAL;
> -
> -	mutex_lock(&data->update_lock);
> -	ret = tsl2550_set_power_state(client, val);
> -	mutex_unlock(&data->update_lock);
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	return count;
> -}
> -
> -static DEVICE_ATTR(power_state, S_IWUSR | S_IRUGO,
> -		   tsl2550_show_power_state, tsl2550_store_power_state);
> -
> -static ssize_t tsl2550_show_operating_mode(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
> -
> -	return sprintf(buf, "%u\n", data->operating_mode);
> -}
> -
> -static ssize_t tsl2550_store_operating_mode(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t count)
> -{
> -	struct i2c_client *client = to_i2c_client(dev);
> -	struct tsl2550_data *data = i2c_get_clientdata(client);
> -	unsigned long val = simple_strtoul(buf, NULL, 10);
> -	int ret;
> -
> -	if (val < 0 || val > 1)
> -		return -EINVAL;
> -
> -	if (data->power_state == 0)
> -		return -EBUSY;
> -
> -	mutex_lock(&data->update_lock);
> -	ret = tsl2550_set_operating_mode(client, val);
> -	mutex_unlock(&data->update_lock);
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	return count;
> -}
> -
> -static DEVICE_ATTR(operating_mode, S_IWUSR | S_IRUGO,
> -		   tsl2550_show_operating_mode, tsl2550_store_operating_mode);
> -
> -static ssize_t __tsl2550_show_lux(struct i2c_client *client, char *buf)
> -{
> -	struct tsl2550_data *data = i2c_get_clientdata(client);
> -	u8 ch0, ch1;
> -	int ret;
> -
> -	ret = tsl2550_get_adc_value(client, TSL2550_READ_ADC0);
> -	if (ret < 0)
> -		return ret;
> -	ch0 = ret;
> -
> -	ret = tsl2550_get_adc_value(client, TSL2550_READ_ADC1);
> -	if (ret < 0)
> -		return ret;
> -	ch1 = ret;
> -
> -	/* Do the job */
> -	ret = tsl2550_calculate_lux(ch0, ch1);
> -	if (ret < 0)
> -		return ret;
> -	if (data->operating_mode == 1)
> -		ret *= 5;
> -
> -	return sprintf(buf, "%d\n", ret);
> -}
> -
> -static ssize_t tsl2550_show_lux1_input(struct device *dev,
> -			struct device_attribute *attr, char *buf)
> -{
> -	struct i2c_client *client = to_i2c_client(dev);
> -	struct tsl2550_data *data = i2c_get_clientdata(client);
> -	int ret;
> -
> -	/* No LUX data if not operational */
> -	if (!data->power_state)
> -		return -EBUSY;
> -
> -	mutex_lock(&data->update_lock);
> -	ret = __tsl2550_show_lux(client, buf);
> -	mutex_unlock(&data->update_lock);
> -
> -	return ret;
> -}
> -
> -static DEVICE_ATTR(lux1_input, S_IRUGO,
> -		   tsl2550_show_lux1_input, NULL);
> -
> -static struct attribute *tsl2550_attributes[] = {
> -	&dev_attr_power_state.attr,
> -	&dev_attr_operating_mode.attr,
> -	&dev_attr_lux1_input.attr,
> -	NULL
> -};
> -
> -static const struct attribute_group tsl2550_attr_group = {
> -	.attrs = tsl2550_attributes,
> -};
> -
> -/*
> - * Initialization function
> - */
> -
> -static int tsl2550_init_client(struct i2c_client *client)
> -{
> -	struct tsl2550_data *data = i2c_get_clientdata(client);
> -	int err;
> -
> -	/*
> -	 * Probe the chip. To do so we try to power up the device and then to
> -	 * read back the 0x03 code
> -	 */
> -	err = i2c_smbus_read_byte_data(client, TSL2550_POWER_UP);
> -	if (err < 0)
> -		return err;
> -	if (err != TSL2550_POWER_UP)
> -		return -ENODEV;
> -	data->power_state = 1;
> -
> -	/* Set the default operating mode */
> -	err = i2c_smbus_write_byte(client,
> -				   TSL2550_MODE_RANGE[data->operating_mode]);
> -	if (err < 0)
> -		return err;
> -
> -	return 0;
> -}
> -
> -/*
> - * I2C init/probing/exit functions
> - */
> -
> -static struct i2c_driver tsl2550_driver;
> -static int __devinit tsl2550_probe(struct i2c_client *client,
> -				   const struct i2c_device_id *id)
> -{
> -	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> -	struct tsl2550_data *data;
> -	int *opmode, err = 0;
> -
> -	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WRITE_BYTE
> -					    | I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
> -		err = -EIO;
> -		goto exit;
> -	}
> -
> -	data = kzalloc(sizeof(struct tsl2550_data), GFP_KERNEL);
> -	if (!data) {
> -		err = -ENOMEM;
> -		goto exit;
> -	}
> -	data->client = client;
> -	i2c_set_clientdata(client, data);
> -
> -	/* Check platform data */
> -	opmode = client->dev.platform_data;
> -	if (opmode) {
> -		if (*opmode < 0 || *opmode > 1) {
> -			dev_err(&client->dev, "invalid operating_mode (%d)\n",
> -					*opmode);
> -			err = -EINVAL;
> -			goto exit_kfree;
> -		}
> -		data->operating_mode = *opmode;
> -	} else
> -		data->operating_mode = 0;	/* default mode is standard */
> -	dev_info(&client->dev, "%s operating mode\n",
> -			data->operating_mode ? "extended" : "standard");
> -
> -	mutex_init(&data->update_lock);
> -
> -	/* Initialize the TSL2550 chip */
> -	err = tsl2550_init_client(client);
> -	if (err)
> -		goto exit_kfree;
> -
> -	/* Register sysfs hooks */
> -	err = sysfs_create_group(&client->dev.kobj, &tsl2550_attr_group);
> -	if (err)
> -		goto exit_kfree;
> -
> -	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
> -
> -	return 0;
> -
> -exit_kfree:
> -	kfree(data);
> -exit:
> -	return err;
> -}
> -
> -static int __devexit tsl2550_remove(struct i2c_client *client)
> -{
> -	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
> -
> -	/* Power down the device */
> -	tsl2550_set_power_state(client, 0);
> -
> -	kfree(i2c_get_clientdata(client));
> -
> -	return 0;
> -}
> -
> -#ifdef CONFIG_PM
> -
> -static int tsl2550_suspend(struct i2c_client *client, pm_message_t mesg)
> -{
> -	return tsl2550_set_power_state(client, 0);
> -}
> -
> -static int tsl2550_resume(struct i2c_client *client)
> -{
> -	return tsl2550_set_power_state(client, 1);
> -}
> -
> -#else
> -
> -#define tsl2550_suspend		NULL
> -#define tsl2550_resume		NULL
> -
> -#endif /* CONFIG_PM */
> -
> -static const struct i2c_device_id tsl2550_id[] = {
> -	{ "tsl2550", 0 },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(i2c, tsl2550_id);
> -
> -static struct i2c_driver tsl2550_driver = {
> -	.driver = {
> -		.name	= TSL2550_DRV_NAME,
> -		.owner	= THIS_MODULE,
> -	},
> -	.suspend = tsl2550_suspend,
> -	.resume	= tsl2550_resume,
> -	.probe	= tsl2550_probe,
> -	.remove	= __devexit_p(tsl2550_remove),
> -	.id_table = tsl2550_id,
> -};
> -
> -static int __init tsl2550_init(void)
> -{
> -	return i2c_add_driver(&tsl2550_driver);
> -}
> -
> -static void __exit tsl2550_exit(void)
> -{
> -	i2c_del_driver(&tsl2550_driver);
> -}
> -
> -MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
> -MODULE_DESCRIPTION("TSL2550 ambient light sensor driver");
> -MODULE_LICENSE("GPL");
> -MODULE_VERSION(DRIVER_VERSION);
> -
> -module_init(tsl2550_init);
> -module_exit(tsl2550_exit);

All the rest looks just fine. Thanks a lot for driving this. I really
hope we can get rid of drivers/i2c/chips really soon now!

-- 
Jean Delvare
