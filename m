Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbZIWN4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbZIWN4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZIWN4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:56:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:46037 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZIWN4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:56:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190759069"
Date: Wed, 23 Sep 2009 21:56:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6 -v2] writeback: balance_dirty_pages() shall write more
	than dirtied pages
Message-ID: <20090923135600.GA11463@localhost>
References: <20090923123337.990689487@intel.com> <20090923124027.456325340@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923124027.456325340@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some filesystem may choose to write much more than ratelimit_pages
before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
determine number to write based on real number of dirtied pages.

Otherwise it is possible that
  loop {
    btrfs_file_write():     dirty 1024 pages
    balance_dirty_pages():  write up to 48 pages (= ratelimit_pages * 1.5)
  }
in which the writeback rate cannot keep up with dirty rate, and the
dirty pages go all the way beyond dirty_thresh.

The increased write_chunk may make the dirtier more bumpy.
So filesystems shall be take care not to dirty too much at
a time (eg. > 4MB) without checking the ratelimit.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-09-23 21:41:21.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-23 21:42:17.000000000 +0800
@@ -44,12 +44,15 @@ static long ratelimit_pages = 32;
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
+	if (dirtied < ratelimit_pages)
+		dirtied = ratelimit_pages;
+
+	return dirtied + dirtied / 2;
 }
 
 /* The following parameters are exported via /proc/sys/vm */
@@ -476,7 +479,8 @@ get_dirty_limits(unsigned long *pbackgro
  * If we're over `background_thresh' then pdflush is woken to perform some
  * writeout.
  */
-static void balance_dirty_pages(struct address_space *mapping)
+static void balance_dirty_pages(struct address_space *mapping,
+				unsigned long write_chunk)
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
@@ -484,7 +488,6 @@ static void balance_dirty_pages(struct a
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
-	unsigned long write_chunk = sync_writeback_pages();
 	unsigned long pause = 1;
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
@@ -639,9 +642,10 @@ void balance_dirty_pages_ratelimited_nr(
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
