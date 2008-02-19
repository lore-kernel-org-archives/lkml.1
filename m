Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbYBSEPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbYBSEPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbYBSEMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:12:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:54363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750AbYBSEMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:12:33 -0500
Message-Id: <20080219040829.349349507@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:42 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 07/11] split out libfs/file.c from libfs.c
Content-Disposition: inline; filename=libfs-file.diff
X-Provags-ID: V01U2FsdGVkX18uV1haR7GsSI5zHyO8yrh4mtynuqCxuUCRoXJ
 zmoc4FdND2D/ZEnSRsDN2FSFJLeiWwHnQGSp4kEkortKPJMlm1
 2+DGRnqpFzIB9fFTTOzkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all file manipulation code in libfs in a single
source file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -421,165 +421,6 @@ ssize_t simple_read_from_buffer(void __u
 }
 
 /*
- * Transaction based IO.
- * The file expects a single write which triggers the transaction, and then
- * possibly a read which collects the result - which is stored in a
- * file-local buffer.
- */
-char *simple_transaction_get(struct file *file, const char __user *buf, size_t size)
-{
-	struct simple_transaction_argresp *ar;
-	static DEFINE_SPINLOCK(simple_transaction_lock);
-
-	if (size > SIMPLE_TRANSACTION_LIMIT - 1)
-		return ERR_PTR(-EFBIG);
-
-	ar = (struct simple_transaction_argresp *)get_zeroed_page(GFP_KERNEL);
-	if (!ar)
-		return ERR_PTR(-ENOMEM);
-
-	spin_lock(&simple_transaction_lock);
-
-	/* only one write allowed per open */
-	if (file->private_data) {
-		spin_unlock(&simple_transaction_lock);
-		free_page((unsigned long)ar);
-		return ERR_PTR(-EBUSY);
-	}
-
-	file->private_data = ar;
-
-	spin_unlock(&simple_transaction_lock);
-
-	if (copy_from_user(ar->data, buf, size))
-		return ERR_PTR(-EFAULT);
-
-	return ar->data;
-}
-
-ssize_t simple_transaction_read(struct file *file, char __user *buf, size_t size, loff_t *pos)
-{
-	struct simple_transaction_argresp *ar = file->private_data;
-
-	if (!ar)
-		return 0;
-	return simple_read_from_buffer(buf, size, pos, ar->data, ar->size);
-}
-
-int simple_transaction_release(struct inode *inode, struct file *file)
-{
-	free_page((unsigned long)file->private_data);
-	return 0;
-}
-
-/* Simple attribute files */
-
-struct simple_attr {
-	int (*get)(void *, u64 *);
-	int (*set)(void *, u64);
-	char get_buf[24];	/* enough to store a u64 and "\n\0" */
-	char set_buf[24];
-	void *data;
-	const char *fmt;	/* format for read operation */
-	struct mutex mutex;	/* protects access to these buffers */
-};
-
-/* simple_attr_open is called by an actual attribute open file operation
- * to set the attribute specific access operations. */
-int simple_attr_open(struct inode *inode, struct file *file,
-		     int (*get)(void *, u64 *), int (*set)(void *, u64),
-		     const char *fmt)
-{
-	struct simple_attr *attr;
-
-	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr)
-		return -ENOMEM;
-
-	attr->get = get;
-	attr->set = set;
-	attr->data = inode->i_private;
-	attr->fmt = fmt;
-	mutex_init(&attr->mutex);
-
-	file->private_data = attr;
-
-	return nonseekable_open(inode, file);
-}
-
-int simple_attr_release(struct inode *inode, struct file *file)
-{
-	kfree(file->private_data);
-	return 0;
-}
-
-/* read from the buffer that is filled with the get function */
-ssize_t simple_attr_read(struct file *file, char __user *buf,
-			 size_t len, loff_t *ppos)
-{
-	struct simple_attr *attr;
-	size_t size;
-	ssize_t ret;
-
-	attr = file->private_data;
-
-	if (!attr->get)
-		return -EACCES;
-
-	ret = mutex_lock_interruptible(&attr->mutex);
-	if (ret)
-		return ret;
-
-	if (*ppos) {		/* continued read */
-		size = strlen(attr->get_buf);
-	} else {		/* first read */
-		u64 val;
-		ret = attr->get(attr->data, &val);
-		if (ret)
-			goto out;
-
-		size = scnprintf(attr->get_buf, sizeof(attr->get_buf),
-				 attr->fmt, (unsigned long long)val);
-	}
-
-	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
-out:
-	mutex_unlock(&attr->mutex);
-	return ret;
-}
-
-/* interpret the buffer as a number to call the set function with */
-ssize_t simple_attr_write(struct file *file, const char __user *buf,
-			  size_t len, loff_t *ppos)
-{
-	struct simple_attr *attr;
-	u64 val;
-	size_t size;
-	ssize_t ret;
-
-	attr = file->private_data;
-	if (!attr->set)
-		return -EACCES;
-
-	ret = mutex_lock_interruptible(&attr->mutex);
-	if (ret)
-		return ret;
-
-	ret = -EFAULT;
-	size = min(sizeof(attr->set_buf) - 1, len);
-	if (copy_from_user(attr->set_buf, buf, size))
-		goto out;
-
-	ret = len; /* claim we got the whole input */
-	attr->set_buf[size] = '\0';
-	val = simple_strtol(attr->set_buf, NULL, 0);
-	attr->set(attr->data, val);
-out:
-	mutex_unlock(&attr->mutex);
-	return ret;
-}
-
-/*
  * This is what d_alloc_anon should have been.  Once the exportfs
  * argument transition has been finished I will update d_alloc_anon
  * to this prototype and this wrapper will go away.   --hch
@@ -689,10 +530,3 @@ EXPORT_SYMBOL(simple_statfs);
 EXPORT_SYMBOL(simple_sync_file);
 EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
-EXPORT_SYMBOL(simple_transaction_get);
-EXPORT_SYMBOL(simple_transaction_read);
-EXPORT_SYMBOL(simple_transaction_release);
-EXPORT_SYMBOL_GPL(simple_attr_open);
-EXPORT_SYMBOL_GPL(simple_attr_release);
-EXPORT_SYMBOL_GPL(simple_attr_read);
-EXPORT_SYMBOL_GPL(simple_attr_write);
Index: linux-2.6/fs/libfs/file.c
===================================================================
--- linux-2.6.orig/fs/libfs/file.c
+++ linux-2.6/fs/libfs/file.c
@@ -9,6 +9,172 @@
 
 #include <asm/uaccess.h>
 
+/*
+ * Transaction based IO.
+ * The file expects a single write which triggers the transaction, and then
+ * possibly a read which collects the result - which is stored in a
+ * file-local buffer.
+ */
+char *simple_transaction_get(struct file *file, const char __user *buf, size_t size)
+{
+	struct simple_transaction_argresp *ar;
+	static DEFINE_SPINLOCK(simple_transaction_lock);
+
+	if (size > SIMPLE_TRANSACTION_LIMIT - 1)
+		return ERR_PTR(-EFBIG);
+
+	ar = (struct simple_transaction_argresp *)get_zeroed_page(GFP_KERNEL);
+	if (!ar)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&simple_transaction_lock);
+
+	/* only one write allowed per open */
+	if (file->private_data) {
+		spin_unlock(&simple_transaction_lock);
+		free_page((unsigned long)ar);
+		return ERR_PTR(-EBUSY);
+	}
+
+	file->private_data = ar;
+
+	spin_unlock(&simple_transaction_lock);
+
+	if (copy_from_user(ar->data, buf, size))
+		return ERR_PTR(-EFAULT);
+
+	return ar->data;
+}
+EXPORT_SYMBOL(simple_transaction_get);
+
+ssize_t simple_transaction_read(struct file *file, char __user *buf, size_t size, loff_t *pos)
+{
+	struct simple_transaction_argresp *ar = file->private_data;
+
+	if (!ar)
+		return 0;
+	return simple_read_from_buffer(buf, size, pos, ar->data, ar->size);
+}
+EXPORT_SYMBOL(simple_transaction_read);
+
+int simple_transaction_release(struct inode *inode, struct file *file)
+{
+	free_page((unsigned long)file->private_data);
+	return 0;
+}
+EXPORT_SYMBOL(simple_transaction_release);
+
+/* Simple attribute files */
+
+struct simple_attr {
+	int (*get)(void *, u64 *);
+	int (*set)(void *, u64);
+	char get_buf[24];	/* enough to store a u64 and "\n\0" */
+	char set_buf[24];
+	void *data;
+	const char *fmt;	/* format for read operation */
+	struct mutex mutex;	/* protects access to these buffers */
+};
+
+/* simple_attr_open is called by an actual attribute open file operation
+ * to set the attribute specific access operations. */
+int simple_attr_open(struct inode *inode, struct file *file,
+		     int (*get)(void *, u64 *), int (*set)(void *, u64),
+		     const char *fmt)
+{
+	struct simple_attr *attr;
+
+	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	attr->get = get;
+	attr->set = set;
+	attr->data = inode->i_private;
+	attr->fmt = fmt;
+	mutex_init(&attr->mutex);
+
+	file->private_data = attr;
+
+	return nonseekable_open(inode, file);
+}
+EXPORT_SYMBOL_GPL(simple_attr_open);
+
+int simple_attr_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(simple_attr_release);
+
+/* read from the buffer that is filled with the get function */
+ssize_t simple_attr_read(struct file *file, char __user *buf,
+			 size_t len, loff_t *ppos)
+{
+	struct simple_attr *attr;
+	size_t size;
+	ssize_t ret;
+
+	attr = file->private_data;
+
+	if (!attr->get)
+		return -EACCES;
+
+	ret = mutex_lock_interruptible(&attr->mutex);
+	if (ret)
+		return ret;
+
+	if (*ppos) {		/* continued read */
+		size = strlen(attr->get_buf);
+	} else {		/* first read */
+		u64 val;
+		ret = attr->get(attr->data, &val);
+		if (ret)
+			goto out;
+
+		size = scnprintf(attr->get_buf, sizeof(attr->get_buf),
+				 attr->fmt, (unsigned long long)val);
+	}
+
+	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
+out:
+	mutex_unlock(&attr->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(simple_attr_read);
+
+/* interpret the buffer as a number to call the set function with */
+ssize_t simple_attr_write(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos)
+{
+	struct simple_attr *attr;
+	u64 val;
+	size_t size;
+	ssize_t ret;
+
+	attr = file->private_data;
+	if (!attr->set)
+		return -EACCES;
+
+	ret = mutex_lock_interruptible(&attr->mutex);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
+	size = min(sizeof(attr->set_buf) - 1, len);
+	if (copy_from_user(attr->set_buf, buf, size))
+		goto out;
+
+	ret = len; /* claim we got the whole input */
+	attr->set_buf[size] = '\0';
+	val = simple_strtol(attr->set_buf, NULL, 0);
+	attr->set(attr->data, val);
+out:
+	mutex_unlock(&attr->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(simple_attr_write);
+
 /* commonly used attribute file operations */
 static int simple_u8_set(void *data, u64 val)
 {

-- 

