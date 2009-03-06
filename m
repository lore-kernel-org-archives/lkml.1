Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZCFViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZCFViU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZCFViH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:38:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753964AbZCFViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:38:06 -0500
Date: Fri, 6 Mar 2009 13:37:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, diego.dompe@ridgerun.com,
       jdk@ti.com
Subject: Re: [patch 2.6.29-rc7] leds-gpio: just ignore invalid GPIOs
Message-Id: <20090306133733.9afe1c1c.akpm@linux-foundation.org>
In-Reply-To: <200903051646.44364.david-b@pacbell.net>
References: <200903051646.44364.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009 16:46:44 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Sometimes it's awkward to make sure that the array in the
> platform_data handed to the leds-gpio driver has only valid
> data ... some leds may not be always available, and coping
> with that currently requires patching or rebuilding the array.
> 
> This patch fixes that by making it be OK to pass an invalid
> GPIO (such as "-EINVAL") ... such table entries are skipped.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Tested-by: Diego Dompe <diego.dompe@ridgerun.com>
> ---
> Noted on OMAP3 Beagle board ... one of the three programmable
> LEDs is driven by a twl4030 GPIO, which might not be configured.
> (In fact it's a PWM-capable LED, but the PWM support isn't yet
> available.)
> 
>  drivers/leds/leds-gpio.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -90,13 +90,19 @@ static int gpio_led_probe(struct platfor
>  		cur_led = &pdata->leds[i];
>  		led_dat = &leds_data[i];
>  
> +		/* skip leds that aren't available */
> +		led_dat->gpio = cur_led->gpio;
> +		if (!gpio_is_valid(led_dat->gpio)) {
> +			dev_dbg(&pdev->dev, "skipping %s\n", cur_led->name);
> +			continue;
> +		}
> +
>  		ret = gpio_request(cur_led->gpio, cur_led->name);
>  		if (ret < 0)
>  			goto err;
>  
>  		led_dat->cdev.name = cur_led->name;
>  		led_dat->cdev.default_trigger = cur_led->default_trigger;
> -		led_dat->gpio = cur_led->gpio;
>  		led_dat->can_sleep = gpio_cansleep(cur_led->gpio);
>  		led_dat->active_low = cur_led->active_low;
>  		if (pdata->gpio_blink_set) {
> @@ -125,6 +131,8 @@ static int gpio_led_probe(struct platfor
>  err:
>  	if (i > 0) {
>  		for (i = i - 1; i >= 0; i--) {
> +			if (!gpio_is_valid(leds_data[i].gpio))
> +				continue;
>  			led_classdev_unregister(&leds_data[i].cdev);
>  			cancel_work_sync(&leds_data[i].work);
>  			gpio_free(leds_data[i].gpio);
> @@ -145,6 +153,8 @@ static int __devexit gpio_led_remove(str
>  	leds_data = platform_get_drvdata(pdev);
>  
>  	for (i = 0; i < pdata->num_leds; i++) {
> +		if (!gpio_is_valid(leds_data[i].gpio))
> +			continue;
>  		led_classdev_unregister(&leds_data[i].cdev);
>  		cancel_work_sync(&leds_data[i].work);
>  		gpio_free(leds_data[i].gpio);

All this code has changed a lot in linux.next.  Nothing applies and it
goes beyond my fix-it-up preparedness.


