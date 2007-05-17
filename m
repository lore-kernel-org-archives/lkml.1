Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXEQEn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXEQEn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXEQEnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:43:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42509 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbXEQEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:43:18 -0400
Date: Thu, 17 May 2007 10:20:41 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Convert namespace_sem to a mutex
Message-ID: <20070517045041.GA4462@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

namespace_sem is a rwsem. It is acquired as read sem at only one place(used
by /proc/mounts, /proc/<pid>/mounts and /proc/<pid>/mountstats). In all other
cases it is acquired as a write sem. So, as there is not more than one reader
for this sem, this can be a generic sem (and not rwsem) and if so it can be
a mutex.

Patch is for 2.6.22-rc1-mm1.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/namespace.c |   48 ++++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -37,7 +37,7 @@ static int event;
 static struct list_head *mount_hashtable __read_mostly;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
-static struct rw_semaphore namespace_sem;
+static struct mutex namespace_mutex;
 
 int nr_user_mounts;
 int max_user_mounts = 1024;
@@ -396,7 +396,7 @@ static void *m_start(struct seq_file *m,
 	struct list_head *p;
 	loff_t l = *pos;
 
-	down_read(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	list_for_each(p, &n->list)
 		if (!l--)
 			return list_entry(p, struct vfsmount, mnt_list);
@@ -413,7 +413,7 @@ static void *m_next(struct seq_file *m, 
 
 static void m_stop(struct seq_file *m, void *v)
 {
-	up_read(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 }
 
 static inline void mangle(struct seq_file *m, const char *s)
@@ -683,7 +683,7 @@ static int do_umount(struct vfsmount *mn
 		return retval;
 	}
 
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	spin_lock(&vfsmount_lock);
 	event++;
 
@@ -696,7 +696,7 @@ static int do_umount(struct vfsmount *mn
 	spin_unlock(&vfsmount_lock);
 	if (retval)
 		security_sb_umount_busy(mnt);
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	release_mounts(&umount_list);
 	return retval;
 }
@@ -1002,12 +1002,12 @@ static int do_change_type(struct nameida
 	if (nd->dentry != nd->mnt->mnt_root)
 		return -EINVAL;
 
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	spin_lock(&vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
 	spin_unlock(&vfsmount_lock);
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	return 0;
 }
 
@@ -1030,7 +1030,7 @@ static int do_loopback(struct nameidata 
 	if (err)
 		return err;
 
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	err = -EINVAL;
 	if (IS_MNT_UNBINDABLE(old_nd.mnt))
  		goto out;
@@ -1062,7 +1062,7 @@ static int do_loopback(struct nameidata 
 	}
 
 out:
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	path_release(&old_nd);
 	return err;
 }
@@ -1124,7 +1124,7 @@ static int do_move_mount(struct nameidat
 	if (err)
 		return err;
 
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
 		;
 	err = -EINVAL;
@@ -1176,7 +1176,7 @@ static int do_move_mount(struct nameidat
 out1:
 	mutex_unlock(&nd->dentry->d_inode->i_mutex);
 out:
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	if (!err)
 		path_release(&parent_nd);
 	path_release(&old_nd);
@@ -1238,7 +1238,7 @@ int do_add_mount(struct vfsmount *newmnt
 {
 	int err;
 
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	/* Something was mounted here while we slept */
 	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
 		;
@@ -1267,11 +1267,11 @@ int do_add_mount(struct vfsmount *newmnt
 		list_add_tail(&newmnt->mnt_expire, fslist);
 		spin_unlock(&vfsmount_lock);
 	}
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	return 0;
 
 unlock:
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	mntput(newmnt);
 	return err;
 }
@@ -1337,9 +1337,9 @@ static void expire_mount_list(struct lis
 		get_mnt_ns(ns);
 
 		spin_unlock(&vfsmount_lock);
-		down_write(&namespace_sem);
+		mutex_lock(&namespace_mutex);
 		expire_mount(mnt, mounts, &umounts);
-		up_write(&namespace_sem);
+		mutex_unlock(&namespace_mutex);
 		release_mounts(&umounts);
 		mntput(mnt);
 		put_mnt_ns(ns);
@@ -1612,12 +1612,12 @@ static struct mnt_namespace *dup_mnt_ns(
 	init_waitqueue_head(&new_ns->poll);
 	new_ns->event = 0;
 
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
 					CL_COPY_ALL | CL_EXPIRE, 0);
 	if (IS_ERR(new_ns->root)) {
-		up_write(&namespace_sem);
+		mutex_unlock(&namespace_mutex);
 		kfree(new_ns);
 		return NULL;
 	}
@@ -1651,7 +1651,7 @@ static struct mnt_namespace *dup_mnt_ns(
 		p = next_mnt(p, mnt_ns->root);
 		q = next_mnt(q, new_ns->root);
 	}
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 
 	if (rootmnt)
 		mntput(rootmnt);
@@ -1850,7 +1850,7 @@ asmlinkage long sys_pivot_root(const cha
 	user_nd.mnt = mntget(current->fs->rootmnt);
 	user_nd.dentry = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	mutex_lock(&old_nd.dentry->d_inode->i_mutex);
 	error = -EINVAL;
 	if (IS_MNT_SHARED(old_nd.mnt) ||
@@ -1905,7 +1905,7 @@ asmlinkage long sys_pivot_root(const cha
 	path_release(&parent_nd);
 out2:
 	mutex_unlock(&old_nd.dentry->d_inode->i_mutex);
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	path_release(&user_nd);
 	path_release(&old_nd);
 out1:
@@ -1951,7 +1951,7 @@ void __init mnt_init(unsigned long mempa
 	int i;
 	int err;
 
-	init_rwsem(&namespace_sem);
+	mutex_init(&namespace_mutex);
 
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct vfsmount),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL, NULL);
@@ -2008,11 +2008,11 @@ void __put_mnt_ns(struct mnt_namespace *
 	LIST_HEAD(umount_list);
 	ns->root = NULL;
 	spin_unlock(&vfsmount_lock);
-	down_write(&namespace_sem);
+	mutex_lock(&namespace_mutex);
 	spin_lock(&vfsmount_lock);
 	umount_tree(root, 0, &umount_list);
 	spin_unlock(&vfsmount_lock);
-	up_write(&namespace_sem);
+	mutex_unlock(&namespace_mutex);
 	release_mounts(&umount_list);
 	kfree(ns);
 }
