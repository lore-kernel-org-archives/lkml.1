Return-Path: <linux-kernel-owner+w=401wt.eu-S934124AbZJGIE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124AbZJGIE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934092AbZJGIDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:03:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:9396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011AbZJGIDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:03:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195972052"
Message-Id: <20091007074906.994003723@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:39:03 +0800
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
Subject: [PATCH 45/45] btrfs: fix race on syncing the btree inode
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=btrfs-remove-nr_to_write-tricks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing sync, the btree dirty pages refuse to go away for tens of seconds:

# vmmon -d 1 nr_writeback nr_dirty nr_unstable

     nr_writeback         nr_dirty      nr_unstable
            46641            23315                0
            46641            23380                0
            46641            23381                0
            26674            43206                0
            18963            51006                0
            11252            58721                0
             3528            66419                0
                0            70024                0
                0            70024                0
                0            70024                0
                0            70024                0
                0            70024                0
                0            70024                0
                0            70024                0
                0            70024                0

Note that the 70024 pages are under the btree inode's 32MB
no-write-metadata threshold. This is racy because the sync
work has to sleep and retry it forever for data integrity.

The 32MB threshold may also become a problem for background
writeback given a memory tight box. So it may be better to
replace the threshold with some informed writeback tricks.

CC: Chris Mason <chris.mason@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/disk-io.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- linux.orig/fs/btrfs/disk-io.c	2009-10-07 14:31:45.000000000 +0800
+++ linux/fs/btrfs/disk-io.c	2009-10-07 14:32:55.000000000 +0800
@@ -707,22 +707,19 @@ static int btree_writepage(struct page *
 static int btree_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
-	struct extent_io_tree *tree;
-	tree = &BTRFS_I(mapping->host)->io_tree;
-	if (wbc->sync_mode == WB_SYNC_NONE) {
-		struct btrfs_root *root = BTRFS_I(mapping->host)->root;
-		u64 num_dirty;
-		unsigned long thresh = 32 * 1024 * 1024;
-
-		if (wbc->for_kupdate)
-			return 0;
-
-		/* this is a bit racy, but that's ok */
-		num_dirty = root->fs_info->dirty_metadata_bytes;
-		if (num_dirty < thresh)
-			return 0;
-	}
-	return extent_writepages(tree, mapping, btree_get_extent, wbc);
+	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
+	int ret;
+
+	if (!wbc->for_sync)
+		wbc->nr_segments = 1;
+	ret = extent_writepages(tree, mapping, btree_get_extent, wbc);
+	/*
+	 * Fake some some skipped pages, so that VFS won't
+	 * try hard on writing this inode.
+	 */
+	if (!wbc->for_sync)
+		wbc->pages_skipped++;
+	return ret;
 }
 
 static int btree_readpage(struct file *file, struct page *page)


