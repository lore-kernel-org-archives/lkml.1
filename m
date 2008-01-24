Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYAXVpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYAXVpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYAXVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:45:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:36663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbYAXVpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:45:04 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
Date: Thu, 24 Jan 2008 16:44:48 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20071226020325.GA21099@srcf.ucam.org>
In-Reply-To: <20071226020325.GA21099@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241644.49114.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 December 2007 21:03, Matthew Garrett wrote:
> The sysfs backlight class provides no mechanism for querying the 
> acceptable brightness for a backlight. The ACPI spec states that values 
> are only valid if they are reported as available by the firmware. Since 
> we can't provide that information to userspace, instead collapse the 
> range to the number of actual values that can be set.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

I wish we did this in the first place.
But doing it now is an API change -- since
with the old way 100 always meant 100% brightness, yes?

so my concern is that if we change what "10" means, somebody like akpm
with an existing script gets grumpy.

-Len

> ---
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 521645e..12b2adb 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -296,18 +296,26 @@ static int acpi_video_device_set_state(struct acpi_video_device *device, int sta
>  static int acpi_video_get_brightness(struct backlight_device *bd)
>  {
>  	unsigned long cur_level;
> +	int i;
>  	struct acpi_video_device *vd =
>  		(struct acpi_video_device *)bl_get_data(bd);
>  	acpi_video_device_lcd_get_level_current(vd, &cur_level);
> -	return (int) cur_level;
> +	for (i=2; i<vd->brightness->count; i++) {
> +		if (vd->brightness->levels[i] == cur_level)
> +			/* The first two entries are special - see page 575
> +			   of the ACPI spec 3.0 */
> +			return i-2;
> +	}
> +	return 0;
>  }
>  
>  static int acpi_video_set_brightness(struct backlight_device *bd)
>  {
> -	int request_level = bd->props.brightness;
> +	int request_level = bd->props.brightness+2;
>  	struct acpi_video_device *vd =
>  		(struct acpi_video_device *)bl_get_data(bd);
> -	acpi_video_device_lcd_set_level(vd, request_level);
> +	acpi_video_device_lcd_set_level(vd, 
> +					vd->brightness->levels[request_level]);
>  	return 0;
>  }
>  
> @@ -656,7 +664,6 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
>  	kfree(obj);
>  
>  	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
> -		unsigned long tmp;
>  		static int count = 0;
>  		char *name;
>  		name = kzalloc(MAX_NAME_LEN, GFP_KERNEL);
> @@ -664,11 +671,10 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
>  			return;
>  
>  		sprintf(name, "acpi_video%d", count++);
> -		acpi_video_device_lcd_get_level_current(device, &tmp);
>  		device->backlight = backlight_device_register(name,
>  			NULL, device, &acpi_backlight_ops);
> -		device->backlight->props.max_brightness = max_level;
> -		device->backlight->props.brightness = (int)tmp;
> +		device->backlight->props.max_brightness = device->brightness->count-3;
> +		device->backlight->props.brightness = acpi_video_get_brightness(device->backlight);
>  		backlight_update_status(device->backlight);
>  
>  		kfree(name);
> 
