Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYH1SVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYH1SVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYH1SUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:20:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616AbYH1SUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:20:33 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] FUSE: export symbols to be used by CUSE
Date: Fri, 29 Aug 2008 03:19:01 +0900
Message-Id: <1219947544-666-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219947544-666-1-git-send-email-tj@kernel.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:20:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the following symbols for CUSE.

fuse_conn_put()
fuse_conn_get()
fuse_get_root_inode()
fuse_super_operations
fuse_send_init()
fuse_flush()
fuse_fsync()
fuse_direct_io()
fuse_file_lock()
fuse_file_flock()
fuse_file_llseek()
fuse_file_ioctl()
fuse_file_compat_ioctl()
fuse_file_poll()

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c    |    9 ++++++++-
 fs/fuse/file.c   |   30 ++++++++++++++++++++----------
 fs/fuse/fuse_i.h |   29 +++++++++++++++++++++++++++++
 fs/fuse/inode.c  |   11 ++++++++---
 4 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index b448dfd..75e2775 100644
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
@@ -398,6 +401,7 @@ void fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 	}
 	spin_unlock(&fc->lock);
 }
+EXPORT_SYMBOL_GPL(fuse_request_send);
 
 static void fuse_request_send_nowait_locked(struct fuse_conn *fc,
 					    struct fuse_req *req)
@@ -1092,8 +1096,9 @@ void fuse_abort_conn(struct fuse_conn *fc)
 	}
 	spin_unlock(&fc->lock);
 }
+EXPORT_SYMBOL_GPL(fuse_abort_conn);
 
-static int fuse_dev_release(struct inode *inode, struct file *file)
+int fuse_dev_release(struct inode *inode, struct file *file)
 {
 	struct fuse_conn *fc = fuse_get_conn(file);
 	if (fc) {
@@ -1108,6 +1113,7 @@ static int fuse_dev_release(struct inode *inode, struct file *file)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(fuse_dev_release);
 
 static int fuse_dev_fasync(int fd, struct file *file, int on)
 {
@@ -1130,6 +1136,7 @@ const struct file_operations fuse_dev_operations = {
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
 };
+EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
 static struct miscdevice fuse_miscdevice = {
 	.minor = FUSE_MINOR,
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 40895ed..38b0bfb 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -261,7 +262,7 @@ static int fuse_wait_on_page_writeback(struct inode *inode, pgoff_t index)
 	return 0;
 }
 
-static int fuse_flush(struct file *file, fl_owner_t id)
+int fuse_flush(struct file *file, fl_owner_t id)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -295,6 +296,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_flush);
 
 /*
  * Wait for all pending writepages on the inode to finish.
@@ -363,10 +365,11 @@ int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
 	return err;
 }
 
-static int fuse_fsync(struct file *file, struct dentry *de, int datasync)
+int fuse_fsync(struct file *file, struct dentry *de, int datasync)
 {
 	return fuse_fsync_common(file, de, datasync, 0);
 }
+EXPORT_SYMBOL_GPL(fuse_fsync);
 
 void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode)
@@ -961,8 +964,8 @@ static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
 	return 0;
 }
 
-static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
-			      size_t count, loff_t *ppos, int write)
+ssize_t fuse_direct_io(struct file *file, const char __user *buf,
+		       size_t count, loff_t *ppos, int write)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1027,6 +1030,7 @@ static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(fuse_direct_io);
 
 static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
@@ -1376,7 +1380,7 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 	return err;
 }
 
-static int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
+int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1398,8 +1402,9 @@ static int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_file_lock);
 
-static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
+int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1415,6 +1420,7 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_file_flock);
 
 static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 {
@@ -1452,7 +1458,7 @@ static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 	return err ? 0 : outarg.block;
 }
 
-static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
+loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval = -EINVAL;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1512,6 +1518,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(fuse_file_llseek);
 
 static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 			unsigned int nr_segs, size_t bytes, bool to_user)
@@ -1738,17 +1745,19 @@ static long fuse_file_do_ioctl(struct file *file, unsigned int cmd,
 	return err ? err : outarg.result;
 }
 
-static long fuse_file_ioctl(struct file *file, unsigned int cmd,
+long fuse_file_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
 	return fuse_file_do_ioctl(file, cmd, arg, 0);
 }
+EXPORT_SYMBOL_GPL(fuse_file_ioctl);
 
-static long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
+long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
 				   unsigned long arg)
 {
 	return fuse_file_do_ioctl(file, cmd, arg, FUSE_IOCTL_COMPAT);
 }
+EXPORT_SYMBOL_GPL(fuse_file_compat_ioctl);
 
 /*
  * All files which have been polled are linked to RB tree
@@ -1811,7 +1820,7 @@ static void fuse_register_polled_file(struct fuse_conn *fc,
 	spin_unlock(&fc->lock);
 }
 
-static unsigned fuse_file_poll(struct file *file, poll_table *wait)
+unsigned fuse_file_poll(struct file *file, poll_table *wait)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct fuse_file *ff = file->private_data;
@@ -1859,6 +1868,7 @@ static unsigned fuse_file_poll(struct file *file, poll_table *wait)
 	}
 	return POLLERR;
 }
+EXPORT_SYMBOL_GPL(fuse_file_poll);
 
 /*
  * This is called from fuse_handle_notify() on FUSE_NOTIFY_POLL and
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c5c11d7..bc55f6d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -488,10 +488,14 @@ static inline u64 get_node_id(struct inode *inode)
 }
 
 /** Device operations */
+extern const struct super_operations fuse_super_operations;
+
 extern const struct file_operations fuse_dev_operations;
 
 extern struct dentry_operations fuse_dentry_operations;
 
+struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode);
+
 /**
  * Get a filled in inode
  */
@@ -503,6 +507,11 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
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
@@ -539,6 +548,21 @@ int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
 		      int isdir);
 
 /**
+ * Exported file operations
+ */
+loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin);
+unsigned fuse_file_poll(struct file *file, poll_table *wait);
+ssize_t fuse_direct_io(struct file *file, const char __user *buf,
+		       size_t count, loff_t *ppos, int write);
+int fuse_flush(struct file *file, fl_owner_t id);
+int fuse_fsync(struct file *file, struct dentry *de, int datasync);
+int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl);
+int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl);
+long fuse_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg);
+
+/**
  * Notify poll wakeup
  */
 int fuse_notify_poll_wakeup(struct fuse_conn *fc,
@@ -581,6 +605,11 @@ void fuse_truncate(struct address_space *mapping, loff_t offset);
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
index c8806bb..fae8732 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -536,14 +536,16 @@ void fuse_conn_put(struct fuse_conn *fc)
 		kfree(fc);
 	}
 }
