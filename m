Return-Path: <linux-kernel-owner+w=401wt.eu-S934065AbZJGIJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbZJGIJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933971AbZJGIBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:35820 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945AbZJGIBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971315"
Message-Id: <20091007074906.370852398@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:58 +0800
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
       <linux-fsdevel@vger.kernel.org>, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 40/45] writeback: requeue_io_wait() on I_SYNC locked inode
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-more_io_wait-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use requeue_io_wait() if inode is being synced by others.
This queue won't be busy retried, so avoids busy loops.

Cc: Jan Kara <jack@suse.cz> 
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-07 14:32:51.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-07 14:32:52.000000000 +0800
@@ -526,14 +526,14 @@ writeback_single_inode(struct inode *ino
 	if (inode->i_state & I_SYNC) {
 		/*
 		 * If this inode is locked for writeback and we are not doing
-		 * writeback-for-data-integrity, move it to b_more_io so that
-		 * writeback can proceed with the other inodes on s_io.
+		 * writeback-for-data-integrity, move it to b_more_io_wait so
+		 * that writeback can proceed with the other inodes on b_io.
 		 *
 		 * We'll have another go at writing back this inode when we
 		 * completed a full scan of b_io.
 		 */
 		if (!wait) {
-			requeue_io(inode);
+			requeue_io_wait(inode);
 			return 0;
 		}
 


