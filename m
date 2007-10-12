Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXJLQ0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXJLQ0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760511AbXJLQIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760496AbXJLQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 40/52] CRED: Give the lookup() inode op a credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:44 +0100
Message-ID: <20071012160843.15119.22583.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give the lookup() inode op a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c            |    4 ++--
 fs/afs/mntpt.c          |    6 ++++--
 fs/autofs4/root.c       |    6 ++++--
 fs/bad_inode.c          |    3 ++-
 fs/ext3/namei.c         |    4 ++--
 fs/libfs.c              |    3 ++-
 fs/namei.c              |    6 ++++--
 fs/nfs/dir.c            |   18 +++++++++++-------
 fs/proc/base.c          |   23 +++++++++++++++++------
 fs/proc/generic.c       |    3 ++-
 fs/proc/proc_net.c      |    4 ++--
 fs/proc/proc_sysctl.c   |    2 +-
 fs/proc/root.c          |    6 +++---
 fs/sysfs/dir.c          |    2 +-
 fs/vfat/namei.c         |    2 +-
 include/linux/fs.h      |    6 ++++--
 include/linux/proc_fs.h |    3 ++-
 17 files changed, 64 insertions(+), 37 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 745c8cb..b7bd368 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -20,7 +20,7 @@
 #include "internal.h"
 
 static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd);
+				 struct nameidata *nd, struct cred *cred);
 static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, void *dirent, filldir_t filldir);
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
@@ -488,7 +488,7 @@ static int afs_do_lookup(struct inode *dir, struct dentry *dentry,
  * look up an entry in a directory
  */
 static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+				 struct nameidata *nd, struct cred *cred)
 {
 	struct afs_vnode *vnode;
 	struct afs_fid fid;
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index 6f8c96f..21a04c0 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -23,7 +23,8 @@
 
 static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct dentry *dentry,
-				       struct nameidata *nd);
+				       struct nameidata *nd,
+				       struct cred *cred);
 static int afs_mntpt_open(struct inode *inode, struct file *file);
 static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd);
 static void afs_mntpt_expiry_timed_out(struct work_struct *work);
@@ -103,7 +104,8 @@ out:
  */
 static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct dentry *dentry,
