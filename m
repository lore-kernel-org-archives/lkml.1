Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZIXOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZIXOkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZIXOkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:40:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44115 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbZIXOkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:35 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 02/10] writeback: balance_dirty_pages() shall write more than dirtied pages
Date: Thu, 24 Sep 2009 16:40:28 +0200
Message-Id: <1253803236-20760-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

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
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/page-writeback.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5f378dd..cbd4cba 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
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
@@ -477,7 +480,8 @@ get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
  * If we're over `background_thresh' then pdflush is woken to perform some
  * writeout.
  */
-static void balance_dirty_pages(struct address_space *mapping)
+static void balance_dirty_pages(struct address_space *mapping,
+				unsigned long write_chunk)
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
@@ -485,7 +489,6 @@ static void balance_dirty_pages(struct address_space *mapping)
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
-	unsigned long write_chunk = sync_writeback_pages();
 	unsigned long pause = 1;
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
@@ -640,9 +643,10 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
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
1.6.4.1.207.g68ea

