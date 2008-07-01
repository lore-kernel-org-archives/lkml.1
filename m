Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYGAHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYGAHOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYGAHOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:14:03 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20698 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYGAHOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:14:01 -0400
Date: Tue, 1 Jul 2008 09:14:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitri Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fix bio_add_page for non trivial merge_bvec_fn case
Message-ID: <20080701071359.GY20826@kernel.dk>
References: <m3y75gszgb.fsf@dmon-lap.sw.ru> <20080630133739.fc4effec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630133739.fc4effec.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30 2008, Andrew Morton wrote:
> On Sun, 08 Jun 2008 19:45:08 +0400
> Dmitri Monakhov <dmonakhov@openvz.org> wrote:
> 
> > We have to properly decrease all related bio's counters, especially bi_size
> > in order to merge_bvec_fn return right result. Usually this result in
> > false merge rejects for two absolutely valid bio_vecs. This may cause 
> > significant performance penalty for example Itanium: page_size == 16k,
> > fs_block_size == 1k and block device is raid with small chunk_size.
> > 
> 
> Please cc Jens on BIO changes.
> 
> > ---
> >  fs/bio.c |   16 ++++++++++++----
> >  1 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 7856257..d713074 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -332,14 +332,21 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
> >  
> >  		if (page == prev->bv_page &&
> >  		    offset == prev->bv_offset + prev->bv_len) {
> > +			/* Temprory detacth last bio_vec. */
> 
> whoa, drunken speling.
> 
> > +			bio->bi_size -= prev->bv_len;
> > +			bio->bi_vcnt--;
> > +			bio->bi_phys_segments--;
> > +			bio->bi_hw_segments--;
> > +

This logic isn't quite right, the rules for what constitutes a new hw or
phys segment is not a 1:1 mapping with number of pages in the bio. How
about just dropping the segment decrement? The merge_bvec fn should not
care, and we'll retry and coalesce segment count if we get to the limit
anyway.

-- 
Jens Axboe

