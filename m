Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZJDNBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZJDNBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 09:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZJDNBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 09:01:07 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52871 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106AbZJDNBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 09:01:03 -0400
Message-Id: <20091004125334.269163576@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sun, 04 Oct 2009 21:50:07 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #16 21/25] TOMOYO: Add securityfs interface.
Content-Disposition: inline; filename=tomoyo-add-securityfs-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains code for creating /sys/kernel/security/tomoyo/ interface.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/securityfs_if.c |  148 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)

--- /dev/null
+++ security-testing-2.6/security/tomoyo/securityfs_if.c
@@ -0,0 +1,148 @@
+/*
+ * security/tomoyo/securityfs_if.c
+ *
+ * Copyright (C) 2005-2009  NTT DATA CORPORATION
+ */
+#include "internal.h"
+
+/**
+ * tomoyo_open - open() for /sys/kernel/security/tomoyo/ interface.
+ *
+ * @inode: Pointer to "struct inode".
+ * @file:  Pointer to "struct file".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int tomoyo_open(struct inode *inode, struct file *file)
+{
+	const int key = ((u8 *) file->f_path.dentry->d_inode->i_private)
+		- ((u8 *) NULL);
+	return tomoyo_open_control(key, file);
+}
+
+/**
+ * tomoyo_release - close() for /sys/kernel/security/tomoyo/ interface.
+ *
+ * @inode: Pointer to "struct inode".
+ * @file:  Pointer to "struct file".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int tomoyo_release(struct inode *inode, struct file *file)
+{
+	return tomoyo_close_control(file);
+}
+
+/**
+ * tomoyo_poll - poll() for /sys/kernel/security/tomoyo/ interface.
+ *
+ * @file: Pointer to "struct file".
+ * @wait: Pointer to "poll_table".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static unsigned int tomoyo_poll(struct file *file, poll_table *wait)
+{
+	return tomoyo_poll_control(file, wait);
+}
+
+/**
+ * tomoyo_read - read() for /sys/kernel/security/tomoyo/ interface.
+ *
+ * @file:  Pointer to "struct file".
+ * @buf:   Pointer to buffer.
+ * @count: Size of @buf.
+ * @ppos:  Unused.
+ *
+ * Returns bytes read on success, negative value otherwise.
+ */
+static ssize_t tomoyo_read(struct file *file, char __user *buf, size_t count,
+			   loff_t *ppos)
+{
+	return tomoyo_read_control(file, buf, count);
+}
+
+/**
+ * tomoyo_write - write() for /sys/kernel/security/tomoyo/ interface.
+ *
+ * @file:  Pointer to "struct file".
+ * @buf:   Pointer to buffer.
+ * @count: Size of @buf.
+ * @ppos:  Unused.
+ *
+ * Returns @count on success, negative value otherwise.
+ */
+static ssize_t tomoyo_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	return tomoyo_write_control(file, buf, count);
+}
+
+/* Operations for /sys/kernel/security/tomoyo/interface. */
+static const struct file_operations tomoyo_operations = {
+	.open    = tomoyo_open,
+	.release = tomoyo_release,
+	.poll    = tomoyo_poll,
+	.read    = tomoyo_read,
+	.write   = tomoyo_write,
+};
+
+/**
+ * tomoyo_create_entry - Create interface files under /sys/kernel/security/tomoyo/ directory.
+ *
+ * @name:   The name of the interface file.
+ * @mode:   The permission of the interface file.
+ * @parent: The parent directory.
+ * @key:    Type of interface.
+ *
+ * Returns nothing.
+ */
+static void __init tomoyo_create_entry(const char *name, const mode_t mode,
+				       struct dentry *parent, const u8 key)
+{
+	securityfs_create_file(name, mode, parent, ((u8 *) NULL) + key,
+			       &tomoyo_operations);
+}
+
+/**
+ * tomoyo_securityfs_init - Initialize /sys/kernel/security/tomoyo/ interface.
+ *
+ * Returns 0.
+ */
+static int __init tomoyo_securityfs_init(void)
+{
+	struct dentry *tomoyo_dir;
+	if (!tomoyo_registered)
+		return 0;
+	tomoyo_dir = securityfs_create_dir("tomoyo", NULL);
+	tomoyo_create_entry("query",            0600, tomoyo_dir,
+			    TOMOYO_QUERY);
+	tomoyo_create_entry("domain_policy",    0600, tomoyo_dir,
+			    TOMOYO_DOMAINPOLICY);
+	tomoyo_create_entry("exception_policy", 0600, tomoyo_dir,
+			    TOMOYO_EXCEPTIONPOLICY);
+#ifdef CONFIG_SECURITY_TOMOYO_AUDIT
+	tomoyo_create_entry("grant_log",        0400, tomoyo_dir,
+			    TOMOYO_GRANTLOG);
+	tomoyo_create_entry("reject_log",       0400, tomoyo_dir,
+			    TOMOYO_REJECTLOG);
+#endif
+	tomoyo_create_entry("self_domain",      0400, tomoyo_dir,
+			    TOMOYO_SELFDOMAIN);
+	tomoyo_create_entry(".domain_status",   0600, tomoyo_dir,
+			    TOMOYO_DOMAIN_STATUS);
+	tomoyo_create_entry(".process_status",  0600, tomoyo_dir,
+			    TOMOYO_PROCESS_STATUS);
+	tomoyo_create_entry("meminfo",          0600, tomoyo_dir,
+			    TOMOYO_MEMINFO);
+	tomoyo_create_entry("profile",          0600, tomoyo_dir,
+			    TOMOYO_PROFILE);
+	tomoyo_create_entry("manager",          0600, tomoyo_dir,
+			    TOMOYO_MANAGER);
+	tomoyo_create_entry("version",          0400, tomoyo_dir,
+			    TOMOYO_VERSION);
+	tomoyo_create_entry(".execute_handler", 0666, tomoyo_dir,
+			    TOMOYO_EXECUTE_HANDLER);
+	return 0;
+}
+fs_initcall(tomoyo_securityfs_init);

-- 
