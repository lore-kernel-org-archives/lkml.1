Return-Path: <linux-kernel-owner+w=401wt.eu-S1030270AbYHFPms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270AbYHFPms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbYHFPje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765AbYHFPjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/24] CRED: Pass credentials through dentry_open() [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:36 +0100
Message-ID: <20080806153836.14351.35907.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through dentry_open() so that the COW creds patch can have
SELinux's flush_unauthorized_files() pass the appropriate creds back to itself
when it opens its null chardev.

The security_dentry_open() call also now takes a creds pointer, as does the
dentry_open hook in struct security_operations.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |    3 ++-
 fs/ecryptfs/kthread.c         |    9 +++++----
 fs/ecryptfs/main.c            |    3 ++-
 fs/exportfs/expfs.c           |    4 +++-
 fs/hppfs/hppfs.c              |    6 ++++--
 fs/nfsctl.c                   |    3 ++-
 fs/nfsd/nfs4recover.c         |    3 ++-
 fs/nfsd/vfs.c                 |    3 ++-
 fs/open.c                     |   17 +++++++++++------
 fs/xfs/linux-2.6/xfs_ioctl.c  |    3 ++-
 include/linux/fs.h            |    4 +++-
 include/linux/security.h      |    7 ++++---
 ipc/mqueue.c                  |   11 +++++++----
 security/capability.c         |    2 +-
 security/security.c           |    4 ++--
 security/selinux/hooks.c      |   15 +++++++++------
 16 files changed, 61 insertions(+), 36 deletions(-)


diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index b73fb75..e73414f 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -709,7 +709,8 @@ int ecryptfs_init_kthread(void);
 void ecryptfs_destroy_kthread(void);
 int ecryptfs_privileged_open(struct file **lower_file,
 			     struct dentry *lower_dentry,
-			     struct vfsmount *lower_mnt);
+			     struct vfsmount *lower_mnt,
+			     const struct cred *cred);
 int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index c440c6b..c6d7a4d 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -73,7 +73,7 @@ static int ecryptfs_threadfn(void *ignored)
 				mntget(req->lower_mnt);
 				(*req->lower_file) = dentry_open(
 					req->lower_dentry, req->lower_mnt,
-					(O_RDWR | O_LARGEFILE));
+					(O_RDWR | O_LARGEFILE), current_cred());
 				req->flags |= ECRYPTFS_REQ_PROCESSED;
 			}
 			wake_up(&req->wait);
