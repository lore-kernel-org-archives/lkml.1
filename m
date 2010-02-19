Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab0BSJih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:38:37 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43953 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab0BSJhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:37:13 -0500
From: john.johansen@canonical.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 09/12] AppArmor ipc, rlimit, network and capability routines
Date: Fri, 19 Feb 2010 01:36:25 -0800
Message-Id: <1266572188-26529-10-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

ipc:
AppArmor ipc is currently limited to mediation done by file mediation
and basic ptrace tests.  Improved mediation is a wip.

rlimits:
AppArmor provides basic abilities to set and control rlimits at
a per profile level.  Only resources specified in a profile are controled
or set.  AppArmor rules set the hard limit to a value <= to the current
hard limit (ie. they can not currently raise hard limits), and if
necessary will lower the soft limit to the new hard limit value.

AppArmor does not track resource limits to reset them when a profile
is left so that children processes inherit the limits set by the
parent even if they are not confined by the same profile.

net:
AppArmor net mediation is currently a per profile basic net toggle, at
the protocol level, ie. tcp, udp, raw.

More advanced network rules are a wip.

Capabilities:  AppArmor provides a per profile mask of capabilities,
that will further restrict.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/capability.c         |  122 +++++++++++++++++++++++++++
 security/apparmor/include/capability.h |   45 ++++++++++
 security/apparmor/include/ipc.h        |   28 ++++++
 security/apparmor/include/net.h        |   40 +++++++++
 security/apparmor/include/resource.h   |   45 ++++++++++
 security/apparmor/ipc.c                |  101 ++++++++++++++++++++++
 security/apparmor/net.c                |  145 ++++++++++++++++++++++++++++++++
 security/apparmor/resource.c           |  104 +++++++++++++++++++++++
 8 files changed, 630 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/capability.c
 create mode 100644 security/apparmor/include/capability.h
 create mode 100644 security/apparmor/include/ipc.h
 create mode 100644 security/apparmor/include/net.h
 create mode 100644 security/apparmor/include/resource.h
 create mode 100644 security/apparmor/ipc.c
 create mode 100644 security/apparmor/net.c
 create mode 100644 security/apparmor/resource.c

