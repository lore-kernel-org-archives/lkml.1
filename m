Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZHCT4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZHCT4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZHCT4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:56:13 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:55316 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbZHCT4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:56:12 -0400
Subject: Re: [PATCH v4] regulator: Add GPIO enable control to fixed voltage
 regulator driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: broonie@sirena.org.uk, philipp.zabel@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1249319716-17825-1-git-send-email-quadros.roger@gmail.com>
References: <quadros.roger@gmail.com>
	 <1249319716-17825-1-git-send-email-quadros.roger@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 20:32:47 +0100
Message-Id: <1249327967.4248.144.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 20:15 +0300, Roger Quadros wrote:
> From: Roger Quadros <ext-roger.quadros@nokia.com>
> 
> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver for regulator enable/disable control.
> The GPIO number and polarity information is passed through platform data.
> GPIO enable control is achieved using gpiolib.
> 
> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> ---
>  drivers/regulator/fixed.c       |   78 ++++++++++++++++++++++++++++++++++++++-
>  include/linux/regulator/fixed.h |   21 ++++++++++
>  2 files changed, 97 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index cdc674f..6cea02c 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -5,6 +5,9 @@
>   *
>   * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
>   *
> + * Copyright (c) 2009 Nokia Corporation
> + * Roger Quadros <ext-roger.quadros@nokia.com>
> + *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License as
>   * published by the Free Software Foundation; either version 2 of the
> @@ -20,20 +23,45 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/fixed.h>
> +#include <linux/gpio.h>
>  
>  struct fixed_voltage_data {
>  	struct regulator_desc desc;
>  	struct regulator_dev *dev;
>  	int microvolts;
> +	int gpio;
> +	unsigned enable_high:1;
> +	unsigned is_enabled:1;
>  };
>  
>  static int fixed_voltage_is_enabled(struct regulator_dev *dev)
>  {
> -	return 1;
> +	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +	return data->is_enabled;
>  }
>  
>  static int fixed_voltage_enable(struct regulator_dev *dev)
>  {
> +	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +	if (gpio_is_valid(data->gpio)) {
> +		gpio_set_value_cansleep(data->gpio, data->enable_high);
> +		data->is_enabled = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fixed_voltage_disable(struct regulator_dev *dev)
> +{
> +	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +	if (gpio_is_valid(data->gpio)) {
> +		gpio_set_value_cansleep(data->gpio, !data->enable_high);
> +		data->is_enabled = 0;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -58,6 +86,7 @@ static int fixed_voltage_list_voltage(struct regulator_dev *dev,
>  static struct regulator_ops fixed_voltage_ops = {
>  	.is_enabled = fixed_voltage_is_enabled,
>  	.enable = fixed_voltage_enable,
> +	.disable = fixed_voltage_disable,
>  	.get_voltage = fixed_voltage_get_voltage,
>  	.list_voltage = fixed_voltage_list_voltage,
>  };
> @@ -85,12 +114,51 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
>  	drvdata->desc.n_voltages = 1;
>  
>  	drvdata->microvolts = config->microvolts;
> +	drvdata->gpio = config->gpio;
> +
> +	if (gpio_is_valid(config->gpio)) {
> +		drvdata->enable_high = config->enable_high;
> +
> +		/* FIXME: Remove this print warning */

Sorry to nitpick. Please describe the reason for this warning in the
comment and when it will likely be removed. Obvious from email thread
but not by someone looking at code.

Thanks

Liam

