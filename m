Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbXKXQ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbXKXQ7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 11:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXKXQ7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 11:59:15 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:47523 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXKXQ7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 11:59:14 -0500
Date: Sat, 24 Nov 2007 19:59:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] wait_task_continued/zombie: don't use task_pid_nr_ns() lockless
Message-ID: <20071124165934.GA8033@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Surprise, other 2 wait_task_() functions also abuse task_pid_nr_ns(). May cause
read-after-free or report nr == 0 in wait_task_continued(). wait_task_zombie()
doesn't have this problem, but still it is better to cache pid_t rather than
call task_pid_nr_ns() 3 times on the saved pid_namespace.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~PID	2007-11-24 18:17:20.000000000 +0300
+++ PT/kernel/exit.c	2007-11-24 19:28:11.000000000 +0300
@@ -1186,12 +1186,9 @@ static int wait_task_zombie(struct task_
 {
 	unsigned long state;
 	int retval, status, traced;
-	struct pid_namespace *ns;
-
-	ns = current->nsproxy->pid_ns;
+	pid_t pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 
 	if (unlikely(noreap)) {
-		pid_t pid = task_pid_nr_ns(p, ns);
 		uid_t uid = p->uid;
 		int exit_code = p->exit_code;
 		int why, status;
@@ -1310,11 +1307,11 @@ static int wait_task_zombie(struct task_
 			retval = put_user(status, &infop->si_status);
 	}
 	if (!retval && infop)
-		retval = put_user(task_pid_nr_ns(p, ns), &infop->si_pid);
+		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(p->uid, &infop->si_uid);
 	if (!retval)
-		retval = task_pid_nr_ns(p, ns);
+		retval = pid;
 
 	if (traced) {
 		write_lock_irq(&tasklist_lock);
@@ -1433,7 +1430,6 @@ static int wait_task_continued(struct ta
 	int retval;
 	pid_t pid;
 	uid_t uid;
-	struct pid_namespace *ns;
 
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
@@ -1448,8 +1444,7 @@ static int wait_task_continued(struct ta
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
 
-	ns = current->nsproxy->pid_ns;
-	pid = task_pid_nr_ns(p, ns);
+	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 	uid = p->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
@@ -1460,7 +1455,7 @@ static int wait_task_continued(struct ta
 		if (!retval && stat_addr)
 			retval = put_user(0xffff, stat_addr);
 		if (!retval)
-			retval = task_pid_nr_ns(p, ns);
+			retval = pid;
 	} else {
 		retval = wait_noreap_copyout(p, pid, uid,
 					     CLD_CONTINUED, SIGCONT,

