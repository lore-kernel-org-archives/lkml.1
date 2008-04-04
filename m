Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYDDM5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYDDM5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbYDDMy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:54:58 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63729 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbYDDMys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:54:48 -0400
Message-Id: <20080404122401.326400640@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:22:53 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 11/30] /proc/ccs/ interface for policy management.
Content-Disposition: inline; filename=tomoyo-proc-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file handles entries in /proc/ccs/ directory.


Kyle Moffett advised me not to use /proc/ , but I want to use /proc/ because

(1) securityfs is not always ready at /sys/kernel/security/ .
    I have to mount securityfs when /sbin/init starts.
    But proc is always ready at /proc/ .
(2) TOMOYO Linux doesn't require LSM.
    TOMOYO Linux can be built without CONFIG_SECURITY=y .
(3) TOMOYO Linux is not only a tool for access control
    but also a tool for analyzing a system's behavior.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 fs/proc/ccs_proc.c |  156 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/fs/proc/ccs_proc.c
@@ -0,0 +1,156 @@
+/*
+ * fs/proc/ccs_proc.c
+ *
+ * /proc interface for SAKURA and TOMOYO.
+ *
+ * Copyright (C) 2005-2008  NTT DATA CORPORATION
+ *
+ * Version: 1.6.0   2008/04/01
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/ccs_proc.h>
+#include <linux/ccs_common.h>
+
+#if defined(CONFIG_SAKURA) || defined(CONFIG_TOMOYO)
+
+/**
+ * ccs_open - open() for /proc/ccs/ interface.
+ *
+ * @inode: Pointer to "struct inode".
+ * @file:  Pointer to "struct file".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int ccs_open(struct inode *inode, struct file *file)
+{
+	return ccs_open_control(((u8 *) PDE(inode)->data) - ((u8 *) NULL),
+				file);
+}
+
+/**
+ * ccs_release - close() for /proc/ccs/ interface.
+ *
+ * @inode: Pointer to "struct inode".
+ * @file:  Pointer to "struct file".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int ccs_release(struct inode *inode, struct file *file)
+{
+	return ccs_close_control(file);
+}
+
+/**
+ * ccs_poll - poll() for /proc/ccs/ interface.
+ *
+ * @file: Pointer to "struct file".
+ * @wait: Pointer to "poll_table".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static unsigned int ccs_poll(struct file *file, poll_table *wait)
+{
+	return ccs_poll_control(file, wait);
+}
+
+/**
+ * ccs_read - read() for /proc/ccs/ interface.
+ *
+ * @file:  Pointer to "struct file".
+ * @buf:   Pointer to buffer.
+ * @count: Size of @buf.
+ * @ppos:  Unused.
+ *
+ * Returns bytes read on success, negative value otherwise.
+ */
+static ssize_t ccs_read(struct file *file, char __user *buf, size_t count,
+			loff_t *ppos)
+{
+	return ccs_read_control(file, buf, count);
+}
+
+/**
+ * ccs_write - write() for /proc/ccs/ interface.
+ *
+ * @file:  Pointer to "struct file".
+ * @buf:   Pointer to buffer.
+ * @count: Size of @buf.
+ * @ppos:  Unused.
+ *
+ * Returns @count on success, negative value otherwise.
+ */
+static ssize_t ccs_write(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	return ccs_write_control(file, buf, count);
+}
+
+/* Operations for /proc/ccs/interface. */
+static struct file_operations ccs_operations = {
+	.open    = ccs_open,
+	.release = ccs_release,
+	.poll    = ccs_poll,
+	.read    = ccs_read,
+	.write   = ccs_write,
+};
+
+/**
+ * create_entry - Create interface files under /proc/ccs/ directory.
+ *
+ * @name:   The name of the interface file.
+ * @mode:   The permission of the interface file.
+ * @parent: The parent directory.
+ * @key:    Type of interface.
+ *
+ * Returns nothing.
+ */
+static void __init create_entry(const char *name, const mode_t mode,
+				struct proc_dir_entry *parent, const u8 key)
+{
+	struct proc_dir_entry *entry = create_proc_entry(name, mode, parent);
+	if (entry) {
+		entry->proc_fops = &ccs_operations;
+		entry->data = ((u8 *) NULL) + key;
+	}
+}
+
+/**
+ * ccs_proc_init - Initialize /proc/ccs/ interface.
+ *
+ * Returns 0.
+ */
+static int __init ccs_proc_init(void)
+{
+	struct proc_dir_entry *ccs_dir = proc_mkdir("ccs", NULL);
+	create_entry("query",            0600, ccs_dir, CCS_QUERY);
+#ifdef CONFIG_SAKURA
+	create_entry("system_policy",    0600, ccs_dir, CCS_SYSTEMPOLICY);
+#endif
+#ifdef CONFIG_TOMOYO
+	create_entry("domain_policy",    0600, ccs_dir, CCS_DOMAINPOLICY);
+	create_entry("exception_policy", 0600, ccs_dir, CCS_EXCEPTIONPOLICY);
+	create_entry("grant_log",        0400, ccs_dir, CCS_GRANTLOG);
+	create_entry("reject_log",       0400, ccs_dir, CCS_REJECTLOG);
+#endif
+	create_entry("self_domain",      0400, ccs_dir, CCS_SELFDOMAIN);
+	create_entry(".domain_status",   0600, ccs_dir, CCS_DOMAIN_STATUS);
+	create_entry(".process_status",  0600, ccs_dir, CCS_PROCESS_STATUS);
+	create_entry("meminfo",          0400, ccs_dir, CCS_MEMINFO);
+	create_entry("profile",          0600, ccs_dir, CCS_PROFILE);
+	create_entry("manager",          0600, ccs_dir, CCS_MANAGER);
+	create_entry(".updates_counter", 0400, ccs_dir, CCS_UPDATESCOUNTER);
+	create_entry("version",          0400, ccs_dir, CCS_VERSION);
+	if (sizeof(struct ccs_page_buffer) <  CCS_MAX_PATHNAME_LEN - 16)
+		panic("Bad size!");
+	return 0;
+}
+
+security_initcall(ccs_proc_init);
+
+#endif

-- 
