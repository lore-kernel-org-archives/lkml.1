Return-Path: <linux-kernel-owner+w=401wt.eu-S932802AbXA1UGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbXA1UGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbXA1UGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:06:50 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32870 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbXA1UGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:06:48 -0500
Date: Sun, 28 Jan 2007 22:06:46 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org, hch@lst.de, alan@lxorguk.ukuu.org.uk
Subject: [RFC/PATCH] revokeat/frevoke system calls V5
Message-ID: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The revokeat(2) and frevoke(2) system calls invalidate open file
descriptors and shared mappings of an inode. After an successful
revocation, operations on file descriptors fail with the EBADF or
ENXIO error code for regular and device files,
respectively. Attempting to read from or write to a revoked mapping
causes SIGBUS.

The actual operation is done in two passes:

 1. Revoke all file descriptors that point to the given inode. We do
    this under tasklist_lock so that after this pass, we don't need
    to worry about racing with close(2) or dup(2).
   
 2. Take down shared memory mappings of each revoked file and close
    the file pointer.

The file descriptors are kept until the owning task does close(2) and
memory mapping ranges preserved until the owning task does munmap(2).

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 arch/i386/kernel/syscall_table.S |    3 
 fs/Makefile                      |    2 
 fs/ext2/file.c                   |    1 
 fs/ext3/file.c                   |    1 
 fs/file_table.c                  |    1 
 fs/revoke.c                      |  588 ++++++++++++++++++++++++++++++++++
 fs/revoked_inode.c               |  664 +++++++++++++++++++++++++++++++++++++++
 include/asm-i386/unistd.h        |    4 
 include/linux/file.h             |   14 
 include/linux/fs.h               |    6 
 include/linux/mm.h               |    2 
 include/linux/syscalls.h         |    3 
 mm/memory.c                      |    3 
 mm/mmap.c                        |   11 
 14 files changed, 1298 insertions(+), 5 deletions(-)

