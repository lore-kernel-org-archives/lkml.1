Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZENJuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZENJuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZENJuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:50:21 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36881 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZENJuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qNjAYpSXL5Z5dAZ8oeTulQdjgYkCoW7GJu6CMxcZMECQV2Hg1q7vG0pda2lETzGax5
         DiK0vjy6jlwYW8F9gtEYUkZRfYQUaFxw5dFSBxKtX8ACewn3d48pcq2uRQuwKAxkrEgd
         HCgbzNTUF3vMmqsBqCqyDzirIqQWoC4guBIC8=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Move more common code from wait_task_*() to copy_wait_opts_to_user()
Date: Thu, 14 May 2009 11:50:14 +0200
Message-Id: <1242294612-28680-3-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242294612-28680-1-git-send-email-v.mayatskih@gmail.com>
References: <1242294612-28680-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath pointed me to more common checks and put_user() around
invoke of copy_wait_opts_to_user() in wait_task_*() functions.
This common code is moved to copy_wait_opts_to_user().

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   45 +++++++++++++++++----------------------------
 1 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 3952385..1d42627 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1124,7 +1124,8 @@ static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 }
 
 static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
-				  pid_t pid, uid_t uid, int why, int status, int signal)
+				  pid_t pid, uid_t uid, int why, int status,
+				  int signal, int stat)
 {
 	struct siginfo __user *infop = wo->wo_info;
 	int retval = wo->wo_rusage
@@ -1143,6 +1144,8 @@ static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
 		if (!retval)
 			retval = put_user(status, &infop->si_status);
 	}
+	if (!retval && wo->wo_stat)
+		retval = put_user(stat, wo->wo_stat);
 	if (!retval)
 		retval = pid;
 	return retval;
@@ -1157,7 +1160,7 @@ static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
 static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
 	unsigned long state;
-	int retval, why, status, traced;
+	int retval, why, status, traced, stat;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
 
@@ -1177,7 +1180,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			status = exit_code & 0x7f;
 		}
 		retval = copy_wait_opts_to_user(wo, p, pid, uid,
-						why, status, SIGCHLD);
+						why, status, SIGCHLD, 0);
 		put_task_struct(p);
 		return retval;
 	}
@@ -1260,23 +1263,18 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 */
 	read_unlock(&tasklist_lock);
 
-	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
+	stat = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
-	if (wo->wo_stat)
-		retval = put_user(status, wo->wo_stat);
 
-	if ((status & 0x7f) == 0) {
+	if ((stat & 0x7f) == 0) {
 		why = CLD_EXITED;
-		status >>= 8;
+		status = stat >> 8;
 	} else {
-		why = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
-		status &= 0x7f;
+		why = (stat & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		status = stat & 0x7f;
 	}
 
-	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
-
-	if (!retval)
-		retval = pid;
+	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD, stat);
 
 	if (traced) {
 		write_lock_irq(&tasklist_lock);
@@ -1366,12 +1364,8 @@ unlock_sig:
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, exit_code, SIGCHLD);
-
-	if (!retval && wo->wo_stat)
-		retval = put_user((exit_code << 8) | 0x7f, wo->wo_stat);
-	if (!retval)
-		retval = pid;
+	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, exit_code, SIGCHLD,
+					(exit_code << 8) | 0x7f);
 	put_task_struct(p);
 
 	BUG_ON(!retval);
@@ -1411,15 +1405,10 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
-	retval = copy_wait_opts_to_user(wo, p, pid, uid,
-					CLD_CONTINUED, SIGCONT, SIGCHLD);
+	retval = copy_wait_opts_to_user(wo, p, pid, uid, CLD_CONTINUED, SIGCONT,
+					SIGCHLD, 0xffff);
 	put_task_struct(p);
 
-	if (!retval && wo->wo_stat)
-		retval = put_user(0xffff, wo->wo_stat);
-	if (!retval)
-		retval = pid;
-
 	BUG_ON(retval == 0);
 
 	return retval;
@@ -1583,7 +1572,7 @@ end:
 			 * we would set so the user can easily tell the
 			 * difference.
 			 */
-			retval = copy_wait_opts_to_user(wo, 0, 0, 0, 0, 0, 0);
+			retval = copy_wait_opts_to_user(wo, 0, 0, 0, 0, 0, 0, 0);
 		}
 	}
 	return retval;
-- 
1.6.2.2

