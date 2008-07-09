Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYGIVY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYGIVY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYGIVYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:24:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:45368 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYGIVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=spEh+/dUJKpaY3ZltzmXi9PFHOzQlzbpMaoeCpdwsO/+zTN6JHQ5RqYAQI1UfejSF0
         CETRHqIh36ki5pyDmjik/UTPcq788E+sWhY1eCE77r2zO8eve7ASX6Lwl6kFFf7bdZMd
         M9do3AG6s6qTmzYY1DEimJ+llkm2MNt/9nqik=
To: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Subject: Re: [RESEND] [PATCH -next 2/2] acpi,rfkill,backlight: comapl-laptop update - use rfkill switch subsystem
Date: Wed, 9 Jul 2008 23:33:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@linux.intel.com, Len Brown <lenb@kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <20080709231059.778d16f4@debian>
In-Reply-To: <20080709231059.778d16f4@debian>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092333.01355.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008, Cezary Jackiewicz wrote:
> From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> 
> Remove unnecessary attributes, use rfkill switch subsystem.

I'm missing a call to rfkill_force_state() to inform the rfkill subsystem that
the key has been toggled. This function should be called when the hardware
has raised the interrupt about the pressed event, or when the function
which polls the register notices the state change.

As the patch works now, it means that the driver will only listen to
events coming from rfkill and it doen't provide any updates itself.

Ivo

> Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> ---
> diff -Nuar a/drivers/misc/compal-laptop.c b/drivers/misc/compal-laptop.c
> --- a/drivers/misc/compal-laptop.c	2008-07-09 21:40:06.000000000 +0200
> +++ b/drivers/misc/compal-laptop.c	2008-07-09 22:54:15.000000000 +0200
> @@ -43,6 +43,7 @@
>  #include <linux/backlight.h>
>  #include <linux/platform_device.h>
>  #include <linux/autoconf.h>
> +#include <linux/rfkill.h>
>  
>  #define COMPAL_DRIVER_VERSION "0.3.0"
>  #define COMPAL_DRIVER_NAME "compal-laptop"
> @@ -58,6 +59,10 @@
>  #define WLAN_MASK	0x01
>  #define BT_MASK		0x02
>  
> +/* rfkill switches */
> +static struct rfkill *bluetooth_rfkill;
> +static struct rfkill *wlan_rfkill;
> +
>  static int force;
>  module_param(force, bool, 0);
>  MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
> @@ -83,67 +88,6 @@
>  	return (int) result;
>  }
>  
> -static int set_wlan_state(int state)
> -{
> -	u8 result, value;
> -
> -	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> -
> -	if ((result & KILLSWITCH_MASK) == 0)
> -		return -EINVAL;
> -	else {
> -		if (state)
> -			value = (u8) (result | WLAN_MASK);
> -		else
> -			value = (u8) (result & ~WLAN_MASK);
> -		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
> -	}
> -
> -	return 0;
> -}
> -
> -static int set_bluetooth_state(int state)
> -{
> -	u8 result, value;
> -
> -	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> -
> -	if ((result & KILLSWITCH_MASK) == 0)
> -		return -EINVAL;
> -	else {
> -		if (state)
> -			value = (u8) (result | BT_MASK);
> -		else
> -			value = (u8) (result & ~BT_MASK);
> -		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
> -	}
> -
> -	return 0;
> -}
> -
> -static int get_wireless_state(int *wlan, int *bluetooth)
> -{
> -	u8 result;
> -
> -	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> -
> -	if (wlan) {
> -		if ((result & KILLSWITCH_MASK) == 0)
> -			*wlan = 0;
> -		else
> -			*wlan = result & WLAN_MASK;
> -	}
> -
> -	if (bluetooth) {
> -		if ((result & KILLSWITCH_MASK) == 0)
> -			*bluetooth = 0;
> -		else
> -			*bluetooth = (result & BT_MASK) >> 1;
> -	}
> -
> -	return 0;
> -}
> -
>  /* Backlight device stuff */
>  
>  static int bl_get_brightness(struct backlight_device *b)
> @@ -166,93 +110,125 @@
>  
>  /* Platform device */
>  
> -static ssize_t show_wlan(struct device *dev,
> -	struct device_attribute *attr, char *buf)
> -{
> -	int ret, enabled;
> +static struct platform_driver compal_driver = {
> +	.driver = {
> +		.name = COMPAL_DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	}
> +};
>  
> -	ret = get_wireless_state(&enabled, NULL);
> -	if (ret < 0)
> -		return ret;
> +static struct platform_device *compal_device;
>  
> -	return sprintf(buf, "%i\n", enabled);
> -}
> +/* rfkill stuff */
>  
> -static ssize_t show_raw(struct device *dev,
> -	struct device_attribute *attr, char *buf)
> +static int wlan_rfk_set(void *data, enum rfkill_state state)
>  {
> -	u8 result;
> +	u8 result, value;
>  
>  	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
>  
> -	return sprintf(buf, "%i\n", result);
> +	switch (state) {
> +	case RFKILL_STATE_UNBLOCKED:
> +		value = (u8) (result | WLAN_MASK);
> +		break;
> +	case RFKILL_STATE_SOFT_BLOCKED:
> +		value = (u8) (result & ~WLAN_MASK);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
> +
> +	return 0;
>  }
>  
> -static ssize_t show_bluetooth(struct device *dev,
> -	struct device_attribute *attr, char *buf)
> +static int wlan_rfk_get(void *data, enum rfkill_state *state)
>  {
> -	int ret, enabled;
> +	u8 result;
> +
> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
>  
> -	ret = get_wireless_state(NULL, &enabled);
> -	if (ret < 0)
> -		return ret;
> +	if ((result & KILLSWITCH_MASK) == 0)
> +		*state = RFKILL_STATE_HARD_BLOCKED;
> +	else
> +		*state = ((result & WLAN_MASK) != 0) ?
> +			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
>  
> -	return sprintf(buf, "%i\n", enabled);
> +	return 0;
>  }
>  
> -static ssize_t store_wlan_state(struct device *dev,
> -	struct device_attribute *attr, const char *buf, size_t count)
> +static int bluetooth_rfk_set(void *data, enum rfkill_state state)
>  {
> -	int state, ret;
> +	u8 result, value;
> +
> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
>  
> -	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
> +	switch (state) {
> +	case RFKILL_STATE_UNBLOCKED:
> +		value = (u8) (result | BT_MASK);
> +		break;
> +	case RFKILL_STATE_SOFT_BLOCKED:
> +		value = (u8) (result & ~BT_MASK);
> +		break;
> +	default:
>  		return -EINVAL;
> +	}
>  
> -	ret = set_wlan_state(state);
> -	if (ret < 0)
> -		return ret;
> +	ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
>  
> -	return count;
> +	return 0;
>  }
>  
> -static ssize_t store_bluetooth_state(struct device *dev,
> -	struct device_attribute *attr, const char *buf, size_t count)
> +static int bluetooth_rfk_get(void *data, enum rfkill_state *state)
>  {
> -	int state, ret;
> +	u8 result;
>  
> -	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
> -		return -EINVAL;
> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
>  
> -	ret = set_bluetooth_state(state);
> -	if (ret < 0)
> -		return ret;
> -
> -	return count;
> -}
> -
> -static DEVICE_ATTR(bluetooth, 0644, show_bluetooth, store_bluetooth_state);
> -static DEVICE_ATTR(wlan, 0644, show_wlan, store_wlan_state);
> -static DEVICE_ATTR(raw, 0444, show_raw, NULL);
> -
> -static struct attribute *compal_attributes[] = {
> -	&dev_attr_bluetooth.attr,
> -	&dev_attr_wlan.attr,
> -	&dev_attr_raw.attr,
> -	NULL
> -};
> +	if ((result & KILLSWITCH_MASK) == 0)
> +		*state = RFKILL_STATE_HARD_BLOCKED;
> +	else
> +		*state = (((result & BT_MASK) >> 1) != 0) ?
> +			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
>  
> -static struct attribute_group compal_attribute_group = {
> -	.attrs = compal_attributes
> -};
> +	return 0;
> +}
>  
> -static struct platform_driver compal_driver = {
> -	.driver = {
> -		.name = COMPAL_DRIVER_NAME,
> -		.owner = THIS_MODULE,
> +static int __init compal_rfkill(struct rfkill **rfk,
> +				const enum rfkill_type rfktype,
> +				const char *name,
> +				int (*toggle_radio)(void *, enum rfkill_state),
> +				int (*get_state)(void *, enum rfkill_state *))
> +{
> +	int res;
> +	enum rfkill_state initial_state;
> +
> +	(*rfk) = rfkill_allocate(&compal_device->dev, rfktype);
> +	if (!*rfk) {
> +		printk(COMPAL_ERR
> +			"failed to allocate memory for rfkill class\n");
> +		return -ENOMEM;
>  	}
> -};
>  
> -static struct platform_device *compal_device;
> +	(*rfk)->name = name;
> +	(*rfk)->get_state = get_state;
> +	(*rfk)->toggle_radio = toggle_radio;
> +	if (!get_state(NULL, &initial_state))
> +		(*rfk)->state = initial_state;
> +
> +	res = rfkill_register(*rfk);
> +	if (res < 0) {
> +		printk(COMPAL_ERR
> +			"failed to register %s rfkill switch: %d\n",
> +			name, res);
> +		rfkill_free(*rfk);
> +		*rfk = NULL;
> +		return res;
> +	}
> +
> +	return 0;
> +}
>  
>  /* Initialization */
>  
> @@ -342,23 +318,28 @@
>  
>  	ret = platform_device_add(compal_device);
>  	if (ret)
> -		goto fail_platform_device1;
> +		goto fail_platform_device;
>  
> -	ret = sysfs_create_group(&compal_device->dev.kobj,
> -		&compal_attribute_group);
> -	if (ret)
> -		goto fail_platform_device2;
> +	/* Register rfkill stuff */
> +
> +	compal_rfkill(&wlan_rfkill,
> +			RFKILL_TYPE_WLAN,
> +			"compal_laptop_wlan_sw",
> +			wlan_rfk_set,
> +			wlan_rfk_get);
> +
> +	compal_rfkill(&bluetooth_rfkill,
> +			RFKILL_TYPE_BLUETOOTH,
> +			"compal_laptop_bluetooth_sw",
> +			bluetooth_rfk_set,
> +			bluetooth_rfk_get);
>  
>  	printk(COMPAL_INFO "driver "COMPAL_DRIVER_VERSION
>  			" successfully loaded.\n");
>  
>  	return 0;
>  
> -fail_platform_device2:
> -
> -	platform_device_del(compal_device);
> -
> -fail_platform_device1:
> +fail_platform_device:
>  
>  	platform_device_put(compal_device);
>  
> @@ -375,8 +356,16 @@
>  
>  static void __exit compal_cleanup(void)
>  {
> +	if (bluetooth_rfkill) {
> +		rfkill_unregister(bluetooth_rfkill);
> +		bluetooth_rfkill = NULL;
> +	}
> +
> +	if (wlan_rfkill) {
> +		rfkill_unregister(wlan_rfkill);
> +		wlan_rfkill = NULL;
> +	}
>  
> -	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
>  	platform_device_unregister(compal_device);
>  	platform_driver_unregister(&compal_driver);
>  	backlight_device_unregister(compalbl_device);
> 


