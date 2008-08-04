Return-Path: <linux-kernel-owner+w=401wt.eu-S1764042AbYHDVBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764042AbYHDVBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbYHDVA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:00:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888AbYHDVAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:00:53 -0400
From: Eric Paris <eparis@redhat.com>
To: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [RFC 2/5] [TALPA] securityfs configuration interfaces
Date: Mon,  4 Aug 2008 17:00:37 -0400
Message-Id: <1217883640-29121-2-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1217883640-29121-1-git-send-email-eparis@redhat.com>
References: <1217883640-29121-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each filter can choose to export a set of configuration options
which is implemented through securityfs on the low-level.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 security/talpa/Makefile              |    4 +-
 security/talpa/talpa.h               |   41 +++++++++
 security/talpa/talpa_common.c        |   54 ++++++++++++
 security/talpa/talpa_configuration.c |  155 ++++++++++++++++++++++++++++++++++
 4 files changed, 253 insertions(+), 1 deletions(-)
 create mode 100644 security/talpa/talpa_common.c
 create mode 100644 security/talpa/talpa_configuration.c

diff --git a/security/talpa/Makefile b/security/talpa/Makefile
index 676fc90..41045d7 100644
--- a/security/talpa/Makefile
+++ b/security/talpa/Makefile
@@ -4,4 +4,6 @@
 
 obj-$(CONFIG_TALPA) := talpa.o
 
-talpa-y := talpa_interceptor.o
+talpa-y :=	talpa_interceptor.o \
+		talpa_common.o \
+		talpa_configuration.o
diff --git a/security/talpa/talpa.h b/security/talpa/talpa.h
index 2c4fb6f..871b6d4 100644
--- a/security/talpa/talpa.h
+++ b/security/talpa/talpa.h
@@ -1,5 +1,6 @@
 /*
  *  Copyright 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -61,4 +62,44 @@ struct talpa_file_vetting {
 	int code;
 };
 
+/**
+ * struct talpa_configuration - configuration description for filters
+ * @name: name of the configuration
+ * @mode: access mode
+ * @data: private data to pass to get and set callbacks
+ * @get: callback to read out configuration value
+ * @set: callback to write in configuration value
+ *
+ * Filter wanting to have configurable items passes in an array of these
+ * structures at registration time. Last item should have name set to
+ * NULL.
+ * Get and set callbacks will be called with a pointer to a single
+ * configuration item.
+ * Set callback is guaranteed to provide a null-terminated string
+ * with no newline characters and len set to string length.
+ */
+struct talpa_configuration {
+	char *name;
+	int mode;
+	void *data;
+	ssize_t (*get)(struct talpa_configuration *cfg, char *buf, size_t len);
+	ssize_t (*set)(struct talpa_configuration *cfg, char *buf, size_t len);
+};
+
+/**
+ * talpa_register_configuration - register an array of configuration items
+ * @group: group name
+ * @name: filter name
+ * @cfg: array of configuration items
+ *
+ * This is an internal function which will be called for filters which
+ * specify configuration on registration time.
+ */
+extern struct dentry *talpa_register_configuration(char *name, struct talpa_configuration *cfg);
+
+/* Generic configuration get and set methods which can be used in simple cases. */
+extern ssize_t talpa_generic_get_ulong(struct talpa_configuration *cfg, char *buf, size_t len);
+extern ssize_t talpa_generic_set_ulong(struct talpa_configuration *cfg, char *buf, size_t len);
+extern ssize_t talpa_generic_get_long(struct talpa_configuration *cfg, char *buf, size_t len);
+
 #endif /* __TALPA_H__ */
