Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYLIWt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYLIWt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYLIWsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:48:55 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:58552 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbYLIWsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:48:53 -0500
Message-ID: <493EF5CD.2050206@cosmosbay.com>
Date: Tue, 09 Dec 2008 23:48:45 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs: filp_cachep can be static in fs/file_table.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 09 Dec 2008 23:48:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

Please find two cleanups before patch re-submission to use
SLAB_DESTROY_BY_RCU for "struct file".

Thank you

[PATCH] fs: filp_cachep can be static in fs/file_table.c

1) Documentation cleanup

Documentation/filesystems/files.txt was not updated when
f_count became an atomic_long_t.
atomic_long_inc_not_zero() is now used instead of atomic_inc_not_zero()

2) filp_cachep can be static to fs/file_table.c

Instead of creating the "filp" kmem_cache in vfs_caches_init(),
we can do it a litle be later in files_init(), so that filp_cachep
is static to fs/file_table.c

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 Documentation/filesystems/files.txt |    6 +++---
 fs/dcache.c                         |    6 ------
 fs/file_table.c                     |   10 +++++++++-
 include/linux/fdtable.h             |    2 --
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/files.txt b/Documentation/filesystems/files.txt
index bb0142f..ac2facc 100644
--- a/Documentation/filesystems/files.txt
+++ b/Documentation/filesystems/files.txt
@@ -76,13 +76,13 @@ the fdtable structure -
 5. Handling of the file structures is special. Since the look-up
    of the fd (fget()/fget_light()) are lock-free, it is possible
    that look-up may race with the last put() operation on the
-   file structure. This is avoided using atomic_inc_not_zero()
+   file structure. This is avoided using atomic_long_inc_not_zero()
    on ->f_count :
 
 	rcu_read_lock();
 	file = fcheck_files(files, fd);
 	if (file) {
-		if (atomic_inc_not_zero(&file->f_count))
+		if (atomic_long_inc_not_zero(&file->f_count))
 			*fput_needed = 1;
 		else
 		/* Didn't get the reference, someone's freed */
@@ -92,7 +92,7 @@ the fdtable structure -
 	....
 	return file;
 
-   atomic_inc_not_zero() detects if refcounts is already zero or
+   atomic_long_inc_not_zero() detects if refcounts is already zero or
    goes to zero during increment. If it does, we fail
    fget()/fget_light().
 
diff --git a/fs/dcache.c b/fs/dcache.c
index a1d86c7..fa1ba03 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2313,9 +2313,6 @@ static void __init dcache_init(void)
 /* SLAB cache for __getname() consumers */
 struct kmem_cache *names_cachep __read_mostly;
 
-/* SLAB cache for file structures */
-struct kmem_cache *filp_cachep __read_mostly;
-
 EXPORT_SYMBOL(d_genocide);
 
 void __init vfs_caches_init_early(void)
@@ -2337,9 +2334,6 @@ void __init vfs_caches_init(unsigned long mempages)
 	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
-	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-
 	dcache_init();
 	inode_init();
 	files_init(mempages);
diff --git a/fs/file_table.c b/fs/file_table.c
index 5ad0eca..a46e880 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -32,6 +32,9 @@ struct files_stat_struct files_stat = {
 /* public. Not pretty! */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
 
+/* SLAB cache for file structures */
+static struct kmem_cache *filp_cachep __read_mostly;
+
 static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
 static inline void file_free_rcu(struct rcu_head *head)
@@ -397,7 +400,12 @@ too_bad:
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
-	/* One file with associated inode and dcache is very roughly 1K. 
+
+	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+
+	/*
+	 * One file with associated inode and dcache is very roughly 1K. 
 	 * Per default don't use more than 10% of our memory for files. 
 	 */ 
 
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 4aab6f1..09d6c5b 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -57,8 +57,6 @@ struct files_struct {
 
 #define files_fdtable(files) (rcu_dereference((files)->fdt))
 
-extern struct kmem_cache *filp_cachep;
-
 struct file_operations;
 struct vfsmount;
 struct dentry;
