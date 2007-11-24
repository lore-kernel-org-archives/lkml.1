Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXKXPdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXKXPdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 10:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXKXPdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 10:33:47 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:47859 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXKXPdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 10:33:46 -0500
Date: Sat, 24 Nov 2007 18:33:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC, PATCH -mm] do_wait: fix security checks
Message-ID: <20071124153323.GA6696@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Imho, the current usage of security_task_wait() is not logical.

Suppose we have the single child p, and security_task_wait(p) return -EANY.
In that case waitpid(-1) returns this error. Why? Isn't it better to return
ECHLD? We don't really have the reapable childs.

Now suppose that child was stealed by gdb. In that case we find this child
on ->ptrace_children and set flag = 1, but we don't check that the child was
denied. So, do_wait(..., WNOHANG) returns 0, this doesn't match the behaviour
above. Without WNOHANG do_wait() blocks only to return the error later, when
the child will be untraced. Inho, really strange.

I think eligible_child() should return the error only if the child's pid was
requested explicitly, otherwise we should silently ignore the tasks which were
nacked by security_task_wait().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~7_security_task_wait	2007-11-23 21:29:44.000000000 +0300
+++ PT/kernel/exit.c	2007-11-24 18:17:20.000000000 +0300
@@ -1139,10 +1139,14 @@ static int eligible_child(pid_t pid, int
 		return 0;
 
 	err = security_task_wait(p);
-	if (err)
-		return err;
+	if (likely(!err))
+		return 1;
 
-	return 1;
+	if (pid <= 0)
+		return 0;
+	/* This child was explicitly requested, abort */
+	read_unlock(&tasklist_lock);
+	return err;
 }
 
 static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
@@ -1473,7 +1477,6 @@ static long do_wait(pid_t pid, int optio
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
-	int allowed, denied;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
@@ -1481,8 +1484,7 @@ repeat:
 	 * We will set this flag if we see any child that might later
 	 * match our criteria, even if we are not able to reap it yet.
 	 */
-	flag = 0;
-	allowed = denied = 0;
+	flag = retval = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
@@ -1495,13 +1497,8 @@ repeat:
 				continue;
 
 			if (unlikely(ret < 0)) {
-				denied = ret;
-				continue;
-			}
-			allowed = 1;
-
-			retval = 0;
-			if (is_task_stopped_or_traced(p)) {
+				retval = ret;
+			} else if (is_task_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.
@@ -1539,24 +1536,25 @@ repeat:
 			if (retval != 0) /* tasklist_lock released */
 				goto end;
 		}
-		if (!flag) {
-			list_for_each_entry(p, &tsk->ptrace_children,
-					    ptrace_list) {
-				if (!eligible_child(pid, options, p))
-					continue;
-				flag = 1;
+		if (flag)
+			continue;
+		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
+			flag = eligible_child(pid, options, p);
+			if (!flag)
+				continue;
+			if (likely(flag > 0))
 				break;
-			}
+			retval = flag;
+			goto end;
 		}
 		if (options & __WNOTHREAD)
 			break;
 		tsk = next_thread(tsk);
 		BUG_ON(tsk->signal != current->signal);
 	} while (tsk != current);
-
 	read_unlock(&tasklist_lock);
+
 	if (flag) {
-		retval = 0;
 		if (options & WNOHANG)
 			goto end;
 		retval = -ERESTARTSYS;
@@ -1566,8 +1564,6 @@ repeat:
 		goto repeat;
 	}
 	retval = -ECHILD;
-	if (unlikely(denied) && !allowed)
-		retval = denied;
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);

