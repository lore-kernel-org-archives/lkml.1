Return-Path: <linux-kernel-owner+w=401wt.eu-S933286AbXCUWCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbXCUWCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCUWCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:02:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24549 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278AbXCUWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:02:46 -0400
Date: Wed, 21 Mar 2007 15:01:58 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk
Subject: [PATCH 1/2] Turn do_sync_file_range() into do_sync_mapping_range()
Message-ID: <20070321220158.GH23274@ca-server1.us.oracle.com>
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

do_sync_file_range() accepts a file * from which it takes an address_space
to sync. Abstract out the bulk of the function into do_sync_mapping_range()
which takes the address_space directly. This way callers who want to sync an
address_space directly can take advantage of the functionality provided.

do_sync_file_range() is preserved as a small wrapper around
do_sync_mapping_range().

Ocfs2 in particular would like to use this to initiate a sync of a specific
inode range during truncate, where a file * may not be available.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

---

 fs/sync.c          |    8 +++-----
 include/linux/fs.h |    9 +++++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

6b5e910e89db2b796f5e52dd88b989513f706bd7
diff --git a/fs/sync.c b/fs/sync.c
index d0feff6..5cb9e7e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -239,13 +239,11 @@ out:
 /*
  * `endbyte' is inclusive
  */
-int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags)
+int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			  loff_t endbyte, unsigned int flags)
 {
 	int ret;
-	struct address_space *mapping;
 
-	mapping = file->f_mapping;
 	if (!mapping) {
 		ret = -EINVAL;
 		goto out;
@@ -275,4 +273,4 @@ int do_sync_file_range(struct file *file
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(do_sync_file_range);
+EXPORT_SYMBOL_GPL(do_sync_mapping_range);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 86ec3f4..095a9c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -843,8 +843,13 @@ extern int fcntl_setlease(unsigned int f
 extern int fcntl_getlease(struct file *filp);
 
 /* fs/sync.c */
-extern int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags);
+extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			loff_t endbyte, unsigned int flags);
+static inline int do_sync_file_range(struct file *file, loff_t offset,
+			loff_t endbyte, unsigned int flags)
+{
+	return do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
+}
 
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
-- 
1.3.3
