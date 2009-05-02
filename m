Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZEBD4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZEBD4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 23:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZEBDzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 23:55:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:54526 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZEBDzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 23:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kVe5uNEhjZra+Q/C8Jb2nr7K/nn8JWJUpyWbKAQhO4aBc1K4DMKPkR/Ta/WGIovsdr
         MdAkXjbWUm4xCOj6YzeZQ9jlBdZKEoM7cv5bdJsV6Zu3F57CGSkHmcsiNerMrDdUKnOE
         nYAkfVYPG0jjJRzNlnj5cORNnsquZGlS+KhDA=
Date: Sat, 2 May 2009 11:55:39 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 5/5] initdev:kernel: USB and SCSI block init device
 notification, v3
Message-ID: <20090502115539.396206bc@linux-lm>
In-Reply-To: <20090502023000.GA16076@cuplxvomd02.corp.sa.net>
References: <20090502023000.GA16076@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 19:30:00 -0700
David VomLehn <dvomlehn@cisco.com> wrote:

> From: Alan Stern <stern@rowland.harvard.edu
> 
> Add notification of device discovery for USB and SCSI block devices.
> 
> History
> v3	Change bootdev_* to initdev_*
> v2	Correct location of call to bootdev_found
> v1	Initial version
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---
>  drivers/scsi/scsi_scan.c  |    2 ++
>  drivers/usb/storage/usb.c |    3 +++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6f51ca4..735b061 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1834,6 +1834,7 @@ static int do_scan_async(void *_data)
>  	struct async_scan_data *data = _data;
>  	do_scsi_scan_host(data->shost);
>  	scsi_finish_async_scan(data);
> +	initdev_probe_done(BOOTDEV_BLOCK_MASK);

Which code are waiting for the block device's probe done?


>  	return 0;
>  }
>  
> @@ -1855,6 +1856,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  		return;
>  	}
>  
> +	initdev_found(BOOTDEV_BLOCK_MASK);
>  	p = kthread_run(do_scan_async, data, "scsi_scan_%d",
> shost->host_no); if (IS_ERR(p))
>  		do_scan_async(data);
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index 8060b85..ea7abab 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -837,6 +837,7 @@ static int usb_stor_scan_thread(void * __us)
>  		/* Should we unbind if no devices were detected? */
>  	}
>  
> +	initdev_probe_done(BOOTDEV_BLOCK_MASK);

the same question with above.

>  	complete_and_exit(&us->scanning_done, 0);
>  }
>  
> @@ -937,10 +938,12 @@ int usb_stor_probe2(struct us_data *us)
>  	}
>  
>  	/* Start up the thread for delayed SCSI-device scanning */
> +	initdev_found(BOOTDEV_BLOCK_MASK);
>  	th = kthread_create(usb_stor_scan_thread, us,
> "usb-stor-scan"); if (IS_ERR(th)) {
>  		printk(KERN_WARNING USB_STORAGE 
>  		       "Unable to start the device-scanning
> thread\n");
> +		initdev_probe_done(BOOTDEV_BLOCK_MASK);

the same question with above.

>  		complete(&us->scanning_done);
>  		quiesce_and_remove_host(us);
>  		result = PTR_ERR(th);
> --


-- 
Lei Ming
