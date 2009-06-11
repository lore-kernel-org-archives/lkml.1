Return-Path: <linux-kernel-owner+w=401wt.eu-S1762809AbZFKKsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809AbZFKKsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbZFKKry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:47:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35596 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbZFKKrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:47:53 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring behaviour more in line with expectations V3
Date: Thu, 11 Jun 2009 11:47:50 +0100
Message-Id: <1244717273-15176-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big change with this release is that the patch reintroducing
zone_reclaim_interval has been dropped as Ram reports the malloc() stalls
have been resolved. If this bug occurs again, the counter will be there to
help us identify the situation.

Changelog since V2
  o Add reviews/acks
  o Take advantage of Kosaki's work on the estimate of tmpfs pages
  o Watch for underflow with Kosaki's calculation
  o Drop the zone_reclaim_interval patch again after Ram reported that the
    scan-avoidance-heuristic works for the malloc() test case

Changelog since V1
  o Rebase to mmotm
  o Add various acks
  o Documentation and patch leader fixes
  o Use Kosaki's method for calculating the number of unmapped pages
  o Consider the zone full in more situations than all pages being unreclaimable
  o Add a counter to detect when scan-avoidance heuristics are failing
  o Handle jiffie wraps for zone_reclaim_interval
  o Move zone_reclaim_interval to the end of the set with the view to dropping
    it. If Kosaki's calculation is accurate, then the problem being dealt with
    should also be addressed

A bug was brought to my attention against a distro kernel but it affects
mainline and I believe problems like this have been reported in various guises
on the mailing lists although I don't have specific examples at the moment.

The reported problem was that malloc() stalled for a long time (minutes
in some cases) if a large tmpfs mount was occupying a large percentage of
memory overall. The pages did not get cleaned or reclaimed by zone_reclaim()
because the zone_reclaim_mode was unsuitable, but the lists are uselessly
scanned frequencly making the CPU spin at near 100%.

This patchset intends to address that bug and bring the behaviour of
zone_reclaim() more in line with expectations which were noticed during
investigation. It is based on top of mmotm and takes advantage of Kosaki's
work with respect to zone_reclaim().

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

 include/linux/vmstat.h |    3 ++
 mm/internal.h          |    4 +++
 mm/page_alloc.c        |   26 +++++++++++++++---
 mm/vmscan.c            |   69 ++++++++++++++++++++++++++++++++++-------------
 mm/vmstat.c            |    3 ++
 5 files changed, 82 insertions(+), 23 deletions(-)

