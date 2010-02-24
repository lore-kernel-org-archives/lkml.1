Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0BXDMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:12:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:10294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab0BXDMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:12:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="775369720"
Message-Id: <20100224031055.738182009@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
cc: Matt Mackall <mpm@selenic.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/15] readahead: pagecache context based mmap read-around
References: <20100224031001.026464755@intel.com>
Content-Disposition: inline; filename=readahead-mmap-around-context.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do mmap read-around when there are cached pages in the nearby 256KB
(covered by one radix tree node).

There is a failure case though: for a sequence of page faults at page
index 64*i+1, i=1,2,3,..., this heuristic will keep doing pointless
read-arounds.  Hopefully the pattern won't appear in real workloads.
Note that the readahead heuristic has similiar failure case.

CC: Nick Piggin <npiggin@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- linux.orig/mm/filemap.c	2010-02-23 13:20:39.000000000 +0800
+++ linux/mm/filemap.c	2010-02-23 13:22:36.000000000 +0800
@@ -1421,11 +1421,17 @@ static void do_sync_mmap_readahead(struc
 
 
 	/*
-	 * Do we miss much more than hit in this file? If so,
-	 * stop bothering with read-ahead. It will only hurt.
+	 * Do we miss much more than hit in this file? If so, stop bothering
+	 * with read-around, unless some nearby pages were accessed recently.
 	 */
-	if (ra_mmap_miss_inc(ra) > MMAP_LOTSAMISS)
-		return;
+	if (ra_mmap_miss_inc(ra) > MMAP_LOTSAMISS) {
+		struct radix_tree_node *node;
+		rcu_read_lock();
+		node = radix_tree_lookup_leaf_node(&mapping->page_tree, offset);
+		rcu_read_unlock();
+		if (!node)
+			return;
+	}
 
 	/*
 	 * mmap read-around


