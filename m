Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZCCTzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZCCTzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZCCTy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:54:59 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:27358 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZCCTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:54:57 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49AD8B0A.90901@tremplin-utc.net>
Date: Tue, 03 Mar 2009 20:54:50 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/5] lis3: solve dependency between core and ACPI
References: <49ABB22F.7040508@tremplin-utc.net> <1236004310-29196-1-git-send-email-daniel@caiaq.de> <1236004310-29196-2-git-send-email-daniel@caiaq.de> <1236004310-29196-3-git-send-email-daniel@caiaq.de> <1236004310-29196-4-git-send-email-daniel@caiaq.de>
In-Reply-To: <1236004310-29196-4-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:
> This solves the dependency between lis3lv02d.[ch] and ACPI specific
> methods. It introduces a ->bus_priv pointer to the device struct which
> is casted to 'struct acpi_device' in the ACIP layer. Changed hp_accel.c
> accordingly.
> 
> This also moves the read_8() and read_16() routines from hp_accel.c to
> lis3lv02d.c as they are not specific to ACPI.
Hello,
I've tried the patch series on my laptop. This particular patch burst
the driver... need some work :-) The values are not read correctly and
the IRQ is not detected. See down in the code...


> @@ -291,23 +284,9 @@ static int lis3lv02d_add(struct acpi_device *device)
>  	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
>  	device->driver_data = &lis3_dev;
>  
> -	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &lis3_dev.whoami);
> -	switch (lis3_dev.whoami) {
> -	case LIS_DOUBLE_ID:
> -		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
> -		lis3_dev.read_data = lis3lv02d_read_16;
> -		lis3_dev.mdps_max_val = 2048;
> -		break;
> -	case LIS_SINGLE_ID:
> -		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
> -		lis3_dev.read_data = lis3lv02d_read_8;
> -		lis3_dev.mdps_max_val = 128;
> -		break;
> -	default:
> -		printk(KERN_ERR DRIVER_NAME
> -			": unknown sensor type 0x%X\n", lis3_dev.whoami);
> -		return -EINVAL;
> -	}
> +	ret = lis3lv02d_init_device(&lis3_dev);
> +	if (ret)
> +		return ret;
>  
>  	/* If possible use a "standard" axes order */
>  	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
> @@ -318,19 +297,16 @@ static int lis3lv02d_add(struct acpi_device *device)
>  
>  	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
>  	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
> -	if (ret)
> -		return ret;
> -
> -	/* obtain IRQ number of our device from ACPI */
> -	lis3lv02d_enum_resources(lis3_dev.device);
> -
> -	ret = lis3lv02d_init_device(&lis3_dev);
>  	if (ret) {
> +		lis3lv02d_joystick_disable();
> +		lis3lv02d_poweroff(&lis3_dev);
>  		flush_work(&hpled_led.work);
> -		led_classdev_unregister(&hpled_led.led_classdev);
>  		return ret;
>  	}
>  
> +	/* obtain IRQ number of our device from ACPI */
> +	lis3lv02d_enum_resources(device);
> +
>  	return ret;
>  }
So now, we first try to set up the IRQ, in lis3lv02d_init_device() and
only after look for a IRQ number with lis3lv02d_enum_resources()... that
doesn't work.

>  
> -static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
> -{
> -	u8 lo, hi;
> -
> -	lis3_dev.read(handle, reg - 1, &lo);
> -	lis3_dev.read(handle, reg, &hi);
> -	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
> -	return (s16)((hi << 8) | lo);
> -}
:
> +static s16 lis3lv02d_read_16(struct lis3lv02d *lis3, int reg)
>  {
>  	u8 lo, hi;
>  
> -	lis3_dev.read(handle, reg, &lo);
> -	lis3_dev.read(handle, reg + 1, &hi);
> +	lis3->read(lis3, reg, &lo);
> +	lis3->read(lis3, reg + 1, &hi);
>  	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
>  	return (s16)((hi << 8) | lo);
>  }
Looking at it I cannot beleive we ended up with two versions of
lis3lv02d_read_16()!
Anyway, you want the logic of the above version, the one with "- 1".

Eric