diff --git a/security/talpa/talpa_common.c b/security/talpa/talpa_common.c
new file mode 100644
index 0000000..2dd3eb1
--- /dev/null
+++ b/security/talpa/talpa_common.c
@@ -0,0 +1,54 @@
+/*
+ *  Copyright 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+
+#include "talpa.h"
+
+ssize_t talpa_generic_get_ulong(struct talpa_configuration *cfg, char *buf, size_t len)
+{
+	int ret = snprintf(buf, len, "%lu\n", *((unsigned long *)cfg->data));
+	if (ret > 0)
+		ret++;
+
+	return ret;
+}
+
+ssize_t talpa_generic_set_ulong(struct talpa_configuration *cfg, char *buf, size_t len)
+{
+	ssize_t ret = 0;
+
+	if (strict_strtoul(buf, 10, (unsigned long *)cfg->data))
+		return -EINVAL;
+
+	return ret;
+
+}
+
+ssize_t talpa_generic_get_long(struct talpa_configuration *cfg, char *buf, size_t len)
+{
+	int ret = snprintf(buf, len, "%ld\n", *((long *)cfg->data));
+	if (ret > 0)
+		ret++;
+
+	return ret;
+}
diff --git a/security/talpa/talpa_configuration.c b/security/talpa/talpa_configuration.c
new file mode 100644
index 0000000..18378b5
--- /dev/null
+++ b/security/talpa/talpa_configuration.c
@@ -0,0 +1,155 @@
+/*
+ *  Copyright 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/talpa.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+
+#include "talpa.h"
+
+/* Talpa configuration root. */
+static struct dentry *talpa_fs_root;
+
+/* Filesytem read function. */
+static ssize_t talpa_fs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct talpa_configuration *cfg;
+	char *data;
+	ssize_t ret;
+
+
+	cfg = (struct talpa_configuration *)file->f_dentry->d_inode->i_private;
+	if (!cfg)
+		return -EBADF;
+
+	if (!cfg->get)
+		return -ENOSYS;
+
+	/* Return EOF for second read (whole value must be read in one go) */
+	if (!count || file->f_pos)
+		return 0;
+
+	data = kzalloc(count, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = cfg->get(cfg, data, count);
+	if (ret > 0 && copy_to_user(buf, data, ret)) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	kfree(data);
+	*ppos = ret;
+	return ret;
+}
+
+/* Filesytem write function. */
+static ssize_t talpa_fs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+{
+	struct talpa_configuration *cfg;
+	char *data, *ptr, *end;
+	ssize_t ret;
+	size_t len = 0;
+
+	cfg = (struct talpa_configuration *)file->f_dentry->d_inode->i_private;
+	if (!cfg)
+		return -EBADF;
+
+	if (!cfg->set)
+		return -ENOSYS;
+
+	if (!count)
+		return 0;
+
+	if (file->f_pos)
+		return -EINVAL;
+
+	/* Make sure we have space in buffer is string is
+	   not null-terminated. */
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count)) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	/* Null terminate string on first newline and find out it's
+	   resulting length. */
+	ptr = data;
+	end = data + count;
+	while (ptr < end) {
+		if (*ptr == 0 || *ptr == '\n') {
+			*ptr = 0;
+			break;
+		}
+		len++;
+		ptr++;
+	}
+
+	ret = cfg->set(cfg, data, len);
+	if (ret >= 0) {
+		*ppos = ret;
+		ret = count;
+	}
+	kfree(data);
+	return ret;
+}
+
+static struct file_operations talpa_fs_ops = {
+	.open = nonseekable_open,
+	.read = talpa_fs_read,
+	.write = talpa_fs_write,
+};
+
+/* Externally visible registration function. */
+struct dentry *talpa_register_configuration(char *name, struct talpa_configuration *cfg)
+{
+	struct dentry *subdir;
+	struct dentry *param;
+
+	/* Get root sub-directory for this group. */
+	subdir = securityfs_create_dir(name, talpa_fs_root);
+	if (!subdir)
+		return ERR_PTR(-ENOMEM);
+
+	/* Create files for configuration items. */
+	for (; cfg->name != NULL; cfg++)
+		param = securityfs_create_file(cfg->name, cfg->mode, subdir, cfg, &talpa_fs_ops);
+
+	return subdir;
+}
+
+static __init int talpa_configuration_init(void)
+{
+	talpa_fs_root = securityfs_create_dir("talpa", NULL);
+	if (!talpa_fs_root)
+		return -ENOMEM;
+
+	return 0;
+}
+
+__initcall(talpa_configuration_init);
-- 
1.5.2.1

