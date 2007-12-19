Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbXLSAdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbXLSAdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbXLSAcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:32:51 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:48988 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758740AbXLSAct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:32:49 -0500
Date: Wed, 19 Dec 2007 01:27:39 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH v3 7/8] debugfs: allow access to signed values
Message-ID: <20071219012739.6dcdd150@morte>
In-Reply-To: <20071219001955.055692620@polimi.it>
References: <20071219001955.055692620@polimi.it>>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __STOCK_PHRASE_24 0, __STOCK_PHRASE_7 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debugfs_create_s{8,16,32,64}. For these to work properly, we need to remove
a cast in libfs.

Cc: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Greg,

here comes an implementation of debugfs_create_s{8,16,32,64} which avoids code
duplication, suggested by Johannes Berg. We would need this to be merged to
2.6.25, as we need those functions to be available for rc80211-pid, the new
mac80211 rate control algorithm.

---
 fs/debugfs/file.c       |  166 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/libfs.c              |    4 -
 include/linux/debugfs.h |   30 ++++++++
 3 files changed, 197 insertions(+), 3 deletions(-)

Index: wireless-2.6/fs/debugfs/file.c
===================================================================
--- wireless-2.6.orig/fs/debugfs/file.c
+++ wireless-2.6/fs/debugfs/file.c
@@ -221,6 +221,172 @@ struct dentry *debugfs_create_u64(const
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u64);

+
+static void debugfs_s8_set(void *data, u64 val)
+{
+	*(s8 *)data = val;
+}
+static u64 debugfs_s8_get(void *data)
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
+static void debugfs_s16_set(void *data, u64 val)
+{
+	*(s16 *)data = val;
+}
+static u64 debugfs_s16_get(void *data)
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
+static void debugfs_s32_set(void *data, u64 val)
+{
+	*(s32 *)data = val;
+}
+static u64 debugfs_s32_get(void *data)
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
+static void debugfs_s64_set(void *data, u64 val)
+{
+	*(s64 *)data = val;
+}
+
+static u64 debugfs_s64_get(void *data)
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
+				 struct dentry *parent, u64 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_s64);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_s64);
+
 DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");

 DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");

Index: wireless-2.6/fs/libfs.c
===================================================================
--- wireless-2.6.orig/fs/libfs.c
+++ wireless-2.6/fs/libfs.c
@@ -586,7 +586,7 @@ int simple_transaction_release(struct in
 /* Simple attribute files */

 struct simple_attr {
-	u64 (*get)(void *);
+	unsigned long long (*get)(void *);
 	void (*set)(void *, u64);
 	char get_buf[24];	/* enough to store a u64 and "\n\0" */
 	char set_buf[24];
@@ -643,7 +643,7 @@ ssize_t simple_attr_read(struct file *fi
 	else	  /* first read */
 		size = scnprintf(attr->get_buf, sizeof(attr->get_buf),
 				 attr->fmt,
-				 (unsigned long long)attr->get(attr->data));
+				 attr->get(attr->data));

 	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
 	mutex_unlock(&attr->mutex);
Index: wireless-2.6/include/linux/debugfs.h
===================================================================
--- wireless-2.6.orig/include/linux/debugfs.h
+++ wireless-2.6/include/linux/debugfs.h
@@ -65,7 +65,7 @@ struct dentry *debugfs_create_blob(const

 #include <linux/err.h>

-/*
+/*
  * We do not return NULL from these functions if CONFIG_DEBUG_FS is not enabled
  * so users have a chance to detect if there was a real error or not.  We don't
  * want to duplicate the design decision mistakes of procfs and devfs again.
@@ -128,6 +128,34 @@ static inline struct dentry *debugfs_cre
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

-- 
Ciao
Stefano
