Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbZEKKNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbZEKKNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbZEKKNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50128 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217AbZEKKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z61OsozVNzQUnKcFLJBQm0NLsXauEgwwRupfR1IOAt2O50xJMNYNBUEPCKiFr3j9UT
         V2ZqoU0WlNNBDdVUCVdKTgLxiqk8Y+QgpZGdRM3oUlAkrluU6XQJW13PE/rHRYrDHt8o
         h7tvBPaKxQJIwGxztHqgMNR3KImWY8NoVo85s=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] Split wait_noreap_copyout()
Date: Mon, 11 May 2009 12:12:40 +0200
Message-Id: <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move getrusage() and put_user() code from wait_noreap_copyout()
to wait_copyout(). The same code is spreaded across all
wait_task_*() routines, it's better to reuse one copy.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 25782da..cbc5623 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1123,27 +1123,34 @@ static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 	return 1;
 }
 
-static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
-				pid_t pid, uid_t uid, int why, int status)
+static int wait_copyout(struct wait_opts *wo, struct task_struct *p,
+			pid_t pid, uid_t uid, int why, int status, int signal)
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
+	int retval = wait_copyout(wo, p, pid, uid, why, status, SIGCHLD);
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


