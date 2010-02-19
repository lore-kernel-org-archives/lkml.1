Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0BSJgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:36:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43659 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0BSJgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:36:48 -0500
From: john.johansen@canonical.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 02/12] Update kenel audit range comments to show AppArmor's registered range of 1500-1599.  This range used to be reserved for LSPP but LSPP uses the SELinux range and the range was given to AppArmor. Patch is not in mainline -- pending AppArmor code submission to lkml
Date: Fri, 19 Feb 2010 01:36:18 -0800
Message-Id: <1266572188-26529-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

Add the core routine for AppArmor auditing.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 include/linux/audit.h             |   10 ++-
 security/apparmor/audit.c         |  149 +++++++++++++++++++++++++++++++++++++
 security/apparmor/include/audit.h |   54 +++++++++++++
 3 files changed, 212 insertions(+), 1 deletions(-)
 create mode 100644 security/apparmor/audit.c
 create mode 100644 security/apparmor/include/audit.h

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 3c7a358..a1db25b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -33,7 +33,7 @@
  * 1200 - 1299 messages internal to the audit daemon
  * 1300 - 1399 audit event messages
  * 1400 - 1499 SE Linux use
- * 1500 - 1599 kernel LSPP events
+ * 1500 - 1599 AppArmor use
  * 1600 - 1699 kernel crypto events
  * 1700 - 1799 kernel anomaly records
  * 1800 - 1899 kernel integrity events
@@ -122,6 +122,14 @@
 #define AUDIT_MAC_UNLBL_STCADD	1416	/* NetLabel: add a static label */
 #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label */
 
