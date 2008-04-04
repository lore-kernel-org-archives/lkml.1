Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbYDDM56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbYDDM56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYDDMzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:55:06 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63784 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757745AbYDDMys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:54:48 -0400
Message-Id: <20080404122406.189810363@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:23:05 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 23/30] argvrestriction part.
Content-Disposition: inline; filename=tomoyo-argv0-restriction-part.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file controls argv[0] passed to execve().

Multi call binary programs (e.g. busybox) behave differently depending on
the invocation name (a.k.a. argv[0]).
Thus, to prevent attackers from abusing multi call binary programs,
TOMOYO checks the combination of filename and argv[0] passed to execve().

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 fs/tomoyo_exec.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 203 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/fs/tomoyo_exec.c
@@ -0,0 +1,203 @@
+/*
+ * fs/tomoyo_exec.c
+ *
+ * Implementation of the Domain-Based Mandatory Access Control.
+ *
+ * Copyright (C) 2005-2008  NTT DATA CORPORATION
+ *
+ * Version: 1.6.0   2008/04/01
+ *
+ */
+
+#include <linux/ccs_common.h>
+#include <linux/tomoyo.h>
+#include <linux/realpath.h>
+
+/**
+ * audit_argv0_log - Audit argv[0] log.
+ *
+ * @filename:   The fullpath of program.
+ * @argv0:      The basename of argv[0].
+ * @is_granted: True if this is a granted log.
+ * @profile:    Profile number used.
+ * @mode:       Access control mode used.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int audit_argv0_log(const struct path_info *filename, const char *argv0,
+			   const bool is_granted, const u8 profile,
+			   const u8 mode)
+{
+	char *buf;
+	int len;
+	int len2;
+	if (ccs_can_save_audit_log(is_granted) < 0)
+		return -ENOMEM;
+	len = filename->total_len + strlen(argv0) + 64;
+	buf = ccs_init_audit_log(&len, profile, mode, NULL);
+	if (!buf)
+		return -ENOMEM;
+	len2 = strlen(buf);
+	snprintf(buf + len2, len - len2 - 1,
+		 KEYWORD_ALLOW_ARGV0 "%s %s\n", filename->name, argv0);
+	return ccs_write_audit_log(buf, is_granted);
+}
+
+/**
+ * update_argv0_entry - Update "struct argv0_acl_record" list.
+ *
+ * @filename:  The fullpath of the program.
+ * @argv0:     The basename of argv[0].
+ * @domain:    Pointer to "struct domain_info".
+ * @condition: Pointer to "struct condition_list". May be NULL.
+ * @is_delete: True if it is a delete request.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int update_argv0_entry(const char *filename, const char *argv0,
+			      struct domain_info *domain,
+			      const struct condition_list *condition,
+			      const bool is_delete)
+{
+	struct acl_info *ptr;
+	struct argv0_acl_record *acl;
+	const struct path_info *saved_filename;
+	const struct path_info *saved_argv0;
+	int error = -ENOMEM;
+	if (!ccs_is_correct_path(filename, 1, 0, -1, __func__) ||
+	    !ccs_is_correct_path(argv0, -1, 0, -1, __func__) ||
+	    strchr(argv0, '/'))
+		return -EINVAL;
+	saved_filename = ccs_save_name(filename);
+	saved_argv0 = ccs_save_name(argv0);
+	if (!saved_filename || !saved_argv0)
+		return -ENOMEM;
+	mutex_lock(&domain_acl_lock);
+	if (is_delete)
+		goto delete;
+	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
+		if (ccs_acl_type1(ptr) != TYPE_ARGV0_ACL)
+			continue;
+		if (ccs_get_condition_part(ptr) != condition)
+			continue;
+		acl = container_of(ptr, struct argv0_acl_record, head);
+		if (acl->filename != saved_filename ||
+		    acl->argv0 != saved_argv0)
+			continue;
+		error = ccs_add_domain_acl(NULL, ptr);
+		goto out;
+	}
+	/* Not found. Append it to the tail. */
+	acl = ccs_alloc_acl_element(TYPE_ARGV0_ACL, condition);
+	if (!acl)
+		goto out;
+	acl->filename = saved_filename;
+	acl->argv0 = saved_argv0;
+	error = ccs_add_domain_acl(domain, &acl->head);
+	goto out;
+ delete:
+	error = -ENOENT;
+	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
+		if (ccs_acl_type2(ptr) != TYPE_ARGV0_ACL)
+			continue;
+		if (ccs_get_condition_part(ptr) != condition)
+			continue;
+		acl = container_of(ptr, struct argv0_acl_record, head);
+		if (acl->filename != saved_filename ||
+		    acl->argv0 != saved_argv0)
+			continue;
+		error = ccs_del_domain_acl(ptr);
+		break;
+	}
+ out:
+	mutex_unlock(&domain_acl_lock);
+	return error;
+}
+
+/**
+ * check_argv0_acl - Check permission for argv[0].
+ *
+ * @filename: The fullpath of the program.
+ * @argv0:    The basename of argv[0].
+ *
+ * Returns 0 on success, -EPERM otherwise.
+ */
+static int check_argv0_acl(const struct path_info *filename, const char *argv0)
+{
+	const struct domain_info *domain = current->domain_info;
+	int error = -EPERM;
+	struct acl_info *ptr;
+	struct path_info argv_0;
+	argv_0.name = argv0;
+	ccs_fill_path_info(&argv_0);
+	list1_for_each_entry(ptr, &domain->acl_info_list, list) {
+		struct argv0_acl_record *acl;
+		if (ccs_acl_type2(ptr) != TYPE_ARGV0_ACL)
+			continue;
+		acl = container_of(ptr, struct argv0_acl_record, head);
+		if (!ccs_check_condition(ptr, NULL) ||
+		    !ccs_path_matches_pattern(filename, acl->filename) ||
+		    !ccs_path_matches_pattern(&argv_0, acl->argv0))
+			continue;
+		ccs_update_condition(ptr);
+		error = 0;
+		break;
+	}
+	return error;
+}
+
+/**
+ * ccs_check_argv0_perm - Check permission for argv[0].
+ *
+ * @filename: The fullpath of the program.
+ * @argv0:    The basename of argv[0].
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+int ccs_check_argv0_perm(const struct path_info *filename, const char *argv0)
+{
+	int error = 0;
+	struct domain_info * const domain = current->domain_info;
+	const u8 profile = domain->profile;
+	const u8 mode = ccs_check_flags(CCS_TOMOYO_MAC_FOR_ARGV0);
+	const bool is_enforce = (mode == 3);
+	if (!filename || !argv0 || !*argv0)
+		return 0;
+	error = check_argv0_acl(filename, argv0);
+	audit_argv0_log(filename, argv0, !error, profile, mode);
+	if (!error)
+		return 0;
+	if (ccs_verbose_mode())
+		printk(KERN_WARNING "TOMOYO-%s: Run %s as %s denied for %s\n",
+		       ccs_get_msg(is_enforce), filename->name, argv0,
+		       ccs_get_last_name(domain));
+	if (is_enforce)
+		return ccs_check_supervisor("%s\n"
+					    KEYWORD_ALLOW_ARGV0 "%s %s\n",
+					    domain->domainname->name,
+					    filename->name, argv0);
+	if (mode == 1 && ccs_check_domain_quota(domain))
+		update_argv0_entry(filename->name, argv0, domain, NULL, false);
+	return 0;
+}
+
+/**
+ * ccs_write_argv0_policy - Write "struct argv0_acl_record" list.
+ *
+ * @data:      String to parse.
+ * @domain:    Pointer to "struct domain_info".
+ * @condition: Pointer to "struct condition_list". May be NULL.
+ * @is_delete: True if it is a delete request.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+int ccs_write_argv0_policy(char *data, struct domain_info *domain,
+			   const struct condition_list *condition,
+			   const bool is_delete)
+{
+	char *argv0 = strchr(data, ' ');
+	if (!argv0)
+		return -EINVAL;
+	*argv0++ = '\0';
+	return update_argv0_entry(data, argv0, domain, condition, is_delete);
+}

-- 