@@ -132,7 +132,8 @@ void ecryptfs_destroy_kthread(void)
  */
 int ecryptfs_privileged_open(struct file **lower_file,
 			     struct dentry *lower_dentry,
-			     struct vfsmount *lower_mnt)
+			     struct vfsmount *lower_mnt,
+			     const struct cred *cred)
 {
 	struct ecryptfs_open_req *req;
 	int rc = 0;
@@ -143,7 +144,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	dget(lower_dentry);
 	mntget(lower_mnt);
 	(*lower_file) = dentry_open(lower_dentry, lower_mnt,
-				    (O_RDWR | O_LARGEFILE));
+				    (O_RDWR | O_LARGEFILE), cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
 	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
@@ -184,7 +185,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 		dget(lower_dentry);
 		mntget(lower_mnt);
 		(*lower_file) = dentry_open(lower_dentry, lower_mnt,
-					    (O_RDONLY | O_LARGEFILE));
+					    (O_RDONLY | O_LARGEFILE), cred);
 		if (IS_ERR(*lower_file)) {
 			rc = PTR_ERR(*req->lower_file);
 			(*lower_file) = NULL;
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 448dfd5..00a945b 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -119,6 +119,7 @@ void __ecryptfs_printk(const char *fmt, ...)
  */
 int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 {
+	const struct cred *cred = current_cred();
 	struct ecryptfs_inode_info *inode_info =
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
 	int rc = 0;
@@ -131,7 +132,7 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 
 		lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
 		rc = ecryptfs_privileged_open(&inode_info->lower_file,
-						     lower_dentry, lower_mnt);
+					      lower_dentry, lower_mnt, cred);
 		if (rc || IS_ERR(inode_info->lower_file)) {
 			printk(KERN_ERR "Error opening lower persistent file "
 			       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index cc91227..5c9de1e 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/sched.h>
 
 #define dprintk(fmt, args...) do{}while(0)
 
@@ -250,6 +251,7 @@ static int filldir_one(void * __buf, const char * name, int len,
 static int get_name(struct vfsmount *mnt, struct dentry *dentry,
 		char *name, struct dentry *child)
 {
+	const struct cred *cred = current_cred();
 	struct inode *dir = dentry->d_inode;
 	int error;
 	struct file *file;
@@ -264,7 +266,7 @@ static int get_name(struct vfsmount *mnt, struct dentry *dentry,
 	/*
 	 * Open the directory ...
 	 */
-	file = dentry_open(dget(dentry), mntget(mnt), O_RDONLY);
+	file = dentry_open(dget(dentry), mntget(mnt), O_RDONLY, cred);
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out;
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 2b3d182..795e2c1 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -426,6 +426,7 @@ static int file_mode(int fmode)
 
 static int hppfs_open(struct inode *inode, struct file *file)
 {
+	const struct cred *cred = current_cred();
 	struct hppfs_private *data;
 	struct vfsmount *proc_mnt;
 	struct dentry *proc_dentry;
@@ -446,7 +447,7 @@ static int hppfs_open(struct inode *inode, struct file *file)
 
 	/* XXX This isn't closed anywhere */
 	data->proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt),
-				      file_mode(file->f_mode));
+				      file_mode(file->f_mode), cred);
 	err = PTR_ERR(data->proc_file);
 	if (IS_ERR(data->proc_file))
 		goto out_free1;
@@ -489,6 +490,7 @@ static int hppfs_open(struct inode *inode, struct file *file)
 
 static int hppfs_dir_open(struct inode *inode, struct file *file)
 {
+	const struct cred *cred = current_cred();
 	struct hppfs_private *data;
 	struct vfsmount *proc_mnt;
 	struct dentry *proc_dentry;
@@ -502,7 +504,7 @@ static int hppfs_dir_open(struct inode *inode, struct file *file)
 	proc_dentry = HPPFS_I(inode)->proc_dentry;
 	proc_mnt = inode->i_sb->s_fs_info;
 	data->proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt),
-				      file_mode(file->f_mode));
+				      file_mode(file->f_mode), cred);
 	err = PTR_ERR(data->proc_file);
 	if (IS_ERR(data->proc_file))
 		goto out_free;
diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index aed8145..cc4ef26 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -41,7 +41,8 @@ static struct file *do_open(char *name, int flags)
 		error = may_open(&nd, MAY_WRITE, FMODE_WRITE);
 
 	if (!error)
-		return dentry_open(nd.path.dentry, nd.path.mnt, flags);
+		return dentry_open(nd.path.dentry, nd.path.mnt, flags,
+				   current_cred());
 
 	path_put(&nd.path);
 	return ERR_PTR(error);
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 6e751e7..7092d37 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -226,7 +226,8 @@ nfsd4_list_rec_dir(struct dentry *dir, recdir_func *f)
 
 	nfs4_save_user(&uid, &gid);
 
-	filp = dentry_open(dget(dir), mntget(rec_dir.path.mnt), O_RDONLY);
+	filp = dentry_open(dget(dir), mntget(rec_dir.path.mnt), O_RDONLY,
+			   current_cred());
 	status = PTR_ERR(filp);
 	if (IS_ERR(filp))
 		goto out;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a1b99c6..a80e82c 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -668,6 +668,7 @@ __be32
 nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 			int access, struct file **filp)
 {
+	const struct cred *cred = current_cred();
 	struct dentry	*dentry;
 	struct inode	*inode;
 	int		flags = O_RDONLY|O_LARGEFILE;
@@ -722,7 +723,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 		DQUOT_INIT(inode);
 	}
 	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt),
-				flags);
+			    flags, cred);
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
 out_nfserr:
