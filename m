Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbYEZMdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbYEZMdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbYEZM0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:26:11 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49542 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYEZM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:26:09 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Hans Reiser <reiser@namesys.com>,
       "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 01/29] VFS: move inode_lock into sync_sb_inodes
Date: Mon, 26 May 2008 17:05:15 +0300
Message-Id: <1211810743-18936-2-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 26 May 2008 12:23:29.0307 (UTC) FILETIME=[4DFE4EB0:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Reiser <reiser@namesys.com>

This patch makes 'sync_sb_inodes()' lock 'inode_lock', rather
than expect that the caller will do this.

This change was previously done by Hans Reiser <reiser@namesys.com>
and sat in the -mm tree.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ae45f77..16519fe 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -424,8 +424,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
  * that it can be located for waiting on in __writeback_single_inode().
  *
- * Called under inode_lock.
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -446,6 +444,7 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
+	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		queue_io(sb, wbc->older_than_this);
 
@@ -524,6 +523,7 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 		if (!list_empty(&sb->s_more_io))
 			wbc->more_io = 1;
 	}
+	spin_unlock(&inode_lock);
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
@@ -565,11 +565,8 @@ restart:
 			 * be unmounted by the time it is released.
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
-				if (sb->s_root) {
-					spin_lock(&inode_lock);
+				if (sb->s_root)
 					sync_sb_inodes(sb, wbc);
-					spin_unlock(&inode_lock);
-				}
 				up_read(&sb->s_umount);
 			}
 			spin_lock(&sb_lock);
@@ -607,9 +604,7 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
-	spin_lock(&inode_lock);
 	sync_sb_inodes(sb, &wbc);
-	spin_unlock(&inode_lock);
 }
 
 /*
-- 
1.5.4.1

