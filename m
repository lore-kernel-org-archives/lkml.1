Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbZJGIAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbZJGIAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZJGIAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:00:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758672AbZJGIAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971124"
Message-Id: <20091007074904.230238362@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:42 +0800
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
Subject: [PATCH 24/45] writeback: remove global nr_to_write and use timeout instead
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-global-timeout.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global wbc.timeout could be useful when we decide to do two sync
scans on dirty pages and dirty metadata. XFS could say: please return to
sync dirty metadata after 10s. Would need another b_io_metadata queue,
but that's possible.

CC: Theodore Ts'o <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Dave Chinner <david@fromorbit.com> 
CC: Christoph Hellwig <hch@infradead.org>
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    6 ++++++
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |    1 +
 3 files changed, 8 insertions(+)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:38:44.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:38:45.000000000 +0800
@@ -666,6 +666,10 @@ static void writeback_inodes_wb(struct b
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
 	const unsigned long start = jiffies;	/* livelock avoidance */
+	unsigned long stop_time = 0;
+
+	if (wbc->timeout)
+		stop_time = (start + wbc->timeout) | 1;
 
 	spin_lock(&inode_lock);
 
@@ -723,6 +727,8 @@ static void writeback_inodes_wb(struct b
 		}
 		if (!list_empty(&wb->b_more_io))
 			wbc->more_io = 1;
+		if (stop_time && time_after(jiffies, stop_time))
+			break;
 	}
 
 	unpin_sb_for_writeback(&pin_sb);
--- linux.orig/mm/backing-dev.c	2009-10-06 23:38:45.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:38:45.000000000 +0800
@@ -339,6 +339,7 @@ static void bdi_flush_io(struct backing_
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 		.nr_to_write		= 1024,
+		.timeout		= HZ,
 	};
 
 	writeback_inodes_wbc(&wbc);
--- linux.orig/include/linux/writeback.h	2009-10-06 23:38:44.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-06 23:38:45.000000000 +0800
@@ -42,6 +42,7 @@ struct writeback_control {
 	struct super_block *sb;		/* if !NULL, only write inodes from
 					   this super_block */
 	enum writeback_sync_modes sync_mode;
+	int timeout;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
 	long nr_to_write;		/* Write this many pages, and decrement


