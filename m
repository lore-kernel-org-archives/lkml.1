Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbXDIO5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbXDIO5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933843AbXDIO4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:56:39 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44041 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793AbXDIOzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:55:10 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 16/21] Unionfs: unionfs_create needs to revalidate the dentry
Date: Mon,  9 Apr 2007 10:54:07 -0400
Message-Id: <1176130455792-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

We have to read-lock the superblock rwsem, and we have to revalidate the
parent dentry and this one.  A branch-management operation could have taken
place, mid-way through a VFS operation that eventually reaches
unionfs_create().  So we have to ensure consistency, just as we do with the
file operations.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 6dfc16f..edd226f 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -28,9 +28,35 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	struct dentry *hidden_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
-
+	int valid = 0;
+
+	/*
+	 * We have to read-lock the superblock rwsem, and we have to
+	 * revalidate the parent dentry and this one.  A branch-management
+	 * operation could have taken place, mid-way through a VFS operation
+	 * that eventually reaches here.  So we have to ensure consistency,
+	 * just as we do with the file operations.
+	 *
+	 * XXX: we may need to do this for all other inode ops that take a
+	 * dentry.
+	 */
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
+	unionfs_lock_dentry(dentry->d_parent);
+	valid = __unionfs_d_revalidate_chain(dentry->d_parent, nd);
+	unionfs_unlock_dentry(dentry->d_parent);
+	if (!valid) {
+		err = -ENOENT;	/* same as what real_lookup does */
+		goto out;
+	}
+	valid = __unionfs_d_revalidate_chain(dentry, nd);
+	/*
+	 * It's only a bug if this dentry was not negative and couldn't be
+	 * revalidated (shouldn't happen).
+	 */
+	BUG_ON(!valid && dentry->d_inode);
+
 	/* We start out in the leftmost branch. */
 	bstart = dbstart(dentry);
 	hidden_dentry = unionfs_lower_dentry(dentry);
@@ -184,6 +210,7 @@ out:
 	kfree(name);
 
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
-- 
1.5.0.3.268.g3dda

