Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZDNB5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZDNB5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZDNB4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:56:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:56158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZDNB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:56:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] FUSE: export symbols to be used by CUSE
Date: Tue, 14 Apr 2009 10:54:53 +0900
Message-Id: <1239674094-30894-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674094-30894-1-git-send-email-tj@kernel.org>
References: <1239674094-30894-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 01:55:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the following symbols for CUSE.

fuse_conn_put()
fuse_conn_get()
fuse_send_init()
fuse_flush()
fuse_fsync()
fuse_direct_io()
fuse_direct_read()
fuse_file_ioctl_common()
fuse_file_poll()
fuse_request_alloc()
fuse_get_req()
fuse_put_request()
fuse_request_send()
fuse_abort_conn()
fuse_dev_release()
fuse_dev_operations

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c    |    9 ++++++++-
 fs/fuse/file.c   |   27 ++++++++++++++++++---------
 fs/fuse/fuse_i.h |   39 +++++++++++++++++++++++++++++++++++++++
 fs/fuse/inode.c  |    5 ++++-
 4 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ba76b68..2a17249 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -46,6 +46,7 @@ struct fuse_req *fuse_request_alloc(void)
 		fuse_request_init(req);
 	return req;
 }
+EXPORT_SYMBOL_GPL(fuse_request_alloc);
 
 struct fuse_req *fuse_request_alloc_nofs(void)
 {
@@ -124,6 +125,7 @@ struct fuse_req *fuse_get_req(struct fuse_conn *fc)
 	atomic_dec(&fc->num_waiting);
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL_GPL(fuse_get_req);
 
 /*
  * Return request in fuse_file->reserved_req.  However that may
@@ -208,6 +210,7 @@ void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req)
 			fuse_request_free(req);
 	}
 }
+EXPORT_SYMBOL_GPL(fuse_put_request);
 
 static unsigned len_args(unsigned numargs, struct fuse_arg *args)
 {
@@ -400,6 +403,7 @@ void fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 	}
 	spin_unlock(&fc->lock);
 }
+EXPORT_SYMBOL_GPL(fuse_request_send);
 
 static void fuse_request_send_nowait_locked(struct fuse_conn *fc,
 					    struct fuse_req *req)
@@ -1105,8 +1109,9 @@ void fuse_abort_conn(struct fuse_conn *fc)
 	}
 	spin_unlock(&fc->lock);
 }
+EXPORT_SYMBOL_GPL(fuse_abort_conn);
 
-static int fuse_dev_release(struct inode *inode, struct file *file)
+int fuse_dev_release(struct inode *inode, struct file *file)
 {
 	struct fuse_conn *fc = fuse_get_conn(file);
 	if (fc) {
@@ -1120,6 +1125,7 @@ static int fuse_dev_release(struct inode *inode, struct file *file)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(fuse_dev_release);
 
 static int fuse_dev_fasync(int fd, struct file *file, int on)
 {
@@ -1142,6 +1148,7 @@ const struct file_operations fuse_dev_operations = {
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
 };
+EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
 static struct miscdevice fuse_miscdevice = {
 	.minor = FUSE_MINOR,
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 54ad406..700cdf9 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -149,6 +150,7 @@ int fuse_open_common(struct fuse_conn *fc, struct fuse_inode *fi,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_open_common);
 
 void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode)
 {
@@ -190,6 +192,7 @@ void fuse_release_common(struct fuse_file *ff, int isdir)
 	 */
 	fuse_file_put(ff);
 }
+EXPORT_SYMBOL_GPL(fuse_release_common);
 
 static int fuse_open(struct inode *inode, struct file *file)
 {
@@ -268,7 +271,7 @@ static int fuse_wait_on_page_writeback(struct fuse_inode *fi, pgoff_t index)
 	return 0;
 }
 
-static int fuse_flush(struct file *file, fl_owner_t id)
+int fuse_flush(struct file *file, fl_owner_t id)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
@@ -301,6 +304,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_flush);
 
 /*
  * Wait for all pending writepages on the inode to finish.
@@ -367,12 +371,13 @@ int fuse_fsync_common(struct fuse_file *ff, int datasync, int isdir)
 	return err;
 }
 
-static int fuse_fsync(struct file *file, struct dentry *de, int datasync)
+int fuse_fsync(struct file *file, struct dentry *de, int datasync)
 {
 	struct fuse_file *ff = file->private_data;
 
 	return fuse_fsync_common(ff, datasync, 0);
 }
+EXPORT_SYMBOL_GPL(fuse_fsync);
 
 void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
 		    loff_t pos, size_t count, int opcode)
@@ -987,8 +992,8 @@ static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
 	return 0;
 }
 
-static ssize_t fuse_direct_io(struct fuse_file *ff, const char __user *buf,
-			      size_t count, loff_t *ppos, int write)
+ssize_t fuse_direct_io(struct fuse_file *ff, const char __user *buf,
+		       size_t count, loff_t *ppos, int write)
 {
 	struct fuse_conn *fc = ff->fc;
 	size_t nmax = write ? fc->max_write : fc->max_read;
@@ -1051,14 +1056,16 @@ static ssize_t fuse_direct_io(struct fuse_file *ff, const char __user *buf,
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(fuse_direct_io);
 
-static ssize_t fuse_direct_read(struct file *file, char __user *buf,
-				     size_t count, loff_t *ppos)
+ssize_t fuse_direct_read(struct file *file, char __user *buf, size_t count,
+			 loff_t *ppos)
 {
 	struct fuse_file *ff = file->private_data;
 
 	return fuse_direct_io(ff, buf, count, ppos, 0);
 }
+EXPORT_SYMBOL_GPL(fuse_direct_read);
 
 static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -1611,8 +1618,8 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
  * limits ioctl data transfers to well-formed ioctls and is the forced
  * behavior for all FUSE servers.
  */
