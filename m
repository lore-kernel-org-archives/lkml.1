Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbZA2Qnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbZA2Qnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZA2Qnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:43:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55021 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZA2Qni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:43:38 -0500
Date: Thu, 29 Jan 2009 17:40:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dvlasenk@redhat.com, jmarchan@redhat.com,
       roland@redhat.com
Subject: Re: + ptrace-simplify-ptrace_exit-ignoring_children-path.patch
	added to -mm tree
Message-ID: <20090129164032.GA21030@redhat.com>
References: <200901290843.n0T8hpmi002940@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901290843.n0T8hpmi002940@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Andrew Morton wrote:
>
> The patch titled
>      ptrace: simplify ptrace_exit()->ignoring_children() path
> has been added to the -mm tree.  Its filename is
>     ptrace-simplify-ptrace_exit-ignoring_children-path.patch
> ------------------------------------------------------
> Subject: ptrace: simplify ptrace_exit()->ignoring_children() path
> From: Oleg Nesterov <oleg@redhat.com>
>
> ignoring_children() takes parent->sighand->siglock and checks
> k_sigaction[SIGCHLD] atomically.  But this buys nothing, we can't get the
> "really" wrong result even if we race with sigaction(SIGCHLD).  If we read
> the "stale" sa_handler/sa_flags we can pretend it was changed right after
> the check.

I am stupid.

Somehow I didn't even try to think about false _negative_, and it is
possible without ->siglock.

If we race with sigaction() which changes ->action[SIGCHLD]

	from:	{ .sa_handler = SIG_IGN, .sa_flags = 0 }
	to:	{ .sa_handler = handler, .sa_flags = SA_NOCLDWAIT }

we can read the stores out of order, and ignoring_children() may
return the wrong "false". Nothing really bad can happen, and the
race is mostly theoretical, but still this is not right.


Andrew, please replace
	ptrace-simplify-ptrace_exit-ignoring_children-path.patch
with the new version below.

I'll also re-send the next one,
	ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
because it should be re-diffed, and because I forgot to update the comments.

Other patches I sent can be applied cleanly.

Sorry for inconvenience!

--------------------------------------------------------------------
[PATCH 2/4] ptrace: simplify ptrace_exit()->ignoring_children() path

In order to avoid the unnecessary ignoring_children() calls, ptrace_exit()
uses "int ign" to cache the returned value.

This makes sense because ptrace_exit() works with the list of tracees, but
the next patche changes this code to work with individual threads.

Remove this optimization, I don't think it is common to exit with a lot of
attached EXIT_ZOMBIE tracees. And this makes the code a bit simpler.

Also remove _irqsave/_irqrestore, this code always runs with irqs disabled.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~2_IGN_SIGCHLD	2009-01-19 10:44:33.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 16:40:38.000000000 +0100
@@ -729,19 +729,15 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * Return nonzero if @parent's children should reap themselves.
- *
- * Called with write_lock_irq(&tasklist_lock) held.
+ * Called with irqs disabled, returns true if childs should reap themselves.
  */
-static int ignoring_children(struct task_struct *parent)
+static int ignoring_children(struct sighand_struct *sigh)
 {
 	int ret;
-	struct sighand_struct *psig = parent->sighand;
-	unsigned long flags;
-	spin_lock_irqsave(&psig->siglock, flags);
-	ret = (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
-	       (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT));
-	spin_unlock_irqrestore(&psig->siglock, flags);
+	spin_lock(&sigh->siglock);
+	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
+	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
+	spin_unlock(&sigh->siglock);
 	return ret;
 }
 
@@ -754,7 +750,6 @@ static int ignoring_children(struct task
 static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
 	struct task_struct *p, *n;
-	int ign = -1;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
 		__ptrace_unlink(p);
@@ -776,12 +771,8 @@ static void ptrace_exit(struct task_stru
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, parent))
 				do_notify_parent(p, p->exit_signal);
-			else {
-				if (ign < 0)
-					ign = ignoring_children(parent);
-				if (ign)
-					p->exit_signal = -1;
-			}
+			else if (ignoring_children(parent->sighand))
+				p->exit_signal = -1;
 		}
 
 		if (task_detached(p)) {

