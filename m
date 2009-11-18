Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZKRIcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZKRIcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZKRIcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:32:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:27526 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbZKRIby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830429"
Message-Id: <20091118082845.565669527@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/12] writeback: remove unused nonblocking and congestion checks
References: <20091118082648.140755818@intel.com>
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

--- linux.orig/fs/fs-writeback.c	2009-11-18 16:25:49.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-11-18 16:25:51.000000000 +0800
@@ -640,14 +640,6 @@ static void writeback_inodes_wb(struct b
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
@@ -770,7 +762,6 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);


