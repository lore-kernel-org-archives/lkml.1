Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZEMMJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZEMMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbZEMMIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:08:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63547 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbZEMMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OBK2TVKPbhbpOwiuPLGmrvLjHEFkRdY7WgkzKHxFoXpDv3AA7UKmqix3sNo2EcfvcI
         YjgCrdiPEX23JkXLDPfnDjjcckyCAHCNPpLD5qIepuHMJxrWmEGYgpjuG9ogucmsp162
         cd4PZfxGP7hZ0bbMP7AUZcqH3BfY7EiHVkENk=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Move more common code from wait_task_*() to copy_wait_opts_to_user()
Date: Wed, 13 May 2009 14:08:13 +0200
Message-Id: <1242216490-8226-4-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
References: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath pointed to more common checks and put_user() around
invoke of copy_wait_opts_to_user() in wait_task_*() functions.
This common code is moved to copy_wait_opts_to_user().

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index cea85c9..cf41c2b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1095,6 +1095,7 @@ struct wait_info {
 	int			why;
 	int			status;
 	int			signal;
+	int			stat;
 };
 
 static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
@@ -1151,6 +1152,10 @@ static int copy_wait_opts_to_user(struct wait_opts *wo, struct wait_info *wi)
 		if (!retval)
 			retval = put_user(wi->status, &infop->si_status);
 	}
+	if (!retval && wo->wo_stat)
+		retval = put_user(wi->stat, wo->wo_stat);
+	if (!retval)
+		retval = wi->pid;
 	return retval;
 }
 
@@ -1166,7 +1171,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	int retval, traced;
 	struct wait_info wi = { .p = p, .pid = task_pid_vnr(p),
 				.uid = __task_cred(p)->uid,
-				.signal = SIGCHLD };
+				.signal = SIGCHLD, .stat = 0 };
 
 	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
@@ -1185,8 +1190,6 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		}
 		retval = copy_wait_opts_to_user(wo, &wi);
 		put_task_struct(p);
-		if (!retval)
-			retval = wi.pid;
 		return retval;
 	}
 
@@ -1268,24 +1271,19 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 */
 	read_unlock(&tasklist_lock);
 
-	wi.status = (p->signal->flags & SIGNAL_GROUP_EXIT)
+	wi.stat = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
-	if (wo->wo_stat)
-		retval = put_user(wi.status, wo->wo_stat);
 
-	if ((wi.status & 0x7f) == 0) {
+	if ((wi.stat & 0x7f) == 0) {
 		wi.why = CLD_EXITED;
-		wi.status >>= 8;
+		wi.status = wi.stat >> 8;
 	} else {
-		wi.why = (wi.status & 0x80) ? CLD_DUMPED : CLD_KILLED;
-		wi.status &= 0x7f;
+		wi.why = (wi.stat & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		wi.status = wi.stat & 0x7f;
 	}
 
 	retval = copy_wait_opts_to_user(wo, &wi);
 
-	if (!retval)
-		retval = wi.pid;
-
 	if (traced) {
 		write_lock_irq(&tasklist_lock);
 		/* We dropped tasklist, ptracer could die and untrace */
@@ -1369,16 +1367,14 @@ unlock_sig:
 	 * possibly take page faults for user memory.
 	 */
 	get_task_struct(p);
+	read_unlock(&tasklist_lock);
+
 	wi.pid = task_pid_vnr(p);
 	wi.why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
-	read_unlock(&tasklist_lock);
+	wi.stat = (wi.status << 8) | 0x7f;
 
 	retval = copy_wait_opts_to_user(wo, &wi);
 
-	if (!retval && wo->wo_stat)
-		retval = put_user((wi.status << 8) | 0x7f, wo->wo_stat);
-	if (!retval)
-		retval = wi.pid;
 	put_task_struct(p);
 
 	BUG_ON(!retval);
@@ -1395,7 +1391,8 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 {
 	int retval;
 	struct wait_info wi = { .p = p, .why = CLD_CONTINUED,
-				.status = SIGCONT, .signal = SIGCHLD };
+				.status = SIGCONT, .signal = SIGCHLD,
+				.stat = 0xffff };
 
 	if (!unlikely(wo->wo_flags & WCONTINUED))
 		return 0;
@@ -1422,11 +1419,6 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 
 	put_task_struct(p);
 
-	if (!retval && wo->wo_stat)
-		retval = put_user(0xffff, wo->wo_stat);
-	if (!retval)
-		retval = wi.pid;
-
 	BUG_ON(retval == 0);
 
 	return retval;
-- 
1.6.2.2

