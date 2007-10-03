Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbXJCEZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbXJCEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXJCEZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:25:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58617 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXJCEZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:25:15 -0400
Date: Wed, 3 Oct 2007 05:25:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix bogus reporting of signals by audit
Message-ID: <20071003042509.GG8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Async signals should not be reported as sent by current in
audit log.  As it is, we call audit_signal_info() too early in
check_kill_permission().  Note that check_kill_permission() has that
test already - it needs to know if it should apply current-based
permission checks.  So the solution is to move the call of audit_signal_info()
between those.
	Bogosity in question is easily reproduced - add a rule watching for
e.g. kill(2) from specific process (so that audit_signal_info() would not
short-circuit to nothing), say load_policy, watch the bogus OBJ_PID entry
in audit logs claiming that write(2) on selinuxfs file issued by load_policy(8)
had somehow managed to send a signal to syslogd...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
---
diff --git a/kernel/signal.c b/kernel/signal.c
index 9fb91a3..7929523 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -531,18 +531,18 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	if (!valid_signal(sig))
 		return error;
 
-	error = audit_signal_info(sig, t); /* Let audit system see the signal */
-	if (error)
-		return error;
-
-	error = -EPERM;
-	if ((info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info)))
-	    && ((sig != SIGCONT) ||
-		(process_session(current) != process_session(t)))
-	    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
-	    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
-	    && !capable(CAP_KILL))
+	if (info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info))) {
+		error = audit_signal_info(sig, t); /* Let audit system see the signal */
+		if (error)
+			return error;
+		error = -EPERM;
+		if (((sig != SIGCONT) ||
+			(process_session(current) != process_session(t)))
+		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
+		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
+		    && !capable(CAP_KILL))
 		return error;
+	}
 
 	return security_task_kill(t, info, sig, 0);
 }
