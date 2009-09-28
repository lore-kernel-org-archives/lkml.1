Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbZI1HPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbZI1HPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZI1HPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:15:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:24361 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZI1HPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,465,1249282800"; 
   d="scan'208";a="192352163"
Date: Mon, 28 Sep 2009 15:15:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090928071507.GA20068@localhost>
References: <20090922185941.1118e011.akpm@linux-foundation.org> <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928010700.GE9464@discord.disaster>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 09:07:00AM +0800, Dave Chinner wrote:
> On Fri, Sep 25, 2009 at 02:45:03PM +0800, Wu Fengguang wrote:
> > On Fri, Sep 25, 2009 at 01:04:13PM +0800, Dave Chinner wrote:
> > > On Thu, Sep 24, 2009 at 08:38:20PM -0400, Chris Mason wrote:
> > > > On Fri, Sep 25, 2009 at 10:11:17AM +1000, Dave Chinner wrote:
> > > > > On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:
> > > > > > On Wed, Sep 23, 2009 at 10:00:58PM +0800, Chris Mason wrote:
> > > > > > > The only place that actually honors the congestion flag is pdflush.
> > > > > > > It's trivial to get pdflush backed up and make it sit down without
> > > > > > > making any progress because once the queue congests, pdflush goes away.
> > > > > > 
> > > > > > Right. I guess that's more or less intentional - to give lowest priority
> > > > > > to periodic/background writeback.
> > > > > 
> > > > > IMO, this is the wrong design. Background writeback should
> > > > > have higher CPU/scheduler priority than normal tasks. If there is
> > > > > sufficient dirty pages in the system for background writeback to
> > > > > be active, it should be running *now* to start as much IO as it can
> > > > > without being held up by other, lower priority tasks.
> > > > 
> > > > I'd say that an fsync from mutt or vi should be done at a higher prio
> > > > than a background streaming writer.
> > > 
> > > I don't think you caught everything I said - synchronous IO is
> > > un-throttled.
> > 
> > O_SYNC writes may be un-throttled in theory, however it seems to be
> > throttled in practice:
> > 
> >   generic_file_aio_write
> >     __generic_file_aio_write
> >       generic_file_buffered_write
> >         generic_perform_write
> >           balance_dirty_pages_ratelimited
> >     generic_write_sync
> > 
> > Do you mean some other code path?
> 
> In the context of the setup I was talking about, I meant is that sync
> IO _should_ be unthrottled because it is self-throttling by it's
> very nature. The current code makes no differentiation between the
> two.

Yes, O_SYNC writers are double throttled now..

> > > Background writeback should dump async IO to the elevator as fast as
> > > it can, then get the hell out of the way. If you've got a UP system,
> > > then the fsync can't be issued at the same time pdflush is running
> > > (same as right now), and if you've got a MP system then fsync can
> > > run at the same time.
> > 
> > I think you are right for system wide sync.
> > 
> > System wide sync seems to always wait for the queued bdi writeback
> > works to finish, which should be fine in terms of efficiency, except
> > that sync could end up do more works and even live lock.
> > 
> > > On the premise that sync IO is unthrottled and given that elevators
> > > queue and issue sync IO sperately to async writes, fsync latency
> > > would be entirely derived from the elevator queuing behaviour, not
> > > the CPU priority of pdflush.
> > 
> > It's not exactly CPU priority, but queue fullness priority.
> 
> That's exactly what I implied. The elevator manages the
> queue fullness and when it decides when to block background or
> foreground writes. The problem is, the elevator can't make a sane
> scheduling decision because it can't tell the difference between
> async and sync IO because we don't propagate that information to
> THE Block layer from the VFS.
> 
> We have all the smarts in the block layer interface to distinguish
> between sync and async IO and the elevators do smart stuff with this
> information. But by throwing away that information at the VFS level,
> we hamstring the elevator scheduler because it never sees any
> "synchronous" write IO for data writes. Hence any synchronous data
> write gets stuck in the same queue with all the background stuff
> and doesn't get priority.

Yes this is a problem. We may also need to add priority awareness to
get_request_wait() to get a complete solution.

> Hence right now if you issue an fsync or pageout, it's a crap shoot
> as to whether the elevator will schedule it first or last behind
> other IO. The fact that they then ignore congestion is relying on a
> side effect to stop background writeback and allow the fsync to
> monopolise the elevator. It is not predictable and hence IO patterns
> under load will change all the time regardless of whether the system
> is in a steady state or not.
>
> IMO there are architectural failings from top to bottom in the
> writeback stack - while people are interested in fixing stuff, I
> figured that they should be pointed out to give y'all something to
> think about...

Thanks, your information helps a lot.

