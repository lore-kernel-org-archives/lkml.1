Return-Path: <linux-kernel-owner+w=401wt.eu-S935847AbXHGXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935847AbXHGXB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbXHGXBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:01:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60718 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXHGXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:01:48 -0400
Date: Wed, 8 Aug 2007 00:01:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] fix oops in __audit_signal_info()
Message-ID: <20070807230146.GZ21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Check for audit_signals is misplaced and check for
audit_dummy_context() is missing; as the result, if we send
signal to auditd from task with NULL ->audit_context while
we have audit_signals != 0 we end up with an oops.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a777d37..3401293 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1992,19 +1992,19 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	extern uid_t audit_sig_uid;
 	extern u32 audit_sig_sid;
 
-	if (audit_pid && t->tgid == audit_pid &&
-	    (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1)) {
-		audit_sig_pid = tsk->pid;
-		if (ctx)
-			audit_sig_uid = ctx->loginuid;
-		else
-			audit_sig_uid = tsk->uid;
-		selinux_get_task_sid(tsk, &audit_sig_sid);
+	if (audit_pid && t->tgid == audit_pid) {
+		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1) {
+			audit_sig_pid = tsk->pid;
+			if (ctx)
+				audit_sig_uid = ctx->loginuid;
+			else
+				audit_sig_uid = tsk->uid;
+			selinux_get_task_sid(tsk, &audit_sig_sid);
+		}
+		if (!audit_signals || audit_dummy_context())
+			return 0;
 	}
 
-	if (!audit_signals) /* audit_context checked in wrapper */
-		return 0;
-
 	/* optimize the common case by putting first signal recipient directly
 	 * in audit_context */
 	if (!ctx->target_pid) {