Index: 2.6/arch/i386/kernel/syscall_table.S
===================================================================
--- 2.6.orig/arch/i386/kernel/syscall_table.S
+++ 2.6/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,6 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+ 	.long sys_revokeat		/* 320 */
+ 	.long sys_frevoke
+
Index: 2.6/fs/Makefile
===================================================================
--- 2.6.orig/fs/Makefile
+++ 2.6/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o
+		stack.o revoke.o revoked_inode.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: 2.6/fs/revoke.c
===================================================================
--- /dev/null
+++ 2.6/fs/revoke.c
@@ -0,0 +1,588 @@
+/*
+ * fs/revoke.c - Invalidate all current open file descriptors of an inode.
+ *
+ * Copyright (C) 2006-2007  Pekka Enberg
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/sched.h>
+
+/*
+ * We pre-allocate an array of file pointers (including dummy inodes)
+ * so that we do not need to do kmalloc() under tasklist_lock.  The
+ * revoke operation is done in two passes: first we revoke all fds
+ * pointing to an inode and then we do close/munmap in a second pass.
+ */
+struct revoke_table {
+	struct file **files;
+	unsigned long nr_files;		/* capacity */
+	unsigned long nr_revoked;	/* used in first pass */
+	unsigned long nr_closed;	/* used in second pass */
+};
+
+struct kmem_cache *revokefs_inode_cache;
+
+/*
+ * Revoked file descriptors point to inodes in the revokefs filesystem.
+ */
+static struct vfsmount *revokefs_mnt;
+
+struct revokefs_inode_info {
+	struct task_struct *owner;
+	struct file *file;
+	unsigned int fd;
+	struct inode vfs_inode;
+};
+
+static inline struct revokefs_inode_info *REVOKEFS_I(struct inode *inode)
+{
+	return container_of(inode, struct revokefs_inode_info, vfs_inode);
+}
+
+extern void make_revoked_inode(struct inode *, int);
+
+static struct file *get_revoked_file(void)
+{
+	struct dentry *dentry;
+	struct inode *inode;
+	struct file *filp;
+	struct qstr name;
+
+	filp = get_empty_filp();
+	if (!filp)
+		goto err;
+
+	inode = new_inode(revokefs_mnt->mnt_sb);
+	if (!inode)
+		goto err_inode;
+
+	name.name = "revoked_file";
+	name.len = strlen(name.name);
+	dentry = d_alloc(revokefs_mnt->mnt_sb->s_root, &name);
+	if (!dentry)
+		goto err_dentry;
+
+	d_instantiate(dentry, inode);
+
+	filp->f_mapping = inode->i_mapping;
+	filp->f_dentry = dget(dentry);
+	filp->f_vfsmnt = mntget(revokefs_mnt);
+	filp->f_op = fops_get(inode->i_fop);
+	filp->f_pos = 0;
+
+	return filp;
+
+  err_dentry:
+	iput(inode);
+  err_inode:
+	fput(filp);
+  err:
+	return NULL;
+}
+
+static inline int inode_matches(struct file *file, struct inode *inode,
+				struct file *to_exclude)
+{
+	return file && file != to_exclude && file->f_dentry->d_inode == inode;
+}
+
+static inline bool revoke_table_is_full(struct revoke_table *table)
+{
+	return table->nr_revoked == table->nr_files;
+}
+
+static inline struct file *revoke_table_get(struct revoke_table *table)
+{
+	return table->files[table->nr_revoked++];
+}
+
+/*
+ * 	LOCKING: task_lock(owner)
+ */
+static int revoke_fds(struct task_struct *owner,
+		      struct inode *inode,
+		      struct file *to_exclude,
+		      struct revoke_table *table)
+{
+	struct files_struct *files;
+	struct fdtable *fdt;
+	unsigned int fd;
+	int err = 0;
+
+	files = get_files_struct(owner);
+	if (!files)
+		goto out;
+
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+
+	for (fd = 0; fd < fdt->max_fds; fd++) {
+		struct revokefs_inode_info *info;
+		struct file *filp, *new_filp;
+		struct inode *new_inode;
+
+		filp = fcheck_files(files, fd);
+		if (!inode_matches(filp, inode, to_exclude))
+			continue;
+
+		if (!filp->f_op->revoke) {
+			err = -EOPNOTSUPP;
+			goto failed;
+		}
+
+		if (revoke_table_is_full(table)) {
+			err = -ENOMEM;
+			goto failed;
+		}
+
+		new_filp = revoke_table_get(table);
+		get_file(new_filp);
+
+		/*
+		 * Replace original struct file pointer with a pointer to
+		 * a 'revoked file.'  After this point, we don't need to worry
+		 * about racing with sys_close or sys_dup.
+		 */
+		rcu_assign_pointer(fdt->fd[fd], new_filp);
+
+		/*
+		 * Hold on to task until we can take down the file and its
+		 * mmap.
+		 */
+		get_task_struct(owner);
+
+		new_inode = new_filp->f_dentry->d_inode;
+		make_revoked_inode(new_inode, inode->i_mode & S_IFMT);
+
+		info = REVOKEFS_I(new_inode);
+		info->fd = fd;
+		info->file = filp;
+		info->owner = owner;
+	}
+  failed:
+	spin_unlock(&files->file_lock);
+	put_files_struct(files);
+  out:
+	return err;
+}
+
+static int revoke_mmap(struct revokefs_inode_info *revoked)
+{
+	struct vm_area_struct *this, *next;
+	struct mm_struct *mm;
+	int err = 0;
+
+	mm = get_task_mm(revoked->owner);
+	down_write(&mm->mmap_sem);
+
+	this = mm->mmap;
+	while (this) {
+		next = this->vm_next;
+		if (this->vm_flags & VM_SHARED &&
+		    this->vm_file == revoked->file) {
+			this->vm_flags |= VM_REVOKED;
+			zap_page_range(this, this->vm_start,
+				this->vm_end - this->vm_start, NULL);
+		}
+		this = next;
+	}
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	return err;
+}
+
+static int revoke_filp(struct revokefs_inode_info *info)
+{
+	struct files_struct *files;
+	int err = 0;
+
+	files = get_files_struct(info->owner);
+	if (files) {
+		while (info->file->f_light)
+			schedule();
+		err = filp_close(info->file, files);
+		put_files_struct(files);
+	}
+	return err;
+}
+
+static void restore_file(struct revokefs_inode_info *info)
+{
+	struct files_struct *files;
+
+	files = get_files_struct(info->owner);
+	if (files) {
+		struct fdtable *fdt;
+		struct file *filp;
+
+		spin_lock(&files->file_lock);
+		fdt = files_fdtable(files);
+
+		filp = fdt->fd[info->fd];
+		if (filp)
+			fput(filp);
+
+		rcu_assign_pointer(fdt->fd[info->fd], info->file);
+		FD_SET(info->fd, fdt->close_on_exec);
+		spin_unlock(&files->file_lock);
+		put_files_struct(files);
+	}
+	put_task_struct(info->owner);
+	info->owner = NULL;	/* To avoid double-restore. */
+}
+
+static void restore_files(struct revoke_table *table)
+{
+	unsigned long i;
+
+	for (i = table->nr_closed; i < table->nr_files; i++) {
+		struct revokefs_inode_info *info;
+		struct file *filp;
+
+		filp = table->files[i];
+		info = REVOKEFS_I(filp->f_dentry->d_inode);
+		BUG_ON(!info->owner);
+
+		restore_file(info);
+	}
+}
+
+static int close_file(struct revokefs_inode_info *info)
+{
+	struct file *file;
+	int err;
+
+	err = revoke_mmap(info);
+	if (err)
+		goto out;
+
+	file = info->file;
+
+	err = file->f_op->revoke(file);
+	if (err)
+		goto out;
+
+	err = revoke_filp(info);
+  out:
+	return err;
+}
+
+static int close_files(struct revoke_table *table)
+{
+	unsigned long i;
+	int err = 0;
+
+	for (i = 0; i < table->nr_revoked; i++) {
+		struct revokefs_inode_info *info;
+		struct file *this;
+
+		this = table->files[i];
+		info = REVOKEFS_I(this->f_dentry->d_inode);
+		BUG_ON(!info->owner);
+
+		/*
+		 * Increase count before attempting to close file as
+		 * an partially closed file can no longer be restored.
+		 */
+		table->nr_closed++;
+		err = close_file(info);
+		put_task_struct(info->owner);
+		info->owner = NULL;	/* To avoid restoring closed file. */
+		if (err)
+			goto failed;
+	}
+	return 0;
+
+  failed:
+	restore_files(table);
+	return err;
+}
+
+/*
+ *	Returns the maximum number of fds pointing to inode.
+ *
+ *	LOCKING: read_lock(&tasklist_lock)
+ */
+static unsigned long inode_fds(struct inode *inode, struct file *to_exclude)
+{
+	struct task_struct *g, *p;
+	unsigned long nr_fds = 0;
+
+	do_each_thread(g, p) {
+		struct files_struct *files;
+		struct fdtable *fdt;
+		unsigned int fd;
+
+		files = get_files_struct(p);
+		if (!files)
+			continue;
+
+		spin_lock(&files->file_lock);
+		fdt = files_fdtable(files);
+		for (fd = 0; fd < fdt->max_fds; fd++) {
+			struct file *file;
+
+			file = fcheck_files(files, fd);
+			if (inode_matches(file, inode, to_exclude)) {
+				nr_fds += fdt->max_fds;
+				break;
+			}
+		}
+		spin_unlock(&files->file_lock);
+		put_files_struct(files);
+	} while_each_thread(g, p);
+	return nr_fds;
+}
+
+static void free_revoke_table(struct revoke_table *table)
+{
+	int i;
+
+	for (i = 0; i < table->nr_files; i++)
+		fput(table->files[i]);
+
+	kfree(table->files);
+	kfree(table);
+}
+
+static struct revoke_table *__alloc_revoke_table(unsigned long nr_fds)
+{
+	struct revoke_table *table;
+	int i;
+
+	table = kzalloc(sizeof *table, GFP_KERNEL);
+	if (!table)
+		return NULL;
+
+	table->nr_files = nr_fds;
+	table->files = kcalloc(nr_fds, sizeof(struct file *), GFP_KERNEL);
+	if (!table->files) {
+		kfree(table);
+		return NULL;
+	}
+
+	for (i = 0; i < table->nr_files; i++) {
+		struct file *filp;
+
+		filp = get_revoked_file();
+		if (!filp)
+			goto err;
+
+		table->files[i] = filp;
+	}
+	return table;
+  err:
+	free_revoke_table(table);
+	return NULL;
+}
+
+static struct revoke_table *alloc_revoke_table(struct inode *inode,
+					       struct file *to_exclude)
+{
+	unsigned long nr_fds;
+
+	read_lock(&tasklist_lock);
+	nr_fds = inode_fds(inode, to_exclude);
+	read_unlock(&tasklist_lock);
+
+	return __alloc_revoke_table(nr_fds);
+}
+
+static int do_revoke(struct inode *inode, struct file *to_exclude)
+{
+	struct revoke_table *table = NULL;
+	struct task_struct *g, *p;
+	int err = 0;
+
+	if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER)) {
+		err = -EPERM;
+		goto out;
+	}
+
+  retry:
+	if (signal_pending(current)) {
+		err = -ERESTARTSYS;
+		goto out;
+	}
+
+	table = alloc_revoke_table(inode, to_exclude);
+	if (!table) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	read_lock(&tasklist_lock);
+
+	/*
+	 * If someone forked while we were allocating memory, try again.
+	 */
+	if (inode_fds(inode, to_exclude) > table->nr_files) {
+		read_unlock(&tasklist_lock);
+		free_revoke_table(table);
+		goto retry;
+	}
+
+	/*
+	 * First revoke the fds. After we are done, no one can start new
+	 * operations on them.
+	 */
+	do_each_thread(g, p) {
+		err = revoke_fds(p, inode, to_exclude, table);
+		if (err)
+			goto exit_loop;
+	} while_each_thread(g, p);
+  exit_loop:
+	read_unlock(&tasklist_lock);
+
+	if (err) {
+		restore_files(table);
+		goto out;
+	}
+
+	/*
+	 * Now, take down the mmaps and close the files for good.
+	 */
+	err = close_files(table);
+  out:
+	free_revoke_table(table);
+	return err;
+}
+
+asmlinkage int sys_revokeat(int dfd, const char __user *filename)
+{
+	struct nameidata nd;
+	int err;
+
+	err = __user_walk_fd(dfd, filename, 0, &nd);
+	if (!err) {
+		err = do_revoke(nd.dentry->d_inode, NULL);
+		path_release(&nd);
+	}
+	return err;
+}
+
+asmlinkage int sys_frevoke(unsigned int fd)
+{
+	struct file *file = fget(fd);
+	int err = -EBADF;
+
+	if (file) {
+		err = do_revoke(file->f_dentry->d_inode, file);
+		fput(file);
+	}
+	return err;
+}
+
+int generic_file_revoke(struct file *file)
+{
+	int err;
+
+	/*
+	 * Flush pending writes.
+	 */
+	err = do_fsync(file, 1);
+	if (err)
+		goto out;
+
+	/*
+	 * Make pending reads fail.
+	 */
+	err = invalidate_inode_pages2(file->f_mapping);
+
+  out:
+	return err;
+}
+EXPORT_SYMBOL(generic_file_revoke);
+
+/*
+ *	Filesystem for revoked files.
+ */
+
+static struct inode *revokefs_alloc_inode(struct super_block *sb)
+{
+        struct revokefs_inode_info *info;
+
+	info = kmem_cache_alloc(revokefs_inode_cache, GFP_NOFS);
+	if (!info)
+		return NULL;
+
+	return &info->vfs_inode;
+}
+
+static void revokefs_destroy_inode(struct inode *inode)
+{
+        kmem_cache_free(revokefs_inode_cache, REVOKEFS_I(inode));
+}
+
+#define REVOKEFS_MAGIC	0x5245564B /* REVK */
+
+static struct super_operations revokefs_super_ops = {
+	.alloc_inode = revokefs_alloc_inode,
+	.destroy_inode = revokefs_destroy_inode,
+	.drop_inode = generic_delete_inode,
+};
+
+static int revokefs_get_sb(struct file_system_type *fs_type,
+			    int flags, const char *dev_name, void *data,
+			    struct vfsmount *mnt)
+
+{
+        return get_sb_pseudo(fs_type, "revoke:", &revokefs_super_ops, REVOKEFS_MAGIC, mnt);
+}
+
+struct file_system_type revokefs_fs_type = {
+	.name = "revokefs",
+	.get_sb = revokefs_get_sb,
+	.kill_sb = kill_anon_super
+};
+
+static void init_once(void *obj, struct kmem_cache *cache, unsigned long flags)
+{
+	struct revokefs_inode_info *info = obj;
+
+	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
+	    SLAB_CTOR_CONSTRUCTOR) {
+		info->owner = NULL;
+		inode_init_once(&info->vfs_inode);
+	}
+}
+
+static int __init revokefs_init(void)
+{
+	int err = -ENOMEM;
+
+	revokefs_inode_cache =
+		kmem_cache_create("revokefs_inode_cache",
+				  sizeof(struct revokefs_inode_info),
+				  0,
+				  (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
+				  init_once, NULL);
+	if (!revokefs_inode_cache)
+		goto out;
+
+	err = register_filesystem(&revokefs_fs_type);
+	if (err)
+		goto err_register;
+
+	revokefs_mnt = kern_mount(&revokefs_fs_type);
+	if (IS_ERR(revokefs_mnt)) {
+		err = PTR_ERR(revokefs_mnt);
+		goto err_mnt;
+	}
+  out:
+	return err;
+  err_mnt:
+	unregister_filesystem(&revokefs_fs_type);
+  err_register:
+	kmem_cache_destroy(revokefs_inode_cache);
+	return err;
+}
+late_initcall(revokefs_init);
Index: 2.6/include/asm-i386/unistd.h
===================================================================
--- 2.6.orig/include/asm-i386/unistd.h
+++ 2.6/include/asm-i386/unistd.h
@@ -325,10 +325,12 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_revokeat		320
+#define __NR_frevoke		321
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 322
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: 2.6/include/linux/syscalls.h
===================================================================
--- 2.6.orig/include/linux/syscalls.h
+++ 2.6/include/linux/syscalls.h
@@ -605,4 +605,7 @@ asmlinkage long sys_getcpu(unsigned __us
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage int sys_revokeat(int dfd, const char __user *filename);
+asmlinkage int sys_frevoke(unsigned int fd);
+
 #endif
Index: 2.6/fs/file_table.c
===================================================================
--- 2.6.orig/fs/file_table.c
+++ 2.6/fs/file_table.c
@@ -219,6 +219,7 @@ struct file fastcall *fget_light(unsigne
 	*fput_needed = 0;
 	if (likely((atomic_read(&files->count) == 1))) {
 		file = fcheck_files(files, fd);
+		set_f_light(file);
 	} else {
 		rcu_read_lock();
 		file = fcheck_files(files, fd);
Index: 2.6/include/linux/file.h
===================================================================
--- 2.6.orig/include/linux/file.h
+++ 2.6/include/linux/file.h
@@ -6,6 +6,7 @@
 #define __LINUX_FILE_H
 
 #include <asm/atomic.h>
+#include <linux/fs.h>
 #include <linux/posix_types.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
@@ -62,10 +63,23 @@ extern struct kmem_cache *filp_cachep;
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
 
+static inline void clear_f_light(struct file *file)
+{
+	file->f_light = 0;
+}
+
+static inline void set_f_light(struct file *file)
+{
+	if (file)
+		file->f_light = 1;
+}
+
 static inline void fput_light(struct file *file, int fput_needed)
 {
 	if (unlikely(fput_needed))
 		fput(file);
+	else
+		clear_f_light(file);
 }
 
 extern struct file * FASTCALL(fget(unsigned int fd));
Index: 2.6/include/linux/fs.h
===================================================================
--- 2.6.orig/include/linux/fs.h
+++ 2.6/include/linux/fs.h
@@ -737,6 +737,8 @@ struct file {
 	struct list_head	f_ep_links;
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
+	/* This instance is being used without holding a reference. */
+	int			f_light;
 	struct address_space	*f_mapping;
 };
 extern spinlock_t files_lock;
@@ -1098,6 +1100,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
+	int (*revoke)(struct file *);
 };
 
 struct inode_operations {
@@ -1732,6 +1735,9 @@ extern ssize_t generic_splice_sendpage(s
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		size_t len, unsigned int flags);
 
+/* fs/revoke.c */
+extern int generic_file_revoke(struct file *);
+
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
Index: 2.6/fs/ext2/file.c
===================================================================
--- 2.6.orig/fs/ext2/file.c
+++ 2.6/fs/ext2/file.c
@@ -56,6 +56,7 @@ const struct file_operations ext2_file_o
 	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke		= generic_file_revoke,
 };
 
 #ifdef CONFIG_EXT2_FS_XIP
Index: 2.6/include/linux/mm.h
===================================================================
--- 2.6.orig/include/linux/mm.h
+++ 2.6/include/linux/mm.h
@@ -169,6 +169,8 @@ extern unsigned int kobjsize(const void 
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 
+#define VM_REVOKED	0x04000000	/* Mapping has been revoked */
+
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
 #endif
Index: 2.6/mm/memory.c
===================================================================
--- 2.6.orig/mm/memory.c
+++ 2.6/mm/memory.c
@@ -2460,6 +2460,9 @@ int __handle_mm_fault(struct mm_struct *
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, write_access);
 
+	if (unlikely(vma->vm_flags & VM_REVOKED))
+		return VM_FAULT_SIGBUS;
+
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
Index: 2.6/mm/mmap.c
===================================================================
--- 2.6.orig/mm/mmap.c
+++ 2.6/mm/mmap.c
@@ -1028,6 +1028,8 @@ unsigned long do_mmap_pgoff(struct file 
 	error = -ENOMEM;
 munmap_back:
 	vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
+	if (unlikely(vma->vm_flags & VM_REVOKED))
+		return -ENODEV;
 	if (vma && vma->vm_start < addr + len) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
@@ -1679,13 +1681,16 @@ static void unmap_region(struct mm_struc
 {
 	struct vm_area_struct *next = prev? prev->vm_next: mm->mmap;
 	struct mmu_gather *tlb;
-	unsigned long nr_accounted = 0;
 
 	lru_add_drain();
 	tlb = tlb_gather_mmu(mm, 0);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
-	vm_unacct_memory(nr_accounted);
+	if (!(vma->vm_flags & VM_REVOKED)) {
+		unsigned long nr_accounted = 0;
+
+		unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
+		vm_unacct_memory(nr_accounted);
+	}
 	free_pgtables(&tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
 	tlb_finish_mmu(tlb, start, end);
Index: 2.6/fs/ext3/file.c
===================================================================
--- 2.6.orig/fs/ext3/file.c
+++ 2.6/fs/ext3/file.c
@@ -123,6 +123,7 @@ const struct file_operations ext3_file_o
 	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 struct inode_operations ext3_file_inode_operations = {
Index: 2.6/fs/revoked_inode.c
===================================================================
--- /dev/null
+++ 2.6/fs/revoked_inode.c
@@ -0,0 +1,664 @@
+/*
+ *  linux/fs/revoked_inode.c
+ *
+ *  Copyright (C) 1997, Stephen Tweedie
+ *
+ *  Provide stub functions for revoked inodes
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/stat.h>
+#include <linux/time.h>
+#include <linux/smp_lock.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+
+static loff_t revoked_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_read(struct file *filp, char __user * buf,
+				 size_t size, loff_t * ppos)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_write(struct file *filp, const char __user * buf,
+				  size_t siz, loff_t * ppos)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_aio_read(struct kiocb *iocb,
+				     const struct iovec *iov,
+				     unsigned long nr_segs, loff_t pos)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_aio_write(struct kiocb *iocb,
+				      const struct iovec *iov,
+				      unsigned long nr_segs, loff_t pos)
+{
+	return -EBADF;
+}
+
+static int revoked_file_readdir(struct file *filp, void *dirent,
+				filldir_t filldir)
+{
+	return -EBADF;
+}
+
+static unsigned int revoked_file_poll(struct file *filp, poll_table * wait)
+{
+	return POLLERR;
+}
+
+static int revoked_file_ioctl(struct inode *inode, struct file *filp,
+			      unsigned int cmd, unsigned long arg)
+{
+	return -EBADF;
+}
+
+static long revoked_file_unlocked_ioctl(struct file *file, unsigned cmd,
+					unsigned long arg)
+{
+	return -EBADF;
+}
+
+static long revoked_file_compat_ioctl(struct file *file, unsigned int cmd,
+				      unsigned long arg)
+{
+	return -EBADF;
+}
+
+static int revoked_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return -EBADF;
+}
+
+static int revoked_file_open(struct inode *inode, struct file *filp)
+{
+	return -EBADF;
+}
+
+static int revoked_file_flush(struct file *file, fl_owner_t id)
+{
+	return 0;
+}
+
+static int revoked_file_release(struct inode *inode, struct file *filp)
+{
+	return -EBADF;
+}
+
+static int revoked_file_fsync(struct file *file, struct dentry *dentry,
+			      int datasync)
+{
+	return -EBADF;
+}
+
+static int revoked_file_aio_fsync(struct kiocb *iocb, int datasync)
+{
+	return -EBADF;
+}
+
+static int revoked_file_fasync(int fd, struct file *filp, int on)
+{
+	return -EBADF;
+}
+
+static int revoked_file_lock(struct file *file, int cmd, struct file_lock *fl)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_sendfile(struct file *in_file, loff_t * ppos,
+				     size_t count, read_actor_t actor,
+				     void *target)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_sendpage(struct file *file, struct page *page,
+				     int off, size_t len, loff_t * pos,
+				     int more)
+{
+	return -EBADF;
+}
+
+static unsigned long revoked_file_get_unmapped_area(struct file *file,
+						    unsigned long addr,
+						    unsigned long len,
+						    unsigned long pgoff,
+						    unsigned long flags)
+{
+	return -EBADF;
+}
+
+static int revoked_file_check_flags(int flags)
+{
+	return -EBADF;
+}
+
+static int revoked_file_dir_notify(struct file *file, unsigned long arg)
+{
+	return -EBADF;
+}
+
+static int revoked_file_flock(struct file *filp, int cmd, struct file_lock *fl)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_splice_write(struct pipe_inode_info *pipe,
+					 struct file *out, loff_t * ppos,
+					 size_t len, unsigned int flags)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_file_splice_read(struct file *in, loff_t * ppos,
+					struct pipe_inode_info *pipe,
+					size_t len, unsigned int flags)
+{
+	return -EBADF;
+}
+
+static const struct file_operations revoked_file_ops = {
+	.llseek = revoked_file_llseek,
+	.read = revoked_file_read,
+	.write = revoked_file_write,
+	.aio_read = revoked_file_aio_read,
+	.aio_write = revoked_file_aio_write,
+	.readdir = revoked_file_readdir,
+	.poll = revoked_file_poll,
+	.ioctl = revoked_file_ioctl,
+	.unlocked_ioctl = revoked_file_unlocked_ioctl,
+	.compat_ioctl = revoked_file_compat_ioctl,
+	.mmap = revoked_file_mmap,
+	.open = revoked_file_open,
+	.flush = revoked_file_flush,
+	.release = revoked_file_release,
+	.fsync = revoked_file_fsync,
+	.aio_fsync = revoked_file_aio_fsync,
+	.fasync = revoked_file_fasync,
+	.lock = revoked_file_lock,
+	.sendfile = revoked_file_sendfile,
+	.sendpage = revoked_file_sendpage,
+	.get_unmapped_area = revoked_file_get_unmapped_area,
+	.check_flags = revoked_file_check_flags,
+	.dir_notify = revoked_file_dir_notify,
+	.flock = revoked_file_flock,
+	.splice_write = revoked_file_splice_write,
+	.splice_read = revoked_file_splice_read,
+};
+
+static int revoked_inode_create(struct inode *dir, struct dentry *dentry,
+				int mode, struct nameidata *nd)
+{
+	return -EBADF;
+}
+
+static struct dentry *revoked_inode_lookup(struct inode *dir,
+					   struct dentry *dentry,
+					   struct nameidata *nd)
+{
+	return ERR_PTR(-EBADF);
+}
+
+static int revoked_inode_link(struct dentry *old_dentry, struct inode *dir,
+			      struct dentry *dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_unlink(struct inode *dir, struct dentry *dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_symlink(struct inode *dir, struct dentry *dentry,
+				 const char *symname)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			       int mode)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_mknod(struct inode *dir, struct dentry *dentry,
+			       int mode, dev_t rdev)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_rename(struct inode *old_dir,
+				struct dentry *old_dentry,
+				struct inode *new_dir,
+				struct dentry *new_dentry)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_readlink(struct dentry *dentry, char __user * buffer,
+				  int buflen)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_permission(struct inode *inode, int mask,
+				    struct nameidata *nd)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_getattr(struct vfsmount *mnt, struct dentry *dentry,
+				 struct kstat *stat)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_setattr(struct dentry *direntry, struct iattr *attrs)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_inode_getxattr(struct dentry *dentry, const char *name,
+				      void *buffer, size_t size)
+{
+	return -EBADF;
+}
+
+static ssize_t revoked_inode_listxattr(struct dentry *dentry, char *buffer,
+				       size_t buffer_size)
+{
+	return -EBADF;
+}
+
+static int revoked_inode_removexattr(struct dentry *dentry, const char *name)
+{
+	return -EBADF;
+}
+
+static struct inode_operations revoked_inode_ops = {
+	.create = revoked_inode_create,
+	.lookup = revoked_inode_lookup,
+	.link = revoked_inode_link,
+	.unlink = revoked_inode_unlink,
+	.symlink = revoked_inode_symlink,
+	.mkdir = revoked_inode_mkdir,
+	.rmdir = revoked_inode_rmdir,
+	.mknod = revoked_inode_mknod,
+	.rename = revoked_inode_rename,
+	.readlink = revoked_inode_readlink,
+	/* follow_link must be no-op, otherwise unmounting this inode
+	   won't work */
+	/* put_link returns void */
+	/* truncate returns void */
+	.permission = revoked_inode_permission,
+	.getattr = revoked_inode_getattr,
+	.setattr = revoked_inode_setattr,
+	.setxattr = revoked_inode_setxattr,
+	.getxattr = revoked_inode_getxattr,
+	.listxattr = revoked_inode_listxattr,
+	.removexattr = revoked_inode_removexattr,
+	/* truncate_range returns void */
+};
+
+static loff_t revoked_special_file_llseek(struct file *file, loff_t offset,
+					  int origin)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_read(struct file *filp, char __user * buf,
+					 size_t size, loff_t * ppos)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_write(struct file *filp,
+					  const char __user * buf, size_t siz,
+					  loff_t * ppos)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_aio_read(struct kiocb *iocb,
+					     const struct iovec *iov,
+					     unsigned long nr_segs, loff_t pos)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_aio_write(struct kiocb *iocb,
+					      const struct iovec *iov,
+					      unsigned long nr_segs, loff_t pos)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_readdir(struct file *filp, void *dirent,
+					filldir_t filldir)
+{
+	return -ENXIO;
+}
+
+static unsigned int revoked_special_file_poll(struct file *filp,
+					      poll_table * wait)
+{
+	return POLLERR;
+}
+
+static int revoked_special_file_ioctl(struct inode *inode, struct file *filp,
+				      unsigned int cmd, unsigned long arg)
+{
+	return -ENXIO;
+}
+
+static long revoked_special_file_unlocked_ioctl(struct file *file, unsigned cmd,
+						unsigned long arg)
+{
+	return -ENXIO;
+}
+
+static long revoked_special_file_compat_ioctl(struct file *file,
+					      unsigned int cmd,
+					      unsigned long arg)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_mmap(struct file *file,
+				     struct vm_area_struct *vma)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_open(struct inode *inode, struct file *filp)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_flush(struct file *file, fl_owner_t id)
+{
+	return 0;
+}
+
+static int revoked_special_file_release(struct inode *inode, struct file *filp)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_fsync(struct file *file, struct dentry *dentry,
+				      int datasync)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_aio_fsync(struct kiocb *iocb, int datasync)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_fasync(int fd, struct file *filp, int on)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_lock(struct file *file, int cmd,
+				     struct file_lock *fl)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_sendfile(struct file *in_file,
+					     loff_t * ppos, size_t count,
+					     read_actor_t actor, void *target)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_sendpage(struct file *file,
+					     struct page *page, int off,
+					     size_t len, loff_t * pos, int more)
+{
+	return -ENXIO;
+}
+
+static unsigned long revoked_special_file_get_unmapped_area(struct file *file,
+							    unsigned long addr,
+							    unsigned long len,
+							    unsigned long pgoff,
+							    unsigned long flags)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_check_flags(int flags)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_dir_notify(struct file *file, unsigned long arg)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_file_flock(struct file *filp, int cmd,
+				      struct file_lock *fl)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_splice_write(struct pipe_inode_info *pipe,
+						 struct file *out,
+						 loff_t * ppos, size_t len,
+						 unsigned int flags)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_file_splice_read(struct file *in, loff_t * ppos,
+						struct pipe_inode_info *pipe,
+						size_t len, unsigned int flags)
+{
+	return -ENXIO;
+}
+
+static const struct file_operations revoked_special_file_ops = {
+	.llseek = revoked_special_file_llseek,
+	.read = revoked_special_file_read,
+	.write = revoked_special_file_write,
+	.aio_read = revoked_special_file_aio_read,
+	.aio_write = revoked_special_file_aio_write,
+	.readdir = revoked_special_file_readdir,
+	.poll = revoked_special_file_poll,
+	.ioctl = revoked_special_file_ioctl,
+	.unlocked_ioctl = revoked_special_file_unlocked_ioctl,
+	.compat_ioctl = revoked_special_file_compat_ioctl,
+	.mmap = revoked_special_file_mmap,
+	.open = revoked_special_file_open,
+	.flush = revoked_special_file_flush,
+	.release = revoked_special_file_release,
+	.fsync = revoked_special_file_fsync,
+	.aio_fsync = revoked_special_file_aio_fsync,
+	.fasync = revoked_special_file_fasync,
+	.lock = revoked_special_file_lock,
+	.sendfile = revoked_special_file_sendfile,
+	.sendpage = revoked_special_file_sendpage,
+	.get_unmapped_area = revoked_special_file_get_unmapped_area,
+	.check_flags = revoked_special_file_check_flags,
+	.dir_notify = revoked_special_file_dir_notify,
+	.flock = revoked_special_file_flock,
+	.splice_write = revoked_special_file_splice_write,
+	.splice_read = revoked_special_file_splice_read,
+};
+
+static int revoked_special_inode_create(struct inode *dir,
+					struct dentry *dentry, int mode,
+					struct nameidata *nd)
+{
+	return -ENXIO;
+}
+
+static struct dentry *revoked_special_inode_lookup(struct inode *dir,
+						   struct dentry *dentry,
+						   struct nameidata *nd)
+{
+	return ERR_PTR(-ENXIO);
+}
+
+static int revoked_special_inode_link(struct dentry *old_dentry,
+				      struct inode *dir, struct dentry *dentry)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_unlink(struct inode *dir,
+					struct dentry *dentry)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_symlink(struct inode *dir,
+					 struct dentry *dentry,
+					 const char *symname)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_mkdir(struct inode *dir, struct dentry *dentry,
+				       int mode)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_mknod(struct inode *dir, struct dentry *dentry,
+				       int mode, dev_t rdev)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_rename(struct inode *old_dir,
+					struct dentry *old_dentry,
+					struct inode *new_dir,
+					struct dentry *new_dentry)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_readlink(struct dentry *dentry,
+					  char __user * buffer, int buflen)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_permission(struct inode *inode, int mask,
+					    struct nameidata *nd)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_getattr(struct vfsmount *mnt,
+					 struct dentry *dentry,
+					 struct kstat *stat)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_setattr(struct dentry *direntry,
+					 struct iattr *attrs)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_setxattr(struct dentry *dentry,
+					  const char *name, const void *value,
+					  size_t size, int flags)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_inode_getxattr(struct dentry *dentry,
+					      const char *name, void *buffer,
+					      size_t size)
+{
+	return -ENXIO;
+}
+
+static ssize_t revoked_special_inode_listxattr(struct dentry *dentry,
+					       char *buffer, size_t buffer_size)
+{
+	return -ENXIO;
+}
+
+static int revoked_special_inode_removexattr(struct dentry *dentry,
+					     const char *name)
+{
+	return -ENXIO;
+}
+
+static struct inode_operations revoked_special_inode_ops = {
+	.create = revoked_special_inode_create,
+	.lookup = revoked_special_inode_lookup,
+	.link = revoked_special_inode_link,
+	.unlink = revoked_special_inode_unlink,
+	.symlink = revoked_special_inode_symlink,
+	.mkdir = revoked_special_inode_mkdir,
+	.rmdir = revoked_special_inode_rmdir,
+	.mknod = revoked_special_inode_mknod,
+	.rename = revoked_special_inode_rename,
+	.readlink = revoked_special_inode_readlink,
+	/* follow_link must be no-op, otherwise unmounting this inode
+	   won't work */
+	/* put_link returns void */
+	/* truncate returns void */
+	.permission = revoked_special_inode_permission,
+	.getattr = revoked_special_inode_getattr,
+	.setattr = revoked_special_inode_setattr,
+	.setxattr = revoked_special_inode_setxattr,
+	.getxattr = revoked_special_inode_getxattr,
+	.listxattr = revoked_special_inode_listxattr,
+	.removexattr = revoked_special_inode_removexattr,
+	/* truncate_range returns void */
+};
+
+void make_revoked_inode(struct inode *inode, int mode)
+{
+	remove_inode_hash(inode);
+
+	inode->i_mode = mode;
+	inode->i_atime = inode->i_mtime = inode->i_ctime =
+	    current_fs_time(inode->i_sb);
+
+	if (special_file(mode)) {
+		inode->i_op = &revoked_special_inode_ops;
+		inode->i_fop = &revoked_special_file_ops;
+	} else {
+		inode->i_op = &revoked_inode_ops;
+		inode->i_fop = &revoked_file_ops;
+	}
+}
