Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbZIWMoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbZIWMoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZIWMoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:44:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:41517 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZIWMnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190735416"
Message-Id: <20090923124027.928511190@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 23 Sep 2009 20:33:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jan Kara <jack@suse.cz>, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] writeback: cleanup writeback_single_inode()
References: <20090923123337.990689487@intel.com>
Content-Disposition: inline; filename=writeback-simplify-x.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the if-else straight in writeback_single_inode().
No behavior change.

Cc: Jan Kara <jack@suse.cz>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-23 18:33:17.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-23 18:44:10.000000000 +0800
@@ -452,8 +452,13 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
-		if (!(inode->i_state & I_DIRTY) &&
-		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		if (inode->i_state & I_DIRTY) {
+			/*
+			 * Someone redirtied the inode while were writing back
+			 * the pages.
+			 */
+			redirty_tail(inode);
+		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
@@ -497,12 +502,6 @@ writeback_single_inode(struct inode *ino
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
-			 */
-			redirty_tail(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse


