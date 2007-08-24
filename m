Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbXHXMxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbXHXMxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932915AbXHXMwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:52:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:7952 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899AbXHXMwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=nkRAgt1L7zI8gb/Ym7E1qDZ4u0/skyt5hhADb97S8C7x72+G+rKqnRqwIzDsFE8SnZdltikHyGvbJheSkEgzrnZCUYgl5Xbtmwu+0eWsbpSGjQEpsb1335xyLszwxDEseKJ7qTm/wRdSh5qc8mACYIVfwlcp/voYa4+pNHe14Wk=
Message-ID: <46CED488.8000603@gmail.com>
Date: Fri, 24 Aug 2007 21:52:24 +0900
From: Kentaro Takeda <k.takeda26@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: [TOMOYO 07/15] Auditing interface.
References: <46CED214.6050505@gmail.com>
In-Reply-To: <46CED214.6050505@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
+++ linux-2.6/security/tomoyo/audit.c	2007-08-24 15:51:36.000000000 +0900
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
+int tmy_write_audit_log(char *buf, const int is_granted, const int is_enforce)
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
--- linux-2.6.orig/include/linux/audit.h	2007-08-23 21:25:55.000000000 +0900
+++ linux-2.6/include/linux/audit.h	2007-08-24 15:51:36.000000000 +0900
@@ -120,6 +120,9 @@
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
+#define AUDIT_TMY_GRANTED  2001 /* TOMOYO Linux audit granted */
+#define AUDIT_TMY_REJECTED 2002 /* TOMOYO Linux audit rejected */
+
 /* Rule flags */
 #define AUDIT_FILTER_USER	0x00	/* Apply rule to user-generated messages */
 #define AUDIT_FILTER_TASK	0x01	/* Apply rule at task creation (not syscall) */

