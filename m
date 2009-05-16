Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZEPSCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZEPSCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 14:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZEPSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 14:02:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62708 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZEPSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 14:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wM4D+gpzbGXCKjbaWa5n3Buujlikmzvp8Sa3KUg+zIAqLk9GH1+2arr+sImMRCrc6T
         LEbPbhAvy0ZG/z1raVIYaMkplxkeFWhOe8G07CuXx+GoFFRQaioc3HL80P6Cjh2+Bnw8
         PSZ/jU4dolNyQs7utKVEUwVZR3plPRDHLv60Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/2] kill-the-bkl/reiserfs: move the concurrent tree accesses checks per superblock
Date: Sat, 16 May 2009 20:02:02 +0200
Message-Id: <1242496922-6330-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do_balance() balances the tree, a trick is performed to
provide the ability for other tree writers/readers to check whether
do_balance() is executing concurrently (requires CONFIG_REISERFS_CHECK).

This is done to protect concurrent accesses to the tree. The trick
is the following:

When do_balance is called, a unique global variable called cur_tb
takes a pointer to the current tree to be rebalanced.
Once do_balance finishes its work, cur_tb takes the NULL value.

Then, concurrent tree readers/writers just have to check the value
of cur_tb to ensure do_balance isn't executing concurrently.
If it is, then it proves that schedule() occured on do_balance(),
which then relaxed the bkl that protected the tree.

Now that the bkl has be turned into a mutex, this check is still
fine even though do_balance() becomes preemptible: the write lock
will not be automatically released on schedule(), so the tree is
still protected.

But this is only fine if we have a single reiserfs mountpoint.
Indeed, because the bkl is a global lock, it didn't allowed
concurrent executions between a tree reader/writer in a mount point
and a do_balance() on another tree from another mountpoint.

So assuming all these readers/writers weren't supposed to be
reentrant, the current check now sometimes detect false positives with
the current per-superblock mutex which allows this reentrancy.

This patch keeps the concurrent tree accesses check but moves it
per superblock, so that only trees from a same mount point are
checked to be not accessed concurrently.

[ Impact: fix spurious panic while running several reiserfs mount-points ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/do_balan.c         |   17 +++++------------
 fs/reiserfs/fix_node.c         |    5 +----
 fs/reiserfs/prints.c           |    4 ----
 fs/reiserfs/stree.c            |    5 +----
 include/linux/reiserfs_fs_sb.h |   11 +++++++++++
 5 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 4beb964..2787349 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -21,14 +21,6 @@
 #include <linux/buffer_head.h>
 #include <linux/kernel.h>
 
-#ifdef CONFIG_REISERFS_CHECK
-
-struct tree_balance *cur_tb = NULL;	/* detects whether more than one
-					   copy of tb exists as a means
-					   of checking whether schedule
-					   is interrupting do_balance */
-#endif
-
 static inline void buffer_info_init_left(struct tree_balance *tb,
                                          struct buffer_info *bi)
 {
@@ -1841,11 +1833,12 @@ static int check_before_balancing(struct tree_balance *tb)
 {
 	int retval = 0;
 
-	if (cur_tb) {
+	if (REISERFS_SB(tb->tb_sb)->cur_tb) {
 		reiserfs_panic(tb->tb_sb, "vs-12335", "suspect that schedule "
 			       "occurred based on cur_tb not being null at "
 			       "this point in code. do_balance cannot properly "
-			       "handle schedule occurring while it runs.");
+			       "handle concurrent tree accesses on a same "
+			       "mount point.");
 	}
 
 	/* double check that buffers that we will modify are unlocked. (fix_nodes should already have
@@ -1987,7 +1980,7 @@ static inline void do_balance_starts(struct tree_balance *tb)
 	     "check");*/
 	RFALSE(check_before_balancing(tb), "PAP-12340: locked buffers in TB");
 #ifdef CONFIG_REISERFS_CHECK
-	cur_tb = tb;
+	REISERFS_SB(tb->tb_sb)->cur_tb = tb;
 #endif
 }
 
@@ -1997,7 +1990,7 @@ static inline void do_balance_completed(struct tree_balance *tb)
 #ifdef CONFIG_REISERFS_CHECK
 	check_leaf_level(tb);
 	check_internal_levels(tb);
-	cur_tb = NULL;
+	REISERFS_SB(tb->tb_sb)->cur_tb = NULL;
 #endif
 
 	/* reiserfs_free_block is no longer schedule safe.  So, we need to
diff --git a/fs/reiserfs/fix_node.c b/fs/reiserfs/fix_node.c
index 3a685e3..d2f3133 100644
--- a/fs/reiserfs/fix_node.c
+++ b/fs/reiserfs/fix_node.c
@@ -563,9 +563,6 @@ static int get_num_ver(int mode, struct tree_balance *tb, int h,
 	return needed_nodes;
 }
 
-#ifdef CONFIG_REISERFS_CHECK
-extern struct tree_balance *cur_tb;
-#endif
 
 /* Set parameters for balancing.
  * Performs write of results of analysis of balancing into structure tb,
@@ -2368,7 +2365,7 @@ int fix_nodes(int op_mode, struct tree_balance *tb,
 			return REPEAT_SEARCH;
 	}
 #ifdef CONFIG_REISERFS_CHECK
-	if (cur_tb) {
+	if (REISERFS_SB(tb->tb_sb)->cur_tb) {
 		print_cur_tb("fix_nodes");
 		reiserfs_panic(tb->tb_sb, "PAP-8305",
 			       "there is pending do_balance");
diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
index 536eaca..adbc6f5 100644
--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -349,10 +349,6 @@ void reiserfs_debug(struct super_block *s, int level, const char *fmt, ...)
 
    .  */
 
-#ifdef CONFIG_REISERFS_CHECK
-extern struct tree_balance *cur_tb;
-#endif
-
 void __reiserfs_panic(struct super_block *sb, const char *id,
 		      const char *function, const char *fmt, ...)
 {
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 6b025a4..5fa7118 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -222,9 +222,6 @@ static inline int bin_search(const void *key,	/* Key to search for. */
 	return ITEM_NOT_FOUND;
 }
 
-#ifdef CONFIG_REISERFS_CHECK
-extern struct tree_balance *cur_tb;
-#endif
 
 /* Minimal possible key. It is never in the tree. */
 const struct reiserfs_key MIN_KEY = { 0, 0, {{0, 0},} };
@@ -711,7 +708,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
 		       !key_in_buffer(search_path, key, sb),
 		       "PAP-5130: key is not in the buffer");
 #ifdef CONFIG_REISERFS_CHECK
-		if (cur_tb) {
+		if (REISERFS_SB(sb)->cur_tb) {
 			print_cur_tb("5140");
 			reiserfs_panic(sb, "PAP-5140",
 				       "schedule occurred in do_balance!");
diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 8a1d409..2f8bb04 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -417,6 +417,17 @@ struct reiserfs_sb_info {
 	char *s_qf_names[MAXQUOTAS];
 	int s_jquota_fmt;
 #endif
+#ifdef CONFIG_REISERFS_CHECK
+
+	struct tree_balance *cur_tb;	/*
+					 * Detects whether more than one
+					 * copy of tb exists per superblock
+					 * as a means of checking whether
+					 * do_balance is executing concurrently
+					 * against another tree reader/writer
+					 * on a same mount point.
+					 */
+#endif
 };
 
 /* Definitions of reiserfs on-disk properties: */
-- 
1.6.2.3

