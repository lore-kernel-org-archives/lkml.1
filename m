Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZLBSX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZLBSX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZLBSX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:23:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61128 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZLBSX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:23:56 -0500
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
In-Reply-To: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 18:23:55 +0000
Message-ID: <1259778235.3588.141.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 18:40 +0100, Antonio Ospite wrote:
> This driver provides an interface for controlling LEDs (or vibrators)
> connected to PMICs for which there is a regulator framework driver.
> 
> This driver can be used, for instance, to control vibrator on all Motorola EZX
> phones using the pcap-regulator driver services.
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Some very minor points below.

> ---
> The patch is against:
> git://git.o-hand.com/linux-rpurdie-leds for-mm
> 
> A doubt I had was about leaving the 'supply' variable configurable from
> platform data, or relying on some fixed value like "vled", but leaving it
> configurable covers the case when we have different regulators used for
> different LEDs or vibrators.
> 
> Should I add a note in Documentation/ about how to use it? Tell me if so.
> 
> Thanks,
>    Antonio
> 
> P.S.: for those who get the mail from LKML, please Cc me on reply.
> 
>  drivers/leds/Kconfig           |    6 +
>  drivers/leds/Makefile          |    1 +
>  drivers/leds/leds-regulator.c  |  214 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/leds-regulator.h |   20 ++++
>  4 files changed, 241 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/leds-regulator.c
>  create mode 100644 include/linux/leds-regulator.h
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index f12a996..8a0e1ec 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -229,6 +229,12 @@ config LEDS_PWM
>  	help
>  	  This option enables support for pwm driven LEDs
>  
> +config LEDS_REGULATOR
> +	tristate "REGULATOR driven LED support"
> +	depends on LEDS_CLASS && REGULATOR
> +	help
> +	  This option enables support for regulator driven LEDs.
> +
>  config LEDS_BD2802
>  	tristate "LED driver for BD2802 RGB LED"
>  	depends on LEDS_CLASS && I2C
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 176f0c6..9e63869 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
>  obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
>  obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
>  obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
> +obj-$(CONFIG_LEDS_REGULATOR)		+= leds-regulator.o
>  obj-$(CONFIG_LEDS_INTEL_SS4200)		+= leds-ss4200.o
>  obj-$(CONFIG_LEDS_LT3593)		+= leds-lt3593.o
>  obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
> diff --git a/drivers/leds/leds-regulator.c b/drivers/leds/leds-regulator.c
> new file mode 100644
> index 0000000..fca5d42
> --- /dev/null
> +++ b/drivers/leds/leds-regulator.c
> @@ -0,0 +1,214 @@
> +/*
> + * leds-regulator.c - LED class driver for regulator driven LEDs.
> + *
> + * Copyright (C) 2009 Antonio Ospite <ospite@studenti.unina.it>
> + *
> + * Inspired by leds-wm8350 driver.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/workqueue.h>
> +#include <linux/leds.h>
> +#include <linux/leds-regulator.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +
> +#define to_regulator_led(led_cdev) \
> +	container_of(led_cdev, struct regulator_led, cdev)
> +
> +struct regulator_led {
> +	struct led_classdev cdev;
> +	enum led_brightness value;
> +	int enabled;
> +	struct mutex mutex;
> +	struct work_struct work;
> +
> +	struct regulator *vcc;
> +};
> +
> +static inline int led_regulator_get_max_brightness(struct regulator *supply)
> +{
> +	return regulator_count_voltages(supply);
> +}
> +
> +static int led_regulator_get_vdd(struct regulator *supply,
> +		enum led_brightness brightness)
> +{
> +	if (brightness == 0)
> +		return 0;
> +
> +	return regulator_list_voltage(supply, brightness - 1);
> +}
> +
> +
> +static void regulator_led_enable(struct regulator_led *led)
> +{
> +	int ret;
> +
> +	if (led->enabled)
> +		return;
> +
> +	ret = regulator_enable(led->vcc);
> +	if (ret != 0) {
> +		dev_err(led->cdev.dev, "Failed to enable vcc: %d\n", ret);
> +		return;
> +	}
> +
> +	led->enabled = 1;
> +}
> +
> +static void regulator_led_disable(struct regulator_led *led)
> +{
> +	int ret;
> +
> +	if (!led->enabled)
> +		return;
> +
> +	ret = regulator_disable(led->vcc);
> +	if (ret != 0) {
> +		dev_err(led->cdev.dev, "Failed to disable vcc: %d\n", ret);
> +		return;
> +	}
> +
> +	led->enabled = 0;
> +}
> +
> +static void led_work(struct work_struct *work)
> +{
> +	struct regulator_led *led;
> +	int voltage;
> +	int ret;
> +
> +	led = container_of(work, struct regulator_led, work);
> +
> +	mutex_lock(&led->mutex);
> +
> +	if (led->value == 0) {

LED_OFF instead of 0 here ?

> +		regulator_led_disable(led);
> +		goto out;
> +	}
> +
> +	voltage = led_regulator_get_vdd(led->vcc, led->value);
> +	dev_dbg(led->cdev.dev, "brightness: %d voltage: %d",
> +			led->value, voltage);
> +
> +	ret = regulator_set_voltage(led->vcc, voltage, voltage);
> +	if (ret != 0)
> +		dev_err(led->cdev.dev, "Failed to set voltage %d: %d\n",
> +			voltage, ret);

Some regulators may not support voltage change (via hw design or
constraints) so set_voltage() will fail. We probably want to handle this
regulator type so we don't call set_voltage().

> +
> +	regulator_led_enable(led);
> +
> +out:
> +	mutex_unlock(&led->mutex);
> +}
> +
> +static void regulator_led_brightness_set(struct led_classdev *led_cdev,
> +			   enum led_brightness value)
> +{
> +	struct regulator_led *led = to_regulator_led(led_cdev);
> +
> +	led->value = value;
> +	schedule_work(&led->work);
> +}
> +
> +static int regulator_led_probe(struct platform_device *pdev)
> +{
> +	struct led_regulator_platform_data *pdata = pdev->dev.platform_data;
> +	struct regulator_led *led;
> +	struct regulator *vcc;
> +	int ret;
> +
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "no platform data\n");
> +		return -ENODEV;
> +	}
> +
> +	vcc = regulator_get(&pdev->dev, pdata->supply);
> +	if (IS_ERR(vcc)) {
> +		dev_err(&pdev->dev, "Cannot get vcc for %s\n", pdata->name);
> +		return PTR_ERR(vcc);;

double ;; here

> +	}
> +
> +	led = kzalloc(sizeof(*led), GFP_KERNEL);
> +	if (led == NULL) {
> +		ret = -ENOMEM;
> +		goto err_vcc;
> +	}
> +
> +	ret = led_regulator_get_max_brightness(vcc);
> +	if (ret < 0)
> +		goto err_led;
> +
> +	led->cdev.max_brightness = ret;
> +
> +	led->cdev.brightness_set = regulator_led_brightness_set;
> +	led->cdev.name = pdata->name;
> +	led->cdev.flags |= LED_CORE_SUSPENDRESUME;
> +	led->enabled = regulator_is_enabled(vcc);
> +	led->vcc = vcc;
> +
> +	mutex_init(&led->mutex);
> +	INIT_WORK(&led->work, led_work);
> +
> +	led->value = LED_OFF;
> +	platform_set_drvdata(pdev, led);
> +
> +	ret = led_classdev_register(&pdev->dev, &led->cdev);
> +	if (ret < 0) {
> +		cancel_work_sync(&led->work);
> +		goto err_led;
> +	}
> +
> +	return 0;
> +
> +err_led:
> +	kfree(led);
> +err_vcc:
> +	regulator_put(vcc);
> +	return ret;
> +}
> +
> +static int regulator_led_remove(struct platform_device *pdev)
> +{
> +	struct regulator_led *led = platform_get_drvdata(pdev);
> +
> +	led_classdev_unregister(&led->cdev);
> +	cancel_work_sync(&led->work);
> +	regulator_led_disable(led);
> +	regulator_put(led->vcc);
> +	kfree(led);
> +	return 0;
> +}
> +
> +static struct platform_driver regulator_led_driver = {
> +	.driver = {
> +		   .name  = "leds-regulator",
> +		   .owner = THIS_MODULE,
> +		   },
> +	.probe  = regulator_led_probe,
> +	.remove = regulator_led_remove,
> +};
> +
> +static int __devinit regulator_led_init(void)
> +{
> +	return platform_driver_register(&regulator_led_driver);
> +}
> +module_init(regulator_led_init);
> +
> +static void regulator_led_exit(void)
> +{
> +	platform_driver_unregister(&regulator_led_driver);
> +}
> +module_exit(regulator_led_exit);
> +
> +MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
> +MODULE_DESCRIPTION("Regulator driven LED driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:leds-regulator");
> diff --git a/include/linux/leds-regulator.h b/include/linux/leds-regulator.h
> new file mode 100644
> index 0000000..a5850fd
> --- /dev/null
> +++ b/include/linux/leds-regulator.h
> @@ -0,0 +1,20 @@
> +/*
> + * leds-regulator.h - platform data structure for regulator driven LEDs.
> + *
> + * Copyright (C) 2009 Antonio Ospite <ospite@studenti.unina.it>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __LINUX_LEDS_REGULATOR_H
> +#define __LINUX_LEDS_REGULATOR_H
> +
> +struct led_regulator_platform_data {
> +	char *name;	/* LED name as expected by LED class */
> +	char *supply;
> +};
> +
> +#endif /* __LINUX_LEDS_REGULATOR_H */


