Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZFCICx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZFCICx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZFCICO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:02:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46312 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbZFCICK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:02:10 -0400
To: linux-fsdevel@vger.kernel.org
CC: muirj@nortel.com, csaba@gluster.com, avati@zresearch.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] fuse: cache invalidation calls
Message-Id: <E1MBlQ6-0002V4-D7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 03 Jun 2009 10:01:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John, thanks for the patch.  If no problems are found I'd like to add
it to the 2.6.31 queue.

Csaba, Anand, does this meet your requirements?

Other comments?

Thanks,
Miklos

---
From: John Muir <muirj@nortel.com>

Add notification messages that allow the filesystem to invalidate VFS
caches.  This is a much requested feature in FUSE.

Two notifications are added:

 1) inode invalidation

   - invalidate cached attributes
   - invalidate a range of pages in the page cache (this is optional)

 2) dentry invalidation

   - try to invalidate a subtree in the dentry cache

Care must be taken while accessing the 'struct super_block' for the
mount, as it can go away while an invalidation is in progress.  To
prevent this, introduce a rw-semaphore, that is taken for read during
the invalidation and taken for write in the ->kill_sb callback.

Cc: Csaba Henk <csaba@gluster.com>
Cc: Anand Avati <avati@zresearch.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dev.c        |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dir.c        |   37 +++++++++++++++++++++++
 fs/fuse/fuse_i.h     |   24 +++++++++++++++
 fs/fuse/inode.c      |   59 +++++++++++++++++++++++++++++++++++--
 include/linux/fuse.h |   16 ++++++++++
 5 files changed, 214 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/fuse/dev.c
===================================================================
--- linux-2.6.orig/fs/fuse/dev.c	2009-06-02 16:20:59.000000000 +0200
+++ linux-2.6/fs/fuse/dev.c	2009-06-02 16:21:23.000000000 +0200
@@ -849,6 +849,81 @@ err:
 	return err;
 }
 
