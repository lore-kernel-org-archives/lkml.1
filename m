Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbZEGNjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbZEGNjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZEGNiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:38:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42563 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbZEGNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:38:08 -0400
Message-Id: <20090507133748.161689790@szeredi.hu>
References: <20090507133734.450612199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 07 May 2009 15:37:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: Max Kellermann <max@duempel.org>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/3] splice: implement default splice_read method
Content-Disposition: inline; filename=splice_read_fallback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If f_op->splice_read() is not implemented, fall back to a plain read.
Use vfs_readv() to read into previously allocated pages.

This will allow splice and functions using splice, such as the loop
device, to work on all filesystems.  This includes "direct_io" files
in fuse which bypass the page cache.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 drivers/block/loop.c      |   11 ----
 fs/coda/file.c            |    9 ++-
 fs/pipe.c                 |   14 +++++
 fs/read_write.c           |    7 --
 fs/splice.c               |  120 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h        |    2 
 include/linux/pipe_fs_i.h |    1 
 7 files changed, 140 insertions(+), 24 deletions(-)

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2009-05-07 14:40:01.000000000 +0200
+++ linux-2.6/fs/pipe.c	2009-05-07 14:40:06.000000000 +0200
@@ -302,6 +302,20 @@ int generic_pipe_buf_confirm(struct pipe
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
--- linux-2.6.orig/fs/splice.c	2009-05-07 14:40:06.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-05-07 14:40:06.000000000 +0200
@@ -507,9 +507,116 @@ ssize_t generic_file_splice_read(struct
 
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
@@ -933,11 +1040,10 @@ static long do_splice_to(struct file *in
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
 
@@ -945,7 +1051,11 @@ static long do_splice_to(struct file *in
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
--- linux-2.6.orig/include/linux/pipe_fs_i.h	2009-05-07 14:40:01.000000000 +0200
+++ linux-2.6/include/linux/pipe_fs_i.h	2009-05-07 14:40:06.000000000 +0200
@@ -152,5 +152,6 @@ void generic_pipe_buf_unmap(struct pipe_
 void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
+void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
 #endif
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-05-07 14:40:01.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-05-07 14:40:06.000000000 +0200
@@ -2204,6 +2204,8 @@ extern int generic_segment_checks(const
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
+extern ssize_t default_file_splice_read(struct file *, loff_t *,
+		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2009-05-07 14:40:01.000000000 +0200
+++ linux-2.6/drivers/block/loop.c	2009-05-07 14:40:06.000000000 +0200
@@ -721,10 +721,6 @@ static int loop_change_fd(struct loop_de
 	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
 		goto out_putf;
 
-	/* new backing store needs to support loop (eg splice_read) */
-	if (!inode->i_fop->splice_read)
-		goto out_putf;
-
 	/* size of the new backing store needs to be the same */
 	if (get_loop_size(lo, file) != get_loop_size(lo, old_file))
 		goto out_putf;
@@ -800,12 +796,7 @@ static int loop_set_fd(struct loop_devic
 	error = -EINVAL;
 	if (S_ISREG(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		const struct address_space_operations *aops = mapping->a_ops;
-		/*
-		 * If we can't read - sorry. If we only can't write - well,
-		 * it's going to be read-only.
-		 */
-		if (!file->f_op->splice_read)
-			goto out_putf;
+
 		if (aops->write_begin)
 			lo_flags |= LO_FLAGS_USE_AOPS;
 		if (!(lo_flags & LO_FLAGS_USE_AOPS) && !file->f_op->write)
Index: linux-2.6/fs/coda/file.c
===================================================================
--- linux-2.6.orig/fs/coda/file.c	2009-05-07 14:40:01.000000000 +0200
+++ linux-2.6/fs/coda/file.c	2009-05-07 14:40:06.000000000 +0200
@@ -47,6 +47,8 @@ coda_file_splice_read(struct file *coda_
 		      struct pipe_inode_info *pipe, size_t count,
 		      unsigned int flags)
 {
+	ssize_t (*splice_read)(struct file *, loff_t *,
+			       struct pipe_inode_info *, size_t, unsigned int);
 	struct coda_file_info *cfi;
 	struct file *host_file;
 
@@ -54,10 +56,11 @@ coda_file_splice_read(struct file *coda_
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 	host_file = cfi->cfi_container;
 
-	if (!host_file->f_op || !host_file->f_op->splice_read)
-		return -EINVAL;
+	splice_read = host_file->f_op->splice_read;
+	if (!splice_read)
+		splice_read = default_file_splice_read;
 
-	return host_file->f_op->splice_read(host_file, ppos, pipe, count,flags);
+	return splice_read(host_file, ppos, pipe, count, flags);
 }
 
 static ssize_t
Index: linux-2.6/fs/read_write.c
===================================================================
--- linux-2.6.orig/fs/read_write.c	2009-05-07 14:40:01.000000000 +0200
+++ linux-2.6/fs/read_write.c	2009-05-07 14:40:06.000000000 +0200
@@ -805,12 +805,6 @@ static ssize_t do_sendfile(int out_fd, i
 		goto out;
 	if (!(in_file->f_mode & FMODE_READ))
 		goto fput_in;
-	retval = -EINVAL;
-	in_inode = in_file->f_path.dentry->d_inode;
-	if (!in_inode)
-		goto fput_in;
-	if (!in_file->f_op || !in_file->f_op->splice_read)
-		goto fput_in;
 	retval = -ESPIPE;
 	if (!ppos)
 		ppos = &in_file->f_pos;
@@ -834,6 +828,7 @@ static ssize_t do_sendfile(int out_fd, i
 	retval = -EINVAL;
 	if (!out_file->f_op || !out_file->f_op->sendpage)
 		goto fput_out;
+	in_inode = in_file->f_path.dentry->d_inode;
 	out_inode = out_file->f_path.dentry->d_inode;
 	retval = rw_verify_area(WRITE, out_file, &out_file->f_pos, count);
 	if (retval < 0)

--