+EXPORT_SYMBOL_GPL(fuse_conn_put);
 
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc)
 {
 	atomic_inc(&fc->count);
 	return fc;
 }
+EXPORT_SYMBOL_GPL(fuse_conn_get);
 
-static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
+struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
 {
 	struct fuse_attr attr;
 	memset(&attr, 0, sizeof(attr));
@@ -553,6 +555,7 @@ static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
 	attr.nlink = 1;
 	return fuse_iget(sb, 1, 0, &attr, 0, 0);
 }
+EXPORT_SYMBOL_GPL(fuse_get_root_inode);
 
 struct fuse_inode_handle
 {
@@ -722,7 +725,7 @@ static const struct export_operations fuse_export_operations = {
 	.get_parent	= fuse_get_parent,
 };
 
-static const struct super_operations fuse_super_operations = {
+const struct super_operations fuse_super_operations = {
 	.alloc_inode    = fuse_alloc_inode,
 	.destroy_inode  = fuse_destroy_inode,
 	.clear_inode	= fuse_clear_inode,
@@ -733,6 +736,7 @@ static const struct super_operations fuse_super_operations = {
 	.statfs		= fuse_statfs,
 	.show_options	= fuse_show_options,
 };
+EXPORT_SYMBOL_GPL(fuse_super_operations);
 
 static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 {
@@ -776,7 +780,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	wake_up_all(&fc->blocked_waitq);
 }
 
-static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct fuse_init_in *arg = &req->misc.init_in;
 
@@ -799,6 +803,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	req->end = process_init_reply;
 	fuse_request_send_background(fc, req);
 }
+EXPORT_SYMBOL_GPL(fuse_send_init);
 
 static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 {
-- 
1.5.4.5

