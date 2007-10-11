Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbXJKN33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbXJKN33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759197AbXJKN3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:29:00 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56052 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759166AbXJKN25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:28:57 -0400
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: chrisw@sous-sol.org
Subject: [TOMOYO #4 06/13] Auditing interface.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710112225.HGI87594.FVLFOFMJtHSOQO@I-love.SAKURA.ne.jp>
In-Reply-To: <200710112225.HGI87594.FVLFOFMJtHSOQO@I-love.SAKURA.ne.jp>
Message-Id: <200710112228.GHF52176.SLJHFOOFVMQOFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 11 Oct 2007 22:28:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes access logs sent to auditing subsystem.
TOMOYO Linux uses two channels for auditing.
One is 'AUDIT_TMY_GRANTED', used for auditing accesses which are
granted in the TOMOYO Linux policy.
The other is 'AUDIT_TMY_REJECTED', used for auditing accesses which
are not granted in the TOMOYO Linux policy.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/audit.h   |    3 ++
 security/tomoyo/audit.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/security/tomoyo/audit.c	2007-10-11 15:53:12.000000000 +0900
@@ -0,0 +1,68 @@
+/*
+ * security/tomoyo/audit.c
+ *
+ * Audit functions for TOMOYO Linux
+ */
+
+#include "tomoyo.h"
+#include <linux/audit.h>
+
+/**
+ * tmy_init_audit_log - allocate and initialize audit buffer.
+ * @len: pointer to length of requested size.
+ *
+ * Returns pointer to audit buffer on success. @len received allocated size.
+ * Returns NULL on failure.
+ *
+ * @len must not be a NULL.
+ */
+char *tmy_init_audit_log(int *len)
+{
+	char *buf;
+	struct task_struct *task = current;
+	const char *domainname = TMY_SECURITY->domain->domainname->name;
+
+	*len += strlen(domainname) + 256;
+	buf = tmy_alloc(*len);
+
+	if (!buf)
+		return NULL;
+
+	snprintf(buf, (*len) - 1,
+		 "pid=%d uid=%d gid=%d euid=%d egid=%d "
+		 "suid=%d sgid=%d fsuid=%d fsgid=%d : %s : ",
+		 task->pid, task->uid, task->gid, task->euid, task->egid,
+		 task->suid, task->sgid, task->fsuid, task->fsgid, domainname);
+
+	return buf;
+}
+
+/**
+ * tmy_write_audit_log - write audit log.
+ * @buf:        pointer to access log contents.
+ * @is_granted: is the access request granted?
+ * @is_enforce: is the access requested in enforcing mode?
+ *
+ * Returns zero on success.
+ * Returns nonzero on failure.
+ *
+ * Write audit log.
+ * Caller must allocate @buf with tmy_init_audit_log().
+ */
+int tmy_write_audit_log(char *buf, const u8 is_granted, const u8 is_enforce)
+{
+	struct audit_buffer *ab;
+	int type = is_granted ? AUDIT_TMY_GRANTED : AUDIT_TMY_REJECTED;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, type);
+	if (ab) {
+		const char *msg
+			= is_granted ? "granted" : is_enforce ?
+			"error" : "warning";
+		audit_log_format(ab, "TOMOYO %s: %s", msg, buf);
+		audit_log_end(ab);
+	}
+
+	tmy_free(buf);
+	return ab ? 0 : -ENOMEM;
+}
--- linux-2.6.orig/include/linux/audit.h	2007-10-11 15:52:19.000000000 +0900
+++ linux-2.6/include/linux/audit.h	2007-10-11 15:53:12.000000000 +0900
@@ -120,6 +120,9 @@
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
+#define AUDIT_TMY_GRANTED  2001 /* TOMOYO Linux audit granted */
+#define AUDIT_TMY_REJECTED 2002 /* TOMOYO Linux audit rejected */
+
 /* Rule flags */
 #define AUDIT_FILTER_USER	0x00	/* Apply rule to user-generated messages */
 #define AUDIT_FILTER_TASK	0x01	/* Apply rule at task creation (not syscall) */

