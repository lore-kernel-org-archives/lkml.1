Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbXJLQIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbXJLQIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbXJLQF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:05:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760097AbXJLQFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:05:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/52] CRED: Prepare RAMFS for cred passing
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:50 +0100
Message-ID: <20071012160550.15119.87511.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare RAMFS for cred passing.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ramfs/inode.c      |   16 ++++++++++------
 include/linux/ramfs.h |    3 ++-
 mm/tiny-shmem.c       |    3 ++-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index fe3642a..29100e2 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -49,14 +49,15 @@ static struct backing_dev_info ramfs_backing_dev_info = {
 			  BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP,
 };
 
-struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
+struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev,
+			      struct cred *cred)
 {
 	struct inode * inode = new_inode(sb);
 
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->cred->uid;
-		inode->i_gid = current->cred->gid;
+		inode->i_uid = cred->uid;
+		inode->i_gid = cred->gid;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
@@ -92,7 +93,8 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 static int
 ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
-	struct inode * inode = ramfs_get_inode(dir->i_sb, mode, dev);
+	struct cred *cred = current->cred;
+	struct inode * inode = ramfs_get_inode(dir->i_sb, mode, dev, cred);
 	int error = -ENOSPC;
 
 	if (inode) {
@@ -124,10 +126,11 @@ static int ramfs_create(struct inode *dir, struct dentry *dentry, int mode, stru
 
 static int ramfs_symlink(struct inode * dir, struct dentry *dentry, const char * symname)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode;
 	int error = -ENOSPC;
 
-	inode = ramfs_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);
+	inode = ramfs_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0, cred);
 	if (inode) {
 		int l = strlen(symname)+1;
 		error = page_symlink(inode, symname, l);
@@ -162,6 +165,7 @@ static const struct super_operations ramfs_ops = {
 
 static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 {
+	struct cred *cred = current->cred;
 	struct inode * inode;
 	struct dentry * root;
 
@@ -171,7 +175,7 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 	sb->s_magic = RAMFS_MAGIC;
 	sb->s_op = &ramfs_ops;
 	sb->s_time_gran = 1;
-	inode = ramfs_get_inode(sb, S_IFDIR | 0755, 0);
+	inode = ramfs_get_inode(sb, S_IFDIR | 0755, 0, cred);
 	if (!inode)
 		return -ENOMEM;
 
diff --git a/include/linux/ramfs.h b/include/linux/ramfs.h
index b160fb1..124b0c3 100644
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -1,7 +1,8 @@
 #ifndef _LINUX_RAMFS_H
 #define _LINUX_RAMFS_H
 
-struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev);
+struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev,
+			      struct cred *cred);
 extern int ramfs_get_sb(struct file_system_type *fs_type,
 	 int flags, const char *dev_name, void *data, struct vfsmount *mnt);
 
diff --git a/mm/tiny-shmem.c b/mm/tiny-shmem.c
index 8803471..3d4d602 100644
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -48,6 +48,7 @@ module_init(init_tmpfs)
  */
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 {
+	struct cred *cred = current->cred;
 	int error;
 	struct file *file;
 	struct inode *inode;
@@ -72,7 +73,7 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 		goto put_dentry;
 
 	error = -ENOSPC;
-	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
+	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0, cred);
 	if (!inode)
 		goto close_file;
 

