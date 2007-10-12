Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXJLQRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXJLQRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434AbXJLQHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760258AbXJLQH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/52] CRED: Pass credentials to the setattr() inode operation
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:17 +0100
Message-ID: <20071012160716.15119.32081.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials to the setattr() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/inode.c           |    2 +-
 fs/afs/internal.h        |    2 +-
 fs/attr.c                |    3 ++-
 fs/bad_inode.c           |    3 ++-
 fs/ext3/inode.c          |    3 +--
 fs/fat/file.c            |    3 ++-
 fs/nfs/inode.c           |    5 ++---
 fs/proc/base.c           |    3 ++-
 fs/proc/generic.c        |    3 ++-
 fs/proc/proc_net.c       |    5 +++--
 fs/proc/proc_sysctl.c    |    3 ++-
 fs/sysfs/inode.c         |    3 ++-
 fs/sysfs/sysfs.h         |    3 ++-
 include/linux/ext3_fs.h  |    2 +-
 include/linux/fs.h       |    2 +-
 include/linux/msdos_fs.h |    3 ++-
 include/linux/nfs_fs.h   |    2 +-
 mm/shmem.c               |    3 ++-
 18 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index ca9b02f..f6e4dc1 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -357,7 +357,7 @@ void afs_clear_inode(struct inode *inode)
 /*
  * set the attributes of an inode
  */
