Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXJLQ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXJLQ1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbXJLQJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760561AbXJLQJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:09:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 42/52] CRED: Pass credentials through the permission() inode op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:54 +0100
Message-ID: <20071012160854.15119.57578.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the permission() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h        |    5 ++---
 fs/afs/security.c        |    5 +++--
 fs/bad_inode.c           |    2 +-
 fs/ext3/acl.c            |    5 +++--
 fs/ext3/acl.h            |    3 ++-
 fs/namei.c               |   14 ++++++++------
 fs/nfs/dir.c             |    6 +++---
 fs/proc/base.c           |    4 ++--
 fs/proc/proc_sysctl.c    |    5 +++--
 include/linux/fs.h       |    7 ++++---
 include/linux/nfs_fs.h   |    3 ++-
 include/linux/shmem_fs.h |    2 +-
 mm/shmem_acl.c           |    5 +++--
 13 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index cac5092..09b440e 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -469,8 +469,6 @@ extern bool afs_cm_incoming_call(struct afs_call *);
 extern const struct inode_operations afs_dir_inode_operations;
 extern const struct file_operations afs_dir_file_operations;
 
-extern int afs_permission(struct inode *, int, struct nameidata *);
-
 /*
  * file.c
  */
@@ -607,7 +605,8 @@ extern void afs_clear_permits(struct afs_vnode *);
 extern void afs_cache_permit(struct afs_vnode *, struct key *, long);
 extern void afs_zap_permits(struct rcu_head *);
 extern struct key *afs_request_key(struct afs_cell *);
-extern int afs_permission(struct inode *, int, struct nameidata *);
+extern int afs_permission(struct inode *, int, struct nameidata *,
+			  struct cred *);
 
 /*
  * server.c
diff --git a/fs/afs/security.c b/fs/afs/security.c
index 9446a1f..ad217c5 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -284,7 +284,8 @@ static int afs_check_permit(struct afs_vnode *vnode, struct key *key,
  * - AFS ACLs are attached to directories only, and a file is controlled by its
  *   parent directory's ACL
  */
-int afs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int afs_permission(struct inode *inode, int mask, struct nameidata *nd,
+		   struct cred *cred)
 {
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 	afs_access_t access;
@@ -346,7 +347,7 @@ int afs_permission(struct inode *inode, int mask, struct nameidata *nd)
 	}
 
 	key_put(key);
-	ret = generic_permission(inode, mask, NULL);
+	ret = generic_permission(inode, mask, NULL, cred);
 	_leave(" = %d", ret);
 	return ret;
 
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index e77a80d..93c6283 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -248,7 +248,7 @@ static int bad_inode_readlink(struct dentry *dentry, char __user *buffer,
 }
 
 static int bad_inode_permission(struct inode *inode, int mask,
-			struct nameidata *nd)
+			struct nameidata *nd, struct cred *cred)
 {
 	return -EIO;
 }
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 3122db9..0f7fd74 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -299,9 +299,10 @@ ext3_check_acl(struct inode *inode, int mask)
 }
 
 int
-ext3_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext3_permission(struct inode *inode, int mask, struct nameidata *nd,
+		struct cred *cred)
 {
-	return generic_permission(inode, mask, ext3_check_acl);
+	return generic_permission(inode, mask, ext3_check_acl, cred);
 }
 
 /*
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
index f35ccac..72168ee 100644
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -58,7 +58,8 @@ static inline int ext3_acl_count(size_t size)
 #define EXT3_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext3_permission (struct inode *, int, struct nameidata *);
+extern int ext3_permission (struct inode *, int, struct nameidata *,
+			    struct cred *);
 extern int ext3_acl_chmod (struct inode *, struct cred *);
 extern int ext3_init_acl (handle_t *, struct inode *, struct inode *,
 			  struct cred *);
diff --git a/fs/namei.c b/fs/namei.c
index e9e45ac..1703fd0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -174,18 +174,19 @@ EXPORT_SYMBOL(putname);
  * @inode:	inode to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  * @check_acl:	optional callback to check for Posix ACLs
+ * @cred:	the credentials to use
  *
  * Used to check for read/write/execute permissions on a file.
  * We use "fsuid" for this, letting us set arbitrary permissions
  * for filesystem access without changing the "normal" uids which
  * are used for other things..
  */
-int generic_permission(struct inode *inode, int mask,
-		int (*check_acl)(struct inode *inode, int mask))
+int generic_permission(struct inode *inode, int mask, check_acl_t check_acl,
+		       struct cred *cred)
 {
 	umode_t			mode = inode->i_mode;
 
-	if (current->cred->uid == inode->i_uid)
+	if (cred->uid == inode->i_uid)
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
@@ -196,7 +197,7 @@ int generic_permission(struct inode *inode, int mask,
 				return error;
 		}
 
-		if (in_group_p(current->cred, inode->i_gid))
+		if (in_group_p(cred, inode->i_gid))
 			mode >>= 3;
 	}
 
