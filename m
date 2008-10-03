Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYJCCcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYJCCcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 22:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYJCCcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 22:32:35 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:47260 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753382AbYJCCce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 22:32:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=qHWmu5IDJGVUSDci9FemNQzsd/9u0MCEuXV4dDoYHfJLWNjrgJRwRCmsiHf6Xe+VDKjm0w1vCli0TCTm0flYCg9F9kB63/J7Y+mTAF1ikN6xq2VW2WH6TjAv85lZRvvXPCEX0fOU9q99A4DU3YLqaS0Bh7jRAlSjt468+e53ok4=  ;
X-YMail-OSG: QKuDpYkVM1m5KVO3CJZnQ8sDtbohVZSHn03LrFPfqlRiJm0CWG0L4A4FddMiW7S6T2WLS36yV6vvM13Y5FulR8yEZPp_PkX0iQv74Dx0hGH2ZlsFVbZhgqvsGxv9kcmaM1CA_xs7VqC9x81SBfleMW0n8pwslzs0bo69e8.CGSN9SzC0JVA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 12:32:23 +1000
User-Agent: KMail/1.9.5
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com> <20080923154905.50d4b0fa.akpm@linux-foundation.org>
In-Reply-To: <20080923154905.50d4b0fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3QY5IvQ7RNtzEn2"
Message-Id: <200810031232.23836.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_3QY5IvQ7RNtzEn2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 24 September 2008 08:49, Andrew Morton wrote:
> On Tue, 23 Sep 2008 18:34:20 -0400 (EDT)
>
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > On Mon, 22 Sep 2008 17:10:04 -0400 (EDT)
> > >
> > > Mikulas Patocka <mpatocka@xxxxxxxxxx> wrote:
> > > > The bug happens when one process is doing sequential buffered writes
> > > > to a block device (or file) and another process is attempting to
> > > > execute sync(), fsync() or direct-IO on that device (or file). This
> > > > syncing process will wait indefinitelly, until the first writing
> > > > process finishes.
> > > >
> > > > For example, run these two commands:
> > > > dd if=/dev/zero of=/dev/sda1 bs=65536 &
> > > > dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct
> > > >
> > > > The bug is caused by sequential walking of address space in
> > > > write_cache_pages and wait_on_page_writeback_range: if some other
> > > > process is constantly making dirty and writeback pages while these
> > > > functions run, the functions will wait on every new page, resulting
> > > > in indefinite wait.

I think the problem has been misidentified, or else I have misread the
code. See below. I hope I'm right, because I think the patches are pretty
heavy on complexity in these already complex paths...

It would help if you explicitly identify the exact livelock. Ie. give a
sequence of behaviour that leads to our progress rate falling to zero.


> > > Shouldn't happen. All the data-syncing functions should have an upper
> > > bound on the number of pages which they attempt to write. In the
> > > example above, we end up in here:
> > >
> > > int __filemap_fdatawrite_range(struct address_space *mapping, loff_t
> > > start,
> > > loff_t end, int sync_mode)
> > > {
> > > int ret;
> > > struct writeback_control wbc = {
> > > .sync_mode = sync_mode,
> > > .nr_to_write = mapping->nrpages * 2, <<--
> > > .range_start = start,
> > > .range_end = end,
> > > };
> > >
> > > so generic_file_direct_write()'s filemap_write_and_wait() will attempt
> > > to write at most 2* the number of pages which are in cache for that
> > > inode.
> >
> > See write_cache_pages:
> >
> > if (wbc->sync_mode != WB_SYNC_NONE)
> >         wait_on_page_writeback(page);	(1)
> > if (PageWriteback(page) ||
> >     !clear_page_dirty_for_io(page)) {
> >         unlock_page(page);		(2)
> >         continue;
> > }
> > ret = (*writepage)(page, wbc, data);
> > if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
> >         unlock_page(page);
> >         ret = 0;
> > }
> > if (ret || (--(wbc->nr_to_write) <= 0))
> >         done = 1;
> >
> > --- so if it goes by points (1) and (2), the counter is not decremented,
> > yet the function waits for the page. If there is constant stream of
> > writeback pages being generated, it waits on each on them --- that is,
> > forever.

*What* is, forever? Data integrity syncs should have pages operated on
in-order, until we get to the end of the range. Circular writeback could
go through again, possibly, but no more than once.


