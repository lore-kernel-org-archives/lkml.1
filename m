Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbYBZUqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbYBZUqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765610AbYBZUqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:46:25 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35161 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765119AbYBZUqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:46:22 -0500
Date: Tue, 26 Feb 2008 21:46:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/9] fs/reiserfs/super.c: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0802262145580.18200@ask.diku.dk>
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

diff -u -p a/fs/reiserfs/super.c b/fs/reiserfs/super.c
--- a/fs/reiserfs/super.c 2008-02-16 18:06:38.000000000 +0100
+++ b/fs/reiserfs/super.c 2008-02-26 08:17:07.000000000 +0100
@@ -2031,7 +2031,7 @@ static int reiserfs_quota_on(struct supe
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask) {
+	if (!(REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask)) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
 		path_put(&nd.path);
