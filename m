Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbXICC1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbXICC1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbXICCZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:14 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57599 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbXICCYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:24 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 11/32] Unionfs: cache-coherency and fixes for unionfs_rename
Date: Sun,  2 Sep 2007 22:20:34 -0400
Message-Id: <11887860563890-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/rename.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 4de984e..f8ea37a 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -457,18 +457,44 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 	err = do_unionfs_rename(old_dir, old_dentry, new_dir, new_dentry);
-
 out:
 	if (err)
 		/* clear the new_dentry stuff created */
 		d_drop(new_dentry);
-	else
+	else {
 		/*
 		 * force re-lookup since the dir on ro branch is not renamed,
 		 * and lower dentries still indicate the un-renamed ones.
 		 */
 		if (S_ISDIR(old_dentry->d_inode->i_mode))
 			atomic_dec(&UNIONFS_D(old_dentry)->generation);
+		if (new_dentry->d_inode &&
+		    !S_ISDIR(new_dentry->d_inode->i_mode)) {
+			if (!unionfs_lower_inode(new_dentry->d_inode)) {
+				/*
+				 * If we get here, it means that no copyup
+				 * was needed, and that a file by the old
+				 * name already existing on the destination
+				 * branch; that file got renamed earlier in
+				 * this function, so all we need to do here
+				 * is set the lower inode.
+				 */
+				struct inode *inode;
+				inode = unionfs_lower_inode(
+					old_dentry->d_inode);
+				igrab(inode);
+				unionfs_set_lower_inode_idx(
+					new_dentry->d_inode,
+					dbstart(new_dentry), inode);
+			}
+
+		}
+		/* if all of this renaming succeeded, update our times */
+		unionfs_copy_attr_times(old_dir);
+		unionfs_copy_attr_times(new_dir);
+		unionfs_copy_attr_times(old_dentry->d_inode);
+		unionfs_copy_attr_times(new_dentry->d_inode);
+	}
 
 	unionfs_unlock_dentry(new_dentry);
 	unionfs_unlock_dentry(old_dentry);
-- 
1.5.2.2.238.g7cbf2f2

