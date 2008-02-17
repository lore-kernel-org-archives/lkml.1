Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYBQDEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYBQDEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYBQC7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:59:09 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36440 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbYBQC7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:59:06 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 14/17] Unionfs: stop using iget() and read_inode()
Date: Sat, 16 Feb 2008 21:57:23 -0500
Message-Id: <12032170532579-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Replace unionfs_read_inode() with unionfs_iget(), and call that instead of
iget().  unionfs_iget() then uses iget_locked() directly and returns a
proper error code instead of an inode in the event of an error.

unionfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c  |   11 +++++------
 fs/unionfs/super.c |   19 ++++++++++++++-----
 fs/unionfs/union.h |    1 +
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index ba3471d..4bc2c66 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -104,9 +104,8 @@ struct dentry *unionfs_interpose(struct dentry *dentry, struct super_block *sb,
 	BUG_ON(is_negative_dentry);
 
 	/*
-	 * We allocate our new inode below, by calling iget.
-	 * iget will call our read_inode which will initialize some
-	 * of the new inode's fields
+	 * We allocate our new inode below by calling unionfs_iget,
+	 * which will initialize some of the new inode's fields
 	 */
 
 	/*
@@ -128,9 +127,9 @@ struct dentry *unionfs_interpose(struct dentry *dentry, struct super_block *sb,
 		}
 	} else {
 		/* get unique inode number for unionfs */
-		inode = iget(sb, iunique(sb, UNIONFS_ROOT_INO));
-		if (!inode) {
-			err = -EACCES;
+		inode = unionfs_iget(sb, iunique(sb, UNIONFS_ROOT_INO));
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
 			goto out;
 		}
 		if (atomic_read(&inode->i_count) > 1)
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 175840f..b71fc2a 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -24,11 +24,19 @@
  */
 static struct kmem_cache *unionfs_inode_cachep;
 
-static void unionfs_read_inode(struct inode *inode)
+struct inode *unionfs_iget(struct super_block *sb, unsigned long ino)
 {
 	int size;
-	struct unionfs_inode_info *info = UNIONFS_I(inode);
+	struct unionfs_inode_info *info;
+	struct inode *inode;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+ 	if (!(inode->i_state & I_NEW))
+ 		return inode;
+
+	info = UNIONFS_I(inode);
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
@@ -44,7 +52,8 @@ static void unionfs_read_inode(struct inode *inode)
 	if (unlikely(!info->lower_inodes)) {
 		printk(KERN_CRIT "unionfs: no kernel memory when allocating "
 		       "lower-pointer array!\n");
-		BUG();
+		iget_failed(inode);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_version++;
@@ -60,7 +69,8 @@ static void unionfs_read_inode(struct inode *inode)
 	inode->i_atime.tv_sec = inode->i_atime.tv_nsec = 0;
 	inode->i_mtime.tv_sec = inode->i_mtime.tv_nsec = 0;
 	inode->i_ctime.tv_sec = inode->i_ctime.tv_nsec = 0;
-
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
@@ -1025,7 +1035,6 @@ out:
 }
 
 struct super_operations unionfs_sops = {
-	.read_inode	= unionfs_read_inode,
 	.delete_inode	= unionfs_delete_inode,
 	.put_super	= unionfs_put_super,
 	.statfs		= unionfs_statfs,
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 1bf0c09..533806c 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -364,6 +364,7 @@ extern int unionfs_fsync(struct file *file, struct dentry *dentry,
 extern int unionfs_fasync(int fd, struct file *file, int flag);
 
 /* Inode operations */
+extern struct inode *unionfs_iget(struct super_block *sb, unsigned long ino);
 extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 extern int unionfs_unlink(struct inode *dir, struct dentry *dentry);
-- 
1.5.2.2

