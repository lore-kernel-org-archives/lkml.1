Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZGEMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZGEMMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 08:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZGEMMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 08:12:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44577 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZGEMMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 08:12:09 -0400
Date: Sun, 5 Jul 2009 14:12:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <julia@diku.dk>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH 4/5] drivers/hwmon: Use resource_size
Message-ID: <20090705141200.6b0deb34@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0907050836530.27464@ask.diku.dk>
References: <Pine.LNX.4.64.0907050836530.27464@ask.diku.dk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009 08:37:14 +0200 (CEST), Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use the function resource_size, which reduces the chance of introducing
> off-by-one errors in calculating the resource size.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> struct resource *res;
> @@
> 
> - (res->end - res->start) + 1
> + resource_size(res)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/hwmon/pc87427.c |    6 +++---
>  drivers/hwmon/vt1211.c  |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff -u -p a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
> --- a/drivers/hwmon/pc87427.c 2009-01-09 22:41:01.000000000 +0100
> +++ b/drivers/hwmon/pc87427.c 2009-07-04 21:38:15.000000000 +0200
> @@ -435,7 +435,7 @@ static int __devinit pc87427_probe(struc
>  	/* This will need to be revisited when we add support for
>  	   temperature and voltage monitoring. */
>  	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> -	if (!request_region(res->start, res->end - res->start + 1, DRVNAME)) {
> +	if (!request_region(res->start, resource_size(res), DRVNAME)) {
>  		err = -EBUSY;
>  		dev_err(&pdev->dev, "Failed to request region 0x%lx-0x%lx\n",
>  			(unsigned long)res->start, (unsigned long)res->end);
> @@ -475,7 +475,7 @@ exit_remove_files:
>  		sysfs_remove_group(&pdev->dev.kobj, &pc87427_group_fan[i]);
>  	}
>  exit_release_region:
> -	release_region(res->start, res->end - res->start + 1);
> +	release_region(res->start, resource_size(res));
>  exit_kfree:
>  	platform_set_drvdata(pdev, NULL);
>  	kfree(data);
> @@ -500,7 +500,7 @@ static int __devexit pc87427_remove(stru
>  	kfree(data);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> -	release_region(res->start, res->end - res->start + 1);
> +	release_region(res->start, resource_size(res));
>  
>  	return 0;
>  }
> diff -u -p a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
> --- a/drivers/hwmon/vt1211.c 2009-03-02 11:33:15.000000000 +0100
> +++ b/drivers/hwmon/vt1211.c 2009-07-04 21:38:17.000000000 +0200
> @@ -1136,7 +1136,7 @@ static int __devinit vt1211_probe(struct
>  	}
>  
>  	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> -	if (!request_region(res->start, res->end - res->start + 1, DRVNAME)) {
> +	if (!request_region(res->start, resource_size(res), DRVNAME)) {
>  		err = -EBUSY;
>  		dev_err(dev, "Failed to request region 0x%lx-0x%lx\n",
>  			(unsigned long)res->start, (unsigned long)res->end);
> @@ -1209,7 +1209,7 @@ EXIT_DEV_REMOVE:
>  	dev_err(dev, "Sysfs interface creation failed (%d)\n", err);
>  EXIT_DEV_REMOVE_SILENT:
>  	vt1211_remove_sysfs(pdev);
> -	release_region(res->start, res->end - res->start + 1);
> +	release_region(res->start, resource_size(res));
>  EXIT_KFREE:
>  	platform_set_drvdata(pdev, NULL);
>  	kfree(data);
> @@ -1228,7 +1228,7 @@ static int __devexit vt1211_remove(struc
>  	kfree(data);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> -	release_region(res->start, res->end - res->start + 1);
> +	release_region(res->start, resource_size(res));
>  
>  	return 0;
>  }

Applied, thanks.

-- 
Jean Delvare
