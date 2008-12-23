Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbYLWKc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbYLWKc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 05:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYLWKcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 05:32:20 -0500
Received: from brick.kernel.dk ([93.163.65.50]:26802 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYLWKcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 05:32:19 -0500
Date: Tue, 23 Dec 2008 11:31:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] bio: zero inlined bio_vec
Message-ID: <20081223103138.GG32491@kernel.dk>
References: <Pine.LNX.4.64.0812230103480.19807@blonde.anvils> <20081223080747.GE32491@kernel.dk> <Pine.LNX.4.64.0812230951100.3062@blonde.anvils> <20081223102320.GF32491@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223102320.GF32491@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23 2008, Jens Axboe wrote:
> On Tue, Dec 23 2008, Hugh Dickins wrote:
> > On Tue, 23 Dec 2008, Jens Axboe wrote:
> > > On Tue, Dec 23 2008, Hugh Dickins wrote:
> > > > bvec_alloc_bs() zeroes its bio_vec, and at least __blk_queue_bounce()
> > > > relies upon that: therefore bio_alloc_bioset() must zero the inlined
> > > > bio_vec - without that, lots of nastiness occurs in bounce_end_io and
> > > > blk_rq_map_sg and other places when booting up my PAE box.
> > > 
> > > Hmm, where does it die? Nobody should look at the bio_vec index beyond
> > > bio->bi_vcnt, and 0...bio->bi_vcnt-1 should always be initialized due to
> > > the way we fill the entries.
> > 
> > It dies in a great variety of places, different mmotms and different
> > nexts and different configs on that box preferring to collapse in
> > different places all over the blk/bounce/scsi/map_sg stack.
> > 
> > bounce_end_io() and blk_rq_map_sg() and nommu_map_sg() stick in my
> > mind as among the locations seen, though perhaps the actual oopses
> > and BUGs were sometimes a level below.
> > 
> > __blk_queue_bounce() does one transit of the bio skipping any
> > segments which don't need bouncing, then a second transit of the
> > newly allocated bounce bio assuming
> > 		if (!to->bv_page) {
> > means that it needs to copy from orig_bio: so if the new bio was
> > not zeroed there, it'll skip that segment and leave junk?
> 
> It's because the code in question does this:
> 
>         __bio_for_each_segment(from, *bio_orig, i, 0) {
>                 to = bio_iovec_idx(bio, i);
>                 if (!to->bv_page) {
> 
> That is, it iterates *bio_orig but indexes bio since it knows it has the
> same number of segments. So this code is the odd one out, I'd be
> surprised if we had more such cases. And since it would be nice to get
> rid of the need to memset in general, can you try with the below patch?
> 
> The reason why it also oopses in other places is probably because this
> very same code can leave junk in in the bio_vec if it happens to find a
> non-NULL page there that isn't valid.
> 
> diff --git a/mm/bounce.c b/mm/bounce.c
> index 06722c4..f4907d3 100644
> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -181,12 +181,22 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  	struct page *page;
>  	struct bio *bio = NULL;
>  	int i, rw = bio_data_dir(*bio_orig);
> -	struct bio_vec *to, *from;
> +	struct bio_vec *uninitialized_var(to), *from;
>  
>  	bio_for_each_segment(from, *bio_orig, i) {
>  		page = from->bv_page;
>  
>  		/*
> +		 * Make sure we initialize the page element even if we
> +		 * don't need to bounce it, since we'll be checking for
> +		 * a valid page further down.
> +		 */
> +		if (bio) {
> +			to = bio->bi_io_vec + i;
> +			to->bv_page = NULL;
> +		}
> +
> +		/*
>  		 * is destination page below bounce pfn?
>  		 */
>  		if (page_to_pfn(page) <= q->bounce_pfn)
> @@ -195,10 +205,10 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  		/*
>  		 * irk, bounce it
>  		 */
> -		if (!bio)
> +		if (!bio) {
>  			bio = bio_alloc(GFP_NOIO, (*bio_orig)->bi_vcnt);
> -
> -		to = bio->bi_io_vec + i;
> +			to = bio->bi_io_vec + i;
> +		}
>  
>  		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
>  		to->bv_len = from->bv_len;

Nope, that still wont be enough, since we leave entries 0..i-1
uninitialized. Lets just do this instead.

diff --git a/mm/bounce.c b/mm/bounce.c
index 06722c4..877be42 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -195,11 +195,14 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		/*
 		 * irk, bounce it
 		 */
-		if (!bio)
-			bio = bio_alloc(GFP_NOIO, (*bio_orig)->bi_vcnt);
+		if (!bio) {
+			unsigned int vcnt = (*bio_orig)->bi_vcnt;
 
-		to = bio->bi_io_vec + i;
+			bio = bio_alloc(GFP_NOIO, vcnt);
+			memset(bio->bi_io_vec, 0,vcnt * sizeof(struct bio_vec));
+		}
 
+		to = bio->bi_io_vec + i;
 		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
 		to->bv_len = from->bv_len;
 		to->bv_offset = from->bv_offset;

-- 
Jens Axboe

