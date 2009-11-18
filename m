Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZKRIee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZKRIee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZKRIeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:34:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZKRIby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830420"
Message-Id: <20091118082846.719033780@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/12] writeback: remove the always false bdi_cap_writeback_dirty() test
References: <20091118082648.140755818@intel.com>
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

--- linux.orig/fs/fs-writeback.c	2009-11-18 16:25:51.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-11-18 16:26:04.000000000 +0800
@@ -597,7 +597,6 @@ static void writeback_inodes_wb(struct b
 				struct writeback_control *wbc)
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
-	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
 	spin_lock(&inode_lock);
@@ -618,23 +617,6 @@ static void writeback_inodes_wb(struct b
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


