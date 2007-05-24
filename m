Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbXEXAqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbXEXAqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762260AbXEXAhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:37:51 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40252 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbXEXAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:59 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 13/21] Unionfs: Don't leak resources when copyup fails partially
Date: Wed, 23 May 2007 20:36:03 -0400
Message-Id: <11799669731382-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Original-patch-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 0975b6e..a80ece6 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -632,7 +632,7 @@ static struct dentry *create_parents_named(struct inode *dir,
 	unsigned int childnamelen;
 
 	int nr_dentry;
-	int count;
+	int count = 0;
 
 	int old_bstart;
 	int old_bend;
@@ -660,7 +660,6 @@ static struct dentry *create_parents_named(struct inode *dir,
 	/* assume the negative dentry of unionfs as the parent dentry */
 	parent_dentry = dentry;
 
-	count = 0;
 	/*
 	 * This loop finds the first parent that exists in the given branch.
 	 * We start building the directory structure from there.  At the end
@@ -772,6 +771,23 @@ static struct dentry *create_parents_named(struct inode *dir,
 							 hidden_dentry);
 			unlock_dir(hidden_parent_dentry);
 			if (err) {
+				struct inode *inode = hidden_dentry->d_inode;
+				/*
+				 * If we get here, it means that we created a new
+				 * dentry+inode, but copying permissions failed.
+				 * Therefore, we should delete this inode and dput
+				 * the dentry so as not to leave cruft behind.
+				 *
+				 * XXX: call dentry_iput() instead, but then we have
+				 * to export that symbol.
+				 */
+				if (hidden_dentry->d_op && hidden_dentry->d_op->d_iput)
+					hidden_dentry->d_op->d_iput(hidden_dentry,
+								    inode);
+				else
+					iput(inode);
+				hidden_dentry->d_inode = NULL;
+
 				dput(hidden_dentry);
 				hidden_dentry = ERR_PTR(err);
 				goto out;
@@ -786,6 +802,10 @@ static struct dentry *create_parents_named(struct inode *dir,
 		child_dentry = path[--count];
 	}
 out:
+	/* cleanup any leftover locks from the do/while loop above */
+	if (IS_ERR(hidden_dentry))
+		while (count)
+			unionfs_unlock_dentry(path[count--]);
 	kfree(path);
 	return hidden_dentry;
 }
-- 
1.5.2.rc1.165.gaf9b

