Return-Path: <linux-kernel-owner+w=401wt.eu-S1765775AbXHAPlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765775AbXHAPlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbXHAPlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:41:14 -0400
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:40339 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbXHAPlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:41:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] drivers/block/cciss.c: fix check-after-use
Date: Wed, 1 Aug 2007 15:40:30 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C01A3F8A2@G3W0639.americas.hpqcorp.net>
In-Reply-To: <20070730222811.GD3972@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] drivers/block/cciss.c: fix check-after-use
Thread-Index: AcfS+Q09/7kEgZ6/SsKwazliNh72FQBWSqEg
References: <20070730222811.GD3972@stusta.de>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Adrian Bunk" <bunk@stusta.de>, "Jens Axboe" <jens.axboe@oracle.com>
Cc: "ISS StorageDev" <iss_storagedev@hp.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Aug 2007 15:40:31.0366 (UTC) FILETIME=[4AFA1A60:01C7D452]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Adrian Bunk [mailto:bunk@stusta.de] 
> Sent: Monday, July 30, 2007 5:28 PM
> To: Miller, Mike (OS Dev); Jens Axboe
> Cc: ISS StorageDev; linux-kernel@vger.kernel.org
> Subject: [2.6 patch] drivers/block/cciss.c: fix check-after-use
> 
> The Coverity checker spotted that we have already oops'ed if "disk"
> was NULL.
> 
> Since "disk" being NULL seems impossible at this point this 
> patch removes the NULL check.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Mike Miller <mike.miller@hp.com>

> 
> ---
> 
>  drivers/block/cciss.c |   56 
> ++++++++++++++++++++----------------------
>  1 file changed, 27 insertions(+), 29 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1/drivers/block/cciss.c.old	
> 2007-07-30 02:27:15.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/block/cciss.c	
> 2007-07-30 02:28:28.000000000 +0200
> @@ -1569,66 +1569,64 @@ static int deregister_disk(struct gendis
>  	ctlr_info_t *h = get_host(disk);
>  
>  	if (!capable(CAP_SYS_RAWIO))
>  		return -EPERM;
>  
>  	/* make sure logical volume is NOT is use */
>  	if (clear_all || (h->gendisk[0] == disk)) {
>  		if (drv->usage_count > 1)
>  			return -EBUSY;
>  	} else if (drv->usage_count > 0)
>  		return -EBUSY;
>  
>  	/* invalidate the devices and deregister the disk.  If 
> it is disk
>  	 * zero do not deregister it but just zero out it's 
> values.  This
>  	 * allows us to delete disk zero but keep the 
> controller registered.
>  	 */
>  	if (h->gendisk[0] != disk) {
> -		if (disk) {
> -			struct request_queue *q = disk->queue;
> -			if (disk->flags & GENHD_FL_UP)
> -				del_gendisk(disk);
> -			if (q) {
> -				blk_cleanup_queue(q);
> -				/* Set drv->queue to NULL so 
> that we do not try
> -				 * to call blk_start_queue on 
> this queue in the
> -				 * interrupt handler
> -				 */
> -				drv->queue = NULL;
> -			}
> -			/* If clear_all is set then we are 
> deleting the logical
> -			 * drive, not just refreshing its info. 
>  For drives
> -			 * other than disk 0 we will call 
> put_disk.  We do not
> -			 * do this for disk 0 as we need it to 
> be able to
> -			 * configure the controller.
> +		struct request_queue *q = disk->queue;
> +		if (disk->flags & GENHD_FL_UP)
> +			del_gendisk(disk);
> +		if (q) {
> +			blk_cleanup_queue(q);
> +			/* Set drv->queue to NULL so that we do not try
> +			 * to call blk_start_queue on this queue in the
> +			 * interrupt handler
> +			 */
> +			drv->queue = NULL;
> +		}
> +		/* If clear_all is set then we are deleting the logical
> +		 * drive, not just refreshing its info.  For drives
> +		 * other than disk 0 we will call put_disk.  We do not
> +		 * do this for disk 0 as we need it to be able to
> +		 * configure the controller.
> +		*/
> +		if (clear_all){
> +			/* This isn't pretty, but we need to find the
> +			 * disk in our array and NULL our the pointer.
> +			 * This is so that we will call alloc_disk if
> +			 * this index is used again later.
>  			*/
> -			if (clear_all){
> -				/* This isn't pretty, but we 
> need to find the
> -				 * disk in our array and NULL 
> our the pointer.
> -				 * This is so that we will call 
> alloc_disk if
> -				 * this index is used again later.
> -				*/
> -				for (i=0; i < CISS_MAX_LUN; i++){
> -					if(h->gendisk[i] == disk){
> -						h->gendisk[i] = NULL;
> -						break;
> -					}
> +			for (i=0; i < CISS_MAX_LUN; i++){
> +				if(h->gendisk[i] == disk){
> +					h->gendisk[i] = NULL;
> +					break;
>  				}
> -				put_disk(disk);
>  			}
> +			put_disk(disk);
>  		}
>  	} else {
>  		set_capacity(disk, 0);
>  	}
>  
>  	--h->num_luns;
>  	/* zero out the disk size info */
>  	drv->nr_blocks = 0;
>  	drv->block_size = 0;
>  	drv->heads = 0;
>  	drv->sectors = 0;
>  	drv->cylinders = 0;
>  	drv->raid_level = -1;	/* This can be used as a flag 
> variable to
>  				 * indicate that this element 
> of the drive
>  				 * array is free.
>  				 */
>  
> 
> 
