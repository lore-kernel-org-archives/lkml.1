Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbXJLW1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbXJLW1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbXJLWS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:49655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760793AbXJLWSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/75] debugfs: helper for decimal challenged
Date: Fri, 12 Oct 2007 15:16:21 -0700
Message-Id: <11922275181138-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275121763-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Allows debugfs helper functions to have a hex output, rather than just decimal

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c       |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h |   27 +++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 2e124e0..a9b99c0 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -221,6 +221,42 @@ struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u64);
 
+DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
+
+/**
+ * debugfs_create_x8 - create a debugfs file that is used to read and write an unsigned 8-bit value
+ * debugfs_create_x16 - create a debugfs file that is used to read and write an unsigned 16-bit value
+ * debugfs_create_x32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+ *
+ * These functions are exactly the same as the above functions, (but use a hex
+ * output for the decimal challenged) for details look at the above unsigned
+ * decimal functions.
+ */
+struct dentry *debugfs_create_x8(const char *name, mode_t mode,
+				 struct dentry *parent, u8 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x8);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x8);
+
+struct dentry *debugfs_create_x16(const char *name, mode_t mode,
+				 struct dentry *parent, u16 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x16);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x16);
+
+struct dentry *debugfs_create_x32(const char *name, mode_t mode,
+				 struct dentry *parent, u32 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x32);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x32);
+
 static ssize_t read_file_bool(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 104e51e..f592d6d 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -49,6 +49,12 @@ struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
 struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 				  struct dentry *parent, u64 *value);
+struct dentry *debugfs_create_x8(const char *name, mode_t mode,
+				 struct dentry *parent, u8 *value);
+struct dentry *debugfs_create_x16(const char *name, mode_t mode,
+				  struct dentry *parent, u16 *value);
+struct dentry *debugfs_create_x32(const char *name, mode_t mode,
+				  struct dentry *parent, u32 *value);
 struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
 
@@ -122,6 +128,27 @@ static inline struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_x8(const char *name, mode_t mode,
+					       struct dentry *parent,
+					       u8 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_x16(const char *name, mode_t mode,
+						struct dentry *parent,
+						u16 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *debugfs_create_x32(const char *name, mode_t mode,
+						struct dentry *parent,
+						u32 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 						 struct dentry *parent,
 						 u32 *value)
-- 
1.5.3.4

