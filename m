Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYIAOOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYIAOOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYIAONx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:13:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51216 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYIAONw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:13:52 -0400
Subject: [PATCH] make setpriority POSIX compliant; introduce PRIO_THREAD
	extension
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 16:12:35 +0200
Message-Id: <1220278355.3866.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX and SUS say that setpriority(PRIO_PROCESS) should affect
all threads in the process:

SYNOPSIS
       #include <sys/resource.h>
       int getpriority(int which, id_t who);
       int setpriority(int which, id_t who, int value);
DESCRIPTION
       ...
       The  nice value set with setpriority() shall be applied to
       the process. If the process is multi-threaded, the nice value
       shall affect all system scope threads in the process.

Currently, this is not the case. While PRIO_PGRP and PRIO_USER
do set priority to the selected group of processes, PRIO_PROCESS
sets priority only for the thread with tid == who.

This mostly goes unnoticed because single-threaded processes have
tid == pid.

However, in multi-threaded processes

setpriority(PRIO_PROCESS, getpid(), value)

sets new priority only for the thread with tid == pid, leaving
all other threads unaffected. This is wrong.

Attached patch changes setpriority(PRIO_PROCESS) to set priority
for all threads with selected pid. getpriority is changed accordingly,
to return the (numerical) max of all threads' priority.

In order to allow priority of individual threads to be manipulated,
patch adds PRIO_THREAD which acts on single thread, always.

Since there may be programs which use the fact that

setpriority(PRIO_PROCESS, tid, value)

prior to this patch was setting priority for selected thread,
this behavior is retained in case when tid != pid.

IOW: with PRIO_PROCESS, if pid specifies a thread group leader,
all threads' prios are set. Otherwise, only selected thread's priority
is set. (Alternative can be to just fail with ESRCH).

getpriority() is acting similarly.

Patch is run tested. I will post test program etc as a reply.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
--
vda



diff --git a/include/linux/resource.h b/include/linux/resource.h
index aaa423a..f292690 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -51,6 +51,7 @@ struct rlimit {
 #define	PRIO_PROCESS	0
 #define	PRIO_PGRP	1
 #define	PRIO_USER	2
+#define	PRIO_THREAD	3
 
 /*
  * Limit the stack by to some sane default: root can always
diff --git a/kernel/sys.c b/kernel/sys.c
index 038a7bc..d339c1a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -142,9 +142,9 @@ asmlinkage long sys_setpriority(int which, int who,
int niceval)
 	struct task_struct *g, *p;
 	struct user_struct *user;
 	int error = -EINVAL;
-	struct pid *pgrp;
+	struct pid *pgrp, *pid;
 
-	if (which > PRIO_USER || which < PRIO_PROCESS)
+	if (which > PRIO_THREAD || which < PRIO_PROCESS)
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
@@ -156,7 +156,7 @@ asmlinkage long sys_setpriority(int which, int who,
int niceval)
 
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
+		case PRIO_THREAD:
 			if (who)
 				p = find_task_by_vpid(who);
 			else
@@ -164,6 +164,19 @@ asmlinkage long sys_setpriority(int which, int who,
int niceval)
 			if (p)
 				error = set_one_prio(p, niceval, error);
 			break;
+		case PRIO_PROCESS:
+			if (who)
+				pid = find_vpid(who);
+			else {
+				pid = task_pid(current);
+				who = current->pid;
+			}
+			do_each_pid_thread(pid, PIDTYPE_PID, p) {
+				if (who == p->pid || who == p->tgid) {
+					error = set_one_prio(p, niceval, error);
+				}
+			} while_each_pid_thread(pid, PIDTYPE_PID, p);
+			break;
 		case PRIO_PGRP:
 			if (who)
 				pgrp = find_vpid(who);
@@ -206,14 +219,14 @@ asmlinkage long sys_getpriority(int which, int
who)
 	struct task_struct *g, *p;
 	struct user_struct *user;
 	long niceval, retval = -ESRCH;
-	struct pid *pgrp;
+	struct pid *pgrp, *pid;
 
-	if (which > PRIO_USER || which < PRIO_PROCESS)
+	if (which > PRIO_THREAD || which < PRIO_PROCESS)
 		return -EINVAL;
 
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
+		case PRIO_THREAD:
 			if (who)
 				p = find_task_by_vpid(who);
 			else
@@ -224,6 +237,21 @@ asmlinkage long sys_getpriority(int which, int who)
 					retval = niceval;
 			}
 			break;
+		case PRIO_PROCESS:
+			if (who)
+				pid = find_vpid(who);
+			else {
+				pid = task_pid(current);
+				who = current->pid;
+			}
+			do_each_pid_thread(pid, PIDTYPE_PID, p) {
+				if (who == p->pid || who == p->tgid) {
+					niceval = 20 - task_nice(p);
+					if (niceval > retval)
+						retval = niceval;
+				}
+			} while_each_pid_thread(pid, PIDTYPE_PID, p);
+			break;
 		case PRIO_PGRP:
 			if (who)
 				pgrp = find_vpid(who);


