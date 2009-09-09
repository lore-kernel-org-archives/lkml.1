Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZIIPIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZIIPIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZIIPIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:08:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:65365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZIIPH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185728213"
Message-Id: <20090909150600.583737346@intel.com>
References: <20090909145141.293229693@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Sep 2009 22:51:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@infradead.org>
CC: jack@suse.cz
CC: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [RFC][PATCH 3/7] writeback: merge for_kupdate and !for_kupdate requeue io logics
Content-Disposition: inline; filename=writeback-more_io_wait-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the logic for kupdate and non-kupdate cases.
There won't be starvation because the inodes requeued into b_more_io or
b_more_io_wait will later be spliced _after_ the remaining inodes in b_io,
hence won't stand in the way of other inodes in the next run.

CC: Dave Chinner <david@fromorbit.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-09 20:47:11.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-09 20:48:01.000000000 +0800
@@ -426,45 +426,18 @@ writeback_single_inode(struct inode *ino
 		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything. Redirty
-			 * the inode; Move it from b_io onto b_more_io/b_dirty.
+			 * sometimes bales out without doing anything.
 			 */
-			/*
-			 * akpm: if the caller was the kupdate function we put
-			 * this inode at the head of b_dirty so it gets first
-			 * consideration.  Otherwise, move it to the tail, for
-			 * the reasons described there.  I'm not really sure
-			 * how much sense this makes.  Presumably I had a good
-			 * reasons for doing it this way, and I'd rather not
-			 * muck with it at present.
-			 */
-			if (wbc->for_kupdate) {
+			inode->i_state |= I_DIRTY_PAGES;
+			if (wbc->nr_to_write <= 0) {
 				/*
-				 * For the kupdate function we move the inode
-				 * to b_more_io so it will get more writeout as
-				 * soon as the queue becomes uncongested.
+				 * slice used up: queue for next turn
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write <= 0) {
-					/*
-					 * slice used up: queue for next turn
-					 */
-					requeue_io(inode);
-				} else {
-					/*
-					 * somehow blocked: retry later
-					 */
-					redirty_tail(inode);
-				}
+				requeue_io(inode);
 			} else {
 				/*
-				 * Otherwise fully redirty the inode so that
-				 * other inodes on this superblock will get some
-				 * writeout.  Otherwise heavy writing to one
-				 * file would indefinitely suspend writeout of
-				 * all the other files.
+				 * somehow blocked: retry later
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
 		} else if (atomic_read(&inode->i_count)) {

-- 

