Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbZERMhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbZERMhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZERMgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:36:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48881 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZERMgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:36:49 -0400
To: jens.axboe@oracle.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, max@duempel.org,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20090514180003.GU4140@kernel.dk> (message from Jens Axboe on
	Thu, 14 May 2009 20:00:03 +0200)
Subject: Re: [patch 2/3] splice: implement default splice_read method
References: <20090507133734.450612199@szeredi.hu> <20090507133748.161689790@szeredi.hu> <20090512223500.d7ef4648.akpm@linux-foundation.org> <20090513063707.GC4140@kernel.dk> <E1M4ALP-0005za-1i@pomaz-ex.szeredi.hu> <20090514172935.GR4140@kernel.dk> <E1M4f8b-0000Tb-GI@pomaz-ex.szeredi.hu> <20090514180003.GU4140@kernel.dk>
Message-Id: <E1M6254-00070d-0p@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 May 2009 14:36:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Thu, 14 May 2009, Jens Axboe wrote:
> On Thu, May 14 2009, Miklos Szeredi wrote:
> > > > Hmm.  Simple solution would be to do a write() for each buffer.  But
> > > > this only affects HIGHMEM kernels, so it's a bit pointless to do that
> > > > on all archs.  Sigh...
> > > 
> > > It is unfortunate, we are going to be stuck with that for some time
> > > still...

Here's a patch that fixes the multiple kmap() issue.  It goes on top
of the previous splice patches.

Thanks,
Miklos

----
Subject: splice: fix kmaps in default_file_splice_write()
From: Miklos Szeredi <mszeredi@suse.cz>

Unfortunately multiple kmap() within a single thread are deadlockable,
so writing out multiple buffers with writev() isn't possible.

Change the implementation so that it does a separate write() for each
buffer.  This actually simplifies the code a lot since the
splice_from_pipe() helper can be used.

This limitation is caused by HIGHMEM pages, and so only affects a
subset of architectures and configurations.  In the future it may be
worth to implement default_file_splice_write() in a more efficient way
on configs that allow it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |  130 ++++++++++--------------------------------------------------
 1 file changed, 22 insertions(+), 108 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-05-18 13:22:49.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-05-18 14:18:22.000000000 +0200
@@ -535,8 +535,8 @@ static ssize_t kernel_readv(struct file
 	return res;
 }
 
-static ssize_t kernel_writev(struct file *file, const struct iovec *vec,
-			    unsigned long vlen, loff_t *ppos)
+static ssize_t kernel_write(struct file *file, const char *buf, size_t count,
+			    loff_t pos)
 {
 	mm_segment_t old_fs;
 	ssize_t res;
@@ -544,7 +544,7 @@ static ssize_t kernel_writev(struct file
 	old_fs = get_fs();
 	set_fs(get_ds());
 	/* The cast to a user pointer is valid due to the set_fs() */
-	res = vfs_writev(file, (const struct iovec __user *)vec, vlen, ppos);
+	res = vfs_write(file, (const char __user *)buf, count, &pos);
 	set_fs(old_fs);
 
 	return res;
@@ -1003,120 +1003,34 @@ generic_file_splice_write(struct pipe_in
 
 EXPORT_SYMBOL(generic_file_splice_write);
 
-static struct pipe_buffer *nth_pipe_buf(struct pipe_inode_info *pipe, int n)
+static int write_pipe_buf(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+			  struct splice_desc *sd)
 {
-	return &pipe->bufs[(pipe->curbuf + n) % PIPE_BUFFERS];
+	int ret;
+	void *data;
+
+	ret = buf->ops->confirm(pipe, buf);
+	if (ret)
+		return ret;
+
+	data = buf->ops->map(pipe, buf, 0);
+	ret = kernel_write(sd->u.file, data + buf->offset, sd->len, sd->pos);
+	buf->ops->unmap(pipe, buf, data);
+
+	return ret;
 }
 
 static ssize_t default_file_splice_write(struct pipe_inode_info *pipe,
 					 struct file *out, loff_t *ppos,
 					 size_t len, unsigned int flags)
 {
-	ssize_t ret = 0;
-	ssize_t total_len = 0;
-	int do_wakeup = 0;
-
-	pipe_lock(pipe);
-	while (len) {
-		struct pipe_buffer *buf;
-		void *data[PIPE_BUFFERS];
-		struct iovec vec[PIPE_BUFFERS];
-		unsigned int nr_pages = 0;
-		unsigned int write_len = 0;
-		unsigned int now_len = len;
-		unsigned int this_len;
-		int i;
-
-		BUG_ON(pipe->nrbufs > PIPE_BUFFERS);
-		for (i = 0; i < pipe->nrbufs && now_len; i++) {
-			buf = nth_pipe_buf(pipe, i);
-
-			ret = buf->ops->confirm(pipe, buf);
-			if (ret)
-				break;
-
-			data[i] = buf->ops->map(pipe, buf, 0);
-			this_len = min(buf->len, now_len);
-			vec[i].iov_base = (void __user *) data[i] + buf->offset;
-			vec[i].iov_len = this_len;
-			now_len -= this_len;
-			write_len += this_len;
-			nr_pages++;
-		}
-
-		if (nr_pages) {
-			ret = kernel_writev(out, vec, nr_pages, ppos);
-			if (ret == 0)
-				ret = -EIO;
-			if (ret > 0) {
-				len -= ret;
-				total_len += ret;
-			}
-		}
-
-		for (i = 0; i < nr_pages; i++) {
-			buf = nth_pipe_buf(pipe, i);
-			buf->ops->unmap(pipe, buf, data[i]);
-
-			if (ret > 0) {
-				this_len = min_t(unsigned, vec[i].iov_len, ret);
-				buf->offset += this_len;
-				buf->len -= this_len;
-				ret -= this_len;
-			}
-		}
-
-		if (ret < 0)
-			break;
-
-		while (pipe->nrbufs) {
-			const struct pipe_buf_operations *ops;
-
-			buf = nth_pipe_buf(pipe, 0);
-			if (buf->len)
-				break;
-
-			ops = buf->ops;
-			buf->ops = NULL;
-			ops->release(pipe, buf);
-			pipe->curbuf = (pipe->curbuf + 1) % PIPE_BUFFERS;
-			pipe->nrbufs--;
-			if (pipe->inode)
-				do_wakeup = 1;
-		}
-
-		if (pipe->nrbufs)
-			continue;
-		if (!pipe->writers)
-			break;
-		if (!pipe->waiting_writers) {
-			if (total_len)
-				break;
-		}
-
-		if (flags & SPLICE_F_NONBLOCK) {
-			ret = -EAGAIN;
-			break;
-		}
-
-		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
-			break;
-		}
-
-		if (do_wakeup) {
-			wakeup_pipe_writers(pipe);
-			do_wakeup = 0;
-		}
-
-		pipe_wait(pipe);
-	}
-	pipe_unlock(pipe);
+	ssize_t ret;
 
-	if (do_wakeup)
-		wakeup_pipe_writers(pipe);
+	ret = splice_from_pipe(pipe, out, ppos, len, flags, write_pipe_buf);
+	if (ret > 0)
+		*ppos += ret;
 
-	return total_len ? total_len : ret;
+	return ret;
 }
 
 /**

