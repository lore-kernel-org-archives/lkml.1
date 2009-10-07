Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbZJGIAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbZJGIAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbZJGIAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067AbZJGIAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971153"
Message-Id: <20091007074905.944232109@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:55 +0800
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
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 37/45] writeback: use timestamp to indicate dirty exceeded
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-dirty-exceed-time.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there are only one (or several) dirtiers, dirty_exceeded is always
(or mostly) off. Converting to timestamp avoids this problem. It helps
to use smaller write_chunk for smoother throttling.

We'll lower ratelimit if saw dirty exceeded in the last 1 second.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

Before patch, the wait time in balance_dirty_pages() are ~200ms:

[ 1093.397700] write_bandwidth: comm=swapper pages=1536 time=204ms
[ 1093.594319] write_bandwidth: comm=swapper pages=1536 time=196ms
[ 1093.796642] write_bandwidth: comm=swapper pages=1536 time=200ms

After patch, ~25ms:

[   90.261339] write_bandwidth: comm=swapper pages=192 time=20ms
[   90.293168] write_bandwidth: comm=swapper pages=192 time=24ms
[   90.323853] write_bandwidth: comm=swapper pages=192 time=24ms
[   90.354510] write_bandwidth: comm=swapper pages=192 time=28ms
[   90.389890] write_bandwidth: comm=swapper pages=192 time=28ms
[   90.421787] write_bandwidth: comm=swapper pages=192 time=24ms

 include/linux/backing-dev.h |    2 +-
 mm/backing-dev.c            |    1 -
 mm/page-writeback.c         |    9 +++------
 3 files changed, 4 insertions(+), 8 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-07 14:32:43.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-07 14:32:46.000000000 +0800
@@ -523,14 +523,10 @@ static void balance_dirty_pages(struct a
 		goto out;
 
 throttle:
-	if (!bdi->dirty_exceeded)
-		bdi->dirty_exceeded = 1;
+	bdi->dirty_exceed_time = jiffies;
 
 	bdi_writeback_wait(bdi, write_chunk);
 
-	if (bdi->dirty_exceeded)
-		bdi->dirty_exceeded = 0;
-
 out:
 	/*
 	 * In laptop mode, we wait until hitting the higher threshold before
@@ -578,7 +574,8 @@ void balance_dirty_pages_ratelimited_nr(
 	unsigned long *p;
 
 	ratelimit = ratelimit_pages;
-	if (mapping->backing_dev_info->dirty_exceeded)
+	if (jiffies - mapping->backing_dev_info->dirty_exceed_time <
+							(unsigned long) HZ)
 		ratelimit >>= 3;
 
 	/*
--- linux.orig/include/linux/backing-dev.h	2009-10-07 14:31:53.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-07 14:32:46.000000000 +0800
@@ -74,7 +74,7 @@ struct backing_dev_info {
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
 	struct prop_local_percpu completions;
-	int dirty_exceeded;
+	unsigned long dirty_exceed_time;
 
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
--- linux.orig/mm/backing-dev.c	2009-10-07 14:31:53.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-07 14:32:46.000000000 +0800
@@ -661,7 +661,6 @@ int bdi_init(struct backing_dev_info *bd
 			goto err;
 	}
 
-	bdi->dirty_exceeded = 0;
 	err = prop_local_init_percpu(&bdi->completions);
 
 	if (err) {


