Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYH1Roh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYH1Roh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYH1Rms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:42:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:52438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbYH1Rmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:42:47 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/7] FUSE: implement poll support
Date: Fri, 29 Aug 2008 02:41:03 +0900
Message-Id: <1219945263-21074-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219945263-21074-1-git-send-email-tj@kernel.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:42:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement poll support.  Polled files are indexed using fh in a RB
tree rooted at fuse_conn->polled_files.  All pollable files should
have unique fh as that's how notifications are matched to files.  If
duplicate fhs are detected, FUSE spits out warning message.  Poll will
malfunction but otherwise it will work fine.

Client should send FUSE_NOTIFY_POLL notification once after processing
FUSE_POLL which has FUSE_POLL_SCHEDULE_NOTIFY set.  Sending
notification unconditionally after the latest poll or everytime file
content might have changed is inefficient but won't cause malfunction.

fuse_file_poll() can sleep and requires patches from the following
thread which allows f_op->poll() to sleep.

  http://thread.gmane.org/gmane.linux.kernel/726176

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c        |   15 +++++
 fs/fuse/file.c       |  141 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h     |   23 ++++++++
 fs/fuse/inode.c      |    1 +
 include/linux/fuse.h |   24 +++++++++
 5 files changed, 204 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 2fb65a5..1c422f9 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -819,11 +819,26 @@ static int fuse_handle_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 	int err;
 
 	switch (code) {
+	case FUSE_NOTIFY_POLL: {
+		struct fuse_notify_poll_wakeup_out outarg;
+
+		err = -EINVAL;
+		if (size != sizeof(outarg))
+			goto out;
+
+		err = fuse_copy_one(cs, &outarg, sizeof(outarg));
+		if (err)
+			goto out;
+
+		err = fuse_notify_poll_wakeup(fc, &outarg);
+		break;
+	}
 	default:
 		err = -EINVAL;
 		break;
 	}
 
+ out:
 	fuse_copy_finish(cs);
 	return err;
 }
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 75a9b53..5d704e3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -59,6 +59,8 @@ struct fuse_file *fuse_file_alloc(void)
 			INIT_LIST_HEAD(&ff->write_entry);
 			atomic_set(&ff->count, 0);
 		}
+		RB_CLEAR_NODE(&ff->polled_node);
+		init_waitqueue_head(&ff->poll_wait);
 	}
 	return ff;
 }
@@ -167,7 +169,11 @@ int fuse_release_common(struct inode *inode, struct file *file, int isdir)
 
 		spin_lock(&fc->lock);
 		list_del(&ff->write_entry);
+		if (!RB_EMPTY_NODE(&ff->polled_node))
+			rb_erase(&ff->polled_node, &fc->polled_files);
 		spin_unlock(&fc->lock);
