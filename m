Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXKZQuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXKZQuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbXKZQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:49:10 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53119 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743AbXKZQtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:49:08 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 09/16] Unionfs: don't create whiteouts on rightmost branch
Date: Mon, 26 Nov 2007 11:44:06 -0500
Message-Id: <11960954571522-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we are unlinking/rmdir'ing an object on the  rightmost branch, there's no
need to  create a whiteout there: this saves on storage space and inodes.
Also, in the (degenerate) case of having only one branch, this really saves
on whiteouts.

CC: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/unlink.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index f65245d..423ff36 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -53,14 +53,23 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 	if (err && !IS_COPYUP_ERR(err))
 		goto out;
 
+	/*
+	 * We create whiteouts if (1) there was an error unlinking the main
+	 * file; (2) there is a lower priority file with the same name
+	 * (dbopaque); (3) the branch in which the file is not the last
+	 * (rightmost0 branch.  The last rule is an optimization to avoid
+	 * creating all those whiteouts if there's no chance they'd be
+	 * masking any lower-priority branch, as well as unionfs is used
+	 * with only one branch (using only one branch, while odd, is still
+	 * possible).
+	 */
 	if (err) {
 		if (dbstart(dentry) == 0)
 			goto out;
 		err = create_whiteout(dentry, dbstart(dentry) - 1);
 	} else if (dbopaque(dentry) != -1) {
-		/* There is a lower lower-priority file with the same name. */
 		err = create_whiteout(dentry, dbopaque(dentry));
-	} else {
+	} else if (dbstart(dentry) < sbend(dentry->d_sb)) {
 		err = create_whiteout(dentry, dbstart(dentry));
 	}
 
@@ -167,9 +176,17 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 	err = unionfs_rmdir_first(dir, dentry, namelist);
 	dstart = dbstart(dentry);
 	dend = dbend(dentry);
-	/* create whiteout */
+	/*
+	 * We create a whiteout for the directory if there was an error to
+	 * rmdir the first directory entry in the union.  Otherwise, we
+	 * create a whiteout only if there is no chance that a lower
+	 * priority branch might also have the same named directory.  IOW,
+	 * if there is not another same-named directory at a lower priority
+	 * branch, then we don't need to create a whiteout for it.
+	 */
 	if (!err) {
-		err = create_whiteout(dentry, dstart);
+		if (dstart < dend)
+			err = create_whiteout(dentry, dstart);
 	} else {
 		int new_err;
 
-- 
1.5.2.2

