Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZDYBbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZDYBbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZDYB3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZDYB2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:50 -0400
Message-Id: <20090425012212.529358405@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:44 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 24/27] fs: icache atomic inodes_stat
References: <20090425012020.457460929@suse.de>
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
@@ -691,7 +691,8 @@ void sync_inodes_sb(struct super_block *
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
@@ -395,7 +395,7 @@ static void hugetlbfs_forget_inode(struc
 	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
+		atomic_inc(&inodes_stat.nr_unused);
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
 			spin_unlock(&inode_lock);
 			return;
@@ -413,7 +413,7 @@ static void hugetlbfs_forget_inode(struc
 		spin_lock(&inode->i_lock);
 		inode->i_state &= ~I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
-		inodes_stat.nr_unused--;
+		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
@@ -425,7 +425,7 @@ static void hugetlbfs_forget_inode(struc
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
@@ -99,7 +99,10 @@ static DEFINE_MUTEX(iprune_mutex);
 /*
  * Statistics gathering..
  */
-struct inodes_stat_t inodes_stat;
+struct inodes_stat_t inodes_stat = {
+	.nr_inodes = ATOMIC_INIT(0),
+	.nr_unused = ATOMIC_INIT(0),
+};
 
 static struct kmem_cache * inode_cachep __read_mostly;
 
@@ -276,7 +279,7 @@ void __iget(struct inode * inode)
 
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
-	inodes_stat.nr_unused--;
+	atomic_dec(&inodes_stat.nr_unused);
 }
 
 /**
@@ -342,9 +345,7 @@ static void dispose_list(struct list_hea
 		destroy_inode(inode);
 		nr_disposed++;
 	}
-	spin_lock(&inode_lock);
-	inodes_stat.nr_inodes -= nr_disposed;
-	spin_unlock(&inode_lock);
+	atomic_sub(nr_disposed, &inodes_stat.nr_inodes);
 }
 
 /*
@@ -391,7 +392,7 @@ static int invalidate_list(struct list_h
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
-	inodes_stat.nr_unused -= count;
+	atomic_sub(count, &inodes_stat.nr_unused);
 	return busy;
 }
 
@@ -498,7 +499,7 @@ static void prune_icache(int nr_to_scan)
 		spin_unlock(&inode->i_lock);
 		nr_pruned++;
 	}
-	inodes_stat.nr_unused -= nr_pruned;
+	atomic_sub(nr_pruned, &inodes_stat.nr_unused);
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
@@ -530,7 +531,8 @@ static int shrink_icache_memory(int nr,
 			return -1;
 		prune_icache(nr);
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (atomic_read(&inodes_stat.nr_unused) / 100) *
+					sysctl_vfs_cache_pressure;
 }
 
 static struct shrinker icache_shrinker = {
@@ -619,7 +621,7 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	inodes_stat.nr_inodes++;
+	atomic_inc(&inodes_stat.nr_inodes);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
@@ -1227,7 +1229,7 @@ void generic_delete_inode(struct inode *
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
-	inodes_stat.nr_inodes--;
+	atomic_dec(&inodes_stat.nr_inodes);
 	spin_unlock(&inode_lock);
 
 	security_inode_delete(inode);
@@ -1264,7 +1266,7 @@ static void generic_forget_inode(struct
 	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
+		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
@@ -1282,7 +1284,7 @@ static void generic_forget_inode(struct
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
+		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
@@ -1292,7 +1294,7 @@ static void generic_forget_inode(struct
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
@@ -775,7 +775,8 @@ static void wb_kupdate(unsigned long arg
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
@@ -1507,7 +1507,7 @@ int cifs_revalidate(struct dentry *diren
 	}
 	cFYI(1, ("Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
 		 "jiffies %ld", full_path, direntry->d_inode,
-		 direntry->d_inode->i_count.counter, direntry,
+		 direntry->d_inode->i_count, direntry,
 		 direntry->d_time, jiffies));
 
 	if (cifsInode->time == 0) {


