Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbXJLQ3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbXJLQ3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbXJLQJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760449AbXJLQJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 45/52] CRED: Pass credentials through the getattr() inode op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:09:09 +0100
Message-ID: <20071012160909.15119.2820.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the getattr() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/inode.c           |    2 +-
 fs/afs/internal.h        |    3 ++-
 fs/bad_inode.c           |    2 +-
 fs/fat/file.c            |    3 ++-
 fs/libfs.c               |    2 +-
 fs/nfs/inode.c           |    4 ++--
 fs/proc/base.c           |    6 ++++--
 fs/proc/generic.c        |    2 +-
 fs/proc/root.c           |    4 ++--
 fs/stat.c                |    3 ++-
 include/linux/fs.h       |    6 ++++--
 include/linux/msdos_fs.h |    2 +-
 include/linux/nfs_fs.h   |    3 ++-
 13 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index f6e4dc1..75f8a8f 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -292,7 +292,7 @@ error_unlock:
  * read the attributes of an inode
  */
 int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		      struct kstat *stat)
+		struct kstat *stat, struct cred *cred)
 {
 	struct inode *inode;
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 09b440e..1b2eeef 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -546,7 +546,8 @@ extern struct inode *afs_iget(struct super_block *, struct key *,
 			      struct afs_callback *);
 extern void afs_zap_data(struct afs_vnode *);
 extern int afs_validate(struct afs_vnode *, struct key *);
-extern int afs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int afs_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+		       struct cred *);
 extern int afs_setattr(struct dentry *, struct iattr *, struct cred *);
 extern void afs_clear_inode(struct inode *);
 
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 93c6283..a891eaa 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -254,7 +254,7 @@ static int bad_inode_permission(struct inode *inode, int mask,
 }
 
 static int bad_inode_getattr(struct vfsmount *mnt, struct dentry *dentry,
-			struct kstat *stat)
+			struct kstat *stat, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/fat/file.c b/fs/fat/file.c
index f0b3faa..6e62dd6 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -304,7 +304,8 @@ void fat_truncate(struct inode *inode, struct cred *cred)
 	fat_flush_inodes(inode->i_sb, inode, NULL);
 }
 
-int fat_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int fat_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat,
+		struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
diff --git a/fs/libfs.c b/fs/libfs.c
index e214329..1699b79 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -12,7 +12,7 @@
 #include <asm/uaccess.h>
 
 int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		   struct kstat *stat)
+		   struct kstat *stat, struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 178979c..b55f803 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -425,9 +425,9 @@ static void nfs_wake_up_inode(struct inode *inode)
 	wake_up_bit(&nfsi->flags, NFS_INO_REVALIDATING);
 }
 
-int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat,
+		struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
 	int err;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d26cf33..3a53ceb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1064,7 +1064,8 @@ out_unlock:
 	return NULL;
 }
 
-static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		       struct kstat *stat, struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task;
@@ -2640,7 +2641,8 @@ out_no_task:
 	return retval;
 }
 
-static int proc_task_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+static int proc_task_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			     struct kstat *stat, struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *p = get_proc_task(inode);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index ea67aac..afbba93 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -256,7 +256,7 @@ out:
 }
 
 static int proc_getattr(struct vfsmount *mnt, struct dentry *dentry,
-			struct kstat *stat)
+			struct kstat *stat, struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct proc_dir_entry *de = PROC_I(inode)->pde;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 4e3a6c7..6025b9d 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -83,8 +83,8 @@ void __init proc_root_init(void)
 	proc_sys_init();
 }
 
-static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat
-)
+static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			     struct kstat *stat, struct cred *cred)
 {
 	generic_fillattr(dentry->d_inode, stat);
 	stat->nlink = proc_root.nlink + nr_processes();
diff --git a/fs/stat.c b/fs/stat.c
index 6851006..0d71257 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -39,6 +39,7 @@ EXPORT_SYMBOL(generic_fillattr);
 
 int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int retval;
 
@@ -47,7 +48,7 @@ int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 		return retval;
 
 	if (inode->i_op->getattr)
-		return inode->i_op->getattr(mnt, dentry, stat);
+		return inode->i_op->getattr(mnt, dentry, stat, cred);
 
 	generic_fillattr(inode, stat);
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9e7ac7c..395b272 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1158,7 +1158,8 @@ struct inode_operations {
 	int (*permission) (struct inode *, int, struct nameidata *,
 			   struct cred *);
 	int (*setattr) (struct dentry *, struct iattr *, struct cred *);
-	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
+	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *,
+			struct cred *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
@@ -1802,7 +1803,8 @@ extern int dcache_dir_open(struct inode *, struct file *);
 extern int dcache_dir_close(struct inode *, struct file *);
 extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
 extern int dcache_readdir(struct file *, void *, filldir_t);
-extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+			  struct cred *);
 extern int simple_statfs(struct dentry *, struct kstatfs *, struct cred *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *,
 		       struct cred *);
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index 63a3efc..2276346 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -405,7 +405,7 @@ extern int fat_notify_change(struct dentry * dentry, struct iattr * attr,
 			     struct cred *cred);
 extern void fat_truncate(struct inode *inode, struct cred *cred);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		       struct kstat *stat);
+		       struct kstat *statm, struct cred *cred);
 
 /* fat/inode.c */
 extern void fat_attach(struct inode *inode, loff_t i_pos);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 333abc5..d26fd56 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -288,7 +288,8 @@ extern struct inode *nfs_fhget(struct super_block *, struct nfs_fh *,
 				struct nfs_fattr *);
 extern int nfs_refresh_inode(struct inode *, struct nfs_fattr *);
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
-extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+		       struct cred *);
 extern int nfs_permission(struct inode *, int, struct nameidata *,
 			  struct cred *);
 extern int nfs_access_get_cached(struct inode *, struct rpc_cred *, struct nfs_access_entry *);

