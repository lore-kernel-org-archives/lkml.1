Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZIWMo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZIWMo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZIWMoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:44:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:18527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZIWMnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:43:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190735406"
Message-Id: <20090923124028.060887241@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 23 Sep 2009 20:33:43 +0800
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
Subject: [PATCH 5/6] writeback: don't delay inodes redirtied by a fast dirtier
References: <20090923123337.990689487@intel.com>
Content-Disposition: inline; filename=writeback-redirty-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debug traces show that in per-bdi writeback, the inode under writeback
almost always get redirtied by a busy dirtier.  We used to call
redirty_tail() in this case, which could delay inode for up to 30s.

This is unacceptable because it now happens so frequently for plain cp/dd,
that the accumulated delays could make writeback of big files very slow.

So let's distinguish between data redirty and metadata only redirty.
The first one is caused by a busy dirtier, while the latter one could
happen in XFS, NFS, etc. when they are doing delalloc or updating isize.

The inode being busy dirtied will now be requeued for next io, while
the inode being redirtied by fs will continue to be delayed to avoid
repeated IO.

CC: Jan Kara <jack@suse.cz>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-23 16:13:41.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-23 16:21:24.000000000 +0800
@@ -491,10 +493,15 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
-		if (inode->i_state & I_DIRTY) {
+		if (inode->i_state & I_DIRTY_PAGES) {
 			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
+			 * More pages get dirtied by a fast dirtier.
+			 */
+			goto select_queue;
+		} else if (inode->i_state & I_DIRTY) {
+			/*
+			 * At least XFS will redirty the inode during the
+			 * writeback (delalloc) and on io completion (isize).
 			 */
 			redirty_tail(inode);
 		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {


