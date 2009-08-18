Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbZHRBYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbZHRBYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 21:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZHRBYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 21:24:36 -0400
Received: from senator.holtmann.net ([87.106.208.187]:45756 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZHRBYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 21:24:35 -0400
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Marcel Holtmann <marcel@holtmann.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: cezary.jackiewicz@gmail.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A89E768.7010207@dell.com>
References: <4A89E768.7010207@dell.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 18:24:03 -0700
Message-Id: <1250558643.30166.109.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mario,

the general rule for patches on LKML is that you send them inline and
not as attachment. A successful workaround for the ones with Exchange
only mail account is to use git send-email.

> --- drivers/platform/x86/compal-laptop.c.old    2009-08-17
> 07:01:36.244874430 -0500
> +++ drivers/platform/x86/compal-laptop.c        2009-08-17
> 07:02:15.012836625 -0500
> @@ -52,6 +52,7 @@
>  #include <linux/backlight.h>
>  #include <linux/platform_device.h>
>  #include <linux/autoconf.h>
> +#include <linux/rfkill.h>
>  
>  #define COMPAL_DRIVER_VERSION "0.2.6"
>  
> @@ -64,6 +65,9 @@
>  #define WLAN_MASK      0x01
>  #define BT_MASK        0x02
>  
> +static struct rfkill *wifi_rfkill;
> +static struct rfkill *bluetooth_rfkill;
> +
>  static int force;
>  module_param(force, bool, 0);
>  MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
> @@ -89,6 +93,87 @@
>         return (int) result;
>  }
>  
> +static void compal_rfkill_query(struct rfkill *rfkill, void *data)
> +{
> +       unsigned long radio = (unsigned long) data;
> +       u8 result;
> +       bool blocked;
> +
> +       ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> +
> +       if ((result & KILLSWITCH_MASK) == 0)
> +               blocked = 1;
> +        else if (radio == WLAN_MASK)
> +               blocked = !(result & WLAN_MASK);

You are using spaces instead of tabs here.

> +       else
> +               blocked = !((result & BT_MASK) >> 1);
> +
> +       rfkill_set_sw_state(rfkill,blocked);
> +       rfkill_set_hw_state(rfkill,0);
> +}
> +
> +static int compal_rfkill_set(void *data, bool blocked)
> +{
> +       unsigned long radio = (unsigned long) data;
> +       u8 result, value;
> +
> +       ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> +
> +       if ((result & KILLSWITCH_MASK) == 0)
> +               return -EINVAL;
> +       else {
> +               if (!blocked)
> +                       value = (u8) (result | radio);
> +               else
> +                       value = (u8) (result & ~radio);
> +               ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
> +       }

This else part is utterly stupid. There is no need to have an else
statement. You already left the function. So get rid of it. And at the
same time this code becomes readable.

> +       return 0;
> +}
> +
> +static const struct rfkill_ops compal_rfkill_ops = {
> +       .set_block = compal_rfkill_set,
> +       .query = compal_rfkill_query,
> +};
> +
> +static int setup_rfkill(void)
> +{
> +       int ret;
> +
> +       wifi_rfkill = rfkill_alloc("compal-wifi", NULL,
> RFKILL_TYPE_WLAN,
> +                                       &compal_rfkill_ops, (void *)
> WLAN_MASK);
> +       if (!wifi_rfkill) {
> +               ret = -ENOMEM;
> +               goto err_wifi;
> +       }
> +       ret = rfkill_register(wifi_rfkill);
> +       if (ret)
> +               goto err_wifi;
> +
> +       bluetooth_rfkill = rfkill_alloc("compal-bluetooth", NULL,
> RFKILL_TYPE_BLUETOOTH,
> +                                       &compal_rfkill_ops, (void *)
> BT_MASK);
> +       if (!bluetooth_rfkill) {
> +               ret = -ENOMEM;
> +               goto err_bt;
> +       }
> +       ret = rfkill_register(bluetooth_rfkill);
> +       if (ret)
> +               goto err_bt;
> +
> +       return 0;
> +err_bt:
> +       rfkill_destroy(bluetooth_rfkill);
> +       if (bluetooth_rfkill)
> +               rfkill_unregister(bluetooth_rfkill);
> +err_wifi:
> +       rfkill_destroy(wifi_rfkill);
> +       if (wifi_rfkill)
> +               rfkill_unregister(wifi_rfkill);

I don't understand how this is not a potential NULL pointer dereference.
There might some good luck that the pointer is still valid at that time,
but I highly doubt it. So please unregister before destory.

> +
> +       return ret;
> +}
> +
>  static int set_wlan_state(int state)
>  {
>         u8 result, value;
> @@ -357,6 +442,12 @@
>         if (!force && !dmi_check_system(compal_dmi_table))
>                 return -ENODEV;
>  
> +       ret = setup_rfkill();
> +       if (ret) {
> +               printk(KERN_WARNING "compal-laptop: Unable to setup
> rfkill\n");
> +               goto fail_rfkill;
> +       }
> +
>         /* Register backlight stuff */
>  
>         if (!acpi_video_backlight_support()) {
> @@ -410,6 +501,13 @@
>  
>         backlight_device_unregister(compalbl_device);
>  
> +fail_rfkill:
> +
> +       if (wifi_rfkill)
> +               rfkill_unregister(wifi_rfkill);
> +       if (bluetooth_rfkill)
> +               rfkill_unregister(bluetooth_rfkill);
> +

What non-sense is this. If setup_rfkill() fails, then both RFKILL
switches got unregistered if they ever have been registered.

>         return ret;
>  }
>  
> @@ -420,6 +518,10 @@
>         platform_device_unregister(compal_device);
>         platform_driver_unregister(&compal_driver);
>         backlight_device_unregister(compalbl_device);
> +       if (wifi_rfkill)
> +               rfkill_unregister(wifi_rfkill);
> +       if (bluetooth_rfkill)
> +               rfkill_unregister(bluetooth_rfkill);

Same here. It should never ever succeeded in the first place. You can
call it conditionally.

>  
>         printk(KERN_INFO "compal-laptop: driver unloaded.\n");
>  }
> 

Regards

Marcel


