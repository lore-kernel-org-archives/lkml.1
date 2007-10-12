Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbXJLQTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbXJLQTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760182AbXJLQHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758643AbXJLQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/52] CRED: Give the create() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:37 +0100
Message-ID: <20071012160737.15119.32906.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the create() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c       |    4 ++--
 fs/bad_inode.c     |    2 +-
 fs/ext3/namei.c    |    3 +--
 fs/namei.c         |    3 ++-
 fs/nfs/dir.c       |    6 +++---
 fs/ramfs/inode.c   |    4 ++--
 fs/vfat/namei.c    |    2 +-
 include/linux/fs.h |    3 ++-
 mm/shmem.c         |    3 +--
 9 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index ccc09f1..e495269 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -29,7 +29,7 @@ static void afs_d_release(struct dentry *dentry);
 static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
 				  loff_t fpos, u64 ino, unsigned dtype);
 static int afs_create(struct inode *dir, struct dentry *dentry, int mode,
-		      struct nameidata *nd);
+		      struct nameidata *nd, struct cred *cred);
 static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
 		     struct cred *cred);
 static int afs_rmdir(struct inode *dir, struct dentry *dentry);
@@ -908,7 +908,7 @@ error:
  * create a regular file on an AFS filesystem
  */
 static int afs_create(struct inode *dir, struct dentry *dentry, int mode,
-		      struct nameidata *nd)
+		      struct nameidata *nd, struct cred *cred)
 {
 	struct afs_file_status status;
 	struct afs_callback cb;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 4b7e6b1..3895f7d 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -186,7 +186,7 @@ static const struct file_operations bad_file_ops =
 };
 
 static int bad_inode_create (struct inode *dir, struct dentry *dentry,
-		int mode, struct nameidata *nd)
+		int mode, struct nameidata *nd, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index f02cb17..c007ef2 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1720,9 +1720,8 @@ static int ext3_add_nondir(handle_t *handle,
  * with d_instantiate().
  */
 static int ext3_create (struct inode * dir, struct dentry * dentry, int mode,
-		struct nameidata *nd)
+		struct nameidata *nd, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * inode;
 	int err, retries = 0;
diff --git a/fs/namei.c b/fs/namei.c
index ca2ccb1..ef6041a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1545,6 +1545,7 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	int error = may_create(dir, dentry, nd);
 
 	if (error)
@@ -1558,7 +1559,7 @@ int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	if (error)
 		return error;
 	DQUOT_INIT(dir);
-	error = dir->i_op->create(dir, dentry, mode, nd);
+	error = dir->i_op->create(dir, dentry, mode, nd, cred);
 	if (!error)
 		fsnotify_create(dir, dentry);
 	return error;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 98fccc1..833351e 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -44,7 +44,8 @@
 static int nfs_opendir(struct inode *, struct file *);
 static int nfs_readdir(struct file *, void *, filldir_t);
 static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameidata *);
-static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *);
+static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *,
+		      struct cred *);
 static int nfs_mkdir(struct inode *, struct dentry *, int, struct cred *);
 static int nfs_rmdir(struct inode *, struct dentry *);
 static int nfs_unlink(struct inode *, struct dentry *);
@@ -1248,9 +1249,8 @@ int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fhandle,
  * reply path made it appear to have failed.
  */
 static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct nameidata *nd, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct iattr attr;
 	int error;
 	int open_flags = 0;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 0e3142b..53e917c 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -120,9 +120,9 @@ static int ramfs_mkdir(struct inode * dir, struct dentry * dentry, int mode,
 	return retval;
 }
 
-static int ramfs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+static int ramfs_create(struct inode *dir, struct dentry *dentry, int mode,
+			struct nameidata *nd, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	return ramfs_mknod(dir, dentry, mode | S_IFREG, 0, cred);
 }
 
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index 132601d..8784b57 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -731,7 +731,7 @@ error:
 }
 
 static int vfat_create(struct inode *dir, struct dentry *dentry, int mode,
-		       struct nameidata *nd)
+		       struct nameidata *nd, struct cred *cred)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 69d7fcc..cb09038 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1135,7 +1135,8 @@ struct file_operations {
 };
 
 struct inode_operations {
-	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
+	int (*create) (struct inode *,struct dentry *,int, struct nameidata *,
+		       struct cred *);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
diff --git a/mm/shmem.c b/mm/shmem.c
index e69691a..3fff09b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1752,9 +1752,8 @@ static int shmem_mkdir(struct inode *dir, struct dentry *dentry, int mode,
 }
 
 static int shmem_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct nameidata *nd, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	return shmem_mknod(dir, dentry, mode | S_IFREG, 0, cred);
 }
 

