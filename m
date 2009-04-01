Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbZDARjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbZDARjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbZDARjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:39:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41455 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbZDARjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:39:04 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       fengguang.wu@intel.com
Subject: [PATCH] writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #3)
Date: Wed,  1 Apr 2009 13:37:55 -0400
Message-Id: <1238607475-8203-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of this patch. The main difference from the
last patch is the addition by Wu of a helper function that encapsulates
the check.

The dirtied_when value on an inode is supposed to represent the first
time that an inode has one of its pages dirtied. This value is in units
of jiffies. It's used in several places in the writeback code to
determine when to write out an inode.

The problem is that these checks assume that dirtied_when is updated
periodically. If an inode is continuously being used for I/O it can be
persistently marked as dirty and will continue to age. Once the time
difference between dirtied_when and the jiffies value it is being
compared to is greater than or equal to half the maximum of the jiffies
type, the logic of the time_*() macros inverts and the opposite of what
is needed is returned. On 32-bit architectures that's just under 25 days
(assuming HZ == 1000).

As the least-recently dirtied inode, it'll end up being the first one
that pdflush will try to write out. sync_sb_inodes does this check:

	/* Was this inode dirtied after sync_sb_inodes was called? */
 	if (time_after(inode->dirtied_when, start))
 		break;

...but now dirtied_when appears to be in the future. sync_sb_inodes
bails out without attempting to write any dirty inodes. When this
occurs, pdflush will stop writing out inodes for this superblock.
Nothing can unwedge it until jiffies moves out of the problematic
window.

This patch fixes this problem by changing the checks against
dirtied_when to also check whether it appears to be in the future. If it
does, then we consider the value to be far in the past.

This should shrink the problematic window of time to such a small period
(30s) as not to matter.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/fs-writeback.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e3fe991..cf9192c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -196,7 +196,7 @@ static void redirty_tail(struct inode *inode)
 		struct inode *tail_inode;
 
 		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
+		if (time_before(inode->dirtied_when,
 				tail_inode->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
@@ -220,6 +220,21 @@ static void inode_sync_complete(struct inode *inode)
 	wake_up_bit(&inode->i_state, __I_SYNC);
 }
 
+static bool inode_dirtied_after(struct inode *inode, unsigned long t)
+{
+	bool ret = time_after(inode->dirtied_when, t);
+#ifndef CONFIG_64BIT
+	/*
+	 * For inodes being constantly redirtied, dirtied_when can get stuck.
+	 * It _appears_ to be in the future, but is actually in distant past.
+	 * This test is necessary to prevent such wrapped-around relative times
+	 * from permanently stopping the whole pdflush writeback.
+	 */
+	ret = ret && time_before_eq(inode->dirtied_when, jiffies);
+#endif
+	return ret;
+}
+
 /*
  * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
  */
@@ -231,7 +246,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 		struct inode *inode = list_entry(delaying_queue->prev,
 						struct inode, i_list);
 		if (older_than_this &&
-			time_after(inode->dirtied_when, *older_than_this))
+		    inode_dirtied_after(inode, *older_than_this))
 			break;
 		list_move(&inode->i_list, dispatch_queue);
 	}
@@ -492,8 +507,11 @@ void generic_sync_sb_inodes(struct super_block *sb,
 			continue;		/* blockdev has wrong queue */
 		}
 
-		/* Was this inode dirtied after sync_sb_inodes was called? */
-		if (time_after(inode->dirtied_when, start))
+		/*
+		 * Was this inode dirtied after sync_sb_inodes was called?
+		 * This keeps sync from extra jobs and livelock.
+		 */
+		if (inode_dirtied_after(inode, start))
 			break;
 
 		/* Is another pdflush already flushing this queue? */
-- 
1.5.5.6

