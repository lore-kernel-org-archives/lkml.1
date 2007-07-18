Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbXGRSkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbXGRSkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbXGRSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:40:32 -0400
Received: from brick.kernel.dk ([80.160.20.94]:29614 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbXGRSkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:40:32 -0400
Date: Wed, 18 Jul 2007 20:40:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
Message-ID: <20070718184006.GF11657@kernel.dk>
References: <20070718141533.GA11657@kernel.dk> <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com> <20070718182456.GE11657@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718182456.GE11657@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18 2007, Jens Axboe wrote:
> On Wed, Jul 18 2007, Hugh Dickins wrote:
> > On Wed, 18 Jul 2007, Jens Axboe wrote:
> > > 
> > > We have these checks scattered, makes sense to put them in
> > > set_page_dirty() instead. This also fixes a bug where __bio_unmap_user()
> > > does set_page_dirty_lock() without checking for a compound page, instead
> > > of adding one more check we move it to set_page_dirty().
> > > 
> > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > 
> > > diff --git a/fs/bio.c b/fs/bio.c
> > > index cd888f9..ff96cd9 100644
> > > --- a/fs/bio.c
> > > +++ b/fs/bio.c
> > > @@ -902,7 +902,7 @@ void bio_set_pages_dirty(struct bio *bio)
> > >  	for (i = 0; i < bio->bi_vcnt; i++) {
> > >  		struct page *page = bvec[i].bv_page;
> > >  
> > > -		if (page && !PageCompound(page))
> > > +		if (page)
> > >  			set_page_dirty_lock(page);
> > >  	}
> > >  }
> > > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > > index 52bb263..72195bc 100644
> > > --- a/fs/direct-io.c
> > > +++ b/fs/direct-io.c
> > > @@ -426,7 +426,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
> > >  		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
> > >  			struct page *page = bvec[page_no].bv_page;
> > >  
> > > -			if (dio->rw == READ && !PageCompound(page))
> > > +			if (dio->rw == READ)
> > >  				set_page_dirty_lock(page);
> > >  			page_cache_release(page);
> > >  		}
> > > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > > index 886ea0d..3c590b9 100644
> > > --- a/mm/page-writeback.c
> > > +++ b/mm/page-writeback.c
> > > @@ -861,8 +861,12 @@ EXPORT_SYMBOL(redirty_page_for_writepage);
> > >   */
> > >  int fastcall set_page_dirty(struct page *page)
> > >  {
> > > -	struct address_space *mapping = page_mapping(page);
> > > +	struct address_space *mapping;
> > > +	
> > > +	if (unlikely(PageCompound(page)))
> > > +		return 0;
> > >  
> > > +	mapping = page_mapping(page);
> > >  	if (likely(mapping)) {
> > >  		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
> > >  #ifdef CONFIG_BLOCK
> > 
> > I'd prefer it if we just remove those two tests from fs without
> > adding one into set_page_dirty at all; though I've not tested
> > that recently (replying before remembering the easiest way to
> > do so), and others may disagree.
> > 
> > The real reason for those tests was that pre-2.6.16 a compound page
> > stored its destructor in page[1].mapping: which went badly wrong if
> > that constituent page ever ended up being passed to set_page_dirty.
> > 
> > I moved it somewhere safer in 41d78ba55037468e6c86c53e3076d1a74841de39
> > but didn't have the courage to remove those tests you're now removing:
> > the earlier we skip out from that case, the more efficiently it's
> > handled, I didn't want to slow those paths down in case they were
> > important to someone.
> > 
> > So I'd be glad to see those tests now gone without replacement.
> 
> OK, you clearly have more knowledge in that area than I, but I do wish
> that you would have made a note in the code at least to remove things
> like this. It's pretty ugly to have superflous tests like that,
> especially since there was not even a comment saying _why_ you could not
> call set_page_dirty() on a compound page. I see it in the commit text,
> but nobody looking at fs/bio.c or fs/direct-io.c would directly find any
> reference of that.
> 
> Could you submit a patch removing the tests?

Since I had my hands dirty already...

---

[PATCH] Remove PageCompound() checks before calling set_page_dirty()

Pre commit 41d78ba55037468e6c86c53e3076d1a74841de39 it was illegal
to call set_page_dirty() on a compound page, since it stored the
destructor in the mapping field. But now it's ok, so remove the
ugly PageCompound() checks from bio and direct-io.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/bio.c b/fs/bio.c
index 33e4634..1e12416 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -911,7 +911,7 @@ void bio_set_pages_dirty(struct bio *bio)
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		struct page *page = bvec[i].bv_page;
 
-		if (page && !PageCompound(page))
+		if (page)
 			set_page_dirty_lock(page);
 	}
 }
@@ -978,7 +978,7 @@ void bio_check_pages_dirty(struct bio *bio)
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		struct page *page = bvec[i].bv_page;
 
-		if (PageDirty(page) || PageCompound(page)) {
+		if (PageDirty(page)) {
 			page_cache_release(page);
 			bvec[i].bv_page = NULL;
 		} else {
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 52bb263..72195bc 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -426,7 +426,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
 			struct page *page = bvec[page_no].bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (dio->rw == READ)
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}

-- 
Jens Axboe

