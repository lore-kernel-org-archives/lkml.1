Return-Path: <linux-kernel-owner+w=401wt.eu-S934691AbZJJQwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbZJJQwm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 12:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934670AbZJJQwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 12:52:41 -0400
Received: from poutre.nerim.net ([62.4.16.124]:59113 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbZJJQwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 12:52:40 -0400
Date: Sat, 10 Oct 2009 18:52:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
Message-ID: <20091010185200.671846c5@hyperion.delvare>
In-Reply-To: <4ACF4AC6.7070802@cam.ac.uk>
References: <4ACF4AC6.7070802@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Oct 2009 15:37:58 +0100, Jonathan Cameron wrote:
>  drivers/als/Kconfig                  |   14 ++++++
>  drivers/als/Makefile                 |    2 +
>  drivers/{i2c/chips => als}/tsl2550.c |   73 ++++++++++++++++++++++++++++++---
>  3 files changed, 82 insertions(+), 7 deletions(-)

Review:

> diff --git a/drivers/als/Kconfig b/drivers/als/Kconfig
> index 200c52b..0c5dbb2 100644
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
> +	depends on EXPERIMENTAL

As you found out already, you need to depend on I2C as well.

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
> diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/als/tsl2550.c
> similarity index 87%
> rename from drivers/i2c/chips/tsl2550.c
> rename to drivers/als/tsl2550.c
> index aa96bd2..6c11695 100644
> --- a/drivers/i2c/chips/tsl2550.c
> +++ b/drivers/als/tsl2550.c
> @@ -24,9 +24,12 @@
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/idr.h>
> +#include <linux/als_sys.h>
>  
>  #define TSL2550_DRV_NAME	"tsl2550"
> -#define DRIVER_VERSION		"1.2"
> +#define DRIVER_VERSION		"2"

"2.0"?

>  
>  /*
>   * Defines
> @@ -44,8 +47,10 @@
>   */
>  
>  struct tsl2550_data {
> +	struct device *classdev;
>  	struct i2c_client *client;
>  	struct mutex update_lock;
> +	unsigned int id;
>  
>  	unsigned int power_state : 1;
>  	unsigned int operating_mode : 1;
> @@ -60,9 +65,41 @@ static const u8 TSL2550_MODE_RANGE[2] = {
>  };
>  
>  /*
> + * IDR to assign each registered device a unique id
> + */
> +static DEFINE_IDR(tsl2550_idr);
> +static DEFINE_SPINLOCK(tsl2550_idr_lock);
> +#define TSL2550_DEV_MAX 9

Such an arbitrary limit is simply not acceptable.

> +
> +/*
>   * Management functions
>   */
>  
> +static int tsl2550_get_id(void)
> +{
> +	int ret, val;
> +
> +idr_again:
> +	if (unlikely(idr_pre_get(&tsl2550_idr, GFP_KERNEL) == 0))
> +		return -ENOMEM;
> +	spin_lock(&tsl2550_idr_lock);
> +	ret = idr_get_new(&tsl2550_idr, NULL, &val);
> +	if (unlikely(ret == -EAGAIN))
> +		goto idr_again;
> +	else if (unlikely(ret))
> +		return ret;
> +	if (val > TSL2550_DEV_MAX)
> +		return -ENOMEM;
> +	return val;
> +}
> +
> +static void tsl2550_free_id(int val)
> +{
> +	spin_lock(&tsl2550_idr_lock);
> +	idr_remove(&tsl2550_idr, val);
> +	spin_unlock(&tsl2550_idr_lock);
> +}

Having to implement this in _every_ ALS driver sounds wrong and
painful. If uniqueness of any kind must be provided, it should be
handled by the ALS core and not by individual drivers, otherwise you
can be certain that at least one driver will get it wrong someday.

I'd imaging that als-class devices are simply named als%u. Just like
hwmon devices are named hwmon%u, input devices are names input%u and
event%u, etc. I don't know of any class pushing the naming down to its
drivers, do you? The only example I can remember are i2c drivers back
in year 1999, when they were part of lm-sensors.I have personally put
an end to this years ago.

> +
>  static int tsl2550_set_operating_mode(struct i2c_client *client, int mode)
>  {
>  	struct tsl2550_data *data = i2c_get_clientdata(client);
> @@ -296,13 +333,13 @@ static ssize_t tsl2550_show_lux1_input(struct device *dev,
>  	return ret;
>  }
>  
> -static DEVICE_ATTR(lux1_input, S_IRUGO,
> +static DEVICE_ATTR(illuminance, S_IRUGO,
>  		   tsl2550_show_lux1_input, NULL);

Question: if I have a light sensing chip with two sensors, how are we
going to handle it? Will we register 2 als class devices? The initial
naming convention had the advantage that you could have more than one
sensor per device, but I don't know if it is desirable in practice.

>  
>  static struct attribute *tsl2550_attributes[] = {
>  	&dev_attr_power_state.attr,
>  	&dev_attr_operating_mode.attr,
> -	&dev_attr_lux1_input.attr,
> +	&dev_attr_illuminance.attr,
>  	NULL
>  };
>  
> @@ -350,6 +387,7 @@ static int __devinit tsl2550_probe(struct i2c_client *client,
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>  	struct tsl2550_data *data;
>  	int *opmode, err = 0;
> +	char name[9];
>  
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WRITE_BYTE
>  					    | I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
> @@ -387,15 +425,31 @@ static int __devinit tsl2550_probe(struct i2c_client *client,
>  	if (err)
>  		goto exit_kfree;
>  
> +	data->id = tsl2550_get_id();
> +	if (data->id < 0) {
> +		err = data->id;
> +		goto exit_kfree;
> +	}
> +	sprintf(name, "tsl2550%d", data->id);

Please no. For one thing you should always use snprintf and not sprintf
when writing to such small buffers. It's way too easy to get things
wrong otherwise. And you really want a separator between the chip name
and the id, because "tsl25500" will be confusing as hell.

Not that these comments of mine really matter, as I don't think the
above code should stay at all.

>  	/* Register sysfs hooks */
> -	err = sysfs_create_group(&client->dev.kobj, &tsl2550_attr_group);
> +	data->classdev = als_device_register(&client->dev, name);
> +	if (IS_ERR(data->classdev)) {
> +		err = PTR_ERR(data->classdev);
> +		goto exit_free_id;
> +	}
> +
> +	err = sysfs_create_group(&data->classdev->kobj, &tsl2550_attr_group);
>  	if (err)
> -		goto exit_kfree;
> +		goto exit_unreg;
>  
>  	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
>  
>  	return 0;
>  
> +exit_unreg:
> +	als_device_unregister(data->classdev);
> +exit_free_id:
> +	tsl2550_free_id(data->id);
>  exit_kfree:
>  	kfree(data);
>  exit:
> @@ -404,12 +458,17 @@ exit:
>  
>  static int __devexit tsl2550_remove(struct i2c_client *client)
>  {
> -	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
> +	struct tsl2550_data *data = i2c_get_clientdata(client);
> +
> +	sysfs_remove_group(&data->classdev->kobj, &tsl2550_attr_group);
> +	als_device_unregister(data->classdev);
>  
>  	/* Power down the device */
>  	tsl2550_set_power_state(client, 0);
>  
> -	kfree(i2c_get_clientdata(client));
> +	tsl2550_free_id(data->id);
> +
> +	kfree(data);
>  
>  	return 0;
>  }


-- 
Jean Delvare
