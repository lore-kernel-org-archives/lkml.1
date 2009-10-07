Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbZJGIHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbZJGIHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934017AbZJGIC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:02:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730AbZJGICZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971827"
Message-Id: <20091007074901.755680773@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:23 +0800
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
Subject: [PATCH 05/45] writeback: remove the always false bdi_cap_writeback_dirty() test
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-remove-memory-bdi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is dead code because no bdi flush thread will be started for
!bdi_cap_writeback_dirty bdis.

CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:31:59.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:37:57.000000000 +0800
@@ -617,7 +617,6 @@ static void writeback_inodes_wb(struct b
 				struct writeback_control *wbc)
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
-	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
 	spin_lock(&inode_lock);
@@ -638,23 +637,6 @@ static void writeback_inodes_wb(struct b
 			continue;
 		}
 
-		if (!bdi_cap_writeback_dirty(wb->bdi)) {
-			redirty_tail(inode);
-			if (is_blkdev_sb) {
-				/*
-				 * Dirty memory-backed blockdev: the ramdisk
-				 * driver does this.  Skip just this inode
-				 */
-				continue;
-			}
-			/*
-			 * Dirty memory-backed inode against a filesystem other
-			 * than the kernel-internal bdev filesystem.  Skip the
-			 * entire superblock.
-			 */
-			break;
-		}
-
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
 			requeue_io(inode);
 			continue;


