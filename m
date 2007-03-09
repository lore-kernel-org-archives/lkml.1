Return-Path: <linux-kernel-owner+w=401wt.eu-S965781AbXCIMYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965781AbXCIMYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965787AbXCIMYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:24:14 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41020 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965781AbXCIMYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:24:13 -0500
Date: Fri, 9 Mar 2007 14:24:11 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: dada1@cosmosbay.com, linux-kernel@vger.kernel.org
Subject: [PATCH] revoke: delayed file closing
Message-ID: <Pine.LNX.4.64.0703091423260.17046@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As explained by Eric Dumazet, one of the interests of fget_light() is
to avoid dirtying struct file which is broken by the newly added
file->f_light. In addition, fget_light() currently has a race window
between fcheck_files() and set_f_light().

To fix this, change sys_revoke() not to close the actual revoked file
immediately. Instead, we do filp_close() when the user does close(2)
on the revoked file descriptor.

Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/file_table.c              |    1 
 fs/revoke.c                  |   53 +++----------------------------------------
 fs/revoked_inode.c           |    3 +-
 include/linux/file.h         |   13 ----------
 include/linux/fs.h           |    2 -
 include/linux/revoked_fs_i.h |   20 ++++++++++++++++
 6 files changed, 26 insertions(+), 66 deletions(-)

Index: uml-2.6/fs/file_table.c
===================================================================
--- uml-2.6.orig/fs/file_table.c	2007-03-09 14:06:48.000000000 +0200
+++ uml-2.6/fs/file_table.c	2007-03-09 14:06:53.000000000 +0200
@@ -219,7 +219,6 @@
 	*fput_needed = 0;
 	if (likely((atomic_read(&files->count) == 1))) {
 		file = fcheck_files(files, fd);
-		set_f_light(file);
 	} else {
 		rcu_read_lock();
 		file = fcheck_files(files, fd);
Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-09 14:00:02.000000000 +0200
+++ uml-2.6/fs/revoke.c	2007-03-09 14:18:15.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/revoked_fs_i.h>
 
 /*
  * This is used for pre-allocating an array of file pointers so that we don't
@@ -33,20 +34,6 @@
  */
 static struct vfsmount *revokefs_mnt;
 
-struct revokefs_inode_info {
-	struct task_struct *owner;
-	struct file *file;
-	unsigned int fd;
-	struct inode vfs_inode;
-};
-
-static inline struct revokefs_inode_info *revokefs_i(struct inode *inode)
-{
-	return container_of(inode, struct revokefs_inode_info, vfs_inode);
-}
-
-extern void make_revoked_inode(struct inode *, int);
-
 static struct file *get_revoked_file(void)
 {
 	struct dentry *dentry;
@@ -235,24 +222,6 @@
 	return err;
 }
 
-static int task_filp_close(struct task_struct *task, struct file *filp)
-{
-	struct files_struct *files;
-	int err = 0;
-
-	files = get_files_struct(task);
-	if (files) {
-		/*
-		 * Wait until sys_read and sys_write are done.
-		 */
-		while (filp->f_light)
-			schedule();
-		err = filp_close(filp, files);
-		put_files_struct(files);
-	}
-	return err;
-}
-
 static void restore_file(struct revokefs_inode_info *info)
 {
 	struct files_struct *files;
@@ -293,19 +262,6 @@
 	}
 }
 
-static int revoke_file(struct task_struct *task, struct file *filp)
-{
-	int err;
-
-	err = filp->f_op->revoke(filp);
-	if (err)
-		goto out;
-
-	err = task_filp_close(task, filp);
-  out:
-	return err;
-}
-
 static int revoke_files(struct revoke_table *table)
 {
 	unsigned long i;
@@ -313,7 +269,7 @@
 
 	for (i = 0; i < table->end; i++) {
 		struct revokefs_inode_info *info;
-		struct file *this;
+		struct file *this, *filp;
 
 		this = table->files[i];
 		info = revokefs_i(this->f_dentry->d_inode);
@@ -323,7 +279,8 @@
 		 * an partially closed file can no longer be restored.
 		 */
 		table->restore_start++;
-		err = revoke_file(info->owner, info->file);
+		filp = info->file;
+		err = filp->f_op->revoke(filp);
 		put_task_struct(info->owner);
 		info->owner = NULL;	/* To avoid restoring closed file. */
 		if (err)
@@ -565,8 +522,6 @@
 	kmem_cache_free(revokefs_inode_cache, revokefs_i(inode));
 }
 
-#define REVOKEFS_MAGIC	0x5245564B	/* REVK */
-
 static struct super_operations revokefs_super_ops = {
 	.alloc_inode = revokefs_alloc_inode,
 	.destroy_inode = revokefs_destroy_inode,
Index: uml-2.6/fs/revoked_inode.c
===================================================================
--- uml-2.6.orig/fs/revoked_inode.c	2007-03-09 14:03:58.000000000 +0200
+++ uml-2.6/fs/revoked_inode.c	2007-03-09 14:05:21.000000000 +0200
@@ -17,6 +17,7 @@
 #include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
+#include <linux/revoked_fs_i.h>
 
 static loff_t revoked_file_llseek(struct file *file, loff_t offset, int origin)
 {
@@ -96,7 +97,7 @@
 
 static int revoked_file_flush(struct file *file, fl_owner_t id)
 {
-	return 0;
+	return filp_close(file, id);
 }
 
 static int revoked_file_release(struct inode *inode, struct file *filp)
Index: uml-2.6/include/linux/file.h
===================================================================
--- uml-2.6.orig/include/linux/file.h	2007-03-09 14:07:16.000000000 +0200
+++ uml-2.6/include/linux/file.h	2007-03-09 14:07:43.000000000 +0200
@@ -63,23 +63,10 @@
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
 
-static inline void clear_f_light(struct file *file)
-{
-	file->f_light = 0;
-}
-
-static inline void set_f_light(struct file *file)
-{
-	if (file)
-		file->f_light = 1;
-}
-
 static inline void fput_light(struct file *file, int fput_needed)
 {
 	if (unlikely(fput_needed))
 		fput(file);
-	else
-		clear_f_light(file);
 }
 
 extern struct file * FASTCALL(fget(unsigned int fd));
Index: uml-2.6/include/linux/fs.h
===================================================================
--- uml-2.6.orig/include/linux/fs.h	2007-03-09 14:07:02.000000000 +0200
+++ uml-2.6/include/linux/fs.h	2007-03-09 14:07:06.000000000 +0200
@@ -739,8 +739,6 @@
 	struct list_head	f_ep_links;
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
-	/* This instance is being used without holding a reference. */
-	int			f_light;
 	struct address_space	*f_mapping;
 };
 extern spinlock_t files_lock;
Index: uml-2.6/include/linux/revoked_fs_i.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ uml-2.6/include/linux/revoked_fs_i.h	2007-03-09 14:03:43.000000000 +0200
@@ -0,0 +1,20 @@
+#ifndef _LINUX_REVOKED_FS_I_H
+#define _LINUX_REVOKED_FS_I_H
+
+#define REVOKEFS_MAGIC 0x5245564B      /* REVK */
+
+struct revokefs_inode_info {
+	struct task_struct *owner;
+	struct file *file;
+	unsigned int fd;
+	struct inode vfs_inode;
+};
+
+static inline struct revokefs_inode_info *revokefs_i(struct inode *inode)
+{
+	return container_of(inode, struct revokefs_inode_info, vfs_inode);
+}
+
+void make_revoked_inode(struct inode *, int);
+
+#endif
