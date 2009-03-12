Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZCLOek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZCLOek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZCLOdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:33:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40014 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbZCLOdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:33:51 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/7] writeback: get rid of task/current_is_pdflush()
Date: Thu, 12 Mar 2009 15:33:45 +0100
Message-Id: <1236868428-20408-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's just a single user in the kernel and Chris says it's safe to kill.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/btrfs/disk-io.c        |    2 +-
 include/linux/writeback.h |   11 -----------
 2 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e18175..6ec80c0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2385,7 +2385,7 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	unsigned long thresh = 32 * 1024 * 1024;
 	tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 
-	if (current_is_pdflush() || current->flags & PF_MEMALLOC)
+	if (current->flags & PF_MEMALLOC)
 		return;
 
 	num_dirty = count_range_bits(tree, &start, (u64)-1,
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 724327b..f96fea3 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -14,17 +14,6 @@ extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
- * Yes, writeback.h requires sched.h
- * No, sched.h is not included from here.
- */
-static inline int task_is_pdflush(struct task_struct *task)
-{
-	return task->flags & PF_FLUSHER;
-}
-
-#define current_is_pdflush()	task_is_pdflush(current)
-
-/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
-- 
1.6.2

