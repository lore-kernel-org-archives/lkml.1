Return-Path: <linux-kernel-owner+w=401wt.eu-S2992505AbXCWQKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992505AbXCWQKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992502AbXCWQKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:10:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57659 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992505AbXCWQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:10:38 -0400
Subject: [Patch 1/7] integrity: new hooks
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:09:15 -0400
Message-Id: <1174666155.11149.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds integrity hooks used to implement an integrity service
provider and updates the previously submitted dummy provider to
support these new hooks.

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
signed-off-by: Kylene Hall <kjhall@us.ibm.com>
---
Index: linux-2.6.21-rc4-mm1/security/integrity_dummy.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/security/integrity_dummy.c
+++ linux-2.6.21-rc4-mm1/security/integrity_dummy.c
@@ -3,7 +3,7 @@
  *
  * Instantiate integrity subsystem
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -28,21 +28,24 @@ static int dummy_verify_metadata(struct 
 	int size;
 	int error;
 
-	if (!xattr_value || !xattr_value_len || !status)
+	if (!status)
 		return -EINVAL;
 
-	size = vfs_getxattr(dentry, xattr_name, NULL, 0);
-	if (size < 0) {
-		if (size == -ENODATA)
-			*status = INTEGRITY_NOLABEL;
-		return size;
+	/* get requested extended attribute */
+	if (xattr_name && xattr_value && xattr_value_len) {
+		size = vfs_getxattr(dentry, xattr_name, NULL, 0);
+		if (size < 0) {
+			if (size == -ENODATA)
+				*status = INTEGRITY_NOLABEL;
+			return size;
+		}
+
+		value = kzalloc(size + 1, GFP_KERNEL);
+		if (!value)
+			return -ENOMEM;
+		error = vfs_getxattr(dentry, xattr_name, value, size);
 	}
 
-	value = kzalloc(size + 1, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-	error = vfs_getxattr(dentry, xattr_name, value, size);
-
 	*xattr_value_len = size;
 	*xattr_value = value;
 	*status = INTEGRITY_PASS;
@@ -62,9 +65,78 @@ static void dummy_measure(struct dentry 
 	return;
 }
 
+static int dummy_inode_alloc_integrity(struct inode *inode)
+{
+	return 0;
+}
+
+static void dummy_inode_free_integrity(struct inode *inode)
+{
+	return;
+}
+
+static void dummy_inode_init_integrity(struct inode *inode, struct inode *dir,
+				      char **name, void **value, size_t * len)
+{
+	return;
+}
+
+static void dummy_file_free_integrity(struct file *file)
+{
+	return;
+}
+
+static int dummy_inode_setxattr(struct dentry *dentry, char *name, void *value,
+				size_t size, int flags)
+{
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	return 0;
+}
+
+static void dummy_inode_post_setxattr(struct dentry *dentry, char *name)
+{
+}
+
+static void dummy_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	return;
+}
+
 struct integrity_operations dummy_integrity_ops = {
 	.verify_metadata = dummy_verify_metadata,
 	.verify_data = dummy_verify_data,
-	.measure = dummy_measure
+	.measure = dummy_measure,
+	.inode_setxattr = dummy_inode_setxattr,
+	.inode_post_setxattr = dummy_inode_post_setxattr,
+	.inode_alloc_integrity = dummy_inode_alloc_integrity,
+	.inode_init_integrity = dummy_inode_init_integrity,
+	.inode_free_integrity = dummy_inode_free_integrity,
+	.file_free_integrity = dummy_file_free_integrity,
+	.d_instantiate = dummy_d_instantiate
 };
 
+#define set_to_dummy_if_null(ops, function)				\
+	do {								\
+		if (!ops->function) {					\
+			ops->function = dummy_##function;		\
+			printk(KERN_INFO "Had to override the " #function \
+			" security operation with the dummy one.\n");\
+			}						\
+	} while (0)
+
+void integrity_fixup_ops(struct integrity_operations *ops)
+{
+	set_to_dummy_if_null(ops, verify_metadata);
+	set_to_dummy_if_null(ops, verify_data);
+	set_to_dummy_if_null(ops, measure);
+	set_to_dummy_if_null(ops, inode_setxattr);
+	set_to_dummy_if_null(ops, inode_post_setxattr);
+	set_to_dummy_if_null(ops, inode_alloc_integrity);
+	set_to_dummy_if_null(ops, inode_init_integrity);
+	set_to_dummy_if_null(ops, inode_free_integrity);
+	set_to_dummy_if_null(ops, file_free_integrity);
+	set_to_dummy_if_null(ops, d_instantiate);
+}
Index: linux-2.6.21-rc4-mm1/security/integrity_dummy.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/security/integrity_dummy.h
+++ linux-2.6.21-rc4-mm1/security/integrity_dummy.h
@@ -1,7 +1,7 @@
 /*
  * integrity_dummy.h
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -10,3 +10,4 @@
  */
 
 extern struct integrity_operations dummy_integrity_ops;
+extern void integrity_fixup_ops(struct integrity_operations *ops);
Index: linux-2.6.21-rc4-mm1/include/linux/integrity.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/include/linux/integrity.h
+++ linux-2.6.21-rc4-mm1/include/linux/integrity.h
@@ -1,7 +1,7 @@
 /*
  * integrity.h
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -45,6 +45,45 @@
  *	@filename either contains the full pathname/short file name.
  *	@mask contains the filename permission status(i.e. read, write, append).
  *
+ * @inode_setxattr:
+ *	Check permission before permitting an integrity extended attribute
+ * 	to be set.
+ *	@value identified by @name for @dentry.
+ *	Return 0 if permission is granted.
+ *
+ * @inode_post_setxattr:
+ *	Update inode integrity xattr after successful setxattr operation.
+ * 	identified by @name for @dentry.
+ *
+ * @inode_alloc_integrity:
+ *	Allocate and attach an integrity structure to @inode->i_integrity.  The
+ * 	i_integrity field is initialized to NULL when the inode structure is
+ * 	allocated.
+ * 	@inode contains the inode structure.
+ * 	Return 0 if operation was successful.
+ *
+ * @inode_free_integrity:
+ *	@inode contains the inode structure.
+ * 	Deallocate the inode integrity structure and set @inode->i_integrity to
+ * 	NULL.
+ *
+ * @inode_init_integrity:
+ *	Create inode integrity xattr for a new inode based on the new security
+ * 	xattr information.
+ *	@inode contains the inode structure of the newly created inode.
+ *	@dir contains the inode structure of the parent directory.
+ * 	@name contains the security xattr name suffix.
+ *	@value contains the security attribute value.
+ *	@len contains the length of the security attribute value.
+ *
+ * @file_free_integrity:
+ *	Update the integrity xattr value as necessary.
+ * 	*file contains the file structure being closed.
+ *
+ * @d_instantiate:
+ *	Initialize the integrity structure of an inode for a dentry.
+ *	@dentry to complete.
+ *	@inode to attach to this dentry.
  */
 
 #define PASS_STR "INTEGRITY_PASS"
@@ -57,13 +96,22 @@ struct integrity_operations {
 	int (*verify_data) (struct dentry *dentry, int *status);
 	void (*measure) (struct dentry *dentry,
 			const unsigned char *filename, int mask);
+	int (*inode_setxattr) (struct dentry *dentry, char *name, void *value,
+			       size_t size, int flags);
+	void (*inode_post_setxattr) (struct dentry *dentry, char *name);
+	int (*inode_alloc_integrity) (struct inode *inode);
+	void (*inode_free_integrity) (struct inode *inode);
+	void (*inode_init_integrity) (struct inode *inode, struct inode *dir,
+				    char **name, void **value, size_t *len);
+	void (*file_free_integrity) (struct file * file);
+	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 };
 extern int register_integrity(struct integrity_operations *ops);
 extern int unregister_integrity(struct integrity_operations *ops);
 
 /* global variables */
 extern struct integrity_operations *integrity_ops;
-enum integrity_verify_status {
+enum integrity_status {
 	INTEGRITY_PASS = 0, INTEGRITY_FAIL = -1, INTEGRITY_NOLABEL = -2
 };
 
@@ -77,8 +125,7 @@ static inline int integrity_verify_metad
 			xattr_value, xattr_val_len, status);
 }
 
-static inline int integrity_verify_data(struct dentry *dentry,
-					int *status)
+static inline int integrity_verify_data(struct dentry *dentry, int *status)
 {
 	return integrity_ops->verify_data(dentry, status);
 }
@@ -88,6 +135,55 @@ static inline void integrity_measure(str
 {
 	integrity_ops->measure(dentry, filename, mask);
 }
+
+static inline int integrity_inode_setxattr(struct dentry *dentry, char *name,
+					   void *value, size_t size, int flags)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return integrity_ops->inode_setxattr(dentry, name, value, size, flags);
+}
+
+static inline void integrity_inode_post_setxattr(struct dentry *dentry, char *name)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return;
+ 	integrity_ops->inode_post_setxattr(dentry, name);
+}
+
+static inline int integrity_inode_alloc(struct inode *inode)
+{
+	return integrity_ops->inode_alloc_integrity(inode);
+}
+
+static inline void integrity_inode_free(struct inode *inode)
+{
+	integrity_ops->inode_free_integrity(inode);
+}
+
+static inline void integrity_inode_init_integrity(struct inode *inode,
+						struct inode *dir,
+						char **name,
+						void **value,
+						size_t *len)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return;
+	integrity_ops->inode_init_integrity(inode, dir, name, value, len);
+	return;
+}
+
+static inline void integrity_file_free(struct file *file)
+{
+	integrity_ops->file_free_integrity(file);
+}
+
+static inline void integrity_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	if (unlikely (inode && IS_PRIVATE(inode)))
+		return;
+	integrity_ops->d_instantiate(dentry, inode);
+}
 #else
 static inline int integrity_verify_metadata(struct dentry *dentry,
 			char *xattr_name, char **xattr_value,
@@ -97,8 +193,7 @@ static inline int integrity_verify_metad
 	return 0;
 }
 
