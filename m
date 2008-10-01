Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYJAMc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYJAMc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYJAMbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:31:12 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41978 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYJAMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:31:11 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] Reclaim page capture v4
Date: Wed,  1 Oct 2008 13:30:57 +0100
Message-Id: <1222864261-22570-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For sometime we have been looking at mechanisms for improving the availability
of larger allocations under load.  One of the options we have explored is
the capturing of pages freed under direct reclaim in order to increase the
chances of free pages coelescing before they are subject to reallocation
by racing allocators.

Following this email is a patch stack implementing page capture during
direct reclaim.  It consits of four patches.  The first two simply pull
out existing code into helpers for reuse.  The third makes buddy's use
of struct page explicit.  The fourth contains the meat of the changes,
and its leader contains a much fuller description of the feature.

This update represents a rebase to -mm and incorporates feedback from
KOSAKI Motohiro.  It also incorporates an accounting fix which was
preventing some captures.

I have done a lot of comparitive testing with and without this patch
set and in broad brush I am seeing improvements in hugepage allocations
(worst case size) success on all of my test systems.  These tests consist
of placing a constant stream of high order allocations on the system,
at varying rates.  The results for these various runs are then averaged
to give an overall improvement.

		Absolute	Effective
x86-64		2.48%		 4.58%
powerpc		5.55%		25.22%

x86-64 has a relatively small huge page size and so is always much more
effective at allocating huge pages.  Even there we get a measurable
improvement.  On powerpc the huge pages are much larger and much harder
to recover.  Here we see a full 25% increase in page recovery.

It should be noted that these are worst case testing, and very agressive
taking every possible page in the system.  It would be helpful to get
wider testing in -mm.

Against: 2.6.27-rc1-mm1

Andrew, please consider for -mm.

-apw

Changes since V3:
 - Incorporates an anon vma fix pointed out by MinChan Kim
 - switch to using a pagevec for page capture collection

Changes since V2:
 - Incorporates review feedback from Christoph Lameter,
 - Incorporates review feedback from Peter Zijlstra, and
 - Checkpatch fixes.

Changes since V1:
 - Incorporates review feedback from KOSAKI Motohiro,
 - fixes up accounting when checking watermarks for captured pages,
 - rebase 2.6.27-rc1-mm1,
 - Incorporates review feedback from Mel.


Andy Whitcroft (4):
  pull out the page pre-release and sanity check logic for reuse
  pull out zone cpuset and watermark checks for reuse
  buddy: explicitly identify buddy field use in struct page
  capture pages freed during direct reclaim for allocation by the
    reclaimer

 include/linux/mm_types.h   |    4 +
 include/linux/page-flags.h |    4 +
 include/linux/pagevec.h    |    1 +
 mm/internal.h              |    7 +-
 mm/page_alloc.c            |  265 ++++++++++++++++++++++++++++++++++++++------
 mm/vmscan.c                |  118 ++++++++++++++++----
 6 files changed, 343 insertions(+), 56 deletions(-)

