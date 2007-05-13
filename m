Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbXEMXQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbXEMXQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbXEMXQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:16:36 -0400
Received: from tim.rpsys.net ([194.106.48.114]:38297 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbXEMXQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:16:35 -0400
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: Richard Purdie <rpurdie@rpsys.net>
To: cbou@mail.ru
Cc: kogiidena@eggplant.ddo.jp, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org
In-Reply-To: <20070509160328.GA13640@zarina>
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp>
	 <1178628889.6061.33.camel@localhost.localdomain>
	 <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp>
	 <1178723594.6291.21.camel@localhost.localdomain>
	 <20070509160328.GA13640@zarina>
Content-Type: text/plain
Date: Mon, 14 May 2007 00:16:22 +0100
Message-Id: <1179098182.5883.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 20:03 +0400, Anton Vorontsov wrote:
> Following patch sitting for a long time in our handhelds.org tree.
> 
> kogiidena, I'm almost sure you'll find it useful, just apply patch,
> and implement .is_led_supported function for your trigger, which will
> eliminate trigger showing in
> /sys/class/leds/LED_WHICH_NOT_SUPPORTS_CUSTOM_TRIGGER/triggers

I like the approach and will apply something like this. Comments
follow...

> Custom triggers support, which are might not supported by all LEDs
>     
> Signed-off-by: Anton Vorontsov <cbou@mail.ru>
> 
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 454fb09..0af0d61 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -53,6 +53,9 @@ ssize_t led_trigger_store(struct class_device *dev, const char *buf,
>  	read_lock(&triggers_list_lock);
>  	list_for_each_entry(trig, &trigger_list, next_trig) {
>  		if (!strcmp(trigger_name, trig->name)) {
> +			if (trig->is_led_supported &&
> +			    !trig->is_led_supported(led_cdev)) break;

Missing newline.

> @@ -85,6 +88,8 @@ ssize_t led_trigger_show(struct class_device *dev, char *buf)
>  		if (led_cdev->trigger && !strcmp(led_cdev->trigger->name,
>  							trig->name))
>  			len += sprintf(buf+len, "[%s] ", trig->name);
> +		else if (trig->is_led_supported &&
> +			 !trig->is_led_supported(led_cdev)) continue;

ditto.

> @@ -127,6 +132,7 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
>  			led_cdev->trigger->deactivate(led_cdev);
>  		led_set_brightness(led_cdev, LED_OFF);
>  	}
> +	led_cdev->trigger = trigger;
>  	if (trigger) {
>  		write_lock_irqsave(&trigger->leddev_list_lock, flags);
>  		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
> @@ -134,7 +140,6 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
>  		if (trigger->activate)
>  			trigger->activate(led_cdev);
>  	}
> -	led_cdev->trigger = trigger;
>  }
>  
>  void led_trigger_set_default(struct led_classdev *led_cdev)

Why was the above was changed?

I think we've discussed this before and it would be better to add a
trigger parameter to activate/deactivate if we really need it. Anyhow,
its not part of this patch and if you want that it should be in a
separate one with accompanying rational.

Can you resend with the above fixed and I'll apply.

Thanks,

Richard


