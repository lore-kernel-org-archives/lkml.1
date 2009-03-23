Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbZCWUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbZCWUcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZCWUcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:32:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44470 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZCWUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:32:05 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH] writeback: reset inode dirty time when adding it back to empty s_dirty list
Date: Mon, 23 Mar 2009 16:30:33 -0400
Message-Id: <1237840233-11045-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may be a problem on other filesystems too, but the reproducer I
have involves NFS.

On NFS, the __mark_inode_dirty() call after writing back the inode is
done in the rpc_release handler for COMMIT calls. This call is done
asynchronously after the call completes.

Because there's no real coordination between __mark_inode_dirty() and
__sync_single_inode(), it's often the case that these two calls will
race and __mark_inode_dirty() will get called while I_SYNC is still set.
When this happens, __sync_single_inode() should detect that the inode
was redirtied while we were flushing it and call redirty_tail() to put
it back on the s_dirty list.

When redirty_tail() puts it back on the list, it only resets the
dirtied_when value if it's necessary to maintain the list order. Given
the right situation (the right I/O patterns and a lot of luck), this
could result in dirtied_when never getting updated on an inode that's
constantly being redirtied while pdflush is writing it back.

Since dirtied_when is based on jiffies, it's possible for it to persist
across 2 sign-bit flips of jiffies. When that happens, the time_after()
check in sync_sb_inodes no longer works correctly and writeouts by
pdflush of this inode and any inodes after it on the list stop.

This patch fixes this by resetting the dirtied_when value on an inode
when we're adding it back onto an empty s_dirty list. Since we generally
write inodes from oldest to newest dirtied_when values, this has the
effect of making it so that these inodes don't end up with dirtied_when
values that are frozen.

I've also taken the liberty of fixing up the comments a bit and changed
the !time_after_eq() check in redirty_tail to be time_before().  That
should be functionally equivalent but I think it's more readable.

I wish this were just a theoretical problem, but we've had a customer
hit a variant of it in an older kernel. Newer upstream kernels have a
number of changes that make this problem less likely. As best I can tell
though, there is nothing that really prevents it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fs-writeback.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e3fe991..bd2a7ff 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -184,19 +184,31 @@ static int write_inode(struct inode *inode, int sync)
  * furthest end of its superblock's dirty-inode list.
  *
  * Before stamping the inode's ->dirtied_when, we check to see whether it is
- * already the most-recently-dirtied inode on the s_dirty list.  If that is
- * the case then the inode must have been redirtied while it was being written
- * out and we don't reset its dirtied_when.
+ * "newer" or equal to that of the most-recently-dirtied inode on the s_dirty
+ * list. If that is the case then we don't need to restamp it to maintain the
+ * order of the list.
+ *
+ * If s_dirty is empty however, then we need to go ahead and update
+ * dirtied_when for the inode. Not doing so will mean that inodes that are
+ * constantly being redirtied can end up with "stuck" dirtied_when values if
+ * they happen to consistently be the first one to go back on the list.
+ *
+ * Since we're using jiffies values in that field, letting dirtied_when grow
+ * too old will be problematic if jiffies wraps. It may also be causing
+ * pdflush to flush the inode too often since it'll always look like it was
+ * dirtied a long time ago.
  */
 static void redirty_tail(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	if (!list_empty(&sb->s_dirty)) {
+	if (list_empty(&sb->s_dirty)) {
+		inode->dirtied_when = jiffies;
+	} else {
 		struct inode *tail_inode;
 
 		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
+		if (time_before(inode->dirtied_when,
 				tail_inode->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-- 
1.6.0.6

