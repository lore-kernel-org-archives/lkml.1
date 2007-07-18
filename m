Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXGRUgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXGRUgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbXGRUf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:35:58 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50085 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbXGRUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:35:56 -0400
Date: Wed, 18 Jul 2007 21:35:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ken Chen <kenchen@google.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
In-Reply-To: <20070718184006.GF11657@kernel.dk>
Message-ID: <Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com>
References: <20070718141533.GA11657@kernel.dk>
 <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com>
 <20070718182456.GE11657@kernel.dk> <20070718184006.GF11657@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAamVucy5heGJvZUBvcmFjbGUuY29tAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAa2VuY2hlbkBnb29nbGUuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Jens Axboe wrote:
> 
> Since I had my hands dirty already...

Great, thanks.  (There's also such a test in fs/nfs/direct.c,
but let's not trouble Trond until we've settled what to do here.)

> 
> ---
> 
> [PATCH] Remove PageCompound() checks before calling set_page_dirty()
> 
> Pre commit 41d78ba55037468e6c86c53e3076d1a74841de39 it was illegal
> to call set_page_dirty() on a compound page, since it stored the
> destructor in the mapping field. But now it's ok, so remove the
> ugly PageCompound() checks from bio and direct-io.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

I was about to Ack that, now that I've found something or other in the
libhugetlb testsuite comes this way, even on page[1], without showing
any problem.

However, I have noticed a particular inefficiency arising: that
bio_check_pages_dirty test specifically avoids pages already
PageDirty; but hugetlbfs_set_page_dirty carefully redirects to
set the head page dirty: so tail pages of a hugetlb compound page
will tend never to be PageDirty, and keep on coming back this way.

Which led me to look up the origin of those PageCompound tests:
Author: Andrew Morton <akpm@osdl.org>
Date:   Sun Sep 21 01:42:22 2003 -0700

    [PATCH] Speed up direct-io hugetlbpage handling
    
    This patch short-circuits all the direct-io page dirtying logic for
    higher-order pages.  Without this, we pointlessly bounce BIOs up to keventd
    all the time.

diff --git a/fs/bio.c b/fs/bio.c
index d016523..2463163 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -532,6 +532,12 @@ void bio_unmap_user(struct bio *bio, int write_to_vm)
  * check that the pages are still dirty.   If so, fine.  If not, redirty them
  * in process context.
  *
+ * We special-case compound pages here: normally this means reads into hugetlb
+ * pages.  The logic in here doesn't really work right for compound pages
+ * because the VM does not uniformly chase down the head page in all cases.
+ * But dirtiness of compound pages is pretty meaningless anyway: the VM doesn't
+ * handle them at all.  So we skip compound pages here at an early stage.
...

It looks like I was wrong in thinking it was just trying to avoid 
the crash on page[1].mapping.  At the least, your patch needs also
to remove that paragraph of comment from Andrew.  But really, it
looks like those PageCompound tests should stay, unless you can
persuade Andrew to Ack their removal.

Except (now, how many times can I change my mind in the course of
one email?), hugetlbfs_set_page_dirty was specifically added by
Ken Chen to avoid losing data via /proc/sys/vm/drop_caches.  Yet
fs/bio.c is carefully avoiding going there when dirtying a hugepage.
How does this work?  Looks like those PageCompound tests need to go!

I'm lost: I hope Andrew and Ken can sort it out for us.

Hugh

> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 33e4634..1e12416 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -911,7 +911,7 @@ void bio_set_pages_dirty(struct bio *bio)
>  	for (i = 0; i < bio->bi_vcnt; i++) {
>  		struct page *page = bvec[i].bv_page;
>  
> -		if (page && !PageCompound(page))
> +		if (page)
>  			set_page_dirty_lock(page);
>  	}
>  }
> @@ -978,7 +978,7 @@ void bio_check_pages_dirty(struct bio *bio)
>  	for (i = 0; i < bio->bi_vcnt; i++) {
>  		struct page *page = bvec[i].bv_page;
>  
> -		if (PageDirty(page) || PageCompound(page)) {
> +		if (PageDirty(page)) {
>  			page_cache_release(page);
>  			bvec[i].bv_page = NULL;
>  		} else {
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 52bb263..72195bc 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -426,7 +426,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
>  		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
>  			struct page *page = bvec[page_no].bv_page;
>  
> -			if (dio->rw == READ && !PageCompound(page))
> +			if (dio->rw == READ)
>  				set_page_dirty_lock(page);
>  			page_cache_release(page);
>  		}
> 
> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
