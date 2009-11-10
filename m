Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZKJQNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZKJQNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZKJQNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:13:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59843 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbZKJQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:16 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 03/12] AppArmor: contexts used in attaching policy to system objects
Date: Tue, 10 Nov 2009 08:12:56 -0800
Message-Id: <1257869585-7092-4-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AppArmor contexts attach profiles and state to tasks, files, etc. when
a direct profile reference is not sufficient.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/context.c         |  225 +++++++++++++++++++++++++++++++++++
 security/apparmor/include/context.h |  145 ++++++++++++++++++++++
 2 files changed, 370 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/context.c
 create mode 100644 security/apparmor/include/context.h

diff --git a/security/apparmor/context.c b/security/apparmor/context.c
new file mode 100644
index 0000000..823207d
--- /dev/null
+++ b/security/apparmor/context.c
@@ -0,0 +1,225 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor functions used to manipulate object security
+ * contexts.
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
+#include "include/context.h"
+#include "include/policy.h"
+
+struct aa_task_context *aa_alloc_task_context(gfp_t flags)
+{
+	return kzalloc(sizeof(struct aa_task_context), flags);
+}
+
+void aa_free_task_context(struct aa_task_context *cxt)
+{
+	if (cxt) {
+		aa_put_profile(cxt->sys.profile);
+		aa_put_profile(cxt->sys.previous);
+		aa_put_profile(cxt->sys.onexec);
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
+void aa_dup_task_context(struct aa_task_context *new,
+			 const struct aa_task_context *old)
+{
+	*new = *old;
+	aa_get_profile(new->sys.profile);
+	aa_get_profile(new->sys.previous);
+	aa_get_profile(new->sys.onexec);
+}
+
+/**
+ * aa_cred_policy - obtain cred's profiles
+ * @cred: cred to obtain profiles from
+ * @sys: return system profile
+ *
+ * does NOT increment reference count
+ */
+void aa_cred_policy(const struct cred *cred, struct aa_profile **sys)
+{
+	struct aa_task_context *cxt = cred->security;
+	BUG_ON(!cxt);
+	*sys = aa_confining_profile(cxt->sys.profile);
+}
+
+/**
+ * aa_get_task_policy - get the cred with the task policy, and current profiles
+ * @task: task to get policy of
+ * @sys: return - pointer to system profile
+ *
+ * Returns: a refcounted task cred
+ *
+ * Only gets the cred ref count which has ref counts on the profiles returned
+ */
+struct cred *aa_get_task_policy(const struct task_struct *task,
+				struct aa_profile **sys)
+{
+	struct cred *cred = get_task_cred(task);
+	aa_cred_policy(cred, sys);
+	return cred;
+}
+
+/**
+ * replace_group - replace a context group profile
+ * @cgrp: profile
+ * @profile: profile to replace cxt group
+ *
+ * Replace context grouping profile reference with @profile
+ */
+static void replace_group(struct aa_task_cxt_group *cgrp,
+			  struct aa_profile *profile)
+{
+	if (cgrp->profile == profile)
+		return;
+
+	if (!profile || (profile->flags & PFLAG_UNCONFINED) ||
+	    (cgrp->profile && cgrp->profile->ns != profile->ns)) {
+		aa_put_profile(cgrp->previous);
+		aa_put_profile(cgrp->onexec);
+		cgrp->previous = NULL;
+		cgrp->onexec = NULL;
+		cgrp->token = 0;
+	}
+	aa_put_profile(cgrp->profile);
+	cgrp->profile = aa_get_profile(profile);
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
+	struct aa_task_context *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	replace_group(&cxt->sys, sys);
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
+	struct aa_task_context *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	aa_put_profile(cxt->sys.onexec);
+	cxt->sys.onexec = aa_get_profile(sys);
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
+	struct aa_task_context *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	if (!cxt->sys.previous) {
+		cxt->sys.previous = cxt->sys.profile;
+		cxt->sys.token = token;
+	} else if (cxt->sys.token == token) {
+		aa_put_profile(cxt->sys.profile);
+	} else {
+		/* previous_profile && cxt->token != token */
+		abort_creds(new);
+		return -EACCES;
+	}
+	cxt->sys.profile = aa_get_profile(profile);
+	/* clear exec on switching context */
+	aa_put_profile(cxt->sys.onexec);
+	cxt->sys.onexec = NULL;
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
+	struct aa_task_context *cxt;
+	struct cred *new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	cxt = new->security;
+	if (cxt->sys.token != token) {
+		abort_creds(new);
+		return -EACCES;
+	}
+	/* ignore restores when there is no saved profile */
+	if (!cxt->sys.previous) {
+		abort_creds(new);
+		return 0;
+	}
+
+	aa_put_profile(cxt->sys.profile);
+	cxt->sys.profile = aa_profile_newest(cxt->sys.previous);
+	if (unlikely(cxt->sys.profile != cxt->sys.previous)) {
+		aa_get_profile(cxt->sys.profile);
+		aa_put_profile(cxt->sys.previous);
+	}
+	/* clear exec && prev information when restoring to previous context */
+	cxt->sys.previous = NULL;
+	cxt->sys.token = 0;
+	aa_put_profile(cxt->sys.onexec);
+	cxt->sys.onexec = NULL;
+
+	commit_creds(new);
+	return 0;
+}
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
new file mode 100644
index 0000000..ffc83c6
--- /dev/null
+++ b/security/apparmor/include/context.h
@@ -0,0 +1,145 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor contexts used to associate "labels" to objects.
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
+/* struct aa_task_cxt_group - a grouping label data for confined tasks
+ * @profile: the current profile
+ * @exec: profile to transition to on next exec
+ * @previous: profile the task may return to
+ * @token: magic value the task must know for returning to @previous_profile
+ *
+ * Contains the task's current profile (which could change due to
+ * change_hat).  Plus the hat_magic needed during change_hat.
+ */
+struct aa_task_cxt_group {
+	struct aa_profile *profile;
+	struct aa_profile *onexec;
+	struct aa_profile *previous;
+	u64 token;
+};
+
+/**
+ * struct aa_task_context - primary label for confined tasks
+ * @sys: the system labeling for the task
+ *
+ * A task is confined by the intersection of its system and user profiles
+ */
+struct aa_task_context {
+	struct aa_task_cxt_group sys;
+};
+
+struct aa_task_context *aa_alloc_task_context(gfp_t flags);
+void aa_free_task_context(struct aa_task_context *cxt);
+void aa_dup_task_context(struct aa_task_context *new,
+			 const struct aa_task_context *old);
+void aa_cred_policy(const struct cred *cred, struct aa_profile **sys);
+struct cred *aa_get_task_policy(const struct task_struct *task,
+				struct aa_profile **sys);
+int aa_replace_current_profiles(struct aa_profile *sys);
+void aa_put_task_policy(struct cred *cred);
+int aa_set_current_onexec(struct aa_profile *sys);
+int aa_set_current_hat(struct aa_profile *profile, u64 token);
+int aa_restore_previous_profile(u64 cookie);
+
+static inline struct aa_task_context *__aa_task_cxt(struct task_struct *task)
+{
+	return __task_cred(task)->security;
+}
+
+/**
+ * __aa_task_is_confined - determine if @task has any confinement
+ * @task: task to check confinement of
+ *
+ * If @task != current needs to be in RCU safe critical section
+ */
+static inline int __aa_task_is_confined(struct task_struct *task)
+{
+	struct aa_task_context *cxt;
+	int rc = 1;
+
+	cxt = __aa_task_cxt(task);
+	if (!cxt || (cxt->sys.profile->flags & PFLAG_UNCONFINED))
+		rc = 0;
+
+	return rc;
+}
+
+static inline const struct cred *aa_current_policy(struct aa_profile **sys)
+{
+	const struct cred *cred = current_cred();
+	struct aa_task_context *cxt = cred->security;
+	BUG_ON(!cxt);
+	*sys = aa_confining_profile(cxt->sys.profile);
+
+	return cred;
+}
+
+static inline const struct cred *aa_current_policy_wupd(struct aa_profile **sys)
+{
+	const struct cred *cred = current_cred();
+	struct aa_task_context *cxt = cred->security;
+	BUG_ON(!cxt);
+
+	*sys = aa_profile_newest(cxt->sys.profile);
+	if (unlikely((cxt->sys.profile != *sys)))
+		aa_replace_current_profiles(*sys);
+	*sys = aa_filter_profile(*sys);
+
+	return cred;
+}
+
+static inline struct aa_profile *aa_current_profile(void)
+{
+	const struct cred *cred = current_cred();
+	struct aa_task_context *cxt = cred->security;
+	BUG_ON(!cxt);
+	return aa_confining_profile(cxt->sys.profile);
+}
+
+static inline struct aa_profile *aa_current_profile_wupd(void)
+{
+	struct aa_profile *p;
+	aa_current_policy_wupd(&p);
+	return p;
+}
+
+#endif /* __AA_CONTEXT_H */
-- 
1.6.3.3

