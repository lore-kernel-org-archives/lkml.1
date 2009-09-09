Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZIIPIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZIIPIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZIIPID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:08:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:6662 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbZIIPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185728223"
Message-Id: <20090909150601.159061863@intel.com>
References: <20090909145141.293229693@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Sep 2009 22:51:48 +0800
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
Subject: [RFC][PATCH 7/7] writeback: balance_dirty_pages() shall write more than dirtied pages
Content-Disposition: inline; filename=writeback-ratelimit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some filesystem may choose to write much more than ratelimit_pages
before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
determine number to write based on real number of dirtied pages.

The increased write_chunk may make the dirtier more bumpy.  This is
filesystem writers' duty not to dirty too much at a time without
checking the ratelimit.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-09-09 21:19:21.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-09 21:25:45.000000000 +0800
@@ -44,12 +44,12 @@ static long ratelimit_pages = 32;
 /*
  * When balance_dirty_pages decides that the caller needs to perform some
  * non-background writeback, this is how many pages it will attempt to write.
- * It should be somewhat larger than RATELIMIT_PAGES to ensure that reasonably
+ * It should be somewhat larger than dirtied pages to ensure that reasonably
  * large amounts of I/O are submitted.
  */
-static inline long sync_writeback_pages(void)
+static inline long sync_writeback_pages(unsigned long dirtied)
 {
-	return ratelimit_pages + ratelimit_pages / 2;
+	return dirtied + dirtied / 2;
 }
 
 /* The following parameters are exported via /proc/sys/vm */
@@ -476,7 +476,8 @@ get_dirty_limits(unsigned long *pbackgro
  * If we're over `background_thresh' then pdflush is woken to perform some
  * writeout.
  */
-static void balance_dirty_pages(struct address_space *mapping)
+static void balance_dirty_pages(struct address_space *mapping,
+				unsigned long write_chunk)
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
@@ -484,7 +485,6 @@ static void balance_dirty_pages(struct a
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
-	unsigned long write_chunk = sync_writeback_pages();
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
@@ -638,9 +638,10 @@ void balance_dirty_pages_ratelimited_nr(
 	p =  &__get_cpu_var(bdp_ratelimits);
 	*p += nr_pages_dirtied;
 	if (unlikely(*p >= ratelimit)) {
+		ratelimit = sync_writeback_pages(*p);
 		*p = 0;
 		preempt_enable();
-		balance_dirty_pages(mapping);
+		balance_dirty_pages(mapping, ratelimit);
 		return;
 	}
 	preempt_enable();

-- 