diff --git a/fs/open.c b/fs/open.c
index a8ddf81..4d0afbe 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -783,7 +783,8 @@ static inline int __get_file_write_access(struct inode *inode,
 
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					int flags, struct file *f,
-					int (*open)(struct inode *, struct file *))
+					int (*open)(struct inode *, struct file *),
+					const struct cred *cred)
 {
 	struct inode *inode;
 	int error;
@@ -807,7 +808,7 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	f->f_op = fops_get(inode->i_fop);
 	file_move(f, &inode->i_sb->s_files);
 
-	error = security_dentry_open(f);
+	error = security_dentry_open(f, cred);
 	if (error)
 		goto cleanup_all;
 
@@ -882,6 +883,8 @@ cleanup_file:
 struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
 		int (*open)(struct inode *, struct file *))
 {
+	const struct cred *cred = current_cred();
+
 	if (IS_ERR(nd->intent.open.file))
 		goto out;
 	if (IS_ERR(dentry))
@@ -889,7 +892,7 @@ struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry
 	nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->path.mnt),
 					     nd->intent.open.flags - 1,
 					     nd->intent.open.file,
-					     open);
+					     open, cred);
 out:
 	return nd->intent.open.file;
 out_err:
@@ -908,6 +911,7 @@ EXPORT_SYMBOL_GPL(lookup_instantiate_filp);
  */
 struct file *nameidata_to_filp(struct nameidata *nd, int flags)
 {
+	const struct cred *cred = current_cred();
 	struct file *filp;
 
 	/* Pick up the filp from the open intent */
@@ -915,7 +919,7 @@ struct file *nameidata_to_filp(struct nameidata *nd, int flags)
 	/* Has the filesystem initialised the file for us? */
 	if (filp->f_path.dentry == NULL)
 		filp = __dentry_open(nd->path.dentry, nd->path.mnt, flags, filp,
-				     NULL);
+				     NULL, cred);
 	else
 		path_put(&nd->path);
 	return filp;
@@ -925,7 +929,8 @@ struct file *nameidata_to_filp(struct nameidata *nd, int flags)
  * dentry_open() will have done dput(dentry) and mntput(mnt) if it returns an
  * error.
  */
-struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags)
+struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
+			 const struct cred *cred)
 {
 	int error;
 	struct file *f;
@@ -950,7 +955,7 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags)
 		return ERR_PTR(error);
 	}
 
-	return __dentry_open(dentry, mnt, flags, f, NULL);
+	return __dentry_open(dentry, mnt, flags, f, NULL, cred);
 }
 EXPORT_SYMBOL(dentry_open);
 
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index acc3fd9..f4c5795 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -256,6 +256,7 @@ xfs_open_by_handle(
 	struct file		*parfilp,
 	struct inode		*parinode)
 {
+	const struct cred	*cred = current_cred();
 	int			error;
 	int			new_fd;
 	int			permflag;
@@ -322,7 +323,7 @@ xfs_open_by_handle(
 	mntget(parfilp->f_path.mnt);
 
 	/* Create file pointer. */
-	filp = dentry_open(dentry, parfilp->f_path.mnt, hreq.oflags);
+	filp = dentry_open(dentry, parfilp->f_path.mnt, hreq.oflags, cred);
 	if (IS_ERR(filp)) {
 		put_unused_fd(new_fd);
 		return -XFS_ERROR(-PTR_ERR(filp));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9a8397f..d4e0016 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -305,6 +305,7 @@ struct poll_table_struct;
 struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
+struct cred;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1617,7 +1618,8 @@ extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
-extern struct file * dentry_open(struct dentry *, struct vfsmount *, int);
+extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
+				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
 
diff --git a/include/linux/security.h b/include/linux/security.h
index a0f5886..27c0fbf 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1398,7 +1398,7 @@ struct security_operations {
 	int (*file_send_sigiotask) (struct task_struct *tsk,
 				    struct fown_struct *fown, int sig);
 	int (*file_receive) (struct file *file);
-	int (*dentry_open) (struct file *file);
+	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
 	int (*cred_alloc_security) (struct cred *cred);
@@ -1657,7 +1657,7 @@ int security_file_set_fowner(struct file *file);
 int security_file_send_sigiotask(struct task_struct *tsk,
 				 struct fown_struct *fown, int sig);
 int security_file_receive(struct file *file);
-int security_dentry_open(struct file *file);
+int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
 int security_cred_alloc(struct cred *cred);
 void security_cred_free(struct cred *cred);
@@ -2160,7 +2160,8 @@ static inline int security_file_receive(struct file *file)
 	return 0;
 }
 
-static inline int security_dentry_open(struct file *file)
+static inline int security_dentry_open(struct file *file,
+				       const struct cred *cred)
 {
 	return 0;
 }
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index f020a77..5246c02 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -586,6 +586,7 @@ static int mq_attr_ok(struct mq_attr *attr)
 static struct file *do_create(struct dentry *dir, struct dentry *dentry,
 			int oflag, mode_t mode, struct mq_attr __user *u_attr)
 {
+	const struct cred *cred = current_cred();
 	struct mq_attr attr;
 	struct file *result;
 	int ret;
@@ -610,7 +611,7 @@ static struct file *do_create(struct dentry *dir, struct dentry *dentry,
 	if (ret)
 		goto out_drop_write;
 
-	result = dentry_open(dentry, mqueue_mnt, oflag);
+	result = dentry_open(dentry, mqueue_mnt, oflag, cred);
 	/*
 	 * dentry_open() took a persistent mnt_want_write(),
 	 * so we can now drop this one.
@@ -629,8 +630,10 @@ out:
 /* Opens existing queue */
 static struct file *do_open(struct dentry *dentry, int oflag)
 {
-static int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
-					MAY_READ | MAY_WRITE };
+	const struct cred *cred = current_cred();
+
+	static const int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
+						  MAY_READ | MAY_WRITE };
 
 	if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY)) {
 		dput(dentry);
@@ -644,7 +647,7 @@ static int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
 		return ERR_PTR(-EACCES);
 	}
 
-	return dentry_open(dentry, mqueue_mnt, oflag);
+	return dentry_open(dentry, mqueue_mnt, oflag, cred);
 }
 
 asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
diff --git a/security/capability.c b/security/capability.c
index 6c4b513..fac2f61 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -330,7 +330,7 @@ static int cap_file_receive(struct file *file)
 	return 0;
 }
 
