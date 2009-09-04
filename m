Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbZIDHE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbZIDHE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932748AbZIDHEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:04:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZIDG6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:39 -0400
Message-Id: <20090904065537.584827477@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:52:04 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 23/33] fs: icache atomic inodes_stat
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-inode_lock-scale-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect inodes_stat statistics with atomic ops rather than inode_lock.
---
 fs/cifs/inode.c      |    2 +-
 fs/fs-writeback.c    |    3 ++-
 fs/hugetlbfs/inode.c |    6 +++---
 fs/inode.c           |   28 +++++++++++++++-------------
 include/linux/fs.h   |    5 +++--
 mm/page-writeback.c  |    3 ++-
 6 files changed, 26 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -695,7 +695,8 @@ void sync_inodes_sb(struct super_block *
 		unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
 
 		wbc.nr_to_write = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 	} else
 		wbc.nr_to_write = LONG_MAX; /* doesn't actually matter */
 
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -386,7 +386,7 @@ static void hugetlbfs_forget_inode(struc
 	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
+		atomic_inc(&inodes_stat.nr_unused);
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
 			spin_unlock(&inode_lock);
 			return;
@@ -404,7 +404,7 @@ static void hugetlbfs_forget_inode(struc
 		spin_lock(&inode->i_lock);
 		inode->i_state &= ~I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
-		inodes_stat.nr_unused--;
+		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
@@ -416,7 +416,7 @@ static void hugetlbfs_forget_inode(struc
 	spin_lock(&inode->i_lock);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	inodes_stat.nr_inodes--;
+	atomic_dec(&inodes_stat.nr_unused);
 	spin_unlock(&inode_lock);
 	truncate_hugepages(inode, 0);
 	clear_inode(inode);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -101,7 +101,10 @@ static DEFINE_MUTEX(iprune_mutex);
 /*
  * Statistics gathering..
  */
-struct inodes_stat_t inodes_stat;
+struct inodes_stat_t inodes_stat = {
+	.nr_inodes = ATOMIC_INIT(0),
+	.nr_unused = ATOMIC_INIT(0),
+};
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
@@ -303,7 +306,7 @@ void __iget(struct inode *inode)
 
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
-	inodes_stat.nr_unused--;
+	atomic_dec(&inodes_stat.nr_unused);
 }
 
 /**
@@ -368,9 +371,7 @@ static void dispose_list(struct list_hea
 		destroy_inode(inode);
 		nr_disposed++;
 	}
-	spin_lock(&inode_lock);
-	inodes_stat.nr_inodes -= nr_disposed;
-	spin_unlock(&inode_lock);
+	atomic_sub(nr_disposed, &inodes_stat.nr_inodes);
 }
 
 /*
@@ -417,7 +418,7 @@ static int invalidate_list(struct list_h
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
-	inodes_stat.nr_unused -= count;
+	atomic_sub(count, &inodes_stat.nr_unused);
 	return busy;
 }
 
@@ -524,7 +525,7 @@ static void prune_icache(int nr_to_scan)
 		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
-	inodes_stat.nr_unused -= nr_pruned;
+	atomic_sub(nr_pruned, &inodes_stat.nr_unused);
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -556,7 +557,8 @@ static int shrink_icache_memory(int nr,
 			return -1;
 		prune_icache(nr);
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (atomic_read(&inodes_stat.nr_unused) / 100) *
+					sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -649,7 +651,7 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
+	atomic_inc(&inodes_stat.nr_inodes);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
@@ -1287,7 +1289,7 @@ void generic_delete_inode(struct inode *
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	inodes_stat.nr_inodes--;
+	atomic_dec(&inodes_stat.nr_inodes);
 	spin_unlock(&inode_lock);
 
 	security_inode_delete(inode);
@@ -1323,7 +1325,7 @@ static void generic_forget_inode(struct
 	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
+		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
@@ -1341,7 +1343,7 @@ static void generic_forget_inode(struct
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
+		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
@@ -1351,7 +1353,7 @@ static void generic_forget_inode(struct
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
+	atomic_dec(&inodes_stat.nr_inodes);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (inode->i_data.nrpages)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <asm/atomic.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -39,8 +40,8 @@ struct files_stat_struct {
 };
 
 struct inodes_stat_t {
-	int nr_inodes;
-	int nr_unused;
+	atomic_t nr_inodes;
+	atomic_t nr_unused;
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -779,7 +779,8 @@ static void wb_kupdate(unsigned long arg
 	next_jif = start_jif + msecs_to_jiffies(dirty_writeback_interval * 10);
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+			(atomic_read(&inodes_stat.nr_inodes) -
+			atomic_read(&inodes_stat.nr_unused));
 	while (nr_to_write > 0) {
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c
+++ linux-2.6/fs/cifs/inode.c
@@ -1428,7 +1428,7 @@ int cifs_revalidate(struct dentry *diren
 	}
 	cFYI(1, ("Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
 		 "jiffies %ld", full_path, direntry->d_inode,
-		 direntry->d_inode->i_count.counter, direntry,
+		 direntry->d_inode->i_count, direntry,
 		 direntry->d_time, jiffies));
 
 	if (cifsInode->time == 0) {


