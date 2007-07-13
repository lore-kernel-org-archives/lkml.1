Return-Path: <linux-kernel-owner+w=401wt.eu-S935443AbXGMTBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935443AbXGMTBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937057AbXGMTAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:00:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:62651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937000AbXGMTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:00:43 -0400
Date: Fri, 13 Jul 2007 21:00:30 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3][try 1] init: enable system-on-initramfs: root-on-tmpfs
In-Reply-To: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
Message-ID: <Pine.LNX.4.58.0707132059480.3303@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18G3pV7pMLPc+QFgkSxtou+kZRSGlN+s5geDk2
 Dm7ABo2ZvuWCUq+ApbeCec6yMgHreRUiKZi2GQJTX5ZrgbZRN2
 o/Ll5D4dxm5FzS63JvF/w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the root filesystem to tmpfs. Doing this makes having a system on
tmpfs much easier, while allowing to discard the now unnecessary ramfs.

Having the rootfs on tmpfs allows to safely run e.g. a rescue system without
using tricks. You might even include the rescue system into the kernel.

This is a rework of Al Boldi's "[PATCH] initramfs: Allow rootfs to use
tmpfs instead of ramfs". All the fame belongs to him, the bugs belong to me.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>


diff -Xdontdiff -pruN linux-2.6.22.base/fs/Kconfig linux-2.6.22.tmpfsroot/fs/Kconfig
--- linux-2.6.22.base/fs/Kconfig	2007-07-12 14:05:16.000000000 +0200
+++ linux-2.6.22.tmpfsroot/fs/Kconfig	2007-07-12 15:10:09.000000000 +0200
@@ -989,6 +989,22 @@ config TMPFS_POSIX_ACL
 
 	  If you don't know what Access Control Lists are, say N.
 
+config TMPFS_ROOT
+	bool "Use tmpfs instrad of ramfs for initramfs"
+	depends on TMPFS
+	default n
+	help
+	  This replaces the ramfs used for unpacking the cpio images
+	  with tmpfs, thereby allowing swapping these contents to disk and
+	  adding size limit support.
+	  
+	  Side effect:
+	  This is useful only if you don't plan on mounting a different
+	  root filesystem. Therefore it will change the default of the
+	  root= parameter to "rootfs".
+
+	  If unsure, say N
+
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || PPC64 || SPARC64 || SUPERH || BROKEN
@@ -1003,7 +1019,7 @@ config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
 config RAMFS
-	bool
+	bool "Ramfs file system support" if TMPFS_ROOT
 	default y
 	---help---
 	  Ramfs is a file system which keeps all files in RAM. It allows
diff -Xdontdiff -pruN linux-2.6.22.base/fs/ramfs/inode.c linux-2.6.22.tmpfsroot/fs/ramfs/inode.c
--- linux-2.6.22.base/fs/ramfs/inode.c	2007-07-12 14:05:17.000000000 +0200
+++ linux-2.6.22.tmpfsroot/fs/ramfs/inode.c	2007-07-12 15:01:32.000000000 +0200
@@ -189,6 +189,13 @@ int ramfs_get_sb(struct file_system_type
 	return get_sb_nodev(fs_type, flags, data, ramfs_fill_super, mnt);
 }
 
+static struct file_system_type ramfs_fs_type = {
+	.name		= "ramfs",
+	.get_sb		= ramfs_get_sb,
+	.kill_sb	= kill_litter_super,
+};
+
+#ifdef CONFIG_RAMFS_ROOTFS
 static int rootfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
@@ -196,17 +203,18 @@ static int rootfs_get_sb(struct file_sys
 			    mnt);
 }
 
-static struct file_system_type ramfs_fs_type = {
-	.name		= "ramfs",
-	.get_sb		= ramfs_get_sb,
-	.kill_sb	= kill_litter_super,
-};
 static struct file_system_type rootfs_fs_type = {
 	.name		= "rootfs",
 	.get_sb		= rootfs_get_sb,
 	.kill_sb	= kill_litter_super,
 };
 
+int __init init_rootfs(void)
+{
+	return register_filesystem(&rootfs_fs_type);
+}
+#endif
+
 static int __init init_ramfs_fs(void)
 {
 	return register_filesystem(&ramfs_fs_type);
@@ -220,9 +228,4 @@ static void __exit exit_ramfs_fs(void)
 module_init(init_ramfs_fs)
 module_exit(exit_ramfs_fs)
 
-int __init init_rootfs(void)
-{
-	return register_filesystem(&rootfs_fs_type);
-}
-
 MODULE_LICENSE("GPL");
diff -Xdontdiff -pruN linux-2.6.22.base/init/do_mounts.c linux-2.6.22.tmpfsroot/init/do_mounts.c
--- linux-2.6.22.base/init/do_mounts.c	2007-07-12 15:04:48.000000000 +0200
+++ linux-2.6.22.tmpfsroot/init/do_mounts.c	2007-07-12 14:53:07.000000000 +0200
@@ -24,7 +24,11 @@ int __initdata rd_doload;	/* 1 = load RA
 
 int root_mountflags = MS_RDONLY | MS_SILENT;
 char * __initdata root_device_name;
+#ifdef CONFIG_TMPFS_ROOT
+static char __initdata saved_root_name[64] = "rootfs";
+#else
 static char __initdata saved_root_name[64];
+#endif
 
 dev_t ROOT_DEV;
 
diff -Xdontdiff -pruN linux-2.6.22.base/mm/shmem.c linux-2.6.22.tmpfsroot/mm/shmem.c
--- linux-2.6.22.base/mm/shmem.c	2007-07-12 14:05:25.000000000 +0200
+++ linux-2.6.22.tmpfsroot/mm/shmem.c	2007-07-12 15:01:32.000000000 +0200
@@ -2369,6 +2369,8 @@ static void init_once(void *foo, struct 
 
 static int init_inodecache(void)
 {
+	if (shmem_inode_cachep)
+		return 0;
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
 				0, 0, init_once, NULL);
@@ -2582,6 +2584,34 @@ put_memory:
 	return ERR_PTR(error);
 }
 
+#ifdef CONFIG_TMPFS_ROOT
+static int rootfs_get_sb(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_nodev(fs_type, flags|MS_NOUSER, data, shmem_fill_super,
+	                    mnt);
+}
+
+/*static struct super_block *rootfs_get_sb(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data)
+{
+	return get_sb_single(fs_type, flags, data, shmem_fill_super);
+}*/
+
+static struct file_system_type rootfs_fs_type = {
+	.name		= "rootfs",
+	.get_sb		= rootfs_get_sb,
+	.kill_sb	= kill_litter_super,
+};
+
+int __init init_rootfs(void)
+{
+	if (init_inodecache())
+		panic("Can't initialize shm inode cache");
+	return register_filesystem(&rootfs_fs_type);
+}
+#endif
+
 /*
  * shmem_zero_setup - setup a shared anonymous mapping
  *
