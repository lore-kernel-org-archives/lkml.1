Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbXGSRh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbXGSRh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763275AbXGSRhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:37:12 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36301 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124AbXGSRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:37:07 -0400
Date: Thu, 19 Jul 2007 18:35:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, David Gibson <david@gibson.dropbear.id.au>,
       Ken Chen <kenchen@google.com>, Bill Irwin <wli@holomorphy.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
In-Reply-To: <20070719062934.GT11657@kernel.dk>
Message-ID: <Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
References: <20070718141533.GA11657@kernel.dk>
 <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com>
 <20070718182456.GE11657@kernel.dk> <20070718184006.GF11657@kernel.dk>
 <Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com>
 <20070719062934.GT11657@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWdsQHVzLmlibS5jb20AY2xhbWV0ZXJAc2dpLmNvbQBqZW5zLmF4Ym9lQG9yYWNsZS5jb20AYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwB3bGlAaG9sb21vcnBoeS5jb20Aa2VuY2hlbkBnb29nbGUuY29tAGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Jens Axboe wrote:
> On Wed, Jul 18 2007, Hugh Dickins wrote:
> > On Wed, 18 Jul 2007, Jens Axboe wrote:
> > > 
> > > Since I had my hands dirty already...
> > 
> > Great, thanks.  (There's also such a test in fs/nfs/direct.c,
> > but let's not trouble Trond until we've settled what to do here.)

I've added several of the hugetlb guys to the CC list, plus CLameter;
but again not yet Trond since the details won't be of much interest
to him; though I have included fs/nfs/direct.c in the patch below,
since it's now looking like a bugfix rather than a cleanup.
I've kept in most of the background text for newcomers.

> > > [PATCH] Remove PageCompound() checks before calling set_page_dirty()
> > > 
> > > Pre commit 41d78ba55037468e6c86c53e3076d1a74841de39 it was illegal
> > > to call set_page_dirty() on a compound page, since it stored the
> > > destructor in the mapping field. But now it's ok, so remove the
> > > ugly PageCompound() checks from bio and direct-io.
> > > 
> > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > 
> > I was about to Ack that, now that I've found something or other in the
> > libhugetlb testsuite comes this way, even on page[1], without showing
> > any problem.
> > 
> > However, I have noticed a particular inefficiency arising: that
> > bio_check_pages_dirty test specifically avoids pages already
> > PageDirty; but hugetlbfs_set_page_dirty carefully redirects to
> > set the head page dirty: so tail pages of a hugetlb compound page
> > will tend never to be PageDirty, and keep on coming back this way.
> > 
> > Which led me to look up the origin of those PageCompound tests:
> > Author: Andrew Morton <akpm@osdl.org>
> > Date:   Sun Sep 21 01:42:22 2003 -0700
> > 
> >     [PATCH] Speed up direct-io hugetlbpage handling
> >     
> >     This patch short-circuits all the direct-io page dirtying logic for
> >     higher-order pages.  Without this, we pointlessly bounce BIOs up to keventd
> >     all the time.
> > 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index d016523..2463163 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -532,6 +532,12 @@ void bio_unmap_user(struct bio *bio, int write_to_vm)
> >   * check that the pages are still dirty.   If so, fine.  If not, redirty them
> >   * in process context.
> >   *
> > + * We special-case compound pages here: normally this means reads into hugetlb
> > + * pages.  The logic in here doesn't really work right for compound pages
> > + * because the VM does not uniformly chase down the head page in all cases.
> > + * But dirtiness of compound pages is pretty meaningless anyway: the VM doesn't
> > + * handle them at all.  So we skip compound pages here at an early stage.
> > ...
> > 
> > It looks like I was wrong in thinking it was just trying to avoid 
> > the crash on page[1].mapping.  At the least, your patch needs also
> > to remove that paragraph of comment from Andrew.  But really, it
> > looks like those PageCompound tests should stay, unless you can
> > persuade Andrew to Ack their removal.
> > 
> > Except (now, how many times can I change my mind in the course of
> > one email?), hugetlbfs_set_page_dirty was specifically added by
> > Ken Chen to avoid losing data via /proc/sys/vm/drop_caches.  Yet
> > fs/bio.c is carefully avoiding going there when dirtying a hugepage.
> > How does this work?  Looks like those PageCompound tests need to go!
> 
> Hehe, that didn't really get us much further, did it? :-)

