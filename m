Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbXFNHic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbXFNHic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXFNHiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:38:24 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:37265 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXFNHiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:38:23 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 03:38:23 EDT
Message-ID: <4670F05C.4070509@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:38:04 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 7/9] Auditing interface.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:38:04.0756 (UTC) FILETIME=[F19FF140:01C7AE56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes access logs sent to auditing subsystem.
Although TOMOYO Linux has /proc interface for access logs,
we were advised to use auditing subsystem (after we introduced
TOMOYO Linux 1.0 on December 2005, http://lkml.org/lkml/2005/12/21/63 )
and we did so in TOMOYO Linux 2.0.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/tomoyo/audit.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/tomoyo/audit.c linux-2.6.21.5-tomoyo/security/tomoyo/audit.c
--- linux-2.6.21.5/security/tomoyo/audit.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/audit.c	2007-06-14 15:06:10.000000000 +0900
@@ -0,0 +1,52 @@
+/*
+ * security/tomoyo/audit.c
+ *
+ * Audit functions for TOMOYO Linux
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ */
+
+#include "tomoyo.h"
+#include <linux/audit.h>
+
+/* move to include/linux/audit.h */
+#define AUDIT_TOMOYO 2001
+
+char *tomoyo_init_audit_log(int *len)
+{
+	char *buf;
+	struct timeval tv;
+	struct task_struct *task = current;
+	const char *domainname =
+		((struct tomoyo_security *) current->security)->domain_info->domainname->name;
+	do_gettimeofday(&tv);
+	*len += strlen(domainname) + 256;
+	if ((buf = tomoyo_alloc(*len)) != NULL)
+		snprintf(buf,
+		         (*len) - 1,
+		         "#timestamp=%lu pid=%d uid=%d gid=%d euid=%d egid=%d "
+		         "suid=%d sgid=%d fsuid=%d fsgid=%d\n%s\n",
+		         tv.tv_sec, task->pid, task->uid, task->gid, task->euid, task->egid,
+		         task->suid, task->sgid, task->fsuid, task->fsgid, domainname);
+	return buf;
+}
+
+/*
+ * Write audit log.
+ * Caller must allocate buf with tomoyo_init_audit_log().
+ */
+int tomoyo_write_audit_log(char *buf, const int is_granted)
+{
+	struct audit_buffer *ab;
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, AUDIT_TOMOYO);
+	if (ab) {
+		audit_log_format(ab,
+		                 "%s\n%s",
+		                 is_granted ? "TOMOYO_GRANT_LOG" : "TOMOYO_REJECT_LOG", buf);
+		audit_log_end(ab);
+	}
+	tomoyo_free(buf);
+	return ab ? 0 : -ENOMEM;
+}
---------------

