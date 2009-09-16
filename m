Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZIPRWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZIPRWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 13:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZIPRWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 13:22:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:57218 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbZIPRWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 13:22:47 -0400
From: Jan Kara <jack@suse.cz>
To: jens.axboe@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] fs: Fix busyloop in wb_writeback()
Date: Wed, 16 Sep 2009 19:22:48 +0200
Message-Id: <1253121768-20673-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all inodes are under writeback (e.g. in case when there's only one inode
with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
write anything.

CC: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8e1e5e1..c59d673 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -706,6 +706,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
+	struct inode *inode;
 
 	if (wbc.for_kupdate) {
 		wbc.older_than_this = &oldest_jif;
@@ -747,8 +748,24 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * If we ran out of stuff to write, bail unless more_io got set
 		 */
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
-			if (wbc.more_io && !wbc.for_kupdate)
+			if (wbc.more_io && !wbc.for_kupdate) {
+				if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+					continue;
+				/*
+				 * Nothing written. Wait for some inode to
+				 * become available for writeback. Otherwise
+				 * we'll just busyloop.
+				 */
+				spin_lock(&inode_lock);
+				if (!list_empty(&wb->b_more_io))  {
+					inode = list_entry(
+							wb->b_more_io.prev,
+							struct inode, i_list);
+					inode_wait_for_writeback(inode);
+				}
+				spin_unlock(&inode_lock);
 				continue;
+			}
 			break;
 		}
 	}
-- 
1.6.0.2

