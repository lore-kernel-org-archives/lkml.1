Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXKFOxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXKFOxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXKFOxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:53:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbXKFOxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:53:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] IGET: Stop UnionFS from using iget() and read_inode()
To: akpm@linux-foundation.org, ezk@cs.sunysb.edu
Cc: unionfs@filesystems.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 06 Nov 2007 14:52:34 +0000
Message-ID: <20071106145234.4807.69325.stgit@warthog.procyon.org.uk>
In-Reply-To: 200711060835.lA68Z7QN014604@imap1.linux-foundation.org
References: 200711060835.lA68Z7QN014604@imap1.linux-foundation.org
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Stop the UnionFS filesystem from using iget() and read_inode().  Replace
unionfs_read_inode() with unionfs_iget(), and call that instead of iget().
unionfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

unionfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/unionfs/main.c  |   11 +++++------
 fs/unionfs/super.c |   23 +++++++++++++++++------
 fs/unionfs/union.h |    1 +
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 4faae44..8d28520 100644
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
index 4e0fe7c..c9d4562 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -24,14 +24,22 @@
  */
 static struct kmem_cache *unionfs_inode_cachep;
 
-static void unionfs_read_inode(struct inode *inode)
+struct inode *unionfs_iget(struct super_block *sb, unsigned long ino)
 {
 	extern struct address_space_operations unionfs_aops;
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
@@ -47,7 +55,9 @@ static void unionfs_read_inode(struct inode *inode)
 	if (!info->lower_inodes) {
 		printk(KERN_ERR "unionfs: no kernel memory when allocating "
 		       "lower-pointer array!\n");
-		BUG();
+		iget_failed(inode);
+		unionfs_read_unlock(sb);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_version++;
@@ -56,7 +66,9 @@ static void unionfs_read_inode(struct inode *inode)
 
 	inode->i_mapping->a_ops = &unionfs_aops;
 
-	unionfs_read_unlock(inode->i_sb);
+	unlock_new_inode(inode);
+	unionfs_read_unlock(sb);
+	return inode;
 }
 
 /*
@@ -996,7 +1008,6 @@ out:
 }
 
 struct super_operations unionfs_sops = {
-	.read_inode	= unionfs_read_inode,
 	.delete_inode	= unionfs_delete_inode,
 	.put_super	= unionfs_put_super,
 	.statfs		= unionfs_statfs,
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 97da8f9..2653802 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -322,6 +322,7 @@ extern int unionfs_fsync(struct file *file, struct dentry *dentry,
 extern int unionfs_fasync(int fd, struct file *file, int flag);
 
 /* Inode operations */
+extern struct inode *unionfs_iget(struct super_block *sb, unsigned long ino);
 extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 extern int unionfs_unlink(struct inode *dir, struct dentry *dentry);

