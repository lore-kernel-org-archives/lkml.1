Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZIXOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZIXOmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZIXOmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:42:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44138 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZIXOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:37 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/10] writeback: move inodes from one super_block together
Date: Thu, 24 Sep 2009 16:40:34 +0200
Message-Id: <1253803236-20760-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

__mark_inode_dirty adds inode to wb dirty list in random order. If a disk has
several partitions, writeback might keep spindle moving between partitions.
To reduce the move, better write big chunk of one partition and then move to
another. Inodes from one fs usually are in one partion, so idealy move indoes
from one fs together should reduce spindle move. This patch tries to address
this. Before per-bdi writeback is added, the behavior is write indoes
from one fs first and then another, so the patch restores previous behavior.
The loop in the patch is a bit ugly, should we add a dirty list for each
superblock in bdi_writeback?

Test in a two partition disk with attached fio script shows about 3% ~ 6%
improvement.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15944f7..b27406d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -334,13 +334,28 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 			       struct list_head *dispatch_queue,
 				unsigned long *older_than_this)
 {
+	LIST_HEAD(tmp);
+	struct list_head *pos, *node;
+	struct super_block *sb;
+	struct inode *inode;
+
 	while (!list_empty(delaying_queue)) {
-		struct inode *inode = list_entry(delaying_queue->prev,
-						struct inode, i_list);
+		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (older_than_this &&
 		    inode_dirtied_after(inode, *older_than_this))
 			break;
-		list_move(&inode->i_list, dispatch_queue);
+		list_move(&inode->i_list, &tmp);
+	}
+
+	/* Move inodes from one superblock together */
+	while (!list_empty(&tmp)) {
+		inode = list_entry(tmp.prev, struct inode, i_list);
+		sb = inode->i_sb;
+		list_for_each_prev_safe(pos, node, &tmp) {
+			inode = list_entry(pos, struct inode, i_list);
+			if (inode->i_sb == sb)
+				list_move(&inode->i_list, dispatch_queue);
+		}
 	}
 }
 
-- 
1.6.4.1.207.g68ea

