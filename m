Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbXI3St1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbXI3St1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 14:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXI3StU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 14:49:20 -0400
Received: from daimi.au.dk ([130.225.16.1]:59701 "EHLO daimi.au.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbXI3StT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 14:49:19 -0400
X-Greylist: delayed 2724 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 14:49:18 EDT
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add ability to dump mapped pages with /proc/sys/vm/drop_caches
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 30 Sep 2007 20:03:51 +0200
Message-ID: <ye8641s2fp4.fsf@camel11.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to drop mapped pages with
/proc/sys/vm/drop_caches. This is useful to get repeatable
measurements of startup time for applications. 

Without it, pages that are mapped in already-running applications will
not get dropped, so the time measured will not be a true cold-cache
time.

Rik pointed out that "be_atomic" is a bit pointless since there is a
race on SMP anyway where pages can be added. However, it is there in
the existing code, so I added it for the new code as well. Does anyone
know why it's there?


Soren

Signed-off-by: Soren Sandmann <sandmann@redhat.com>

---
 fs/drop_caches.c   |   13 ++++++++-----
 include/linux/fs.h |    3 +++
 include/linux/mm.h |    2 +-
 mm/truncate.c      |   36 ++++++++++++++++++++++--------------
 4 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 59375ef..9f3741d 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -12,7 +12,7 @@
 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
 
-static void drop_pagecache_sb(struct super_block *sb)
+static void drop_pagecache_sb(struct super_block *sb, int unmap)
 {
 	struct inode *inode;
 
@@ -20,12 +20,15 @@ static void drop_pagecache_sb(struct super_block *sb)
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
-		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
+		if (unmap)
+			__invalidate_inode_pages2_range(inode->i_mapping, 0, -1, true);
+		else
+			__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
 	}
 	spin_unlock(&inode_lock);
 }
 
-void drop_pagecache(void)
+void drop_pagecache(int unmap)
 {
 	struct super_block *sb;
 
@@ -36,7 +39,7 @@ restart:
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
 		if (sb->s_root)
-			drop_pagecache_sb(sb);
+			drop_pagecache_sb(sb, unmap);
 		up_read(&sb->s_umount);
 		spin_lock(&sb_lock);
 		if (__put_super_and_need_restart(sb))
@@ -60,7 +63,7 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
 	proc_dointvec_minmax(table, write, file, buffer, length, ppos);
 	if (write) {
 		if (sysctl_drop_caches & 1)
-			drop_pagecache();
+			drop_pagecache(sysctl_drop_caches & 4);
 		if (sysctl_drop_caches & 2)
 			drop_slab();
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 16421f6..c112aa3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1536,6 +1536,9 @@ static inline void invalidate_remote_inode(struct inode *inode)
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 }
 extern int invalidate_inode_pages2(struct address_space *mapping);
+extern int __invalidate_inode_pages2_range(struct address_space *mapping,
+					   pgoff_t start, pgoff_t end,
+					   int be_atomic);
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1692dd6..6719c41 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1207,7 +1207,7 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
-void drop_pagecache(void);
+void drop_pagecache(int unmap);
 void drop_slab(void);
 
 #ifndef CONFIG_MMU
diff --git a/mm/truncate.c b/mm/truncate.c
index 5cdfbc1..568ac77 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -371,19 +371,9 @@ static int do_launder_page(struct address_space *mapping, struct page *page)
 	return mapping->a_ops->launder_page(page);
 }
 
-/**
- * invalidate_inode_pages2_range - remove range of pages from an address_space
- * @mapping: the address_space
- * @start: the page offset 'from' which to invalidate
- * @end: the page offset 'to' which to invalidate (inclusive)
- *
- * Any pages which are found to be mapped into pagetables are unmapped prior to
- * invalidation.
- *
- * Returns -EIO if any pages could not be invalidated.
- */
-int invalidate_inode_pages2_range(struct address_space *mapping,
-				  pgoff_t start, pgoff_t end)
+int __invalidate_inode_pages2_range(struct address_space *mapping,
+				    pgoff_t start, pgoff_t end,
+				    int be_atomic)
 {
 	struct pagevec pvec;
 	pgoff_t next;
@@ -442,10 +432,28 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
-		cond_resched();
+		if (likely(!be_atomic))
+			cond_resched();
 	}
 	return ret;
 }
+
+/**
+ * invalidate_inode_pages2_range - remove range of pages from an address_space
+ * @mapping: the address_space
+ * @start: the page offset 'from' which to invalidate
+ * @end: the page offset 'to' which to invalidate (inclusive)
+ *
+ * Any pages which are found to be mapped into pagetables are unmapped prior to
+ * invalidation.
+ *
+ * Returns -EIO if any pages could not be invalidated.
+ */
+int invalidate_inode_pages2_range(struct address_space *mapping,
+				  pgoff_t start, pgoff_t end)
+{
+	return __invalidate_inode_pages2_range(mapping, start, end, false);
+}
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
 
 /**
-- 
1.5.2.4

