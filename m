Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZKJQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZKJQNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbZKJQNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:13:37 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59999 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbZKJQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:31 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 07/12] AppArmor: userspace interfaces
Date: Tue, 10 Nov 2009 08:13:00 -0800
Message-Id: <1257869585-7092-8-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AppArmor /proc/<pid>/attr/* and apparmorfs interfaces to userspace.

The /proc/<pid>/attr/* interface is used for process introspection and
commands.  While the apparmorfs interface is used for global introspection
and loading and removing policy.

The current apparmorfs interface is compatible with previous versions
of AppArmor.  The plans are to deprecate it (hence the config option
APPARMOR_COMPAT_24) and replace it with a more sysfs style single
entry per file interface.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/apparmorfs-24.c      |  211 ++++++++++++++++++++++++++
 security/apparmor/apparmorfs.c         |  260 ++++++++++++++++++++++++++++++++
 security/apparmor/include/apparmorfs.h |   29 ++++
 security/apparmor/include/procattr.h   |   26 +++
 security/apparmor/procattr.c           |  114 ++++++++++++++
 5 files changed, 640 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/apparmorfs-24.c
 create mode 100644 security/apparmor/apparmorfs.c
 create mode 100644 security/apparmor/include/apparmorfs.h
 create mode 100644 security/apparmor/include/procattr.h
 create mode 100644 security/apparmor/procattr.c

diff --git a/security/apparmor/apparmorfs-24.c b/security/apparmor/apparmorfs-24.c
new file mode 100644
index 0000000..02a3396
--- /dev/null
+++ b/security/apparmor/apparmorfs-24.c
@@ -0,0 +1,211 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor /sys/kernel/secrutiy/apparmor interface functions
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ *
+ * This file contain functions providing an interface for <= AppArmor 2.4
+ * compatibility.  It is dependent on CONFIG_SECURITY_APPARMOR_COMPAT_24
+ * being set (see Makefile).
+ */
+
+#include <linux/security.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/namei.h>
+
+#include "include/apparmor.h"
+#include "include/audit.h"
+#include "include/context.h"
+#include "include/policy.h"
+
+/**
+ * next_profile - step to the next profile to be output
+ * @profile: profile that was last output
+ *
+ * Perform a depth first traversal over profile tree.
+ *
+ * Returns: next profile or NULL if done
+ * Requires: ns_list_lock, and profile->ns->base.lock be held
+ *           will unlock profile->ns.base.lock and aquire lock for next ns
+ *           __releases(last ns lock);
+ */
+static struct aa_profile *next_profile(struct aa_profile *profile)
+{
+	struct aa_profile *parent;
+	struct aa_namespace *ns = profile->ns;
+
+	/* is next profile a child */
+	if (!list_empty(&profile->base.profiles))
+		return list_first_entry(&profile->base.profiles,
+					struct aa_profile, base.list);
+
+	/* is next a sibling, parent sibling, gp sibling */
+	parent = profile->parent;
+	while (parent) {
+		list_for_each_entry_continue(profile, &parent->base.profiles,
+					     base.list)
+			return profile;
+		profile = parent;
+		parent = parent->parent;
+	}
+
+	/* is next the another profile in the namespace */
+	list_for_each_entry_continue(profile, &ns->base.profiles, base.list)
+		return profile;
+
+	/* finished all profiles in namespace move to next namespace */
+	read_unlock(&ns->base.lock);
+	list_for_each_entry_continue(ns, &ns_list, base.list) {
+		read_lock(&ns->base.lock);
+		return list_first_entry(&ns->base.profiles, struct aa_profile,
+					base.list);
+	}
+
+	/* done all profiles */
+	return NULL;
+}
+
+/**
+ * p_start - start a depth first traversal of profile tree
+ * @f: seq_file to fill
+ * @pos: current position
+ *
+ * acquires first ns->base.lock
+ */
+static void *p_start(struct seq_file *f, loff_t *pos) __acquires(ns_list_lock)
+{
+	struct aa_namespace *ns;
+	loff_t l = *pos;
+
+	read_lock(&ns_list_lock);
+	if (!list_empty(&ns_list)) {
+		struct aa_profile *profile = NULL;
+		ns = list_first_entry(&ns_list, typeof(*ns), base.list);
+		read_lock(&ns->base.lock);
+		if (!list_empty(&ns->base.profiles)) {
+			profile = list_first_entry(&ns->base.profiles,
+						   typeof(*profile), base.list);
+			/* skip to position */
+			for (; profile && l > 0; l--)
+				profile = next_profile(profile);
+			return profile;
+		} else
+			read_unlock(&ns->base.lock);
+	}
+	return NULL;
+}
+
+static void *p_next(struct seq_file *f, void *p, loff_t *pos)
+{
+	struct aa_profile *profile = (struct aa_profile *)p;
+
+	(*pos)++;
+	profile = next_profile(profile);
+
+	return profile;
+}
+
+/**
+ * p_stop - stop depth first traversal
+ * @f: seq_file we are filling
+ * @p: the last profile writen
+ *
+ * if we haven't completely traversed the profile tree will release the
+ * ns->base.lock, if we have the ns->base.lock was released in next_profile
+ */
+static void p_stop(struct seq_file *f, void *p) __releases(ns_list_lock)
+{
+	struct aa_profile *profile = (struct aa_profile *)p;
+
+	if (profile)
+		read_unlock(&profile->ns->base.lock);
+	read_unlock(&ns_list_lock);
+}
+
+static void print_name(struct seq_file *f, struct aa_profile *profile)
+{
+	if (profile->parent) {
+		print_name(f, profile->parent);
+		seq_printf(f, "//");
+	}
+	seq_printf(f, "%s", profile->base.name);
+}
+
+static int seq_show_profile(struct seq_file *f, void *p)
+{
+	struct aa_profile *profile = (struct aa_profile *)p;
+
+	if (profile->ns != default_namespace)
+		seq_printf(f, ":%s:", profile->ns->base.name);
+	print_name(f, profile);
+	seq_printf(f, " (%s)\n",
+		   PROFILE_COMPLAIN(profile) ? "complain" : "enforce");
+
+	return 0;
+}
+
+/* Used in apparmorfs.c */
+static const struct seq_operations aa_fs_profiles_op = {
+	.start = p_start,
+	.next = p_next,
+	.stop = p_stop,
+	.show = seq_show_profile,
+};
+
+static int aa_profiles_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &aa_fs_profiles_op);
+}
+
+static int aa_profiles_release(struct inode *inode, struct file *file)
+{
+	return seq_release(inode, file);
+}
+
+const struct file_operations aa_fs_profiles_fops = {
+	.open = aa_profiles_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = aa_profiles_release,
+};
+
+/* apparmor/matching */
+static ssize_t aa_matching_read(struct file *file, char __user *buf,
+				size_t size, loff_t *ppos)
+{
+	const char matching[] = "pattern=aadfa audit perms=crwxamlk/ "
+	    "user::other";
+
+	return simple_read_from_buffer(buf, size, ppos, matching,
+				       sizeof(matching) - 1);
+}
+
+const struct file_operations aa_fs_matching_fops = {
+	.read = aa_matching_read,
+};
+
+/* apparmor/features */
+static ssize_t aa_features_read(struct file *file, char __user *buf,
+				size_t size, loff_t *ppos)
+{
+	const char features[] = "file=3.1 capability=2.0 network=1.0 "
+	    "change_hat=1.5 change_profile=1.1 " "aanamespaces=1.1 rlimit=1.1";
+
+	return simple_read_from_buffer(buf, size, ppos, features,
+				       sizeof(features) - 1);
+}
+
+const struct file_operations aa_fs_features_fops = {
+	.read = aa_features_read,
+};
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
new file mode 100644
index 0000000..8aa1c48
--- /dev/null
+++ b/security/apparmor/apparmorfs.c
@@ -0,0 +1,260 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor /sys/kernel/security/apparmor interface functions
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
+#include <linux/security.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/namei.h>
+
+#include "include/apparmor.h"
+#include "include/apparmorfs.h"
+#include "include/audit.h"
+#include "include/context.h"
+#include "include/policy.h"
+
+static char *aa_simple_write_to_buffer(const char __user *userbuf,
+				       size_t alloc_size, size_t copy_size,
+				       loff_t *pos, const char *operation)
+{
+	const struct cred *cred;
+	struct aa_profile *profile;
+	char *data;
+
+	if (*pos != 0) {
+		/* only writes from pos 0, that is complete writes */
+		data = ERR_PTR(-ESPIPE);
+		goto out;
+	}
+
+	/*
+	 * Don't allow confined processes to load/replace/remove profiles.
+	 * No sane person would add rules allowing this to a profile
+	 * but we enforce the restriction anyways.
+	 */
+	cred = aa_current_policy(&profile);
+	if (profile) {
+		struct aa_audit sa = {
+			.operation = operation,
+			.gfp_mask = GFP_KERNEL,
+			.error = -EACCES,
+		};
+		data = ERR_PTR(aa_audit(AUDIT_APPARMOR_DENIED, profile, &sa,
+					NULL));
+		goto out;
+	}
+
+	/* freed by caller to aa_simple_write_to_buffer */
+	data = vmalloc(alloc_size);
+	if (data == NULL) {
+		data = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	if (copy_from_user(data, userbuf, copy_size)) {
+		vfree(data);
+		data = ERR_PTR(-EFAULT);
+		goto out;
+	}
+
+out:
+	return data;
+}
+
+/* apparmor/.load */
+static ssize_t aa_profile_load(struct file *f, const char __user *buf,
+			       size_t size, loff_t *pos)
+{
+	char *data;
+	ssize_t error;
+
+	data = aa_simple_write_to_buffer(buf, size, size, pos, "profile_load");
+
+	error = PTR_ERR(data);
+	if (!IS_ERR(data)) {
+		error = aa_interface_add_profiles(data, size);
+		vfree(data);
+	}
+
+	return error;
+}
+
+static const struct file_operations aa_fs_profile_load = {
+	.write = aa_profile_load
+};
+
+/* apparmor/.replace */
+static ssize_t aa_profile_replace(struct file *f, const char __user *buf,
+				  size_t size, loff_t *pos)
+{
+	char *data;
+	ssize_t error;
+
+	data = aa_simple_write_to_buffer(buf, size, size, pos,
+					 "profile_replace");
+	error = PTR_ERR(data);
+	if (!IS_ERR(data)) {
+		error = aa_interface_replace_profiles(data, size);
+		vfree(data);
+	}
+
+	return error;
+}
+
+static const struct file_operations aa_fs_profile_replace = {
+	.write = aa_profile_replace
+};
+
+/* apparmor/.remove */
+static ssize_t aa_profile_remove(struct file *f, const char __user *buf,
+				 size_t size, loff_t *pos)
+{
+	char *data;
+	ssize_t error;
+
+	/*
+	 * aa_remove_profile needs a null terminated string so 1 extra
+	 * byte is allocated and the copied data is null terminated.
+	 */
+	data = aa_simple_write_to_buffer(buf, size + 1, size, pos,
+					 "profile_remove");
+
+	error = PTR_ERR(data);
+	if (!IS_ERR(data)) {
+		data[size] = 0;
+		error = aa_interface_remove_profiles(data, size);
+		vfree(data);
+	}
+
+	return error;
+}
+
+static const struct file_operations aa_fs_profile_remove = {
+	.write = aa_profile_remove
+};
+
+static struct dentry *aa_fs_dentry;
+struct dentry *aa_fs_null;
+struct vfsmount *aa_fs_mnt;
+
+static void aafs_remove(const char *name)
+{
+	struct dentry *dentry;
+
+	dentry = lookup_one_len(name, aa_fs_dentry, strlen(name));
+	if (!IS_ERR(dentry)) {
+		securityfs_remove(dentry);
+		dput(dentry);
+	}
+}
+
+/**
+ * aafs_create - create an entry in the apparmor filesystem
+ * @name: name of the entry
+ * @mask: file permission mask of the file
+ * @fops: file operations for the file
+ *
+ * Used aafs_remove to remove entries created with this fn.
+ */
+static int aafs_create(const char *name, int mask,
+		       const struct file_operations *fops)
+{
+	struct dentry *dentry;
+
+	dentry = securityfs_create_file(name, S_IFREG | mask, aa_fs_dentry,
+					NULL, fops);
+
+	return IS_ERR(dentry) ? PTR_ERR(dentry) : 0;
+}
+
+/**
+ * aa_destroy_aafs - cleanup and free aafs
+ *
+ * releases dentries allocated by aa_create_aafs
+ */
+void aa_destroy_aafs(void)
+{
+	if (aa_fs_dentry) {
+		aafs_remove(".remove");
+		aafs_remove(".replace");
+		aafs_remove(".load");
+#ifdef CONFIG_SECURITY_APPARMOR_COMPAT_24
+		aafs_remove("matching");
+		aafs_remove("features");
+		aafs_remove("profiles");
+#endif
+		securityfs_remove(aa_fs_dentry);
+		aa_fs_dentry = NULL;
+	}
+}
+
+/**
+ * aa_create_aafs - create the apparmor security filesystem
+ *
+ * dentries created here are released by aa_destroy_aafs
+ */
+int aa_create_aafs(void)
+{
+	int error;
+
+	if (!apparmor_initialized)
+		return 0;
+
+	if (aa_fs_dentry) {
+		AA_ERROR("%s: AppArmor securityfs already exists\n", __func__);
+		return -EEXIST;
+	}
+
+	aa_fs_dentry = securityfs_create_dir("apparmor", NULL);
+	if (IS_ERR(aa_fs_dentry)) {
+		error = PTR_ERR(aa_fs_dentry);
+		aa_fs_dentry = NULL;
+		goto error;
+	}
+#ifdef CONFIG_SECURITY_APPARMOR_COMPAT_24
+	error = aafs_create("profiles", 0440, &aa_fs_profiles_fops);
+	if (error)
+		goto error;
+	error = aafs_create("matching", 0444, &aa_fs_matching_fops);
+	if (error)
+		goto error;
+	error = aafs_create("features", 0444, &aa_fs_features_fops);
+	if (error)
+		goto error;
+#endif
+	error = aafs_create(".load", 0640, &aa_fs_profile_load);
+	if (error)
+		goto error;
+	error = aafs_create(".replace", 0640, &aa_fs_profile_replace);
+	if (error)
+		goto error;
+	error = aafs_create(".remove", 0640, &aa_fs_profile_remove);
+	if (error)
+		goto error;
+
+	/* TODO: add support for apparmorfs_null and apparmorfs_mnt */
+
+	/* Report that AppArmor fs is enabled */
+	aa_info_message("AppArmor Filesystem Enabled");
+	return 0;
+
+error:
+	aa_destroy_aafs();
+	AA_ERROR("Error creating AppArmor securityfs\n");
+	apparmor_disable();
+	return error;
+}
+
+fs_initcall(aa_create_aafs);
diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
new file mode 100644
index 0000000..177b35b
--- /dev/null
+++ b/security/apparmor/include/apparmorfs.h
@@ -0,0 +1,29 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor filesystem definitions.
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
+#ifndef __AA_APPARMORFS_H
+#define __AA_APPARMORFS_H
+
+extern struct dentry *aa_fs_null;
+extern struct vfsmount *aa_fs_mnt;
+
+extern void aa_destroy_aafs(void);
+
+#ifdef CONFIG_SECURITY_APPARMOR_COMPAT_24
+extern const struct file_operations aa_fs_profiles_fops;
+extern const struct file_operations aa_fs_matching_fops;
+extern const struct file_operations aa_fs_features_fops;
+#endif
+
+#endif /* __AA_APPARMORFS_H */
diff --git a/security/apparmor/include/procattr.h b/security/apparmor/include/procattr.h
new file mode 100644
index 0000000..70f4c8a
--- /dev/null
+++ b/security/apparmor/include/procattr.h
@@ -0,0 +1,26 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor /proc/<pid>/attr/ interface function defintions.
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
+#ifndef __AA_PROCATTR_H
+#define __AA_PROCATTR_H
+
+#define AA_DO_TEST 1
+
+int aa_getprocattr(struct aa_namespace *ns, struct aa_profile *profile,
+		   char **string);
+int aa_setprocattr_changehat(char *args, int test);
+int aa_setprocattr_changeprofile(char *args, int onexec, int test);
+int aa_setprocattr_permipc(char *args);
+
+#endif /* __AA_PROCATTR_H */
diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
new file mode 100644
index 0000000..cba407a
--- /dev/null
+++ b/security/apparmor/procattr.c
@@ -0,0 +1,114 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor /proc/<pid>/attr/ interface functions
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
+#include "include/apparmor.h"
+#include "include/policy.h"
+#include "include/domain.h"
+
+int aa_getprocattr(struct aa_namespace *ns, struct aa_profile *profile,
+		   char **string)
+{
+	char *str;
+	int len = 0;
+
+	if (profile) {
+		int mode_len, name_len, ns_len = 0;
+		const char *mode_str = profile_mode_names[profile->mode];
+		char *s;
+
+		mode_len = strlen(mode_str) + 3;	/* + 3 for _() */
+		name_len = strlen(profile->fqname);
+		if (ns != default_namespace)
+			ns_len = strlen(ns->base.name) + 3; /*+ 3 for :// */
+		len = mode_len + ns_len + name_len + 1;	    /*+ 1 for \n */
+		s = str = kmalloc(len + 1, GFP_ATOMIC);	    /* + 1 \0 */
+		if (!str)
+			return -ENOMEM;
+
+		if (ns_len) {
+			sprintf(s, "%s://", ns->base.name);
+			s += ns_len;
+		}
+		sprintf(s, "%s (%s)\n",profile->fqname, mode_str);
+	} else {
+		const char unconfined_str[] = "unconfined\n";
+
+		len = sizeof(unconfined_str) - 1;	/* - 1 for \0 */
+		if (ns != default_namespace)
+			len += strlen(ns->base.name) + 3; /* + 3 for :// */
+
+		str = kmalloc(len + 1, GFP_ATOMIC);
+		if (!str)
+			return -ENOMEM;
+
+		if (ns != default_namespace)
+			sprintf(str, "%s://%s", ns->base.name, unconfined_str);
+		else
+			memcpy(str, unconfined_str, len);
+	}
+	*string = str;
+
+	/* NOTE: len does not include \0 of string, not saved as part of file */
+	return len;
+}
+
+static char *split_token_from_name(const char *op, char *args, u64 * token)
+{
+	char *name;
+
+	*token = simple_strtoull(args, &name, 16);
+	if ((name == args) || *name != '^') {
+		AA_ERROR("%s: Invalid input '%s'", op, args);
+		return ERR_PTR(-EINVAL);
+	}
+
+	name++;			/* skip ^ */
+	if (!*name)
+		name = NULL;
+	return name;
+}
+
+int aa_setprocattr_changehat(char *args, int test)
+{
+	char *hat;
+	u64 token;
+
+	hat = split_token_from_name("change_hat", args, &token);
+	if (IS_ERR(hat))
+		return PTR_ERR(hat);
+
+	if (!hat && !token) {
+		AA_ERROR("change_hat: Invalid input, NULL hat and NULL magic");
+		return -EINVAL;
+	}
+
+	AA_DEBUG("%s: Magic 0x%llx Hat '%s'\n",
+		 __func__, token, hat ? hat : NULL);
+
+	return aa_change_hat(hat, token, test);
+}
+
+int aa_setprocattr_changeprofile(char *args, int onexec, int test)
+{
+	char *name, *ns_name;
+
+	name = aa_split_name_from_ns(args, &ns_name);
+	return aa_change_profile(ns_name, name, onexec, test);
+}
+
+int aa_setprocattr_permipc(char *args)
+{
+	/* TODO: add ipc permission querying */
+	return -ENOTSUPP;
+}
-- 
1.6.3.3

