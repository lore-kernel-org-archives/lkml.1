Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYDCBuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYDCBuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbYDCBt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:49:56 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45873 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbYDCBty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:49:54 -0400
Date: Wed, 2 Apr 2008 21:49:11 -0400
Message-Id: <200804030149.m331nBCv005555@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org
Subject: fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add locking to copy_inode_size
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, this patch has been in my git tree for a while.  It affects current
mainline users (i.e., ecryptfs).  Do you think it can go to mainline soon?
If not, post-25? (I can remind you then).  This patch has a few changes, and
I can break it into several smaller ones if desired:

1. remove the 3rd arg to fsstack_copy_attr_all.  There are no users for it:
   ecryptfs never used the 3rd arg; unionfs stopped using it a long time
   ago.  Halcrow ok'ed this patch some time ago.

2. add necessary locking for 32-bit smp systems in fsstack_copy_inode_size
   (courtesy Hugh Dickins).

3. minor commenting style changes, and addition of copyrights which were
   missing.

Thanks,
Erez.

--cut--here----cut--here----cut--here----cut--here----cut--here--


fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add locking to copy_inode_size

Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

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
diff --git a/fs/ecryptfs/dentry.c b/fs/ecryptfs/dentry.c
index 5e59658..4621f89 100644
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
index e238611..687819d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -575,9 +575,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -910,7 +910,7 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 
 	rc = notify_change(lower_dentry, ia);
 out:
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d25ac95..7eac062 100644
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
