Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbXD0TJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbXD0TJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbXD0TJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:09:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:35320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbXD0S61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michael Ellerman <michael@ellerman.id.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/46] debugfs: Add debugfs_create_u64()
Date: Fri, 27 Apr 2007 11:53:49 -0700
Message-Id: <11777001682584-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001642551-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

I went to use this the other day, only to find it didn't exist.

It's a straight copy of the debugfs u32 code, then s/u32/u64/. A quick
test shows it seems to be working.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c       |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h |    9 +++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 682f928..2e124e0 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -179,6 +179,48 @@ struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
+static void debugfs_u64_set(void *data, u64 val)
+{
+	*(u64 *)data = val;
+}
+
+static u64 debugfs_u64_get(void *data)
+{
+	return *(u64 *)data;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugfs_u64_get, debugfs_u64_set, "%llu\n");
+
+/**
+ * debugfs_create_u64 - create a debugfs file that is used to read and write an unsigned 64-bit value
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
+struct dentry *debugfs_create_u64(const char *name, mode_t mode,
+				 struct dentry *parent, u64 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_u64);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_u64);
+
 static ssize_t read_file_bool(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 9fa0983..5a9c495 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -44,6 +44,8 @@ struct dentry *debugfs_create_u16(const char *name, mode_t mode,
 				  struct dentry *parent, u16 *value);
 struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
+struct dentry *debugfs_create_u64(const char *name, mode_t mode,
+				  struct dentry *parent, u64 *value);
 struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
 
@@ -104,6 +106,13 @@ static inline struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_u64(const char *name, mode_t mode,
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
1.5.1.2

