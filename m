Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153Ab0ARPuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0ARPuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793Ab0ARPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:50:21 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56994 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0ARPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:50:20 -0500
Message-ID: <4B5482D3.305@s5r6.in-berlin.de>
Date: Mon, 18 Jan 2010 16:48:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 31/40] libata: take advantage of cmwq and remove concurrency
 limitations
References: <1263776272-382-1-git-send-email-tj@kernel.org> <1263776272-382-32-git-send-email-tj@kernel.org>
In-Reply-To: <1263776272-382-32-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
[...]
> b. ata_aux_wq which is used for SCSI probing has single thread.  In
>    cases where SCSI probing is stalled for extended period of time
>    which is possible for ATAPI devices, this will stall all probing.

Are things like INQUIRY and possibly motor spin-up performed there?
If yes, ...

[...]
> #b is solved by using the default wq instead and achieving exclusion
> via per-port mutex.
[...]
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -727,7 +727,7 @@ void ata_scsi_error(struct Scsi_Host *host)
>  	if (ap->pflags & ATA_PFLAG_LOADING)
>  		ap->pflags &= ~ATA_PFLAG_LOADING;
>  	else if (ap->pflags & ATA_PFLAG_SCSI_HOTPLUG)
> -		queue_delayed_work(ata_aux_wq, &ap->hotplug_task, 0);
> +		schedule_delayed_work(&ap->hotplug_task, 0);
>  
>  	if (ap->pflags & ATA_PFLAG_RECOVERED)
>  		ata_port_printk(ap, KERN_INFO, "EH complete\n");
> @@ -2938,7 +2938,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
>  			ehc->i.flags |= ATA_EHI_SETMODE;
>  
>  			/* schedule the scsi_rescan_device() here */
> -			queue_work(ata_aux_wq, &(ap->scsi_rescan_task));
> +			schedule_work(&(ap->scsi_rescan_task));
>  		} else if (dev->class == ATA_DEV_UNKNOWN &&
>  			   ehc->tries[dev->devno] &&
>  			   ata_class_enabled(ehc->classes[dev->devno])) {
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index f4ea5a8..08e2ef8 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3408,8 +3408,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  				"                  switching to async\n");
>  	}
>  
> -	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
> -			   round_jiffies_relative(HZ));
> +	schedule_delayed_work(&ap->hotplug_task, round_jiffies_relative(HZ));
>  }
>  
>  /**
[...]

... wouldn't queue_delayed_work(system_long_wq, &ap->hotplug_task, ...);
be more appropriate then?
-- 
Stefan Richter
-=====-==-=- ---= =--=-
http://arcgraph.de/sr/
