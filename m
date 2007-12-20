Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbXLTMW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbXLTMW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbXLTMWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:22:17 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:43827 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753996AbXLTMWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:22:14 -0500
Date: Thu, 20 Dec 2007 13:15:48 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>,
       Arnd Bergmann <arndb@de.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/8] debugfs: allow access to signed values
Message-ID: <20071220131548.1d09cd62@morte>
In-Reply-To: <1198080034.4747.15.camel@johannes.berg>
References: <20071219001955.055692620@polimi.it>
	<20071219012739.6dcdd150@morte>
	<1198080034.4747.15.camel@johannes.berg>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.4.1.325704, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2007.12.20.40340
X-PerlMx-Spam: No virus found, Gauge=IIIIII, Probability=26%, Report='RELAY_IN_PBL_11 2.5, SXL_IP_DYNAMIC 0.5, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __STOCK_PHRASE_24 0, __STOCK_PHRASE_7 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs: allow access to signed values

Add debugfs_create_s{8,16,32,64}. For these to work properly, we need to remove
a cast in libfs, change the simple_attr_open prototype and thus fix the users as
well.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Mattias Nissler <mattias.nissler@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
To: Arnd Bergmann <arndb@de.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---

This version addresses last Johannes' concerns.

---
 arch/powerpc/platforms/cell/spufs/file.c |   48 ++++----
 fs/debugfs/file.c                        |  186 +++++++++++++++++++++++++++++--
 fs/libfs.c                               |   23 ++-
 include/linux/debugfs.h                  |   38 ++++++
 include/linux/fs.h                       |   25 ++--
 lib/fault-inject.c                       |   11 +
 6 files changed, 268 insertions(+), 63 deletions(-)

Index: wireless-2.6/fs/debugfs/file.c
===================================================================
--- wireless-2.6.orig/fs/debugfs/file.c
+++ wireless-2.6/fs/debugfs/file.c
@@ -56,11 +56,11 @@ const struct inode_operations debugfs_li
 	.follow_link    = debugfs_follow_link,
 };
 
-static void debugfs_u8_set(void *data, u64 val)
+static void debugfs_u8_set(void *data, unsigned long long val)
 {
 	*(u8 *)data = val;
 }
-static u64 debugfs_u8_get(void *data)
+static unsigned long long debugfs_u8_get(void *data)
 {
 	return *(u8 *)data;
 }
@@ -97,11 +97,11 @@ struct dentry *debugfs_create_u8(const c
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u8);
 
-static void debugfs_u16_set(void *data, u64 val)
+static void debugfs_u16_set(void *data, unsigned long long val)
 {
 	*(u16 *)data = val;
 }
-static u64 debugfs_u16_get(void *data)
+static unsigned long long debugfs_u16_get(void *data)
 {
 	return *(u16 *)data;
 }
@@ -138,11 +138,11 @@ struct dentry *debugfs_create_u16(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u16);
 
-static void debugfs_u32_set(void *data, u64 val)
+static void debugfs_u32_set(void *data, unsigned long long val)
 {
 	*(u32 *)data = val;
 }
-static u64 debugfs_u32_get(void *data)
+static unsigned long long debugfs_u32_get(void *data)
 {
 	return *(u32 *)data;
 }
