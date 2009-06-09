Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbZFIRB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbZFIRB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZFIRBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:01:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59468 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZFIRBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:01:45 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] [RFC] Functional fix to zone_reclaim() and bring behaviour more in line with expectations V2
Date: Tue,  9 Jun 2009 18:01:40 +0100
Message-Id: <1244566904-31470-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The problem is that malloc() stalled for a long time (minutes in some
cases) if a large tmpfs mount was occupying a large percentage of memory
overall. The pages did not get cleaned or reclaimed by zone_reclaim()
because the zone_reclaim_mode was unsuitable, but the lists are uselessly
scanned frequencly making the CPU spin at near 100%.

This patchset intends to address that bug and bring the behaviour of
zone_reclaim() more in line with expectations. It is based on top of mmotm
and takes advantage of Kosaki's work with respect to zone_reclaim().

Patch 1 alters the heuristics that zone_reclaim() uses to determine if the
	scan should go ahead. Currently, it is basically assuming
	zone_reclaim_mode is 1 and historically it could not deal with
	tmpfs pages at all. This fixes up the heuristic so that the scan
	is more likely to be correctly avoided.

Patch 2 notes that zone_reclaim() returning a failure automatically means
	the zone is marked full. This is not always true. It could have
	failed because the GFP mask or zone_reclaim_mode were unsuitable.

Patch 3 introduces a counter zreclaim_failed that will increment each
	time the zone_reclaim scan-avoidance heuristics fail. If that
	counter is rapidly increasing, then zone_reclaim_mode should be
	set to 0 as a temporarily resolution and a bug reported.

Patch 4 reintroduces zone_reclaim_interval to catch the situation where
	zone_reclaim() cannot tell in advance that the scan is a waste of
	time. This is a brute force catch-all. I've asked the bug reporter
	to test with just patch 1. If that works, then this patch will be
	dropped and patch 3 will be enough to tell us if/when the situation
	occured again. Even with this patch applied, the counter will
	increase slowly so it's still possible to detect the problem.

 Documentation/sysctl/vm.txt |   15 +++++++
 include/linux/mmzone.h      |    9 ++++
 include/linux/swap.h        |    1 +
 include/linux/vmstat.h      |    3 +
 kernel/sysctl.c             |    9 ++++
 mm/internal.h               |    4 ++
 mm/page_alloc.c             |   26 ++++++++++--
 mm/vmscan.c                 |   91 ++++++++++++++++++++++++++++++++++---------
 mm/vmstat.c                 |    3 +
 9 files changed, 138 insertions(+), 23 deletions(-)

