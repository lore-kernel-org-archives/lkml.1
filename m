Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZECT6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZECT6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZECT6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:58:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbZECT6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:58:30 -0400
Date: Sun, 3 May 2009 21:54:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: do not use task->ptrace directly in core kernel
Message-ID: <20090503195404.GA18889@redhat.com>
References: <20090429122827.GA27838@redhat.com> <20090430202828.8A763FC3BF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430202828.8A763FC3BF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Roland McGrath wrote:
>
> That is fine, but doesn't buy much.

Yes this patch is only cosmetic. But it allows us to change the internals
in ptrace.c without thinking about other kernel/*.c. The only goal is to
make the further changes smaller and more reviewable.

Honestly, I'd also like to temporary change ptrace.c too, see the patch
below. But this is minor.

> i.e., we will be changing these again
> before too long anyway I imagine.

Yes, agreed.

> The BUG_ON cases might as well just go away, probably.

Agreed.

> ptrace_fork() is a wrapper that just calls arch_ptrace_fork(), which itself
> is an empty macro on most configurations.  I think we might as well just
> make ptrace_fork() an inline in linux/ptrace.h and put the test inside it.
> (Thus any future changes touch ptrace.h and not fork.c.)

ptrace_fork() will die soon, so the change if fork.c will go away. Markus
already has patches, hopefully they will be merged soon.

Oleg.

--- a/kernel/ptrace.c	2009-05-03 19:57:11.000000000 +0200
+++ b/kernel/ptrace.c	2009-05-03 21:24:36.000000000 +0200
@@ -79,8 +79,6 @@ static void ptrace_untrace(struct task_s
  */
 void __ptrace_unlink(struct task_struct *child)
 {
-	BUG_ON(!child->ptrace);
-
 	child->ptrace = 0;
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
@@ -105,7 +103,7 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
+	if (task_ptrace(child) && child->parent == current) {
 		ret = 0;
 		/*
 		 * child->sighand can't be NULL, release_task()
@@ -203,7 +201,7 @@ int ptrace_attach(struct task_struct *ta
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
 		goto unlock_tasklist;
-	if (task->ptrace)
+	if (task_ptrace(task))
 		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
@@ -233,7 +231,7 @@ int ptrace_traceme(void)
 
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
-	if (!current->ptrace) {
+	if (!task_ptrace(current)) {
 		ret = security_ptrace_traceme(current->parent);
 		/*
 		 * Check PF_EXITING to ensure ->real_parent has not passed
@@ -314,7 +312,7 @@ int ptrace_detach(struct task_struct *ch
 	 * This child can be already killed. Make sure de_thread() or
 	 * our sub-thread doing do_wait() didn't do release_task() yet.
 	 */
-	if (child->ptrace) {
+	if (task_ptrace(child)) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 	}
@@ -401,30 +399,35 @@ int ptrace_writedata(struct task_struct 
 
 static int ptrace_setoptions(struct task_struct *child, long data)
 {
-	child->ptrace &= ~PT_TRACE_MASK;
+	unsigned int new_flags = 0;
+
+	if (data & ~PTRACE_O_MASK)
+		return -EINVAL;
 
 	if (data & PTRACE_O_TRACESYSGOOD)
-		child->ptrace |= PT_TRACESYSGOOD;
+		new_flags |= PT_TRACESYSGOOD;
 
 	if (data & PTRACE_O_TRACEFORK)
-		child->ptrace |= PT_TRACE_FORK;
+		new_flags |= PT_TRACE_FORK;
 
 	if (data & PTRACE_O_TRACEVFORK)
-		child->ptrace |= PT_TRACE_VFORK;
+		new_flags |= PT_TRACE_VFORK;
 
 	if (data & PTRACE_O_TRACECLONE)
-		child->ptrace |= PT_TRACE_CLONE;
+		new_flags |= PT_TRACE_CLONE;
 
 	if (data & PTRACE_O_TRACEEXEC)
-		child->ptrace |= PT_TRACE_EXEC;
+		new_flags |= PT_TRACE_EXEC;
 
 	if (data & PTRACE_O_TRACEVFORKDONE)
-		child->ptrace |= PT_TRACE_VFORK_DONE;
+		new_flags |= PT_TRACE_VFORK_DONE;
 
 	if (data & PTRACE_O_TRACEEXIT)
-		child->ptrace |= PT_TRACE_EXIT;
+		new_flags |= PT_TRACE_EXIT;
 
-	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
+	child->ptrace &= ~PT_TRACE_MASK;
+	child->ptrace |= new_flags;
+	return 0;
 }
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)

