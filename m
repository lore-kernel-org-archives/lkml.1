Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbXHAQb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbXHAQb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXHAQbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:31:49 -0400
Received: from pat.uio.no ([129.240.10.15]:46582 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXHAQbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:31:46 -0400
Subject: Re: PROBLEM: [2.6.22.1] Copying to full NFS dir
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Raphael Manfredi <Raphael_Manfredi@pobox.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <30002.1185980421@nice>
References: <30002.1185980421@nice>
Content-Type: multipart/mixed; boundary="=-p3jowV5dBrcA5u4O4rVx"
Date: Wed, 01 Aug 2007 12:31:40 -0400
Message-Id: <1185985900.6700.132.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.077)
X-UiO-Scanned: 98AAEA616F8776D69FF1B8C7700FFCD939E12CE1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 334 total 3051371 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-p3jowV5dBrcA5u4O4rVx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2007-08-01 at 17:00 +0200, Raphael Manfredi wrote:
> I've stumbled into a problem running 2.6.22.1 on both my NFS client and
> my NFS server.  I've just upgraded from 2.4.31, so I have no idea whether
> this is a new problem or if it is known in the 2.6.x series.
> 
> Here's a high-level description of the context:
> 
> * The NFS server has a directory which is full.
> * That directory is mounted on the NFS client.
> * The NFS client tries to "mv local-file /nfs/remote-dir/"
> * local-file is big (typically 700 MiB).
> 
> What happens is:
> 
> * The "mv" takes a long long time and eventually fails, of course.
> * The load on the NFS server (initially at 0) increases to about 8.
> * Any access to the NFS-mounted dir from the client whilst "mv" is in
>   progress stalls (e.g. ls -l /nfs/remote-dir).
> 
> I've tried to write my own "mv" in C to see which syscalls were involved.
> What happens is:
> 
> * All the write() succeed with no error.
> * The final close() returns -1 with either EINTR or ENOSPC.
> 
> I could not determine what makes close return EINTR or ENOSPC.
> 
> Problem is, under 2.4.31, the write() was immediately failing when writing
> to a full NFS partition.
> 
> This looks like an important bug, but I don't know if it is in the NFS-client
> or NFS-server side.  I'm tempted to say NFS-server, but that's more a hunch.

The answer appears to be that some filesystems really _suck_ when they
have to return errors: they take forever to return to the user. When the
client then tries with several WRITE requests (it can cache huge numbers
of requests) then the cumulative effect of the delays are quite
noticeable as you can see above.

I've got a tentative client-side patch to deal with this sort of server.
Basically, when the client sees that a cached write returns an error,
then it will stop caching, and start doing O_SYNC-style writes until the
error conditions stop. That won't fix the server side problem, but it
does ensure that the application gets notified of the error as soon as
possible.

Cheers
  Trond

--=-p3jowV5dBrcA5u4O4rVx
Content-Disposition: inline; filename=linux-2.6.23-011-osync_on_error.dif
Content-Type: message/rfc822; name=linux-2.6.23-011-osync_on_error.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 25 Jul 2007 14:09:54 -0400
NFS: Fall back to synchronous writes when a background write errors...
Subject: No Subject
Message-Id: <1185985859.6700.131.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

This helps prevent huge queues of background writes from building up
whenever the server runs out of disk or quota space, or if someone changes
the file access modes behind our backs.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/file.c          |   64 +++++++++++++++++++++++++++++++++---------------
 fs/nfs/write.c         |   13 ++++++++--
 include/linux/nfs_fs.h |    3 ++
 3 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 72711b4..4d9dca2 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -177,6 +177,31 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
 }
 
 /*
+ * Helper for nfs_file_flush() and nfs_fsync()
+ *
+ * Notice that it clears the NFS_CONTEXT_ERROR_WRITE before synching to
+ * disk, but it retrieves and clears ctx->error after synching, despite
+ * the two being set at the same time in nfs_context_set_write_error().
+ * This is because the former is used to notify the _next_ call to
+ * nfs_file_write() that a write error occured, and hence cause it to
+ * fall back to doing a synchronous write.
+ */
+static int nfs_do_fsync(struct nfs_open_context *ctx, struct inode *inode)
+{
+	int have_error, status;
+	int ret = 0;
+
+	have_error = test_and_clear_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
+	status = nfs_wb_all(inode);
+	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
+	if (have_error)
+		ret = xchg(&ctx->error, 0);
+	if (!ret)
+		ret = status;
+	return ret;
+}
+
+/*
  * Flush all dirty pages, and check for write errors.
  *
  */
