Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYLEWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYLEWo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbYLEWoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:44:20 -0500
Received: from waste.org ([66.93.16.53]:40171 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYLEWoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:44:19 -0500
Subject: Re: [PATCH] shmem: unify regular and tiny shmem
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812052218120.27321@blonde.anvils>
References: <1228425564.3255.121.camel@calx>
	 <Pine.LNX.4.64.0812051311530.10157@blonde.anvils>
	 <1228500936.3255.210.camel@calx>
	 <Pine.LNX.4.64.0812052218120.27321@blonde.anvils>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 16:43:53 -0600
Message-Id: <1228517033.3255.241.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 22:21 +0000, Hugh Dickins wrote:
> On Fri, 5 Dec 2008, Matt Mackall wrote:
> > On Fri, 2008-12-05 at 13:18 +0000, Hugh Dickins wrote:
> > > I agree with where you're going (surrendering your empire to mine!
> > > or perhaps you don't you see it quite that way?), but I think this
> > > isn't quite the patch you meant to send: it shouldn't contain that
> > > 
> > > > -			&shmem_file_operations);
> > > > +		  &shmem_file_operations);
> > > > +
> > > > +#ifndef CONFIG_MMU
> > > > +	error = ramfs_nommu_expand_for_mapping(inode, size);
> > > > +	if (error)
> > > > +		goto close_file;
> > > > +#endif
> > > 
> > > hunk in mm/shmem.c
> > 
> > I'm staring at the source and I'm at a loss as to why not? SHMEM depends
> > on MMU, so this only gets done when !SHMEM && !MMU, which makes it the
> > same as the tiny-shmem.c code it's unifying, no?
> 
> Sorry for wasting your time puzzling over that, it was just me getting
> confused with the ramfs_nommu_get_unmapped_area() bit which does vanish:
> this part is fine.
> 
> Hugh

Ok, here's a version with the rm of tiny-shmem restored. Andrew, please
apply.

 a/mm/tiny-shmem.c |  123 ------------------------------------------------------
 init/Kconfig      |    4 -
 mm/Makefile       |    4 -
 mm/shmem.c        |   81 +++++++++++++++++++++++++++++++----
 4 files changed, 72 insertions(+), 140 deletions(-)

shmem: unify regular and tiny shmem

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

diff -r 03b1e5320279 -r 4d7f11d413c3 init/Kconfig
--- a/init/Kconfig	Mon Oct 27 17:33:21 2008 -0500
+++ b/init/Kconfig	Mon Oct 27 17:33:24 2008 -0500
@@ -830,10 +830,6 @@
 	boolean
 	select PLIST
 
-config TINY_SHMEM
-	default !SHMEM
-	bool
-
 config BASE_SMALL
 	int
 	default 0 if BASE_FULL
diff -r 03b1e5320279 -r 4d7f11d413c3 mm/Makefile
--- a/mm/Makefile	Mon Oct 27 17:33:21 2008 -0500
+++ b/mm/Makefile	Mon Oct 27 17:33:24 2008 -0500
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
diff -r 03b1e5320279 -r 4d7f11d413c3 mm/shmem.c
--- a/mm/shmem.c	Mon Oct 27 17:33:21 2008 -0500
+++ b/mm/shmem.c	Mon Oct 27 17:33:24 2008 -0500
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
@@ -2486,7 +2494,6 @@
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
 };
-static struct vfsmount *shm_mnt;
 
 static int __init init_tmpfs(void)
 {
@@ -2525,7 +2532,51 @@
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
+#define shmem_file_operations ramfs_file_operations
+#define shmem_vm_ops generic_file_vm_ops
+#define shmem_get_inode ramfs_get_inode
+#define shmem_acct_size(a, b) 0
+#define shmem_unacct_size(a, b) do {} while (0)
+#define SHMEM_MAX_BYTES LLONG_MAX
+
+#endif /* CONFIG_SHMEM */
+
+/* common code */
 
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
@@ -2569,12 +2620,20 @@
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
@@ -2606,3 +2665,5 @@
 	vma->vm_ops = &shmem_vm_ops;
 	return 0;
 }
+
+module_init(init_tmpfs)
diff -r 03b1e5320279 -r 4d7f11d413c3 mm/tiny-shmem.c
--- a/mm/tiny-shmem.c	Mon Oct 27 17:33:21 2008 -0500
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,123 +0,0 @@
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
-	inode->i_nlink = 0;	/* It is unlinked */
-	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&ramfs_file_operations);
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
-EXPORT_SYMBOL_GPL(shmem_file_setup);
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


-- 
Mathematics is the supreme nostalgia of our time.

