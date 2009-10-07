Return-Path: <linux-kernel-owner+w=401wt.eu-S934047AbZJGICr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbZJGICr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbZJGICl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:02:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934031AbZJGICh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971998"
Message-Id: <20091007074905.131727024@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:49 +0800
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
Subject: [PATCH 31/45] writeback: sync old inodes first in background writeback
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-expired-for-background.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A background flush work may run for ever. So it's reasonable for it to
mimic the kupdate behavior of syncing old/expired inodes first.

CC: Jan Kara <jack@suse.cz> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:39:28.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:39:31.000000000 +0800
@@ -680,7 +680,7 @@ static long writeback_inodes_wb(struct b
 
 	spin_lock(&inode_lock);
 
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
 	while (!list_empty(&wb->b_io)) {
@@ -793,14 +793,15 @@ static long wb_writeback(struct bdi_writ
 		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
+	int expire_interval = msecs_to_jiffies(dirty_expire_interval * 10);
+	int fg_rounds = 0;
 	long wrote = 0;
 	long nr;
 	struct inode *inode;
 
-	if (wbc.for_kupdate) {
+	if (wbc.for_kupdate || wbc.for_background) {
 		wbc.older_than_this = &oldest_jif;
-		oldest_jif = jiffies -
-				msecs_to_jiffies(dirty_expire_interval * 10);
+		oldest_jif = jiffies - expire_interval;
 	}
 	if (!wbc.range_cyclic) {
 		wbc.range_start = 0;
@@ -828,6 +829,18 @@ static long wb_writeback(struct bdi_writ
 		args->nr_pages -= nr;
 		wrote += nr;
 
+		if (args->for_background && expire_interval &&
+		    ++fg_rounds && list_empty(&wb->b_io)) {
+			if (fg_rounds < 10)
+				expire_interval >>= 1;
+			if (expire_interval)
+				oldest_jif = jiffies - expire_interval;
+			else
+				wbc.older_than_this = 0;
+			fg_rounds = 0;
+			continue;
+		}
+
 		/*
 		 * Bail if no more IO
 		 */


