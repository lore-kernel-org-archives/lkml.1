Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZAMWRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZAMWRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZAMWRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:17:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbZAMWRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:17:30 -0500
Date: Tue, 13 Jan 2009 14:17:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net
Subject: Re: hp_accel: do not call ACPI from invalid context
Message-Id: <20090113141721.ccd90351.akpm@linux-foundation.org>
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
> ...
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

Is this the only LED driver int he current and future history of the
world which uses ACPI?

coz otherwise, this code might better live in LEDs core somewhere, so
those other drivers can use it?

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
> -	.brightness_set		= hpled_set,
> +static struct delayed_led_classdev hpled_led = {
> +	.led_classdev = {
> +		.name			= "hp::hddprotect",
> +		.default_trigger	= "none",
> +		.brightness_set		= delayed_sysfs_set,
> +		.flags                  = LED_CORE_SUSPENDRESUME,
> +	},
> +	.set_brightness = hpled_set,
>  };
>  
>  static int lis3lv02d_add(struct acpi_device *device)
> @@ -208,13 +237,17 @@ static int lis3lv02d_add(struct acpi_dev
>  		adev.ac = lis3lv02d_axis_normal;
>  	}
>  
> -	ret = led_classdev_register(NULL, &hpled_led);
> +	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
> +	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
>  	if (ret)
>  		return ret;
>  
>  	ret = lis3lv02d_init_device(&adev);
>  	if (ret) {
> -		led_classdev_unregister(&hpled_led);
> +		while (work_pending(&hpled_led.work))
> +			schedule();

We have flush_work() for this?

> +	while (work_pending(&hpled_led.work))
> +		schedule();

ditto.
