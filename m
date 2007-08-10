Return-Path: <linux-kernel-owner+w=401wt.eu-S939477AbXHJOp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939477AbXHJOp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933698AbXHJOnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:43:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:54780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762541AbXHJOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:43:43 -0400
Message-Id: <20070810143847.174567467@suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 16:22:12 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [patch 4/4] Switch to struct path in fs_struct
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de>
 <20070808193209.GA31354@infradead.org>
 <20070810142208.827949199@suse.de>
Content-Disposition: inline; filename=paths-in-fs_struct.diff
Replace-Subject: Switch to struct path in fs_struct
Recipient-Cc: Jan Blunck <jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Move the definition of struct path into <linux/path.h>.

* Use struct path in fs_struct. This allows to use pathget and
  pathput on a fs_struct.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>

---
 drivers/pnp/pnpbios/core.c     |    2 -
 fs/dcache.c                    |   31 ++++++++------------
 fs/namei.c                     |   47 +++++++++++--------------------
 fs/namespace.c                 |   61 ++++++++++++++++++-----------------------
 fs/proc/base.c                 |    8 ++---
 include/linux/fs_struct.h      |    6 +---
 include/linux/namei.h          |    6 ----
 include/linux/path.h           |   12 ++++++++
 init/do_mounts.c               |    6 ++--
 kernel/auditsc.c               |   27 ++++++++----------
 kernel/exit.c                  |   12 ++------
 kernel/fork.c                  |   17 ++++-------
 kernel/kmod.c                  |    2 -
 sound/core/seq/seq_clientmgr.c |    5 ++-
 sound/core/seq/seq_device.c    |    2 -
 sound/core/sound.c             |    4 +-
 sound/core/timer.c             |    2 -
 17 files changed, 110 insertions(+), 140 deletions(-)

