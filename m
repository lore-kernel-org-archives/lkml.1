Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZIXOkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZIXOkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZIXOkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:40:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44139 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZIXOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:37 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 09/10] writeback: don't resort for a single super_block in move_expired_inodes()
Date: Thu, 24 Sep 2009 16:40:35 +0200
Message-Id: <1253803236-20760-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we only moved inodes from a single super_block to the temporary
list, there's no point in doing a resort for multiple super_blocks.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b27406d..225c731 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -336,17 +336,27 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 {
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
-	struct super_block *sb;
+	struct super_block *sb = NULL;
 	struct inode *inode;
+	int do_sb_sort = 0;
 
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (older_than_this &&
 		    inode_dirtied_after(inode, *older_than_this))
 			break;
+		if (sb && sb != inode->i_sb)
+			do_sb_sort = 1;
+		sb = inode->i_sb;
 		list_move(&inode->i_list, &tmp);
 	}
 
+	/* just one sb in list, splice to dispatch_queue and we're done */
+	if (!do_sb_sort) {
+		list_splice(&tmp, dispatch_queue);
+		return;
+	}
+
 	/* Move inodes from one superblock together */
 	while (!list_empty(&tmp)) {
 		inode = list_entry(tmp.prev, struct inode, i_list);
-- 
1.6.4.1.207.g68ea

