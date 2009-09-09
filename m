Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZIIPIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZIIPIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZIIPIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:08:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:65365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZIIPH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185728207"
Message-Id: <20090909150600.330539880@intel.com>
References: <20090909145141.293229693@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Sep 2009 22:51:42 +0800
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
Subject: [RFC][PATCH 1/7] writeback: cleanup writeback_single_inode()
Content-Disposition: inline; filename=writeback-simplify-x.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the if-else straight in writeback_single_inode().
No behavior change.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-09 21:40:41.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-09 21:41:14.000000000 +0800
@@ -417,8 +417,13 @@ writeback_single_inode(struct inode *ino
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
@@ -462,12 +467,6 @@ writeback_single_inode(struct inode *ino
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

-- 

