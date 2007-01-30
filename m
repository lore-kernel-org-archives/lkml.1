Return-Path: <linux-kernel-owner+w=401wt.eu-S1751062AbXA3Pir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbXA3Pir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXA3Pir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:38:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbXA3Pip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:38:45 -0500
Date: Tue, 30 Jan 2007 10:38:16 -0500
Message-Id: <200701301538.l0UFcGNX027715@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 1/2] add lazy_getattr and lazy_readdir patches that defer i_ino assignment
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dada1@cosmosbay.com, dev@openvz.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 2 new libfs functions that allow for us to defer assignment of
an i_ino value until such time that it's actually used. This allows us to
ensure uniqueness without actually impacting the cases that don't really care
about it. With this i_ino == 0 has a special meaning of "unassigned".

I have 2 things I'm not sure of with this patch. The first is the #defined
value for MAX_RESERVED_INODE. I'm not thrilled with that, but didn't see a way
to pass in a max_reserved value for iunique through the standard filesystem
call (maybe we could hang the value off of the superblock, but I kind of
don't like doing that either).

The other thing I'm not sure of is whether the locking I'm doing in case 1 of
__dcache_readdir (where I replace the parent_ino call) is correct.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/libfs.c b/fs/libfs.c
index 9b77f89..f6cd382 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -11,6 +11,17 @@
 
 #include <asm/uaccess.h>
 
+/* highest inode number that should be assigned by simple_fill_super */
+#define MAX_RESERVED_INODE 100
+
+static inline void lazy_hash_inode(struct inode *inode)
+{
+	if (unlikely(inode->i_ino == 0)) {
+		inode->i_ino = iunique(inode->i_sb, MAX_RESERVED_INODE);
+		insert_inode_hash(inode);
+	}
+}
+
 int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		   struct kstat *stat)
 {
@@ -20,6 +31,13 @@ int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
+int lazy_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		   struct kstat *stat)
+{
+	lazy_hash_inode(dentry->d_inode);
+	return simple_getattr(mnt, dentry, stat);
+}
+
 int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	buf->f_type = dentry->d_sb->s_magic;
@@ -124,24 +142,34 @@ static inline unsigned char dt_type(struct inode *inode)
  * both impossible due to the lock on directory.
  */
 
-int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
+static int __dcache_readdir(struct file * filp, void * dirent,
+			    filldir_t filldir, bool lazy)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct dentry *cursor = filp->private_data;
+	struct inode *inode;
 	struct list_head *p, *q = &cursor->d_u.d_child;
 	ino_t ino;
 	int i = filp->f_pos;
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			inode = dentry->d_inode;
+			if (lazy)
+				lazy_hash_inode(inode);
+			ino = inode->i_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
 			i++;
 			/* fallthrough */
 		case 1:
-			ino = parent_ino(dentry);
+			spin_lock(&dentry->d_lock);
+			inode = dentry->d_parent->d_inode;
+			spin_unlock(&dentry->d_lock);
+			if (lazy)
+				lazy_hash_inode(inode);
+			ino = inode->i_ino;
 			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -155,11 +183,17 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				if (d_unhashed(next) || !next->d_inode)
+				inode = next->d_inode;
+				if (d_unhashed(next) || !inode)
 					continue;
 
 				spin_unlock(&dcache_lock);
-				if (filldir(dirent, next->d_name.name, next->d_name.len, filp->f_pos, next->d_inode->i_ino, dt_type(next->d_inode)) < 0)
+
+				if (lazy)
+					lazy_hash_inode(inode);
+				if (filldir(dirent, next->d_name.name,
+					    next->d_name.len, filp->f_pos,
+					    inode->i_ino, dt_type(inode)) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
 				/* next is still alive */
@@ -172,6 +206,16 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	return 0;
 }
 
+int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
+{
+	return __dcache_readdir(filp, dirent, filldir, false);
+}
+
+int lazy_readdir(struct file * filp, void * dirent, filldir_t filldir)
+{
+	return __dcache_readdir(filp, dirent, filldir, true);
+}
+
 ssize_t generic_read_dir(struct file *filp, char __user *buf, size_t siz, loff_t *ppos)
 {
 	return -EISDIR;
@@ -634,6 +678,7 @@ EXPORT_SYMBOL(dcache_dir_close);
 EXPORT_SYMBOL(dcache_dir_lseek);
 EXPORT_SYMBOL(dcache_dir_open);
 EXPORT_SYMBOL(dcache_readdir);
+EXPORT_SYMBOL(lazy_readdir);
 EXPORT_SYMBOL(generic_read_dir);
 EXPORT_SYMBOL(get_sb_pseudo);
 EXPORT_SYMBOL(simple_commit_write);
@@ -643,6 +688,7 @@ EXPORT_SYMBOL(simple_empty);
 EXPORT_SYMBOL(d_alloc_name);
 EXPORT_SYMBOL(simple_fill_super);
 EXPORT_SYMBOL(simple_getattr);
+EXPORT_SYMBOL(lazy_getattr);
 EXPORT_SYMBOL(simple_link);
 EXPORT_SYMBOL(simple_lookup);
 EXPORT_SYMBOL(simple_pin_fs);
