Return-Path: <linux-kernel-owner+w=401wt.eu-S934160AbZJGINa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbZJGINa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933993AbZJGIN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:13:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbZJGIBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="c'?scan'208";a="195971410"
Message-Id: <20091007074902.649878005@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:30 +0800
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
Subject: [PATCH 12/45] writeback: quit on wrap for .range_cyclic (ext4)
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=linux_fs_ext4_inode.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
of the inode, which instructs writeback_single_inode() to delay it for a
while if necessary.

It removes one inefficient .range_cyclic IO pattern when writeback_index
wraps:
	submit [10000-10100], (wrap), submit [0-100]
In which the submitted pages may be consisted of two distant ranges.

It also prevents submitting pointless IO for busy overwriters.

CC: Theodore Ts'o <tytso@mit.edu> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext4/inode.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- linux.orig/fs/ext4/inode.c	2009-10-06 23:37:48.000000000 +0800
+++ linux/fs/ext4/inode.c	2009-10-06 23:38:35.000000000 +0800
@@ -2805,7 +2805,7 @@ static int ext4_da_writepages(struct add
 	int pages_written = 0;
 	long pages_skipped;
 	unsigned int max_pages;
-	int range_cyclic, cycled = 1, io_done = 0;
+	int range_cyclic, io_done = 0;
 	int needed_blocks, ret = 0;
 	long desired_nr_to_write, nr_to_writebump = 0;
 	loff_t range_start = wbc->range_start;
@@ -2840,8 +2840,6 @@ static int ext4_da_writepages(struct add
 	range_cyclic = wbc->range_cyclic;
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
-		if (index)
-			cycled = 0;
 		wbc->range_start = index << PAGE_CACHE_SHIFT;
 		wbc->range_end  = LLONG_MAX;
 		wbc->range_cyclic = 0;
@@ -2889,7 +2887,6 @@ static int ext4_da_writepages(struct add
 	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
-retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2963,20 +2960,13 @@ retry:
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
 			io_done = 1;
-		} else if (wbc->nr_to_write)
+		} else if (wbc->nr_to_write > 0) {
 			/*
 			 * There is no more writeout needed
-			 * or we requested for a noblocking writeout
-			 * and we found the device congested
 			 */
+			index = 0;
 			break;
-	}
-	if (!io_done && !cycled) {
-		cycled = 1;
-		index = 0;
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
-		wbc->range_end  = mapping->writeback_index - 1;
-		goto retry;
+		}
 	}
 	if (pages_skipped != wbc->pages_skipped)
 		ext4_msg(inode->i_sb, KERN_CRIT,


