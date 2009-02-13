Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZBMJrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZBMJrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZBMJrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:47:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37736 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZBMJrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:47:33 -0500
Date: Fri, 13 Feb 2009 10:44:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jan Kratochvil <jan.kratochvil@redhat.com>,
       Kaz Kylheku <kkylheku@gmail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] do_wait: fix waiting for the group stop with the dead
	leader
Message-ID: <20090213094449.GA20257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_wait(WSTOPPED) assumes that p->state must be == TASK_STOPPED, this is not
true if the leader is already dead. Check SIGNAL_STOP_STOPPED instead and use
signal->group_exit_code.

Trivial test-case:

	void *tfunc(void *arg)
	{
		pause();
		return NULL;
	}

	int main(void)
	{
		pthread_t thr;
		pthread_create(&thr, NULL, tfunc, NULL);
		pthread_exit(NULL);
		return 0;
	}
					
It doesn't react to ^Z (and then to ^C or ^\). The task is stopped, but
bash can't see this.

The bug is very old, and it was reported multiple times. This patch was sent
more than a year ago (http://marc.info/?t=119713920000003) but it was ignored.

>From my pov this change also fixes other oddities (but not all) in this area.
For example, before this patch:

	$ sleep 100
	^Z
	[1]+  Stopped                 sleep 100
	$ strace -p `pidof sleep`
	Process 11442 attached - interrupt to quit

strace hangs in do_wait(), because ->exit_code was already consumed by bash.
After this patch, strace happily proceeds:

	--- SIGTSTP (Stopped) @ 0 (0) ---
	restart_syscall(<... resuming interrupted call ...>

To me, this looks much more "natural" and correct.

Another example. Let's suppose we have the main thread M and sub-thread T,
the process is stopped, and its parent did wait(WSTOPPED). Now we can ptrace
T but not M. This looks at least strange to me.

Imho, do_wait() should not confuse the per-thread ptrace stops with the
per-process job control stops.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~WSTOPPED	2009-02-11 21:25:35.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-02-13 07:04:12.000000000 +0100
@@ -1345,6 +1345,18 @@ static int wait_task_zombie(struct task_
 	return retval;
 }
 
+static int *task_stopped_code(struct task_struct *p, bool ptrace)
+{
+	if (ptrace) {
+		if (task_is_stopped_or_traced(p))
+			return &p->exit_code;
+	} else {
+		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+			return &p->signal->group_exit_code;
+	}
+	return NULL;
+}
+
 /*
  * Handle sys_wait4 work for one task in state TASK_STOPPED.  We hold
  * read_lock(&tasklist_lock) on entry.  If we return zero, we still hold
@@ -1355,7 +1367,7 @@ static int wait_task_stopped(int ptrace,
 			     int options, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
-	int retval, exit_code, why;
+	int retval, exit_code, *p_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
@@ -1365,22 +1377,16 @@ static int wait_task_stopped(int ptrace,
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
-	if (unlikely(!task_is_stopped_or_traced(p)))
-		goto unlock_sig;
-
-	if (!ptrace && p->signal->group_stop_count > 0)
-		/*
-		 * A group stop is in progress and this is the group leader.
-		 * We won't report until all threads have stopped.
-		 */
+	p_code = task_stopped_code(p, ptrace);
+	if (unlikely(!p_code))
 		goto unlock_sig;
 
-	exit_code = p->exit_code;
+	exit_code = *p_code;
 	if (!exit_code)
 		goto unlock_sig;
 
 	if (!unlikely(options & WNOWAIT))
-		p->exit_code = 0;
+		*p_code = 0;
 
 	/* don't need the RCU readlock here as we're holding a spinlock */
 	uid = __task_cred(p)->uid;
@@ -1536,7 +1542,7 @@ static int wait_consider_task(struct tas
 	 */
 	*notask_error = 0;
 
-	if (task_is_stopped_or_traced(p))
+	if (task_stopped_code(p, ptrace))
 		return wait_task_stopped(ptrace, p, options,
 					 infop, stat_addr, ru);
 

