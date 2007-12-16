Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbXLPQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbXLPQiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 11:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXLPQiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 11:38:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:58449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750819AbXLPQiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 11:38:05 -0500
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX19tCsxkZzVtwpQqwxTkLL6v2ekcCUa5hTRa1SvP9t
	r4qm48Am8QuNEh
Subject: [PATCH] debugfs: Revamp debugfs_create_{u,x,s}{8,16,32,64} to
	support signed integers
From: Mattias Nissler <mattias.nissler@gmx.de>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 16 Dec 2007 17:37:59 +0100
Message-Id: <1197823079.7530.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes debugfs use its own file_operations for the value accessor files
created by debugfs_create_XXX. Having that, we can also have proper versions
for signed integers.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---

When writing some debugfs code for mac80211 I wanted to have access to
some s32 variables. I thought it's better to make debugfs support signed
integers instead of adding the functionality locally. I assume generic
versions will be useful for other people as well.

Please CC me for replies.


 fs/debugfs/file.c       |  291 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/debugfs.h |   45 +++++++
 2 files changed, 287 insertions(+), 49 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index fa6b7f7..8808bc0 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -56,18 +56,121 @@ const struct inode_operations debugfs_link_operations = {
 	.follow_link    = debugfs_follow_link,
 };
 
-static void debugfs_u8_set(void *data, u64 val)
+/* Simple numeric attributes */
+struct debugfs_num_attr
 {
-	*(u8 *)data = val;
+	void (*get)(void *, char *);
+	void (*set)(void *, char *);
+	char get_buf[24];
+	char set_buf[24];
+	void *pnum;
+	struct mutex mutex;
+};
+
+static int debugfs_num_attr_open(struct inode *inode, struct file *file,
+				 void (*get)(void *, char*),
+				 void (*set)(void *, char*))
+{
+	struct debugfs_num_attr *attr;
+
+	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	attr->get = get;
+	attr->set = set;
+	attr->pnum = inode->i_private;
+	mutex_init(&attr->mutex);
+
+	file->private_data = attr;
+
+	return nonseekable_open(inode, file);
+}
+
+static int debugfs_num_attr_close(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+
+	return 0;
+}
+
+static ssize_t debugfs_num_attr_read(struct file *file, char __user *buf,
+				     size_t len, loff_t *ppos)
+{
+	struct debugfs_num_attr *attr;
+	size_t size;
+	ssize_t ret;
+
+	attr = file->private_data;
+
+	mutex_lock(&attr->mutex);
+	if (!*ppos) {
+		/* first read */
+		attr->get(attr->pnum, attr->get_buf);
+		attr->get_buf[sizeof(attr->get_buf) - 1] = '\0';
+	}
+
+	size = strlen(attr->get_buf);
+	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
+	mutex_unlock(&attr->mutex);
+
+	return ret;
 }
-static u64 debugfs_u8_get(void *data)
+
+static ssize_t debugfs_num_attr_write(struct file *file, const char __user *buf,
+				      size_t len, loff_t *ppos)
 {
-	return *(u8 *)data;
+	struct debugfs_num_attr *attr;
+	size_t size;
+	ssize_t ret;
+
+	attr = file->private_data;
+
+	mutex_lock(&attr->mutex);
+	ret = -EFAULT;
+	size = min(sizeof(attr->set_buf) - 1, len);
+	if (copy_from_user(attr->set_buf, buf, size))
+		goto out;
+
+	ret = len; /* claim we got the whole input */
+	attr->set_buf[size] = '\0';
+	attr->set(attr->pnum, attr->set_buf);
+out:
+	mutex_unlock(&attr->mutex);
+	return ret;
 }
-DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs_u8_get, debugfs_u8_set, "%llu\n");
+
+#define DEFINE_NUM_ATTR(__fops, __type, __format)			\
+static void __fops ## _get(void *data, char *buf)			\
+{									\
+	scnprintf(buf, 24, __format, *(__type *) data);			\
+}									\
+static void __fops ## _set(void *data, char *buf)			\
+{									\
+	sscanf(buf, __format, (__type *) data);				\
+}									\
+static int __fops ## _open(struct inode *inode, struct file *file)	\
+{									\
+	return debugfs_num_attr_open(inode, file, __fops ## _get,	\
+				     __fops ## _set);			\
+}									\
+static struct file_operations __fops = {				\
+	.owner	 = THIS_MODULE,						\
+	.open	 = __fops ## _open,					\
+	.release = debugfs_num_attr_close,				\
+	.read	 = debugfs_num_attr_read,				\
+	.write	 = debugfs_num_attr_write,				\
+};
+
+DEFINE_NUM_ATTR(fops_u8, u8, "%hhu\n")
+DEFINE_NUM_ATTR(fops_u16, u16, "%hu\n")
+DEFINE_NUM_ATTR(fops_u32, u32, "%u\n")
+DEFINE_NUM_ATTR(fops_u64, u64, "%llu\n")
 
 /**
- * debugfs_create_u8 - create a debugfs file that is used to read and write an unsigned 8-bit value
+ * debugfs_create_u8 - create a debugfs file that is used to read and write an
+ * unsigned 8-bit value
+ *
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -97,18 +200,10 @@ struct dentry *debugfs_create_u8(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u8);
 
-static void debugfs_u16_set(void *data, u64 val)
-{
-	*(u16 *)data = val;
-}
-static u64 debugfs_u16_get(void *data)
-{
-	return *(u16 *)data;
-}
-DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugfs_u16_get, debugfs_u16_set, "%llu\n");
-
 /**
- * debugfs_create_u16 - create a debugfs file that is used to read and write an unsigned 16-bit value
+ * debugfs_create_u16 - create a debugfs file that is used to read and write an
+ * unsigned 16-bit value
+ *
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -138,18 +233,10 @@ struct dentry *debugfs_create_u16(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u16);
 
-static void debugfs_u32_set(void *data, u64 val)
-{
-	*(u32 *)data = val;
-}
-static u64 debugfs_u32_get(void *data)
-{
-	return *(u32 *)data;
-}
-DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugfs_u32_get, debugfs_u32_set, "%llu\n");
-
 /**
- * debugfs_create_u32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+ * debugfs_create_u32 - create a debugfs file that is used to read and write an
+ * unsigned 32-bit value
+ *
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -179,19 +266,10 @@ struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
-static void debugfs_u64_set(void *data, u64 val)
-{
-	*(u64 *)data = val;
-}
-
-static u64 debugfs_u64_get(void *data)
-{
-	return *(u64 *)data;
-}
-DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugfs_u64_get, debugfs_u64_set, "%llu\n");
-
 /**
- * debugfs_create_u64 - create a debugfs file that is used to read and write an unsigned 64-bit value
+ * debugfs_create_u64 - create a debugfs file that is used to read and write an
+ * unsigned 64-bit value
+ *
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -221,14 +299,104 @@ struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u64);
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");
+DEFINE_NUM_ATTR(fops_s8, s8, "%hhd\n")
+DEFINE_NUM_ATTR(fops_s16, s16, "%hd\n")
+DEFINE_NUM_ATTR(fops_s32, s32, "%d\n")
+DEFINE_NUM_ATTR(fops_s64, s64, "%lld\n")
+
+/*
+ * debugfs_create_s{8,16,32,64} - create a debugfs file that is used to read
+ * and write a signed {8,16,32,64}-bit value
+ *
+ * These functions are exactly the same as the above functions (but use a hex
+ * output for the decimal challenged). For details look at the above unsigned
+ * decimal functions.
+ */
+
+/**
+ * debugfs_create_s8 - create a debugfs file that is used to read and write a
+ * signed 8-bit value
+ *
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_create_s8(const char *name, mode_t mode,
+				 struct dentry *parent, s8 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s8);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s8);
+
+/**
+ * debugfs_create_s16 - create a debugfs file that is used to read and write a
+ * signed 16-bit value
+ *
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_create_s16(const char *name, mode_t mode,
+				 struct dentry *parent, s16 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s16);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s16);
+
+/**
+ * debugfs_create_s32 - create a debugfs file that is used to read and write a
+ * signed 32-bit value
+ *
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_create_s32(const char *name, mode_t mode,
+				 struct dentry *parent, s32 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s32);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s32);
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
+/**
+ * debugfs_create_s64 - create a debugfs file that is used to read and write a
+ * signed 32-bit value
+ *
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_create_s64(const char *name, mode_t mode,
+				 struct dentry *parent, s64 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s64);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s64);
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
+DEFINE_NUM_ATTR(fops_x8, u8, "%hhx\n")
+DEFINE_NUM_ATTR(fops_x16, u16, "%hx\n")
+DEFINE_NUM_ATTR(fops_x32, u32, "%x\n")
+DEFINE_NUM_ATTR(fops_x64, u64, "%llx\n")
 
 /*
- * debugfs_create_x{8,16,32} - create a debugfs file that is used to read and write an unsigned {8,16,32}-bit value
+ * debugfs_create_x{8,16,32,64} - create a debugfs file that is used to read
+ * and write an unsigned {8,16,32,64}-bit value
  *
  * These functions are exactly the same as the above functions (but use a hex
  * output for the decimal challenged). For details look at the above unsigned
@@ -236,7 +404,9 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n"
  */
 
 /**
- * debugfs_create_x8 - create a debugfs file that is used to read and write an unsigned 8-bit value
+ * debugfs_create_x8 - create a debugfs file that is used to read and write an
+ * unsigned 8-bit value
+ *
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -253,7 +423,9 @@ struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 EXPORT_SYMBOL_GPL(debugfs_create_x8);
 
 /**
- * debugfs_create_x16 - create a debugfs file that is used to read and write an unsigned 16-bit value
+ * debugfs_create_x16 - create a debugfs file that is used to read and write an
+ * unsigned 16-bit value
+ *
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -263,14 +435,16 @@ EXPORT_SYMBOL_GPL(debugfs_create_x8);
  *         from.
  */
 struct dentry *debugfs_create_x16(const char *name, mode_t mode,
-				 struct dentry *parent, u16 *value)
+				  struct dentry *parent, u16 *value)
 {
 	return debugfs_create_file(name, mode, parent, value, &fops_x16);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x16);
 
 /**
- * debugfs_create_x32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+ * debugfs_create_x32 - create a debugfs file that is used to read and write an
+ * unsigned 32-bit value
+ *
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -280,12 +454,31 @@ EXPORT_SYMBOL_GPL(debugfs_create_x16);
  *         from.
  */
 struct dentry *debugfs_create_x32(const char *name, mode_t mode,
-				 struct dentry *parent, u32 *value)
+				  struct dentry *parent, u32 *value)
 {
 	return debugfs_create_file(name, mode, parent, value, &fops_x32);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x32);
 
