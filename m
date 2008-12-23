Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbYLWLUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbYLWLUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 06:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYLWLUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 06:20:34 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59192 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYLWLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 06:20:33 -0500
Date: Tue, 23 Dec 2008 11:21:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] bio: zero inlined bio_vec
In-Reply-To: <20081223103138.GG32491@kernel.dk>
Message-ID: <Pine.LNX.4.64.0812231110320.9177@blonde.anvils>
References: <Pine.LNX.4.64.0812230103480.19807@blonde.anvils>
 <20081223080747.GE32491@kernel.dk> <Pine.LNX.4.64.0812230951100.3062@blonde.anvils>
 <20081223102320.GF32491@kernel.dk> <20081223103138.GG32491@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Jens Axboe wrote:
> On Tue, Dec 23 2008, Jens Axboe wrote:
> > 
> > That is, it iterates *bio_orig but indexes bio since it knows it has the
> > same number of segments. So this code is the odd one out, I'd be
> > surprised if we had more such cases. And since it would be nice to get
> > rid of the need to memset in general, can you try with the below patch?
> 
> Nope, that still wont be enough, since we leave entries 0..i-1
> uninitialized. Lets just do this instead.

Yes, that second version worked for me.  But if __blk_queue_bounce()
is indeed the odd one out (likely but not certain), then the extension
below makes more sense - I don't like how your bio.c returns a cleared
bio_vec in some cases but not in others.  This is running fine for me
on my test machines, but my test coverage is probably very poor (am I
ever using more than the inlined bio_vec?), and I've not really tried
to understand all the ways through bvec_alloc_bs().

Hugh

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -180,7 +180,7 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_
 	 * kzalloc() for the exact number of vecs right away.
 	 */
 	if (!bs)
-		bvl = kzalloc(nr * sizeof(struct bio_vec), gfp_mask);
+		bvl = kmalloc(nr * sizeof(struct bio_vec), gfp_mask);
 
 	/*
 	 * see comment near bvec_array define!
@@ -237,9 +237,6 @@ fallback:
 		}
 	}
 
-	if (bvl)
-		memset(bvl, 0, bvec_nr_vecs(*idx) * sizeof(struct bio_vec));
-
 	return bvl;
 }
 
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -198,11 +198,14 @@ static void __blk_queue_bounce(struct re
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
