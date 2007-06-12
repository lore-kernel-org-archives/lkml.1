Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbXFLHEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbXFLHEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXFLHAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:42 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13577 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hugh@veritas.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 14/18] shmem: convert to using splice instead of sendfile()
Date: Tue, 12 Jun 2007 08:58:10 +0200
Message-Id: <11816314952101-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

Remove shmem_file_sendfile and resurrect shmem_readpage, as used by tmpfs
to support loop and sendfile in 2.4 and 2.5.  Now tmpfs can support splice,
loop and sendfile in the simplest way, using generic_file_splice_read and
generic_file_splice_write (with the aid of shmem_prepare_write).

We could make some efficiency tweaks later, if there's a real need;
but this is stable and works well as is.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/shmem.c |   42 +++++++++++++++++-------------------------
 1 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b6aae2b..0493e4d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1100,9 +1100,9 @@ static int shmem_getpage(struct inode *inode, unsigned long idx,
 	 * Normally, filepage is NULL on entry, and either found
 	 * uptodate immediately, or allocated and zeroed, or read
 	 * in under swappage, which is then assigned to filepage.
-	 * But shmem_prepare_write passes in a locked filepage,
-	 * which may be found not uptodate by other callers too,
-	 * and may need to be copied from the swappage read in.
+	 * But shmem_readpage and shmem_prepare_write pass in a locked
+	 * filepage, which may be found not uptodate by other callers
+	 * too, and may need to be copied from the swappage read in.
 	 */
 repeat:
 	if (!filepage)
@@ -1485,9 +1485,18 @@ static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_symlink_inline_operations;
 
 /*
- * Normally tmpfs makes no use of shmem_prepare_write, but it
- * lets a tmpfs file be used read-write below the loop driver.
+ * Normally tmpfs avoids the use of shmem_readpage and shmem_prepare_write;
+ * but providing them allows a tmpfs file to be used for splice, sendfile, and
+ * below the loop driver, in the generic fashion that many filesystems support.
  */
+static int shmem_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	int error = shmem_getpage(inode, page->index, &page, SGP_CACHE, NULL);
+	unlock_page(page);
+	return error;
+}
+
 static int
 shmem_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
 {
@@ -1711,25 +1720,6 @@ static ssize_t shmem_file_read(struct file *filp, char __user *buf, size_t count
 	return desc.error;
 }
 
-static ssize_t shmem_file_sendfile(struct file *in_file, loff_t *ppos,
-			 size_t count, read_actor_t actor, void *target)
-{
-	read_descriptor_t desc;
-
-	if (!count)
-		return 0;
-
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.data = target;
-	desc.error = 0;
-
-	do_shmem_file_read(in_file, ppos, &desc, actor);
-	if (desc.written)
-		return desc.written;
-	return desc.error;
-}
-
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
@@ -2386,6 +2376,7 @@ static const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
+	.readpage	= shmem_readpage,
 	.prepare_write	= shmem_prepare_write,
 	.commit_write	= simple_commit_write,
 #endif
@@ -2399,7 +2390,8 @@ static const struct file_operations shmem_file_operations = {
 	.read		= shmem_file_read,
 	.write		= shmem_file_write,
 	.fsync		= simple_sync_file,
-	.sendfile	= shmem_file_sendfile,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
 #endif
 };
 
-- 
1.5.2.1.174.gcd03

