Return-Path: <linux-kernel-owner+w=401wt.eu-S932405AbZGABQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbZGABQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbZGAAf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:56 -0400
Received: from kroah.org ([198.145.64.141]:60722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761549AbZGAAfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:43 2009
Message-Id: <20090701002443.184726273@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [patch 100/108] vmscan: properly account for the number of page cache pages zone_reclaim() can reclaim
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit 90afa5de6f3fa89a733861e843377302479fcf7e upstream.

A bug was brought to my attention against a distro kernel but it affects
mainline and I believe problems like this have been reported in various
guises on the mailing lists although I don't have specific examples at the
moment.

The reported problem was that malloc() stalled for a long time (minutes in
some cases) if a large tmpfs mount was occupying a large percentage of
memory overall.  The pages did not get cleaned or reclaimed by
zone_reclaim() because the zone_reclaim_mode was unsuitable, but the lists
are uselessly scanned frequencly making the CPU spin at near 100%.

This patchset intends to address that bug and bring the behaviour of
zone_reclaim() more in line with expectations which were noticed during
investigation.  It is based on top of mmotm and takes advantage of
Kosaki's work with respect to zone_reclaim().

Patch 1 fixes the heuristics that zone_reclaim() uses to determine if the
	scan should go ahead. The broken heuristic is what was causing the
	malloc() stall as it uselessly scanned the LRU constantly. Currently,
	zone_reclaim is assuming zone_reclaim_mode is 1 and historically it
	could not deal with tmpfs pages at all. This fixes up the heuristic so
	that an unnecessary scan is more likely to be correctly avoided.

Patch 2 notes that zone_reclaim() returning a failure automatically means
	the zone is marked full. This is not always true. It could have
	failed because the GFP mask or zone_reclaim_mode were unsuitable.

Patch 3 introduces a counter zreclaim_failed that will increment each
	time the zone_reclaim scan-avoidance heuristics fail. If that
	counter is rapidly increasing, then zone_reclaim_mode should be
	set to 0 as a temporarily resolution and a bug reported because
	the scan-avoidance heuristic is still broken.

This patch:

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim.  On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that
clean unmapped pages will be reclaimed if the zone watermarks are not
being met.

There is a heuristic that determines if the scan is worthwhile but the
problem is that the heuristic is not being properly applied and is
basically assuming zone_reclaim_mode is 1 if it is enabled.  The lack of
proper detection can manfiest as high CPU usage as the LRU list is scanned
uselessly.

Historically, once enabled it was depending on NR_FILE_PAGES which may
include swapcache pages that the reclaim_mode cannot deal with.  Patch
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch by
Kosaki Motohiro noted that zone_page_state(zone, NR_FILE_PAGES) included
pages that were not file-backed such as swapcache and made a calculation
based on the inactive, active and mapped files.  This is far superior when
zone_reclaim==1 but if RECLAIM_SWAP is set, then NR_FILE_PAGES is a
reasonable starting figure.

This patch alters how zone_reclaim() works out how many pages it might be
able to reclaim given the current reclaim_mode.  If RECLAIM_SWAP is set in
the reclaim_mode it will either consider NR_FILE_PAGES as potential
candidates or else use NR_{IN}ACTIVE}_PAGES-NR_FILE_MAPPED to discount
swapcache and other non-file-backed pages.  If RECLAIM_WRITE is not set,
then NR_FILE_DIRTY number of pages are not candidates.  If RECLAIM_SWAP is
not set, then NR_FILE_MAPPED are not.

[kosaki.motohiro@jp.fujitsu.com: Estimate unmapped pages minus tmpfs pages]
[fengguang.wu@intel.com: Fix underflow problem in Kosaki's estimate]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/sysctl/vm.txt |   12 ++++++----
 mm/vmscan.c                 |   52 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 53 insertions(+), 11 deletions(-)

--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -314,10 +314,14 @@ min_unmapped_ratio:
 
 This is available only on NUMA kernels.
 
-A percentage of the total pages in each zone.  Zone reclaim will only
-occur if more than this percentage of pages are file backed and unmapped.
-This is to insure that a minimal amount of local pages is still available for
-file I/O even if the node is overallocated.
+This is a percentage of the total pages in each zone. Zone reclaim will
+only occur if more than this percentage of pages are in a state that
+zone_reclaim_mode allows to be reclaimed.
+
+If zone_reclaim_mode has the value 4 OR'd, then the percentage is compared
+against all file-backed unmapped pages including swapcache pages and tmpfs
+files. Otherwise, only unmapped pages backed by normal files but not tmpfs
+files and similar are considered.
 
 The default is 1 percent.
 
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2290,6 +2290,48 @@ int sysctl_min_unmapped_ratio = 1;
  */
 int sysctl_min_slab_ratio = 5;
 
+static inline unsigned long zone_unmapped_file_pages(struct zone *zone)
+{
+	unsigned long file_mapped = zone_page_state(zone, NR_FILE_MAPPED);
+	unsigned long file_lru = zone_page_state(zone, NR_INACTIVE_FILE) +
+		zone_page_state(zone, NR_ACTIVE_FILE);
+
+	/*
+	 * It's possible for there to be more file mapped pages than
+	 * accounted for by the pages on the file LRU lists because
+	 * tmpfs pages accounted for as ANON can also be FILE_MAPPED
+	 */
+	return (file_lru > file_mapped) ? (file_lru - file_mapped) : 0;
+}
+
+/* Work out how many page cache pages we can reclaim in this reclaim_mode */
+static long zone_pagecache_reclaimable(struct zone *zone)
+{
+	long nr_pagecache_reclaimable;
+	long delta = 0;
+
+	/*
+	 * If RECLAIM_SWAP is set, then all file pages are considered
+	 * potentially reclaimable. Otherwise, we have to worry about
+	 * pages like swapcache and zone_unmapped_file_pages() provides
+	 * a better estimate
+	 */
+	if (zone_reclaim_mode & RECLAIM_SWAP)
+		nr_pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
+	else
+		nr_pagecache_reclaimable = zone_unmapped_file_pages(zone);
+
+	/* If we can't clean pages, remove dirty pages from consideration */
+	if (!(zone_reclaim_mode & RECLAIM_WRITE))
+		delta += zone_page_state(zone, NR_FILE_DIRTY);
+
+	/* Watch for any possible underflows due to delta */
+	if (unlikely(delta > nr_pagecache_reclaimable))
+		delta = nr_pagecache_reclaimable;
+
+	return nr_pagecache_reclaimable - delta;
+}
+
 /*
  * Try to free up some pages from this zone through reclaim.
  */
@@ -2324,9 +2366,7 @@ static int __zone_reclaim(struct zone *z
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	if (zone_page_state(zone, NR_FILE_PAGES) -
-		zone_page_state(zone, NR_FILE_MAPPED) >
-		zone->min_unmapped_pages) {
+	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
 		/*
 		 * Free memory by calling shrink zone with increasing
 		 * priorities until we have enough memory freed.
@@ -2384,10 +2424,8 @@ int zone_reclaim(struct zone *zone, gfp_
 	 * if less than a specified percentage of the zone is used by
 	 * unmapped file backed pages.
 	 */
-	if (zone_page_state(zone, NR_FILE_PAGES) -
-	    zone_page_state(zone, NR_FILE_MAPPED) <= zone->min_unmapped_pages
-	    && zone_page_state(zone, NR_SLAB_RECLAIMABLE)
-			<= zone->min_slab_pages)
+	if (zone_pagecache_reclaimable(zone) <= zone->min_unmapped_pages &&
+	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
 		return 0;
 
 	if (zone_is_all_unreclaimable(zone))


