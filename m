Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbZJIPFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbZJIPFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760830AbZJIPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:05:40 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:35635 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZJIPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:05:39 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4ACF5126.5000600@cam.ac.uk>
Date: Fri, 09 Oct 2009 16:05:10 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
References: <4ACF4AC6.7070802@cam.ac.uk>
In-Reply-To: <4ACF4AC6.7070802@cam.ac.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gah, I forgot the I2C dependency as well.

Sorry for the silly errors.
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> ---
> Minimal changes made. Untested due to lack of hardware.
> All comments welcome.
> 
> illuminance is already documented as part of the class.
> operating mode and power state are both as per the original
> driver. I can't find any documentation for them, but if people
> want it I can probably figure out what they are from
> the data sheet.  
> 
> Might be worth dropping the power state control and moving
> over to runtime pm but that is definitely the topic for another
> patch.
> 
> Does anyone want a patch without using Git's move functionality?
> 
> Have copied all the users Jean knows about, but please cc any other
> users as this does involve a change to the userspace interface.
> 
> Applies on 2.6.31-rc3 with the ALS patches
> http://patchwork.kernel.org/patch/49153/
> 
>  drivers/als/Kconfig                  |   14 ++++++
>  drivers/als/Makefile                 |    2 +
>  drivers/{i2c/chips => als}/tsl2550.c |   73 ++++++++++++++++++++++++++++++---
>  3 files changed, 82 insertions(+), 7 deletions(-)
> 
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

