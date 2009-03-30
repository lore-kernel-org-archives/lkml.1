Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbZC3UEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbZC3UEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZC3UEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:04:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38067 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbZC3UEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:04:30 -0400
To: linux-fsdevel@vger.kernel.org
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-reply-to: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 30 Mar 2009 22:00:37 +0200)
Subject: [patch 3/3] splice: implement default splice_read method
References: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu>
Message-Id: <E1LoNie-0007m5-B4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Mar 2009 22:04:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If f_op->splice_read() is not implemented fall back to a plain read.
Use vfs_readv() to read into previously allocated pages.

This will allow splice and functions using splice, such as the loop
device, to work on all filesystems.  This includes "direct_io" files
in fuse which bypass the page cache.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/pipe.c                 |   14 +++++
 fs/splice.c               |  120 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h        |    2 
 include/linux/pipe_fs_i.h |    2 
 4 files changed, 133 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2009-03-30 21:11:58.000000000 +0200
+++ linux-2.6/fs/pipe.c	2009-03-30 21:22:06.000000000 +0200
@@ -268,6 +268,20 @@ int generic_pipe_buf_confirm(struct pipe
 	return 0;
 }
 
+/**
+ * generic_pipe_buf_release - put a reference to a &struct pipe_buffer
+ * @pipe:	the pipe that the buffer belongs to
+ * @buf:	the buffer to put a reference to
+ *
+ * Description:
+ *	This function releases a reference to @buf.
+ */
+void generic_pipe_buf_release(struct pipe_inode_info *pipe,
+			      struct pipe_buffer *buf)
+{
+	page_cache_release(buf->page);
+}
+
 static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.can_merge = 1,
 	.map = generic_pipe_buf_map,
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-03-30 21:11:58.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-03-30 21:22:06.000000000 +0200
@@ -509,9 +509,116 @@ ssize_t generic_file_splice_read(struct
 
 	return ret;
 }
-
 EXPORT_SYMBOL(generic_file_splice_read);
 
+static const struct pipe_buf_operations default_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = generic_pipe_buf_release,
+	.steal = generic_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
+static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
+			    unsigned long vlen, loff_t offset)
+{
+	mm_segment_t old_fs;
+	loff_t pos = offset;
+	ssize_t res;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	/* The cast to a user pointer is valid due to the set_fs() */
+	res = vfs_readv(file, (const struct iovec __user *)vec, vlen, &pos);
+	set_fs(old_fs);
+
+	return res;
+}
+
+ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
+				 struct pipe_inode_info *pipe, size_t len,
+				 unsigned int flags)
+{
+	unsigned int nr_pages;
+	unsigned int nr_freed;
+	size_t offset;
+	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial[PIPE_BUFFERS];
+	struct iovec vec[PIPE_BUFFERS];
+	pgoff_t index;
+	ssize_t res;
+	size_t this_len;
+	int error;
+	int i;
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.partial = partial,
+		.flags = flags,
+		.ops = &default_pipe_buf_ops,
+		.spd_release = spd_release_page,
+	};
+
+	index = *ppos >> PAGE_CACHE_SHIFT;
+	offset = *ppos & ~PAGE_CACHE_MASK;
+	nr_pages = (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+	for (i = 0; i < nr_pages && i < PIPE_BUFFERS && len; i++) {
+		struct page *page;
+
+		page = alloc_page(GFP_HIGHUSER);
+		error = -ENOMEM;
+		if (!page)
+			goto err;
+
+		this_len = min_t(size_t, len, PAGE_CACHE_SIZE - offset);
+		vec[i].iov_base = (void __user *) kmap(page);
+		vec[i].iov_len = this_len;
+		pages[i] = page;
+		spd.nr_pages++;
+		len -= this_len;
+		offset = 0;
+	}
+
+	res = kernel_readv(in, vec, spd.nr_pages, *ppos);
+	if (res < 0)
+		goto err;
+
+	error = 0;
+	if (!res)
+		goto err;
+
+	nr_freed = 0;
+	for (i = 0; i < spd.nr_pages; i++) {
+		kunmap(pages[i]);
+		this_len = min_t(size_t, vec[i].iov_len, res);
+		partial[i].offset = 0;
+		partial[i].len = this_len;
+		if (!this_len) {
+			__free_page(pages[i]);
+			pages[i] = NULL;
+			nr_freed++;
+		}
+		res -= this_len;
+	}
+	spd.nr_pages -= nr_freed;
+
+	res = splice_to_pipe(pipe, &spd);
+	if (res > 0)
+		*ppos += res;
+
+	return res;
+
+err:
+	for (i = 0; i < spd.nr_pages; i++) {
+		kunmap(pages[i]);
+		__free_page(pages[i]);
+	}
+	return error;
+}
+EXPORT_SYMBOL(default_file_splice_read);
+
 /*
  * Send 'sd->len' bytes to socket from 'sd->file' at position 'sd->pos'
  * using sendpage(). Return the number of bytes sent.
@@ -916,11 +1023,10 @@ static long do_splice_to(struct file *in
 			 struct pipe_inode_info *pipe, size_t len,
 			 unsigned int flags)
 {
+	ssize_t (*splice_read)(struct file *, loff_t *,
+			       struct pipe_inode_info *, size_t, unsigned int);
 	int ret;
 
-	if (unlikely(!in->f_op || !in->f_op->splice_read))
-		return -EINVAL;
-
 	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
 
@@ -928,7 +1034,11 @@ static long do_splice_to(struct file *in
 	if (unlikely(ret < 0))
 		return ret;
 
-	return in->f_op->splice_read(in, ppos, pipe, len, flags);
+	splice_read = in->f_op->splice_read;
+	if (!splice_read)
+		splice_read = default_file_splice_read;
+
+	return splice_read(in, ppos, pipe, len, flags);
 }
 
 /**
Index: linux-2.6/include/linux/pipe_fs_i.h
===================================================================
--- linux-2.6.orig/include/linux/pipe_fs_i.h	2009-03-30 21:11:58.000000000 +0200
+++ linux-2.6/include/linux/pipe_fs_i.h	2009-03-30 21:22:06.000000000 +0200
@@ -147,5 +147,7 @@ void generic_pipe_buf_unmap(struct pipe_
 void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
+void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
+
 
 #endif
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-03-30 21:13:11.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-03-30 21:22:06.000000000 +0200
@@ -2126,6 +2126,8 @@ extern int generic_segment_checks(const
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
+extern ssize_t default_file_splice_read(struct file *, loff_t *,
+		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write_nolock(struct pipe_inode_info *,
