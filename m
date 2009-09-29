Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZI2APQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZI2APQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZI2APO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:15:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:35557 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbZI2APN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:15:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,469,1249282800"; 
   d="scan'208";a="192676911"
Date: Tue, 29 Sep 2009 08:15:04 +0800
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
Message-ID: <20090929001504.GA18192@localhost>
References: <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928071507.GA20068@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 03:15:07PM +0800, Wu Fengguang wrote:
> On Mon, Sep 28, 2009 at 09:07:00AM +0800, Dave Chinner wrote:
> > 
> > pageout is so horribly inefficient from an IO perspective it is not
> > funny. It is one of the reasons Linux sucks so much when under
> > memory pressure. It basically causes the system to do random 4k
> > writeback of dirty pages (and lumpy reclaim can make it
> > synchronous!). 
> > 
> > pageout needs an enema, and preferably it should defer to background
> > writeback to clean pages. background writeback will clean pages
> > much, much faster than the random crap that pageout spews at the
> > disk right now.
> > 
> > Given that I can basically lock up my 2.6.30-based laptop for 10-15
> > minutes at a time with the disk running flat out in low memory
> > situations simply by starting to copy a large file(*), I think that
> > the way we currently handle dirty page writeback needs a bit of a
> > rethink.
> > 
> > (*) I had this happen 4-5 times last week moving VM images around on
> > my laptop, and it involved the Linux VM switching between pageout
> > and swapping to make more memory available while the copy was was
> > hammering the same drive with dirty pages from foreground writeback.
> > It made for extremely fragmented files when the machine finally
> > recovered because of the non-sequential writeback patterns on the
> > single file being copied.  You can't tell me that this is sane,
> > desirable behaviour, and this is the sort of problem that I want
> > sorted out. I don't beleive it can be fixed by maintaining the
> > number of uncoordinated, competing writeback mechanisms we currently
> > have.
> 
> I imagined some lumpy pageout policy would help, but didn't realize
> it's such a severe problem that can happen in daily desktop workload..
> 
> Below is a quick patch. Any comments?

Wow, it's much easier to reuse write_cache_pages for lumpy pageout :)

---
 mm/page-writeback.c |   36 ++++++++++++++++++++++++------------
 mm/shmem.c          |    1 +
 mm/vmscan.c         |    6 ++++++
 3 files changed, 31 insertions(+), 12 deletions(-)

--- linux.orig/mm/vmscan.c	2009-09-29 07:21:51.000000000 +0800
+++ linux/mm/vmscan.c	2009-09-29 07:46:59.000000000 +0800
@@ -344,6 +344,8 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
+#define LUMPY_PAGEOUT_PAGES	(512 * 1024 / PAGE_CACHE_SIZE)
+
 /*
  * pageout is called by shrink_page_list() for each dirty page.
  * Calls ->writepage().
@@ -408,6 +410,10 @@ static pageout_t pageout(struct page *pa
 			return PAGE_ACTIVATE;
 		}
 
+		wbc.range_start = (page->index + 1) << PAGE_CACHE_SHIFT;
+		wbc.nr_to_write = LUMPY_PAGEOUT_PAGES - 1;
+		generic_writepages(mapping, &wbc);
+
 		/*
 		 * Wait on writeback if requested to. This happens when
 		 * direct reclaiming a large contiguous area and the
--- linux.orig/mm/page-writeback.c	2009-09-29 07:33:13.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-29 08:10:39.000000000 +0800
@@ -799,6 +799,12 @@ retry:
 		if (nr_pages == 0)
 			break;
 
+		if (wbc->for_reclaim && done_index + nr_pages - 1 !=
+					pvec.pages[nr_pages - 1]->index) {
+			pagevec_release(&pvec);
+			break;
+		}
+
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
@@ -852,24 +858,30 @@ continue_unlock:
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
+			/*
+			 * active and unevictable pages will be checked at
+			 * rotate time
+			 */
+			if (wbc->for_reclaim)
+				SetPageReclaim(page);
+
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {
 					unlock_page(page);
 					ret = 0;
-				} else {
-					/*
-					 * done_index is set past this page,
-					 * so media errors will not choke
-					 * background writeout for the entire
-					 * file. This has consequences for
-					 * range_cyclic semantics (ie. it may
-					 * not be suitable for data integrity
-					 * writeout).
-					 */
-					done = 1;
-					break;
 				}
+				/*
+				 * done_index is set past this page,
+				 * so media errors will not choke
+				 * background writeout for the entire
+				 * file. This has consequences for
+				 * range_cyclic semantics (ie. it may
+				 * not be suitable for data integrity
+				 * writeout).
+				 */
+				done = 1;
+				break;
  			}
 
 			if (nr_to_write > 0) {
--- linux.orig/mm/shmem.c	2009-09-29 08:07:22.000000000 +0800
+++ linux/mm/shmem.c	2009-09-29 08:08:02.000000000 +0800
@@ -1103,6 +1103,7 @@ unlock:
 	 */
 	swapcache_free(swap, NULL);
 redirty:
+	wbc->pages_skipped++;
 	set_page_dirty(page);
 	if (wbc->for_reclaim)
 		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */
