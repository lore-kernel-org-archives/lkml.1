Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYCZVWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYCZVWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbYCZVWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:22:01 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58471 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbYCZVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:21:55 -0400
Message-Id: <20080326212142.255524094@szeredi.hu>
References: <20080326211131.705321084@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 26 Mar 2008 22:11:36 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 5/7] vfs: mountinfo: allow using process root
Content-Disposition: inline; filename=mountinfo_proc_mounts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow /proc/<pid>/mountinfo to use the root of <pid> to calculate
mountpoints.

 - move definition of 'struct proc_mounts' to <linux/mnt_namespace.h>
 - add the process's namespace and root to this structure
 - pass a pointer to 'struct proc_mounts' into seq_operations

In addition the following cleanups are made:

 - use a common open function for /proc/<pid>/{mounts,mountstat}
 - surround namespace.c part of these proc files with #ifdef CONFIG_PROC_FS
 - make the seq_operations structures const

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c                |   14 +++--
 fs/proc/base.c                |  108 +++++++++++++++++++-----------------------
 include/linux/mnt_namespace.h |   11 ++++
 3 files changed, 70 insertions(+), 63 deletions(-)

Index: vfs-2.6/fs/namespace.c
===================================================================
--- vfs-2.6.orig/fs/namespace.c	2008-03-26 21:39:49.000000000 +0100
+++ vfs-2.6/fs/namespace.c	2008-03-26 21:43:03.000000000 +0100
@@ -731,20 +731,21 @@ void save_mount_options(struct super_blo
 }
 EXPORT_SYMBOL(save_mount_options);
 
+#ifdef CONFIG_PROC_FS
 /* iterator */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct mnt_namespace *n = m->private;
+	struct proc_mounts *p = m->private;
 
 	down_read(&namespace_sem);
-	return seq_list_start(&n->list, *pos);
+	return seq_list_start(&p->ns->list, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct mnt_namespace *n = m->private;
+	struct proc_mounts *p = m->private;
 
-	return seq_list_next(v, &n->list, pos);
+	return seq_list_next(v, &p->ns->list, pos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -801,7 +802,7 @@ static int show_vfsmnt(struct seq_file *
 	return err;
 }
 
-struct seq_operations mounts_op = {
+const struct seq_operations mounts_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
@@ -840,12 +841,13 @@ static int show_vfsstat(struct seq_file 
 	return err;
 }
 
-struct seq_operations mountstats_op = {
+const struct seq_operations mountstats_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
 	.show	= show_vfsstat,
 };
+#endif  /* CONFIG_PROC_FS */
 
 /**
  * may_umount_tree - check if a mount tree is busy
Index: vfs-2.6/fs/proc/base.c
===================================================================
--- vfs-2.6.orig/fs/proc/base.c	2008-03-26 21:37:52.000000000 +0100
+++ vfs-2.6/fs/proc/base.c	2008-03-26 21:43:03.000000000 +0100
@@ -502,17 +502,14 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-extern const struct seq_operations mounts_op;
-struct proc_mounts {
-	struct seq_file m;
-	int event;
-};
-
-static int mounts_open(struct inode *inode, struct file *file)
+static int mounts_open_common(struct inode *inode, struct file *file,
+			      const struct seq_operations *op)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct nsproxy *nsp;
 	struct mnt_namespace *ns = NULL;
+	struct fs_struct *fs = NULL;
+	struct path root;
 	struct proc_mounts *p;
 	int ret = -EINVAL;
 
@@ -525,40 +522,61 @@ static int mounts_open(struct inode *ino
 				get_mnt_ns(ns);
 		}
 		rcu_read_unlock();
-
+		if (ns)
+			fs = get_fs_struct(task);
 		put_task_struct(task);
 	}
 
-	if (ns) {
-		ret = -ENOMEM;
-		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
-		if (p) {
-			file->private_data = &p->m;
-			ret = seq_open(file, &mounts_op);
-			if (!ret) {
-				p->m.private = ns;
-				p->event = ns->event;
-				return 0;
-			}
-			kfree(p);
-		}
-		put_mnt_ns(ns);
-	}
+	if (!ns)
+		goto err;
+	if (!fs)
+		goto err_put_ns;
+
+	read_lock(&fs->lock);
+	root = fs->root;
+	path_get(&root);
+	read_unlock(&fs->lock);
+	put_fs_struct(fs);
+
+	ret = -ENOMEM;
+	p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
+	if (!p)
+		goto err_put_path;
+
+	file->private_data = &p->m;
+	ret = seq_open(file, op);
+	if (ret)
+		goto err_free;
+
+	p->m.private = p;
+	p->ns = ns;
+	p->root = root;
+	p->event = ns->event;
+
+	return 0;
+
+ err_free:
+	kfree(p);
+ err_put_path:
+	path_put(&root);
+ err_put_ns:
+	put_mnt_ns(ns);
+ err:
 	return ret;
 }
 
 static int mounts_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *m = file->private_data;
-	struct mnt_namespace *ns = m->private;
-	put_mnt_ns(ns);
+	struct proc_mounts *p = file->private_data;
+	path_put(&p->root);
+	put_mnt_ns(p->ns);
 	return seq_release(inode, file);
 }
 
 static unsigned mounts_poll(struct file *file, poll_table *wait)
 {
 	struct proc_mounts *p = file->private_data;
-	struct mnt_namespace *ns = p->m.private;
+	struct mnt_namespace *ns = p->ns;
 	unsigned res = 0;
 
 	poll_wait(file, &ns->poll, wait);
@@ -573,6 +591,11 @@ static unsigned mounts_poll(struct file 
 	return res;
 }
 
+static int mounts_open(struct inode *inode, struct file *file)
+{
+	return mounts_open_common(inode, file, &mounts_op);
+}
+
 static const struct file_operations proc_mounts_operations = {
 	.open		= mounts_open,
 	.read		= seq_read,
@@ -581,38 +604,9 @@ static const struct file_operations proc
 	.poll		= mounts_poll,
 };
 
-extern const struct seq_operations mountstats_op;
 static int mountstats_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open(file, &mountstats_op);
-
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		struct nsproxy *nsp;
-		struct mnt_namespace *mnt_ns = NULL;
-		struct task_struct *task = get_proc_task(inode);
-
-		if (task) {
-			rcu_read_lock();
-			nsp = task_nsproxy(task);
-			if (nsp) {
-				mnt_ns = nsp->mnt_ns;
-				if (mnt_ns)
-					get_mnt_ns(mnt_ns);
-			}
-			rcu_read_unlock();
-
-			put_task_struct(task);
-		}
-
-		if (mnt_ns)
-			m->private = mnt_ns;
-		else {
-			seq_release(inode, file);
-			ret = -EINVAL;
-		}
-	}
-	return ret;
+	return mounts_open_common(inode, file, &mountstats_op);
 }
 
 static const struct file_operations proc_mountstats_operations = {
Index: vfs-2.6/include/linux/mnt_namespace.h
===================================================================
--- vfs-2.6.orig/include/linux/mnt_namespace.h	2008-03-26 21:37:52.000000000 +0100
+++ vfs-2.6/include/linux/mnt_namespace.h	2008-03-26 21:43:03.000000000 +0100
@@ -5,6 +5,7 @@
 #include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
+#include <linux/seq_file.h>
 
 struct mnt_namespace {
 	atomic_t		count;
@@ -14,6 +15,13 @@ struct mnt_namespace {
 	int event;
 };
 
+struct proc_mounts {
+	struct seq_file m; /* must be the first element */
+	struct mnt_namespace *ns;
+	struct path root;
+	int event;
+};
+
 extern struct mnt_namespace *copy_mnt_ns(unsigned long, struct mnt_namespace *,
 		struct fs_struct *);
 extern void __put_mnt_ns(struct mnt_namespace *ns);
@@ -37,5 +45,8 @@ static inline void get_mnt_ns(struct mnt
 	atomic_inc(&ns->count);
 }
 
+extern const struct seq_operations mounts_op;
+extern const struct seq_operations mountstats_op;
+
 #endif
 #endif

--
