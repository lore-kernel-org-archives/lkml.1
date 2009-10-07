Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbZJGIBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbZJGIBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933943AbZJGIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:50747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933939AbZJGIBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971292"
Message-Id: <20091007074905.694996170@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:53 +0800
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
Subject: [PATCH 35/45] writeback: sync livelock - use single timestamp for whole sync work
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-sync-pending-start_time.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The start time in writeback_inodes_wb() is not very useful because it
slips at each invocation time. We shall use one _constant_ time at the
beginning to cover this whole sync() work.

The timestamp is now grabbed at work start time. It could be better set
at the sync work submission time.

CC: Jan Kara <jack@suse.cz> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:39:33.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:39:39.000000000 +0800
@@ -669,12 +669,11 @@ static long writeback_inodes_wb(struct b
 				struct writeback_control *wbc)
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
-	const unsigned long start = jiffies;	/* livelock avoidance */
 	unsigned long stop_time = 0;
 	unsigned long wrote = 0;
 
 	if (wbc->timeout)
-		stop_time = (start + wbc->timeout) | 1;
+		stop_time = (jiffies + wbc->timeout) | 1;
 
 	spin_lock(&inode_lock);
 
@@ -699,13 +698,6 @@ static long writeback_inodes_wb(struct b
 			continue;
 		}
 
-		/*
-		 * Was this inode dirtied after sync_sb_inodes was called?
-		 * This keeps sync from extra jobs and livelock.
-		 */
-		if (inode_dirtied_after(inode, start))
-			break;
-
 		if (pin_sb_for_writeback(wbc, inode, &pin_sb)) {
 			requeue_io(inode);
 			continue;
@@ -798,6 +790,13 @@ static long wb_writeback(struct bdi_writ
 	long nr;
 	struct inode *inode;
 
+	/*
+	 * keep sync from extra jobs and livelock
+	 */
+	if (wbc.for_sync) {
+		wbc.older_than_this = &oldest_jif;
+		oldest_jif = jiffies;
+	}
 	if (wbc.for_kupdate || wbc.for_background) {
 		wbc.older_than_this = &oldest_jif;
 		oldest_jif = jiffies - expire_interval;


