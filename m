Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYDYHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYDYHxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYDYHxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:53:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59465 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbYDYHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:53:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48118DDD.8010507@s5r6.in-berlin.de>
Date: Fri, 25 Apr 2008 09:53:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, mdharm-usb@one-eyed-alien.net,
       linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Cc: Matthew Wilcox)

Pekka J Enberg wrote:
> Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the kernel
> wait until background scanning of USB mass storage devices is complete before
> attempting to mount the root filesystem.
> 
> The config option is an alternative to the root_delay= kernel parameter
> solution people currently use to boot from USB mass storage devices.
[...]
>  drivers/scsi/scsi_scan.c  |    2 ++
>  drivers/usb/storage/usb.c |    3 +++
>  include/linux/init.h      |   12 ++++++++++++
>  init/Kconfig              |    5 +++++
>  init/do_mounts.c          |   32 ++++++++++++++++++++++++++++++++
>  5 files changed, 54 insertions(+)
> 
> Index: linux-2.6/drivers/usb/storage/usb.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/storage/usb.c
> +++ linux-2.6/drivers/usb/storage/usb.c
> @@ -928,6 +928,7 @@ static int usb_stor_scan_thread(void * _
>  		/* Should we unbind if no devices were detected? */
>  	}
>  
> +	complete_root_scan();
>  	complete_and_exit(&us->scanning_done, 0);
>  }
>  
> @@ -1007,12 +1008,14 @@ static int storage_probe(struct usb_inte
>  		goto BadDevice;
>  	}
>  
> +	begin_root_scan();
>  	/* Start up the thread for delayed SCSI-device scanning */
>  	th = kthread_create(usb_stor_scan_thread, us, "usb-stor-scan");
>  	if (IS_ERR(th)) {
>  		printk(KERN_WARNING USB_STORAGE 
>  		       "Unable to start the device-scanning thread\n");
>  		quiesce_and_remove_host(us);
> +		complete_root_scan();
>  		result = PTR_ERR(th);
>  		goto BadDevice;
>  	}
[...]
> Index: linux-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/scsi_scan.c
> +++ linux-2.6/drivers/scsi/scsi_scan.c
> @@ -1802,6 +1802,7 @@ static int do_scan_async(void *_data)
>  	struct async_scan_data *data = _data;
>  	do_scsi_scan_host(data->shost);
>  	scsi_finish_async_scan(data);
> +	complete_root_scan();
>  	return 0;
>  }
>  
> @@ -1823,6 +1824,7 @@ void scsi_scan_host(struct Scsi_Host *sh
>  		return;
>  	}
>  
> +	begin_root_scan();
>  	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
>  	if (unlikely(IS_ERR(p)))
>  		do_scan_async(data);

Looks like you want complete_root_scan() after IS_ERR(p).  Are there any 
other thread exit paths which don't call complete_root_scan() yet?

Besides, can't you use the generic async scan facility of the SCSI stack 
for your purpose?  If not, can it be extended to make it usable?
-- 
Stefan Richter
-=====-==--- -=-- ==--=
http://arcgraph.de/sr/
