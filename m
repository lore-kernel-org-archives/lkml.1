Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYCYIvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYCYIvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYCYIvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:51:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:45796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYCYIvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,551,1199692800"; 
   d="scan'208";a="539499522"
Subject: Re: [PATCH 4/5] drivers/acpi: elide a non-zero test on a result
	that is never 0
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0803241909420.32740@ask.diku.dk>
References: <Pine.LNX.4.64.0803241909420.32740@ask.diku.dk>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 16:31:21 +0800
Message-Id: <1206433881.3047.51.camel@acpi-hp-zz.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-25 at 02:10 +0800, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The function thermal_cooling_device_register always returns either a
> valid
> pointer or a value made with ERR_PTR, so a test for non-zero on the
> result
> will always succeed.
> 
> 
> The problem was found using the following semantic match.
> (http://www.emn.fr/x-info/coccinelle/)
> 
> //<smpl>
> @a@
> expression E, E1;
> statement S,S1;
> position p;
> @@
> 
> E = thermal_cooling_device_register(...)
> ... when != E = E1
> if@p (E) S else S1
> 
> @n@
> position a.p;
> expression E,E1;
> statement S,S1;
> @@
> 
> E = NULL
> ... when != E = E1
> if@p (E) S else S1
> 
> @depends on !n@
> expression E;
> statement S,S1;
> position a.p;
> @@
> 
> * if@p (E)
>   S else S1
> //</smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/fan.c            |   34
> ++++++++++++++++------------------
>  drivers/acpi/processor_core.c |   30 ++++++++++++++----------------
>  drivers/acpi/video.c          |   28 +++++++++++++---------------
>  3 files changed, 43 insertions(+), 49 deletions(-)
> 
> diff -u -p a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> --- a/drivers/acpi/fan.c        2008-03-12 14:13:13.000000000 +0100
> +++ b/drivers/acpi/fan.c        2008-03-24 16:14:50.000000000 +0100
> @@ -260,24 +260,22 @@ static int acpi_fan_add(struct acpi_devi
>                 result = PTR_ERR(cdev);
>                 goto end;
>         }
> -       if (cdev) {
> -               printk(KERN_INFO PREFIX
> -                       "%s is registered as cooling_device%d\n",
> -                       device->dev.bus_id, cdev->id);
> -
> -               acpi_driver_data(device) = cdev;
> -               result = sysfs_create_link(&device->dev.kobj,
> -                                          &cdev->device.kobj,
> -                                          "thermal_cooling");
> -               if (result)
> -                       return result;
> -
> -               result = sysfs_create_link(&cdev->device.kobj,
> -                                          &device->dev.kobj,
> -                                          "device");
> -               if (result)
> -                       return result;
> -       }
> +       printk(KERN_INFO PREFIX
> +               "%s is registered as cooling_device%d\n",
> +               device->dev.bus_id, cdev->id);
> +
> +       acpi_driver_data(device) = cdev;
> +       result = sysfs_create_link(&device->dev.kobj,
> +                                  &cdev->device.kobj,
> +                                  "thermal_cooling");
> +       if (result)
> +               return result;
> +
> +       result = sysfs_create_link(&cdev->device.kobj,
> +                                  &device->dev.kobj,
> +                                  "device");
> +       if (result)
> +               return result;
> 
>         result = acpi_fan_add_fs(device);
>         if (result)
> diff -u -p a/drivers/acpi/processor_core.c
> b/drivers/acpi/processor_core.c
> --- a/drivers/acpi/processor_core.c     2008-03-12 14:13:13.000000000
> +0100
> +++ b/drivers/acpi/processor_core.c     2008-03-24 16:15:53.000000000
> +0100
> @@ -674,22 +674,20 @@ static int __cpuinit acpi_processor_star
>                 result = PTR_ERR(pr->cdev);
>                 goto end;
>         }
> -       if (pr->cdev) {
> -               printk(KERN_INFO PREFIX
> -                       "%s is registered as cooling_device%d\n",
> -                       device->dev.bus_id, pr->cdev->id);
> -
> -               result = sysfs_create_link(&device->dev.kobj,
> -                                          &pr->cdev->device.kobj,
> -                                          "thermal_cooling");
> -               if (result)
> -                       return result;
> -               result = sysfs_create_link(&pr->cdev->device.kobj,
> -                                          &device->dev.kobj,
> -                                          "device");
> -               if (result)
> -                       return result;
> -       }
> +       printk(KERN_INFO PREFIX
> +               "%s is registered as cooling_device%d\n",
> +               device->dev.bus_id, pr->cdev->id);
> +
> +       result = sysfs_create_link(&device->dev.kobj,
> +                                  &pr->cdev->device.kobj,
> +                                  "thermal_cooling");
> +       if (result)
> +               return result;
> +       result = sysfs_create_link(&pr->cdev->device.kobj,
> +                                  &device->dev.kobj,
> +                                  "device");
> +       if (result)
> +               return result;
> 
>         if (pr->flags.throttling) {
>                 printk(KERN_INFO PREFIX "%s [%s] (supports",
> diff -u -p a/drivers/acpi/video.c b/drivers/acpi/video.c
> --- a/drivers/acpi/video.c      2008-03-12 14:13:13.000000000 +0100
> +++ b/drivers/acpi/video.c      2008-03-24 16:17:17.000000000 +0100
> @@ -734,21 +734,19 @@ static void acpi_video_device_find_cap(s
>                 if (IS_ERR(device->cdev))
>                         return;
> 
> -               if (device->cdev) {
> -                       printk(KERN_INFO PREFIX
> -                               "%s is registered as cooling_device%d
> \n",
> -                               device->dev->dev.bus_id,
> device->cdev->id);
> -                       result =
> sysfs_create_link(&device->dev->dev.kobj,
> -                                         &device->cdev->device.kobj,
> -                                         "thermal_cooling");
> -                       if (result)
> -                               printk(KERN_ERR PREFIX "Create sysfs
> link\n");
> -                       result =
> sysfs_create_link(&device->cdev->device.kobj,
> -                                         &device->dev->dev.kobj,
> -                                         "device");
> -                        if (result)
> -                               printk(KERN_ERR PREFIX "Create sysfs
> link\n");
> -               }
> +               printk(KERN_INFO PREFIX
> +                       "%s is registered as cooling_device%d\n",
> +                       device->dev->dev.bus_id, device->cdev->id);
> +               result = sysfs_create_link(&device->dev->dev.kobj,
> +                                 &device->cdev->device.kobj,
> +                                 "thermal_cooling");
> +               if (result)
> +                       printk(KERN_ERR PREFIX "Create sysfs link\n");
> +               result = sysfs_create_link(&device->cdev->device.kobj,
> +                                 &device->dev->dev.kobj,
> +                                 "device");
> +               if (result)
> +                       printk(KERN_ERR PREFIX "Create sysfs link\n");
>         }
>         if (device->cap._DCS && device->cap._DSS){
>                 static int count = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

