Return-Path: <linux-kernel-owner+w=401wt.eu-S936142AbXJQR3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936142AbXJQR3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762597AbXJQR3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:29:39 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9446 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762882AbXJQR3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:29:37 -0400
Date: Wed, 17 Oct 2007 19:29:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017172932.GI15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017172158.GH15552@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Jens Axboe wrote:
> On Wed, Oct 17 2007, Jens Axboe wrote:
> > On Wed, Oct 17 2007, Jens Axboe wrote:
> > > On Wed, Oct 17 2007, Linus Torvalds wrote:
> > > > 
> > > > 
> > > > On Wed, 17 Oct 2007, Ingo Molnar wrote:
> > > > > 
> > > > > Jens, just got this crash on a testbox:
> > > > 
> > > > The code in question is:
> > > > 
> > > >      mov    %edx,0xc(%esp)
> > > >      mov    (%ebx),%edi
> > > >      mov    %edi,%edx
> > > >      sub    %eax,%edx
> > > >      mov    %edx,%eax
> > > >      sar    $0x5,%eax
> > > >      shl    $0xc,%eax
> > > >      add    0x8(%ebx),%eax
> > > >      cmp    %eax,0xc(%esp)
> > > >      je     +126
> > > >      mov    0x10(%esi),%eax	<----- Oops
> > > >      lea    0x10(%esi),%edx
> > > >      test   $0x1,%al
> > > >      jne    +76
> > > >      mov    %edi,(%esi)
> > > >      mov    %ebp,0xc(%esi)
> > > >      mov    0x8(%ebx),%eax
> > > >      mov    %eax,0x4(%esi)
> > > > 
> > > > 
> > > > and it looks like %esi is overflowing from one page to the next one, ie:
> > > > 
> > > > 	BUG: unable to handle kernel paging request at virtual address 7ca76000
> > > > 	ESI: 7ca75ff0
> > > > 
> > > > and you caught this thanks to page-alloc debugging again.
> > > > 
> > > > I think I can match that up with the source code: that's "sg_next()". It's 
> > > > doing:
> > > > 
> > > >         sg++;
> > > > 
> > > >         if (unlikely(sg_is_chain(sg)))
> > > >                 sg = sg_chain_ptr(sg);
> > > > 
> > > >         return sg;
> > > > 
> > > > and the oopsing instruction is that load of "sg->page" in the assembly 
> > > > code:
> > > > 
> > > > 	mov    0x10(%esi),%eax		# %eax = sg->page
> > > > 	lea    0x10(%esi),%edx		# %edx = sg+1;
> > > > 	test   $0x1,%al			# if (unlikely(sg_is_chain()))
> > > > 	jne    +76
> > > > 
> > > > Jens?
> > > 
> > > Yep, that's what I came up with as well - I asked Ingo for a dump in
> > > private, but ended up just using ksymoops to decode the line.
> > > 
> > > The way blk_rq_map_sg() operates is that it ends up doing a
> > > 
> > >         next_sg = sg_next(sg);
> > > 
> > > even though sg may be the last entry. Perhaps this is crapping out,
> > > although if sg is a valid address, then sg + 1 should be as well.
> > > next_sg may end up being crap, in fact it will, but we'll never use that
> > > unless there are more entries to fill. And if there is, then both sg and
> > > next_sg were valid.
> > > 
> > > So nothing in for-linus should fix it, I'll try and come up with an
> > > alternate way to assign next_sg so it's always valid.
> > 
> > OK, the below should actually be safe, I don't know why I talked myself
> > into the next_sg stuff in the beginning. It's always safe to zero sg,
> > since it's a valid entry - nothing to save in ->page. Ingo, does this
> > work for you?
> > 
> > diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > index 9e3f3cc..3935469 100644
> > --- a/block/ll_rw_blk.c
> > +++ b/block/ll_rw_blk.c
> > @@ -1322,8 +1322,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
> >  		  struct scatterlist *sglist)
> >  {
> >  	struct bio_vec *bvec, *bvprv;
> > -	struct scatterlist *next_sg, *sg;
> >  	struct req_iterator iter;
> > +	struct scatterlist *sg;
> >  	int nsegs, cluster;
> >  
> >  	nsegs = 0;
> > @@ -1333,7 +1333,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
> >  	 * for each bio in rq
> >  	 */
> >  	bvprv = NULL;
> > -	sg = next_sg = &sglist[0];
> > +	sg = NULL;
> >  	rq_for_each_segment(bvec, rq, iter) {
> >  		int nbytes = bvec->bv_len;
> >  
> > @@ -1349,8 +1349,10 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
> >  			sg->length += nbytes;
> >  		} else {
> >  new_segment:
> > -			sg = next_sg;
> > -			next_sg = sg_next(sg);
> > +			if (!sg)
> > +				sg = sglist;
> > +			else
> > +				sg = sg_next(sg);
> >  
> >  			memset(sg, 0, sizeof(*sg));
> >  			sg->page = bvec->bv_page;
> > 
> 
> Scratch that, it cannot work... I'll think up a different approach.

OK, it is fine, as long as the sglist is cleared initially. And I don't
think there's anyway around that, clearly I didn't think long enough
before including the memset() removal from Tomo.

Ingo, please try this rolled up version.

Linus, this should work. It would probably be best if you first did a
git revert on f5c0dde4c66421a3a2d7d6fa604a712c9b0744e5 and then applied
the ll_rw_blk.c bit alone. Do you want me to stuff that (revert + patch)
into a branch for you to pull?

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 9e3f3cc..3935469 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1322,8 +1322,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		  struct scatterlist *sglist)
 {
 	struct bio_vec *bvec, *bvprv;
-	struct scatterlist *next_sg, *sg;
 	struct req_iterator iter;
+	struct scatterlist *sg;
 	int nsegs, cluster;
 
 	nsegs = 0;
@@ -1333,7 +1333,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	 * for each bio in rq
 	 */
 	bvprv = NULL;
-	sg = next_sg = &sglist[0];
+	sg = NULL;
 	rq_for_each_segment(bvec, rq, iter) {
 		int nbytes = bvec->bv_len;
 
@@ -1349,8 +1349,10 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 			sg->length += nbytes;
 		} else {
 new_segment:
-			sg = next_sg;
-			next_sg = sg_next(sg);
+			if (!sg)
+				sg = sglist;
+			else
+				sg = sg_next(sg);
 
 			memset(sg, 0, sizeof(*sg));
 			sg->page = bvec->bv_page;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c86be7..aac8a02 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -764,6 +764,8 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		if (unlikely(!sgl))
 			goto enomem;
 
+		memset(sgl, 0, sizeof(*sgl) * sgp->size);
+
 		/*
 		 * first loop through, set initial index and return value
 		 */

-- 
Jens Axboe

