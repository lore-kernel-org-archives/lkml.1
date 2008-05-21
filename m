Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbYEUCTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbYEUCTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933466AbYEUCTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:19:18 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:16686 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbYEUCTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:19:16 -0400
Date: Tue, 20 May 2008 20:17:08 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ata: fix sleep-while-holding-spinlock in sata_nv
In-reply-to: <fa.m+kShlzXY/wmFlvZXsE0W7wQIxU@ifi.uio.no>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <48338624.3000304@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.m+kShlzXY/wmFlvZXsE0W7wQIxU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] ata: fix sleep-while-holding-spinlock in sata_nv
> 
> blk_queue_bounce_limit() is a sleeping function, so reorganize
> the code a little to not call it while holding a spinlock.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/ata/sata_nv.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index 858f706..a7bc56d 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -671,6 +671,11 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
>  	port1 = ap->host->ports[1]->private_data;
>  	sdev0 = ap->host->ports[0]->link.device[0].sdev;
>  	sdev1 = ap->host->ports[1]->link.device[0].sdev;
> +
> +	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
> +	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
> +	spin_unlock_irqrestore(ap->lock, flags);
> +
>  	if ((port0->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
>  	    (port1->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
>  		/** We have to set the DMA mask to 32-bit if either port is in
> @@ -701,14 +706,11 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
>  					       pp->adma_dma_mask);
>  	}
>  
> -	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
> -	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
>  	ata_port_printk(ap, KERN_INFO,
>  		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
>  		(unsigned long long)*ap->host->dev->dma_mask,
>  		segment_boundary, sg_tablesize);
>  
> -	spin_unlock_irqrestore(ap->lock, flags);
>  
>  	return rc;
>  }

I'm not certain this is safe to do it quite this way. It would be better 
to keep that spinlock held so that no operations could be in progress on 
either port while these operations are happening.

It would be better to fix the regression from 
419c434c35614609fd0c79d335c134bf4b88b30b in block/blk_settings.c that 
resulted in the blk_queue_bounce_limit allocation wrongly allocating 
emergency ISA pages in the first place as a 32-bit DMA mask does not 
need them.