+
+		wake_up_interruptible_sync(&ff->poll_wait);
 		/*
 		 * Normally this will send the RELEASE request,
 		 * however if some asynchronous READ or WRITE requests
@@ -1744,6 +1750,139 @@ static long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
 	return fuse_file_do_ioctl(file, cmd, arg, FUSE_IOCTL_COMPAT);
 }
 
+/*
+ * All files which have been polled are linked to RB tree
+ * fuse_conn->polled_files which is indexed by fh.  Walk the tree and
+ * find the matching one.
+ */
+static struct rb_node **fuse_find_polled_node(struct fuse_conn *fc, u64 fh,
+					      struct rb_node **parent_out)
+{
+	struct rb_node **link = &fc->polled_files.rb_node;
+	struct rb_node *last = NULL;
+
+	while (*link) {
+		struct fuse_file *ff = rb_entry(*link, struct fuse_file,
+						polled_node);
+		last = *link;
+
+		if (fh < ff->fh)
+			link = &(*link)->rb_left;
+		else if (fh > ff->fh)
+			link = &(*link)->rb_right;
+		else
+			return link;
+	}
+
+	if (parent_out)
+		*parent_out = last;
+	return link;
+}
+
+/*
+ * The file is about to be polled.  Make sure it's on the polled_files
+ * RB tree.  Note that files once added to the polled_files tree are
+ * not removed before the file is released.  This is because a file
+ * polled once is likely to be polled again.
+ */
+static void fuse_register_polled_file(struct fuse_conn *fc,
+				      struct fuse_file *ff)
+{
+	if (!RB_EMPTY_NODE(&ff->polled_node))
+		return;
+
+	spin_lock(&fc->lock);
+
+	if (RB_EMPTY_NODE(&ff->polled_node)) {
+		struct rb_node **link, *parent;
+
+		link = fuse_find_polled_node(fc, ff->fh, &parent);
+		if (likely(!*link)) {
+			rb_link_node(&ff->polled_node, parent, link);
+			rb_insert_color(&ff->polled_node, &fc->polled_files);
+		} else if (!fc->warned_duplicate_fh) {
+			printk(KERN_WARNING "FUSE %u:%u duplicate fh detected, "
+			       "poll will malfunction, please fix client\n",
+			       MAJOR(fc->dev), MINOR(fc->dev));
+			fc->warned_duplicate_fh = 1;
+		}
+	}
+
+	spin_unlock(&fc->lock);
+}
+
+static unsigned fuse_file_poll(struct file *file, poll_table *wait)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_poll_in inarg = { .fh = ff->fh };
+	struct fuse_poll_out outarg;
+	struct fuse_req *req;
+	int err;
+
+	if (fc->no_poll)
+		return DEFAULT_POLLMASK;
+
+	poll_wait(file, &ff->poll_wait, wait);
+
+	/*
+	 * Ask for notification iff there's someone waiting for it.
+	 * The client may ignore the flag and always notify.
+	 */
+	if (waitqueue_active(&ff->poll_wait)) {
+		inarg.flags |= FUSE_POLL_SCHEDULE_NOTIFY;
+		fuse_register_polled_file(fc, ff);
+	}
+
+	req = fuse_get_req(fc);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	req->in.h.opcode = FUSE_POLL;
+	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
+	req->out.numargs = 1;
+	req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
+	request_send(fc, req);
+	err = req->out.h.error;
+	fuse_put_request(fc, req);
+
+	if (!err)
+		return outarg.revents;
+	if (err == -ENOSYS) {
+		fc->no_poll = 1;
+		return DEFAULT_POLLMASK;
+	}
+	return POLLERR;
+}
+
+/*
+ * This is called from fuse_handle_notify() on FUSE_NOTIFY_POLL and
+ * wakes up the poll waiters.
+ */
+int fuse_notify_poll_wakeup(struct fuse_conn *fc,
+			    struct fuse_notify_poll_wakeup_out *outarg)
+{
+	u64 fh = outarg->fh;
+	struct rb_node **link;
+
+	spin_lock(&fc->lock);
+
+	link = fuse_find_polled_node(fc, fh, NULL);
+	if (*link) {
+		struct fuse_file *ff = rb_entry(*link, struct fuse_file,
+						polled_node);
+		wake_up_interruptible_sync(&ff->poll_wait);
+	}
+
+	spin_unlock(&fc->lock);
+	return 0;
+}
+
 static const struct file_operations fuse_file_operations = {
 	.llseek		= fuse_file_llseek,
 	.read		= do_sync_read,
@@ -1760,6 +1899,7 @@ static const struct file_operations fuse_file_operations = {
 	.splice_read	= generic_file_splice_read,
 	.unlocked_ioctl	= fuse_file_ioctl,
 	.compat_ioctl	= fuse_file_compat_ioctl,
+	.poll		= fuse_file_poll,
 };
 
 static const struct file_operations fuse_direct_io_file_operations = {
@@ -1774,6 +1914,7 @@ static const struct file_operations fuse_direct_io_file_operations = {
 	.flock		= fuse_file_flock,
 	.unlocked_ioctl	= fuse_file_ioctl,
 	.compat_ioctl	= fuse_file_compat_ioctl,
+	.poll		= fuse_file_poll,
 	/* no mmap and splice_read */
 };
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 2bf2209..f884160 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -19,6 +19,8 @@
 #include <linux/backing-dev.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/rbtree.h>
+#include <linux/poll.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -108,6 +110,12 @@ struct fuse_file {
 
 	/** Entry on inode's write_files list */
 	struct list_head write_entry;
+
+	/** RB node to be linked on fuse_conn->polled_files */
+	struct rb_node polled_node;
+
+	/** Wait queue head for poll */
+	wait_queue_head_t poll_wait;
 };
 
 /** One input argument of a request */
@@ -322,6 +330,9 @@ struct fuse_conn {
 	/** The list of requests under I/O */
 	struct list_head io;
 
+	/** rbtree of fuse_files waiting for poll events */
+	struct rb_root polled_files;
+
 	/** Number of requests currently in the background */
 	unsigned num_background;
 
@@ -413,9 +424,15 @@ struct fuse_conn {
 	/** Is bmap not implemented by fs? */
 	unsigned no_bmap : 1;
 
+	/** Is poll not implemented by fs? */
+	unsigned no_poll : 1;
+
 	/** Do multi-page cached writes */
 	unsigned big_writes : 1;
 
+	/** Warned about duplicate fh's when using poll? */
+	unsigned warned_duplicate_fh : 1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
@@ -522,6 +539,12 @@ int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
 		      int isdir);
 
 /**
+ * Notify poll wakeup
+ */
+int fuse_notify_poll_wakeup(struct fuse_conn *fc,
+			    struct fuse_notify_poll_wakeup_out *outarg);
+
+/**
  * Initialize file operations on a regular file
  */
 void fuse_init_file_inode(struct inode *inode);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 7693dfc..088ba6e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -485,6 +485,7 @@ static struct fuse_conn *new_conn(struct super_block *sb)
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
 		/* fuse does it's own writeback accounting */
 		fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
+		fc->polled_files = RB_ROOT;
 		fc->dev = sb->s_dev;
 		err = bdi_init(&fc->bdi);
 		if (err)
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 0044590..b772b4a 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -165,6 +165,13 @@ struct fuse_file_lock {
 
 #define FUSE_IOCTL_MAX_IOV	256
 
+/**
+ * Poll flags
+ *
+ * FUSE_POLL_SCHEDULE_NOTIFY: request poll notify
+ */
+#define FUSE_POLL_SCHEDULE_NOTIFY (1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -204,9 +211,11 @@ enum fuse_opcode {
 	FUSE_DESTROY       = 38,
 	FUSE_LSEEK         = 39,
 	FUSE_IOCTL         = 40,
+	FUSE_POLL          = 41,
 };
 
 enum fuse_notify_code {
+	FUSE_NOTIFY_POLL   = 1,
 	FUSE_NOTIFY_CODE_MAX,
 };
 
@@ -436,6 +445,21 @@ struct fuse_ioctl_out {
 	__u32	out_iovs;
 };
 
+struct fuse_poll_in {
+	__u64	fh;
+	__u32	flags;
+	__u32   padding;
+};
+
+struct fuse_poll_out {
+	__u32	revents;
+	__u32	padding;
+};
+
+struct fuse_notify_poll_wakeup_out {
+	__u64	fh;
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
-- 
1.5.4.5

