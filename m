Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbXCEB6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbXCEB6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXCEB6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:58:21 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38368 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXCEBzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:17 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 12/13] fs/unionfs/: Fix dentry leak in copyup_named_dentry
Date: Sun,  4 Mar 2007 20:55:02 -0500
Message-Id: <11730597051513-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

When we chmod a directory on a readonly branch, and have to copy it up, we
forget to dput(). If this was a file, it gets dput indirectly through other
functions we call, but not if it was a directory.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index e0075ca..e24d940 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -352,20 +352,18 @@ static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
 
 	unionfs_read_lock(sb);
 
-	if ((err = is_robranch_super(sb, new_bindex))) {
-		dput(old_hidden_dentry);
+	if ((err = is_robranch_super(sb, new_bindex)))
 		goto out;
-	}
 
 	/* Create the directory structure above this dentry. */
 	new_hidden_dentry = create_parents_named(dir, dentry, name, new_bindex);
 	if (IS_ERR(new_hidden_dentry)) {
-		dput(old_hidden_dentry);
 		err = PTR_ERR(new_hidden_dentry);
 		goto out;
 	}
 
 	old_hidden_dentry = unionfs_lower_dentry_idx(dentry, old_bindex);
+	/* we conditionally dput this old_hidden_dentry at end of function */
 	dget(old_hidden_dentry);
 
 	/* For symlinks, we must read the link before we lock the directory. */
@@ -460,6 +458,14 @@ out_unlock:
 	unlock_dir(new_hidden_parent_dentry);
 
 out_free:
+	/*
+	 * If old_hidden_dentry was a directory, we need to dput it.  If it
+	 * was a file, then it was already dput indirectly by other
+	 * functions we call ablve which operate on regular files.
+	 */
+	if (old_hidden_dentry && old_hidden_dentry->d_inode &&
+	    S_ISDIR(old_hidden_dentry->d_inode->i_mode))
+		dput(old_hidden_dentry);
 	kfree(symbuf);
 
 out:
-- 
1.5.0.2.260.g2eb065

