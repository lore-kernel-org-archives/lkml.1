Return-Path: <linux-kernel-owner+w=401wt.eu-S1760407AbYBQDDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbYBQDDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbYBQC6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:40 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36370 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYBQC6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:32 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/17] Unionfs: extend dentry branch configuration lock in open
Date: Sat, 16 Feb 2008 21:57:15 -0500
Message-Id: <1203217049377-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dentry branch configuration "info node" lock should extend to calls to
copy_attr_times.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index f37192f..96473c4 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -521,11 +521,12 @@ int unionfs_open(struct inode *inode, struct file *file)
 {
 	int err = 0;
 	struct file *lower_file = NULL;
-	struct dentry *dentry = NULL;
+	struct dentry *dentry = file->f_path.dentry;
 	int bindex = 0, bstart = 0, bend = 0;
 	int size;
 
 	unionfs_read_lock(inode->i_sb, UNIONFS_SMUTEX_PARENT);
+	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
 
 	file->private_data =
 		kzalloc(sizeof(struct unionfs_file_info), GFP_KERNEL);
@@ -551,9 +552,6 @@ int unionfs_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	dentry = file->f_path.dentry;
-	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
-
 	bstart = fbstart(file) = dbstart(dentry);
 	bend = fbend(file) = dbend(dentry);
 
@@ -573,15 +571,12 @@ int unionfs_open(struct inode *inode, struct file *file)
 			if (!lower_file)
 				continue;
 
-			branchput(file->f_path.dentry->d_sb, bindex);
+			branchput(dentry->d_sb, bindex);
 			/* fput calls dput for lower_dentry */
 			fput(lower_file);
 		}
 	}
 
-	/* XXX: should this unlock be moved to the function bottom? */
-	unionfs_unlock_dentry(dentry);
-
 out:
 	if (err) {
 		kfree(UNIONFS_F(file)->lower_files);
@@ -590,12 +585,11 @@ out:
 	}
 out_nofree:
 	if (!err) {
-		dentry = file->f_path.dentry;
-		unionfs_copy_attr_times(dentry->d_parent->d_inode);
 		unionfs_copy_attr_times(inode);
 		unionfs_check_file(file);
 		unionfs_check_inode(inode);
 	}
+	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(inode->i_sb);
 	return err;
 }
-- 
1.5.2.2

