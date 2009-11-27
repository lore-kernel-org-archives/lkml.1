Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZK0LgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZK0LgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZK0LgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:36:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:23832 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbZK0LgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:36:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,300,1257148800"; 
   d="scan'208";a="216271224"
Message-Id: <20091127110407.852540101@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Nov 2009 18:59:13 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/6] writeback: remove the always false bdi_cap_writeback_dirty() test
References: <20091127105908.944744141@intel.com>
Content-Disposition: inline; filename=writeback-remove-memory-bdi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is dead code because no bdi flush thread will be started for
!bdi_cap_writeback_dirty bdi.

CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-11-27 18:54:50.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-11-27 18:55:11.000000000 +0800
@@ -614,7 +614,6 @@ static void writeback_inodes_wb(struct b
 				struct writeback_control *wbc)
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
-	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
 	spin_lock(&inode_lock);
@@ -635,23 +634,6 @@ static void writeback_inodes_wb(struct b
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


