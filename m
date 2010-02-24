Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0BXDMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:12:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:40913 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0BXDMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:12:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="247401637"
Message-Id: <20100224031054.449606633@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
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
Subject: [PATCH 06/15] readahead: replace ra->mmap_miss with ra->ra_flags
References: <20100224031001.026464755@intel.com>
Content-Disposition: inline; filename=readahead-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a readahead flags field and embed the existing mmap_miss in it
(mainly to save space).

It also changes the mmap_miss upper bound from LONG_MAX to 4096.
This is to help adapt properly for changing mmap access patterns.

It will be possible to lose the flags in race conditions, however the
impact should be limited.  For the race to happen, there must be two
threads sharing the same file descriptor to be in page fault or
readahead at the same time.

Note that it has always been racy for "page faults" at the same time.

And if ever the race happen, we'll lose one mmap_miss++ or mmap_miss--.
Which may change some concrete readahead behavior, but won't really
impact overall I/O performance.

CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |   30 +++++++++++++++++++++++++++++-
 mm/filemap.c       |    7 ++-----
 2 files changed, 31 insertions(+), 6 deletions(-)

--- linux.orig/include/linux/fs.h	2010-02-24 10:44:30.000000000 +0800
+++ linux/include/linux/fs.h	2010-02-24 10:44:43.000000000 +0800
@@ -889,10 +889,38 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
+	unsigned int ra_flags;
 	loff_t prev_pos;		/* Cache last read() position */
 };
 
+/* ra_flags bits */
+#define	READAHEAD_MMAP_MISS	0x00000fff /* cache misses for mmap access */
+
+/*
+ * Don't do ra_flags++ directly to avoid possible overflow:
+ * the ra fields can be accessed concurrently in a racy way.
+ */
+static inline unsigned int ra_mmap_miss_inc(struct file_ra_state *ra)
+{
+	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
+
+	if (miss < READAHEAD_MMAP_MISS) {
+		miss++;
+		ra->ra_flags = miss | (ra->ra_flags &~ READAHEAD_MMAP_MISS);
+	}
+	return miss;
+}
+
+static inline void ra_mmap_miss_dec(struct file_ra_state *ra)
+{
+	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
+
+	if (miss) {
+		miss--;
+		ra->ra_flags = miss | (ra->ra_flags &~ READAHEAD_MMAP_MISS);
+	}
+}
+
 /*
  * Check if @index falls in the readahead windows.
  */
--- linux.orig/mm/filemap.c	2010-02-24 10:44:25.000000000 +0800
+++ linux/mm/filemap.c	2010-02-24 10:44:43.000000000 +0800
@@ -1418,14 +1418,12 @@ static void do_sync_mmap_readahead(struc
 		return;
 	}
 
-	if (ra->mmap_miss < INT_MAX)
-		ra->mmap_miss++;
 
 	/*
 	 * Do we miss much more than hit in this file? If so,
 	 * stop bothering with read-ahead. It will only hurt.
 	 */
-	if (ra->mmap_miss > MMAP_LOTSAMISS)
+	if (ra_mmap_miss_inc(ra) > MMAP_LOTSAMISS)
 		return;
 
 	/*
@@ -1455,8 +1453,7 @@ static void do_async_mmap_readahead(stru
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
 		return;
-	if (ra->mmap_miss > 0)
-		ra->mmap_miss--;
+	ra_mmap_miss_dec(ra);
 	if (PageReadahead(page))
 		page_cache_async_readahead(mapping, ra, file,
 					   page, offset, ra->ra_pages);


