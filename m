Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZJBBhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZJBBhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932116AbZJBBeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:21 -0400
Received: from kroah.org ([198.145.64.141]:33531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbZJBBeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:25 2009
Message-Id: <20091002012425.842096239@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>
Subject: [119/136] page-allocator: limit the number of MIGRATE_RESERVE pageblocks per zone
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mel Gorman <mel@csn.ul.ie>

commit 78986a678f6ec3759a01976749f4437d8bf2d6c3 upstream.

After anti-fragmentation was merged, a bug was reported whereby devices
that depended on high-order atomic allocations were failing.  The solution
was to preserve a property in the buddy allocator which tended to keep the
minimum number of free pages in the zone at the lower physical addresses
and contiguous.  To preserve this property, MIGRATE_RESERVE was introduced
and a number of pageblocks at the start of a zone would be marked
"reserve", the number of which depended on min_free_kbytes.

Anti-fragmentation works by avoiding the mixing of page migratetypes
within the same pageblock.  One way of helping this is to increase
min_free_kbytes because it becomes less like that it will be necessary to
place pages of of MIGRATE_RESERVE is unbounded, the free memory is kept
there in large contiguous blocks instead of helping anti-fragmentation as
much as it should.  With the page-allocator tracepoint patches applied, it
was found during anti-fragmentation tests that the number of
fragmentation-related events were far higher than expected even with
min_free_kbytes at higher values.

This patch limits the number of MIGRATE_RESERVE blocks that exist per zone
to two.  For example, with a sufficient min_free_kbytes, 4MB of memory
will be kept aside on an x86-64 and remain more or less free and
contiguous for the systems uptime.  This should be sufficient for devices
depending on high-order atomic allocations while helping fragmentation
control when min_free_kbytes is tuned appropriately.  As side-effect of
this patch is that the reserve variable is converted to int as unsigned
long was the wrong type to use when ensuring that only the required number
of reserve blocks are created.

With the patches applied, fragmentation-related events as measured by the
page allocator tracepoints were significantly reduced when running some
fragmentation stress-tests on systems with min_free_kbytes tuned to a
value appropriate for hugepage allocations at runtime.  On x86, the events
recorded were reduced by 99.8%, on x86-64 by 99.72% and on ppc64 by
99.83%.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2783,7 +2783,8 @@ static void setup_zone_migrate_reserve(s
 {
 	unsigned long start_pfn, pfn, end_pfn;
 	struct page *page;
-	unsigned long reserve, block_migratetype;
+	unsigned long block_migratetype;
+	int reserve;
 
 	/* Get the start pfn, end pfn and the number of blocks to reserve */
 	start_pfn = zone->zone_start_pfn;
@@ -2791,6 +2792,15 @@ static void setup_zone_migrate_reserve(s
 	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
 
+	/*
+	 * Reserve blocks are generally in place to help high-order atomic
+	 * allocations that are short-lived. A min_free_kbytes value that
+	 * would result in more than 2 reserve blocks for atomic allocations
+	 * is assumed to be in place to help anti-fragmentation for the
+	 * future allocation of hugepages at runtime.
+	 */
+	reserve = min(2, reserve);
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		if (!pfn_valid(pfn))
 			continue;


