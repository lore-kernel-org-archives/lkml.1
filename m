Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbXB0XSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbXB0XSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXB0XSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:18:45 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:51161 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXB0XSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:20 -0500
Message-Id: <20070227231744.371044552@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:15:04 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 22/22] fuse: allow big write requests
Content-Disposition: inline; filename=fuse_bigwrite.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Up to now, file writes were split into page size WRITE requests.  This
is inefficient, since there are two context switches per request.

So allow bigger writes, but still do it synchronously.  Asynchronous
writeback would be even better, but is very difficult, because of the
way file attributes are handled in fuse.

Pages to be written back are collected in a per-file request.  When no
more pages fit in the request or the size of the write would exceed
the maximum write count, send the request and start a new.  The write,
and hence the per-file request is protected by i_mutex.

Pages are not dirtied, but changed to write-back state immediately.
If page is already being written back, then wait for writeback to
finish.

Change s_blocksize and s_blocksize_bits to the number of bytes that
fit in a single write request, so that userspace tools utilize the big
write requests.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-02-27 20:45:07.000000000 +0100
+++ linux/fs/fuse/file.c	2007-02-27 21:58:06.000000000 +0100
@@ -56,6 +56,7 @@ struct fuse_file *fuse_file_alloc(void)
 		}
 		INIT_LIST_HEAD(&ff->write_entry);
 		atomic_set(&ff->count, 0);
+		ff->write_req = NULL;
 	}
 	return ff;
 }
@@ -91,6 +92,12 @@ void fuse_finish_open(struct inode *inod
 		invalidate_inode_pages2(inode->i_mapping);
 	ff->fh = outarg->fh;
 	file->private_data = fuse_file_get(ff);
+	/*
+	 * Writes are synchronous anyway, and the page syncing in
+	 * generic_file_aio_write_nolock() interferes with our special
+	 * batched write thingy
+	 */
+	file->f_flags &= ~O_SYNC;
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, int isdir)
@@ -486,44 +493,135 @@ static int fuse_prepare_write(struct fil
 	return 0;
 }
 
