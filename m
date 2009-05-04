Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZEDFpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZEDFpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 01:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZEDFpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 01:45:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49343 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZEDFpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 01:45:31 -0400
Message-ID: <49FE812B.7060906@cn.fujitsu.com>
Date: Mon, 04 May 2009 13:46:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Subject: [PATCH] from-sector redundant in trace_block_remap
References: <20090430133627.D217.A69D9226@jp.fujitsu.com> <49F9D82D.50901@hp.com> <49F9D8CC.7010502@hp.com>
In-Reply-To: <49F9D8CC.7010502@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>From f167379b6c2cbad5f4fe8492052693825980ec19 Mon Sep 17 00:00:00 2001
> From: Alan D. Brunelle <alan.brunelle@hp.com>
> Date: Thu, 30 Apr 2009 11:22:55 -0400
> Subject: [PATCH] from-sector redundant in trace_block_remap
> 
> Removed redundant from-sector parameter: it's /always/ the bio's sector
> passed in.
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
> @@ -817,7 +817,7 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
>   *
>   **/
>  static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> -				       dev_t dev, sector_t from, sector_t to)
> +				       dev_t dev, sector_t to)

You should also update the kernel-doc:

  * @dev:	target device
- * @from:	source sector
  * @to:	target sector

With this fix:

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

>  {
>  	struct blk_trace *bt = q->blk_trace;
>  	struct blk_io_trace_remap r;
> @@ -829,8 +829,9 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
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


