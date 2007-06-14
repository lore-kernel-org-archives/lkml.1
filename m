Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbXFNHjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbXFNHjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXFNHjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:39:09 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:37981 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbXFNHjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:39:06 -0400
Message-ID: <4670F087.1090309@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:38:47 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 8/9] File access control functions.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:38:47.0458 (UTC) FILETIME=[0B13C020:01C7AE57]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the main part for profiling and controlling file access.
We thought checking old pathname and new pathname separately
for rename() and link() operation is a too rough access control
and we are checking both pathnames using tomoyo_check_double_write_acl().

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/tomoyo/file.c | 1126 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 1126 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/tomoyo/file.c linux-2.6.21.5-tomoyo/security/tomoyo/file.c
--- linux-2.6.21.5/security/tomoyo/file.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/file.c	2007-06-05 00:00:00.000000000 +0900
@@ -0,0 +1,1126 @@
+/*
+ * security/tomoyo/file.c
+ *
+ * File access control functions for TOMOYO Linux.
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ */
+
+#include "tomoyo.h"
+#include "realpath.h"
+#define ACC_MODE(x) ("\000\004\002\006"[(x)&O_ACCMODE])
+
+/*************************  VARIABLES  *************************/
+
+extern struct semaphore domain_acl_lock;
+
+/***** The structure for globally readable files. *****/
+
+struct globally_readable_file_entry {
+	struct globally_readable_file_entry *next;
+	const struct path_info *filename;
+	int is_deleted;
+};
+
+/***** The structure for filename patterns. *****/
+
+struct pattern_entry {
+	struct pattern_entry *next;
+	const struct path_info *pattern;
+	int is_deleted;
+};
+
+/***** The structure for non-rewritable-by-default file patterns. *****/
+
+struct no_rewrite_entry {
+	struct no_rewrite_entry *next;
+	const struct path_info *pattern;
+	int is_deleted;
+};
+
+/***** The structure for detailed write operations. *****/
+
+static struct {
+	const char *keyword;
+	const int paths;
+	int check_type;
+} acl_type_array[] = { /* mapping.txt */
+	{ "create",   1, 1 }, /* TOMOYO_TYPE_CREATE_ACL */
+	{ "unlink",   1, 1 }, /* TOMOYO_TYPE_UNLINK_ACL */
+	{ "mkdir",    1, 1 }, /* TOMOYO_TYPE_MKDIR_ACL */
+	{ "rmdir",    1, 1 }, /* TOMOYO_TYPE_RMDIR_ACL */
+	{ "mkfifo",   1, 1 }, /* TOMOYO_TYPE_MKFIFO_ACL */
+	{ "mksock",   1, 1 }, /* TOMOYO_TYPE_MKSOCK_ACL */
+	{ "mkblock",  1, 1 }, /* TOMOYO_TYPE_MKBLOCK_ACL */
+	{ "mkchar",   1, 1 }, /* TOMOYO_TYPE_MKCHAR_ACL */
+	{ "truncate", 1, 1 }, /* TOMOYO_TYPE_TRUNCATE_ACL */
+	{ "symlink",  1, 1 }, /* TOMOYO_TYPE_SYMLINK_ACL */
+	{ "link",     2, 1 }, /* TOMOYO_TYPE_LINK_ACL */
+	{ "rename",   2, 1 }, /* TOMOYO_TYPE_RENAME_ACL */
+	{ "rewrite",  1, 1 }, /* TOMOYO_TYPE_REWRITE_ACL */
+	{ NULL, 0, 0 }
+};
+
+/*************************  UTILITY FUNCTIONS  *************************/
+
+const char *tomoyo_acltype2keyword(const unsigned int acl_type)
+{
+	return (acl_type < sizeof(acl_type_array) / sizeof(acl_type_array[0]))
+		? acl_type_array[acl_type].keyword : NULL;
+}
+
+int tomoyo_acltype2paths(const unsigned int acl_type)
+{
+	return (acl_type < sizeof(acl_type_array) / sizeof(acl_type_array[0]))
+		? acl_type_array[acl_type].paths : 0;
+}
+
+static unsigned int tomoyo_check_acl_flags(const unsigned int index)
+{
+	if (index < (sizeof(acl_type_array) / sizeof(acl_type_array[0])) - 1)
+		return acl_type_array[index].check_type;
+	printk("%s: Index %u is out of range. Fix the kernel source.\n", __FUNCTION__, index);
+	return 0;
+}
+
+static int tomoyo_strendswith(const char *name, const char *tail)
+{
+	int len;
+	if (!name || !tail) return 0;
+	len = strlen(name) - strlen(tail);
+	return len >= 0 && strcmp(name + len, tail) == 0;
+}
+
+static struct path_info *tomoyo_get_path(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct path_info_with_data { /* sizeof(struct path_info_with_data) <= PAGE_SIZE */
+		struct path_info head; /* Keep this first, this pointer is passed to tomoyo_free(). */
+		char bariier1[16];
+		char body[TOMOYO_MAX_PATHNAME_LEN];
+		char barrier2[16];
+	} *buf = tomoyo_alloc(sizeof(*buf));
+	if (buf) {
+		int error;
+		if ((error = tomoyo_realpath_from_dentry2(dentry,
+		                                          mnt,
+		                                          buf->body,
+		                                          sizeof(buf->body) - 1)) == 0) {
+			buf->head.name = buf->body;
+			tomoyo_fill_path_info(&buf->head);
+			return &buf->head;
+		}
+		tomoyo_free(buf);
+		buf = NULL;
+		printk("tomoyo_realpath_from_dentry = %d\n", error);
+	}
+	return NULL;
+}
+
+/*************************  PROTOTYPES  *************************/
+
+static int tomoyo_add_double_write_acl(const u8 type,
+                                       const char *filename1,
+                                       const char *filename2,
+                                       struct domain_info * const domain,
+                                       const u8 is_add);
+static int tomoyo_add_single_write_acl(const u8 type,
+                                       const char *filename,
+                                       struct domain_info * const domain,
+                                       const u8 is_add);
+
+/*************************  AUDIT FUNCTIONS  *************************/
+
+static int tomoyo_audit_file_log(const struct path_info *filename,
+                                 const u8 perm,
+                                 const int is_granted)
+{
+	char *buf;
+	int len;
+	len = filename->total_len + 8;
+	if ((buf = tomoyo_init_audit_log(&len)) == NULL) return -ENOMEM;
+	snprintf(buf + strlen(buf), len - strlen(buf) - 1, "%d %s\n", perm, filename->name);
+	return tomoyo_write_audit_log(buf, is_granted);
+}
+
+static int tomoyo_audit_write_log(const char *operation,
+                                  const struct path_info *filename1,
+                                  const struct path_info *filename2,
+                                  const int is_granted)
+{
+	char *buf;
+	int len;
+	len = strlen(operation) + filename1->total_len + (filename2 ? filename2->total_len : 0) + 16;
+	if ((buf = tomoyo_init_audit_log(&len)) == NULL) return -ENOMEM;
+	snprintf(buf + strlen(buf), len - strlen(buf) - 1, "allow_%s %s %s\n",
+	         operation, filename1->name, filename2 ? filename2->name : "");
+	return tomoyo_write_audit_log(buf, is_granted);
+}
+
+/*************************  PERMISSION MAP HANDLER  *************************/
+
+int tomoyo_set_permission_mapping(struct io_buffer *head)
+{
+	int i;
+	char *data = head->write_buf;
+	char *cp = NULL;
+	if ((cp = strchr(data, '=')) == NULL) {
+	out: ;
+		printk("ERROR: Invalid line '%s=%s'\n", data, cp);
+		printk("This line must be one of the following. The first is the default.\n");
+		printk("%s=%s if you want to check this permission using this permission.\n",
+		       data, data);
+		printk("%s=generic-write if you want to check this permission "
+		       "using generic-write permission.\n", data);
+		printk("%s=no-check if you don't want to check this permission.\n", data);
+		return -EINVAL;
+	}
+	*cp++ = '\0';
+	for (i = 0; acl_type_array[i].keyword; i++) {
+		if (strcmp(acl_type_array[i].keyword, data)) continue;
+		if (strcmp(cp, acl_type_array[i].keyword) == 0) acl_type_array[i].check_type = 1;
+		else if (strcmp(cp, "generic-write") == 0) acl_type_array[i].check_type = 0;
+		else if (strcmp(cp, "no-check") == 0) acl_type_array[i].check_type = -1;
+		else goto out;
+		return 0;
+	}
+	printk("WARNING: Unprocessed line '%s=%s'\n", data, cp);
+	return -EINVAL;
+}
+
+int tomoyo_read_permission_mapping(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		int i;
+		for (i = 0; acl_type_array[i].keyword; i++) {
+			tomoyo_io_printf(head,
+			                 "%s=%s\n",
+			                 acl_type_array[i].keyword,
+			                 acl_type_array[i].check_type > 0 ?
+			                 	acl_type_array[i].keyword :
+			                 	acl_type_array[i].check_type == 0 ?
+			                 		"generic-write" : "no-check");
+		}
+		head->read_eof = 1;
+	}
+	return 0;
+}
+
+/*************************  GLOBALLY READABLE FILE HANDLER  *************************/
+
+static struct globally_readable_file_entry *globally_readable_list = NULL;
+
+static int tomoyo_add_globally_readable_entry(const char *filename, const int is_delete)
+{
+	struct globally_readable_file_entry *new_entry, *ptr;
+	static DECLARE_MUTEX(lock);
+	const struct path_info *saved_filename;
+	int error = -ENOMEM;
+	if (!tomoyo_is_correct_path(filename, 1, -1, -1, __FUNCTION__))
+		return -EINVAL; /* No patterns allowed. */
+	if ((saved_filename = tomoyo_save_name(filename)) == NULL) return -ENOMEM;
+	down(&lock);
+	for (ptr = globally_readable_list; ptr; ptr = ptr->next) {
+		if (ptr->filename == saved_filename) {
+			ptr->is_deleted = is_delete;
+			error = 0;
+			goto out;
+		}
+	}
+	if (is_delete) {
+		error = -ENOENT;
+		goto out;
+	}
+	if ((new_entry = tomoyo_alloc_element(sizeof(*new_entry))) == NULL) goto out;
+	new_entry->filename = saved_filename;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = globally_readable_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		globally_readable_list = new_entry;
+	}
+	error = 0;
+ out: ;
+	up(&lock);
+	return error;
+}
+
+static int tomoyo_is_globally_readable_file(const struct path_info *filename)
+{
+	struct globally_readable_file_entry *ptr;
+	for (ptr = globally_readable_list; ptr; ptr = ptr->next) {
+		if (!ptr->is_deleted && !tomoyo_pathcmp(filename, ptr->filename)) return 1;
+	}
+	return 0;
+}
+
+int tomoyo_add_globally_readable_policy(char *filename, const int is_delete)
+{
+	return tomoyo_add_globally_readable_entry(filename, is_delete);
+}
+
+int tomoyo_read_globally_readable_policy(struct io_buffer *head)
+{
+	struct globally_readable_file_entry *ptr = head->read_var2;
+	if (!ptr) ptr = globally_readable_list;
+	while (ptr) {
+		head->read_var2 = ptr;
+		if (!ptr->is_deleted && tomoyo_io_printf(head,
+		                                         TOMOYO_KEYWORD_ALLOW_READ "%s\n",
+		                                         ptr->filename->name))
+			break;
+		ptr = ptr->next;
+	}
+	return ptr ? -ENOMEM : 0;
+}
+
+/*************************  FILE GROUP HANDLER  *************************/
+
+static struct group_entry *group_list = NULL;
+
+static int tomoyo_add_group_entry(const char *group_name,
+                                  const char *member_name,
+                                  const int is_delete)
+{
+	static DECLARE_MUTEX(lock);
+	struct group_entry *new_group, *group;
+	struct group_member *new_member, *member;
+	const struct path_info *saved_group_name, *saved_member_name;
+	int error = -ENOMEM;
+	if (!tomoyo_is_correct_path(group_name, 0, 0, 0, __FUNCTION__) || !group_name[0] ||
+		!tomoyo_is_correct_path(member_name, 0, 0, 0, __FUNCTION__) || !member_name[0])
+			return -EINVAL;
+	if ((saved_group_name = tomoyo_save_name(group_name)) == NULL ||
+		(saved_member_name = tomoyo_save_name(member_name)) == NULL) return -ENOMEM;
+	down(&lock);
+	for (group = group_list; group; group = group->next) {
+		if (saved_group_name != group->group_name) continue;
+		for (member = group->first_member; member; member = member->next) {
+			if (member->member_name == saved_member_name) {
+				member->is_deleted = is_delete;
+				error = 0;
+				goto out;
+			}
+		}
+		break;
+	}
+	if (is_delete) {
+		error = -ENOENT;
+		goto out;
+	}
+	if (!group) {
+		if ((new_group = tomoyo_alloc_element(sizeof(*new_group))) == NULL) goto out;
+		new_group->group_name = saved_group_name;
+		mb(); /* Instead of using spinlock. */
+		if ((group = group_list) != NULL) {
+			while (group->next)
+				group = group->next;
+			group->next = new_group;
+		} else {
+			group_list= new_group;
+		}
+		group = new_group;
+	}
+	if ((new_member = tomoyo_alloc_element(sizeof(*new_member))) == NULL) goto out;
+	new_member->member_name = saved_member_name;
+	mb(); /* Instead of using spinlock. */
+	if ((member = group->first_member) != NULL) {
+		while (member->next)
+			member = member->next;
+		member->next = new_member;
+	} else {
+		group->first_member = new_member;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	return error;
+}
+
+int tomoyo_add_group_policy(char *data, const int is_delete)
+{
+	char *cp = strchr(data, ' ');
+	if (!cp) return -EINVAL;
+	*cp++ = '\0';
+	return tomoyo_add_group_entry(data, cp, is_delete);
+}
+
+static struct group_entry *tomoyo_find_or_assign_new_group(const char *group_name)
+{
+	int i;
+	struct group_entry *group;
+	for (i = 0; i <= 1; i++) {
+		for (group = group_list; group; group = group->next) {
+			if (strcmp(group_name, group->group_name->name) == 0) return group;
+		}
+		if (i == 0) {
+			tomoyo_add_group_entry(group_name, "/", 0);
+			tomoyo_add_group_entry(group_name, "/", 1);
+		}
+	}
+	return NULL;
+}
+
+static int tomoyo_path_matchies_to_group(const struct path_info *pathname,
+                                         const struct group_entry *group,
+                                         const int may_use_pattern)
+{
+	struct group_member *member;
+	for (member = group->first_member; member; member = member->next) {
+		if (member->is_deleted) continue;
+		if (!member->member_name->is_patterned) {
+			if (!tomoyo_pathcmp(pathname, member->member_name)) return 1;
+		} else if (may_use_pattern) {
+			if (tomoyo_path_matches_to_pattern(pathname, member->member_name)) return 1;
+		}
+	}
+	return 0;
+}
+
+int tomoyo_read_group_policy(struct io_buffer *head)
+{
+	struct group_entry *group = head->read_var1;
+	struct group_member *member = head->read_var2;
+	if (!group) group = group_list;
+	while (group) {
+		head->read_var1 = group;
+		if (!member) member = group->first_member;
+		while (member) {
+			head->read_var2 = member;
+			if (!member->is_deleted &&
+			    tomoyo_io_printf(head,
+			                     TOMOYO_KEYWORD_PATH_GROUP "%s %s\n",
+			                     group->group_name->name,
+			                     member->member_name->name))
+				break;
+			member = member->next;
+		}
+		if (member) break;
+		head->read_var2 = NULL;
+		group = group->next;
+	}
+	return group ? -ENOMEM : 0;
+}
+
+/*************************  FILE PATTERN HANDLER  *************************/
+
+static struct pattern_entry *pattern_list = NULL;
+
+static int tomoyo_add_pattern_entry(const char *pattern, const int is_delete)
+{
+	struct pattern_entry *new_entry, *ptr;
+	static DECLARE_MUTEX(lock);
+	const struct path_info *saved_pattern;
+	int error = -ENOMEM;
+	if (!tomoyo_is_correct_path(pattern, 0, 1, 0, __FUNCTION__)) return -EINVAL;
+	if ((saved_pattern = tomoyo_save_name(pattern)) == NULL) return -ENOMEM;
+	down(&lock);
+	for (ptr = pattern_list; ptr; ptr = ptr->next) {
+		if (saved_pattern == ptr->pattern) {
+			ptr->is_deleted = is_delete;
+			error = 0;
+			goto out;
+		}
+	}
+	if (is_delete) {
+		error = -ENOENT;
+		goto out;
+	}
+	if ((new_entry = tomoyo_alloc_element(sizeof(*new_entry))) == NULL) goto out;
+	new_entry->pattern = saved_pattern;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = pattern_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		pattern_list = new_entry;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	return error;
+}
+
+static const struct path_info *tomoyo_get_pattern(const struct path_info *filename)
+{
+	struct pattern_entry *ptr;
+	const struct path_info *pattern = NULL;
+	for (ptr = pattern_list; ptr; ptr = ptr->next) {
+		if (ptr->is_deleted) continue;
+		if (!tomoyo_path_matches_to_pattern(filename, ptr->pattern)) continue;
+		pattern = ptr->pattern;
+		if (tomoyo_strendswith(pattern->name, "/\\*")) {
+			/* Do nothing. Try to find the better match. */
+		} else {
+			/* This would be the better match. Use this. */
+			break;
+		}
+	}
+	if (pattern) filename = pattern;
+	return filename;
+}
+
+int tomoyo_add_pattern_policy(char *pattern, const int is_delete)
+{
+	return tomoyo_add_pattern_entry(pattern, is_delete);
+}
+
+int tomoyo_read_pattern_policy(struct io_buffer *head)
+{
+	struct pattern_entry *ptr = head->read_var2;
+	if (!ptr) ptr = pattern_list;
+	while (ptr) {
+		head->read_var2 = ptr;
+		if (!ptr->is_deleted &&
+		    tomoyo_io_printf(head,
+		                     TOMOYO_KEYWORD_FILE_PATTERN "%s\n",
+		                     ptr->pattern->name))
+			break;
+		ptr = ptr->next;
+	}
+	return ptr ? -ENOMEM : 0;
+}
+
+/*************************  NON REWRITABLE FILE HANDLER  *************************/
+
+static struct no_rewrite_entry *no_rewrite_list = NULL;
+
+static int tomoyo_add_no_rewrite_entry(const char *pattern, const int is_delete)
+{
+	struct no_rewrite_entry *new_entry, *ptr;
+	static DECLARE_MUTEX(lock);
+	const struct path_info *saved_pattern;
+	int error = -ENOMEM;
+	if (!tomoyo_is_correct_path(pattern, 0, 0, 0, __FUNCTION__)) return -EINVAL;
+	if ((saved_pattern = tomoyo_save_name(pattern)) == NULL) return -ENOMEM;
+	down(&lock);
+	for (ptr = no_rewrite_list; ptr; ptr = ptr->next) {
+		if (ptr->pattern == saved_pattern) {
+			ptr->is_deleted = is_delete;
+			error = 0;
+			goto out;
+		}
+	}
+	if (is_delete) {
+		error = -ENOENT;
+		goto out;
+	}
+	if ((new_entry = tomoyo_alloc_element(sizeof(*new_entry))) == NULL) goto out;
+	new_entry->pattern = saved_pattern;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = no_rewrite_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		no_rewrite_list = new_entry;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	return error;
+}
+
+static int tomoyo_is_no_rewrite_file(const struct path_info *filename)
+{
+	struct no_rewrite_entry *ptr;
+	for (ptr = no_rewrite_list; ptr; ptr = ptr->next) {
+		if (ptr->is_deleted) continue;
+		if (!tomoyo_path_matches_to_pattern(filename, ptr->pattern)) continue;
+		return 1;
+	}
+	return 0;
+}
+
+int tomoyo_add_no_rewrite_policy(char *pattern, const int is_delete)
+{
+	return tomoyo_add_no_rewrite_entry(pattern, is_delete);
+}
+
+int tomoyo_read_no_rewrite_policy(struct io_buffer *head)
+{
+	struct no_rewrite_entry *ptr = head->read_var2;
+	if (!ptr) ptr = no_rewrite_list;
+	while (ptr) {
+		head->read_var2 = ptr;
+		if (!ptr->is_deleted &&
+		    tomoyo_io_printf(head,
+		                     TOMOYO_KEYWORD_DENY_REWRITE "%s\n",
+		                     ptr->pattern->name))
+			break;
+		ptr = ptr->next;
+	}
+	return ptr ? -ENOMEM : 0;
+}
+
+/*************************  FILE ACL HANDLER  *************************/
+
+static int tomoyo_add_file_acl(const char *filename,
+                               u8 perm,
+                               struct domain_info * const domain,
+                               const u8 is_add)
+{
+	const struct path_info *saved_filename;
+	struct acl_info *ptr;
+	int error = -ENOMEM;
+	u8 is_group = 0;
+	if (!domain) return -EINVAL;
+	if (perm > 7 || !perm) {
+		printk(KERN_DEBUG "%s: Invalid permission '%d %s'\n", __FUNCTION__, perm, filename);
+		return -EINVAL;
+	}
+	if (!tomoyo_is_correct_path(filename, 0, 0, 0, __FUNCTION__)) return -EINVAL;
+	if (filename[0] == '@') {
+		/* This cast is OK because I don't dereference in this function. */
+		if ((saved_filename =
+			(struct path_info *) tomoyo_find_or_assign_new_group(filename + 1)) == NULL)
+			return -ENOMEM;
+		is_group = 1;
+	} else {
+		if ((saved_filename = tomoyo_save_name(filename)) == NULL) return -ENOMEM;
+		if (!saved_filename->is_dir) {
+			if (perm == 4 &&
+			    tomoyo_is_globally_readable_file(saved_filename) &&
+			    is_add) {
+				return 0;   /* Don't add if the file is globally readable files. */
+			}
+		} else {
+			if ((perm & 2) == 0)
+				return 0; /* Don't add if the directory doesn't have write permission. */
+		}
+	}
+	down(&domain_acl_lock);
+	if (is_add) {
+		if ((ptr = domain->first_acl_ptr) == NULL) goto first_entry;
+		while (1) {
+			struct file_acl_record *new_ptr;
+			if (ptr->type == TOMOYO_TYPE_FILE_ACL) {
+				if (((struct file_acl_record *) ptr)->u.filename == saved_filename) {
+					if (ptr->is_deleted) {
+						ptr->u.b[0] = 0;
+						mb();
+						ptr->is_deleted = 0;
+					}
+					/* Found. Just 'OR' the permission bits. */
+					ptr->u.b[0] |= perm;
+					error = 0;
+					tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_DOMAIN_POLICY);
+					break;
+				}
+			}
+			if (ptr->next) {
+				ptr = ptr->next;
+				continue;
+			}
+	first_entry: ;
+			if (is_add == 1 && tomoyo_too_many_domain_acl(domain)) break;
+			/* Not found. Append it to the tail. */
+			if ((new_ptr = tomoyo_alloc_element(sizeof(*new_ptr))) == NULL) break;
+			new_ptr->head.type = TOMOYO_TYPE_FILE_ACL;
+			new_ptr->head.u.b[0] = perm;
+			new_ptr->head.u.b[1] = is_group;
+			new_ptr->u.filename = saved_filename;
+			error = tomoyo_add_domain_acl(ptr, domain, (struct acl_info *) new_ptr);
+			break;
+		}
+	} else {
+		for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+			if (ptr->type != TOMOYO_TYPE_FILE_ACL ||
+			    ptr->is_deleted ||
+			    ptr->u.b[0] != perm)
+				continue;
+			if (((struct file_acl_record *) ptr)->u.filename != saved_filename) continue;
+			error = tomoyo_del_domain_acl(ptr);
+			break;
+		}
+	}
+	up(&domain_acl_lock);
+	return error;
+}
+
+static int tomoyo_check_file_acl(const struct path_info *filename, const u8 perm)
+{
+	const struct domain_info *domain =
+		((struct tomoyo_security *) current->security)->domain_info;
+	struct acl_info *ptr;
+	const int may_use_pattern = ((perm & 1) == 0);
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	if (!filename->is_dir) {
+		if (perm == 4 && tomoyo_is_globally_readable_file(filename)) return 0;
+	}
+	for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+		if (ptr->type != TOMOYO_TYPE_FILE_ACL ||
+		    ptr->is_deleted ||
+		    (ptr->u.b[0] & perm) != perm)
+			continue;
+		if (ptr->u.b[1]) {
+			if (tomoyo_path_matchies_to_group(filename,
+			                                  ((struct file_acl_record *) ptr)->u.group,
+			                                  may_use_pattern))
+				return 0;
+		} else if (may_use_pattern ||
+		           !((struct file_acl_record *) ptr)->u.filename->is_patterned) {
+			if (tomoyo_path_matches_to_pattern(filename,
+			                                   ((struct file_acl_record *) ptr)->u.filename))
+				return 0;
+		}
+	}
+	return -EPERM;
+}
+
+static int tomoyo_check_file_perm2(const struct path_info *filename, const u8 perm, const char *operation)
+{
+	int error = 0;
+	if (!filename) return 0;
+	error = tomoyo_check_file_acl(filename, perm);
+	tomoyo_audit_file_log(filename, perm, !error);
+	if (error) {
+		struct domain_info * const domain =
+			((struct tomoyo_security *) current->security)->domain_info;
+		const int is_enforce = tomoyo_check_enforce(TOMOYO_MAC_FOR_FILE);
+		if (tomoyo_verbose_mode()) {
+			printk("TOMOYO-%s: Access %d(%s) to %s denied for %s\n",
+			       tomoyo_get_msg(is_enforce), perm, operation,
+			       filename->name, tomoyo_get_last_name(domain));
+		}
+		if (is_enforce) error =
+			tomoyo_check_supervisor("%s\n%d %s\n",
+			                        domain->domainname->name, perm, filename->name);
+		else if (tomoyo_check_accept(TOMOYO_MAC_FOR_FILE)) {
+			/* Don't use patterns if execution bit is on. */
+			const struct path_info *patterned_file =
+				((perm & 1) == 0) ? tomoyo_get_pattern(filename) : filename;
+			tomoyo_add_file_acl(patterned_file->name, perm, domain, 1);
+		}
+		if (!is_enforce) error = 0;
+	}
+	return error;
+}
+
+int tomoyo_add_file_policy(char *data, struct domain_info *domain, const int is_delete)
+{
+	char *filename = strchr(data, ' ');
+	unsigned int perm;
+	u8 type;
+	if (!filename) return -EINVAL;
+	*filename++ = '\0';
+	if (sscanf(data, "%u", &perm) == 1) {
+		return tomoyo_add_file_acl(filename, (u8) perm, domain, is_delete ? 0 : -1);
+	}
+	if (strncmp(data, "allow_", 6)) goto out;
+	data += 6;
+	for (type = 0; acl_type_array[type].keyword; type++) {
+		if (strcmp(data, acl_type_array[type].keyword)) continue;
+		if (acl_type_array[type].paths == 2) {
+			char *filename2 = strchr(filename, ' ');
+			if (!filename2) break;
+			*filename2++ = '\0';
+			return tomoyo_add_double_write_acl(type,
+			                                   filename,
+			                                   filename2,
+			                                   domain,
+			                                   is_delete ? 0 : -1);
+		} else {
+			return tomoyo_add_single_write_acl(type,
+			                                   filename,
+			                                   domain,
+			                                   is_delete ? 0 : -1);
+		}
+		break;
+	}
+ out:
+	return -EINVAL;
+}
+
+static int tomoyo_add_single_write_acl(const u8 type,
+                                       const char *filename,
+                                       struct domain_info * const domain,
+                                       const u8 is_add)
+{
+	const struct path_info *saved_filename;
+	struct acl_info *ptr;
+	int error = -ENOMEM;
+	u8 is_group = 0;
+	if (!domain) return -EINVAL;
+	if (!tomoyo_is_correct_path(filename, 0, 0, 0, __FUNCTION__)) return -EINVAL;
+	if (filename[0] == '@') {
+		/* This cast is OK because I don't dereference in this function. */
+		if ((saved_filename =
+			(struct path_info *) tomoyo_find_or_assign_new_group(filename + 1)) == NULL)
+			return -ENOMEM;
+		is_group = 1;
+	} else {
+		if ((saved_filename = tomoyo_save_name(filename)) == NULL) return -ENOMEM;
+	}
+	down(&domain_acl_lock);
+	if (is_add) {
+		if ((ptr = domain->first_acl_ptr) == NULL) goto first_entry;
+		while (1) {
+			struct single_acl_record *new_ptr;
+			if (ptr->type == type) {
+				if (((struct single_acl_record *) ptr)->u.filename ==
+				    saved_filename) {
+					ptr->is_deleted = 0;
+					/* Found. Nothing to do. */
+					error = 0;
+					break;
+				}
+			}
+			if (ptr->next) {
+				ptr = ptr->next;
+				continue;
+			}
+		first_entry: ;
+			if (is_add == 1 && tomoyo_too_many_domain_acl(domain)) break;
+			/* Not found. Append it to the tail. */
+			if ((new_ptr = tomoyo_alloc_element(sizeof(*new_ptr))) == NULL) break;
+			new_ptr->head.type = type;
+			new_ptr->head.u.w = is_group;
+			new_ptr->u.filename = saved_filename;
+			error = tomoyo_add_domain_acl(ptr, domain, (struct acl_info *) new_ptr);
+			break;
+		}
+	} else {
+		error = -ENOENT;
+		for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+			if (ptr->type != type || ptr->is_deleted) continue;
+			if (((struct single_acl_record *) ptr)->u.filename != saved_filename)
+				continue;
+			error = tomoyo_del_domain_acl(ptr);
+			break;
+		}
+	}
+	up(&domain_acl_lock);
+	return error;
+}
+
+static int tomoyo_add_double_write_acl(const u8 type,
+                                       const char *filename1,
+                                       const char *filename2,
+                                       struct domain_info * const domain,
+                                       const u8 is_add)
+{
+	const struct path_info *saved_filename1, *saved_filename2;
+	struct acl_info *ptr;
+	int error = -ENOMEM;
+	u8 is_group1 = 0, is_group2 = 0;
+	if (!domain) return -EINVAL;
+	if (!tomoyo_is_correct_path(filename1, 0, 0, 0, __FUNCTION__) ||
+	    !tomoyo_is_correct_path(filename2, 0, 0, 0, __FUNCTION__))
+		return -EINVAL;
+	if (filename1[0] == '@') {
+		/* This cast is OK because I don't dereference in this function. */
+		if ((saved_filename1 =
+			(struct path_info *) tomoyo_find_or_assign_new_group(filename1 + 1)) == NULL)
+			return -ENOMEM;
+		is_group1 = 1;
+	} else {
+		if ((saved_filename1 = tomoyo_save_name(filename1)) == NULL) return -ENOMEM;
+	}
+	if (filename2[0] == '@') {
+		/* This cast is OK because I don't dereference in this function. */
+		if ((saved_filename2 =
+			(struct path_info *) tomoyo_find_or_assign_new_group(filename2 + 1)) == NULL)
+			return -ENOMEM;
+		is_group2 = 1;
+	} else {
+		if ((saved_filename2 = tomoyo_save_name(filename2)) == NULL) return -ENOMEM;
+	}
+	down(&domain_acl_lock);
+	if (is_add) {
+		if ((ptr = domain->first_acl_ptr) == NULL) goto first_entry;
+		while (1) {
+			struct double_acl_record *new_ptr;
+			if (ptr->type == type) {
+				if (((struct double_acl_record *) ptr)->u1.filename1 ==
+					saved_filename1 &&
+				    ((struct double_acl_record *) ptr)->u2.filename2 ==
+					saved_filename2) {
+					ptr->is_deleted = 0;
+					/* Found. Nothing to do. */
+					error = 0;
+					break;
+				}
+			}
+			if (ptr->next) {
+				ptr = ptr->next;
+				continue;
+			}
+		first_entry: ;
+			if (is_add == 1 && tomoyo_too_many_domain_acl(domain)) break;
+			/* Not found. Append it to the tail. */
+			if ((new_ptr = tomoyo_alloc_element(sizeof(*new_ptr))) == NULL) break;
+			new_ptr->head.type = type;
+			new_ptr->head.u.b[0] = is_group1;
+			new_ptr->head.u.b[1] = is_group2;
+			new_ptr->u1.filename1 = saved_filename1;
+			new_ptr->u2.filename2 = saved_filename2;
+			error = tomoyo_add_domain_acl(ptr, domain, (struct acl_info *) new_ptr);
+			break;
+		}
+	} else {
+		error = -ENOENT;
+		for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+			if (ptr->type != type || ptr->is_deleted) continue;
+			if (((struct double_acl_record *) ptr)->u1.filename1 != saved_filename1 ||
+				((struct double_acl_record *) ptr)->u2.filename2 != saved_filename2)
+					continue;
+			error = tomoyo_del_domain_acl(ptr);
+			break;
+		}
+	}
+	up(&domain_acl_lock);
+	return error;
+}
+
+static int tomoyo_check_single_write_acl(const u8 type, const struct path_info *filename)
+{
+	const struct domain_info *domain =
+		((struct tomoyo_security *) current->security)->domain_info;
+	struct acl_info *ptr;
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+		if (ptr->type != type || ptr->is_deleted) continue;
+		if (ptr->u.w) {
+			if (!tomoyo_path_matchies_to_group(filename,
+			                                   ((struct single_acl_record *) ptr)->u.group,
+			                                   1))
+				continue;
+		} else {
+			if (!tomoyo_path_matches_to_pattern(filename,
+			                                    ((struct single_acl_record *) ptr)->u.filename))
+				continue;
+		}
+		return 0;
+	}
+	return -EPERM;
+}
+
+static int tomoyo_check_double_write_acl(const u8 type,
+                                         const struct path_info *filename1,
+                                         const struct path_info *filename2)
+{
+	const struct domain_info *domain =
+		((struct tomoyo_security *) current->security)->domain_info;
+	struct acl_info *ptr;
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+		if (ptr->type != type || ptr->is_deleted) continue;
+		if (ptr->u.b[0]) {
+			if (!tomoyo_path_matchies_to_group(filename1,
+			                                   ((struct double_acl_record *) ptr)->u1.group1,
+			                                   1))
+				continue;
+		} else {
+			if (!tomoyo_path_matches_to_pattern(filename1,
+			                                    ((struct double_acl_record *) ptr)->u1.filename1))
+				continue;
+		}
+		if (ptr->u.b[1]) {
+			if (!tomoyo_path_matchies_to_group(filename2,
+			                                   ((struct double_acl_record *) ptr)->u2.group2,
+			                                   1))
+				continue;
+		} else {
+			if (!tomoyo_path_matches_to_pattern(filename2,
+			                                    ((struct double_acl_record *) ptr)->u2.filename2))
+				continue;
+		}
+		return 0;
+	}
+	return -EPERM;
+}
+
+static int tomoyo_check_single_write_permission2(const unsigned int operation,
+                                                 const struct path_info *filename)
+{
+	int error;
+	struct domain_info * const domain =
+		((struct tomoyo_security *) current->security)->domain_info;
+	const int is_enforce = tomoyo_check_enforce(TOMOYO_MAC_FOR_FILE);
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	if (tomoyo_check_acl_flags(operation) < 0) return 0;
+	if (tomoyo_check_acl_flags(operation) > 0) {
+		error = tomoyo_check_single_write_acl(operation, filename);
+		tomoyo_audit_write_log(tomoyo_acltype2keyword(operation), filename, NULL, !error);
+		if (error) {
+			if (tomoyo_verbose_mode()) {
+				printk("TOMOYO-%s: Access '%s %s' denied for %s\n",
+				       tomoyo_get_msg(is_enforce),
+				       tomoyo_acltype2keyword(operation),
+				       filename->name,
+				       tomoyo_get_last_name(domain));
+			}
+			if (is_enforce)
+				error = tomoyo_check_supervisor("%s\nallow_%s %s\n",
+				                                domain->domainname->name,
+				                                tomoyo_acltype2keyword(operation),
+				                                filename->name);
+			else if (tomoyo_check_accept(TOMOYO_MAC_FOR_FILE))
+				tomoyo_add_single_write_acl(operation,
+				                            tomoyo_get_pattern(filename)->name,
+				                            domain,
+				                            1);
+			if (!is_enforce)
+				error = 0;
+		}
+	} else {
+		error = tomoyo_check_file_perm2(filename, 2, tomoyo_acltype2keyword(operation));
+	}
+	if (!error && operation == TOMOYO_TYPE_TRUNCATE_ACL && tomoyo_is_no_rewrite_file(filename)) {
+		error = tomoyo_check_single_write_permission2(TOMOYO_TYPE_REWRITE_ACL, filename);
+	}
+	return error;
+}
+
+int tomoyo_check_exec_perm(const struct path_info *filename, struct file *filp)
+{
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	return tomoyo_check_file_perm2(filename, 1, "do_execve");
+}
+
+int tomoyo_check_open_permission(struct dentry *dentry, struct vfsmount *mnt, const int flag)
+{
+	const int acc_mode = ACC_MODE(flag);
+	int error = -ENOMEM;
+	struct path_info *buf;
+	const int is_enforce = tomoyo_check_enforce(TOMOYO_MAC_FOR_FILE);
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	if (acc_mode == 0) return 0;
+	if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
+		/* I don't check directories here because mkdir() and rmdir() don't call me. */
+		return 0;
+	}
+	buf = tomoyo_get_path(dentry, mnt);
+	if (buf) {
+		error = 0;
+		if ((acc_mode & MAY_WRITE)) {
+			if ((flag & O_TRUNC) || !(flag & O_APPEND)) {
+				if (tomoyo_is_no_rewrite_file(buf)) {
+					error = tomoyo_check_single_write_permission2(TOMOYO_TYPE_REWRITE_ACL,
+					                                              buf);
+				}
+			}
+		}
+		if (error == 0) error = tomoyo_check_file_perm2(buf, acc_mode, "open");
+		if (error == 0 && (flag & O_TRUNC))
+			error = tomoyo_check_single_write_permission2(TOMOYO_TYPE_TRUNCATE_ACL, buf);
+		tomoyo_free(buf);
+	}
+	if (!is_enforce) error = 0;
+	return error;
+}
+
+int tomoyo_check_single_write_permission(const unsigned int operation,
+                                         struct dentry *dentry,
+                                         struct vfsmount *mnt)
+{
+	int error = -ENOMEM;
+	struct path_info *buf;
+	const int is_enforce = tomoyo_check_enforce(TOMOYO_MAC_FOR_FILE);
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	buf = tomoyo_get_path(dentry, mnt);
+	if (buf) {
+		switch (operation) {
+		case TOMOYO_TYPE_MKDIR_ACL:
+		case TOMOYO_TYPE_RMDIR_ACL:
+			if (!buf->is_dir) {
+				strcat((char *) buf->name, "/");
+				tomoyo_fill_path_info(buf);
+			}
+		}
+		error = tomoyo_check_single_write_permission2(operation, buf);
+		tomoyo_free(buf);
+	}
+	if (!is_enforce) error = 0;
+	return error;
+}
+
+int tomoyo_check_rewrite_permission(struct file *filp)
+{
+	int error = -ENOMEM;
+	const int is_enforce = tomoyo_check_enforce(TOMOYO_MAC_FOR_FILE);
+	struct path_info *buf = tomoyo_get_path(filp->f_dentry, filp->f_vfsmnt);
+	if (buf) {
+		if (tomoyo_is_no_rewrite_file(buf)) {
+			error = tomoyo_check_single_write_permission2(TOMOYO_TYPE_REWRITE_ACL, buf);
+		} else {
+			error = 0;
+		}
+		tomoyo_free(buf);
+	}
+	if (!is_enforce) error = 0;
+	return error;
+}
+
+int tomoyo_check_double_write_permission(const unsigned int operation,
+                                         struct dentry *dentry1,
+                                         struct vfsmount *mnt1,
+                                         struct dentry *dentry2,
+                                         struct vfsmount *mnt2)
+{
+	int error = -ENOMEM;
+	struct path_info *buf1, *buf2;
+	struct domain_info * const domain =
+		((struct tomoyo_security *) current->security)->domain_info;
+	const int is_enforce = tomoyo_check_enforce(TOMOYO_MAC_FOR_FILE);
+	if (!tomoyo_check_flags(TOMOYO_MAC_FOR_FILE)) return 0;
+	if (tomoyo_check_acl_flags(operation) < 0) return 0;		
+	buf1 = tomoyo_get_path(dentry1, mnt1);
+	buf2 = tomoyo_get_path(dentry2, mnt2);
+	if (buf1 && buf2) {
+		if (operation == TOMOYO_TYPE_RENAME_ACL) {
+			/* TOMOYO_TYPE_LINK_ACL can't reach here for directory. */
+			if (dentry1->d_inode && S_ISDIR(dentry1->d_inode->i_mode)) {
+				if (!buf1->is_dir) {
+					strcat((char *) buf1->name, "/");
+					tomoyo_fill_path_info(buf1);
+				}
+				if (!buf2->is_dir) {
+					strcat((char *) buf2->name, "/");
+					tomoyo_fill_path_info(buf2);
+				}
+			}
+		}
+		if (tomoyo_check_acl_flags(operation) > 0) {
+			error = tomoyo_check_double_write_acl(operation, buf1, buf2);
+			tomoyo_audit_write_log(tomoyo_acltype2keyword(operation), buf1, buf2, !error);
+			if (error) {
+				if (tomoyo_verbose_mode()) {
+					printk("TOMOYO-%s: Access '%s %s %s' denied for %s\n",
+					       tomoyo_get_msg(is_enforce),
+					       tomoyo_acltype2keyword(operation),
+					       buf1->name,
+					       buf2->name,
+					       tomoyo_get_last_name(domain));
+				}
+				if (is_enforce)
+					error = tomoyo_check_supervisor("%s\nallow_%s %s %s\n",
+					                                domain->domainname->name,
+					                                tomoyo_acltype2keyword(operation),
+					                                buf1->name,
+					                                buf2->name);
+				else if (tomoyo_check_accept(TOMOYO_MAC_FOR_FILE))
+					tomoyo_add_double_write_acl(operation,
+					                            tomoyo_get_pattern(buf1)->name,
+					                            tomoyo_get_pattern(buf2)->name,
+					                            domain,
+					                            1);
+			}
+		} else {
+			error = tomoyo_check_file_perm2(buf1, 2, tomoyo_acltype2keyword(operation));
+			if (!error)
+				error = tomoyo_check_file_perm2(buf2,
+				                                2,
+				                                tomoyo_acltype2keyword(operation));
+		}
+	}
+	tomoyo_free(buf1);
+	tomoyo_free(buf2);
+	if (!is_enforce) error = 0;
+	return error;
+}
---------------

