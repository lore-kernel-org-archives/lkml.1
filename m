Return-Path: <linux-kernel-owner+w=401wt.eu-S1765456AbXLNPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765456AbXLNPta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbXLNPs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:48:57 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55688 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbXLNPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:48:53 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 1/2] Unionfs: avoid using drop_pagecache_sb in remount
Date: Fri, 14 Dec 2007 10:48:00 -0500
Message-Id: <11976472812568-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11976472813872-git-send-email-ezk@cs.sunysb.edu>
References: <11976472813872-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting drop_pagecache_sb to modules is somewhat risky because one cannot
sleep inside invalidate_mapping_pages.  This could cause a lot of latency in
the pre-emption code.  So don't export this symbol to minimize the risk that
others will use it.

Instead, unionfs will try to directly invalidate as many pages it can from
the unionfs_remount code.  Invalidating those inode pages is not strictly
required, but helpful in encouraging a revalidation of inodes sooner than
waiting for individual f/s ops to access the union.  Since a remount is
already an expensive but rare operation, this inode pages invalidation
shouldn't add too much overhead.

CC: Nick Piggin <nickpiggin@yahoo.com.au>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/drop_caches.c    |    4 +---
 fs/unionfs/dentry.c |   11 +++++++++++
 fs/unionfs/super.c  |   34 ++++++++++++----------------------
 fs/unionfs/union.h  |    1 +
 include/linux/mm.h  |    2 --
 5 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 90410ac..59375ef 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/writeback.h>
@@ -13,7 +12,7 @@
 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
 
-void drop_pagecache_sb(struct super_block *sb)
+static void drop_pagecache_sb(struct super_block *sb)
 {
 	struct inode *inode;
 
@@ -25,7 +24,6 @@ void drop_pagecache_sb(struct super_block *sb)
 	}
 	spin_unlock(&inode_lock);
 }
-EXPORT_SYMBOL(drop_pagecache_sb);
 
 void drop_pagecache(void)
 {
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 7d27987..c7b6a7c 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -276,6 +276,17 @@ static inline void purge_inode_data(struct inode *inode)
 		truncate_inode_pages(&inode->i_data, 0);
 }
 
+void purge_sb_data(struct super_block *sb)
+{
+	struct inode *inode;
+
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (inode->i_state & (I_FREEING|I_WILL_FREE))
+			continue;
+		purge_inode_data(inode);
+	}
+}
+
 /*
  * Revalidate a parent chain of dentries, then the actual node.
  * Assumes that dentry is locked, but will lock all parents if/when needed.
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index d9cf2a7..0ff9a9e 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -704,29 +704,19 @@ out_no_change:
 	 */
 
 	/*
-	 * Now we call drop_pagecache_sb() to invalidate all pages in this
-	 * super.  This function calls invalidate_inode_pages(mapping),
-	 * which calls invalidate_mapping_pages(): the latter, however, will
-	 * not invalidate pages which are dirty, locked, under writeback, or
-	 * mapped into page tables.  We shouldn't have to worry about dirty
-	 * or under-writeback pages, because do_remount_sb() called
-	 * fsync_super() which would not have returned until all dirty pages
-	 * were flushed.
-	 *
-	 * But do we have to worry about locked pages?  Is there any chance
-	 * that in here we'll get locked pages?
-	 *
-	 * XXX: what about pages mapped into pagetables?  Are these pages
-	 * which user processes may have mmap(2)'ed?  If so, then we need to
-	 * invalidate those too, no?  Maybe we'll have to write our own
-	 * version of invalidate_mapping_pages() which also handled mapped
-	 * pages.
-	 *
-	 * XXX: Alternatively, maybe we should call truncate_inode_pages(),
-	 * which use two passes over the pages list, and will truncate all
-	 * pages.
+	 * Once we finish the remounting successfully, our superblock
+	 * generation number will have increased.  This will be detected by
+	 * our dentry-revalidation code upon subsequent f/s operations
+	 * through unionfs.  The revalidation code will rebuild the union of
+	 * lower inodes for a given unionfs inode and invalidate any pages
+	 * of such "stale" inodes (by calling our purge_inode_data
+	 * function).  This revalidation will happen lazily and
+	 * incrementally, as users perform operations on cached inodes.  We
+	 * would like to encourage this revalidation to happen sooner if
+	 * possible, so we try to invalidate as many other pages in our
+	 * superblock as we can.
 	 */
-	drop_pagecache_sb(sb);
+	purge_sb_data(sb);
 
 	/* copy new vectors into their correct place */
 	tmp_data = UNIONFS_SB(sb)->data;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 20bff7b..b1bcb42 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -362,6 +362,7 @@ extern int unionfs_rmdir(struct inode *dir, struct dentry *dentry);
 extern bool __unionfs_d_revalidate_chain(struct dentry *dentry,
 					 struct nameidata *nd, bool willwrite);
 extern bool is_newer_lower(const struct dentry *dentry);
+extern void purge_sb_data(struct super_block *sb);
 
 /* The values for unionfs_interpose's flag. */
 #define INTERPOSE_DEFAULT	0
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fc61bd3..1b7b95c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -19,7 +19,6 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
-struct super_block;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -1136,7 +1135,6 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
-extern void drop_pagecache_sb(struct super_block *);
 void drop_pagecache(void);
 void drop_slab(void);
 
-- 
1.5.2.2

