Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZEMMIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZEMMIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbZEMMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:08:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42623 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbZEMMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wRA+RZPKiaORe5tAq9CEuQJxVEW6PxfdAi79dXGdqwx5qq3jBldr319JdGwtTf/x1v
         pJvwS7Ain2IRusJtlO3qf64Pgdsw024s6/vwfRnD7+nu2J7Ax29CQn7C+3eieRl/QBKW
         XzXMMPxKCv+FY9Gm4jQWCevn0QUkbLnrqbD+M=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Introduce "struct wait_info" to simplify wait_task*() pathes
Date: Wed, 13 May 2009 14:08:11 +0200
Message-Id: <1242216490-8226-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
References: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's too much parameters passing to wait_noreap_copyout() and
copy_wait_opts_to_user().

Introduce "struct wait_info" which holds data needed for user's siginfo
structure. This will save registers and some stack on
copy_wait_opts_to_user() invoke.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |  116 +++++++++++++++++++++++++++++++--------------------------
 1 files changed, 63 insertions(+), 53 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f22e82c..f069bc1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1088,6 +1088,15 @@ struct wait_opts {
 	int			notask_error;
 };
 
+struct wait_info {
+	struct task_struct*	p;
+	pid_t			pid;
+	uid_t			uid;
+	int			why;
+	int			status;
+	int			signal;
+};
+
 static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid = NULL;
@@ -1123,36 +1132,36 @@ static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 	return 1;
 }
 
-static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
-				  pid_t pid, uid_t uid, int why, int status, int signal)
+static int copy_wait_opts_to_user(struct wait_opts *wo, struct wait_info *wi)
 {
 	struct siginfo __user *infop = wo->wo_info;
 	int retval = wo->wo_rusage
-		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
+		? getrusage(wi->p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 
 	if (!retval && infop) {
-		retval = put_user(signal, &infop->si_signo);
+		retval = put_user(wi->signal, &infop->si_signo);
 		if (!retval)
 			retval = put_user(0, &infop->si_errno);
 		if (!retval)
-			retval = put_user((short)why, &infop->si_code);
+			retval = put_user((short)wi->why, &infop->si_code);
 		if (!retval)
-			retval = put_user(pid, &infop->si_pid);
+			retval = put_user(wi->pid, &infop->si_pid);
 		if (!retval)
-			retval = put_user(uid, &infop->si_uid);
+			retval = put_user(wi->uid, &infop->si_uid);
 		if (!retval)
-			retval = put_user(status, &infop->si_status);
+			retval = put_user(wi->status, &infop->si_status);
 	}
 	return retval;
 }
 
-static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
-				pid_t pid, uid_t uid, int why, int status)
+static int wait_noreap_copyout(struct wait_opts *wo, struct wait_info *wi)
 {
-	int retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
-	put_task_struct(p);
+	int retval;
+	wi->signal = SIGCHLD;
+	retval = copy_wait_opts_to_user(wo, wi);
+	put_task_struct(wi->p);
 	if (!retval)
-		retval = pid;
+		retval = wi->pid;
 	return retval;
 }
 
@@ -1165,26 +1174,27 @@ static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
 static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
 	unsigned long state;
-	int retval, why, status, traced;
-	pid_t pid = task_pid_vnr(p);
-	uid_t uid = __task_cred(p)->uid;
+	int retval, traced;
+	struct wait_info wi = { .p = p, .pid = task_pid_vnr(p),
+				.uid = __task_cred(p)->uid,
+				.signal = SIGCHLD };
 
 	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