--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -105,7 +105,7 @@ static int pnp_dock_event(int dock, stru
 	char *argv[3], **envp, *buf, *scratch;
 	int i = 0, value;
 
-	if (!current->fs->root)
+	if (!current->fs->root.dentry)
 		return -EAGAIN;
 	if (!(envp = kcalloc(20, sizeof(char *), GFP_KERNEL)))
 		return -ENOMEM;
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1854,8 +1854,7 @@ char * d_path(struct dentry *dentry, str
 				char *buf, int buflen)
 {
 	char *res;
-	struct vfsmount *rootmnt;
-	struct dentry *root;
+	struct path root;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -1868,14 +1867,12 @@ char * d_path(struct dentry *dentry, str
 		return dentry->d_op->d_dname(dentry, buf, buflen);
 
 	read_lock(&current->fs->lock);
-	rootmnt = mntget(current->fs->rootmnt);
-	root = dget(current->fs->root);
+	root = *pathget(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen);
+	res = __d_path(dentry, vfsmnt, root.dentry, root.mnt, buf, buflen);
 	spin_unlock(&dcache_lock);
-	dput(root);
-	mntput(rootmnt);
+	pathput(&root);
 	return res;
 }
 
@@ -1921,28 +1918,26 @@ char *dynamic_dname(struct dentry *dentr
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size)
 {
 	int error;
-	struct vfsmount *pwdmnt, *rootmnt;
-	struct dentry *pwd, *root;
+	struct path pwd, root;
 	char *page = (char *) __get_free_page(GFP_USER);
 
 	if (!page)
 		return -ENOMEM;
 
 	read_lock(&current->fs->lock);
-	pwdmnt = mntget(current->fs->pwdmnt);
-	pwd = dget(current->fs->pwd);
-	rootmnt = mntget(current->fs->rootmnt);
-	root = dget(current->fs->root);
+	pwd = *pathget(&current->fs->pwd);
+	root = *pathget(&current->fs->root);
 	read_unlock(&current->fs->lock);
 
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
 	spin_lock(&dcache_lock);
-	if (pwd->d_parent == pwd || !d_unhashed(pwd)) {
+	if (pwd.dentry->d_parent == pwd.dentry || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
 		char * cwd;
 
-		cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE);
+		cwd = __d_path(pwd.dentry, pwd.mnt, root.dentry, root.mnt,
+			       page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
@@ -1960,10 +1955,8 @@ asmlinkage long sys_getcwd(char __user *
 		spin_unlock(&dcache_lock);
 
 out:
-	dput(pwd);
-	mntput(pwdmnt);
-	dput(root);
-	mntput(rootmnt);
+	pathput(&pwd);
+	pathput(&root);
 	free_page((unsigned long) page);
 	return error;
 }
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -521,16 +521,14 @@ walk_init_root(const char *name, struct 
 	struct fs_struct *fs = current->fs;
 
 	read_lock(&fs->lock);
-	if (fs->altroot && !(nd->lookup.flags & LOOKUP_NOALT)) {
-		nd->lookup.path.mnt = mntget(fs->altrootmnt);
-		nd->lookup.path.dentry = dget(fs->altroot);
+	if (fs->altroot.dentry && !(nd->lookup.flags & LOOKUP_NOALT)) {
+		nd->lookup.path = *pathget(&fs->altroot);
 		read_unlock(&fs->lock);
 		if (__emul_lookup_dentry(name,nd))
 			return 0;
 		read_lock(&fs->lock);
 	}
-	nd->lookup.path.mnt = mntget(fs->rootmnt);
-	nd->lookup.path.dentry = dget(fs->root);
+	nd->lookup.path = *pathget(&fs->root);
 	read_unlock(&fs->lock);
 	return 1;
 }
@@ -727,8 +725,8 @@ static __always_inline void follow_dotdo
 		struct dentry *old = nd->lookup.path.dentry;
 
                 read_lock(&fs->lock);
-		if (nd->lookup.path.dentry == fs->root &&
-		    nd->lookup.path.mnt == fs->rootmnt) {
+		if (nd->lookup.path.dentry == fs->root.dentry &&
+		    nd->lookup.path.mnt == fs->root.mnt) {
                         read_unlock(&fs->lock);
 			break;
 		}
@@ -1045,8 +1043,7 @@ static int __emul_lookup_dentry(const ch
 		 */
 		nd->last_type = LAST_ROOT;
 		read_lock(&fs->lock);
-		nd->lookup.path.mnt = mntget(fs->rootmnt);
-		nd->lookup.path.dentry = dget(fs->root);
+		nd->lookup.path = *pathget(&fs->root);
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
 			if (nd->lookup.path.dentry->d_inode) {
@@ -1066,29 +1063,22 @@ void set_fs_altroot(void)
 {
 	char *emul = __emul_prefix();
 	struct nameidata nd;
-	struct vfsmount *mnt = NULL, *oldmnt;
-	struct dentry *dentry = NULL, *olddentry;
+	struct path path = { }, old_path;
 	int err;
 	struct fs_struct *fs = current->fs;
 
 	if (!emul)
 		goto set_it;
 	err = path_lookup(emul, LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_NOALT, &nd);
-	if (!err) {
-		mnt = nd.lookup.path.mnt;
-		dentry = nd.lookup.path.dentry;
-	}
+	if (!err)
+		path = nd.lookup.path;
 set_it:
 	write_lock(&fs->lock);
-	oldmnt = fs->altrootmnt;
-	olddentry = fs->altroot;
-	fs->altrootmnt = mnt;
-	fs->altroot = dentry;
+	old_path = fs->altroot;
+	fs->altroot = path;
 	write_unlock(&fs->lock);
-	if (olddentry) {
-		dput(olddentry);
-		mntput(oldmnt);
-	}
+	if (old_path.dentry)
+		pathput(&old_path);
 }
 
 /* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
@@ -1106,21 +1096,18 @@ static int fastcall do_path_lookup(int d
 
 	if (*name=='/') {
 		read_lock(&fs->lock);
-		if (fs->altroot && !(nd->lookup.flags & LOOKUP_NOALT)) {
-			nd->lookup.path.mnt = mntget(fs->altrootmnt);
-			nd->lookup.path.dentry = dget(fs->altroot);
+		if (fs->altroot.dentry && !(nd->lookup.flags & LOOKUP_NOALT)) {
+			nd->lookup.path = *pathget(&fs->altroot);
 			read_unlock(&fs->lock);
 			if (__emul_lookup_dentry(name,nd))
 				goto out; /* found in altroot */
 			read_lock(&fs->lock);
 		}
-		nd->lookup.path.mnt = mntget(fs->rootmnt);
-		nd->lookup.path.dentry = dget(fs->root);
+		nd->lookup.path = *pathget(&fs->root);
 		read_unlock(&fs->lock);
 	} else if (dfd == AT_FDCWD) {
 		read_lock(&fs->lock);
-		nd->lookup.path.mnt = mntget(fs->pwdmnt);
-		nd->lookup.path.dentry = dget(fs->pwd);
+		nd->lookup.path = *pathget(&fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
 		file = fget_light(dfd, &fput_needed);
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -551,7 +551,7 @@ static int do_umount(struct vfsmount *mn
 	 *  (2) the usage count == 1 [parent vfsmount] + 1 [sys_umount]
 	 */
 	if (flags & MNT_EXPIRE) {
-		if (mnt == current->fs->rootmnt ||
+		if (mnt == current->fs->root.mnt ||
 		    flags & (MNT_FORCE | MNT_DETACH))
 			return -EINVAL;
 
@@ -586,7 +586,7 @@ static int do_umount(struct vfsmount *mn
 	 * /reboot - static binary that would close all descriptors and
 	 * call reboot(9). Then init(8) could umount root and exec /reboot.
 	 */
-	if (mnt == current->fs->rootmnt && !(flags & MNT_DETACH)) {
+	if (mnt == current->fs->root.mnt && !(flags & MNT_DETACH)) {
 		/*
 		 * Special case for "unmounting" root ...
 		 * we just try to remount it readonly.
@@ -1482,17 +1482,17 @@ static struct mnt_namespace *dup_mnt_ns(
 	while (p) {
 		q->mnt_ns = new_ns;
 		if (fs) {
-			if (p == fs->rootmnt) {
+			if (p == fs->root.mnt) {
 				rootmnt = p;
-				fs->rootmnt = mntget(q);
+				fs->root.mnt = mntget(q);
 			}
-			if (p == fs->pwdmnt) {
+			if (p == fs->pwd.mnt) {
 				pwdmnt = p;
-				fs->pwdmnt = mntget(q);
+				fs->pwd.mnt = mntget(q);
 			}
-			if (p == fs->altrootmnt) {
+			if (p == fs->altroot.mnt) {
 				altrootmnt = p;
-				fs->altrootmnt = mntget(q);
+				fs->altroot.mnt = mntget(q);
 			}
 		}
 		p = next_mnt(p, mnt_ns->root);
@@ -1570,47 +1570,41 @@ out1:
 }
 
 /*
- * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
+ * Replace fs->root with {mnt,dentry}. Put the old values.
  * It can block. Requires the big lock held.
  */
 void set_fs_root(struct fs_struct *fs, struct vfsmount *mnt,
 		 struct dentry *dentry)
 {
-	struct dentry *old_root;
-	struct vfsmount *old_rootmnt;
+	struct path old_root;
+
 	write_lock(&fs->lock);
 	old_root = fs->root;
-	old_rootmnt = fs->rootmnt;
-	fs->rootmnt = mntget(mnt);
-	fs->root = dget(dentry);
+	fs->root.mnt = mntget(mnt);
+	fs->root.dentry = dget(dentry);
 	write_unlock(&fs->lock);
-	if (old_root) {
-		dput(old_root);
-		mntput(old_rootmnt);
-	}
+
+	if (old_root.dentry)
+		pathput(&old_root);
 }
 
 /*
- * Replace the fs->{pwdmnt,pwd} with {mnt,dentry}. Put the old values.
+ * Replace fs->pwd with {mnt,dentry}. Put the old values.
  * It can block. Requires the big lock held.
  */
 void set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct dentry *old_pwd;
-	struct vfsmount *old_pwdmnt;
+	struct path old_pwd;
 
 	write_lock(&fs->lock);
 	old_pwd = fs->pwd;
-	old_pwdmnt = fs->pwdmnt;
-	fs->pwdmnt = mntget(mnt);
-	fs->pwd = dget(dentry);
+	fs->pwd.mnt = mntget(mnt);
+	fs->pwd.dentry = dget(dentry);
 	write_unlock(&fs->lock);
 
-	if (old_pwd) {
-		dput(old_pwd);
-		mntput(old_pwdmnt);
-	}
+	if (old_pwd.dentry)
+		pathput(&old_pwd);
 }
 
 static void chroot_fs_refs(struct nameidata *old_nd, struct nameidata *new_nd)
@@ -1625,11 +1619,11 @@ static void chroot_fs_refs(struct nameid
 		if (fs) {
 			atomic_inc(&fs->count);
 			task_unlock(p);
-			if (fs->root == old_nd->lookup.path.dentry
-			    && fs->rootmnt == old_nd->lookup.path.mnt)
+			if (fs->root.dentry == old_nd->lookup.path.dentry
+			    && fs->root.mnt == old_nd->lookup.path.mnt)
 				set_fs_root(fs, new_nd->lookup.path.mnt, new_nd->lookup.path.dentry);
-			if (fs->pwd == old_nd->lookup.path.dentry
-			    && fs->pwdmnt == old_nd->lookup.path.mnt)
+			if (fs->pwd.dentry == old_nd->lookup.path.dentry
+			    && fs->pwd.mnt == old_nd->lookup.path.mnt)
 				set_fs_pwd(fs, new_nd->lookup.path.mnt, new_nd->lookup.path.dentry);
 			put_fs_struct(fs);
 		} else
@@ -1694,8 +1688,7 @@ asmlinkage long sys_pivot_root(const cha
 	}
 
 	read_lock(&current->fs->lock);
-	user_nd.lookup.path.mnt = mntget(current->fs->rootmnt);
-	user_nd.lookup.path.dentry = dget(current->fs->root);
+	user_nd.lookup.path = *pathget(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	down_write(&namespace_sem);
 	mutex_lock(&old_nd.lookup.path.dentry->d_inode->i_mutex);
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -162,8 +162,8 @@ static int proc_cwd_link(struct inode *i
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->pwdmnt);
-		*dentry = dget(fs->pwd);
+		*mnt = mntget(fs->pwd.mnt);
+		*dentry = dget(fs->pwd.dentry);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -183,8 +183,8 @@ static int proc_root_link(struct inode *
 	}
 	if (fs) {
 		read_lock(&fs->lock);
-		*mnt = mntget(fs->rootmnt);
-		*dentry = dget(fs->root);
+		*mnt = mntget(fs->root.mnt);
+		*dentry = dget(fs->root.dentry);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -1,15 +1,13 @@
 #ifndef _LINUX_FS_STRUCT_H
 #define _LINUX_FS_STRUCT_H
 
-struct dentry;
-struct vfsmount;
+#include <linux/path.h>
 
 struct fs_struct {
 	atomic_t count;
 	rwlock_t lock;
 	int umask;
-	struct dentry * root, * pwd, * altroot;
-	struct vfsmount * rootmnt, * pwdmnt, * altrootmnt;
+	struct path root, pwd, altroot;
 };
 
 #define INIT_FS {				\
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -3,6 +3,7 @@
 
 #include <linux/dcache.h>
 #include <linux/mount.h>
+#include <linux/path.h>
 #include <linux/linkage.h>
 
 struct open_intent {
@@ -13,11 +14,6 @@ struct open_intent {
 
 enum { MAX_NESTED_LINKS = 8 };
 
-struct path {
-	struct vfsmount *mnt;
-	struct dentry *dentry;
-};
-
 struct vfs_lookup {
 	struct path	 path;
 	unsigned int	flags;
--- /dev/null
+++ b/include/linux/path.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_PATH_H
+#define _LINUX_PATH_H
+
+struct dentry;
+struct vfsmount;
+
+struct path {
+	struct vfsmount *mnt;
+	struct dentry *dentry;
+};
+
+#endif  /* _LINUX_PATH_H */
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -286,10 +286,10 @@ static int __init do_mount_root(char *na
 		return err;
 
 	sys_chdir("/root");
-	ROOT_DEV = current->fs->pwdmnt->mnt_sb->s_dev;
+	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
 	printk("VFS: Mounted root (%s filesystem)%s.\n",
-	       current->fs->pwdmnt->mnt_sb->s_type->name,
-	       current->fs->pwdmnt->mnt_sb->s_flags & MS_RDONLY ? 
+	       current->fs->pwd.mnt->mnt_sb->s_type->name,
+	       current->fs->pwd.mnt->mnt_sb->s_flags & MS_RDONLY ? 
 	       " readonly" : "");
 	return 0;
 }
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -196,8 +196,7 @@ struct audit_context {
 	int		    name_count;
 	struct audit_names  names[AUDIT_NAMES];
 	char *		    filterkey;	/* key for rule that triggered record */
-	struct dentry *	    pwd;
-	struct vfsmount *   pwdmnt;
+	struct path	    pwd;
 	struct audit_context *previous; /* For nested syscalls */
 	struct audit_aux_data *aux;
 	struct audit_aux_data *aux_pids;
@@ -635,12 +634,9 @@ static inline void audit_free_names(stru
 			__putname(context->names[i].name);
 	}
 	context->name_count = 0;
-	if (context->pwd)
-		dput(context->pwd);
-	if (context->pwdmnt)
-		mntput(context->pwdmnt);
-	context->pwd = NULL;
-	context->pwdmnt = NULL;
+	pathput(&context->pwd);
+	context->pwd.dentry = NULL;
+	context->pwd.mnt = NULL;
 }
 
 static inline void audit_free_aux(struct audit_context *context)
@@ -1052,10 +1048,11 @@ static void audit_log_exit(struct audit_
 				  context->target_sid))
 			call_panic = 1;
 
-	if (context->pwd && context->pwdmnt) {
+	if (context->pwd.dentry && context->pwd.mnt) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
 		if (ab) {
-			audit_log_d_path(ab, "cwd=", context->pwd, context->pwdmnt);
+			audit_log_d_path(ab, "cwd=", context->pwd.dentry,
+					 context->pwd.mnt);
 			audit_log_end(ab);
 		}
 	}
@@ -1078,8 +1075,9 @@ static void audit_log_exit(struct audit_
 			case 0:
 				/* name was specified as a relative path and the
 				 * directory component is the cwd */
-				audit_log_d_path(ab, " name=", context->pwd,
-						 context->pwdmnt);
+				audit_log_d_path(ab, " name=",
+						 context->pwd.dentry,
+						 context->pwd.mnt);
 				break;
 			default:
 				/* log the name's directory component */
@@ -1311,10 +1309,9 @@ void __audit_getname(const char *name)
 	context->names[context->name_count].ino  = (unsigned long)-1;
 	context->names[context->name_count].osid = 0;
 	++context->name_count;
-	if (!context->pwd) {
+	if (!context->pwd.dentry) {
 		read_lock(&current->fs->lock);
-		context->pwd = dget(current->fs->pwd);
-		context->pwdmnt = mntget(current->fs->pwdmnt);
+		context->pwd = *pathget(&current->fs->pwd);
 		read_unlock(&current->fs->lock);
 	}
 		
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -523,14 +523,10 @@ static inline void __put_fs_struct(struc
 {
 	/* No need to hold fs->lock if we are killing it */
 	if (atomic_dec_and_test(&fs->count)) {
-		dput(fs->root);
-		mntput(fs->rootmnt);
-		dput(fs->pwd);
-		mntput(fs->pwdmnt);
-		if (fs->altroot) {
-			dput(fs->altroot);
-			mntput(fs->altrootmnt);
-		}
+		pathput(&fs->root);
+		pathput(&fs->pwd);
+		if (fs->altroot.dentry)
+			pathput(&fs->altroot);
 		kmem_cache_free(fs_cachep, fs);
 	}
 }
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -582,16 +582,13 @@ static inline struct fs_struct *__copy_f
 		rwlock_init(&fs->lock);
 		fs->umask = old->umask;
 		read_lock(&old->lock);
-		fs->rootmnt = mntget(old->rootmnt);
-		fs->root = dget(old->root);
-		fs->pwdmnt = mntget(old->pwdmnt);
-		fs->pwd = dget(old->pwd);
-		if (old->altroot) {
-			fs->altrootmnt = mntget(old->altrootmnt);
-			fs->altroot = dget(old->altroot);
-		} else {
-			fs->altrootmnt = NULL;
-			fs->altroot = NULL;
+		fs->root = *pathget(&old->root);
+		fs->pwd = *pathget(&old->pwd);
+		if (old->altroot.dentry)
+			fs->altroot = *pathget(&old->altroot);
+		else {
+			fs->altroot.mnt = NULL;
+			fs->altroot.dentry = NULL;
 		}
 		read_unlock(&old->lock);
 	}
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -174,7 +174,7 @@ static int ____call_usermodehelper(void 
 	set_user_nice(current, 0);
 
 	retval = -EPERM;
-	if (current->fs->root)
+	if (current->fs->root.dentry)
 		retval = kernel_execve(sub_info->path,
 				sub_info->argv, sub_info->envp);
 
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -152,13 +152,14 @@ struct snd_seq_client *snd_seq_client_us
 	}
 	spin_unlock_irqrestore(&clients_lock, flags);
 #ifdef CONFIG_KMOD
-	if (!in_interrupt() && current->fs->root) {
+	if (!in_interrupt() && current->fs->root.dentry) {
 		static char client_requested[SNDRV_SEQ_GLOBAL_CLIENTS];
 		static char card_requested[SNDRV_CARDS];
 		if (clientid < SNDRV_SEQ_GLOBAL_CLIENTS) {
 			int idx;
 			
-			if (! client_requested[clientid] && current->fs->root) {
+			if (!client_requested[clientid] &&
+			    current->fs->root.dentry) {
 				client_requested[clientid] = 1;
 				for (idx = 0; idx < 15; idx++) {
 					if (seq_client_load[idx] < 0)
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -150,7 +150,7 @@ void snd_seq_device_load_drivers(void)
 	if (snd_seq_in_init)
 		return;
 
-	if (! current->fs->root)
+	if (! current->fs->root.dentry)
 		return;
 
 	mutex_lock(&ops_mutex);
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -72,7 +72,7 @@ static DEFINE_MUTEX(sound_mutex);
  */
 void snd_request_card(int card)
 {
-	if (! current->fs->root)
+	if (! current->fs->root.dentry)
 		return;
 	if (snd_card_locked(card))
 		return;
@@ -87,7 +87,7 @@ static void snd_request_other(int minor)
 {
 	char *str;
 
-	if (! current->fs->root)
+	if (! current->fs->root.dentry)
 		return;
 	switch (minor) {
 	case SNDRV_MINOR_SEQUENCER:	str = "snd-seq";	break;
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -148,7 +148,7 @@ static struct snd_timer *snd_timer_find(
 
 static void snd_timer_request(struct snd_timer_id *tid)
 {
-	if (! current->fs->root)
+	if (! current->fs->root.dentry)
 		return;
 	switch (tid->dev_class) {
 	case SNDRV_TIMER_CLASS_GLOBAL:

