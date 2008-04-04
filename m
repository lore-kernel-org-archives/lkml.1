Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbYDDMzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbYDDMzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbYDDMys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:54:48 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63550 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbYDDMyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:54:46 -0400
Message-Id: <20080404122403.412679998@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:22:58 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 16/30] Unmount restriction part.
Content-Disposition: inline; filename=tomoyo-unmount-restriction-part.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some partitions such as /proc/ /sys/ should not be unmounted
for proper operation.

This file forbids unmount operation for specified directory.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 fs/sakura_umount.c |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/fs/sakura_umount.c
@@ -0,0 +1,157 @@
+/*
+ * fs/sakura_umount.c
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
+#include <linux/mount.h>
+
+/* Structure for "deny_unmount" keyword. */
+struct no_umount_entry {
+	struct list1_head list;
+	const struct path_info *dir;
+	bool is_deleted;
+};
+
+/* The list for "struct no_umount_entry". */
+static LIST1_HEAD(no_umount_list);
+
+/**
+ * update_no_umount_acl - Update "struct no_umount_entry" list.
+ *
+ * @dir:       The name of directrory.
+ * @is_delete: True if it is a delete request.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int update_no_umount_acl(const char *dir, const bool is_delete)
+{
+	struct no_umount_entry *new_entry;
+	struct no_umount_entry *ptr;
+	const struct path_info *saved_dir;
+	static DEFINE_MUTEX(lock);
+	int error = -ENOMEM;
+	if (!ccs_is_correct_path(dir, 1, 0, 1, __func__))
+		return -EINVAL;
+	saved_dir = ccs_save_name(dir);
+	if (!saved_dir)
+		return -ENOMEM;
+	mutex_lock(&lock);
+	list1_for_each_entry(ptr, &no_umount_list, list) {
+		if (ptr->dir != saved_dir)
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
+	new_entry->dir = saved_dir;
+	list1_add_tail_mb(&new_entry->list, &no_umount_list);
+	error = 0;
+	printk(KERN_CONT "%sDon't allow umount %s\n", ccs_log_level, dir);
+ out:
+	mutex_unlock(&lock);
+	ccs_update_counter(CCS_UPDATES_COUNTER_SYSTEM_POLICY);
+	return error;
+}
+
+/**
+ * ccs_may_umount - Check permission for unmount.
+ *
+ * @mnt: Pointer to "struct vfsmount".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+int ccs_may_umount(struct vfsmount *mnt)
+{
+	int error = -EPERM;
+	const char *dir0;
+	const u8 mode = ccs_check_flags(CCS_SAKURA_RESTRICT_UNMOUNT);
+	const bool is_enforce = (mode == 3);
+	struct no_umount_entry *ptr;
+	struct path_info dir;
+	bool found = false;
+	if (!mode)
+		return 0;
+	dir0 = ccs_realpath_from_dentry(mnt->mnt_root, mnt);
+	if (!dir0)
+		goto out;
+	dir.name = dir0;
+	ccs_fill_path_info(&dir);
+	list1_for_each_entry(ptr, &no_umount_list, list) {
+		if (ptr->is_deleted)
+			continue;
+		if (!ccs_path_matches_pattern(&dir, ptr->dir))
+			continue;
+		found = true;
+		break;
+	}
+	if (found) {
+		const char *exename = ccs_get_exe();
+		printk(KERN_WARNING "SAKURA-%s: umount %s "
+		       "(pid=%d:exe=%s): Permission denied.\n",
+		       ccs_get_msg(is_enforce), dir0, current->pid,
+		       exename);
+		if (is_enforce)
+			error = ccs_check_supervisor("# %s is requesting\n"
+						     "unmount %s\n",
+						     exename, dir0);
+		ccs_free(exename);
+	}
+	ccs_free(dir0);
+ out:
+	if (!is_enforce)
+		error = 0;
+	return error;
+}
+
+/**
+ * ccs_write_no_umount_policy - Write "struct no_umount_entry" list.
+ *
+ * @data:      String to parse.
+ * @is_delete: True if it is a delete request.
+ *
+ * Returns 0 on sucess, negative value otherwise.
+ */
+int ccs_write_no_umount_policy(char *data, const bool is_delete)
+{
+	return update_no_umount_acl(data, is_delete);
+}
+
+/**
+ * ccs_read_no_umount_policy - Read "struct no_umount_entry" list.
+ *
+ * @head: Pointer to "struct ccs_io_buffer".
+ *
+ * Returns true on success, false otherwise.
+ */
+bool ccs_read_no_umount_policy(struct ccs_io_buffer *head)
+{
+	struct list1_head *pos;
+	list1_for_each_cookie(pos, head->read_var2, &no_umount_list) {
+		struct no_umount_entry *ptr;
+		ptr = list1_entry(pos, struct no_umount_entry, list);
+		if (ptr->is_deleted)
+			continue;
+		if (!ccs_io_printf(head, KEYWORD_DENY_UNMOUNT "%s\n",
+				   ptr->dir->name))
+			goto out;
+	}
+	return true;
+ out:
+	return false;
+}

-- 