And I've changed my mind several times since then too: from thinking
that the DIO case gives hugetlbfs a lost dirty bug, to thinking that
it's okay after all, to thinking again that yes we do have a bug.

> My opinion is that since the win is marginal at best, we want to remove
> such tests as it just clutters up the code. And it's definitely not
> obvious why the tests are there, since they are not commented at all.

That's very unfair to Andrew, who took the trouble to write long and
enlightening comments above the functions.  Let's blame ourselves for
not looking there and reading them.

You won't much like the compound_head(page) I'm putting into
bio_check_pages_dirty, but I think it is being reasonable to
try to avoid scheduling work when that's hardly ever needed
(dirty already set and not cleaned in the meanwhile).

There are enough twists and turns in this area, that I also think
it's as well to keep something here to think about and comment on.

> Since it's even confusing you, then we can't expect the more vm ignorant
> of us (which definitely includes me) to grasp it!

Oh, it doesn't take much to confuse me!

> > I'm lost: I hope Andrew and Ken can sort it out for us.

I believe I've reached my conclusion in the patch below, but definitely
need others to check and test.  I'll be out of contact for a few days
from tomorrow, so better someone else take this up.

> Posting a revised version, still leaving nfs out of it (I'll ping Trond
> to do the same, if this goes in).

I started from your patch.  But it now seems to me a bugfix to remove
those PageCompound tests, because they're preventing a hugetlb page
from being marked dirty, when Ken needs it to be marked dirty so
/proc/sys/vm/drop_caches doesn't drop the data read in by DIO.
(His original patch went into -stable: would the patch fixing
this all up need to go into -stable?)

For a while I thought it wasn't important, because get_user_pages
normally marks the pages dirty at the beginning, and there's no
pdflushing of hugetlb pages to clean them in the meanwhile.

But get_user_pages goes a different route on hugetlb pages, it goes
off to follow_hugetlb_page.  Which doesn't even take an argument to
tell it whether the page is being written to or not.  So far as I
can see, there's no preliminary set_page_dirty in that case (but
haven't checked in practice).  Therefore I now think Ken's case
would rely on bio.c or direct-io.c to set the page dirty after all.

(Side issue not addressed in this patch at all: the hugetlb folks
introduced private hugetlb mappings and hugetlb_cow in 2.6.16: yet
get_user_pages appears not to honour that, which seems a serious
omission: breaking COW is an important duty of get_user_pages.)

I think set_page_dirty just has to act on compound_head(page):
it's only in the head page that page->mapping is set, so set_page_dirty
can't even discover that it ought to go to hugetlbfs_set_page_dirty
without doing the compound_head(page) first.  Which then leaves
the distinct hugetlbfs_set_page_dirty rather pointless: we can
just use the standard __set_page_dirty_no_writeback.

Without that change, even after removing the PageCompound exclusions
from bio.c as you did, I suspect that DIO to a tail page of a
hugetlb page would never get to dirty the head page -
something the libhugetlb guys might like to test for.

I didn't see any attention to set_page_dirty in Christoph's
Large Blocksize (variable page_cachesize) patches, but I expect
he'd also be wanting set_page_dirty to act on compound_head.

Hugh

