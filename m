Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZIYWMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZIYWMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZIYWMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:12:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41227 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbZIYWMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:12:43 -0400
Date: Sat, 26 Sep 2009 00:12:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] single writeback fixup
Message-ID: <20090925221246.GU23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The last commit in the series caused all inodes on all super_blocks to
be written out from writeback_inodes_sb() (potentially at least), this
single commit fixes that up again. Please pull!

  git://git.kernel.dk/linux-2.6-block.git writeback

Jens Axboe (1):
      writeback: pass in super_block to bdi_start_writeback()

 fs/fs-writeback.c           |    6 ++++--
 include/linux/backing-dev.h |    3 ++-
 mm/page-writeback.c         |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fb61178..9d5360c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -250,9 +250,11 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
  *   completion. Caller need not hold sb s_umount semaphore.
  *
  */
-void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
+void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+			 long nr_pages)
 {
 	struct wb_writeback_args args = {
+		.sb		= sb,
 		.sync_mode	= WB_SYNC_NONE,
 		.nr_pages	= nr_pages,
 		.range_cyclic	= 1,
@@ -1206,7 +1208,7 @@ void writeback_inodes_sb(struct super_block *sb)
 	nr_to_write = nr_dirty + nr_unstable +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 
-	bdi_start_writeback(sb->s_bdi, nr_to_write);
+	bdi_start_writeback(sb->s_bdi, sb, nr_to_write);
 }
 EXPORT_SYMBOL(writeback_inodes_sb);
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 0ee33c2..b449e73 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -101,7 +101,8 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
-void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages);
+void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+				long nr_pages);
 int bdi_writeback_task(struct bdi_writeback *wb);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 69b5fba..a3b1409 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -596,7 +596,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 	    (!laptop_mode && ((global_page_state(NR_FILE_DIRTY)
 			       + global_page_state(NR_UNSTABLE_NFS))
 					  > background_thresh)))
-		bdi_start_writeback(bdi, 0);
+		bdi_start_writeback(bdi, NULL, 0);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)


-- 
Jens Axboe

