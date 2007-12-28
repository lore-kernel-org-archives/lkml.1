Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXL1Utk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXL1Utk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXL1UoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:00 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37130 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXL1Unq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:46 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 30/30] Unionfs: don't check parent dentries
Date: Fri, 28 Dec 2007 15:43:04 -0500
Message-Id: <11988745992884-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parent dentries may not be locked and may change, so don't check them.  But
do check parent inodes if they are passed to the method.  Also, ensure the
checks are done only if no error occurred.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    1 -
 fs/unionfs/file.c       |    1 -
 fs/unionfs/inode.c      |   23 +++++++++++------------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index b8357a7..2c32ada 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -588,7 +588,6 @@ out_nofree:
 		unionfs_copy_attr_times(dentry->d_parent->d_inode);
 		unionfs_copy_attr_times(inode);
 		unionfs_check_file(file);
-		unionfs_check_dentry(dentry->d_parent);
 		unionfs_check_inode(inode);
 	}
 	unionfs_read_unlock(inode->i_sb);
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index b632042..0c424f6 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -66,7 +66,6 @@ out:
 		/* copyup could cause parent dir times to change */
 		unionfs_copy_attr_times(file->f_path.dentry->d_parent->d_inode);
 		unionfs_check_file(file);
-		unionfs_check_dentry(file->f_path.dentry->d_parent);
 	}
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 740d364..6095c4f 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -157,7 +157,6 @@ out:
 
 	unionfs_check_inode(parent);
 	if (!err) {
-		unionfs_check_dentry(dentry->d_parent);
 		unionfs_check_dentry(dentry);
 		unionfs_check_nd(nd);
 	}
@@ -207,14 +206,16 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 	}
 
 	unionfs_check_inode(parent);
-	unionfs_check_dentry(dentry);
-	unionfs_check_dentry(dentry->d_parent);
-	unionfs_check_nd(nd);
-	if (!IS_ERR(ret))
+	if (!IS_ERR(ret)) {
+		unionfs_check_dentry(dentry);
+		unionfs_check_nd(nd);
 		unionfs_unlock_dentry(dentry);
+	}
 
-	if (dentry != dentry->d_parent)
+	if (dentry != dentry->d_parent) {
+		unionfs_check_dentry(dentry->d_parent);
 		unionfs_unlock_dentry(dentry->d_parent);
+	}
 	unionfs_read_unlock(dentry->d_sb);
 
 	return ret;
@@ -520,8 +521,7 @@ out:
 
 	unionfs_check_inode(parent);
 	if (!err)
-		unionfs_check_dentry(dentry->d_parent);
-	unionfs_check_dentry(dentry);
+		unionfs_check_dentry(dentry);
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
@@ -815,8 +815,7 @@ out:
 
 	unionfs_check_inode(parent);
 	if (!err)
-		unionfs_check_dentry(dentry->d_parent);
-	unionfs_check_dentry(dentry);
+		unionfs_check_dentry(dentry);
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
@@ -1110,8 +1109,8 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	/* if setattr succeeded, then parent dir may have changed */
 	unionfs_copy_attr_times(dentry->d_parent->d_inode);
 out:
-	unionfs_check_dentry(dentry);
-	unionfs_check_dentry(dentry->d_parent);
+	if (!err)
+		unionfs_check_dentry(dentry);
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 
-- 
1.5.2.2

