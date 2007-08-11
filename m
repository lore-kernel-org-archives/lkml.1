Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbXHKGGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbXHKGGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 02:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXHKGGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 02:06:43 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37729 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752082AbXHKGGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 02:06:41 -0400
Message-ID: <386812375.01804@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070811060614.981610077@mail.ustc.edu.cn>
References: <20070811060202.690651223@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 14:02:03 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] writeback: fix time ordering of the per superblock inode lists 8
Content-Disposition: inline; filename=inode-dirty-time-ordering-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the time ordering bug re-introduced by
writeback-fix-periodic-superblock-dirty-inode-flushing.patch.

It works by never move not-yet-expired dirty inodes from s_dirty to s_io,
*only to* move them back. The move-inodes-back-and-forth thing is a mess.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -172,6 +172,23 @@ static void requeue_io(struct inode *ino
 }
 
 /*
+ * Queue expired dirty inodes for io.
+ */
+static void queue_io(struct super_block *sb,
+				unsigned long *older_than_this)
+{
+	while (!list_empty(&sb->s_dirty)) {
+		struct inode *inode = list_entry(sb->s_dirty.prev,
+						struct inode, i_list);
+		/* Was this inode dirtied too recently? */
+		if (older_than_this &&
+			time_after(inode->dirtied_when, *older_than_this))
+			break;
+		list_move(&inode->i_list, &sb->s_io);
+	}
+}
+
+/*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
  *
@@ -295,10 +312,10 @@ __writeback_single_inode(struct inode *i
 
 		/*
 		 * We're skipping this inode because it's locked, and we're not
-		 * doing writeback-for-data-integrity.  Move it to the head of
-		 * s_dirty so that writeback can proceed with the other inodes
-		 * on s_io.  We'll have another go at writing back this inode
-		 * when the s_dirty iodes get moved back onto s_io.
+		 * doing writeback-for-data-integrity.  Move it to s_more_io so
+		 * that writeback can proceed with the other inodes on s_io.
+		 * We'll have another go at writing back this inode when we
+		 * completed a full scan of s_io.
 		 */
 		requeue_io(inode);
 
@@ -362,10 +379,8 @@ __writeback_single_inode(struct inode *i
 static void
 sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
-	const unsigned long start = jiffies;	/* livelock avoidance */
-
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
-		list_splice_init(&sb->s_dirty, &sb->s_io);
+		queue_io(sb, wbc->older_than_this);
 
 	while (!list_empty(&sb->s_io)) {
 		struct inode *inode = list_entry(sb->s_io.prev,
@@ -406,17 +421,6 @@ sync_sb_inodes(struct super_block *sb, s
 			continue;		/* blockdev has wrong queue */
 		}
 
-		/* Was this inode dirtied after sync_sb_inodes was called? */
-		if (time_after(inode->dirtied_when, start))
-			break;
-
-		/* Was this inode dirtied too recently? */
-		if (wbc->older_than_this && time_after(inode->dirtied_when,
-						*wbc->older_than_this)) {
-			list_splice_init(&sb->s_io, sb->s_dirty.prev);
-			break;
-		}
-
 		/* Is another pdflush already flushing this queue? */
 		if (current_is_pdflush() && !writeback_acquire(bdi))
 			break;

-- 
