Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXJLQRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXJLQRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760171AbXJLQHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXJLQHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/52] CRED: Give the mknod() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:27 +0100
Message-ID: <20071012160727.15119.53709.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the mknod() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/bad_inode.c     |    2 +-
 fs/ext2/namei.c    |    4 ++--
 fs/ext3/namei.c    |    3 +--
 fs/ext4/namei.c    |    3 +--
 fs/namei.c         |    3 ++-
 fs/nfs/dir.c       |    7 ++++---
 fs/ramfs/inode.c   |   10 ++++++----
 include/linux/fs.h |    2 +-
 mm/shmem.c         |   10 ++++++----
 9 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index dda2d52..7df0a7c 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -226,7 +226,7 @@ static int bad_inode_rmdir (struct inode *dir, struct dentry *dentry)
 }
 
 static int bad_inode_mknod (struct inode *dir, struct dentry *dentry,
-			int mode, dev_t rdev)
+			int mode, dev_t rdev, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 821a2c3..f539ee0 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -126,9 +126,9 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, int mode, st
 	return err;
 }
 
-static int ext2_mknod (struct inode * dir, struct dentry *dentry, int mode, dev_t rdev)
+static int ext2_mknod (struct inode * dir, struct dentry *dentry, int mode,
+		       dev_t rdev, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode * inode;
 	int err;
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4a6adaa..54f997d 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1752,9 +1752,8 @@ retry:
 }
 
 static int ext3_mknod (struct inode * dir, struct dentry *dentry,
-			int mode, dev_t rdev)
+			int mode, dev_t rdev, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode *inode;
 	int err, retries = 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index be28f73..54530e7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1781,9 +1781,8 @@ retry:
 }
 
 static int ext4_mknod (struct inode * dir, struct dentry *dentry,
-			int mode, dev_t rdev)
+			int mode, dev_t rdev, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode *inode;
 	int err, retries = 0;
diff --git a/fs/namei.c b/fs/namei.c
index 3db9a41..5ff42f1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1889,6 +1889,7 @@ EXPORT_SYMBOL_GPL(lookup_create);
 
 int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
+	struct cred *cred = current->cred;
 	int error = may_create(dir, dentry, NULL);
 
 	if (error)
@@ -1905,7 +1906,7 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 		return error;
 
 	DQUOT_INIT(dir);
-	error = dir->i_op->mknod(dir, dentry, mode, dev);
+	error = dir->i_op->mknod(dir, dentry, mode, dev, cred);
 	if (!error)
 		fsnotify_create(dir, dentry);
 	return error;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 35a63cf..35bbaf6 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -50,7 +50,8 @@ static int nfs_rmdir(struct inode *, struct dentry *);
 static int nfs_unlink(struct inode *, struct dentry *);
 static int nfs_symlink(struct inode *, struct dentry *, const char *);
 static int nfs_link(struct dentry *, struct inode *, struct dentry *);
-static int nfs_mknod(struct inode *, struct dentry *, int, dev_t);
+static int nfs_mknod(struct inode *, struct dentry *, int, dev_t,
+		     struct cred *);
 static int nfs_rename(struct inode *, struct dentry *,
 		      struct inode *, struct dentry *);
 static int nfs_fsync_dir(struct file *, struct dentry *, int);
@@ -1284,9 +1285,9 @@ out_err:
  * See comments for nfs_proc_create regarding failed operations.
  */
 static int
-nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
+nfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev,
+	  struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct iattr attr;
 	int status;
 
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 29100e2..f9e6244 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -91,9 +91,9 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev,
  */
 /* SMP-safe */
 static int
-ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev,
+	    struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode * inode = ramfs_get_inode(dir->i_sb, mode, dev, cred);
 	int error = -ENOSPC;
 
@@ -113,7 +113,8 @@ ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 
 static int ramfs_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 {
-	int retval = ramfs_mknod(dir, dentry, mode | S_IFDIR, 0);
+	struct cred *cred = current->cred;
+	int retval = ramfs_mknod(dir, dentry, mode | S_IFDIR, 0, cred);
 	if (!retval)
 		inc_nlink(dir);
 	return retval;
@@ -121,7 +122,8 @@ static int ramfs_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 
 static int ramfs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
 {
-	return ramfs_mknod(dir, dentry, mode | S_IFREG, 0);
+	struct cred *cred = current->cred;
+	return ramfs_mknod(dir, dentry, mode | S_IFREG, 0, cred);
 }
 
 static int ramfs_symlink(struct inode * dir, struct dentry *dentry, const char * symname)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 10245c6..a8d2d26 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1142,7 +1142,7 @@ struct inode_operations {
 	int (*symlink) (struct inode *,struct dentry *,const char *);
 	int (*mkdir) (struct inode *,struct dentry *,int);
 	int (*rmdir) (struct inode *,struct dentry *);
-	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
+	int (*mknod) (struct inode *,struct dentry *,int,dev_t, struct cred *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
diff --git a/mm/shmem.c b/mm/shmem.c
index ccab183..62ae312 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1707,9 +1707,9 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
  * File creation. Allocate an inode, and we're done..
  */
 static int
-shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev,
+	    struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = shmem_get_inode(dir->i_sb, mode, dev, cred);
 	int error = -ENOSPC;
 
@@ -1742,9 +1742,10 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 
 static int shmem_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
+	struct cred *cred = current->cred;
 	int error;
 
-	if ((error = shmem_mknod(dir, dentry, mode | S_IFDIR, 0)))
+	if ((error = shmem_mknod(dir, dentry, mode | S_IFDIR, 0, cred)))
 		return error;
 	inc_nlink(dir);
 	return 0;
@@ -1753,7 +1754,8 @@ static int shmem_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 static int shmem_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
-	return shmem_mknod(dir, dentry, mode | S_IFREG, 0);
+	struct cred *cred = current->cred;
+	return shmem_mknod(dir, dentry, mode | S_IFREG, 0, cred);
 }
 
 /*

