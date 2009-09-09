Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZIIPJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZIIPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZIIPJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:09:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:65365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZIIPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185728205"
Message-Id: <20090909150600.727523225@intel.com>
References: <20090909145141.293229693@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Sep 2009 22:51:45 +0800
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
Subject: [RFC][PATCH 4/7] writeback: ensure large files are written in MAX_WRITEBACK_PAGES chunks
Content-Disposition: inline; filename=writeback-track-large-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remember pages written for the current file between successive 
writeback_single_inode() invocations, and modify wbc->nr_to_write
accordingly to continue write the file until MAX_WRITEBACK_PAGES is
reached for this single file.

This ensures large files will be written in large MAX_WRITEBACK_PAGES
chunks. It works best for kernel sync threads which repeatedly call into
writeback_single_inode() with the same wbc. For balance_dirty_pages()
that normally restart with a fresh wbc, it may never collect enough
last_file_written to skip the current large file, hence lead to
starvation of other (small) files. However/luckily balance_dirty_pages()
writeback is normally interleaved with background writeback, which will
do the duty of rotating the writeback files. So this is not a bit problem.

CC: Dave Chinner <david@fromorbit.com>
Cc: Martin Bligh <mbligh@google.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   41 +++++++++++++++++++++++++++---------
 include/linux/writeback.h |   12 ++++++++++
 2 files changed, 43 insertions(+), 10 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-09 21:50:53.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-09 21:51:04.000000000 +0800
@@ -271,6 +271,19 @@ static void requeue_io(struct inode *ino
 	list_move(&inode->i_list, &wb->b_more_io);
 }
 
+/*
+ * continue io on this inode on next writeback if
+ * it has not accumulated large enough writeback io chunk
+ */
+static void requeue_partial_io(struct writeback_control *wbc, struct inode *inode)
+{
+	if (wbc->last_file_written == 0 ||
+	    wbc->last_file_written >= MAX_WRITEBACK_PAGES)
+		return requeue_io(inode);
+
+	list_move_tail(&inode->i_list, &inode_to_bdi(inode)->wb.b_io);
+}
+
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
@@ -365,6 +378,8 @@ writeback_single_inode(struct inode *ino
 {
 	struct address_space *mapping = inode->i_mapping;
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
+	long last_file_written;
+	long nr_to_write;
 	unsigned dirty;
 	int ret;
 
@@ -402,8 +417,21 @@ writeback_single_inode(struct inode *ino
 
 	spin_unlock(&inode_lock);
 
+	if (wbc->last_file != inode->i_ino)
+		last_file_written = 0;
+	else
+		last_file_written = wbc->last_file_written;
+	wbc->nr_to_write -= last_file_written;
+	nr_to_write = wbc->nr_to_write;
+
 	ret = do_writepages(mapping, wbc);
 
+	if (wbc->last_file != inode->i_ino) {
+		wbc->last_file = inode->i_ino;
+		wbc->last_file_written = nr_to_write - wbc->nr_to_write;
+	} else
+		wbc->last_file_written += nr_to_write - wbc->nr_to_write;
+
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		int err = write_inode(inode, wait);
@@ -436,7 +464,7 @@ writeback_single_inode(struct inode *ino
 				/*
 				 * slice used up: queue for next turn
 				 */
-				requeue_io(inode);
+				requeue_partial_io(wbc, inode);
 			} else {
 				/*
 				 * somehow blocked: retry later
@@ -456,6 +484,8 @@ writeback_single_inode(struct inode *ino
 		}
 	}
 	inode_sync_complete(inode);
+	wbc->nr_to_write += last_file_written;
+
 	return ret;
 }
 
@@ -612,15 +642,6 @@ void writeback_inodes_wbc(struct writeba
 	writeback_inodes_wb(&bdi->wb, wbc);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
--- linux.orig/include/linux/writeback.h	2009-09-09 21:50:53.000000000 +0800
+++ linux/include/linux/writeback.h	2009-09-09 21:51:22.000000000 +0800
@@ -14,6 +14,16 @@ extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
+ * The maximum number of pages to writeout in a single bdi flush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES     1024
+
+
+/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
@@ -36,6 +46,8 @@ struct writeback_control {
 					   older than this */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
+	unsigned long last_file;	/* Inode number of last written file */
+	long last_file_written;		/* Total pages written for last file */
 	long pages_skipped;		/* Pages which were not written */
 
 	/*

-- 