+static int fuse_send_write_chunk(struct fuse_file *ff, struct inode *inode)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req *req = ff->write_req;
+	struct fuse_write_in *inarg = &req->misc.write.in;
+	struct fuse_write_out *outarg = &req->misc.write.out;
+	loff_t pos = inarg->offset + inarg->size;
+	int err;
+	int i;
+
+	req->in.args[1].size = inarg->size;
+	request_send(fc, req);
+	err = req->out.h.error;
+	if (!err && outarg->size != inarg->size)
+		err = -EIO;
+	for (i = 0; i < req->num_pages; i++) {
+		struct page *page = req->pages[i];
+		if (err)
+			ClearPageUptodate(page);
+		end_page_writeback(page);
+	}
+	fuse_put_request(fc, req);
+	ff->write_req = NULL;
+	if (!err) {
+		spin_lock(&fc->lock);
+		if (pos > inode->i_size)
+			i_size_write(inode, pos);
+		spin_unlock(&fc->lock);
+	}
+	fuse_invalidate_attr(inode);
+	return err;
+}
+
+static int fuse_alloc_write_chunk(struct fuse_file *ff, struct inode *inode,
+				  struct page *page, unsigned offset)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req *req = fuse_get_req(fc);
+	if (IS_ERR(req)) {
+		ClearPageUptodate(page);
+		return PTR_ERR(req);
+	}
+	fuse_write_fill(req, ff, inode, page_offset(page) + offset, 0, 0);
+	req->page_offset = offset;
+	ff->write_req = req;
+	return 0;
+}
+
+/*
+ * Fuse wants synchronous, interruptible writes, so this is slightly
+ * unconventional.
+ *
+ * Instead of just dirtying pages, they are accumulated in
+ * ff->write_req, in WriteBack state.  When the request is full or the
+ * number of bytes exceeds max_write, then the request is sent and a
+ * new one is started.
+ */
 static int fuse_commit_write(struct file *file, struct page *page,
 			     unsigned offset, unsigned to)
 {
 	int err;
-	size_t nres;
 	unsigned count = to - offset;
 	struct inode *inode = page->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	loff_t pos = page_offset(page) + offset;
-	struct fuse_req *req;
+	struct fuse_file *ff = file->private_data;
+	struct fuse_req *req = ff->write_req;
 
 	if (is_bad_inode(inode))
 		return -EIO;
 
-	req = fuse_get_req(fc);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	BUG_ON(!count);
+	if (req) {
+		struct fuse_write_in *inarg = &req->misc.write.in;
+
+		/* Writes are always contiguous */
+		BUG_ON(inarg->offset+inarg->size != page_offset(page)+offset);
+
+		if ((!offset && req->num_pages == FUSE_MAX_PAGES_PER_REQ) ||
+		    inarg->size + count > fc->max_write) {
+			err = fuse_send_write_chunk(ff, inode);
+			if (err)
+				return err;
+		}
+	}
+	if (!ff->write_req) {
+		err = fuse_alloc_write_chunk(ff, inode, page, offset);
+		if (err)
+			return err;
+	}
+	req = ff->write_req;
 
-	req->num_pages = 1;
-	req->pages[0] = page;
-	req->page_offset = offset;
-	nres = fuse_send_write(req, file, inode, pos, count);
-	err = req->out.h.error;
-	fuse_put_request(fc, req);
-	if (!err && nres != count)
-		err = -EIO;
-	if (!err) {
-		pos += count;
-		spin_lock(&fc->lock);
-		if (pos > inode->i_size)
-			i_size_write(inode, pos);
-		spin_unlock(&fc->lock);
+	/* Whole page has been overwritten, it's now clean and up-to-date */
+	if (to == PAGE_CACHE_SIZE &&
+	    (!req->page_offset || req->num_pages > 1)) {
+		clear_page_dirty_for_io(page);
+		SetPageUptodate(page);
+	}
 
-		if (offset == 0 && to == PAGE_CACHE_SIZE)
-			SetPageUptodate(page);
+	if (!req->num_pages || req->pages[req->num_pages - 1] != page) {
+		req->pages[req->num_pages] = page;
+		req->num_pages++;
+		wait_on_page_writeback(page);
+		set_page_writeback(page);
 	}
-	fuse_invalidate_attr(inode);
-	return err;
+	req->misc.write.in.size += count;
+	return 0;
+}
+
+static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+				   unsigned long nr_segs, loff_t pos)
+{
+	ssize_t ret;
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct fuse_file *ff = file->private_data;
+	BUG_ON(iocb->ki_pos != pos);
+
+	mutex_lock(&inode->i_mutex);
+	BUG_ON(ff->write_req);
+	ret = generic_file_aio_write_nolock(iocb, iov, nr_segs, iocb->ki_pos);
+	if (ff->write_req) {
+		ssize_t written = ff->write_req->misc.write.in.offset - pos;
+		int err = fuse_send_write_chunk(ff, inode);
+		if (err)
+			ret = written ? written : err;
+	}
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
 }
 
 static void fuse_release_user_pages(struct fuse_req *req, int write)
@@ -1067,7 +1165,7 @@ static const struct file_operations fuse
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.aio_write	= fuse_file_aio_write,
 	.mmap		= fuse_file_mmap,
 	.open		= fuse_open,
 	.flush		= fuse_flush,
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-02-27 20:45:07.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2007-02-27 20:46:51.000000000 +0100
@@ -85,6 +85,9 @@ struct fuse_file {
 
 	/** Entry on inode's write_files list */
 	struct list_head write_entry;
+
+	/** Request used in synchronous writes */
+	struct fuse_req *write_req;
 };
 
 /** One input argument of a request */
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-02-27 20:45:07.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-02-27 21:57:19.000000000 +0100
@@ -108,6 +108,9 @@ static int fuse_remount_fs(struct super_
 	if (*flags & MS_MANDLOCK)
 		return -EINVAL;
 
+	/* Writes are synchronous anyway, also see O_SYNC */
+	*flags &= ~MS_SYNCHRONOUS;
+
 	return 0;
 }
 
@@ -542,6 +545,9 @@ static int fuse_fill_super(struct super_
 	if (sb->s_flags & MS_MANDLOCK)
 		return -EINVAL;
 
+	/* Writes are synchronous anyway, also see O_SYNC */
+	sb->s_flags &= ~MS_SYNCHRONOUS;
+
 	if (!parse_fuse_opt((char *) data, &d, is_bdev))
 		return -EINVAL;
 
@@ -551,8 +557,8 @@ static int fuse_fill_super(struct super_
 			return -EINVAL;
 #endif
 	} else {
-		sb->s_blocksize = PAGE_CACHE_SIZE;
-		sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
+		sb->s_blocksize = PAGE_CACHE_SIZE * FUSE_MAX_PAGES_PER_REQ;
+		sb->s_blocksize_bits = ilog2(sb->s_blocksize);
 	}
 	sb->s_magic = FUSE_SUPER_MAGIC;
 	sb->s_op = &fuse_super_operations;

--
