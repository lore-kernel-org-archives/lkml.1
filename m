Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZIXS17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZIXS17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZIXS16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:27:58 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:51560 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZIXS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:27:57 -0400
Subject: Re: [PATCH 2.6.33] regulator: Implement WM831x BuckWise DC-DC
 convertor DVS support
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1253634431-8260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1253634431-8260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 19:27:56 +0100
Message-Id: <1253816876.11624.891.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 08:47 -0700, Mark Brown wrote:
> The BuckWise DC-DC convertors in WM831x devices support switching to
> a second output voltage using the logic level on one of the device
> pins. This is intended to allow rapid voltage switching for uses like
> cpufreq, replacing the I2C or SPI write used to configure the voltage
> of the regulator with a much faster GPIO status change.
> 
> This is implemented by keeping the DVS voltage configured as the
> maximum voltage permitted for the regulator. If a request is made
> for the maximum voltage then the GPIO is used to switch to the DVS
> voltage, otherwise the normal ON voltage is updated and used. This
> follows the idiom used by most cpufreq drivers, which drop the
> minimum voltage as the core frequency is dropped but use a constant
> maximum - raising the voltage should normally be fast, but lowering
> it may be slower.
> 
> Configuration of the DVS MFP on the device should be done externally,
> for example via OTP.
> 
> Support is present in the hardware for monitoring the status of the
> transition using a second GPIO. This is not currently implemented
> but platform data is provided for it - the driver currently assumes
> that the device will be configured to transition immediately - but
> platform data is provided to reduce merge issues once it is.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm831x-dcdc.c  |  207 ++++++++++++++++++++++++++++++++++----
>  include/linux/mfd/wm831x/pdata.h |   17 +++
>  2 files changed, 206 insertions(+), 18 deletions(-)
> 

Looks good to me.

Samuel, are you ok with the pdata.h change going through regulator ?

Thanks

Liam

> diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
> index 2eefc1a..0a65775 100644
> --- a/drivers/regulator/wm831x-dcdc.c
> +++ b/drivers/regulator/wm831x-dcdc.c
> @@ -19,6 +19,8 @@
>  #include <linux/i2c.h>
>  #include <linux/platform_device.h>
>  #include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +#include <linux/gpio.h>
>  
>  #include <linux/mfd/wm831x/core.h>
>  #include <linux/mfd/wm831x/regulator.h>
> @@ -39,6 +41,7 @@
>  #define WM831X_DCDC_CONTROL_2     1
>  #define WM831X_DCDC_ON_CONFIG     2
>  #define WM831X_DCDC_SLEEP_CONTROL 3
> +#define WM831X_DCDC_DVS_CONTROL   4
>  
>  /*
>   * Shared
> @@ -50,6 +53,10 @@ struct wm831x_dcdc {
>  	int base;
>  	struct wm831x *wm831x;
>  	struct regulator_dev *regulator;
> +	int dvs_gpio;
> +	int dvs_gpio_state;
> +	int on_vsel;
> +	int dvs_vsel;
>  };
>  
>  static int wm831x_dcdc_is_enabled(struct regulator_dev *rdev)
> @@ -240,11 +247,9 @@ static int wm831x_buckv_list_voltage(struct regulator_dev *rdev,
>  	return -EINVAL;
>  }
>  
> -static int wm831x_buckv_set_voltage_int(struct regulator_dev *rdev, int reg,
> -					 int min_uV, int max_uV)
> +static int wm831x_buckv_select_min_voltage(struct regulator_dev *rdev,
> +					   int min_uV, int max_uV)
>  {
> -	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
> -	struct wm831x *wm831x = dcdc->wm831x;
>  	u16 vsel;
>  
>  	if (min_uV < 600000)
> @@ -257,39 +262,126 @@ static int wm831x_buckv_set_voltage_int(struct regulator_dev *rdev, int reg,
>  	if (wm831x_buckv_list_voltage(rdev, vsel) > max_uV)
>  		return -EINVAL;
>  
> -	return wm831x_set_bits(wm831x, reg, WM831X_DC1_ON_VSEL_MASK, vsel);
> +	return vsel;
> +}
> +
> +static int wm831x_buckv_select_max_voltage(struct regulator_dev *rdev,
> +					   int min_uV, int max_uV)
> +{
> +	u16 vsel;
> +
> +	if (max_uV < 600000 || max_uV > 1800000)
> +		return -EINVAL;
> +
> +	vsel = ((max_uV - 600000) / 12500) + 8;
> +
> +	if (wm831x_buckv_list_voltage(rdev, vsel) < min_uV ||
> +	    wm831x_buckv_list_voltage(rdev, vsel) < max_uV)
> +		return -EINVAL;
> +
> +	return vsel;
> +}
> +
> +static int wm831x_buckv_set_dvs(struct regulator_dev *rdev, int state)
> +{
> +	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
> +
> +	if (state == dcdc->dvs_gpio_state)
> +		return 0;
> +
> +	dcdc->dvs_gpio_state = state;
> +	gpio_set_value(dcdc->dvs_gpio, state);
> +
> +	/* Should wait for DVS state change to be asserted if we have
> +	 * a GPIO for it, for now assume the device is configured
> +	 * for the fastest possible transition.
> +	 */
> +
> +	return 0;
>  }
>  
>  static int wm831x_buckv_set_voltage(struct regulator_dev *rdev,
> -				     int min_uV, int max_uV)
> +				    int min_uV, int max_uV)
>  {
>  	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
> -	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
> +	struct wm831x *wm831x = dcdc->wm831x;
> +	int on_reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
> +	int dvs_reg = dcdc->base + WM831X_DCDC_DVS_CONTROL;
> +	int vsel, ret;
> +
> +	vsel = wm831x_buckv_select_min_voltage(rdev, min_uV, max_uV);
> +	if (vsel < 0)
> +		return vsel;
> +
> +	/* If this value is already set then do a GPIO update if we can */
> +	if (dcdc->dvs_gpio && dcdc->on_vsel == vsel)
> +		return wm831x_buckv_set_dvs(rdev, 0);
> +
> +	if (dcdc->dvs_gpio && dcdc->dvs_vsel == vsel)
> +		return wm831x_buckv_set_dvs(rdev, 1);
> +
> +	/* Always set the ON status to the minimum voltage */
> +	ret = wm831x_set_bits(wm831x, on_reg, WM831X_DC1_ON_VSEL_MASK, vsel);
> +	if (ret < 0)
> +		return ret;
> +	dcdc->on_vsel = vsel;
> +
> +	if (!dcdc->dvs_gpio)
> +		return ret;
> +
> +	/* Kick the voltage transition now */
> +	ret = wm831x_buckv_set_dvs(rdev, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Set the high voltage as the DVS voltage.  This is optimised
> +	 * for CPUfreq usage, most processors will keep the maximum
> +	 * voltage constant and lower the minimum with the frequency. */
> +	vsel = wm831x_buckv_select_max_voltage(rdev, min_uV, max_uV);
> +	if (vsel < 0) {
> +		/* This should never happen - at worst the same vsel
> +		 * should be chosen */
> +		WARN_ON(vsel < 0);
> +		return 0;
> +	}
> +
> +	/* Don't bother if it's the same VSEL we're already using */
> +	if (vsel == dcdc->on_vsel)
> +		return 0;
>  
> -	return wm831x_buckv_set_voltage_int(rdev, reg, min_uV, max_uV);
> +	ret = wm831x_set_bits(wm831x, dvs_reg, WM831X_DC1_DVS_VSEL_MASK, vsel);
> +	if (ret == 0)
> +		dcdc->dvs_vsel = vsel;
> +	else
> +		dev_warn(wm831x->dev, "Failed to set DCDC DVS VSEL: %d\n",
> +			 ret);
> +
> +	return 0;
>  }
>  
>  static int wm831x_buckv_set_suspend_voltage(struct regulator_dev *rdev,
> -					     int uV)
> +					    int uV)
>  {
>  	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
> +	struct wm831x *wm831x = dcdc->wm831x;
>  	u16 reg = dcdc->base + WM831X_DCDC_SLEEP_CONTROL;
> +	int vsel;
> +
> +	vsel = wm831x_buckv_select_min_voltage(rdev, uV, uV);
> +	if (vsel < 0)
> +		return vsel;
>  
> -	return wm831x_buckv_set_voltage_int(rdev, reg, uV, uV);
> +	return wm831x_set_bits(wm831x, reg, WM831X_DC1_SLP_VSEL_MASK, vsel);
>  }
>  
>  static int wm831x_buckv_get_voltage(struct regulator_dev *rdev)
>  {
>  	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
> -	struct wm831x *wm831x = dcdc->wm831x;
> -	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
> -	int val;
>  
> -	val = wm831x_reg_read(wm831x, reg);
> -	if (val < 0)
> -		return val;
> -
> -	return wm831x_buckv_list_voltage(rdev, val & WM831X_DC1_ON_VSEL_MASK);
> +	if (dcdc->dvs_gpio && dcdc->dvs_gpio_state)
> +		return wm831x_buckv_list_voltage(rdev, dcdc->dvs_vsel);
> +	else
> +		return wm831x_buckv_list_voltage(rdev, dcdc->on_vsel);
>  }
>  
>  /* Current limit options */
> @@ -346,6 +438,64 @@ static struct regulator_ops wm831x_buckv_ops = {
>  	.set_suspend_mode = wm831x_dcdc_set_suspend_mode,
>  };
>  
> +/*
> + * Set up DVS control.  We just log errors since we can still run
> + * (with reduced performance) if we fail.
> + */
> +static __devinit void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
> +					    struct wm831x_buckv_pdata *pdata)
> +{
> +	struct wm831x *wm831x = dcdc->wm831x;
> +	int ret;
> +	u16 ctrl;
> +
> +	if (!pdata || !pdata->dvs_gpio)
> +		return;
> +
> +	switch (pdata->dvs_control_src) {
> +	case 1:
> +		ctrl = 2 << WM831X_DC1_DVS_SRC_SHIFT;
> +		break;
> +	case 2:
> +		ctrl = 3 << WM831X_DC1_DVS_SRC_SHIFT;
> +		break;
> +	default:
> +		dev_err(wm831x->dev, "Invalid DVS control source %d for %s\n",
> +			pdata->dvs_control_src, dcdc->name);
> +		return;
> +	}
> +
> +	ret = wm831x_set_bits(wm831x, dcdc->base + WM831X_DCDC_DVS_CONTROL,
> +			      WM831X_DC1_DVS_SRC_MASK, ctrl);
> +	if (ret < 0) {
> +		dev_err(wm831x->dev, "Failed to set %s DVS source: %d\n",
> +			dcdc->name, ret);
> +		return;
> +	}
> +
> +	ret = gpio_request(pdata->dvs_gpio, "DCDC DVS");
> +	if (ret < 0) {
> +		dev_err(wm831x->dev, "Failed to get %s DVS GPIO: %d\n",
> +			dcdc->name, ret);
> +		return;
> +	}
> +
> +	/* gpiolib won't let us read the GPIO status so pick the higher
> +	 * of the two existing voltages so we take it as platform data.
> +	 */
> +	dcdc->dvs_gpio_state = pdata->dvs_init_state;
> +
> +	ret = gpio_direction_output(pdata->dvs_gpio, dcdc->dvs_gpio_state);
> +	if (ret < 0) {
> +		dev_err(wm831x->dev, "Failed to enable %s DVS GPIO: %d\n",
> +			dcdc->name, ret);
> +		gpio_free(pdata->dvs_gpio);
> +		return;
> +	}
> +
> +	dcdc->dvs_gpio = pdata->dvs_gpio;
> +}
> +
>  static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
>  {
>  	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
> @@ -384,6 +534,23 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
>  	dcdc->desc.ops = &wm831x_buckv_ops;
>  	dcdc->desc.owner = THIS_MODULE;
>  
> +	ret = wm831x_reg_read(wm831x, dcdc->base + WM831X_DCDC_ON_CONFIG);
> +	if (ret < 0) {
> +		dev_err(wm831x->dev, "Failed to read ON VSEL: %d\n", ret);
> +		goto err;
> +	}
> +	dcdc->on_vsel = ret & WM831X_DC1_ON_VSEL_MASK;
> +
> +	ret = wm831x_reg_read(wm831x, dcdc->base + WM831X_DCDC_ON_CONFIG);
> +	if (ret < 0) {
> +		dev_err(wm831x->dev, "Failed to read DVS VSEL: %d\n", ret);
> +		goto err;
> +	}
> +	dcdc->dvs_vsel = ret & WM831X_DC1_DVS_VSEL_MASK;
> +
> +	if (pdata->dcdc[id])
> +		wm831x_buckv_dvs_init(dcdc, pdata->dcdc[id]->driver_data);
> +
>  	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
>  					     pdata->dcdc[id], dcdc);
>  	if (IS_ERR(dcdc->regulator)) {
> @@ -422,6 +589,8 @@ err_uv:
>  err_regulator:
>  	regulator_unregister(dcdc->regulator);
>  err:
> +	if (dcdc->dvs_gpio)
> +		gpio_free(dcdc->dvs_gpio);
>  	kfree(dcdc);
>  	return ret;
>  }
> @@ -434,6 +603,8 @@ static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
>  	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "HC"), dcdc);
>  	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
>  	regulator_unregister(dcdc->regulator);
> +	if (dcdc->dvs_gpio)
> +		gpio_free(dcdc->dvs_gpio);
>  	kfree(dcdc);
>  
>  	return 0;
> diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
> index 90d8202..318c13a 100644
> --- a/include/linux/mfd/wm831x/pdata.h
> +++ b/include/linux/mfd/wm831x/pdata.h
> @@ -41,6 +41,23 @@ struct wm831x_battery_pdata {
>  	int timeout;        /** Charge cycle timeout, in minutes */
>  };
>  
> +/**
> + * Configuration for the WM831x DC-DC BuckWise convertors.  This
> + * should be passed as driver_data in the regulator_init_data.
> + *
> + * Currently all the configuration is for the fast DVS switching
> + * support of the devices.  This allows MFPs on the device to be
> + * configured as an input to switch between two output voltages,
> + * allowing voltage transitions without the expense of an access over
> + * I2C or SPI buses.
> + */
> +struct wm831x_buckv_pdata {
> +	int dvs_gpio;        /** CPU GPIO to use for DVS switching */
> +	int dvs_control_src; /** Hardware DVS source to use (1 or 2) */
> +	int dvs_init_state;  /** DVS state to expect on startup */
> +	int dvs_state_gpio;  /** CPU GPIO to use for monitoring status */
> +};
> +
>  /* Sources for status LED configuration.  Values are register values
>   * plus 1 to allow for a zero default for preserve.
>   */

