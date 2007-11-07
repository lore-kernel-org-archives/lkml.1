Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbXKGGtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbXKGGtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbXKGGtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:49:00 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46099 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbXKGGs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:48:59 -0500
Date: Wed, 7 Nov 2007 01:48:44 -0500
Message-Id: <200711070648.lA76miPW005794@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: ezk@cs.sunysb.edu, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Unionfs: stop using iget() and read_inode()
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Howells <dhowells@redhat.com>

Stop UnionFS from using iget() and read_inode().  Replace
unionfs_read_inode() with unionfs_iget(), and call that instead of iget().
unionfs_iget() then uses iget_locked() directly and returns a proper error
code instead of an inode in the event of an error.

unionfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index ffb0da1..89e3b31 100644
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
index 7d28045..18e506b 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -24,13 +24,21 @@
  */
 static struct kmem_cache *unionfs_inode_cachep;
 
-static void unionfs_read_inode(struct inode *inode)
+struct inode *unionfs_iget(struct super_block *sb, unsigned long ino)
 {
 	int size;
-	struct unionfs_inode_info *info = UNIONFS_I(inode);
+	struct unionfs_inode_info *info;
+	struct inode *inode;
 
-	unionfs_read_lock(inode->i_sb);
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
+	unionfs_read_lock(sb);
+
+	info = UNIONFS_I(inode);
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
@@ -46,7 +54,9 @@ static void unionfs_read_inode(struct inode *inode)
 	if (unlikely(!info->lower_inodes)) {
 		printk(KERN_CRIT "unionfs: no kernel memory when allocating "
 		       "lower-pointer array!\n");
-		BUG();
+		iget_failed(inode);
+		unionfs_read_unlock(sb);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_version++;
@@ -55,7 +65,9 @@ static void unionfs_read_inode(struct inode *inode)
 
 	inode->i_mapping->a_ops = &unionfs_aops;
 
-	unionfs_read_unlock(inode->i_sb);
+	unlock_new_inode(inode);
+	unionfs_read_unlock(sb);
+	return inode;
 }
 
 /*
@@ -1002,7 +1014,6 @@ out:
 }
 
 struct super_operations unionfs_sops = {
-	.read_inode	= unionfs_read_inode,
 	.delete_inode	= unionfs_delete_inode,
 	.put_super	= unionfs_put_super,
 	.statfs		= unionfs_statfs,
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 9b530ec..f5afae0 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -356,6 +356,7 @@ extern int unionfs_fsync(struct file *file, struct dentry *dentry,
 extern int unionfs_fasync(int fd, struct file *file, int flag);
 
 /* Inode operations */
+extern struct inode *unionfs_iget(struct super_block *sb, unsigned long ino);
 extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 extern int unionfs_unlink(struct inode *dir, struct dentry *dentry);
