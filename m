Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXCJURa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXCJURa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 15:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbXCJURa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 15:17:30 -0500
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:3728 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932133AbXCJUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 15:17:28 -0500
Date: Sat, 10 Mar 2007 21:15:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
Message-Id: <20070310211550.c694555d.khali@linux-fr.org>
In-Reply-To: <11735324081261-git-send-email-hskinnemoen@atmel.com>
References: <200703091345.44744.david-b@pacbell.net>
	<11735324081261-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

On Sat, 10 Mar 2007 14:13:28 +0100, Haavard Skinnemoen wrote:
> This is a very simple bitbanging i2c bus driver utilizing the new
> arch-neutral GPIO API. Useful for chips that don't have a built-in
> i2c controller, additional i2c busses, or testing purposes.
> 
> To use, include something similar to the following in the
> board-specific setup code:
> 
>   #include <linux/i2c-gpio.h>
> 
>   static struct i2c_gpio_platform_data i2c_gpio_data = {
> 	.sda_pin	= GPIO_PIN_FOO,
> 	.scl_pin	= GPIO_PIN_BAR,
>   };
>   static struct platform_device i2c_gpio_device = {
> 	.name		= "i2c-gpio",
> 	.id		= 0,
> 	.dev		= {
> 		.platform_data	= &i2c_gpio_data,
> 	},
>   };
> 
> Register this platform_device, set up the i2c pins as GPIO if
> required and you're ready to go.

I like the idea very much. Would this let us get rid of i2c-ixp2000?
i2c-ixp4xx? scx200_i2c? Other drivers?

>  drivers/i2c/busses/Kconfig    |    8 ++
>  drivers/i2c/busses/Makefile   |    1 +
>  drivers/i2c/busses/i2c-gpio.c |  211 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c-gpio.h      |   30 ++++++
>  4 files changed, 250 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index fb19dbb..52f79d1 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -102,6 +102,14 @@ config I2C_ELEKTOR
>  	  This support is also available as a module.  If so, the module 
>  	  will be called i2c-elektor.
>  
> +config I2C_GPIO
> +	tristate "GPIO-based bitbanging i2c driver"
> +	depends on I2C && GENERIC_GPIO
> +	select I2C_ALGOBIT
> +	help
> +	  This is a very simple bitbanging i2c driver utilizing the
> +	  arch-neutral GPIO API to control the SCL and SDA lines.
> +
>  config I2C_HYDRA
>  	tristate "CHRP Apple Hydra Mac I/O I2C interface"
>  	depends on I2C && PCI && PPC_CHRP && EXPERIMENTAL
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 290b540..68f2b05 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
>  obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
>  obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
>  obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
> +obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
>  obj-$(CONFIG_I2C_HYDRA)		+= i2c-hydra.o
>  obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
>  obj-$(CONFIG_I2C_I810)		+= i2c-i810.o
> diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
> new file mode 100644
> index 0000000..423db0a
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-gpio.c
> @@ -0,0 +1,211 @@
> +/*
> + * Bitbanging i2c bus driver using the GPIO API
> + *
> + * Copyright (C) 2006 Atmel Corporation

I'm told we're in year 2007 ;)

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/i2c.h>
> +#include <linux/i2c-algo-bit.h>
> +#include <linux/i2c-gpio.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/gpio.h>
> +
> +/* Toggle SDA by changing the direction of the pin */
> +static void i2c_gpio_setsda_dir(void *data, int state)
> +{
> +	struct i2c_gpio_platform_data *pdata = data;
> +
> +	if (state)
> +		gpio_direction_input(pdata->sda_pin);
> +	else {
> +		gpio_direction_output(pdata->sda_pin);
> +		gpio_set_value(pdata->sda_pin, 0);
> +	}
> +}
> +
> +/*
> + * Toggle SDA by changing the output value of the pin. This is only
> + * valid for pins configured as open drain (i.e. setting the value
> + * high effectively turns off the output driver.)
> + */
> +static void i2c_gpio_setsda_val(void *data, int state)
> +{
> +	struct i2c_gpio_platform_data *pdata = data;
> +
> +	gpio_set_value(pdata->sda_pin, state);
> +}
> +
> +/* Toggle SCL by changing the direction of the pin. */
> +static void i2c_gpio_setscl_dir(void *data, int state)
> +{
> +	struct i2c_gpio_platform_data *pdata = data;
> +
> +	if (state)
> +		gpio_direction_input(pdata->scl_pin);
> +	else {
> +		gpio_direction_output(pdata->scl_pin);
> +		gpio_set_value(pdata->scl_pin, 0);
> +	}
> +}
> +
> +/*
> + * Toggle SCL by changing the output value of the pin. This is used
> + * for pins that are configured as open drain and for output-only
> + * pins. The latter case will break the i2c protocol, but it will
> + * often work in practice.
> + */
> +static void i2c_gpio_setscl_val(void *data, int state)
> +{
> +	struct i2c_gpio_platform_data *pdata = data;
> +
> +	gpio_set_value(pdata->scl_pin, state);
> +}
> +
> +int i2c_gpio_getsda(void *data)
> +{
> +	struct i2c_gpio_platform_data *pdata = data;
> +
> +	return gpio_get_value(pdata->sda_pin);
> +}


