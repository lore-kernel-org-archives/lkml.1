Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZK0LhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZK0LhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZK0LhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:37:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:31626 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbZK0LhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:37:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,300,1257148800"; 
   d="scan'208";a="216271354"
Message-Id: <20091127110407.243915604@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Nov 2009 18:59:09 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/6] writeback: remove unused nonblocking and congestion checks
References: <20091127105908.944744141@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_fs_fs-writeback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- no one is calling wb_writeback and write_cache_pages with
  wbc.nonblocking=1 any more
- lumpy pageout will want to do nonblocking writeback without the
  congestion wait

So remove the congestion checks as suggested by Chris.

CC: Chris Mason <chris.mason@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    9 ---------
 1 file changed, 9 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-11-27 16:35:00.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-11-27 18:54:50.000000000 +0800
@@ -657,14 +657,6 @@ static void writeback_inodes_wb(struct b
 			continue;
 		}
 
-		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
-			wbc->encountered_congestion = 1;
-			if (!is_blkdev_sb)
-				break;		/* Skip a congested fs */
-			requeue_io(inode);
-			continue;		/* Skip a congested blockdev */
-		}
-
 		/*
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
@@ -787,7 +779,6 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);


