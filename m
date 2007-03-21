Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXCUWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXCUWCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCUWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:02:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24555 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847AbXCUWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:02:46 -0400
Date: Wed, 21 Mar 2007 15:02:07 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk
Subject: [PATCH 2/2] Remove do_sync_file_range()
Message-ID: <20070321220207.GI23274@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove do_sync_file_range() and convert callers to just use
do_sync_mapping_range().

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

---

 drivers/md/bitmap.c |    8 ++++----
 fs/sync.c           |    2 +-
 include/linux/fs.h  |    5 -----
 mm/filemap.c        |    8 ++++----
 4 files changed, 9 insertions(+), 14 deletions(-)

19e0a73af3081eb606b648bb7065be4bd0c5e6ab
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5554ada..aa5b0ef 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1458,10 +1458,10 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->offset = mddev->bitmap_offset;
 	if (file) {
 		get_file(file);
-		do_sync_file_range(file, 0, LLONG_MAX,
-				   SYNC_FILE_RANGE_WAIT_BEFORE |
-				   SYNC_FILE_RANGE_WRITE |
-				   SYNC_FILE_RANGE_WAIT_AFTER);
+		do_sync_mapping_range(file->f_mapping, 0, LLONG_MAX,
+				      SYNC_FILE_RANGE_WAIT_BEFORE |
+				      SYNC_FILE_RANGE_WRITE |
+				      SYNC_FILE_RANGE_WAIT_AFTER);
 	}
 	/* read superblock from bitmap file (this sets bitmap->chunksize) */
 	err = bitmap_read_sb(bitmap);
diff --git a/fs/sync.c b/fs/sync.c
index 5cb9e7e..2f97576 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -229,7 +229,7 @@ asmlinkage long sys_sync_file_range(int 
 			!S_ISLNK(i_mode))
 		goto out_put;
 
-	ret = do_sync_file_range(file, offset, endbyte, flags);
+	ret = do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
 out_put:
 	fput_light(file, fput_needed);
 out:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 095a9c9..b0c58a6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -845,11 +845,6 @@ extern int fcntl_getlease(struct file *f
 /* fs/sync.c */
 extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
 			loff_t endbyte, unsigned int flags);
-static inline int do_sync_file_range(struct file *file, loff_t offset,
-			loff_t endbyte, unsigned int flags)
-{
-	return do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
-}
 
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 5dfc093..e232056 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2294,10 +2294,10 @@ __generic_file_aio_write_nolock(struct k
 		 * semantics.
 		 */
 		endbyte = pos + written_buffered - written - 1;
-		err = do_sync_file_range(file, pos, endbyte,
-					 SYNC_FILE_RANGE_WAIT_BEFORE|
-					 SYNC_FILE_RANGE_WRITE|
-					 SYNC_FILE_RANGE_WAIT_AFTER);
+		err = do_sync_mapping_range(file->f_mapping, pos, endbyte,
+					    SYNC_FILE_RANGE_WAIT_BEFORE|
+					    SYNC_FILE_RANGE_WRITE|
+					    SYNC_FILE_RANGE_WAIT_AFTER);
 		if (err == 0) {
 			written = written_buffered;
 			invalidate_mapping_pages(mapping,
-- 
1.3.3
