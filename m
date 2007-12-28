Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbXL1UvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbXL1UvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXL1Uno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:44 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37100 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXL1Uni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:38 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 21/30] Unionfs: minor code rearrangement in rename
Date: Fri, 28 Dec 2007 15:42:55 -0500
Message-Id: <11988745951583-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid too much code nesting.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/rename.c |   83 ++++++++++++++++++++++++--------------------------
 1 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 824c285..1019d47 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -479,54 +479,51 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto out;
 		}
 	}
+
 	err = do_unionfs_rename(old_dir, old_dentry, new_dir, new_dentry);
-out:
-	if (err) {
-		/* clear the new_dentry stuff created */
-		d_drop(new_dentry);
-	} else {
-		/*
-		 * force re-lookup since the dir on ro branch is not renamed,
-		 * and lower dentries still indicate the un-renamed ones.
-		 */
-		if (S_ISDIR(old_dentry->d_inode->i_mode))
-			atomic_dec(&UNIONFS_D(old_dentry)->generation);
-		else
-			unionfs_postcopyup_release(old_dentry);
-		if (new_dentry->d_inode &&
-		    !S_ISDIR(new_dentry->d_inode->i_mode)) {
-			unionfs_postcopyup_release(new_dentry);
-			unionfs_postcopyup_setmnt(new_dentry);
-			if (!unionfs_lower_inode(new_dentry->d_inode)) {
-				/*
-				 * If we get here, it means that no copyup
-				 * was needed, and that a file by the old
-				 * name already existing on the destination
-				 * branch; that file got renamed earlier in
-				 * this function, so all we need to do here
-				 * is set the lower inode.
-				 */
-				struct inode *inode;
-				inode = unionfs_lower_inode(
-					old_dentry->d_inode);
-				igrab(inode);
-				unionfs_set_lower_inode_idx(
-					new_dentry->d_inode,
-					dbstart(new_dentry), inode);
-			}
+	if (err)
+		goto out;
 
+	/*
+	 * force re-lookup since the dir on ro branch is not renamed, and
+	 * lower dentries still indicate the un-renamed ones.
+	 */
+	if (S_ISDIR(old_dentry->d_inode->i_mode))
+		atomic_dec(&UNIONFS_D(old_dentry)->generation);
+	else
+		unionfs_postcopyup_release(old_dentry);
+	if (new_dentry->d_inode && !S_ISDIR(new_dentry->d_inode->i_mode)) {
+		unionfs_postcopyup_release(new_dentry);
+		unionfs_postcopyup_setmnt(new_dentry);
+		if (!unionfs_lower_inode(new_dentry->d_inode)) {
+			/*
+			 * If we get here, it means that no copyup was
+			 * needed, and that a file by the old name already
+			 * existing on the destination branch; that file got
+			 * renamed earlier in this function, so all we need
+			 * to do here is set the lower inode.
+			 */
+			struct inode *inode;
+			inode = unionfs_lower_inode(old_dentry->d_inode);
+			igrab(inode);
+			unionfs_set_lower_inode_idx(new_dentry->d_inode,
+						    dbstart(new_dentry),
+						    inode);
 		}
-		/* if all of this renaming succeeded, update our times */
-		unionfs_copy_attr_times(old_dir);
-		unionfs_copy_attr_times(new_dir);
-		unionfs_copy_attr_times(old_dentry->d_inode);
-		unionfs_copy_attr_times(new_dentry->d_inode);
-		unionfs_check_inode(old_dir);
-		unionfs_check_inode(new_dir);
-		unionfs_check_dentry(old_dentry);
-		unionfs_check_dentry(new_dentry);
 	}
+	/* if all of this renaming succeeded, update our times */
+	unionfs_copy_attr_times(old_dir);
+	unionfs_copy_attr_times(new_dir);
+	unionfs_copy_attr_times(old_dentry->d_inode);
+	unionfs_copy_attr_times(new_dentry->d_inode);
+	unionfs_check_inode(old_dir);
+	unionfs_check_inode(new_dir);
+	unionfs_check_dentry(old_dentry);
+	unionfs_check_dentry(new_dentry);
 
+out:
+	if (err)		/* clear the new_dentry stuff created */
+		d_drop(new_dentry);
 	unionfs_unlock_dentry(new_dentry);
 	unionfs_unlock_dentry(old_dentry);
 	unionfs_read_unlock(old_dentry->d_sb);
-- 
1.5.2.2

