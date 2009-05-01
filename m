Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZEACJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZEACJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZEACIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:08:53 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:63802 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZEACIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GxTo/7dl5Df7glgLECQFfF0bPDUWOsrNf+X8FvWfn8k1vo8xcYKB3X31wUmMrWmN9e
         Z5gGXyau67nDMjfhlTluLRG5FR5W+rr1s5/UUMjuyh6SeXzgXpBTQqnb4hv+yc/zMmw/
         CDyZ76LjkpjdvxvPVx5DwBN1CW6UeDbtvesG4=
MIME-Version: 1.0
In-Reply-To: <49F9D8CC.7010502@hp.com>
References: <20090430133627.D217.A69D9226@jp.fujitsu.com>
	 <49F9D82D.50901@hp.com> <49F9D8CC.7010502@hp.com>
Date: Fri, 1 May 2009 11:08:51 +0900
X-Google-Sender-Auth: b21cb2c346171f3c
Message-ID: <2f11576a0904301908i1c0f12e5tc3f76e1ffee84a18@mail.gmail.com>
Subject: Re: Subject: [PATCH] from-sector redundant in trace_block_remap
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From f167379b6c2cbad5f4fe8492052693825980ec19 Mon Sep 17 00:00:00 2001
> From: Alan D. Brunelle <alan.brunelle@hp.com>
> Date: Thu, 30 Apr 2009 11:22:55 -0400
> Subject: [PATCH] from-sector redundant in trace_block_remap
>
> Removed redundant from-sector parameter: it's /always/ the bio's sector
> passed in.

please swap patch 1/2 and 2/2.
Actually this patch remove "to" parameter. but wrong parameter name
confuse patch description.

IOW, this patch description and changing code isn't consistent because
there is argument to-from swapping.
Otherthings, looks good to me.

>
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> ---
>  block/blk-core.c        |    5 ++---
>  drivers/md/dm.c         |    3 +--
>  include/trace/block.h   |    4 ++--
>  kernel/trace/blktrace.c |    7 ++++---
>  4 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2998fe3..d028baf 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1277,7 +1277,7 @@ static inline void blk_partition_remap(struct bio *bio)
>  		bio->bi_bdev = bdev->bd_contains;
>
>  		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
> -				    bdev->bd_dev, bio->bi_sector,
> +				    bdev->bd_dev,
>  				    bio->bi_sector - p->start_sect);
>  	}
>  }
> @@ -1446,8 +1446,7 @@ static inline void __generic_make_request(struct bio *bio)
>  			goto end_io;
>
>  		if (old_sector != -1)
> -			trace_block_remap(q, bio, old_dev, bio->bi_sector,
> -					    old_sector);
> +			trace_block_remap(q, bio, old_dev, old_sector);
>
>  		trace_block_bio_queue(q, bio);
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 424f7b0..e2ee4a7 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -656,8 +656,7 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
>  		/* the bio has been remapped so dispatch it */
>
>  		trace_block_remap(bdev_get_queue(clone->bi_bdev), clone,
> -				    tio->io->bio->bi_bdev->bd_dev,
> -				    clone->bi_sector, sector);
> +				    tio->io->bio->bi_bdev->bd_dev, sector);
>
>  		generic_make_request(clone);
>  	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
> diff --git a/include/trace/block.h b/include/trace/block.h
> index 25b7068..8ac945b 100644
> --- a/include/trace/block.h
> +++ b/include/trace/block.h
> @@ -70,7 +70,7 @@ DECLARE_TRACE(block_split,
>
>  DECLARE_TRACE(block_remap,
>  	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
> -		 sector_t from, sector_t to),
> -	      TP_ARGS(q, bio, dev, from, to));
> +		 sector_t to),
> +	      TP_ARGS(q, bio, dev, to));
>
>  #endif
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 921ef5d..6eaef3b 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -817,7 +817,7 @@ static void blk_add_trace_split(struct request_queue *q, struct bio > *bio,
>   *
>   **/
>  static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> -				       dev_t dev, sector_t from, sector_t to)
> +				       dev_t dev, sector_t to)
>  {
>  	struct blk_trace *bt = q->blk_trace;
>  	struct blk_io_trace_remap r;
> @@ -829,8 +829,9 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio > *bio,
>  	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
>  	r.sector = cpu_to_be64(to);
>
> -	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
> -			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
> +	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw,
> +			BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE),
> +			sizeof(r), &r);
>  }
>
>  /**
> --
> 1.6.0.4
>
>
