Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZEKKOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZEKKOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbZEKKNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50009 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158AbZEKKNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=phk3+dM9WNRWFBski+RYEqzy8IVYYiyQiKh55GhNE6hKFMyDUC06fJUmvLjKbZl3v7
         wNWBnUK6vfHyimm1UxRaMOq97CytPf0W6V1CxGCOz69N8DPSuRCo+HT3TxDgWvThLEQL
         aLJY6GsHU77Jck+0P3S9DmyM3aBxaCsOB6ACI=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] Use wait_copyout() in wait_task_zombie()
Date: Mon, 11 May 2009 12:12:43 +0200
Message-Id: <1242036759-4025-5-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All copy-paste getrusage() and put_user() code in wait_task_* functions
is replaced by call to wait_copyout()

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   39 +++++++++++----------------------------
 1 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 6ee6b53..1ff490d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1165,17 +1165,15 @@ static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
 static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
 	unsigned long state;
-	int retval, status, traced;
+	int retval, why, status, traced;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
-	struct siginfo __user *infop;
 
 	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
-		int why, status;
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
@@ -1267,36 +1265,21 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 */
 	read_unlock(&tasklist_lock);
 
-	retval = wo->wo_rusage
-		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
-	if (!retval && wo->wo_stat)
+	if (wo->wo_stat)
 		retval = put_user(status, wo->wo_stat);
 
-	infop = wo->wo_info;
-	if (!retval && infop)
-		retval = put_user(SIGCHLD, &infop->si_signo);
-	if (!retval && infop)
-		retval = put_user(0, &infop->si_errno);
-	if (!retval && infop) {
-		int why;
-
-		if ((status & 0x7f) == 0) {
-			why = CLD_EXITED;
-			status >>= 8;
-		} else {
-			why = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
-			status &= 0x7f;
-		}
-		retval = put_user((short)why, &infop->si_code);
-		if (!retval)
-			retval = put_user(status, &infop->si_status);
+	if ((status & 0x7f) == 0) {
+		why = CLD_EXITED;
+		status >>= 8;
+	} else {
+		why = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		status &= 0x7f;
 	}
-	if (!retval && infop)
-		retval = put_user(pid, &infop->si_pid);
-	if (!retval && infop)
-		retval = put_user(uid, &infop->si_uid);
+
+	retval = wait_copyout(wo, p, pid, uid, why, status, SIGCHLD);
+
 	if (!retval)
 		retval = pid;
 
-- 
1.6.2.2


