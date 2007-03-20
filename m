Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXCTVrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXCTVrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXCTVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:47:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39466 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXCTVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:47:08 -0400
Date: Tue, 20 Mar 2007 14:46:26 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk
Subject: [PATCH] Turn do_sync_file_range() into do_sync_mapping_range()
Message-ID: <20070320214626.GC23274@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do_sync_file_range() accepts a file * from which it takes an address_space
to sync. Abstract out the bulk of the function into do_sync_mapping_range()
which takes the address_space directly. This way callers who want to sync an
address_space directly can take advantage of the functionality provided.

do_sync_file_range() is preserved as a 3 line wrapper around
do_sync_mapping_range().

Ocfs2 in particular would like to use this to initiate a sync of a specific
inode range during truncate, where a file * may not be available.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/sync.c          |   16 ++++------------
 include/linux/fs.h |   11 +++++++++--
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index d0feff6..b0675ec 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -239,19 +239,11 @@ out:
 /*
  * `endbyte' is inclusive
  */
-int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags)
+int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			  loff_t endbyte, unsigned int flags)
 {
-	int ret;
-	struct address_space *mapping;
-
-	mapping = file->f_mapping;
-	if (!mapping) {
-		ret = -EINVAL;
-		goto out;
-	}
+	int ret = 0;
 
-	ret = 0;
 	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
 		ret = wait_on_page_writeback_range(mapping,
 					offset >> PAGE_CACHE_SHIFT,
@@ -275,4 +267,4 @@ int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(do_sync_file_range);
+EXPORT_SYMBOL_GPL(do_sync_mapping_range);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1410e53..7fa4473 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -842,8 +842,15 @@ extern int fcntl_setlease(unsigned int fd, struct file *filp, long arg);
 extern int fcntl_getlease(struct file *filp);
 
 /* fs/sync.c */
-extern int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags);
+extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			loff_t endbyte, unsigned int flags);
+static inline int do_sync_file_range(struct file *file, loff_t offset,
+				     loff_t endbyte, unsigned int flags)
+{
+	if (file->f_mapping == NULL)
+		return -EINVAL;
+	return do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
+}
 
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
-- 
1.4.4.2