@@ -228,6 +229,7 @@ int generic_permission(struct inode *inode, int mask,
 
 int permission(struct inode *inode, int mask, struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	umode_t mode = inode->i_mode;
 	int retval, submask;
 
@@ -260,9 +262,9 @@ int permission(struct inode *inode, int mask, struct nameidata *nd)
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
 	if (inode->i_op && inode->i_op->permission)
-		retval = inode->i_op->permission(inode, submask, nd);
+		retval = inode->i_op->permission(inode, submask, nd, cred);
 	else
-		retval = generic_permission(inode, submask, NULL);
+		retval = generic_permission(inode, submask, NULL, cred);
 	if (retval)
 		return retval;
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 48a8935..680249e 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1992,9 +1992,9 @@ out:
 	return -EACCES;
 }
 
-int nfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int nfs_permission(struct inode *inode, int mask, struct nameidata *nd,
+		   struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct rpc_cred *cred;
 	int res = 0;
 
@@ -2045,7 +2045,7 @@ out:
 out_notsup:
 	res = nfs_revalidate_inode(NFS_SERVER(inode), inode, acred);
 	if (res == 0)
-		res = generic_permission(inode, mask, NULL);
+		res = generic_permission(inode, mask, NULL, acred);
 	unlock_kernel();
 	goto out;
 }
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3034e02..9262681 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1486,11 +1486,11 @@ static const struct file_operations proc_fd_operations = {
  * access /proc/self/fd after it has executed a setuid().
  */
 static int proc_fd_permission(struct inode *inode, int mask,
-				struct nameidata *nd)
+				struct nameidata *nd, struct cred *cred)
 {
 	int rv;
 
-	rv = generic_permission(inode, mask, NULL);
+	rv = generic_permission(inode, mask, NULL, cred);
 	if (rv == 0)
 		return 0;
 	if (task_pid(current) == proc_pid(inode))
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index e1de8ae..3b8cea8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -369,7 +369,8 @@ out:
 	return ret;
 }
 
-static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int proc_sys_permission(struct inode *inode, int mask,
+			       struct nameidata *nd, struct cred *cred)
 {
 	/*
 	 * sysctl entries that are not writeable,
@@ -393,7 +394,7 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 
 	if (current->euid == 0)
 		mode >>= 6;
-	else if (in_group_p(current->cred, 0))
+	else if (in_group_p(cred, 0))
 		mode >>= 3;
 
 	if ((mode & mask & (MAY_READ|MAY_WRITE|MAY_EXEC)) == mask)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8d64b1e..658bdc8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1154,7 +1154,8 @@ struct inode_operations {
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *, struct cred *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct inode *, int, struct nameidata *,
+			   struct cred *);
 	int (*setattr) (struct dentry *, struct iattr *, struct cred *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
@@ -1571,8 +1572,8 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int permission(struct inode *, int, struct nameidata *);
-extern int generic_permission(struct inode *, int,
-		int (*check_acl)(struct inode *, int));
+typedef int (*check_acl_t)(struct inode *, int);
+extern int generic_permission(struct inode *, int, check_acl_t, struct cred *);
 
 extern int get_write_access(struct inode *);
 extern int deny_write_access(struct file *);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 670e734..333abc5 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -289,7 +289,8 @@ extern struct inode *nfs_fhget(struct super_block *, struct nfs_fh *,
 extern int nfs_refresh_inode(struct inode *, struct nfs_fattr *);
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int nfs_permission(struct inode *, int, struct nameidata *);
+extern int nfs_permission(struct inode *, int, struct nameidata *,
+			  struct cred *);
 extern int nfs_access_get_cached(struct inode *, struct rpc_cred *, struct nfs_access_entry *);
 extern void nfs_access_add_cache(struct inode *, struct nfs_access_entry *);
 extern void nfs_access_zap_cache(struct inode *inode);
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index f3c5189..5db1f0b 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -41,7 +41,7 @@ static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
 }
 
 #ifdef CONFIG_TMPFS_POSIX_ACL
-int shmem_permission(struct inode *, int, struct nameidata *);
+int shmem_permission(struct inode *, int, struct nameidata *, struct cred *);
 int shmem_acl_init(struct inode *, struct inode *);
 void shmem_acl_destroy_inode(struct inode *);
 
diff --git a/mm/shmem_acl.c b/mm/shmem_acl.c
index 0c7f1f2..f78720f 100644
--- a/mm/shmem_acl.c
+++ b/mm/shmem_acl.c
@@ -191,7 +191,8 @@ shmem_check_acl(struct inode *inode, int mask)
  * shmem_permission  -  permission() inode operation
  */
 int
-shmem_permission(struct inode *inode, int mask, struct nameidata *nd)
+shmem_permission(struct inode *inode, int mask, struct nameidata *nd,
+		 struct cred *cred)
 {
-	return generic_permission(inode, mask, shmem_check_acl);
+	return generic_permission(inode, mask, shmem_check_acl, cred);
 }