+/**
+ * debugfs_create_x64 - create a debugfs file that is used to read and write an
+ * unsigned 32-bit value
+ *
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+				  struct dentry *parent, u64 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x64);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x64);
+
 static ssize_t read_file_bool(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index f592d6d..e9991ed 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -49,12 +49,22 @@ struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
 struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 				  struct dentry *parent, u64 *value);
+struct dentry *debugfs_create_s8(const char *name, mode_t mode,
+				 struct dentry *parent, s8 *value);
+struct dentry *debugfs_create_s16(const char *name, mode_t mode,
+				  struct dentry *parent, s16 *value);
+struct dentry *debugfs_create_s32(const char *name, mode_t mode,
+				  struct dentry *parent, s32 *value);
+struct dentry *debugfs_create_s64(const char *name, mode_t mode,
+				  struct dentry *parent, s64 *value);
 struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value);
 struct dentry *debugfs_create_x16(const char *name, mode_t mode,
 				  struct dentry *parent, u16 *value);
 struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
+struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+				  struct dentry *parent, u64 *value);
 struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
 
@@ -128,6 +138,34 @@ static inline struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_s8(const char *name, mode_t mode,
+					       struct dentry *parent,
+					       s8 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_s16(const char *name, mode_t mode,
+						struct dentry *parent,
+						s16 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_s32(const char *name, mode_t mode,
+						struct dentry *parent,
+						s32 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_s64(const char *name, mode_t mode,
+						struct dentry *parent,
+						s64 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 					       struct dentry *parent,
 					       u8 *value)
@@ -149,6 +187,13 @@ static inline struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_x64(const char *name, mode_t mode,
+						struct dentry *parent,
+						u64 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 						 struct dentry *parent,
 						 u32 *value)
-- 
1.5.3.7

