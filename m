Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbZEKN1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbZEKN1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZEKN1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:27:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:6093 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZEKN1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U/VM4/KMxHyUlDJlM628JSr+u/Qh4EGNgBwaMjrGuzg14ATokuvW7sBHbdIW61XcYp
         FwJJpzvlyb5WEPNc5wmv7sXmAH8fdvDjz2JFBHMr4pCJDq80KfeSRwLDvXwqR3fGZfXu
         6rbm/UTaGDFuAiX6fkK88vEs/Tkf5cpZHzYNw=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] Split wait_noreap_copyout()
Date: Mon, 11 May 2009 15:25:50 +0200
Message-Id: <1242048349-2766-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move getrusage() and put_user() code from wait_noreap_copyout()
to copy_wait_opts_to_user(). The same code is spreaded across all
wait_task_*() routines, it's better to reuse one copy.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 25782da..9546362 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1123,27 +1123,34 @@ static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 	return 1;
 }
 
-static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
-				pid_t pid, uid_t uid, int why, int status)
+static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
+				  pid_t pid, uid_t uid, int why, int status, int signal)
 {
-	struct siginfo __user *infop;
+	struct siginfo __user *infop = wo->wo_info;
 	int retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 
+	if (!retval && infop) {
+		retval = put_user(signal, &infop->si_signo);
+		if (!retval)
+			retval = put_user(0, &infop->si_errno);
+		if (!retval)
+			retval = put_user((short)why, &infop->si_code);
+		if (!retval)
+			retval = put_user(pid, &infop->si_pid);
+		if (!retval)
+			retval = put_user(uid, &infop->si_uid);
+		if (!retval)
+			retval = put_user(status, &infop->si_status);
+	}
+	return retval;
+}
+
+static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
+				pid_t pid, uid_t uid, int why, int status)
+{
+	int retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
 	put_task_struct(p);
-	infop = wo->wo_info;
-	if (!retval)
-		retval = put_user(SIGCHLD, &infop->si_signo);
-	if (!retval)
-		retval = put_user(0, &infop->si_errno);
-	if (!retval)
-		retval = put_user((short)why, &infop->si_code);
-	if (!retval)
-		retval = put_user(pid, &infop->si_pid);
-	if (!retval)
-		retval = put_user(uid, &infop->si_uid);
-	if (!retval)
-		retval = put_user(status, &infop->si_status);
 	if (!retval)
 		retval = pid;
 	return retval;
-- 
1.6.2.2


