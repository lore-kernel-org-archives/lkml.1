Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbZGWKpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbZGWKpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZGWKpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:45:45 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:55167 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZGWKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ImHI394rso5OQN0vvXCBMT2D5xchWXTJ9OrgfSeLnDs1Mym+xkyTIs70ewQLBadFPR
         Xv3TpHRkZjvO4r1GQvu2yy0f7Q6kfTjgooN5LbZXDNZlnx2OpeVckpeyCwgIuSUjqOlb
         FAWJosR75+OaEdFTtxARxUYWOVU5RykWgYMMs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: unsik Kim <donari75@gmail.com>
Subject: Re: [PATCH] mg_disk: Add missing ready status check on mg_write()
Date: Fri, 24 Jul 2009 12:41:42 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090721-04109-g2db5ef2; KDE/4.2.4; i686; ; )
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <200907031516.51893.bzolnier@gmail.com> <1248322878-3804-1-git-send-email-donari75@gmail.com>
In-Reply-To: <1248322878-3804-1-git-send-email-donari75@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907241241.42842.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 July 2009 06:21:18 unsik Kim wrote:
> When last sector is written, ready bit of status register should be
> checked.
> 
> Signed-off-by: unsik Kim <donari75@gmail.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[ It is on top of my patch (http://lkml.org/lkml/2009/6/28/237), right?

  I assume that both patches were verified with hardware and are ready
  to be merged upstream now? ]

> ---
>  drivers/block/mg_disk.c |   32 +++++++++++++++-----------------
>  1 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
> index f8149db..64f90f5 100644
> --- a/drivers/block/mg_disk.c
> +++ b/drivers/block/mg_disk.c
> @@ -516,16 +516,16 @@ static void mg_write_one(struct mg_host *host, struct request *req)
>  static void mg_write(struct request *req)
>  {
>  	struct mg_host *host = req->rq_disk->private_data;
> -	bool rem;
> +	unsigned int rem = blk_rq_sectors(req);
>  
> -	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
> +	if (mg_out(host, blk_rq_pos(req), rem,
>  		   MG_CMD_WR, NULL) != MG_ERR_NONE) {
>  		mg_bad_rw_intr(host);
>  		return;
>  	}
>  
>  	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
> -	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
> +	       rem, blk_rq_pos(req), req->buffer);
>  
>  	if (mg_wait(host, ATA_DRQ,
>  		    MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> @@ -533,25 +533,23 @@ static void mg_write(struct request *req)
>  		return;
>  	}
>  
> -	mg_write_one(host, req);
> +	do {
> +		mg_write_one(host, req);
>  
> -	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
> +		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
> +				MG_REG_COMMAND);
>  
> -	do {
> -		if (blk_rq_sectors(req) > 1 &&
> -		     mg_wait(host, ATA_DRQ,
> -			     MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> +		rem--;
> +		if (rem > 1 && mg_wait(host, ATA_DRQ,
> +					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> +			mg_bad_rw_intr(host);
> +			return;
> +		} else if (mg_wait(host, MG_STAT_READY,
> +					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
>  			mg_bad_rw_intr(host);
>  			return;
>  		}
> -
> -		rem = mg_end_request(host, 0, MG_SECTOR_SIZE);
> -		if (rem)
> -			mg_write_one(host, req);
> -
> -		outb(MG_CMD_WR_CONF,
> -		     (unsigned long)host->dev_base + MG_REG_COMMAND);
> -	} while (rem);
> +	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
>  }
>  
>  static void mg_read_intr(struct mg_host *host)
