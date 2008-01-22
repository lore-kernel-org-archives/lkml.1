Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbYAVI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbYAVI2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYAVI2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:28:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:16120 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbYAVI2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:28:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,232,1199692800"; 
   d="scan'208";a="506287832"
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com
In-Reply-To: <20071226020325.GA21099@srcf.ucam.org>
References: <20071226020325.GA21099@srcf.ucam.org>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 16:33:29 +0800
Message-Id: <1200990809.7424.31.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-26 at 02:03 +0000, Matthew Garrett wrote:
> The sysfs backlight class provides no mechanism for querying the 
> acceptable brightness for a backlight. The ACPI spec states that values 
> are only valid if they are reported as available by the firmware. Since 
> we can't provide that information to userspace, instead collapse the 
> range to the number of actual values that can be set.
> 
There is another patch which round the bd->props.brightness to the
nearest but larger acceptable brightness level.
Please refer to http://bugzilla.kernel.org/show_bug.cgi?id=9277

I have no obvious objection on either of these two proposals.
But one thing to mention is that
both of these two patches is written on the assumption that the
brightness levels listed in _BCL method are in ascending order, while
this is not stated in the ACPI spec.
Is this a problem?

Thanks,
Rui

> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> 
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

