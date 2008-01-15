Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYAOMxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYAOMxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYAOMsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:39 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48331 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754282AbYAOMs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:27 -0500
Message-ID: <400401294.29514@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124801.800688912@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:47 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] writeback: introduce queue_dirty()
Content-Disposition: inline; filename=writeback-queue_dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce queue_dirty() to enqueue a newly dirtied inode.
It helps remove duplicate code.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -25,6 +25,15 @@
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
@@ -122,10 +131,8 @@ void __mark_inode_dirty(struct inode *in
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
@@ -445,10 +452,8 @@ int generic_sync_sb_inodes(struct super_
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
