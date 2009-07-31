Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZGaRDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZGaRDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZGaRD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:03:29 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:38425 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZGaRD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EMiMUBnSWWHc+k4Yb9i16sAerVqfXPVuCNDiJTGJ+VzWCkKrvWd62pUBaplnCs1yOX
         xSzZdmNNrniOOWraiuL+2MlcW5s2LXDh840hK7s6BXXteDc/JFosE1CREYzRSl+7vBeR
         NXjxZ3K9RPzDWQpeBMKVqqnu5CUiNq/Ariw9I=
MIME-Version: 1.0
In-Reply-To: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
Date: Fri, 31 Jul 2009 19:03:28 +0200
Message-ID: <74d0deb30907311003offfc1el7c2a28cdb23cb388@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 6:19 PM, Roger Quadros<quadros.roger@gmail.com> wrote:
> From: Roger Quadros <ext-roger.quadros@nokia.com>
>
> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver. The GPIO number and polarity
> information is passed through platform data. GPIO enable control
> is acheived using gpiolib.
>
> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
>
> ---
>  drivers/regulator/fixed.c       |   66 +++++++++++++++++++++++++++++++++++++-
>  include/linux/regulator/fixed.h |   17 ++++++++++
>  2 files changed, 81 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index cdc674f..bcebb0c 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -20,20 +20,50 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/fixed.h>
> +#include <linux/gpio.h>
>
>  struct fixed_voltage_data {
>        struct regulator_desc desc;
>        struct regulator_dev *dev;
>        int microvolts;
> +       int gpio;
> +       int enable_high;
> +       int is_enabled;
>  };
>
>  static int fixed_voltage_is_enabled(struct regulator_dev *dev)
>  {
> -       return 1;
> +       struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +       if (data->gpio)

if (gpio_is_valid(data->gpio))

> +               return data->is_enabled;
> +       else
> +               return 1;
>  }

Or this function could just unconditionally return data->is_enabled if
you set it to 1 in _probe for gpio-less regulators.

>
>  static int fixed_voltage_enable(struct regulator_dev *dev)
>  {
> +       struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +       if (data->gpio) {

if (gpio_is_valid(data->gpio)) {

> +               gpio_set_value(data->gpio,
> +                               data->enable_high ? 1 : 0);
> +               data->is_enabled = 1;
> +       }
> +
> +       return 0;
> +}
> +
> +static int fixed_voltage_disable(struct regulator_dev *dev)
> +{
> +       struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +       if (data->gpio) {
> +               gpio_set_value(data->gpio,
> +                               data->enable_high ? 0 : 1);
> +               data->is_enabled = 0;
> +       }
> +
>        return 0;
>  }
>
> @@ -58,6 +88,7 @@ static int fixed_voltage_list_voltage(struct regulator_dev *dev,
>  static struct regulator_ops fixed_voltage_ops = {
>        .is_enabled = fixed_voltage_is_enabled,
>        .enable = fixed_voltage_enable,
> +       .disable = fixed_voltage_disable,
>        .get_voltage = fixed_voltage_get_voltage,
>        .list_voltage = fixed_voltage_list_voltage,
>  };
> @@ -85,12 +116,37 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
>        drvdata->desc.n_voltages = 1;
>
>        drvdata->microvolts = config->microvolts;
> +       if (config->gpio) {

That should be more like
    if (gpio_is_valid(config->gpio) && config->gpio) {

People are going to set config->gpio to negative values to disable the gpio.
(And I think eventually GPIO0 should be allowed here.)

> +               drvdata->gpio = config->gpio;
> +               drvdata->enable_high = config->enable_high;
> +
> +               ret = gpio_request(config->gpio,
> +                                       config->supply_name);
> +               if (ret) {
> +                       dev_err(&pdev->dev, "Could not obtain regulator"
> +                               "enable GPIO %d: %d\n", config->gpio, ret);
> +                       goto err_name;
> +               }
> +
> +               /* set output direction without changing state
> +                * to prevent glitch
> +                */
> +               ret = gpio_get_value(config->gpio);
> +               ret = gpio_direction_output(config->gpio, ret);
> +               if (ret) {
> +                       dev_err(&pdev->dev, "Could not configure "
> +                               "enable GPIO %d direction: %d\n",
> +                                               config->gpio, ret);
> +                       goto err_gpio;
> +               }
> +       } else
> +               dev_warn(&pdev->dev, "Not using GPIO 0 for enable control\n");
>
>        drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
>                                          config->init_data, drvdata);
>        if (IS_ERR(drvdata->dev)) {
>                ret = PTR_ERR(drvdata->dev);
> -               goto err_name;
> +               goto err_gpio;
>        }
>
>        platform_set_drvdata(pdev, drvdata);
> @@ -100,6 +156,9 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
>
>        return 0;
>
> +err_gpio:
> +       if (config->gpio)
> +               gpio_free(config->gpio);

gpio_is_valid(config->gpio)

>  err_name:
>        kfree(drvdata->desc.name);
>  err:
> @@ -115,6 +174,9 @@ static int regulator_fixed_voltage_remove(struct platform_device *pdev)
>        kfree(drvdata->desc.name);
>        kfree(drvdata);
>
> +       if (drvdata->gpio)
> +               gpio_free(drvdata->gpio);
> +

dito

>        return 0;
>  }
>
> diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
> index 91b4da3..b40e06b 100644
> --- a/include/linux/regulator/fixed.h
> +++ b/include/linux/regulator/fixed.h
> @@ -16,9 +16,26 @@
>
>  struct regulator_init_data;
>
> +/**
> + * struct fixed_voltage_config - fixed_voltage_config structure
> + * @supply_name:       Name of the regulator supply
> + * @microvolts:                Output voltage of regulator
> + * @use_gpio_control:  Use GPIO enable control
> + * @gpio:              GPIO to use for enable control
> + * @enable_high:       Polarity of enable GPIO
> + *                     1 = Active high, 0 = Active low
> + * @init_data:         regulator_init_data
> + *
> + * This structure contains fixed voltage regulator configuration
> + * information that must be passed by platform code to the fixed
> + * voltage regulator driver.
> + */
>  struct fixed_voltage_config {
>        const char *supply_name;
>        int microvolts;
> +       int use_gpio_control;

You wanted to drop that, it's not used anymore.

> +       int gpio;
> +       int enable_high;
>        struct regulator_init_data *init_data;
>  };
>
> --
> 1.6.0.4
>
>

regards
Philipp
