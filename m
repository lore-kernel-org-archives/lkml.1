Return-Path: <linux-kernel-owner+w=401wt.eu-S934113AbZJGIIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbZJGIIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933198AbZJGIIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:08:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:50747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933988AbZJGIB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="c'?scan'208";a="195971921"
Message-Id: <20091007074902.518009147@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:29 +0800
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
       <linux-fsdevel@vger.kernel.org>, Steve French <sfrench@samba.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/45] writeback: quit on wrap for .range_cyclic (cifs)
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=linux_fs_cifs_file.c
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

CC: Steve French <sfrench@samba.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/cifs/file.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- linux.orig/fs/cifs/file.c	2009-10-06 23:37:49.000000000 +0800
+++ linux/fs/cifs/file.c	2009-10-06 23:38:33.000000000 +0800
@@ -1337,7 +1337,6 @@ static int cifs_partialpagewrite(struct 
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	unsigned int bytes_to_write;
 	unsigned int bytes_written;
 	struct cifs_sb_info *cifs_sb;
@@ -1349,14 +1348,13 @@ static int cifs_writepages(struct addres
 	int len;
 	int n_iov = 0;
 	pgoff_t next;
-	int nr_pages;
+	int nr_pages = 1;
 	__u64 offset = 0;
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsi = CIFS_I(mapping->host);
 	struct page *page;
 	struct pagevec pvec;
 	int rc = 0;
-	int scanned = 0;
 	int xid, long_op;
 
 	cifs_sb = CIFS_SB(mapping->host->i_sb);
@@ -1390,9 +1388,8 @@ static int cifs_writepages(struct addres
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
-retry:
+
 	while (!done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			PAGECACHE_TAG_DIRTY,
@@ -1425,7 +1422,7 @@ retry:
 				break;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
 				done = 1;
 				unlock_page(page);
 				break;
@@ -1537,15 +1534,8 @@ retry:
 
 		pagevec_release(&pvec);
 	}
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
+	if (!nr_pages)
 		index = 0;
-		goto retry;
-	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 


