Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYAOMtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYAOMtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYAOMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:15 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47925 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751326AbYAOMsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:07 -0500
Message-ID: <400401291.24198@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124759.398587485@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] writeback: introduce super_block.s_more_io_wait
Content-Disposition: inline; filename=writeback-more_io_wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce super_block.s_more_io_wait to park inodes that for some reason cannot
be synced immediately. They will be revisited in the next s_io enqueue time(<=5s).

The new data flow after this patchset:

s_dirty --> s_io --> s_more_io/s_more_io_wait --+
             ^                                  |
	     |                                  |
	     +----------------------------------+

- to fill s_io:
		s_more_io +
		s_dirty(expired) +
		s_more_io_wait
				---> s_io
- to drain s_io:
		s_io -+--> clean inodes goto inode_in_use/inode_unused
		      |
		      +--> s_more_io
		      |
		      +--> s_more_io_wait

Obviously there're no ordering or starvation problems in the queues:
- s_dirty is now a strict FIFO queue
- inode.dirtied_when is only set when made dirty
- once exipired, the dirty inode will stay in s_*io* queues until made clean
- the dirty inodes in s_*io* will be revisted in order, hence small files won't
  be starved by big dirty files.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c  |   16 +++++++++++++---
 fs/super.c         |    1 +
 include/linux/fs.h |    1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -172,6 +172,14 @@ static void requeue_io(struct inode *ino
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
 }
 
+/*
+ * The inode should be retried after _sleeping_ for a while.
+ */
+static void requeue_io_wait(struct inode *inode)
+{
+	list_move(&inode->i_list, &inode->i_sb->s_more_io_wait);
+}
+
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
@@ -206,13 +214,15 @@ static void queue_io(struct super_block 
 {
 	list_splice_init(&sb->s_more_io, sb->s_io.prev);
 	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
+	list_splice_init(&sb->s_more_io_wait, sb->s_io.prev);
 }
 
 int sb_has_dirty_inodes(struct super_block *sb)
 {
-	return !list_empty(&sb->s_dirty) ||
-	       !list_empty(&sb->s_io) ||
-	       !list_empty(&sb->s_more_io);
+	return !list_empty(&sb->s_dirty)   ||
+	       !list_empty(&sb->s_io)      ||
+	       !list_empty(&sb->s_more_io) ||
+	       !list_empty(&sb->s_more_io_wait);
 }
 EXPORT_SYMBOL(sb_has_dirty_inodes);
 
--- linux-mm.orig/fs/super.c
+++ linux-mm/fs/super.c
@@ -64,6 +64,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LIST_HEAD(&s->s_more_io);
+		INIT_LIST_HEAD(&s->s_more_io_wait);
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
--- linux-mm.orig/include/linux/fs.h
+++ linux-mm/include/linux/fs.h
@@ -1011,6 +1011,7 @@ struct super_block {
 	struct list_head	s_dirty;	/* dirty inodes */
 	struct list_head	s_io;		/* parked for writeback */
 	struct list_head	s_more_io;	/* parked for more writeback */
+	struct list_head	s_more_io_wait;	/* parked for sleep-then-retry */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
 

-- 
