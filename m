Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYAVUck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYAVUck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYAVUc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:32:28 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45593 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYAVUc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:32:27 -0500
Message-ID: <479652D2.10800@garzik.org>
Date: Tue, 22 Jan 2008 15:32:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>	 <1201022985.3210.24.camel@localhost.localdomain>	 <Pine.LNX.4.64.0801221813540.8693@blonde.site> <1201031028.3210.61.camel@localhost.localdomain>
In-Reply-To: <1201031028.3210.61.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Actually, I don't think it's a smaller I/O issue.  The SMART protocol
> specifically mandates that the transfers for SMART READ DATA and SMART
> READ LOG shall be 512 bytes).  However, the pio transfer routine does
> seem to be assuming sector alignment as well, which will be where your
> problems are coming from.  I think we need to specify sector minimum
> alignment for ata (but not atapi, which has its own non sector size pio
> routine).  How about the attached?
> 
> We have to do this for all ATA devices, because they'll likely all
> support SMART, and SMART is defined to be a PIO command.
> 
> James
> 
> ---
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 4bb268b..bc5cf6b 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -824,9 +824,6 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
>  	 * requests.
>  	 */
>  	sdev->max_device_blocked = 1;
> -
> -	/* set the min alignment */
> -	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
>  }
>  
>  static void ata_scsi_dev_config(struct scsi_device *sdev,
> @@ -842,7 +839,14 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
>  	if (dev->class == ATA_DEV_ATAPI) {
>  		struct request_queue *q = sdev->request_queue;
>  		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
> -	}
> +
> +		/* set the min alignment */
> +		blk_queue_update_dma_alignment(sdev->request_queue,
> +					       ATA_DMA_PAD_SZ - 1);
> +	} else
> +		/* ATA devices must be sector aligned */
> +		blk_queue_update_dma_alignment(sdev->request_queue,
> +					       ATA_SECT_SIZE - 1);
>  
>  	if (dev->flags & ATA_DFLAG_AN)
>  		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);


ACK

Unlike ATAPI, ATA is indeed all 512-byte alignment transfers (_not_ 
sector size, which may or may not be 512 bytes)

Does this apply to libata?  libata + jejb dma alignment patch?

What tree...

	Jeff



