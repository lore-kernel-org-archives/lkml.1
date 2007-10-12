Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbXJLQ1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbXJLQ1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbXJLQJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:09:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760544AbXJLQI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 41/52] CRED: Pass credentials through d_revalidate()
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:49 +0100
Message-ID: <20071012160849.15119.18308.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through d_revalidate().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c            |    6 ++-
 fs/autofs4/root.c       |    8 +++-
 fs/namei.c              |    7 +++-
 fs/nfs/dir.c            |   13 ++++---
 fs/proc/base.c          |   88 +++++++++++++++++++++++++++++------------------
 fs/proc/proc_sysctl.c   |    3 +-
 fs/proc/root.c          |    2 +
 fs/vfat/namei.c         |    3 +-
 include/linux/dcache.h  |    3 +-
 include/linux/proc_fs.h |    3 +-
 10 files changed, 84 insertions(+), 52 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index b7bd368..d998075 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -23,7 +23,8 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 				 struct nameidata *nd, struct cred *cred);
 static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, void *dirent, filldir_t filldir);
-static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd);
+static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd,
+			    struct cred *cred);
 static int afs_d_delete(struct dentry *dentry);
 static void afs_d_release(struct dentry *dentry);
 static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
@@ -564,7 +565,8 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
  * - NOTE! the hit can be a negative hit too, so we can't assume we have an
  *   inode
  */
