Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZIIPIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZIIPIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZIIPIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:08:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:41520 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZIIPH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185728217"
Message-Id: <20090909150600.874037375@intel.com>
References: <20090909145141.293229693@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Sep 2009 22:51:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@infradead.org>
CC: jack@suse.cz
CC: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [RFC][PATCH 5/7] writeback: use 64MB MAX_WRITEBACK_PAGES
Content-Disposition: inline; filename=writeback-64M-MAX_WRITEBACK_PAGES.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore has a nice description:

Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
concern of not holding I_SYNC for too long.  (At least, that was the
comment previously.)  This doesn't make sense now because the only
time we wait for I_SYNC is if we are calling sync or fsync, and in
that case we need to write out all of the data anyway.  Previously
there may have been other code paths that waited on I_SYNC, but not
any more.

According to Christoph, the current writeback size is way too small,
and XFS had a hack that bumped out nr_to_write to four times the value
sent by the VM to be able to saturate medium-sized RAID arrays.  This
value was also problematic for ext4 as well, as it caused large files
to be come interleaved on disk by in 8 megabyte chunks (we bumped up
the nr_to_write by a factor of two).

So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable,
max_writeback_mb, and set it to a default value of 128 megabytes.

http://bugzilla.kernel.org/show_bug.cgi?id=13930

CC: Theodore Ts'o <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/writeback.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- linux.orig/include/linux/writeback.h	2009-09-09 21:51:54.000000000 +0800
+++ linux/include/linux/writeback.h	2009-09-09 21:51:58.000000000 +0800
@@ -14,14 +14,13 @@ extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
+ * The maximum number of pages to writeout in a single periodic/background
+ * writeback operation. 64MB means I_SYNC may be hold for up to 1 second.
+ * This is not a big problem since we normally do kind of trylock on I_SYNC
+ * for non-data-integrity writes.  Userspace tasks doing throttled writeback
+ * do not use this value.
  */
-#define MAX_WRITEBACK_PAGES     1024
-
+#define MAX_WRITEBACK_PAGES	(64 * 1024 * 1024 / PAGE_SIZE)
 
 /*
  * fs/fs-writeback.c

-- 

