Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0BSJhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:37:19 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43923 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0BSJhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:37:09 -0500
From: john.johansen@canonical.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 08/12] AppArmor: file enforcement routines
Date: Fri, 19 Feb 2010 01:36:24 -0800
Message-Id: <1266572188-26529-9-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

AppArmor does files enforcement via pathname matching.  Matching is done
at file open using a dfa match engine.  Permission is against the final
file object not parent directories, ie. the traversal of directories
as part of the file match is implicitly allowed.  In the case of nonexistant
files (creation) permissions are checked against the target file not the
directory.  eg. In case of creating the file /dir/new, permissions are
checked against the match /dir/new not against /dir/.

The permissions for matches are currently stored in the dfa accept table,
but this will change to allow for dfa reuse and also to allow for sharing
of wider accept states.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/file.c         |  453 ++++++++++++++++++++++++++++++++++++++
 security/apparmor/include/file.h |  224 +++++++++++++++++++
 2 files changed, 677 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/file.c
 create mode 100644 security/apparmor/include/file.h

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
new file mode 100644
index 0000000..c4d04ef
--- /dev/null
+++ b/security/apparmor/file.c
@@ -0,0 +1,453 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor mediation of files
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include "include/apparmor.h"
+#include "include/audit.h"
+#include "include/file.h"
+#include "include/match.h"
+#include "include/path.h"
+#include "include/policy.h"
+
+struct file_perms nullperms;
+
+static void aa_audit_file_sub_mask(char *buffer, u16 mask, u16 xindex)
+{
+	char *m = buffer;
+
+	if (mask & AA_EXEC_MMAP)
+		*m++ = 'm';
+	if (mask & MAY_READ)
+		*m++ = 'r';
+	if (mask & (MAY_WRITE | AA_MAY_CREATE | AA_MAY_DELETE | AA_MAY_CHMOD |
+		    AA_MAY_CHOWN))
+		*m++ = 'w';
+	else if (mask & MAY_APPEND)
+		*m++ = 'a';
+	if (mask & AA_MAY_LINK)
+		*m++ = 'l';
+	if (mask & AA_MAY_LOCK)
+		*m++ = 'k';
+	if (mask & MAY_EXEC)
+		*m++ = 'x';
+	*m++ = '\0';
+}
+
+static void aa_audit_file_mask(struct audit_buffer *ab, u16 mask, int xindex,
+			       int owner)
+{
+	char str[10];
+
+	if (owner) {
+		aa_audit_file_sub_mask(str, mask, xindex);
+		strcat(str, "::");
+	} else {
+		strcpy(str, "::");
+		aa_audit_file_sub_mask(str + 2, mask, xindex);
+	}
+	audit_log_string(ab, str);
+}
+
+static void file_audit_cb(struct audit_buffer *ab, struct aa_audit *va)
+{
+	struct aa_audit_file *sa = container_of(va, struct aa_audit_file, base);
+	u16 denied = sa->request & ~sa->perms.allowed;
+	uid_t fsuid;
+
+	if (sa->base.task)
+		fsuid = task_uid(sa->base.task);
+	else
+		fsuid = current_fsuid();
+
+	if (sa->request & AA_AUDIT_FILE_MASK) {
+		audit_log_format(ab, " requested_mask=");
+		aa_audit_file_mask(ab, sa->request, AA_X_NONE,
+				   fsuid == sa->cond->uid);
+	}
+	if (denied & AA_AUDIT_FILE_MASK) {
+		audit_log_format(ab, " denied_mask=");
+		aa_audit_file_mask(ab, denied, sa->perms.xindex,
+				   fsuid == sa->cond->uid);
+	}
+	if (sa->request & AA_AUDIT_FILE_MASK) {
+		audit_log_format(ab, " fsuid=%d", fsuid);
+		audit_log_format(ab, " ouid=%d", sa->cond->uid);
+	}
+
+	if (sa->name) {
+		audit_log_format(ab, " name=");
+		audit_log_untrustedstring(ab, sa->name);
+	}
+
+	if (sa->name2) {
+		audit_log_format(ab, " name2=");
+		audit_log_untrustedstring(ab, sa->name2);
+	}
+
+	if (sa->name3) {
+		audit_log_format(ab, " name3=");
+		audit_log_untrustedstring(ab, sa->name3);
+	}
+}
+
+/**
+ * aa_audit_file - handle the auditing of file operations
+ * @profile: the profile being enforced
+ * @sa: file auditing context
+ *
+ * Returns: error on failure
+ */
+int aa_audit_file(struct aa_profile *profile, struct aa_audit_file *sa)
+{
+	int type = AUDIT_APPARMOR_AUTO;
+
+	if (likely(!sa->base.error)) {
+		u16 mask = sa->perms.audit;
+
+		if (unlikely(AUDIT_MODE(profile) == AUDIT_ALL))
+			mask = 0xffff;
+
+		/* mask off perms that are not being force audited */
+		sa->request &= mask;
+
+		if (likely(!sa->request))
+			return 0;
+		type = AUDIT_APPARMOR_AUDIT;
+	} else {
+		/* only report permissions that were denied */
+		sa->request = sa->request & ~sa->perms.allowed;
+
+		if (sa->request & sa->perms.kill)
+			type = AUDIT_APPARMOR_KILL;
+
+		/* quiet known rejects, assumes quiet and kill do not overlap */
+		if ((sa->request & sa->perms.quiet) &&
+		    AUDIT_MODE(profile) != AUDIT_NOQUIET &&
+		    AUDIT_MODE(profile) != AUDIT_ALL)
+			sa->request &= ~sa->perms.quiet;
+
+		if (!sa->request)
+			return COMPLAIN_MODE(profile) ? 0 : sa->base.error;
+	}
+	return aa_audit(type, profile, &sa->base, file_audit_cb);
+}
+
+/* TODO: convert from dfa + state to permission entry */
+static struct file_perms aa_compute_perms(struct aa_dfa *dfa,
+					  unsigned int state,
+					  struct path_cond *cond)
+{
+	struct file_perms perms;
+
+	/* FIXME: change over to new dfa format
+	 * currently file perms are encoded in the dfa, new format
+	 * splits the permissions from the dfa.  This mapping can be
+	 * done at profile load
+	 */
+	perms.kill = 0;
+	perms.dindex = 0;
+
+	if (current_fsuid() == cond->uid) {
+		perms.allowed = dfa_user_allow(dfa, state);
+		perms.audit = dfa_user_audit(dfa, state);
+		perms.quiet = dfa_user_quiet(dfa, state);
+		perms.xindex = dfa_user_xindex(dfa, state);
+	} else {
+		perms.allowed = dfa_other_allow(dfa, state);
+		perms.audit = dfa_other_audit(dfa, state);
+		perms.quiet = dfa_other_quiet(dfa, state);
+		perms.xindex = dfa_other_xindex(dfa, state);
+	}
+	/* in the old mapping MAY_WRITE implies
+	 * AA_MAY_CREATE | AA_MAY_CHMOD | AA_MAY_CHOWN */
+	if (perms.allowed & MAY_WRITE)
+		perms.allowed |= AA_MAY_CREATE | AA_MAY_CHMOD | AA_MAY_CHOWN |
+			AA_MAY_DELETE;
+	if (perms.audit & MAY_WRITE)
+		perms.audit |= AA_MAY_CREATE | AA_MAY_CHMOD | AA_MAY_CHOWN |
+			AA_MAY_DELETE;
+	if (perms.quiet & MAY_WRITE)
+		perms.quiet |= AA_MAY_CREATE | AA_MAY_CHMOD | AA_MAY_CHOWN |
+			AA_MAY_DELETE;
+
+	/* in the old mapping AA_MAY_LOCK and link subset are overlayed
+	 * and only determined by which part of a pair they are  in
+	 */
+	if (perms.allowed & AA_MAY_LOCK)
+		perms.allowed |= AA_LINK_SUBSET;
+
+	/* change_profile wasn't determined by ownership in old mapping */
+	if (ACCEPT_TABLE(dfa)[state] & 0x80000000)
+		perms.allowed |= AA_MAY_CHANGE_PROFILE;
+
+	return perms;
+}
+
+struct file_perms aa_str_perms(struct aa_dfa *dfa, unsigned int start,
+			       const char *name, struct path_cond *cond,
+			       unsigned int *rstate)
+{
+	unsigned int state;
+	if (!dfa)
+		return nullperms;
+
+	state = aa_dfa_match(dfa, start, name);
+
+	if (rstate)
+		*rstate = state;
+
+	/* TODO: convert to new dfa format */
+
+	return aa_compute_perms(dfa, state, cond);
+}
+
+int aa_pathstr_perm(struct aa_profile *profile, const char *op,
+		    const char *name, u16 request, struct path_cond *cond)
+{
+	struct aa_audit_file sa = {
+		.base.operation = op,
+		.base.gfp_mask = GFP_KERNEL,
+		.request = request,
+		.name = name,
+		.cond = cond,
+	};
+
+	sa.perms = aa_str_perms(profile->file.dfa, profile->file.start, sa.name,
+				cond,
+				NULL);
+	if (request & ~sa.perms.allowed)
+		sa.base.error = -EACCES;
+	return aa_audit_file(profile, &sa);
+}
+
+int aa_path_perm(struct aa_profile *profile, const char *operation,
+		 struct path *path, u16 request, struct path_cond *cond)
+{
+	char *buffer, *name;
+	struct aa_audit_file sa = {
+		.base.operation = operation,
+		.base.gfp_mask = GFP_KERNEL,
+		.request = request,
+		.cond = cond,
+	};
+	int flags = profile->path_flags |
+		(S_ISDIR(cond->mode) ? PATH_IS_DIR : 0);
+	/* buffer freed below - name is pointer inside buffer */
+	sa.base.error = aa_get_name(path, flags, &buffer, &name);
+	sa.name = name;
+	if (sa.base.error) {
+		sa.perms = nullperms;
+		if (sa.base.error == -ENOENT)
+			sa.base.info = "Failed name lookup - deleted entry";
+		else if (sa.base.error == -ESTALE)
+			sa.base.info = "Failed name lookup - disconnected path";
+		else if (sa.base.error == -ENAMETOOLONG)
+			sa.base.info = "Failed name lookup - name too long";
+		else
+			sa.base.info = "Failed name lookup";
+	} else {
+		sa.perms = aa_str_perms(profile->file.dfa, profile->file.start,
+					sa.name, cond, NULL);
+		if (request & ~sa.perms.allowed)
+			sa.base.error = -EACCES;
+	}
+	sa.base.error = aa_audit_file(profile, &sa);
+	kfree(buffer);
+
+	return sa.base.error;
+}
+
+/* helper for aa_path_link - test target xindex == OR subset of link xindex */
+static inline bool xindex_is_subset(u16 link, u16 target)
+{
+	if (((link & ~AA_X_UNSAFE) != (target & ~AA_X_UNSAFE)) ||
+	    ((link & AA_X_UNSAFE) && !(target & AA_X_UNSAFE)))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * aa_path_link - Handle hard link permission check
+ * @profile: the profile being enforced
+ * @old_dentry: the target dentry
+ * @new_dir: directory the new link will be created in
+ * @new_dentry: the link being created
+ *
+ * Handle the permission test for a link & target pair.  Permission
+ * is encoded as a pair where the link permission is determined
+ * first, and if allowed, the target is tested.  The target test
+ * is done from the point of the link match (not start of DFA)
+ * making the target permission dependent on the link permission match.
+ *
+ * The subset test if required forces that permissions granted
+ * on link are a subset of the permission granted to target.
+ */
+int aa_path_link(struct aa_profile *profile, struct dentry *old_dentry,
+		 struct path *new_dir, struct dentry *new_dentry)
+{
+	struct path link = { new_dir->mnt, new_dentry };
+	struct path target = { new_dir->mnt, old_dentry };
+	struct path_cond cond = {
+		old_dentry->d_inode->i_uid,
+		old_dentry->d_inode->i_mode
+	};
+	char *buffer = NULL, *buffer2 = NULL;
+	char *lname, *tname;
+	struct file_perms perms;
+	unsigned int state;
+
+	struct aa_audit_file sa = {
+		.base.operation = "link",
+		.base.gfp_mask = GFP_KERNEL,
+		.request = AA_MAY_LINK,
+		.cond = &cond,
+		.perms = nullperms,
+	};
+	/* buffer freed below, lname is pointer in buffer */
+	sa.base.error = aa_get_name(&link, profile->path_flags, &buffer,
+				    &lname);
+	sa.name = lname;
+	if (sa.base.error)
+		goto audit;
+
+	/* buffer2 freed below, tname is pointer in buffer2 */
+	sa.base.error = aa_get_name(&target, profile->path_flags, &buffer2,
+				    &tname);
+	sa.name2 = tname;
+	if (sa.base.error)
+		goto audit;
+
+	sa.base.error = -EACCES;
+
+	/* aa_str_perms - handles the case of the dfa being NULL */
+	sa.perms = aa_str_perms(profile->file.dfa, profile->file.start, lname,
+				&cond, &state);
+	sa.perms.audit &= AA_MAY_LINK;
+	sa.perms.quiet &= AA_MAY_LINK;
+	sa.perms.kill &= AA_MAY_LINK;
+
+	if (!(sa.perms.allowed & AA_MAY_LINK))
+		goto audit;
+
+	/* test to see if target can be paired with link */
+	state = aa_dfa_null_transition(profile->file.dfa, state,
+				       profile->flags & PFLAG_OLD_NULL_TRANS);
+	perms = aa_str_perms(profile->file.dfa, state, tname, &cond, NULL);
+	if (!(perms.allowed & AA_MAY_LINK)) {
+		sa.base.info = "target restricted";
+		goto audit;
+	}
+
+	/* done if link subset test is not required */
+	if (!(perms.allowed & AA_LINK_SUBSET))
+		goto done_tests;
+
+	/* Do link perm subset test requiring allowed permission on link are a
+	 * subset of the allowed permissions on target.
+	 */
+	perms = aa_str_perms(profile->file.dfa, profile->file.start, tname,
+			     &cond, NULL);
+
+	/* AA_MAY_LINK is not considered in the subset test */
+	sa.request = sa.perms.allowed & ~AA_MAY_LINK;
+	sa.perms.allowed &= perms.allowed | AA_MAY_LINK;
+
+	sa.request |= AA_AUDIT_FILE_MASK & (sa.perms.allowed & ~perms.allowed);
+	if (sa.request & ~sa.perms.allowed) {
+		goto audit;
+	} else if ((sa.perms.allowed & MAY_EXEC) &&
+		   !xindex_is_subset(sa.perms.xindex, perms.xindex)) {
+		sa.perms.allowed &= ~MAY_EXEC;
+		sa.request |= MAY_EXEC;
+		sa.base.info = "link not subset of target";
+		goto audit;
+	}
+
+done_tests:
+	sa.base.error = 0;
+
+audit:
+	sa.base.error = aa_audit_file(profile, &sa);
+	kfree(buffer);
+	kfree(buffer2);
+
+	return sa.base.error;
+}
+
+static inline bool aa_is_deleted_file(struct dentry *dentry)
+{
+	if (d_unlinked(dentry) && dentry->d_inode->i_nlink == 0)
+		return 1;
+	return 0;
+}
+
+static int aa_file_common_perm(struct aa_profile *profile,
+			       const char *operation, struct file *file,
+			       u16 request, const char *name, int error)
+{
+	struct path_cond cond = {
+		.uid = file->f_path.dentry->d_inode->i_uid,
+		.mode = file->f_path.dentry->d_inode->i_mode
+	};
+	struct aa_audit_file sa = {
+		.base.operation = operation,
+		.base.gfp_mask = GFP_KERNEL,
+		.request = request,
+		.base.error = error,
+		.name = name,
+		.cond = &cond,
+	};
+
+	if (sa.base.error) {
+		sa.perms = nullperms;
+		if (sa.base.error == -ENOENT &&
+		    aa_is_deleted_file(file->f_path.dentry)) {
+			/* Access to open files that are deleted are
+			 * give a pass (implicit delegation)
+			 */
+			sa.base.error = 0;
+			sa.perms.allowed = sa.request;
+		} else if (sa.base.error == -ENOENT)
+			sa.base.info = "Failed name lookup - deleted entry";
+		else if (sa.base.error == -ESTALE)
+			sa.base.info = "Failed name lookup - disconnected path";
+		else if (sa.base.error == -ENAMETOOLONG)
+			sa.base.info = "Failed name lookup - name too long";
+		else
+			sa.base.info = "Failed name lookup";
+	} else {
+		sa.perms = aa_str_perms(profile->file.dfa, profile->file.start,
+					sa.name, &cond, NULL);
+		if (request & ~sa.perms.allowed)
+			sa.base.error = -EACCES;
+	}
+	sa.base.error = aa_audit_file(profile, &sa);
+
+	return sa.base.error;
+}
+
+int aa_file_perm(struct aa_profile *profile, const char *operation,
+		 struct file *file, u16 request)
+{
+	char *buffer, *name;
+	umode_t mode = file->f_path.dentry->d_inode->i_mode;
+	/* buffer freed below, name is a pointer inside of buffer */
+	int flags = profile->path_flags | (S_ISDIR(mode) ? PATH_IS_DIR : 0);
+	int error = aa_get_name(&file->f_path, flags, &buffer, &name);
+
+	error = aa_file_common_perm(profile, operation, file, request, name,
+				    error);
+	kfree(buffer);
+	return error;
+}
diff --git a/security/apparmor/include/file.h b/security/apparmor/include/file.h
new file mode 100644
index 0000000..47ac4c7
--- /dev/null
+++ b/security/apparmor/include/file.h
@@ -0,0 +1,224 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor file mediation function definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009-2010 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_FILE_H
+#define __AA_FILE_H
+
+#include <linux/path.h>
+
+#include "audit.h"
+#include "domain.h"
+#include "match.h"
+
+struct aa_profile;
+
+/*
+ * We use MAY_EXEC, MAY_WRITE, MAY_READ, MAY_APPEND and the following flags
+ * for profile permissions
+ */
+#define AA_MAY_LINK			0x0010
+#define AA_MAY_LOCK			0x0020
+#define AA_EXEC_MMAP			0x0040
+
+#define AA_MAY_CREATE			0x0080
+#define AA_MAY_DELETE			0x0100
+#define AA_MAY_CHMOD			0x0200
+#define AA_MAY_CHOWN			0x0400
+
+#define AA_LINK_SUBSET			0x0800
+#define AA_MAY_CHANGEHAT		0x2000	/* ctrl auditing only */
+#define AA_MAY_ONEXEC			0x4000	/* exec allows onexec */
+#define AA_MAY_CHANGE_PROFILE		0x8000
+
+#define AA_AUDIT_FILE_MASK	(MAY_READ | MAY_WRITE | MAY_EXEC | MAY_APPEND |\
+				 AA_MAY_LINK | AA_MAY_LOCK | AA_EXEC_MMAP | \
+				 AA_MAY_CREATE | AA_MAY_DELETE | AA_MAY_CHMOD |\
+				 AA_MAY_CHOWN)
+
+/*
+ * The xindex is broken into 3 parts
+ * - index - an index into either the exec name table or the variable table
+ * - exec type - which determines how the executable name and index are used
+ * - flags - which modify how the destination name is applied
+ */
+#define AA_X_INDEX_MASK		0x03ff
+
+#define AA_X_TYPE_MASK		0x0c00
+#define AA_X_TYPE_SHIFT		10
+#define AA_X_NONE		0x0000
+#define AA_X_NAME		0x0400	/* use executable name px */
+#define AA_X_TABLE		0x0800	/* use a specified name ->n# */
+
+#define AA_X_UNSAFE		0x1000
+#define AA_X_CHILD		0x2000	/* make >AA_X_NONE apply to children */
+#define AA_X_INHERIT		0x4000
+#define AA_X_UNCONFINED		0x8000
+
+/* AA_SECURE_X_NEEDED - is passed in the bprm->unsafe field */
+#define AA_SECURE_X_NEEDED	0x8000
+
+/* need to conditionalize which ones are being set */
+struct path_cond {
+	uid_t uid;
+	umode_t mode;
+};
+
+/* struct file_perms - file permission fo
+ * @allowed: mask of permissions that are allowed
+ * @audit: mask of permissions to force an audit message for
+ * @quiet: mask of permissions to quiet audit messages for
+ * @kill: mask of permissions that when matched will kill the task
+ * @xindex: exec transition index if @allowed contains MAY_EXEC
+ * @xdelegate: used by exec to determine set of delegates allowed
+ * @dindex: delegate table index, 0 if no delegation allowed
+ *
+ * The @audit and @queit mask should be mutually exclusive.
+ */
+struct file_perms {
+	u16 allowed;
+	u16 audit;
+	u16 quiet;
+	u16 kill;
+	u16 xindex;
+	u16 xdelegate;
+	u16 dindex;
+};
+
+extern struct file_perms nullperms;
+
+#define COMBINED_PERM_MASK(X) ((X).allowed | (X).audit | (X).quiet | (X).kill)
+
+/* FIXME: split perms from dfa and match this to description
+ *        also add delegation info.
+ */
+static inline u16 dfa_map_xindex(u16 mask)
+{
+	u16 old_index = (mask >> 10) & 0xf;
+	u16 index = 0;
+
+	if (mask & 0x100)
+		index |= AA_X_UNSAFE;
+	if (mask & 0x200)
+		index |= AA_X_INHERIT;
+	if (mask & 0x80)
+		index |= AA_X_UNCONFINED;
+
+	if (old_index == 1) {
+		index |= AA_X_UNCONFINED;
+	} else if (old_index == 2) {
+		index |= AA_X_NAME;
+	} else if (old_index == 3) {
+		index |= AA_X_NAME | AA_X_CHILD;
+	} else {
+		index |= AA_X_TABLE;
+		index |= old_index - 4;
+	}
+
+	return index;
+}
+
+/*
+ * map old dfa inline permissions to new format
+ */
+#define dfa_user_allow(dfa, state) ((ACCEPT_TABLE(dfa)[state]) & 0x7f)
+#define dfa_user_audit(dfa, state) ((ACCEPT_TABLE2(dfa)[state]) & 0x7f)
+#define dfa_user_quiet(dfa, state) (((ACCEPT_TABLE2(dfa)[state]) >> 7) & 0x7f)
+#define dfa_user_xindex(dfa, state) \
+	(dfa_map_xindex(ACCEPT_TABLE(dfa)[state] & 0x3fff))
+
+#define dfa_other_allow(dfa, state) (((ACCEPT_TABLE(dfa)[state]) >> 14) & 0x7f)
+#define dfa_other_audit(dfa, state) (((ACCEPT_TABLE2(dfa)[state]) >> 14) & 0x7f)
+#define dfa_other_quiet(dfa, state) \
+	((((ACCEPT_TABLE2(dfa)[state]) >> 7) >> 14) & 0x7f)
+#define dfa_other_xindex(dfa, state) \
+	dfa_map_xindex((ACCEPT_TABLE(dfa)[state] >> 14) & 0x3fff)
+
+struct aa_audit_file {
+	struct aa_audit base;
+
+	const char *name;
+	const char *name2;
+	const char *name3;
+	struct file_perms perms;
+	u16 request;
+	struct path_cond *cond;
+};
+
+int aa_audit_file(struct aa_profile *profile, struct aa_audit_file *sa);
+
+/**
+ * struct aa_file_rules - components used for file rule permissions
+ * @dfa: dfa to match path names and conditionals against
+ * @perms: permission table indexed by the matched state accept entry of @dfa
+ * @trans: transition table for indexed by named x transitions
+ *
+ * File permission are determined by matching a path against @dfa and then
+ * then using the value of the accept entry for the matching state as
+ * an index into @perms.  If a named exec transition is required it is
+ * looked up in the transition table.
+ */
+struct aa_file_rules {
+	unsigned int start;
+	struct aa_dfa *dfa;
+	/* struct perms perms; */
+	struct aa_domain trans;
+	/* TODO: add delegate table */
+};
+
+struct file_perms aa_str_perms(struct aa_dfa *dfa, unsigned int start,
+			       const char *name, struct path_cond *cond,
+			       unsigned int *rstate);
+
+int aa_pathstr_perm(struct aa_profile *profile, const char *op,
+		    const char *name, u16 request, struct path_cond *cond);
+
+int aa_path_perm(struct aa_profile *profile, const char *operation,
+		 struct path *path, u16 request, struct path_cond *cond);
+
+int aa_path_link(struct aa_profile *profile, struct dentry *old_dentry,
+		 struct path *new_dir, struct dentry *new_dentry);
+
+int aa_file_perm(struct aa_profile *profile, const char *operation,
+		 struct file *file, u16 request);
+
+static inline void aa_free_file_rules(struct aa_file_rules *rules)
+{
+	aa_put_dfa(rules->dfa);
+	aa_free_domain_entries(&rules->trans);
+}
+
+#define ACC_FMODE(x) (("\000\004\002\006"[(x)&O_ACCMODE]) | (((x) << 1) & 0x40))
+
+/* from namei.c */
+#define MAP_OPEN_FLAGS(x) ((((x) + 1) & O_ACCMODE) ? (x) + 1 : (x))
+/*
+ * map file flags to AppArmor permissions
+ */
+static inline u16 aa_map_file_to_perms(struct file *file)
+{
+	int flags = MAP_OPEN_FLAGS(file->f_flags);
+	u16 perms = ACC_FMODE(file->f_mode);
+
+	if ((flags & O_APPEND) && (perms & MAY_WRITE))
+		perms = (perms & ~MAY_WRITE) | MAY_APPEND;
+	/* trunc implies write permission */
+	if (flags & O_TRUNC)
+		perms |= MAY_WRITE;
+	if (flags & O_CREAT)
+		perms |= AA_MAY_CREATE;
+
+	return perms;
+}
+
+#endif /* __AA_FILE_H */
-- 
1.6.6.1

