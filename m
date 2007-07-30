Return-Path: <linux-kernel-owner+w=401wt.eu-S938715AbXG3QPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938715AbXG3QPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937900AbXG3QOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:15 -0400
Received: from mail.suse.de ([195.135.220.2]:40548 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764588AbXG3QOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:05 -0400
Message-Id: <20070730161323.232923812@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:24 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 01/26] [PATCH 14/18] shmem: convert to using splice instead of sendfile()
Content-Disposition: inline; filename=um/shmem-convert-to-splice.diff
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
 mm/shmem.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1109,8 +1109,8 @@ static int shmem_getpage(struct inode *i
 	 * Normally, filepage is NULL on entry, and either found
 	 * uptodate immediately, or allocated and zeroed, or read
 	 * in under swappage, which is then assigned to filepage.
-	 * But shmem_write_begin passes in a locked filepage,
-	 * which may be found not uptodate by other callers too,
+	 * But shmem_readpage and shmem_write_begin passes in a locked
+	 * filepage, which may be found not uptodate by other callers too,
 	 * and may need to be copied from the swappage read in.
 	 */
 repeat:
@@ -1454,9 +1454,18 @@ static const struct inode_operations shm
 static const struct inode_operations shmem_symlink_inline_operations;
 
 /*
- * Normally tmpfs makes no use of shmem_write_begin, but it
- * lets a tmpfs file be used read-write below the loop driver.
+ * Normally tmpfs avoids the use of shmem_readpage and shmem_write_begin;
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
 shmem_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
@@ -1701,25 +1710,6 @@ static ssize_t shmem_file_read(struct fi
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
@@ -2376,6 +2366,7 @@ static const struct address_space_operat
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
+	.readpage	= shmem_readpage,
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
 #endif
@@ -2389,7 +2380,8 @@ static const struct file_operations shme
 	.read		= shmem_file_read,
 	.write		= shmem_file_write,
 	.fsync		= simple_sync_file,
-	.sendfile	= shmem_file_sendfile,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
 #endif
 };
 

-- 

