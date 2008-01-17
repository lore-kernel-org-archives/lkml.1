Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbYAQXmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbYAQXmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYAQXmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:42:00 -0500
Received: from ozlabs.org ([203.10.76.45]:53490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbYAQXl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:41:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove vfs_init_caches_early()
Date: Fri, 18 Jan 2008 10:41:21 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181041.22157.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfs_init_caches_early() does nothing on IA-64 and x86-64 (unless you
turn off CONFIG_NUMA): hashdist is set by default on these platforms.

Maybe some obscure feature which requires VFS to be set up v. early
(hence is broken in this configuration), or something arch-specific
(which seems unlikely).  Most likely this is a relic.

Unless someone has inside knowledge, the easiest way to find out is to
rip it out and see if anyone screams.  Boots fine on my 32-bit x86 box here.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/kernel-parameters.txt |    2 +-
 fs/dcache.c                         |   34 ----------------------------------
 fs/inode.c                          |   31 -------------------------------
 include/linux/fs.h                  |    2 --
 init/main.c                         |    1 -
 5 files changed, 1 insertion(+), 69 deletions(-)

diff -r e4dd27867542 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt	Fri Jan 18 09:59:22 2008 +1100
+++ b/Documentation/kernel-parameters.txt	Fri Jan 18 10:07:13 2008 +1100
@@ -662,7 +662,7 @@ and is between 256 and 4096 characters. 
 
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
-			for IA-64, off otherwise.
+			for IA-64 and x86-64, off otherwise.
 			Format: 0 | 1 (for off | on)
 
 	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
diff -r e4dd27867542 fs/dcache.c
--- a/fs/dcache.c	Fri Jan 18 09:59:22 2008 +1100
+++ b/fs/dcache.c	Fri Jan 18 10:07:13 2008 +1100
@@ -2082,30 +2082,6 @@ static int __init set_dhash_entries(char
 }
 __setup("dhash_entries=", set_dhash_entries);
 
-static void __init dcache_init_early(void)
-{
-	int loop;
-
-	/* If hashes are distributed across NUMA nodes, defer
-	 * hash allocation until vmalloc space is available.
-	 */
-	if (hashdist)
-		return;
-
-	dentry_hashtable =
-		alloc_large_system_hash("Dentry cache",
-					sizeof(struct hlist_head),
-					dhash_entries,
-					13,
-					HASH_EARLY,
-					&d_hash_shift,
-					&d_hash_mask,
-					0);
-
-	for (loop = 0; loop < (1 << d_hash_shift); loop++)
-		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
-}
-
 static void __init dcache_init(void)
 {
 	int loop;
@@ -2119,10 +2095,6 @@ static void __init dcache_init(void)
 		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 	
 	register_shrinker(&dcache_shrinker);
-
-	/* Hash may have been set up in dcache_init_early */
-	if (!hashdist)
-		return;
 
 	dentry_hashtable =
 		alloc_large_system_hash("Dentry cache",
@@ -2145,12 +2117,6 @@ struct kmem_cache *filp_cachep __read_mo
 struct kmem_cache *filp_cachep __read_mostly;
 
 EXPORT_SYMBOL(d_genocide);
-
-void __init vfs_caches_init_early(void)
-{
-	dcache_init_early();
-	inode_init_early();
-}
 
 void __init vfs_caches_init(unsigned long mempages)
 {
diff -r e4dd27867542 fs/inode.c
--- a/fs/inode.c	Fri Jan 18 09:59:22 2008 +1100
+++ b/fs/inode.c	Fri Jan 18 10:07:13 2008 +1100
@@ -1369,33 +1369,6 @@ static int __init set_ihash_entries(char
 }
 __setup("ihash_entries=", set_ihash_entries);
 
-/*
- * Initialize the waitqueues and inode hash table.
- */
-void __init inode_init_early(void)
-{
-	int loop;
-
-	/* If hashes are distributed across NUMA nodes, defer
-	 * hash allocation until vmalloc space is available.
-	 */
-	if (hashdist)
-		return;
-
-	inode_hashtable =
-		alloc_large_system_hash("Inode-cache",
-					sizeof(struct hlist_head),
-					ihash_entries,
-					14,
-					HASH_EARLY,
-					&i_hash_shift,
-					&i_hash_mask,
-					0);
-
-	for (loop = 0; loop < (1 << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
-}
-
 void __init inode_init(void)
 {
 	int loop;
@@ -1408,10 +1381,6 @@ void __init inode_init(void)
 					 SLAB_MEM_SPREAD),
 					 init_once);
 	register_shrinker(&icache_shrinker);
-
-	/* Hash may have been set up in inode_init_early */
-	if (!hashdist)
-		return;
 
 	inode_hashtable =
 		alloc_large_system_hash("Inode-cache",
diff -r e4dd27867542 include/linux/fs.h
--- a/include/linux/fs.h	Fri Jan 18 09:59:22 2008 +1100
+++ b/include/linux/fs.h	Fri Jan 18 10:07:13 2008 +1100
@@ -302,7 +302,6 @@ struct vfsmount;
 struct vfsmount;
 
 extern void __init inode_init(void);
-extern void __init inode_init_early(void);
 extern void __init mnt_init(void);
 extern void __init files_init(unsigned long);
 
@@ -1546,7 +1545,6 @@ extern char * getname(const char __user 
 extern char * getname(const char __user *);
 
 /* fs/dcache.c */
-extern void __init vfs_caches_init_early(void);
 extern void __init vfs_caches_init(unsigned long);
 
 extern struct kmem_cache *names_cachep;
diff -r e4dd27867542 init/main.c
--- a/init/main.c	Fri Jan 18 09:59:22 2008 +1100
+++ b/init/main.c	Fri Jan 18 10:07:13 2008 +1100
@@ -604,7 +604,6 @@ asmlinkage void __init start_kernel(void
 		initrd_start = 0;
 	}
 #endif
-	vfs_caches_init_early();
 	cpuset_init_early();
 	mem_init();
 	kmem_cache_init();
