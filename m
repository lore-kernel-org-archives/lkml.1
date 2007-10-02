Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbXJBJDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbXJBJDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXJBJDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:03:01 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39059 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751737AbXJBJDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:03:00 -0400
Message-ID: <391315778.14430@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071002090254.489150786@mail.ustc.edu.cn>
References: <20071002084143.110486039@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 02 Oct 2007 16:41:44 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Michael Rubin <mrubin@google.com>
Subject: [PATCH 1/5] revert check_dirty_inode_list.patch
Content-Disposition: inline; filename=revert-check_dirty_inode_list.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the check_dirty_inode_list.patch.
I'm pretty sure the time ordering problem has gone.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   62 --------------------------------------------
 kernel/sysctl.c   |    8 -----
 2 files changed, 1 insertion(+), 69 deletions(-)

--- linux-2.6.23-rc8-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc8-mm2/fs/fs-writeback.c
@@ -25,57 +25,6 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
-int sysctl_inode_debug __read_mostly;
-
-static int __check(struct super_block *sb, int print_stuff)
-{
-	struct list_head *cursor = &sb->s_dirty;
-	unsigned long dirtied_when = 0;
-
-	while ((cursor = cursor->prev) != &sb->s_dirty) {
-		struct inode *inode = list_entry(cursor, struct inode, i_list);
-		if (print_stuff) {
-			printk("%p:%lu\n", inode, inode->dirtied_when);
-		} else {
-			if (dirtied_when &&
-			    time_before(inode->dirtied_when, dirtied_when))
-				return 1;
-			dirtied_when = inode->dirtied_when;
-		}
-	}
-	return 0;
-}
-
-static void __check_dirty_inode_list(struct super_block *sb,
-			struct inode *inode, const char *file, int line)
-{
-	if (!sysctl_inode_debug)
-		return;
-
-	if (__check(sb, 0)) {
-		sysctl_inode_debug = 0;
-		if (inode)
-			printk("%s:%d: s_dirty got screwed up.  inode=%p:%lu\n",
-					file, line, inode, inode->dirtied_when);
-		else
-			printk("%s:%d: s_dirty got screwed up\n", file, line);
-		__check(sb, 1);
-	}
-}
-
-#define check_dirty_inode_list(sb)					\
-	do {								\
-		if (unlikely(sysctl_inode_debug))			\
-		__check_dirty_inode_list(sb, NULL, __FILE__, __LINE__);	\
-	} while (0)
-
-#define check_dirty_inode(inode)					\
-	do {								\
-		if (unlikely(sysctl_inode_debug))			\
-			__check_dirty_inode_list(inode->i_sb, inode,	\
-						__FILE__, __LINE__);	\
-	} while (0)
-
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -174,10 +123,8 @@ void __mark_inode_dirty(struct inode *in
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			check_dirty_inode(inode);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
-			check_dirty_inode(inode);
 		}
 	}
 out:
@@ -206,7 +153,6 @@ static void redirty_tail(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 
-	check_dirty_inode(inode);
 	if (!list_empty(&sb->s_dirty)) {
 		struct inode *tail_inode;
 
@@ -216,7 +162,6 @@ static void redirty_tail(struct inode *i
 			inode->dirtied_when = jiffies;
 	}
 	list_move(&inode->i_list, &sb->s_dirty);
-	check_dirty_inode(inode);
 }
 
 /*
@@ -430,11 +375,8 @@ int generic_sync_sb_inodes(struct super_
 
 	spin_lock(&inode_lock);
 
-	if (!wbc->for_kupdate || list_empty(&sb->s_io)) {
-		check_dirty_inode_list(sb);
+	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		list_splice_init(&sb->s_dirty, &sb->s_io);
-		check_dirty_inode_list(sb);
-	}
 
 	while (!list_empty(&sb->s_io)) {
 		int err;
@@ -499,10 +441,8 @@ int generic_sync_sb_inodes(struct super_
 		if (!ret)
 			ret = err;
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
-			check_dirty_inode(inode);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
-			check_dirty_inode(inode);
 		}
 		if (current_is_pdflush())
 			writeback_release(bdi);
--- linux-2.6.23-rc8-mm2.orig/kernel/sysctl.c
+++ linux-2.6.23-rc8-mm2/kernel/sysctl.c
@@ -1206,14 +1206,6 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "inode_debug",
-		.data		= &sysctl_inode_debug,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
 		.ctl_name	= CTL_UNNUMBERED,

-- 
