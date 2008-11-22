Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYKVIGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYKVIGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 03:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYKVIGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 03:06:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:50772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYKVIGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 03:06:45 -0500
Message-ID: <4927BD64.7040506@kernel.org>
Date: Sat, 22 Nov 2008 17:05:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, greg@kroah.com
Subject: [PATCH 2/5 UPDATED] FUSE: export symbols to be used by CUSE
References: <1227190983-5820-1-git-send-email-tj@kernel.org> <1227190983-5820-3-git-send-email-tj@kernel.org>
In-Reply-To: <1227190983-5820-3-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 22 Nov 2008 08:06:02 +0000 (UTC)
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
The original posting contained a snippet fixing ioctl data direction
bug which should have been in fuse-implement-ioctl patch.  The
original patch is fixed now.  Drop the contamination.

Thanks.

 fs/fuse/dev.c    |    9 ++++++++-
 fs/fuse/file.c   |   29 +++++++++++++++++++----------
 fs/fuse/fuse_i.h |   28 ++++++++++++++++++++++++++++
 fs/fuse/inode.c  |   11 ++++++++---
 4 files changed, 63 insertions(+), 14 deletions(-)

Index: work/fs/fuse/fuse_i.h
===================================================================
--- work.orig/fs/fuse/fuse_i.h
+++ work/fs/fuse/fuse_i.h
@@ -488,10 +488,14 @@ static inline u64 get_node_id(struct ino
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
@@ -503,6 +507,11 @@ int fuse_lookup_name(struct super_block
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
@@ -539,6 +548,20 @@ int fuse_fsync_common(struct file *file,
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
+long fuse_file_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
+			unsigned int flags);
+
+/**
  * Notify poll wakeup
  */
 int fuse_notify_poll_wakeup(struct fuse_conn *fc,
@@ -581,6 +604,11 @@ void fuse_truncate(struct address_space
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
Index: work/fs/fuse/file.c
===================================================================
--- work.orig/fs/fuse/file.c
+++ work/fs/fuse/file.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -265,7 +266,7 @@ static int fuse_wait_on_page_writeback(s
 	return 0;
 }
 
-static int fuse_flush(struct file *file, fl_owner_t id)
+int fuse_flush(struct file *file, fl_owner_t id)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -299,6 +300,7 @@ static int fuse_flush(struct file *file,
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_flush);
 
 /*
  * Wait for all pending writepages on the inode to finish.
@@ -367,10 +369,11 @@ int fuse_fsync_common(struct file *file,
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
@@ -961,8 +964,8 @@ static int fuse_get_user_pages(struct fu
 	return 0;
 }
 
-static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
-			      size_t count, loff_t *ppos, int write)
+ssize_t fuse_direct_io(struct file *file, const char __user *buf,
+		       size_t count, loff_t *ppos, int write)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1027,6 +1030,7 @@ static ssize_t fuse_direct_io(struct fil
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(fuse_direct_io);
 
 static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
@@ -1376,7 +1380,7 @@ static int fuse_setlk(struct file *file,
 	return err;
 }
 
-static int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
+int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1398,8 +1402,9 @@ static int fuse_file_lock(struct file *f
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_file_lock);
 
-static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
+int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1415,6 +1420,7 @@ static int fuse_file_flock(struct file *
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_file_flock);
 
 static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 {
@@ -1452,7 +1458,7 @@ static sector_t fuse_bmap(struct address
 	return err ? 0 : outarg.block;
 }
 
-static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
+loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1479,6 +1485,7 @@ static loff_t fuse_file_llseek(struct fi
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(fuse_file_llseek);
 
 static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 			unsigned int nr_segs, size_t bytes, bool to_user)
@@ -1569,8 +1576,8 @@ static int fuse_ioctl_copy_user(struct p
  * limits ioctl data transfers to well-formed ioctls and is the forced
  * behavior for all FUSE servers.
  */
-static long fuse_file_do_ioctl(struct file *file, unsigned int cmd,
-			       unsigned long arg, unsigned int flags)
+long fuse_file_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
+			unsigned int flags)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct fuse_file *ff = file->private_data;
@@ -1736,6 +1743,7 @@ static long fuse_file_do_ioctl(struct fi
 
 	return err ? err : outarg.result;
 }
+EXPORT_SYMBOL_GPL(fuse_file_do_ioctl);
 
 static long fuse_file_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
@@ -1804,7 +1812,7 @@ static void fuse_register_polled_file(st
 	spin_unlock(&fc->lock);
 }
 
-static unsigned fuse_file_poll(struct file *file, poll_table *wait)
+unsigned fuse_file_poll(struct file *file, poll_table *wait)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct fuse_file *ff = file->private_data;
@@ -1852,6 +1860,7 @@ static unsigned fuse_file_poll(struct fi
 	}
 	return POLLERR;
 }
+EXPORT_SYMBOL_GPL(fuse_file_poll);
 
 /*
  * This is called from fuse_handle_notify() on FUSE_NOTIFY_POLL and
Index: work/fs/fuse/inode.c
===================================================================
--- work.orig/fs/fuse/inode.c
+++ work/fs/fuse/inode.c
@@ -537,14 +537,16 @@ void fuse_conn_put(struct fuse_conn *fc)
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
@@ -554,6 +556,7 @@ static struct inode *fuse_get_root_inode
 	attr.nlink = 1;
 	return fuse_iget(sb, 1, 0, &attr, 0, 0);
 }
+EXPORT_SYMBOL_GPL(fuse_get_root_inode);
 
 struct fuse_inode_handle
 {
@@ -716,7 +719,7 @@ static const struct export_operations fu
 	.get_parent	= fuse_get_parent,
 };
 
-static const struct super_operations fuse_super_operations = {
+const struct super_operations fuse_super_operations = {
 	.alloc_inode    = fuse_alloc_inode,
 	.destroy_inode  = fuse_destroy_inode,
 	.clear_inode	= fuse_clear_inode,
@@ -727,6 +730,7 @@ static const struct super_operations fus
 	.statfs		= fuse_statfs,
 	.show_options	= fuse_show_options,
 };
+EXPORT_SYMBOL_GPL(fuse_super_operations);
 
 static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 {
@@ -768,7 +772,7 @@ static void process_init_reply(struct fu
 	wake_up_all(&fc->blocked_waitq);
 }
 
-static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct fuse_init_in *arg = &req->misc.init_in;
 
@@ -791,6 +795,7 @@ static void fuse_send_init(struct fuse_c
 	req->end = process_init_reply;
 	fuse_request_send_background(fc, req);
 }
+EXPORT_SYMBOL_GPL(fuse_send_init);
 
 static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 {
Index: work/fs/fuse/dev.c
===================================================================
--- work.orig/fs/fuse/dev.c
+++ work/fs/fuse/dev.c
@@ -46,6 +46,7 @@ struct fuse_req *fuse_request_alloc(void
 		fuse_request_init(req);
 	return req;
 }
+EXPORT_SYMBOL_GPL(fuse_request_alloc);
 
 struct fuse_req *fuse_request_alloc_nofs(void)
 {
@@ -124,6 +125,7 @@ struct fuse_req *fuse_get_req(struct fus
 	atomic_dec(&fc->num_waiting);
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL_GPL(fuse_get_req);
 
 /*
  * Return request in fuse_file->reserved_req.  However that may
@@ -208,6 +210,7 @@ void fuse_put_request(struct fuse_conn *
 			fuse_request_free(req);
 	}
 }
+EXPORT_SYMBOL_GPL(fuse_put_request);
 
 static unsigned len_args(unsigned numargs, struct fuse_arg *args)
 {
@@ -398,6 +401,7 @@ void fuse_request_send(struct fuse_conn
 	}
 	spin_unlock(&fc->lock);
 }
+EXPORT_SYMBOL_GPL(fuse_request_send);
 
 static void fuse_request_send_nowait_locked(struct fuse_conn *fc,
 					    struct fuse_req *req)
@@ -1092,8 +1096,9 @@ void fuse_abort_conn(struct fuse_conn *f
 	}
 	spin_unlock(&fc->lock);
 }
+EXPORT_SYMBOL_GPL(fuse_abort_conn);
 
-static int fuse_dev_release(struct inode *inode, struct file *file)
+int fuse_dev_release(struct inode *inode, struct file *file)
 {
 	struct fuse_conn *fc = fuse_get_conn(file);
 	if (fc) {
@@ -1107,6 +1112,7 @@ static int fuse_dev_release(struct inode
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(fuse_dev_release);
 
 static int fuse_dev_fasync(int fd, struct file *file, int on)
 {
@@ -1129,6 +1135,7 @@ const struct file_operations fuse_dev_op
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
 };
+EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
 static struct miscdevice fuse_miscdevice = {
 	.minor = FUSE_MINOR,
