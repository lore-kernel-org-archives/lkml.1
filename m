Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXIMVce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXIMVce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbXIMVc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:32:27 -0400
Received: from tim.rpsys.net ([194.106.48.114]:50421 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454AbXIMVc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:32:26 -0400
Subject: Re: [PATCH][1/2] led: add Cobalt Raq LEDs support
From: Richard Purdie <rpurdie@rpsys.net>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070913235441.5bab3d8e.yoichi_yuasa@tripeaks.co.jp>
References: <20070913235441.5bab3d8e.yoichi_yuasa@tripeaks.co.jp>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 22:32:12 +0100
Message-Id: <1189719132.6326.164.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 23:54 +0900, Yoichi Yuasa wrote:
> Add Cobalt Raq LEDs support.
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Not the clearest patch I've ever seen or the most helpful patch
description. The rename could probably be split from the additional new
driver at least...

> diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-raq.c mips/drivers/leds/leds-cobalt-raq.c
> --- mips-orig/drivers/leds/leds-cobalt-raq.c	1970-01-01 09:00:00.000000000 +0900
> +++ mips/drivers/leds/leds-cobalt-raq.c	2007-09-12 12:04:34.021000750 +0900
[...]
> +static void raq_web_led_set(struct led_classdev *led_cdev,
> +                            enum led_brightness brightness)
> +{
> +	spin_lock_irq(&raq_led_lock);
> +
> +	if (brightness)
> +		led_value |= LED_WEB;
> +	else
> +		led_value &= ~LED_WEB;
> +	writeb(led_value, led_port);
> +
> +	spin_unlock_irq(&raq_led_lock);
> +}

The _irq spinlock variants are not safe there or in the other brightness
set function...

+static struct led_classdev raq_web_led = {
> +	.name		= "raq-web-led",
> +	.brightness_set	= raq_web_led_set,
> +};
> +
[...]
> +static struct led_classdev raq_power_off_led = {
> +	.name			= "raq-power-off-led",
> +	.brightness_set		= raq_power_off_led_set,
> +	.default_trigger	= "power-off",
> +};

Do these really need "led" in the name?

What does a power-off trigger do with an LED out of interest?

> +static int __devexit cobalt_raq_led_remove(struct platform_device *pdev)
> +{
> +	if (led_port) {
> +		iounmap(led_port);
> +		led_port = NULL;
> +	}
> +
> +	led_classdev_unregister(&raq_power_off_led);
> +	led_classdev_unregister(&raq_web_led);
> +
> +	return 0;
> +}

You want to unregister, then iounmap...

> +static int __init cobalt_raq_led_init(void)
> +{
> +	return platform_driver_register(&cobalt_raq_led_driver);
> +}
> +
> +module_init(cobalt_raq_led_init);

No module_exit in one driver for any particular reason?

Some of these comments also apply to you second patch. All minor tweaks
really though :).

Cheers,

Richard