-		int exit_code = p->exit_code;
+		wi.status = p->exit_code;
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
-		if ((exit_code & 0x7f) == 0) {
-			why = CLD_EXITED;
-			status = exit_code >> 8;
+		if ((wi.status & 0x7f) == 0) {
+			wi.why = CLD_EXITED;
+			wi.status >>= 8;
 		} else {
-			why = (exit_code & 0x80) ? CLD_DUMPED : CLD_KILLED;
-			status = exit_code & 0x7f;
+			wi.why = (wi.status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+			wi.status &= 0x7f;
 		}
-		return wait_noreap_copyout(wo, p, pid, uid, why, status);
+		return wait_noreap_copyout(wo, &wi);
 	}
 
 	/*
@@ -1265,23 +1275,23 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 */
 	read_unlock(&tasklist_lock);
 
-	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
+	wi.status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
 	if (wo->wo_stat)
-		retval = put_user(status, wo->wo_stat);
+		retval = put_user(wi.status, wo->wo_stat);
 
-	if ((status & 0x7f) == 0) {
-		why = CLD_EXITED;
-		status >>= 8;
+	if ((wi.status & 0x7f) == 0) {
+		wi.why = CLD_EXITED;
+		wi.status >>= 8;
 	} else {
-		why = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
-		status &= 0x7f;
+		wi.why = (wi.status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		wi.status &= 0x7f;
 	}
 
-	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
+	retval = copy_wait_opts_to_user(wo, &wi);
 
 	if (!retval)
-		retval = pid;
+		retval = wi.pid;
 
 	if (traced) {
 		write_lock_irq(&tasklist_lock);
@@ -1328,9 +1338,8 @@ static int *task_stopped_code(struct task_struct *p, bool ptrace)
 static int wait_task_stopped(struct wait_opts *wo,
 				int ptrace, struct task_struct *p)
 {
-	int retval, exit_code, *p_code, why;
-	uid_t uid = 0; /* unneeded, required by compiler */
-	pid_t pid;
+	int retval, *p_code;
+	struct wait_info wi = { .p = p, .signal = SIGCHLD };
 
 	/*
 	 * Traditionally we see ptrace'd stopped tasks regardless of options.
@@ -1338,25 +1347,25 @@ static int wait_task_stopped(struct wait_opts *wo,
 	if (!ptrace && !(wo->wo_flags & WUNTRACED))
 		return 0;
 
-	exit_code = 0;
+	wi.status = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
 	p_code = task_stopped_code(p, ptrace);
 	if (unlikely(!p_code))
 		goto unlock_sig;
 
-	exit_code = *p_code;
-	if (!exit_code)
+	wi.status = *p_code;
+	if (!wi.status)
 		goto unlock_sig;
 
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		*p_code = 0;
 
 	/* don't need the RCU readlock here as we're holding a spinlock */
-	uid = __task_cred(p)->uid;
+	wi.uid = __task_cred(p)->uid;
 unlock_sig:
 	spin_unlock_irq(&p->sighand->siglock);
-	if (!exit_code)
+	if (!wi.status)
 		return 0;
 
 	/*
@@ -1367,16 +1376,16 @@ unlock_sig:
 	 * possibly take page faults for user memory.
 	 */
 	get_task_struct(p);
-	pid = task_pid_vnr(p);
-	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
+	wi.pid = task_pid_vnr(p);
+	wi.why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, exit_code, SIGCHLD);
+	retval = copy_wait_opts_to_user(wo, &wi);
 
 	if (!retval && wo->wo_stat)
-		retval = put_user((exit_code << 8) | 0x7f, wo->wo_stat);
+		retval = put_user((wi.status << 8) | 0x7f, wo->wo_stat);
 	if (!retval)
-		retval = pid;
+		retval = wi.pid;
 	put_task_struct(p);
 
 	BUG_ON(!retval);
@@ -1392,8 +1401,8 @@ unlock_sig:
 static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 {
 	int retval;
-	pid_t pid;
-	uid_t uid;
+	struct wait_info wi = { .p = p, .why = CLD_CONTINUED,
+				.status = SIGCONT, .signal = SIGCHLD };
 
 	if (!unlikely(wo->wo_flags & WCONTINUED))
 		return 0;
@@ -1409,21 +1418,21 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
-	uid = __task_cred(p)->uid;
+	wi.uid = __task_cred(p)->uid;
 	spin_unlock_irq(&p->sighand->siglock);
 
-	pid = task_pid_vnr(p);
+	wi.pid = task_pid_vnr(p);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
-	retval = copy_wait_opts_to_user(wo, p, pid, uid,
-					CLD_CONTINUED, SIGCONT, SIGCHLD);
+	retval = copy_wait_opts_to_user(wo, &wi);
+
 	put_task_struct(p);
 
 	if (!retval && wo->wo_stat)
 		retval = put_user(0xffff, wo->wo_stat);
 	if (!retval)
-		retval = pid;
+		retval = wi.pid;
 
 	BUG_ON(retval == 0);
 
@@ -1588,7 +1597,8 @@ end:
 			 * we would set so the user can easily tell the
 			 * difference.
 			 */
-			retval = copy_wait_opts_to_user(wo, 0, 0, 0, 0, 0, 0);
+			struct wait_info wi = { 0 };
+			retval = copy_wait_opts_to_user(wo, &wi);
 		}
 	}
 	return retval;
-- 
1.6.2.2


