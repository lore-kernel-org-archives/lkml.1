Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbXL1NzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbXL1NzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbXL1Nvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:48 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44615 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752964AbXL1Nv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:29 -0500
Message-ID: <398849895.60612@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135123.237186756@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:30 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] writeback: __sync_single_inode() code cleanup
Content-Disposition: inline; filename=writeback-simplify-x.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the if-else straight in __sync_single_inode().
No behavior change.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -248,37 +248,36 @@ __sync_single_inode(struct inode *inode,
 	if (wait) {
 		int err = filemap_fdatawait(mapping);
 		if (ret == 0)
 			ret = err;
 	}
 
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
-		if (!(inode->i_state & I_DIRTY) &&
-		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		if (inode->i_state & I_DIRTY) {
+			/*
+			 * Someone redirtied the inode while were writing back
+			 * the pages.
+			 */
+			requeue_io(inode);
+		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
 			if (wbc->nr_to_write > 0)
 				/* somehow blocked: wait and retry */
 				requeue_io_wait(inode);
 			else
 				/* slice used up: queue for next turn */
 				requeue_io(inode);
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
-			 */
-			requeue_io(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
 			 */
 			list_move(&inode->i_list, &inode_in_use);
 		} else {
 			/*
 			 * The inode is clean, unused
 			 */

-- 
