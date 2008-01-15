Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbYAOMvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbYAOMvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYAOMsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:30 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48041 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751353AbYAOMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:08 -0500
Message-ID: <400401294.20012@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124803.025520828@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:50 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] writeback: cleanup __sync_single_inode()
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
 1 files changed, 7 insertions(+), 8 deletions(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -254,8 +254,13 @@ __sync_single_inode(struct inode *inode,
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
@@ -272,12 +277,6 @@ __sync_single_inode(struct inode *inode,
 				 * 2) fast writer during sync: give others a try
 				 */
 				requeue_io_wait(inode);
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
-			 */
-			requeue_io(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse

-- 
