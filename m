Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbZAMWMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbZAMWMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZAMWLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:11:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbZAMWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:11:50 -0500
Date: Tue, 13 Jan 2009 14:11:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net
Subject: Re: hp_accel: do not call ACPI from invalid context
Message-Id: <20090113141116.6faeada9.akpm@linux-foundation.org>
In-Reply-To: <20090112103155.GA6652@elf.ucw.cz>
References: <20090112103155.GA6652@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 11:31:55 +0100
Pavel Machek <pavel@suse.cz> wrote:

> 
> LED on HP notebooks is connected through ACPI. That unfortunately
> means that it needs to be delayed by using schedule_work() to avoid
> calling ACPI interpretter in invalid context. This patch fixes that.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> ---
> commit 66d8f12491f52e259e42148af099a3fc83425a7b
> tree ea1d77bc228df0ff2ef0d3983fe62fefc8bfb182
> parent 84ef7973b5c6e4f4c5dae03add0a3f37057b61db
> author Pavel <pavel@amd.ucw.cz> Mon, 12 Jan 2009 11:30:08 +0100
> committer Pavel <pavel@amd.ucw.cz> Mon, 12 Jan 2009 11:30:08 +0100
> 
>  drivers/hwmon/hp_accel.c |   71 ++++++++++++++++++++++++++++++++++------------
>  1 files changed, 52 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> index bd8497b..6c3c592 100644
> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -3,7 +3,7 @@
>   *
>   *  Copyright (C) 2007-2008 Yan Burman
>   *  Copyright (C) 2008 Eric Piel
> - *  Copyright (C) 2008 Pavel Machek
> + *  Copyright (C) 2008-2009 Pavel Machek
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License as published by
> @@ -44,6 +44,36 @@ #include "lis3lv02d.h"
>  #define DRIVER_NAME     "lis3lv02d"
>  #define ACPI_MDPS_CLASS "accelerometer"
>  
> +/* Delayed LEDs infrastructure ------------------------------------ */ 
> +
> +/* Special LED class that can defer work */
> +struct delayed_led_classdev {
> +	struct led_classdev led_classdev;
> +	struct work_struct work;
> +	enum led_brightness new_brightness;
> +
> +	unsigned int led;		/* For driver */
> +	void (*set_brightness)(struct delayed_led_classdev *data, enum led_brightness value);
> +};
> +
> +static inline void delayed_set_status_worker(struct work_struct *work)
> +{
> +	struct delayed_led_classdev *data =
> +			container_of(work, struct delayed_led_classdev, work);
> +
> +	data->set_brightness(data, data->new_brightness);
> +}
> +
> +static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
> +			      enum led_brightness brightness)
> +{
> +	struct delayed_led_classdev *data = container_of(led_cdev,
> +			     struct delayed_led_classdev, led_classdev);
> +	data->new_brightness = brightness;
> +	schedule_work(&data->work);
> +}
> +
> +/* HP-specific accelerometer driver ------------------------------------ */ 
>  
>  /* For automatic insertion of the module */
>  static struct acpi_device_id lis3lv02d_device_ids[] = {
> @@ -155,28 +185,27 @@ static struct dmi_system_id lis3lv02d_dm
>   */
>  };
>  
> -static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
> +static void hpled_set(struct delayed_led_classdev *led_cdev, enum led_brightness value)
>  {
> +	acpi_handle handle = adev.device->handle;
>  	unsigned long long ret; /* Not used when writing */
>  	union acpi_object in_obj[1];
>  	struct acpi_object_list args = { 1, in_obj };
>  
>  	in_obj[0].type          = ACPI_TYPE_INTEGER;
> -	in_obj[0].integer.value = reg;
> +	in_obj[0].integer.value = !!value;
>  
> -	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
> +	acpi_evaluate_integer(handle, "ALED", &args, &ret);
>  }
>  
> -static void hpled_set(struct led_classdev *led_cdev,
> -			       enum led_brightness value)
> -{
> -	hpled_acpi_write(adev.device->handle, !!value);
> -}
> -
> -static struct led_classdev hpled_led = {
> -	.name			= "hp:red:hddprotection",
> -	.default_trigger	= "heartbeat",

Current mainline+lis3lv02d-merge-with-leds-hp-disk.patch has "none"
here, so the patch didn't apply.

> -	.brightness_set		= hpled_set,
> +static struct delayed_led_classdev hpled_led = {
> +	.led_classdev = {
> +		.name			= "hp::hddprotect",
> +		.default_trigger	= "none",

But I assume we wanted "none" here anyway, so that's what I'll do.

> +		.brightness_set		= delayed_sysfs_set,
> +		.flags                  = LED_CORE_SUSPENDRESUME,
> +	},
> +	.set_brightness = hpled_set,
>  };
>  

