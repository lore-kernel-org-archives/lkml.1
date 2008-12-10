Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYLJQca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYLJQca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYLJQcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:32:22 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:32309 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753642AbYLJQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:32:20 -0500
Date: Wed, 10 Dec 2008 19:32:18 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>, devicetree-discuss@ozlabs.org,
       Grant Likely <grant.likely@secretlab.ca>,
       Sean MacLennan <smaclennan@pikatech.com>
Subject: Re: [PATCH 1/4] leds: Support OpenFirmware led bindings
Message-ID: <20081210163217.GA20150@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1228923703-16370-1-git-send-email-tpiepho@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1228923703-16370-1-git-send-email-tpiepho@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

On Wed, Dec 10, 2008 at 07:41:40AM -0800, Trent Piepho wrote:
> Add bindings to support LEDs defined as of_platform devices in addition to
> the existing bindings for platform devices.
> 
> New options in Kconfig allow the platform binding code and/or the
> of_platform code to be turned on.  The of_platform code is of course only
> available on archs that have OF support.
> 
> The existing probe and remove methods are refactored to use new functions
> create_gpio_led(), to create and register one led, and delete_gpio_led(),
> to unregister and free one led.  The new probe and remove methods for the
> of_platform driver can then share most of the common probe and remove code
> with the platform driver.
> 
> The suspend and resume methods aren't shared, but they are very short.  The
> actual led driving code is the same for LEDs created by either binding.
> 
> The OF bindings are based on patch by Anton Vorontsov
> <avorontsov@ru.mvista.com>.  They have been extended to allow multiple LEDs
> per device.
> 
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Sean MacLennan <smaclennan@pikatech.com>
> CC: devicetree-discuss@ozlabs.org
> ---

Some petty notes below...

[...]  
> -static int gpio_led_probe(struct platform_device *pdev)
> +static int __devinit create_gpio_led(const struct gpio_led *template,
> +	struct gpio_led_data *led_dat, struct device *parent,
> +	int (*blink_set)(unsigned, unsigned long *, unsigned long *))
> +{
> +	int ret;
> +
> +	ret = gpio_request(template->gpio, template->name);
> +	if (ret < 0)
> +		return ret;
> +
> +	led_dat->cdev.name = template->name;
> +	led_dat->cdev.default_trigger = template->default_trigger;
> +	led_dat->gpio = template->gpio;
> +	led_dat->can_sleep = gpio_cansleep(template->gpio);
> +	led_dat->active_low = template->active_low;
> +	if (blink_set) {
> +		led_dat->platform_gpio_blink_set = blink_set;
> +		led_dat->cdev.blink_set = gpio_blink_set;
> +	}
> +	led_dat->cdev.brightness_set = gpio_led_set;
> +	led_dat->cdev.brightness = LED_OFF;
> +
> +	gpio_direction_output(led_dat->gpio, led_dat->active_low);

This can fail (yeah, the original code didn't check return value
either).

> +	INIT_WORK(&led_dat->work, gpio_led_work);
> +
> +	ret = led_classdev_register(parent, &led_dat->cdev);
> +	if (ret < 0)
> +		gpio_free(led_dat->gpio);
> +
> +	return ret;
> +}
[...]
> +static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
> +					const struct of_device_id *match)
> +{
> +	struct device_node *np = ofdev->node, *child;
> +	struct gpio_led led;
> +	struct gpio_led_of_platform_data *pdata;
> +	int count = 0, ret;
> +
> +	/* count LEDs defined by this device, so we know how much to allocate */
> +	for_each_child_of_node(np, child)
> +		count++;
> +	if (!count)
> +		return 0; /* or ENODEV? */
> +
> +	pdata = kzalloc(sizeof(*pdata) + sizeof(struct gpio_led_data) * count,
> +			GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	memset(&led, 0, sizeof(led));
> +	for_each_child_of_node(np, child) {
> +		unsigned int flags;

I think it would be better to use `enum of_gpio_flags' type here,
just for clarity.

> +
> +		led.gpio = of_get_gpio_flags(child, 0, &flags);
> +		led.active_low = flags & OF_GPIO_ACTIVE_LOW;
> +		led.name = of_get_property(child, "label", NULL) ? : child->name;
> +		led.default_trigger =
> +			of_get_property(child, "linux,default-trigger", NULL);
> +
> +		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
> +				      &ofdev->dev, NULL);
> +		if (ret < 0)

of_node_put(np); is missing here.

> +			goto err;
> +	}
> +
> +	dev_set_drvdata(&ofdev->dev, pdata);
> +
> +	return 0;
> +
> +err:
> +	for (count = pdata->num_leds - 2; count >= 0; count--)
> +		delete_gpio_led(&pdata->led_data[count]);
> +
> +	kfree(pdata);
> +
> +	return ret;
> +}
[...]

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
