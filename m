Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbYHDRaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbYHDRaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYHDRaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:30:02 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:57748 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYHDRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=FIgG0nRGmZQlTNSJvW7GEbMHqS64fivy44dx2GrYFX2uz8yew4uhqYFc0jAECbHxTj
         ooca7iRG2So1DCTbFa9t9ei2VHnSx9jW6LyvXvTuOsYB7s1JJZ4EQgwhrcxJfQAxuPq5
         N39pBA4LOoo+9hERioCH4Q4XTyYW56MR2OGu0=
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] eeepc-laptop: Use standard interfaces
Date: Mon, 4 Aug 2008 19:53:38 +0200
User-Agent: KMail/1.9.9
Cc: corentincj@iksaif.net, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, hmh@hmh.eng.br
References: <20080804170833.GA9513@srcf.ucam.org> <20080804171504.GB9513@srcf.ucam.org>
In-Reply-To: <20080804171504.GB9513@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041953.38829.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008, Matthew Garrett wrote:
> eeepc-laptop currently only sends key events via ACPI and has 
> non-standard rfkill control. Add an input device and use the rfkill 
> infrastructure.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Please use the rfkill_force_state() to report state changes,
that will ensure that the events are immediately send to the
rfkill layer.

Otherwise events will not be reported untill the next get_state() event.

Ivo