--- 2.6.22-git12/fs/bio.c	2007-07-19 13:58:42.000000000 +0100
+++ linux/fs/bio.c	2007-07-19 17:05:46.000000000 +0100
@@ -884,12 +884,6 @@ struct bio *bio_map_kern(request_queue_t
  * check that the pages are still dirty.   If so, fine.  If not, redirty them
  * in process context.
  *
- * We special-case compound pages here: normally this means reads into hugetlb
- * pages.  The logic in here doesn't really work right for compound pages
- * because the VM does not uniformly chase down the head page in all cases.
- * But dirtiness of compound pages is pretty meaningless anyway: the VM doesn't
- * handle them at all.  So we skip compound pages here at an early stage.
- *
  * Note that this code is very hard to test under normal circumstances because
  * direct-io pins the pages with get_user_pages().  This makes
  * is_page_cache_freeable return false, and the VM will not clean the pages.
@@ -911,7 +905,7 @@ void bio_set_pages_dirty(struct bio *bio
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		struct page *page = bvec[i].bv_page;
 
-		if (page && !PageCompound(page))
+		if (page)
 			set_page_dirty_lock(page);
 	}
 }
@@ -978,7 +972,12 @@ void bio_check_pages_dirty(struct bio *b
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		struct page *page = bvec[i].bv_page;
 
-		if (PageDirty(page) || PageCompound(page)) {
+		/*
+		 * set_page_dirty(page) sets PageDirty on the head when
+		 * PageCompound: therefore that's where we should look when
+		 * trying to avoid scheduling our dirty work unnecessarily.
+		 */
+		if (PageDirty(compound_head(page))) {
 			page_cache_release(page);
 			bvec[i].bv_page = NULL;
 		} else {
--- 2.6.22-git12/fs/direct-io.c	2007-07-09 00:32:17.000000000 +0100
+++ linux/fs/direct-io.c	2007-07-19 17:05:46.000000000 +0100
@@ -426,7 +426,7 @@ static int dio_bio_complete(struct dio *
 		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
 			struct page *page = bvec[page_no].bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (dio->rw == READ)
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
--- 2.6.22-git12/fs/hugetlbfs/inode.c	2007-07-19 13:58:43.000000000 +0100
+++ linux/fs/hugetlbfs/inode.c	2007-07-19 17:05:46.000000000 +0100
@@ -470,17 +470,6 @@ static int hugetlbfs_symlink(struct inod
 	return error;
 }
 
-/*
- * mark the head page dirty
- */
-static int hugetlbfs_set_page_dirty(struct page *page)
-{
-	struct page *head = compound_head(page);
-
-	SetPageDirty(head);
-	return 0;
-}
-
 static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(dentry->d_sb);
@@ -566,7 +555,7 @@ static const struct address_space_operat
 	.readpage	= hugetlbfs_readpage,
 	.prepare_write	= hugetlbfs_prepare_write,
 	.commit_write	= hugetlbfs_commit_write,
-	.set_page_dirty	= hugetlbfs_set_page_dirty,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 };
 
 
--- 2.6.22-git12/fs/nfs/direct.c	2007-07-19 13:58:43.000000000 +0100
+++ linux/fs/nfs/direct.c	2007-07-19 17:05:46.000000000 +0100
@@ -133,8 +133,7 @@ static void nfs_direct_dirty_pages(struc
 	npages = (count + (pgbase & ~PAGE_MASK) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	for (i = 0; i < npages; i++) {
 		struct page *page = pages[i];
-		if (!PageCompound(page))
-			set_page_dirty(page);
+		set_page_dirty(page);
 	}
 }
 
--- 2.6.22-git12/mm/page-writeback.c	2007-07-19 13:58:49.000000000 +0100
+++ linux/mm/page-writeback.c	2007-07-19 17:05:46.000000000 +0100
@@ -861,7 +861,10 @@ EXPORT_SYMBOL(redirty_page_for_writepage
  */
 int fastcall set_page_dirty(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
+
+	page = compound_head(page);
+	mapping = page_mapping(page);
 
 	if (likely(mapping)) {
 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
