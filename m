Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZKJQNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZKJQNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZKJQNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:13:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59759 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbZKJQNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:09 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 01/12] AppArmor: misc. base functions and defines
Date: Tue, 10 Nov 2009 08:12:54 -0800
Message-Id: <1257869585-7092-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous functions and defines needed by AppArmor, including
the base path resolution routines.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/apparmor.h |   61 +++++++++++
 security/apparmor/include/path.h     |   21 ++++
 security/apparmor/lib.c              |   76 +++++++++++++
 security/apparmor/path.c             |  196 ++++++++++++++++++++++++++++++++++
 4 files changed, 354 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/include/apparmor.h
 create mode 100644 security/apparmor/include/path.h
 create mode 100644 security/apparmor/lib.c
 create mode 100644 security/apparmor/path.c

diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
new file mode 100644
index 0000000..1bf700f
--- /dev/null
+++ b/security/apparmor/include/apparmor.h
@@ -0,0 +1,61 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor basic global and lib definitions
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __APPARMOR_H
+#define __APPARMOR_H
+
+#include <linux/fs.h>
+
+/* Control parameters settable thru module/boot flags or
+ * via /sys/kernel/security/apparmor/control */
+extern enum audit_mode aa_g_audit;
+extern int aa_g_audit_header;
+extern int aa_g_debug;
+extern int aa_g_lock_policy;
+extern int aa_g_logsyscall;
+extern unsigned int aa_g_path_max;
+
+/*
+ * DEBUG remains global (no per profile flag) since it is mostly used in sysctl
+ * which is not related to profile accesses.
+ */
+
+#define AA_DEBUG(fmt, args...)						\
+	do {								\
+		if (aa_g_debug && printk_ratelimit())			\
+			printk(KERN_DEBUG "AppArmor: " fmt, ##args);	\
+	} while (0)
+
+#define AA_ERROR(fmt, args...)						\
+	do {								\
+		if (printk_ratelimit())					\
+			printk(KERN_ERR "AppArmor: " fmt, ##args);	\
+	} while (0)
+
+/* Flag indicating whether initialization completed */
+extern int apparmor_initialized;
+void apparmor_disable(void);
+
+/* fn's in lib */
+char *aa_split_name_from_ns(char *args, char **ns_name);
+int aa_strneq(const char *str, const char *sub, int len);
+char *aa_strchrnul(const char *s, int c);
+void aa_info_message(const char *str);
+
+static inline int mediated_filesystem(struct inode *inode)
+{
+	return !(inode->i_sb->s_flags & MS_NOUSER);
+}
+
+#endif /* __APPARMOR_H */
diff --git a/security/apparmor/include/path.h b/security/apparmor/include/path.h
new file mode 100644
index 0000000..f146868
--- /dev/null
+++ b/security/apparmor/include/path.h
@@ -0,0 +1,21 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor basic path manipulation function definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_PATH_H
+#define __AA_PATH_H
+
+int aa_get_name(struct path *path, int is_dir, char **buffer, char **name);
+char *sysctl_pathname(struct ctl_table *table, char *buffer, int buflen);
+
+#endif /* __AA_PATH_H */
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
new file mode 100644
index 0000000..739705c
--- /dev/null
+++ b/security/apparmor/lib.c
@@ -0,0 +1,76 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains basic common functions used in AppArmor
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "include/audit.h"
+
+char *aa_strchrnul(const char *s, int c)
+{
+	for (; *s != (char)c && *s != '\0'; ++s)
+		;
+	return (char *)s;
+}
+
+char *aa_split_name_from_ns(char *args, char **ns_name)
+{
+	char *name = strstrip(args);
+
+	*ns_name = NULL;
+	if (args[0] == ':') {
+		char *split = strstrip(strchr(&args[1], ':'));
+
+		if (!split)
+			return NULL;
+
+		*split = 0;
+		*ns_name = &args[1];
+		name = strstrip(split + 1);
+	}
+	if (*name == 0)
+		name = NULL;
+
+	return name;
+}
+
+/**
+ * aa_strneq - compare null terminated @str to a non null terminated substring
+ * @str: a null terminated string
+ * @sub: a substring, not necessarily null terminated
+ * @len: length of @sub to compare
+ *
+ * The @str string must be full consumed for this to be considered a match
+ */
+int aa_strneq(const char *str, const char *sub, int len)
+{
+	int res = strncmp(str, sub, len);
+	if (res)
+		return 0;
+	if (str[len] == 0)
+		return 1;
+	return 0;
+}
+
+void aa_info_message(const char *str)
+{
+	struct aa_audit sa = {
+		.gfp_mask = GFP_KERNEL,
+		.info = str,
+	};
+	printk(KERN_INFO "AppArmor: %s\n", str);
+	if (audit_enabled)
+		aa_audit(AUDIT_APPARMOR_STATUS, NULL, &sa, NULL);
+}
+
diff --git a/security/apparmor/path.c b/security/apparmor/path.c
new file mode 100644
index 0000000..c816c79
--- /dev/null
+++ b/security/apparmor/path.c
@@ -0,0 +1,196 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor function for pathnames
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include <linux/mnt_namespace.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/path.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/fs_struct.h>
+
+#include "include/apparmor.h"
+#include "include/path.h"
+#include "include/policy.h"
+
+/**
+ * d_namespace_path - lookup a name associated with a given path
+ * @path: path to lookup
+ * @buf:  buffer to store path to
+ * @buflen: length of @buf
+ * @name: returns pointer for start of path name with in @buf
+ * @flags: flags controling path lookup
+ *
+ */
+static int d_namespace_path(struct path *path, char *buf, int buflen,
+			    char **name, int flags)
+{
+	struct path root, tmp, ns_root = { };
+	char *res;
+	int deleted;
+	int error = 0;
+
+	read_lock(&current->fs->lock);
+	root = current->fs->root;
+	/* released below */
+	path_get(&current->fs->root);
+	read_unlock(&current->fs->lock);
+	spin_lock(&vfsmount_lock);
+	if (root.mnt && root.mnt->mnt_ns)
+		/* released below */
+		ns_root.mnt = mntget(root.mnt->mnt_ns->root);
+	if (ns_root.mnt)
+		/* released below */
+		ns_root.dentry = dget(ns_root.mnt->mnt_root);
+	spin_unlock(&vfsmount_lock);
+	spin_lock(&dcache_lock);
+
+	/* There is a race window between path lookup here and the
+	 * need to strip the " (deleted) string that __d_path applies
+	 * Detect the race and relookup the path
+	 */
+	do {
+		tmp = ns_root;
+		deleted = d_unlinked(path->dentry);
+		res = __d_path(path, &tmp, buf, buflen);
+
+	} while (deleted != d_unlinked(path->dentry));
+
+	*name = res;
+	/* handle error conditions - and still allow a partial path to
+	 * be returned.
+	 */
+	if (IS_ERR(res)) {
+		error = PTR_ERR(res);
+		*name = buf;
+	} else if (deleted) {
+		/* The stripping of (deleted) is a hack that could be removed
+		 * with an updated __d_path
+		 */
+
+		if (!path->dentry->d_inode || flags & PFLAG_DELETED_NAMES)
+			/* On some filesystems, newly allocated dentries appear
+			 * to the security_path hooks as a deleted
+			 * dentry except without an inode allocated.
+			 *
+			 * Remove the appended deleted text and return as a
+			 * string for normal mediation.  The (deleted) string
+			 * is guarenteed to be added in this case, so just
+			 * strip it.
+			 */
+			buf[buflen - 11] = 0;	/* - (len(" (deleted)") +\0) */
+		else
+			error = -ENOENT;
+	} else if (flags & ~PFLAG_CONNECT_PATH &&
+		   tmp.dentry != ns_root.dentry && tmp.mnt != ns_root.mnt) {
+		/* disconnected path, don't return pathname starting with '/' */
+		error = -ESTALE;
+		if (*res == '/')
+			*name = res + 1;
+	}
+
+	spin_unlock(&dcache_lock);
+	path_put(&root);
+	path_put(&ns_root);
+
+	return error;
+}
+
+static int get_name_to_buffer(struct path *path, int is_dir, char *buffer,
+			      int size, char **name, int flags)
+{
+	int error = d_namespace_path(path, buffer, size - is_dir, name, flags);
+
+	if (!error && is_dir && (*name)[1] != '\0')
+		/*
+		 * Append "/" to the pathname.  The root directory is a special
+		 * case; it already ends in slash.
+		 */
+		strcpy(&buffer[size - 2], "/");
+
+	return error;
+}
+
+/**
+ * aa_get_name - compute the pathname of a file
+ * @path: path the file
+ * @is_dir: set if the file is a directory
+ * @buffer: buffer that aa_get_name() allocated
+ * @name: the error code indicating whether aa_get_name failed
+ *
+ * Returns an error code if the there was a failure in obtaining the
+ * name.
+ *
+ * @name is apointer to the beginning of the pathname (which usually differs
+ * from the beginning of the buffer), or NULL.  If there is an error @name
+ * may contain a partial or invalid name (in the case of a deleted file), that
+ * can be used for audit purposes, but it can not be used for mediation.
+ *
+ * We need @is_dir to indicate whether the file is a directory or not because
+ * the file may not yet exist, and so we cannot check the inode's file type.
+ */
+int aa_get_name(struct path *path, int is_dir, char **buffer, char **name)
+{
+	char *buf, *str = NULL;
+	int size = 256;
+	int error;
+
+	*name = NULL;
+	*buffer = NULL;
+	for (;;) {
+		/* freed by caller */
+		buf = kmalloc(size, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		error = get_name_to_buffer(path, is_dir, buf, size, &str, 0);
+		if (!error || (error == -ENOENT) || (error == -ESTALE))
+			break;
+
+		kfree(buf);
+		size <<= 1;
+		if (size > aa_g_path_max)
+			return -ENAMETOOLONG;
+	}
+	*buffer = buf;
+	*name = str;
+
+	return error;
+}
+
+char *sysctl_pathname(struct ctl_table *table, char *buffer, int buflen)
+{
+	if (buflen < 1)
+		return NULL;
+	buffer += --buflen;
+	*buffer = '\0';
+
+	while (table) {
+		int namelen = strlen(table->procname);
+
+		if (buflen < namelen + 1)
+			return NULL;
+		buflen -= namelen + 1;
+		buffer -= namelen;
+		memcpy(buffer, table->procname, namelen);
+		*--buffer = '/';
+		table = table->parent;
+	}
+	if (buflen < 4)
+		return NULL;
+	buffer -= 4;
+	memcpy(buffer, "/sys", 4);
+
+	return buffer;
+}
-- 
1.6.3.3

