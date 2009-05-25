Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbZEYWoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbZEYWoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZEYWnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:43:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZEYWny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:43:54 -0400
Date: Tue, 26 May 2009 00:39:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 8/X] ptrace: introduce ptrace_tracer() helper
Message-ID: <20090525223932.GA11508@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525215903.GA9113@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Oleg Nesterov wrote:
>
> On 05/25, Oleg Nesterov wrote:
> >
> > Move task_struct->parent into ptrace_task->pt_tracer and change the users
> > accordingly.
> >
> > ...
> >
> > @@ -1773,8 +1779,8 @@ static int ptrace_signal(int signr, sigi
> >  		info->si_signo = signr;
> >  		info->si_errno = 0;
> >  		info->si_code = SI_USER;
> > -		info->si_pid = task_pid_vnr(current->parent);
> > -		info->si_uid = task_uid(current->parent);
> > +		info->si_pid = task_pid_vnr(current->ptrace_task->pt_tracer);
> > +		info->si_uid = task_uid(current->ptrace_task->pt_tracer);
>
> This change is wrong, will re-do. The task can be already untraced
> after ptrace_stop().
>
> But is the current code correct? If we are not traced any longer
> si_pid/si_uid are not necessary right either, we should calculate them
> before ptrace_stop(), no?

... and in theory we need rcu_read_lock() here.

I'd like to send the next patch for review, because I have questions.
It fixes the bug above, but of course the previous patch should be
fixed instead. I'll re-send the whole series (with renames), but first
I'd like to know what Roland thinks.

---------------------------------------------------------------------
[RFC PATCH 8/X] ptrace: introduce ptrace_tracer() helper

Introduce ptrace_tracer() (or suggest a better name) to simplify/cleanup
the code which needs the tracer and checks task_ptrace(). From now nobody
else uses ->pt_tracer except ptrace_link/ptrace_unlink.

Question. Note that ptrace_tracer() is equal to tracehook_tracer_task().
But I do not understand the future plans for tracehook_tracer_task().
Should we just use tracehook_tracer_task() ? If yes, how
ptrace_reparented() can use this helper?


 include/linux/ptrace.h |   17 ++++++++++++-----
 kernel/ptrace.c        |    2 +-
 kernel/signal.c        |   28 +++++++++++++++++-----------
 3 files changed, 30 insertions(+), 17 deletions(-)

--- PTRACE/include/linux/ptrace.h~8_PT_TRACER	2009-05-25 22:52:51.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-25 23:21:17.000000000 +0200
@@ -116,10 +116,17 @@ static inline int task_ptrace(struct tas
 		task->ptrace_task->pt_flags : 0;
 }
 
-static inline int ptrace_reparented(struct task_struct *child)
+static inline struct task_struct *ptrace_tracer(struct task_struct *task)
 {
-	return unlikely(task_ptrace(child)) &&
-		child->ptrace_task->pt_tracer != child->real_parent;
+	if (task->ptrace_task)
+		return task->ptrace_task->pt_tracer;
+	return NULL;
+}
+
+static inline bool ptrace_reparented(struct task_struct *child)
+{
+	struct task_struct *tracer = ptrace_tracer(child);
+	return unlikely(tracer) && tracer != child->real_parent;
 }
 
 static inline void ptrace_unlink(struct task_struct *child)
@@ -167,9 +174,9 @@ static inline void ptrace_init_task(stru
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
 
-	if (unlikely(child->ptrace_task) && task_ptrace(current))
+	if (unlikely(child->ptrace_task) && ptrace_tracer(current))
 		ptrace_link(child, task_ptrace(current),
-				current->ptrace_task->pt_tracer);
+				ptrace_tracer(current));
 }
 
 /**
--- PTRACE/kernel/ptrace.c~8_PT_TRACER	2009-05-25 22:52:51.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-25 23:24:57.000000000 +0200
@@ -108,7 +108,7 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if (task_ptrace(child) && child->ptrace_task->pt_tracer == current) {
+	if (ptrace_tracer(child) == current) {
 		ret = 0;
 		/*
 		 * child->sighand can't be NULL, release_task()
--- PTRACE/kernel/signal.c~8_PT_TRACER	2009-05-25 22:52:51.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-26 00:14:00.000000000 +0200
@@ -1411,9 +1411,8 @@ int do_notify_parent(struct task_struct 
 	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
-	if (task_ptrace(tsk))
-		parent = tsk->ptrace_task->pt_tracer;
-	else
+	parent = ptrace_tracer(tsk);
+	if (likely(!parent))
 		parent = tsk->real_parent;
 
 	info.si_signo = sig;
@@ -1489,9 +1488,8 @@ static void do_notify_parent_cldstop(str
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
 
-	if (task_ptrace(tsk))
-		parent = tsk->ptrace_task->pt_tracer;
-	else {
+	parent = ptrace_tracer(tsk);
+	if (likely(!parent)) {
 		tsk = tsk->group_leader;
 		parent = tsk->real_parent;
 	}
@@ -1538,7 +1536,9 @@ static void do_notify_parent_cldstop(str
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(task_ptrace(current)))
+	struct task_struct *tracer = ptrace_tracer(current);
+
+	if (!likely(tracer))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1550,7 +1550,7 @@ static inline int may_ptrace_stop(void)
 	 * is safe to enter schedule().
 	 */
 	if (unlikely(current->mm->core_state) &&
-	    unlikely(current->mm == current->ptrace_task->pt_tracer->mm))
+	    unlikely(current->mm == tracer->mm))
 		return 0;
 
 	return 1;
@@ -1756,8 +1756,14 @@ static int do_signal_stop(int signr)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!task_ptrace(current))
+	struct task_struct *tracer = ptrace_tracer(current);
+	pid_t pid;
+	uid_t uid;
+
+	if (!tracer)
 		return signr;
+	pid = task_pid_vnr(tracer);
+	uid = task_uid(tracer);
 
 	ptrace_signal_deliver(regs, cookie);
 
@@ -1779,8 +1785,8 @@ static int ptrace_signal(int signr, sigi
 		info->si_signo = signr;
 		info->si_errno = 0;
 		info->si_code = SI_USER;
-		info->si_pid = task_pid_vnr(current->ptrace_task->pt_tracer);
-		info->si_uid = task_uid(current->ptrace_task->pt_tracer);
+		info->si_pid = pid;
+		info->si_uid = uid;
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */

