Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbXH0Ldy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbXH0Ldy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXH0Lcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:32:55 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49506 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754764AbXH0Lcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:32:52 -0400
Message-ID: <388214370.31498@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070827113249.306814072@mail.ustc.edu.cn>
References: <20070827112152.816663278@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 19:21:55 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Ken Chen <kenchen@google.com>,
       Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] writeback: writeback clustering by inode number
Content-Disposition: inline; filename=writeback-ino-clustering.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Organize dirty inodes in the order of location instead of dirty time.
It helps write extensive workloads to be more seek-friendly.

There are 2 candidates for this feature:
	1) XFS style piggybacking
	   write all expired(age>30s) inodes, plus the ones near them(any ages)
	2) elevator style sweep scanning
	   in each kupdate wake ups, walk 1/5 the partition and write all
	   non-volatile(age>5s) inodes in that range

This patch implements the second scheme. The merits of it are:
	- more predictable behavior
	- can smooth out time-bursty writes
However, it does not help space-bursty caused by hot write areas.

For many filesystems(ext3/XFS/...), inode number is a good location hint
for the inode. However inode data blocks may not necessarily lie close to the
inode itself(i.e. XFS), hence we should somehow extend the location hint in
future.

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c  |  129 +++++++++++++++++++++++++++++++++++++++++++
 fs/super.c         |    2 
 include/linux/fs.h |   10 +++
 3 files changed, 141 insertions(+)

--- linux-2.6.23-rc3-mm1.orig/fs/super.c
+++ linux-2.6.23-rc3-mm1/fs/super.c
@@ -61,6 +61,8 @@ static struct super_block *alloc_super(s
 			s = NULL;
 			goto out;
 		}