@@ -179,12 +179,12 @@ struct dentry *debugfs_create_u32(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
-static void debugfs_u64_set(void *data, u64 val)
+static void debugfs_u64_set(void *data, unsigned long long val)
 {
 	*(u64 *)data = val;
 }
 
-static u64 debugfs_u64_get(void *data)
+static unsigned long long debugfs_u64_get(void *data)
 {
 	return *(u64 *)data;
 }
@@ -221,6 +221,172 @@ struct dentry *debugfs_create_u64(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u64);
 
+
+static void debugfs_s8_set(void *data, unsigned long long val)
+{
+	*(s8 *)data = val;
+}
+static unsigned long long debugfs_s8_get(void *data)
+{
+	return *(s8 *)data;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_s8, debugfs_s8_get, debugfs_s8_set, "%lld\n");
+
+/**
+ * debugfs_create_s8 - create a debugfs file that is used to read and write a signed 8-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ *
+ * This function creates a file in debugfs with the given name that
+ * contains the value of the variable @value.  If the @mode variable is so
+ * set, it can be read from, and written to.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_create_s8(const char *name, mode_t mode,
+				 struct dentry *parent, s8 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s8);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s8);
+
+static void debugfs_s16_set(void *data, unsigned long long val)
+{
+	*(s16 *)data = val;
+}
+static unsigned long long debugfs_s16_get(void *data)
+{
+	return *(s16 *)data;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_s16, debugfs_s16_get, debugfs_s16_set, "%lld\n");
+
+/**
+ * debugfs_create_s16 - create a debugfs file that is used to read and write a signed 16-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ *
+ * This function creates a file in debugfs with the given name that
+ * contains the value of the variable @value.  If the @mode variable is so
+ * set, it can be read from, and written to.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_create_s16(const char *name, mode_t mode,
+				  struct dentry *parent, s16 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s16);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s16);
+
+static void debugfs_s32_set(void *data, unsigned long long val)
+{
+	*(s32 *)data = val;
+}
+static unsigned long long debugfs_s32_get(void *data)
+{
+	return *(s32 *)data;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_s32, debugfs_s32_get, debugfs_s32_set, "%lld\n");
+
+/**
+ * debugfs_create_s32 - create a debugfs file that is used to read and write a signed 32-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ *
+ * This function creates a file in debugfs with the given name that
+ * contains the value of the variable @value.  If the @mode variable is so
+ * set, it can be read from, and written to.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_create_s32(const char *name, mode_t mode,
+				 struct dentry *parent, s32 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s32);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s32);
+
+static void debugfs_s64_set(void *data, unsigned long long val)
+{
+	*(s64 *)data = val;
+}
+
+static unsigned long long debugfs_s64_get(void *data)
+{
+	return *(s64 *)data;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_s64, debugfs_s64_get, debugfs_s64_set, "%lld\n");
+
+/**
+ * debugfs_create_s64 - create a debugfs file that is used to read and write a signed 64-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ *
+ * This function creates a file in debugfs with the given name that
+ * contains the value of the variable @value.  If the @mode variable is so
+ * set, it can be read from, and written to.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_create_s64(const char *name, mode_t mode,
+				 struct dentry *parent, s64 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s64);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s64);
+
 DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
@@ -291,7 +457,7 @@ static ssize_t read_file_bool(struct fil
 {
 	char buf[3];
 	u32 *val = file->private_data;
-	
+
 	if (*val)
 		buf[0] = 'Y';
 	else
@@ -324,7 +490,7 @@ static ssize_t write_file_bool(struct fi
 		*val = 0;
 		break;
 	}
-	
+
 	return count;
 }
 
Index: wireless-2.6/fs/libfs.c
===================================================================
--- wireless-2.6.orig/fs/libfs.c
+++ wireless-2.6/fs/libfs.c
@@ -59,7 +59,7 @@ int simple_sync_file(struct file * file,
 {
 	return 0;
 }
- 
+
 int dcache_dir_open(struct inode *inode, struct file *file)
 {
 	static struct qstr cursor_name = {.len = 1, .name = "."};
@@ -160,9 +160,9 @@ int dcache_readdir(struct file * filp, v
 					continue;
 
 				spin_unlock(&dcache_lock);
-				if (filldir(dirent, next->d_name.name, 
-					    next->d_name.len, filp->f_pos, 
-					    next->d_inode->i_ino, 
+				if (filldir(dirent, next->d_name.name,
+					    next->d_name.len, filp->f_pos,
+					    next->d_inode->i_ino,
 					    dt_type(next->d_inode)) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
@@ -586,10 +586,10 @@ int simple_transaction_release(struct in
 /* Simple attribute files */
 
 struct simple_attr {
-	u64 (*get)(void *);
-	void (*set)(void *, u64);
-	char get_buf[24];	/* enough to store a u64 and "\n\0" */
-	char set_buf[24];
+	unsigned long long (*get)(void *);
+	void (*set)(void *, unsigned long long);
+	char get_buf[sizeof(unsigned long long) + 2];	/* ULL + "\n\0" */
+	char set_buf[sizeof(unsigned long long) + 2];
 	void *data;
 	const char *fmt;	/* format for read operation */
 	struct mutex mutex;	/* protects access to these buffers */
@@ -598,7 +598,8 @@ struct simple_attr {
 /* simple_attr_open is called by an actual attribute open file operation
  * to set the attribute specific access operations. */
 int simple_attr_open(struct inode *inode, struct file *file,
-		     u64 (*get)(void *), void (*set)(void *, u64),
+		     unsigned long long (*get)(void *),
+		     void (*set)(void *, unsigned long long),
 		     const char *fmt)
 {
 	struct simple_attr *attr;
@@ -643,7 +644,7 @@ ssize_t simple_attr_read(struct file *fi
 	else	  /* first read */
 		size = scnprintf(attr->get_buf, sizeof(attr->get_buf),
 				 attr->fmt,
-				 (unsigned long long)attr->get(attr->data));
+				 attr->get(attr->data));
 
 	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
 	mutex_unlock(&attr->mutex);
@@ -655,7 +656,7 @@ ssize_t simple_attr_write(struct file *f
 			  size_t len, loff_t *ppos)
 {
 	struct simple_attr *attr;
-	u64 val;
+	unsigned long long val;
 	size_t size;
 	ssize_t ret;
 
Index: wireless-2.6/include/linux/debugfs.h
===================================================================
--- wireless-2.6.orig/include/linux/debugfs.h
+++ wireless-2.6/include/linux/debugfs.h
@@ -49,6 +49,14 @@ struct dentry *debugfs_create_u32(const 
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
@@ -65,7 +73,7 @@ struct dentry *debugfs_create_blob(const
 
 #include <linux/err.h>
 
-/* 
+/*
  * We do not return NULL from these functions if CONFIG_DEBUG_FS is not enabled
  * so users have a chance to detect if there was a real error or not.  We don't
  * want to duplicate the design decision mistakes of procfs and devfs again.
@@ -128,6 +136,34 @@ static inline struct dentry *debugfs_cre
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_s8(const char *name, mode_t mode,
+					       struct dentry *parent,
+					       u8 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_s16(const char *name, mode_t mode,
+					       struct dentry *parent,
+					       s16 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_s32(const char *name, mode_t mode,
+					       struct dentry *parent,
+					       s32 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_s64(const char *name, mode_t mode,
+					       struct dentry *parent,
+					       s64 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 					       struct dentry *parent,
 					       u8 *value)
Index: wireless-2.6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- wireless-2.6.orig/arch/powerpc/platforms/cell/spufs/file.c
+++ wireless-2.6/arch/powerpc/platforms/cell/spufs/file.c
@@ -286,10 +286,10 @@ static int spufs_cntl_mmap(struct file *
 #define spufs_cntl_mmap NULL
 #endif /* !SPUFS_MMAP_4K */
 
-static u64 spufs_cntl_get(void *data)
+static unsigned long long spufs_cntl_get(void *data)
 {
 	struct spu_context *ctx = data;
-	u64 val;
+	unsigned long long val;
 
 	spu_acquire(ctx);
 	val = ctx->ops->status_read(ctx);
@@ -298,7 +298,7 @@ static u64 spufs_cntl_get(void *data)
 	return val;
 }
 
-static void spufs_cntl_set(void *data, u64 val)
+static void spufs_cntl_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 
@@ -1086,10 +1086,10 @@ static const struct file_operations spuf
 #define SPU_ATTR_ACQUIRE_SAVED	2
 
 #define DEFINE_SPUFS_ATTRIBUTE(__name, __get, __set, __fmt, __acquire)	\
-static u64 __##__get(void *data)					\
+static unsigned long long __##__get(void *data)				\
 {									\
 	struct spu_context *ctx = data;					\
-	u64 ret;							\
+	unsigned long long ret;						\
 									\
 	if (__acquire == SPU_ATTR_ACQUIRE) {				\
 		spu_acquire(ctx);					\
@@ -1106,7 +1106,7 @@ static u64 __##__get(void *data)					\
 }									\
 DEFINE_SIMPLE_ATTRIBUTE(__name, __##__get, __set, __fmt);
 
-static void spufs_signal1_type_set(void *data, u64 val)
+static void spufs_signal1_type_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 
@@ -1115,7 +1115,7 @@ static void spufs_signal1_type_set(void 
 	spu_release(ctx);
 }
 
-static u64 spufs_signal1_type_get(struct spu_context *ctx)
+static unsigned long long spufs_signal1_type_get(struct spu_context *ctx)
 {
 	return ctx->ops->signal1_type_get(ctx);
 }
@@ -1123,7 +1123,7 @@ DEFINE_SPUFS_ATTRIBUTE(spufs_signal1_typ
 		       spufs_signal1_type_set, "%llu", SPU_ATTR_ACQUIRE);
 
 
-static void spufs_signal2_type_set(void *data, u64 val)
+static void spufs_signal2_type_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 
@@ -1132,7 +1132,7 @@ static void spufs_signal2_type_set(void 
 	spu_release(ctx);
 }
 
-static u64 spufs_signal2_type_get(struct spu_context *ctx)
+static unsigned long long spufs_signal2_type_get(struct spu_context *ctx)
 {
 	return ctx->ops->signal2_type_get(ctx);
 }
@@ -1605,7 +1605,7 @@ static const struct file_operations spuf
 	.mmap	 = spufs_mfc_mmap,
 };
 
-static void spufs_npc_set(void *data, u64 val)
+static void spufs_npc_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 	spu_acquire(ctx);
@@ -1613,14 +1613,14 @@ static void spufs_npc_set(void *data, u6
 	spu_release(ctx);
 }
 
-static u64 spufs_npc_get(struct spu_context *ctx)
+static unsigned long long spufs_npc_get(struct spu_context *ctx)
 {
 	return ctx->ops->npc_read(ctx);
 }
 DEFINE_SPUFS_ATTRIBUTE(spufs_npc_ops, spufs_npc_get, spufs_npc_set,
 		       "0x%llx\n", SPU_ATTR_ACQUIRE);
 
-static void spufs_decr_set(void *data, u64 val)
+static void spufs_decr_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
@@ -1629,7 +1629,7 @@ static void spufs_decr_set(void *data, u
 	spu_release_saved(ctx);
 }
 
-static u64 spufs_decr_get(struct spu_context *ctx)
+static unsigned long long spufs_decr_get(struct spu_context *ctx)
 {
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	return lscsa->decr.slot[0];
@@ -1637,7 +1637,7 @@ static u64 spufs_decr_get(struct spu_con
 DEFINE_SPUFS_ATTRIBUTE(spufs_decr_ops, spufs_decr_get, spufs_decr_set,
 		       "0x%llx\n", SPU_ATTR_ACQUIRE_SAVED);
 
-static void spufs_decr_status_set(void *data, u64 val)
+static void spufs_decr_status_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 	spu_acquire_saved(ctx);
@@ -1648,7 +1648,7 @@ static void spufs_decr_status_set(void *
 	spu_release_saved(ctx);
 }
 
-static u64 spufs_decr_status_get(struct spu_context *ctx)
+static unsigned long long spufs_decr_status_get(struct spu_context *ctx)
 {
 	if (ctx->csa.priv2.mfc_control_RW & MFC_CNTL_DECREMENTER_RUNNING)
 		return SPU_DECR_STATUS_RUNNING;
@@ -1659,7 +1659,7 @@ DEFINE_SPUFS_ATTRIBUTE(spufs_decr_status
 		       spufs_decr_status_set, "0x%llx\n",
 		       SPU_ATTR_ACQUIRE_SAVED);
 
-static void spufs_event_mask_set(void *data, u64 val)
+static void spufs_event_mask_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
@@ -1668,7 +1668,7 @@ static void spufs_event_mask_set(void *d
 	spu_release_saved(ctx);
 }
 
-static u64 spufs_event_mask_get(struct spu_context *ctx)
+static unsigned long long spufs_event_mask_get(struct spu_context *ctx)
 {
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	return lscsa->event_mask.slot[0];
@@ -1678,7 +1678,7 @@ DEFINE_SPUFS_ATTRIBUTE(spufs_event_mask_
 		       spufs_event_mask_set, "0x%llx\n",
 		       SPU_ATTR_ACQUIRE_SAVED);
 
-static u64 spufs_event_status_get(struct spu_context *ctx)
+static unsigned long long spufs_event_status_get(struct spu_context *ctx)
 {
 	struct spu_state *state = &ctx->csa;
 	u64 stat;
@@ -1690,7 +1690,7 @@ static u64 spufs_event_status_get(struct
 DEFINE_SPUFS_ATTRIBUTE(spufs_event_status_ops, spufs_event_status_get,
 		       NULL, "0x%llx\n", SPU_ATTR_ACQUIRE_SAVED)
 
-static void spufs_srr0_set(void *data, u64 val)
+static void spufs_srr0_set(void *data, unsigned long long val)
 {
 	struct spu_context *ctx = data;
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
@@ -1699,7 +1699,7 @@ static void spufs_srr0_set(void *data, u
 	spu_release_saved(ctx);
 }
 
-static u64 spufs_srr0_get(struct spu_context *ctx)
+static unsigned long long spufs_srr0_get(struct spu_context *ctx)
 {
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	return lscsa->srr0.slot[0];
@@ -1707,7 +1707,7 @@ static u64 spufs_srr0_get(struct spu_con
 DEFINE_SPUFS_ATTRIBUTE(spufs_srr0_ops, spufs_srr0_get, spufs_srr0_set,
 		       "0x%llx\n", SPU_ATTR_ACQUIRE_SAVED)
 
-static u64 spufs_id_get(struct spu_context *ctx)
+static unsigned long long spufs_id_get(struct spu_context *ctx)
 {
 	u64 num;
 
@@ -1721,13 +1721,13 @@ static u64 spufs_id_get(struct spu_conte
 DEFINE_SPUFS_ATTRIBUTE(spufs_id_ops, spufs_id_get, NULL, "0x%llx\n",
 		       SPU_ATTR_ACQUIRE)
 
-static u64 spufs_object_id_get(struct spu_context *ctx)
+static unsigned long long spufs_object_id_get(struct spu_context *ctx)
 {
 	/* FIXME: Should there really be no locking here? */
 	return ctx->object_id;
 }
 
-static void spufs_object_id_set(void *data, u64 id)
+static void spufs_object_id_set(void *data, unsigned long long id)
 {
 	struct spu_context *ctx = data;
 	ctx->object_id = id;
@@ -1736,7 +1736,7 @@ static void spufs_object_id_set(void *da
 DEFINE_SPUFS_ATTRIBUTE(spufs_object_id_ops, spufs_object_id_get,
 		       spufs_object_id_set, "0x%llx\n", SPU_ATTR_NOACQUIRE);
 
-static u64 spufs_lslr_get(struct spu_context *ctx)
+static unsigned long long spufs_lslr_get(struct spu_context *ctx)
 {
 	return ctx->csa.priv2.spu_lslr_RW;
 }
Index: wireless-2.6/include/linux/fs.h
===================================================================
--- wireless-2.6.orig/include/linux/fs.h
+++ wireless-2.6/include/linux/fs.h
@@ -15,8 +15,8 @@
  * nr_file rlimit, so it's safe to set up a ridiculously high absolute
  * upper limit on files-per-process.
  *
- * Some programs (notably those using select()) may have to be 
- * recompiled to take full advantage of the new limits..  
+ * Some programs (notably those using select()) may have to be
+ * recompiled to take full advantage of the new limits..
  */
 
 /* Fixed constants first: */
@@ -90,7 +90,7 @@ extern int dir_notify_enable;
 #define SEL_EX		4
 
 /* public flags for file_system_type */
-#define FS_REQUIRES_DEV 1 
+#define FS_REQUIRES_DEV 1
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
@@ -365,7 +365,7 @@ struct iattr {
  */
 #include <linux/quota.h>
 
-/** 
+/**
  * enum positive_aop_returns - aop return codes with specific semantics
  *
  * @AOP_WRITEPAGE_ACTIVATE: Informs the caller that page writeback has
@@ -375,7 +375,7 @@ struct iattr {
  * 			    be a candidate for writeback again in the near
  * 			    future.  Other callers must be careful to unlock
  * 			    the page if they get this return.  Returned by
- * 			    writepage(); 
+ * 			    writepage();
  *
  * @AOP_TRUNCATED_PAGE: The AOP method that was handed a locked page has
  *  			unlocked it and the page might have been truncated.
@@ -818,10 +818,10 @@ extern spinlock_t files_lock;
 
 #define	MAX_NON_LFS	((1UL<<31) - 1)
 
-/* Page cache limit. The filesystems should put that into their s_maxbytes 
-   limits, otherwise bad things can happen in VM. */ 
+/* Page cache limit. The filesystems should put that into their s_maxbytes
+   limits, otherwise bad things can happen in VM. */
 #if BITS_PER_LONG==32
-#define MAX_LFS_FILESIZE	(((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 
+#define MAX_LFS_FILESIZE	(((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
 #elif BITS_PER_LONG==64
 #define MAX_LFS_FILESIZE 	0x7fffffffffffffffUL
 #endif
@@ -1240,7 +1240,7 @@ struct super_operations {
 	void (*destroy_inode)(struct inode *);
 
 	void (*read_inode) (struct inode *);
-  
+
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -1719,7 +1719,7 @@ extern int may_open(struct nameidata *, 
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
 extern struct file * open_exec(const char *);
- 
+
 /* fs/dcache.c -- generic fs support functions */
 extern int is_subdir(struct dentry *, struct dentry *);
 extern ino_t find_inode_number(struct dentry *, struct qstr *);
@@ -1753,7 +1753,7 @@ extern void unlock_new_inode(struct inod
 static inline struct inode *iget(struct super_block *sb, unsigned long ino)
 {
 	struct inode *inode = iget_locked(sb, ino);
-	
+
 	if (inode && (inode->i_state & I_NEW)) {
 		sb->s_op->read_inode(inode);
 		unlock_new_inode(inode);
@@ -2062,7 +2062,8 @@ __simple_attr_check_format(const char *f
 }
 
 int simple_attr_open(struct inode *inode, struct file *file,
-		     u64 (*get)(void *), void (*set)(void *, u64),
+		     unsigned long long (*get)(void *),
+		     void (*set)(void *, unsigned long long),
 		     const char *fmt);
 int simple_attr_close(struct inode *inode, struct file *file);
 ssize_t simple_attr_read(struct file *file, char __user *buf,
Index: wireless-2.6/lib/fault-inject.c
===================================================================
--- wireless-2.6.orig/lib/fault-inject.c
+++ wireless-2.6/lib/fault-inject.c
@@ -134,13 +134,14 @@ bool should_fail(struct fault_attr *attr
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
-static void debugfs_ul_set(void *data, u64 val)
+static void debugfs_ul_set(void *data, unsigned long long val)
 {
 	*(unsigned long *)data = val;
 }
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-static void debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
+static void debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data,
+						 unsigned long long val)
 {
 	*(unsigned long *)data =
 		val < MAX_STACK_TRACE_DEPTH ?
@@ -148,7 +149,7 @@ static void debugfs_ul_set_MAX_STACK_TRA
 }
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-static u64 debugfs_ul_get(void *data)
+static unsigned long long debugfs_ul_get(void *data)
 {
 	return *(unsigned long *)data;
 }
@@ -174,12 +175,12 @@ static struct dentry *debugfs_create_ul_
 }
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-static void debugfs_atomic_t_set(void *data, u64 val)
+static void debugfs_atomic_t_set(void *data, unsigned long long val)
 {
 	atomic_set((atomic_t *)data, val);
 }
 
-static u64 debugfs_atomic_t_get(void *data)
+static unsigned long long debugfs_atomic_t_get(void *data)
 {
 	return atomic_read((atomic_t *)data);
 }



-- 
Ciao
Stefano
