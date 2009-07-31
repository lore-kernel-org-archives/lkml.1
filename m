Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZGaRBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZGaRBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZGaRBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:01:05 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61511 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZGaRBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:01:04 -0400
Date: Fri, 31 Jul 2009 20:01:47 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Roger Quadros <quadros.roger@gmail.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "philipp.zabel@gmail.com" <philipp.zabel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage
 regulator driver
Message-ID: <20090731170147.GA11363@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Jul 2009 17:00:59.0873 (UTC) FILETIME=[7A8B4D10:01CA1200]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 06:19:49PM +0200, ext Roger Quadros wrote:
> From: Roger Quadros <ext-roger.quadros@nokia.com>
> 
> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver. The GPIO number and polarity
> information is passed through platform data. GPIO enable control
> is acheived using gpiolib.

little typo here.

> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
> 
> ---
>  drivers/regulator/fixed.c       |   66 +++++++++++++++++++++++++++++++++++++-
>  include/linux/regulator/fixed.h |   17 ++++++++++
>  2 files changed, 81 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index cdc674f..bcebb0c 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -20,20 +20,50 @@
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
> +	int enable_high;
> +	int is_enabled;

how about making these two:

unsigned enable_high:1;
unsigned is_enabled:1;

>  };
>  
>  static int fixed_voltage_is_enabled(struct regulator_dev *dev)
>  {
> -	return 1;
> +	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +	if (data->gpio)
> +		return data->is_enabled;
> +	else
> +		return 1;
>  }
>  
>  static int fixed_voltage_enable(struct regulator_dev *dev)
>  {
> +	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
> +
> +	if (data->gpio) {
> +		gpio_set_value(data->gpio,
> +				data->enable_high ? 1 : 0);

gpio_set_value(data->gpio, data->enable_high);
should be enough, no ?

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
> +	if (data->gpio) {
> +		gpio_set_value(data->gpio,
> +				data->enable_high ? 0 : 1);

gpio_set_value(data->gpio, !data->enable_high); ??

> @@ -85,12 +116,37 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
>  	drvdata->desc.n_voltages = 1;
>  
>  	drvdata->microvolts = config->microvolts;
> +	if (config->gpio) {

gpio_is_valid() since 0 is a valid gpio number.

> +		drvdata->gpio = config->gpio;
> +		drvdata->enable_high = config->enable_high;
> +
> +		ret = gpio_request(config->gpio,
> +					config->supply_name);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Could not obtain regulator"
> +				"enable GPIO %d: %d\n", config->gpio, ret);
> +			goto err_name;
> +		}
> +
> +		/* set output direction without changing state
> +		 * to prevent glitch
> +		 */
> +		ret = gpio_get_value(config->gpio);

and if this fails ??

> +		ret = gpio_direction_output(config->gpio, ret);

you continue anyways...

> +		if (ret) {
> +			dev_err(&pdev->dev, "Could not configure "
> +				"enable GPIO %d direction: %d\n",
> +						config->gpio, ret);
> +			goto err_gpio;
> +		}
> +	} else

this should have brackets.

> +		dev_warn(&pdev->dev, "Not using GPIO 0 for enable control\n");
>  
>  	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
>  					  config->init_data, drvdata);
>  	if (IS_ERR(drvdata->dev)) {
>  		ret = PTR_ERR(drvdata->dev);
> -		goto err_name;
> +		goto err_gpio;
>  	}
>  
>  	platform_set_drvdata(pdev, drvdata);
> @@ -100,6 +156,9 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> +err_gpio:
> +	if (config->gpio)

0 is a valid gpio number, you should initialize everyone using this to
-EINVAL, for example, and use gpio_is_valid()

> +		gpio_free(config->gpio);
>  err_name:
>  	kfree(drvdata->desc.name);
>  err:
> @@ -115,6 +174,9 @@ static int regulator_fixed_voltage_remove(struct platform_device *pdev)
>  	kfree(drvdata->desc.name);
>  	kfree(drvdata);
>  
> +	if (drvdata->gpio)

likewise, use gpio_is_valid()

> +		gpio_free(drvdata->gpio);
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
> index 91b4da3..b40e06b 100644
> --- a/include/linux/regulator/fixed.h
> +++ b/include/linux/regulator/fixed.h
> @@ -16,9 +16,26 @@
>  
>  struct regulator_init_data;
>  
> +/**
> + * struct fixed_voltage_config - fixed_voltage_config structure
> + * @supply_name:	Name of the regulator supply
> + * @microvolts:		Output voltage of regulator
> + * @use_gpio_control:	Use GPIO enable control
> + * @gpio:		GPIO to use for enable control
> + * @enable_high:	Polarity of enable GPIO
> + *			1 = Active high, 0 = Active low
> + * @init_data:		regulator_init_data
> + *
> + * This structure contains fixed voltage regulator configuration
> + * information that must be passed by platform code to the fixed
> + * voltage regulator driver.
> + */
>  struct fixed_voltage_config {
>  	const char *supply_name;
>  	int microvolts;
> +	int use_gpio_control;
> +	int gpio;

put a comment for this field asking people to intialized to -EINVAL if
they're not gonna use it.

> +	int enable_high;

unsigned enable_high:1;

-- 
balbi
