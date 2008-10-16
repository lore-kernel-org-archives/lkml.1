Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYJPLx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYJPLx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYJPLw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:52:59 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:40396 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395AbYJPLw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:52:57 -0400
Date: Thu, 16 Oct 2008 14:03:53 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] use tmpfs for rootfs
Message-ID: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows chosing tmpfs instead of ramfs for the root filesystem. 
Having tmpfs is usefull for running systems from RAM, because it does not 
risk deadlocking the system and possibly allows swapping. Using tmpfs 
increases the kernel by 10 bytes on x86_64.

Having tmpfs as the root filesystem allows you to get rid of the now unused 
ramfs and free some kernel memory. On my system, that's about 5198 bytes 
compared to having a ramfs root.

Off cause you can mount tmpfs and move around the data, but this is slower
(having to copy around the data), more error-prone and it uses more memory.
Besides that, I don't see the point in explicitely doing the wrong thing
and then having everybody fix it.


Signed-off-by: Bodo Eggert <7eggert@gmx.de>

---
Some numbers for my system: (from make and from size vmlinux)

Setup is 10716 bytes (padded to 10752 bytes).
System is 2659 kB
text    data     bss     dec     hex filename
5341667  874212  562992 6778871  676ff7 vmlinux

having TMPFS_IS_ROOT:
Setup is 10716 bytes (padded to 10752 bytes).
System is 2659 kB
text    data     bss     dec     hex filename
5341677  874212  562992 6778881  677001 vmlinux
    +10

not having ramfs:
Setup is 10716 bytes (padded to 10752 bytes).
System is 2659 kB
text    data     bss     dec     hex filename
5336733  873948  562992 6773673  675ba9 vmlinux
  -4934    -264


 fs/Kconfig       |   21 +++++++++++++++++++++
 fs/ramfs/inode.c |   39 +++++++++++++++++++++------------------
 mm/shmem.c       |   26 ++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 18 deletions(-)


diff -pruNXdontdiff linux-2.6.27.2-numlock/fs/Kconfig linux-2.6.27.3-tmpfs/fs/Kconfig
--- linux-2.6.27.2-numlock/fs/Kconfig	2008-10-10 13:18:34.000000000 +0200
+++ linux-2.6.27.3-tmpfs/fs/Kconfig	2008-10-11 15:42:21.000000000 +0200
@@ -953,6 +953,27 @@ config TMPFS_POSIX_ACL
 
 	  If you don't know what Access Control Lists are, say N.
 
+config TMPFS_ROOT
+	bool "Use tmpfs instrad of ramfs for initramfs"
+	depends on TMPFS && SHMEM
+	default n
+	help
+	  This replaces the ramfs used for unpacking the cpio images
+	  with tmpfs.
+	  
+	  If unsure, say N
+
+config RAMFS
+ 	bool "Ramfs file system support" if TMPFS_ROOT
+  	default y
+  	---help---
+  	  Ramfs is a file system which keeps all files in RAM. Unlike tmpfs,
+  	  it cannot be swapped to disk, and it has the risk of deadlocking
+  	  the system by using all memory.
+
+  	  Ramfs is used for booting the system and unpacking the cpio if
+  	  TMPFS_ROOT is not set.
+
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || \
diff -pruNXdontdiff linux-2.6.27.2-numlock/fs/ramfs/inode.c linux-2.6.27.3-tmpfs/fs/ramfs/inode.c
--- linux-2.6.27.2-numlock/fs/ramfs/inode.c	2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.27.3-tmpfs/fs/ramfs/inode.c	2008-10-11 15:50:03.000000000 +0200
@@ -190,6 +190,13 @@ int ramfs_get_sb(struct file_system_type
 	return get_sb_nodev(fs_type, flags, data, ramfs_fill_super, mnt);
 }
 
+static struct file_system_type ramfs_fs_type = {
+	.name		= "ramfs",
+	.get_sb		= ramfs_get_sb,
+	.kill_sb	= kill_litter_super,
+};
+
+#ifndef CONFIG_TMPFS_ROOT
 static int rootfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
@@ -197,30 +204,12 @@ static int rootfs_get_sb(struct file_sys
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
 
-static int __init init_ramfs_fs(void)
-{
-	return register_filesystem(&ramfs_fs_type);
-}
-
-static void __exit exit_ramfs_fs(void)
-{
-	unregister_filesystem(&ramfs_fs_type);
-}
-
-module_init(init_ramfs_fs)
-module_exit(exit_ramfs_fs)
-
 int __init init_rootfs(void)
 {
 	int err;
@@ -235,5 +224,19 @@ int __init init_rootfs(void)
 
 	return err;
 }
+#endif
+
+static int __init init_ramfs_fs(void)
+{
+	return register_filesystem(&ramfs_fs_type);
+}
+
+static void __exit exit_ramfs_fs(void)
+{
+	unregister_filesystem(&ramfs_fs_type);
+}
+
+module_init(init_ramfs_fs)
+module_exit(exit_ramfs_fs)
 
 MODULE_LICENSE("GPL");
diff -pruNXdontdiff linux-2.6.27.2-numlock/mm/shmem.c linux-2.6.27.3-tmpfs/mm/shmem.c
--- linux-2.6.27.2-numlock/mm/shmem.c	2008-10-10 13:18:47.000000000 +0200
+++ linux-2.6.27.3-tmpfs/mm/shmem.c	2008-10-11 16:05:52.000000000 +0200
@@ -2366,6 +2366,10 @@ static void init_once(void *foo)
 
 static int init_inodecache(void)
 {
+#ifdef CONFIG_TMPFS_ROOT
+	if (shmem_inode_cachep)
+		return 0;
+#endif
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
 				0, SLAB_PANIC, init_once);
@@ -2583,6 +2587,28 @@ put_memory:
 	return ERR_PTR(error);
 }
 
+#ifdef CONFIG_TMPFS_ROOT
+static int rootfs_get_sb(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_nodev(fs_type, flags, data, shmem_fill_super, mnt);
+}
+
+ 
+ static struct file_system_type rootfs_fs_type = {
+ 	.name		= "rootfs",
+ 	.get_sb		= rootfs_get_sb,
+ 	.kill_sb	= kill_litter_super,
+ };
+ 
+ int __init init_rootfs(void)
+ {
+ 	if (init_inodecache())
+ 		panic("Can't initialize shm inode cache");
+ 	return register_filesystem(&rootfs_fs_type);
+ }
+ #endif
+ 
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
  * @vma: the vma to be mmapped is prepared by do_mmap_pgoff

-- 
"If your attack is going too well, you're walking into an ambush."
-Infantry Journal
