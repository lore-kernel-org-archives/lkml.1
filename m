Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYGBQ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYGBQ56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYGBQ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:57:48 -0400
Received: from mx1.suse.de ([195.135.220.2]:38543 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYGBQ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:57:47 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 55/84] ACPI: video: fix brightness allocation
Date: Wed, 2 Jul 2008 18:57:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Julia Jomantaite <julia.jomantaite@gmail.com>,
       Len Brown <len.brown@intel.com>, ak@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
References: <1214631868-1715-1-git-send-email-lenb@kernel.org> <985af41a38b76827c1f0692cf18469ebf0c4475b.1214631214.git.len.brown@intel.com>
In-Reply-To: <985af41a38b76827c1f0692cf18469ebf0c4475b.1214631214.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807021857.45814.trenn@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 June 2008 07:43:59 Len Brown wrote:
> From: Julia Jomantaite <julia.jomantaite@gmail.com>
>
> Fix use of uninitialized device->brightness.

Can this one be left out.
I did something similar and put the brightness (and display output) 
initialization into separate functions for bug #9614:
http://bugzilla.kernel.org/show_bug.cgi?id=9614

My patches go a step further and make sure that not several drivers try to do 
the switching.

They probably still need a bit testing and reviewing, but the first one:
Cleanup: Initialize brightness and display switching in separate functions
could replace this one (maybe a small one on top is still needed) already?
This would make things easier for me.

Could these three posted on the bug go into linux-next or into -mm?
Or should I better set up separate [PATCH 0/3] mails?

Thanks,

    Thomas

>
> Signed-off-by: Julia Jomantaite <julia.jomantaite@gmail.com>
> Acked-by: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/video.c |  123
> +++++++++++++++++++++++++++++-------------------- 1 files changed, 73
> insertions(+), 50 deletions(-)
>
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index d089c45..0da8f55 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -631,6 +631,76 @@ acpi_video_bus_DOS(struct acpi_video_bus *video, int
> bios_flag, int lcd_flag) *  	device	: video output device (LCD, CRT, ..)
>   *
>   *  Return Value:
> + *  	Maximum brightness level
> + *
> + *  Allocate and initialize device->brightness.
> + */
> +
> +static int
> +acpi_video_init_brightness(struct acpi_video_device *device)
> +{
> +	union acpi_object *obj = NULL;
> +	int i, max_level = 0, count = 0;
> +	union acpi_object *o;
> +	struct acpi_video_device_brightness *br = NULL;
> +
> +	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available "
> +						"LCD brightness level\n"));
> +		goto out;
> +	}
> +
> +	if (obj->package.count < 2)
> +		goto out;
> +
> +	br = kzalloc(sizeof(*br), GFP_KERNEL);
> +	if (!br) {
> +		printk(KERN_ERR "can't allocate memory\n");
> +		goto out;
> +	}
> +
> +	br->levels = kmalloc(obj->package.count * sizeof *(br->levels),
> +				GFP_KERNEL);
> +	if (!br->levels)
> +		goto out_free;
> +
> +	for (i = 0; i < obj->package.count; i++) {
> +		o = (union acpi_object *)&obj->package.elements[i];
> +		if (o->type != ACPI_TYPE_INTEGER) {
> +			printk(KERN_ERR PREFIX "Invalid data\n");
> +			continue;
> +		}
> +		br->levels[count] = (u32) o->integer.value;
> +
> +		if (br->levels[count] > max_level)
> +			max_level = br->levels[count];
> +		count++;
> +	}
> +
> +	if (count < 2)
> +		goto out_free_levels;
> +
> +	br->count = count;
> +	device->brightness = br;
> +	ACPI_DEBUG_PRINT((ACPI_DB_INFO,	"found %d brightness levels\n",	count));
> +	kfree(obj);
> +	return max_level;
> +
> +out_free_levels:
> +	kfree(br->levels);
> +out_free:
> +	kfree(br);
> +out:
> +	device->brightness = NULL;
> +	kfree(obj);
> +	return 0;
> +}
> +
> +/*
> + *  Arg:
> + *  	device	: video output device (LCD, CRT, ..)
> + *
> + *  Return Value:
>   *  	None
>   *
>   *  Find out all required AML methods defined under the output
> @@ -640,10 +710,7 @@ acpi_video_bus_DOS(struct acpi_video_bus *video, int
> bios_flag, int lcd_flag) static void acpi_video_device_find_cap(struct
> acpi_video_device *device) {
>  	acpi_handle h_dummy1;
> -	int i;
>  	u32 max_level = 0;
> -	union acpi_object *obj = NULL;
> -	struct acpi_video_device_brightness *br = NULL;
>
>
>  	memset(&device->cap, 0, sizeof(device->cap));
> @@ -672,53 +739,7 @@ static void acpi_video_device_find_cap(struct
> acpi_video_device *device) device->cap._DSS = 1;
>  	}
>
> -	if (ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
> -
> -		if (obj->package.count >= 2) {
> -			int count = 0;
> -			union acpi_object *o;
> -
> -			br = kzalloc(sizeof(*br), GFP_KERNEL);
> -			if (!br) {
> -				printk(KERN_ERR "can't allocate memory\n");
> -			} else {
> -				br->levels = kmalloc(obj->package.count *
> -						     sizeof *(br->levels), GFP_KERNEL);
> -				if (!br->levels)
> -					goto out;
> -
> -				for (i = 0; i < obj->package.count; i++) {
> -					o = (union acpi_object *)&obj->package.
> -					    elements[i];
> -					if (o->type != ACPI_TYPE_INTEGER) {
> -						printk(KERN_ERR PREFIX "Invalid data\n");
> -						continue;
> -					}
> -					br->levels[count] = (u32) o->integer.value;
> -
> -					if (br->levels[count] > max_level)
> -						max_level = br->levels[count];
> -					count++;
> -				}
> -			      out:
> -				if (count < 2) {
> -					kfree(br->levels);
> -					kfree(br);
> -				} else {
> -					br->count = count;
> -					device->brightness = br;
> -					ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -							  "found %d brightness levels\n",
> -							  count));
> -				}
> -			}
> -		}
> -
> -	} else {
> -		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available LCD
> brightness level\n")); -	}
> -
> -	kfree(obj);
> +	max_level = acpi_video_init_brightness(device);
>
>  	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level
> > 0){ int result;
> @@ -1695,6 +1716,8 @@ static void
>  acpi_video_switch_brightness(struct acpi_video_device *device, int event)
>  {
>  	unsigned long level_current, level_next;
> +	if (!device->brightness)
> +		return;
>  	acpi_video_device_lcd_get_level_current(device, &level_current);
>  	level_next = acpi_video_get_next_level(device, level_current, event);
>  	acpi_video_device_lcd_set_level(device, level_next);


