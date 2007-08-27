Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXH0LdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXH0LdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXH0Lcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:32:53 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49482 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754631AbXH0Lcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:32:52 -0400
Message-ID: <388214369.33461@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070827113249.031094166@mail.ustc.edu.cn>
References: <20070827112152.816663278@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 19:21:53 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] writeback: introduce queue_dirty()
Content-Disposition: inline; filename=writeback-queue_dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce queue_dirty() to enqueue a newly dirtied inode.
It helps remove duplicate code.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc3-mm1/fs/fs-writeback.c
@@ -24,6 +24,15 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+/*
+ * Enqueue a newly dirtied inode.
+ */
+static void queue_dirty(struct inode *inode)
+{
+	inode->dirtied_when = jiffies;
+	list_move(&inode->i_list, &inode->i_sb->s_dirty);
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -121,10 +130,8 @@ void __mark_inode_dirty(struct inode *in
 		 * If the inode was already on s_dirty/s_io/s_more_io, don't
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
-		if (!was_dirty) {
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-		}
+		if (!was_dirty)
+			queue_dirty(inode);
 	}
 out:
 	spin_unlock(&inode_lock);
@@ -466,10 +473,8 @@ int generic_sync_sb_inodes(struct super_
 		err = __writeback_single_inode(inode, wbc);
 		if (!ret)
 			ret = err;
-		if (wbc->sync_mode == WB_SYNC_HOLD) {
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-		}
+		if (wbc->sync_mode == WB_SYNC_HOLD)
+			queue_dirty(inode);
 		if (current_is_pdflush())
 			writeback_release(bdi);
 		if (wbc->pages_skipped != pages_skipped) {

-- 
