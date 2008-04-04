Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbYDDM4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbYDDM4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYDDMy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:54:56 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63726 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbYDDMys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:54:48 -0400
Message-Id: <20080404122404.191981507@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:23:00 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 18/30] pivot_root restriction part.
Content-Disposition: inline; filename=tomoyo-pivot_root-restriction-part.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file controls pivot_root() requests.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 fs/sakura_pivot.c |  185 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/fs/sakura_pivot.c
@@ -0,0 +1,185 @@
+/*
+ * fs/sakura_pivot.c
+ *
+ * Implementation of the Domain-Free Mandatory Access Control.
+ *
+ * Copyright (C) 2005-2008  NTT DATA CORPORATION
+ *
+ * Version: 1.6.0   2008/04/01
+ *
+ */
+
+#include <linux/ccs_common.h>
+#include <linux/sakura.h>
+#include <linux/realpath.h>
+#include <linux/namei.h>
+
+/* Structure for "allow_pivot_root" keyword. */
+struct pivot_root_entry {
+	struct list1_head list;
+	const struct path_info *old_root;
+	const struct path_info *new_root;
+	bool is_deleted;
+};
+
+/* The list for "struct pivot_root_entry". */
+static LIST1_HEAD(pivot_root_list);
+
+/**
+ * update_pivot_root_acl - Update "struct pivot_root_entry" list.
+ *
+ * @old_root:  The name of old root directory.
+ * @new_root:  The name of new root directory.
+ * @is_delete: True if it is a delete request.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int update_pivot_root_acl(const char *old_root, const char *new_root,
+				 const bool is_delete)
+{
+	struct pivot_root_entry *new_entry;
+	struct pivot_root_entry *ptr;
+	const struct path_info *saved_old_root;
+	const struct path_info *saved_new_root;
+	static DEFINE_MUTEX(lock);
+	int error = -ENOMEM;
+	if (!ccs_is_correct_path(old_root, 1, 0, 1, __func__) ||
+	    !ccs_is_correct_path(new_root, 1, 0, 1, __func__))
+		return -EINVAL;
+	saved_old_root = ccs_save_name(old_root);
+	saved_new_root = ccs_save_name(new_root);
+	if (!saved_old_root || !saved_new_root)
+		return -ENOMEM;
+	mutex_lock(&lock);
+	list1_for_each_entry(ptr, &pivot_root_list, list) {
+		if (ptr->old_root != saved_old_root ||
+		    ptr->new_root != saved_new_root)
+			continue;
+		ptr->is_deleted = is_delete;
+		error = 0;
+		goto out;
+	}
+	if (is_delete) {
+		error = -ENOENT;
+		goto out;
+	}
+	new_entry = ccs_alloc_element(sizeof(*new_entry));
+	if (!new_entry)
+		goto out;
+	new_entry->old_root = saved_old_root;
+	new_entry->new_root = saved_new_root;
+	list1_add_tail_mb(&new_entry->list, &pivot_root_list);
+	error = 0;
+	printk(KERN_CONT "%sAllow pivot_root(%s, %s)\n", ccs_log_level,
+	       new_root, old_root);
+ out:
+	mutex_unlock(&lock);
+	ccs_update_counter(CCS_UPDATES_COUNTER_SYSTEM_POLICY);
+	return error;
+}
+
+/**
+ * ccs_check_pivot_root_permission - Check permission for pivot_root().
+ *
+ * @old_nd: Pointer to "struct nameidata".
+ * @new_nd: Pointer to "struct nameidata".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+int ccs_check_pivot_root_permission(struct nameidata *old_nd,
+				    struct nameidata *new_nd)
+{
+	int error = -EPERM;
+	char *old_root, *new_root;
+	const u8 mode = ccs_check_flags(CCS_SAKURA_RESTRICT_PIVOT_ROOT);
+	if (!mode)
+		return 0;
+	old_root = ccs_realpath_from_dentry(old_nd->path.dentry,
+					    old_nd->path.mnt);
+	new_root = ccs_realpath_from_dentry(new_nd->path.dentry,
+					    new_nd->path.mnt);
+	if (old_root && new_root) {
+		struct path_info old_root_dir, new_root_dir;
+		old_root_dir.name = old_root;
+		ccs_fill_path_info(&old_root_dir);
+		new_root_dir.name = new_root;
+		ccs_fill_path_info(&new_root_dir);
+		if (old_root_dir.is_dir && new_root_dir.is_dir) {
+			struct pivot_root_entry *ptr;
+			list1_for_each_entry(ptr, &pivot_root_list, list) {
+				if (ptr->is_deleted)
+					continue;
+				if (!ccs_path_matches_pattern(&old_root_dir,
+							      ptr->old_root) ||
+				    !ccs_path_matches_pattern(&new_root_dir,
+							      ptr->new_root))
+					continue;
+				error = 0;
+				break;
+			}
+		}
+	}
+	if (error) {
+		const bool is_enforce = (mode == 3);
+		const char *exename = ccs_get_exe();
+		printk(KERN_WARNING "SAKURA-%s: pivot_root %s %s "
+		       "(pid=%d:exe=%s): Permission denied.\n",
+		       ccs_get_msg(is_enforce), new_root, old_root,
+		       current->pid, exename);
+		if (is_enforce)
+			error = ccs_check_supervisor("# %s is requesting\n"
+						     "pivot_root %s %s\n",
+						     exename, new_root,
+						     old_root);
+		else
+			error = 0;
+		if (exename)
+			ccs_free(exename);
+		if (mode == 1 && old_root && new_root)
+			update_pivot_root_acl(old_root, new_root, 0);
+	}
+	ccs_free(old_root);
+	ccs_free(new_root);
+	return error;
+}
+
+/**
+ * ccs_write_pivot_root_policy - Write "struct pivot_root_entry" list.
+ *
+ * @data:      String to parse.
+ * @is_delete: True if it is a delete request.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+int ccs_write_pivot_root_policy(char *data, const bool is_delete)
+{
+	char *cp = strchr(data, ' ');
+	if (!cp)
+		return -EINVAL;
+	*cp++ = '\0';
+	return update_pivot_root_acl(cp, data, is_delete);
+}
+
+/**
+ * ccs_read_pivot_root_policy - Read "struct pivot_root_entry" list.
+ *
+ * @head: Pointer to "struct ccs_io_buffer".
+ *
+ * Returns true on success, false otherwise.
+ */
+bool ccs_read_pivot_root_policy(struct ccs_io_buffer *head)
+{
+	struct list1_head *pos;
+	list1_for_each_cookie(pos, head->read_var2, &pivot_root_list) {
+		struct pivot_root_entry *ptr;
+		ptr = list1_entry(pos, struct pivot_root_entry, list);
+		if (ptr->is_deleted)
+			continue;
+		if (!ccs_io_printf(head, KEYWORD_ALLOW_PIVOT_ROOT "%s %s\n",
+				   ptr->new_root->name, ptr->old_root->name))
+			goto out;
+	}
+	return true;
+ out:
+	return false;
+}

-- 
