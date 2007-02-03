Return-Path: <linux-kernel-owner+w=401wt.eu-S1946187AbXBCBTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946187AbXBCBTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXBCBTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:19:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48177 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbXBCBT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:19:28 -0500
Date: Fri, 2 Feb 2007 17:19:24 -0800
From: Andrew Morton <akpm@osdl.org>
To: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.6.19.2] SCSI sd:  udev accessing an uninitialized
 scsi_disk results in a crash
Message-Id: <20070202171924.a225cff7.akpm@linux-foundation.org>
In-Reply-To: <200702021734.57161.nagendra_tomar@adaptec.com>
References: <200702021734.57161.nagendra_tomar@adaptec.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 17:34:56 +0530
Nagendra Singh Tomar <nagendra_tomar@adaptec.com> wrote:

> Hi,
> 	sd_probe() calls class_device_add() even before initializing the 
> sdkp->device variable. class_device_add() eventually results in the user mode 
> udev program to be called. udev program can read the the allow_restart 
> attribute of the newly created scsi device. This is resulting in a crash as 
> the show function for allow_restart (i.e sd_show_allow_restart) returns the 
> attribute value by reading the sdkp->device->allow_restart variable. As the 
> sdkp->device is not initialized before calling the user mode hotplug helper, 
> this results in a crash.
> 	The patch below solves it by calling class_device_add() only after the 
> necessary fields in the scsi_disk structure are initialized properly.
> 
> 
> 
> --- linux-2.6.19.2/drivers/scsi/sd.c.orig	2007-02-02 17:03:03.000000000 +0530
> +++ linux-2.6.19.2/drivers/scsi/sd.c	2007-02-02 17:04:04.000000000 +0530
> @@ -1646,16 +1646,6 @@ static int sd_probe(struct device *dev)
>  	if (error)
>  		goto out_put;
>  
> -	class_device_initialize(&sdkp->cdev);
> -	sdkp->cdev.dev = &sdp->sdev_gendev;
> -	sdkp->cdev.class = &sd_disk_class;
> -	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
> -
> -	if (class_device_add(&sdkp->cdev))
> -		goto out_put;
> -
> -	get_device(&sdp->sdev_gendev);
> -
>  	sdkp->device = sdp;
>  	sdkp->driver = &sd_template;
>  	sdkp->disk = gd;
> @@ -1669,6 +1659,16 @@ static int sd_probe(struct device *dev)
>  			sdp->timeout = SD_MOD_TIMEOUT;
>  	}
>  
> +	class_device_initialize(&sdkp->cdev);
> +	sdkp->cdev.dev = &sdp->sdev_gendev;
> +	sdkp->cdev.class = &sd_disk_class;
> +	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
> +
> +	if (class_device_add(&sdkp->cdev))
> +		goto out_put;
> +
> +	get_device(&sdp->sdev_gendev);
> +
>  	gd->major = sd_major((index & 0xf0) >> 4);
>  	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
>  	gd->minors = 16;

Thanks - I'll queue this up for 2.6.20 also.