-static int cap_dentry_open(struct file *file)
+static int cap_dentry_open(struct file *file, const struct cred *cred)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 23c3c91..1a96ec9 100644
--- a/security/security.c
+++ b/security/security.c
@@ -592,9 +592,9 @@ int security_file_receive(struct file *file)
 	return security_ops->file_receive(file);
 }
 
-int security_dentry_open(struct file *file)
+int security_dentry_open(struct file *file, const struct cred *cred)
 {
-	return security_ops->dentry_open(file);
+	return security_ops->dentry_open(file, cred);
 }
 
 int security_task_create(unsigned long clone_flags)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index fb76940..d0e399d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2149,9 +2149,9 @@ extern struct vfsmount *selinuxfs_mount;
 extern struct dentry *selinux_null;
 
 /* Derived from fs/exec.c:flush_old_files. */
-static inline void flush_unauthorized_files(struct files_struct *files)
+static inline void flush_unauthorized_files(const struct cred *cred,
+					    struct files_struct *files)
 {
-	const struct cred *cred = current_cred();
 	struct avc_audit_data ad;
 	struct file *file, *devnull = NULL;
 	struct tty_struct *tty;
@@ -2220,7 +2220,10 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 					if (devnull) {
 						get_file(devnull);
 					} else {
-						devnull = dentry_open(dget(selinux_null), mntget(selinuxfs_mount), O_RDWR);
+						devnull = dentry_open(
+							dget(selinux_null),
+							mntget(selinuxfs_mount),
+							O_RDWR, cred);
 						if (IS_ERR(devnull)) {
 							devnull = NULL;
 							put_unused_fd(fd);
@@ -2300,6 +2303,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
  */
 static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 {
+	const struct cred *cred = current_cred();
 	struct task_security_struct *tsec;
 	struct rlimit *rlim, *initrlim;
 	struct itimerval itimer;
@@ -2317,7 +2321,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 		return;
 
 	/* Close files for which the new task SID is not authorized. */
-	flush_unauthorized_files(current->files);
+	flush_unauthorized_files(cred, current->files);
 
 	/* Check whether the new SID can inherit signal state
 	   from the old SID.  If not, clear itimers to avoid
@@ -3206,9 +3210,8 @@ static int selinux_file_receive(struct file *file)
 	return file_has_perm(cred, file, file_to_av(file));
 }
 
-static int selinux_dentry_open(struct file *file)
+static int selinux_dentry_open(struct file *file, const struct cred *cred)
 {
-	const struct cred *cred = current_cred();
 	struct file_security_struct *fsec;
 	struct inode *inode;
 	struct inode_security_struct *isec;

