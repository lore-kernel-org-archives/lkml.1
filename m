Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbXGPTEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbXGPTEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbXGPTEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:04:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:58999 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbXGPTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=UfSPof6iXB2G3HVTC5TuHw4WhEgiNO6aTBnFrofzofaQmi+ycVPecqIPUQBaxpFEh95Wa1UEuPtFpayDgaHRRZzXFULdX/cmNkP/b/JwAtCLirpd0vhdv3mCJlYhKIKei7wzY70qZyjfdF0eJimynO0BN6+AECOI/QmQawoQjgw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 03/33] block: convert to using sg helpers
Date: Mon, 16 Jul 2007 21:21:32 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792672399-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11845792672399-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707162121.32936.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 16 July 2007, Jens Axboe wrote:
> Convert the main rq mapper (blk_rq_map_sg()) to the sg helper setup.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/ll_rw_blk.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> index ef42bb2..ab71087 100644
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -30,6 +30,7 @@
>  #include <linux/cpu.h>
>  #include <linux/blktrace_api.h>
>  #include <linux/fault-inject.h>
> +#include <linux/scatterlist.h>
>  
>  /*
>   * for max sense size
> @@ -1307,9 +1308,11 @@ static int blk_hw_contig_segment(request_queue_t *q, struct bio *bio,
>   * map a request to scatterlist, return number of sg entries setup. Caller
>   * must make sure sg can hold rq->nr_phys_segments entries
>   */
> -int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
> +int blk_rq_map_sg(request_queue_t *q, struct request *rq,
> +		  struct scatterlist *sglist)
>  {
>  	struct bio_vec *bvec, *bvprv;
> +	struct scatterlist *next_sg, *sg;
>  	struct bio *bio;
>  	int nsegs, i, cluster;
>  
> @@ -1320,6 +1323,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
>  	 * for each bio in rq
>  	 */
>  	bvprv = NULL;
> +	sg = next_sg = &sglist[0];
>  	rq_for_each_bio(bio, rq) {
>  		/*
>  		 * for each segment in bio
> @@ -1328,7 +1332,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
>  			int nbytes = bvec->bv_len;
>  
>  			if (bvprv && cluster) {
> -				if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
> +				if (sg->length + nbytes > q->max_segment_size)
>  					goto new_segment;
>  
>  				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
> @@ -1336,14 +1340,15 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
>  				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
>  					goto new_segment;
>  
> -				sg[nsegs - 1].length += nbytes;
> +				sg->length += nbytes;
>  			} else {
>  new_segment:
> -				memset(&sg[nsegs],0,sizeof(struct scatterlist));

Is this intended?  If so why this is no longer needed?

> -				sg[nsegs].page = bvec->bv_page;
> -				sg[nsegs].length = nbytes;
> -				sg[nsegs].offset = bvec->bv_offset;
> +				sg = next_sg;
> +				next_sg = sg_next(sg);
>  
> +				sg->page = bvec->bv_page;
> +				sg->length = nbytes;
> +				sg->offset = bvec->bv_offset;
>  				nsegs++;
>  			}
>  			bvprv = bvec;
