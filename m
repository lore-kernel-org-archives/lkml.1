Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYLWIIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYLWIIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 03:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYLWII3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 03:08:29 -0500
Received: from brick.kernel.dk ([93.163.65.50]:21701 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbYLWII2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 03:08:28 -0500
Date: Tue, 23 Dec 2008 09:07:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] bio: zero inlined bio_vec
Message-ID: <20081223080747.GE32491@kernel.dk>
References: <Pine.LNX.4.64.0812230103480.19807@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812230103480.19807@blonde.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23 2008, Hugh Dickins wrote:
> bvec_alloc_bs() zeroes its bio_vec, and at least __blk_queue_bounce()
> relies upon that: therefore bio_alloc_bioset() must zero the inlined
> bio_vec - without that, lots of nastiness occurs in bounce_end_io and
> blk_rq_map_sg and other places when booting up my PAE box.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  fs/bio.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next/fs/bio.c	2008-12-21 20:49:25.000000000 +0000
> +++ fixed/fs/bio.c	2008-12-22 21:10:06.000000000 +0000
> @@ -324,6 +324,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
>  			if (nr_iovecs <= BIO_INLINE_VECS) {
>  				idx = 0;
>  				bvl = bio->bi_inline_vecs;
> +				memset(bvl, 0, BIO_INLINE_VECS *
> +							sizeof(struct bio_vec));
>  				nr_iovecs = BIO_INLINE_VECS;
>  			} else {
>  				bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx,

Hmm, where does it die? Nobody should look at the bio_vec index beyond
bio->bi_vcnt, and 0...bio->bi_vcnt-1 should always be initialized due to
the way we fill the entries.

-- 
Jens Axboe

