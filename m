Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbXJLQUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbXJLQUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXJLQHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716AbXJLQHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/52] CRED: Give the link() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:42 +0100
Message-ID: <20071012160742.15119.31887.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the link() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c       |    4 ++--
 fs/bad_inode.c     |    2 +-
 fs/ext3/namei.c    |    3 +--
 fs/libfs.c         |    3 ++-
 fs/namei.c         |    3 ++-
 fs/nfs/dir.c       |    7 ++++---
 include/linux/fs.h |    6 ++++--
 mm/shmem.c         |    3 ++-
 8 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index e495269..48f2759 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -35,7 +35,7 @@ static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
 static int afs_rmdir(struct inode *dir, struct dentry *dentry);
 static int afs_unlink(struct inode *dir, struct dentry *dentry);
 static int afs_link(struct dentry *from, struct inode *dir,
-		    struct dentry *dentry);
+		    struct dentry *dentry, struct cred *cred);
 static int afs_symlink(struct inode *dir, struct dentry *dentry,
 		       const char *content);
 static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -979,7 +979,7 @@ error:
  * create a hard link between files in an AFS filesystem
  */
 static int afs_link(struct dentry *from, struct inode *dir,
-		    struct dentry *dentry)
+		    struct dentry *dentry, struct cred *cred)
 {
 	struct afs_vnode *dvnode, *vnode;
 	struct key *key;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 3895f7d..a13970d 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -198,7 +198,7 @@ static struct dentry *bad_inode_lookup(struct inode *dir,
 }
 
 static int bad_inode_link (struct dentry *old_dentry, struct inode *dir,
-		struct dentry *dentry)
+		struct dentry *dentry, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index c007ef2..4c19acf 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2254,9 +2254,8 @@ out_stop:
 }
 
 static int ext3_link (struct dentry * old_dentry,
-		struct inode * dir, struct dentry *dentry)
+		struct inode * dir, struct dentry *dentry, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode *inode = old_dentry->d_inode;
 	int err, retries = 0;
diff --git a/fs/libfs.c b/fs/libfs.c
index 5294de1..d82eaaa 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -250,7 +250,8 @@ Enomem:
 	return -ENOMEM;
 }
 
-int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
+int simple_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry, struct cred *cred)
 {
 	struct inode *inode = old_dentry->d_inode;
 
diff --git a/fs/namei.c b/fs/namei.c
index ef6041a..51e0322 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2300,6 +2300,7 @@ asmlinkage long sys_symlink(const char __user *oldname, const char __user *newna
 
 int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
@@ -2329,7 +2330,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 
 	mutex_lock(&old_dentry->d_inode->i_mutex);
 	DQUOT_INIT(dir);
-	error = dir->i_op->link(old_dentry, dir, new_dentry);
+	error = dir->i_op->link(old_dentry, dir, new_dentry, cred);
 	mutex_unlock(&old_dentry->d_inode->i_mutex);
 	if (!error)
 		fsnotify_create(dir, new_dentry);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 833351e..4e12cf7 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -50,7 +50,8 @@ static int nfs_mkdir(struct inode *, struct dentry *, int, struct cred *);
 static int nfs_rmdir(struct inode *, struct dentry *);
 static int nfs_unlink(struct inode *, struct dentry *);
 static int nfs_symlink(struct inode *, struct dentry *, const char *);
-static int nfs_link(struct dentry *, struct inode *, struct dentry *);
+static int nfs_link(struct dentry *, struct inode *, struct dentry *,
+		    struct cred *);
 static int nfs_mknod(struct inode *, struct dentry *, int, dev_t,
 		     struct cred *);
 static int nfs_rename(struct inode *, struct dentry *,
@@ -1604,9 +1605,9 @@ static int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *sym
 }
 
 static int 
-nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
+nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry,
+	 struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cb09038..d8cecd4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1138,7 +1138,8 @@ struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *,
 		       struct cred *);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
-	int (*link) (struct dentry *,struct inode *,struct dentry *);
+	int (*link) (struct dentry *,struct inode *,struct dentry *,
+		     struct cred *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
 	int (*mkdir) (struct inode *,struct dentry *,int, struct cred *);
@@ -1794,7 +1795,8 @@ extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
 extern int dcache_readdir(struct file *, void *, filldir_t);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
-extern int simple_link(struct dentry *, struct inode *, struct dentry *);
+extern int simple_link(struct dentry *, struct inode *, struct dentry *,
+		       struct cred *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
diff --git a/mm/shmem.c b/mm/shmem.c
index 3fff09b..7358d14 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1760,7 +1760,8 @@ static int shmem_create(struct inode *dir, struct dentry *dentry, int mode,
 /*
  * Link a file..
  */
-static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
+static int shmem_link(struct dentry *old_dentry, struct inode *dir,
+		      struct dentry *dentry, struct cred *cred)
 {
 	struct inode *inode = old_dentry->d_inode;
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);

