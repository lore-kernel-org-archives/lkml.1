Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZG3Hpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZG3Hpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZG3Hpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:45:45 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:43981 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbZG3Hpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:45:44 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907300745.n6U7jc6b000909@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: driver [un]registration fixes
To: bzolnier@gmail.com (Bartlomiej Zolnierkiewicz)
Date: Thu, 30 Jul 2009 17:15:38 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200907292215.33182.bzolnier@gmail.com> from "Bartlomiej Zolnierkiewicz" at Jul 29, 2009 10:15:33 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] fujitsu-laptop: driver [un]registration fixes
> 
> * Move led_classdev_unregister() calls from fujitsu_cleanup() to
>   acpi_fujitsu_hotkey_remove().
> 
> * Fix ordering in fujitsu_cleanup().
> 
> * Fix backlight_device_register() failure handling in fujitsu_init().
> 
> * Add missing sysfs group removal on failure to fujitsu_init().
> 
> * Add input device unregistering on failure to acpi_fujitsu_add()
>   and acpi_fujitsu_hotkey_add().
> 
> * Add input device unregistering/freeing to acpi_fujitsu_remove()
>   and acpi_fujitsu_hotkey_remove() (also remove superfluous 'device'
>   and 'acpi_driver_data(device)' checks while at it).
> 
> * Do few minor cleanups.

Thanks for these - most of these look ok and a few fix some embarrassing
omissions, but a couple of them clash with the other patches being discussed
in other threads.  A consolidated patch will follow in a separate thread for
further discussion.

Regards
  jonathan


> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |   86 ++++++++++++++++------------------
>  1 file changed, 41 insertions(+), 45 deletions(-)
> 
> Index: b/drivers/platform/x86/fujitsu-laptop.c
> ===================================================================
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -691,7 +691,7 @@ static int acpi_fujitsu_add(struct acpi_
>  	result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
>  	if (result) {
>  		printk(KERN_ERR "Error reading power state\n");
> -		goto end;
> +		goto err_unregister_input_dev;
>  	}
>  
>  	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
> @@ -722,22 +722,22 @@ static int acpi_fujitsu_add(struct acpi_
>  
>  	return result;
>  
> -end:
> +err_unregister_input_dev:
> +	input_unregister_device(input);
>  err_free_input_dev:
>  	input_free_device(input);
>  err_stop:
> -
>  	return result;
>  }
>  
>  static int acpi_fujitsu_remove(struct acpi_device *device, int type)
>  {
> -	struct fujitsu_t *fujitsu = NULL;
> +	struct fujitsu_t *fujitsu = acpi_driver_data(device);
> +	struct input_dev *input = fujitsu->input;
>  
> -	if (!device || !acpi_driver_data(device))
> -		return -EINVAL;
> +	input_unregister_device(input);
>  
> -	fujitsu = acpi_driver_data(device);
> +	input_free_device(input);
>  
>  	fujitsu->acpi_handle = NULL;
>  
> @@ -862,7 +862,7 @@ static int acpi_fujitsu_hotkey_add(struc
>  	result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
>  	if (result) {
>  		printk(KERN_ERR "Error reading power state\n");
> -		goto end;
> +		goto err_unregister_input_dev;
>  	}
>  
>  	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
> @@ -902,7 +902,7 @@ static int acpi_fujitsu_hotkey_add(struc
>  	printk(KERN_INFO "fujitsu-laptop: BTNI: [0x%x]\n",
>  		call_fext_func(FUNC_BUTTONS, 0x0, 0x0, 0x0));
>  
> -	#ifdef CONFIG_LEDS_CLASS
> +#ifdef CONFIG_LEDS_CLASS
>  	if (call_fext_func(FUNC_LEDS, 0x0, 0x0, 0x0) & LOGOLAMP_POWERON) {
>  		result = led_classdev_register(&fujitsu->pf_device->dev,
>  						&logolamp_led);
> @@ -925,33 +925,41 @@ static int acpi_fujitsu_hotkey_add(struc
>  			"LED handler for keyboard lamps, error %i\n", result);
>  		}
>  	}
> -	#endif
> +#endif
>  
>  	return result;
>  
> -end:
> +err_unregister_input_dev:
> +	input_unregister_device(input);
>  err_free_input_dev:
>  	input_free_device(input);
>  err_free_fifo:
>  	kfifo_free(fujitsu_hotkey->fifo);
>  err_stop:
> -
>  	return result;
>  }
>  
>  static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
>  {
> -	struct fujitsu_hotkey_t *fujitsu_hotkey = NULL;
> +	struct fujitsu_hotkey_t *fujitsu_hotkey = acpi_driver_data(device);
> +	struct input_dev *input = fujitsu_hotkey->input;
>  
> -	if (!device || !acpi_driver_data(device))
> -		return -EINVAL;
> +#ifdef CONFIG_LEDS_CLASS
> +	if (fujitsu_hotkey->logolamp_registered)
> +		led_classdev_unregister(&logolamp_led);
> +
> +	if (fujitsu_hotkey->kblamps_registered)
> +		led_classdev_unregister(&kblamps_led);
> +#endif
>  
> -	fujitsu_hotkey = acpi_driver_data(device);
> +	input_unregister_device(input);
>  
> -	fujitsu_hotkey->acpi_handle = NULL;
> +	input_free_device(input);
>  
>  	kfifo_free(fujitsu_hotkey->fifo);
>  
> +	fujitsu_hotkey->acpi_handle = NULL;
> +
>  	return 0;
>  }
>  
> @@ -1121,8 +1129,11 @@ static int __init fujitsu_init(void)
>  		fujitsu->bl_device =
>  			backlight_device_register("fujitsu-laptop", NULL, NULL,
>  						  &fujitsubl_ops);
> -		if (IS_ERR(fujitsu->bl_device))
> -			return PTR_ERR(fujitsu->bl_device);
> +		if (IS_ERR(fujitsu->bl_device)) {
> +			ret = PTR_ERR(fujitsu->bl_device);
> +			fujitsu->bl_device = NULL;
> +			goto fail_sysfs_group;
> +		}
>  		max_brightness = fujitsu->max_brightness;
>  		fujitsu->bl_device->props.max_brightness = max_brightness - 1;
>  		fujitsu->bl_device->props.brightness = fujitsu->brightness_level;
> @@ -1162,32 +1173,22 @@ static int __init fujitsu_init(void)
>  	return 0;
>  
>  fail_hotkey1:
> -
>  	kfree(fujitsu_hotkey);
> -
>  fail_hotkey:
> -
>  	platform_driver_unregister(&fujitsupf_driver);
> -
>  fail_backlight:
> -
>  	if (fujitsu->bl_device)
>  		backlight_device_unregister(fujitsu->bl_device);
> -
> +fail_sysfs_group:
> +	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
> +			   &fujitsupf_attribute_group);
>  fail_platform_device2:
> -
>  	platform_device_del(fujitsu->pf_device);
> -
>  fail_platform_device1:
> -
>  	platform_device_put(fujitsu->pf_device);
> -
>  fail_platform_driver:
> -
>  	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
> -
>  fail_acpi:
> -
>  	kfree(fujitsu);
>  
>  	return ret;
> @@ -1195,28 +1196,23 @@ fail_acpi:
>  
>  static void __exit fujitsu_cleanup(void)
>  {
> -	#ifdef CONFIG_LEDS_CLASS
> -	if (fujitsu_hotkey->logolamp_registered != 0)
> -		led_classdev_unregister(&logolamp_led);
> +	acpi_bus_unregister_driver(&acpi_fujitsu_hotkey_driver);
>  
> -	if (fujitsu_hotkey->kblamps_registered != 0)
> -		led_classdev_unregister(&kblamps_led);
> -	#endif
> +	kfree(fujitsu_hotkey);
>  
> -	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
> -			   &fujitsupf_attribute_group);
> -	platform_device_unregister(fujitsu->pf_device);
>  	platform_driver_unregister(&fujitsupf_driver);
> +
>  	if (fujitsu->bl_device)
>  		backlight_device_unregister(fujitsu->bl_device);
>  
> -	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
> +	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
> +			   &fujitsupf_attribute_group);
>  
> -	kfree(fujitsu);
> +	platform_device_unregister(fujitsu->pf_device);
>  
> -	acpi_bus_unregister_driver(&acpi_fujitsu_hotkey_driver);
> +	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
>  
> -	kfree(fujitsu_hotkey);
> +	kfree(fujitsu);
>  
>  	printk(KERN_INFO "fujitsu-laptop: driver unloaded.\n");
>  }
