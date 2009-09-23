Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZIWMno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZIWMno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZIWMnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:43:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:18527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZIWMnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:43:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190735395"
Message-Id: <20090923124028.204618354@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 23 Sep 2009 20:33:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] writeback: redirty a fully scanned inode
References: <20090923123337.990689487@intel.com>
Content-Disposition: inline; filename=writeback-delay-rewrites.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redirty inode when its writeback_index wrapped around.
This is mainly to avoid unnecessary IOs for fast dirtier
that do lots of overwrites.

CC: Jan Kara <jack@suse.cz>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-09-23 18:44:56.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-23 18:52:22.000000000 +0800
@@ -397,6 +397,7 @@ writeback_single_inode(struct inode *ino
 {
 	struct address_space *mapping = inode->i_mapping;
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
+	pgoff_t start_index;
 	unsigned dirty;
 	int ret;
 
@@ -434,6 +435,7 @@ writeback_single_inode(struct inode *ino
 
 	spin_unlock(&inode_lock);
 
+	start_index = mapping->writeback_index;
 	ret = do_writepages(mapping, wbc);
 
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
@@ -485,7 +487,9 @@ writeback_single_inode(struct inode *ino
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write <= 0) {
+select_queue:
+				if (wbc->nr_to_write <= 0 &&
+				    start_index < mapping->writeback_index) {
 					/*
 					 * slice used up: queue for next turn
 					 */


