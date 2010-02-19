Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0BSJj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:39:28 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43699 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0BSJgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:36:51 -0500
From: john.johansen@canonical.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 03/12] AppArmor contexts attach profiles and state to tasks, files, etc. when a direct profile reference is not sufficient.
Date: Fri, 19 Feb 2010 01:36:19 -0800
Message-Id: <1266572188-26529-4-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/context.c         |  195 +++++++++++++++++++++++++++++++++++
 security/apparmor/include/context.h |  142 +++++++++++++++++++++++++
 2 files changed, 337 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/context.c
 create mode 100644 security/apparmor/include/context.h

diff --git a/security/apparmor/context.c b/security/apparmor/context.c
new file mode 100644
index 0000000..c2901af
--- /dev/null
+++ b/security/apparmor/context.c
@@ -0,0 +1,195 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor functions used to manipulate object security
+ * contexts.
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
+#include "include/context.h"
+#include "include/policy.h"
+
+struct aa_task_cxt *aa_alloc_task_context(gfp_t flags)
+{
+	return kzalloc(sizeof(struct aa_task_cxt), flags);
+}
+
+void aa_free_task_context(struct aa_task_cxt *cxt)
+{
+	if (cxt) {
+		aa_put_profile(cxt->profile);
+		aa_put_profile(cxt->previous);
+		aa_put_profile(cxt->onexec);
+
+		kzfree(cxt);
+	}
+}
+
+/**
+ * aa_dup_task_context - duplicate a task context, incrementing reference counts
+ * @new: a blank task context
+ * @old: the task context to copy
+ */
+void aa_dup_task_context(struct aa_task_cxt *new, const struct aa_task_cxt *old)
+{
+	*new = *old;
+	aa_get_profile(new->profile);
+	aa_get_profile(new->previous);
+	aa_get_profile(new->onexec);
+}
+
+/**
+ * replace_cxt - replace a context profile
+ * @cxt: task context
+ * @profile: profile to replace cxt group
+ *
+ * Replace context grouping profile reference with @profile
+ */
+static void replace_group(struct aa_task_cxt *cxt, struct aa_profile *profile)
+{
+	if (cxt->profile == profile)
+		return;
+
+	BUG_ON(!profile);
+	if (unconfined(profile) || (cxt->profile->ns != profile->ns)) {
+		/* if switching to unconfined or a different profile namespace
+		 * clear out context state
+		 */
+		aa_put_profile(cxt->previous);
+		aa_put_profile(cxt->onexec);
+		cxt->previous = NULL;
+		cxt->onexec = NULL;
+		cxt->token = 0;
+	}
+	aa_put_profile(cxt->profile);
+	cxt->profile = aa_get_profile(profile);
+}
+
+/**
+ * aa_replace_current_profiles - replace the current tasks profiles
+ * @sys: new system profile
+ *
+ * Returns: error on failure
+ */
+int aa_replace_current_profiles(struct aa_profile *sys)
+{
+	struct aa_task_cxt *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	replace_group(cxt, sys);
+	/* todo add user group */
+
+	commit_creds(new);
+	return 0;
+}
+
+/**
+ * aa_set_current_onexec - set the tasks change_profile to happen onexec
+ * @sys: system profile to set at exec
+ *
+ * Returns: error on failure
+ */
+int aa_set_current_onexec(struct aa_profile *sys)
+{
+	struct aa_task_cxt *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	aa_put_profile(cxt->onexec);
+	cxt->onexec = aa_get_profile(sys);
+
+	commit_creds(new);
+	return 0;
+}
+
+/**
+ * aa_set_current_hat - set the current tasks hat
+ * @profile: profile to set as the current hat
+ * @token: token value that must be specified to change from the hat
+ *
+ * Do switch of tasks hat.  If the task is currently in a hat
+ * validate the token to match.
+ *
+ * Returns: error on failure
+ */
+int aa_set_current_hat(struct aa_profile *profile, u64 token)
+{
+	struct aa_task_cxt *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	if (!cxt->previous) {
+		cxt->previous = cxt->profile;
+		cxt->token = token;
+	} else if (cxt->token == token) {
+		aa_put_profile(cxt->profile);
+	} else {
+		/* previous_profile && cxt->token != token */
+		abort_creds(new);
+		return -EACCES;
+	}
+	cxt->profile = aa_get_profile(aa_newest_version(profile));
+	/* clear exec on switching context */
+	aa_put_profile(cxt->onexec);
+	cxt->onexec = NULL;
+
+	commit_creds(new);
+	return 0;
+}
+
+/**
+ * aa_restore_previous_profile - exit from hat context restoring the profile
+ * @token: the token that must be matched to exit hat context
+ *
+ * Attempt to return out of a hat to the previous profile.  The token
+ * must match the stored token value.
+ *
+ * Returns: error of failure
+ */
+int aa_restore_previous_profile(u64 token)
+{
+	struct aa_task_cxt *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	if (cxt->token != token) {
+		abort_creds(new);
+		return -EACCES;
+	}
+	/* ignore restores when there is no saved profile */
+	if (!cxt->previous) {
+		abort_creds(new);
+		return 0;
+	}
+
+	aa_put_profile(cxt->profile);
+	cxt->profile = aa_newest_version(cxt->previous);
+	if (unlikely(cxt->profile != cxt->previous)) {
+		aa_get_profile(cxt->profile);
+		aa_put_profile(cxt->previous);
+	}
+	/* clear exec && prev information when restoring to previous context */
+	cxt->previous = NULL;
+	cxt->token = 0;
+	aa_put_profile(cxt->onexec);
+	cxt->onexec = NULL;
+
+	commit_creds(new);
+	return 0;
+}
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
new file mode 100644
index 0000000..8b53cf1
--- /dev/null
+++ b/security/apparmor/include/context.h
@@ -0,0 +1,142 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor contexts used to associate "labels" to objects.
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
+#ifndef __AA_CONTEXT_H
+#define __AA_CONTEXT_H
+
+#include <linux/cred.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+#include "policy.h"
+
+/* struct aa_file_cxt - the AppArmor context the file was opened in
+ * @profile: the profile the file was opened under
+ * @perms: the permission the file was opened with
+ */
+struct aa_file_cxt {
+	struct aa_profile *profile;
+	u16 allowed;
+};
+
+static inline struct aa_file_cxt *aa_alloc_file_context(gfp_t gfp)
+{
+	return kzalloc(sizeof(struct aa_file_cxt), gfp);
+}
+
+static inline void aa_free_file_context(struct aa_file_cxt *cxt)
+{
+	aa_put_profile(cxt->profile);
+	kzfree(cxt);
+}
+
+/**
+ * struct aa_task_cxt - primary label for confined tasks
+ * @profile: the current profile
+ * @exec: profile to transition to on next exec
+ * @previous: profile the task may return to
+ * @token: magic value the task must know for returning to @previous_profile
+ *
+ * Contains the task's current profile (which could change due to
+ * change_hat).  Plus the hat_magic needed during change_hat.
+ *
+ * TODO: make so a task can be confined by a stack of contexts
+ */
+struct aa_task_cxt {
+	struct aa_profile *profile;
+	struct aa_profile *onexec;
+	struct aa_profile *previous;
+	u64 token;
+};
+
+struct aa_task_cxt *aa_alloc_task_context(gfp_t flags);
+void aa_free_task_context(struct aa_task_cxt *cxt);
+void aa_dup_task_context(struct aa_task_cxt *new,
+			 const struct aa_task_cxt *old);
+int aa_replace_current_profiles(struct aa_profile *sys);
+int aa_set_current_onexec(struct aa_profile *sys);
+int aa_set_current_hat(struct aa_profile *profile, u64 token);
+int aa_restore_previous_profile(u64 cookie);
+
+/**
+ * __aa_task_is_confined - determine if @task has any confinement
+ * @task: task to check confinement of
+ *
+ * If @task != current needs to be called in RCU safe critical section
+ */
+static inline bool __aa_task_is_confined(struct task_struct *task)
+{
+	struct aa_task_cxt *cxt = __task_cred(task)->security;
+
+	BUG_ON(!cxt);
+	if (unconfined(aa_newest_version(cxt->profile)))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * aa_cred_profile - obtain cred's profiles
+ * @cred: cred to obtain profiles from
+ *
+ * Returns: system confining profile
+ *
+ * does NOT increment reference count
+ */
+static inline struct aa_profile *aa_cred_profile(const struct cred *cred)
+{
+	struct aa_task_cxt *cxt = cred->security;
+	BUG_ON(!cxt);
+	return aa_newest_version(cxt->profile);
+}
+
+/**
+ * __aa_current_profile - find the current tasks confining profile
+ *
+ * Returns: up to date confining profile or NULL if task is unconfined
+ *
+ * This fn will not update the tasks cred to the most up to date version
+ * of the profile so it is safe to call when inside of locks.
+ */
+static inline struct aa_profile *__aa_current_profile(void)
+{
+	return aa_cred_profile(current_cred());
+}
+
+/**
+ * aa_current_profile - find the current tasks confining profile and do updates
+ *
+ * Returns: up to date confinging profile or NULL if task is unconfined
+ *
+ * This fn will update the tasks cred structure if the profile has been
+ * replaced.  Not safe to call inside locks
+ */
+static inline struct aa_profile *aa_current_profile(void)
+{
+	const struct aa_task_cxt *cxt = current_cred()->security;
+	struct aa_profile *profile;
+	BUG_ON(!cxt);
+
+	profile = aa_newest_version(cxt->profile);
+	/*
+	 * Whether or not replacement succeeds, use newest profile so
+	 * there is no need to update it after replacement.
+	 */
+	if (unlikely((cxt->profile != profile)))
+		aa_replace_current_profiles(profile);
+
+	return profile;
+}
+
+#endif /* __AA_CONTEXT_H */
-- 
1.6.6.1