-static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd,
+			    struct cred *cred)
 {
 	struct afs_vnode *vnode, *dir;
 	struct afs_fid fid;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index bef0396..fd22c05 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -98,6 +98,7 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct vfsmount *mnt = file->f_path.mnt;
+	struct cred *cred = file->f_cred;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct dentry *cursor;
 	int status;
@@ -136,7 +137,7 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
 			d_invalidate(dentry);
 
 		nd.flags = LOOKUP_DIRECTORY;
-		ret = (dentry->d_op->d_revalidate)(dentry, &nd);
+		ret = (dentry->d_op->d_revalidate)(dentry, &nd, cred);
 
 		if (ret <= 0) {
 			if (ret < 0)
@@ -394,7 +395,8 @@ out_error:
  * yet completely filled in, and revalidate has to delay such
  * lookups..
  */
-static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd,
+			      struct cred *cred)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
@@ -633,7 +635,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (dentry->d_op && dentry->d_op->d_revalidate) {
 		mutex_unlock(&dir->i_mutex);
-		(dentry->d_op->d_revalidate)(dentry, nd);
+		(dentry->d_op->d_revalidate)(dentry, nd, cred);
 		mutex_lock(&dir->i_mutex);
 	}
 
diff --git a/fs/namei.c b/fs/namei.c
index cac57e2..e9e45ac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -378,7 +378,8 @@ void release_open_intent(struct nameidata *nd)
 static inline struct dentry *
 do_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
-	int status = dentry->d_op->d_revalidate(dentry, nd);
+	struct cred *cred = current->cred;
+	int status = dentry->d_op->d_revalidate(dentry, nd, cred);
 	if (unlikely(status <= 0)) {
 		/*
 		 * The dentry failed validation.
@@ -811,6 +812,7 @@ fail:
  */
 static fastcall int __link_path_walk(const char * name, struct nameidata *nd)
 {
+	struct cred *cred = current->cred;
 	struct path next;
 	struct inode *inode;
 	int err;
@@ -980,7 +982,8 @@ return_reval:
 		    (nd->dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
 			err = -ESTALE;
 			/* Note: we do not d_invalidate() */
-			if (!nd->dentry->d_op->d_revalidate(nd->dentry, nd))
+			if (!nd->dentry->d_op->d_revalidate(nd->dentry, nd,
+							    cred))
 				break;
 		}
 return_base:
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 11dae6d..48a8935 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -762,9 +762,9 @@ int nfs_neg_need_reval(struct inode *dir, struct dentry *dentry,
  * If the parent directory is seen to have changed, we throw out the
  * cached dentry and do a new lookup.
  */
-static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd)
+static int nfs_lookup_revalidate(struct dentry * dentry, struct nameidata *nd,
+				 struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct inode *dir;
 	struct inode *inode;
 	struct dentry *parent;
@@ -993,7 +993,8 @@ out:
 }
 
 #ifdef CONFIG_NFS_V4
-static int nfs_open_revalidate(struct dentry *, struct nameidata *);
+static int nfs_open_revalidate(struct dentry *, struct nameidata *,
+			       struct cred *);
 
 struct dentry_operations nfs4_dentry_operations = {
 	.d_revalidate	= nfs_open_revalidate,
@@ -1090,9 +1091,9 @@ no_open:
 	return nfs_lookup(dir, dentry, nd, acred);
 }
 
-static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd,
+			       struct cred *acred)
 {
-	struct cred *acred = current->cred;
 	struct dentry *parent = NULL;
 	struct inode *inode = dentry->d_inode;
 	struct inode *dir;
@@ -1138,7 +1139,7 @@ no_open:
 	dput(parent);
 	if (inode != NULL && nfs_have_delegation(inode, FMODE_READ))
 		return 1;
-	return nfs_lookup_revalidate(dentry, nd);
+	return nfs_lookup_revalidate(dentry, nd, acred);
 }
 #endif /* CONFIG_NFSV4 */
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 26f27e5..3034e02 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1101,7 +1101,8 @@ static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat
  * made this apply to all per process world readable and executable
  * directories.
  */
-static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int pid_revalidate(struct dentry *dentry, struct nameidata *nd,
+			  struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
@@ -1141,7 +1142,8 @@ static struct dentry_operations pid_dentry_operations =
 /* Lookups */
 
 typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
-				struct task_struct *, const void *);
+				struct task_struct *, const void *,
+				struct cred *);
 
 /*
  * Fill a directory entry.
@@ -1174,7 +1176,8 @@ static int proc_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 		struct dentry *new;
 		new = d_alloc(dir, &qname);
 		if (new) {
-			child = instantiate(dir->d_inode, new, task, ptr);
+			child = instantiate(dir->d_inode, new, task, ptr,
+					    filp->f_cred);
 			if (child)
 				dput(new);
 			else
@@ -1267,7 +1270,8 @@ static int proc_fd_link(struct inode *inode, struct dentry **dentry,
 	return proc_fd_info(inode, dentry, mnt, NULL);
 }
 
-static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd,
+			     struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
@@ -1309,7 +1313,8 @@ static struct dentry_operations tid_fd_dentry_operations =
 };
 
 static struct dentry *proc_fd_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, const void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr,
+	struct cred *cred)
 {
 	unsigned fd = *(const unsigned *)ptr;
 	struct file *file;
@@ -1349,7 +1354,7 @@ static struct dentry *proc_fd_instantiate(struct inode *dir,
 	dentry->d_op = &tid_fd_dentry_operations;
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
-	if (tid_fd_revalidate(dentry, NULL))
+	if (tid_fd_revalidate(dentry, NULL, cred))
 		error = NULL;
 
  out:
@@ -1364,7 +1369,8 @@ out_iput:
 
 static struct dentry *proc_lookupfd_common(struct inode *dir,
 					   struct dentry *dentry,
-					   instantiate_t instantiate)
+					   instantiate_t instantiate,
+					   struct cred *cred)
 {
 	struct task_struct *task = get_proc_task(dir);
 	unsigned fd = name_to_int(dentry);
@@ -1375,7 +1381,7 @@ static struct dentry *proc_lookupfd_common(struct inode *dir,
 	if (fd == ~0U)
 		goto out;
 
-	result = instantiate(dir, dentry, task, &fd);
+	result = instantiate(dir, dentry, task, &fd, cred);
 out:
 	put_task_struct(task);
 out_no_task:
@@ -1447,7 +1453,7 @@ out_no_task:
 static struct dentry *proc_lookupfd(struct inode *dir, struct dentry *dentry,
 				    struct nameidata *nd, struct cred *cred)
 {
-	return proc_lookupfd_common(dir, dentry, proc_fd_instantiate);
+	return proc_lookupfd_common(dir, dentry, proc_fd_instantiate, cred);
 }
 
 static int proc_readfd(struct file *filp, void *dirent, filldir_t filldir)
@@ -1502,7 +1508,8 @@ static const struct inode_operations proc_fd_inode_operations = {
 };
 
 static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, const void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr,
+	struct cred *cred)
 {
 	unsigned fd = *(unsigned *)ptr;
  	struct inode *inode;
@@ -1519,7 +1526,7 @@ static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 	dentry->d_op = &tid_fd_dentry_operations;
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
-	if (tid_fd_revalidate(dentry, NULL))
+	if (tid_fd_revalidate(dentry, NULL, cred))
 		error = NULL;
 
  out:
@@ -1531,7 +1538,7 @@ static struct dentry *proc_lookupfdinfo(struct inode *dir,
 					struct nameidata *nd,
 					struct cred *cred)
 {
-	return proc_lookupfd_common(dir, dentry, proc_fdinfo_instantiate);
+	return proc_lookupfd_common(dir, dentry, proc_fdinfo_instantiate, cred);
 }
 
 static int proc_readfdinfo(struct file *filp, void *dirent, filldir_t filldir)
@@ -1555,7 +1562,8 @@ static const struct inode_operations proc_fdinfo_inode_operations = {
 
 
 static struct dentry *proc_pident_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, const void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr,
+	struct cred *cred)
 {
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
@@ -1578,7 +1586,7 @@ static struct dentry *proc_pident_instantiate(struct inode *dir,
 	dentry->d_op = &pid_dentry_operations;
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
-	if (pid_revalidate(dentry, NULL))
+	if (pid_revalidate(dentry, NULL, cred))
 		error = NULL;
 out:
 	return error;
@@ -1587,7 +1595,8 @@ out:
 static struct dentry *proc_pident_lookup(struct inode *dir, 
 					 struct dentry *dentry,
 					 const struct pid_entry *ents,
-					 unsigned int nents)
+					 unsigned int nents,
+					 struct cred *cred)
 {
 	struct inode *inode;
 	struct dentry *error;
@@ -1614,7 +1623,7 @@ static struct dentry *proc_pident_lookup(struct inode *dir,
 	if (p > last)
 		goto out;
 
-	error = proc_pident_instantiate(dir, dentry, task, p);
+	error = proc_pident_instantiate(dir, dentry, task, p, cred);
 out:
 	put_task_struct(task);
 out_no_task:
@@ -1672,7 +1681,8 @@ static int proc_pident_readdir(struct file *filp,
 		p = ents + i;
 		last = &ents[nents - 1];
 		while (p <= last) {
-			if (proc_pident_fill_cache(filp, dirent, filldir, task, p) < 0)
+			if (proc_pident_fill_cache(filp, dirent, filldir, task,
+						   p) < 0)
 				goto out;
 			filp->f_pos++;
 			p++;
@@ -1762,7 +1772,7 @@ static const struct pid_entry attr_dir_stuff[] = {
 };
 
 static int proc_attr_dir_readdir(struct file * filp,
-			     void * dirent, filldir_t filldir)
+			    void * dirent, filldir_t filldir)
 {
 	return proc_pident_readdir(filp,dirent,filldir,
 				   attr_dir_stuff,ARRAY_SIZE(attr_dir_stuff));
@@ -1778,7 +1788,8 @@ static struct dentry *proc_attr_dir_lookup(struct inode *dir,
 				struct cred *cred)
 {
 	return proc_pident_lookup(dir, dentry,
-				  attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff));
+				  attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff),
+				  cred);
 }
 
 static const struct inode_operations proc_attr_dir_inode_operations = {
@@ -1914,7 +1925,8 @@ static const struct pid_entry proc_base_stuff[] = {
  * directory. In this case, however, we can do it - no aliasing problems
  * due to the way we treat inodes.
  */
-static int proc_base_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int proc_base_revalidate(struct dentry *dentry, struct nameidata *nd,
+				struct cred *cred)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
@@ -1933,7 +1945,8 @@ static struct dentry_operations proc_base_dentry_operations =
 };
 
 static struct dentry *proc_base_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, const void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr,
