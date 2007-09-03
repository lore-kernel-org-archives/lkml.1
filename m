Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXICCg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXICCg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbXICC0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:17 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57702 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbXICCZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:19 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 27/32] Unionfs: extended attributes fixes
Date: Sun,  2 Sep 2007 22:20:50 -0400
Message-Id: <11887860591926-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |   43 +++++++++++++++++++++++++++++++------------
 fs/unionfs/union.h  |    6 ++++--
 fs/unionfs/xattr.c  |   16 ++--------------
 3 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 4c45790..36f751e 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -32,27 +32,39 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
 	ssize_t list_size = -1;
 	char *name_list = NULL;
 	char *attr_value = NULL;
-	char *name_list_orig = NULL;
+	char *name_list_buf = NULL;
 
+	/* query the actual size of the xattr list */
 	list_size = vfs_listxattr(old_lower_dentry, NULL, 0);
-
 	if (list_size <= 0) {
 		err = list_size;
 		goto out;
 	}
 
+	/* allocate space for the actual list */
 	name_list = unionfs_xattr_alloc(list_size + 1, XATTR_LIST_MAX);
 	if (!name_list || IS_ERR(name_list)) {
 		err = PTR_ERR(name_list);
 		goto out;
 	}
+
+	name_list_buf = name_list; /* save for kfree at end */
+
+	/* now get the actual xattr list of the source file */
 	list_size = vfs_listxattr(old_lower_dentry, name_list, list_size);
+	if (list_size <= 0) {
+		err = list_size;
+		goto out;
+	}
+
+	/* allocate space to hold each xattr's value */
 	attr_value = unionfs_xattr_alloc(XATTR_SIZE_MAX, XATTR_SIZE_MAX);
 	if (!attr_value || IS_ERR(attr_value)) {
 		err = PTR_ERR(name_list);
 		goto out;
 	}
-	name_list_orig = name_list;
+
+	/* in a loop, get and set each xattr from src to dst file */
 	while (*name_list) {
 		ssize_t size;
 
@@ -65,7 +77,6 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
 			err = size;
 			goto out;
 		}
-
 		if (size > XATTR_SIZE_MAX) {
 			err = -E2BIG;
 			goto out;
@@ -73,19 +84,27 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
 		/* Don't lock here since vfs_setxattr does it for us. */
 		err = vfs_setxattr(new_lower_dentry, name_list, attr_value,
 				   size, 0);
-
+		/*
+		 * Selinux depends on "security.*" xattrs, so to maintain
+		 * the security of copied-up files, if Selinux is active,
+		 * then we must copy these xattrs as well.  So we need to
+		 * temporarily get FOWNER privileges.
+		 * XXX: move entire copyup code to SIOQ.
+		 */
+		if (err == -EPERM && !capable(CAP_FOWNER)) {
+			cap_raise(current->cap_effective, CAP_FOWNER);
+			err = vfs_setxattr(new_lower_dentry, name_list,
+					   attr_value, size, 0);
+			cap_lower(current->cap_effective, CAP_FOWNER);
+		}
 		if (err < 0)
 			goto out;
 		name_list += strlen(name_list) + 1;
 	}
 out:
-	name_list = name_list_orig;
-
-	if (name_list)
-		unionfs_xattr_free(name_list, list_size + 1);
-	if (attr_value)
-		unionfs_xattr_free(attr_value, XATTR_SIZE_MAX);
-	/* It is no big deal if this fails, we just roll with the punches. */
+	unionfs_xattr_kfree(name_list_buf);
+	unionfs_xattr_kfree(attr_value);
+	/* Ignore if xattr isn't supported */
 	if (err == -ENOTSUPP || err == -EOPNOTSUPP)
 		err = 0;
 	return err;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 26d886e..d1232ac 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -341,8 +341,10 @@ extern struct dentry *unionfs_interpose(struct dentry *this_dentry,
 #ifdef CONFIG_UNION_FS_XATTR
 /* Extended attribute functions. */
 extern void *unionfs_xattr_alloc(size_t size, size_t limit);
-extern void unionfs_xattr_free(void *ptr, size_t size);
-
+static inline void unionfs_xattr_kfree(const void *p)
+{
+	kfree(p);
+}
 extern ssize_t unionfs_getxattr(struct dentry *dentry, const char *name,
 				void *value, size_t size);
 extern int unionfs_removexattr(struct dentry *dentry, const char *name);
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 46f3d4e..6ab92f3 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -28,25 +28,13 @@ void *unionfs_xattr_alloc(size_t size, size_t limit)
 
 	if (!size)		/* size request, no buffer is needed */
 		return NULL;
-	else if (size <= PAGE_SIZE)
-		ptr = kmalloc(size, GFP_KERNEL);
-	else
-		ptr = vmalloc(size);
+
+	ptr = kmalloc(size, GFP_KERNEL);
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 	return ptr;
 }
 
-void unionfs_xattr_free(void *ptr, size_t size)
-{
-	if (!size)		/* size request, no buffer was needed */
-		return;
-	else if (size <= PAGE_SIZE)
-		kfree(ptr);
-	else
-		vfree(ptr);
-}
-
 /*
  * BKL held by caller.
  * dentry->d_inode->i_mutex locked
-- 
1.5.2.2.238.g7cbf2f2

