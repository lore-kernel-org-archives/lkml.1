Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbXJLQVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbXJLQVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbXJLQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760266AbXJLQIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/52] CRED: Give the rename() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:57 +0100
Message-ID: <20071012160757.15119.85145.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the rename() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c       |    6 ++++--
 fs/bad_inode.c     |    3 ++-
 fs/ext3/namei.c    |    4 ++--
 fs/libfs.c         |    5 ++---
 fs/namei.c         |    8 ++++++--
 fs/nfs/dir.c       |    6 +++---
 fs/vfat/namei.c    |    3 ++-
 include/linux/fs.h |    6 ++++--
 mm/shmem.c         |    5 +++--
 9 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9f2c214..5f4ac2e 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -41,7 +41,8 @@ static int afs_link(struct dentry *from, struct inode *dir,
 static int afs_symlink(struct inode *dir, struct dentry *dentry,
 		       const char *content);
 static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry);
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      struct cred *cred);
 
 const struct file_operations afs_dir_file_operations = {
 	.open		= afs_dir_open,
@@ -1103,7 +1104,8 @@ error:
  * rename a file in an AFS filesystem and/or move it between directories
  */
 static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      struct cred *cred)
 {
 	struct afs_vnode *orig_dvnode, *new_dvnode, *vnode;
 	struct key *key;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 79d8856..2511f29 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -234,7 +234,8 @@ static int bad_inode_mknod (struct inode *dir, struct dentry *dentry,
 }
 
 static int bad_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index b54b60a..d682786 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2299,9 +2299,9 @@ retry:
  * higher-level routines.
  */
 static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
-			   struct inode * new_dir,struct dentry *new_dentry)
+			struct inode * new_dir, struct dentry *new_dentry,
+			struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct inode * old_inode, * new_inode;
 	struct buffer_head * old_bh, * new_bh, * dir_bh;
diff --git a/fs/libfs.c b/fs/libfs.c
index f237ef3..6b41090 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -8,7 +8,6 @@
 #include <linux/mount.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
-#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 
@@ -306,9 +305,9 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry, struct cred *cred)
 }
 
 int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		  struct inode *new_dir, struct dentry *new_dentry,
+		  struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
 
diff --git a/fs/namei.c b/fs/namei.c
index b991b32..4af97fd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2433,6 +2433,7 @@ asmlinkage long sys_link(const char __user *oldname, const char __user *newname)
 static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry)
 {
+	struct cred *cred = current->cred;
 	int error = 0;
 	struct inode *target;
 
@@ -2458,7 +2459,8 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
 		error = -EBUSY;
 	else 
-		error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
+		error = old_dir->i_op->rename(old_dir, old_dentry,
+					      new_dir, new_dentry, cred);
 	if (target) {
 		if (!error)
 			target->i_flags |= S_DEAD;
@@ -2476,6 +2478,7 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
 			    struct inode *new_dir, struct dentry *new_dentry)
 {
+	struct cred *cred = current->cred;
 	struct inode *target;
 	int error;
 
@@ -2490,7 +2493,8 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
 	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
 		error = -EBUSY;
 	else
-		error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
+		error = old_dir->i_op->rename(old_dir, old_dentry,
+					      new_dir, new_dentry, cred);
 	if (!error) {
 		if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
 			d_move(old_dentry, new_dentry);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 447a364..18cea2c 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -55,7 +55,7 @@ static int nfs_link(struct dentry *, struct inode *, struct dentry *,
 static int nfs_mknod(struct inode *, struct dentry *, int, dev_t,
 		     struct cred *);
 static int nfs_rename(struct inode *, struct dentry *,
-		      struct inode *, struct dentry *);
+		      struct inode *, struct dentry *, struct cred *);
 static int nfs_fsync_dir(struct file *, struct dentry *, int);
 static loff_t nfs_llseek_dir(struct file *, loff_t, int);
 
@@ -1654,9 +1654,9 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry,
  * the rename.
  */
 static int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct dentry *dentry = NULL, *rehash = NULL;
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index f4bab9d..0502bb3 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -868,7 +868,8 @@ out:
 }
 
 static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       struct cred *cred)
 {
 	struct buffer_head *dotdot_bh;
 	struct msdos_dir_entry *dotdot_de;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7838e9..7fe8921 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1146,7 +1146,8 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *, struct cred *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t, struct cred *);
 	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
+		       struct inode *, struct dentry *,
+		       struct cred *);
 	int (*readlink) (struct dentry *, char __user *,int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
@@ -1799,7 +1800,8 @@ extern int simple_link(struct dentry *, struct inode *, struct dentry *,
 		       struct cred *);
 extern int simple_unlink(struct inode *, struct dentry *, struct cred *);
 extern int simple_rmdir(struct inode *, struct dentry *, struct cred *);
-extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int simple_rename(struct inode *, struct dentry *,
+			 struct inode *, struct dentry *, struct cred *);
 extern int simple_sync_file(struct file *, struct dentry *, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
diff --git a/mm/shmem.c b/mm/shmem.c
index d0e2db8..9d2ebe2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1828,9 +1828,10 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry,
  * it exists so that the VFS layer correctly free's it when it
  * gets overwritten.
  */
-static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
+static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry,
+			struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(inode->i_mode);
 

