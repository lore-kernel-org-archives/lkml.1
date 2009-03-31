Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZCaKIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZCaKIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZCaKHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:07:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53095 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbZCaKHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:07:40 -0400
To: flar@allandria.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
In-reply-to: <20090330205927.GA7707@cynthia.pants.nu> (message from Brad Boyer
	on Mon, 30 Mar 2009 13:59:28 -0700)
Subject: Re: [patch 3/3] splice: implement default splice_read method
References: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu> <E1LoNie-0007m5-B4@pomaz-ex.szeredi.hu> <20090330205927.GA7707@cynthia.pants.nu>
Message-Id: <E1LoasT-0000gX-KY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 31 Mar 2009 12:07:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Brad Boyer wrote:
> Based on your description, I would have expected this patch to make
> the loop driver work seamlessly. Unless I'm misreading something, I
> think the loop driver will still error out if the fs driver in question
> doesn't explicitly set splice_read.o

You're right.  Here's an updated patch.

Thanks,
Miklos

---
From: Miklos Szeredi <mszeredi@suse.cz>

If f_op->splice_read() is not implemented fall back to a plain read.
Use vfs_readv() to read into previously allocated pages.

This will allow splice and functions using splice, such as the loop
device, to work on all filesystems.  This includes "direct_io" files
in fuse which bypass the page cache.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 drivers/block/loop.c      |   11 ----
 fs/coda/file.c            |    9 ++-
 fs/fuse/file.c            |    1 
 fs/pipe.c                 |   14 +++++
 fs/read_write.c           |    7 --
 fs/splice.c               |  120 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h        |    2 
 include/linux/pipe_fs_i.h |    1 
 8 files changed, 140 insertions(+), 25 deletions(-)

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2009-03-31 11:43:55.000000000 +0200
+++ linux-2.6/fs/pipe.c	2009-03-31 11:44:12.000000000 +0200
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
--- linux-2.6.orig/fs/splice.c	2009-03-31 11:43:55.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-03-31 11:44:12.000000000 +0200
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
--- linux-2.6.orig/include/linux/pipe_fs_i.h	2009-03-31 11:43:55.000000000 +0200
+++ linux-2.6/include/linux/pipe_fs_i.h	2009-03-31 12:04:19.000000000 +0200
@@ -147,5 +147,6 @@ void generic_pipe_buf_unmap(struct pipe_
 void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
+void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
 #endif
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-03-31 11:43:55.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-03-31 11:44:12.000000000 +0200
@@ -2126,6 +2126,8 @@ extern int generic_segment_checks(const
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
+extern ssize_t default_file_splice_read(struct file *, loff_t *,
+		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write_nolock(struct pipe_inode_info *,
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2009-03-31 11:43:55.000000000 +0200
+++ linux-2.6/drivers/block/loop.c	2009-03-31 11:44:12.000000000 +0200
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
--- linux-2.6.orig/fs/coda/file.c	2009-03-31 11:43:55.000000000 +0200
+++ linux-2.6/fs/coda/file.c	2009-03-31 11:44:12.000000000 +0200
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
Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2009-03-31 11:44:12.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2009-03-31 11:44:12.000000000 +0200
@@ -1944,7 +1944,6 @@ static const struct file_operations fuse
 	.unlocked_ioctl	= fuse_file_ioctl,
 	.compat_ioctl	= fuse_file_compat_ioctl,
 	.poll		= fuse_file_poll,
-	/* no splice_read */
 };
 
 static const struct address_space_operations fuse_file_aops  = {
Index: linux-2.6/fs/read_write.c
===================================================================
--- linux-2.6.orig/fs/read_write.c	2009-03-31 11:44:10.000000000 +0200
+++ linux-2.6/fs/read_write.c	2009-03-31 11:45:48.000000000 +0200
@@ -749,12 +749,6 @@ static ssize_t do_sendfile(int out_fd, i
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
@@ -778,6 +772,7 @@ static ssize_t do_sendfile(int out_fd, i
 	retval = -EINVAL;
 	if (!out_file->f_op || !out_file->f_op->sendpage)
 		goto fput_out;
+	in_inode = in_file->f_path.dentry->d_inode;
 	out_inode = out_file->f_path.dentry->d_inode;
 	retval = rw_verify_area(WRITE, out_file, &out_file->f_pos, count);
 	if (retval < 0)