> > I have seen livelock in this function. For you that example with 
> > two dd's, one buffered write and the other directIO read doesn't work?
> > For me it livelocks here.
> >
> > wait_on_page_writeback_range is another example where the livelock
> > happened, there is no protection at all against starvation.
>
> um, OK.  So someone else is initiating IO for this inode and this
> thread *never* gets to initiate any writeback.  That's a bit of a
> surprise.
>
> How do we fix that?  Maybe decrement nt_to_write for these pages as
> well?

What's the actual problem, though? nr_to_write should not be used for
data integrity operations, and it should not be critical for other
writeout. Upper layers should be able to deal with it rather than
have us lying to them.


> > BTW. that .nr_to_write = mapping->nrpages * 2 looks like a dangerous
> > thing to me.
> >
> > Imagine this case: You have two pages with indices 4 and 5 dirty in a
> > file. You call fsync(). It sets nr_to_write to 4.
> >
> > Meanwhile, another process makes pages 0, 1, 2, 3 dirty.
> >
> > The fsync() process goes to write_cache_pages, writes the first 4 dirty
> > pages and exits because it goes over the limit.
> >
> > result --- you violate fsync() semantics, pages that were dirty before
> > call to fsync() are not written when fsync() exits.

Wow, that's really nasty. Sad we still have known data integrity problems
in such core functions.


> yup, that's pretty much unfixable, really, unless new locks are added
> which block threads which are writing to unrelated sections of the
> file, and that could hurt some workloads quite a lot, I expect.

Why is it unfixable? Just ignore nr_to_write, and write out everything
properly, I would have thought.

Some things may go a tad slower, but those are going to be the things
that are using fsync, in which cases they are going to hurt much more
from the loss of data integrity than a slowdown.

Unfortunately because we have played fast and loose for so long, they
expect this behaviour, were tested and optimised with it, and systems
designed and deployed with it, and will notice performance regressions
if we start trying to do things properly. This is one of my main
arguments for doing things correctly up-front, even if it means a
massive slowdown in some real or imagined workload: at least then we
will hear about complaints and be able to try to improve them rather
than setting ourselves up for failure later.
/rant

Anyway, in this case, I don't think there would be really big problems.
Also, I think there is a reasonable optimisation that might improve it
(2nd last point, in attached patch).

OK, so after glancing at the code... wow, it seems like there are a lot
of bugs in there.

--Boundary-00=_3QY5IvQ7RNtzEn2
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="mm-fsync-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mm-fsync-fix.patch"

write_cache_pages has a number of problems, which appear to be real bugs:

* scanned == 1 is supposed to mean that cyclic writeback has circled through
  zero, thus we should not circle again. However it gets set to 1 after the
  first successful pagevec lookup. This leads to cases where not enough data
  gets written. Counterexample: file with first 10 pages dirty,
  writeback_index == 5, nr_to_write == 10. Then the 5 last pages will be found,
  and scanned will be set to 1, after writing those out, we will not cycle
  back to get the first 5. Rework this logic.

* If AOP_WRITEPAGE_ACTIVATE is returned, the filesystem is calling on us to
  drop the page lock and retry, however the existing code would just skip that
  page regardless of whether or not it was a data interity operation. Change
  this to always retry such a result.

  This is a data interity bug.

* If ret signals a real error, but we still have some pages left in the
  pagevec, done would be set to 1, but the remaining pages would continue to
  be processed and ret will be overwritten in the process. It could easily
  be overwritten with success, and thus success will be returned even if there
  is an error. Fix this by bailing immediately if there is an error, and
  retaining the error code.

  This is a data interity bug.

* nr_to_write is heeded by data interity operations, and the callers tend to
  set it to silly values that could break data interity semantics. For
  example, nr_to_write can be set to mapping->nr_pages * 2, however if a file
  has a single, dirty page, then fsync is called, subsequent pages might be
  concurrently added and dirtied, then write_cache_pages might writeout two
  of these newly dirty pages, while not writing out the old page that should
  have been written out. Fix this by ignoring nr_to_write if it is a data
  integrity sync.

  This is a data interity bug.

* In the range_cont case, range_start is set to index << PAGE_CACHE_SHIFT,
  but index is a pgoff_t and range_start is loff_t, so we can get truncation
  of the value on 32-bit platforms. Fix this by adding the standard loff_t
  cast.

  This is a data interity bug (depending on how range_cont is used).


Other problems that are not strictly bugs:

o If we get stuck behind another process that is cleaning pages, we will be
  forced to wait for them to finish, then perform our own writeout (if it
  was redirtied during the long wait), then wait for that. If a page under
  writeout is still clean, we can skip waiting for it (if we're part of a
  data integrity sync, we'll be waiting for all writeout pages afterwards).

o Control structures containing non-indempotent expressions. Break these out
  and make flow control clearer from data control.


---
 mm/filemap.c        |    2 -
 mm/page-writeback.c |  101 +++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 70 insertions(+), 33 deletions(-)

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -869,13 +869,13 @@ int write_cache_pages(struct address_spa
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
-	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
+	pgoff_t writeback_index;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
 	int range_whole = 0;
+	int cycled;
 
 	if (wbc->nonblocking && bdi_write_congested(bdi)) {
 		wbc->encountered_congestion = 1;
@@ -884,23 +884,28 @@ int write_cache_pages(struct address_spa
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
+		cycled = 0;
+		writeback_index = mapping->writeback_index; /* prev offset */
+		index = writeback_index;
+		if (index == 0)
+			cycled = 1;
+		end = ULLONG_MAX;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
 retry:
-	while (!done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					      PAGECACHE_TAG_DIRTY,
-					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
+	do {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1);
+		if (!nr_pages)
+			break;
 
-		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
@@ -911,58 +916,90 @@ retry:
 			 * swizzled back from swapper_space to tmpfs file
 			 * mapping
 			 */
+again:
 			lock_page(page);
 
+			/*
+			 * Page truncated or invalidated. We can freely skip it
+			 * then, even for data integrity operations: the page
+			 * has disappeared concurrently, so there could be no
+			 * real expectation of this data interity operation
+			 * even if there is now a new, dirty page at the same
+			 * pagecache address.
+			 */
 			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
 				unlock_page(page);
 				continue;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
+			if (page->index > end) {
+				/* Can't be cyclic: end == ULLONG_MAX */
 				unlock_page(page);
-				continue;
+done_release:
+				pagevec_release(&pvec);
+				goto done;
 			}
 
-			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
-
-			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page)) {
-				unlock_page(page);
-				continue;
+			if (PageWriteback(page)) {
+				/* someone else wrote it for us */
+				if (!PageDirty(page)) {
+					goto continue_unlock;
+				} else {
+					/* hmm, but it has been dirtied again */
+					if (wbc->sync_mode != WB_SYNC_NONE)
+						wait_on_page_writeback(page);
+					else
+						goto continue_unlock;
+				}
 			}
 
+			BUG_ON(PageWriteback(page));
+
+			if (!clear_page_dirty_for_io(page))
+				goto continue_unlock;
+
 			ret = (*writepage)(page, wbc, data);
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
-				unlock_page(page);
-				ret = 0;
+			if (unlikely(ret)) {
+				/* Must retry the write, esp. for integrity */
+				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+					unlock_page(page);
+					ret = 0;
+					goto again;
+				}
+				goto done;
+			}
+			if (wbc->sync_mode == WB_SYNC_NONE) {
+				wbc->nr_to_write--;
+				if (wbc->nr_to_write <= 0)
+					goto done_release;
 			}
-			if (ret || (--(wbc->nr_to_write) <= 0))
-				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
-				done = 1;
+				goto done_release;
 			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-	}
-	if (!scanned && !done) {
+	} while (index <= end);
+
+	if (wbc->range_cyclic && !cycled) {
 		/*
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
 		 */
-		scanned = 1;
+		cycled = 1;
 		index = 0;
+		end = writeback_index - 1; /* won't be -ve, see above */
 		goto retry;
 	}
+done:
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
-
 	if (wbc->range_cont)
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_start = (loff_t)index << PAGE_CACHE_SHIFT;
+
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -209,7 +209,7 @@ int __filemap_fdatawrite_range(struct ad
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = sync_mode,
-		.nr_to_write = mapping->nrpages * 2,
+		.nr_to_write = LONG_MAX,
 		.range_start = start,
 		.range_end = end,
 	};

--Boundary-00=_3QY5IvQ7RNtzEn2--
