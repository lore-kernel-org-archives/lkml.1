Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXICC0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXICC0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXICCZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:09 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57586 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbXICCYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:22 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 02/32] VFS/fsstack: remove 3rd argument to fsstack_copy_attr_all
Date: Sun,  2 Sep 2007 22:20:25 -0400
Message-Id: <1188786055774-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Unionfs needs a special fan-out version of fsstack_copy_attr_all. A
single-level stackable file systems such as eCryptfs can therefore use a
simplified fsstack_copy_attr_all function; remove its 3rd argument, which
was never used by eCryptfs and was only used by Unionfs.

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/ecryptfs/dentry.c     |    2 +-
 fs/ecryptfs/inode.c      |    6 +++---
 fs/ecryptfs/main.c       |    2 +-
 fs/stack.c               |   13 ++-----------
 include/linux/fs_stack.h |    4 +---
 5 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/fs/ecryptfs/dentry.c b/fs/ecryptfs/dentry.c
index cb20b96..a8c1686 100644
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -62,7 +62,7 @@ static int ecryptfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
 
-		fsstack_copy_attr_all(dentry->d_inode, lower_inode, NULL);
+		fsstack_copy_attr_all(dentry->d_inode, lower_inode);
 	}
 out:
 	return rc;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 131954b..fc4c6cb 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -601,9 +601,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
-	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
+	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
 	if (new_dir != old_dir)
-		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode, NULL);
+		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);
 out_lock:
 	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	dput(lower_new_dentry->d_parent);
@@ -961,7 +961,7 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 	}
 	rc = notify_change(lower_dentry, ia);
 out:
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index a984972..cb349a4 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -151,7 +151,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 		d_add(dentry, inode);
 	else
 		d_instantiate(dentry, inode);
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
diff --git a/fs/stack.c b/fs/stack.c
index 4368d4b..a548aac 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -30,8 +30,7 @@ EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
  * copy all attributes; get_nlinks is optional way to override the i_nlink
  * copying
  */
-void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-			   int (*get_nlinks)(struct inode *))
+void fsstack_copy_attr_all(struct inode *dest, const struct inode *src)
 {
 	dest->i_mode = src->i_mode;
 	dest->i_uid = src->i_uid;
@@ -42,14 +41,6 @@ void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
 	dest->i_ctime = src->i_ctime;
 	dest->i_blkbits = src->i_blkbits;
 	dest->i_flags = src->i_flags;
-
-	/*
-	 * Update the nlinks AFTER updating the above fields, because the
-	 * get_links callback may depend on them.
-	 */
-	if (!get_nlinks)
-		dest->i_nlink = src->i_nlink;
-	else
-		dest->i_nlink = (*get_nlinks)(dest);
+	dest->i_nlink = src->i_nlink;
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
index f3cd7f4..6b52faf 100644
--- a/include/linux/fs_stack.h
+++ b/include/linux/fs_stack.h
@@ -20,9 +20,7 @@
 #include <linux/fs.h>
 
 /* externs for fs/stack.c */
-extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-				  int (*get_nlinks)(struct inode *));
-
+extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
 extern void fsstack_copy_inode_size(struct inode *dst,
 				    const struct inode *src);
 
-- 
1.5.2.2.238.g7cbf2f2

