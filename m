Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZEGNio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZEGNio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZEGNiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:38:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42564 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZEGNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:38:08 -0400
Message-Id: <20090507133749.811492705@szeredi.hu>
References: <20090507133734.450612199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 07 May 2009 15:37:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com
Cc: Max Kellermann <max@duempel.org>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/3] splice: implement default splice_write method
Content-Disposition: inline; filename=splice_write_fallback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If f_op->splice_write() is not implemented, fall back to a plain write.
Use vfs_writev() to write from the pipe buffers.

This will allow splice on all filesystems and file types.  This
includes "direct_io" files in fuse which bypass the page cache.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |  142 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 138 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-05-07 14:40:06.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-05-07 14:40:07.000000000 +0200
@@ -535,6 +535,21 @@ static ssize_t kernel_readv(struct file
 	return res;
 }
 
+static ssize_t kernel_writev(struct file *file, const struct iovec *vec,
+			    unsigned long vlen, loff_t *ppos)
+{
+	mm_segment_t old_fs;
+	ssize_t res;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	/* The cast to a user pointer is valid due to the set_fs() */
+	res = vfs_writev(file, (const struct iovec __user *)vec, vlen, ppos);
+	set_fs(old_fs);
+
+	return res;
+}
+
 ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
@@ -988,6 +1003,122 @@ generic_file_splice_write(struct pipe_in
 
 EXPORT_SYMBOL(generic_file_splice_write);
 
+static struct pipe_buffer *nth_pipe_buf(struct pipe_inode_info *pipe, int n)
+{
+	return &pipe->bufs[(pipe->curbuf + n) % PIPE_BUFFERS];
+}
+
+static ssize_t default_file_splice_write(struct pipe_inode_info *pipe,
+					 struct file *out, loff_t *ppos,
+					 size_t len, unsigned int flags)
+{
+	ssize_t ret = 0;
+	ssize_t total_len = 0;
+	int do_wakeup = 0;
+
+	pipe_lock(pipe);
+	while (len) {
+		struct pipe_buffer *buf;
+		void *data[PIPE_BUFFERS];
+		struct iovec vec[PIPE_BUFFERS];
+		unsigned int nr_pages = 0;
+		unsigned int write_len = 0;
+		unsigned int now_len = len;
+		unsigned int this_len;
+		int i;
+
+		BUG_ON(pipe->nrbufs > PIPE_BUFFERS);
+		for (i = 0; i < pipe->nrbufs && now_len; i++) {
+			buf = nth_pipe_buf(pipe, i);
+
+			ret = buf->ops->confirm(pipe, buf);
+			if (ret)
+				break;
+
+			data[i] = buf->ops->map(pipe, buf, 0);
+			this_len = min(buf->len, now_len);
+			vec[i].iov_base = (void __user *) data[i] + buf->offset;
+			vec[i].iov_len = this_len;
+			now_len -= this_len;
+			write_len += this_len;
+			nr_pages++;
+		}
+
+		if (nr_pages) {
+			ret = kernel_writev(out, vec, nr_pages, ppos);
+			if (ret == 0)
+				ret = -EIO;
+			if (ret > 0) {
+				len -= ret;
+				total_len += ret;
+			}
+		}
+
+		for (i = 0; i < nr_pages; i++) {
+			buf = nth_pipe_buf(pipe, i);
+			buf->ops->unmap(pipe, buf, data[i]);
+
+			if (ret > 0) {
+				this_len = min_t(unsigned, vec[i].iov_len, ret);
+				buf->offset += this_len;
+				buf->len -= this_len;
+				ret -= this_len;
+			}
+		}
+
+		if (ret < 0)
+			break;
+
+		while (pipe->nrbufs) {
+			const struct pipe_buf_operations *ops;
+
+			buf = nth_pipe_buf(pipe, 0);
+			if (buf->len)
+				break;
+
+			ops = buf->ops;
+			buf->ops = NULL;
+			ops->release(pipe, buf);
+			pipe->curbuf = (pipe->curbuf + 1) % PIPE_BUFFERS;
+			pipe->nrbufs--;
+			if (pipe->inode)
+				do_wakeup = 1;
+		}
+
+		if (pipe->nrbufs)
+			continue;
+		if (!pipe->writers)
+			break;
+		if (!pipe->waiting_writers) {
+			if (total_len)
+				break;
+		}
+
+		if (flags & SPLICE_F_NONBLOCK) {
+			ret = -EAGAIN;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (do_wakeup) {
+			wakeup_pipe_writers(pipe);
+			do_wakeup = 0;
+		}
+
+		pipe_wait(pipe);
+	}
+	pipe_unlock(pipe);
+
+	if (do_wakeup)
+		wakeup_pipe_writers(pipe);
+
+	return total_len ? total_len : ret;
+}
+
 /**
  * generic_splice_sendpage - splice data from a pipe to a socket
  * @pipe:	pipe to splice from
@@ -1015,11 +1146,10 @@ EXPORT_SYMBOL(generic_splice_sendpage);
 static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 			   loff_t *ppos, size_t len, unsigned int flags)
 {
+	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *,
+				loff_t *, size_t, unsigned int);
 	int ret;
 
-	if (unlikely(!out->f_op || !out->f_op->splice_write))
-		return -EINVAL;
-
 	if (unlikely(!(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
@@ -1030,7 +1160,11 @@ static long do_splice_from(struct pipe_i
 	if (unlikely(ret < 0))
 		return ret;
 
-	return out->f_op->splice_write(pipe, out, ppos, len, flags);
+	splice_write = out->f_op->splice_write;
+	if (!splice_write)
+		splice_write = default_file_splice_write;
+
+	return splice_write(pipe, out, ppos, len, flags);
 }
 
 /*

--