> ---
> 
> This attempts to ensure that bluetoth and wlan rfkill devices are only 
> created if the device is prseent, but I don't have a Bluetooth-enabled 
> Eee to hand so I'm not certain it's correct. Testing with rfkill-input 
> shows that the wifi interface works, though.
> 
> commit 0656cf909274db0e59bb570c2bddd242cf075e7f
> Author: Matthew Garrett <mjg59@srcf.ucam.org>
> Date:   Mon Aug 4 18:00:57 2008 +0100
> 
>     Rationalise interfacse
> 
> diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
> index facdb98..ad55e60 100644
> --- a/drivers/misc/eeepc-laptop.c
> +++ b/drivers/misc/eeepc-laptop.c
> @@ -28,6 +28,8 @@
>  #include <acpi/acpi_drivers.h>
>  #include <acpi/acpi_bus.h>
>  #include <linux/uaccess.h>
> +#include <linux/input.h>
> +#include <linux/rfkill.h>
>  
>  #define EEEPC_LAPTOP_VERSION	"0.1"
>  
> @@ -125,6 +127,10 @@ struct eeepc_hotk {
>  					   by this BIOS */
>  	uint init_flag;			/* Init flags */
>  	u16 event_count[128];		/* count for each event */
> +	struct input_dev *inputdev;
> +	u16 *keycode_map;
> +	struct rfkill *eeepc_wlan_rfkill;
> +	struct rfkill *eeepc_bluetooth_rfkill;
>  };
>  
>  /* The actual device the driver binds to */
> @@ -140,6 +146,27 @@ static struct platform_driver platform_driver = {
>  
>  static struct platform_device *platform_device;
>  
> +struct key_entry {
> +	char type;
> +	u8 code;
> +	u16 keycode;
> +};
> +
> +enum { KE_KEY, KE_END };
> +
> +static struct key_entry eeepc_keymap[] = {
> +	/* Sleep already handled via generic ACPI code */
> +	{KE_KEY, 0x10, KEY_WLAN },
> +	{KE_KEY, 0x12, KEY_PROG1 },
> +	{KE_KEY, 0x13, KEY_MUTE },
> +	{KE_KEY, 0x14, KEY_VOLUMEDOWN },
> +	{KE_KEY, 0x15, KEY_VOLUMEUP },
> +	{KE_KEY, 0x30, KEY_SWITCHVIDEOMODE },
> +	{KE_KEY, 0x31, KEY_SWITCHVIDEOMODE },
> +	{KE_KEY, 0x32, KEY_SWITCHVIDEOMODE },
> +	{KE_END, 0},
> +};
> +
>  /*
>   * The hotkey driver declaration
>   */
> @@ -261,6 +288,32 @@ static int update_bl_status(struct backlight_device *bd)
>  }
>  
>  /*
> + * Rfkill helpers
> + */
> +
> +static int eeepc_wlan_rfkill_set(void *data, enum rfkill_state state)
> +{
> +	return set_acpi(CM_ASL_WLAN, state);
> +}
> +
> +static int eeepc_wlan_rfkill_state(void *data, enum rfkill_state *state)
> +{
> +	*state = get_acpi(CM_ASL_WLAN);
> +	return 0;
> +}
> +
> +static int eeepc_bluetooth_rfkill_set(void *data, enum rfkill_state state)
> +{
> +	return set_acpi(CM_ASL_BLUETOOTH, state);
> +}
> +
> +static int eeepc_bluetooth_rfkill_state(void *data, enum rfkill_state *state)
> +{
> +	*state = get_acpi(CM_ASL_BLUETOOTH);
> +	return 0;
> +}
> +
> +/*
>   * Sys helpers
>   */
>  static int parse_arg(const char *buf, unsigned long count, int *val)
> @@ -311,13 +364,11 @@ static ssize_t show_sys_acpi(int cm, char *buf)
>  EEEPC_CREATE_DEVICE_ATTR(camera, CM_ASL_CAMERA);
>  EEEPC_CREATE_DEVICE_ATTR(cardr, CM_ASL_CARDREADER);
>  EEEPC_CREATE_DEVICE_ATTR(disp, CM_ASL_DISPLAYSWITCH);
> -EEEPC_CREATE_DEVICE_ATTR(wlan, CM_ASL_WLAN);
>  
>  static struct attribute *platform_attributes[] = {
>  	&dev_attr_camera.attr,
>  	&dev_attr_cardr.attr,
>  	&dev_attr_disp.attr,
> -	&dev_attr_wlan.attr,
>  	NULL
>  };
>  
> @@ -328,8 +379,64 @@ static struct attribute_group platform_attribute_group = {
>  /*
>   * Hotkey functions
>   */
> +static struct key_entry *eepc_get_entry_by_scancode(int code)
> +{
> +	struct key_entry *key;
> +
> +	for (key = eeepc_keymap; key->type != KE_END; key++)
> +		if (code == key->code)
> +			return key;
> +
> +	return NULL;
> +}
> +
> +static struct key_entry *eepc_get_entry_by_keycode(int code)
> +{
> +	struct key_entry *key;
> +
> +	for (key = eeepc_keymap; key->type != KE_END; key++)
> +		if (code == key->keycode && key->type == KE_KEY)
> +			return key;
> +
> +	return NULL;
> +}
> +
> +static int eeepc_getkeycode(struct input_dev *dev, int scancode, int *keycode)
> +{
> +	struct key_entry *key = eepc_get_entry_by_scancode(scancode);
> +
> +	if (key && key->type == KE_KEY) {
> +		*keycode = key->keycode;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int eeepc_setkeycode(struct input_dev *dev, int scancode, int keycode)
> +{
> +	struct key_entry *key;
> +	int old_keycode;
> +
> +	if (keycode < 0 || keycode > KEY_MAX)
> +		return -EINVAL;
> +
> +	key = eepc_get_entry_by_scancode(scancode);
> +	if (key && key->type == KE_KEY) {
> +		old_keycode = key->keycode;
> +		key->keycode = keycode;
> +		set_bit(keycode, dev->keybit);
> +		if (!eepc_get_entry_by_keycode(old_keycode))
> +			clear_bit(old_keycode, dev->keybit);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  static int eeepc_hotk_check(void)
>  {
> +	const struct key_entry *key;
>  	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>  	int result;
>  
> @@ -356,6 +463,31 @@ static int eeepc_hotk_check(void)
>  			       "Get control methods supported: 0x%x\n",
>  			       ehotk->cm_supported);
>  		}
> +		ehotk->inputdev = input_allocate_device();
> +		if (!ehotk->inputdev) {
> +			printk(EEEPC_INFO "Unable to allocate input device\n");
> +			return 0;
> +		}
> +		ehotk->inputdev->name = "Asus EeePC extra buttons";
> +		ehotk->inputdev->phys = EEEPC_HOTK_FILE "/input0";
> +		ehotk->inputdev->id.bustype = BUS_HOST;
> +		ehotk->inputdev->getkeycode = eeepc_getkeycode;
> +		ehotk->inputdev->setkeycode = eeepc_setkeycode;
> +
> +		for (key = eeepc_keymap; key->type != KE_END; key++) {
> +			switch (key->type) {
> +			case KE_KEY:
> +				set_bit(EV_KEY, ehotk->inputdev->evbit);
> +				set_bit(key->keycode, ehotk->inputdev->keybit);
> +				break;
> +			}
> +		}
> +		result = input_register_device(ehotk->inputdev);
> +		if (result) {
> +			printk(EEEPC_INFO "Unable to register input device\n");
> +			input_free_device(ehotk->inputdev);
> +			return 0;
> +		}
>  	} else {
>  		printk(EEEPC_ERR "Hotkey device not present, aborting\n");
>  		return -EINVAL;
> @@ -363,21 +495,6 @@ static int eeepc_hotk_check(void)
>  	return 0;
>  }
>  
> -static void notify_wlan(u32 *event)
> -{
> -	/* if DISABLE_ASL_WLAN is set, the notify code for fn+f2
> -	   will always be 0x10 */
> -	if (ehotk->cm_supported & (0x1 << CM_ASL_WLAN)) {
> -		const char *method = cm_getv[CM_ASL_WLAN];
> -		int value;
> -		if (read_acpi_int(ehotk->handle, method, &value))
> -			printk(EEEPC_WARNING "Error reading %s\n",
> -			       method);
> -		else if (value == 1)
> -			*event = 0x11;
> -	}
> -}
> -
>  static void notify_brn(void)
>  {
>  	struct backlight_device *bd = eeepc_backlight_device;
> @@ -386,14 +503,28 @@ static void notify_brn(void)
>  
>  static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
>  {
> +	static struct key_entry *key;
>  	if (!ehotk)
>  		return;
> -	if (event == NOTIFY_WLAN_ON && (DISABLE_ASL_WLAN & ehotk->init_flag))
> -		notify_wlan(&event);
>  	if (event >= NOTIFY_BRN_MIN && event <= NOTIFY_BRN_MAX)
>  		notify_brn();
>  	acpi_bus_generate_proc_event(ehotk->device, event,
>  				     ehotk->event_count[event % 128]++);
> +	if (ehotk->inputdev) {
> +		key = eepc_get_entry_by_scancode(event);
> +		if (key) {
> +			switch (key->type) {
> +			case KE_KEY:
> +				input_report_key(ehotk->inputdev, key->keycode,
> +						 1);
> +				input_sync(ehotk->inputdev);
> +				input_report_key(ehotk->inputdev, key->keycode,
> +						 0);
> +				input_sync(ehotk->inputdev);
> +				break;
> +			}
> +		}
> +	}
>  }
>  
>  static int eeepc_hotk_add(struct acpi_device *device)
> @@ -420,6 +551,37 @@ static int eeepc_hotk_add(struct acpi_device *device)
>  					     eeepc_hotk_notify, ehotk);
>  	if (ACPI_FAILURE(status))
>  		printk(EEEPC_ERR "Error installing notify handler\n");
> +
> +	if (get_acpi(CM_ASL_WLAN) != -1) {
> +		ehotk->eeepc_wlan_rfkill = rfkill_allocate(&device->dev,
> +							   RFKILL_TYPE_WLAN);
> +
> +		if (!ehotk->eeepc_wlan_rfkill)
> +			goto end;
> +
> +		ehotk->eeepc_wlan_rfkill->name = "eeepc-wlan";
> +		ehotk->eeepc_wlan_rfkill->toggle_radio = eeepc_wlan_rfkill_set;
> +		ehotk->eeepc_wlan_rfkill->get_state = eeepc_wlan_rfkill_state;
> +		ehotk->eeepc_wlan_rfkill->user_claim_unsupported = 0;
> +		rfkill_register(ehotk->eeepc_wlan_rfkill);
> +	}
> +
> +	if (get_acpi(CM_ASL_BLUETOOTH) != -1) {
> +		ehotk->eeepc_bluetooth_rfkill =
> +			rfkill_allocate(&device->dev, RFKILL_TYPE_BLUETOOTH);
> +
> +		if (!ehotk->eeepc_bluetooth_rfkill)
> +			goto end;
> +
> +		ehotk->eeepc_bluetooth_rfkill->name = "eeepc-bluetooth";
> +		ehotk->eeepc_bluetooth_rfkill->toggle_radio =
> +			eeepc_bluetooth_rfkill_set;
> +		ehotk->eeepc_bluetooth_rfkill->get_state =
> +			eeepc_bluetooth_rfkill_state;
> +		ehotk->eeepc_bluetooth_rfkill->user_claim_unsupported = 0;
> +		rfkill_register(ehotk->eeepc_bluetooth_rfkill);
> +	}
> +
>   end:
>  	if (result) {
>  		kfree(ehotk);
> @@ -543,6 +705,12 @@ static void eeepc_backlight_exit(void)
>  {
>  	if (eeepc_backlight_device)
>  		backlight_device_unregister(eeepc_backlight_device);
> +	if (ehotk->inputdev)
> +		input_unregister_device(ehotk->inputdev);
> +	if (ehotk->eeepc_wlan_rfkill)
> +		rfkill_unregister(ehotk->eeepc_wlan_rfkill);
> +	if (ehotk->eeepc_bluetooth_rfkill)
> +		rfkill_unregister(ehotk->eeepc_bluetooth_rfkill);
>  	eeepc_backlight_device = NULL;
>  }
>  
> 
> 


