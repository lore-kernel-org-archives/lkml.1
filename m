Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXDQNNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXDQNNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbXDQNNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:13:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43119 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXDQNNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:13:01 -0400
Date: Tue, 17 Apr 2007 18:50:05 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  6/15] Union-mount dentry reference counting
Message-ID: <20070417132005.GG4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Union-mount dentry reference counting

dget is modified to walk the union stack taking reference on every
dentry that is part of the union stack. This is necessary to ensure that
parts of union stack don't go away from under us. Since dget() takes a mutex
for walking the stack, dget can now sleep.

dput also walks the union stack and releases references to all the
dentries that are part of the union.

Since dget() can now sleep, make sure that dget() doesn't go to sleep with
any spinlocks held while it tries to get the mutex.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/dcache.c                  |   35 ++++--
 fs/dnotify.c                 |    5 
 fs/inotify.c                 |    8 +
 fs/namei.c                   |   42 +++++--
 fs/namespace.c               |   12 +-
 fs/proc/base.c               |   17 ++
 fs/union.c                   |  249 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h       |   64 ++++++++++-
 include/linux/dcache_union.h |   65 +++++++++++
 kernel/auditsc.c             |    4 
 kernel/cpuset.c              |    4 
 kernel/fork.c                |   10 +
 net/unix/af_unix.c           |    5 
 13 files changed, 484 insertions(+), 36 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -171,8 +171,7 @@ static struct dentry *d_kill(struct dent
  *
  * no dcache lock, please.
  */
-
-void dput(struct dentry *dentry)
+void __dput_single(struct dentry *dentry)
 {
 	if (!dentry)
 		return;
@@ -190,6 +189,13 @@ repeat:
 		return;
 	}
 
+	if (!__dput_single_destroy_union(dentry)) {
+		atomic_inc(&dentry->d_count);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_lock);
+		goto repeat;
+	}
+
 	/*
 	 * AV: ->d_delete() is _NOT_ allowed to block now.
 	 */
