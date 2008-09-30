Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYI3Xwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYI3Xwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYI3Xwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:52:30 -0400
Received: from waste.org ([66.93.16.53]:33166 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYI3Xw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:52:28 -0400
Subject: [PATCH] mm: unify shmem and tiny-shmem
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 18:49:30 -0500
Message-Id: <1222818570.13453.5.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This applies on top of Nick's second tiny-shmem patch, which hasn't
made it to mainline yet(!). But as this deletes tiny-shmem.c, you can
probably ignore the rejects.)

tiny-shmem shares most of its 130 lines of code with shmem and tends
to break when particular bits of shmem get modified. Unifying saves
code and makes keeping these two in sync much easier.

before:
  14367	    392	     24	  14783	   39bf	mm/shmem.o
    396      72       8     476	    1dc	mm/tiny-shmem.o

after:
  14367	    392	     24	  14783	   39bf	mm/shmem.o
    412	     72       8     492	    1ec	mm/shmem.o tiny

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 04ceba0d1126 -r 4d75a71b1e9d init/Kconfig
--- a/init/Kconfig	Tue Sep 30 15:36:27 2008 -0500
+++ b/init/Kconfig	Tue Sep 30 18:44:12 2008 -0500
@@ -805,10 +805,6 @@
 	boolean
 	select PLIST
 
-config TINY_SHMEM
-	default !SHMEM
-	bool
-
 config BASE_SMALL
 	int
 	default 0 if BASE_FULL
diff -r 04ceba0d1126 -r 4d75a71b1e9d mm/Makefile
--- a/mm/Makefile	Tue Sep 30 15:36:27 2008 -0500
+++ b/mm/Makefile	Tue Sep 30 18:44:12 2008 -0500
@@ -9,7 +9,7 @@
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o pdflush.o \
-			   readahead.o swap.o truncate.o vmscan.o \
+			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
 
@@ -21,9 +21,7 @@
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
-obj-$(CONFIG_SHMEM) += shmem.o
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
-obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_SLAB) += slab.o
diff -r 04ceba0d1126 -r 4d75a71b1e9d mm/shmem.c
--- a/mm/shmem.c	Tue Sep 30 15:36:27 2008 -0500
+++ b/mm/shmem.c	Tue Sep 30 18:44:12 2008 -0500
@@ -14,31 +14,39 @@
  * Copyright (c) 2004, Luke Kenneth Casson Leighton <lkcl@lkcl.net>
  * Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
  *
+ * tiny-shmem:
+ * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
+ *
  * This file is released under the GPL.
  */
 
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/vfs.h>
+#include <linux/mount.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/swap.h>
+
+static struct vfsmount *shm_mnt;
+
+#ifdef CONFIG_SHMEM
 /*
  * This virtual memory filesystem is heavily based on the ramfs. It
  * extends ramfs by the ability to use swap and honor resource limits
  * which makes it a completely usable filesystem.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/fs.h>
 #include <linux/xattr.h>
 #include <linux/exportfs.h>
 #include <linux/generic_acl.h>
-#include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/file.h>
-#include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/shmem_fs.h>
-#include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/vfs.h>
 #include <linux/blkdev.h>
@@ -2483,7 +2491,6 @@
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
 };
-static struct vfsmount *shm_mnt;
 
 static int __init init_tmpfs(void)
 {
@@ -2522,7 +2529,62 @@
 	shm_mnt = ERR_PTR(error);
 	return error;
 }
-module_init(init_tmpfs)
+
+#else /* !CONFIG_SHMEM */
+
+/*
+ * tiny-shmem: simple shmemfs and tmpfs using ramfs code
+ *
+ * This is intended for small system where the benefits of the full
+ * shmem code (swap-backed and resource-limited) are outweighed by
+ * their complexity. On systems without swap this code should be
+ * effectively equivalent, but much lighter weight.
+ */
+
+#include <linux/ramfs.h>
+
+static struct file_system_type tmpfs_fs_type = {
+	.name		= "tmpfs",
+	.get_sb		= ramfs_get_sb,
+	.kill_sb	= kill_litter_super,
+};
+
+static int __init init_tmpfs(void)
+{
+	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
+
+	shm_mnt = kern_mount(&tmpfs_fs_type);
+	BUG_ON(IS_ERR(shm_mnt));
+
+	return 0;
+}
+
+int shmem_unuse(swp_entry_t entry, struct page *page)
+{
+	return 0;
+}
+
+#ifndef CONFIG_MMU
+unsigned long shmem_get_unmapped_area(struct file *file,
+				      unsigned long addr,
+				      unsigned long len,
+				      unsigned long pgoff,
+				      unsigned long flags)
+{
+	return ramfs_nommu_get_unmapped_area(file, addr, len, pgoff, flags);
+}
+#endif
+
+#define shmem_file_operations ramfs_file_operations
+#define shmem_unacct_size(a, b)
+#define shmem_vm_ops generic_file_vm_ops
+#define shmem_get_inode ramfs_get_inode
+#define SHMEM_MAX_BYTES LONG_MAX
+#define shmem_acct_size(a, b) 0
+
+#endif /* CONFIG_SHMEM */
+
+/* common code */
 
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
@@ -2566,12 +2628,20 @@
 	if (!inode)
 		goto close_file;
 
