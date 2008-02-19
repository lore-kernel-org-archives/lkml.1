Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbYBSEOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbYBSEOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbYBSEMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:12:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbYBSEMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:12:15 -0500
Message-Id: <20080219040828.415218298@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:36 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 01/11] add generic versions of debugfs file operations
Content-Disposition: inline; filename=introduce-libfs-files.diff
X-Provags-ID: V01U2FsdGVkX18LCSF9jH43TT/zvdmIhoCZx8HACq3H7EOOTIw
 u4Bv3r/kIjkSMVhyTYfSM///GpEeSi3e7+zPQMlQIy/9zK0RoQ
 alFwOQQtmW3Ndrlu/y0tQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file operations in debugfs are rather generic and can
be used by other file systems, so it can be interesting to
include them in libfs, with more generic names, and exported
to modules.

This patch adds a new copy of these operations to libfs,
so that the debugfs version can later be cut down.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Index: linux-2.6/fs/Makefile
===================================================================
--- linux-2.6.orig/fs/Makefile
+++ linux-2.6/fs/Makefile
@@ -13,6 +13,8 @@ obj-y :=	open.o read_write.o file_table.
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o
 
+obj-$(CONFIG_LIBFS) += libfs/
+
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
 else
Index: linux-2.6/include/linux/libfs.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/libfs.h
@@ -0,0 +1,21 @@
+#ifndef __LIBFS_H__
+#define __LIBFS_H__
+
+#include <linux/fs.h>
+
+extern const struct file_operations simple_fops_u8;
+extern const struct file_operations simple_fops_x8;
+extern const struct file_operations simple_fops_u16;
+extern const struct file_operations simple_fops_x16;
+extern const struct file_operations simple_fops_u32;
+extern const struct file_operations simple_fops_x32;
+extern const struct file_operations simple_fops_u64;
+extern const struct file_operations simple_fops_bool;
+extern const struct file_operations simple_fops_blob;
+
+struct simple_blob_wrapper {
+	void *data;
+	unsigned long size;
+};
+
+#endif /* __LIBFS_H__ */
Index: linux-2.6/fs/libfs/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/fs/libfs/Makefile
@@ -0,0 +1,3 @@
+libfs-y += file.o
+
+obj-$(CONFIG_LIBFS) += libfs.o
Index: linux-2.6/fs/libfs/file.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/libfs/file.c
@@ -0,0 +1,126 @@
+/*
+ *	fs/libfs/file.c
+ *	Library for filesystems writers.
+ */
+
+#include <linux/fs.h>
+#include <linux/libfs.h>
+#include <linux/module.h>
+
+#include <asm/uaccess.h>
+
+/* commonly used attribute file operations */
+static int simple_u8_set(void *data, u64 val)
+{
+	*(u8 *)data = val;
+	return 0;
+}
+static int simple_u8_get(void *data, u64 *val)
+{
+	*val = *(u8 *)data;
+	return 0;
+}
+DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(simple_fops_u8, simple_u8_get, simple_u8_set, "%llu\n");
+DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(simple_fops_x8, simple_u8_get, simple_u8_set, "0x%02llx\n");
+
+static int simple_u16_set(void *data, u64 val)
+{
+	*(u16 *)data = val;
+	return 0;
+}
+static int simple_u16_get(void *data, u64 *val)
+{
+	*val = *(u16 *)data;
+	return 0;
+}
+DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(simple_fops_u16, simple_u16_get, simple_u16_set, "%llu\n");
+DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(simple_fops_x16, simple_u16_get, simple_u16_set, "0x%04llx\n");
+
+static int simple_u32_set(void *data, u64 val)
+{
+	*(u32 *)data = val;
+	return 0;
+}
+static int simple_u32_get(void *data, u64 *val)
+{
+	*val = *(u32 *)data;
+	return 0;
+}
+DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(simple_fops_u32, simple_u32_get, simple_u32_set, "%llu\n");
+DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(simple_fops_x32, simple_u32_get, simple_u32_set, "0x%08llx\n");
+
+static int simple_u64_set(void *data, u64 val)
+{
+	*(u64 *)data = val;
+	return 0;
+}
+
+static int simple_u64_get(void *data, u64 *val)
+{
+	return *(u64 *)data;
+	return 0;
+}
+DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(simple_fops_u64, simple_u64_get, simple_u64_set, "%llu\n");
+
+static ssize_t read_file_bool(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	char buf[3];
+	u32 *val = file->private_data;
+
+	if (*val)
+		buf[0] = 'Y';
+	else
+		buf[0] = 'N';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+	u32 *val = file->private_data;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		*val = 1;
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		*val = 0;
+		break;
+	}
+
+	return count;
+}
+
+const struct file_operations simple_fops_bool = {
+	.read =		read_file_bool,
+	.write =	write_file_bool,
+	.open =		simple_open,
+};
+EXPORT_SYMBOL_GPL(simple_fops_bool);
+
+static ssize_t read_file_blob(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct simple_blob_wrapper *blob = file->private_data;
+	return simple_read_from_buffer(user_buf, count, ppos, blob->data,
+			blob->size);
+}
+
+const struct file_operations simple_fops_blob = {
+	.read =		read_file_blob,
+	.open =		simple_open,
+};
+EXPORT_SYMBOL_GPL(simple_fops_blob);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -2042,19 +2042,26 @@ static inline void simple_transaction_se
  * All attributes contain a text representation of a numeric value
  * that are accessed with the get() and set() functions.
  */
-#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+#define __DEFINE_SIMPLE_ATTRIBUTE(__static, __fops, __get, __set, __fmt)\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
 	__simple_attr_check_format(__fmt, 0ull);			\
 	return simple_attr_open(inode, file, __get, __set, __fmt);	\
 }									\
-static struct file_operations __fops = {				\
+__static const struct file_operations __fops = {			\
 	.owner	 = THIS_MODULE,						\
 	.open	 = __fops ## _open,					\
 	.release = simple_attr_release,					\
 	.read	 = simple_attr_read,					\
 	.write	 = simple_attr_write,					\
-};
+}
+
+#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+	__DEFINE_SIMPLE_ATTRIBUTE(static, __fops, __get, __set, __fmt)
+
+#define DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(__fops, __get, __set, __fmt)	\
+	__DEFINE_SIMPLE_ATTRIBUTE(/**/, __fops, __get, __set, __fmt);	\
+	EXPORT_SYMBOL_GPL(__fops)
 
 static inline void __attribute__((format(printf, 1, 2)))
 __simple_attr_check_format(const char *fmt, ...)

-- 