@@ -285,6 +291,15 @@ int d_invalidate(struct dentry * dentry)
 
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
+	/*
+	 * TODO: We come here with dcache_lock held and can't
+	 * afford to sleep now to acquire the union_lock. We should
+	 * change all the callers to acquire union_lock first using
+	 * the union_lock_spinlock() helper. Until that is done,
+	 * BUG() here.
+	 */
+	BUG_ON(IS_UNION(dentry));
+
 	atomic_inc(&dentry->d_count);
 	if (!list_empty(&dentry->d_lru)) {
 		dentry_stat.nr_unused--;
@@ -392,7 +407,7 @@ static void prune_one_dentry(struct dent
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
 	if (!prune_parents) {
-		dput(dentry);
+		__dput_single(dentry);
 		spin_lock(&dcache_lock);
 		return;
 	}
@@ -947,7 +962,7 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_alias);
 
 	if (parent) {
-		dentry->d_parent = dget(parent);
+		dentry->d_parent = __dget_single(parent);
 		dentry->d_sb = parent->d_sb;
 	} else {
 		INIT_LIST_HEAD(&dentry->d_u.d_child);
@@ -1908,8 +1923,10 @@ char *d_path(struct dentry *dentry, stru
 		return dentry->d_op->d_dname(dentry, buf, buflen);
 
 	read_lock(&current->fs->lock);
+	union_lock_readlock(current->fs->root, &current->fs->lock);
 	rootmnt = mntget(current->fs->rootmnt);
-	root = dget(current->fs->root);
+	root = __dget(current->fs->root);
+	union_unlock(current->fs->root);
 	read_unlock(&current->fs->lock);
 	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen, 0);
 	dput(root);
@@ -1967,10 +1984,14 @@ asmlinkage long sys_getcwd(char __user *
 		return -ENOMEM;
 
 	read_lock(&current->fs->lock);
+	union_lock_fs(current->fs);
 	pwdmnt = mntget(current->fs->pwdmnt);
-	pwd = dget(current->fs->pwd);
+	pwd = __dget(current->fs->pwd);
 	rootmnt = mntget(current->fs->rootmnt);
-	root = dget(current->fs->root);
+	root = __dget(current->fs->root);
+	union_unlock(current->fs->pwd);
+	union_unlock(current->fs->altroot);
+	union_unlock(current->fs->root);
 	read_unlock(&current->fs->lock);
 
 	cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE, 1);
--- a/fs/dnotify.c
+++ b/fs/dnotify.c
@@ -161,13 +161,16 @@ void dnotify_parent(struct dentry *dentr
 		return;
 
 	spin_lock(&dentry->d_lock);
+	union_lock_spinlock(dentry->d_parent, &dentry->d_lock);
 	parent = dentry->d_parent;
 	if (parent->d_inode->i_dnotify_mask & event) {
-		dget(parent);
+		__dget(parent);
+		union_unlock(parent);
 		spin_unlock(&dentry->d_lock);
 		__inode_dir_notify(parent->d_inode, event);
 		dput(parent);
 	} else {
+		union_unlock(parent);
 		spin_unlock(&dentry->d_lock);
 	}
 }
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -325,17 +325,21 @@ void inotify_dentry_parent_queue_event(s
 		return;
 
 	spin_lock(&dentry->d_lock);
+	union_lock_spinlock(dentry->d_parent, &dentry->d_lock);
 	parent = dentry->d_parent;
 	inode = parent->d_inode;
 
 	if (inotify_inode_watched(inode)) {
-		dget(parent);
+		__dget(parent);
+		union_unlock(parent);
 		spin_unlock(&dentry->d_lock);
 		inotify_inode_queue_event(inode, mask, cookie, name,
 					  dentry->d_inode);
 		dput(parent);
-	} else
+	} else {
+		union_unlock(parent);
 		spin_unlock(&dentry->d_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(inotify_dentry_parent_queue_event);
 
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -522,16 +522,23 @@ walk_init_root(const char *name, struct 
 	struct fs_struct *fs = current->fs;
 
 	read_lock(&fs->lock);
+	union_lock_fs(fs);
 	if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
 		nd->mnt = mntget(fs->altrootmnt);
-		nd->dentry = dget(fs->altroot);
+		nd->dentry = __dget(fs->altroot);
+		union_unlock(fs->pwd);
+		union_unlock(fs->altroot);
+		union_unlock(fs->root);
 		read_unlock(&fs->lock);
 		if (__emul_lookup_dentry(name,nd))
 			return 0;
 		read_lock(&fs->lock);
 	}
 	nd->mnt = mntget(fs->rootmnt);
-	nd->dentry = dget(fs->root);
+	nd->dentry = __dget(fs->root);
+	union_unlock(fs->pwd);
+	union_unlock(fs->altroot);
+	union_unlock(fs->root);
 	read_unlock(&fs->lock);
 	return 1;
 }
@@ -654,13 +661,16 @@ int follow_up(struct vfsmount **mnt, str
 	struct vfsmount *parent;
 	struct dentry *mountpoint;
 	spin_lock(&vfsmount_lock);
+	union_lock_spinlock((*mnt)->mnt_mountpoint, &vfsmount_lock);
 	parent=(*mnt)->mnt_parent;
 	if (parent == *mnt) {
+		union_unlock((*mnt)->mnt_mountpoint);
 		spin_unlock(&vfsmount_lock);
 		return 0;
 	}
 	mntget(parent);
-	mountpoint=dget((*mnt)->mnt_mountpoint);
+	mountpoint=__dget((*mnt)->mnt_mountpoint);
+	union_unlock((*mnt)->mnt_mountpoint);
 	spin_unlock(&vfsmount_lock);
 	dput(*dentry);
 	*dentry = mountpoint;
@@ -736,21 +746,27 @@ static __always_inline void follow_dotdo
 		}
                 read_unlock(&fs->lock);
 		spin_lock(&dcache_lock);
+		union_lock_spinlock(nd->dentry->d_parent, &dcache_lock);
 		if (nd->dentry != nd->mnt->mnt_root) {
-			nd->dentry = dget(nd->dentry->d_parent);
+			nd->dentry = __dget(nd->dentry->d_parent);
+			union_unlock(nd->dentry->d_parent);
 			spin_unlock(&dcache_lock);
 			dput(old);
 			break;
 		}
+		union_unlock(nd->dentry->d_parent);
 		spin_unlock(&dcache_lock);
 		spin_lock(&vfsmount_lock);
+		union_lock_spinlock(nd->mnt->mnt_mountpoint, &vfsmount_lock);
 		parent = nd->mnt->mnt_parent;
 		if (parent == nd->mnt) {
+			union_unlock(nd->mnt->mnt_mountpoint);
 			spin_unlock(&vfsmount_lock);
 			break;
 		}
 		mntget(parent);
-		nd->dentry = dget(nd->mnt->mnt_mountpoint);
+		nd->dentry = __dget(nd->mnt->mnt_mountpoint);
+		union_unlock(nd->mnt->mnt_mountpoint);
 		spin_unlock(&vfsmount_lock);
 		dput(old);
 		mntput(nd->mnt);
@@ -1050,8 +1066,10 @@ static int __emul_lookup_dentry(const ch
 		 */
 		nd->last_type = LAST_ROOT;
 		read_lock(&fs->lock);
+		union_lock_readlock(fs->root, &fs->lock);
 		nd->mnt = mntget(fs->rootmnt);
-		nd->dentry = dget(fs->root);
+		nd->dentry = __dget(fs->root);
+		union_unlock(fs->root);
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
 			if (nd->dentry->d_inode) {
@@ -1114,20 +1132,26 @@ static int fastcall do_path_lookup(int d
 	if (*name=='/') {
 		read_lock(&fs->lock);
 		if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
+			union_lock_readlock(fs->altroot, &fs->lock);
 			nd->mnt = mntget(fs->altrootmnt);
-			nd->dentry = dget(fs->altroot);
+			nd->dentry = __dget(fs->altroot);
+			union_unlock(fs->altroot);
 			read_unlock(&fs->lock);
 			if (__emul_lookup_dentry(name,nd))
 				goto out; /* found in altroot */
 			read_lock(&fs->lock);
 		}
+		union_lock_readlock(fs->root, &fs->lock);
 		nd->mnt = mntget(fs->rootmnt);
-		nd->dentry = dget(fs->root);
+		nd->dentry = __dget(fs->root);
+		union_unlock(fs->root);
 		read_unlock(&fs->lock);
 	} else if (dfd == AT_FDCWD) {
 		read_lock(&fs->lock);
+		union_lock_readlock(fs->pwd, &fs->lock);
 		nd->mnt = mntget(fs->pwdmnt);
-		nd->dentry = dget(fs->pwd);
+		nd->dentry = __dget(fs->pwd);
+		union_unlock(fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
 		struct dentry *dentry;
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1610,12 +1610,14 @@ void set_fs_root(struct fs_struct *fs, s
 {
 	struct dentry *old_root;
 	struct vfsmount *old_rootmnt;
+	union_lock(dentry);
 	write_lock(&fs->lock);
 	old_root = fs->root;
 	old_rootmnt = fs->rootmnt;
 	fs->rootmnt = mntget(mnt);
-	fs->root = dget(dentry);
+	fs->root = __dget(dentry);
 	write_unlock(&fs->lock);
+	union_unlock(dentry);
 	if (old_root) {
 		dput(old_root);
 		mntput(old_rootmnt);
@@ -1632,12 +1634,14 @@ void set_fs_pwd(struct fs_struct *fs, st
 	struct dentry *old_pwd;
 	struct vfsmount *old_pwdmnt;
 
+	union_lock(dentry);
 	write_lock(&fs->lock);
 	old_pwd = fs->pwd;
 	old_pwdmnt = fs->pwdmnt;
 	fs->pwdmnt = mntget(mnt);
-	fs->pwd = dget(dentry);
+	fs->pwd = __dget(dentry);
 	write_unlock(&fs->lock);
+	union_unlock(dentry);
 
 	if (old_pwd) {
 		dput(old_pwd);
@@ -1726,8 +1730,10 @@ asmlinkage long sys_pivot_root(const cha
 	}
 
 	read_lock(&current->fs->lock);
+	union_lock_readlock(current->fs->root, &current->fs->lock);
 	user_nd.mnt = mntget(current->fs->rootmnt);
-	user_nd.dentry = dget(current->fs->root);
+	user_nd.dentry = __dget(current->fs->root);
+	union_unlock(current->fs->root);
 	read_unlock(&current->fs->lock);
 	down_write(&namespace_sem);
 	mutex_lock(&old_nd.dentry->d_inode->i_mutex);
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -203,8 +203,10 @@ static int proc_cwd_link(struct inode *i
 	}
 	if (fs) {
 		read_lock(&fs->lock);
+		union_lock_readlock(fs->pwd, &fs->lock);
 		*mnt = mntget(fs->pwdmnt);
-		*dentry = dget(fs->pwd);
+		*dentry = __dget(fs->pwd);
+		union_unlock(fs->pwd);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -224,8 +226,10 @@ static int proc_root_link(struct inode *
 	}
 	if (fs) {
 		read_lock(&fs->lock);
+		union_lock_readlock(fs->root, &fs->lock);
 		*mnt = mntget(fs->rootmnt);
-		*dentry = dget(fs->root);
+		*dentry = __dget(fs->root);
+		union_unlock(fs->root);
 		read_unlock(&fs->lock);
 		result = 0;
 		put_fs_struct(fs);
@@ -1252,19 +1256,26 @@ static int proc_fd_info(struct inode *in
 		 * We are not taking a ref to the file structure, so we must
 		 * hold ->file_lock.
 		 */
+repeat:
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
+			if (!union_trylock(file->f_path.dentry)) {
+				spin_unlock(&files->file_lock);
+				cpu_relax();
+				goto repeat;
+			}
 			if (mnt)
 				*mnt = mntget(file->f_path.mnt);
 			if (dentry)
-				*dentry = dget(file->f_path.dentry);
+				*dentry = __dget(file->f_path.dentry);
 			if (info)
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
 					 "flags:\t0%o\n",
 					 (long long) file->f_pos,
 					 file->f_flags);
+			union_unlock(file->f_path.dentry);
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
--- a/fs/union.c
+++ b/fs/union.c
@@ -11,6 +11,55 @@
  */
 
 #include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+
+void
+__union_check(struct dentry *dentry)
+{
+	if (likely(!(dentry->d_topmost || dentry->d_overlaid))) {
+		if (unlikely(dentry->d_union)) {
+			printk(KERN_ERR "%s: \"%s\" stale union reference\n" \
+			       "\tdentry=%p, inode=%p, count=%d, u_count=%d\n",
+			       __FUNCTION__,
+			       dentry->d_name.name,
+			       dentry,
+			       dentry->d_inode,
+			       atomic_read(&dentry->d_count),
+			       atomic_read(&dentry->d_union->u_count));
+			dump_stack();
+		}
+		return;
+	}
+
+	BUG_ON(!dentry->d_union);
+
+	if ((dentry == dentry->d_topmost) || (dentry == dentry->d_overlaid)) {
+		printk(KERN_ERR "%s: \"%s\" loop in union stack\n",
+		       __FUNCTION__, dentry->d_name.name);
+		BUG();
+	}
+
+	if (dentry->d_inode && !S_ISDIR(dentry->d_inode->i_mode)) {
+		printk(KERN_ERR "%s: \"%s\" isn't a directory!\n",
+		       __FUNCTION__, dentry->d_name.name);
+		BUG();
+	}
+
+	if (dentry->d_topmost && !dentry->d_topmost->d_inode) {
+		printk(KERN_ERR "%s: \"%s\" has a negative topmost dentry!\n",
+		       __FUNCTION__, dentry->d_name.name);
+		BUG();
+	}
+
+	if (!dentry->d_inode && !dentry->d_topmost) {
+		printk(KERN_ERR "%s: \"%s\" is a negative topmost dentry!\n",
+		       __FUNCTION__, dentry->d_name.name);
+		BUG();
+	}
+}
+EXPORT_SYMBOL_GPL(__union_check);
 
 struct union_info * union_alloc(void)
 {
@@ -51,3 +100,203 @@ void union_put(struct union_info *info)
 
 	return;
 }
+
+/*
+ * Check if the given @parent dentry is really a parent of @dentry
+ */
+static int union_is_parent(struct dentry *dentry, struct dentry *parent)
+{
+	struct dentry *tmp = dentry;
+
+	if (parent->d_sb != dentry->d_sb) {
+		UM_DEBUG("%s and %s have different superblocks\n",
+			 dentry->d_name.name, parent->d_name.name);
+		return 0;
+	}
+
+	do {
+		if (tmp == parent)
+			return 1;
+	} while (tmp != tmp->d_parent && (tmp = tmp->d_parent));
+
+	return 0;
+}
+
+/*
+ * Check if the @dentry is part of a union
+ */
+int union_is_member(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct list_head *tmp;
+	struct vfsmount *p, *m_tmp = mntget(mnt);
+	struct dentry *d_tmp = __dget(dentry);
+
+	UM_DEBUG_UID("dentry=%s\n", dentry->d_name.name);
+
+	do {
+		UM_DEBUG_UID("device=%s\n", mnt->mnt_devname);
+		list_for_each(tmp, &m_tmp->mnt_mounts) {
+			p = list_entry(tmp, struct vfsmount, mnt_child);
+			UM_DEBUG_UID("child=%s\n", p->mnt_devname);
+			if (p->mnt_flags & MNT_UNION) {
+				UM_DEBUG_UID("is union=%s\n", p->mnt_devname);
+				if (union_is_parent(d_tmp, p->mnt_mountpoint)) {
+					__dput(d_tmp);
+					mntput(m_tmp);
+					return 1;
+				}
+			}
+		}
+
+		__dput(d_tmp);
+		d_tmp = __dget(m_tmp->mnt_mountpoint);
+		p = mntget(m_tmp->mnt_parent);
+		mntput(m_tmp);
+		m_tmp = p;
+	} while (m_tmp != m_tmp->mnt_parent);
+
+	__dput(d_tmp);
+	mntput(m_tmp);
+	return 0;
+}
+
+int __destroy_union(struct dentry * dentry)
+{
+	struct dentry *next;
+	struct dentry *topmost;
+	struct union_info *uinfo;
+
+	if (!union_trylock(dentry))
+		return 0;
+
+	uinfo = union_get(dentry->d_union);
+
+	UM_DEBUG_DCACHE("destroying \"%s\" (%p) union stack %p\n",
+			dentry->d_name.name, dentry->d_inode, uinfo);
+
+	next = dentry->d_topmost ? dentry->d_topmost : dentry;
+	while (next) {
+		struct dentry *tmp = next;
+		next = next->d_overlaid;
+
+		UM_DEBUG_DCACHE("\"%s\", inode=%p, count=%d\n",
+				tmp->d_name.name, tmp->d_inode,
+				atomic_read(&tmp->d_count));
+		if (tmp != dentry)
+			spin_lock(&tmp->d_lock);
+		tmp->d_topmost = NULL;
+		tmp->d_overlaid = NULL;
+		union_put(tmp->d_union);
+		tmp->d_union = NULL;
+		if (tmp != dentry)
+			spin_unlock(&tmp->d_lock);
+		if (tmp == dentry)
+			goto rebuild_stack;
+	}
+
+	mutex_unlock(&uinfo->u_mutex);
+	union_put(uinfo);
+	return 1;
+
+rebuild_stack:
+	if (next) {
+		topmost = next;
+		UM_DEBUG_DCACHE("\"%s\", inode=%p, count=%d\n",
+				next->d_name.name, next->d_inode,
+				atomic_read(&next->d_count));
+		spin_lock(&next->d_lock);
+		next->d_topmost = NULL;
+		if (!next->d_overlaid) {
+			union_put(next->d_union);
+			next->d_union = NULL;
+		}
+		spin_unlock(&next->d_lock);
+		next = next->d_overlaid;
+	}
+
+	while (next) {
+		struct dentry *tmp = next;
+		next = next->d_overlaid;
+		UM_DEBUG_DCACHE("\"%s\", inode=%p, count=%d\n",
+				tmp->d_name.name, tmp->d_inode,
+				atomic_read(&tmp->d_count));
+		tmp->d_topmost = topmost;
+	}
+
+	mutex_unlock(&uinfo->u_mutex);
+	union_put(uinfo);
+	return 1;
+}
+
+static void __destroy_stack_part(struct dentry * first, struct dentry * last)
+{
+	struct dentry * next = first;
+
+	while (next) {
+		struct dentry * tmp = next;
+		next = next->d_overlaid;
+
+		spin_lock(&tmp->d_lock);
+		tmp->d_topmost = NULL;
+		tmp->d_overlaid = NULL;
+		union_put(tmp->d_union);
+		tmp->d_union = NULL;
+		spin_unlock(&tmp->d_lock);
+		if (tmp == last)
+			break;
+	}
+}
+
+/*
+ * This is union-mount dput(). For union mount dentries it is walking DOWN
+ * the union stack and putting every dentry in it. If one of the dentries
+ * usage count reaching zero it is removed from the stack.
+ */
+void __dput_union(struct dentry *dentry)
+{
+	struct dentry *topmost;		// the new topmost after dput()
+	struct dentry *next;
+
+	union_check(dentry);
+
+	if (dentry->d_topmost) {
+		UM_DEBUG_DCACHE("we are not the topmost dentry\n");
+		topmost = dentry->d_topmost;
+	} else
+		topmost = NULL;
+
+	next = dentry;
+	while (next) {
+		struct dentry *tmp = next;	// the dentry we dput now
+		next = next->d_overlaid;	// the dentry we dput next
+
+		UM_DEBUG_DCACHE("name=\"%s\", inode=%p, count=%d\n",
+				tmp->d_name.name, tmp->d_inode,
+				atomic_read(&tmp->d_count));
+
+		if (atomic_read(&tmp->d_count) < 2) {
+			__destroy_stack_part(topmost ? topmost : tmp, tmp);
+			topmost = NULL;
+		} else {
+			tmp->d_topmost = topmost;
+			if (!topmost)
+				topmost = tmp;
+		}
+
+		/* We are the last one using d_union */
+		spin_lock(&tmp->d_lock);
+		if (tmp->d_union
+		    && (atomic_read(&tmp->d_union->u_count) == 1)) {
+			BUG_ON(next);
+			tmp->d_overlaid = NULL;
+			tmp->d_topmost = NULL;
+			union_put(tmp->d_union);
+			tmp->d_union = NULL;
+		}
+		spin_unlock(&tmp->d_lock);
+
+		__dput_single(tmp);
+	}
+
+	return;
+}
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -322,7 +322,7 @@ extern char * d_path(struct dentry *, st
  *	and call dget_locked() instead of dget().
  */
  
-static inline struct dentry *dget(struct dentry *dentry)
+static inline struct dentry *__dget_single(struct dentry *dentry)
 {
 	if (dentry) {
 		BUG_ON(!atomic_read(&dentry->d_count));
@@ -331,13 +331,69 @@ static inline struct dentry *dget(struct
 	return dentry;
 }
 
+extern void __dput_single(struct dentry *);
+
 /*
  * Reference counting for union mounts
  */
 #include <linux/dcache_union.h>
 
+/*
+ * Called with dentry's union lock held
+ */
+static inline struct dentry * __dget(struct dentry *dentry)
+{
+	if (unlikely(IS_UNION(dentry)))
+		return __dget_union(dentry);
+	else
+		return __dget_single(dentry);
+}
+
+static inline struct dentry * dget(struct dentry *dentry)
+{
+	if (!dentry)
+		return dentry;
+
+	/*
+	 * Yes, dget() can sleep now, if the union struct isn't yet read
+	 * in completly. This is symmetric to dput() which can sleep too.
+	 */
+	might_sleep();
+
+	union_lock(dentry);
+	__dget(dentry);
+	union_unlock(dentry);
+	return dentry;
+}
+
 extern struct dentry * dget_locked(struct dentry *);
 
+/*
+ * Called with dentry's union lock held
+ */
+static inline void __dput(struct dentry *dentry)
+{
+	if (unlikely(IS_UNION(dentry)))
+		__dput_union(dentry);
+	else
+		__dput_single(dentry);
+}
+
+static inline void dput(struct dentry *dentry)
+{
+	if (!dentry)
+		return;
+
+	if (unlikely(IS_UNION(dentry))) {
+		struct union_info *uinfo;
+
+		uinfo = union_get2(dentry);
+		__dput_union(dentry);
+		union_release(uinfo);
+	} else
+		__dput_single(dentry);
+}
+
 /**
  *	d_unhashed -	is dentry hashed
  *	@dentry: entry to check
@@ -355,13 +411,13 @@ static inline struct dentry *dget_parent
 	struct dentry *ret;
 
 	spin_lock(&dentry->d_lock);
-	ret = dget(dentry->d_parent);
+	union_lock_spinlock(dentry->d_parent, &dentry->d_lock);
+	ret = __dget(dentry->d_parent);
+	union_unlock(dentry->d_parent);
 	spin_unlock(&dentry->d_lock);
 	return ret;
 }
 
-extern void dput(struct dentry *);
-
 static inline int d_mountpoint(struct dentry *dentry)
 {
 	return dentry->d_mounted;
--- a/include/linux/dcache_union.h
+++ b/include/linux/dcache_union.h
@@ -41,6 +41,17 @@ extern struct union_info *union_alloc(vo
 extern struct union_info *union_get(struct union_info *);
 extern void union_put(struct union_info *);
 
+
+extern void __union_check(struct dentry *);
+
+static inline void union_check(struct dentry *dentry)
+{
+	if (!dentry)
+		return;
+	if (unlikely(dentry->d_union))
+		__union_check(dentry);
+}
+
 /*
  * These are the functions for locking a dentrys union. When one
  * want to acquire a denties union lock, use:
@@ -68,6 +79,7 @@ static inline void union_lock(struct den
 		UM_DEBUG_LOCK("\"%s\" locking %p (count=%d)\n",
 			      dentry->d_name.name, ui,
 			      atomic_read(&ui->u_count));
+		union_check(dentry);
 		__union_lock(dentry->d_union);
 	}
 }
@@ -86,6 +98,7 @@ static inline void union_unlock(struct d
 		UM_DEBUG_LOCK("\"%s\" unlocking %p (count=%d)\n",
 			      dentry->d_name.name, ui,
 			      atomic_read(&ui->u_count));
+		union_check(dentry);
 		__union_unlock(dentry->d_union);
 	}
 }
@@ -142,6 +155,7 @@ static inline int union_trylock(struct d
 		UM_DEBUG_LOCK("\"%s\" try locking %p (count=%d)\n",
 			      dentry->d_name.name, dentry->d_union,
 			      atomic_read(&dentry->d_union->u_count));
+		union_check(dentry);
 		BUG_ON(!atomic_read(&dentry->d_union->u_count));
 		locked = mutex_trylock(&dentry->d_union->u_mutex);
 		UM_DEBUG_LOCK("\"%s\" trylock %p %s\n", dentry->d_name.name,
@@ -223,10 +237,57 @@ static inline void union_lock_fs(struct 
 }
 
 #define IS_UNION(dentry) ((dentry)->d_overlaid || (dentry)->d_topmost || \
-				(dentry)->d_overlaid)
+			 (dentry)->d_union)
+
+/* dentry reference counting */
+static inline struct dentry * __dget_union(struct dentry *dentry)
+{
+	if (!dentry)
+		return dentry;
+
+	union_check(dentry);
+	__dget_single(dentry);
+
+	if (likely(!dentry->d_overlaid && !dentry->d_topmost))
+		return dentry;
+
+	if (dentry->d_topmost)
+		UM_DEBUG_DCACHE("we are not the topmost dentry\n");
+
+	UM_DEBUG_DCACHE("name=\"%s\", inode=%p, count=%d\n",
+			dentry->d_name.name, dentry->d_inode,
+			atomic_read(&dentry->d_count));
+
+	if (dentry->d_overlaid) {
+		struct dentry * tmp = dentry->d_overlaid;
+
+		while (tmp) {
+			__dget_single(tmp);
+			UM_DEBUG_DCACHE("name=\"%s\", inode=%p, count=%d\n",
+					tmp->d_name.name, tmp->d_inode,
+					atomic_read(&tmp->d_count));
+			tmp = tmp->d_overlaid;
+		}
+	}
+
+	return dentry;
+}
+
+extern void __dput_union(struct dentry *);
+extern int __destroy_union(struct dentry *dentry);
+
+static inline int __dput_single_destroy_union(struct dentry *dentry)
+{
+	if (!dentry->d_union)
+		return 1;
+
+	return __destroy_union(dentry);
+}
 
 #else /* CONFIG_UNION_MOUNT */
 
+#define union_check(dentry) do { /* empty */ } while (0)
+
 #define union_lock(dentry) do { /* empty */ } while (0)
 #define union_trylock(dentry) ({ (1); })
 #define union_unlock(dentry) do { /* empty */ } while (0)
@@ -238,6 +299,8 @@ static inline void union_lock_fs(struct 
 #define union_get2(x) ({ BUG(); (0); })
 #define union_release(x) do { BUG(); } while (0)
 
+#define __dput_single_destroy_union(x) ({ (1); })
+
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
 #endif	/* __LINUX_DCACHE_UNION_H */
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1229,8 +1229,10 @@ void __audit_getname(const char *name)
 	++context->name_count;
 	if (!context->pwd) {
 		read_lock(&current->fs->lock);
-		context->pwd = dget(current->fs->pwd);
+		union_lock_readlock(current->fs->pwd, &current->fs->lock);
+		context->pwd = __dget(current->fs->pwd);
 		context->pwdmnt = mntget(current->fs->pwdmnt);
+		union_unlock(current->fs->pwd);
 		read_unlock(&current->fs->lock);
 	}
 		
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1894,9 +1894,11 @@ static int cpuset_rmdir(struct inode *un
 	mutex_lock(&callback_mutex);
 	set_bit(CS_REMOVED, &cs->flags);
 	list_del(&cs->sibling);	/* delete my sibling from parent->children */
+	union_lock(cs->dentry);
 	spin_lock(&cs->dentry->d_lock);
-	d = dget(cs->dentry);
+	d = __dget(cs->dentry);
 	cs->dentry = NULL;
+	union_unlock(d);
 	spin_unlock(&d->d_lock);
 	cpuset_d_remove_dir(d);
 	dput(d);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -581,17 +581,21 @@ static inline struct fs_struct *__copy_f
 		rwlock_init(&fs->lock);
 		fs->umask = old->umask;
 		read_lock(&old->lock);
+		union_lock_fs(old);
 		fs->rootmnt = mntget(old->rootmnt);
-		fs->root = dget(old->root);
+		fs->root = __dget(old->root);
 		fs->pwdmnt = mntget(old->pwdmnt);
-		fs->pwd = dget(old->pwd);
+		fs->pwd = __dget(old->pwd);
 		if (old->altroot) {
 			fs->altrootmnt = mntget(old->altrootmnt);
-			fs->altroot = dget(old->altroot);
+			fs->altroot = __dget(old->altroot);
 		} else {
 			fs->altrootmnt = NULL;
 			fs->altroot = NULL;
 		}
+		union_unlock(old->pwd);
+		union_unlock(old->altroot);
+		union_unlock(old->root);
 		read_unlock(&old->lock);
 	}
 	return fs;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1082,8 +1082,11 @@ restart:
 		newu->addr = otheru->addr;
 	}
 	if (otheru->dentry) {
-		newu->dentry	= dget(otheru->dentry);
+		/* Is this safe here? I don't know ... */
+		union_lock_spinlock(otheru->dentry, &otheru->lock);
+		newu->dentry	= __dget(otheru->dentry);
 		newu->mnt	= mntget(otheru->mnt);
+		union_unlock(otheru->dentry);
 	}
 
 	/* Set credentials */