> > fsync operations always use nonblocking=0, so in fact they _used to_
> > enjoy better priority than pdflush. Same is vmscan pageout, which
> > calls writepage directly. Both won't back off on congested bdi.
> > 
> > So when there comes fsync/pageout, they will always be served first.
> 
> pageout is so horribly inefficient from an IO perspective it is not
> funny. It is one of the reasons Linux sucks so much when under
> memory pressure. It basically causes the system to do random 4k
> writeback of dirty pages (and lumpy reclaim can make it
> synchronous!). 
> 
> pageout needs an enema, and preferably it should defer to background
> writeback to clean pages. background writeback will clean pages
> much, much faster than the random crap that pageout spews at the
> disk right now.
> 
> Given that I can basically lock up my 2.6.30-based laptop for 10-15
> minutes at a time with the disk running flat out in low memory
> situations simply by starting to copy a large file(*), I think that
> the way we currently handle dirty page writeback needs a bit of a
> rethink.
> 
> (*) I had this happen 4-5 times last week moving VM images around on
> my laptop, and it involved the Linux VM switching between pageout
> and swapping to make more memory available while the copy was was
> hammering the same drive with dirty pages from foreground writeback.
> It made for extremely fragmented files when the machine finally
> recovered because of the non-sequential writeback patterns on the
> single file being copied.  You can't tell me that this is sane,
> desirable behaviour, and this is the sort of problem that I want
> sorted out. I don't beleive it can be fixed by maintaining the
> number of uncoordinated, competing writeback mechanisms we currently
> have.

I imagined some lumpy pageout policy would help, but didn't realize
it's such a severe problem that can happen in daily desktop workload..

Below is a quick patch. Any comments?

> > Small random IOs may hurt a bit though.
> 
> They *always* hurt, and under load, that appears to be the common IO
> pattern that Linux is generating....

Thanks,
Fengguang
---

vmscan: lumpy pageout

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |   72 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 9 deletions(-)

--- linux.orig/mm/vmscan.c	2009-09-28 11:45:48.000000000 +0800
+++ linux/mm/vmscan.c	2009-09-28 14:45:19.000000000 +0800
@@ -344,6 +344,64 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
+#define LUMPY_PAGEOUT_PAGES	(512 * 1024 / PAGE_CACHE_SIZE)
+
+static pageout_t try_lumpy_pageout(struct page *page,
+				   struct address_space *mapping,
+				   struct writeback_control *wbc)
+{
+	struct page *pages[PAGEVEC_SIZE];
+	pgoff_t start;
+	int total;
+	int count;
+	int i;
+	int err;
+	int res = 0;
+
+	page_cache_get(page);
+	pages[0] = page;
+	i = 0;
+	count = 1;
+	start = page->index + 1;
+
+	for (total = LUMPY_PAGEOUT_PAGES; total > 0; total--) {
+		if (i >= count) {
+			i = 0;
+			count = find_get_pages(mapping, start,
+					       min(total, PAGEVEC_SIZE), pages);
+			if (!count)
+				break;
+
+			/* continuous? */
+			if (start + count - 1 != pages[count - 1]->index)
+				break;
+
+			start += count;
+		}
+
+		page = pages[i];
+		if (!PageDirty(page))
+			break;
+		if (!PageActive(page))
+			SetPageReclaim(page);
+		err = mapping->a_ops->writepage(page, wbc);
+		if (err < 0)
+			handle_write_error(mapping, page, res);
+		if (err == AOP_WRITEPAGE_ACTIVATE) {
+			ClearPageReclaim(page);
+			res = PAGE_ACTIVATE;
+			break;
+		}
+		page_cache_release(page);
+		i++;
+	}
+
+	for (; i < count; i++)
+		page_cache_release(pages[i]);
+
+	return res;
+}
+
 /*
  * pageout is called by shrink_page_list() for each dirty page.
  * Calls ->writepage().
@@ -392,21 +450,17 @@ static pageout_t pageout(struct page *pa
 		int res;
 		struct writeback_control wbc = {
 			.sync_mode = WB_SYNC_NONE,
-			.nr_to_write = SWAP_CLUSTER_MAX,
+			.nr_to_write = LUMPY_PAGEOUT_PAGES,
 			.range_start = 0,
 			.range_end = LLONG_MAX,
 			.nonblocking = 1,
 			.for_reclaim = 1,
 		};
 
-		SetPageReclaim(page);
-		res = mapping->a_ops->writepage(page, &wbc);
-		if (res < 0)
-			handle_write_error(mapping, page, res);
-		if (res == AOP_WRITEPAGE_ACTIVATE) {
-			ClearPageReclaim(page);
-			return PAGE_ACTIVATE;
-		}
+
+		res = try_lumpy_pageout(page, mapping, &wbc);
+		if (res == PAGE_ACTIVATE)
+			return res;
 
 		/*
 		 * Wait on writeback if requested to. This happens when
