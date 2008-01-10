Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYAJPBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYAJPBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYAJPAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:00:18 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56941 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbYAJPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:12 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/29] VFS/eCryptfs: use simplified fs_stack API to fsstack_copy_attr_all
Date: Thu, 10 Jan 2008 09:59:21 -0500
Message-Id: <11999771893150-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/ecryptfs/dentry.c     |    2 +-
 fs/ecryptfs/inode.c      |    6 +++---
 fs/ecryptfs/main.c       |    2 +-
 fs/stack.c               |   38 ++++++++++++++++++++++++--------------
 include/linux/fs_stack.h |   21 ++++++++++++++++-----
 5 files changed, 45 insertions(+), 24 deletions(-)

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
index 5a71918..89e8560 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -576,9 +576,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -912,7 +912,7 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 
 	rc = notify_change(lower_dentry, ia);
 out:
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index e5580bc..6276cdf 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -211,7 +211,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 		d_add(dentry, inode);
 	else
 		d_instantiate(dentry, inode);
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
diff --git a/fs/stack.c b/fs/stack.c
index 67716f6..4336f2b 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -1,24 +1,42 @@
+/*
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
 
-/* does _NOT_ require i_mutex to be held.
+/*
+ * does _NOT_ require i_mutex to be held.
  *
  * This function cannot be inlined since i_size_{read,write} is rather
  * heavy-weight on 32-bit systems
  */
 void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
 {
-	i_size_write(dst, i_size_read((struct inode *)src));
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_lock(&dst->i_lock);
+#endif
+	i_size_write(dst, i_size_read(src));
 	dst->i_blocks = src->i_blocks;
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_unlock(&dst->i_lock);
+#endif
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
-/* copy all attributes; get_nlinks is optional way to override the i_nlink
+/*
+ * copy all attributes; get_nlinks is optional way to override the i_nlink
  * copying
  */
-void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-				int (*get_nlinks)(struct inode *))
+void fsstack_copy_attr_all(struct inode *dest, const struct inode *src)
 {
 	dest->i_mode = src->i_mode;
 	dest->i_uid = src->i_uid;
@@ -29,14 +47,6 @@ void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
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
index bb516ce..6b52faf 100644
--- a/include/linux/fs_stack.h
+++ b/include/linux/fs_stack.h
@@ -1,17 +1,28 @@
+/*
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #ifndef _LINUX_FS_STACK_H
 #define _LINUX_FS_STACK_H
 
-/* This file defines generic functions used primarily by stackable
+/*
+ * This file defines generic functions used primarily by stackable
  * filesystems; none of these functions require i_mutex to be held.
  */
 
 #include <linux/fs.h>
 
 /* externs for fs/stack.c */
-extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-				int (*get_nlinks)(struct inode *));
-
-extern void fsstack_copy_inode_size(struct inode *dst, const struct inode *src);
+extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
+extern void fsstack_copy_inode_size(struct inode *dst,
+				    const struct inode *src);
 
 /* inlines */
 static inline void fsstack_copy_attr_atime(struct inode *dest,
-- 
1.5.2.2