@@ -192,16 +217,11 @@ nfs_file_flush(struct file *file, fl_owner_t id)
 	if ((file->f_mode & FMODE_WRITE) == 0)
 		return 0;
 	nfs_inc_stats(inode, NFSIOS_VFSFLUSH);
-	lock_kernel();
+
 	/* Ensure that data+attribute caches are up to date after close() */
-	status = nfs_wb_all(inode);
-	if (!status) {
-		status = ctx->error;
-		ctx->error = 0;
-		if (!status)
-			nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	}
-	unlock_kernel();
+	status = nfs_do_fsync(ctx, inode);
+	if (!status)
+		nfs_revalidate_inode(NFS_SERVER(inode), inode);
 	return status;
 }
 
@@ -278,19 +298,11 @@ nfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct nfs_open_context *ctx = (struct nfs_open_context *)file->private_data;
 	struct inode *inode = dentry->d_inode;
-	int status;
 
 	dfprintk(VFS, "nfs: fsync(%s/%ld)\n", inode->i_sb->s_id, inode->i_ino);
 
 	nfs_inc_stats(inode, NFSIOS_VFSFSYNC);
-	lock_kernel();
-	status = nfs_wb_all(inode);
-	if (!status) {
-		status = ctx->error;
-		ctx->error = 0;
-	}
-	unlock_kernel();
-	return status;
+	return nfs_do_fsync(ctx, inode);
 }
 
 /*
@@ -377,6 +389,18 @@ static struct vm_operations_struct nfs_file_vm_ops = {
 	.page_mkwrite = nfs_vm_page_mkwrite,
 };
 
+static int nfs_need_sync_write(struct file *filp, struct inode *inode)
+{
+	struct nfs_open_context *ctx;
+
+	if (IS_SYNC(inode) || (filp->f_flags & O_SYNC))
+		return 1;
+	ctx = filp->private_data;
+	if (test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags))
+		return 1;
+	return 0;
+}
+
 static ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
@@ -413,8 +437,8 @@ static ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
 	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, count);
 	result = generic_file_aio_write(iocb, iov, nr_segs, pos);
 	/* Return error values for O_SYNC and IS_SYNC() */
-	if (result >= 0 && (IS_SYNC(inode) || (iocb->ki_filp->f_flags & O_SYNC))) {
-		int err = nfs_fsync(iocb->ki_filp, dentry, 1);
+	if (result >= 0 && nfs_need_sync_write(iocb->ki_filp, inode)) {
+		int err = nfs_do_fsync(iocb->ki_filp->private_data, inode);
 		if (err < 0)
 			result = err;
 	}
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 4e5d43a..d448954 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -110,6 +110,13 @@ void nfs_writedata_release(void *wdata)
 	nfs_writedata_free(wdata);
 }
 
+static void nfs_context_set_write_error(struct nfs_open_context *ctx, int error)
+{
+	ctx->error = error;
+	smp_wmb();
+	set_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
+}
+
 static struct nfs_page *nfs_page_find_request_locked(struct page *page)
 {
 	struct nfs_page *req = NULL;
@@ -945,7 +952,7 @@ static void nfs_writeback_done_partial(struct rpc_task *task, void *calldata)
 
 	if (task->tk_status < 0) {
 		nfs_set_pageerror(page);
-		req->wb_context->error = task->tk_status;
+		nfs_context_set_write_error(req->wb_context, task->tk_status);
 		dprintk(", error = %d\n", task->tk_status);
 		goto out;
 	}
@@ -1008,7 +1015,7 @@ static void nfs_writeback_done_full(struct rpc_task *task, void *calldata)
 
 		if (task->tk_status < 0) {
 			nfs_set_pageerror(page);
-			req->wb_context->error = task->tk_status;
+			nfs_context_set_write_error(req->wb_context, task->tk_status);
 			dprintk(", error = %d\n", task->tk_status);
 			goto remove_request;
 		}
@@ -1222,7 +1229,7 @@ static void nfs_commit_done(struct rpc_task *task, void *calldata)
 			req->wb_bytes,
 			(long long)req_offset(req));
 		if (task->tk_status < 0) {
-			req->wb_context->error = task->tk_status;
+			nfs_context_set_write_error(req->wb_context, task->tk_status);
 			nfs_inode_remove_request(req);
 			dprintk(", error = %d\n", task->tk_status);
 			goto next;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index eb76bbd..59ce401 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -77,6 +77,9 @@ struct nfs_open_context {
 	struct nfs4_state *state;
 	fl_owner_t lockowner;
 	int mode;
+
+	unsigned long flags;
+#define NFS_CONTEXT_ERROR_WRITE		(0)
 	int error;
 
 	struct list_head list;

--=-p3jowV5dBrcA5u4O4rVx--

