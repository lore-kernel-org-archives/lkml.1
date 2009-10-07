Return-Path: <linux-kernel-owner+w=401wt.eu-S934067AbZJGIGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbZJGIGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbZJGIGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:06:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934036AbZJGICl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195972000"
Message-Id: <20091007074904.594171831@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:45 +0800
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
Subject: [PATCH 27/45] writeback: introduce wbc.for_background
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-add-wbc-for_background.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be tested for setting wbc.nr_segments, lower the flush priority
for NFS, and maybe more in future.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    1 +
 fs/nfs/write.c            |    2 +-
 include/linux/writeback.h |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:38:56.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:39:27.000000000 +0800
@@ -783,6 +783,7 @@ static long wb_writeback(struct bdi_writ
 		.sync_mode		= args->sync_mode,
 		.older_than_this	= NULL,
 		.for_kupdate		= args->for_kupdate,
+		.for_background		= args->for_background,
 		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
--- linux.orig/include/linux/writeback.h	2009-10-06 23:38:52.000000000 +0800
+++ linux/include/linux/writeback.h	2009-10-06 23:39:27.000000000 +0800
@@ -61,6 +61,7 @@ struct writeback_control {
 	unsigned nonblocking:1;		/* Don't get stuck on request queues */
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
+	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
--- linux.orig/fs/nfs/write.c	2009-10-06 23:38:44.000000000 +0800
+++ linux/fs/nfs/write.c	2009-10-06 23:39:27.000000000 +0800
@@ -178,7 +178,7 @@ static int wb_priority(struct writeback_
 {
 	if (wbc->for_reclaim)
 		return FLUSH_HIGHPRI | FLUSH_STABLE;
-	if (wbc->for_kupdate)
+	if (wbc->for_kupdate || wbc->for_background)
 		return FLUSH_LOWPRI;
 	return 0;
 }


