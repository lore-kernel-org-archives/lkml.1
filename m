Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbYBZUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbYBZUqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYBZUqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:46:17 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35148 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbYBZUqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:46:16 -0500
Date: Tue, 26 Feb 2008 21:45:56 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/9] fs/ocfs2/aops.c: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0802262145321.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c 2008-02-05 20:56:02.000000000 +0100
+++ b/fs/ocfs2/aops.c 2008-02-26 08:16:47.000000000 +0100
@@ -257,7 +257,7 @@ static int ocfs2_readpage_inline(struct 
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	BUG_ON(!PageLocked(page));
-	BUG_ON(!OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
+	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
 	ret = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &di_bh,
 			       OCFS2_BH_CACHED, inode);
