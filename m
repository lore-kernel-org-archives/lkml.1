Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZK3RYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZK3RYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZK3RYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:24:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:21844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZK3RYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:24:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=OfFOun6QejkkxEpvgMduY27MYbxGOhOas7VmxFLrGSxCbcJKxT22oIivb0CeL7SjfR
         5caX14nc3BuhElZxqca1V19Eq6ZAQTFyuwp0XzY97AlTBo9d5gwsyL4QF1HTcZz4Mn1f
         w0JD2rTb1N9J2MLGoL/zmX6xtik1v36aak1ZM=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
Date: Mon, 30 Nov 2009 18:21:14 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20091126121945.GB13095@csn.ul.ie> <4e5e476b0911300454x74c46852od4c35132f0d4c104@mail.gmail.com> <20091130154832.GB23491@csn.ul.ie>
In-Reply-To: <20091130154832.GB23491@csn.ul.ie>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911301821.16075.czoccolo@gmail.com>
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30 2009 at 16:48:32, Mel Gorman wrote:
> On Mon, Nov 30, 2009 at 01:54:04PM +0100, Corrado Zoccolo wrote:
> > On Mon, Nov 30, 2009 at 1:04 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > > On Sun, Nov 29, 2009 at 04:11:15PM +0100, Corrado Zoccolo wrote:

> > For my I/O scheduler tests I use an external disk, to be able to
> > monitor exactly what is happening.
> > If I don't do a sync & drop cache before starting a test, I usually
> > see writeback happening on the main disk, even if the only activity on
> > the machine is writing a sequential file to my external disk. If that
> > writeback is done in the context of my test process, this will alter
> > the result.
>
> Why does the writeback kick in late? I thought pages were meant to be
> written back after a contigurable interval of time had passed.
That is a good question. Maybe when dirty ratio goes high, something is
being written to swap?

>
> I can try but it'll take a few days to get around to. I'm still trying
> to identify other sources of the problems from between 2.6.30 and
> 2.6.32-rc8. It'll be tricky to test what you ask because it might not just
> be low-memory that is the problem but low memory + enough pressure that
> processes are stalling waiting on reclaim.
Ok.
>
> > Right, but the order of insertions at the tail would be reversed.
>
> True but maybe it doesn't matter. What's important is that the order the
> pages are returned during allocation and after a high-order page is split
> is what is important.
>
> > > There is a fair amount of overhead
> > > introduced here as well with branches and a lot of extra lists although
> > > I believe that could be mitigated.
> > >
> > > What are the results if you just alter whether it's the head or tail of
> > > the list that is used in __free_one_page()?
> >
> > In that case, it would alter the ordering, but not the one of the
> > pages returned by expand.
> > In fact, only the order of the pages returned by free will be
> > affected, and in that case maybe it is already quite disordered.
> > If that order is not needed to be kept, I can prepare a new version
> > with a single list.
>
> The ordering of free does not need to be preserved. The important
> property is that if a high-order page is split by expand() that
> subsequent allocations use the contiguous pages.
Then, a solution with a single list is possible. It removes the overhead
of the branches when allocating, and also the additional lists.
What about:

>From b792ce5afff2e7a28ec3db41baaf93c3200ee5fc Mon Sep 17 00:00:00 2001
From: Corrado Zoccolo <czoccolo@gmail.com>
Date: Mon, 30 Nov 2009 17:42:05 +0100
Subject: [PATCH] page allocator: heuristic to reduce fragmentation in buddy 
allocator

In order to reduce fragmentation, we classify freed pages in two
groups, according to their probability of being part of a high
order merge.
Pages belonging to a compound whose buddy is free are more likely
to be part of a high order merge, so they will be added at the tail
of the freelist. The remaining pages will, instead, be put at the
front of the freelist.

In this way, the pages that are more likely to cause a big merge are
kept free longer. Consequently we tend to aggregate the long-living
allocations on a subset of the compounds, reducing the fragmentation.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 mm/page_alloc.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bc2ac6..0f273af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -451,6 +451,8 @@ static inline void __free_one_page(struct page *page,
 		int migratetype)
 {
 	unsigned long page_idx;
+	unsigned long combined_idx;
+	bool combined_free = false;
 
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
@@ -464,7 +466,6 @@ static inline void __free_one_page(struct page *page,
 	VM_BUG_ON(bad_range(zone, page));
 
 	while (order < MAX_ORDER-1) {
-		unsigned long combined_idx;
 		struct page *buddy;
 
 		buddy = __page_find_buddy(page, page_idx, order);
@@ -481,8 +482,21 @@ static inline void __free_one_page(struct page *page,
 		order++;
 	}
 	set_page_order(page, order);
-	list_add(&page->lru,
-		&zone->free_area[order].free_list[migratetype]);
+
+	if (order < MAX_ORDER-1) {
+		struct page *combined_page, *combined_buddy;
+		combined_idx = __find_combined_index(page_idx, order);
+		combined_page = page + combined_idx - page_idx;
+		combined_buddy = __page_find_buddy(combined_page, combined_idx, order + 1);
+		combined_free = page_is_buddy(combined_page, combined_buddy, order + 1);
+	}
+
+	if (combined_free)
+		list_add_tail(&page->lru,
+			&zone->free_area[order].free_list[migratetype]);
+	else
+		list_add(&page->lru,
+			&zone->free_area[order].free_list[migratetype]);
 	zone->free_area[order].nr_free++;
 }
 
-- 
1.6.2.5