What value will you get if the SDA pin is open-drain and currently in
output mode? Are such GPIO pins actually able to detect that the pin is
low while they are not themselves driving it low?

> +
> +int i2c_gpio_getscl(void *data)
> +{
> +	struct i2c_gpio_platform_data *pdata = data;
> +
> +	return gpio_get_value(pdata->scl_pin);
> +}
> +
> +static int __init i2c_gpio_probe(struct platform_device *pdev)
> +{
> +	struct i2c_gpio_platform_data *pdata;
> +	struct i2c_algo_bit_data *bit_data;
> +	struct i2c_adapter *adap;
> +	int ret;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata)
> +		return -ENXIO;
> +
> +	ret = -ENOMEM;
> +	adap = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
> +	if (!adap)
> +		goto err_alloc_adap;
> +	bit_data = kzalloc(sizeof(struct i2c_algo_bit_data), GFP_KERNEL);
> +	if (!bit_data)
> +		goto err_alloc_bit_data;
> +
> +	ret = gpio_request(pdata->sda_pin, "sda");
> +	if (ret)
> +		goto err_request_sda;
> +	ret = gpio_request(pdata->scl_pin, "scl");
> +	if (ret)
> +		goto err_request_scl;
> +
> +	if (pdata->sda_is_open_drain) {
> +		gpio_direction_output(pdata->sda_pin);
> +		gpio_set_value(pdata->sda_pin, 1);
> +		bit_data->setsda = i2c_gpio_setsda_val;
> +	} else {
> +		gpio_direction_input(pdata->sda_pin);
> +		bit_data->setsda = i2c_gpio_setsda_dir;
> +	}
> +
> +	if (pdata->scl_is_open_drain || pdata->scl_is_output_only) {
> +		gpio_direction_output(pdata->scl_pin);
> +		gpio_set_value(pdata->scl_pin, 1);
> +		bit_data->setscl = i2c_gpio_setscl_val;
> +	} else {
> +		gpio_direction_input(pdata->scl_pin);
> +		bit_data->setscl = i2c_gpio_setscl_dir;
> +	}
> +
> +	if (!pdata->scl_is_output_only)
> +		bit_data->getscl = i2c_gpio_getscl,
> +
> +	bit_data->getsda	= i2c_gpio_getsda,
> +	bit_data->udelay	= 5,			/* 100 kHz */

Actually, no, i2c-algo-bit has a 1/3-2/3 duty cycle, so a complete
cycle is 3 times the udelay value. So udelay=5 gives you 66 kHz. If
someone wants to fix that...

Also, I wouldn't recommend such a low value when SCL cannot be sensed,
if a slave stretches the line even very briefly, you won't notice and
havoc will ensue. udelay=50 sounds more reasonable for such half-baked
busses.

> +	bit_data->timeout	= HZ / 10,		/* 100 ms */
> +	bit_data->data		= pdata;
> +
> +	adap->owner = THIS_MODULE;
> +	snprintf(adap->name, I2C_NAME_SIZE, "i2c-gpio%d", pdev->id);
> +	adap->algo_data = bit_data;
> +	adap->dev.parent = &pdev->dev;
> +
> +	ret = i2c_bit_add_bus(adap);
> +	if (ret)
> +		goto err_add_bus;
> +
> +	platform_set_drvdata(pdev, adap);
> +
> +	dev_info(&pdev->dev, "using pins %u (sda) and %u (scl%s)\n",
> +		 pdata->sda_pin, pdata->scl_pin,
> +		 pdata->scl_is_output_only
> +		 ? ", no clock stretching" : "");
> +
> +	return 0;
> +
> +err_add_bus:
> +	gpio_free(pdata->scl_pin);
> +err_request_scl:
> +	gpio_free(pdata->sda_pin);
> +err_request_sda:
> +	kfree(bit_data);
> +err_alloc_bit_data:
> +	kfree(adap);
> +err_alloc_adap:
> +	return ret;
> +}
> +
> +static int __exit i2c_gpio_remove(struct platform_device *pdev)
> +{
> +	struct i2c_gpio_platform_data *pdata;
> +	struct i2c_adapter *adap;
> +
> +	adap = platform_get_drvdata(pdev);
> +	pdata = pdev->dev.platform_data;
> +
> +	i2c_del_adapter(adap);
> +	gpio_free(pdata->scl_pin);
> +	gpio_free(pdata->sda_pin);
> +	kfree(adap->algo_data);
> +	kfree(adap);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver i2c_gpio_driver = {
> +	.driver		= {
> +		.name	= "i2c-gpio",
> +		.owner	= THIS_MODULE,
> +	},
> +	.remove		= __exit_p(i2c_gpio_remove),
> +};
> +
> +static int __init i2c_gpio_init(void)
> +{
> +	int ret;
> +
> +	ret = platform_driver_probe(&i2c_gpio_driver, i2c_gpio_probe);
> +	if (ret)
> +		printk("i2c-gpio: probe failed: %d\n", ret);

Add KERN_ERR or similar.

> +
> +	return ret;
> +}
> +module_init(i2c_gpio_init);
> +
> +static void __exit i2c_gpio_exit(void)
> +{
> +	platform_driver_unregister(&i2c_gpio_driver);
> +}
> +module_exit(i2c_gpio_exit);
> +
> +MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_DESCRIPTION("Platform-independent bitbanging i2c driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/i2c-gpio.h b/include/linux/i2c-gpio.h
> new file mode 100644
> index 0000000..1e8fa29
> --- /dev/null
> +++ b/include/linux/i2c-gpio.h
> @@ -0,0 +1,30 @@
> +/*
> + * i2c-gpio interface to platform code
> + *
> + * Copyright (C) 2007 Atmel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _LINUX_I2C_GPIO_H
> +#define _LINUX_I2C_GPIO_H
> +
> +/**
> + * struct i2c_gpio_platform_data - Platform-dependent data for i2c-gpio
> + * @sda_pin: GPIO pin ID to use for SDA
> + * @scl_pin: GPIO pin ID to use for SCL
> + * @sda_is_open_drain: SDA is configured as open drain, i.e. the pin
> + *	isn't actively driven high when setting the output value high.
> + * @scl_is_open_drain: SCL is set up as open drain.
> + * @scl_is_output_only: SCL output drivers cannot be turned off.
> + */
> +struct i2c_gpio_platform_data {
> +	unsigned int sda_pin;
> +	unsigned int scl_pin;
> +	unsigned int sda_is_open_drain:1;
> +	unsigned int scl_is_open_drain:1;
> +	unsigned int scl_is_output_only:1;
> +};
> +
> +#endif /* _LINUX_I2C_GPIO_H */

Would you mind also adding yourself to MAINTAINERS for this driver? I
would appreciate it.

Thanks,
-- 
Jean Delvare
