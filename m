Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXJLQVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXJLQVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760089AbXJLQIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760266AbXJLQH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/52] CRED: Give the rmdir() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:52 +0100
Message-ID: <20071012160752.15119.58526.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the rmdir() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c          |    6 ++++--
 fs/autofs4/root.c     |    5 +++--
 fs/bad_inode.c        |    3 ++-
 fs/ext3/namei.c       |    4 ++--
 fs/libfs.c            |    4 +---
 fs/namei.c            |    3 ++-
 fs/nfs/dir.c          |    6 +++---
 fs/vfat/namei.c       |    3 ++-
 include/linux/fs.h    |    4 ++--
 mm/shmem.c            |    4 ++--
 net/sunrpc/rpc_pipe.c |    6 ++++--
 security/inode.c      |    2 +-
 12 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index b6d5abb..9f2c214 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -32,7 +32,8 @@ static int afs_create(struct inode *dir, struct dentry *dentry, int mode,
 		      struct nameidata *nd, struct cred *cred);
 static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
 		     struct cred *cred);
-static int afs_rmdir(struct inode *dir, struct dentry *dentry);
+static int afs_rmdir(struct inode *dir, struct dentry *dentry,
+		     struct cred *cred);
 static int afs_unlink(struct inode *dir, struct dentry *dentry,
 		      struct cred *cred);
 static int afs_link(struct dentry *from, struct inode *dir,
@@ -794,7 +795,8 @@ error:
 /*
  * remove a directory from an AFS filesystem
  */
-static int afs_rmdir(struct inode *dir, struct dentry *dentry)
+static int afs_rmdir(struct inode *dir, struct dentry *dentry,
+		     struct cred *cred)
 {
 	struct afs_vnode *dvnode, *vnode;
 	struct key *key;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 747a51f..1743d38 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -21,7 +21,7 @@
 
 static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
 static int autofs4_dir_unlink(struct inode *,struct dentry *, struct cred *);
-static int autofs4_dir_rmdir(struct inode *,struct dentry *);
+static int autofs4_dir_rmdir(struct inode *,struct dentry *, struct cred *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int, struct cred *);
 static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
@@ -790,7 +790,8 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry,
 	return 0;
 }
 
-static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
+static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry,
+			     struct cred *cred)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 0b0a787..79d8856 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -221,7 +221,8 @@ static int bad_inode_mkdir(struct inode *dir, struct dentry *dentry,
 	return -EIO;
 }
 
-static int bad_inode_rmdir (struct inode *dir, struct dentry *dentry)
+static int bad_inode_rmdir (struct inode *dir, struct dentry *dentry,
+			    struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index f0e3303..b54b60a 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2080,9 +2080,9 @@ out_brelse:
 	goto out_err;
 }
 
-static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
+static int ext3_rmdir (struct inode * dir, struct dentry *dentry,
+		       struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	int retval;
 	struct inode * inode;
 	struct buffer_head * bh;
diff --git a/fs/libfs.c b/fs/libfs.c
index d4cab7a..f237ef3 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -294,10 +294,8 @@ int simple_unlink(struct inode *dir, struct dentry *dentry, struct cred *cred)
 	return 0;
 }
 
-int simple_rmdir(struct inode *dir, struct dentry *dentry)
+int simple_rmdir(struct inode *dir, struct dentry *dentry, struct cred *cred)
 {
-	struct cred *cred = current->cred;
-
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
diff --git a/fs/namei.c b/fs/namei.c
index fe94ef5..b991b32 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2058,6 +2058,7 @@ void dentry_unhash(struct dentry *dentry)
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	int error = may_delete(dir, dentry, 1);
 
 	if (error)
@@ -2075,7 +2076,7 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 	else {
 		error = security_inode_rmdir(dir, dentry);
 		if (!error) {
-			error = dir->i_op->rmdir(dir, dentry);
+			error = dir->i_op->rmdir(dir, dentry, cred);
 			if (!error)
 				dentry->d_inode->i_flags |= S_DEAD;
 		}
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 5c1f1d4..447a364 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -47,7 +47,7 @@ static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameida
 static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *,
 		      struct cred *);
 static int nfs_mkdir(struct inode *, struct dentry *, int, struct cred *);
-static int nfs_rmdir(struct inode *, struct dentry *);
+static int nfs_rmdir(struct inode *, struct dentry *, struct cred *);
 static int nfs_unlink(struct inode *, struct dentry *, struct cred *);
 static int nfs_symlink(struct inode *, struct dentry *, const char *);
 static int nfs_link(struct dentry *, struct inode *, struct dentry *,
@@ -1348,9 +1348,9 @@ out_err:
 	return error;
 }
 
-static int nfs_rmdir(struct inode *dir, struct dentry *dentry)
+static int nfs_rmdir(struct inode *dir, struct dentry *dentry,
+		     struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	int error;
 
 	dfprintk(VFS, "NFS: rmdir(%s/%ld), %s\n",
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index 434ffdf..f4bab9d 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -764,7 +764,8 @@ out:
 	return err;
 }
 
-static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
+static int vfat_rmdir(struct inode *dir, struct dentry *dentry,
+		      struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct fat_slot_info sinfo;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 62df85a..f7838e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1143,7 +1143,7 @@ struct inode_operations {
 	int (*unlink) (struct inode *,struct dentry *, struct cred *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
 	int (*mkdir) (struct inode *,struct dentry *,int, struct cred *);
-	int (*rmdir) (struct inode *,struct dentry *);
+	int (*rmdir) (struct inode *,struct dentry *, struct cred *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t, struct cred *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
@@ -1798,7 +1798,7 @@ extern int simple_statfs(struct dentry *, struct kstatfs *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *,
 		       struct cred *);
 extern int simple_unlink(struct inode *, struct dentry *, struct cred *);
-extern int simple_rmdir(struct inode *, struct dentry *);
+extern int simple_rmdir(struct inode *, struct dentry *, struct cred *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 extern int simple_sync_file(struct file *, struct dentry *, int);
 extern int simple_empty(struct dentry *);
diff --git a/mm/shmem.c b/mm/shmem.c
index 1e3c4e7..d0e2db8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1811,9 +1811,9 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry,
 	return 0;
 }
 
-static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
+static int shmem_rmdir(struct inode *dir, struct dentry *dentry,
+		       struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 1906ee1..c38cc0d 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -547,7 +547,7 @@ repeat:
 			if (S_ISREG(dentry->d_inode->i_mode))
 				simple_unlink(dir, dentry, cred);
 			else if (S_ISDIR(dentry->d_inode->i_mode))
-				simple_rmdir(dir, dentry);
+				simple_rmdir(dir, dentry, cred);
 			d_delete(dentry);
 			dput(dentry);
 		} while (n);
@@ -618,8 +618,10 @@ out_err:
 static int
 __rpc_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *cred = current->cred;
 	int error;
-	error = simple_rmdir(dir, dentry);
+
+	error = simple_rmdir(dir, dentry, cred);
 	if (!error)
 		d_delete(dentry);
 	return error;
diff --git a/security/inode.c b/security/inode.c
index 1eaaf3d..0ea9f41 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -305,7 +305,7 @@ void securityfs_remove(struct dentry *dentry)
 	if (positive(dentry)) {
 		if (dentry->d_inode) {
 			if (S_ISDIR(dentry->d_inode->i_mode))
-				simple_rmdir(parent->d_inode, dentry);
+				simple_rmdir(parent->d_inode, dentry, cred);
 			else
 				simple_unlink(parent->d_inode, dentry, cred);
 			dput(dentry);

