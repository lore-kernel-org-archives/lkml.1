Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbZLPKez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbZLPKez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932892AbZLPKer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:34:47 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:14955 "EHLO
	mx3.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932840AbZLPKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:34:42 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B28B7BE.3030608@tremplin-utc.net>
Date: Wed, 16 Dec 2009 11:34:38 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Mandriva/3.0-4mdv2010.1 (2010.1) Thunderbird/3.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>, akpm@linux-foundation.org
CC: khali@linux-fr.org, kalhan.trisal@intel.com, mm-commits@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] I2C bus support for lis3lv02d and variant accelerometer
 chips
References: <1260958809-13991-1-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1260958809-13991-1-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing LKML, as mm-commits is not read by everyone ;-) )
Op 16-12-09 11:20, Samu Onkalo schreef:
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

Thanks Samu!

Andrew, any chance to get this quite soon upstream?
I'd really like not to have I2C support too much delayed, there has
already been three independent implementations written :-S

Thanks,
Eric
> ---
>  drivers/hwmon/Kconfig         |   17 ++++
>  drivers/hwmon/Makefile        |    1 +
>  drivers/hwmon/lis3lv02d_i2c.c |  183 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 201 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/lis3lv02d_i2c.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 95ccbe3..bf28945 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -998,6 +998,23 @@ config SENSORS_LIS3_SPI
>  	  will be called lis3lv02d and a specific module for the SPI transport
>  	  is called lis3lv02d_spi.
>  
> +config SENSORS_LIS3_I2C
> +	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (I2C)"
> +	depends on I2C && INPUT
> +	select INPUT_POLLDEV
> +	default n
> +	help
> +	  This driver provides support for the LIS3LV02Dx accelerometer connected
> +	  via I2C. The accelerometer data is readable via
> +	  /sys/devices/platform/lis3lv02d.
> +
> +	  This driver also provides an absolute input class device, allowing
> +	  the device to act as a pinball machine-esque joystick.
> +
> +	  This driver can also be built as modules.  If so, the core module
> +	  will be called lis3lv02d and a specific module for the I2C transport
> +	  is called lis3lv02d_i2c.
> +
>  config SENSORS_APPLESMC
>  	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
>  	depends on INPUT && X86
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 33c2ee1..4131e25 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_SENSORS_IT87)	+= it87.o
>  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
>  obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
>  obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
> +obj-$(CONFIG_SENSORS_LIS3_I2C)	+= lis3lv02d.o lis3lv02d_i2c.o
>  obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
>  obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
>  obj-$(CONFIG_SENSORS_LM73)	+= lm73.o
> diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
> new file mode 100644
> index 0000000..dc1f540
> --- /dev/null
> +++ b/drivers/hwmon/lis3lv02d_i2c.c
> @@ -0,0 +1,183 @@
> +/*
> + * drivers/hwmon/lis3lv02d_i2c.c
> + *
> + * Implements I2C interface for lis3lv02d (STMicroelectronics) accelerometer.
> + * Driver is based on corresponding SPI driver written by Daniel Mack
> + * (lis3lv02d_spi.c (C) 2009 Daniel Mack <daniel@caiaq.de> ).
> + *
> + * Copyright (C) 2009 Nokia Corporation and/or its subsidiary(-ies).
> + *
> + * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include "lis3lv02d.h"
> +
> +#define DRV_NAME 	"lis3lv02d_i2c"
> +
> +static inline s32 lis3_i2c_write(struct lis3lv02d *lis3, int reg, u8 value)
> +{
> +	struct i2c_client *c = lis3->bus_priv;
> +	return i2c_smbus_write_byte_data(c, reg, value);
> +}
> +
> +static inline s32 lis3_i2c_read(struct lis3lv02d *lis3, int reg, u8 *v)
> +{
> +	struct i2c_client *c = lis3->bus_priv;
> +	*v = i2c_smbus_read_byte_data(c, reg);
> +	return 0;
> +}
> +
> +static int lis3_i2c_init(struct lis3lv02d *lis3)
> +{
> +	u8 reg;
> +	int ret;
> +
> +	/* power up the device */
> +	ret = lis3->read(lis3, CTRL_REG1, &reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	reg |= CTRL1_PD0;
> +	return lis3->write(lis3, CTRL_REG1, reg);
> +}
> +
> +/* Default axis mapping but it can be overwritten by platform data */
> +static struct axis_conversion lis3lv02d_axis_map = { LIS3_DEV_X,
> +						     LIS3_DEV_Y,
> +						     LIS3_DEV_Z };
> +
> +static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	int ret = 0;
> +	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
> +
> +	if (pdata) {
> +		if (pdata->axis_x)
> +			lis3lv02d_axis_map.x = pdata->axis_x;
> +
> +		if (pdata->axis_y)
> +			lis3lv02d_axis_map.y = pdata->axis_y;
> +
> +		if (pdata->axis_z)
> +			lis3lv02d_axis_map.z = pdata->axis_z;
> +
> +		if (pdata->setup_resources)
> +			ret = pdata->setup_resources();
> +
> +		if (ret)
> +			goto fail;
> +	}
> +
> +	lis3_dev.pdata	  = pdata;
> +	lis3_dev.bus_priv = client;
> +	lis3_dev.init	  = lis3_i2c_init;
> +	lis3_dev.read	  = lis3_i2c_read;
> +	lis3_dev.write	  = lis3_i2c_write;
> +	lis3_dev.irq	  = client->irq;
> +	lis3_dev.ac	  = lis3lv02d_axis_map;
> +
> +	i2c_set_clientdata(client, &lis3_dev);
> +	ret = lis3lv02d_init_device(&lis3_dev);
> +fail:
> +	return ret;
> +}
> +
> +static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
> +{
> +	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
> +	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
> +
> +	if (pdata && pdata->release_resources)
> +		pdata->release_resources();
> +
> +	lis3lv02d_joystick_disable();
> +	lis3lv02d_poweroff(lis3);
> +
> +	return lis3lv02d_remove_fs(&lis3_dev);
> +}
> +
> +#ifdef CONFIG_PM
> +static int lis3lv02d_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
> +
> +	if (!lis3->pdata->wakeup_flags)
> +		lis3lv02d_poweroff(lis3);
> +	return 0;
> +}
> +
> +static int lis3lv02d_i2c_resume(struct i2c_client *client)
> +{
> +	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
> +
> +	if (!lis3->pdata->wakeup_flags)
> +		lis3lv02d_poweron(lis3);
> +	return 0;
> +}
> +
> +static void lis3lv02d_i2c_shutdown(struct i2c_client *client)
> +{
> +	lis3lv02d_i2c_suspend(client, PMSG_SUSPEND);
> +}
> +#else
> +#define lis3lv02d_i2c_suspend	NULL
> +#define lis3lv02d_i2c_resume	NULL
> +#define lis3lv02d_i2c_shutdown	NULL
> +#endif
> +
> +static const struct i2c_device_id lis3lv02d_id[] = {
> +	{"lis3lv02d", 0 },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, lis3lv02d_id);
> +
> +static struct i2c_driver lis3lv02d_i2c_driver = {
> +	.driver	 = {
> +		.name   = DRV_NAME,
> +		.owner  = THIS_MODULE,
> +	},
> +	.suspend = lis3lv02d_i2c_suspend,
> +	.shutdown = lis3lv02d_i2c_shutdown,
> +	.resume = lis3lv02d_i2c_resume,
> +	.probe	= lis3lv02d_i2c_probe,
> +	.remove	= __devexit_p(lis3lv02d_i2c_remove),
> +	.id_table = lis3lv02d_id,
> +};
> +
> +static int __init lis3lv02d_init(void)
> +{
> +	return i2c_add_driver(&lis3lv02d_i2c_driver);
> +}
> +
> +static void __exit lis3lv02d_exit(void)
> +{
> +	i2c_del_driver(&lis3lv02d_i2c_driver);
> +}
> +
> +MODULE_AUTHOR("Nokia Corporation");
> +MODULE_DESCRIPTION("lis3lv02d I2C interface");
> +MODULE_LICENSE("GPL");
> +
> +module_init(lis3lv02d_init);
> +module_exit(lis3lv02d_exit);

