Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZH3Ane@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZH3Ane (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZH3Ane
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:43:34 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50951 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbZH3And (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:43:33 -0400
Message-ID: <4A99CB2F.9000000@interlog.com>
Date: Sat, 29 Aug 2009 20:43:27 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com,
       matthew@wil.cx, dwmw2@infradead.org
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org>
In-Reply-To: <20090829231121.713422216@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Add a prepare_discard function to sd that sends a WRITE SAME request with
> the unmap bit set to the device if it advertises thin provisioning support.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/scsi/sd.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/sd.c	2009-08-29 19:19:36.067371669 -0300
> +++ linux-2.6/drivers/scsi/sd.c	2009-08-29 19:26:20.723754241 -0300
> @@ -911,6 +911,50 @@ static void sd_prepare_flush(struct requ
>  	rq->cmd_len = 10;
>  }
>  
> +static int sd_prepare_discard(struct request_queue *q, struct request *rq,
> +		struct bio *bio)
> +{
> +	struct scsi_device *sdp = q->queuedata;
> +	struct page *page = alloc_page(GFP_KERNEL);
> +
> +	if (!page)
> +		return -ENOMEM;
> +
> +	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> +	rq->timeout = SD_TIMEOUT;
> +	rq->cmd[0] = WRITE_SAME_16;
> +	rq->cmd[1] = 0x8; /* UNMAP bit */
> +	rq->cmd[2] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 56) & 0xff : 0;
> +	rq->cmd[3] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 48) & 0xff : 0;
> +	rq->cmd[4] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 40) & 0xff : 0;
> +	rq->cmd[5] = sizeof(bio->bi_sector) > 4 ?
> +			(unsigned char) (bio->bi_sector >> 32) & 0xff : 0;
> +	rq->cmd[6] = (unsigned char) (bio->bi_sector >> 24) & 0xff;
> +	rq->cmd[7] = (unsigned char) (bio->bi_sector >> 16) & 0xff;
> +	rq->cmd[8] = (unsigned char) (bio->bi_sector >> 8) & 0xff;
> +	rq->cmd[9] = (unsigned char) bio->bi_sector & 0xff;
> +	rq->cmd[10] = (unsigned char) (bio_sectors(bio) >> 24) & 0xff;
> +	rq->cmd[11] = (unsigned char) (bio_sectors(bio) >> 16) & 0xff;
> +	rq->cmd[12] = (unsigned char) (bio_sectors(bio) >> 8) & 0xff;
> +	rq->cmd[13] = (unsigned char) bio_sectors(bio) & 0xff;
> +	rq->cmd[14] = 0;
> +	rq->cmd[15] = 0;
> +	rq->cmd_len = 16;
> +
> +	printk(KERN_INFO "umap, lba = 0x%lld, len = %d\n",
> +	       bio->bi_sector, bio_sectors(bio));
> +
> +	bio->bi_size = 0;
> +	if (bio_add_pc_page(q, bio, page, sdp->sector_size, 0) <
> +			sdp->sector_size)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
>  static void sd_rescan(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> @@ -1369,6 +1413,9 @@ static int read_capacity_16(struct scsi_
>  		sd_printk(KERN_NOTICE, sdkp,
>  			  "physical block alignment offset: %u\n", alignment);
>  
> +	if (buffer[14] & 0x80)
> +		sdkp->thin_provisioning = 1;
> +

So you are checking the TPE bit (Thin Provisioning Enabled) but
not the TPRZ bit (Thin Provisioning Read Zeros). Shouldn't
there also be a sdkp->thin_provisioning_read_zeros bit defined
in struct scsi_disk?

Is your application well defined when TPRZ==0 ?

Doug Gilbert