-static long fuse_file_ioctl_common(struct fuse_file *ff, unsigned int cmd,
-				   unsigned long arg, unsigned int flags)
+long fuse_file_ioctl_common(struct fuse_file *ff, unsigned int cmd,
+			    unsigned long arg, unsigned int flags)
 {
 	struct fuse_conn *fc = ff->fc;
 	struct fuse_ioctl_in inarg = {
@@ -1783,6 +1790,7 @@ static long fuse_file_ioctl_common(struct fuse_file *ff, unsigned int cmd,
 
 	return err ? err : outarg.result;
 }
+EXPORT_SYMBOL_GPL(fuse_file_ioctl_common);
 
 static long fuse_file_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
@@ -1852,7 +1860,7 @@ static void fuse_register_polled_file(struct fuse_file *ff)
 	spin_unlock(&fc->lock);
 }
 
-static unsigned fuse_file_poll(struct file *file, poll_table *wait)
+unsigned fuse_file_poll(struct file *file, poll_table *wait)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
@@ -1899,6 +1907,7 @@ static unsigned fuse_file_poll(struct file *file, poll_table *wait)
 	}
 	return POLLERR;
 }
+EXPORT_SYMBOL_GPL(fuse_file_poll);
 
 /*
  * This is called from fuse_handle_notify() on FUSE_NOTIFY_POLL and
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d2643df..cdab92d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -530,6 +530,11 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode);
 
 /**
+ * Send INIT command
+ */
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req);
+
+/**
  * Send FORGET command
  */
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
@@ -566,6 +571,35 @@ void fuse_release_common(struct fuse_file *ff, int isdir);
 int fuse_fsync_common(struct fuse_file *ff, int datasync, int isdir);
 
 /**
+ * Send READ or WRITE request for direct IO
+ */
+ssize_t fuse_direct_io(struct fuse_file *ff, const char __user *buf,
+		       size_t count, loff_t *ppos, int write);
+ssize_t fuse_direct_read(struct file *file, char __user *buf, size_t count,
+			 loff_t *ppos);
+
+/**
+ * Send FLUSH request
+ */
+int fuse_flush(struct file *file, fl_owner_t id);
+
+/**
+ * Send FSYNCDIR or FSYNC request
+ */
+int fuse_fsync(struct file *file, struct dentry *de, int datasync);
+
+/**
+ * Send IOCTL request
+ */
+long fuse_file_ioctl_common(struct fuse_file *ff, unsigned int cmd,
+			    unsigned long arg, unsigned int flags);
+
+/**
+ * Send POLL request
+ */
+unsigned fuse_file_poll(struct file *file, poll_table *wait);
+
+/**
  * Notify poll wakeup
  */
 int fuse_notify_poll_wakeup(struct fuse_conn *fc,
@@ -608,6 +642,11 @@ void fuse_truncate(struct address_space *mapping, loff_t offset);
 int fuse_dev_init(void);
 
 /**
+ * Release the client device
+ */
+int fuse_dev_release(struct inode *inode, struct file *file);
+
+/**
  * Cleanup the client device
  */
 void fuse_dev_cleanup(void);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 699b228..a01f52c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -545,12 +545,14 @@ void fuse_conn_put(struct fuse_conn *fc)
 		fc->release(fc);
 	}
 }
+EXPORT_SYMBOL_GPL(fuse_conn_put);
 
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc)
 {
 	atomic_inc(&fc->count);
 	return fc;
 }
+EXPORT_SYMBOL_GPL(fuse_conn_get);
 
 static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
 {
@@ -774,7 +776,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	wake_up_all(&fc->blocked_waitq);
 }
 
-static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct fuse_init_in *arg = &req->misc.init_in;
 
@@ -797,6 +799,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	req->end = process_init_reply;
 	fuse_request_send_background(fc, req);
 }
+EXPORT_SYMBOL_GPL(fuse_send_init);
 
 static void fuse_free_conn(struct fuse_conn *fc)
 {
-- 
1.6.0.2

