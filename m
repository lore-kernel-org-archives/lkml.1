Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbYEOTzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbYEOTzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762728AbYEOTvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57981 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758385AbYEOTvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:32 -0400
Message-Id: <20080515195110.415090825@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:25 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 6/9] fuse: add export operations
Content-Disposition: inline; filename=fuse_nfs_export.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Implement export_operations, to allow fuse filesystems to be exported
to NFS.  This feature has been in the out-of-tree fuse module, and is
widely used and tested.

It has not been originally merged into mainline, because doing the NFS
export in userspace was thought to be a cleaner and more efficient way
of doing it, than through the kernel.

While that is true, it would also have involved a lot of duplicated
effort at reimplementing NFS exporting (all the different versions of
the protocol).  This effort was unfortunately not undertaken by
anyone, so we are left with doing it the easy but less efficient way.

If this feature goes in, the out-of-tree fuse module can go away,
which would have several advantages:

  - not having to maintain two versions
  - less confusion for users
  - no bugs due to kernel API changes

Comment from hch:
 - Use the same fh_type values as XFS, since we use the same fh encoding.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c    |    4 -
 fs/fuse/fuse_i.h |    4 +
 fs/fuse/inode.c  |  115 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2008-05-15 15:19:33.000000000 +0200
+++ linux-2.6/fs/fuse/dir.c	2008-05-15 15:40:24.000000000 +0200
@@ -97,7 +97,7 @@ void fuse_invalidate_attr(struct inode *
  * timeout is unknown (unlink, rmdir, rename and in some cases
  * lookup)
  */
-static void fuse_invalidate_entry_cache(struct dentry *entry)
+void fuse_invalidate_entry_cache(struct dentry *entry)
 {
 	fuse_dentry_settime(entry, 0);
 }
@@ -225,7 +225,7 @@ static int invalid_nodeid(u64 nodeid)
 	return !nodeid || nodeid == FUSE_ROOT_ID;
 }
 
-static struct dentry_operations fuse_dentry_operations = {
+struct dentry_operations fuse_dentry_operations = {
 	.d_revalidate	= fuse_dentry_revalidate,
 };
 
Index: linux-2.6/fs/fuse/fuse_i.h
===================================================================
--- linux-2.6.orig/fs/fuse/fuse_i.h	2008-05-15 15:19:29.000000000 +0200
+++ linux-2.6/fs/fuse/fuse_i.h	2008-05-15 15:40:24.000000000 +0200
@@ -464,6 +464,8 @@ static inline u64 get_node_id(struct ino
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
+extern struct dentry_operations fuse_dentry_operations;
+
 /**
  * Get a filled in inode
  */
@@ -604,6 +606,8 @@ void fuse_abort_conn(struct fuse_conn *f
  */
 void fuse_invalidate_attr(struct inode *inode);
 
+void fuse_invalidate_entry_cache(struct dentry *entry);
+
 /**
  * Acquire reference to fuse_conn
  */
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2008-05-15 15:19:29.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2008-05-15 15:43:59.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/statfs.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/exportfs.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -547,6 +548,119 @@ static struct inode *get_root_inode(stru
 	return fuse_iget(sb, 1, 0, &attr, 0, 0);
 }
 
+struct fuse_inode_handle
+{
+	u64 nodeid;
+	u32 generation;
+};
+
+static struct dentry *fuse_get_dentry(struct super_block *sb,
+				      struct fuse_inode_handle *handle)
+{
+	struct inode *inode;
+	struct dentry *entry;
+	int err = -ESTALE;
+
+	if (handle->nodeid == 0)
+		goto out_err;
+
+	inode = ilookup5(sb, handle->nodeid, fuse_inode_eq, &handle->nodeid);
+	if (!inode)
+		goto out_err;
+	err = -ESTALE;
+	if (inode->i_generation != handle->generation)
+		goto out_iput;
+
+	entry = d_alloc_anon(inode);
+	err = -ENOMEM;
+	if (!entry)
+		goto out_iput;
+
+	if (get_node_id(inode) != FUSE_ROOT_ID) {
+		entry->d_op = &fuse_dentry_operations;
+		fuse_invalidate_entry_cache(entry);
+	}
+
+	return entry;
+
+ out_iput:
+	iput(inode);
+ out_err:
+	return ERR_PTR(err);
+}
+
+static int fuse_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
+			   int connectable)
+{
+	struct inode *inode = dentry->d_inode;
+	bool encode_parent = connectable && !S_ISDIR(inode->i_mode);
+	int len = encode_parent ? 6 : 3;
+	u64 nodeid;
+	u32 generation;
+
+	if (*max_len < len)
+		return  255;
+
+	nodeid = get_fuse_inode(inode)->nodeid;
+	generation = inode->i_generation;
+
+	fh[0] = (u32)(nodeid >> 32);
+	fh[1] = (u32)(nodeid & 0xffffffff);
+	fh[2] = generation;
+
+	if (encode_parent) {
+		struct inode *parent;
+
+		spin_lock(&dentry->d_lock);
+		parent = dentry->d_parent->d_inode;
+		nodeid = get_fuse_inode(parent)->nodeid;
+		generation = parent->i_generation;
+		spin_unlock(&dentry->d_lock);
+
+		fh[3] = (u32)(nodeid >> 32);
+		fh[4] = (u32)(nodeid & 0xffffffff);
+		fh[5] = generation;
+	}
+
+	*max_len = len;
+	return encode_parent ? 0x82 : 0x81;
+}
+
+static struct dentry *fuse_fh_to_dentry(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	struct fuse_inode_handle handle;
+
+	if ((fh_type != 0x81 && fh_type != 0x82) || fh_len < 3)
+		return NULL;
+
+	handle.nodeid = (u64) fid->raw[0] << 32;
+	handle.nodeid |= (u64) fid->raw[1];
+	handle.generation = fid->raw[2];
+	return fuse_get_dentry(sb, &handle);
+}
+
+static struct dentry *fuse_fh_to_parent(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	struct fuse_inode_handle parent;
+
+	if (fh_type != 0x82 || fh_len < 6)
+		return NULL;
+
+	parent.nodeid = (u64) fid->raw[3] << 32;
+	parent.nodeid |= (u64) fid->raw[4];
+	parent.generation = fid->raw[5];
+	return fuse_get_dentry(sb, &parent);
+}
+
+
+static const struct export_operations fuse_export_operations = {
+	.fh_to_dentry	= fuse_fh_to_dentry,
+	.fh_to_parent	= fuse_fh_to_parent,
+	.encode_fh	= fuse_encode_fh,
+};
+
 static const struct super_operations fuse_super_operations = {
 	.alloc_inode    = fuse_alloc_inode,
 	.destroy_inode  = fuse_destroy_inode,
@@ -647,6 +761,7 @@ static int fuse_fill_super(struct super_
 	sb->s_magic = FUSE_SUPER_MAGIC;
 	sb->s_op = &fuse_super_operations;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_export_op = &fuse_export_operations;
 
 	file = fget(d.fd);
 	if (!file)

--
