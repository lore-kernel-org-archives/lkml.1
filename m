Return-Path: <linux-kernel-owner+w=401wt.eu-S1764669AbZDAAFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764669AbZDAAFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764537AbZDAAFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:05:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764390AbZDAAFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:05:12 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #2)
Date: Tue, 31 Mar 2009 20:03:59 -0400
Message-Id: <1238544239-31882-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of this patch. The only difference from the
first version is the addition of some comments.

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
as not to matter.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/fs-writeback.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e3fe991..0c10c61 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -196,8 +196,13 @@ static void redirty_tail(struct inode *inode)
 		struct inode *tail_inode;
 
 		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
-				tail_inode->dirtied_when))
+		/*
+		 * must also check whether dirtied_when appears to be in the
+		 * future, in which case it's actually in the distant past.
+		 */
+		if (time_before(inode->dirtied_when,
+				tail_inode->dirtied_when) ||
+		    time_after(inode->dirtied_when, jiffies))
 			inode->dirtied_when = jiffies;
 	}
 	list_move(&inode->i_list, &sb->s_dirty);
@@ -230,8 +235,13 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 	while (!list_empty(delaying_queue)) {
 		struct inode *inode = list_entry(delaying_queue->prev,
 						struct inode, i_list);
+		/*
+		 * must also check whether dirtied_when appears to be in the
+		 * future, in which case it's actually in the distant past.
+		 */
 		if (older_than_this &&
-			time_after(inode->dirtied_when, *older_than_this))
+			time_after(inode->dirtied_when, *older_than_this) &&
+			time_before_eq(inode->dirtied_when, jiffies))
 			break;
 		list_move(&inode->i_list, dispatch_queue);
 	}
@@ -492,8 +502,20 @@ void generic_sync_sb_inodes(struct super_block *sb,
 			continue;		/* blockdev has wrong queue */
 		}
 
-		/* Was this inode dirtied after sync_sb_inodes was called? */
-		if (time_after(inode->dirtied_when, start))
+		/*
+		 * Was this inode dirtied after sync_sb_inodes was called?
+		 *
+		 * It's not sufficient to just do a time_after() check on
+		 * dirtied_when. That assumes that dirtied_when will always
+		 * change within a period of jiffies that encompasses half the
+		 * machine word size (2^31 jiffies on 32-bit arch). That's not
+		 * necessarily the case if an inode is being constantly
+		 * redirtied. Since dirtied_when can never be in the future,
+		 * we can assume that if it appears to be so then it is
+		 * actually in the distant past.
+		 */
+		if (time_after(inode->dirtied_when, start) &&
+		    time_before_eq(inode->dirtied_when, jiffies))
 			break;
 
 		/* Is another pdflush already flushing this queue? */
-- 
1.5.5.6