+#define AUDIT_APPARMOR_AUDIT	1501	/* AppArmor audited grants */
+#define AUDIT_APPARMOR_ALLOWED	1502	/* Allowed Access for learning */
+#define AUDIT_APPARMOR_DENIED	1503
+#define AUDIT_APPARMOR_HINT	1504	/* Process Tracking information */
+#define AUDIT_APPARMOR_STATUS	1505	/* Changes in config */
+#define AUDIT_APPARMOR_ERROR	1506	/* Internal AppArmor Errors */
+#define AUDIT_APPARMOR_KILL	1507	/* AppArmor killing processes */
+
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
new file mode 100644
index 0000000..67a8113
--- /dev/null
+++ b/security/apparmor/audit.c
@@ -0,0 +1,149 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor auditing functions
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
+#include <linux/socket.h>
+
+#include "include/apparmor.h"
+#include "include/audit.h"
+#include "include/policy.h"
+
+const char *audit_mode_names[] = {
+	"normal",
+	"quiet_denied",
+	"quiet",
+	"noquiet",
+	"all"
+};
+
+static char *aa_audit_type[] = {
+	"APPARMOR_AUDIT",
+	"APPARMOR_ALLOWED",
+	"APPARMOR_DENIED",
+	"APPARMOR_HINT",
+	"APPARMOR_STATUS",
+	"APPARMOR_ERROR",
+	"APPARMOR_KILLED"
+};
+
+/*
+ * Currently AppArmor auditing is fed straight into the audit framework.
+ *
+ * TODO:
+ * netlink interface for complain mode
+ * user auditing, - send user auditing to netlink interface
+ * system control of whether user audit messages go to system log
+ */
+
+/**
+ *
+ * NOTE: profile can be NULL if audit is a none profile based message
+ */
+static int aa_audit_base(int type, struct aa_profile *profile,
+			 struct aa_audit *sa, struct audit_context *audit_cxt,
+			 void (*cb) (struct audit_buffer *, struct aa_audit *))
+{
+	struct audit_buffer *ab = NULL;
+	struct task_struct *task = sa->task ? sa->task : current;
+
+	if (profile && DO_KILL(profile) && type == AUDIT_APPARMOR_DENIED)
+		type = AUDIT_APPARMOR_KILL;
+
+	/* ab freed below in audit_log_end */
+	ab = audit_log_start(audit_cxt, sa->gfp_mask, type);
+
+	if (!ab) {
+		AA_ERROR("(%d) Unable to log event of type (%d)\n",
+			 -ENOMEM, type);
+		sa->error = -ENOMEM;
+		goto out;
+	}
+
+	if (aa_g_audit_header) {
+		audit_log_format(ab, " type=");
+		audit_log_string(ab, aa_audit_type[type - AUDIT_APPARMOR_AUDIT]);
+	}
+
+	if (sa->operation) {
+		audit_log_format(ab, " operation=");
+		audit_log_string(ab, sa->operation);
+	}
+
+	if (sa->info) {
+		audit_log_format(ab, " info=");
+		audit_log_string(ab, sa->info);
+		if (sa->error)
+			audit_log_format(ab, " error=%d", sa->error);
+	}
+
+	audit_log_format(ab, " pid=%d", task->pid);
+
+	if (profile && !unconfined(profile)) {
+		pid_t pid = task->real_parent->pid;
+		audit_log_format(ab, " parent=%d", pid);
+		audit_log_format(ab, " profile=");
+		audit_log_untrustedstring(ab, profile->base.hname);
+
+		if (profile->ns != root_ns) {
+			audit_log_format(ab, " namespace=");
+			audit_log_untrustedstring(ab, profile->ns->base.hname);
+		}
+	}
+
+	if (cb)
+		cb(ab, sa);
+
+	audit_log_end(ab);
+
+out:
+	if (type == AUDIT_APPARMOR_KILL)
+		(void)send_sig_info(SIGKILL, NULL, task);
+
+	return type == AUDIT_APPARMOR_ALLOWED ? 0 : sa->error;
+}
+
+/**
+ * aa_audit - Log an audit event to the audit subsystem
+ * @type: audit type for the message
+ * @profile: profile to check against
+ * @sa: audit event
+ * @cb: optional callback fn for type specific fields
+ *
+ * Handle default message switching based off of audit mode flags
+ *
+ * Returns: error on failure
+ */
+int aa_audit(int type, struct aa_profile *profile, struct aa_audit *sa,
+	     void (*cb) (struct audit_buffer *, struct aa_audit *))
+{
+	struct audit_context *audit_cxt;
+	audit_cxt = aa_g_logsyscall ? current->audit_context : NULL;
+
+	if (type == AUDIT_APPARMOR_AUTO) {
+		if (likely(!sa->error)) {
+			if (AUDIT_MODE(profile) != AUDIT_ALL)
+				return 0;
+			type = AUDIT_APPARMOR_AUDIT;
+		} else if (COMPLAIN_MODE(profile))
+			type = AUDIT_APPARMOR_ALLOWED;
+		else
+			type = AUDIT_APPARMOR_DENIED;
+	}
+	if (AUDIT_MODE(profile) == AUDIT_QUIET ||
+	    (type == AUDIT_APPARMOR_DENIED &&
+	     AUDIT_MODE(profile) == AUDIT_QUIET))
+		return sa->error;
+
+	return aa_audit_base(type, profile, sa, audit_cxt, cb);
+}
diff --git a/security/apparmor/include/audit.h b/security/apparmor/include/audit.h
new file mode 100644
index 0000000..d86cfee
--- /dev/null
+++ b/security/apparmor/include/audit.h
@@ -0,0 +1,54 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor auditing function definitions.
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
+#ifndef __AA_AUDIT_H
+#define __AA_AUDIT_H
+
+#include <linux/audit.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+struct aa_profile;
+
+extern const char *audit_mode_names[];
+#define AUDIT_MAX_INDEX 5
+
+#define AUDIT_APPARMOR_AUTO 0	/* auto choose audit message type */
+
+enum audit_mode {
+	AUDIT_NORMAL,		/* follow normal auditing of accesses */
+	AUDIT_QUIET_DENIED,	/* quiet all denied access messages */
+	AUDIT_QUIET,		/* quiet all messages */
+	AUDIT_NOQUIET,		/* do not quiet audit messages */
+	AUDIT_ALL		/* audit all accesses */
+};
+
+/*
+ * aa_audit - AppArmor auditing structure
+ * Structure is populated by access control code and passed to aa_audit which
+ * provides for a single point of logging.
+ */
+struct aa_audit {
+	struct task_struct *task;
+	gfp_t gfp_mask;
+	int error;
+	const char *operation;
+	const char *info;
+};
+
+int aa_audit(int type, struct aa_profile *profile, struct aa_audit *sa,
+	     void (*cb) (struct audit_buffer *, struct aa_audit *));
+
+#endif /* __AA_AUDIT_H */
-- 
1.6.6.1