-				       struct nameidata *nd)
+				       struct nameidata *nd,
+				       struct cred *cred)
 {
 	_enter("%p,%p{%p{%s},%s}",
 	       dir,
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 50c0ec7..bef0396 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -29,7 +29,8 @@ static int autofs4_dir_open(struct inode *inode, struct file *file);
 static int autofs4_dir_close(struct inode *inode, struct file *file);
 static int autofs4_dir_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
-static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
+static struct dentry *autofs4_lookup(struct inode *,struct dentry *,
+				     struct nameidata *, struct cred *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
 
 const struct file_operations autofs4_root_operations = {
@@ -566,7 +567,8 @@ next:
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry,
+				     struct nameidata *nd, struct cred *cred)
 {
 	struct autofs_sb_info *sbi;
 	struct dentry *unhashed;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 2e25bfe..e77a80d 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -192,7 +192,8 @@ static int bad_inode_create (struct inode *dir, struct dentry *dentry,
 }
 
 static struct dentry *bad_inode_lookup(struct inode *dir,
-			struct dentry *dentry, struct nameidata *nd)
+			struct dentry *dentry, struct nameidata *nd,
+			struct cred *cred)
 {
 	return ERR_PTR(-EIO);
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index aa741bb..3b17b59 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1044,9 +1044,9 @@ errout:
 }
 #endif
 
-static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry,
+				  struct nameidata *nd, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode * inode;
 	struct ext3_dir_entry_2 * de;
 	struct buffer_head * bh;
diff --git a/fs/libfs.c b/fs/libfs.c
index 6b41090..107412e 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -41,7 +41,8 @@ static int simple_delete_dentry(struct dentry *dentry)
  * Lookup the data. This is trivial - if the dentry didn't already
  * exist, we know it is negative.  Set d_op to delete negative dentries.
  */
-struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry,
+			     struct nameidata *nd, struct cred *cred)
 {
 	static struct dentry_operations simple_dentry_operations = {
 		.d_delete = simple_delete_dentry,
diff --git a/fs/namei.c b/fs/namei.c
index 9439e6e..cac57e2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -469,6 +469,7 @@ ok:
  */
 static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	struct dentry * result;
 	struct inode *dir = parent->d_inode;
 
@@ -492,7 +493,7 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 		struct dentry * dentry = d_alloc(parent, name);
 		result = ERR_PTR(-ENOMEM);
 		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
+			result = dir->i_op->lookup(dir, dentry, nd, cred);
 			if (result)
 				dput(dentry);
 			else
@@ -1275,6 +1276,7 @@ int __user_path_lookup_open(const char __user *name, unsigned int lookup_flags,
 
 static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry *base, struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	struct dentry *dentry;
 	struct inode *inode;
 	int err;
@@ -1298,7 +1300,7 @@ static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry
 		dentry = ERR_PTR(-ENOMEM);
 		if (!new)
 			goto out;
-		dentry = inode->i_op->lookup(inode, new, nd);
+		dentry = inode->i_op->lookup(inode, new, nd, cred);
 		if (!dentry)
 			dentry = new;
 		else
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 0dda7bb..11dae6d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -43,7 +43,8 @@
 
 static int nfs_opendir(struct inode *, struct file *);
 static int nfs_readdir(struct file *, void *, filldir_t);
-static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *nfs_lookup(struct inode *, struct dentry *,
+				 struct nameidata *, struct cred *);
 static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *,
 		      struct cred *);
 static int nfs_mkdir(struct inode *, struct dentry *, int, struct cred *);
@@ -107,7 +108,8 @@ const struct inode_operations nfs3_dir_inode_operations = {
 
 #ifdef CONFIG_NFS_V4
 
-static struct dentry *nfs_atomic_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *nfs_atomic_lookup(struct inode *, struct dentry *,
+					struct nameidata *, struct cred *);
 const struct inode_operations nfs4_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_atomic_lookup,
@@ -919,9 +921,9 @@ static inline int nfs_reval_fsid(struct inode *dir, const struct nfs_fattr *fatt
 	return 0;
 }
 
-static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry,
+				 struct nameidata *nd, struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct dentry *res;
 	struct inode *inode = NULL;
 	int error;
@@ -1016,9 +1018,11 @@ static int is_atomic_open(struct inode *dir, struct nameidata *nd)
 	return 1;
 }
 
-static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *nfs_atomic_lookup(struct inode *dir,
+					struct dentry *dentry,
+					struct nameidata *nd,
+					struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct dentry *res = NULL;
 	int error;
 
@@ -1083,7 +1087,7 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
 out:
 	return res;
 no_open:
-	return nfs_lookup(dir, dentry, nd);
+	return nfs_lookup(dir, dentry, nd, acred);
 }
 
 static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index c7f9940..26f27e5 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1445,7 +1445,7 @@ out_no_task:
 }
 
 static struct dentry *proc_lookupfd(struct inode *dir, struct dentry *dentry,
-				    struct nameidata *nd)
+				    struct nameidata *nd, struct cred *cred)
 {
 	return proc_lookupfd_common(dir, dentry, proc_fd_instantiate);
 }
@@ -1528,7 +1528,8 @@ static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 
 static struct dentry *proc_lookupfdinfo(struct inode *dir,
 					struct dentry *dentry,
-					struct nameidata *nd)
+					struct nameidata *nd,
+					struct cred *cred)
 {
 	return proc_lookupfd_common(dir, dentry, proc_fdinfo_instantiate);
 }
@@ -1773,7 +1774,8 @@ static const struct file_operations proc_attr_dir_operations = {
 };
 
 static struct dentry *proc_attr_dir_lookup(struct inode *dir,
-				struct dentry *dentry, struct nameidata *nd)
+				struct dentry *dentry, struct nameidata *nd,
+				struct cred *cred)
 {
 	return proc_pident_lookup(dir, dentry,
 				  attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff));
@@ -2112,7 +2114,11 @@ static const struct file_operations proc_tgid_base_operations = {
 	.readdir	= proc_tgid_base_readdir,
 };
 
