Return-Path: <linux-kernel-owner+w=401wt.eu-S933991AbZJGIKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbZJGIKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZJGIBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:35820 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911AbZJGIBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971282"
Message-Id: <20091007074904.870825579@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:47 +0800
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
       <linux-fsdevel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/45] writeback: fix the shmem AOP_WRITEPAGE_ACTIVATE case
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-for-reclaim-pre-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When shmem returns AOP_WRITEPAGE_ACTIVATE, the inode pages cannot be
synced in the near future. So write_cache_pages shall stop writting this
inode, and shmem shall increase pages_skipped to instruct VFS not to
busy retry.

CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

---
 mm/page-writeback.c |   23 +++++++++++------------
 mm/shmem.c          |    1 +
 2 files changed, 12 insertions(+), 12 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-06 23:39:28.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-06 23:39:29.000000000 +0800
@@ -851,19 +851,18 @@ continue_unlock:
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {
 					unlock_page(page);
 					ret = 0;
-				} else {
-					/*
-					 * done_index is set past this page,
-					 * so media errors will not choke
-					 * background writeout for the entire
-					 * file. This has consequences for
-					 * range_cyclic semantics (ie. it may
-					 * not be suitable for data integrity
-					 * writeout).
-					 */
-					done = 1;
-					break;
 				}
+				/*
+				 * done_index is set past this page,
+				 * so media errors will not choke
+				 * background writeout for the entire
+				 * file. This has consequences for
+				 * range_cyclic semantics (ie. it may
+				 * not be suitable for data integrity
+				 * writeout).
+				 */
+				done = 1;
+				break;
  			}
 
 			if (nr_to_write > 0) {
--- linux.orig/mm/shmem.c	2009-10-06 23:37:40.000000000 +0800
+++ linux/mm/shmem.c	2009-10-06 23:39:29.000000000 +0800
@@ -1103,6 +1103,7 @@ unlock:
 	 */
 	swapcache_free(swap, NULL);
 redirty:
+	wbc->pages_skipped++;
 	set_page_dirty(page);
 	if (wbc->for_reclaim)
 		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */


