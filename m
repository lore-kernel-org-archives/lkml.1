Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab0CJReN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:34:13 -0500
Received: from zmc.proxad.net ([212.27.53.206]:42881 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab0CJReL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:34:11 -0500
X-Spam-Flag: NO
X-Spam-Score: -3.798
From: Florian Fainelli <ffainelli@freebox.fr>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LEDS: fix race between LED device uevent and actual attributes creation
Date: Wed, 10 Mar 2010 18:32:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-server; KDE/4.3.2; x86_64; ; )
Cc: Richard Purdie <rpurdie@rpsys.net>
References: <201003101511.44770.ffainelli@freebox.fr>
In-Reply-To: <201003101511.44770.ffainelli@freebox.fr>
Organization: Freebox
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003101832.52324.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

For some reason, this version appears to work, while it actually should not 
because device_add_attributes has no mean to stop iterating over 
leds_class_attrs members.

Also, a LED device removal would have made the device attributes be really 
removed in led_classdev_unregister, and then tried to be removed a second time 
by device_remove_attr. Since we never check the return value of 
device_remove_file and the underlying calls which are made to the syfs 
functions, no error is produced, but this is actually wrong.

I just resent a new version which really fix the issue and is cleaner. Sorry 
for the noise.

On Wednesday 10 March 2010 15:11:44  Fainelli wrote:
> If we were to dynamically register/unregister leds and have udev or other
> daemons handle the leds class uevents, we would be notified of the adding
>  of a new LED and if the daemon immediately tries to open one of the
>  attributes of the led device, it would fail with a "no such file or
>  directory" error since the attributes are not yet created. Fix this by
>  switching attributes to be class-wide, such that the driver core will
>  register these attributes with device_add_attrs and then emit the
>  kobject_uevent ADD signal.
> 
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> CC: stable@kernel.org
> ---
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 782f958..0be0310 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -78,6 +78,14 @@ static DEVICE_ATTR(max_brightness, 0444,
>  led_max_brightness_show, NULL); static DEVICE_ATTR(trigger, 0644,
>  led_trigger_show, led_trigger_store); #endif
> 
> +static struct device_attribute *leds_class_attrs[] = {
> +	&dev_attr_brightness,
> +	&dev_attr_max_brightness,
> +#ifdef CONFIG_LEDS_TRIGGERS
> +	&dev_attr_trigger,
> +#endif
> +};
> +
>  /**
>   * led_classdev_suspend - suspend an led_classdev.
>   * @led_cdev: the led_classdev to suspend.
> @@ -127,18 +135,11 @@ static int led_resume(struct device *dev)
>   */
>  int led_classdev_register(struct device *parent, struct led_classdev
>  *led_cdev) {
> -	int rc;
> -
>  	led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
>  				      "%s", led_cdev->name);
>  	if (IS_ERR(led_cdev->dev))
>  		return PTR_ERR(led_cdev->dev);
> 
> -	/* register the attributes */
> -	rc = device_create_file(led_cdev->dev, &dev_attr_brightness);
> -	if (rc)
> -		goto err_out;
> -
>  #ifdef CONFIG_LEDS_TRIGGERS
>  	init_rwsem(&led_cdev->trigger_lock);
>  #endif
> @@ -150,17 +151,9 @@ int led_classdev_register(struct device *parent,
>  struct led_classdev *led_cdev) if (!led_cdev->max_brightness)
>  		led_cdev->max_brightness = LED_FULL;
> 
> -	rc = device_create_file(led_cdev->dev, &dev_attr_max_brightness);
> -	if (rc)
> -		goto err_out_attr_max;
> -
>  	led_update_brightness(led_cdev);
> 
>  #ifdef CONFIG_LEDS_TRIGGERS
> -	rc = device_create_file(led_cdev->dev, &dev_attr_trigger);
> -	if (rc)
> -		goto err_out_led_list;
> -
>  	led_trigger_set_default(led_cdev);
>  #endif
> 
> @@ -168,18 +161,8 @@ int led_classdev_register(struct device *parent,
>  struct led_classdev *led_cdev) led_cdev->name);
> 
>  	return 0;
> -
> -#ifdef CONFIG_LEDS_TRIGGERS
> -err_out_led_list:
> -	device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
> -#endif
> -err_out_attr_max:
> -	device_remove_file(led_cdev->dev, &dev_attr_brightness);
> -	list_del(&led_cdev->node);
> -err_out:
> -	device_unregister(led_cdev->dev);
> -	return rc;
>  }
> +
>  EXPORT_SYMBOL_GPL(led_classdev_register);
> 
>  /**
> @@ -215,6 +198,7 @@ static int __init leds_init(void)
>  		return PTR_ERR(leds_class);
>  	leds_class->suspend = led_suspend;
>  	leds_class->resume = led_resume;
> +	leds_class->dev_attrs = *leds_class_attrs;
>  	return 0;
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

