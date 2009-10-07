Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbZJGIBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbZJGIBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933692AbZJGIBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933684AbZJGIBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="c'?scan'208";a="195971456"
Message-Id: <20091007074902.913463607@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:32 +0800
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
       <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/45] writeback: quit on wrap for .range_cyclic (afs)
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=linux_fs_afs_write.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
of the inode, which instructs writeback_single_inode() to delay it for
a while if necessary.

It removes one inefficient .range_cyclic IO pattern when writeback_index
wraps:
	submit [10000-10100], (wrap), submit [0-100]
In which the submitted pages may be consisted of two distant ranges.

It also prevents submitting pointless IO for busy overwriters.

CC: David Howells <dhowells@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/afs/write.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux.orig/fs/afs/write.c	2009-10-06 23:37:48.000000000 +0800
+++ linux/fs/afs/write.c	2009-10-06 23:38:42.000000000 +0800
@@ -477,8 +477,10 @@ static int afs_writepages_region(struct 
 	do {
 		n = find_get_pages_tag(mapping, &index, PAGECACHE_TAG_DIRTY,
 				       1, &page);
-		if (!n)
+		if (!n) {
+			index = 0;
 			break;
+		}
 
 		_debug("wback %lx", page->index);
 
@@ -551,9 +553,6 @@ int afs_writepages(struct address_space 
 		start = mapping->writeback_index;
 		end = -1;
 		ret = afs_writepages_region(mapping, wbc, start, end, &next);
-		if (start > 0 && wbc->nr_to_write > 0 && ret == 0)
-			ret = afs_writepages_region(mapping, wbc, 0, start,
-						    &next);
 		mapping->writeback_index = next;
 	} else if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX) {
 		end = (pgoff_t)(LLONG_MAX >> PAGE_CACHE_SHIFT);


