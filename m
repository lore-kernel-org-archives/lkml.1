Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbZIGHZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbZIGHZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZIGHZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:25:10 -0400
Received: from centrinvest.ru ([94.25.115.130]:53147 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZIGHZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:25:09 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Mon, 7 Sep 2009 11:25:07 +0400
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] leds: Add WM831x status LED driver
Message-ID: <20090907072507.GA19269@centrinvest.ru>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
References: <1252156161-10062-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 248, 09 05, 2009 at 02:09:21PM +0100, Mark Brown wrote:
> The WM831x devices feature two software controlled status LEDs with
> hardware assisted blinking.
> 
> The device can also autonomously control the LEDs based on a selection
> of sources.  This can be configured at boot time using either platform
> data or the chip OTP.  A sysfs file in the style of that for triggers
> allowing the control source to be configured at run time.  Triggers
> can't be used here since they can't depend on the implementation details
> of a specific LED type.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +static int wm831x_status_probe(struct platform_device *pdev)
> +{
> +	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
> +	struct wm831x_pdata *chip_pdata;
> +	struct wm831x_status_pdata pdata;
> +	struct wm831x_status *drvdata;
> +	struct resource *res;
> +	int id = pdev->id % ARRAY_SIZE(chip_pdata->status);
> +	int ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "No I/O resource\n");
> +		ret = -EINVAL;
> +		goto err;

Why not return -EINVAL right here ?

> +	}
> +
> +	drvdata = kzalloc(sizeof(struct wm831x_status), GFP_KERNEL);
> +	if (!drvdata)
> +		return -ENOMEM;
> +	dev_set_drvdata(&pdev->dev, drvdata);
> +
> +	drvdata->wm831x = wm831x;
> +	drvdata->reg = res->start;
> +
> +	if (wm831x->dev->platform_data)
> +		chip_pdata = wm831x->dev->platform_data;
> +	else
> +		chip_pdata = NULL;
> +
> +	memset(&pdata, 0, sizeof(pdata));
> +	if (chip_pdata && chip_pdata->status[id])
> +		memcpy(&pdata, chip_pdata->status[id], sizeof(pdata));
> +	else
> +		pdata.name = dev_name(&pdev->dev);
> +
> +	mutex_init(&drvdata->mutex);
> +	INIT_WORK(&drvdata->work, wm831x_status_work);
> +	spin_lock_init(&drvdata->value_lock);
> +
> +	/* We cache the configuration register and read startup values
> +	 * from it. */
> +	drvdata->reg_val = wm831x_reg_read(wm831x, drvdata->reg);
> +
> +	if (drvdata->reg_val & WM831X_LED_MODE_MASK)
> +		drvdata->brightness = LED_FULL;
> +	else
> +		drvdata->brightness = LED_OFF;
> +
> +	/* Set a default source if configured, otherwise leave the
> +	 * current hardware setting.
> +	 */
> +	if (pdata.default_src == WM831X_STATUS_PRESERVE) {
> +		drvdata->src = drvdata->reg_val;
> +		drvdata->src &= WM831X_LED_SRC_MASK;
> +		drvdata->src >>= WM831X_LED_SRC_SHIFT;
> +	} else {
> +		drvdata->src = pdata.default_src - 1;
> +	}
> +
> +	drvdata->cdev.name = pdata.name;
> +	drvdata->cdev.default_trigger = pdata.default_trigger;
> +	drvdata->cdev.brightness_set = wm831x_status_set;
> +	drvdata->cdev.blink_set = wm831x_status_blink_set;
> +
> +	ret = led_classdev_register(wm831x->dev, &drvdata->cdev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
> +		goto err_led;
> +	}
> +
> +	ret = device_create_file(drvdata->cdev.dev, &dev_attr_src);
> +	if (ret != 0)
> +		dev_err(&pdev->dev,
> +			"No source control for LED: %d\n", ret);
> +
> +	return 0;
> +
> +err_led:
> +	led_classdev_unregister(&drvdata->cdev);

This line looks useless and possibly unsafe, led device was not registered.
Also this part of code can be removed if you move next line up.

> +	kfree(drvdata);
> +err:
> +	return ret;
> +}
