Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbYAOMwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbYAOMwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbYAOMsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:35 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47967 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751446AbYAOMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:08 -0500
Message-ID: <400401292.17900@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124800.190056249@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:43 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] writeback: defer writeback on not-all-pages-written
Content-Disposition: inline; filename=writeback-more_io_wait-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to requeue_io_wait() for case:

	- kupdate cannot write all pages due to some blocking condition;
	- during sync, a file is being written to too fast, starving other
	  files.

In the case of sync, requeue_io_wait() can break the starvation because the
inode requeued into s_more_io_wait will be served _after_ normal inodes, hence
won't stand in the way of other inodes in the next run.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   33 ++++++++-------------------------
 1 files changed, 8 insertions(+), 25 deletions(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -275,37 +275,20 @@ __sync_single_inode(struct inode *inode,
 		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything. Redirty
-			 * the inode; Move it from s_io onto s_more_io/s_dirty.
+			 * sometimes bales out without doing anything.
 			 */
-			/*
-			 * akpm: if the caller was the kupdate function we put
-			 * this inode at the head of s_dirty so it gets first
-			 * consideration.  Otherwise, move it to the tail, for
-			 * the reasons described there.  I'm not really sure
-			 * how much sense this makes.  Presumably I had a good
-			 * reasons for doing it this way, and I'd rather not
-			 * muck with it at present.
-			 */
-			if (wbc->for_kupdate) {
+			inode->i_state |= I_DIRTY_PAGES;
+			if (wbc->for_kupdate && wbc->nr_to_write <= 0)
 				/*
-				 * For the kupdate function we move the inode
-				 * to s_more_io so it will get more writeout as
-				 * soon as the queue becomes uncongested.
+				 * slice used up: queue for next turn
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
 				requeue_io(inode);
-			} else {
+			else
 				/*
-				 * Otherwise fully redirty the inode so that
-				 * other inodes on this superblock will get some
-				 * writeout.  Otherwise heavy writing to one
-				 * file would indefinitely suspend writeout of
-				 * all the other files.
+				 * 1) somehow blocked in kupdate: retry later
+				 * 2) fast writer during sync: give others a try
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				redirty_tail(inode);
-			}
+				requeue_io_wait(inode);
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Someone redirtied the inode while were writing back

-- 