diff --git a/security/apparmor/capability.c b/security/apparmor/capability.c
new file mode 100644
index 0000000..f45b891
--- /dev/null
+++ b/security/apparmor/capability.c
@@ -0,0 +1,122 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor capability mediation functions
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
+#include <linux/capability.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+
+#include "include/apparmor.h"
+#include "include/capability.h"
+#include "include/context.h"
+#include "include/policy.h"
+#include "include/audit.h"
+
+/*
+ * Table of capability names: we generate it from capabilities.h.
+ */
+#include "capability_names.h"
+
+struct audit_cache {
+	struct task_struct *task;
+	kernel_cap_t caps;
+};
+
+static DEFINE_PER_CPU(struct audit_cache, audit_cache);
+
+struct aa_audit_caps {
+	struct aa_audit base;
+
+	int cap;
+};
+
+static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
+{
+	struct aa_audit_caps *sa = container_of(va, struct aa_audit_caps, base);
+
+	audit_log_format(ab, " name=");
+	audit_log_untrustedstring(ab, capability_names[sa->cap]);
+}
+
+static int aa_audit_caps(struct aa_profile *profile, struct aa_audit_caps *sa)
+{
+	struct audit_cache *ent;
+	int type = AUDIT_APPARMOR_AUTO;
+
+	if (likely(!sa->base.error)) {
+		/* test if auditing is being forced */
+		if (likely((AUDIT_MODE(profile) != AUDIT_ALL) &&
+			   !cap_raised(profile->caps.audit, sa->cap)))
+			return 0;
+		type = AUDIT_APPARMOR_AUDIT;
+	} else if (DO_KILL(profile) ||
+		   cap_raised(profile->caps.kill, sa->cap)) {
+		type = AUDIT_APPARMOR_KILL;
+	} else if (cap_raised(profile->caps.quiet, sa->cap) &&
+		   AUDIT_MODE(profile) != AUDIT_NOQUIET &&
+		   AUDIT_MODE(profile) != AUDIT_ALL) {
+		/* quiet auditing */
+		return sa->base.error;
+	}
+
+	/* Do simple duplicate message elimination */
+	ent = &get_cpu_var(audit_cache);
+	if (sa->base.task == ent->task && cap_raised(ent->caps, sa->cap)) {
+		put_cpu_var(audit_cache);
+		if (COMPLAIN_MODE(profile))
+			return 0;
+		return sa->base.error;
+	} else {
+		ent->task = sa->base.task;
+		cap_raise(ent->caps, sa->cap);
+	}
+	put_cpu_var(audit_cache);
+
+	return aa_audit(type, profile, &sa->base, audit_cb);
+}
+
+static int aa_profile_capable(struct aa_profile *profile, int cap)
+{
+	return cap_raised(profile->caps.allowed, cap) ? 0 : -EPERM;
+}
+
+/**
+ * aa_capable - test permission to use capability
+ * @task: task doing capability test against
+ * @profile: profile confining @task
+ * @cap: capability to be tested
+ * @audit: whether an audit record should be generated
+ *
+ * Look up capability in profile capability set.
+ * Returns 0 on success, or else an error code.
+ */
+int aa_capable(struct task_struct *task, struct aa_profile *profile, int cap,
+	       int audit)
+{
+	int error = aa_profile_capable(profile, cap);
+	struct aa_audit_caps sa = {
+		.base.operation = "capable",
+		.base.task = task,
+		.base.gfp_mask = GFP_ATOMIC,
+		.base.error = error,
+		.cap = cap,
+	};
+
+	if (!audit) {
+		if (COMPLAIN_MODE(profile))
+			return 0;
+		return error;
+	}
+
+	return aa_audit_caps(profile, &sa);
+}
diff --git a/security/apparmor/include/capability.h b/security/apparmor/include/capability.h
new file mode 100644
index 0000000..8287e9d
--- /dev/null
+++ b/security/apparmor/include/capability.h
@@ -0,0 +1,45 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor capability mediation definitions.
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
+#ifndef __AA_CAPABILITY_H
+#define __AA_CAPABILITY_H
+
+#include <linux/sched.h>
+
+struct aa_profile;
+
+/* aa_caps - confinement data for capabilities
+ * @allowed: capabilities mask
+ * @audit: caps that are to be audited
+ * @quiet: caps that should not be audited
+ * @kill: caps that when requested will result in the task being killed
+ * @extended: caps that are subject finer grained mediation
+ */
+struct aa_caps {
+	kernel_cap_t allowed;
+	kernel_cap_t audit;
+	kernel_cap_t quiet;
+	kernel_cap_t kill;
+	kernel_cap_t extended;
+};
+
+int aa_capable(struct task_struct *task, struct aa_profile *profile, int cap,
+	       int audit);
+
+static inline void aa_free_cap_rules(struct aa_caps *caps)
+{
+	/* NOP */
+}
+
+#endif /* __AA_CAPBILITY_H */
diff --git a/security/apparmor/include/ipc.h b/security/apparmor/include/ipc.h
new file mode 100644
index 0000000..aeda0fb
--- /dev/null
+++ b/security/apparmor/include/ipc.h
@@ -0,0 +1,28 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor ipc mediation function definitions.
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
+#ifndef __AA_IPC_H
+#define __AA_IPC_H
+
+#include <linux/sched.h>
+
+struct aa_profile;
+
+int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
+		  struct aa_profile *tracee, unsigned int mode);
+
+int aa_ptrace(struct task_struct *tracer, struct task_struct *tracee,
+	      unsigned int mode);
+
+#endif /* __AA_IPC_H */
diff --git a/security/apparmor/include/net.h b/security/apparmor/include/net.h
new file mode 100644
index 0000000..7d6ddeb
--- /dev/null
+++ b/security/apparmor/include/net.h
@@ -0,0 +1,40 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor network mediation definitions.
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
+#ifndef __AA_NET_H
+#define __AA_NET_H
+
+#include <net/sock.h>
+
+/* struct aa_net - network confinement data
+ * @allowed: basic network families permissions
+ * @audit_network: which network permissions to force audit
+ * @quiet_network: which network permissions to quiet rejects
+ */
+struct aa_net {
+	u16 allowed[AF_MAX];
+	u16 audit[AF_MAX];
+	u16 quiet[AF_MAX];
+};
+
+extern int aa_net_perm(struct aa_profile *profile, char *operation,
+		       int family, int type, int protocol);
+extern int aa_revalidate_sk(struct sock *sk, char *operation);
+
+static inline void aa_free_net_rules(struct aa_net *new)
+{
+	/* NOP */
+}
+
+#endif /* __AA_NET_H */
diff --git a/security/apparmor/include/resource.h b/security/apparmor/include/resource.h
new file mode 100644
index 0000000..e8fc079
--- /dev/null
+++ b/security/apparmor/include/resource.h
@@ -0,0 +1,45 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor resource limits function defintions.
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
+#ifndef __AA_RESOURCE_H
+#define __AA_RESOURCE_H
+
+#include <linux/resource.h>
+#include <linux/sched.h>
+
+struct aa_profile;
+
+/* struct aa_rlimit - rlimits settings for the profile
+ * @mask: which hard limits to set
+ * @limits: rlimit values that override task limits
+ *
+ * AppArmor rlimits are used to set confined task rlimits.  Only the
+ * limits specified in @mask will be controlled by apparmor.
+ */
+struct aa_rlimit {
+	unsigned int mask;
+	struct rlimit limits[RLIM_NLIMITS];
+};
+
+int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
+		      struct rlimit *new_rlim);
+
+void __aa_transition_rlimits(struct aa_profile *old, struct aa_profile *new);
+
+static inline void aa_free_rlimit_rules(struct aa_rlimit *rlims)
+{
+	/* NOP */
+}
+
+#endif /* __AA_RESOURCE_H */
diff --git a/security/apparmor/ipc.c b/security/apparmor/ipc.c
new file mode 100644
index 0000000..e82c869
--- /dev/null
+++ b/security/apparmor/ipc.c
@@ -0,0 +1,101 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor ipc mediation
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
+#include <linux/gfp.h>
+#include <linux/ptrace.h>
+
+#include "include/audit.h"
+#include "include/capability.h"
+#include "include/context.h"
+#include "include/policy.h"
+
+struct aa_audit_ptrace {
+	struct aa_audit base;
+
+	pid_t tracer, tracee;
+};
+
+/* call back to audit ptrace fields */
+static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
+{
+	struct aa_audit_ptrace *sa = container_of(va, struct aa_audit_ptrace,
+						  base);
+	audit_log_format(ab, " tracer=%d tracee=%d", sa->tracer, sa->tracee);
+}
+
+static int aa_audit_ptrace(struct aa_profile *profile,
+			   struct aa_audit_ptrace *sa)
+{
+	return aa_audit(AUDIT_APPARMOR_AUTO, profile, &sa->base, audit_cb);
+}
+
+/* Returns error on failure */
+int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
+		  struct aa_profile *tracee, unsigned int mode)
+{
+	/* TODO: currently only based on capability, not extended ptrace
+	 *       rules,
+	 *       Test mode for PTRACE_MODE_READ || PTRACE_MODE_ATTACH
+	 */
+
+	if (!tracer || tracer == tracee)
+		return 0;
+	/* log this capability request */
+	return aa_capable(tracer_task, tracer, CAP_SYS_PTRACE, 1);
+}
+
+int aa_ptrace(struct task_struct *tracer, struct task_struct *tracee,
+	      unsigned int mode)
+{
+	/*
+	 * tracer can ptrace tracee when
+	 * - tracer is unconfined ||
+	 * - tracer & tracee are in the same namespace &&
+	 *   - tracer is in complain mode
+	 *   - tracer has rules allowing it to trace tracee currently this is:
+	 *       - confined by the same profile ||
+	 *       - tracer profile has CAP_SYS_PTRACE
+	 */
+
+	struct aa_profile *tracer_p;
+	/* cred released below */
+	const struct cred *cred = get_task_cred(tracer);
+	int error = 0;
+	tracer_p = aa_cred_profile(cred);
+
+	if (!unconfined(tracer_p)) {
+		struct aa_audit_ptrace sa = {
+			.base.operation = "ptrace",
+			.base.gfp_mask = GFP_ATOMIC,
+			.tracer = tracer->pid,
+			.tracee = tracee->pid,
+		};
+		/* FIXME: different namespace restriction can be lifted
+		 * if, namespace are matched to AppArmor namespaces
+		 */
+		struct aa_profile *tracee_p;
+		/* lcred released below */
+		struct cred *lcred = get_task_cred(tracee);
+		tracee_p = aa_cred_profile(lcred);
+
+		sa.base.error = aa_may_ptrace(tracer, tracer_p, tracee_p, mode);
+		sa.base.error = aa_audit_ptrace(tracer_p, &sa);
+
+		put_cred(lcred);
+		error = sa.base.error;
+	}
+	put_cred(cred);
+
+	return error;
+}
diff --git a/security/apparmor/net.c b/security/apparmor/net.c
new file mode 100644
index 0000000..b6123c4
--- /dev/null
+++ b/security/apparmor/net.c
@@ -0,0 +1,145 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor network mediation
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
+#include "include/context.h"
+#include "include/net.h"
+#include "include/policy.h"
+
+#include "af_names.h"
+
+static const char *sock_type_names[] = {
+	"unknown(0)",
+	"stream",
+	"dgram",
+	"raw",
+	"rdm",
+	"seqpacket",
+	"dccp",
+	"unknown(7)",
+	"unknown(8)",
+	"unknown(9)",
+	"packet",
+};
+
+struct aa_audit_net {
+	struct aa_audit base;
+
+	int family, type, protocol;
+
+};
+
+static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
+{
+	struct aa_audit_net *sa = container_of(va, struct aa_audit_net, base);
+
+	if (sa->family || sa->type) {
+		if (address_family_names[sa->family]) {
+			audit_log_format(ab, " family=");
+			audit_log_string(ab, address_family_names[sa->family]);
+		} else {
+			audit_log_format(ab, " family=\"unknown(%d)\"",
+					 sa->family);
+		}
+		if (sock_type_names[sa->type]) {
+			audit_log_format(ab, " sock_type=");
+			audit_log_string(ab, sock_type_names[sa->type]);
+		} else {
+			audit_log_format(ab, " sock_type=\"unknown(%d)\"",
+					 sa->type);
+		}
+		audit_log_format(ab, " protocol=%d", sa->protocol);
+	}
+
+}
+
+/* Returns: error on failure */
+static int aa_audit_net(struct aa_profile *profile, struct aa_audit_net *sa)
+{
+	int type = AUDIT_APPARMOR_AUTO;
+
+	if (likely(!sa->base.error)) {
+		u16 audit_mask = profile->net.audit[sa->family];
+		if (likely((AUDIT_MODE(profile) != AUDIT_ALL) &&
+			   !(1 << sa->type & audit_mask)))
+			return 0;
+		type = AUDIT_APPARMOR_AUDIT;
+	} else {
+		u16 quiet_mask = profile->net.quiet[sa->family];
+		u16 kill_mask = 0;
+		u16 denied = (1 << sa->type) & ~quiet_mask;
+
+		if (denied & kill_mask)
+			type = AUDIT_APPARMOR_KILL;
+
+		if ((denied & quiet_mask) &&
+		    AUDIT_MODE(profile) != AUDIT_NOQUIET &&
+		    AUDIT_MODE(profile) != AUDIT_ALL)
+			return COMPLAIN_MODE(profile) ? 0 : sa->base.error;
+	}
+
+	return aa_audit(type, profile, &sa->base, audit_cb);
+}
+
+/* Returns: error on failure */
+int aa_net_perm(struct aa_profile *profile, char *operation,
+		int family, int type, int protocol)
+{
+	u16 family_mask;
+	struct aa_audit_net sa = {
+		.base.operation = operation,
+		.base.gfp_mask = GFP_KERNEL,
+		.family = family,
+		.type = type,
+		.protocol = protocol,
+	};
+
+	if ((family < 0) || (family >= AF_MAX))
+		return -EINVAL;
+
+	if ((type < 0) || (type >= SOCK_MAX))
+		return -EINVAL;
+
+	/* unix domain and netlink sockets are handled by ipc */
+	if (family == AF_UNIX || family == AF_NETLINK)
+		return 0;
+
+	family_mask = profile->net.allowed[family];
+
+	sa.base.error = (family_mask & (1 << type)) ? 0 : -EACCES;
+
+	return aa_audit_net(profile, &sa);
+}
+
+/* Returns: error on failure */
+int aa_revalidate_sk(struct sock *sk, char *operation)
+{
+	struct aa_profile *profile;
+	int error = 0;
+
+	/* aa_revalidate_sk should not be called from interrupt context
+	 * don't mediate these calls as they are not task related
+	 */
+	if (in_interrupt())
+		return 0;
+
+	profile = __aa_current_profile();
+	if (!unconfined(profile))
+		error = aa_net_perm(profile, operation,
+				    sk->sk_family, sk->sk_type,
+				    sk->sk_protocol);
+
+	return error;
+}
diff --git a/security/apparmor/resource.c b/security/apparmor/resource.c
new file mode 100644
index 0000000..0b6e350
--- /dev/null
+++ b/security/apparmor/resource.c
@@ -0,0 +1,104 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor resource mediation and attachment
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
+#include <linux/audit.h>
+
+#include "include/audit.h"
+#include "include/resource.h"
+#include "include/policy.h"
+
+struct aa_audit_resource {
+	struct aa_audit base;
+
+	int rlimit;
+};
+
+static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
+{
+	struct aa_audit_resource *sa = container_of(va,
+						    struct aa_audit_resource,
+						    base);
+
+	if (sa->rlimit)
+		audit_log_format(ab, " rlimit=%d", sa->rlimit - 1);
+}
+
+static int aa_audit_resource(struct aa_profile *profile,
+			     struct aa_audit_resource *sa)
+{
+	return aa_audit(AUDIT_APPARMOR_AUTO, profile, &sa->base, audit_cb);
+}
+
+/**
+ * aa_task_setrlimit - test permission to set an rlimit
+ * @profile - profile confining the task
+ * @resource - the resource being set
+ * @new_rlim - the new resource limit
+ *
+ * Control raising the processes hard limit.
+ */
+int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
+		      struct rlimit *new_rlim)
+{
+	struct aa_audit_resource sa = {
+		.base.operation = "setrlimit",
+		.base.gfp_mask = GFP_KERNEL,
+		.rlimit = resource + 1,
+	};
+	int error = 0;
+
+	if (profile->rlimits.mask & (1 << resource) &&
+	    new_rlim->rlim_max > profile->rlimits.limits[resource].rlim_max) {
+		sa.base.error = -EACCES;
+
+		error = aa_audit_resource(profile, &sa);
+	}
+
+	return error;
+}
+
+void __aa_transition_rlimits(struct aa_profile *old, struct aa_profile *new)
+{
+	unsigned int mask = 0;
+	struct rlimit *rlim, *initrlim;
+	int i;
+
+	/* for any rlimits the profile controlled reset the soft limit
+	 * to the less of the tasks hard limit and the init tasks soft limit
+	 */
+	if (old && old->rlimits.mask) {
+		for (i = 0, mask = 1; i < RLIM_NLIMITS; i++, mask <<= 1) {
+			if (old->rlimits.mask & mask) {
+				rlim = current->signal->rlim + i;
+				initrlim = init_task.signal->rlim + i;
+				rlim->rlim_cur = min(rlim->rlim_max,
+						     initrlim->rlim_cur);
+			}
+		}
+	}
+
+	/* set any new hard limits as dictated by the new profile */
+	if (!(new && new->rlimits.mask))
+		return;
+	for (i = 0, mask = 1; i < RLIM_NLIMITS; i++, mask <<= 1) {
+		if (!(new->rlimits.mask & mask))
+			continue;
+
+		rlim = current->signal->rlim + i;
+		rlim->rlim_max = min(rlim->rlim_max,
+				     new->rlimits.limits[i].rlim_max);
+		/* soft limit should not exceed hard limit */
+		rlim->rlim_cur = min(rlim->rlim_cur, rlim->rlim_max);
+	}
+}
-- 
1.6.6.1

