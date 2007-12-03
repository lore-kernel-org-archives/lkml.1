Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbXLCGgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbXLCGgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 01:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXLCGf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 01:35:58 -0500
Received: from [60.23.248.87] ([60.23.248.87]:51759 "EHLO virgo.fc-cn.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXLCGf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 01:35:57 -0500
From: Qi Yong <qiyong@fc-cn.com>
Organization: FCD
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] skip writing data pages when inode is under I_SYNC
Date: Mon, 3 Dec 2007 14:35:56 +0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: nickpiggin@yahoo.com.au, akpm@osdl.org, a.p.zijlstra@chello.nl,
       hugh@veritas.com, dhowells@redhat.com, joern@wohnheim.fh-wedel.de,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712031435.59893.qiyong@fc-cn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since I_SYNC was split out from I_LOCK, the concern in commit 
4b89eed93e0fa40a63e3d7b1796ec1337ea7a3aa is not longer valid.

We should revert to the original behavior: in __writeback_single_inode(),
when we find an I_SYNC-ed inode and we're not doing a data-integrity sync, 
skip writing entirely. Otherwise, we are double calling do_writepages()

Signed-off-by: Qi Yong <qiyong@fc-cn.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0fca820..4f8ec63 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -334,9 +334,6 @@ __writeback_single_inode(struct inode *inode, struct 
writeback_control *wbc)
 		WARN_ON(inode->i_state & I_WILL_FREE);
 
 	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
-		struct address_space *mapping = inode->i_mapping;
-		int ret;
-
 		/*
 		 * We're skipping this inode because it's locked, and we're not
 		 * doing writeback-for-data-integrity.  Move it to s_more_io so
@@ -345,15 +342,7 @@ __writeback_single_inode(struct inode *inode, struct 
writeback_control *wbc)
 		 * completed a full scan of s_io.
 		 */
 		requeue_io(inode);
-
-		/*
-		 * Even if we don't actually write the inode itself here,
-		 * we can at least start some of the data writeout..
-		 */
-		spin_unlock(&inode_lock);
-		ret = do_writepages(mapping, wbc);
-		spin_lock(&inode_lock);
-		return ret;
+		return 0;
 	}
 
 	/*
-- 
Qi Yong