-static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
+static struct dentry *proc_tgid_base_lookup(struct inode *dir,
+					    struct dentry *dentry,
+					    struct nameidata *nd,
+					    struct cred *cred)
+{
 	return proc_pident_lookup(dir, dentry,
 				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
@@ -2387,7 +2393,11 @@ static int proc_tid_base_readdir(struct file * filp,
 				   tid_base_stuff,ARRAY_SIZE(tid_base_stuff));
 }
 
-static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
+static struct dentry *proc_tid_base_lookup(struct inode *dir,
+					   struct dentry *dentry,
+					   struct nameidata *nd,
+					   struct cred *cred)
+{
 	return proc_pident_lookup(dir, dentry,
 				  tid_base_stuff, ARRAY_SIZE(tid_base_stuff));
 }
@@ -2431,7 +2441,8 @@ out:
 	return error;
 }
 
-static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_task_lookup(struct inode *dir, struct dentry *dentry,
+				       struct nameidata *nd, struct cred *cred)
 {
 	struct dentry *result = ERR_PTR(-ENOENT);
 	struct task_struct *task;
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 00a2192..ef5fb3a 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -384,7 +384,8 @@ static struct dentry_operations proc_dentry_operations =
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
  */
-struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry,
+			   struct nameidata *nd, struct cred *cred)
 {
 	struct inode *inode = NULL;
 	struct proc_dir_entry * de;
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 3011c08..a1a2fa9 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -101,7 +101,7 @@ static void *proc_net_follow_link(struct dentry *parent, struct nameidata *nd)
 }
 
 static struct dentry *proc_net_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
+				      struct nameidata *nd, struct cred *cred)
 {
 	struct net *net = current->nsproxy->net_ns;
 	struct dentry *shadow;
@@ -113,7 +113,7 @@ static struct dentry *proc_net_lookup(struct inode *dir, struct dentry *dentry,
 	dput(nd->dentry);
 	nd->dentry = shadow;
 
-	return shadow->d_inode->i_op->lookup(shadow->d_inode, dentry, nd);
+	return shadow->d_inode->i_op->lookup(shadow->d_inode, dentry, nd, cred);
 }
 
 static int proc_net_setattr(struct dentry *dentry, struct iattr *iattr,
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 4db895c..b1507e0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -139,7 +139,7 @@ static struct ctl_table *do_proc_sys_lookup(struct dentry *parent,
 }
 
 static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
-					struct nameidata *nd)
+				      struct nameidata *nd, struct cred *cred)
 {
 	struct ctl_table_header *head;
 	struct inode *inode;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 03bfde1..1693a60 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -91,11 +91,11 @@ static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 	return 0;
 }
 
-static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry,
+				       struct nameidata *nd, struct cred *cred)
 {
-	if (!proc_lookup(dir, dentry, nd)) {
+	if (!proc_lookup(dir, dentry, nd, cred))
 		return NULL;
-	}
 	
 	return proc_pid_lookup(dir, dentry, nd);
 }
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 83e76b3..6a4bfb0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -760,7 +760,7 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 }
 
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
-				struct nameidata *nd)
+				struct nameidata *nd, struct cred *cred)
 {
 	struct dentry *ret = NULL;
 	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index 78a6854..2fb53fa 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -684,7 +684,7 @@ static int vfat_find(struct inode *dir, struct qstr *qname,
 }
 
 static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+				  struct nameidata *nd, struct cred *cred)
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 88f9e49..8d64b1e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1137,7 +1137,8 @@ struct file_operations {
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *,
 		       struct cred *);
-	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
+	struct dentry * (*lookup) (struct inode *,struct dentry *,
+				   struct nameidata *, struct cred *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *,
 		     struct cred *);
 	int (*unlink) (struct inode *,struct dentry *, struct cred *);
@@ -1814,7 +1815,8 @@ extern int simple_prepare_write(struct file *file, struct page *page,
 extern int simple_commit_write(struct file *file, struct page *page,
 				unsigned offset, unsigned to);
 
-extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *simple_lookup(struct inode *, struct dentry *,
+				    struct nameidata *, struct cred *);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index a297a65..906c416 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -136,7 +136,8 @@ extern struct inode *proc_get_inode(struct super_block *, unsigned int, struct p
  * of the /proc/<pid> subdirectories.
  */
 extern int proc_readdir(struct file *, void *, filldir_t);
-extern struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *proc_lookup(struct inode *, struct dentry *,
+				  struct nameidata *, struct cred *);
 
 extern const struct file_operations proc_kcore_operations;
 extern const struct file_operations proc_kmsg_operations;

