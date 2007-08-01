Return-Path: <linux-kernel-owner+w=401wt.eu-S933742AbXHAO7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbXHAO7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763256AbXHAO70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:59:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:30129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761213AbXHAO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gkXHIO0cD/oJK+SWnSpEKxiyejizlsd5xwWPbjrahFOPd0RSyzLu9TmxPYWu3pIdDNzkgfQo7JmTXS2qdv8kbYvmhgk5/fOFCDYk34Gm89edTa06AvdNh4Zi7ZLkpj50jCuFkQragkwmBDcqO/e0Eq8YO2mKTIsKab4NU0LfqVU=
Message-ID: <46B09E99.3080705@gmail.com>
Date: Wed, 01 Aug 2007 23:54:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 005 of 35] Stop updating bi_idx, bv_len, bv_offset when
 a request completes
References: <20070731112539.22428.patches@notabene> <1070731021612.25144@suse.de>
In-Reply-To: <1070731021612.25144@suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Went through 1-4 and all look sane and seem to be nice clean ups with or
without the rest of series.  I didn't really dig into each conversion,
so I can't say much about correctness tho.

NeilBrown wrote:
> Some requests signal partial completion.  We currently record this
> by updating bi_idx, bv_len, and bv_offset.
> This is bad if the bi_io_vec is to be shared.
> So instead keep in "struct request" the amount of the first bio
> that has completed.  This is "first_offset" (i.e. offset in to 
> first bio).  Update and use that instead.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> @@ -3668,14 +3679,25 @@ EXPORT_SYMBOL(blk_rq_bio_prep);
>  
>  void *blk_rq_data(struct request *rq)
>  {
> -	return page_address(bio_page(rq->bio)) +
> -		bio_offset(rq->bio);
> +	struct bio_vec bvec;
> +	struct req_iterator i;
> +
> +	rq_for_each_segment(rq, i, bvec)
> +		return page_address(bvec.bv_page) + bvec.bv_offset;
> +
> +	return NULL;
>  }
>  EXPORT_SYMBOL(blk_rq_data);
>  
>  int blk_rq_cur_bytes(struct request *rq)
>  {
> -	return bio_iovec(rq->bio)->bv_len;
> +	struct bio_vec bvec;
> +	struct req_iterator i;
> +
> +	rq_for_each_segment(rq, i, bvec)
> +		return bvec.bv_len;
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL(blk_rq_cur_bytes);

Just a small nit.  It might be easier on eyes to use something like
blk_first_segment(rq), which can also be used to implement rq_for_each.

> diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
> --- .prev/include/linux/blkdev.h	2007-07-31 11:20:46.000000000 +1000
> +++ ./include/linux/blkdev.h	2007-07-31 11:20:46.000000000 +1000
> @@ -254,6 +254,7 @@ struct request {
>  
>  	struct bio *bio;
>  	struct bio *biotail;
> +	int first_offset;	/* offset into first bio in list */
>  
>  	struct hlist_node hash;	/* merge hash */
>  	/*
> @@ -640,14 +641,25 @@ static inline void blk_queue_bounce(stru
>  struct req_iterator {
>  	int i;
>  	struct bio *bio;
> +	int offset;
>  };
>  #define rq_for_each_segment(rq, _iter, bvec)	\
> -	for (_iter.bio = (rq)->bio; _iter.bio; _iter.bio = _iter.bio->bi_next) \
> -		for (_iter.i = _iter.bio->bi_idx, 			       \
> -			bvec = *bio_iovec_idx(_iter.bio, _iter.i);	       \
> +	for (_iter.bio = (rq)->bio, _iter.offset = (rq)->first_offset;	       \
> +	     _iter.bio;							       \
> +	     _iter.bio = _iter.bio->bi_next, _iter.offset = 0) 		       \
> +		for (_iter.i = _iter.bio->bi_idx; 			       \
>  		     _iter.i < _iter.bio->bi_vcnt;			       \
> -		     _iter.i++, bvec = *bio_iovec_idx(_iter.bio, _iter.i)      \
> -		)
> +		     _iter.i++						       \
> +		)							       \
> +			if (bvec = *bio_iovec_idx(_iter.bio, _iter.i),	       \
> +			    bvec.bv_offset += _iter.offset,		       \
> +			    bvec.bv_len <= _iter.offset			       \
> +				? (_iter.offset -= bvec.bv_len, 0)	       \
> +				: (bvec.bv_len -= _iter.offset,		       \
> +				   _iter.offset = 0,			       \
> +				   1))
> +
> +

Implementing and using blk_seg_iter_init(iter, rq) and
blk_seg_iter_next(iter) would be much more readable and take less cache
space.

-- 
tejun