+	struct cred *cred)
 {
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
@@ -1979,7 +1992,8 @@ out_iput:
 	goto out;
 }
 
-static struct dentry *proc_base_lookup(struct inode *dir, struct dentry *dentry)
+static struct dentry *proc_base_lookup(struct inode *dir, struct dentry *dentry,
+				       struct cred *cred)
 {
 	struct dentry *error;
 	struct task_struct *task = get_proc_task(dir);
@@ -2001,7 +2015,7 @@ static struct dentry *proc_base_lookup(struct inode *dir, struct dentry *dentry)
 	if (p > last)
 		goto out;
 
-	error = proc_base_instantiate(dir, dentry, task, p);
+	error = proc_base_instantiate(dir, dentry, task, p, cred);
 
 out:
 	put_task_struct(task);
@@ -2103,7 +2117,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
-			     void * dirent, filldir_t filldir)
+			    void * dirent, filldir_t filldir)
 {
 	return proc_pident_readdir(filp,dirent,filldir,
 				   tgid_base_stuff,ARRAY_SIZE(tgid_base_stuff));
@@ -2120,7 +2134,8 @@ static struct dentry *proc_tgid_base_lookup(struct inode *dir,
 					    struct cred *cred)
 {
 	return proc_pident_lookup(dir, dentry,
-				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
+				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff),
+				  cred);
 }
 
 static const struct inode_operations proc_tgid_base_inode_operations = {
@@ -2198,7 +2213,9 @@ out:
 
 static struct dentry *proc_pid_instantiate(struct inode *dir,
 					   struct dentry * dentry,
-					   struct task_struct *task, const void *ptr)
+					   struct task_struct *task,
+					   const void *ptr,
+					   struct cred *cred)
 {
 	struct dentry *error = ERR_PTR(-ENOENT);
 	struct inode *inode;
@@ -2220,19 +2237,20 @@ static struct dentry *proc_pid_instantiate(struct inode *dir,
 
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
-	if (pid_revalidate(dentry, NULL))
+	if (pid_revalidate(dentry, NULL, cred))
 		error = NULL;
 out:
 	return error;
 }
 
-struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry,
+			       struct nameidata *nd, struct cred *cred)
 {
 	struct dentry *result = ERR_PTR(-ENOENT);
 	struct task_struct *task;
 	unsigned tgid;
 
-	result = proc_base_lookup(dir, dentry);
+	result = proc_base_lookup(dir, dentry, cred);
 	if (!IS_ERR(result) || PTR_ERR(result) != -ENOENT)
 		goto out;
 
@@ -2248,7 +2266,7 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct
 	if (!task)
 		goto out;
 
-	result = proc_pid_instantiate(dir, dentry, task, NULL);
+	result = proc_pid_instantiate(dir, dentry, task, NULL, cred);
 	put_task_struct(task);
 out:
 	return result;
@@ -2399,7 +2417,8 @@ static struct dentry *proc_tid_base_lookup(struct inode *dir,
 					   struct cred *cred)
 {
 	return proc_pident_lookup(dir, dentry,
-				  tid_base_stuff, ARRAY_SIZE(tid_base_stuff));
+				  tid_base_stuff, ARRAY_SIZE(tid_base_stuff),
+				  cred);
 }
 
 static const struct file_operations proc_tid_base_operations = {
@@ -2414,7 +2433,8 @@ static const struct inode_operations proc_tid_base_inode_operations = {
 };
 
 static struct dentry *proc_task_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, const void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr,
+	struct cred *cred)
 {
 	struct dentry *error = ERR_PTR(-ENOENT);
 	struct inode *inode;
@@ -2435,7 +2455,7 @@ static struct dentry *proc_task_instantiate(struct inode *dir,
 
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
-	if (pid_revalidate(dentry, NULL))
+	if (pid_revalidate(dentry, NULL, cred))
 		error = NULL;
 out:
 	return error;
@@ -2466,7 +2486,7 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry *dentry,
 	if (leader->tgid != task->tgid)
 		goto out_drop_task;
 
-	result = proc_task_instantiate(dir, dentry, task, NULL);
+	result = proc_task_instantiate(dir, dentry, task, NULL, cred);
 out_drop_task:
 	put_task_struct(task);
 out:
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index b1507e0..e1de8ae 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -451,7 +451,8 @@ static struct inode_operations proc_sys_inode_operations = {
 	.setattr	= proc_sys_setattr,
 };
 
-static int proc_sys_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int proc_sys_revalidate(struct dentry *dentry, struct nameidata *nd,
+			       struct cred *cred)
 {
 	struct ctl_table_header *head;
 	struct ctl_table *table;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1693a60..4e3a6c7 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -97,7 +97,7 @@ static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentr
 	if (!proc_lookup(dir, dentry, nd, cred))
 		return NULL;
 	
-	return proc_pid_lookup(dir, dentry, nd);
+	return proc_pid_lookup(dir, dentry, nd, cred);
 }
 
 static int proc_root_readdir(struct file * filp,
diff --git a/fs/vfat/namei.c b/fs/vfat/namei.c
index 2fb53fa..c26c94f 100644
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -25,7 +25,8 @@
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
 
-static int vfat_revalidate(struct dentry *dentry, struct nameidata *nd)
+static int vfat_revalidate(struct dentry *dentry, struct nameidata *nd,
+			   struct cred *cred)
 {
 	int ret = 1;
 
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index aab53df..804c662 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -11,6 +11,7 @@
 
 struct nameidata;
 struct vfsmount;
+struct cred;
 
 /*
  * linux/include/linux/dcache.h
@@ -127,7 +128,7 @@ enum dentry_d_lock_class
 };
 
 struct dentry_operations {
-	int (*d_revalidate)(struct dentry *, struct nameidata *);
+	int (*d_revalidate)(struct dentry *, struct nameidata *, struct cred *);
 	int (*d_hash) (struct dentry *, struct qstr *);
 	int (*d_compare) (struct dentry *, struct qstr *, struct qstr *);
 	int (*d_delete)(struct dentry *);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 906c416..d15dd5e 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -110,7 +110,8 @@ extern void proc_misc_init(void);
 struct mm_struct;
 
 void proc_flush_task(struct task_struct *task);
-struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
+struct dentry *proc_pid_lookup(struct inode *, struct dentry *,
+			       struct nameidata *, struct cred *);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);

