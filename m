Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbXL1Nyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbXL1Nyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbXL1Nvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:47 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44565 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752975AbXL1Nv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:29 -0500
Message-ID: <398849894.27936@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135122.779152029@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:27 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] writeback: introduce queue_dirty()
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
 1 file changed, 13 insertions(+), 8 deletions(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -23,10 +23,19 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
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
  *	@flags: what kind of dirty (i.e. I_DIRTY_SYNC)
  *	Mark an inode as dirty. Callers should use mark_inode_dirty or
@@ -120,14 +129,12 @@ void __mark_inode_dirty(struct inode *in
 
 		/*
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
 }
 
@@ -438,14 +445,12 @@ int generic_sync_sb_inodes(struct super_
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
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
 			/*
 			 * writeback is not making progress due to locked

-- 
