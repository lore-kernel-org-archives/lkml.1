Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbXDXBTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbXDXBTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXDXBTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:19:24 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:43515 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbXDXBTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:19:23 -0400
Date: Mon, 23 Apr 2007 21:19:21 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Roland McGrath <roland@redhat.com>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH try #2] Return access error not ECHILD on security_task_wait
 failure
In-Reply-To: <20070424002641.5FB061801A4@magilla.sf.frob.com>
Message-ID: <Line.LNX.4.64.0704232117310.8557@d.namei>
References: <20070424002641.5FB061801A4@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>

wait* syscalls return -ECHILD even when an individual PID of a live child
was requested explicitly, when security_task_wait denies the operation.
This means that something like a broken SELinux policy can produce an
unexpected failure that looks just like a bug with wait or ptrace or
something.

This patch makes do_wait return -EACCES (or other appropriate
error returned from security_task_wait() instead of -ECHILD if some
children were ruled out solely because security_task_wait failed.

Signed-off-by: James Morris <jmorris@namei.org>
---

Updated version, returns value from security_task_wait().


 kernel/exit.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b55ed4c..9236924 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1033,6 +1033,8 @@ asmlinkage void sys_exit_group(int error_code)
 
 static int eligible_child(pid_t pid, int options, struct task_struct *p)
 {
+	int err;
+
 	if (pid > 0) {
 		if (p->pid != pid)
 			return 0;
@@ -1066,8 +1068,9 @@ static int eligible_child(pid_t pid, int options, struct task_struct *p)
 	if (delay_group_leader(p))
 		return 2;
 
-	if (security_task_wait(p))
-		return 0;
+	err = security_task_wait(p);
+	if (err)
+		return err;
 
 	return 1;
 }
@@ -1449,6 +1452,7 @@ static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
+	int allowed, denied;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
@@ -1457,6 +1461,7 @@ repeat:
 	 * match our criteria, even if we are not able to reap it yet.
 	 */
 	flag = 0;
+	allowed = denied = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
@@ -1472,6 +1477,12 @@ repeat:
 			if (!ret)
 				continue;
 
+			if (unlikely(ret < 0)) {
+				denied = ret;
+				continue;
+			}
+			allowed = 1;
+
 			switch (p->state) {
 			case TASK_TRACED:
 				/*
@@ -1570,6 +1581,8 @@ check_continued:
 		goto repeat;
 	}
 	retval = -ECHILD;
+	if (unlikely(denied) && !allowed)
+		retval = denied;
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
-- 
1.5.0.6

