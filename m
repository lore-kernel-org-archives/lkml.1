Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYCYIfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYCYIfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYCYIfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:35:17 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36086 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYCYIfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:35:15 -0400
Date: Tue, 25 Mar 2008 09:35:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/acpi: elide a non-zero test on a result that
 is never 0
In-Reply-To: <1206431411.3047.45.camel@acpi-hp-zz.sh.intel.com>
Message-ID: <Pine.LNX.4.64.0803250931440.22289@ask.diku.dk>
References: <Pine.LNX.4.64.0803241909420.32740@ask.diku.dk>
 <1206431411.3047.45.camel@acpi-hp-zz.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Zhang, Rui wrote:

> 
> On Tue, 2008-03-25 at 02:10 +0800, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The function thermal_cooling_device_register always returns either a
> > valid
> > pointer or a value made with ERR_PTR, so a test for non-zero on the
> > result
> > will always succeed.
> >
> > The problem was found using the following semantic match.
> > (http://www.emn.fr/x-info/coccinelle/)
> > //<smpl>
> > @a@
> > expression E, E1;
> > statement S,S1;
> > position p;
> > @@
> > 
> > E = thermal_cooling_device_register(...)
> > ... when != E = E1
> > if@p (E) S else S1
> > 
> > @n@
> > position a.p;
> > expression E,E1;
> > statement S,S1;
> > @@
> > 
> > E = NULL
> > ... when != E = E1
> > if@p (E) S else S1
> > 
> > @depends on !n@
> > expression E;
> > statement S,S1;
> > position a.p;
> > @@
> > 
> > * if@p (E)
> >   S else S1
> > //</smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> Patch looks correct. Thanks, Julia.
> But it misses the same problem in driver/misc/intel_menlow.c.

I did that one in a separate patch ([PATCH 5/5]), since it is in a 
different directory.

Your patch is certainly more concise, but perhaps it is a little strange 
to put an "else" on an if where the "then" branch ends with a return or 
goto?  That doesn't seem to be done very often anyway.

julia

> And the return value of thermal_zone_device_register is also misused.
> How about this refreshed patch? :)
> 
> 
> Check the return value of thermal zone/cooling device registration correctly.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/fan.c            |    3 +--
>  drivers/acpi/processor_core.c |    3 +--
>  drivers/acpi/thermal.c        |    2 +-
>  drivers/acpi/video.c          |    3 +--
>  drivers/misc/intel_menlow.c   |    4 +---
>  5 files changed, 5 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/fan.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/fan.c
> +++ linux-2.6/drivers/acpi/fan.c
> @@ -259,8 +259,7 @@ static int acpi_fan_add(struct acpi_devi
>  	if (IS_ERR(cdev)) {
>  		result = PTR_ERR(cdev);
>  		goto end;
> -	}
> -	if (cdev) {
> +	} else {
>  		printk(KERN_INFO PREFIX
>  			"%s is registered as cooling_device%d\n",
>  			device->dev.bus_id, cdev->id);
> Index: linux-2.6/drivers/acpi/processor_core.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_core.c
> +++ linux-2.6/drivers/acpi/processor_core.c
> @@ -673,8 +673,7 @@ static int __cpuinit acpi_processor_star
>  	if (IS_ERR(pr->cdev)) {
>  		result = PTR_ERR(pr->cdev);
>  		goto end;
> -	}
> -	if (pr->cdev) {
> +	} else {
>  		printk(KERN_INFO PREFIX
>  			"%s is registered as cooling_device%d\n",
>  			device->dev.bus_id, pr->cdev->id);
> Index: linux-2.6/drivers/acpi/thermal.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/thermal.c
> +++ linux-2.6/drivers/acpi/thermal.c
> @@ -1125,7 +1125,7 @@ static int acpi_thermal_register_thermal
>  			tz->trips.active[i].flags.valid; i++, trips++);
>  	tz->thermal_zone = thermal_zone_device_register("ACPI thermal zone",
>  					trips, tz, &acpi_thermal_zone_ops);
> -	if (!tz->thermal_zone)
> +	if (IS_ERR(tz->thermal_zone))
>  		return -ENODEV;
>  
>  	result = sysfs_create_link(&tz->device->dev.kobj,
> Index: linux-2.6/drivers/acpi/video.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/video.c
> +++ linux-2.6/drivers/acpi/video.c
> @@ -733,8 +733,7 @@ static void acpi_video_device_find_cap(s
>  					device->dev, &video_cooling_ops);
>  		if (IS_ERR(device->cdev))
>  			return;
> -
> -		if (device->cdev) {
> +		else {
>  			printk(KERN_INFO PREFIX
>  				"%s is registered as cooling_device%d\n",
>  				device->dev->dev.bus_id, device->cdev->id);
> Index: linux-2.6/drivers/misc/intel_menlow.c
> ===================================================================
> --- linux-2.6.orig/drivers/misc/intel_menlow.c
> +++ linux-2.6/drivers/misc/intel_menlow.c
> @@ -173,9 +173,7 @@ static int intel_menlow_memory_add(struc
>  	if (IS_ERR(cdev)) {
>  		result = PTR_ERR(cdev);
>  		goto end;
> -	}
> -
> -	if (cdev) {
> +	} else {
>  		acpi_driver_data(device) = cdev;
>  		result = sysfs_create_link(&device->dev.kobj,
>  					&cdev->device.kobj, "thermal_cooling");
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
