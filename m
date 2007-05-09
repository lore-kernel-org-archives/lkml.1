Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXEIMOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXEIMOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbXEIMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:14:35 -0400
Received: from tim.rpsys.net ([194.106.48.114]:35842 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbXEIMOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:14:34 -0400
Subject: Re: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
From: Richard Purdie <rpurdie@rpsys.net>
To: kogiidena@eggplant.ddo.jp
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <1638.192.168.1.10.1178710979.squirrel@eggplant.ddo.jp>
References: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp>
	 <1178628407.6061.24.camel@localhost.localdomain>
	 <1638.192.168.1.10.1178710979.squirrel@eggplant.ddo.jp>
Content-Type: text/plain
Date: Wed, 09 May 2007 13:14:21 +0100
Message-Id: <1178712861.6291.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 20:42 +0900, kogiidena wrote:
> >As far as I can tell, the existing timer trigger can do everything the
> >blink trigger can (and more besides).
> I want to blink LED in the initial state.

Are you after to set that per LED or would some standard configurable
default for all LEDs work? 

> Because that of "the existing timer trigger" was impossible, I made "BLINK".
> 
> I thought about another solution.
> Can the change that sets an initial value to delay_on and delay_off be added?

That would be the preferred solution.

> The matter of "Bitshift" is reserved until this case is solved.
> 
> kogiidena
> ---
> diff -urpN OLD/include/linux/leds.h NEW/include/linux/leds.h
> --- OLD/include/linux/leds.h	2007-05-07 12:12:15.000000000 +0900
> +++ NEW/include/linux/leds.h	2007-05-09 19:17:01.000000000 +0900
> @@ -14,6 +14,7 @@
> 
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
> +#include <linux/timer.h>
> 
>  struct device;
>  struct class_device;
> @@ -41,6 +42,7 @@ struct led_classdev {
>  	struct class_device	*class_dev;
>  	struct list_head	 node;			/* LED Device list */
>  	char			*default_trigger;	/* Trigger to use */
> +	void			*default_trigger_data;	/* Trigger to use */
> 
>  #ifdef CONFIG_LEDS_TRIGGERS
>  	/* Protects the trigger data below */
> @@ -110,6 +112,14 @@ extern void ledtrig_ide_activity(void);
>  #define ledtrig_ide_activity() do {} while(0)
>  #endif
> 
> +#ifdef CONFIG_LEDS_TRIGGER_TIMER
> +struct timer_trig_data {
> +	unsigned long delay_on;		/* milliseconds on */
> +	unsigned long delay_off;	/* milliseconds off */
> +	struct timer_list timer;
> +};
> +#endif
> +
>  /* For the leds-gpio driver */
>  struct gpio_led {
>  	const char *name;
> diff -urpN OLD/drivers/leds/ledtrig-timer.c NEW/drivers/leds/ledtrig-timer.c
> --- OLD/drivers/leds/ledtrig-timer.c	2007-04-28 06:49:26.000000000 +0900
> +++ NEW/drivers/leds/ledtrig-timer.c	2007-05-09 19:12:35.000000000 +0900
> @@ -24,12 +24,6 @@
>  #include <linux/leds.h>
>  #include "leds.h"
> 
> -struct timer_trig_data {
> -	unsigned long delay_on;		/* milliseconds on */
> -	unsigned long delay_off;	/* milliseconds off */
> -	struct timer_list timer;
> -};
> -
>  static void led_timer_function(unsigned long data)
>  {
>  	struct led_classdev *led_cdev = (struct led_classdev *) data;
> @@ -124,6 +118,7 @@ static CLASS_DEVICE_ATTR(delay_off, 0644
>  static void timer_trig_activate(struct led_classdev *led_cdev)
>  {
>  	struct timer_trig_data *timer_data;
> +	struct timer_trig_data *def_trig_data = led_cdev->default_trigger_data;
>  	int rc;
> 
>  	timer_data = kzalloc(sizeof(struct timer_trig_data), GFP_KERNEL);
> @@ -143,6 +138,11 @@ static void timer_trig_activate(struct l
>  				&class_device_attr_delay_off);
>  	if (rc) goto err_out_delayon;
> 
> +	if (def_trig_data){
> +		timer_data->delay_on  = def_trig_data->delay_on;
> +		timer_data->delay_off = def_trig_data->delay_off;
> +		mod_timer(&timer_data->timer, jiffies + 1);
> +	}
>  	return;
> 
>  err_out_delayon:

The approach is probably a good idea but you'll have to split struct
timer_list timer from the data structure.

Also, if default_trigger wasn't the timer trigger you have a nice oops
waiting to happen.

Regards,

Richard