-int afs_setattr(struct dentry *dentry, struct iattr *attr)
+int afs_setattr(struct dentry *dentry, struct iattr *attr, struct cred *cred)
 {
 	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
 	struct key *key;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 6306438..cac5092 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -549,7 +549,7 @@ extern struct inode *afs_iget(struct super_block *, struct key *,
 extern void afs_zap_data(struct afs_vnode *);
 extern int afs_validate(struct afs_vnode *, struct key *);
 extern int afs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int afs_setattr(struct dentry *, struct iattr *);
+extern int afs_setattr(struct dentry *, struct iattr *, struct cred *);
 extern void afs_clear_inode(struct inode *);
 
 /*
diff --git a/fs/attr.c b/fs/attr.c
index 06a3145..1b2908c 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -107,6 +107,7 @@ EXPORT_SYMBOL(inode_setattr);
 
 int notify_change(struct dentry * dentry, struct iattr * attr)
 {
+	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	mode_t mode;
 	int error;
@@ -150,7 +151,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	if (inode->i_op && inode->i_op->setattr) {
 		error = security_inode_setattr(dentry, attr);
 		if (!error)
-			error = inode->i_op->setattr(dentry, attr);
+			error = inode->i_op->setattr(dentry, attr, cred);
 	} else {
 		error = inode_change_ok(inode, attr);
 		if (!error)
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index f1c2ea8..dda2d52 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -255,7 +255,8 @@ static int bad_inode_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return -EIO;
 }
 
-static int bad_inode_setattr(struct dentry *direntry, struct iattr *attrs)
+static int bad_inode_setattr(struct dentry *direntry, struct iattr *attrs,
+			     struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 31e5b38..deb0d56 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2941,9 +2941,8 @@ int ext3_write_inode(struct inode *inode, int wait)
  *
  * Called with inode->sem down.
  */
-int ext3_setattr(struct dentry *dentry, struct iattr *attr)
+int ext3_setattr(struct dentry *dentry, struct iattr *attr, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
 	const unsigned int ia_valid = attr->ia_valid;
diff --git a/fs/fat/file.c b/fs/fat/file.c
index a871db8..4c856c5 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -155,7 +155,8 @@ out:
 	return err;
 }
 
-int fat_notify_change(struct dentry *dentry, struct iattr *attr)
+int fat_notify_change(struct dentry *dentry, struct iattr *attr,
+		      struct cred *cred)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f76a93c..178979c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -319,9 +319,8 @@ out_no_inode:
 #define NFS_VALID_ATTRS (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_SIZE|ATTR_ATIME|ATTR_ATIME_SET|ATTR_MTIME|ATTR_MTIME_SET)
 
 int
-nfs_setattr(struct dentry *dentry, struct iattr *attr)
-{
-	struct cred *acred = current->cred;
+nfs_setattr(struct dentry *dentry, struct iattr *attr, struct cred *acred)
+{	
 	struct inode *inode = dentry->d_inode;
 	struct nfs_fattr fattr;
 	int error;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 19489b0..0612ea4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -343,7 +343,8 @@ static int proc_fd_access_allowed(struct inode *inode)
 	return allowed;
 }
 
-static int proc_setattr(struct dentry *dentry, struct iattr *attr)
+static int proc_setattr(struct dentry *dentry, struct iattr *attr,
+			struct cred *cred)
 {
 	int error;
 	struct inode *inode = dentry->d_inode;
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b5e7155..706d373 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -233,7 +233,8 @@ proc_file_lseek(struct file *file, loff_t offset, int orig)
 	return retval;
 }
 
-static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
+static int proc_notify_change(struct dentry *dentry, struct iattr *iattr,
+			      struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct proc_dir_entry *de = PDE(inode);
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 2e91fb7..3011c08 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -116,7 +116,8 @@ static struct dentry *proc_net_lookup(struct inode *dir, struct dentry *dentry,
 	return shadow->d_inode->i_op->lookup(shadow->d_inode, dentry, nd);
 }
 
-static int proc_net_setattr(struct dentry *dentry, struct iattr *iattr)
+static int proc_net_setattr(struct dentry *dentry, struct iattr *iattr,
+			    struct cred *cred)
 {
 	struct net *net = current->nsproxy->net_ns;
 	struct dentry *shadow;
@@ -125,7 +126,7 @@ static int proc_net_setattr(struct dentry *dentry, struct iattr *iattr)
 	shadow = proc_net_shadow_dentry(dentry->d_parent, net->proc_net);
 	if (!shadow)
 		return -ENOENT;
-	ret = shadow->d_inode->i_op->setattr(shadow, iattr);
+	ret = shadow->d_inode->i_op->setattr(shadow, iattr, cred);
 	dput(shadow);
 	return ret;
 }
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index feaf4f5..a939a09 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -420,7 +420,8 @@ out:
 	return error;
 }
 
-static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
+static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr,
+			    struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index fc1934e..6b4fac5 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -44,7 +44,8 @@ void sysfs_delete_inode(struct inode *inode)
 	return generic_delete_inode(inode);
 }
 
-int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
+int sysfs_setattr(struct dentry * dentry, struct iattr * iattr,
+		  struct cred *cred)
 {
 	struct inode * inode = dentry->d_inode;
 	struct sysfs_dirent * sd = dentry->d_fsdata;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6b8c8d7..9b9d575 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -91,7 +91,8 @@ extern int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			       struct sysfs_dirent **p_sd);
 extern void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
-extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
+extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr,
+			 struct cred *cred);
 
 extern spinlock_t sysfs_assoc_lock;
 extern struct mutex sysfs_mutex;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index a2b686d..1ec7712 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -820,7 +820,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 
 extern struct inode *ext3_iget (struct super_block *, unsigned long);
 extern int  ext3_write_inode (struct inode *, int);
-extern int  ext3_setattr (struct dentry *, struct iattr *);
+extern int  ext3_setattr (struct dentry *, struct iattr *, struct cred *);
 extern void ext3_delete_inode (struct inode *);
 extern int  ext3_sync_inode (handle_t *, struct inode *);
 extern void ext3_discard_reservation (struct inode *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 747fc5b..ec9ed45 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1150,7 +1150,7 @@ struct inode_operations {
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *, struct cred *);
 	int (*permission) (struct inode *, int, struct nameidata *);
-	int (*setattr) (struct dentry *, struct iattr *);
+	int (*setattr) (struct dentry *, struct iattr *, struct cred *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index ddd669c..63a3efc 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -401,7 +401,8 @@ extern int fat_generic_ioctl(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg);
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
-extern int fat_notify_change(struct dentry * dentry, struct iattr * attr);
+extern int fat_notify_change(struct dentry * dentry, struct iattr * attr,
+			     struct cred *cred);
 extern void fat_truncate(struct inode *inode, struct cred *cred);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index fe3136e..670e734 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -306,7 +306,7 @@ extern int nfs_revalidate_mapping(struct inode *inode,
 extern int nfs_revalidate_mapping_nolock(struct inode *inode,
 					 struct address_space *mapping,
 					 struct cred *acred);
-extern int nfs_setattr(struct dentry *, struct iattr *);
+extern int nfs_setattr(struct dentry *, struct iattr *, struct cred *);
 extern void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr,
 				     struct cred *acred);
 extern void nfs_begin_attr_update(struct inode *);
diff --git a/mm/shmem.c b/mm/shmem.c
index accaa18..f6054e0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -713,7 +713,8 @@ static void shmem_truncate(struct inode *inode, struct cred *cred)
 	shmem_truncate_range(inode, inode->i_size, (loff_t)-1);
 }
 
-static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
+static int shmem_notify_change(struct dentry *dentry, struct iattr *attr,
+			       struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct page *page = NULL;