+		INIT_RADIX_TREE(&s->s_dirty_tree.inode_tree, GFP_ATOMIC);
+		INIT_LIST_HEAD(&s->s_dirty_tree.inode_list);
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LIST_HEAD(&s->s_more_io);
--- linux-2.6.23-rc3-mm1.orig/include/linux/fs.h
+++ linux-2.6.23-rc3-mm1/include/linux/fs.h
@@ -978,6 +978,15 @@ extern int send_sigurg(struct fown_struc
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
+struct dirty_inode_tree {
+	struct list_head	inode_list;
+	struct radix_tree_root	inode_tree;
+	unsigned long		nr_inodes;
+	unsigned long		max_index;
+	unsigned long		start_jiffies; /* when the scan started? */
+	unsigned long		next_index;    /* where it is in the scan? */
+};
+
 #define sb_entry(list)	list_entry((list), struct super_block, s_list)
 #define S_BIAS (1<<30)
 struct super_block {
@@ -1007,6 +1016,7 @@ struct super_block {
 	struct xattr_handler	**s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
+	struct dirty_inode_tree	s_dirty_tree;
 	struct list_head	s_dirty;	/* dirty inodes */
 	struct list_head	s_io;		/* parked for writeback */
 	struct list_head	s_more_io;	/* parked for more writeback */
--- linux-2.6.23-rc3-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc3-mm1/fs/fs-writeback.c
@@ -25,12 +25,139 @@
 #include "internal.h"
 
 /*
+ * Add @inode to its superblock's radix tree of dirty inodes.
+ * The radix tree is indexed by inode number.
+ */
+static void add_to_dirty_tree(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct dirty_inode_tree *dt = &sb->s_dirty_tree;
+	int e;
+
+	e = radix_tree_preload(GFP_ATOMIC);
+	if (!e) {
+		e = radix_tree_insert(&dt->inode_tree, inode->i_ino, inode);
+		/*
+		 * Inode numbers are unique, but the inode itself might be
+		 * somehow redirtied and resent to us. So it's safe to ignore
+		 * the conflict.
+		 */
+		if (!e) {
+			__iget(inode);
+			dt->nr_inodes++;
+			if (dt->max_index < inode->i_ino)
+			    dt->max_index = inode->i_ino;
+		}
+		list_move(&inode->i_list, &sb->s_dirty_tree.inode_list);
+		radix_tree_preload_end();
+	}
+}
+
+#define DIRTY_SCAN_BATCH	10
+#define DIRTY_SCAN_ALL		LONG_MAX
+#define DIRTY_SCAN_REMAINING	(LONG_MAX-1)
+
+/*
+ * Scan the dirty inode tree and pull some inodes onto s_io.
+ * It could go beyond @end - it is a soft/approx limit.
+ */
+static unsigned long scan_dirty_tree(struct super_block *sb,
+					unsigned long begin, unsigned long end)
+{
+	struct dirty_inode_tree *dt = &sb->s_dirty_tree;
+	struct inode *inodes[DIRTY_SCAN_BATCH];
+	struct inode *inode = NULL;
+	int i, j;
+	void *p;
+
+	while (begin < end) {
+		j = radix_tree_gang_lookup(&dt->inode_tree, (void **)inodes,
+						begin, DIRTY_SCAN_BATCH);
+		if (!j)
+			break;
+		for (i = 0; i < j; i++) {
+			inode = inodes[i];
+			if (end != DIRTY_SCAN_ALL) {
+				/* skip young volatile ones */
+				if (time_after(inode->dirtied_when,
+					jiffies - dirty_volatile_interval)) {
+					inodes[i] = 0;
+					continue;
+				}
+			}
+
+			dt->nr_inodes--;
+			p = radix_tree_delete(&dt->inode_tree, inode->i_ino);
+			BUG_ON(!p);
+
+			if (!(inode->i_state & I_SYNC))
+				list_move(&inode->i_list, &sb->s_io);
+		}
+		begin = inode->i_ino + 1;
+
+		spin_unlock(&inode_lock);
+		for (i = 0; i < j; i++)
+			if (inodes[i])
+				iput(inodes[i]);
+		cond_resched();
+		spin_lock(&inode_lock);
+	}
+
+	return begin;
+}
+
+/*
+ * Move a cluster of dirty inodes to the io dispatch queue.
+ */
+static void move_cluster_inodes(struct super_block *sb,
+				unsigned long *older_than_this)
+{
+	struct dirty_inode_tree *dt = &sb->s_dirty_tree;
+	int scan_interval = dirty_expire_interval - dirty_volatile_interval;
+	unsigned long begin;
+	unsigned long end;
+
+	if (!older_than_this) {
+		/*
+		 * Be aggressive: either it is a sync(), or we fall into
+		 * background writeback because kupdate-style writebacks
+		 * could not catch up with fast writers.
+		 */
+		begin = 0;
+		end = DIRTY_SCAN_ALL;
+	} else if (time_after_eq(jiffies,
+				dt->start_jiffies + scan_interval)) {
+		begin = dt->next_index;
+		end = DIRTY_SCAN_REMAINING; /* complete this scan */
+	} else {
+		unsigned long time_total = max(scan_interval, 1);
+		unsigned long time_delta = jiffies - dt->start_jiffies;
+		unsigned long scan_total = dt->max_index;
+		unsigned long scan_delta = scan_total * time_delta / time_total;
+
+		begin = dt->next_index;
+		end = scan_delta;
+	}
+
+	scan_dirty_tree(sb, begin, end);
+
+	if (end >= DIRTY_SCAN_REMAINING) { /* wrap around and setup next scan */
+		dt->next_index = 0;
+		dt->start_jiffies = jiffies;
+	} else
+		dt->next_index = begin;
+}
+
+
+/*
  * Enqueue a newly dirtied inode.
  */
 static void queue_dirty(struct inode *inode)
 {
 	inode->dirtied_when = jiffies;
 	list_move(&inode->i_list, &inode->i_sb->s_dirty);
+	if (dirty_volatile_interval <= dirty_expire_interval/2)
+		add_to_dirty_tree(inode);
 }
 
 /**
@@ -212,11 +339,13 @@ static void queue_io(struct super_block 
 {
 	list_splice_init(&sb->s_more_io, sb->s_io.prev);
 	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
+	move_cluster_inodes(sb, older_than_this);
 }
 
 int sb_has_dirty_inodes(struct super_block *sb)
 {
 	return !list_empty(&sb->s_dirty) ||
+	       !list_empty(&sb->s_dirty_tree.inode_list) ||
 	       !list_empty(&sb->s_io) ||
 	       !list_empty(&sb->s_more_io);
 }

-- 
