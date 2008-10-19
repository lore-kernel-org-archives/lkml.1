Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbYJSOBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbYJSOBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 10:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYJSOBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 10:01:06 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:38219 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbYJSOBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 10:01:02 -0400
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitri Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] Add block device speciffic splice write method
Date: Sun, 19 Oct 2008 18:00:58 +0400
Message-Id: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block device write procedure is different from regular file:
 - Actual write performed without i_mutex.
 - It has no metadata, so generic_osync_inode(O_SYNCMETEDATA) can not livelock.
 - We do not have to worry about S_ISUID/S_ISGID bits.

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/block_dev.c     |    2 +-
 fs/splice.c        |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 3 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7ce823c..9aa63b5 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1251,7 +1251,7 @@ const struct file_operations def_blk_fops = {
 	.compat_ioctl	= compat_blkdev_ioctl,
 #endif
 	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
+	.splice_write	= blkdev_splice_write,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
diff --git a/fs/splice.c b/fs/splice.c
index a1e701c..f0ba76c 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -884,6 +884,54 @@ ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
 
 EXPORT_SYMBOL(generic_splice_sendpage);
 
+/**
+ * blkdev_splice_write - splice data from a pipe to a block device
+ * @pipe:	pipe info
+ * @out:	file to write to
+ * @ppos:	position in @out
+ * @len:	number of bytes to splice
+ * @flags:	splice modifier flags
+ *
+ * Description:
+ *    Will either move or copy pages (determined by @flags options) from
+ *    the given pipe inode to the given block device.
+ *    Note: blockdev's i_mutex is not held on entry and it is never taken.
+ */
+ssize_t
+blkdev_splice_write(struct pipe_inode_info *pipe, struct file *out,
+				loff_t *ppos, size_t len, unsigned int flags)
+{
+	struct address_space *mapping = out->f_mapping;
+	struct inode *inode = mapping->host;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+		.u.file = out,
+	};
+	ssize_t ret;
+	unsigned long nr_pages;
+	mutex_lock(&pipe->inode->i_mutex);
+	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
+	mutex_unlock(&pipe->inode->i_mutex);
+	if (ret <= 0)
+		return ret;
+
+	*ppos += ret;
+	nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+	if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
+		int err;
+		err = sync_page_range_nolock(inode, mapping, *ppos, ret);
+		if (err)
+			ret = err;
+	}
+	balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
+	return ret;
+}
+
+EXPORT_SYMBOL(blkdev_splice_write);
+
 /*
  * Attempt to initiate a splice from pipe to file.
  */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 194b607..8543b21 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1960,6 +1960,8 @@ extern ssize_t generic_file_splice_write_nolock(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
+extern ssize_t blkdev_splice_write(struct pipe_inode_info *pipe,
+		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		size_t len, unsigned int flags);
 
-- 
1.5.4.3

