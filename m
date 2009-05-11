Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbZEKKN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbZEKKN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZEKKNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:54875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbZEKKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pW8AP2f3wDzOnJBH8uJxAr32+wn30Pmgulu2Bc/l73NtbvWI9iELp2SbdbLmIKGUwR
         ua8AdlHW4l0entrb2/rmPTzmHCYiJNrjEFclZUK0KwBtYioXVzOoEFCVd8ZDlelBi3oj
         XE6MtJ8fpjWDKbtgcpv8a+Kc/ny/CXZoXkNVE=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] Use wait_copyout() in wait_task_stopped()
Date: Mon, 11 May 2009 12:12:41 +0200
Message-Id: <1242036759-4025-3-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All copy-paste getrusage() and put_user() code in wait_task_* functions
is replaced by call to wait_copyout()

Also, there's no reason to have two almost similar branches of copyout
in wait_task_stopped(). The later branch also puts stat_addr to user,
but it can't affect WNOWAIT flag, and it's ok to merge both branches.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index cbc5623..3b2fdd9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1345,7 +1345,6 @@ static int *task_stopped_code(struct task_struct *p, bool ptrace)
 static int wait_task_stopped(struct wait_opts *wo,
 				int ptrace, struct task_struct *p)
 {
-	struct siginfo __user *infop;
 	int retval, exit_code, *p_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
@@ -1389,27 +1388,10 @@ unlock_sig:
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(wo->wo_flags & WNOWAIT))
-		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
+	retval = wait_copyout(wo, p, pid, uid, why, exit_code, SIGCHLD);
 
-	retval = wo->wo_rusage
-		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	if (!retval && wo->wo_stat)
 		retval = put_user((exit_code << 8) | 0x7f, wo->wo_stat);
-
-	infop = wo->wo_info;
-	if (!retval && infop)
-		retval = put_user(SIGCHLD, &infop->si_signo);
-	if (!retval && infop)
-		retval = put_user(0, &infop->si_errno);
-	if (!retval && infop)
-		retval = put_user((short)why, &infop->si_code);
-	if (!retval && infop)
-		retval = put_user(exit_code, &infop->si_status);
-	if (!retval && infop)
-		retval = put_user(pid, &infop->si_pid);
-	if (!retval && infop)
-		retval = put_user(uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 	put_task_struct(p);
-- 
1.6.2.2