+static int fuse_notify_inval_inode(struct fuse_conn *fc, unsigned int size,
+				   struct fuse_copy_state *cs)
+{
+	struct fuse_notify_inval_inode_out outarg;
+	int err = -EINVAL;
+
+	if (size != sizeof(outarg))
+		goto err;
+
+	err = fuse_copy_one(cs, &outarg, sizeof(outarg));
+	if (err)
+		goto err;
+	fuse_copy_finish(cs);
+
+	down_read(&fc->killsb);
+	err = -ENOENT;
+	if (!fc->sb)
+		goto err_unlock;
+
+	err = fuse_reverse_inval_inode(fc->sb, outarg.ino,
+				       outarg.off, outarg.len);
+
+err_unlock:
+	up_read(&fc->killsb);
+	return err;
+
+err:
+	fuse_copy_finish(cs);
+	return err;
+}
+
+static int fuse_notify_inval_entry(struct fuse_conn *fc, unsigned int size,
+				   struct fuse_copy_state *cs)
+{
+	struct fuse_notify_inval_entry_out outarg;
+	int err = -EINVAL;
+	char buf[FUSE_NAME_MAX+1];
+	struct qstr name;
+
+	if (size < sizeof(outarg))
+		goto err;
+
+	err = fuse_copy_one(cs, &outarg, sizeof(outarg));
+	if (err)
+		goto err;
+
+	err = -ENAMETOOLONG;
+	if (outarg.namelen > FUSE_NAME_MAX)
+		goto err;
+
+	name.name = buf;
+	name.len = outarg.namelen;
+	err = fuse_copy_one(cs, buf, outarg.namelen + 1);
+	if (err)
+		goto err;
+	fuse_copy_finish(cs);
+	buf[outarg.namelen] = 0;
+	name.hash = full_name_hash(name.name, name.len);
+
+	down_read(&fc->killsb);
+	err = -ENOENT;
+	if (!fc->sb)
+		goto err_unlock;
+
+	err = fuse_reverse_inval_entry(fc->sb, outarg.parent, &name);
+
+err_unlock:
+	up_read(&fc->killsb);
+	return err;
+
+err:
+	fuse_copy_finish(cs);
+	return err;
+}
+
 static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 		       unsigned int size, struct fuse_copy_state *cs)
 {
@@ -856,6 +931,12 @@ static int fuse_notify(struct fuse_conn
 	case FUSE_NOTIFY_POLL:
 		return fuse_notify_poll(fc, size, cs);
 
+	case FUSE_NOTIFY_INVAL_INODE:
+		return fuse_notify_inval_inode(fc, size, cs);
+
+	case FUSE_NOTIFY_INVAL_ENTRY:
+		return fuse_notify_inval_entry(fc, size, cs);
+
 	default:
 		fuse_copy_finish(cs);
 		return -EINVAL;
Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2009-06-02 16:20:59.000000000 +0200
+++ linux-2.6/fs/fuse/dir.c	2009-06-02 16:21:23.000000000 +0200
@@ -845,6 +845,43 @@ int fuse_update_attributes(struct inode
 	return err;
 }
 
+int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
+			     struct qstr *name)
+{
+	int err = -ENOTDIR;
+	struct inode *parent;
+	struct dentry *dir;
+	struct dentry *entry;
+
+	parent = ilookup5(sb, parent_nodeid, fuse_inode_eq, &parent_nodeid);
+	if (!parent)
+		return -ENOENT;
+
+	mutex_lock(&parent->i_mutex);
+	if (!S_ISDIR(parent->i_mode))
+		goto unlock;
+
+	err = -ENOENT;
+	dir = d_find_alias(parent);
+	if (!dir)
+		goto unlock;
+
+	entry = d_lookup(dir, name);
+	dput(dir);
+	if (!entry)
+		goto unlock;
+
+	fuse_invalidate_attr(parent);
+	fuse_invalidate_entry(entry);
+	dput(entry);
+	err = 0;
+
+ unlock:
+	mutex_unlock(&parent->i_mutex);
+	iput(parent);
+	return err;
+}
+
 /*
  * Calling into a user-controlled filesystem gives the filesystem
  * daemon ptrace-like capabilities over the requester process.  This
Index: linux-2.6/fs/fuse/fuse_i.h
===================================================================
--- linux-2.6.orig/fs/fuse/fuse_i.h	2009-06-02 16:20:59.000000000 +0200
+++ linux-2.6/fs/fuse/fuse_i.h	2009-06-02 16:21:23.000000000 +0200
@@ -481,6 +481,12 @@ struct fuse_conn {
 
 	/** Called on final put */
 	void (*release)(struct fuse_conn *);
+
+	/** Super block for this connection. */
+	struct super_block *sb;
+
+	/** Read/write semaphore to hold when accessing sb. */
+	struct rw_semaphore killsb;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
@@ -509,6 +515,11 @@ extern const struct file_operations fuse
 extern const struct dentry_operations fuse_dentry_operations;
 
 /**
+ * Inode to nodeid comparison.
+ */
+int fuse_inode_eq(struct inode *inode, void *_nodeidp);
+
+/**
  * Get a filled in inode
  */
 struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
@@ -708,6 +719,19 @@ void fuse_release_nowrite(struct inode *
 
 u64 fuse_get_attr_version(struct fuse_conn *fc);
 
+/**
+ * File-system tells the kernel to invalidate cache for the given node id.
+ */
+int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
+			     loff_t offset, loff_t len);
+
+/**
+ * File-system tells the kernel to invalidate parent attributes and
+ * the dentry matching parent/name.
+ */
+int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
+			     struct qstr *name);
+
 int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir);
 ssize_t fuse_direct_io(struct file *file, const char __user *buf,
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2009-06-02 16:20:59.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2009-06-02 16:21:23.000000000 +0200
@@ -207,7 +207,7 @@ static void fuse_init_inode(struct inode
 		BUG();
 }
 
-static int fuse_inode_eq(struct inode *inode, void *_nodeidp)
+int fuse_inode_eq(struct inode *inode, void *_nodeidp)
 {
 	u64 nodeid = *(u64 *) _nodeidp;
 	if (get_node_id(inode) == nodeid)
@@ -258,6 +258,31 @@ struct inode *fuse_iget(struct super_blo
 	return inode;
 }
 
+int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
+			     loff_t offset, loff_t len)
+{
+	struct inode *inode;
+	pgoff_t pg_start;
+	pgoff_t pg_end;
+
+	inode = ilookup5(sb, nodeid, fuse_inode_eq, &nodeid);
+	if (!inode)
+		return -ENOENT;
+
+	fuse_invalidate_attr(inode);
+	if (offset >= 0) {
+		pg_start = offset >> PAGE_CACHE_SHIFT;
+		if (len <= 0)
+			pg_end = -1;
+		else
+			pg_end = (offset + len - 1) >> PAGE_CACHE_SHIFT;
+		invalidate_inode_pages2_range(inode->i_mapping,
+					      pg_start, pg_end);
+	}
+	iput(inode);
+	return 0;
+}
+
 static void fuse_umount_begin(struct super_block *sb)
 {
 	lock_kernel();
@@ -483,6 +508,7 @@ void fuse_conn_init(struct fuse_conn *fc
 	memset(fc, 0, sizeof(*fc));
 	spin_lock_init(&fc->lock);
 	mutex_init(&fc->inst_mutex);
+	init_rwsem(&fc->killsb);
 	atomic_set(&fc->count, 1);
 	init_waitqueue_head(&fc->waitq);
 	init_waitqueue_head(&fc->blocked_waitq);
@@ -863,6 +889,7 @@ static int fuse_fill_super(struct super_
 	fuse_conn_init(fc);
 
 	fc->dev = sb->s_dev;
+	fc->sb = sb;
 	err = fuse_bdi_init(fc, sb);
 	if (err)
 		goto err_put_conn;
@@ -944,12 +971,25 @@ static int fuse_get_sb(struct file_syste
 	return get_sb_nodev(fs_type, flags, raw_data, fuse_fill_super, mnt);
 }
 
+static void fuse_kill_sb_anon(struct super_block *sb)
+{
+	struct fuse_conn *fc = get_fuse_conn_super(sb);
+
+	if (fc) {
+		down_write(&fc->killsb);
+		fc->sb = NULL;
+		up_write(&fc->killsb);
+	}
+
+	kill_anon_super(sb);
+}
+
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
 	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
-	.kill_sb	= kill_anon_super,
+	.kill_sb	= fuse_kill_sb_anon,
 };
 
 #ifdef CONFIG_BLOCK
@@ -961,11 +1001,24 @@ static int fuse_get_sb_blk(struct file_s
 			   mnt);
 }
 
+static void fuse_kill_sb_blk(struct super_block *sb)
+{
+	struct fuse_conn *fc = get_fuse_conn_super(sb);
+
+	if (fc) {
+		down_write(&fc->killsb);
+		fc->sb = NULL;
+		up_write(&fc->killsb);
+	}
+
+	kill_block_super(sb);
+}
+
 static struct file_system_type fuseblk_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuseblk",
 	.get_sb		= fuse_get_sb_blk,
-	.kill_sb	= kill_block_super,
+	.kill_sb	= fuse_kill_sb_blk,
 	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
 };
 
Index: linux-2.6/include/linux/fuse.h
===================================================================
--- linux-2.6.orig/include/linux/fuse.h	2009-06-02 16:20:59.000000000 +0200
+++ linux-2.6/include/linux/fuse.h	2009-06-02 16:21:23.000000000 +0200
@@ -25,6 +25,8 @@
  *  - add IOCTL message
  *  - add unsolicited notification support
  *  - add POLL message and NOTIFY_POLL notification
+ *  - add notification messages for invalidation of inodes and
+ *    directory entries
  */
 
 #ifndef _LINUX_FUSE_H
@@ -224,6 +226,8 @@ enum fuse_opcode {
 
 enum fuse_notify_code {
 	FUSE_NOTIFY_POLL   = 1,
+	FUSE_NOTIFY_INVAL_INODE = 2,
+	FUSE_NOTIFY_INVAL_ENTRY = 3,
 	FUSE_NOTIFY_CODE_MAX,
 };
 
@@ -508,4 +512,16 @@ struct fuse_dirent {
 #define FUSE_DIRENT_SIZE(d) \
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET + (d)->namelen)
 
+struct fuse_notify_inval_inode_out {
+	__u64	ino;
+	__s64	off;
+	__s64	len;
+};
+
+struct fuse_notify_inval_entry_out {
+	__u64	parent;
+	__u32	namelen;
+	__u32	padding;
+};
+
 #endif /* _LINUX_FUSE_H */
