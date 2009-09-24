Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZIXOml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZIXOml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZIXOmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:42:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44134 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZIXOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:37 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 05/10] writeback: cleanup writeback_single_inode()
Date: Thu, 24 Sep 2009 16:40:31 +0200
Message-Id: <1253803236-20760-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

Make the if-else straight in writeback_single_inode().
No behavior change.

Cc: Jan Kara <jack@suse.cz>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 551684d..916e834 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -449,8 +449,13 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
-		if (!(inode->i_state & I_DIRTY) &&
-		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		if (inode->i_state & I_DIRTY) {
+			/*
+			 * Someone redirtied the inode while were writing back
+			 * the pages.
+			 */
+			redirty_tail(inode);
+		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
@@ -494,12 +499,6 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Someone redirtied the inode while were writing back
-			 * the pages.
-			 */
-			redirty_tail(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
-- 
1.6.4.1.207.g68ea

