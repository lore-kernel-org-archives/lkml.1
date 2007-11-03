Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbXKCBZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbXKCBZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbXKCBXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:23:24 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35206 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbXKCBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:23:15 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 7/8] Unionfs: don't printk an error if it's due to common copyup
Date: Fri,  2 Nov 2007 21:22:48 -0400
Message-Id: <11940529723778-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
References: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c  |    9 +++++----
 fs/unionfs/rename.c |    2 +-
 fs/unionfs/subr.c   |    8 ++++++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 169365c..bcefe45 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -465,10 +465,11 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				if (IS_ERR(lower_dentry))
 					err = PTR_ERR(lower_dentry);
-
-				printk(KERN_ERR "unionfs: lower dentry "
-				       "NULL (or error) for bindex = %d\n",
-				       bindex);
+				if (!IS_COPYUP_ERR(err))
+					printk(KERN_ERR
+					       "unionfs: create_parents for "
+					       "symlink failed: bindex=%d "
+					       "err=%d\n", bindex, err);
 				continue;
 			}
 		}
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 1ab474f..4a35b5e 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -41,7 +41,7 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				       bindex);
 		if (IS_ERR(lower_new_dentry)) {
 			err = PTR_ERR(lower_new_dentry);
-			if (err == -EROFS)
+			if (IS_COPYUP_ERR(err))
 				goto out;
 			printk(KERN_ERR "unionfs: error creating directory "
 			       "tree for rename, bindex=%d err=%d\n",
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index d97086a..968ee8c 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -61,8 +61,12 @@ int create_whiteout(struct dentry *dentry, int start)
 						      dentry->d_name.name,
 						      bindex);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
-				printk(KERN_ERR "unionfs: create_parents "
-				       "failed for bindex = %d\n", bindex);
+				int ret = PTR_ERR(lower_dentry);
+				if (!IS_COPYUP_ERR(ret))
+					printk(KERN_ERR
+					       "unionfs: create_parents for "
+					       "whiteout failed: bindex=%d "
+					       "err=%d\n", bindex, ret);
 				continue;
 			}
 		}
-- 
1.5.2.2

