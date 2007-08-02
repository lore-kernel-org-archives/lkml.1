Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbXHBWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbXHBWUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXHBWUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:20:04 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:11540 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbXHBWUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:20:02 -0400
X-IronPort-AV: i="4.19,215,1183348800"; 
   d="scan'208"; a="47254542:sNHT28371091"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <greg@kroah.com>
Subject: [PATCH] debugfs helper for decimal challenged
Date: Thu, 2 Aug 2007 18:23:50 -0400
User-Agent: KMail/1.9.5
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <vapier.adi@gmail.com>
References: <200708011752.58481.rgetz@blackfin.uclinux.org> <200708012313.51933.rgetz@blackfin.uclinux.org> <20070802210925.GA6199@kroah.com>
In-Reply-To: <20070802210925.GA6199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021823.50173.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 02 Aug 2007 22:19:59.0892 (UTC) FILETIME=[43BEAD40:01C7D553]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>
 
Allows debugfs helper functions to have a hex output, rather than just decimal
 
Signed-off-by:  Robin Getz <rgetz@blackfin.uclinux.org>
---

 fs/debugfs/file.c       |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h |   27 +++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

Index: linux-2.6.x/include/linux/debugfs.h
===================================================================
--- linux-2.6.x/include/linux/debugfs.h	(revision 3534)
+++ linux-2.6.x/include/linux/debugfs.h	(working copy)
@@ -44,6 +44,12 @@
 				  struct dentry *parent, u16 *value);
 struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
+struct dentry *debugfs_create_x8(const char *name, mode_t mode,
+				 struct dentry *parent, u8 *value);
+struct dentry *debugfs_create_x16(const char *name, mode_t mode,
+				 struct dentry *parent, u16 *value);
+struct dentry *debugfs_create_x32(const char *name, mode_t mode,
+				 struct dentry *parent, u32 *value);
 struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
 
@@ -104,6 +110,27 @@
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
Index: linux-2.6.x/fs/debugfs/file.c
===================================================================
--- linux-2.6.x/fs/debugfs/file.c	(revision 3534)
+++ linux-2.6.x/fs/debugfs/file.c	(working copy)
@@ -179,6 +179,42 @@
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
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
