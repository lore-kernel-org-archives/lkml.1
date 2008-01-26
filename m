Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYAZFH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYAZFH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYAZFFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:05:54 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47454 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYAZFFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:05:36 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Mike Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH 4/4] Unionfs: lock_rename related locking fixes
Date: Sat, 26 Jan 2008 00:05:02 -0500
Message-Id: <1201323904620-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12013239022656-git-send-email-ezk@cs.sunysb.edu>
References: <12013239022656-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Mike Halcrow <mhalcrow@us.ibm.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/rename.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 9306a2b..5ab13f9 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -29,6 +29,7 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct dentry *lower_new_dir_dentry;
 	struct dentry *lower_wh_dentry;
 	struct dentry *lower_wh_dir_dentry;
+	struct dentry *trap;
 	char *wh_name = NULL;
 
 	lower_new_dentry = unionfs_lower_dentry_idx(new_dentry, bindex);
@@ -95,6 +96,7 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto out;
 
 	dget(lower_old_dentry);
+	dget(lower_new_dentry);
 	lower_old_dir_dentry = dget_parent(lower_old_dentry);
 	lower_new_dir_dentry = dget_parent(lower_new_dentry);
 
@@ -122,9 +124,20 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	/* see Documentation/filesystems/unionfs/issues.txt */
 	lockdep_off();
-	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	trap = lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	/* source should not be ancenstor of target */
+	if (trap == lower_old_dentry) {
+		err = -EINVAL;
+		goto out_err_unlock;
+	}
+	/* target should not be ancenstor of source */
+	if (trap == lower_new_dentry) {
+		err = -ENOTEMPTY;
+		goto out_err_unlock;
+	}
 	err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
 			 lower_new_dir_dentry->d_inode, lower_new_dentry);
+out_err_unlock:
 	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	lockdep_on();
 
@@ -132,6 +145,7 @@ out_dput:
 	dput(lower_old_dir_dentry);
 	dput(lower_new_dir_dentry);
 	dput(lower_old_dentry);
+	dput(lower_new_dentry);
 
 out:
 	if (!err) {
-- 
1.5.2.2

