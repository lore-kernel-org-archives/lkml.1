Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbXL1NyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbXL1NyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXL1Nvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:45 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44503 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752967AbXL1Nv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:29 -0500
Message-ID: <398849894.92868@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135122.055004293@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:22 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] writeback: replace redirty_tail() on more-pages-to-sync
Content-Disposition: inline; filename=writeback-simplify-more-io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace redirty_tail() with requeue_io()/requeue_io_wait() when
there are more pages to sync. There won't be starvation.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   43 ++++++++-----------------------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -273,46 +273,19 @@ __sync_single_inode(struct inode *inode,
 	if (!(inode->i_state & I_FREEING)) {
 		if (!(inode->i_state & I_DIRTY) &&
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
-				/*
-				 * For the kupdate function we move the inode
-				 * to s_more_io so it will get more writeout as
-				 * soon as the queue becomes uncongested.
-				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write > 0)
-					/* somehow blocked: wait and retry */
-					requeue_io_wait(inode);
-				else
-					/* slice used up: queue for next turn */
-					requeue_io(inode);
-			} else {
-				/*
-				 * Otherwise fully redirty the inode so that
-				 * other inodes on this superblock will get some
-				 * writeout.  Otherwise heavy writing to one
-				 * file would indefinitely suspend writeout of
-				 * all the other files.
-				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				redirty_tail(inode);
-			}
+			inode->i_state |= I_DIRTY_PAGES;
+			if (wbc->nr_to_write > 0)
+				/* somehow blocked: wait and retry */
+				requeue_io_wait(inode);
+			else
+				/* slice used up: queue for next turn */
+				requeue_io(inode);
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Someone redirtied the inode while were writing back
 			 * the pages.
 			 */

-- 
