Return-Path: <linux-kernel-owner+w=401wt.eu-S1759802AbZE3S5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbZE3S5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 14:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZE3S4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 14:56:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37740 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbZE3S4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 14:56:54 -0400
Date: Sat, 30 May 2009 20:52:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: PATCH? tracehook_report_clone: fix false positives
Message-ID: <20090530185212.GA10677@redhat.com>
References: <20090528113601.GA18725@redhat.com> <20090528114100.GA18744@redhat.com> <20090528212418.2F605FC2BD@magilla.sf.frob.com> <20090529122411.GC19812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529122411.GC19812@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29, Oleg Nesterov wrote:
>
> I wonder if can kill "int trace" in do_fork/copy_process. Looks like we
> can...

Hmm. In fact, I think "int trace" is not always right.

tracehook_report_clone:

	if (unlikely(trace) || unlikely(clone_flags & CLONE_PTRACE)) {
		/*
		 * The child starts up with an immediate SIGSTOP.
		 */
		sigaddset(&child->pending.signal, SIGSTOP);
		set_tsk_thread_flag(child, TIF_SIGPENDING);
	}

Firtsly, I don't understand CLONE_PTRACE check. Suppose that untraced
task does clone(CLONE_PTRACE). In that case we create the untraced
child (this is correct) but still we send SIGSTOP.

I do not really know if this bug or not, but this doesn't look right.
At least this should be commented, imho. And, looking at 2.6.26, I think
the behaviour was different before tracehooks.

So, I assume this is bug for now.

But even the "trace != 0" check is not right, it can be false positive.
Suppose that PT_TRACE_FORK task P forks, tracehook_finish_clone() does
ptrace_link(). Then, the tracer exits and untraces both P and its new
child. In that case, I don't think it is right to send SIGSTOP.

Afaics, we can fix these problems (and kill "trace" arg):

	static inline void tracehook_report_clone(struct pt_regs *regs,
						  unsigned long clone_flags,
						  pid_t pid, struct task_struct *child)
	{
		if (unlikely(task_ptrace(child)) {
			/*
			 * The child starts up with an immediate SIGSTOP.
			 */
			sigaddset(&child->pending.signal, SIGSTOP);
			set_tsk_thread_flag(child, TIF_SIGPENDING);
		}
	}

Is task_ptrace() check racy? Yes. But a) this race is harmless and
b) the current code is equally racy.

We have multiple scenarious, but for example, suppose that untraced task
does clone(CLONE_PTRACE), do_fork() returns the new untraced child. This
child C is already visible to user-space, so it is possible that another
tracer has already attached to C, or ptrace_attach() is in progress.

However, afaics in this case we are fine. We do not care if we race with
another tracer. Because this tracer will send or has alredy sent SIGSTOP
anyway. And given that wake_up_new_task() was not called yet, we should
not worry about untrace. The child can be untraced (if tracer exits) in
parallel, but the pending SIGSTOP won't go away in any case.


So, I am going to send the patch below. But this leads to another question:
should not we move these sigaddset() + set_tsk_thread_flag() into
ptrace_init_task() ?

I don't thinks this makes sense for 2.6.30, we need another check. But
with ->ptrace_ctx patches we can do

	static inline void ptrace_init_task(struct task_struct *child)
	{
		INIT_LIST_HEAD(&child->ptraced);

		if (unlikely(child->ptrace_ctx) && ptrace_tracer(current)) {
			ptrace_link(child, task_ptrace(current),
					ptrace_tracer(current));
			sigaddset(&child->pending.signal, SIGSTOP);
			set_tsk_thread_flag(child, TIF_SIGPENDING);
		}
	}

This way we optimize the fork() path a little bit, and it becomes more
clear. Yes, utrace-ptrace will likely change this code further anyway
and move the code from _init() to _report_clone() back, but in this case
I guess the whole tracehook_finish_clone() will go away, so this change
looks right anyway to me.

Oleg.

--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -259,14 +259,12 @@ static inline void tracehook_finish_clon
 
 /**
  * tracehook_report_clone - in parent, new child is about to start running
- * @trace:		return value from tracehook_prepare_clone()
  * @regs:		parent's user register state
  * @clone_flags:	flags from parent's system call
  * @pid:		new child's PID in the parent's namespace
  * @child:		new child task
  *
- * Called after a child is set up, but before it has been started
- * running.  @trace is the value returned by tracehook_prepare_clone().
+ * Called after a child is set up, but before it has been started running.
  * This is not a good place to block, because the child has not started
  * yet.  Suspend the child here if desired, and then block in
  * tracehook_report_clone_complete().  This must prevent the child from
@@ -276,13 +274,14 @@ static inline void tracehook_finish_clon
  *
  * Called with no locks held, but the child cannot run until this returns.
  */
-static inline void tracehook_report_clone(int trace, struct pt_regs *regs,
+static inline void tracehook_report_clone(struct pt_regs *regs,
 					  unsigned long clone_flags,
 					  pid_t pid, struct task_struct *child)
 {
-	if (unlikely(trace) || unlikely(clone_flags & CLONE_PTRACE)) {
+	if (unlikely(task_ptrace(child))) {
 		/*
-		 * The child starts up with an immediate SIGSTOP.
+		 * It doesn't matter who attached/attaching to this
+		 * task, the pending SIGSTOP is right in any case.
 		 */
 		sigaddset(&child->pending.signal, SIGSTOP);
 		set_tsk_thread_flag(child, TIF_SIGPENDING);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1409,7 +1409,7 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		audit_finish_fork(p);
-		tracehook_report_clone(trace, regs, clone_flags, nr, p);
+		tracehook_report_clone(regs, clone_flags, nr, p);
 
 		/*
 		 * We set PF_STARTING at creation in case tracing wants to

