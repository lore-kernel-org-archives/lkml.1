Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZCMTh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZCMTh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZCMThP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:37:15 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:61192 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZCMThN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SqxUCcjzC/39kh0TDXcFumBc2FjYjU7thxO6HCRiem7/yVVgPATlybLBDXTF1ZVXCU
         a+mO+LlenEOaDY+4hHAKaMB+LxG1sfX69sLbw7jXVjo2c8JcvxTPm95p+t9NSvltY3sl
         vTjd4ieFGQHMXKFk2DmoOzTpjD1v/SixJQQv4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
Date: Fri, 13 Mar 2009 20:21:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <1236920578-2179-12-git-send-email-tj@kernel.org>
In-Reply-To: <1236920578-2179-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903132021.55921.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009, Tejun Heo wrote:
> Impact: cleanup
> 
> There are many [__]blk_end_request() call sites which call it with
> full request length and expect full completion.  Many of them ensure
> that the request actually completes by doing BUG_ON() the return
> value, which is awkward and error-prone.
> 
> This patch adds [__]blk_end_request_all() which takes @rq and @error
> and fully completes the request.  BUG_ON() is added to
> blk_update_request() to ensure that this actually happens.
> 
> Most conversions are simple but there are a few noteworthy ones.
> 
> * cdrom/viocd: viocd_end_request() replaced with direct calls to
>   __blk_end_request_all().
> 
> * s390/block/dasd: dasd_end_request() replaced with direct calls to
>   __blk_end_request_all().
> 
> * s390/char/tape_block: tapeblock_end_request() replaced with direct
>   calls to blk_end_request_all().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[...]

> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index f825d50..8e6705a 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c

[...]

> @@ -950,14 +947,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  
>  end_request:
>  	if (blk_pc_request(rq)) {
> -		unsigned int dlen = rq->data_len;
> -
>  		if (dma)
>  			rq->data_len = 0;

Since rq->data_len is modified here...

> -
> -		if (blk_end_request(rq, 0, dlen))
> -			BUG();
> -
> +		blk_end_request_all(rq, 0);

...this won't fly.

[ IIRC ->data_len modification is needed for SG_IO ]

>  		hwif->rq = NULL;
>  	} else {
>  		if (!uptodate)
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index a9a6c20..82f46dd 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -190,9 +190,7 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
>  
>  	rq->errors = err;
>  
> -	if (unlikely(blk_end_request(rq, (rq->errors ? -EIO : 0),
> -				     blk_rq_bytes(rq))))
> -		BUG();
> +	blk_end_request_all(rq, (rq->errors ? -EIO : 0));

How's about dropping needless parentheses while at it?

>  }
>  EXPORT_SYMBOL(ide_end_drive_cmd);
>  
> diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
> index 60538d9..d3d2d29 100644
> --- a/drivers/ide/ide-pm.c
> +++ b/drivers/ide/ide-pm.c
> @@ -194,8 +194,7 @@ void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
>  
>  	drive->hwif->rq = NULL;
>  
> -	if (blk_end_request(rq, 0, 0))
> -		BUG();
> +	blk_end_request_all(rq, 0);

0 => ide_rq_bytes() _not_ blk_rq_bytes()

Please convert ide_complete_pm_request() to use blk_rq_bytes() in
the separate pre-patch first.

More generic comment follows -> this patch is guaranteed to clash with
at least linux-next/pata-2.6 tree so why not introduce block layer helpers
now, then push all driver updates through respective driver maintainers
and deal with end_request() later (after all driver updates are in-tree)?

Thanks,
Bart