-static inline int integrity_verify_data(struct dentry *dentry,
-					int *status)
+static inline int integrity_verify_data(struct dentry *dentry, int *status)
 {
 	status = INTEGRITY_PASS;
 	return 0;
@@ -108,5 +203,47 @@ static inline void integrity_measure(str
 			const unsigned char *filename, int mask)
 {
 }
+
+static inline int integrity_inode_setxattr(struct dentry *dentry, char *name,
+					   void *value, size_t size, int flags)
+{
+	return 0;
+}
+
+static inline void integrity_inode_post_setxattr(struct dentry *dentry, char *name)
+{ }
+
+static inline int integrity_inode_alloc(struct inode *inode)
+{
+	return 0;
+}
+
+static inline void integrity_inode_free(struct inode *inode)
+{ }
+
+static inline int integrity_inode_init_integrity(struct inode *inode,
+						struct inode *dir,
+						char **name,
+						void **value,
+						size_t *len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int integrity_file_permission(struct file *file, int mask)
+{
+	return 0;
+}
+
+static inline void integrity_file_free(struct file *file)
+{
+	return;
+}
+
+static inline void integrity_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	return;
+}
+
 #endif
 #endif
Index: linux-2.6.21-rc4-mm1/security/integrity.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/security/integrity.c
+++ linux-2.6.21-rc4-mm1/security/integrity.c
@@ -3,7 +3,7 @@
  *
  * register integrity subsystem
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -27,6 +27,7 @@ int register_integrity(struct integrity_
 		return -EAGAIN;
 
 	integrity_ops = ops;
+	integrity_fixup_ops(integrity_ops);
 	return 0;
 }
 


