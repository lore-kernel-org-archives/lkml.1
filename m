Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbXJLQTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbXJLQTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbXJLQHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbXJLQHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/52] CRED: Give the mkdir() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:32 +0100
Message-ID: <20071012160732.15119.34337.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the mkdir() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c       |    6 ++++--
 fs/autofs4/root.c  |    5 +++--
 fs/bad_inode.c     |    2 +-
 fs/ext2/namei.c    |    4 ++--
 fs/ext3/namei.c    |    4 ++--
 fs/ext4/namei.c    |    4 ++--
 fs/namei.c         |    3 ++-
 fs/nfs/dir.c       |    6 +++---
 fs/ramfs/inode.c   |    4 ++--
 fs/vfat/namei.c    |    3 ++-
 include/linux/fs.h |    2 +-
 mm/shmem.c         |    4 ++--
 12 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index f861d08..ccc09f1 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -30,7 +30,8 @@ static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
 				  loff_t fpos, u64 ino, unsigned dtype);
 static int afs_create(struct inode *dir, struct dentry *dentry, int mode,
 		      struct nameidata *nd);
-static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+		     struct cred *cred);
 static int afs_rmdir(struct inode *dir, struct dentry *dentry);
 static int afs_unlink(struct inode *dir, struct dentry *dentry);
 static int afs_link(struct dentry *from, struct inode *dir,
@@ -721,7 +722,8 @@ static void afs_d_release(struct dentry *dentry)
 /*
  * create a directory on an AFS filesystem
  */
-static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+		     struct cred *cred)
 {
 	struct afs_file_status status;
 	struct afs_callback cb;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 45ff3d6..63c0b62 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -22,7 +22,7 @@
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *);
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
-static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
+static int autofs4_dir_mkdir(struct inode *,struct dentry *,int, struct cred *);
 static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static int autofs4_dir_close(struct inode *inode, struct file *file);
@@ -829,7 +829,8 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	return 0;
 }
 
-static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+			     struct cred *cred)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 7df0a7c..4b7e6b1 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -215,7 +215,7 @@ static int bad_inode_symlink (struct inode *dir, struct dentry *dentry,
 }
 
 static int bad_inode_mkdir(struct inode *dir, struct dentry *dentry,
-			int mode)
+			int mode, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index f539ee0..333330d 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -208,9 +208,9 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 	return ext2_add_nondir(dentry, inode);
 }
 
-static int ext2_mkdir(struct inode * dir, struct dentry * dentry, int mode)
+static int ext2_mkdir(struct inode * dir, struct dentry * dentry, int mode,
+		      struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode * inode;
 	int err = -EMLINK;
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 54f997d..f02cb17 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1787,9 +1787,9 @@ retry:
 	return err;
 }
 
-static int ext3_mkdir(struct inode * dir, struct dentry * dentry, int mode)
+static int ext3_mkdir(struct inode * dir, struct dentry * dentry, int mode,
+		      struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	struct buffer_head * dir_block;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 54530e7..539456c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1816,9 +1816,9 @@ retry:
 	return err;
 }
 
-static int ext4_mkdir(struct inode * dir, struct dentry * dentry, int mode)
+static int ext4_mkdir(struct inode * dir, struct dentry * dentry, int mode,
+		      struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	struct buffer_head * dir_block;
diff --git a/fs/namei.c b/fs/namei.c
index 5ff42f1..ca2ccb1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1969,6 +1969,7 @@ asmlinkage long sys_mknod(const char __user *filename, int mode, unsigned dev)
 
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
+	struct cred *cred = current->cred;
 	int error = may_create(dir, dentry, NULL);
 
 	if (error)
@@ -1983,7 +1984,7 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return error;
 
 	DQUOT_INIT(dir);
-	error = dir->i_op->mkdir(dir, dentry, mode);
+	error = dir->i_op->mkdir(dir, dentry, mode, cred);
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
 	return error;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 35bbaf6..98fccc1 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -45,7 +45,7 @@ static int nfs_opendir(struct inode *, struct file *);
 static int nfs_readdir(struct file *, void *, filldir_t);
 static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameidata *);
 static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *);
-static int nfs_mkdir(struct inode *, struct dentry *, int);
+static int nfs_mkdir(struct inode *, struct dentry *, int, struct cred *);
 static int nfs_rmdir(struct inode *, struct dentry *);
 static int nfs_unlink(struct inode *, struct dentry *);
 static int nfs_symlink(struct inode *, struct dentry *, const char *);
@@ -1319,9 +1319,9 @@ out_err:
 /*
  * See comments for nfs_proc_create regarding failed operations.
  */
-static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int nfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+		     struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct iattr attr;
 	int error;
 
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index f9e6244..0e3142b 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -111,9 +111,9 @@ ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev,
 	return error;
 }
 
-static int ramfs_mkdir(struct inode * dir, struct dentry * dentry, int mode)
+static int ramfs_mkdir(struct inode * dir, struct dentry * dentry, int mode,
+		       struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	int retval = ramfs_mknod(dir, dentry, mode | S_IFDIR, 0, cred);
 	if (!retval)
 		inc_nlink(dir);
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index cd450be..132601d 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -817,7 +817,8 @@ out:
 	return err;
 }
 
-static int vfat_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int vfat_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+		      struct cred *cred)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a8d2d26..69d7fcc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1140,7 +1140,7 @@ struct inode_operations {
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
-	int (*mkdir) (struct inode *,struct dentry *,int);
+	int (*mkdir) (struct inode *,struct dentry *,int, struct cred *);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t, struct cred *);
 	int (*rename) (struct inode *, struct dentry *,
diff --git a/mm/shmem.c b/mm/shmem.c
index 62ae312..e69691a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1740,9 +1740,9 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev,
 	return error;
 }
 
-static int shmem_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int shmem_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+		       struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	int error;
 
 	if ((error = shmem_mknod(dir, dentry, mode | S_IFDIR, 0, cred)))

