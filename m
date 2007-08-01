Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbXHAPtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbXHAPtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHAPtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:49:13 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:27591 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXHAPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=i6gRoeq/f8OgL07OEXTZ9I6vm7PUichxiOFRJ9yBWGFgN8LFGgAXLOEiuCbYndhjz8M9b8lK9Yl/6R2vfxKJ40LzQ2UePh3TZD7+zCfn9adwVtD0XMoQQ1idN1ApJ4Jf6mGMNcFRz9WZ/5vIgv6PRJtGq8e42sPnAxng2cqRXYU=
Date: Thu, 2 Aug 2007 00:49:04 +0900
From: Tejun Heo <htejun@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 008 of 35] Introduce bi_iocnt to count requests sharing the one bio.
Message-ID: <20070801154904.GE13674@htj.dyndns.org>
References: <20070731112539.22428.patches@notabene> <1070731021629.25195@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070731021629.25195@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 31, 2007 at 12:16:29PM +1000, NeilBrown wrote:
>  static int ordered_bio_endio(struct request *rq, struct bio *bio,
>  			     int error)
>  {
>  	struct request_queue *q = rq->q;
> -	bio_end_io_t *endio;
> -	void *private;
>  
>  	if (&q->bar_rq != rq)
>  		return 0;
>  
>  	/*
>  	 * Okay, this is the barrier request in progress, dry finish it.
> +	 *
> +	 * We'll finish this request again with the original
> +	 * bi_end_io after an error occurs or post flush is complete.
>  	 */
> +
>  	if (error && !q->orderr)
>  		q->orderr = error;
>  
> -	endio = bio->bi_end_io;
> -	private = bio->bi_private;
> -	bio->bi_end_io = flush_dry_bio_endio;
> -	bio->bi_private = q;
> -
> -	bio_endio(bio, error);
> -
> -	bio->bi_end_io = endio;
> -	bio->bi_private = private;
> +	set_bit(BIO_UPTODATE, &bio->bi_flags);
>  
>  	return 1;
>  }

The only reason bio_endio() was called from ordered_bio_endio() was to
get the same side effect (bio update) as real io completions, which
should be reversed by flush_dry_bio_endio() to re-finish it later.
This was done this way under the assumption that somebody might depend
on bio updates after partial bio completion.

Now that it's guaranteed that there's no partial bio completion, none
of the dancing is needed.  Setting BIO_UPTODATE can be removed too.

Nice clean up.  Thanks.

-- 
tejun
