Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZIXOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZIXOmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZIXOmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:42:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44133 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZIXOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:37 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/10] writeback: improve readability of the wb_writeback() continue/break logic
Date: Thu, 24 Sep 2009 16:40:32 +0200
Message-Id: <1253803236-20760-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And throw some comments in there, too.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   43 +++++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 916e834..15e375b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -750,29 +750,32 @@ static long wb_writeback(struct bdi_writeback *wb,
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
 		/*
-		 * If we ran out of stuff to write, bail unless more_io got set
+		 * If we consumed everything, see if we have more
 		 */
-		if (wbc.nr_to_write > 0) {
-			if (wbc.more_io) {
-				if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
-					continue;
-				/*
-				 * Nothing written. Wait for some inode to
-				 * become available for writeback. Otherwise
-				 * we'll just busyloop.
-				 */
-				spin_lock(&inode_lock);
-				if (!list_empty(&wb->b_more_io))  {
-					inode = list_entry(
-							wb->b_more_io.prev,
-							struct inode, i_list);
-					inode_wait_for_writeback(inode);
-				}
-				spin_unlock(&inode_lock);
-				continue;
-			}
+		if (wbc.nr_to_write <= 0)
+			continue;
+		/*
+		 * Didn't write everything and we don't have more IO, bail
+		 */
+		if (!wbc.more_io)
 			break;
+		/*
+		 * Did we write something? Try for more
+		 */
+		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+			continue;
+		/*
+		 * Nothing written. Wait for some inode to
+		 * become available for writeback. Otherwise
+		 * we'll just busyloop.
+		 */
+		spin_lock(&inode_lock);
+		if (!list_empty(&wb->b_more_io))  {
+			inode = list_entry(wb->b_more_io.prev,
+						struct inode, i_list);
+			inode_wait_for_writeback(inode);
 		}
+		spin_unlock(&inode_lock);
 	}
 
 	return wrote;
-- 
1.6.4.1.207.g68ea

