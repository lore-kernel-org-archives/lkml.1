Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbZGGOuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbZGGOuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbZGGOuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:50:12 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37067 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbZGGOuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:50:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EG0d/FvtjopL+QFPjRRu3ckXVleHbc/ECLDatYhxJlckpKQxeVFjQvM1zgyGF/dj7V
         QuovIIF/qTONcre+O2N5PKypFp7qaF6EZB1Cd7WZDRkkh6BuSO4lZ/ddvjc2E/uqkmp/
         ZhWdd8fxWJirraoXU5Z1Z1++LIdtu8Vgmfuv4=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] do_wait: fix sys_waitid()-specific behaviour
Date: Tue,  7 Jul 2009 16:50:02 +0200
Message-Id: <1246978201-10875-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246978201-10875-1-git-send-email-v.mayatskih@gmail.com>
References: <1246978201-10875-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_wait() checks ->wo_info to figure out who is the caller.
If it's not NULL the caller should be sys_waitid(), in that case
do_wait() fixes up the retval or zeros ->wo_info, depending on
retval from underlying function.

This is bug: user can pass ->wo_info == NULL and sys_waitid() will
return incorrect value.

>From man 2 waitid:

	waitid(): returns 0 on success

Test-case:

	int main(void)
	{
		if (fork())
			assert(waitid(P_ALL, 0, NULL, WEXITED) == 0);

		return 0;
	}

Result:

	Assertion `waitid(P_ALL, 0, ((void *)0), 4) == 0' failed.

Move that code to sys_waitid().

User-visible change: sys_waitid() will return 0 on success, either
infop is set or not.

Note, there's another bug in wait_noreap_copyout() which affects
return value of sys_waitid(). It will be fixed in next patch.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   49 +++++++++++++++++++++++--------------------------
 1 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 80a15b6..62e3646 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1630,32 +1630,6 @@ notask:
 end:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
-
-	if (wo->wo_info) {
-		struct siginfo __user *infop = wo->wo_info;
-
-		if (retval > 0)
-			retval = 0;
-		else {
-			/*
-			 * For a WNOHANG return, clear out all the fields
-			 * we would set so the user can easily tell the
-			 * difference.
-			 */
-			if (!retval)
-				retval = put_user(0, &infop->si_signo);
-			if (!retval)
-				retval = put_user(0, &infop->si_errno);
-			if (!retval)
-				retval = put_user(0, &infop->si_code);
-			if (!retval)
-				retval = put_user(0, &infop->si_pid);
-			if (!retval)
-				retval = put_user(0, &infop->si_uid);
-			if (!retval)
-				retval = put_user(0, &infop->si_status);
-		}
-	}
 	return retval;
 }
 
@@ -1700,6 +1674,29 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 	wo.wo_stat	= NULL;
 	wo.wo_rusage	= ru;
 	ret = do_wait(&wo);
+
+	if (ret > 0) {
+		ret = 0;
+	} else if (infop) {
+		/*
+		 * For a WNOHANG return, clear out all the fields
+		 * we would set so the user can easily tell the
+		 * difference.
+		 */
+		if (!ret)
+			ret = put_user(0, &infop->si_signo);
+		if (!ret)
+			ret = put_user(0, &infop->si_errno);
+		if (!ret)
+			ret = put_user(0, &infop->si_code);
+		if (!ret)
+			ret = put_user(0, &infop->si_pid);
+		if (!ret)
+			ret = put_user(0, &infop->si_uid);
+		if (!ret)
+			ret = put_user(0, &infop->si_status);
+	}
+
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
-- 
1.6.2.5


