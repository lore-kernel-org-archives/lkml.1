Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbXCEBzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbXCEBzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXCEBza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:30 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38385 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXCEBz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:26 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 13/13] fs/unionfs/: Fix unlocking in error paths
Date: Sun,  4 Mar 2007 20:55:03 -0500
Message-Id: <11730597063852-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index df929e9..967bb5b 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -84,6 +84,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry, struct nameidata *n
 	struct vfsmount *first_hidden_mnt = NULL;
 	int locked_parent = 0;
 	int locked_child = 0;
+	int allocated_new_info = 0;
 
 	int opaque;
 	char *whname = NULL;
@@ -101,9 +102,11 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry, struct nameidata *n
 		BUG_ON(UNIONFS_D(dentry) != NULL);
 		locked_child = 1;
 	}
-	if (lookupmode != INTERPOSE_PARTIAL)
+	if (lookupmode != INTERPOSE_PARTIAL) {
 		if ((err = new_dentry_private_data(dentry)))
 			goto out;
+		allocated_new_info = 1;
+	}
 	/* must initialize dentry operations */
 	dentry->d_op = &unionfs_dops;
 
@@ -380,7 +383,7 @@ out:
 	if (locked_parent)
 		unionfs_unlock_dentry(parent_dentry);
 	dput(parent_dentry);
-	if (locked_child)
+	if (locked_child || (err && allocated_new_info))
 		unionfs_unlock_dentry(dentry);
 	return ERR_PTR(err);
 }
@@ -431,6 +434,7 @@ int new_dentry_private_data(struct dentry *dentry)
 	int newsize;
 	int oldsize = 0;
 	struct unionfs_dentry_info *info = UNIONFS_D(dentry);
+	int unlock_on_err = 0;
 
 	spin_lock(&dentry->d_lock);
 	if (!info) {
@@ -443,6 +447,7 @@ int new_dentry_private_data(struct dentry *dentry)
 
 		mutex_init(&info->lock);
 		mutex_lock(&info->lock);
+		unlock_on_err = 1;
 
 		info->lower_paths = NULL;
 	} else
@@ -482,6 +487,8 @@ int new_dentry_private_data(struct dentry *dentry)
 
 out_free:
 	kfree(info->lower_paths);
+	if (unlock_on_err)
+		mutex_unlock(&info->lock);
 
 out:
 	free_dentry_private_data(info);
-- 
1.5.0.2.260.g2eb065

