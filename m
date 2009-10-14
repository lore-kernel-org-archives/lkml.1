Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbZJNW0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbZJNW0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932701AbZJNW0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:26:06 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:65014 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbZJNW0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:26:05 -0400
Subject: Re: [PATCH] LED: add driver for LT3593 controlled LEDs
From: Richard Purdie <rpurdie@rpsys.net>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1254865260-13570-1-git-send-email-daniel@caiaq.de>
References: <1254865260-13570-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 19:13:21 +0100
Message-Id: <1255544001.14634.8.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 05:41 +0800, Daniel Mack wrote:
> The LT3593 is a step-up DC/DC converter designed to drive up to ten
> white LEDs in series. The current flow can be set with a control pin.
> 
> This driver controls any number of such devices connected on generic
> GPIOs and exports the function as as platform_driver.
> 
> The gpio_led platform data struct definition is reused for this purpose.
> 
> Successfully tested on a PXA embedded board.

Looks good to me, just some minor comments:

> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/leds.h>
> +#include <linux/workqueue.h>
> +#include <linux/delay.h>
> +
> +#include <asm/gpio.h>

Should this be <linux/gpio.h> ?

> +static void lt3593_led_work(struct work_struct *work)
> +{
> +	int pulses;
> +	struct lt3593_led_data	*led_dat =
> +		container_of(work, struct lt3593_led_data, work);

There's a tab above which caught my eye. I'd have ignored it if I wasn't
mentioning the above...

> +	pulses = 32 - (led_dat->new_level * 32) / 255;
> +
> +	if (pulses == 0) {
> +		gpio_set_value_cansleep(led_dat->gpio, 0);
> +		mdelay(1);
> +		gpio_set_value_cansleep(led_dat->gpio, 1);
> +		return;
> +	}

mdelay is frowned upon

> +	gpio_set_value_cansleep(led_dat->gpio, 1);
> +
> +	while (pulses--) {
> +		gpio_set_value_cansleep(led_dat->gpio, 0);
> +		udelay(1);
> +		gpio_set_value_cansleep(led_dat->gpio, 1);
> +		udelay(1);
> +	}

and likewise udelay but I guess we can't do much else with this
hardware...

Otherwise it looks good, just check the include please and then I'll
apply it.

Cheers,

Richard