+#ifdef CONFIG_SHMEM
 	SHMEM_I(inode)->flags = flags & VM_ACCOUNT;
+#endif
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;	/* It is unlinked */
 	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&shmem_file_operations);
+		  &shmem_file_operations);
+
+#ifndef CONFIG_MMU
+	error = ramfs_nommu_expand_for_mapping(inode, size);
+	if (error)
+		goto close_file;
+#endif
 	return file;
 
 close_file:
@@ -2602,3 +2672,5 @@
 	vma->vm_ops = &shmem_vm_ops;
 	return 0;
 }
+
+module_init(init_tmpfs)
diff -r 04ceba0d1126 -r 4d75a71b1e9d mm/tiny-shmem.c
--- a/mm/tiny-shmem.c	Tue Sep 30 15:36:27 2008 -0500
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,133 +0,0 @@
-/*
- * tiny-shmem.c: simple shmemfs and tmpfs using ramfs code
- *
- * Matt Mackall <mpm@selenic.com> January, 2004
- * derived from mm/shmem.c and fs/ramfs/inode.c
- *
- * This is intended for small system where the benefits of the full
- * shmem code (swap-backed and resource-limited) are outweighed by
- * their complexity. On systems without swap this code should be
- * effectively equivalent, but much lighter weight.
- */
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/vfs.h>
-#include <linux/mount.h>
-#include <linux/file.h>
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/swap.h>
-#include <linux/ramfs.h>
-
-static struct file_system_type tmpfs_fs_type = {
-	.name		= "tmpfs",
-	.get_sb		= ramfs_get_sb,
-	.kill_sb	= kill_litter_super,
-};
-
-static struct vfsmount *shm_mnt;
-
-static int __init init_tmpfs(void)
-{
-	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
-
-	shm_mnt = kern_mount(&tmpfs_fs_type);
-	BUG_ON(IS_ERR(shm_mnt));
-
-	return 0;
-}
-module_init(init_tmpfs)
-
-/**
- * shmem_file_setup - get an unlinked file living in tmpfs
- * @name: name for dentry (to be seen in /proc/<pid>/maps
- * @size: size to be set for the file
- * @flags: vm_flags
- */
-struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
-{
-	int error;
-	struct file *file;
-	struct inode *inode;
-	struct dentry *dentry, *root;
-	struct qstr this;
-
-	if (IS_ERR(shm_mnt))
-		return (void *)shm_mnt;
-
-	error = -ENOMEM;
-	this.name = name;
-	this.len = strlen(name);
-	this.hash = 0; /* will go */
-	root = shm_mnt->mnt_root;
-	dentry = d_alloc(root, &this);
-	if (!dentry)
-		goto put_memory;
-
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto put_dentry;
-
-	error = -ENOSPC;
-	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
-	if (!inode)
-		goto close_file;
-
-	d_instantiate(dentry, inode);
-	inode->i_size = size;
-        inode->i_nlink = 0;     /* It is unlinked */
-        init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-                        &ramfs_file_operations);
-
-#ifndef CONFIG_MMU
-	error = ramfs_nommu_expand_for_mapping(inode, size);
-	if (error)
-		goto close_file;
-#endif
-	return file;
-
-close_file:
-	put_filp(file);
-put_dentry:
-	dput(dentry);
-put_memory:
-	return ERR_PTR(error);
-}
-
-/**
- * shmem_zero_setup - setup a shared anonymous mapping
- * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
- */
-int shmem_zero_setup(struct vm_area_struct *vma)
-{
-	struct file *file;
-	loff_t size = vma->vm_end - vma->vm_start;
-
-	file = shmem_file_setup("dev/zero", size, vma->vm_flags);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
-	if (vma->vm_file)
-		fput(vma->vm_file);
-	vma->vm_file = file;
-	vma->vm_ops = &generic_file_vm_ops;
-	return 0;
-}
-
-int shmem_unuse(swp_entry_t entry, struct page *page)
-{
-	return 0;
-}
-
-#ifndef CONFIG_MMU
-unsigned long shmem_get_unmapped_area(struct file *file,
-				      unsigned long addr,
-				      unsigned long len,
-				      unsigned long pgoff,
-				      unsigned long flags)
-{
-	return ramfs_nommu_get_unmapped_area(file, addr, len, pgoff, flags);
-}
-#endif

-- 
Mathematics is the supreme nostalgia of our time.

