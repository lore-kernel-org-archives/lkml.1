Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbYDYWYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbYDYWYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbYDYWUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:42 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40629 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763837AbYDYWUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:35 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/12] Unionfs: minor code cleanups
Date: Fri, 25 Apr 2008 18:18:57 -0400
Message-Id: <1209161949502-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    2 --
 fs/unionfs/file.c       |   17 +++++------------
 fs/unionfs/inode.c      |   39 +++++++++++++++++----------------------
 3 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 50f4eda..0fc7963 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -250,7 +250,6 @@ static int do_delayed_copyup(struct file *file)
 	BUG_ON(!S_ISREG(dentry->d_inode->i_mode));
 
 	unionfs_check_file(file);
-	unionfs_check_dentry(dentry);
 	for (bindex = bstart - 1; bindex >= 0; bindex--) {
 		if (!d_deleted(dentry))
 			err = copyup_file(parent_inode, file, bstart,
@@ -292,7 +291,6 @@ static int do_delayed_copyup(struct file *file)
 
 out:
 	unionfs_check_file(file);
-	unionfs_check_dentry(dentry);
 	return err;
 }
 
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 0a39387..1fe4c30 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -35,14 +35,14 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 	err = vfs_read(lower_file, buf, count, ppos);
 	/* update our inode atime upon a successful lower read */
 	if (err >= 0) {
-		fsstack_copy_attr_atime(file->f_path.dentry->d_inode,
+		fsstack_copy_attr_atime(dentry->d_inode,
 					lower_file->f_path.dentry->d_inode);
 		unionfs_check_file(file);
 	}
 
 out:
 	unionfs_unlock_dentry(dentry);
-	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -63,32 +63,25 @@ static ssize_t unionfs_write(struct file *file, const char __user *buf,
 	err = vfs_write(lower_file, buf, count, ppos);
 	/* update our inode times+sizes upon a successful lower write */
 	if (err >= 0) {
-		fsstack_copy_inode_size(file->f_path.dentry->d_inode,
+		fsstack_copy_inode_size(dentry->d_inode,
 					lower_file->f_path.dentry->d_inode);
-		fsstack_copy_attr_times(file->f_path.dentry->d_inode,
+		fsstack_copy_attr_times(dentry->d_inode,
 					lower_file->f_path.dentry->d_inode);
 		unionfs_check_file(file);
 	}
 
 out:
 	unionfs_unlock_dentry(dentry);
-	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
-
 static int unionfs_file_readdir(struct file *file, void *dirent,
 				filldir_t filldir)
 {
 	return -ENOTDIR;
 }
 
-int unionfs_readpage_dummy(struct file *file, struct page *page)
-{
-	BUG();
-	return -EINVAL;
-}
-
 static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int err = 0;
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 0dc07ec..1446124 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -396,28 +396,23 @@ docopyup:
 					    bindex, old_dentry->d_name.name,
 					    old_dentry->d_name.len, NULL,
 					    i_size_read(old_dentry->d_inode));
-			if (!err) {
-				lower_new_dentry =
-					create_parents(dir, new_dentry,
-						       new_dentry->d_name.name,
-						       bindex);
-				lower_old_dentry =
-					unionfs_lower_dentry(old_dentry);
-				lower_dir_dentry =
-					lock_parent(lower_new_dentry);
-				/*
-				 * see
-				 * Documentation/filesystems/unionfs/issues.txt
-				 */
-				lockdep_off();
-				/* do vfs_link */
-				err = vfs_link(lower_old_dentry,
-					       lower_dir_dentry->d_inode,
-					       lower_new_dentry);
-				lockdep_on();
-				unlock_dir(lower_dir_dentry);
-				goto check_link;
-			}
+			if (err)
+				continue;
+			lower_new_dentry =
+				create_parents(dir, new_dentry,
+					       new_dentry->d_name.name,
+					       bindex);
+			lower_old_dentry = unionfs_lower_dentry(old_dentry);
+			lower_dir_dentry = lock_parent(lower_new_dentry);
+			/* see Documentation/filesystems/unionfs/issues.txt */
+			lockdep_off();
+			/* do vfs_link */
+			err = vfs_link(lower_old_dentry,
+				       lower_dir_dentry->d_inode,
+				       lower_new_dentry);
+			lockdep_on();
+			unlock_dir(lower_dir_dentry);
+			goto check_link;
 		}
 		goto out;
 	}
-- 
1.5.2.2

