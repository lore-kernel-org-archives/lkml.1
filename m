Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbZJGIDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbZJGIDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934071AbZJGIDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:03:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934063AbZJGIC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195972038"
Message-Id: <20091007074901.884235522@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/45] writeback: use larger ratelimit when dirty_exceeded
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-ratelimit-on-dirty-exceeded.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dirty_exceeded, use ratelimit = ratelimit_pages/8, allowing it to
scale up to 512KB for memory bounty systems. This is more efficient than
the original 8 pages, and won't risk exceeding the dirty limit too much.

Given the larger ratelimit value, we can safely ignore the low bound
check in sync_writeback_pages.

dirty_exceeded is more likely to be seen when there are multiple dirty
processes. In which case the lowered ratelimit will help reduce their
overall wait time (latency) in the throttled queue.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-06 23:37:50.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:38:18.000000000 +0800
@@ -39,7 +39,8 @@
  * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
  * will look to see if it needs to force writeback or throttling.
  */
-static long ratelimit_pages = 32;
+#define MAX_RATELIMIT_PAGES ((4096 * 1024) / PAGE_CACHE_SIZE)
+static long ratelimit_pages = MAX_RATELIMIT_PAGES;
 
 /*
  * When balance_dirty_pages decides that the caller needs to perform some
@@ -49,9 +50,6 @@ static long ratelimit_pages = 32;
  */
 static inline long sync_writeback_pages(unsigned long dirtied)
 {
-	if (dirtied < ratelimit_pages)
-		dirtied = ratelimit_pages;
-
 	return dirtied + dirtied / 2;
 }
 
@@ -600,7 +598,7 @@ void balance_dirty_pages_ratelimited_nr(
 
 	ratelimit = ratelimit_pages;
 	if (mapping->backing_dev_info->dirty_exceeded)
-		ratelimit = 8;
+		ratelimit >>= 3;
 
 	/*
 	 * Check the rate limiting. Also, we do not want to throttle real-time
@@ -722,8 +720,8 @@ void writeback_set_ratelimit(void)
 	ratelimit_pages = vm_total_pages / (num_online_cpus() * 32);
 	if (ratelimit_pages < 16)
 		ratelimit_pages = 16;
-	if (ratelimit_pages * PAGE_CACHE_SIZE > 4096 * 1024)
-		ratelimit_pages = (4096 * 1024) / PAGE_CACHE_SIZE;
+	if (ratelimit_pages > MAX_RATELIMIT_PAGES)
+		ratelimit_pages = MAX_RATELIMIT_PAGES;
 }
 
 static int __cpuinit


